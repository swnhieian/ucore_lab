##练习一##
####1####

　　执行命令`make V=`可以看到命令行中输出了执行的编译命令，对应的是Makefile里面含有$(V)的语句。
这里结合输出和Makefile文件中的内容进行递归式的详细分析。  
　　为了生成ucore.img，Makefile里的命令为：
```
$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
```
　　这里的三条指令的含义首先是将ucore.img先拷贝为全0(10000个块），然后将bootblock拷贝到第一个块里（conv=notrunc的含义是只修改目标文件对应的数据而不截短文件），最后跳过一个块（seek=1），把kernel写入第二个块里。
由这里的依赖关系可知，要想生成ucore.img,首先需要生成kernel和bootblock两个模块。

***kernel模块***  
生成bin/kernel的代码如下：
```
$(kernel): tools/kernel.ld
$(kernel): $(KOBJS)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
```
　　可以看到kernel依赖于kernel.ld以及KOBJS。  
　　这里的KOBJS是libs和kern目录下的所有.c文件生成的.o目标文件（这里参见function.mk里面的read_packet以及packetname函数）。  
　　编译的命令(定义在LDFLAGS里)转化过来就是  
```ld -m elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel```

+ -m elf_i386为模拟i386上的连接器  
+ -nostdlib为不使用标准库,仅搜索那些在命令行上显式指定的库路径  
+ -T选项的意思按照指定的脚本文件（tools/kernel.ld)来进行链接  

　　它依赖的.o目标文件是通过add_files_cc(*此处参考答案*)在funciton.mk中最终调用的cc_template里的
```$(V)$(2) -I$$(dir $(1)) $(3) -c $$< -o $$@```
实现的。这一命令翻译过来（以init.c为例）如下：  
```
gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
```
其中
+ -Ikern/init/等指定了头文件所在的文件夹  
+ -fno-builtin不使用不用__builtint_修饰的内建函数  
+ -Wall显示所有警告信息  
+ -ggdb产生gdb使用的调试信息  
+ -m32生成32位代码
+ -gstabs生成stabs格式的调试信息
+ -nostdinc不在标准系统目录中搜索头文件,只在-I指定的目录中搜索
+ -fno-stack-protector禁用堆栈保护
+ -o指定输出文件名

***bootblock模块***  

生成bin/bootblock的代码如下：
```
$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)
```
　　可以看到它依赖于bootfiles对应的obj(.o文件)和sign对应的目标文件(bin/sign)  
　　**bootfiles**为boot文件夹下以CTYPE(.S .c)为扩展名的文件编译成的目标文件，包括bootasm.o和bootmain.o  
采用gcc编译，命令
```
gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
```
这里的参数在之前都已经解释过了。  

　　**sign**转化为目标则是bin/sign，通过gcc由sign.c编译而成
```
gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
```
这里新增的参数为
+ -O2 对代码进行优化

　　解决了依赖文件的问题后，就可以查看bootblock的生成了。这里的命令有多条，下面逐一解释。  
1.首先编译生成bootblock.o。这里编译时执行的实际命令如下：
```
ld -m elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
```
这里
+ -N 把text和data节设置为可读写  
+ -e start 把start作为程序的开始执行点  
+ -Ttext 0x7C00 指定.text代码段的位置为0x7C00  

2.objdump命令把bootblock.o反汇编重定向到bootblock.asm中（这里没有用到）  
```
objdump -S obj/bootblock.o > obj/bootblock.asm
```
+ -S 输出C源代码和反汇编出来的指令对照的格式  

3.objcopy命令把bootblock.o转化成bootblock.out二进制格式文件。  
```
objcopy -S -O binary obj/bootblock.o obj/bootblock.out
```
+ -S 不从源文件拷贝符号信息和重写位信息  
+ -O binary 输出文件为二进制格式  

