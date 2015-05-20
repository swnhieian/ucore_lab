LabX 实现短作业优先（SJF）调度算法
===
1 小组成员
---
2012011367 石伟男  
2012011364 矣晓沅  
2012011369 王轩  

2 设计思路
---
　　运用lab6中提供的调度算法的框架，在`struct proc`中定义SJF_time成员变量，用于表示进程的预计完成时间，并置初始值为无符号整形的最大值。
　　需要给用户态程序提价一个设置进程预计完成时间的系统调用，这里使用了`SJFfork(unsigned int)`函数，在完成fork的同时设置SJF_time的值。这里并不能像`lab6_set_priority`一样在进程开始执行后设置时间，因为SJF调度算法会将进程执行到结束为止，而一旦进程开始执行，说明已经被调度算法选中，此时再改变时间已经没有任何作用。
　　进程调度中仍要实现如下几个函数(提供了使用skew heap和不使用两种机制)：
+ `SJF_init`和stride相同
+ `SJF_enqueue`、`SJF_dequeue`和stride相同，唯一不同的是比较函数的不同
+ `proc_SJF_comp_f`两个进程的比较函数，比较SJF_time的大小
+ `SJF_pick_next`选取SJF_time最小的进程
+ `SJF_proc_tick`在时钟中断开始时将SJF_time减1，如果SJF_time为0，说明进程没有在预计的时间内完成，系统将提示杀死进程，并使得进程退出 。

3 实验结果
---
　　代码中的SJFtest文件是对SJF调度算法的测试，其中使用SJFfork创建了五个时间依次递减的进程（其中包括预计时间不足被进程杀死的），直接运行`make qemu`可以得到结果如下：
```
kernel_execve: pid = 2, name = "SJFtest".
main: fork ok,now need to wait pids.
child start,pid:7,time:2
proc 7 run out of time, killed by kernel!
child start,pid:6,time:3
child exit,pid:6
child start,pid:5,time:4
child exit,pid:5
child start,pid:4,time:5
child exit,pid:4
child start,pid:3,time:6
child exit,pid:3
main: wait pids over
all user-mode processes have quit.
```

