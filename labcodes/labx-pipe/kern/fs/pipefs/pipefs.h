#ifndef __KERN_FS_PIPEFS_PIPEFS_H__
#define __KERN_FS_PIPEFS_PIPEFS_H__

#include <defs.h>
#include <mmu.h>
#include <list.h>
#include <sem.h>
#include <sem.h>
#include <monitor.h>
#include <unistd.h>

#define PIPE_MAX_DATA_SIZE 2048

#define MOVE(ptr, len) ((ptr)=(((ptr)+(len))%PIPE_MAX_DATA_SIZE))
struct pipefs_inode {
	char* data;
	int head, tail;
	monitor_t wait;
};
struct inode;
void pipefs_init(void);
int pipefs_create_inode(struct inode ** node_store);

#endif
