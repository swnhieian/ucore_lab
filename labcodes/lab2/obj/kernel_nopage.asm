
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 e3 5c 00 00       	call   105d39 <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 e0 5e 10 00 	movl   $0x105ee0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 fc 5e 10 00 	movl   $0x105efc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 bc 41 00 00       	call   104240 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 fe 17 00 00       	call   10188c <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 01 5f 10 00 	movl   $0x105f01,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 0f 5f 10 00 	movl   $0x105f0f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 1d 5f 10 00 	movl   $0x105f1d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 2b 5f 10 00 	movl   $0x105f2b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 39 5f 10 00 	movl   $0x105f39,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 48 5f 10 00 	movl   $0x105f48,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 68 5f 10 00 	movl   $0x105f68,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 87 5f 10 00 	movl   $0x105f87,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 1b 52 00 00       	call   105552 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 8c 5f 10 00    	movl   $0x105f8c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 8c 5f 10 00 	movl   $0x105f8c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 b8 71 10 00 	movl   $0x1071b8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 e8 1c 11 00 	movl   $0x111ce8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec e9 1c 11 00 	movl   $0x111ce9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 40 47 11 00 	movl   $0x114740,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 c1 54 00 00       	call   105bad <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 96 5f 10 00 	movl   $0x105f96,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 af 5f 10 00 	movl   $0x105faf,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 c2 5e 10 	movl   $0x105ec2,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 c7 5f 10 00 	movl   $0x105fc7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 df 5f 10 00 	movl   $0x105fdf,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 f7 5f 10 00 	movl   $0x105ff7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 10 60 10 00 	movl   $0x106010,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 3a 60 10 00 	movl   $0x10603a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	53                   	push   %ebx
  1009be:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c1:	89 e8                	mov    %ebp,%eax
  1009c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	      uint32_t ebp = read_ebp();
  1009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		  uint32_t eip = read_eip();
  1009cc:	e8 d8 ff ff ff       	call   1009a9 <read_eip>
  1009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  int i;
		  for (i=0; i<STACKFRAME_DEPTH; i++) {
  1009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009db:	e9 89 00 00 00       	jmp    100a69 <print_stackframe+0xaf>
		     cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ee:	c7 04 24 68 60 10 00 	movl   $0x106068,(%esp)
  1009f5:	e8 42 f9 ff ff       	call   10033c <cprintf>
		     uint32_t* arg = (uint32_t*)ebp+2;
  1009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fd:	83 c0 08             	add    $0x8,%eax
  100a00:	89 45 e8             	mov    %eax,-0x18(%ebp)
		     cprintf("args: 0x%08x 0x%08x 0x%08x 0x%08x\n", arg[0], arg[1], arg[2], arg[3]);
  100a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a06:	83 c0 0c             	add    $0xc,%eax
  100a09:	8b 18                	mov    (%eax),%ebx
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	83 c0 08             	add    $0x8,%eax
  100a11:	8b 08                	mov    (%eax),%ecx
  100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a16:	83 c0 04             	add    $0x4,%eax
  100a19:	8b 10                	mov    (%eax),%edx
  100a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1e:	8b 00                	mov    (%eax),%eax
  100a20:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a24:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a28:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a30:	c7 04 24 80 60 10 00 	movl   $0x106080,(%esp)
  100a37:	e8 00 f9 ff ff       	call   10033c <cprintf>
		     print_debuginfo(eip-1);
  100a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a3f:	83 e8 01             	sub    $0x1,%eax
  100a42:	89 04 24             	mov    %eax,(%esp)
  100a45:	e8 bc fe ff ff       	call   100906 <print_debuginfo>
		     eip = *((uint32_t*)ebp+1);
  100a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4d:	83 c0 04             	add    $0x4,%eax
  100a50:	8b 00                	mov    (%eax),%eax
  100a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
		     ebp = *(uint32_t *)ebp;
  100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a58:	8b 00                	mov    (%eax),%eax
  100a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		     if (ebp == 0) break;
  100a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a61:	75 02                	jne    100a65 <print_stackframe+0xab>
  100a63:	eb 0e                	jmp    100a73 <print_stackframe+0xb9>
      *                   the calling funciton's ebp = ss:[ebp]
      */
	      uint32_t ebp = read_ebp();
		  uint32_t eip = read_eip();
		  int i;
		  for (i=0; i<STACKFRAME_DEPTH; i++) {
  100a65:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a69:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a6d:	0f 8e 6d ff ff ff    	jle    1009e0 <print_stackframe+0x26>
		     print_debuginfo(eip-1);
		     eip = *((uint32_t*)ebp+1);
		     ebp = *(uint32_t *)ebp;
		     if (ebp == 0) break;
		  }
}
  100a73:	83 c4 44             	add    $0x44,%esp
  100a76:	5b                   	pop    %ebx
  100a77:	5d                   	pop    %ebp
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 24 61 10 00 	movl   $0x106124,(%esp)
  100ab2:	e8 c3 50 00 00       	call   105b7a <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 29 61 10 00 	movl   $0x106129,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 24 61 10 00 	movl   $0x106124,(%esp)
  100b1f:	e8 56 50 00 00       	call   105b7a <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 52 4f 00 00       	call   105adb <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 47 61 10 00 	movl   $0x106147,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 60 61 10 00 	movl   $0x106160,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 30 0e 00 00       	call   101a44 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 ad 61 10 00 	movl   $0x1061ad,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 b1 61 10 00 	movl   $0x1061b1,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 ba 61 10 00 	movl   $0x1061ba,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 d6 61 10 00 	movl   $0x1061d6,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 d8 61 10 00 	movl   $0x1061d8,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 d6 61 10 00 	movl   $0x1061d6,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 f6 61 10 00 	movl   $0x1061f6,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 7e 4b 00 00       	call   105d78 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 11 62 10 00 	movl   $0x106211,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 1d 62 10 00 	movl   $0x10621d,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 40 62 10 00 	movl   $0x106240,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10188a:	c9                   	leave  
  10188b:	c3                   	ret    

0010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10188c:	55                   	push   %ebp
  10188d:	89 e5                	mov    %esp,%ebp
  10188f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	      extern uintptr_t __vectors[];
		  int i;
		  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
  101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101899:	e9 c3 00 00 00       	jmp    101961 <idt_init+0xd5>
		      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a1:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a8:	89 c2                	mov    %eax,%edx
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b4:	00 
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018bf:	00 08 00 
  1018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c5:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cc:	00 
  1018cd:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d0:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e1:	00 
  1018e2:	83 e2 1f             	and    $0x1f,%edx
  1018e5:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f6:	00 
  1018f7:	83 e2 f0             	and    $0xfffffff0,%edx
  1018fa:	83 ca 0e             	or     $0xe,%edx
  1018fd:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 ef             	and    $0xffffffef,%edx
  101912:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 9f             	and    $0xffffff9f,%edx
  101927:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101938:	00 
  101939:	83 ca 80             	or     $0xffffff80,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10194d:	c1 e8 10             	shr    $0x10,%eax
  101950:	89 c2                	mov    %eax,%edx
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10195c:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	      extern uintptr_t __vectors[];
		  int i;
		  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
  10195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101964:	3d ff 00 00 00       	cmp    $0xff,%eax
  101969:	0f 86 2f ff ff ff    	jbe    10189e <idt_init+0x12>
		      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		  }
		  SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10196f:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101974:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10197a:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101981:	08 00 
  101983:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10198a:	83 e0 e0             	and    $0xffffffe0,%eax
  10198d:	a2 8c 84 11 00       	mov    %al,0x11848c
  101992:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101999:	83 e0 1f             	and    $0x1f,%eax
  10199c:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019a1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019a8:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ab:	83 c8 0e             	or     $0xe,%eax
  1019ae:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019b3:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ba:	83 e0 ef             	and    $0xffffffef,%eax
  1019bd:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c9:	83 c8 60             	or     $0x60,%eax
  1019cc:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d8:	83 c8 80             	or     $0xffffff80,%eax
  1019db:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e0:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019e5:	c1 e8 10             	shr    $0x10,%eax
  1019e8:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019ee:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f8:	0f 01 18             	lidtl  (%eax)
		  lidt(&idt_pd);
}
  1019fb:	c9                   	leave  
  1019fc:	c3                   	ret    

001019fd <trapname>:

static const char *
trapname(int trapno) {
  1019fd:	55                   	push   %ebp
  1019fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a00:	8b 45 08             	mov    0x8(%ebp),%eax
  101a03:	83 f8 13             	cmp    $0x13,%eax
  101a06:	77 0c                	ja     101a14 <trapname+0x17>
        return excnames[trapno];
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	8b 04 85 a0 65 10 00 	mov    0x1065a0(,%eax,4),%eax
  101a12:	eb 18                	jmp    101a2c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a14:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a18:	7e 0d                	jle    101a27 <trapname+0x2a>
  101a1a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1e:	7f 07                	jg     101a27 <trapname+0x2a>
        return "Hardware Interrupt";
  101a20:	b8 4a 62 10 00       	mov    $0x10624a,%eax
  101a25:	eb 05                	jmp    101a2c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a27:	b8 5d 62 10 00       	mov    $0x10625d,%eax
}
  101a2c:	5d                   	pop    %ebp
  101a2d:	c3                   	ret    

00101a2e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2e:	55                   	push   %ebp
  101a2f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a38:	66 83 f8 08          	cmp    $0x8,%ax
  101a3c:	0f 94 c0             	sete   %al
  101a3f:	0f b6 c0             	movzbl %al,%eax
}
  101a42:	5d                   	pop    %ebp
  101a43:	c3                   	ret    