4.调用之前生成的sign工具，将bootblock.out作为输入，bootblock作为输出(稍后可以看到，这里是构建了一个符合规范的硬盘主引导扇区)。
```
bin/sign obj/bootblock.out bin/bootblock
```
####2####
分析sign.c文件的结构：  
　　首先通过fread读入文件，并要求该文件的大小不超过510字节，然后开辟一个512字节大小的空间，在第31行和第32行将最后两个字节填充成0x55和0xAA写入输出文件中，因此得到符合规范的硬盘主引导扇区的特征是有512个字节且最后两个字节为0x55和0xAA。  
##练习二##
*注：这里的调试命令参考了答案和视频中的内容*
####1####
将Makefile的debug部分修改如下：
```
debug: $(UCOREIMG)
    $(V)$(TERMINAL) -e "$(QEMU) -S -s -d in_asm -D $(BINDIR)/q.log -parallel stdio -hda $< -serial null"
    $(V)sleep 2
    $(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
```
　　这里`-D bin/q.log`是将qemu的汇编指令保存在q.log文件中，使用`make debug`运行gdb调试，结束后打开bin/q.log可以看到qemu执行的指令信息，可以看到BIOS的执行过程。
####2####
修改gdb执行的指令文件（tools/gdbinit),在0x7c00处设置断点（b *0x7c00),然后用x指令显示当前的后5条指令：
```
file bin/kernel
target remote :1234
set architecture i8086
b *0x7c00
continue
x /5i $pc
```
执行`make debug`可以看到显示如下：
> 
Breakpoint 1, 0x00007c00 in ?? ()
=> 0x7c00:      cli    
   0x7c01:      cld    
   0x7c02:      xor    %ax,%ax
   0x7c04:      mov    %ax,%ds
   0x7c06:      mov    %ax,%es
(gdb) Quit
(gdb)  

和bootasm.S里的start函数比较发现完全符合，在0x7c00处的断点正常。
####3####
　　在`make debug`执行的时候可通过`si`指令单步执行机器指令，通过`x`指令查看实际执行的代码。
也可在qemu的q.log文件中查找执行的代码如下：
```
IN: 
0x00007c00:  cli    

----------------
IN: 
0x00007c00:  cli    

----------------
IN: 
0x00007c01:  cld    
0x00007c02:  xor    %ax,%ax
0x00007c04:  mov    %ax,%ds
0x00007c06:  mov    %ax,%es
0x00007c08:  mov    %ax,%ss

----------------
IN: 
0x00007c0a:  in     $0x64,%al

----------------
IN: 
0x00007c0c:  test   $0x2,%al
0x00007c0e:  jne    0x7c0a

----------------
IN: 
0x00007c10:  mov    $0xd1,%al
0x00007c12:  out    %al,$0x64
0x00007c14:  in     $0x64,%al
0x00007c16:  test   $0x2,%al
0x00007c18:  jne    0x7c14

----------------
IN: 
0x00007c1a:  mov    $0xdf,%al
0x00007c1c:  out    %al,$0x60
0x00007c1e:  lgdtw  0x7c6c
0x00007c23:  mov    %cr0,%eax
0x00007c26:  or     $0x1,%eax
0x00007c2a:  mov    %eax,%cr0

----------------
IN: 
0x00007c2d:  ljmp   $0x8,$0x7c32

----------------
IN: 
0x00007c32:  mov    $0x10,%ax
0x00007c36:  mov    %eax,%ds

----------------
IN: 
0x00007c38:  mov    %eax,%es

----------------
IN: 
0x00007c3a:  mov    %eax,%fs
0x00007c3c:  mov    %eax,%gs
0x00007c3e:  mov    %eax,%ss

----------------
IN: 
0x00007c40:  mov    $0x0,%ebp

----------------
IN: 
0x00007c45:  mov    $0x7c00,%esp
0x00007c4a:  call   0x7cd1

----------------
IN: 
0x00007cd1:  push   %ebp
0x00007cd2:  mov    %esp,%ebp
0x00007cd4:  push   %edi
0x00007cd5:  push   %esi
0x00007cd6:  push   %ebx
0x00007cd7:  mov    $0x1,%ebx
0x00007cdc:  sub    $0x1c,%esp
0x00007cdf:  lea    0x7f(%ebx),%eax
0x00007ce2:  mov    %ebx,%edx
0x00007ce4:  shl    $0x9,%eax
0x00007ce7:  inc    %ebx
0x00007ce8:  call   0x7c72

----------------
```
与bootasm.S和bootblock.asm比较，发现实现执行的代码是有对应的地址的，而在bootasm.S中没有对应的实际地址。另外，在bootasm.S中汇编指令的后缀（w、b）等都没有了，实际执行的指令和是相同的。  
####4####
　　这里选用练习五里编写的idt_init函数处作为断点进行测试。  
　　使用命令`b idt_init`设置断点，并通过`c`来执行程序，发现程序停止在该函数入口处，结果如下：  
> (gdb) b idt_init  
> Breakpoint 2 at 0x1017ff: file kern/trap/trap.c, line 36.  
> (gdb) c  
> Continuing.  
>   
> Breakpoint 2, idt_init () at kern/trap/trap.c:36  

