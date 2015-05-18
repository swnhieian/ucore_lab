LabX 实现基于VFS接口的pipe机制
===
1 小组成员
---
2012011367 石伟男  
2012011364 矣晓沅  
2012011369 王轩  

2 设计思路
---
　　使用VFS机制提供的接口，设计一个pipe用的pipefs,在系统调用时，创建出两个file，一个只读，一个只写，并使这两个file连接到同一个inode上，inode里使用pipefs里定义的pipefs_inode，并在其中维护一个数据缓冲区，使用VFS提供的read/write接口，在该数据缓冲区里读写数据。  
　　在缓冲区里提供了一个head和一个tail指针，当两个指针重合时数据为空，并且在filefs_inode中提供了一个管程wait,用来对进程间的同步进行管理。  
　　写数据的过程如下：首先进入管程，当有数据要写入时，不断循环，循环中的内容为，首先获取当前缓冲区里的空闲空间，如果没有空闲空间，则使用管程通知当前睡在条件变量上的进程进行读操作，如果没有需要进行读操作的进程，则直接返回，否则当前进程睡眠，等待其他进程读数据。当缓冲区中有空闲空间时，将数据写入缓冲区中，并同步更新指针，已写字节数，以及剩余字节数。  
　　读数据的过程和上面类似。
3 关键数据结构与函数
---
　　主要代码位于kern/fs/pipefs文件夹下。
+ pipefs_inode结构  
```
pipefs_inode {  
    char* data;        //数据缓冲区  
    int head, tail;    //头指针和尾指针，写数据时从头指针开始写，读数据时从尾指针开始读  
    monitor_t wait;    //用于同步  
};
```
+ pipe系统调用 kern/fs/file.c文件的file_pipe函数，调用fd_array_alloc给进程分配两个file,kern/fs/pipe/fs/pipefs_inode.c中的pipefs_create_inode函数创建inode,并直接用fd_array_open打开文件，设置好文件的读写属性。
+ 读文件 kern/fs/pipefs/pipefs_inode.c 中的pipefs_read函数。
+ 写文件 kern/fs/pipefs/pipefs_inode.c 中的pipefs_write函数。
+ 释放inode kern/fs/pipefs/pipefs_inode.c 中的pipefs_reclaim函数

4 实验结果
---
　　运行代码中的测试文件pipe得到结果,fork两个进程，父进程读，子进程写，结果如下：
```
program begins!
this is child process
I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
this is parent process
I want to read 10 chars from pipe, success with 10 chars:HELLO, WOR
I want to read 10 chars from pipe, success with 3 chars:LD!
```
　　运行代码中的测试文件pipe2得到结果，两个进程，乱序读写，结果如下：
```
program begins!
parent:read failed!
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:HELLO, WOR
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:LD!HELLO, 
parent:I want to read 10 chars from pipe, success with 6 chars:WORLD!
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:HELLO, WOR
parent:I want to read 10 chars from pipe, success with 3 chars:LD!
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:HELLO, WOR
parent:I want to read 10 chars from pipe, success with 3 chars:LD!
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:HELLO, WOR
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
parent:I want to read 10 chars from pipe, success with 10 chars:LD!HELLO, 
parent:I want to read 10 chars from pipe, success with 6 chars:WORLD!
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
child:I want to write 'HELLO, WORLD!' to pipe, success with 13 chars
```