00101a44 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a44:	55                   	push   %ebp
  101a45:	89 e5                	mov    %esp,%ebp
  101a47:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 9e 62 10 00 	movl   $0x10629e,(%esp)
  101a58:	e8 df e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	89 04 24             	mov    %eax,(%esp)
  101a63:	e8 a1 01 00 00       	call   101c09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a6f:	0f b7 c0             	movzwl %ax,%eax
  101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a76:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  101a7d:	e8 ba e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a89:	0f b7 c0             	movzwl %ax,%eax
  101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a90:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  101a97:	e8 a0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa3:	0f b7 c0             	movzwl %ax,%eax
  101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aaa:	c7 04 24 d5 62 10 00 	movl   $0x1062d5,(%esp)
  101ab1:	e8 86 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101abd:	0f b7 c0             	movzwl %ax,%eax
  101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac4:	c7 04 24 e8 62 10 00 	movl   $0x1062e8,(%esp)
  101acb:	e8 6c e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	8b 40 30             	mov    0x30(%eax),%eax
  101ad6:	89 04 24             	mov    %eax,(%esp)
  101ad9:	e8 1f ff ff ff       	call   1019fd <trapname>
  101ade:	8b 55 08             	mov    0x8(%ebp),%edx
  101ae1:	8b 52 30             	mov    0x30(%edx),%edx
  101ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aec:	c7 04 24 fb 62 10 00 	movl   $0x1062fb,(%esp)
  101af3:	e8 44 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 40 34             	mov    0x34(%eax),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 0d 63 10 00 	movl   $0x10630d,(%esp)
  101b09:	e8 2e e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	8b 40 38             	mov    0x38(%eax),%eax
  101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b18:	c7 04 24 1c 63 10 00 	movl   $0x10631c,(%esp)
  101b1f:	e8 18 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  101b39:	e8 fe e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 40             	mov    0x40(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 3e 63 10 00 	movl   $0x10633e,(%esp)
  101b4f:	e8 e8 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b5b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b62:	eb 3e                	jmp    101ba2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b64:	8b 45 08             	mov    0x8(%ebp),%eax
  101b67:	8b 50 40             	mov    0x40(%eax),%edx
  101b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b6d:	21 d0                	and    %edx,%eax
  101b6f:	85 c0                	test   %eax,%eax
  101b71:	74 28                	je     101b9b <print_trapframe+0x157>
  101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b76:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	74 1a                	je     101b9b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b84:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 4d 63 10 00 	movl   $0x10634d,(%esp)
  101b96:	e8 a1 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b9f:	d1 65 f0             	shll   -0x10(%ebp)
  101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba5:	83 f8 17             	cmp    $0x17,%eax
  101ba8:	76 ba                	jbe    101b64 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 40             	mov    0x40(%eax),%eax
  101bb0:	25 00 30 00 00       	and    $0x3000,%eax
  101bb5:	c1 e8 0c             	shr    $0xc,%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 51 63 10 00 	movl   $0x106351,(%esp)
  101bc3:	e8 74 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	89 04 24             	mov    %eax,(%esp)
  101bce:	e8 5b fe ff ff       	call   101a2e <trap_in_kernel>
  101bd3:	85 c0                	test   %eax,%eax
  101bd5:	75 30                	jne    101c07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 44             	mov    0x44(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 5a 63 10 00 	movl   $0x10635a,(%esp)
  101be8:	e8 4f e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf4:	0f b7 c0             	movzwl %ax,%eax
  101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfb:	c7 04 24 69 63 10 00 	movl   $0x106369,(%esp)
  101c02:	e8 35 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c07:	c9                   	leave  
  101c08:	c3                   	ret    

00101c09 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c09:	55                   	push   %ebp
  101c0a:	89 e5                	mov    %esp,%ebp
  101c0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	8b 00                	mov    (%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  101c1f:	e8 18 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c24:	8b 45 08             	mov    0x8(%ebp),%eax
  101c27:	8b 40 04             	mov    0x4(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 8b 63 10 00 	movl   $0x10638b,(%esp)
  101c35:	e8 02 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 08             	mov    0x8(%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 9a 63 10 00 	movl   $0x10639a,(%esp)
  101c4b:	e8 ec e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 0c             	mov    0xc(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 a9 63 10 00 	movl   $0x1063a9,(%esp)
  101c61:	e8 d6 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 10             	mov    0x10(%eax),%eax
  101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c70:	c7 04 24 b8 63 10 00 	movl   $0x1063b8,(%esp)
  101c77:	e8 c0 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	8b 40 14             	mov    0x14(%eax),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 c7 63 10 00 	movl   $0x1063c7,(%esp)
  101c8d:	e8 aa e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 18             	mov    0x18(%eax),%eax
  101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9c:	c7 04 24 d6 63 10 00 	movl   $0x1063d6,(%esp)
  101ca3:	e8 94 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb2:	c7 04 24 e5 63 10 00 	movl   $0x1063e5,(%esp)
  101cb9:	e8 7e e6 ff ff       	call   10033c <cprintf>
}
  101cbe:	c9                   	leave  
  101cbf:	c3                   	ret    

00101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc0:	55                   	push   %ebp
  101cc1:	89 e5                	mov    %esp,%ebp
  101cc3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 30             	mov    0x30(%eax),%eax
  101ccc:	83 f8 2f             	cmp    $0x2f,%eax
  101ccf:	77 1d                	ja     101cee <trap_dispatch+0x2e>
  101cd1:	83 f8 2e             	cmp    $0x2e,%eax
  101cd4:	0f 83 f2 00 00 00    	jae    101dcc <trap_dispatch+0x10c>
  101cda:	83 f8 21             	cmp    $0x21,%eax
  101cdd:	74 73                	je     101d52 <trap_dispatch+0x92>
  101cdf:	83 f8 24             	cmp    $0x24,%eax
  101ce2:	74 48                	je     101d2c <trap_dispatch+0x6c>
  101ce4:	83 f8 20             	cmp    $0x20,%eax
  101ce7:	74 13                	je     101cfc <trap_dispatch+0x3c>
  101ce9:	e9 a6 00 00 00       	jmp    101d94 <trap_dispatch+0xd4>
  101cee:	83 e8 78             	sub    $0x78,%eax
  101cf1:	83 f8 01             	cmp    $0x1,%eax
  101cf4:	0f 87 9a 00 00 00    	ja     101d94 <trap_dispatch+0xd4>
  101cfa:	eb 7c                	jmp    101d78 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101cfc:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d01:	83 c0 01             	add    $0x1,%eax
  101d04:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks == TICK_NUM) {
  101d09:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d0e:	83 f8 64             	cmp    $0x64,%eax
  101d11:	75 14                	jne    101d27 <trap_dispatch+0x67>
            print_ticks();
  101d13:	e8 58 fb ff ff       	call   101870 <print_ticks>
           	ticks = 0;
  101d18:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  101d1f:	00 00 00 
        }
        break;
  101d22:	e9 a6 00 00 00       	jmp    101dcd <trap_dispatch+0x10d>
  101d27:	e9 a1 00 00 00       	jmp    101dcd <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d2c:	e8 03 f9 ff ff       	call   101634 <cons_getc>
  101d31:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d34:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d38:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d44:	c7 04 24 f4 63 10 00 	movl   $0x1063f4,(%esp)
  101d4b:	e8 ec e5 ff ff       	call   10033c <cprintf>
        break;
  101d50:	eb 7b                	jmp    101dcd <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d52:	e8 dd f8 ff ff       	call   101634 <cons_getc>
  101d57:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d5a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d5e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d62:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6a:	c7 04 24 06 64 10 00 	movl   $0x106406,(%esp)
  101d71:	e8 c6 e5 ff ff       	call   10033c <cprintf>
        break;
  101d76:	eb 55                	jmp    101dcd <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d78:	c7 44 24 08 15 64 10 	movl   $0x106415,0x8(%esp)
  101d7f:	00 
  101d80:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101d87:	00 
  101d88:	c7 04 24 25 64 10 00 	movl   $0x106425,(%esp)
  101d8f:	e8 32 ef ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d94:	8b 45 08             	mov    0x8(%ebp),%eax
  101d97:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d9b:	0f b7 c0             	movzwl %ax,%eax
  101d9e:	83 e0 03             	and    $0x3,%eax
  101da1:	85 c0                	test   %eax,%eax
  101da3:	75 28                	jne    101dcd <trap_dispatch+0x10d>
            print_trapframe(tf);
  101da5:	8b 45 08             	mov    0x8(%ebp),%eax
  101da8:	89 04 24             	mov    %eax,(%esp)
  101dab:	e8 94 fc ff ff       	call   101a44 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101db0:	c7 44 24 08 36 64 10 	movl   $0x106436,0x8(%esp)
  101db7:	00 
  101db8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101dbf:	00 
  101dc0:	c7 04 24 25 64 10 00 	movl   $0x106425,(%esp)
  101dc7:	e8 fa ee ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dcc:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101dcd:	c9                   	leave  
  101dce:	c3                   	ret    

00101dcf <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101dcf:	55                   	push   %ebp
  101dd0:	89 e5                	mov    %esp,%ebp
  101dd2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd8:	89 04 24             	mov    %eax,(%esp)
  101ddb:	e8 e0 fe ff ff       	call   101cc0 <trap_dispatch>
}
  101de0:	c9                   	leave  
  101de1:	c3                   	ret    

00101de2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101de2:	1e                   	push   %ds
    pushl %es
  101de3:	06                   	push   %es
    pushl %fs
  101de4:	0f a0                	push   %fs
    pushl %gs
  101de6:	0f a8                	push   %gs
    pushal
  101de8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101de9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101dee:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101df0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101df2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101df3:	e8 d7 ff ff ff       	call   101dcf <trap>

    # pop the pushed stack pointer
    popl %esp
  101df8:	5c                   	pop    %esp

00101df9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101df9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dfa:	0f a9                	pop    %gs
    popl %fs
  101dfc:	0f a1                	pop    %fs
    popl %es
  101dfe:	07                   	pop    %es
    popl %ds
  101dff:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e00:	83 c4 08             	add    $0x8,%esp
    iret
  101e03:	cf                   	iret   

00101e04 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e04:	6a 00                	push   $0x0
  pushl $0
  101e06:	6a 00                	push   $0x0
  jmp __alltraps
  101e08:	e9 d5 ff ff ff       	jmp    101de2 <__alltraps>

00101e0d <vector1>:
.globl vector1
vector1:
  pushl $0
  101e0d:	6a 00                	push   $0x0
  pushl $1
  101e0f:	6a 01                	push   $0x1
  jmp __alltraps
  101e11:	e9 cc ff ff ff       	jmp    101de2 <__alltraps>

00101e16 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $2
  101e18:	6a 02                	push   $0x2
  jmp __alltraps
  101e1a:	e9 c3 ff ff ff       	jmp    101de2 <__alltraps>

00101e1f <vector3>:
.globl vector3
vector3:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $3
  101e21:	6a 03                	push   $0x3
  jmp __alltraps
  101e23:	e9 ba ff ff ff       	jmp    101de2 <__alltraps>

00101e28 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e28:	6a 00                	push   $0x0
  pushl $4
  101e2a:	6a 04                	push   $0x4
  jmp __alltraps
  101e2c:	e9 b1 ff ff ff       	jmp    101de2 <__alltraps>

00101e31 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $5
  101e33:	6a 05                	push   $0x5
  jmp __alltraps
  101e35:	e9 a8 ff ff ff       	jmp    101de2 <__alltraps>

00101e3a <vector6>:
.globl vector6
vector6:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $6
  101e3c:	6a 06                	push   $0x6
  jmp __alltraps
  101e3e:	e9 9f ff ff ff       	jmp    101de2 <__alltraps>

00101e43 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $7
  101e45:	6a 07                	push   $0x7
  jmp __alltraps
  101e47:	e9 96 ff ff ff       	jmp    101de2 <__alltraps>

00101e4c <vector8>:
.globl vector8
vector8:
  pushl $8
  101e4c:	6a 08                	push   $0x8
  jmp __alltraps
  101e4e:	e9 8f ff ff ff       	jmp    101de2 <__alltraps>

00101e53 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e53:	6a 09                	push   $0x9
  jmp __alltraps
  101e55:	e9 88 ff ff ff       	jmp    101de2 <__alltraps>

00101e5a <vector10>:
.globl vector10
vector10:
  pushl $10
  101e5a:	6a 0a                	push   $0xa
  jmp __alltraps
  101e5c:	e9 81 ff ff ff       	jmp    101de2 <__alltraps>

00101e61 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e61:	6a 0b                	push   $0xb
  jmp __alltraps
  101e63:	e9 7a ff ff ff       	jmp    101de2 <__alltraps>

00101e68 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e68:	6a 0c                	push   $0xc
  jmp __alltraps
  101e6a:	e9 73 ff ff ff       	jmp    101de2 <__alltraps>

00101e6f <vector13>:
.globl vector13
vector13:
  pushl $13
  101e6f:	6a 0d                	push   $0xd
  jmp __alltraps
  101e71:	e9 6c ff ff ff       	jmp    101de2 <__alltraps>

00101e76 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e76:	6a 0e                	push   $0xe
  jmp __alltraps
  101e78:	e9 65 ff ff ff       	jmp    101de2 <__alltraps>

00101e7d <vector15>:
.globl vector15
vector15:
  pushl $0
  101e7d:	6a 00                	push   $0x0
  pushl $15
  101e7f:	6a 0f                	push   $0xf
  jmp __alltraps
  101e81:	e9 5c ff ff ff       	jmp    101de2 <__alltraps>

00101e86 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e86:	6a 00                	push   $0x0
  pushl $16
  101e88:	6a 10                	push   $0x10
  jmp __alltraps
  101e8a:	e9 53 ff ff ff       	jmp    101de2 <__alltraps>

00101e8f <vector17>:
.globl vector17
vector17:
  pushl $17
  101e8f:	6a 11                	push   $0x11
  jmp __alltraps
  101e91:	e9 4c ff ff ff       	jmp    101de2 <__alltraps>

00101e96 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $18
  101e98:	6a 12                	push   $0x12
  jmp __alltraps
  101e9a:	e9 43 ff ff ff       	jmp    101de2 <__alltraps>

00101e9f <vector19>:
.globl vector19
vector19:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $19
  101ea1:	6a 13                	push   $0x13
  jmp __alltraps
  101ea3:	e9 3a ff ff ff       	jmp    101de2 <__alltraps>

00101ea8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $20
  101eaa:	6a 14                	push   $0x14
  jmp __alltraps
  101eac:	e9 31 ff ff ff       	jmp    101de2 <__alltraps>

00101eb1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $21
  101eb3:	6a 15                	push   $0x15
  jmp __alltraps
  101eb5:	e9 28 ff ff ff       	jmp    101de2 <__alltraps>

00101eba <vector22>:
.globl vector22
vector22:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $22
  101ebc:	6a 16                	push   $0x16
  jmp __alltraps
  101ebe:	e9 1f ff ff ff       	jmp    101de2 <__alltraps>

00101ec3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $23
  101ec5:	6a 17                	push   $0x17
  jmp __alltraps
  101ec7:	e9 16 ff ff ff       	jmp    101de2 <__alltraps>

00101ecc <vector24>:
.globl vector24
vector24:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $24
  101ece:	6a 18                	push   $0x18
  jmp __alltraps
  101ed0:	e9 0d ff ff ff       	jmp    101de2 <__alltraps>

00101ed5 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $25
  101ed7:	6a 19                	push   $0x19
  jmp __alltraps
  101ed9:	e9 04 ff ff ff       	jmp    101de2 <__alltraps>

00101ede <vector26>:
.globl vector26
vector26:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $26
  101ee0:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ee2:	e9 fb fe ff ff       	jmp    101de2 <__alltraps>

00101ee7 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $27
  101ee9:	6a 1b                	push   $0x1b
  jmp __alltraps
  101eeb:	e9 f2 fe ff ff       	jmp    101de2 <__alltraps>

00101ef0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $28
  101ef2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ef4:	e9 e9 fe ff ff       	jmp    101de2 <__alltraps>

00101ef9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $29
  101efb:	6a 1d                	push   $0x1d
  jmp __alltraps
  101efd:	e9 e0 fe ff ff       	jmp    101de2 <__alltraps>

00101f02 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $30
  101f04:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f06:	e9 d7 fe ff ff       	jmp    101de2 <__alltraps>

00101f0b <vector31>:
.globl vector31
vector31:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $31
  101f0d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f0f:	e9 ce fe ff ff       	jmp    101de2 <__alltraps>

00101f14 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $32
  101f16:	6a 20                	push   $0x20
  jmp __alltraps
  101f18:	e9 c5 fe ff ff       	jmp    101de2 <__alltraps>

00101f1d <vector33>:
.globl vector33
vector33:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $33
  101f1f:	6a 21                	push   $0x21
  jmp __alltraps
  101f21:	e9 bc fe ff ff       	jmp    101de2 <__alltraps>

00101f26 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $34
  101f28:	6a 22                	push   $0x22
  jmp __alltraps
  101f2a:	e9 b3 fe ff ff       	jmp    101de2 <__alltraps>

00101f2f <vector35>:
.globl vector35
vector35:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $35
  101f31:	6a 23                	push   $0x23
  jmp __alltraps
  101f33:	e9 aa fe ff ff       	jmp    101de2 <__alltraps>

00101f38 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $36
  101f3a:	6a 24                	push   $0x24
  jmp __alltraps
  101f3c:	e9 a1 fe ff ff       	jmp    101de2 <__alltraps>

00101f41 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $37
  101f43:	6a 25                	push   $0x25
  jmp __alltraps
  101f45:	e9 98 fe ff ff       	jmp    101de2 <__alltraps>

00101f4a <vector38>:
.globl vector38
vector38:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $38
  101f4c:	6a 26                	push   $0x26
  jmp __alltraps
  101f4e:	e9 8f fe ff ff       	jmp    101de2 <__alltraps>

00101f53 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $39
  101f55:	6a 27                	push   $0x27
  jmp __alltraps
  101f57:	e9 86 fe ff ff       	jmp    101de2 <__alltraps>

00101f5c <vector40>:
.globl vector40
vector40:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $40
  101f5e:	6a 28                	push   $0x28
  jmp __alltraps
  101f60:	e9 7d fe ff ff       	jmp    101de2 <__alltraps>

00101f65 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $41
  101f67:	6a 29                	push   $0x29
  jmp __alltraps
  101f69:	e9 74 fe ff ff       	jmp    101de2 <__alltraps>

00101f6e <vector42>:
.globl vector42
vector42:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $42
  101f70:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f72:	e9 6b fe ff ff       	jmp    101de2 <__alltraps>

00101f77 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $43
  101f79:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f7b:	e9 62 fe ff ff       	jmp    101de2 <__alltraps>

00101f80 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $44
  101f82:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f84:	e9 59 fe ff ff       	jmp    101de2 <__alltraps>

00101f89 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $45
  101f8b:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f8d:	e9 50 fe ff ff       	jmp    101de2 <__alltraps>

00101f92 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $46
  101f94:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f96:	e9 47 fe ff ff       	jmp    101de2 <__alltraps>

00101f9b <vector47>:
.globl vector47
vector47:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $47
  101f9d:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f9f:	e9 3e fe ff ff       	jmp    101de2 <__alltraps>

00101fa4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $48
  101fa6:	6a 30                	push   $0x30
  jmp __alltraps
  101fa8:	e9 35 fe ff ff       	jmp    101de2 <__alltraps>

00101fad <vector49>:
.globl vector49
vector49:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $49
  101faf:	6a 31                	push   $0x31
  jmp __alltraps
  101fb1:	e9 2c fe ff ff       	jmp    101de2 <__alltraps>

00101fb6 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $50
  101fb8:	6a 32                	push   $0x32
  jmp __alltraps
  101fba:	e9 23 fe ff ff       	jmp    101de2 <__alltraps>

00101fbf <vector51>:
.globl vector51
vector51:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $51
  101fc1:	6a 33                	push   $0x33
  jmp __alltraps
  101fc3:	e9 1a fe ff ff       	jmp    101de2 <__alltraps>

00101fc8 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $52
  101fca:	6a 34                	push   $0x34
  jmp __alltraps
  101fcc:	e9 11 fe ff ff       	jmp    101de2 <__alltraps>

00101fd1 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $53
  101fd3:	6a 35                	push   $0x35
  jmp __alltraps
  101fd5:	e9 08 fe ff ff       	jmp    101de2 <__alltraps>

00101fda <vector54>:
.globl vector54
vector54:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $54
  101fdc:	6a 36                	push   $0x36
  jmp __alltraps
  101fde:	e9 ff fd ff ff       	jmp    101de2 <__alltraps>

00101fe3 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $55
  101fe5:	6a 37                	push   $0x37
  jmp __alltraps
  101fe7:	e9 f6 fd ff ff       	jmp    101de2 <__alltraps>

00101fec <vector56>:
.globl vector56
vector56:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $56
  101fee:	6a 38                	push   $0x38
  jmp __alltraps
  101ff0:	e9 ed fd ff ff       	jmp    101de2 <__alltraps>

00101ff5 <vector57>:
.globl vector57
vector57:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $57
  101ff7:	6a 39                	push   $0x39
  jmp __alltraps
  101ff9:	e9 e4 fd ff ff       	jmp    101de2 <__alltraps>

00101ffe <vector58>:
.globl vector58
vector58:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $58
  102000:	6a 3a                	push   $0x3a
  jmp __alltraps
  102002:	e9 db fd ff ff       	jmp    101de2 <__alltraps>

00102007 <vector59>:
.globl vector59
vector59:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $59
  102009:	6a 3b                	push   $0x3b
  jmp __alltraps
  10200b:	e9 d2 fd ff ff       	jmp    101de2 <__alltraps>

00102010 <vector60>:
.globl vector60
vector60:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $60
  102012:	6a 3c                	push   $0x3c
  jmp __alltraps
  102014:	e9 c9 fd ff ff       	jmp    101de2 <__alltraps>

00102019 <vector61>:
.globl vector61
vector61:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $61
  10201b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10201d:	e9 c0 fd ff ff       	jmp    101de2 <__alltraps>

00102022 <vector62>:
.globl vector62
vector62:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $62
  102024:	6a 3e                	push   $0x3e
  jmp __alltraps
  102026:	e9 b7 fd ff ff       	jmp    101de2 <__alltraps>

0010202b <vector63>:
.globl vector63
vector63:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $63
  10202d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10202f:	e9 ae fd ff ff       	jmp    101de2 <__alltraps>

00102034 <vector64>:
.globl vector64
vector64:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $64
  102036:	6a 40                	push   $0x40
  jmp __alltraps
  102038:	e9 a5 fd ff ff       	jmp    101de2 <__alltraps>

0010203d <vector65>:
.globl vector65
vector65:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $65
  10203f:	6a 41                	push   $0x41
  jmp __alltraps
  102041:	e9 9c fd ff ff       	jmp    101de2 <__alltraps>

00102046 <vector66>:
.globl vector66
vector66:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $66
  102048:	6a 42                	push   $0x42
  jmp __alltraps
  10204a:	e9 93 fd ff ff       	jmp    101de2 <__alltraps>

0010204f <vector67>:
.globl vector67
vector67:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $67
  102051:	6a 43                	push   $0x43
  jmp __alltraps
  102053:	e9 8a fd ff ff       	jmp    101de2 <__alltraps>

00102058 <vector68>:
.globl vector68
vector68:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $68
  10205a:	6a 44                	push   $0x44
  jmp __alltraps
  10205c:	e9 81 fd ff ff       	jmp    101de2 <__alltraps>

00102061 <vector69>:
.globl vector69
vector69:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $69
  102063:	6a 45                	push   $0x45
  jmp __alltraps
  102065:	e9 78 fd ff ff       	jmp    101de2 <__alltraps>

0010206a <vector70>:
.globl vector70
vector70:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $70
  10206c:	6a 46                	push   $0x46
  jmp __alltraps
  10206e:	e9 6f fd ff ff       	jmp    101de2 <__alltraps>

00102073 <vector71>:
.globl vector71
vector71:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $71
  102075:	6a 47                	push   $0x47
  jmp __alltraps
  102077:	e9 66 fd ff ff       	jmp    101de2 <__alltraps>

0010207c <vector72>:
.globl vector72
vector72:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $72
  10207e:	6a 48                	push   $0x48
  jmp __alltraps
  102080:	e9 5d fd ff ff       	jmp    101de2 <__alltraps>

00102085 <vector73>:
.globl vector73
vector73:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $73
  102087:	6a 49                	push   $0x49
  jmp __alltraps
  102089:	e9 54 fd ff ff       	jmp    101de2 <__alltraps>

0010208e <vector74>:
.globl vector74
vector74:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $74
  102090:	6a 4a                	push   $0x4a
  jmp __alltraps
  102092:	e9 4b fd ff ff       	jmp    101de2 <__alltraps>

00102097 <vector75>:
.globl vector75
vector75:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $75
  102099:	6a 4b                	push   $0x4b
  jmp __alltraps
  10209b:	e9 42 fd ff ff       	jmp    101de2 <__alltraps>

001020a0 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $76
  1020a2:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020a4:	e9 39 fd ff ff       	jmp    101de2 <__alltraps>

001020a9 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $77
  1020ab:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020ad:	e9 30 fd ff ff       	jmp    101de2 <__alltraps>

001020b2 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $78
  1020b4:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020b6:	e9 27 fd ff ff       	jmp    101de2 <__alltraps>

001020bb <vector79>:
.globl vector79
vector79:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $79
  1020bd:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020bf:	e9 1e fd ff ff       	jmp    101de2 <__alltraps>

001020c4 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $80
  1020c6:	6a 50                	push   $0x50
  jmp __alltraps
  1020c8:	e9 15 fd ff ff       	jmp    101de2 <__alltraps>

001020cd <vector81>:
.globl vector81
vector81:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $81
  1020cf:	6a 51                	push   $0x51
  jmp __alltraps
  1020d1:	e9 0c fd ff ff       	jmp    101de2 <__alltraps>

001020d6 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $82
  1020d8:	6a 52                	push   $0x52
  jmp __alltraps
  1020da:	e9 03 fd ff ff       	jmp    101de2 <__alltraps>

001020df <vector83>:
.globl vector83
vector83:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $83
  1020e1:	6a 53                	push   $0x53
  jmp __alltraps
  1020e3:	e9 fa fc ff ff       	jmp    101de2 <__alltraps>

001020e8 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $84
  1020ea:	6a 54                	push   $0x54
  jmp __alltraps
  1020ec:	e9 f1 fc ff ff       	jmp    101de2 <__alltraps>

001020f1 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $85
  1020f3:	6a 55                	push   $0x55
  jmp __alltraps
  1020f5:	e9 e8 fc ff ff       	jmp    101de2 <__alltraps>

001020fa <vector86>:
.globl vector86
vector86:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $86
  1020fc:	6a 56                	push   $0x56
  jmp __alltraps
  1020fe:	e9 df fc ff ff       	jmp    101de2 <__alltraps>

00102103 <vector87>:
.globl vector87
vector87:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $87
  102105:	6a 57                	push   $0x57
  jmp __alltraps
  102107:	e9 d6 fc ff ff       	jmp    101de2 <__alltraps>

0010210c <vector88>:
.globl vector88
vector88:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $88
  10210e:	6a 58                	push   $0x58
  jmp __alltraps
  102110:	e9 cd fc ff ff       	jmp    101de2 <__alltraps>

00102115 <vector89>:
.globl vector89
vector89:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $89
  102117:	6a 59                	push   $0x59
  jmp __alltraps
  102119:	e9 c4 fc ff ff       	jmp    101de2 <__alltraps>

0010211e <vector90>:
.globl vector90
vector90:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $90
  102120:	6a 5a                	push   $0x5a
  jmp __alltraps
  102122:	e9 bb fc ff ff       	jmp    101de2 <__alltraps>

00102127 <vector91>:
.globl vector91
vector91:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $91
  102129:	6a 5b                	push   $0x5b
  jmp __alltraps
  10212b:	e9 b2 fc ff ff       	jmp    101de2 <__alltraps>

00102130 <vector92>:
.globl vector92
vector92:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $92
  102132:	6a 5c                	push   $0x5c
  jmp __alltraps
  102134:	e9 a9 fc ff ff       	jmp    101de2 <__alltraps>

00102139 <vector93>:
.globl vector93
vector93:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $93
  10213b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10213d:	e9 a0 fc ff ff       	jmp    101de2 <__alltraps>

00102142 <vector94>:
.globl vector94
vector94:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $94
  102144:	6a 5e                	push   $0x5e
  jmp __alltraps
  102146:	e9 97 fc ff ff       	jmp    101de2 <__alltraps>

0010214b <vector95>:
.globl vector95
vector95:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $95
  10214d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10214f:	e9 8e fc ff ff       	jmp    101de2 <__alltraps>

00102154 <vector96>:
.globl vector96
vector96:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $96
  102156:	6a 60                	push   $0x60
  jmp __alltraps
  102158:	e9 85 fc ff ff       	jmp    101de2 <__alltraps>

0010215d <vector97>:
.globl vector97
vector97:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $97
  10215f:	6a 61                	push   $0x61
  jmp __alltraps
  102161:	e9 7c fc ff ff       	jmp    101de2 <__alltraps>

00102166 <vector98>:
.globl vector98
vector98:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $98
  102168:	6a 62                	push   $0x62
  jmp __alltraps
  10216a:	e9 73 fc ff ff       	jmp    101de2 <__alltraps>

0010216f <vector99>:
.globl vector99
vector99:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $99
  102171:	6a 63                	push   $0x63
  jmp __alltraps
  102173:	e9 6a fc ff ff       	jmp    101de2 <__alltraps>

00102178 <vector100>:
.globl vector100
vector100:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $100
  10217a:	6a 64                	push   $0x64
  jmp __alltraps
  10217c:	e9 61 fc ff ff       	jmp    101de2 <__alltraps>

00102181 <vector101>:
.globl vector101
vector101:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $101
  102183:	6a 65                	push   $0x65
  jmp __alltraps
  102185:	e9 58 fc ff ff       	jmp    101de2 <__alltraps>

0010218a <vector102>:
.globl vector102
vector102:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $102
  10218c:	6a 66                	push   $0x66
  jmp __alltraps
  10218e:	e9 4f fc ff ff       	jmp    101de2 <__alltraps>

00102193 <vector103>:
.globl vector103
vector103:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $103
  102195:	6a 67                	push   $0x67
  jmp __alltraps
  102197:	e9 46 fc ff ff       	jmp    101de2 <__alltraps>

0010219c <vector104>:
.globl vector104
vector104:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $104
  10219e:	6a 68                	push   $0x68
  jmp __alltraps
  1021a0:	e9 3d fc ff ff       	jmp    101de2 <__alltraps>

001021a5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $105
  1021a7:	6a 69                	push   $0x69
  jmp __alltraps
  1021a9:	e9 34 fc ff ff       	jmp    101de2 <__alltraps>

001021ae <vector106>:
.globl vector106
vector106:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $106
  1021b0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021b2:	e9 2b fc ff ff       	jmp    101de2 <__alltraps>

001021b7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $107
  1021b9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021bb:	e9 22 fc ff ff       	jmp    101de2 <__alltraps>

001021c0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $108
  1021c2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021c4:	e9 19 fc ff ff       	jmp    101de2 <__alltraps>

001021c9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $109
  1021cb:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021cd:	e9 10 fc ff ff       	jmp    101de2 <__alltraps>

001021d2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $110
  1021d4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021d6:	e9 07 fc ff ff       	jmp    101de2 <__alltraps>

001021db <vector111>:
.globl vector111
vector111:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $111
  1021dd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021df:	e9 fe fb ff ff       	jmp    101de2 <__alltraps>

001021e4 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $112
  1021e6:	6a 70                	push   $0x70
  jmp __alltraps
  1021e8:	e9 f5 fb ff ff       	jmp    101de2 <__alltraps>

001021ed <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $113
  1021ef:	6a 71                	push   $0x71
  jmp __alltraps
  1021f1:	e9 ec fb ff ff       	jmp    101de2 <__alltraps>

001021f6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $114
  1021f8:	6a 72                	push   $0x72
  jmp __alltraps
  1021fa:	e9 e3 fb ff ff       	jmp    101de2 <__alltraps>

001021ff <vector115>:
.globl vector115
vector115:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $115
  102201:	6a 73                	push   $0x73
  jmp __alltraps
  102203:	e9 da fb ff ff       	jmp    101de2 <__alltraps>

00102208 <vector116>:
.globl vector116
vector116:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $116
  10220a:	6a 74                	push   $0x74
  jmp __alltraps
  10220c:	e9 d1 fb ff ff       	jmp    101de2 <__alltraps>

00102211 <vector117>:
.globl vector117
vector117:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $117
  102213:	6a 75                	push   $0x75
  jmp __alltraps
  102215:	e9 c8 fb ff ff       	jmp    101de2 <__alltraps>

0010221a <vector118>:
.globl vector118
vector118:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $118
  10221c:	6a 76                	push   $0x76
  jmp __alltraps
  10221e:	e9 bf fb ff ff       	jmp    101de2 <__alltraps>

00102223 <vector119>:
.globl vector119
vector119:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $119
  102225:	6a 77                	push   $0x77
  jmp __alltraps
  102227:	e9 b6 fb ff ff       	jmp    101de2 <__alltraps>

0010222c <vector120>:
.globl vector120
vector120:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $120
  10222e:	6a 78                	push   $0x78
  jmp __alltraps
  102230:	e9 ad fb ff ff       	jmp    101de2 <__alltraps>

00102235 <vector121>:
.globl vector121
vector121:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $121
  102237:	6a 79                	push   $0x79
  jmp __alltraps
  102239:	e9 a4 fb ff ff       	jmp    101de2 <__alltraps>

0010223e <vector122>:
.globl vector122
vector122:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $122
  102240:	6a 7a                	push   $0x7a
  jmp __alltraps
  102242:	e9 9b fb ff ff       	jmp    101de2 <__alltraps>

00102247 <vector123>:
.globl vector123
vector123:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $123
  102249:	6a 7b                	push   $0x7b
  jmp __alltraps
  10224b:	e9 92 fb ff ff       	jmp    101de2 <__alltraps>

00102250 <vector124>:
.globl vector124
vector124:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $124
  102252:	6a 7c                	push   $0x7c
  jmp __alltraps
  102254:	e9 89 fb ff ff       	jmp    101de2 <__alltraps>

00102259 <vector125>:
.globl vector125
vector125:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $125
  10225b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10225d:	e9 80 fb ff ff       	jmp    101de2 <__alltraps>

00102262 <vector126>:
.globl vector126
vector126:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $126
  102264:	6a 7e                	push   $0x7e
  jmp __alltraps
  102266:	e9 77 fb ff ff       	jmp    101de2 <__alltraps>

0010226b <vector127>:
.globl vector127
vector127:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $127
  10226d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10226f:	e9 6e fb ff ff       	jmp    101de2 <__alltraps>

00102274 <vector128>:
.globl vector128
vector128:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $128
  102276:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10227b:	e9 62 fb ff ff       	jmp    101de2 <__alltraps>

00102280 <vector129>:
.globl vector129
vector129:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $129
  102282:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102287:	e9 56 fb ff ff       	jmp    101de2 <__alltraps>

0010228c <vector130>:
.globl vector130
vector130:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $130
  10228e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102293:	e9 4a fb ff ff       	jmp    101de2 <__alltraps>

00102298 <vector131>:
.globl vector131
vector131:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $131
  10229a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10229f:	e9 3e fb ff ff       	jmp    101de2 <__alltraps>

001022a4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $132
  1022a6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022ab:	e9 32 fb ff ff       	jmp    101de2 <__alltraps>

001022b0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $133
  1022b2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022b7:	e9 26 fb ff ff       	jmp    101de2 <__alltraps>

001022bc <vector134>:
.globl vector134
vector134:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $134
  1022be:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022c3:	e9 1a fb ff ff       	jmp    101de2 <__alltraps>

001022c8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $135
  1022ca:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022cf:	e9 0e fb ff ff       	jmp    101de2 <__alltraps>

001022d4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $136
  1022d6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022db:	e9 02 fb ff ff       	jmp    101de2 <__alltraps>

001022e0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $137
  1022e2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022e7:	e9 f6 fa ff ff       	jmp    101de2 <__alltraps>

001022ec <vector138>:
.globl vector138
vector138:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $138
  1022ee:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022f3:	e9 ea fa ff ff       	jmp    101de2 <__alltraps>

001022f8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $139
  1022fa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022ff:	e9 de fa ff ff       	jmp    101de2 <__alltraps>

00102304 <vector140>:
.globl vector140
vector140:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $140
  102306:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10230b:	e9 d2 fa ff ff       	jmp    101de2 <__alltraps>

00102310 <vector141>:
.globl vector141
vector141:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $141
  102312:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102317:	e9 c6 fa ff ff       	jmp    101de2 <__alltraps>

0010231c <vector142>:
.globl vector142
vector142:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $142
  10231e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102323:	e9 ba fa ff ff       	jmp    101de2 <__alltraps>

00102328 <vector143>:
.globl vector143
vector143:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $143
  10232a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10232f:	e9 ae fa ff ff       	jmp    101de2 <__alltraps>

00102334 <vector144>:
.globl vector144
vector144:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $144
  102336:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10233b:	e9 a2 fa ff ff       	jmp    101de2 <__alltraps>

00102340 <vector145>:
.globl vector145
vector145:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $145
  102342:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102347:	e9 96 fa ff ff       	jmp    101de2 <__alltraps>

0010234c <vector146>:
.globl vector146
vector146:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $146
  10234e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102353:	e9 8a fa ff ff       	jmp    101de2 <__alltraps>

00102358 <vector147>:
.globl vector147
vector147:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $147
  10235a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10235f:	e9 7e fa ff ff       	jmp    101de2 <__alltraps>

00102364 <vector148>:
.globl vector148
vector148:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $148
  102366:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10236b:	e9 72 fa ff ff       	jmp    101de2 <__alltraps>

00102370 <vector149>:
.globl vector149
vector149:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $149
  102372:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102377:	e9 66 fa ff ff       	jmp    101de2 <__alltraps>

0010237c <vector150>:
.globl vector150
vector150:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $150
  10237e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102383:	e9 5a fa ff ff       	jmp    101de2 <__alltraps>

00102388 <vector151>:
.globl vector151
vector151:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $151
  10238a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10238f:	e9 4e fa ff ff       	jmp    101de2 <__alltraps>

00102394 <vector152>:
.globl vector152
vector152:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $152
  102396:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10239b:	e9 42 fa ff ff       	jmp    101de2 <__alltraps>

001023a0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $153
  1023a2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023a7:	e9 36 fa ff ff       	jmp    101de2 <__alltraps>

001023ac <vector154>:
.globl vector154
vector154:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $154
  1023ae:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023b3:	e9 2a fa ff ff       	jmp    101de2 <__alltraps>

001023b8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $155
  1023ba:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023bf:	e9 1e fa ff ff       	jmp    101de2 <__alltraps>

001023c4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $156
  1023c6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023cb:	e9 12 fa ff ff       	jmp    101de2 <__alltraps>

001023d0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $157
  1023d2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023d7:	e9 06 fa ff ff       	jmp    101de2 <__alltraps>

001023dc <vector158>:
.globl vector158
vector158:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $158
  1023de:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023e3:	e9 fa f9 ff ff       	jmp    101de2 <__alltraps>

001023e8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $159
  1023ea:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023ef:	e9 ee f9 ff ff       	jmp    101de2 <__alltraps>

001023f4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $160
  1023f6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023fb:	e9 e2 f9 ff ff       	jmp    101de2 <__alltraps>

00102400 <vector161>:
.globl vector161
vector161:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $161
  102402:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102407:	e9 d6 f9 ff ff       	jmp    101de2 <__alltraps>

0010240c <vector162>:
.globl vector162
vector162:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $162
  10240e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102413:	e9 ca f9 ff ff       	jmp    101de2 <__alltraps>

00102418 <vector163>:
.globl vector163
vector163:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $163
  10241a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10241f:	e9 be f9 ff ff       	jmp    101de2 <__alltraps>

00102424 <vector164>:
.globl vector164
vector164:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $164
  102426:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10242b:	e9 b2 f9 ff ff       	jmp    101de2 <__alltraps>

00102430 <vector165>:
.globl vector165
vector165:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $165
  102432:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102437:	e9 a6 f9 ff ff       	jmp    101de2 <__alltraps>

0010243c <vector166>:
.globl vector166
vector166:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $166
  10243e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102443:	e9 9a f9 ff ff       	jmp    101de2 <__alltraps>

00102448 <vector167>:
.globl vector167
vector167:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $167
  10244a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10244f:	e9 8e f9 ff ff       	jmp    101de2 <__alltraps>

00102454 <vector168>:
.globl vector168
vector168:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $168
  102456:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10245b:	e9 82 f9 ff ff       	jmp    101de2 <__alltraps>

00102460 <vector169>:
.globl vector169
vector169:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $169
  102462:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102467:	e9 76 f9 ff ff       	jmp    101de2 <__alltraps>

0010246c <vector170>:
.globl vector170
vector170:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $170
  10246e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102473:	e9 6a f9 ff ff       	jmp    101de2 <__alltraps>

00102478 <vector171>:
.globl vector171
vector171:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $171
  10247a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10247f:	e9 5e f9 ff ff       	jmp    101de2 <__alltraps>

00102484 <vector172>:
.globl vector172
vector172:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $172
  102486:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10248b:	e9 52 f9 ff ff       	jmp    101de2 <__alltraps>

00102490 <vector173>:
.globl vector173
vector173:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $173
  102492:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102497:	e9 46 f9 ff ff       	jmp    101de2 <__alltraps>

0010249c <vector174>:
.globl vector174
vector174:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $174
  10249e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024a3:	e9 3a f9 ff ff       	jmp    101de2 <__alltraps>

001024a8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $175
  1024aa:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024af:	e9 2e f9 ff ff       	jmp    101de2 <__alltraps>

001024b4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $176
  1024b6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024bb:	e9 22 f9 ff ff       	jmp    101de2 <__alltraps>

001024c0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $177
  1024c2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024c7:	e9 16 f9 ff ff       	jmp    101de2 <__alltraps>

001024cc <vector178>:
.globl vector178
vector178:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $178
  1024ce:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024d3:	e9 0a f9 ff ff       	jmp    101de2 <__alltraps>

001024d8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $179
  1024da:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024df:	e9 fe f8 ff ff       	jmp    101de2 <__alltraps>

001024e4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $180
  1024e6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024eb:	e9 f2 f8 ff ff       	jmp    101de2 <__alltraps>

001024f0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $181
  1024f2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024f7:	e9 e6 f8 ff ff       	jmp    101de2 <__alltraps>

001024fc <vector182>:
.globl vector182
vector182:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $182
  1024fe:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102503:	e9 da f8 ff ff       	jmp    101de2 <__alltraps>

00102508 <vector183>:
.globl vector183
vector183:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $183
  10250a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10250f:	e9 ce f8 ff ff       	jmp    101de2 <__alltraps>

00102514 <vector184>:
.globl vector184
vector184:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $184
  102516:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10251b:	e9 c2 f8 ff ff       	jmp    101de2 <__alltraps>

00102520 <vector185>:
.globl vector185
vector185:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $185
  102522:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102527:	e9 b6 f8 ff ff       	jmp    101de2 <__alltraps>

0010252c <vector186>:
.globl vector186
vector186:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $186
  10252e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102533:	e9 aa f8 ff ff       	jmp    101de2 <__alltraps>

00102538 <vector187>:
.globl vector187
vector187:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $187
  10253a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10253f:	e9 9e f8 ff ff       	jmp    101de2 <__alltraps>

00102544 <vector188>:
.globl vector188
vector188:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $188
  102546:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10254b:	e9 92 f8 ff ff       	jmp    101de2 <__alltraps>

00102550 <vector189>:
.globl vector189
vector189:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $189
  102552:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102557:	e9 86 f8 ff ff       	jmp    101de2 <__alltraps>

0010255c <vector190>:
.globl vector190
vector190:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $190
  10255e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102563:	e9 7a f8 ff ff       	jmp    101de2 <__alltraps>

00102568 <vector191>:
.globl vector191
vector191:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $191
  10256a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10256f:	e9 6e f8 ff ff       	jmp    101de2 <__alltraps>

00102574 <vector192>:
.globl vector192
vector192:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $192
  102576:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10257b:	e9 62 f8 ff ff       	jmp    101de2 <__alltraps>

00102580 <vector193>:
.globl vector193
vector193:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $193
  102582:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102587:	e9 56 f8 ff ff       	jmp    101de2 <__alltraps>

0010258c <vector194>:
.globl vector194
vector194:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $194
  10258e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102593:	e9 4a f8 ff ff       	jmp    101de2 <__alltraps>

00102598 <vector195>:
.globl vector195
vector195:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $195
  10259a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10259f:	e9 3e f8 ff ff       	jmp    101de2 <__alltraps>

001025a4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $196
  1025a6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025ab:	e9 32 f8 ff ff       	jmp    101de2 <__alltraps>

001025b0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $197
  1025b2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025b7:	e9 26 f8 ff ff       	jmp    101de2 <__alltraps>

001025bc <vector198>:
.globl vector198
vector198:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $198
  1025be:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025c3:	e9 1a f8 ff ff       	jmp    101de2 <__alltraps>

001025c8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $199
  1025ca:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025cf:	e9 0e f8 ff ff       	jmp    101de2 <__alltraps>

001025d4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $200
  1025d6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025db:	e9 02 f8 ff ff       	jmp    101de2 <__alltraps>

001025e0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $201
  1025e2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025e7:	e9 f6 f7 ff ff       	jmp    101de2 <__alltraps>

001025ec <vector202>:
.globl vector202
vector202:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $202
  1025ee:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025f3:	e9 ea f7 ff ff       	jmp    101de2 <__alltraps>

001025f8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $203
  1025fa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025ff:	e9 de f7 ff ff       	jmp    101de2 <__alltraps>

00102604 <vector204>:
.globl vector204
vector204:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $204
  102606:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10260b:	e9 d2 f7 ff ff       	jmp    101de2 <__alltraps>

00102610 <vector205>:
.globl vector205
vector205:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $205
  102612:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102617:	e9 c6 f7 ff ff       	jmp    101de2 <__alltraps>

0010261c <vector206>:
.globl vector206
vector206:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $206
  10261e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102623:	e9 ba f7 ff ff       	jmp    101de2 <__alltraps>

00102628 <vector207>:
.globl vector207
vector207:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $207
  10262a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10262f:	e9 ae f7 ff ff       	jmp    101de2 <__alltraps>

00102634 <vector208>:
.globl vector208
vector208:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $208
  102636:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10263b:	e9 a2 f7 ff ff       	jmp    101de2 <__alltraps>

00102640 <vector209>:
.globl vector209
vector209:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $209
  102642:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102647:	e9 96 f7 ff ff       	jmp    101de2 <__alltraps>

0010264c <vector210>:
.globl vector210
vector210:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $210
  10264e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102653:	e9 8a f7 ff ff       	jmp    101de2 <__alltraps>

00102658 <vector211>:
.globl vector211
vector211:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $211
  10265a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10265f:	e9 7e f7 ff ff       	jmp    101de2 <__alltraps>

00102664 <vector212>:
.globl vector212
vector212:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $212
  102666:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10266b:	e9 72 f7 ff ff       	jmp    101de2 <__alltraps>

00102670 <vector213>:
.globl vector213
vector213:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $213
  102672:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102677:	e9 66 f7 ff ff       	jmp    101de2 <__alltraps>

0010267c <vector214>:
.globl vector214
vector214:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $214
  10267e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102683:	e9 5a f7 ff ff       	jmp    101de2 <__alltraps>

00102688 <vector215>:
.globl vector215
vector215:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $215
  10268a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10268f:	e9 4e f7 ff ff       	jmp    101de2 <__alltraps>

00102694 <vector216>:
.globl vector216
vector216:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $216
  102696:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10269b:	e9 42 f7 ff ff       	jmp    101de2 <__alltraps>

001026a0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $217
  1026a2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026a7:	e9 36 f7 ff ff       	jmp    101de2 <__alltraps>

001026ac <vector218>:
.globl vector218
vector218:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $218
  1026ae:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026b3:	e9 2a f7 ff ff       	jmp    101de2 <__alltraps>

001026b8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $219
  1026ba:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026bf:	e9 1e f7 ff ff       	jmp    101de2 <__alltraps>

001026c4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $220
  1026c6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026cb:	e9 12 f7 ff ff       	jmp    101de2 <__alltraps>

001026d0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $221
  1026d2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026d7:	e9 06 f7 ff ff       	jmp    101de2 <__alltraps>

001026dc <vector222>:
.globl vector222
vector222:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $222
  1026de:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026e3:	e9 fa f6 ff ff       	jmp    101de2 <__alltraps>

001026e8 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $223
  1026ea:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026ef:	e9 ee f6 ff ff       	jmp    101de2 <__alltraps>

001026f4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $224
  1026f6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026fb:	e9 e2 f6 ff ff       	jmp    101de2 <__alltraps>

00102700 <vector225>:
.globl vector225
vector225:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $225
  102702:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102707:	e9 d6 f6 ff ff       	jmp    101de2 <__alltraps>

0010270c <vector226>:
.globl vector226
vector226:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $226
  10270e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102713:	e9 ca f6 ff ff       	jmp    101de2 <__alltraps>

00102718 <vector227>:
.globl vector227
vector227:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $227
  10271a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10271f:	e9 be f6 ff ff       	jmp    101de2 <__alltraps>

00102724 <vector228>:
.globl vector228
vector228:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $228
  102726:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10272b:	e9 b2 f6 ff ff       	jmp    101de2 <__alltraps>

00102730 <vector229>:
.globl vector229
vector229:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $229
  102732:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102737:	e9 a6 f6 ff ff       	jmp    101de2 <__alltraps>

0010273c <vector230>:
.globl vector230
vector230:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $230
  10273e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102743:	e9 9a f6 ff ff       	jmp    101de2 <__alltraps>

00102748 <vector231>:
.globl vector231
vector231:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $231
  10274a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10274f:	e9 8e f6 ff ff       	jmp    101de2 <__alltraps>

00102754 <vector232>:
.globl vector232
vector232:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $232
  102756:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10275b:	e9 82 f6 ff ff       	jmp    101de2 <__alltraps>

00102760 <vector233>:
.globl vector233
vector233:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $233
  102762:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102767:	e9 76 f6 ff ff       	jmp    101de2 <__alltraps>

0010276c <vector234>:
.globl vector234
vector234:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $234
  10276e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102773:	e9 6a f6 ff ff       	jmp    101de2 <__alltraps>

00102778 <vector235>:
.globl vector235
vector235:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $235
  10277a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10277f:	e9 5e f6 ff ff       	jmp    101de2 <__alltraps>

00102784 <vector236>:
.globl vector236
vector236:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $236
  102786:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10278b:	e9 52 f6 ff ff       	jmp    101de2 <__alltraps>

00102790 <vector237>:
.globl vector237
vector237:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $237
  102792:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102797:	e9 46 f6 ff ff       	jmp    101de2 <__alltraps>

0010279c <vector238>:
.globl vector238
vector238:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $238
  10279e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027a3:	e9 3a f6 ff ff       	jmp    101de2 <__alltraps>

001027a8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $239
  1027aa:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027af:	e9 2e f6 ff ff       	jmp    101de2 <__alltraps>

001027b4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $240
  1027b6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027bb:	e9 22 f6 ff ff       	jmp    101de2 <__alltraps>

001027c0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $241
  1027c2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027c7:	e9 16 f6 ff ff       	jmp    101de2 <__alltraps>

001027cc <vector242>:
.globl vector242
vector242:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $242
  1027ce:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027d3:	e9 0a f6 ff ff       	jmp    101de2 <__alltraps>

001027d8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $243
  1027da:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027df:	e9 fe f5 ff ff       	jmp    101de2 <__alltraps>

001027e4 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $244
  1027e6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027eb:	e9 f2 f5 ff ff       	jmp    101de2 <__alltraps>

001027f0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $245
  1027f2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027f7:	e9 e6 f5 ff ff       	jmp    101de2 <__alltraps>

001027fc <vector246>:
.globl vector246
vector246:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $246
  1027fe:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102803:	e9 da f5 ff ff       	jmp    101de2 <__alltraps>

00102808 <vector247>:
.globl vector247
vector247:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $247
  10280a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10280f:	e9 ce f5 ff ff       	jmp    101de2 <__alltraps>

00102814 <vector248>:
.globl vector248
vector248:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $248
  102816:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10281b:	e9 c2 f5 ff ff       	jmp    101de2 <__alltraps>

00102820 <vector249>:
.globl vector249
vector249:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $249
  102822:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102827:	e9 b6 f5 ff ff       	jmp    101de2 <__alltraps>

0010282c <vector250>:
.globl vector250
vector250:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $250
  10282e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102833:	e9 aa f5 ff ff       	jmp    101de2 <__alltraps>

00102838 <vector251>:
.globl vector251
vector251:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $251
  10283a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10283f:	e9 9e f5 ff ff       	jmp    101de2 <__alltraps>

00102844 <vector252>:
.globl vector252
vector252:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $252
  102846:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10284b:	e9 92 f5 ff ff       	jmp    101de2 <__alltraps>

00102850 <vector253>:
.globl vector253
vector253:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $253
  102852:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102857:	e9 86 f5 ff ff       	jmp    101de2 <__alltraps>

0010285c <vector254>:
.globl vector254
vector254:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $254
  10285e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102863:	e9 7a f5 ff ff       	jmp    101de2 <__alltraps>

00102868 <vector255>:
.globl vector255
vector255:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $255
  10286a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10286f:	e9 6e f5 ff ff       	jmp    101de2 <__alltraps>

00102874 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102874:	55                   	push   %ebp
  102875:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102877:	8b 55 08             	mov    0x8(%ebp),%edx
  10287a:	a1 64 89 11 00       	mov    0x118964,%eax
  10287f:	29 c2                	sub    %eax,%edx
  102881:	89 d0                	mov    %edx,%eax
  102883:	c1 f8 02             	sar    $0x2,%eax
  102886:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10288c:	5d                   	pop    %ebp
  10288d:	c3                   	ret    

0010288e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10288e:	55                   	push   %ebp
  10288f:	89 e5                	mov    %esp,%ebp
  102891:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102894:	8b 45 08             	mov    0x8(%ebp),%eax
  102897:	89 04 24             	mov    %eax,(%esp)
  10289a:	e8 d5 ff ff ff       	call   102874 <page2ppn>
  10289f:	c1 e0 0c             	shl    $0xc,%eax
}
  1028a2:	c9                   	leave  
  1028a3:	c3                   	ret    

001028a4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028a4:	55                   	push   %ebp
  1028a5:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028aa:	8b 00                	mov    (%eax),%eax
}
  1028ac:	5d                   	pop    %ebp
  1028ad:	c3                   	ret    

001028ae <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028ae:	55                   	push   %ebp
  1028af:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028b7:	89 10                	mov    %edx,(%eax)
}
  1028b9:	5d                   	pop    %ebp
  1028ba:	c3                   	ret    

