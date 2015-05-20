练习0
===
　　已完成合并，并对之前代码做少量修改

练习1
===
1 编码
---
　　在`sfs_io_nolock`函数中实现了缓冲区和文件系统之间的读/写过程。磁盘上的内容是从offset开始，由于每次的读写单元是一个block,需要考虑块是否对齐的问题。函数的开始部分是基本的赋值和判断，核心部分主要可分为三个部分，如下实现：
```
/*下面是一个磁盘内容逻辑布局示意图，这里开始和结尾处都没有对齐
        offset                                           endpos
          |                                                | 
          V                                                V
     |  0 |  1 |                    2                  | 3 |
-----------------------------------------------------------------------
     |         |         |         |         |         |         |
 ……  |  block  |  block  |  block  |  block  |  block  |  block  | ……
     |         |         |         |         |         |         |
-----------------------------------------------------------------------
*/       
uint32_t blkno = offset / SFS_BLKSIZE;          //blkno是当前的块编号
uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  //结束处所在的块号和开始处所在的块号之差
blkoff = offset % SFS_BLKSIZE;                  //blkoff是开始处的偏移，即目力产中0区域的长度
if (blkoff != 0) {                              //处理1号区域的读/写问题
    size = (nblks != 0) ? (SFS_BLKSIZE -blkoff) : (endpos - offset);  //size为要读/写的长度
    if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)))          //这里通过逻辑编号获取磁盘块的实际编号，保存在ino里
    	goto out;
    if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)))              //这里是真实的读/写数据
    	goto out;
    alen += size;
    if (nblks == 0)
    	goto out;
    buf += size;
    nblks --;
    blkno ++;
}
size = SFS_BLKSIZE;                                                   //下面对示意图中的区域2进行处理，这里包含blkno个块（上面已经减1）
if (nblks > 0) {
  	if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)))
   		goto out;
   	if ((ret = sfs_block_op(sfs, buf, ino, blkno)))                   //这里可以直接通过块操作一次完成
   		goto out;
   	alen += (size * nblks);
   	buf += (size * nblks);
   	blkno += nblks;
}
size = endpos % SFS_BLKSIZE;                                          //现在size是示意图中区域3的长度
if (size > 0) {                                                       //类似于区域1的处理方式
  	if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)))
   		goto out;
   	if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)))
   	    goto out;
   	alen += size;
   	buf += size;
}

```
　
2 UNIX的PIPE机制
---
　　已经完成实验编码，代码地址为　https://github.com/swnhieian/ucore_lab/blob/master/labcodes/labx-pipe/labx-pipe.md ，主要设计思路如下：  
　　使用VFS机制提供的接口，设计一个pipe用的pipefs,在系统调用时，创建出两个file，一个只读，一个只写，并使这两个file连接到同一个inode上，inode里使用pipefs里定义的pipefs_inode，并在其中维护一个数据缓冲区，使用VFS提供的read/write接口，在该数据缓冲区里读写数据。  
　　在缓冲区里提供了一个head和一个tail指针，当两个指针重合时数据为空，并且在filefs_inode中提供了一个管程wait,用来对进程间的同步进行管理。  
　　写数据的过程如下：首先进入管程，当有数据要写入时，不断循环，循环中的内容为，首先获取当前缓冲区里的空闲空间，如果没有空闲空间，则使用管程通知当前睡在条件变量上的进程进行读操作，如果没有需要进行读操作的进程，则直接返回，否则当前进程睡眠，等待其他进程读数据。当缓冲区中有空闲空间时，将数据写入缓冲区中，并同步更新指针，已写字节数，以及剩余字节数。  
　　读数据的过程和上面类似。  

练习2
===
1 编码
---
　　`load_icode`函数是将用户态的程序加载到当前的进程中，并设置好内存等一系列相关的值。其大体实现和lab7之前的代码类似，唯一不同的是之前是从内存中加载，现在是从文件系统中加载，因此参数上变成了一个文件描述符fd，其他不同的地方如下：（代码中以`different from lab7`注释）  
　　lab7中是从指定位置直接加载elfhdr，而现在是通过`load_icode_read`函数从指定的文件中读取。  
　　读取proghdr、以及加载程序的text/data section的时候也是通过`load_icode_read`函数读取。  
　　读取完文件内容，设置CR3内存等值后比较关键的一步是设置程序的参数（argc,kargv）：  
```
/*
以参数个数为2，分别为hello和world为例，用户栈顶部布局示意图如下：

    初始栈顶:USTACKTOP-->|               |
                        |---------------|
                        |   world       |<-------------p2
     曾经stacktop位置    |   hello       |<-------------p1
                        |---------------|
             uargv[1]-->|   char*       |   指针，指向-- p2
                uargv-->|   char*       |   指针，指向-- p1
                        |---------------|
      当前栈顶stacktop-->|   2(argc)     |
                        |               |
                        |               |
                        |               |

*/
uint32_t argv_size=0;
for (i = 0; i < argc; i ++) {
    argv_size += strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;                //计算放置参数值所需要的空间
}
uintptr_t stacktop = USTACKTOP - (argv_size/sizeof(long)+1)*sizeof(long); //找到放置完参数值后的栈顶位置，上图中‘曾经stacktop所在位置’
char** uargv=(char **)(stacktop  - argc * sizeof(char *));                //为放置参数的指针留出位置,示意图中uargv位置
argv_size = 0;
for (i = 0; i < argc; i ++) {
    uargv[i] = strcpy((char *)(stacktop + argv_size ), kargv[i]);         //把每一个参数复制到相应的位置
    argv_size +=  strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
}
stacktop = (uintptr_t)uargv - sizeof(int);                                //留出放置argc的位置，示意图中stacktop当前栈顶位置
*(int *)stacktop = argc;                                                  //设置argc（参数个数）
```
　　上述设置完成后只需要将stacktop赋值给trapframe中的esp即可。
2 UNIX的硬链接和软链接机制
---
+ 硬链接机制的设计实现：  
	vfs中预留了硬链接的实现接口`int vfs_link(char *old_path, char *new_path);`，在实现硬链接机制的时候，只要把为new_path创建对应的file,并把其inode指向old_path所对应的inode，并把inode的引用计数加1，在unlink时将引用计数减去即可。
+ 软链接机制的设计实现：  
	软链接相当于一种特殊的文件，即"快捷方式"。可以在创建软链接时分配创建一个新的文件（这时创建了一个新的inode），并把old_path的内容存放到文件的内容中去，给该文件保存在磁盘上时disk_inode类型为`SFS_TYPE_LINK`，再完善对于该类型inode的操作即可。unlink时类似于删除一个普通的文件。

其他
===
1 我的实现 VS 参考答案
---
　　在补全`sfs_io_nolock`函数时我对参考答案代码做了优化：该实现分为三个部分，分别是读/写开头未对齐的部分，读/写中间对齐的部分以及读/写结尾未对齐的部分，在读写中间对齐的块时答案采用了循环nblks次每次调用`sfs_block_op`，但是传给它的最后一个参数（读/写块的个数）却是1，然而由于这个参数的存在，实际我们可以只用一次操作（参数传入nblks）代替，这样代码显得更优美。  
　　在实现`load_icode`时，基本是在lab7之前的代码的基础上进行修改，不同部分在代码上有`different from lab7`的注释。  
 
2 知识点
---
- 文件系统的结构
- VFS提供的接口,文件和目录等的各种操作
- 真实文件系统（SFS）是怎样和VFS关联的
- 文件和磁盘之间的交互
- 没有涉及到文件块的分配等知识