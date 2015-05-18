#include <defs.h>
#include <string.h>
#include <stdlib.h>
#include <list.h>
#include <stat.h>
#include <kmalloc.h>
#include <vfs.h>
#include <dev.h>
#include <pipefs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>


static const struct inode_ops pipefs_node_fileops; // file operation

static int pipe_inode_exist_space(struct pipefs_inode *node) {
	if (node->head >= node->tail) return (node->head - node->tail);
	return (PIPE_MAX_DATA_SIZE - (node->tail - node->head));
}
static int pipe_inode_free_space(struct pipefs_inode *node) {
	return (PIPE_MAX_DATA_SIZE - 1 - pipe_inode_exist_space(node));
}
static void write_into(char* src, char* dst, int len) {
	int i;
	for (i=0; i<len; i++)
		dst[i] = src[i];
}
static void show_status(struct pipefs_inode *node) {
	cprintf("=========node ========\n");
	cprintf("%d %d\n", node->head, node->tail);
	int i;
	for (i=0; i<13; i++) {
		cprintf("%c", *(node->data+node->tail+i));
	}

	cprintf("\n=========node end========\n");
}
// sfs_openfile - open file (no use)
static int
pipefs_openfile(struct inode *node, uint32_t open_flags) {
    return 0;
}

// pipefs_close - close file
static int
pipefs_close(struct inode *node) {
    return 0;
}
// pipefs_read - read file
static int
pipefs_read(struct inode *node, struct iobuf *iob) {
	struct pipefs_inode *pin = vop_info(node, pipefs_inode);
	int read = 0;
	int size, chars;
	down(&(pin->wait.mutex));
	{
		while(iob->io_resid >0) {
			while (!(size = pipe_inode_exist_space(pin))) {
				cond_signal((pin->wait.cv));
				if (pin->wait.next_count == 0) {
					up(&(pin->wait.mutex));
					return (read?read:-1);
				}
				cond_wait((pin->wait.cv));
			}
			if (size > iob->io_resid)
				size = iob->io_resid;
			write_into(pin->data+pin->tail, ((char*)iob->io_base)/*+iob->io_offset*/, size);
			MOVE(pin->tail, size);
			iob->io_resid -= size;
			//iob->io_offset += size;
			read += size;
		}
	}
	cond_signal((pin->wait.cv));
	if(pin->wait.next_count>0)
        up(&(pin->wait.next));
	else
		up(&(pin->wait.mutex));
    return read;
}

// pipefs_write - write file
static int
pipefs_write(struct inode *node, struct iobuf *iob) {
	struct pipefs_inode *pin = vop_info(node, pipefs_inode);
	int write=0;
	int size;
	down(&(pin->wait.mutex));
	while (iob->io_resid > 0) {
		while (!(size = pipe_inode_free_space(node))) {
			cond_signal((pin->wait.cv));
			if (pin->wait.next_count == 0) {
				up(&(pin->wait.mutex));
				return (write?write:-1);
			}
			cond_wait((pin->wait.cv));
		}
		if (size > iob->io_resid)
			size = iob->io_resid;
		write_into(((char*)iob->io_base)/*+iob->io_offset*/, pin->data+pin->head, size);
		MOVE(pin->head, size);
		iob->io_resid -= size;
		write += size;
	}
	cond_signal((pin->wait.cv));
	if(pin->wait.next_count>0)
		up(&(pin->wait.next));
	else
		up(&(pin->wait.mutex));
    return write;
}
/*
 * pipefs_reclaim - Free all resources inode occupied . Called when inode is no longer in use.
 */
static int
pipefs_reclaim(struct inode *node) {
	struct pipefs_inode *pin = vop_info(node, pipefs_inode);
	kfree((void*)(pin->data));
	vop_kill(node);
    return 0;
}

int pipefs_create_inode(struct inode ** node_store) {
	struct inode *node;
	if ((node = alloc_inode(pipefs_inode)) != NULL) {
		vop_init(node, &pipefs_node_fileops, NULL);
		struct pipefs_inode *pin = vop_info(node, pipefs_inode);
		monitor_init(&(pin->wait), 1);
		pin->data = (char*)(kmalloc(PIPE_MAX_DATA_SIZE));
		pin->head = pin->tail = 0;
		*node_store = node;
		return 0;
	}
	return -E_NO_MEM;
}
static const struct inode_ops pipefs_node_fileops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = pipefs_openfile,
    .vop_close                      = pipefs_close,
    .vop_read                       = pipefs_read,
    .vop_write                      = pipefs_write,
    //.vop_fstat                      = sfs_fstat,
    //.vop_fsync                      = sfs_fsync,
    .vop_reclaim                    = pipefs_reclaim,
    //.vop_gettype                    = sfs_gettype,
    //.vop_tryseek                    = sfs_tryseek,
    //.vop_truncate                   = sfs_truncfile,
};