001028bb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028bb:	55                   	push   %ebp
  1028bc:	89 e5                	mov    %esp,%ebp
  1028be:	83 ec 10             	sub    $0x10,%esp
  1028c1:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028ce:	89 50 04             	mov    %edx,0x4(%eax)
  1028d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028d4:	8b 50 04             	mov    0x4(%eax),%edx
  1028d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028da:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028dc:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1028e3:	00 00 00 
}
  1028e6:	c9                   	leave  
  1028e7:	c3                   	ret    

001028e8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028e8:	55                   	push   %ebp
  1028e9:	89 e5                	mov    %esp,%ebp
  1028eb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1028ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028f2:	75 24                	jne    102918 <default_init_memmap+0x30>
  1028f4:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  1028fb:	00 
  1028fc:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102903:	00 
  102904:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10290b:	00 
  10290c:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102913:	e8 ae e3 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  102918:	8b 45 08             	mov    0x8(%ebp),%eax
  10291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10291e:	e9 dc 00 00 00       	jmp    1029ff <default_init_memmap+0x117>
        assert(PageReserved(p));
  102923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102926:	83 c0 04             	add    $0x4,%eax
  102929:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102930:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102936:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102939:	0f a3 10             	bt     %edx,(%eax)
  10293c:	19 c0                	sbb    %eax,%eax
  10293e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102941:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102945:	0f 95 c0             	setne  %al
  102948:	0f b6 c0             	movzbl %al,%eax
  10294b:	85 c0                	test   %eax,%eax
  10294d:	75 24                	jne    102973 <default_init_memmap+0x8b>
  10294f:	c7 44 24 0c 21 66 10 	movl   $0x106621,0xc(%esp)
  102956:	00 
  102957:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10295e:	00 
  10295f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102966:	00 
  102967:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10296e:	e8 53 e3 ff ff       	call   100cc6 <__panic>
        p->flags = 0;
  102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  10297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102980:	83 c0 04             	add    $0x4,%eax
  102983:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10298a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10298d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102993:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102999:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  1029a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029a7:	00 
  1029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ab:	89 04 24             	mov    %eax,(%esp)
  1029ae:	e8 fb fe ff ff       	call   1028ae <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  1029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b6:	83 c0 0c             	add    $0xc,%eax
  1029b9:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1029c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029c6:	8b 00                	mov    (%eax),%eax
  1029c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1029cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1029ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029dd:	89 10                	mov    %edx,(%eax)
  1029df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029e2:	8b 10                	mov    (%eax),%edx
  1029e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029e7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029f9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029fb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a02:	89 d0                	mov    %edx,%eax
  102a04:	c1 e0 02             	shl    $0x2,%eax
  102a07:	01 d0                	add    %edx,%eax
  102a09:	c1 e0 02             	shl    $0x2,%eax
  102a0c:	89 c2                	mov    %eax,%edx
  102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a11:	01 d0                	add    %edx,%eax
  102a13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a16:	0f 85 07 ff ff ff    	jne    102923 <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a22:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102a25:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a2e:	01 d0                	add    %edx,%eax
  102a30:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102a35:	c9                   	leave  
  102a36:	c3                   	ret    

00102a37 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a37:	55                   	push   %ebp
  102a38:	89 e5                	mov    %esp,%ebp
  102a3a:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102a3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a41:	75 24                	jne    102a67 <default_alloc_pages+0x30>
  102a43:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  102a4a:	00 
  102a4b:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102a52:	00 
  102a53:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102a5a:	00 
  102a5b:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102a62:	e8 5f e2 ff ff       	call   100cc6 <__panic>
    if (n > nr_free) {
  102a67:	a1 58 89 11 00       	mov    0x118958,%eax
  102a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a6f:	73 0a                	jae    102a7b <default_alloc_pages+0x44>
        return NULL;
  102a71:	b8 00 00 00 00       	mov    $0x0,%eax
  102a76:	e9 0d 01 00 00       	jmp    102b88 <default_alloc_pages+0x151>
    }
    struct Page *page = NULL;
  102a7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *le = &free_list;
  102a82:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
  102a89:	e9 d9 00 00 00       	jmp    102b67 <default_alloc_pages+0x130>
        page = le2page(le, page_link);
  102a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a91:	83 e8 0c             	sub    $0xc,%eax
  102a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (page->property >= n) {
  102a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a9a:	8b 40 08             	mov    0x8(%eax),%eax
  102a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aa0:	0f 82 c1 00 00 00    	jb     102b67 <default_alloc_pages+0x130>
            int i;
            for (i=0; i<n; i++) {
  102aa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102aad:	eb 7c                	jmp    102b2b <default_alloc_pages+0xf4>
                 struct Page* tempp = le2page(le, page_link);
  102aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab2:	83 e8 0c             	sub    $0xc,%eax
  102ab5:	89 45 e8             	mov    %eax,-0x18(%ebp)
                 SetPageReserved(tempp);
  102ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102abb:	83 c0 04             	add    $0x4,%eax
  102abe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102ac8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102acb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ace:	0f ab 10             	bts    %edx,(%eax)
                 ClearPageProperty(tempp);
  102ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ad4:	83 c0 04             	add    $0x4,%eax
  102ad7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102ade:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ae1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ae4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ae7:	0f b3 10             	btr    %edx,(%eax)
  102aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aed:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102af0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102af3:	8b 40 04             	mov    0x4(%eax),%eax
                 temp = list_next(le);
  102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102afc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b02:	8b 40 04             	mov    0x4(%eax),%eax
  102b05:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b08:	8b 12                	mov    (%edx),%edx
  102b0a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102b0d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b13:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b16:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b19:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b1f:	89 10                	mov    %edx,(%eax)
                 list_del(le);
                 le = temp;
  102b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
        page = le2page(le, page_link);
        if (page->property >= n) {
            int i;
            for (i=0; i<n; i++) {
  102b27:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b31:	0f 82 78 ff ff ff    	jb     102aaf <default_alloc_pages+0x78>
                 ClearPageProperty(tempp);
                 temp = list_next(le);
                 list_del(le);
                 le = temp;
            }
            size_t rest = page->property - n;
  102b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b3a:	8b 40 08             	mov    0x8(%eax),%eax
  102b3d:	2b 45 08             	sub    0x8(%ebp),%eax
  102b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
            if (rest > 0) {
  102b43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102b47:	74 0c                	je     102b55 <default_alloc_pages+0x11e>
                (le2page(le, page_link))->property = rest;
  102b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b4c:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b52:	89 42 08             	mov    %eax,0x8(%edx)
            }
            nr_free -= n;
  102b55:	a1 58 89 11 00       	mov    0x118958,%eax
  102b5a:	2b 45 08             	sub    0x8(%ebp),%eax
  102b5d:	a3 58 89 11 00       	mov    %eax,0x118958
            return page;
  102b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b65:	eb 21                	jmp    102b88 <default_alloc_pages+0x151>
  102b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b6a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b70:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
  102b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b76:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102b7d:	0f 85 0b ff ff ff    	jne    102a8e <default_alloc_pages+0x57>
            }
            nr_free -= n;
            return page;
        }
    }
    return NULL;
  102b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b88:	c9                   	leave  
  102b89:	c3                   	ret    

