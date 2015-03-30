##练习0  

已完成合并。
##练习1  

####1 实现  
对各函数的简要说明如下：
default_init
这里是对系统需要用到的数据结构的初始化，包括对free_list链表的初始化和nr_free空闲页个数置0的初始化。
default_init_memmap
这个函数是对内存中空闲页的初始化，即将它们加入到空闲页的列表中。  
主要代码如下：  
```
    struct Page *p = base;
    //对于需要初始化的每一个页
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = 0;
        //设置标志位表明该页有效
        SetPageProperty(p);  
        //property的值表示以该页开头有多少个连续的页，除了base外都为0，先统一设置成0
        p->property = 0;
        //开始的时候页都没有引用
        set_page_ref(p, 0);
        //将页按顺序加到链表的末尾
        list_add_before(&free_list, &(p->page_link));
    }
    //修改base的property和nr_free的值
    base->property = n;
    nr_free += n;
```
default_alloc_pages
这个函数的作用是配从base开始的n个连续的页。
```
    if (n > nr_free) {                                         //如果需要分配的页多于当前空闲的总页数，则分配失败
        return NULL;
    }
    struct Page *page = NULL;  
    list_entry_t *le = &free_list;
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {               //从头开始遍历页表
        page = le2page(le, page_link);
        if (page->property >= n) {                             //一旦找到一个大于n个连续页的块，就开始分配
            int i;
            for (i=0; i<n; i++) {                              //对于需要分配出去的n个页
                 struct Page* tempp = le2page(le, page_link);
                 SetPageReserved(tempp);                       //设置标志表明它们已经被使用
                 ClearPageProperty(tempp);                     //清除可用标志
                 temp = list_next(le);
                 list_del(le);                                 //在空闲页列表里删除当前页
                 le = temp;
            }
            size_t rest = page->property - n;                  //如果当前空闲块的页数大于n，
            if (rest > 0) {                                    //那么分配n个页后剩下的第一个页
                (le2page(le, page_link))->property = rest;     //作为新的块的形状，它的property
            }                                                  //比原来的小n
            nr_free -= n;                                      //更新空闲页个数
            return page;
        }
    }
    return NULL;                                                //如果整个列表中都没有比n大的块，那么分配失败
```
default_free_pages
这个函数的作用是释放从base开始的n个连续页，并对空闲块做合并工作。
```
assert(n > 0);
    struct Page *p = base;
 
    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {                     //按顺序寻找，找到第一个地址大于base的页
        if ((le2page(le, page_link)) > base)                       //这一页的前面就是要释放的块应该插入的位置
            break;
    }
    for (p = base; p<base+n; p++) {                                //对于要释放的每一个页
        set_page_ref(p, 0);                                        //置引用个数为0
        ClearPageReserved(p);                                      //清除使用标志
        SetPageProperty(p);                                        //设置有效可用标志
        p->property = 0;                                           //先统一设置property为0
        list_add_before(le, &(p->page_link));                      //并将它们重新加入的空闲链表当中
    }
    base->property = n;                                            //设置base的property
    p = le2page(le, page_link);
    if (base + n == p) {                                           //看当前块是否能和后面的块进行合并
        base->property += p->property;                             //如果能，修改它们的property值
        p->property = 0;
    }
    le = list_prev(&(base->page_link));                            //切换到base的前一页
    if ((le != &free_list) && (le2page(le, page_link)+1==base)) {  //只有前一页和base相连的时候才有可能合并
        while (le != &free_list) {                                 //向前遍历
            p = le2page(le, page_link);
            if (p->property > 0) {                                 //找到当前块的第一页
                p->property += base->property;                     //修改base和它的property，完成合并
                base->property = 0;
                break;
            }
            le = list_prev(le);
        }
    }
    nr_free += n;                                                  //修改空闲页个数
```
####2 改进空间  

当前在空闲页列表中存储的是每一页，而遍历的时候则是一页页遍历，通过property的值来判断块的大小，
如果有一个块很大，那么需要遍历很多个无用的页。可以改进存储方式 ，将空闲页按连续块进行存储，而每一块中则只需要记录
第一页的起始地址和块中页的个数，这样在遍历的时候可以节约很多空间。

##练习二  

####1 实现  

get_pte函数是通过PDT的基址pgdir和线性地址la来获取pte
```
    //PDX根据la获取其页目录的索引，根据此索引可以得到页目录项pde，由于可能对其进行修改
    //这里采用指向pde的指针pdep，而*pdep中保存的便是pde的真实内容
    pde_t *pdep = &pgdir[PDX(la)];                    
    struct Page * page;
    //根据pde中的present标志位，如果不存在，则需要创建一页（这一页的作用是用作页表）
    if (!((*pdep) & PTE_P)) { 
        //参数中指明不要创建则返回NULL
        if (!create) {  
            return NULL;
        }
        page = alloc_page();
        //如果创建失败同样返回NULL
        if (page == NULL) return NULL;
        //设置ref表示该page被引用一次
        set_page_ref(page, 1);
        //这里获取该页的物理地址，也就是需要给pde赋的值
        uintptr_t page_addr = page2pa(page);
        //将页的内容清空，这里需要调用memset所以需要虚拟地址
        memset(KADDR(page_addr), 0, PGSIZE);
        //设置pde的同时需要设置标志位
        *pdep = page_addr | PTE_P | PTE_W | PTE_U;
    }
    //现在pde的值已经存在了
    //需要返回的值是pte的指针，这里先将pde中的地址转化为程序可用的虚拟地址
    //将这个地址转化为pte数据类型的指针，然后根据la的值索引出对应的pte表项
    //最后通过&取得它的指针返回
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
```
####2  

PDE和PTE的组成（详见mmu.h文件）
```
#define PTE_P           0x001                   // 当前项是否存在，用于判断缺页
#define PTE_W           0x002                   // 当前项是否可写，标志权限
#define PTE_U           0x004                   // 用户是否可获取，标志权限
#define PTE_PWT         0x008                   // 写直达缓存机制,硬件使用Write Through
#define PTE_PCD         0x010                   // 禁用缓存，硬件使用Cache-Disable
#define PTE_A           0x020                   // Accessed
#define PTE_D           0x040                   // 页是否被修改，硬件使用（dirty)
#define PTE_PS          0x080                   // 页大小
#define PTE_MBZ         0x180                   // 必须为0的位
#define PTE_AVAIL       0xE00                   // 软件使用的位，可任意设置
```
####3  
硬件需要根据设置的IDT找到对应异常的处理例程的入口，然后跳转到该处理例程处理该异常。

##练习三  
####1 实现  

page_remove_pte函数：释放la地址所指向的页，并设置对应的pte的值
```
    if (*ptep & PTE_P) {                         //首先确保页存在
        struct Page* page = pte2page(*ptep);     //找到pte所在的页
        page_ref_dec(page);                      //把pte所在页的ref减一
        if (page_ref(page) == 0) {               //如果该页已经没有ref
            free_page(page);                     //那么pte所在的页可以释放看
        }
        *ptep = 0;                               //释放pte指向的页
        tlb_invalidate(pgdir, la);               //由于页表改变，清空tlb
    }
```
####2 Page的全局变量  

Page的全局变量为pages。
pages变量对应的是每一个页的虚拟地址，而页表项和页目录项都指向一个页，它们保存的是页的物理地址，通过pte2page、pde2page可以将pte、pte中保存的页映射到page中的虚拟地址对应的页。
####3 修改lab2  

需要修改pages变量的地址，如果把它的虚拟地址映射到0处就实现了page的虚拟地址等于物理地址。

