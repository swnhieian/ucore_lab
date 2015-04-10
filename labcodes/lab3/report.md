练习0
===
　　已完成合并。

练习1
===
 1 实现过程
---  
　　do_pgfault()函数完成了对缺页中断的处理。增添的主要代码如下：  
```
//获取pte的指针，在get_pte函数中，如果pte对应的页表不存在，会分配一页
ptep = get_pte(mm->pgdir, addr, 1)
if (!ptep) {
    cprintf("do_pgfault --> get_pte failed\n");
    goto failed;
}
//如果*pte中保存的是pte的实地址的值
if (*ptep == 0) {         //如果pte的地址不存在
    //通过pgdir_alloc_page函数分配一页空间并把地址映射到新创建的pte中
    if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
        cprintf("do_pgfault -->pgdir_alloc_page failed\n");
        goto failed;
    }
} else {    //否则认为该pte对应一个交换出去的页
    if (swap_init_ok) { //如果交换初始化成功
        struct Paage *page = NULL;
        //把该页从硬盘交换进来
        ret = swap_in(mm, addr, &page); 
        if (ret != 0) {
            cprintf("do_pgfault --> swap_in failed\n");
            goto failed;
        }
        //并把该页插入到PDT表中，建立地址映射
        ret = page_insert(mm->pgdir, page, addr, perm);
        if (ret != 0) {
            cprintf("do_pgfault --> page_insert failed\n");
            goto failed;
        }
        //设置该页为可以交换
        ret = swap_map_swappable(mm, addr, page, 1);
        if (ret != 0) {
            cprintf("do_pgfault --> swap_map_swappable failed\n");
            goto failed;
        }
    } else {
        //交换初始化失败，输出信息
        cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
        goto failed;
    }
}  
```

2 PDE PTE表项的利用
---  
　　PDE和PTE表项的组成部分如下(mmu.h文件)：
```
/* page table/directory entry flags */
#define PTE_P           0x001                   // Present
#define PTE_W           0x002                   // Writeable
#define PTE_U           0x004                   // User
#define PTE_PWT         0x008                   // Write-Through
#define PTE_PCD         0x010                   // Cache-Disable
#define PTE_A           0x020                   // Accessed
#define PTE_D           0x040                   // Dirty
#define PTE_PS          0x080                   // Page Size
#define PTE_MBZ         0x180                   // Bits must be zero
#define PTE_AVAIL       0xE00                   // Available for software use
                                                // The PTE_AVAIL bits aren't used by the kernel or interpreted by the
                                                // hardware, so user processes are allowed to set them arbitrarily.

```  
其中`PTE_P`、`PTE_W`和`PTE_U`用于控制权限
`PTE_PWT`和`PTE_PCD`是和cache相关的标志位
`PTE_A`和`PTE_D`可以用于页面替换算法，分别用作访问位和修改位，由此可以实现时钟算法等页面替换算法。

3 缺页异常的处理
---  
　　如果在处理缺页异常的同时再次发生异常，那么由于异常可以嵌套，系统会暂停当前异常的处理，由硬件将当前程序现场保存，取得新异常的信息（如类型、产生位置等等），然后产生中断信号，将这个异常的处理交给异常处理例程进行处理。
　　正常情况下，在缺页异常处理例程中是不会发生第二次缺页的，如果由于操作系统设计不当而又出现了缺页异常，那么系统会直接崩溃。


练习2
===
1 实现过程
---
- 补全do_pgfault()函数，见练习1内容  
- _fifo_map_swappable()函数，用于记录当前访问的页（加入FIFO链表）
	代码如下：  

	```
	//获取page链表的头以及当前访问的页的值
	list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
    assert(entry != NULL && head != NULL);
	//新增代码：把最后的访问的页插入到链表的后面
	//这里采用了和参考答案不同的组织方式：链表的最后一项在head的前面
    list_add_before(head, entry);
    return 0;
	```
- _fifo_swap_out_victim()函数  
	代码如下：  

    ```
	list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
    //新增代码：换出最早访问的页，赋值给ptr_page指向的内容
    *ptr_page = le2page(list_next(head), pra_page_link)
    //并将该页从链表中移除
    list_del(list_next(head));
    return 0;
	```

2 Extended Clock 页替换算法
---
**实现方案**  
当前框架可以完成该算法的实现。
设计方案：


- 仍将所有页组织成环形链表的形式，由指针指向最先调入的页面
- 页面装入内存时，访问位初始化为０，修改位初始化为０
- 访问页面时，如果是读页面，只将访问位置１；如果是写页面访问位和修改位均置１
- 缺页时，从指针处开始顺序检查环形链表，直到找到可以替换的页面，在检查过程中
	- 如果页面访问位和修改位都是１，那么将访问位置０
	- 如果页面访问位为１，修改位为０，那么将访问位置０
	- 如果页面访问位为０，修改位为１，那么将修改位置０，同时需要将内容写到外存里
	- 如果页面访问位和修改位均为０，则置换该页面
- 系统定期将修改过的页写到外存里

**回答问题**  
- 需要被换出的页的特征：  
	页面的访问位和修改位均为0
- 在ucore中如何判断这样的特征：  
	可以利用上面提到PDE、PTE表项中的`PTE_A`访问标志和`PTE_D`修改标志来进行记录和判断
- 何时进行换入和换出操作：  
	- 换入操作：发生缺页，需要访问之前被换出到硬盘中的页面
	- 换出操作：当需要访问或分配新的页面，但是内存中没有多余的空间容纳新页时


其他
===
1 我的答案vs参考答案
---
　　由于本次实验的原理在注释中解释的非常清楚，逻辑上也比较简单，因此答案在主体上和参考答案无明显区别，两答案的最大区别就是参考答案在实现过程中对函数的返回值进行了判断，由此可以得知某函数在调用时失败，随之输出信息便于调试。这样做的好处是代码严谨清楚，考虑问题的角度比较全面，可以保证后续函数在调用时不会出现问题，因此在我的代码中也随之加入了相应的错误处理。
　　在swap_fifo.c文件中，由于FIFO页面置换算法的简单性，所需要操作更加简洁，主要代码和参考答案相同。参考代码中多了一些assert内容，可以使得代码出错的可能降至更低，但其实如果能保证之前的函数的正确性，那么这些语句是不必要的。
　　另外，参考答案中fifo链表的存储方式（头和尾的方向）和我的实现略有不同，不过这并不影响结果的正确性。  
2 知识点 
---
- 中断处理方法及中断处理例程  
	即本实验中对中断调用过程的理解
- 页面替换算法  
	本实验中FIFO算法的实现  
	何时调用页面替换算法等
- 虚存管理  
	理解页表、页目录表的结构与虚地址的映射方法  
	了解地址之间的对应关系，正确调用实验中的各种分配函数
