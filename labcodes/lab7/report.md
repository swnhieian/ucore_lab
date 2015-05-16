练习0
===
　　已完成合并，并对之前代码做少量修改

练习1
===
1 信号量的设计描述
---
　　信号量由如下数据结构定义：
```
typedef struct {
    int value;                   //信号量的当前值
    wait_queue_t wait_queue;     //信号量对应的等待队列
} semaphore_t;
```
　　其基本操作包括P操作(down)和V操作(up)，这两个操作的核心代码分别在`__down`和`__up`函数中实现：
+ `__down`具体实现如下所示：  
```
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);                                //关中断
    if (sem->value > 0) {                                      //如果当前信号量的值大于0，表明可以直接获得信号量
        sem->value --;                                         //因此这时value值减一
        local_intr_restore(intr_flag);                         //开中断
        return 0;                                              //直接返回即可
    }
    wait_t __wait, *wait = &__wait;                            //否则，说明无法获得信号量，
    wait_current_set(&(sem->wait_queue), wait, wait_state);    //将其挂入等待队列中
    local_intr_restore(intr_flag);                             //打开中断
    schedule();                                                //进行调度
    local_intr_save(intr_flag);                                //执行到这里说明被up操作唤醒，关中断
    wait_current_del(&(sem->wait_queue), wait);                //将wait从等待队列中删除
    local_intr_restore(intr_flag);                             //开中断
    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```
+ ` __up`具体实现如下所示：
```
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);                                       //关中断
    {
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {  //如果在等待队列中没有进程在等待
            sem->value ++;                                            //那么直接将value值加1
        }
        else {                                                        //如果有进程在等待，
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);     //调用wakeup_wait将该等待进程从队列中删除，并且将该进程唤醒
        }
    }
    local_intr_restore(intr_flag);                                    //开中断返回
}
```

2 用户态信号量机制设计实现
---
　　上述信号量的相关操作是在内核态中完成了，使用了进程切换、开关中断等操作，而这些操作在用户态是无法进行的。因此如果想在用户态实现信号量机制，需要通过系统调用来实现。  
　　我们可以定义三个系统调用，分别为创建信号量，P操作和V操作，在执行系统调用（中断）的时候在内核态中使用内核中定义的三个函数来完成相应的操作。  
3 比较
---
　　用户态和内核态实现信号量的原理是类似的，只是由于所处特权级不同，导致实现方式略有差别，实际上用户态实现信号量只是相当于将内核态的信号量的函数加了一层“壳”，通过系统调用改变优先级来进行访问。

练习2
===
1 管程与条件变量的设计描述
---
　　管程由如下数据结构定义：
```
typedef struct monitor{
    semaphore_t mutex;      //mutex实现了一个二值信号量(初始化时value值设为1)，用于确保每次只有一个进程进入管程
    semaphore_t next;       //用于唤醒由于发出signal操作而睡眠的进程
    int next_count;         //上述睡眠进程的个数
    condvar_t *cv;          //管程中的条件变量
} monitor_t;
```
　　条件变量由如下数据结构定义：
```
typedef struct condvar{
    semaphore_t sem;        //让发出wait操作的进程睡眠，让发出signal操作的进程通过该信号量唤醒睡眠的进程
    int count;              //表示等待在该条件变量上的睡眠进程个数
    monitor_t * owner;      //表示该条件变量的宿主是哪个管程
} condvar_t;
```
　　管程中两个关键的操作函数是cond_wait，用于将该进程挂起并进行等待，直到该进程等待的条件为真，为真后程序会自动唤醒睡眠中的进程；cond_signal用于唤醒等待中的一个进程。
+ cond_wait具体实现如下：
```
void cond_wait (condvar_t *cvp) {
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
      cvp->count++;                     //调用了wait,说明该进程需要进行睡眠，睡眠的进程数加1
      if(cvp->owner->next_count > 0)    //如果有进程执行cond_signal函数且睡着了，那么睡在了moniter.next的信号量上
         up(&(cvp->owner->next));       //那么这时需要唤醒其中一个进程
      else                              //如果没有进程执行cond_signal函数睡着了，那么
         up(&(cvp->owner->mutex));      //需要唤醒由于互斥条件限制而无法进入管程的进程，即mutex信号量上的进程
      down(&(cvp->sem));                //让当前进程睡在sem上
      cvp->count --;                    //如果当前进程醒了，那么睡眠的进程数减1
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
```
+ cond_signal具体实现如下：
``` 
void cond_signal (condvar_t *cvp) {
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
     if(cvp->count>0) {              //如果有进程正在睡眠中
        cvp->owner->next_count ++;   //那么需要让自己睡眠
        up(&(cvp->sem));             //唤醒一个正在睡眠的进程(该进程睡在sem上)
        down(&(cvp->owner->next));   //让自己睡在next上
        cvp->owner->next_count --;   //如果自己醒了，让睡眠数减1
      }                              //否则没有进程在睡眠，直接返回
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
```
　　另外，管程在调用的时候的框架如下，以check_sync中的函数为例：
```
//这里mtp是管程
void phi_take_forks_condvar(int i) {
     down(&(mtp->mutex));                       //这是确保只有一个进程能进入管程进行操作
//--------into routine in monitor--------------
     //这里是函数的真正执行的部分
//--------leave routine in monitor--------------
      if(mtp->next_count>0)                     //这里确保所有通过执行cond_signal而睡眠的进程能够被唤醒
         up(&(mtp->next));
      else                                      //当再无上述进程可被唤醒时，释放管程的锁，确保其他进程可以使用管程
         up(&(mtp->mutex));
}
```
　　以上各函数的协调使用完成了整个管程和条件变量机制的实现。  

2 用户态条件变量机制设计实现
---  
　　和信号量类似，这里可以通过新建系统调用封装各操作的方式来实现。  

3 比较  
---  
　　同上面提到的信号量的区别，不再赘述。  

其他
===
1 我的实现 VS 参考答案
---
　　本次实验的原理代码十分清晰，只要判断ucore中各函数的使用方法即可写出完整的代码，实现方式也和答案完全相同。
 
2 知识点
---
- 信号量的原理和实现
- 条件变量的原理和实现
- 管程的原理和实现
- 哲学家就餐问题的描述和解决
- 读者写者问题没有得到体现
