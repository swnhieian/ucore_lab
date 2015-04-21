练习0
===
　　已完成合并。
练习1
===
1 实现过程
---
　　实现方法为按注释将需要初始化的变量分别初始化即可,但需要注意此时只是初始化TCB空间，而没有实际线程与其对应，大部分变量的值实际上是在真正调用do_fork创建新线程的时候赋值，所以此处变量值基本都赋成空或0。
实现代码如下：
```
proc->state = PROC_UNINIT;                          //设置状态为未初始化
proc->pid = -1;                                     //根据proc_init函数中的判断，pid为负值表示进程不合法，后续会在do_fork中为其分配合法的pid
proc->runs = 0;                                     //线程运行次数为0
proc->kstack = 0;                                   //这里无需赋有意义值，在do_fork调用的setup_kstack函数时会将其赋值
proc->need_resched = 1;                             //线程需要被调试
proc->parent = NULL;                                //其父进程仍在do_fork中赋值
proc->mm = NULL;                                    //本实验中无需对mm操作，但在copy_mm中assert其值为NULL，在些将其初值赋为空
memset(&(proc->context), 0, sizeof(proc->context)); //context不是指针，将其内容赋空
proc->tf = NULL;                                    //trapframe的内容会在do_fork中进行填充，此处赋空即可
proc->cr3 = boot_cr3;                               //当前创建内核线程，使用内核的PDT地址（CR3寄存器值）
proc->flags = 0;                                    //标志位清空
memset(proc->name, 0, sizeof(proc->name));          //名字清空
```
2 变量作用
---
+ context  
	context变量保存的是当前进程的上下文，其中包括eip，esp，ebx，ecx，edx，esi，edi，ebp寄存器的值，用于保存当前进程的运行状态。该变量主要用于切换进程，在进程调度切换进程时需要根据context中保存的值来切换至新的进程。
+ trapframe  
	trapframe变量保存了中断发生时的进程的相关寄存器的信息，其中既有硬件保存的信息，也有软件需要保存的信息。trapframe用于处理中断的时候，在本实验中主要在do_fork时设置好对应的函数、参数、返回值等信息，通过forkrets完成fork操作，并将运行环境切换到trapframe中设置好信息，随之切换到kernel_thread_entry开始运行地线程。

练习2
===
1 实现过程
---
```
if ((proc = alloc_proc())== NULL) {                //为线程分配空间
    cprintf("do_fork-->alloc_proc failed!\n");
    goto fork_out;
}
proc->parent = current;                            //设置新进程的父进程为当前进程
if (setup_kstack(proc)) {                          //为子线程分配内核堆栈
    cprintf("do_fork-->setup_kstack failed!\n");
    goto bad_fork_cleanup_proc;                    //失败时只需要释放proc的空间即可
}
if (copy_mm(clone_flags, proc)) {                  //根据clone_flags复制或共享内存信息（本实验中无任何作用）   
    cprintf("do_fork-->copy_mm failed!\n");
    goto bad_fork_cleanup_kstack;                  //失败时除了释放proc空间还要释放分配的堆栈空间
}
copy_thread(proc, stack, tf);                      //开始复制线程，包括设置上下文context,trapframe等以保证线程可以正常运行
bool flag;
local_intr_save(flag);                             //关中断，保证如下原子操作不被中断打断而导致线程在分配了pid后却未被及时加入到线程列表中
proc->pid = get_pid();                             //为子线程分配一个pid，注意这一句需要在hash_proc之前，因为hash需要用到pid的值
hash_proc(proc);                                   //将子线程加到hash链表里
list_add(&proc_list, &(proc->list_link));          //将子线程加到所有线程的列表中
nr_process ++;                                     //线程数加1    
local_intr_restore(flag);                          //开中断
wakeup_proc(proc);                                 //唤醒线程，即将其状态置为runnable就绪状态，确保之后被调度时可以运行
ret = proc->pid;                                   //这里是父线程，需要返回子线程的pid值
```
2 赋id过程
---
　　实验中通过get_pid()函数为每个进程分配一个唯一的pid，该函数运行流程如下：  
　　变量说明：last_pid是上一个分配出去的pid，next_safe是线程列表中下一个比last_pid大的pid，这样如果分配在next_safe之前的pid则可以直接分配  
　　因为该函数在next_safe不满足分配需求的时候就会遍历整个线程链表来完成对last_pid和next_safe的重新赋值，因此可以保证为每一个进程分配一个唯一的pid。
```
static_assert(MAX_PID > MAX_PROCESS);
struct proc_struct *proc;
list_entry_t *list = &proc_list, *le;
static int next_safe = MAX_PID, last_pid = MAX_PID;
if (++ last_pid >= MAX_PID) {                                        //将last_pid先加1，作为备选的下一个分配，如果分配到头则需要从头重新开始分配
    last_pid = 1;
    goto inside;                                                     //则直接开始分配
}
if (last_pid >= next_safe) {                                         //只有在last_pid达到了next_safe才需要重新寻找，否则直接返回last_pid即可成功分配
inside:
    next_safe = MAX_PID;                                             //next_safe暂定为最大进程数，根据之后的结果逐渐缩小
repeat:
    le = list;
    while ((le = list_next(le)) != list) {                           //遍历整个链表
        proc = le2proc(le, list_link);
        if (proc->pid == last_pid) {                                 //如果当前被先的last_pid已经被使用过
            if (++ last_pid >= next_safe) {                          //将last_pid再次加1，并和next_safe比较，如果没有达到则是安全的
                                                                     //可以继续遍历，否则需要将next_safe置为最大，再次遍历整个链表
                if (last_pid >= MAX_PID) {
                    last_pid = 1;
                }
                next_safe = MAX_PID;
                goto repeat;
            }
        }    
        else if (proc->pid > last_pid && next_safe > proc->pid) {    //如果last_pid还没被使用过根据结果缩小next_safe
            next_safe = proc->pid;
        }
    }
}
return last_pid;                                                     //这样在遍历过整个链表后last_pid的值就是当前可以被分配的pid进程号，
                                                                     //而从last_pid到next_safe之间的pid都没有被分配过
                                                                     //可以根据static变量的特性被下一个调用些函数的进程直接使用，减少了函数运行时间。
```