00102b8a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b8a:	55                   	push   %ebp
  102b8b:	89 e5                	mov    %esp,%ebp
  102b8d:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102b90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b94:	75 24                	jne    102bba <default_free_pages+0x30>
  102b96:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  102b9d:	00 
  102b9e:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102ba5:	00 
  102ba6:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  102bad:	00 
  102bae:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102bb5:	e8 0c e1 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  102bba:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = &free_list;
  102bc0:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le=list_next(le)) != &free_list) {
  102bc7:	eb 0d                	jmp    102bd6 <default_free_pages+0x4c>
        if ((le2page(le, page_link)) > base)
  102bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bcc:	83 e8 0c             	sub    $0xc,%eax
  102bcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bd2:	76 02                	jbe    102bd6 <default_free_pages+0x4c>
            break;
  102bd4:	eb 18                	jmp    102bee <default_free_pages+0x64>
  102bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bdf:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;

    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
  102be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102be5:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102bec:	75 db                	jne    102bc9 <default_free_pages+0x3f>
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (p = base; p<base+n; p++) {
  102bee:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bf4:	e9 9a 00 00 00       	jmp    102c93 <default_free_pages+0x109>
        set_page_ref(p, 0);
  102bf9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c00:	00 
  102c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c04:	89 04 24             	mov    %eax,(%esp)
  102c07:	e8 a2 fc ff ff       	call   1028ae <set_page_ref>
        ClearPageReserved(p);
  102c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c0f:	83 c0 04             	add    $0x4,%eax
  102c12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102c22:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);
  102c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c28:	83 c0 04             	add    $0x4,%eax
  102c2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c32:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c3b:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_add_before(le, &(p->page_link));
  102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4b:	8d 50 0c             	lea    0xc(%eax),%edx
  102c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102c54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c5a:	8b 00                	mov    (%eax),%eax
  102c5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c5f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102c62:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102c65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c68:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c71:	89 10                	mov    %edx,(%eax)
  102c73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c76:	8b 10                	mov    (%eax),%edx
  102c78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c7b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c81:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c8a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c8d:	89 10                	mov    %edx,(%eax)
    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (p = base; p<base+n; p++) {
  102c8f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c96:	89 d0                	mov    %edx,%eax
  102c98:	c1 e0 02             	shl    $0x2,%eax
  102c9b:	01 d0                	add    %edx,%eax
  102c9d:	c1 e0 02             	shl    $0x2,%eax
  102ca0:	89 c2                	mov    %eax,%edx
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca5:	01 d0                	add    %edx,%eax
  102ca7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102caa:	0f 87 49 ff ff ff    	ja     102bf9 <default_free_pages+0x6f>
        ClearPageReserved(p);
        SetPageProperty(p);
        p->property = 0;
        list_add_before(le, &(p->page_link));
    }
    base->property = n;
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cb6:	89 50 08             	mov    %edx,0x8(%eax)
    p = le2page(le, page_link);
  102cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cbc:	83 e8 0c             	sub    $0xc,%eax
  102cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (base + n == p) {
  102cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cc5:	89 d0                	mov    %edx,%eax
  102cc7:	c1 e0 02             	shl    $0x2,%eax
  102cca:	01 d0                	add    %edx,%eax
  102ccc:	c1 e0 02             	shl    $0x2,%eax
  102ccf:	89 c2                	mov    %eax,%edx
  102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd4:	01 d0                	add    %edx,%eax
  102cd6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cd9:	75 1e                	jne    102cf9 <default_free_pages+0x16f>
        base->property += p->property;
  102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cde:	8b 50 08             	mov    0x8(%eax),%edx
  102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce4:	8b 40 08             	mov    0x8(%eax),%eax
  102ce7:	01 c2                	add    %eax,%edx
  102ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cec:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
  102cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfc:	83 c0 0c             	add    $0xc,%eax
  102cff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d05:	8b 00                	mov    (%eax),%eax
  102d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if ((le != &free_list) && (le2page(le, page_link)+1==base)) {
  102d0a:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d11:	74 57                	je     102d6a <default_free_pages+0x1e0>
  102d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d16:	83 c0 08             	add    $0x8,%eax
  102d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d1c:	75 4c                	jne    102d6a <default_free_pages+0x1e0>
        while (le != &free_list) {
  102d1e:	eb 41                	jmp    102d61 <default_free_pages+0x1d7>
            p = le2page(le, page_link);
  102d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d23:	83 e8 0c             	sub    $0xc,%eax
  102d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (p->property > 0) {
  102d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d2c:	8b 40 08             	mov    0x8(%eax),%eax
  102d2f:	85 c0                	test   %eax,%eax
  102d31:	74 20                	je     102d53 <default_free_pages+0x1c9>
                p->property += base->property;
  102d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d36:	8b 50 08             	mov    0x8(%eax),%edx
  102d39:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3c:	8b 40 08             	mov    0x8(%eax),%eax
  102d3f:	01 c2                	add    %eax,%edx
  102d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d44:	89 50 08             	mov    %edx,0x8(%eax)
                base->property = 0;
  102d47:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                break;
  102d51:	eb 17                	jmp    102d6a <default_free_pages+0x1e0>
  102d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102d59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d5c:	8b 00                	mov    (%eax),%eax
            }
            le = list_prev(le);
  102d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        base->property += p->property;
        p->property = 0;
    }
    le = list_prev(&(base->page_link));
    if ((le != &free_list) && (le2page(le, page_link)+1==base)) {
        while (le != &free_list) {
  102d61:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d68:	75 b6                	jne    102d20 <default_free_pages+0x196>
                break;
            }
            le = list_prev(le);
        }
    }
    nr_free += n;
  102d6a:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d73:	01 d0                	add    %edx,%eax
  102d75:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102d7a:	c9                   	leave  
  102d7b:	c3                   	ret    

00102d7c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102d7c:	55                   	push   %ebp
  102d7d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102d7f:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102d84:	5d                   	pop    %ebp
  102d85:	c3                   	ret    

00102d86 <basic_check>:

static void
basic_check(void) {
  102d86:	55                   	push   %ebp
  102d87:	89 e5                	mov    %esp,%ebp
  102d89:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102d9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102da6:	e8 85 0e 00 00       	call   103c30 <alloc_pages>
  102dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102db2:	75 24                	jne    102dd8 <basic_check+0x52>
  102db4:	c7 44 24 0c 31 66 10 	movl   $0x106631,0xc(%esp)
  102dbb:	00 
  102dbc:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102dc3:	00 
  102dc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  102dcb:	00 
  102dcc:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102dd3:	e8 ee de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102dd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ddf:	e8 4c 0e 00 00       	call   103c30 <alloc_pages>
  102de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102deb:	75 24                	jne    102e11 <basic_check+0x8b>
  102ded:	c7 44 24 0c 4d 66 10 	movl   $0x10664d,0xc(%esp)
  102df4:	00 
  102df5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102dfc:	00 
  102dfd:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102e04:	00 
  102e05:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102e0c:	e8 b5 de ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e18:	e8 13 0e 00 00       	call   103c30 <alloc_pages>
  102e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102e24:	75 24                	jne    102e4a <basic_check+0xc4>
  102e26:	c7 44 24 0c 69 66 10 	movl   $0x106669,0xc(%esp)
  102e2d:	00 
  102e2e:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102e35:	00 
  102e36:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  102e3d:	00 
  102e3e:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102e45:	e8 7c de ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e50:	74 10                	je     102e62 <basic_check+0xdc>
  102e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e58:	74 08                	je     102e62 <basic_check+0xdc>
  102e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e5d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e60:	75 24                	jne    102e86 <basic_check+0x100>
  102e62:	c7 44 24 0c 88 66 10 	movl   $0x106688,0xc(%esp)
  102e69:	00 
  102e6a:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102e71:	00 
  102e72:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  102e79:	00 
  102e7a:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102e81:	e8 40 de ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e89:	89 04 24             	mov    %eax,(%esp)
  102e8c:	e8 13 fa ff ff       	call   1028a4 <page_ref>
  102e91:	85 c0                	test   %eax,%eax
  102e93:	75 1e                	jne    102eb3 <basic_check+0x12d>
  102e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e98:	89 04 24             	mov    %eax,(%esp)
  102e9b:	e8 04 fa ff ff       	call   1028a4 <page_ref>
  102ea0:	85 c0                	test   %eax,%eax
  102ea2:	75 0f                	jne    102eb3 <basic_check+0x12d>
  102ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea7:	89 04 24             	mov    %eax,(%esp)
  102eaa:	e8 f5 f9 ff ff       	call   1028a4 <page_ref>
  102eaf:	85 c0                	test   %eax,%eax
  102eb1:	74 24                	je     102ed7 <basic_check+0x151>
  102eb3:	c7 44 24 0c ac 66 10 	movl   $0x1066ac,0xc(%esp)
  102eba:	00 
  102ebb:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102ec2:	00 
  102ec3:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  102eca:	00 
  102ecb:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102ed2:	e8 ef dd ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eda:	89 04 24             	mov    %eax,(%esp)
  102edd:	e8 ac f9 ff ff       	call   10288e <page2pa>
  102ee2:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102ee8:	c1 e2 0c             	shl    $0xc,%edx
  102eeb:	39 d0                	cmp    %edx,%eax
  102eed:	72 24                	jb     102f13 <basic_check+0x18d>
  102eef:	c7 44 24 0c e8 66 10 	movl   $0x1066e8,0xc(%esp)
  102ef6:	00 
  102ef7:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102efe:	00 
  102eff:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  102f06:	00 
  102f07:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102f0e:	e8 b3 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f16:	89 04 24             	mov    %eax,(%esp)
  102f19:	e8 70 f9 ff ff       	call   10288e <page2pa>
  102f1e:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f24:	c1 e2 0c             	shl    $0xc,%edx
  102f27:	39 d0                	cmp    %edx,%eax
  102f29:	72 24                	jb     102f4f <basic_check+0x1c9>
  102f2b:	c7 44 24 0c 05 67 10 	movl   $0x106705,0xc(%esp)
  102f32:	00 
  102f33:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102f3a:	00 
  102f3b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  102f42:	00 
  102f43:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102f4a:	e8 77 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f52:	89 04 24             	mov    %eax,(%esp)
  102f55:	e8 34 f9 ff ff       	call   10288e <page2pa>
  102f5a:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f60:	c1 e2 0c             	shl    $0xc,%edx
  102f63:	39 d0                	cmp    %edx,%eax
  102f65:	72 24                	jb     102f8b <basic_check+0x205>
  102f67:	c7 44 24 0c 22 67 10 	movl   $0x106722,0xc(%esp)
  102f6e:	00 
  102f6f:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102f76:	00 
  102f77:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102f7e:	00 
  102f7f:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102f86:	e8 3b dd ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  102f8b:	a1 50 89 11 00       	mov    0x118950,%eax
  102f90:	8b 15 54 89 11 00    	mov    0x118954,%edx
  102f96:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f99:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f9c:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102fa9:	89 50 04             	mov    %edx,0x4(%eax)
  102fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102faf:	8b 50 04             	mov    0x4(%eax),%edx
  102fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fb5:	89 10                	mov    %edx,(%eax)
  102fb7:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fc1:	8b 40 04             	mov    0x4(%eax),%eax
  102fc4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fc7:	0f 94 c0             	sete   %al
  102fca:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102fcd:	85 c0                	test   %eax,%eax
  102fcf:	75 24                	jne    102ff5 <basic_check+0x26f>
  102fd1:	c7 44 24 0c 3f 67 10 	movl   $0x10673f,0xc(%esp)
  102fd8:	00 
  102fd9:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102fe0:	00 
  102fe1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102fe8:	00 
  102fe9:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102ff0:	e8 d1 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  102ff5:	a1 58 89 11 00       	mov    0x118958,%eax
  102ffa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102ffd:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103004:	00 00 00 

    assert(alloc_page() == NULL);
  103007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10300e:	e8 1d 0c 00 00       	call   103c30 <alloc_pages>
  103013:	85 c0                	test   %eax,%eax
  103015:	74 24                	je     10303b <basic_check+0x2b5>
  103017:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  10301e:	00 
  10301f:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103026:	00 
  103027:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  10302e:	00 
  10302f:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103036:	e8 8b dc ff ff       	call   100cc6 <__panic>

    free_page(p0);
  10303b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103042:	00 
  103043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103046:	89 04 24             	mov    %eax,(%esp)
  103049:	e8 1a 0c 00 00       	call   103c68 <free_pages>
    free_page(p1);
  10304e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103055:	00 
  103056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103059:	89 04 24             	mov    %eax,(%esp)
  10305c:	e8 07 0c 00 00       	call   103c68 <free_pages>
    free_page(p2);
  103061:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103068:	00 
  103069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10306c:	89 04 24             	mov    %eax,(%esp)
  10306f:	e8 f4 0b 00 00       	call   103c68 <free_pages>
    assert(nr_free == 3);
  103074:	a1 58 89 11 00       	mov    0x118958,%eax
  103079:	83 f8 03             	cmp    $0x3,%eax
  10307c:	74 24                	je     1030a2 <basic_check+0x31c>
  10307e:	c7 44 24 0c 6b 67 10 	movl   $0x10676b,0xc(%esp)
  103085:	00 
  103086:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10308d:	00 
  10308e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  103095:	00 
  103096:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10309d:	e8 24 dc ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1030a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030a9:	e8 82 0b 00 00       	call   103c30 <alloc_pages>
  1030ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1030b5:	75 24                	jne    1030db <basic_check+0x355>
  1030b7:	c7 44 24 0c 31 66 10 	movl   $0x106631,0xc(%esp)
  1030be:	00 
  1030bf:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1030c6:	00 
  1030c7:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1030ce:	00 
  1030cf:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1030d6:	e8 eb db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030e2:	e8 49 0b 00 00       	call   103c30 <alloc_pages>
  1030e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030ee:	75 24                	jne    103114 <basic_check+0x38e>
  1030f0:	c7 44 24 0c 4d 66 10 	movl   $0x10664d,0xc(%esp)
  1030f7:	00 
  1030f8:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1030ff:	00 
  103100:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  103107:	00 
  103108:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10310f:	e8 b2 db ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10311b:	e8 10 0b 00 00       	call   103c30 <alloc_pages>
  103120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103127:	75 24                	jne    10314d <basic_check+0x3c7>
  103129:	c7 44 24 0c 69 66 10 	movl   $0x106669,0xc(%esp)
  103130:	00 
  103131:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103138:	00 
  103139:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  103140:	00 
  103141:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103148:	e8 79 db ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  10314d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103154:	e8 d7 0a 00 00       	call   103c30 <alloc_pages>
  103159:	85 c0                	test   %eax,%eax
  10315b:	74 24                	je     103181 <basic_check+0x3fb>
  10315d:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103164:	00 
  103165:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10316c:	00 
  10316d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  103174:	00 
  103175:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10317c:	e8 45 db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  103181:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103188:	00 
  103189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10318c:	89 04 24             	mov    %eax,(%esp)
  10318f:	e8 d4 0a 00 00       	call   103c68 <free_pages>
  103194:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10319b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10319e:	8b 40 04             	mov    0x4(%eax),%eax
  1031a1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1031a4:	0f 94 c0             	sete   %al
  1031a7:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1031aa:	85 c0                	test   %eax,%eax
  1031ac:	74 24                	je     1031d2 <basic_check+0x44c>
  1031ae:	c7 44 24 0c 78 67 10 	movl   $0x106778,0xc(%esp)
  1031b5:	00 
  1031b6:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1031bd:	00 
  1031be:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  1031c5:	00 
  1031c6:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1031cd:	e8 f4 da ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1031d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031d9:	e8 52 0a 00 00       	call   103c30 <alloc_pages>
  1031de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031e7:	74 24                	je     10320d <basic_check+0x487>
  1031e9:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  1031f0:	00 
  1031f1:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1031f8:	00 
  1031f9:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  103200:	00 
  103201:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103208:	e8 b9 da ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10320d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103214:	e8 17 0a 00 00       	call   103c30 <alloc_pages>
  103219:	85 c0                	test   %eax,%eax
  10321b:	74 24                	je     103241 <basic_check+0x4bb>
  10321d:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103224:	00 
  103225:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10322c:	00 
  10322d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  103234:	00 
  103235:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10323c:	e8 85 da ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  103241:	a1 58 89 11 00       	mov    0x118958,%eax
  103246:	85 c0                	test   %eax,%eax
  103248:	74 24                	je     10326e <basic_check+0x4e8>
  10324a:	c7 44 24 0c a9 67 10 	movl   $0x1067a9,0xc(%esp)
  103251:	00 
  103252:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103259:	00 
  10325a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103261:	00 
  103262:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103269:	e8 58 da ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  10326e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103271:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103274:	a3 50 89 11 00       	mov    %eax,0x118950
  103279:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103282:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103287:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10328e:	00 
  10328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103292:	89 04 24             	mov    %eax,(%esp)
  103295:	e8 ce 09 00 00       	call   103c68 <free_pages>
    free_page(p1);
  10329a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032a1:	00 
  1032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032a5:	89 04 24             	mov    %eax,(%esp)
  1032a8:	e8 bb 09 00 00       	call   103c68 <free_pages>
    free_page(p2);
  1032ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032b4:	00 
  1032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b8:	89 04 24             	mov    %eax,(%esp)
  1032bb:	e8 a8 09 00 00       	call   103c68 <free_pages>
}
  1032c0:	c9                   	leave  
  1032c1:	c3                   	ret    

001032c2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1032c2:	55                   	push   %ebp
  1032c3:	89 e5                	mov    %esp,%ebp
  1032c5:	53                   	push   %ebx
  1032c6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1032cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1032d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1032da:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1032e1:	eb 6b                	jmp    10334e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032e6:	83 e8 0c             	sub    $0xc,%eax
  1032e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ef:	83 c0 04             	add    $0x4,%eax
  1032f2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1032f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1032fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1032ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103302:	0f a3 10             	bt     %edx,(%eax)
  103305:	19 c0                	sbb    %eax,%eax
  103307:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10330a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10330e:	0f 95 c0             	setne  %al
  103311:	0f b6 c0             	movzbl %al,%eax
  103314:	85 c0                	test   %eax,%eax
  103316:	75 24                	jne    10333c <default_check+0x7a>
  103318:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  10331f:	00 
  103320:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103327:	00 
  103328:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  10332f:	00 
  103330:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103337:	e8 8a d9 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  10333c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103343:	8b 50 08             	mov    0x8(%eax),%edx
  103346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103349:	01 d0                	add    %edx,%eax
  10334b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10334e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103351:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103354:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103357:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10335a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10335d:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103364:	0f 85 79 ff ff ff    	jne    1032e3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10336a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10336d:	e8 28 09 00 00       	call   103c9a <nr_free_pages>
  103372:	39 c3                	cmp    %eax,%ebx
  103374:	74 24                	je     10339a <default_check+0xd8>
  103376:	c7 44 24 0c c6 67 10 	movl   $0x1067c6,0xc(%esp)
  10337d:	00 
  10337e:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103385:	00 
  103386:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10338d:	00 
  10338e:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103395:	e8 2c d9 ff ff       	call   100cc6 <__panic>

    basic_check();
  10339a:	e8 e7 f9 ff ff       	call   102d86 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10339f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1033a6:	e8 85 08 00 00       	call   103c30 <alloc_pages>
  1033ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1033ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033b2:	75 24                	jne    1033d8 <default_check+0x116>
  1033b4:	c7 44 24 0c df 67 10 	movl   $0x1067df,0xc(%esp)
  1033bb:	00 
  1033bc:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1033c3:	00 
  1033c4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1033cb:	00 
  1033cc:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1033d3:	e8 ee d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  1033d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033db:	83 c0 04             	add    $0x4,%eax
  1033de:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1033e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1033eb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1033ee:	0f a3 10             	bt     %edx,(%eax)
  1033f1:	19 c0                	sbb    %eax,%eax
  1033f3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1033f6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1033fa:	0f 95 c0             	setne  %al
  1033fd:	0f b6 c0             	movzbl %al,%eax
  103400:	85 c0                	test   %eax,%eax
  103402:	74 24                	je     103428 <default_check+0x166>
  103404:	c7 44 24 0c ea 67 10 	movl   $0x1067ea,0xc(%esp)
  10340b:	00 
  10340c:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103413:	00 
  103414:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  10341b:	00 
  10341c:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103423:	e8 9e d8 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  103428:	a1 50 89 11 00       	mov    0x118950,%eax
  10342d:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103433:	89 45 80             	mov    %eax,-0x80(%ebp)
  103436:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103439:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103443:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103446:	89 50 04             	mov    %edx,0x4(%eax)
  103449:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10344c:	8b 50 04             	mov    0x4(%eax),%edx
  10344f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103452:	89 10                	mov    %edx,(%eax)
  103454:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10345b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10345e:	8b 40 04             	mov    0x4(%eax),%eax
  103461:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103464:	0f 94 c0             	sete   %al
  103467:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10346a:	85 c0                	test   %eax,%eax
  10346c:	75 24                	jne    103492 <default_check+0x1d0>
  10346e:	c7 44 24 0c 3f 67 10 	movl   $0x10673f,0xc(%esp)
  103475:	00 
  103476:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10347d:	00 
  10347e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103485:	00 
  103486:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10348d:	e8 34 d8 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103492:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103499:	e8 92 07 00 00       	call   103c30 <alloc_pages>
  10349e:	85 c0                	test   %eax,%eax
  1034a0:	74 24                	je     1034c6 <default_check+0x204>
  1034a2:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1034a9:	00 
  1034aa:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1034b1:	00 
  1034b2:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1034b9:	00 
  1034ba:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1034c1:	e8 00 d8 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  1034c6:	a1 58 89 11 00       	mov    0x118958,%eax
  1034cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1034ce:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1034d5:	00 00 00 

    free_pages(p0 + 2, 3);
  1034d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034db:	83 c0 28             	add    $0x28,%eax
  1034de:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1034e5:	00 
  1034e6:	89 04 24             	mov    %eax,(%esp)
  1034e9:	e8 7a 07 00 00       	call   103c68 <free_pages>
    assert(alloc_pages(4) == NULL);
  1034ee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1034f5:	e8 36 07 00 00       	call   103c30 <alloc_pages>
  1034fa:	85 c0                	test   %eax,%eax
  1034fc:	74 24                	je     103522 <default_check+0x260>
  1034fe:	c7 44 24 0c fc 67 10 	movl   $0x1067fc,0xc(%esp)
  103505:	00 
  103506:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10350d:	00 
  10350e:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103515:	00 
  103516:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10351d:	e8 a4 d7 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103525:	83 c0 28             	add    $0x28,%eax
  103528:	83 c0 04             	add    $0x4,%eax
  10352b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103532:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103535:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103538:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10353b:	0f a3 10             	bt     %edx,(%eax)
  10353e:	19 c0                	sbb    %eax,%eax
  103540:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103543:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103547:	0f 95 c0             	setne  %al
  10354a:	0f b6 c0             	movzbl %al,%eax
  10354d:	85 c0                	test   %eax,%eax
  10354f:	74 0e                	je     10355f <default_check+0x29d>
  103551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103554:	83 c0 28             	add    $0x28,%eax
  103557:	8b 40 08             	mov    0x8(%eax),%eax
  10355a:	83 f8 03             	cmp    $0x3,%eax
  10355d:	74 24                	je     103583 <default_check+0x2c1>
  10355f:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  103566:	00 
  103567:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10356e:	00 
  10356f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103576:	00 
  103577:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10357e:	e8 43 d7 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103583:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10358a:	e8 a1 06 00 00       	call   103c30 <alloc_pages>
  10358f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103592:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103596:	75 24                	jne    1035bc <default_check+0x2fa>
  103598:	c7 44 24 0c 40 68 10 	movl   $0x106840,0xc(%esp)
  10359f:	00 
  1035a0:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1035a7:	00 
  1035a8:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1035af:	00 
  1035b0:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1035b7:	e8 0a d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1035bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035c3:	e8 68 06 00 00       	call   103c30 <alloc_pages>
  1035c8:	85 c0                	test   %eax,%eax
  1035ca:	74 24                	je     1035f0 <default_check+0x32e>
  1035cc:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1035d3:	00 
  1035d4:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1035db:	00 
  1035dc:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  1035e3:	00 
  1035e4:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1035eb:	e8 d6 d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  1035f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035f3:	83 c0 28             	add    $0x28,%eax
  1035f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1035f9:	74 24                	je     10361f <default_check+0x35d>
  1035fb:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  103602:	00 
  103603:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10360a:	00 
  10360b:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103612:	00 
  103613:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10361a:	e8 a7 d6 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  10361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103622:	83 c0 14             	add    $0x14,%eax
  103625:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103628:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10362f:	00 
  103630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103633:	89 04 24             	mov    %eax,(%esp)
  103636:	e8 2d 06 00 00       	call   103c68 <free_pages>
    free_pages(p1, 3);
  10363b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103642:	00 
  103643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103646:	89 04 24             	mov    %eax,(%esp)
  103649:	e8 1a 06 00 00       	call   103c68 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103651:	83 c0 04             	add    $0x4,%eax
  103654:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10365b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10365e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103661:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103664:	0f a3 10             	bt     %edx,(%eax)
  103667:	19 c0                	sbb    %eax,%eax
  103669:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10366c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103670:	0f 95 c0             	setne  %al
  103673:	0f b6 c0             	movzbl %al,%eax
  103676:	85 c0                	test   %eax,%eax
  103678:	74 0b                	je     103685 <default_check+0x3c3>
  10367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10367d:	8b 40 08             	mov    0x8(%eax),%eax
  103680:	83 f8 01             	cmp    $0x1,%eax
  103683:	74 24                	je     1036a9 <default_check+0x3e7>
  103685:	c7 44 24 0c 6c 68 10 	movl   $0x10686c,0xc(%esp)
  10368c:	00 
  10368d:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103694:	00 
  103695:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  10369c:	00 
  10369d:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1036a4:	e8 1d d6 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1036a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036ac:	83 c0 04             	add    $0x4,%eax
  1036af:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1036b6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036b9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1036bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1036bf:	0f a3 10             	bt     %edx,(%eax)
  1036c2:	19 c0                	sbb    %eax,%eax
  1036c4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1036c7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1036cb:	0f 95 c0             	setne  %al
  1036ce:	0f b6 c0             	movzbl %al,%eax
  1036d1:	85 c0                	test   %eax,%eax
  1036d3:	74 0b                	je     1036e0 <default_check+0x41e>
  1036d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036d8:	8b 40 08             	mov    0x8(%eax),%eax
  1036db:	83 f8 03             	cmp    $0x3,%eax
  1036de:	74 24                	je     103704 <default_check+0x442>
  1036e0:	c7 44 24 0c 94 68 10 	movl   $0x106894,0xc(%esp)
  1036e7:	00 
  1036e8:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1036ef:	00 
  1036f0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1036f7:	00 
  1036f8:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1036ff:	e8 c2 d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103704:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10370b:	e8 20 05 00 00       	call   103c30 <alloc_pages>
  103710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103713:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103716:	83 e8 14             	sub    $0x14,%eax
  103719:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10371c:	74 24                	je     103742 <default_check+0x480>
  10371e:	c7 44 24 0c ba 68 10 	movl   $0x1068ba,0xc(%esp)
  103725:	00 
  103726:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10372d:	00 
  10372e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103735:	00 
  103736:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10373d:	e8 84 d5 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  103742:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103749:	00 
  10374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10374d:	89 04 24             	mov    %eax,(%esp)
  103750:	e8 13 05 00 00       	call   103c68 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103755:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10375c:	e8 cf 04 00 00       	call   103c30 <alloc_pages>
  103761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103764:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103767:	83 c0 14             	add    $0x14,%eax
  10376a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10376d:	74 24                	je     103793 <default_check+0x4d1>
  10376f:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  103776:	00 
  103777:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10377e:	00 
  10377f:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103786:	00 
  103787:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10378e:	e8 33 d5 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  103793:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10379a:	00 
  10379b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10379e:	89 04 24             	mov    %eax,(%esp)
  1037a1:	e8 c2 04 00 00       	call   103c68 <free_pages>
    free_page(p2);
  1037a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037ad:	00 
  1037ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037b1:	89 04 24             	mov    %eax,(%esp)
  1037b4:	e8 af 04 00 00       	call   103c68 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1037b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1037c0:	e8 6b 04 00 00       	call   103c30 <alloc_pages>
  1037c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1037cc:	75 24                	jne    1037f2 <default_check+0x530>
  1037ce:	c7 44 24 0c f8 68 10 	movl   $0x1068f8,0xc(%esp)
  1037d5:	00 
  1037d6:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1037dd:	00 
  1037de:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1037e5:	00 
  1037e6:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1037ed:	e8 d4 d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1037f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037f9:	e8 32 04 00 00       	call   103c30 <alloc_pages>
  1037fe:	85 c0                	test   %eax,%eax
  103800:	74 24                	je     103826 <default_check+0x564>
  103802:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103809:	00 
  10380a:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103811:	00 
  103812:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103819:	00 
  10381a:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103821:	e8 a0 d4 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  103826:	a1 58 89 11 00       	mov    0x118958,%eax
  10382b:	85 c0                	test   %eax,%eax
  10382d:	74 24                	je     103853 <default_check+0x591>
  10382f:	c7 44 24 0c a9 67 10 	movl   $0x1067a9,0xc(%esp)
  103836:	00 
  103837:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10383e:	00 
  10383f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103846:	00 
  103847:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10384e:	e8 73 d4 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  103853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103856:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  10385b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10385e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103861:	a3 50 89 11 00       	mov    %eax,0x118950
  103866:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  10386c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103873:	00 
  103874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103877:	89 04 24             	mov    %eax,(%esp)
  10387a:	e8 e9 03 00 00       	call   103c68 <free_pages>

    le = &free_list;
  10387f:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103886:	eb 1d                	jmp    1038a5 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10388b:	83 e8 0c             	sub    $0xc,%eax
  10388e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103891:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103895:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10389b:	8b 40 08             	mov    0x8(%eax),%eax
  10389e:	29 c2                	sub    %eax,%edx
  1038a0:	89 d0                	mov    %edx,%eax
  1038a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038a8:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1038ab:	8b 45 88             	mov    -0x78(%ebp),%eax
  1038ae:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1038b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038b4:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1038bb:	75 cb                	jne    103888 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1038bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1038c1:	74 24                	je     1038e7 <default_check+0x625>
  1038c3:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  1038ca:	00 
  1038cb:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1038d2:	00 
  1038d3:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1038da:	00 
  1038db:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1038e2:	e8 df d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  1038e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038eb:	74 24                	je     103911 <default_check+0x64f>
  1038ed:	c7 44 24 0c 21 69 10 	movl   $0x106921,0xc(%esp)
  1038f4:	00 
  1038f5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1038fc:	00 
  1038fd:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103904:	00 
  103905:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10390c:	e8 b5 d3 ff ff       	call   100cc6 <__panic>
}
  103911:	81 c4 94 00 00 00    	add    $0x94,%esp
  103917:	5b                   	pop    %ebx
  103918:	5d                   	pop    %ebp
  103919:	c3                   	ret    

0010391a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10391a:	55                   	push   %ebp
  10391b:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10391d:	8b 55 08             	mov    0x8(%ebp),%edx
  103920:	a1 64 89 11 00       	mov    0x118964,%eax
  103925:	29 c2                	sub    %eax,%edx
  103927:	89 d0                	mov    %edx,%eax
  103929:	c1 f8 02             	sar    $0x2,%eax
  10392c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103932:	5d                   	pop    %ebp
  103933:	c3                   	ret    

00103934 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103934:	55                   	push   %ebp
  103935:	89 e5                	mov    %esp,%ebp
  103937:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10393a:	8b 45 08             	mov    0x8(%ebp),%eax
  10393d:	89 04 24             	mov    %eax,(%esp)
  103940:	e8 d5 ff ff ff       	call   10391a <page2ppn>
  103945:	c1 e0 0c             	shl    $0xc,%eax
}
  103948:	c9                   	leave  
  103949:	c3                   	ret    

0010394a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10394a:	55                   	push   %ebp
  10394b:	89 e5                	mov    %esp,%ebp
  10394d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103950:	8b 45 08             	mov    0x8(%ebp),%eax
  103953:	c1 e8 0c             	shr    $0xc,%eax
  103956:	89 c2                	mov    %eax,%edx
  103958:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10395d:	39 c2                	cmp    %eax,%edx
  10395f:	72 1c                	jb     10397d <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103961:	c7 44 24 08 5c 69 10 	movl   $0x10695c,0x8(%esp)
  103968:	00 
  103969:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103970:	00 
  103971:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  103978:	e8 49 d3 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  10397d:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103983:	8b 45 08             	mov    0x8(%ebp),%eax
  103986:	c1 e8 0c             	shr    $0xc,%eax
  103989:	89 c2                	mov    %eax,%edx
  10398b:	89 d0                	mov    %edx,%eax
  10398d:	c1 e0 02             	shl    $0x2,%eax
  103990:	01 d0                	add    %edx,%eax
  103992:	c1 e0 02             	shl    $0x2,%eax
  103995:	01 c8                	add    %ecx,%eax
}
  103997:	c9                   	leave  
  103998:	c3                   	ret    

00103999 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103999:	55                   	push   %ebp
  10399a:	89 e5                	mov    %esp,%ebp
  10399c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  10399f:	8b 45 08             	mov    0x8(%ebp),%eax
  1039a2:	89 04 24             	mov    %eax,(%esp)
  1039a5:	e8 8a ff ff ff       	call   103934 <page2pa>
  1039aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039b0:	c1 e8 0c             	shr    $0xc,%eax
  1039b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039b6:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039bb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1039be:	72 23                	jb     1039e3 <page2kva+0x4a>
  1039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039c7:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  1039ce:	00 
  1039cf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1039d6:	00 
  1039d7:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  1039de:	e8 e3 d2 ff ff       	call   100cc6 <__panic>
  1039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039e6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1039eb:	c9                   	leave  
  1039ec:	c3                   	ret    

001039ed <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1039ed:	55                   	push   %ebp
  1039ee:	89 e5                	mov    %esp,%ebp
  1039f0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1039f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f6:	83 e0 01             	and    $0x1,%eax
  1039f9:	85 c0                	test   %eax,%eax
  1039fb:	75 1c                	jne    103a19 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1039fd:	c7 44 24 08 b0 69 10 	movl   $0x1069b0,0x8(%esp)
  103a04:	00 
  103a05:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a0c:	00 
  103a0d:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  103a14:	e8 ad d2 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103a19:	8b 45 08             	mov    0x8(%ebp),%eax
  103a1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a21:	89 04 24             	mov    %eax,(%esp)
  103a24:	e8 21 ff ff ff       	call   10394a <pa2page>
}
  103a29:	c9                   	leave  
  103a2a:	c3                   	ret    

00103a2b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103a2b:	55                   	push   %ebp
  103a2c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a31:	8b 00                	mov    (%eax),%eax
}
  103a33:	5d                   	pop    %ebp
  103a34:	c3                   	ret    

00103a35 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103a35:	55                   	push   %ebp
  103a36:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103a38:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a3e:	89 10                	mov    %edx,(%eax)
}
  103a40:	5d                   	pop    %ebp
  103a41:	c3                   	ret    

00103a42 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103a42:	55                   	push   %ebp
  103a43:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103a45:	8b 45 08             	mov    0x8(%ebp),%eax
  103a48:	8b 00                	mov    (%eax),%eax
  103a4a:	8d 50 01             	lea    0x1(%eax),%edx
  103a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a50:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a52:	8b 45 08             	mov    0x8(%ebp),%eax
  103a55:	8b 00                	mov    (%eax),%eax
}
  103a57:	5d                   	pop    %ebp
  103a58:	c3                   	ret    

00103a59 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103a59:	55                   	push   %ebp
  103a5a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5f:	8b 00                	mov    (%eax),%eax
  103a61:	8d 50 ff             	lea    -0x1(%eax),%edx
  103a64:	8b 45 08             	mov    0x8(%ebp),%eax
  103a67:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a69:	8b 45 08             	mov    0x8(%ebp),%eax
  103a6c:	8b 00                	mov    (%eax),%eax
}
  103a6e:	5d                   	pop    %ebp
  103a6f:	c3                   	ret    

