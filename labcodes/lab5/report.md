练习0
===
　　已完成合并，并在合并时根据实际情况对之前代码做出少量修改。
练习1
===  
1 实现
---  
　　在`load_icode`函数中对trapframe的设置部分如下：
```
tf->tf_cs = USER_CS;                          //CS代码段寄存器为user态的CS
tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;  //其他数据段寄存器为user态的DS
tf->tf_esp = USTACKTOP;                       //esp为用户堆栈的栈顶指针
tf->tf_eip = elf->e_entry;                    //eip为开始执行时的第一条指令地址，对应elf中的entry
tf->tf_eflags |= FL_IF;                       //为trapframe设置elfags，使得程序允许外部中断的产生
```
2 进程的执行过程
---
　　首先，ucore在内核态中创建了一个新的内核线程user_main，当该线程被schedule调度函数选中并开始占用CPU执行时，便开始了用户进程的创建过程。  
　　执行user_main时，将其中的KERNEL_EXECVE等宏的展开，可以看到实际是执行int系统调用中断，系统调用编号设置为SYS_exec,设置的参数为待执行的用户态进程信息。这是中断系统起作用，硬件通过查找idt表和系统调用表，执行syscall.c中的sys_exec函数，在这个函数中最终执行do_execve函数。  
　　在do_execve函数中，首先清空原内核线程的内存，然后执行load_icode。  
　　在load_icode中先后经历了分配内存、建立页表、复制数据、代码，建立用户堆栈等等后，设置了trapframe，这里把cs，ds，es，ss，sp，eip等进行赋值。  
　　load_icode返回后，do_execve设置名字后也返回。  
　　do_execve函数返回后，就到了系统调用的返回阶段，ucore会弹出寄存器的值执行iret，这时根据load_icode中设置的trapframe的内容，完成了cs ds等段寄存器以及sp栈指针到用户态的转变，并且由于eip保存的是用户进程代码中的entry程序入口的地址，那么在iret后执行的就应该是eip指向的代码，即执行进程的第一条指令。  
　　总体流程可表示如下：
```
user_main
|
int sys_exec --> sys_exec --> do_execve --> load_icode 
                    |            |            | load_icode 返回(设置trapframe)
                    |            |         <---
                    |            |do_execve 返回
                    |         <---
                    |sys_exec返回
                 <---
iret 系统调用结束 

```
练习二
===
1 实现
---
```
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));
    // 一页一页地复制
    do {
        //获取进程A的页表指针
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL) {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue ;
        }
        //获取或分配一个B进程的页表指针
        if (*ptep & PTE_P) {
            if ((nptep = get_pte(to, start, 1)) == NULL) {
                return -E_NO_MEM;
            }
        uint32_t perm = (*ptep & PTE_USER);
        //根据页表得到物理页
        struct Page *page = pte2page(*ptep);
        // 为进程B分配一页的空间
        struct Page *npage=alloc_page();
        assert(page!=NULL);
        assert(npage!=NULL);
        int ret=0;
        //我的代码：将page复制到npage
        memcpy(page2kva(npage), page2kva(page), PGSIZE);
        //我的代码：并将npage建立到start的映射关系
        ret = page_insert(to, npage, start, perm);
        assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    return 0;
}  
```
2 COW机制的实现
---
　　实现COW机制，需要在fork进程的时候将父进程的页表设置为只读模式，而不需要在fork的时候将其内存中的内容重新复制一遍。这样当两个进程读取信息时不会有任何问题。当某个进程需要对页面进行写操作时，由于权限的问题，会触发page fault，然后在do_pgfault函数中可以根据页面的存在情况判断出但前操作是对一个只读页进行写操作，这是就可以根据当前页面的引用情况，取消这个只读的共享设置，并复制一份该页给两个进程分别使用，设置好映射关系这样就可以实现Coyp on Write机制。
练习三
===  
1 函数分析
---  
+ do_fork:do_fork函数是根据给定的flag对进程进行复制操作,包括复制内存、堆栈、寄存器值等，新得到的子进程和父进程不同之处在于，子进程分配了一个新的pid，且父进程的返回值是子进程的pid，子进程的返回值为0.
+ do_execve: 这个函数是将用户进程的内容装入到创建的进程的“壳”里，它通过load_icode函数将elf格式的文件代码、数据等复制到内存中，并通过设置trapframe来从内核态切换到用户态，以及设置进程的起始执行代码。
+ do_wait:这个函数一般是父进程发出的等待子进程的指令。如果子进程已经执行完毕，那么它的状态为PROC_ZOMBIE，这时父进程可以直接得到返回值；如果子进程尚在执行，那么父进程会进入PROC_SLEEPING状态，且wait_state为WT_CHILD，子进程在执行完毕后会执行wakeup_proc来唤醒父进程，使得父进程可以继续执行。
+ do_exit:这是进程退出的系统调用的实现。当一个进程退出时，它的状态会变成PROC_ZOMBIE，这时如果它是一个子进程，且它的父进程正处在等待子进程退出状态的话，那么该进程就会调用wakeup_proc唤醒父进程；如果该进程退出时它的子进程仍在运行，那么ucore会将它的子进程依次取出，并连接到initproc的子进程列表中，即相当于它们变成了独立的处于根进程下的一个个子进程。

2 进程执行状态的改变
---
+ do_fork首先调用alloc_proc创建一个未被初始化的进程，其状态为PROC_UNINIT，在复制完进程，分配pid后调用wakeup_proc将进程状态置为PROC_RUNNABLE
+ do_execve 函数只是将进程的内容装入，并没有对进程的状态进行改变
+ do_wait 如果正常执行为当前进程等待其子进程执行完毕，如果子进程已经结束（即状态为PROC_ZOMBIE）,那么直接返回值，如果子进程未结束，那么当前父进程的状态变为PROC_SLEEPING，等待子进程结束
+ do_exit 将当前进程状态置为PROC_ZOMBIE,如果它有正在等待子进程返回的父进程，那么调用wakeup_proc唤醒父进程。  

3 程序生命周期图
---
```
alloc_proc
   |
   |
   V
 ____________               ______________   wait，sleep   ________________
|           |  wakeup_proc |             | -------------->|               |
|PROC_UNINIT| -----------> |PROC_RUNNABLE|   子进程wakeup  | PROC_SLEEPING |
|___________|              |_____________| <------------- |_______________|
                                |
                                | exit        ______________       
                                |            |              |
                                |----------->| PROC_ZOMBIE  |
                                             |______________| 
                    


```

其他
===
1 我的代码vs参考代码
---
　　由于这次的代码逻辑非常简单，参考注释中的做法，本次的代码和参考代码基本相同。

2 知识点
---
+ 用户进程的创建
+ 用户态内核态的切换过程
+ 系统调用的实现
+ 进程状态的变化
+ elf格式文件的操作