然后通过`x /5i $pc`查看接下来的五条指令，结果如下：  
> (gdb) x /5i $pc  
> => 0x1017ff <idt_init>: push   %bp  
>    0x101800 <idt_init+1>:       mov    %sp,%bp  
>    0x101802 <idt_init+3>:       sub    $0x10,%sp  
>    0x101805 <idt_init+6>:       movw   $0x0,-0x4(%di)  
>    0x10180a <idt_init+11>:      add    %al,(%bx,%si)  

可以看出，这正是调用函数时的汇编指令，也是idt_init向下执行的位置，测试正常。  

##练习三##
　　具体过程体现在lab1的boot/bootasm.S文件中，它完成了从CPU开始运行、设置A20地址线、切换到保护模式
直到调用bootmain主函数的过程。代码分析如下：
```
开始的时候段寄存器cs为0，指令寄存器ip为0x7c00，这是开始执行指令的位置。
.globl start
start:
.code16                                             # 这里设置一些标记
    cli                                             # 禁止中断
    cld                                             # 清除方向标志
    # 把ds、es、ss段寄存器置0
    xorw %ax, %ax                                   
    movw %ax, %ds                                   
    movw %ax, %es                                   
    movw %ax, %ss                                   

    # 开启A20地址线，因为在8086只支持20位地址线时如果提供21位地址那么会自动取余回滚到从0开始，但是
    # 在实模式下，80286之后的芯片在访问21位的地址时为了和之前的版本兼容，就将第21位（从0开始的20）置0，
    # 以和8086保持兼容性。但是在进入保护模式后，我们需要访问连续的地址空间，如果此时A20一直是0，会影响我
    # 们对地址空间的使用，因此必须将A20（也就是8042键盘控制器输出端口0x64的第2位）置1来开启它。
seta20.1:
    inb $0x64, %al                                  # 等待直到输入缓冲区中无数据
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 发送向8042写数据的指令
    outb %al, $0x64
seta20.2:
    inb $0x64, %al                                  # 等待直到输入缓冲区中无数据
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 将0xdf=11011111写入0x64，它的第2位为1，
    outb %al, $0x60                                 # 即将A20开启成功

    # 载入GDT表，并设置CR0寄存器的最低位为1（CR0_PE_ON的值为0x1），开启保护模式
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
    # 跳转到protcseg处，这时的段地址为$PROT_MODE_CSEG为保护模式下的代码段，因此用ljmp
    ljmp $PROT_MODE_CSEG, $protcseg
.code32                                             # 保护模式下的32位代码
protcseg:
    # 设置各个段寄存器的值
    movw $PROT_MODE_DSEG, %ax 
    movw %ax, %ds 
    movw %ax, %es 
    movw %ax, %fs 
    movw %ax, %gs 
    movw %ax, %ss 

    # 建立栈指针，跳转到bootmain主函数进行下一步的处理
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain
```
##练习四##
主要内容在bootmain.c里面，其中bootmain函数是bootloader的入口
```
void
bootmain(void) {
    // 首先读取ELF文件的头部信息
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // 判断ELF是否有效
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // 从每一段的头部信息中找到文件被加载的位置并通过readseg读取加载
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // 执行入口处的代码
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```
　　其中用到的工具函数readseg(va, count, offset)可以读取kernel从offset开始count个字节的内容到地址va里:
```
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // 把非整个扇区的偏移减去
    va -= offset % SECTSIZE;

    // 计算出初始扇区号
    uint32_t secno = (offset / SECTSIZE) + 1;

    // 通过readsect函数读取各扇区的信息
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```
　　readsect(dst, secno)函数实现了把secno扇区的内容读取到dst地址处的功能：  
```
static void
readsect(void *dst, uint32_t secno) {
    // 等待硬盘准备好
    waitdisk();

    outb(0x1F2, 1);                         // 读取扇区的数目为1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0); //发送扇区号信息
    outb(0x1F7, 0x20);                      // 发送读取扇区的命令

    // 等待硬盘准备好
    waitdisk();

    // 读取扇区
    insl(0x1F0, dst, SECTSIZE / 4);
}

```
　　以上对代码的分析可以回答练习中的两个问题。