00103a70 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103a70:	55                   	push   %ebp
  103a71:	89 e5                	mov    %esp,%ebp
  103a73:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103a76:	9c                   	pushf  
  103a77:	58                   	pop    %eax
  103a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103a7e:	25 00 02 00 00       	and    $0x200,%eax
  103a83:	85 c0                	test   %eax,%eax
  103a85:	74 0c                	je     103a93 <__intr_save+0x23>
        intr_disable();
  103a87:	e8 1d dc ff ff       	call   1016a9 <intr_disable>
        return 1;
  103a8c:	b8 01 00 00 00       	mov    $0x1,%eax
  103a91:	eb 05                	jmp    103a98 <__intr_save+0x28>
    }
    return 0;
  103a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a98:	c9                   	leave  
  103a99:	c3                   	ret    

00103a9a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103a9a:	55                   	push   %ebp
  103a9b:	89 e5                	mov    %esp,%ebp
  103a9d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103aa4:	74 05                	je     103aab <__intr_restore+0x11>
        intr_enable();
  103aa6:	e8 f8 db ff ff       	call   1016a3 <intr_enable>
    }
}
  103aab:	c9                   	leave  
  103aac:	c3                   	ret    

00103aad <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103aad:	55                   	push   %ebp
  103aae:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103ab6:	b8 23 00 00 00       	mov    $0x23,%eax
  103abb:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103abd:	b8 23 00 00 00       	mov    $0x23,%eax
  103ac2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103ac4:	b8 10 00 00 00       	mov    $0x10,%eax
  103ac9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103acb:	b8 10 00 00 00       	mov    $0x10,%eax
  103ad0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103ad2:	b8 10 00 00 00       	mov    $0x10,%eax
  103ad7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103ad9:	ea e0 3a 10 00 08 00 	ljmp   $0x8,$0x103ae0
}
  103ae0:	5d                   	pop    %ebp
  103ae1:	c3                   	ret    

00103ae2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103ae2:	55                   	push   %ebp
  103ae3:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae8:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103aed:	5d                   	pop    %ebp
  103aee:	c3                   	ret    

00103aef <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103aef:	55                   	push   %ebp
  103af0:	89 e5                	mov    %esp,%ebp
  103af2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103af5:	b8 00 70 11 00       	mov    $0x117000,%eax
  103afa:	89 04 24             	mov    %eax,(%esp)
  103afd:	e8 e0 ff ff ff       	call   103ae2 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b02:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b09:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b0b:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103b12:	68 00 
  103b14:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b19:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103b1f:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b24:	c1 e8 10             	shr    $0x10,%eax
  103b27:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103b2c:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b33:	83 e0 f0             	and    $0xfffffff0,%eax
  103b36:	83 c8 09             	or     $0x9,%eax
  103b39:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b3e:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b45:	83 e0 ef             	and    $0xffffffef,%eax
  103b48:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b4d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b54:	83 e0 9f             	and    $0xffffff9f,%eax
  103b57:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b5c:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b63:	83 c8 80             	or     $0xffffff80,%eax
  103b66:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b6b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b72:	83 e0 f0             	and    $0xfffffff0,%eax
  103b75:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b7a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b81:	83 e0 ef             	and    $0xffffffef,%eax
  103b84:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b89:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b90:	83 e0 df             	and    $0xffffffdf,%eax
  103b93:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b98:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b9f:	83 c8 40             	or     $0x40,%eax
  103ba2:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ba7:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bae:	83 e0 7f             	and    $0x7f,%eax
  103bb1:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bb6:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bbb:	c1 e8 18             	shr    $0x18,%eax
  103bbe:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103bc3:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103bca:	e8 de fe ff ff       	call   103aad <lgdt>
  103bcf:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103bd5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103bd9:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103bdc:	c9                   	leave  
  103bdd:	c3                   	ret    

00103bde <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103bde:	55                   	push   %ebp
  103bdf:	89 e5                	mov    %esp,%ebp
  103be1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103be4:	c7 05 5c 89 11 00 40 	movl   $0x106940,0x11895c
  103beb:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103bee:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103bf3:	8b 00                	mov    (%eax),%eax
  103bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bf9:	c7 04 24 dc 69 10 00 	movl   $0x1069dc,(%esp)
  103c00:	e8 37 c7 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c05:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c0a:	8b 40 04             	mov    0x4(%eax),%eax
  103c0d:	ff d0                	call   *%eax
}
  103c0f:	c9                   	leave  
  103c10:	c3                   	ret    

00103c11 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c11:	55                   	push   %ebp
  103c12:	89 e5                	mov    %esp,%ebp
  103c14:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103c17:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c1c:	8b 40 08             	mov    0x8(%eax),%eax
  103c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c22:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c26:	8b 55 08             	mov    0x8(%ebp),%edx
  103c29:	89 14 24             	mov    %edx,(%esp)
  103c2c:	ff d0                	call   *%eax
}
  103c2e:	c9                   	leave  
  103c2f:	c3                   	ret    

00103c30 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103c3d:	e8 2e fe ff ff       	call   103a70 <__intr_save>
  103c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103c45:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c4a:	8b 40 0c             	mov    0xc(%eax),%eax
  103c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  103c50:	89 14 24             	mov    %edx,(%esp)
  103c53:	ff d0                	call   *%eax
  103c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c5b:	89 04 24             	mov    %eax,(%esp)
  103c5e:	e8 37 fe ff ff       	call   103a9a <__intr_restore>
    return page;
  103c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c66:	c9                   	leave  
  103c67:	c3                   	ret    

00103c68 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103c68:	55                   	push   %ebp
  103c69:	89 e5                	mov    %esp,%ebp
  103c6b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103c6e:	e8 fd fd ff ff       	call   103a70 <__intr_save>
  103c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103c76:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c7b:	8b 40 10             	mov    0x10(%eax),%eax
  103c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c81:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c85:	8b 55 08             	mov    0x8(%ebp),%edx
  103c88:	89 14 24             	mov    %edx,(%esp)
  103c8b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c90:	89 04 24             	mov    %eax,(%esp)
  103c93:	e8 02 fe ff ff       	call   103a9a <__intr_restore>
}
  103c98:	c9                   	leave  
  103c99:	c3                   	ret    

00103c9a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103c9a:	55                   	push   %ebp
  103c9b:	89 e5                	mov    %esp,%ebp
  103c9d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103ca0:	e8 cb fd ff ff       	call   103a70 <__intr_save>
  103ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103ca8:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cad:	8b 40 14             	mov    0x14(%eax),%eax
  103cb0:	ff d0                	call   *%eax
  103cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb8:	89 04 24             	mov    %eax,(%esp)
  103cbb:	e8 da fd ff ff       	call   103a9a <__intr_restore>
    return ret;
  103cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103cc3:	c9                   	leave  
  103cc4:	c3                   	ret    

00103cc5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103cc5:	55                   	push   %ebp
  103cc6:	89 e5                	mov    %esp,%ebp
  103cc8:	57                   	push   %edi
  103cc9:	56                   	push   %esi
  103cca:	53                   	push   %ebx
  103ccb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103cd1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103cd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103ce6:	c7 04 24 f3 69 10 00 	movl   $0x1069f3,(%esp)
  103ced:	e8 4a c6 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103cf2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103cf9:	e9 15 01 00 00       	jmp    103e13 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103cfe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d04:	89 d0                	mov    %edx,%eax
  103d06:	c1 e0 02             	shl    $0x2,%eax
  103d09:	01 d0                	add    %edx,%eax
  103d0b:	c1 e0 02             	shl    $0x2,%eax
  103d0e:	01 c8                	add    %ecx,%eax
  103d10:	8b 50 08             	mov    0x8(%eax),%edx
  103d13:	8b 40 04             	mov    0x4(%eax),%eax
  103d16:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103d19:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103d1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d22:	89 d0                	mov    %edx,%eax
  103d24:	c1 e0 02             	shl    $0x2,%eax
  103d27:	01 d0                	add    %edx,%eax
  103d29:	c1 e0 02             	shl    $0x2,%eax
  103d2c:	01 c8                	add    %ecx,%eax
  103d2e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d31:	8b 58 10             	mov    0x10(%eax),%ebx
  103d34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d37:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d3a:	01 c8                	add    %ecx,%eax
  103d3c:	11 da                	adc    %ebx,%edx
  103d3e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103d41:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103d44:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d4a:	89 d0                	mov    %edx,%eax
  103d4c:	c1 e0 02             	shl    $0x2,%eax
  103d4f:	01 d0                	add    %edx,%eax
  103d51:	c1 e0 02             	shl    $0x2,%eax
  103d54:	01 c8                	add    %ecx,%eax
  103d56:	83 c0 14             	add    $0x14,%eax
  103d59:	8b 00                	mov    (%eax),%eax
  103d5b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103d61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103d64:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103d67:	83 c0 ff             	add    $0xffffffff,%eax
  103d6a:	83 d2 ff             	adc    $0xffffffff,%edx
  103d6d:	89 c6                	mov    %eax,%esi
  103d6f:	89 d7                	mov    %edx,%edi
  103d71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d77:	89 d0                	mov    %edx,%eax
  103d79:	c1 e0 02             	shl    $0x2,%eax
  103d7c:	01 d0                	add    %edx,%eax
  103d7e:	c1 e0 02             	shl    $0x2,%eax
  103d81:	01 c8                	add    %ecx,%eax
  103d83:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d86:	8b 58 10             	mov    0x10(%eax),%ebx
  103d89:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103d8f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103d93:	89 74 24 14          	mov    %esi,0x14(%esp)
  103d97:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103d9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d9e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103da1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103da5:	89 54 24 10          	mov    %edx,0x10(%esp)
  103da9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103dad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103db1:	c7 04 24 00 6a 10 00 	movl   $0x106a00,(%esp)
  103db8:	e8 7f c5 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103dbd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dc3:	89 d0                	mov    %edx,%eax
  103dc5:	c1 e0 02             	shl    $0x2,%eax
  103dc8:	01 d0                	add    %edx,%eax
  103dca:	c1 e0 02             	shl    $0x2,%eax
  103dcd:	01 c8                	add    %ecx,%eax
  103dcf:	83 c0 14             	add    $0x14,%eax
  103dd2:	8b 00                	mov    (%eax),%eax
  103dd4:	83 f8 01             	cmp    $0x1,%eax
  103dd7:	75 36                	jne    103e0f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ddf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103de2:	77 2b                	ja     103e0f <page_init+0x14a>
  103de4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103de7:	72 05                	jb     103dee <page_init+0x129>
  103de9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103dec:	73 21                	jae    103e0f <page_init+0x14a>
  103dee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103df2:	77 1b                	ja     103e0f <page_init+0x14a>
  103df4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103df8:	72 09                	jb     103e03 <page_init+0x13e>
  103dfa:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e01:	77 0c                	ja     103e0f <page_init+0x14a>
                maxpa = end;
  103e03:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e0f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103e16:	8b 00                	mov    (%eax),%eax
  103e18:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103e1b:	0f 8f dd fe ff ff    	jg     103cfe <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103e21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e25:	72 1d                	jb     103e44 <page_init+0x17f>
  103e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e2b:	77 09                	ja     103e36 <page_init+0x171>
  103e2d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103e34:	76 0e                	jbe    103e44 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103e36:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103e3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e4a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103e4e:	c1 ea 0c             	shr    $0xc,%edx
  103e51:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103e56:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103e5d:	b8 68 89 11 00       	mov    $0x118968,%eax
  103e62:	8d 50 ff             	lea    -0x1(%eax),%edx
  103e65:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103e68:	01 d0                	add    %edx,%eax
  103e6a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103e6d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103e70:	ba 00 00 00 00       	mov    $0x0,%edx
  103e75:	f7 75 ac             	divl   -0x54(%ebp)
  103e78:	89 d0                	mov    %edx,%eax
  103e7a:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103e7d:	29 c2                	sub    %eax,%edx
  103e7f:	89 d0                	mov    %edx,%eax
  103e81:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103e86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e8d:	eb 2f                	jmp    103ebe <page_init+0x1f9>
        SetPageReserved(pages + i);
  103e8f:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e98:	89 d0                	mov    %edx,%eax
  103e9a:	c1 e0 02             	shl    $0x2,%eax
  103e9d:	01 d0                	add    %edx,%eax
  103e9f:	c1 e0 02             	shl    $0x2,%eax
  103ea2:	01 c8                	add    %ecx,%eax
  103ea4:	83 c0 04             	add    $0x4,%eax
  103ea7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103eae:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103eb1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103eb4:	8b 55 90             	mov    -0x70(%ebp),%edx
  103eb7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103eba:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ebe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ec1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103ec6:	39 c2                	cmp    %eax,%edx
  103ec8:	72 c5                	jb     103e8f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103eca:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103ed0:	89 d0                	mov    %edx,%eax
  103ed2:	c1 e0 02             	shl    $0x2,%eax
  103ed5:	01 d0                	add    %edx,%eax
  103ed7:	c1 e0 02             	shl    $0x2,%eax
  103eda:	89 c2                	mov    %eax,%edx
  103edc:	a1 64 89 11 00       	mov    0x118964,%eax
  103ee1:	01 d0                	add    %edx,%eax
  103ee3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103ee6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103eed:	77 23                	ja     103f12 <page_init+0x24d>
  103eef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103ef2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ef6:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  103efd:	00 
  103efe:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f05:	00 
  103f06:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  103f0d:	e8 b4 cd ff ff       	call   100cc6 <__panic>
  103f12:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f15:	05 00 00 00 40       	add    $0x40000000,%eax
  103f1a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103f1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f24:	e9 74 01 00 00       	jmp    10409d <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f29:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f2f:	89 d0                	mov    %edx,%eax
  103f31:	c1 e0 02             	shl    $0x2,%eax
  103f34:	01 d0                	add    %edx,%eax
  103f36:	c1 e0 02             	shl    $0x2,%eax
  103f39:	01 c8                	add    %ecx,%eax
  103f3b:	8b 50 08             	mov    0x8(%eax),%edx
  103f3e:	8b 40 04             	mov    0x4(%eax),%eax
  103f41:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103f47:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f4d:	89 d0                	mov    %edx,%eax
  103f4f:	c1 e0 02             	shl    $0x2,%eax
  103f52:	01 d0                	add    %edx,%eax
  103f54:	c1 e0 02             	shl    $0x2,%eax
  103f57:	01 c8                	add    %ecx,%eax
  103f59:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f5c:	8b 58 10             	mov    0x10(%eax),%ebx
  103f5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f65:	01 c8                	add    %ecx,%eax
  103f67:	11 da                	adc    %ebx,%edx
  103f69:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103f6c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103f6f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f75:	89 d0                	mov    %edx,%eax
  103f77:	c1 e0 02             	shl    $0x2,%eax
  103f7a:	01 d0                	add    %edx,%eax
  103f7c:	c1 e0 02             	shl    $0x2,%eax
  103f7f:	01 c8                	add    %ecx,%eax
  103f81:	83 c0 14             	add    $0x14,%eax
  103f84:	8b 00                	mov    (%eax),%eax
  103f86:	83 f8 01             	cmp    $0x1,%eax
  103f89:	0f 85 0a 01 00 00    	jne    104099 <page_init+0x3d4>
            if (begin < freemem) {
  103f8f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f92:	ba 00 00 00 00       	mov    $0x0,%edx
  103f97:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f9a:	72 17                	jb     103fb3 <page_init+0x2ee>
  103f9c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f9f:	77 05                	ja     103fa6 <page_init+0x2e1>
  103fa1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103fa4:	76 0d                	jbe    103fb3 <page_init+0x2ee>
                begin = freemem;
  103fa6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103fa9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103fb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103fb7:	72 1d                	jb     103fd6 <page_init+0x311>
  103fb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103fbd:	77 09                	ja     103fc8 <page_init+0x303>
  103fbf:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103fc6:	76 0e                	jbe    103fd6 <page_init+0x311>
                end = KMEMSIZE;
  103fc8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103fcf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103fd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103fd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103fdc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103fdf:	0f 87 b4 00 00 00    	ja     104099 <page_init+0x3d4>
  103fe5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103fe8:	72 09                	jb     103ff3 <page_init+0x32e>
  103fea:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103fed:	0f 83 a6 00 00 00    	jae    104099 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103ff3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103ffa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103ffd:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104000:	01 d0                	add    %edx,%eax
  104002:	83 e8 01             	sub    $0x1,%eax
  104005:	89 45 98             	mov    %eax,-0x68(%ebp)
  104008:	8b 45 98             	mov    -0x68(%ebp),%eax
  10400b:	ba 00 00 00 00       	mov    $0x0,%edx
  104010:	f7 75 9c             	divl   -0x64(%ebp)
  104013:	89 d0                	mov    %edx,%eax
  104015:	8b 55 98             	mov    -0x68(%ebp),%edx
  104018:	29 c2                	sub    %eax,%edx
  10401a:	89 d0                	mov    %edx,%eax
  10401c:	ba 00 00 00 00       	mov    $0x0,%edx
  104021:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104024:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104027:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10402a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10402d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104030:	ba 00 00 00 00       	mov    $0x0,%edx
  104035:	89 c7                	mov    %eax,%edi
  104037:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10403d:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104040:	89 d0                	mov    %edx,%eax
  104042:	83 e0 00             	and    $0x0,%eax
  104045:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104048:	8b 45 80             	mov    -0x80(%ebp),%eax
  10404b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10404e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104051:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104054:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104057:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10405a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10405d:	77 3a                	ja     104099 <page_init+0x3d4>
  10405f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104062:	72 05                	jb     104069 <page_init+0x3a4>
  104064:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104067:	73 30                	jae    104099 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104069:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10406c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10406f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104072:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104075:	29 c8                	sub    %ecx,%eax
  104077:	19 da                	sbb    %ebx,%edx
  104079:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10407d:	c1 ea 0c             	shr    $0xc,%edx
  104080:	89 c3                	mov    %eax,%ebx
  104082:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104085:	89 04 24             	mov    %eax,(%esp)
  104088:	e8 bd f8 ff ff       	call   10394a <pa2page>
  10408d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104091:	89 04 24             	mov    %eax,(%esp)
  104094:	e8 78 fb ff ff       	call   103c11 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104099:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10409d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040a0:	8b 00                	mov    (%eax),%eax
  1040a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1040a5:	0f 8f 7e fe ff ff    	jg     103f29 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1040ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1040b1:	5b                   	pop    %ebx
  1040b2:	5e                   	pop    %esi
  1040b3:	5f                   	pop    %edi
  1040b4:	5d                   	pop    %ebp
  1040b5:	c3                   	ret    

001040b6 <enable_paging>:

static void
enable_paging(void) {
  1040b6:	55                   	push   %ebp
  1040b7:	89 e5                	mov    %esp,%ebp
  1040b9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1040bc:	a1 60 89 11 00       	mov    0x118960,%eax
  1040c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1040c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1040c7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1040ca:	0f 20 c0             	mov    %cr0,%eax
  1040cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1040d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1040d6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1040dd:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1040e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1040e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040ea:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1040ed:	c9                   	leave  
  1040ee:	c3                   	ret    

001040ef <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1040ef:	55                   	push   %ebp
  1040f0:	89 e5                	mov    %esp,%ebp
  1040f2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1040f5:	8b 45 14             	mov    0x14(%ebp),%eax
  1040f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040fb:	31 d0                	xor    %edx,%eax
  1040fd:	25 ff 0f 00 00       	and    $0xfff,%eax
  104102:	85 c0                	test   %eax,%eax
  104104:	74 24                	je     10412a <boot_map_segment+0x3b>
  104106:	c7 44 24 0c 62 6a 10 	movl   $0x106a62,0xc(%esp)
  10410d:	00 
  10410e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104115:	00 
  104116:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10411d:	00 
  10411e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104125:	e8 9c cb ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10412a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104131:	8b 45 0c             	mov    0xc(%ebp),%eax
  104134:	25 ff 0f 00 00       	and    $0xfff,%eax
  104139:	89 c2                	mov    %eax,%edx
  10413b:	8b 45 10             	mov    0x10(%ebp),%eax
  10413e:	01 c2                	add    %eax,%edx
  104140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104143:	01 d0                	add    %edx,%eax
  104145:	83 e8 01             	sub    $0x1,%eax
  104148:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10414b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10414e:	ba 00 00 00 00       	mov    $0x0,%edx
  104153:	f7 75 f0             	divl   -0x10(%ebp)
  104156:	89 d0                	mov    %edx,%eax
  104158:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10415b:	29 c2                	sub    %eax,%edx
  10415d:	89 d0                	mov    %edx,%eax
  10415f:	c1 e8 0c             	shr    $0xc,%eax
  104162:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104165:	8b 45 0c             	mov    0xc(%ebp),%eax
  104168:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10416b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10416e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104173:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104176:	8b 45 14             	mov    0x14(%ebp),%eax
  104179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10417c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10417f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104184:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104187:	eb 6b                	jmp    1041f4 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104189:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104190:	00 
  104191:	8b 45 0c             	mov    0xc(%ebp),%eax
  104194:	89 44 24 04          	mov    %eax,0x4(%esp)
  104198:	8b 45 08             	mov    0x8(%ebp),%eax
  10419b:	89 04 24             	mov    %eax,(%esp)
  10419e:	e8 cc 01 00 00       	call   10436f <get_pte>
  1041a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1041a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1041aa:	75 24                	jne    1041d0 <boot_map_segment+0xe1>
  1041ac:	c7 44 24 0c 8e 6a 10 	movl   $0x106a8e,0xc(%esp)
  1041b3:	00 
  1041b4:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1041bb:	00 
  1041bc:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1041c3:	00 
  1041c4:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1041cb:	e8 f6 ca ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  1041d0:	8b 45 18             	mov    0x18(%ebp),%eax
  1041d3:	8b 55 14             	mov    0x14(%ebp),%edx
  1041d6:	09 d0                	or     %edx,%eax
  1041d8:	83 c8 01             	or     $0x1,%eax
  1041db:	89 c2                	mov    %eax,%edx
  1041dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041e0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1041e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1041e6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1041ed:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1041f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1041f8:	75 8f                	jne    104189 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1041fa:	c9                   	leave  
  1041fb:	c3                   	ret    

001041fc <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1041fc:	55                   	push   %ebp
  1041fd:	89 e5                	mov    %esp,%ebp
  1041ff:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104209:	e8 22 fa ff ff       	call   103c30 <alloc_pages>
  10420e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104215:	75 1c                	jne    104233 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104217:	c7 44 24 08 9b 6a 10 	movl   $0x106a9b,0x8(%esp)
  10421e:	00 
  10421f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104226:	00 
  104227:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10422e:	e8 93 ca ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  104233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104236:	89 04 24             	mov    %eax,(%esp)
  104239:	e8 5b f7 ff ff       	call   103999 <page2kva>
}
  10423e:	c9                   	leave  
  10423f:	c3                   	ret    

00104240 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104240:	55                   	push   %ebp
  104241:	89 e5                	mov    %esp,%ebp
  104243:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104246:	e8 93 f9 ff ff       	call   103bde <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10424b:	e8 75 fa ff ff       	call   103cc5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104250:	e8 7b 04 00 00       	call   1046d0 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104255:	e8 a2 ff ff ff       	call   1041fc <boot_alloc_page>
  10425a:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10425f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104264:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10426b:	00 
  10426c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104273:	00 
  104274:	89 04 24             	mov    %eax,(%esp)
  104277:	e8 bd 1a 00 00       	call   105d39 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10427c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104284:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10428b:	77 23                	ja     1042b0 <pmm_init+0x70>
  10428d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104290:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104294:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  10429b:	00 
  10429c:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1042a3:	00 
  1042a4:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1042ab:	e8 16 ca ff ff       	call   100cc6 <__panic>
  1042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042b3:	05 00 00 00 40       	add    $0x40000000,%eax
  1042b8:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1042bd:	e8 2c 04 00 00       	call   1046ee <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1042c2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042c7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1042cd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042d5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1042dc:	77 23                	ja     104301 <pmm_init+0xc1>
  1042de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1042e5:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  1042ec:	00 
  1042ed:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1042f4:	00 
  1042f5:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1042fc:	e8 c5 c9 ff ff       	call   100cc6 <__panic>
  104301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104304:	05 00 00 00 40       	add    $0x40000000,%eax
  104309:	83 c8 03             	or     $0x3,%eax
  10430c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10430e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104313:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10431a:	00 
  10431b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104322:	00 
  104323:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10432a:	38 
  10432b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104332:	c0 
  104333:	89 04 24             	mov    %eax,(%esp)
  104336:	e8 b4 fd ff ff       	call   1040ef <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10433b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104340:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104346:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10434c:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10434e:	e8 63 fd ff ff       	call   1040b6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104353:	e8 97 f7 ff ff       	call   103aef <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104358:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10435d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104363:	e8 21 0a 00 00       	call   104d89 <check_boot_pgdir>

    print_pgdir();
  104368:	e8 ae 0e 00 00       	call   10521b <print_pgdir>

}
  10436d:	c9                   	leave  
  10436e:	c3                   	ret    

0010436f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10436f:	55                   	push   %ebp
  104370:	89 e5                	mov    %esp,%ebp
  104372:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  104375:	8b 45 0c             	mov    0xc(%ebp),%eax
  104378:	c1 e8 16             	shr    $0x16,%eax
  10437b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104382:	8b 45 08             	mov    0x8(%ebp),%eax
  104385:	01 d0                	add    %edx,%eax
  104387:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page * page;
    if (!((*pdep) & PTE_P)) {
  10438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10438d:	8b 00                	mov    (%eax),%eax
  10438f:	83 e0 01             	and    $0x1,%eax
  104392:	85 c0                	test   %eax,%eax
  104394:	0f 85 b9 00 00 00    	jne    104453 <get_pte+0xe4>
        if (!create) {
  10439a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10439e:	75 0a                	jne    1043aa <get_pte+0x3b>
            return NULL;
  1043a0:	b8 00 00 00 00       	mov    $0x0,%eax
  1043a5:	e9 05 01 00 00       	jmp    1044af <get_pte+0x140>
        }
        page = alloc_page();
  1043aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1043b1:	e8 7a f8 ff ff       	call   103c30 <alloc_pages>
  1043b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL) return NULL;
  1043b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1043bd:	75 0a                	jne    1043c9 <get_pte+0x5a>
  1043bf:	b8 00 00 00 00       	mov    $0x0,%eax
  1043c4:	e9 e6 00 00 00       	jmp    1044af <get_pte+0x140>
        set_page_ref(page, 1);
  1043c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1043d0:	00 
  1043d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043d4:	89 04 24             	mov    %eax,(%esp)
  1043d7:	e8 59 f6 ff ff       	call   103a35 <set_page_ref>
        uintptr_t page_addr = page2pa(page);
  1043dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043df:	89 04 24             	mov    %eax,(%esp)
  1043e2:	e8 4d f5 ff ff       	call   103934 <page2pa>
  1043e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(page_addr), 0, PGSIZE);
  1043ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1043f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043f3:	c1 e8 0c             	shr    $0xc,%eax
  1043f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043f9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1043fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104401:	72 23                	jb     104426 <get_pte+0xb7>
  104403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104406:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10440a:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104411:	00 
  104412:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  104419:	00 
  10441a:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104421:	e8 a0 c8 ff ff       	call   100cc6 <__panic>
  104426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104429:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10442e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104435:	00 
  104436:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10443d:	00 
  10443e:	89 04 24             	mov    %eax,(%esp)
  104441:	e8 f3 18 00 00       	call   105d39 <memset>
        *pdep = page_addr | PTE_P | PTE_W | PTE_U;
  104446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104449:	83 c8 07             	or     $0x7,%eax
  10444c:	89 c2                	mov    %eax,%edx
  10444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104451:	89 10                	mov    %edx,(%eax)
    }
    return &(((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]);
  104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104456:	8b 00                	mov    (%eax),%eax
  104458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10445d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104463:	c1 e8 0c             	shr    $0xc,%eax
  104466:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104469:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10446e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104471:	72 23                	jb     104496 <get_pte+0x127>
  104473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104476:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10447a:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104481:	00 
  104482:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  104489:	00 
  10448a:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104491:	e8 30 c8 ff ff       	call   100cc6 <__panic>
  104496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104499:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10449e:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044a1:	c1 ea 0c             	shr    $0xc,%edx
  1044a4:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1044aa:	c1 e2 02             	shl    $0x2,%edx
  1044ad:	01 d0                	add    %edx,%eax
}
  1044af:	c9                   	leave  
  1044b0:	c3                   	ret    