练习3
===
1 分析
---
proc_run函数是激活proc线程的过程，也就是将线程从当前运行的current切换到proc。
```
if (proc != current) {
    bool intr_flag;
    struct proc_struct *prev = current, *next = proc;
    local_intr_save(intr_flag);                        //关中断
    {
        current = proc;                                //设置proc为当前线程
        load_esp0(next->kstack + KSTACKSIZE);          //切换堆栈
        lcr3(next->cr3);                               //切换页表
        switch_to(&(prev->context), &(next->context)); //切换上下文
    }
    local_intr_restore(intr_flag);                     //开中断
}
```
　　这个函数中的切换堆栈和页表都是通过汇编语句改变esp和cr3寄存器的值即可以实现，而稍复杂的核心则是switch_to函数，该函数是由汇编实现的，分析如下：
```
switch_to:                      # switch_to的两个参数分别是from进程的context和to进程的context,分别保存在%esp+4、%esp+8的位置

    movl 4(%esp), %eax          # eax指向from进程的context
    popl 0(%eax)                # 把esp也就是当前switch_to的返回值弹出栈存入form的context的eip中，便于下次切换回去
                                # 而此时%esp指向的内容为from的context，%esp+4变成了to的context
    movl %esp, 4(%eax)          # 依次把其他寄存器存入from的context中
    movl %ebx, 8(%eax)
    movl %ecx, 12(%eax)
    movl %edx, 16(%eax)
    movl %esi, 20(%eax)
    movl %edi, 24(%eax)
    movl %ebp, 28(%eax)

    movl 4(%esp), %eax          # 把eax赋成to的context
    movl 28(%eax), %ebp         # 依次把to的context中保存的内容存入对应寄存器中
    movl 24(%eax), %edi
    movl 20(%eax), %esi
    movl 16(%eax), %edx
    movl 12(%eax), %ecx
    movl 8(%eax), %ebx
    movl 4(%eax), %esp

    pushl 0(%eax)               # 把to的eip值压栈，这样在返回的时候就会跳到这里继续执行，于是通过eip的不同完成了切换过程

    ret
```
2 创建进程数
---
　　本实验中创建并运行了2个内核线程。  
　　在proc_init函数中，首先创建了idle_proc0号线程，又通过kernel_thread创建了一个init_main线程。  
　　在kern_init函数中，完成所有相应的初始化后，调用了cpu_idle运行idle线程，在cpu_idle中调用了schedule调度函数，可以调度切换使得init_main线程执行。

3 语句作用
---
　　这里local_intr_save是关中断,local_intr_restore是开中断的意思。  
　　在关中断过程中的语句可以起到保护作用，保证操作系统指令执行的原子性，即确保保护中的语句不被打断。  
　　在本函数中，可以确保切换线程的过程不被打断，防止切换了当前进程的变量（current)却没有切换页表、上下文等信息使得被中断打断后无法执行正确的指令。或者出现切换完了页表、堆栈等却没有切换上下文就被中断打断，这样执行接下来的指令时可能会取得错误的数据或指令。

其他
===
1 我的代码  vs 参考答案
---
　　练习一中的代码没有什么大问题，只要按照注释的提示将所有的变量赋一个初值即可，而且其中一部分变量还会在之后进一步初始化的时候赋一个有意义的值。  
　　练习二中我的代码虽然可以正确执行，但是比较了参考答案之中发现我的代码是存在一定的问题的，其中最重要的便是没有对部分语句没有进行关中断的保护操作。后来经分析发现没有保护在实际系统中可能会出现问题，即在获取完进程的pid时如果没有将其加入链表，此时被打断如果其他进程再次获取pid可能会出问题。现在已经加以改正。
2 知识点
---
- 创建进程的过程  
- fork执行的过程
- fork需要复制哪些内容（哪些内容完整地描述了一个进程）
- 进程切换需要保存的内容
- 进程之间如何进行切换
- 进程的状态与调度
- 进程如何开始执行
