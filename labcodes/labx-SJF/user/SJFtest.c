#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TOTAL 5
/* to get enough accuracy, MAX_TIME (the running time of each process) should >1000 mseconds. */
#define MAX_TIME  1000
unsigned int acc[TOTAL];
int status[TOTAL];
int pids[TOTAL];

static void
spin_delay(void)
{
     int i;
     volatile int j;
     for (i = 0; i != 200; ++ i)
     {
          j = !j;
     }
}

int
main(void) {
     int i,time;
     memset(pids, 0, sizeof(pids));
     for (i = 0; i < TOTAL; i ++) {
          acc[i]=0;
          if ((pids[i] = SJFfork((TOTAL+1-i)*50)) == 0) {
        	   cprintf("child start,pid:%d,time:%d\n", getpid(), TOTAL+1-i);
               int j;
               for (j=0; j<(i+1)*100000; j++)
            	   spin_delay();
               cprintf("child exit,pid:%d\n", getpid());
               exit(i);
          }
          if (pids[i] < 0) {
               goto failed;
          }
     }

     cprintf("main: fork ok,now need to wait pids.\n");

     for (i = 0; i < TOTAL; i ++) {
         //status[i]=0;
         waitpid(pids[i],&status[i]);
        // cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec());
     }
     cprintf("main: wait pids over\n");

     return 0;

failed:
     for (i = 0; i < TOTAL; i ++) {
          if (pids[i] > 0) {
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
}