001044b1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1044b1:	55                   	push   %ebp
  1044b2:	89 e5                	mov    %esp,%ebp
  1044b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044be:	00 
  1044bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c9:	89 04 24             	mov    %eax,(%esp)
  1044cc:	e8 9e fe ff ff       	call   10436f <get_pte>
  1044d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1044d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044d8:	74 08                	je     1044e2 <get_page+0x31>
        *ptep_store = ptep;
  1044da:	8b 45 10             	mov    0x10(%ebp),%eax
  1044dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044e0:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1044e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044e6:	74 1b                	je     104503 <get_page+0x52>
  1044e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044eb:	8b 00                	mov    (%eax),%eax
  1044ed:	83 e0 01             	and    $0x1,%eax
  1044f0:	85 c0                	test   %eax,%eax
  1044f2:	74 0f                	je     104503 <get_page+0x52>
        return pa2page(*ptep);
  1044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f7:	8b 00                	mov    (%eax),%eax
  1044f9:	89 04 24             	mov    %eax,(%esp)
  1044fc:	e8 49 f4 ff ff       	call   10394a <pa2page>
  104501:	eb 05                	jmp    104508 <get_page+0x57>
    }
    return NULL;
  104503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104508:	c9                   	leave  
  104509:	c3                   	ret    

0010450a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10450a:	55                   	push   %ebp
  10450b:	89 e5                	mov    %esp,%ebp
  10450d:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  104510:	8b 45 10             	mov    0x10(%ebp),%eax
  104513:	8b 00                	mov    (%eax),%eax
  104515:	83 e0 01             	and    $0x1,%eax
  104518:	85 c0                	test   %eax,%eax
  10451a:	74 58                	je     104574 <page_remove_pte+0x6a>
        struct Page* page = pte2page(*ptep);
  10451c:	8b 45 10             	mov    0x10(%ebp),%eax
  10451f:	8b 00                	mov    (%eax),%eax
  104521:	89 04 24             	mov    %eax,(%esp)
  104524:	e8 c4 f4 ff ff       	call   1039ed <pte2page>
  104529:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
  10452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452f:	89 04 24             	mov    %eax,(%esp)
  104532:	e8 22 f5 ff ff       	call   103a59 <page_ref_dec>
        if (page_ref(page) == 0) {
  104537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10453a:	89 04 24             	mov    %eax,(%esp)
  10453d:	e8 e9 f4 ff ff       	call   103a2b <page_ref>
  104542:	85 c0                	test   %eax,%eax
  104544:	75 13                	jne    104559 <page_remove_pte+0x4f>
            free_page(page);
  104546:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10454d:	00 
  10454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104551:	89 04 24             	mov    %eax,(%esp)
  104554:	e8 0f f7 ff ff       	call   103c68 <free_pages>
        }
        *ptep = 0;
  104559:	8b 45 10             	mov    0x10(%ebp),%eax
  10455c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  104562:	8b 45 0c             	mov    0xc(%ebp),%eax
  104565:	89 44 24 04          	mov    %eax,0x4(%esp)
  104569:	8b 45 08             	mov    0x8(%ebp),%eax
  10456c:	89 04 24             	mov    %eax,(%esp)
  10456f:	e8 ff 00 00 00       	call   104673 <tlb_invalidate>
    }
}
  104574:	c9                   	leave  
  104575:	c3                   	ret    

00104576 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104576:	55                   	push   %ebp
  104577:	89 e5                	mov    %esp,%ebp
  104579:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10457c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104583:	00 
  104584:	8b 45 0c             	mov    0xc(%ebp),%eax
  104587:	89 44 24 04          	mov    %eax,0x4(%esp)
  10458b:	8b 45 08             	mov    0x8(%ebp),%eax
  10458e:	89 04 24             	mov    %eax,(%esp)
  104591:	e8 d9 fd ff ff       	call   10436f <get_pte>
  104596:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10459d:	74 19                	je     1045b8 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b0:	89 04 24             	mov    %eax,(%esp)
  1045b3:	e8 52 ff ff ff       	call   10450a <page_remove_pte>
    }
}
  1045b8:	c9                   	leave  
  1045b9:	c3                   	ret    

001045ba <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1045ba:	55                   	push   %ebp
  1045bb:	89 e5                	mov    %esp,%ebp
  1045bd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1045c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1045c7:	00 
  1045c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1045cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d2:	89 04 24             	mov    %eax,(%esp)
  1045d5:	e8 95 fd ff ff       	call   10436f <get_pte>
  1045da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1045dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045e1:	75 0a                	jne    1045ed <page_insert+0x33>
        return -E_NO_MEM;
  1045e3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1045e8:	e9 84 00 00 00       	jmp    104671 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1045ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f0:	89 04 24             	mov    %eax,(%esp)
  1045f3:	e8 4a f4 ff ff       	call   103a42 <page_ref_inc>
    if (*ptep & PTE_P) {
  1045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045fb:	8b 00                	mov    (%eax),%eax
  1045fd:	83 e0 01             	and    $0x1,%eax
  104600:	85 c0                	test   %eax,%eax
  104602:	74 3e                	je     104642 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104607:	8b 00                	mov    (%eax),%eax
  104609:	89 04 24             	mov    %eax,(%esp)
  10460c:	e8 dc f3 ff ff       	call   1039ed <pte2page>
  104611:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104617:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10461a:	75 0d                	jne    104629 <page_insert+0x6f>
            page_ref_dec(page);
  10461c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10461f:	89 04 24             	mov    %eax,(%esp)
  104622:	e8 32 f4 ff ff       	call   103a59 <page_ref_dec>
  104627:	eb 19                	jmp    104642 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104630:	8b 45 10             	mov    0x10(%ebp),%eax
  104633:	89 44 24 04          	mov    %eax,0x4(%esp)
  104637:	8b 45 08             	mov    0x8(%ebp),%eax
  10463a:	89 04 24             	mov    %eax,(%esp)
  10463d:	e8 c8 fe ff ff       	call   10450a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104642:	8b 45 0c             	mov    0xc(%ebp),%eax
  104645:	89 04 24             	mov    %eax,(%esp)
  104648:	e8 e7 f2 ff ff       	call   103934 <page2pa>
  10464d:	0b 45 14             	or     0x14(%ebp),%eax
  104650:	83 c8 01             	or     $0x1,%eax
  104653:	89 c2                	mov    %eax,%edx
  104655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104658:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10465a:	8b 45 10             	mov    0x10(%ebp),%eax
  10465d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104661:	8b 45 08             	mov    0x8(%ebp),%eax
  104664:	89 04 24             	mov    %eax,(%esp)
  104667:	e8 07 00 00 00       	call   104673 <tlb_invalidate>
    return 0;
  10466c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104671:	c9                   	leave  
  104672:	c3                   	ret    

00104673 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104673:	55                   	push   %ebp
  104674:	89 e5                	mov    %esp,%ebp
  104676:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104679:	0f 20 d8             	mov    %cr3,%eax
  10467c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10467f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104682:	89 c2                	mov    %eax,%edx
  104684:	8b 45 08             	mov    0x8(%ebp),%eax
  104687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10468a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104691:	77 23                	ja     1046b6 <tlb_invalidate+0x43>
  104693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104696:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10469a:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  1046a1:	00 
  1046a2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1046a9:	00 
  1046aa:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1046b1:	e8 10 c6 ff ff       	call   100cc6 <__panic>
  1046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b9:	05 00 00 00 40       	add    $0x40000000,%eax
  1046be:	39 c2                	cmp    %eax,%edx
  1046c0:	75 0c                	jne    1046ce <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1046c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1046c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046cb:	0f 01 38             	invlpg (%eax)
    }
}
  1046ce:	c9                   	leave  
  1046cf:	c3                   	ret    

001046d0 <check_alloc_page>:

static void
check_alloc_page(void) {
  1046d0:	55                   	push   %ebp
  1046d1:	89 e5                	mov    %esp,%ebp
  1046d3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1046d6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1046db:	8b 40 18             	mov    0x18(%eax),%eax
  1046de:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1046e0:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1046e7:	e8 50 bc ff ff       	call   10033c <cprintf>
}
  1046ec:	c9                   	leave  
  1046ed:	c3                   	ret    

001046ee <check_pgdir>:

static void
check_pgdir(void) {
  1046ee:	55                   	push   %ebp
  1046ef:	89 e5                	mov    %esp,%ebp
  1046f1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1046f4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046f9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1046fe:	76 24                	jbe    104724 <check_pgdir+0x36>
  104700:	c7 44 24 0c d3 6a 10 	movl   $0x106ad3,0xc(%esp)
  104707:	00 
  104708:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10470f:	00 
  104710:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104717:	00 
  104718:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10471f:	e8 a2 c5 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104724:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104729:	85 c0                	test   %eax,%eax
  10472b:	74 0e                	je     10473b <check_pgdir+0x4d>
  10472d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104732:	25 ff 0f 00 00       	and    $0xfff,%eax
  104737:	85 c0                	test   %eax,%eax
  104739:	74 24                	je     10475f <check_pgdir+0x71>
  10473b:	c7 44 24 0c f0 6a 10 	movl   $0x106af0,0xc(%esp)
  104742:	00 
  104743:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10474a:	00 
  10474b:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104752:	00 
  104753:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10475a:	e8 67 c5 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10475f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104764:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10476b:	00 
  10476c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104773:	00 
  104774:	89 04 24             	mov    %eax,(%esp)
  104777:	e8 35 fd ff ff       	call   1044b1 <get_page>
  10477c:	85 c0                	test   %eax,%eax
  10477e:	74 24                	je     1047a4 <check_pgdir+0xb6>
  104780:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  104787:	00 
  104788:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10478f:	00 
  104790:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104797:	00 
  104798:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10479f:	e8 22 c5 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1047a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1047ab:	e8 80 f4 ff ff       	call   103c30 <alloc_pages>
  1047b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1047b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1047bf:	00 
  1047c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047c7:	00 
  1047c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047cf:	89 04 24             	mov    %eax,(%esp)
  1047d2:	e8 e3 fd ff ff       	call   1045ba <page_insert>
  1047d7:	85 c0                	test   %eax,%eax
  1047d9:	74 24                	je     1047ff <check_pgdir+0x111>
  1047db:	c7 44 24 0c 50 6b 10 	movl   $0x106b50,0xc(%esp)
  1047e2:	00 
  1047e3:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1047ea:	00 
  1047eb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1047f2:	00 
  1047f3:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1047fa:	e8 c7 c4 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1047ff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10480b:	00 
  10480c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104813:	00 
  104814:	89 04 24             	mov    %eax,(%esp)
  104817:	e8 53 fb ff ff       	call   10436f <get_pte>
  10481c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10481f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104823:	75 24                	jne    104849 <check_pgdir+0x15b>
  104825:	c7 44 24 0c 7c 6b 10 	movl   $0x106b7c,0xc(%esp)
  10482c:	00 
  10482d:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104834:	00 
  104835:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  10483c:	00 
  10483d:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104844:	e8 7d c4 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10484c:	8b 00                	mov    (%eax),%eax
  10484e:	89 04 24             	mov    %eax,(%esp)
  104851:	e8 f4 f0 ff ff       	call   10394a <pa2page>
  104856:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104859:	74 24                	je     10487f <check_pgdir+0x191>
  10485b:	c7 44 24 0c a9 6b 10 	movl   $0x106ba9,0xc(%esp)
  104862:	00 
  104863:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10486a:	00 
  10486b:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104872:	00 
  104873:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10487a:	e8 47 c4 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  10487f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104882:	89 04 24             	mov    %eax,(%esp)
  104885:	e8 a1 f1 ff ff       	call   103a2b <page_ref>
  10488a:	83 f8 01             	cmp    $0x1,%eax
  10488d:	74 24                	je     1048b3 <check_pgdir+0x1c5>
  10488f:	c7 44 24 0c be 6b 10 	movl   $0x106bbe,0xc(%esp)
  104896:	00 
  104897:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10489e:	00 
  10489f:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1048a6:	00 
  1048a7:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1048ae:	e8 13 c4 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1048b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048b8:	8b 00                	mov    (%eax),%eax
  1048ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1048bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1048c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048c5:	c1 e8 0c             	shr    $0xc,%eax
  1048c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1048cb:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048d0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1048d3:	72 23                	jb     1048f8 <check_pgdir+0x20a>
  1048d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048dc:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  1048e3:	00 
  1048e4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1048eb:	00 
  1048ec:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1048f3:	e8 ce c3 ff ff       	call   100cc6 <__panic>
  1048f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048fb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104900:	83 c0 04             	add    $0x4,%eax
  104903:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104906:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10490b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104912:	00 
  104913:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10491a:	00 
  10491b:	89 04 24             	mov    %eax,(%esp)
  10491e:	e8 4c fa ff ff       	call   10436f <get_pte>
  104923:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104926:	74 24                	je     10494c <check_pgdir+0x25e>
  104928:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  10492f:	00 
  104930:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104937:	00 
  104938:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  10493f:	00 
  104940:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104947:	e8 7a c3 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  10494c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104953:	e8 d8 f2 ff ff       	call   103c30 <alloc_pages>
  104958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10495b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104960:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104967:	00 
  104968:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10496f:	00 
  104970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104973:	89 54 24 04          	mov    %edx,0x4(%esp)
  104977:	89 04 24             	mov    %eax,(%esp)
  10497a:	e8 3b fc ff ff       	call   1045ba <page_insert>
  10497f:	85 c0                	test   %eax,%eax
  104981:	74 24                	je     1049a7 <check_pgdir+0x2b9>
  104983:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  10498a:	00 
  10498b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104992:	00 
  104993:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  10499a:	00 
  10499b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1049a2:	e8 1f c3 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1049a7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049b3:	00 
  1049b4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049bb:	00 
  1049bc:	89 04 24             	mov    %eax,(%esp)
  1049bf:	e8 ab f9 ff ff       	call   10436f <get_pte>
  1049c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049cb:	75 24                	jne    1049f1 <check_pgdir+0x303>
  1049cd:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  1049d4:	00 
  1049d5:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1049dc:	00 
  1049dd:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  1049e4:	00 
  1049e5:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1049ec:	e8 d5 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  1049f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049f4:	8b 00                	mov    (%eax),%eax
  1049f6:	83 e0 04             	and    $0x4,%eax
  1049f9:	85 c0                	test   %eax,%eax
  1049fb:	75 24                	jne    104a21 <check_pgdir+0x333>
  1049fd:	c7 44 24 0c 60 6c 10 	movl   $0x106c60,0xc(%esp)
  104a04:	00 
  104a05:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a0c:	00 
  104a0d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104a14:	00 
  104a15:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a1c:	e8 a5 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  104a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a24:	8b 00                	mov    (%eax),%eax
  104a26:	83 e0 02             	and    $0x2,%eax
  104a29:	85 c0                	test   %eax,%eax
  104a2b:	75 24                	jne    104a51 <check_pgdir+0x363>
  104a2d:	c7 44 24 0c 6e 6c 10 	movl   $0x106c6e,0xc(%esp)
  104a34:	00 
  104a35:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a3c:	00 
  104a3d:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104a44:	00 
  104a45:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a4c:	e8 75 c2 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104a51:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a56:	8b 00                	mov    (%eax),%eax
  104a58:	83 e0 04             	and    $0x4,%eax
  104a5b:	85 c0                	test   %eax,%eax
  104a5d:	75 24                	jne    104a83 <check_pgdir+0x395>
  104a5f:	c7 44 24 0c 7c 6c 10 	movl   $0x106c7c,0xc(%esp)
  104a66:	00 
  104a67:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a6e:	00 
  104a6f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104a76:	00 
  104a77:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a7e:	e8 43 c2 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  104a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a86:	89 04 24             	mov    %eax,(%esp)
  104a89:	e8 9d ef ff ff       	call   103a2b <page_ref>
  104a8e:	83 f8 01             	cmp    $0x1,%eax
  104a91:	74 24                	je     104ab7 <check_pgdir+0x3c9>
  104a93:	c7 44 24 0c 92 6c 10 	movl   $0x106c92,0xc(%esp)
  104a9a:	00 
  104a9b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104aa2:	00 
  104aa3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104aaa:	00 
  104aab:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104ab2:	e8 0f c2 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104ab7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104abc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104ac3:	00 
  104ac4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104acb:	00 
  104acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104acf:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ad3:	89 04 24             	mov    %eax,(%esp)
  104ad6:	e8 df fa ff ff       	call   1045ba <page_insert>
  104adb:	85 c0                	test   %eax,%eax
  104add:	74 24                	je     104b03 <check_pgdir+0x415>
  104adf:	c7 44 24 0c a4 6c 10 	movl   $0x106ca4,0xc(%esp)
  104ae6:	00 
  104ae7:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104aee:	00 
  104aef:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104af6:	00 
  104af7:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104afe:	e8 c3 c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b06:	89 04 24             	mov    %eax,(%esp)
  104b09:	e8 1d ef ff ff       	call   103a2b <page_ref>
  104b0e:	83 f8 02             	cmp    $0x2,%eax
  104b11:	74 24                	je     104b37 <check_pgdir+0x449>
  104b13:	c7 44 24 0c d0 6c 10 	movl   $0x106cd0,0xc(%esp)
  104b1a:	00 
  104b1b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b22:	00 
  104b23:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b2a:	00 
  104b2b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104b32:	e8 8f c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b3a:	89 04 24             	mov    %eax,(%esp)
  104b3d:	e8 e9 ee ff ff       	call   103a2b <page_ref>
  104b42:	85 c0                	test   %eax,%eax
  104b44:	74 24                	je     104b6a <check_pgdir+0x47c>
  104b46:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104b4d:	00 
  104b4e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b55:	00 
  104b56:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104b5d:	00 
  104b5e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104b65:	e8 5c c1 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b6a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b76:	00 
  104b77:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b7e:	00 
  104b7f:	89 04 24             	mov    %eax,(%esp)
  104b82:	e8 e8 f7 ff ff       	call   10436f <get_pte>
  104b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b8e:	75 24                	jne    104bb4 <check_pgdir+0x4c6>
  104b90:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  104b97:	00 
  104b98:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b9f:	00 
  104ba0:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104ba7:	00 
  104ba8:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104baf:	e8 12 c1 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bb7:	8b 00                	mov    (%eax),%eax
  104bb9:	89 04 24             	mov    %eax,(%esp)
  104bbc:	e8 89 ed ff ff       	call   10394a <pa2page>
  104bc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104bc4:	74 24                	je     104bea <check_pgdir+0x4fc>
  104bc6:	c7 44 24 0c a9 6b 10 	movl   $0x106ba9,0xc(%esp)
  104bcd:	00 
  104bce:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104bd5:	00 
  104bd6:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104bdd:	00 
  104bde:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104be5:	e8 dc c0 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bed:	8b 00                	mov    (%eax),%eax
  104bef:	83 e0 04             	and    $0x4,%eax
  104bf2:	85 c0                	test   %eax,%eax
  104bf4:	74 24                	je     104c1a <check_pgdir+0x52c>
  104bf6:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  104bfd:	00 
  104bfe:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104c05:	00 
  104c06:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104c0d:	00 
  104c0e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104c15:	e8 ac c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104c1a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c26:	00 
  104c27:	89 04 24             	mov    %eax,(%esp)
  104c2a:	e8 47 f9 ff ff       	call   104576 <page_remove>
    assert(page_ref(p1) == 1);
  104c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c32:	89 04 24             	mov    %eax,(%esp)
  104c35:	e8 f1 ed ff ff       	call   103a2b <page_ref>
  104c3a:	83 f8 01             	cmp    $0x1,%eax
  104c3d:	74 24                	je     104c63 <check_pgdir+0x575>
  104c3f:	c7 44 24 0c be 6b 10 	movl   $0x106bbe,0xc(%esp)
  104c46:	00 
  104c47:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104c4e:	00 
  104c4f:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104c56:	00 
  104c57:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104c5e:	e8 63 c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c66:	89 04 24             	mov    %eax,(%esp)
  104c69:	e8 bd ed ff ff       	call   103a2b <page_ref>
  104c6e:	85 c0                	test   %eax,%eax
  104c70:	74 24                	je     104c96 <check_pgdir+0x5a8>
  104c72:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104c79:	00 
  104c7a:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104c81:	00 
  104c82:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104c89:	00 
  104c8a:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104c91:	e8 30 c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104c96:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c9b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ca2:	00 
  104ca3:	89 04 24             	mov    %eax,(%esp)
  104ca6:	e8 cb f8 ff ff       	call   104576 <page_remove>
    assert(page_ref(p1) == 0);
  104cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cae:	89 04 24             	mov    %eax,(%esp)
  104cb1:	e8 75 ed ff ff       	call   103a2b <page_ref>
  104cb6:	85 c0                	test   %eax,%eax
  104cb8:	74 24                	je     104cde <check_pgdir+0x5f0>
  104cba:	c7 44 24 0c 09 6d 10 	movl   $0x106d09,0xc(%esp)
  104cc1:	00 
  104cc2:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104cc9:	00 
  104cca:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104cd1:	00 
  104cd2:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104cd9:	e8 e8 bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ce1:	89 04 24             	mov    %eax,(%esp)
  104ce4:	e8 42 ed ff ff       	call   103a2b <page_ref>
  104ce9:	85 c0                	test   %eax,%eax
  104ceb:	74 24                	je     104d11 <check_pgdir+0x623>
  104ced:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104cf4:	00 
  104cf5:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104cfc:	00 
  104cfd:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104d04:	00 
  104d05:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104d0c:	e8 b5 bf ff ff       	call   100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104d11:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d16:	8b 00                	mov    (%eax),%eax
  104d18:	89 04 24             	mov    %eax,(%esp)
  104d1b:	e8 2a ec ff ff       	call   10394a <pa2page>
  104d20:	89 04 24             	mov    %eax,(%esp)
  104d23:	e8 03 ed ff ff       	call   103a2b <page_ref>
  104d28:	83 f8 01             	cmp    $0x1,%eax
  104d2b:	74 24                	je     104d51 <check_pgdir+0x663>
  104d2d:	c7 44 24 0c 1c 6d 10 	movl   $0x106d1c,0xc(%esp)
  104d34:	00 
  104d35:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104d3c:	00 
  104d3d:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104d44:	00 
  104d45:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104d4c:	e8 75 bf ff ff       	call   100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104d51:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d56:	8b 00                	mov    (%eax),%eax
  104d58:	89 04 24             	mov    %eax,(%esp)
  104d5b:	e8 ea eb ff ff       	call   10394a <pa2page>
  104d60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d67:	00 
  104d68:	89 04 24             	mov    %eax,(%esp)
  104d6b:	e8 f8 ee ff ff       	call   103c68 <free_pages>
    boot_pgdir[0] = 0;
  104d70:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104d7b:	c7 04 24 42 6d 10 00 	movl   $0x106d42,(%esp)
  104d82:	e8 b5 b5 ff ff       	call   10033c <cprintf>
}
  104d87:	c9                   	leave  
  104d88:	c3                   	ret    

