#include <defs.h>
#include <list.h>
#include <proc.h>
#include <error.h>
#include <assert.h>
#include <default_sched.h>

#define USE_SKEW_HEAP 1

/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_SJF_comp_f(void *a, void *b)
{
     struct proc_struct *p = le2proc(a, lab6_run_pool);
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     int32_t c = p->SJF_time - q->SJF_time;
     if (c > 0) return 1;
     else if (c == 0) return 0;
     else return -1;
}

static void
SJF_init(struct run_queue *rq) {
     list_init(&(rq->run_list));
     rq->lab6_run_pool = NULL;
     rq->proc_num = 0;
}


static void
SJF_enqueue(struct run_queue *rq, struct proc_struct *proc) {
#if USE_SKEW_HEAP
     rq->lab6_run_pool =
          skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_SJF_comp_f);
#else
     assert(list_empty(&(proc->run_link)));
     list_add_before(&(rq->run_list), &(proc->run_link));
#endif
     if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
          proc->time_slice = rq->max_time_slice;
     }
     proc->rq = rq;
     rq->proc_num ++;
}

static void
SJF_dequeue(struct run_queue *rq, struct proc_struct *proc) {
#if USE_SKEW_HEAP
     rq->lab6_run_pool =
          skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_SJF_comp_f);
#else
     assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
     list_del_init(&(proc->run_link));
#endif
     rq->proc_num --;
}

static struct proc_struct *
SJF_pick_next(struct run_queue *rq) {
#if USE_SKEW_HEAP
     if (rq->lab6_run_pool == NULL) return NULL;
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
#else
     list_entry_t *le = list_next(&(rq->run_list));

     if (le == &rq->run_list)
          return NULL;
     
     struct proc_struct *p = le2proc(le, run_link);
     le = list_next(le);
     while (le != &rq->run_list)
     {
          struct proc_struct *q = le2proc(le, run_link);
          if ((proc_SJF_comp_f(&(p->lab6_run_pool),&(q->lab6_run_pool))) > 0)
               p = q;
          le = list_next(le);
     }
#endif
     return p;
}



static void
SJF_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     if (proc->SJF_time > 0) {
          proc->SJF_time --;
     }
     if (proc->SJF_time == 0) {
          proc->need_resched = 0;
          cprintf("proc %d run out of time, killed by kernel!\n", proc->pid);
          do_exit(-E_KILLED);
     }
}

struct sched_class default_sched_class = {
     .name = "SJF_scheduler",
     .init = SJF_init,
     .enqueue = SJF_enqueue,
     .dequeue = SJF_dequeue,
     .pick_next = SJF_pick_next,
     .proc_tick = SJF_proc_tick,
};

