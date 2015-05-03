练习0
===
已完成合并，并对之前代码做少量修改

练习1
===
1 sched_class用法
---
各函数指针定义如下：
```
//初始化运行队列rq
void (*init)(struct run_queue *rq);
//把进程proc插入运行队列rq
void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
//把进程proc从运行队列rq中取出
void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
//从运行队列rq中选取下一个执行的行程
struct proc_struct *(*pick_next)(struct run_queue *rq);
//对于时钟中断的处理
void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
```
2 调度执行过程
---
　　调度发生在当前进程在退出、等待等情况放弃CPU控制权时，执行schedule函数，其中主要部分如下：
```
//设置当前进程不需要调度
current->need_resched = 0;
//如果当前进程是可以运行的，那么将进程放入运行队列  
if (current->state == PROC_RUNNABLE) {
    sched_class_enqueue(current);
}
//从运行队列中选择下一个可以运行的进程
if ((next = sched_class_pick_next()) != NULL) {
//并将其从队列中删除
    sched_class_dequeue(next);
}
//如果该进程不存在（队列为空），那么切换到idleproc进程不断循环直到当前进程可以调度 
if (next == NULL) {
    next = idleproc;
}
//进程运行次数+1
next->runs ++;
//如果下一个进程和当前进程不同，需要使得下一个进程运行（切换到下一个进程）
if (next != current) {
    proc_run(next);
}
```
　　除此之外，在trap_dispatch发现当前是时钟中断时，还需要调用`sched_class_proc_tick`函数进行处理。  
　　运用上述代码，在调度框架中填入不同的代码即可以实现不同的调度算法。
Round Robin算法的处理流程如下：
+ 初始化：对rq中的runlist进行初始化，将rq中的进程数置0
+ 入队：将进程加入到rq的runlist中，更新进程的时间片(如果为0或大于max_time_slice则置为max_time_slice)，设置进程的rq为当前的运行队列，并将rq中的进程数目加1
+ 出队：从runlist列表中把进程删去，并把rq中的进程数目减1
+ 挑选下一个：如果队列非空，直接选择队列头部的进程，否则返回空
+ 处理时钟中断：将进程的time_slice减一，直到为0时设置该进程的need_resched为1，表明时间片结束，下次被打断时将主动放弃CPU控制权进行调度

3 多级反馈队列调度算法
---
　　为了实现多级反馈队列算法，需要定义多个run_queue结构(定义成数组，共有支持的最大优先级个运行队列)，用于支持多个优先级(1级优先级最高，n级最低)，每个运行队列有自己的时间片大小，且时间片的长度是不同的:优先级级别越高（优先级越低），时间片越长。  
　　当进程进入待调度的队列等待时，首先进行优先级最高的队列等待。当选取进程执行时选取该进程执行一个时间片，如果该进程没有执行完毕，则将其加入到下一优先级的队列中。也就是说在入队时需要记录一个进程上一次进入的队列的优先级（在初始化时置０），这样每次入队时将该值加１，放入对应优先级队列的尾部即可。  
　　选取下一个进程时，按优先级顺序，在每一个run_queue中顺序选取，这样只有当高优先级队列中已没有调度的队列才会去调度下一个队列。  
　　其余函数的实现同RR算法类似。  

练习2
===
实现过程
---
0. 准备工作  
	首先需要设置好BIG_STRIDE的值，这个值应该为0x7FFFFFFF，推导过程如下：  
	　　设有两个stride为a、b,增加的步进值为x，并假设当前a,b均未溢出。如果选择a进行执行说明a<=b,那么：  
	　　1)如果a+x>=0x100000000溢出,那么实际存储的值应为a'=a+x-0x100000000,为满足条件,b-a'的值应为负，即b-a'=b-(a+x-0x100000000)>=0x80000000,解得x<=0x80000000+b-a,而a<=b,那么b-a>=0,故x<=0x80000000  
	　　2)若a+x<0x100000000未溢出，那么应有a+x-b为正，即a+x-b<0x80000000,解得x<0x80000000+b-a,再加上b-a>=0,故x<0x8000000  
	为了支持更多的优先级，x应尽量取大一些，因此x取0x7FFFFFFF。
1. 初始化  
	如果使用斜堆，需要对rq->lab6_run_pool进行初始化，赋为空即为初始化  
	如果不使用斜堆，需要使用rq->run_list,使用list_init对其进行初始化  
	最后还要将rq->proc_num置为0  
2. 入队  
	如果使用斜堆，直接使用skew_heap_insert加入进程即可  
	如果不使用斜堆，使用list_add加入列表  
	对加入队列的进程，需要对其时间片进行更新，与RR算法中的方法类似；并且需要设置进程的rq值，将rq->proc_num加1
3. 出队  
	分别使用skew_heap_remove和list_del删除即可，之后将rq->proc_num减1
4. 选取下一个  
	如果使用斜堆比较简单，直接选取rq->lab6_run_pool对应的第一个进程即可  
	如果不使用斜堆，需要遍历整个列表，选择stride最小的一个进程返回
5. 时钟中断处理  
	类似RR算法，将time_slice减1，如果减至0，则将need_resched置1
6. 其他  
	这里比较重要的一点是对于trap中的处理。首先ticks不能在每次增加到TICK_NUM就归零，因为sys_time的系统调用是获取时间，它的实现就是返回ticks的值，如果ticks反复归零，那么返回的时间就不会超过100。另外在处理时钟中断时，需要关中断，然后调用sched_class_proc_tick，以免在处理时出现切换进程的情况。  
	还有sched_class_proc_tick本是static函数，不能在其他文件中调用，为了在trap.c中调用，这里把它的static限制去掉。
7. 关于评测  
	在测试priority.c时结果会不稳定，不一定每次都会出现“1 2 3 4 5”的情况，如可能会出现“1 2 3 4 4”等。

其他
===
1 我的实现 VS 参考答案
---
参考实验指导书上的伪代码以及使用skew_heap提供的相关操作，可以很方便地完成使用斜堆的代码，查看参考答案时发现基本一致。不过发现参考答案使用了USE_SKEP_HEAP宏完成了使用斜堆和使用list实现两种，于是我在自己的代码中补全了这一部分操作。
参考答案中有两点可以改进：
+ 在更新stride选取下一个时答案中判断了priority大于0，而根据我们的规定是不允许priority为0的(在lab6_set_priority中也有体现)，因此我们在初始化进程时就可以把priority置为1。
+ 在不使用斜堆pick_next是手动实现比较，然而我们可以通过复用比较函数：`proc_stride_comp_f(&(p->lab6_run_pool), &(p2->lab6_run_pool))`来实现比较，这样如果之后有扩展或修改会比较方便。  

2 知识点
---
- 调度算法的原理与实现
- 调度框架的使用
- 调度点（内核抢占点）
- stride算法的比较与big_stride的选择
- 斜堆数据结构的使用
