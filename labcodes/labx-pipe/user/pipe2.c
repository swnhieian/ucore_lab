#include <stdio.h>
#include <ulib.h>
#include <file.h>
#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <dir.h>
#include <file.h>
#include <stat.h>
#include <dirent.h>
#include <unistd.h>


int main(void) {
    cprintf("program begins!\n");
    int i;
    int num = 10;
    int fd[2];
    char msg[100];
    if (i = pipe(fd)) {
    	return i;
    }
    int pid;
    if ((pid =fork()) == 0) {
    	close(fd[0]);
    	strcpy(msg, "HELLO, WORLD!");
    	for (i=0; i<num; i++) {
    		int ret = write(fd[1], msg, strlen(msg));
    		if (ret >=0) {
    			cprintf("child:I want to write \'%s\' to pipe, success with %d chars\n", msg, ret);
    		} else {
    			cprintf("child:write failed!\n");
    		}
    		sleep(2);
    	}
    	close(fd[1]);
    } else {
    	close(fd[1]);
    	int len = 10;
    	for (i=0; i<num+1; i++) {
    		int ret = read(fd[0], msg, len);
    		if (ret >=0) {
    			msg[ret] = '\0';
    			cprintf("parent:I want to read %d chars from pipe, success with %d chars:%s\n", len, ret, msg);
    		} else {
    			cprintf("parent:read failed!\n");
    		}
    		sleep(1);
    	}
    	close(fd[0]);
    }
    wait();
    return 0;
}