00104d89 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104d89:	55                   	push   %ebp
  104d8a:	89 e5                	mov    %esp,%ebp
  104d8c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d96:	e9 ca 00 00 00       	jmp    104e65 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104da4:	c1 e8 0c             	shr    $0xc,%eax
  104da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104daa:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104daf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104db2:	72 23                	jb     104dd7 <check_boot_pgdir+0x4e>
  104db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104db7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104dbb:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104dc2:	00 
  104dc3:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104dca:	00 
  104dcb:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104dd2:	e8 ef be ff ff       	call   100cc6 <__panic>
  104dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dda:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ddf:	89 c2                	mov    %eax,%edx
  104de1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104de6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ded:	00 
  104dee:	89 54 24 04          	mov    %edx,0x4(%esp)
  104df2:	89 04 24             	mov    %eax,(%esp)
  104df5:	e8 75 f5 ff ff       	call   10436f <get_pte>
  104dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104dfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e01:	75 24                	jne    104e27 <check_boot_pgdir+0x9e>
  104e03:	c7 44 24 0c 5c 6d 10 	movl   $0x106d5c,0xc(%esp)
  104e0a:	00 
  104e0b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104e12:	00 
  104e13:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104e1a:	00 
  104e1b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104e22:	e8 9f be ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e2a:	8b 00                	mov    (%eax),%eax
  104e2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e31:	89 c2                	mov    %eax,%edx
  104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e36:	39 c2                	cmp    %eax,%edx
  104e38:	74 24                	je     104e5e <check_boot_pgdir+0xd5>
  104e3a:	c7 44 24 0c 99 6d 10 	movl   $0x106d99,0xc(%esp)
  104e41:	00 
  104e42:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104e49:	00 
  104e4a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104e51:	00 
  104e52:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104e59:	e8 68 be ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e5e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e68:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e6d:	39 c2                	cmp    %eax,%edx
  104e6f:	0f 82 26 ff ff ff    	jb     104d9b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104e75:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e7a:	05 ac 0f 00 00       	add    $0xfac,%eax
  104e7f:	8b 00                	mov    (%eax),%eax
  104e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e86:	89 c2                	mov    %eax,%edx
  104e88:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e90:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104e97:	77 23                	ja     104ebc <check_boot_pgdir+0x133>
  104e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ea0:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  104ea7:	00 
  104ea8:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104eaf:	00 
  104eb0:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104eb7:	e8 0a be ff ff       	call   100cc6 <__panic>
  104ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ebf:	05 00 00 00 40       	add    $0x40000000,%eax
  104ec4:	39 c2                	cmp    %eax,%edx
  104ec6:	74 24                	je     104eec <check_boot_pgdir+0x163>
  104ec8:	c7 44 24 0c b0 6d 10 	movl   $0x106db0,0xc(%esp)
  104ecf:	00 
  104ed0:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104ed7:	00 
  104ed8:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104edf:	00 
  104ee0:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104ee7:	e8 da bd ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104eec:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ef1:	8b 00                	mov    (%eax),%eax
  104ef3:	85 c0                	test   %eax,%eax
  104ef5:	74 24                	je     104f1b <check_boot_pgdir+0x192>
  104ef7:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104efe:	00 
  104eff:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104f06:	00 
  104f07:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  104f0e:	00 
  104f0f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104f16:	e8 ab bd ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104f1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f22:	e8 09 ed ff ff       	call   103c30 <alloc_pages>
  104f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104f2a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f2f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f36:	00 
  104f37:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104f3e:	00 
  104f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f42:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f46:	89 04 24             	mov    %eax,(%esp)
  104f49:	e8 6c f6 ff ff       	call   1045ba <page_insert>
  104f4e:	85 c0                	test   %eax,%eax
  104f50:	74 24                	je     104f76 <check_boot_pgdir+0x1ed>
  104f52:	c7 44 24 0c f8 6d 10 	movl   $0x106df8,0xc(%esp)
  104f59:	00 
  104f5a:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104f61:	00 
  104f62:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  104f69:	00 
  104f6a:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104f71:	e8 50 bd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  104f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f79:	89 04 24             	mov    %eax,(%esp)
  104f7c:	e8 aa ea ff ff       	call   103a2b <page_ref>
  104f81:	83 f8 01             	cmp    $0x1,%eax
  104f84:	74 24                	je     104faa <check_boot_pgdir+0x221>
  104f86:	c7 44 24 0c 26 6e 10 	movl   $0x106e26,0xc(%esp)
  104f8d:	00 
  104f8e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104f95:	00 
  104f96:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  104f9d:	00 
  104f9e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104fa5:	e8 1c bd ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104faa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104faf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fb6:	00 
  104fb7:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104fbe:	00 
  104fbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fc6:	89 04 24             	mov    %eax,(%esp)
  104fc9:	e8 ec f5 ff ff       	call   1045ba <page_insert>
  104fce:	85 c0                	test   %eax,%eax
  104fd0:	74 24                	je     104ff6 <check_boot_pgdir+0x26d>
  104fd2:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104fd9:	00 
  104fda:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104fe1:	00 
  104fe2:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  104fe9:	00 
  104fea:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104ff1:	e8 d0 bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  104ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ff9:	89 04 24             	mov    %eax,(%esp)
  104ffc:	e8 2a ea ff ff       	call   103a2b <page_ref>
  105001:	83 f8 02             	cmp    $0x2,%eax
  105004:	74 24                	je     10502a <check_boot_pgdir+0x2a1>
  105006:	c7 44 24 0c 6f 6e 10 	movl   $0x106e6f,0xc(%esp)
  10500d:	00 
  10500e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  105015:	00 
  105016:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10501d:	00 
  10501e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  105025:	e8 9c bc ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  10502a:	c7 45 dc 80 6e 10 00 	movl   $0x106e80,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105034:	89 44 24 04          	mov    %eax,0x4(%esp)
  105038:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10503f:	e8 1e 0a 00 00       	call   105a62 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105044:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10504b:	00 
  10504c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105053:	e8 83 0a 00 00       	call   105adb <strcmp>
  105058:	85 c0                	test   %eax,%eax
  10505a:	74 24                	je     105080 <check_boot_pgdir+0x2f7>
  10505c:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  105063:	00 
  105064:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10506b:	00 
  10506c:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  105073:	00 
  105074:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10507b:	e8 46 bc ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105083:	89 04 24             	mov    %eax,(%esp)
  105086:	e8 0e e9 ff ff       	call   103999 <page2kva>
  10508b:	05 00 01 00 00       	add    $0x100,%eax
  105090:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105093:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10509a:	e8 6b 09 00 00       	call   105a0a <strlen>
  10509f:	85 c0                	test   %eax,%eax
  1050a1:	74 24                	je     1050c7 <check_boot_pgdir+0x33e>
  1050a3:	c7 44 24 0c d0 6e 10 	movl   $0x106ed0,0xc(%esp)
  1050aa:	00 
  1050ab:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1050b2:	00 
  1050b3:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  1050ba:	00 
  1050bb:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1050c2:	e8 ff bb ff ff       	call   100cc6 <__panic>

    free_page(p);
  1050c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050ce:	00 
  1050cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050d2:	89 04 24             	mov    %eax,(%esp)
  1050d5:	e8 8e eb ff ff       	call   103c68 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1050da:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050df:	8b 00                	mov    (%eax),%eax
  1050e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050e6:	89 04 24             	mov    %eax,(%esp)
  1050e9:	e8 5c e8 ff ff       	call   10394a <pa2page>
  1050ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050f5:	00 
  1050f6:	89 04 24             	mov    %eax,(%esp)
  1050f9:	e8 6a eb ff ff       	call   103c68 <free_pages>
    boot_pgdir[0] = 0;
  1050fe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105109:	c7 04 24 f4 6e 10 00 	movl   $0x106ef4,(%esp)
  105110:	e8 27 b2 ff ff       	call   10033c <cprintf>
}
  105115:	c9                   	leave  
  105116:	c3                   	ret    

00105117 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105117:	55                   	push   %ebp
  105118:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10511a:	8b 45 08             	mov    0x8(%ebp),%eax
  10511d:	83 e0 04             	and    $0x4,%eax
  105120:	85 c0                	test   %eax,%eax
  105122:	74 07                	je     10512b <perm2str+0x14>
  105124:	b8 75 00 00 00       	mov    $0x75,%eax
  105129:	eb 05                	jmp    105130 <perm2str+0x19>
  10512b:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105130:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105135:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10513c:	8b 45 08             	mov    0x8(%ebp),%eax
  10513f:	83 e0 02             	and    $0x2,%eax
  105142:	85 c0                	test   %eax,%eax
  105144:	74 07                	je     10514d <perm2str+0x36>
  105146:	b8 77 00 00 00       	mov    $0x77,%eax
  10514b:	eb 05                	jmp    105152 <perm2str+0x3b>
  10514d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105152:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105157:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  10515e:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105163:	5d                   	pop    %ebp
  105164:	c3                   	ret    

00105165 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105165:	55                   	push   %ebp
  105166:	89 e5                	mov    %esp,%ebp
  105168:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10516b:	8b 45 10             	mov    0x10(%ebp),%eax
  10516e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105171:	72 0a                	jb     10517d <get_pgtable_items+0x18>
        return 0;
  105173:	b8 00 00 00 00       	mov    $0x0,%eax
  105178:	e9 9c 00 00 00       	jmp    105219 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10517d:	eb 04                	jmp    105183 <get_pgtable_items+0x1e>
        start ++;
  10517f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105183:	8b 45 10             	mov    0x10(%ebp),%eax
  105186:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105189:	73 18                	jae    1051a3 <get_pgtable_items+0x3e>
  10518b:	8b 45 10             	mov    0x10(%ebp),%eax
  10518e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105195:	8b 45 14             	mov    0x14(%ebp),%eax
  105198:	01 d0                	add    %edx,%eax
  10519a:	8b 00                	mov    (%eax),%eax
  10519c:	83 e0 01             	and    $0x1,%eax
  10519f:	85 c0                	test   %eax,%eax
  1051a1:	74 dc                	je     10517f <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1051a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1051a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051a9:	73 69                	jae    105214 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1051ab:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1051af:	74 08                	je     1051b9 <get_pgtable_items+0x54>
            *left_store = start;
  1051b1:	8b 45 18             	mov    0x18(%ebp),%eax
  1051b4:	8b 55 10             	mov    0x10(%ebp),%edx
  1051b7:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1051b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1051bc:	8d 50 01             	lea    0x1(%eax),%edx
  1051bf:	89 55 10             	mov    %edx,0x10(%ebp)
  1051c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051c9:	8b 45 14             	mov    0x14(%ebp),%eax
  1051cc:	01 d0                	add    %edx,%eax
  1051ce:	8b 00                	mov    (%eax),%eax
  1051d0:	83 e0 07             	and    $0x7,%eax
  1051d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051d6:	eb 04                	jmp    1051dc <get_pgtable_items+0x77>
            start ++;
  1051d8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1051df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051e2:	73 1d                	jae    105201 <get_pgtable_items+0x9c>
  1051e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1051e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1051f1:	01 d0                	add    %edx,%eax
  1051f3:	8b 00                	mov    (%eax),%eax
  1051f5:	83 e0 07             	and    $0x7,%eax
  1051f8:	89 c2                	mov    %eax,%edx
  1051fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051fd:	39 c2                	cmp    %eax,%edx
  1051ff:	74 d7                	je     1051d8 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105201:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105205:	74 08                	je     10520f <get_pgtable_items+0xaa>
            *right_store = start;
  105207:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10520a:	8b 55 10             	mov    0x10(%ebp),%edx
  10520d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105212:	eb 05                	jmp    105219 <get_pgtable_items+0xb4>
    }
    return 0;
  105214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105219:	c9                   	leave  
  10521a:	c3                   	ret    

0010521b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10521b:	55                   	push   %ebp
  10521c:	89 e5                	mov    %esp,%ebp
  10521e:	57                   	push   %edi
  10521f:	56                   	push   %esi
  105220:	53                   	push   %ebx
  105221:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105224:	c7 04 24 14 6f 10 00 	movl   $0x106f14,(%esp)
  10522b:	e8 0c b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105230:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105237:	e9 fa 00 00 00       	jmp    105336 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10523c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10523f:	89 04 24             	mov    %eax,(%esp)
  105242:	e8 d0 fe ff ff       	call   105117 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105247:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10524a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10524d:	29 d1                	sub    %edx,%ecx
  10524f:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105251:	89 d6                	mov    %edx,%esi
  105253:	c1 e6 16             	shl    $0x16,%esi
  105256:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105259:	89 d3                	mov    %edx,%ebx
  10525b:	c1 e3 16             	shl    $0x16,%ebx
  10525e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105261:	89 d1                	mov    %edx,%ecx
  105263:	c1 e1 16             	shl    $0x16,%ecx
  105266:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105269:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10526c:	29 d7                	sub    %edx,%edi
  10526e:	89 fa                	mov    %edi,%edx
  105270:	89 44 24 14          	mov    %eax,0x14(%esp)
  105274:	89 74 24 10          	mov    %esi,0x10(%esp)
  105278:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10527c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105280:	89 54 24 04          	mov    %edx,0x4(%esp)
  105284:	c7 04 24 45 6f 10 00 	movl   $0x106f45,(%esp)
  10528b:	e8 ac b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105293:	c1 e0 0a             	shl    $0xa,%eax
  105296:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105299:	eb 54                	jmp    1052ef <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10529b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10529e:	89 04 24             	mov    %eax,(%esp)
  1052a1:	e8 71 fe ff ff       	call   105117 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1052a6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1052a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052ac:	29 d1                	sub    %edx,%ecx
  1052ae:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1052b0:	89 d6                	mov    %edx,%esi
  1052b2:	c1 e6 0c             	shl    $0xc,%esi
  1052b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052b8:	89 d3                	mov    %edx,%ebx
  1052ba:	c1 e3 0c             	shl    $0xc,%ebx
  1052bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052c0:	c1 e2 0c             	shl    $0xc,%edx
  1052c3:	89 d1                	mov    %edx,%ecx
  1052c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1052c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052cb:	29 d7                	sub    %edx,%edi
  1052cd:	89 fa                	mov    %edi,%edx
  1052cf:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052d3:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052d7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1052db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1052df:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052e3:	c7 04 24 64 6f 10 00 	movl   $0x106f64,(%esp)
  1052ea:	e8 4d b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1052ef:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1052f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1052f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052fa:	89 ce                	mov    %ecx,%esi
  1052fc:	c1 e6 0a             	shl    $0xa,%esi
  1052ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105302:	89 cb                	mov    %ecx,%ebx
  105304:	c1 e3 0a             	shl    $0xa,%ebx
  105307:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10530a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10530e:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105311:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105315:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105319:	89 44 24 08          	mov    %eax,0x8(%esp)
  10531d:	89 74 24 04          	mov    %esi,0x4(%esp)
  105321:	89 1c 24             	mov    %ebx,(%esp)
  105324:	e8 3c fe ff ff       	call   105165 <get_pgtable_items>
  105329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10532c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105330:	0f 85 65 ff ff ff    	jne    10529b <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105336:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10533b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10533e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105341:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105345:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105348:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10534c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105350:	89 44 24 08          	mov    %eax,0x8(%esp)
  105354:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10535b:	00 
  10535c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105363:	e8 fd fd ff ff       	call   105165 <get_pgtable_items>
  105368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10536b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10536f:	0f 85 c7 fe ff ff    	jne    10523c <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105375:	c7 04 24 88 6f 10 00 	movl   $0x106f88,(%esp)
  10537c:	e8 bb af ff ff       	call   10033c <cprintf>
}
  105381:	83 c4 4c             	add    $0x4c,%esp
  105384:	5b                   	pop    %ebx
  105385:	5e                   	pop    %esi
  105386:	5f                   	pop    %edi
  105387:	5d                   	pop    %ebp
  105388:	c3                   	ret    

00105389 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105389:	55                   	push   %ebp
  10538a:	89 e5                	mov    %esp,%ebp
  10538c:	83 ec 58             	sub    $0x58,%esp
  10538f:	8b 45 10             	mov    0x10(%ebp),%eax
  105392:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105395:	8b 45 14             	mov    0x14(%ebp),%eax
  105398:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10539b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10539e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1053a7:	8b 45 18             	mov    0x18(%ebp),%eax
  1053aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1053b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1053b6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1053b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053c3:	74 1c                	je     1053e1 <printnum+0x58>
  1053c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c8:	ba 00 00 00 00       	mov    $0x0,%edx
  1053cd:	f7 75 e4             	divl   -0x1c(%ebp)
  1053d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1053d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053d6:	ba 00 00 00 00       	mov    $0x0,%edx
  1053db:	f7 75 e4             	divl   -0x1c(%ebp)
  1053de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1053e7:	f7 75 e4             	divl   -0x1c(%ebp)
  1053ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1053ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1053f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1053fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053ff:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105402:	8b 45 18             	mov    0x18(%ebp),%eax
  105405:	ba 00 00 00 00       	mov    $0x0,%edx
  10540a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10540d:	77 56                	ja     105465 <printnum+0xdc>
  10540f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105412:	72 05                	jb     105419 <printnum+0x90>
  105414:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105417:	77 4c                	ja     105465 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105419:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10541c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10541f:	8b 45 20             	mov    0x20(%ebp),%eax
  105422:	89 44 24 18          	mov    %eax,0x18(%esp)
  105426:	89 54 24 14          	mov    %edx,0x14(%esp)
  10542a:	8b 45 18             	mov    0x18(%ebp),%eax
  10542d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105434:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105437:	89 44 24 08          	mov    %eax,0x8(%esp)
  10543b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10543f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105442:	89 44 24 04          	mov    %eax,0x4(%esp)
  105446:	8b 45 08             	mov    0x8(%ebp),%eax
  105449:	89 04 24             	mov    %eax,(%esp)
  10544c:	e8 38 ff ff ff       	call   105389 <printnum>
  105451:	eb 1c                	jmp    10546f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105453:	8b 45 0c             	mov    0xc(%ebp),%eax
  105456:	89 44 24 04          	mov    %eax,0x4(%esp)
  10545a:	8b 45 20             	mov    0x20(%ebp),%eax
  10545d:	89 04 24             	mov    %eax,(%esp)
  105460:	8b 45 08             	mov    0x8(%ebp),%eax
  105463:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105465:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105469:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10546d:	7f e4                	jg     105453 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10546f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105472:	05 3c 70 10 00       	add    $0x10703c,%eax
  105477:	0f b6 00             	movzbl (%eax),%eax
  10547a:	0f be c0             	movsbl %al,%eax
  10547d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105480:	89 54 24 04          	mov    %edx,0x4(%esp)
  105484:	89 04 24             	mov    %eax,(%esp)
  105487:	8b 45 08             	mov    0x8(%ebp),%eax
  10548a:	ff d0                	call   *%eax
}
  10548c:	c9                   	leave  
  10548d:	c3                   	ret    

0010548e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10548e:	55                   	push   %ebp
  10548f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105491:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105495:	7e 14                	jle    1054ab <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105497:	8b 45 08             	mov    0x8(%ebp),%eax
  10549a:	8b 00                	mov    (%eax),%eax
  10549c:	8d 48 08             	lea    0x8(%eax),%ecx
  10549f:	8b 55 08             	mov    0x8(%ebp),%edx
  1054a2:	89 0a                	mov    %ecx,(%edx)
  1054a4:	8b 50 04             	mov    0x4(%eax),%edx
  1054a7:	8b 00                	mov    (%eax),%eax
  1054a9:	eb 30                	jmp    1054db <getuint+0x4d>
    }
    else if (lflag) {
  1054ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1054af:	74 16                	je     1054c7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1054b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1054b4:	8b 00                	mov    (%eax),%eax
  1054b6:	8d 48 04             	lea    0x4(%eax),%ecx
  1054b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1054bc:	89 0a                	mov    %ecx,(%edx)
  1054be:	8b 00                	mov    (%eax),%eax
  1054c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1054c5:	eb 14                	jmp    1054db <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1054c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ca:	8b 00                	mov    (%eax),%eax
  1054cc:	8d 48 04             	lea    0x4(%eax),%ecx
  1054cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1054d2:	89 0a                	mov    %ecx,(%edx)
  1054d4:	8b 00                	mov    (%eax),%eax
  1054d6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1054db:	5d                   	pop    %ebp
  1054dc:	c3                   	ret    

001054dd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1054dd:	55                   	push   %ebp
  1054de:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1054e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1054e4:	7e 14                	jle    1054fa <getint+0x1d>
        return va_arg(*ap, long long);
  1054e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e9:	8b 00                	mov    (%eax),%eax
  1054eb:	8d 48 08             	lea    0x8(%eax),%ecx
  1054ee:	8b 55 08             	mov    0x8(%ebp),%edx
  1054f1:	89 0a                	mov    %ecx,(%edx)
  1054f3:	8b 50 04             	mov    0x4(%eax),%edx
  1054f6:	8b 00                	mov    (%eax),%eax
  1054f8:	eb 28                	jmp    105522 <getint+0x45>
    }
    else if (lflag) {
  1054fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1054fe:	74 12                	je     105512 <getint+0x35>
        return va_arg(*ap, long);
  105500:	8b 45 08             	mov    0x8(%ebp),%eax
  105503:	8b 00                	mov    (%eax),%eax
  105505:	8d 48 04             	lea    0x4(%eax),%ecx
  105508:	8b 55 08             	mov    0x8(%ebp),%edx
  10550b:	89 0a                	mov    %ecx,(%edx)
  10550d:	8b 00                	mov    (%eax),%eax
  10550f:	99                   	cltd   
  105510:	eb 10                	jmp    105522 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105512:	8b 45 08             	mov    0x8(%ebp),%eax
  105515:	8b 00                	mov    (%eax),%eax
  105517:	8d 48 04             	lea    0x4(%eax),%ecx
  10551a:	8b 55 08             	mov    0x8(%ebp),%edx
  10551d:	89 0a                	mov    %ecx,(%edx)
  10551f:	8b 00                	mov    (%eax),%eax
  105521:	99                   	cltd   
    }
}
  105522:	5d                   	pop    %ebp
  105523:	c3                   	ret    

00105524 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105524:	55                   	push   %ebp
  105525:	89 e5                	mov    %esp,%ebp
  105527:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10552a:	8d 45 14             	lea    0x14(%ebp),%eax
  10552d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105537:	8b 45 10             	mov    0x10(%ebp),%eax
  10553a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10553e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105541:	89 44 24 04          	mov    %eax,0x4(%esp)
  105545:	8b 45 08             	mov    0x8(%ebp),%eax
  105548:	89 04 24             	mov    %eax,(%esp)
  10554b:	e8 02 00 00 00       	call   105552 <vprintfmt>
    va_end(ap);
}
  105550:	c9                   	leave  
  105551:	c3                   	ret    

00105552 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105552:	55                   	push   %ebp
  105553:	89 e5                	mov    %esp,%ebp
  105555:	56                   	push   %esi
  105556:	53                   	push   %ebx
  105557:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10555a:	eb 18                	jmp    105574 <vprintfmt+0x22>
            if (ch == '\0') {
  10555c:	85 db                	test   %ebx,%ebx
  10555e:	75 05                	jne    105565 <vprintfmt+0x13>
                return;
  105560:	e9 d1 03 00 00       	jmp    105936 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105565:	8b 45 0c             	mov    0xc(%ebp),%eax
  105568:	89 44 24 04          	mov    %eax,0x4(%esp)
  10556c:	89 1c 24             	mov    %ebx,(%esp)
  10556f:	8b 45 08             	mov    0x8(%ebp),%eax
  105572:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105574:	8b 45 10             	mov    0x10(%ebp),%eax
  105577:	8d 50 01             	lea    0x1(%eax),%edx
  10557a:	89 55 10             	mov    %edx,0x10(%ebp)
  10557d:	0f b6 00             	movzbl (%eax),%eax
  105580:	0f b6 d8             	movzbl %al,%ebx
  105583:	83 fb 25             	cmp    $0x25,%ebx
  105586:	75 d4                	jne    10555c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105588:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10558c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105596:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105599:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1055a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055a3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1055a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1055a9:	8d 50 01             	lea    0x1(%eax),%edx
  1055ac:	89 55 10             	mov    %edx,0x10(%ebp)
  1055af:	0f b6 00             	movzbl (%eax),%eax
  1055b2:	0f b6 d8             	movzbl %al,%ebx
  1055b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1055b8:	83 f8 55             	cmp    $0x55,%eax
  1055bb:	0f 87 44 03 00 00    	ja     105905 <vprintfmt+0x3b3>
  1055c1:	8b 04 85 60 70 10 00 	mov    0x107060(,%eax,4),%eax
  1055c8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1055ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1055ce:	eb d6                	jmp    1055a6 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1055d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1055d4:	eb d0                	jmp    1055a6 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1055d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1055dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055e0:	89 d0                	mov    %edx,%eax
  1055e2:	c1 e0 02             	shl    $0x2,%eax
  1055e5:	01 d0                	add    %edx,%eax
  1055e7:	01 c0                	add    %eax,%eax
  1055e9:	01 d8                	add    %ebx,%eax
  1055eb:	83 e8 30             	sub    $0x30,%eax
  1055ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1055f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1055f4:	0f b6 00             	movzbl (%eax),%eax
  1055f7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1055fa:	83 fb 2f             	cmp    $0x2f,%ebx
  1055fd:	7e 0b                	jle    10560a <vprintfmt+0xb8>
  1055ff:	83 fb 39             	cmp    $0x39,%ebx
  105602:	7f 06                	jg     10560a <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105604:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105608:	eb d3                	jmp    1055dd <vprintfmt+0x8b>
            goto process_precision;
  10560a:	eb 33                	jmp    10563f <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10560c:	8b 45 14             	mov    0x14(%ebp),%eax
  10560f:	8d 50 04             	lea    0x4(%eax),%edx
  105612:	89 55 14             	mov    %edx,0x14(%ebp)
  105615:	8b 00                	mov    (%eax),%eax
  105617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10561a:	eb 23                	jmp    10563f <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10561c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105620:	79 0c                	jns    10562e <vprintfmt+0xdc>
                width = 0;
  105622:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105629:	e9 78 ff ff ff       	jmp    1055a6 <vprintfmt+0x54>
  10562e:	e9 73 ff ff ff       	jmp    1055a6 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10563a:	e9 67 ff ff ff       	jmp    1055a6 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  10563f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105643:	79 12                	jns    105657 <vprintfmt+0x105>
                width = precision, precision = -1;
  105645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105648:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10564b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105652:	e9 4f ff ff ff       	jmp    1055a6 <vprintfmt+0x54>
  105657:	e9 4a ff ff ff       	jmp    1055a6 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10565c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105660:	e9 41 ff ff ff       	jmp    1055a6 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105665:	8b 45 14             	mov    0x14(%ebp),%eax
  105668:	8d 50 04             	lea    0x4(%eax),%edx
  10566b:	89 55 14             	mov    %edx,0x14(%ebp)
  10566e:	8b 00                	mov    (%eax),%eax
  105670:	8b 55 0c             	mov    0xc(%ebp),%edx
  105673:	89 54 24 04          	mov    %edx,0x4(%esp)
  105677:	89 04 24             	mov    %eax,(%esp)
  10567a:	8b 45 08             	mov    0x8(%ebp),%eax
  10567d:	ff d0                	call   *%eax
            break;
  10567f:	e9 ac 02 00 00       	jmp    105930 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105684:	8b 45 14             	mov    0x14(%ebp),%eax
  105687:	8d 50 04             	lea    0x4(%eax),%edx
  10568a:	89 55 14             	mov    %edx,0x14(%ebp)
  10568d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10568f:	85 db                	test   %ebx,%ebx
  105691:	79 02                	jns    105695 <vprintfmt+0x143>
                err = -err;
  105693:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105695:	83 fb 06             	cmp    $0x6,%ebx
  105698:	7f 0b                	jg     1056a5 <vprintfmt+0x153>
  10569a:	8b 34 9d 20 70 10 00 	mov    0x107020(,%ebx,4),%esi
  1056a1:	85 f6                	test   %esi,%esi
  1056a3:	75 23                	jne    1056c8 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1056a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1056a9:	c7 44 24 08 4d 70 10 	movl   $0x10704d,0x8(%esp)
  1056b0:	00 
  1056b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056bb:	89 04 24             	mov    %eax,(%esp)
  1056be:	e8 61 fe ff ff       	call   105524 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1056c3:	e9 68 02 00 00       	jmp    105930 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1056c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1056cc:	c7 44 24 08 56 70 10 	movl   $0x107056,0x8(%esp)
  1056d3:	00 
  1056d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056db:	8b 45 08             	mov    0x8(%ebp),%eax
  1056de:	89 04 24             	mov    %eax,(%esp)
  1056e1:	e8 3e fe ff ff       	call   105524 <printfmt>
            }
            break;
  1056e6:	e9 45 02 00 00       	jmp    105930 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1056eb:	8b 45 14             	mov    0x14(%ebp),%eax
  1056ee:	8d 50 04             	lea    0x4(%eax),%edx
  1056f1:	89 55 14             	mov    %edx,0x14(%ebp)
  1056f4:	8b 30                	mov    (%eax),%esi
  1056f6:	85 f6                	test   %esi,%esi
  1056f8:	75 05                	jne    1056ff <vprintfmt+0x1ad>
                p = "(null)";
  1056fa:	be 59 70 10 00       	mov    $0x107059,%esi
            }
            if (width > 0 && padc != '-') {
  1056ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105703:	7e 3e                	jle    105743 <vprintfmt+0x1f1>
  105705:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105709:	74 38                	je     105743 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10570b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105711:	89 44 24 04          	mov    %eax,0x4(%esp)
  105715:	89 34 24             	mov    %esi,(%esp)
  105718:	e8 15 03 00 00       	call   105a32 <strnlen>
  10571d:	29 c3                	sub    %eax,%ebx
  10571f:	89 d8                	mov    %ebx,%eax
  105721:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105724:	eb 17                	jmp    10573d <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105726:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10572a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10572d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105731:	89 04 24             	mov    %eax,(%esp)
  105734:	8b 45 08             	mov    0x8(%ebp),%eax
  105737:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105739:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10573d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105741:	7f e3                	jg     105726 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105743:	eb 38                	jmp    10577d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105745:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105749:	74 1f                	je     10576a <vprintfmt+0x218>
  10574b:	83 fb 1f             	cmp    $0x1f,%ebx
  10574e:	7e 05                	jle    105755 <vprintfmt+0x203>
  105750:	83 fb 7e             	cmp    $0x7e,%ebx
  105753:	7e 15                	jle    10576a <vprintfmt+0x218>
                    putch('?', putdat);
  105755:	8b 45 0c             	mov    0xc(%ebp),%eax
  105758:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105763:	8b 45 08             	mov    0x8(%ebp),%eax
  105766:	ff d0                	call   *%eax
  105768:	eb 0f                	jmp    105779 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10576a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10576d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105771:	89 1c 24             	mov    %ebx,(%esp)
  105774:	8b 45 08             	mov    0x8(%ebp),%eax
  105777:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105779:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10577d:	89 f0                	mov    %esi,%eax
  10577f:	8d 70 01             	lea    0x1(%eax),%esi
  105782:	0f b6 00             	movzbl (%eax),%eax
  105785:	0f be d8             	movsbl %al,%ebx
  105788:	85 db                	test   %ebx,%ebx
  10578a:	74 10                	je     10579c <vprintfmt+0x24a>
  10578c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105790:	78 b3                	js     105745 <vprintfmt+0x1f3>
  105792:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10579a:	79 a9                	jns    105745 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10579c:	eb 17                	jmp    1057b5 <vprintfmt+0x263>
                putch(' ', putdat);
  10579e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1057ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1057af:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1057b1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057b9:	7f e3                	jg     10579e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1057bb:	e9 70 01 00 00       	jmp    105930 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1057c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c7:	8d 45 14             	lea    0x14(%ebp),%eax
  1057ca:	89 04 24             	mov    %eax,(%esp)
  1057cd:	e8 0b fd ff ff       	call   1054dd <getint>
  1057d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057de:	85 d2                	test   %edx,%edx
  1057e0:	79 26                	jns    105808 <vprintfmt+0x2b6>
                putch('-', putdat);
  1057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1057f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f3:	ff d0                	call   *%eax
                num = -(long long)num;
  1057f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057fb:	f7 d8                	neg    %eax
  1057fd:	83 d2 00             	adc    $0x0,%edx
  105800:	f7 da                	neg    %edx
  105802:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105805:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105808:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10580f:	e9 a8 00 00 00       	jmp    1058bc <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105814:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105817:	89 44 24 04          	mov    %eax,0x4(%esp)
  10581b:	8d 45 14             	lea    0x14(%ebp),%eax
  10581e:	89 04 24             	mov    %eax,(%esp)
  105821:	e8 68 fc ff ff       	call   10548e <getuint>
  105826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105829:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10582c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105833:	e9 84 00 00 00       	jmp    1058bc <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10583b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583f:	8d 45 14             	lea    0x14(%ebp),%eax
  105842:	89 04 24             	mov    %eax,(%esp)
  105845:	e8 44 fc ff ff       	call   10548e <getuint>
  10584a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105850:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105857:	eb 63                	jmp    1058bc <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105859:	8b 45 0c             	mov    0xc(%ebp),%eax
  10585c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105860:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105867:	8b 45 08             	mov    0x8(%ebp),%eax
  10586a:	ff d0                	call   *%eax
            putch('x', putdat);
  10586c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105873:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10587a:	8b 45 08             	mov    0x8(%ebp),%eax
  10587d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10587f:	8b 45 14             	mov    0x14(%ebp),%eax
  105882:	8d 50 04             	lea    0x4(%eax),%edx
  105885:	89 55 14             	mov    %edx,0x14(%ebp)
  105888:	8b 00                	mov    (%eax),%eax
  10588a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10588d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105894:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10589b:	eb 1f                	jmp    1058bc <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10589d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a4:	8d 45 14             	lea    0x14(%ebp),%eax
  1058a7:	89 04 24             	mov    %eax,(%esp)
  1058aa:	e8 df fb ff ff       	call   10548e <getuint>
  1058af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1058b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1058bc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1058c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058c3:	89 54 24 18          	mov    %edx,0x18(%esp)
  1058c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1058ca:	89 54 24 14          	mov    %edx,0x14(%esp)
  1058ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  1058d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1058e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ea:	89 04 24             	mov    %eax,(%esp)
  1058ed:	e8 97 fa ff ff       	call   105389 <printnum>
            break;
  1058f2:	eb 3c                	jmp    105930 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fb:	89 1c 24             	mov    %ebx,(%esp)
  1058fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105901:	ff d0                	call   *%eax
            break;
  105903:	eb 2b                	jmp    105930 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105905:	8b 45 0c             	mov    0xc(%ebp),%eax
  105908:	89 44 24 04          	mov    %eax,0x4(%esp)
  10590c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105913:	8b 45 08             	mov    0x8(%ebp),%eax
  105916:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105918:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10591c:	eb 04                	jmp    105922 <vprintfmt+0x3d0>
  10591e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105922:	8b 45 10             	mov    0x10(%ebp),%eax
  105925:	83 e8 01             	sub    $0x1,%eax
  105928:	0f b6 00             	movzbl (%eax),%eax
  10592b:	3c 25                	cmp    $0x25,%al
  10592d:	75 ef                	jne    10591e <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  10592f:	90                   	nop
        }
    }
  105930:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105931:	e9 3e fc ff ff       	jmp    105574 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105936:	83 c4 40             	add    $0x40,%esp
  105939:	5b                   	pop    %ebx
  10593a:	5e                   	pop    %esi
  10593b:	5d                   	pop    %ebp
  10593c:	c3                   	ret    