##练习五##
####1编码过程####
根据注释中的提示可以得到如下代码：
```
    uint32_t ebp = read_ebp();                  //通过read_ebp和read_eip获得ebp、eip两个寄存器
    uint32_t eip = read_eip();                  //的值，他们的值用来追踪函数调用栈
    int i;
    for (i=0; i<STACKFRAME_DEPTH; i++) {        //循环STACKFRAME_DEPTH次输出
        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
        uint32_t* arg = (uint32_t*)ebp+2;       //函数参数在ebp+2处，因为ebp+1处是返回地址
        cprintf("args: 0x%08x 0x%08x 0x%08x 0x%08x\n", arg[0], arg[1], arg[2], arg[3]);
        print_debuginfo(eip-1);                 //输出函数信息
        eip = *((uint32_t*)ebp+1);              //ebp+1处是返回地址，也就是下一轮迭代的eip
        ebp = *(uint32_t *)ebp;                 //ebp处指的是上一层函数的ebp处。注意这两条语句顺序不能颠倒
        if (ebp == 0) break;                    //如果ebp为0，证明已经回溯到了最外层，下面再输出就无意义了
    }
```
####2结果####
输出如下：
```
ebp:0x00007b08 eip:0x001009a7 args: 0x00010094 0x00000000 0x00007b38 0x00100092
    kern/debug/kdebug.c:306: print_stackframe+22
ebp:0x00007b18 eip:0x00100c95 args: 0x00000000 0x00000000 0x00000000 0x00007b88
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b38 eip:0x00100092 args: 0x00000000 0x00007b60 0xffff0000 0x00007b64
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b58 eip:0x001000bb args: 0x00000000 0xffff0000 0x00007b84 0x00000029
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b78 eip:0x001000d9 args: 0x00000000 0x00100000 0xffff0000 0x0000001d
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007b98 eip:0x001000fe args: 0x0010347c 0x00103460 0x0000130a 0x00000000
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007bc8 eip:0x00100055 args: 0x00000000 0x00000000 0x00000000 0x00010094
    kern/init/init.c:28: kern_init+84
ebp:0x00007bf8 eip:0x00007d68 args: 0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d67 --
```
　　和文档中结出的结果类似，也和从kern_init开始的调用过程（从grade_backtrace->grade_backtrace0->grade_backtrace1->grade_backtrace2->mon_backtrace->print_stackframe)相同，结果正确。
####3解释####
　　对结果中最后一行的解释：可以看到最后一行ebp的值为0x7bf8。根据代码的内容，再下一个ebp就是0，也就是最开始的初始化的堆栈的位置（bootmain.S中将ebp设为0，然后call bootmain）。由此可见，这里最后一行就是bootmain所在处。
由于在call bootmain之前先交esp栈顶指针设置为了start所在的0x7c00，那么在call bootmain时先将返回地址压栈，再将old ebp压栈，所以当前的ebp应为0x7bf8。

##练习六##
####1####
中断向量表(IDT)定义在trap.c中的idt变量中，idt的类型为gatedesc,查看gatedesc的定义为：
```
struct gatedesc {
    unsigned gd_off_15_0 : 16;        // low 16 bits of offset in segment
    unsigned gd_ss : 16;            // segment selector
    unsigned gd_args : 5;            // # args, 0 for interrupt/trap gates
    unsigned gd_rsv1 : 3;            // reserved(should be zero I guess)
    unsigned gd_type : 4;            // type(STS_{TG,IG32,TG32})
    unsigned gd_s : 1;                // must be 0 (system)
    unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
    unsigned gd_p : 1;                // Present
    unsigned gd_off_31_16 : 16;        // high bits of offset in segment
};
```
这里16+16+5+3+4+1+2+1+16=64 bit=8 B，因此一个表项占8个字节。
其中第2、3字节为段选择子，第0-1字节为偏移的第16位，第6-7字节为偏移的高16位，通过这些信息可以得到处理代码的入口。

####2####
代码如下：
```
    //声明使用中断服务例程的位置表
    extern uintptr_t __vectors[];
    int i;
    for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
        //使用SETGATE宏，将IDT中的表项设为中断、特权级为内核态权限，设置ISR地址
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    //切换到内核态的特权级为用户态权限，challenge1中需要使用
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
    //加载idt
    lidt(&idt_pd);
}
```
####3####
实现思路：  
　　在trap_dispatch函数中，首先ticks全局变量加1，然后判断是否到达需要输出的条件（即ticks == TICK_NUM），
如果满足，则调用print_ticks()输出，并将ticks置0，等待下一次输出。