0010593d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10593d:	55                   	push   %ebp
  10593e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105940:	8b 45 0c             	mov    0xc(%ebp),%eax
  105943:	8b 40 08             	mov    0x8(%eax),%eax
  105946:	8d 50 01             	lea    0x1(%eax),%edx
  105949:	8b 45 0c             	mov    0xc(%ebp),%eax
  10594c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10594f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105952:	8b 10                	mov    (%eax),%edx
  105954:	8b 45 0c             	mov    0xc(%ebp),%eax
  105957:	8b 40 04             	mov    0x4(%eax),%eax
  10595a:	39 c2                	cmp    %eax,%edx
  10595c:	73 12                	jae    105970 <sprintputch+0x33>
        *b->buf ++ = ch;
  10595e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105961:	8b 00                	mov    (%eax),%eax
  105963:	8d 48 01             	lea    0x1(%eax),%ecx
  105966:	8b 55 0c             	mov    0xc(%ebp),%edx
  105969:	89 0a                	mov    %ecx,(%edx)
  10596b:	8b 55 08             	mov    0x8(%ebp),%edx
  10596e:	88 10                	mov    %dl,(%eax)
    }
}
  105970:	5d                   	pop    %ebp
  105971:	c3                   	ret    

00105972 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105972:	55                   	push   %ebp
  105973:	89 e5                	mov    %esp,%ebp
  105975:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105978:	8d 45 14             	lea    0x14(%ebp),%eax
  10597b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10597e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105981:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105985:	8b 45 10             	mov    0x10(%ebp),%eax
  105988:	89 44 24 08          	mov    %eax,0x8(%esp)
  10598c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10598f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105993:	8b 45 08             	mov    0x8(%ebp),%eax
  105996:	89 04 24             	mov    %eax,(%esp)
  105999:	e8 08 00 00 00       	call   1059a6 <vsnprintf>
  10599e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1059a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1059a4:	c9                   	leave  
  1059a5:	c3                   	ret    

001059a6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1059a6:	55                   	push   %ebp
  1059a7:	89 e5                	mov    %esp,%ebp
  1059a9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1059ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1059af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bb:	01 d0                	add    %edx,%eax
  1059bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1059c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1059cb:	74 0a                	je     1059d7 <vsnprintf+0x31>
  1059cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1059d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059d3:	39 c2                	cmp    %eax,%edx
  1059d5:	76 07                	jbe    1059de <vsnprintf+0x38>
        return -E_INVAL;
  1059d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1059dc:	eb 2a                	jmp    105a08 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1059de:	8b 45 14             	mov    0x14(%ebp),%eax
  1059e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1059e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1059e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1059ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f3:	c7 04 24 3d 59 10 00 	movl   $0x10593d,(%esp)
  1059fa:	e8 53 fb ff ff       	call   105552 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1059ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a02:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a08:	c9                   	leave  
  105a09:	c3                   	ret    

00105a0a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a0a:	55                   	push   %ebp
  105a0b:	89 e5                	mov    %esp,%ebp
  105a0d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105a17:	eb 04                	jmp    105a1d <strlen+0x13>
        cnt ++;
  105a19:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a20:	8d 50 01             	lea    0x1(%eax),%edx
  105a23:	89 55 08             	mov    %edx,0x8(%ebp)
  105a26:	0f b6 00             	movzbl (%eax),%eax
  105a29:	84 c0                	test   %al,%al
  105a2b:	75 ec                	jne    105a19 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a30:	c9                   	leave  
  105a31:	c3                   	ret    

00105a32 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105a32:	55                   	push   %ebp
  105a33:	89 e5                	mov    %esp,%ebp
  105a35:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105a3f:	eb 04                	jmp    105a45 <strnlen+0x13>
        cnt ++;
  105a41:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105a4b:	73 10                	jae    105a5d <strnlen+0x2b>
  105a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a50:	8d 50 01             	lea    0x1(%eax),%edx
  105a53:	89 55 08             	mov    %edx,0x8(%ebp)
  105a56:	0f b6 00             	movzbl (%eax),%eax
  105a59:	84 c0                	test   %al,%al
  105a5b:	75 e4                	jne    105a41 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a60:	c9                   	leave  
  105a61:	c3                   	ret    

00105a62 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105a62:	55                   	push   %ebp
  105a63:	89 e5                	mov    %esp,%ebp
  105a65:	57                   	push   %edi
  105a66:	56                   	push   %esi
  105a67:	83 ec 20             	sub    $0x20,%esp
  105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a7c:	89 d1                	mov    %edx,%ecx
  105a7e:	89 c2                	mov    %eax,%edx
  105a80:	89 ce                	mov    %ecx,%esi
  105a82:	89 d7                	mov    %edx,%edi
  105a84:	ac                   	lods   %ds:(%esi),%al
  105a85:	aa                   	stos   %al,%es:(%edi)
  105a86:	84 c0                	test   %al,%al
  105a88:	75 fa                	jne    105a84 <strcpy+0x22>
  105a8a:	89 fa                	mov    %edi,%edx
  105a8c:	89 f1                	mov    %esi,%ecx
  105a8e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a91:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105a9a:	83 c4 20             	add    $0x20,%esp
  105a9d:	5e                   	pop    %esi
  105a9e:	5f                   	pop    %edi
  105a9f:	5d                   	pop    %ebp
  105aa0:	c3                   	ret    

00105aa1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105aa1:	55                   	push   %ebp
  105aa2:	89 e5                	mov    %esp,%ebp
  105aa4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105aad:	eb 21                	jmp    105ad0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ab2:	0f b6 10             	movzbl (%eax),%edx
  105ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ab8:	88 10                	mov    %dl,(%eax)
  105aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105abd:	0f b6 00             	movzbl (%eax),%eax
  105ac0:	84 c0                	test   %al,%al
  105ac2:	74 04                	je     105ac8 <strncpy+0x27>
            src ++;
  105ac4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105ac8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105acc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ad4:	75 d9                	jne    105aaf <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ad9:	c9                   	leave  
  105ada:	c3                   	ret    

00105adb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105adb:	55                   	push   %ebp
  105adc:	89 e5                	mov    %esp,%ebp
  105ade:	57                   	push   %edi
  105adf:	56                   	push   %esi
  105ae0:	83 ec 20             	sub    $0x20,%esp
  105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105af5:	89 d1                	mov    %edx,%ecx
  105af7:	89 c2                	mov    %eax,%edx
  105af9:	89 ce                	mov    %ecx,%esi
  105afb:	89 d7                	mov    %edx,%edi
  105afd:	ac                   	lods   %ds:(%esi),%al
  105afe:	ae                   	scas   %es:(%edi),%al
  105aff:	75 08                	jne    105b09 <strcmp+0x2e>
  105b01:	84 c0                	test   %al,%al
  105b03:	75 f8                	jne    105afd <strcmp+0x22>
  105b05:	31 c0                	xor    %eax,%eax
  105b07:	eb 04                	jmp    105b0d <strcmp+0x32>
  105b09:	19 c0                	sbb    %eax,%eax
  105b0b:	0c 01                	or     $0x1,%al
  105b0d:	89 fa                	mov    %edi,%edx
  105b0f:	89 f1                	mov    %esi,%ecx
  105b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b1d:	83 c4 20             	add    $0x20,%esp
  105b20:	5e                   	pop    %esi
  105b21:	5f                   	pop    %edi
  105b22:	5d                   	pop    %ebp
  105b23:	c3                   	ret    

00105b24 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105b24:	55                   	push   %ebp
  105b25:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b27:	eb 0c                	jmp    105b35 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105b29:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b31:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b39:	74 1a                	je     105b55 <strncmp+0x31>
  105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3e:	0f b6 00             	movzbl (%eax),%eax
  105b41:	84 c0                	test   %al,%al
  105b43:	74 10                	je     105b55 <strncmp+0x31>
  105b45:	8b 45 08             	mov    0x8(%ebp),%eax
  105b48:	0f b6 10             	movzbl (%eax),%edx
  105b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4e:	0f b6 00             	movzbl (%eax),%eax
  105b51:	38 c2                	cmp    %al,%dl
  105b53:	74 d4                	je     105b29 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b59:	74 18                	je     105b73 <strncmp+0x4f>
  105b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5e:	0f b6 00             	movzbl (%eax),%eax
  105b61:	0f b6 d0             	movzbl %al,%edx
  105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b67:	0f b6 00             	movzbl (%eax),%eax
  105b6a:	0f b6 c0             	movzbl %al,%eax
  105b6d:	29 c2                	sub    %eax,%edx
  105b6f:	89 d0                	mov    %edx,%eax
  105b71:	eb 05                	jmp    105b78 <strncmp+0x54>
  105b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b78:	5d                   	pop    %ebp
  105b79:	c3                   	ret    

00105b7a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105b7a:	55                   	push   %ebp
  105b7b:	89 e5                	mov    %esp,%ebp
  105b7d:	83 ec 04             	sub    $0x4,%esp
  105b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b83:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b86:	eb 14                	jmp    105b9c <strchr+0x22>
        if (*s == c) {
  105b88:	8b 45 08             	mov    0x8(%ebp),%eax
  105b8b:	0f b6 00             	movzbl (%eax),%eax
  105b8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b91:	75 05                	jne    105b98 <strchr+0x1e>
            return (char *)s;
  105b93:	8b 45 08             	mov    0x8(%ebp),%eax
  105b96:	eb 13                	jmp    105bab <strchr+0x31>
        }
        s ++;
  105b98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b9f:	0f b6 00             	movzbl (%eax),%eax
  105ba2:	84 c0                	test   %al,%al
  105ba4:	75 e2                	jne    105b88 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bab:	c9                   	leave  
  105bac:	c3                   	ret    

00105bad <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105bad:	55                   	push   %ebp
  105bae:	89 e5                	mov    %esp,%ebp
  105bb0:	83 ec 04             	sub    $0x4,%esp
  105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105bb9:	eb 11                	jmp    105bcc <strfind+0x1f>
        if (*s == c) {
  105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbe:	0f b6 00             	movzbl (%eax),%eax
  105bc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105bc4:	75 02                	jne    105bc8 <strfind+0x1b>
            break;
  105bc6:	eb 0e                	jmp    105bd6 <strfind+0x29>
        }
        s ++;
  105bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcf:	0f b6 00             	movzbl (%eax),%eax
  105bd2:	84 c0                	test   %al,%al
  105bd4:	75 e5                	jne    105bbb <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105bd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bd9:	c9                   	leave  
  105bda:	c3                   	ret    

00105bdb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105bdb:	55                   	push   %ebp
  105bdc:	89 e5                	mov    %esp,%ebp
  105bde:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105be8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105bef:	eb 04                	jmp    105bf5 <strtol+0x1a>
        s ++;
  105bf1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf8:	0f b6 00             	movzbl (%eax),%eax
  105bfb:	3c 20                	cmp    $0x20,%al
  105bfd:	74 f2                	je     105bf1 <strtol+0x16>
  105bff:	8b 45 08             	mov    0x8(%ebp),%eax
  105c02:	0f b6 00             	movzbl (%eax),%eax
  105c05:	3c 09                	cmp    $0x9,%al
  105c07:	74 e8                	je     105bf1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105c09:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0c:	0f b6 00             	movzbl (%eax),%eax
  105c0f:	3c 2b                	cmp    $0x2b,%al
  105c11:	75 06                	jne    105c19 <strtol+0x3e>
        s ++;
  105c13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c17:	eb 15                	jmp    105c2e <strtol+0x53>
    }
    else if (*s == '-') {
  105c19:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1c:	0f b6 00             	movzbl (%eax),%eax
  105c1f:	3c 2d                	cmp    $0x2d,%al
  105c21:	75 0b                	jne    105c2e <strtol+0x53>
        s ++, neg = 1;
  105c23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c32:	74 06                	je     105c3a <strtol+0x5f>
  105c34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105c38:	75 24                	jne    105c5e <strtol+0x83>
  105c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3d:	0f b6 00             	movzbl (%eax),%eax
  105c40:	3c 30                	cmp    $0x30,%al
  105c42:	75 1a                	jne    105c5e <strtol+0x83>
  105c44:	8b 45 08             	mov    0x8(%ebp),%eax
  105c47:	83 c0 01             	add    $0x1,%eax
  105c4a:	0f b6 00             	movzbl (%eax),%eax
  105c4d:	3c 78                	cmp    $0x78,%al
  105c4f:	75 0d                	jne    105c5e <strtol+0x83>
        s += 2, base = 16;
  105c51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105c55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105c5c:	eb 2a                	jmp    105c88 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c62:	75 17                	jne    105c7b <strtol+0xa0>
  105c64:	8b 45 08             	mov    0x8(%ebp),%eax
  105c67:	0f b6 00             	movzbl (%eax),%eax
  105c6a:	3c 30                	cmp    $0x30,%al
  105c6c:	75 0d                	jne    105c7b <strtol+0xa0>
        s ++, base = 8;
  105c6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c72:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105c79:	eb 0d                	jmp    105c88 <strtol+0xad>
    }
    else if (base == 0) {
  105c7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c7f:	75 07                	jne    105c88 <strtol+0xad>
        base = 10;
  105c81:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105c88:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8b:	0f b6 00             	movzbl (%eax),%eax
  105c8e:	3c 2f                	cmp    $0x2f,%al
  105c90:	7e 1b                	jle    105cad <strtol+0xd2>
  105c92:	8b 45 08             	mov    0x8(%ebp),%eax
  105c95:	0f b6 00             	movzbl (%eax),%eax
  105c98:	3c 39                	cmp    $0x39,%al
  105c9a:	7f 11                	jg     105cad <strtol+0xd2>
            dig = *s - '0';
  105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9f:	0f b6 00             	movzbl (%eax),%eax
  105ca2:	0f be c0             	movsbl %al,%eax
  105ca5:	83 e8 30             	sub    $0x30,%eax
  105ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cab:	eb 48                	jmp    105cf5 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105cad:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb0:	0f b6 00             	movzbl (%eax),%eax
  105cb3:	3c 60                	cmp    $0x60,%al
  105cb5:	7e 1b                	jle    105cd2 <strtol+0xf7>
  105cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cba:	0f b6 00             	movzbl (%eax),%eax
  105cbd:	3c 7a                	cmp    $0x7a,%al
  105cbf:	7f 11                	jg     105cd2 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc4:	0f b6 00             	movzbl (%eax),%eax
  105cc7:	0f be c0             	movsbl %al,%eax
  105cca:	83 e8 57             	sub    $0x57,%eax
  105ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cd0:	eb 23                	jmp    105cf5 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd5:	0f b6 00             	movzbl (%eax),%eax
  105cd8:	3c 40                	cmp    $0x40,%al
  105cda:	7e 3d                	jle    105d19 <strtol+0x13e>
  105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdf:	0f b6 00             	movzbl (%eax),%eax
  105ce2:	3c 5a                	cmp    $0x5a,%al
  105ce4:	7f 33                	jg     105d19 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce9:	0f b6 00             	movzbl (%eax),%eax
  105cec:	0f be c0             	movsbl %al,%eax
  105cef:	83 e8 37             	sub    $0x37,%eax
  105cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cf8:	3b 45 10             	cmp    0x10(%ebp),%eax
  105cfb:	7c 02                	jl     105cff <strtol+0x124>
            break;
  105cfd:	eb 1a                	jmp    105d19 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105cff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d06:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d0a:	89 c2                	mov    %eax,%edx
  105d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d0f:	01 d0                	add    %edx,%eax
  105d11:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105d14:	e9 6f ff ff ff       	jmp    105c88 <strtol+0xad>

    if (endptr) {
  105d19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d1d:	74 08                	je     105d27 <strtol+0x14c>
        *endptr = (char *) s;
  105d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d22:	8b 55 08             	mov    0x8(%ebp),%edx
  105d25:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105d27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105d2b:	74 07                	je     105d34 <strtol+0x159>
  105d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d30:	f7 d8                	neg    %eax
  105d32:	eb 03                	jmp    105d37 <strtol+0x15c>
  105d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105d37:	c9                   	leave  
  105d38:	c3                   	ret    

00105d39 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105d39:	55                   	push   %ebp
  105d3a:	89 e5                	mov    %esp,%ebp
  105d3c:	57                   	push   %edi
  105d3d:	83 ec 24             	sub    $0x24,%esp
  105d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d43:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105d46:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  105d4d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105d50:	88 45 f7             	mov    %al,-0x9(%ebp)
  105d53:	8b 45 10             	mov    0x10(%ebp),%eax
  105d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105d59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105d5c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105d60:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105d63:	89 d7                	mov    %edx,%edi
  105d65:	f3 aa                	rep stos %al,%es:(%edi)
  105d67:	89 fa                	mov    %edi,%edx
  105d69:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d6c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105d6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105d72:	83 c4 24             	add    $0x24,%esp
  105d75:	5f                   	pop    %edi
  105d76:	5d                   	pop    %ebp
  105d77:	c3                   	ret    

00105d78 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105d78:	55                   	push   %ebp
  105d79:	89 e5                	mov    %esp,%ebp
  105d7b:	57                   	push   %edi
  105d7c:	56                   	push   %esi
  105d7d:	53                   	push   %ebx
  105d7e:	83 ec 30             	sub    $0x30,%esp
  105d81:	8b 45 08             	mov    0x8(%ebp),%eax
  105d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  105d90:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105d99:	73 42                	jae    105ddd <memmove+0x65>
  105d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105da4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105daa:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105db0:	c1 e8 02             	shr    $0x2,%eax
  105db3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105db5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dbb:	89 d7                	mov    %edx,%edi
  105dbd:	89 c6                	mov    %eax,%esi
  105dbf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105dc1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105dc4:	83 e1 03             	and    $0x3,%ecx
  105dc7:	74 02                	je     105dcb <memmove+0x53>
  105dc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105dcb:	89 f0                	mov    %esi,%eax
  105dcd:	89 fa                	mov    %edi,%edx
  105dcf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105dd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105dd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ddb:	eb 36                	jmp    105e13 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105de0:	8d 50 ff             	lea    -0x1(%eax),%edx
  105de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105de6:	01 c2                	add    %eax,%edx
  105de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105deb:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105df1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105df7:	89 c1                	mov    %eax,%ecx
  105df9:	89 d8                	mov    %ebx,%eax
  105dfb:	89 d6                	mov    %edx,%esi
  105dfd:	89 c7                	mov    %eax,%edi
  105dff:	fd                   	std    
  105e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e02:	fc                   	cld    
  105e03:	89 f8                	mov    %edi,%eax
  105e05:	89 f2                	mov    %esi,%edx
  105e07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e0a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105e13:	83 c4 30             	add    $0x30,%esp
  105e16:	5b                   	pop    %ebx
  105e17:	5e                   	pop    %esi
  105e18:	5f                   	pop    %edi
  105e19:	5d                   	pop    %ebp
  105e1a:	c3                   	ret    

00105e1b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105e1b:	55                   	push   %ebp
  105e1c:	89 e5                	mov    %esp,%ebp
  105e1e:	57                   	push   %edi
  105e1f:	56                   	push   %esi
  105e20:	83 ec 20             	sub    $0x20,%esp
  105e23:	8b 45 08             	mov    0x8(%ebp),%eax
  105e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  105e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e38:	c1 e8 02             	shr    $0x2,%eax
  105e3b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e43:	89 d7                	mov    %edx,%edi
  105e45:	89 c6                	mov    %eax,%esi
  105e47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e49:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105e4c:	83 e1 03             	and    $0x3,%ecx
  105e4f:	74 02                	je     105e53 <memcpy+0x38>
  105e51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e53:	89 f0                	mov    %esi,%eax
  105e55:	89 fa                	mov    %edi,%edx
  105e57:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105e5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105e5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105e63:	83 c4 20             	add    $0x20,%esp
  105e66:	5e                   	pop    %esi
  105e67:	5f                   	pop    %edi
  105e68:	5d                   	pop    %ebp
  105e69:	c3                   	ret    

00105e6a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105e6a:	55                   	push   %ebp
  105e6b:	89 e5                	mov    %esp,%ebp
  105e6d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105e70:	8b 45 08             	mov    0x8(%ebp),%eax
  105e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105e7c:	eb 30                	jmp    105eae <memcmp+0x44>
        if (*s1 != *s2) {
  105e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e81:	0f b6 10             	movzbl (%eax),%edx
  105e84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e87:	0f b6 00             	movzbl (%eax),%eax
  105e8a:	38 c2                	cmp    %al,%dl
  105e8c:	74 18                	je     105ea6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e91:	0f b6 00             	movzbl (%eax),%eax
  105e94:	0f b6 d0             	movzbl %al,%edx
  105e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e9a:	0f b6 00             	movzbl (%eax),%eax
  105e9d:	0f b6 c0             	movzbl %al,%eax
  105ea0:	29 c2                	sub    %eax,%edx
  105ea2:	89 d0                	mov    %edx,%eax
  105ea4:	eb 1a                	jmp    105ec0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105ea6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105eaa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105eae:	8b 45 10             	mov    0x10(%ebp),%eax
  105eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eb4:	89 55 10             	mov    %edx,0x10(%ebp)
  105eb7:	85 c0                	test   %eax,%eax
  105eb9:	75 c3                	jne    105e7e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ec0:	c9                   	leave  
  105ec1:	c3                   	ret    
