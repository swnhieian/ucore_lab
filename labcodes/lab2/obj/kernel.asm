
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 e3 5c 00 00       	call   c0105d39 <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 e0 5e 10 c0 	movl   $0xc0105ee0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 fc 5e 10 c0 	movl   $0xc0105efc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 bc 41 00 00       	call   c0104240 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 fe 17 00 00       	call   c010188c <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 01 5f 10 c0 	movl   $0xc0105f01,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 0f 5f 10 c0 	movl   $0xc0105f0f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 1d 5f 10 c0 	movl   $0xc0105f1d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 2b 5f 10 c0 	movl   $0xc0105f2b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 39 5f 10 c0 	movl   $0xc0105f39,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 68 5f 10 c0 	movl   $0xc0105f68,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 87 5f 10 c0 	movl   $0xc0105f87,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 1b 52 00 00       	call   c0105552 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 8c 5f 10 c0    	movl   $0xc0105f8c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 8c 5f 10 c0 	movl   $0xc0105f8c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 b8 71 10 c0 	movl   $0xc01071b8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 e8 1c 11 c0 	movl   $0xc0111ce8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec e9 1c 11 c0 	movl   $0xc0111ce9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 40 47 11 c0 	movl   $0xc0114740,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 c1 54 00 00       	call   c0105bad <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 96 5f 10 c0 	movl   $0xc0105f96,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 c2 5e 10 	movl   $0xc0105ec2,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 c7 5f 10 c0 	movl   $0xc0105fc7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 df 5f 10 c0 	movl   $0xc0105fdf,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 f7 5f 10 c0 	movl   $0xc0105ff7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 10 60 10 c0 	movl   $0xc0106010,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 3a 60 10 c0 	movl   $0xc010603a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	53                   	push   %ebx
c01009be:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c1:	89 e8                	mov    %ebp,%eax
c01009c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	      uint32_t ebp = read_ebp();
c01009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		  uint32_t eip = read_eip();
c01009cc:	e8 d8 ff ff ff       	call   c01009a9 <read_eip>
c01009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  int i;
		  for (i=0; i<STACKFRAME_DEPTH; i++) {
c01009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009db:	e9 89 00 00 00       	jmp    c0100a69 <print_stackframe+0xaf>
		     cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ee:	c7 04 24 68 60 10 c0 	movl   $0xc0106068,(%esp)
c01009f5:	e8 42 f9 ff ff       	call   c010033c <cprintf>
		     uint32_t* arg = (uint32_t*)ebp+2;
c01009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fd:	83 c0 08             	add    $0x8,%eax
c0100a00:	89 45 e8             	mov    %eax,-0x18(%ebp)
		     cprintf("args: 0x%08x 0x%08x 0x%08x 0x%08x\n", arg[0], arg[1], arg[2], arg[3]);
c0100a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a06:	83 c0 0c             	add    $0xc,%eax
c0100a09:	8b 18                	mov    (%eax),%ebx
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	83 c0 08             	add    $0x8,%eax
c0100a11:	8b 08                	mov    (%eax),%ecx
c0100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a16:	83 c0 04             	add    $0x4,%eax
c0100a19:	8b 10                	mov    (%eax),%edx
c0100a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1e:	8b 00                	mov    (%eax),%eax
c0100a20:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a24:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a28:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a30:	c7 04 24 80 60 10 c0 	movl   $0xc0106080,(%esp)
c0100a37:	e8 00 f9 ff ff       	call   c010033c <cprintf>
		     print_debuginfo(eip-1);
c0100a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a3f:	83 e8 01             	sub    $0x1,%eax
c0100a42:	89 04 24             	mov    %eax,(%esp)
c0100a45:	e8 bc fe ff ff       	call   c0100906 <print_debuginfo>
		     eip = *((uint32_t*)ebp+1);
c0100a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4d:	83 c0 04             	add    $0x4,%eax
c0100a50:	8b 00                	mov    (%eax),%eax
c0100a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
		     ebp = *(uint32_t *)ebp;
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	8b 00                	mov    (%eax),%eax
c0100a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		     if (ebp == 0) break;
c0100a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a61:	75 02                	jne    c0100a65 <print_stackframe+0xab>
c0100a63:	eb 0e                	jmp    c0100a73 <print_stackframe+0xb9>
      *                   the calling funciton's ebp = ss:[ebp]
      */
	      uint32_t ebp = read_ebp();
		  uint32_t eip = read_eip();
		  int i;
		  for (i=0; i<STACKFRAME_DEPTH; i++) {
c0100a65:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a69:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a6d:	0f 8e 6d ff ff ff    	jle    c01009e0 <print_stackframe+0x26>
		     print_debuginfo(eip-1);
		     eip = *((uint32_t*)ebp+1);
		     ebp = *(uint32_t *)ebp;
		     if (ebp == 0) break;
		  }
}
c0100a73:	83 c4 44             	add    $0x44,%esp
c0100a76:	5b                   	pop    %ebx
c0100a77:	5d                   	pop    %ebp
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100ab2:	e8 c3 50 00 00       	call   c0105b7a <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 29 61 10 c0 	movl   $0xc0106129,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100b1f:	e8 56 50 00 00       	call   c0105b7a <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 52 4f 00 00       	call   c0105adb <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 47 61 10 c0 	movl   $0xc0106147,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 60 61 10 c0 	movl   $0xc0106160,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 30 0e 00 00       	call   c0101a44 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 ad 61 10 c0 	movl   $0xc01061ad,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 b1 61 10 c0 	movl   $0xc01061b1,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 ba 61 10 c0 	movl   $0xc01061ba,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 d8 61 10 c0 	movl   $0xc01061d8,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 f6 61 10 c0 	movl   $0xc01061f6,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101170:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 7e 4b 00 00       	call   c0105d78 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 11 62 10 c0 	movl   $0xc0106211,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 1d 62 10 c0 	movl   $0xc010621d,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101659:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101670:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c6:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 40 62 10 c0 	movl   $0xc0106240,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010188a:	c9                   	leave  
c010188b:	c3                   	ret    

c010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010188c:	55                   	push   %ebp
c010188d:	89 e5                	mov    %esp,%ebp
c010188f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	      extern uintptr_t __vectors[];
		  int i;
		  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
c0101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101899:	e9 c3 00 00 00       	jmp    c0101961 <idt_init+0xd5>
		      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a1:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018a8:	89 c2                	mov    %eax,%edx
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018b4:	c0 
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018bf:	c0 08 00 
c01018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c5:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018cc:	c0 
c01018cd:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d0:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e1:	c0 
c01018e2:	83 e2 1f             	and    $0x1f,%edx
c01018e5:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f6:	c0 
c01018f7:	83 e2 f0             	and    $0xfffffff0,%edx
c01018fa:	83 ca 0e             	or     $0xe,%edx
c01018fd:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 ef             	and    $0xffffffef,%edx
c0101912:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 9f             	and    $0xffffff9f,%edx
c0101927:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101938:	c0 
c0101939:	83 ca 80             	or     $0xffffff80,%edx
c010193c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010194d:	c1 e8 10             	shr    $0x10,%eax
c0101950:	89 c2                	mov    %eax,%edx
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010195c:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	      extern uintptr_t __vectors[];
		  int i;
		  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
c010195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101969:	0f 86 2f ff ff ff    	jbe    c010189e <idt_init+0x12>
		      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		  }
		  SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010196f:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101974:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010197a:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101981:	08 00 
c0101983:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010198a:	83 e0 e0             	and    $0xffffffe0,%eax
c010198d:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101992:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101999:	83 e0 1f             	and    $0x1f,%eax
c010199c:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019a1:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019a8:	83 e0 f0             	and    $0xfffffff0,%eax
c01019ab:	83 c8 0e             	or     $0xe,%eax
c01019ae:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019b3:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ba:	83 e0 ef             	and    $0xffffffef,%eax
c01019bd:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c2:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c9:	83 c8 60             	or     $0x60,%eax
c01019cc:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d1:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d8:	83 c8 80             	or     $0xffffff80,%eax
c01019db:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e0:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019e5:	c1 e8 10             	shr    $0x10,%eax
c01019e8:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019ee:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019f8:	0f 01 18             	lidtl  (%eax)
		  lidt(&idt_pd);
}
c01019fb:	c9                   	leave  
c01019fc:	c3                   	ret    

c01019fd <trapname>:

static const char *
trapname(int trapno) {
c01019fd:	55                   	push   %ebp
c01019fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a03:	83 f8 13             	cmp    $0x13,%eax
c0101a06:	77 0c                	ja     c0101a14 <trapname+0x17>
        return excnames[trapno];
c0101a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0b:	8b 04 85 a0 65 10 c0 	mov    -0x3fef9a60(,%eax,4),%eax
c0101a12:	eb 18                	jmp    c0101a2c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a14:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a18:	7e 0d                	jle    c0101a27 <trapname+0x2a>
c0101a1a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a1e:	7f 07                	jg     c0101a27 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a20:	b8 4a 62 10 c0       	mov    $0xc010624a,%eax
c0101a25:	eb 05                	jmp    c0101a2c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a27:	b8 5d 62 10 c0       	mov    $0xc010625d,%eax
}
c0101a2c:	5d                   	pop    %ebp
c0101a2d:	c3                   	ret    

c0101a2e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a2e:	55                   	push   %ebp
c0101a2f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a34:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a38:	66 83 f8 08          	cmp    $0x8,%ax
c0101a3c:	0f 94 c0             	sete   %al
c0101a3f:	0f b6 c0             	movzbl %al,%eax
}
c0101a42:	5d                   	pop    %ebp
c0101a43:	c3                   	ret    

c0101a44 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a44:	55                   	push   %ebp
c0101a45:	89 e5                	mov    %esp,%ebp
c0101a47:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a51:	c7 04 24 9e 62 10 c0 	movl   $0xc010629e,(%esp)
c0101a58:	e8 df e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	89 04 24             	mov    %eax,(%esp)
c0101a63:	e8 a1 01 00 00       	call   c0101c09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a6f:	0f b7 c0             	movzwl %ax,%eax
c0101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a76:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c0101a7d:	e8 ba e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a89:	0f b7 c0             	movzwl %ax,%eax
c0101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a90:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0101a97:	e8 a0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aa3:	0f b7 c0             	movzwl %ax,%eax
c0101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aaa:	c7 04 24 d5 62 10 c0 	movl   $0xc01062d5,(%esp)
c0101ab1:	e8 86 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101abd:	0f b7 c0             	movzwl %ax,%eax
c0101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac4:	c7 04 24 e8 62 10 c0 	movl   $0xc01062e8,(%esp)
c0101acb:	e8 6c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad3:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad6:	89 04 24             	mov    %eax,(%esp)
c0101ad9:	e8 1f ff ff ff       	call   c01019fd <trapname>
c0101ade:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ae1:	8b 52 30             	mov    0x30(%edx),%edx
c0101ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101aec:	c7 04 24 fb 62 10 c0 	movl   $0xc01062fb,(%esp)
c0101af3:	e8 44 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afb:	8b 40 34             	mov    0x34(%eax),%eax
c0101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b02:	c7 04 24 0d 63 10 c0 	movl   $0xc010630d,(%esp)
c0101b09:	e8 2e e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b11:	8b 40 38             	mov    0x38(%eax),%eax
c0101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b18:	c7 04 24 1c 63 10 c0 	movl   $0xc010631c,(%esp)
c0101b1f:	e8 18 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2b:	0f b7 c0             	movzwl %ax,%eax
c0101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b32:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0101b39:	e8 fe e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	8b 40 40             	mov    0x40(%eax),%eax
c0101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b48:	c7 04 24 3e 63 10 c0 	movl   $0xc010633e,(%esp)
c0101b4f:	e8 e8 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b5b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b62:	eb 3e                	jmp    c0101ba2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b67:	8b 50 40             	mov    0x40(%eax),%edx
c0101b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b6d:	21 d0                	and    %edx,%eax
c0101b6f:	85 c0                	test   %eax,%eax
c0101b71:	74 28                	je     c0101b9b <print_trapframe+0x157>
c0101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b76:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1a                	je     c0101b9b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b84:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8f:	c7 04 24 4d 63 10 c0 	movl   $0xc010634d,(%esp)
c0101b96:	e8 a1 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b9f:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba5:	83 f8 17             	cmp    $0x17,%eax
c0101ba8:	76 ba                	jbe    c0101b64 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bad:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb0:	25 00 30 00 00       	and    $0x3000,%eax
c0101bb5:	c1 e8 0c             	shr    $0xc,%eax
c0101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbc:	c7 04 24 51 63 10 c0 	movl   $0xc0106351,(%esp)
c0101bc3:	e8 74 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcb:	89 04 24             	mov    %eax,(%esp)
c0101bce:	e8 5b fe ff ff       	call   c0101a2e <trap_in_kernel>
c0101bd3:	85 c0                	test   %eax,%eax
c0101bd5:	75 30                	jne    c0101c07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bda:	8b 40 44             	mov    0x44(%eax),%eax
c0101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be1:	c7 04 24 5a 63 10 c0 	movl   $0xc010635a,(%esp)
c0101be8:	e8 4f e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bf4:	0f b7 c0             	movzwl %ax,%eax
c0101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfb:	c7 04 24 69 63 10 c0 	movl   $0xc0106369,(%esp)
c0101c02:	e8 35 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c07:	c9                   	leave  
c0101c08:	c3                   	ret    

c0101c09 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c09:	55                   	push   %ebp
c0101c0a:	89 e5                	mov    %esp,%ebp
c0101c0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c12:	8b 00                	mov    (%eax),%eax
c0101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c18:	c7 04 24 7c 63 10 c0 	movl   $0xc010637c,(%esp)
c0101c1f:	e8 18 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c27:	8b 40 04             	mov    0x4(%eax),%eax
c0101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2e:	c7 04 24 8b 63 10 c0 	movl   $0xc010638b,(%esp)
c0101c35:	e8 02 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3d:	8b 40 08             	mov    0x8(%eax),%eax
c0101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c44:	c7 04 24 9a 63 10 c0 	movl   $0xc010639a,(%esp)
c0101c4b:	e8 ec e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5a:	c7 04 24 a9 63 10 c0 	movl   $0xc01063a9,(%esp)
c0101c61:	e8 d6 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 10             	mov    0x10(%eax),%eax
c0101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c70:	c7 04 24 b8 63 10 c0 	movl   $0xc01063b8,(%esp)
c0101c77:	e8 c0 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7f:	8b 40 14             	mov    0x14(%eax),%eax
c0101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c86:	c7 04 24 c7 63 10 c0 	movl   $0xc01063c7,(%esp)
c0101c8d:	e8 aa e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c95:	8b 40 18             	mov    0x18(%eax),%eax
c0101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9c:	c7 04 24 d6 63 10 c0 	movl   $0xc01063d6,(%esp)
c0101ca3:	e8 94 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cab:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb2:	c7 04 24 e5 63 10 c0 	movl   $0xc01063e5,(%esp)
c0101cb9:	e8 7e e6 ff ff       	call   c010033c <cprintf>
}
c0101cbe:	c9                   	leave  
c0101cbf:	c3                   	ret    

c0101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cc0:	55                   	push   %ebp
c0101cc1:	89 e5                	mov    %esp,%ebp
c0101cc3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc9:	8b 40 30             	mov    0x30(%eax),%eax
c0101ccc:	83 f8 2f             	cmp    $0x2f,%eax
c0101ccf:	77 1d                	ja     c0101cee <trap_dispatch+0x2e>
c0101cd1:	83 f8 2e             	cmp    $0x2e,%eax
c0101cd4:	0f 83 f2 00 00 00    	jae    c0101dcc <trap_dispatch+0x10c>
c0101cda:	83 f8 21             	cmp    $0x21,%eax
c0101cdd:	74 73                	je     c0101d52 <trap_dispatch+0x92>
c0101cdf:	83 f8 24             	cmp    $0x24,%eax
c0101ce2:	74 48                	je     c0101d2c <trap_dispatch+0x6c>
c0101ce4:	83 f8 20             	cmp    $0x20,%eax
c0101ce7:	74 13                	je     c0101cfc <trap_dispatch+0x3c>
c0101ce9:	e9 a6 00 00 00       	jmp    c0101d94 <trap_dispatch+0xd4>
c0101cee:	83 e8 78             	sub    $0x78,%eax
c0101cf1:	83 f8 01             	cmp    $0x1,%eax
c0101cf4:	0f 87 9a 00 00 00    	ja     c0101d94 <trap_dispatch+0xd4>
c0101cfa:	eb 7c                	jmp    c0101d78 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101cfc:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d01:	83 c0 01             	add    $0x1,%eax
c0101d04:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks == TICK_NUM) {
c0101d09:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d0e:	83 f8 64             	cmp    $0x64,%eax
c0101d11:	75 14                	jne    c0101d27 <trap_dispatch+0x67>
            print_ticks();
c0101d13:	e8 58 fb ff ff       	call   c0101870 <print_ticks>
           	ticks = 0;
c0101d18:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0101d1f:	00 00 00 
        }
        break;
c0101d22:	e9 a6 00 00 00       	jmp    c0101dcd <trap_dispatch+0x10d>
c0101d27:	e9 a1 00 00 00       	jmp    c0101dcd <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d2c:	e8 03 f9 ff ff       	call   c0101634 <cons_getc>
c0101d31:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d34:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d38:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d3c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d44:	c7 04 24 f4 63 10 c0 	movl   $0xc01063f4,(%esp)
c0101d4b:	e8 ec e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d50:	eb 7b                	jmp    c0101dcd <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d52:	e8 dd f8 ff ff       	call   c0101634 <cons_getc>
c0101d57:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d5a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d5e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d62:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6a:	c7 04 24 06 64 10 c0 	movl   $0xc0106406,(%esp)
c0101d71:	e8 c6 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d76:	eb 55                	jmp    c0101dcd <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d78:	c7 44 24 08 15 64 10 	movl   $0xc0106415,0x8(%esp)
c0101d7f:	c0 
c0101d80:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101d87:	00 
c0101d88:	c7 04 24 25 64 10 c0 	movl   $0xc0106425,(%esp)
c0101d8f:	e8 32 ef ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d97:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d9b:	0f b7 c0             	movzwl %ax,%eax
c0101d9e:	83 e0 03             	and    $0x3,%eax
c0101da1:	85 c0                	test   %eax,%eax
c0101da3:	75 28                	jne    c0101dcd <trap_dispatch+0x10d>
            print_trapframe(tf);
c0101da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da8:	89 04 24             	mov    %eax,(%esp)
c0101dab:	e8 94 fc ff ff       	call   c0101a44 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101db0:	c7 44 24 08 36 64 10 	movl   $0xc0106436,0x8(%esp)
c0101db7:	c0 
c0101db8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101dbf:	00 
c0101dc0:	c7 04 24 25 64 10 c0 	movl   $0xc0106425,(%esp)
c0101dc7:	e8 fa ee ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101dcc:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101dcd:	c9                   	leave  
c0101dce:	c3                   	ret    

c0101dcf <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101dcf:	55                   	push   %ebp
c0101dd0:	89 e5                	mov    %esp,%ebp
c0101dd2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd8:	89 04 24             	mov    %eax,(%esp)
c0101ddb:	e8 e0 fe ff ff       	call   c0101cc0 <trap_dispatch>
}
c0101de0:	c9                   	leave  
c0101de1:	c3                   	ret    

c0101de2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101de2:	1e                   	push   %ds
    pushl %es
c0101de3:	06                   	push   %es
    pushl %fs
c0101de4:	0f a0                	push   %fs
    pushl %gs
c0101de6:	0f a8                	push   %gs
    pushal
c0101de8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101de9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101dee:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101df0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101df2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101df3:	e8 d7 ff ff ff       	call   c0101dcf <trap>

    # pop the pushed stack pointer
    popl %esp
c0101df8:	5c                   	pop    %esp

c0101df9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101df9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101dfa:	0f a9                	pop    %gs
    popl %fs
c0101dfc:	0f a1                	pop    %fs
    popl %es
c0101dfe:	07                   	pop    %es
    popl %ds
c0101dff:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e00:	83 c4 08             	add    $0x8,%esp
    iret
c0101e03:	cf                   	iret   

c0101e04 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e04:	6a 00                	push   $0x0
  pushl $0
c0101e06:	6a 00                	push   $0x0
  jmp __alltraps
c0101e08:	e9 d5 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e0d <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e0d:	6a 00                	push   $0x0
  pushl $1
c0101e0f:	6a 01                	push   $0x1
  jmp __alltraps
c0101e11:	e9 cc ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e16 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $2
c0101e18:	6a 02                	push   $0x2
  jmp __alltraps
c0101e1a:	e9 c3 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e1f <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $3
c0101e21:	6a 03                	push   $0x3
  jmp __alltraps
c0101e23:	e9 ba ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e28 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e28:	6a 00                	push   $0x0
  pushl $4
c0101e2a:	6a 04                	push   $0x4
  jmp __alltraps
c0101e2c:	e9 b1 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e31 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e31:	6a 00                	push   $0x0
  pushl $5
c0101e33:	6a 05                	push   $0x5
  jmp __alltraps
c0101e35:	e9 a8 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e3a <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e3a:	6a 00                	push   $0x0
  pushl $6
c0101e3c:	6a 06                	push   $0x6
  jmp __alltraps
c0101e3e:	e9 9f ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e43 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e43:	6a 00                	push   $0x0
  pushl $7
c0101e45:	6a 07                	push   $0x7
  jmp __alltraps
c0101e47:	e9 96 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e4c <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e4c:	6a 08                	push   $0x8
  jmp __alltraps
c0101e4e:	e9 8f ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e53 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e53:	6a 09                	push   $0x9
  jmp __alltraps
c0101e55:	e9 88 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e5a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e5a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e5c:	e9 81 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e61 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e61:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e63:	e9 7a ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e68 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e68:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e6a:	e9 73 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e6f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e6f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e71:	e9 6c ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e76 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e76:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e78:	e9 65 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e7d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e7d:	6a 00                	push   $0x0
  pushl $15
c0101e7f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e81:	e9 5c ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e86 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e86:	6a 00                	push   $0x0
  pushl $16
c0101e88:	6a 10                	push   $0x10
  jmp __alltraps
c0101e8a:	e9 53 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e8f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e8f:	6a 11                	push   $0x11
  jmp __alltraps
c0101e91:	e9 4c ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e96 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $18
c0101e98:	6a 12                	push   $0x12
  jmp __alltraps
c0101e9a:	e9 43 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101e9f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e9f:	6a 00                	push   $0x0
  pushl $19
c0101ea1:	6a 13                	push   $0x13
  jmp __alltraps
c0101ea3:	e9 3a ff ff ff       	jmp    c0101de2 <__alltraps>

c0101ea8 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $20
c0101eaa:	6a 14                	push   $0x14
  jmp __alltraps
c0101eac:	e9 31 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101eb1 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $21
c0101eb3:	6a 15                	push   $0x15
  jmp __alltraps
c0101eb5:	e9 28 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101eba <vector22>:
.globl vector22
vector22:
  pushl $0
c0101eba:	6a 00                	push   $0x0
  pushl $22
c0101ebc:	6a 16                	push   $0x16
  jmp __alltraps
c0101ebe:	e9 1f ff ff ff       	jmp    c0101de2 <__alltraps>

c0101ec3 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $23
c0101ec5:	6a 17                	push   $0x17
  jmp __alltraps
c0101ec7:	e9 16 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101ecc <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ecc:	6a 00                	push   $0x0
  pushl $24
c0101ece:	6a 18                	push   $0x18
  jmp __alltraps
c0101ed0:	e9 0d ff ff ff       	jmp    c0101de2 <__alltraps>

c0101ed5 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ed5:	6a 00                	push   $0x0
  pushl $25
c0101ed7:	6a 19                	push   $0x19
  jmp __alltraps
c0101ed9:	e9 04 ff ff ff       	jmp    c0101de2 <__alltraps>

c0101ede <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ede:	6a 00                	push   $0x0
  pushl $26
c0101ee0:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ee2:	e9 fb fe ff ff       	jmp    c0101de2 <__alltraps>

c0101ee7 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ee7:	6a 00                	push   $0x0
  pushl $27
c0101ee9:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101eeb:	e9 f2 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101ef0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ef0:	6a 00                	push   $0x0
  pushl $28
c0101ef2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ef4:	e9 e9 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101ef9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ef9:	6a 00                	push   $0x0
  pushl $29
c0101efb:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101efd:	e9 e0 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f02 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f02:	6a 00                	push   $0x0
  pushl $30
c0101f04:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f06:	e9 d7 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f0b <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f0b:	6a 00                	push   $0x0
  pushl $31
c0101f0d:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f0f:	e9 ce fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f14 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f14:	6a 00                	push   $0x0
  pushl $32
c0101f16:	6a 20                	push   $0x20
  jmp __alltraps
c0101f18:	e9 c5 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f1d <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $33
c0101f1f:	6a 21                	push   $0x21
  jmp __alltraps
c0101f21:	e9 bc fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f26 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $34
c0101f28:	6a 22                	push   $0x22
  jmp __alltraps
c0101f2a:	e9 b3 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f2f <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f2f:	6a 00                	push   $0x0
  pushl $35
c0101f31:	6a 23                	push   $0x23
  jmp __alltraps
c0101f33:	e9 aa fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f38 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $36
c0101f3a:	6a 24                	push   $0x24
  jmp __alltraps
c0101f3c:	e9 a1 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f41 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $37
c0101f43:	6a 25                	push   $0x25
  jmp __alltraps
c0101f45:	e9 98 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f4a <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $38
c0101f4c:	6a 26                	push   $0x26
  jmp __alltraps
c0101f4e:	e9 8f fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f53 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $39
c0101f55:	6a 27                	push   $0x27
  jmp __alltraps
c0101f57:	e9 86 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f5c <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f5c:	6a 00                	push   $0x0
  pushl $40
c0101f5e:	6a 28                	push   $0x28
  jmp __alltraps
c0101f60:	e9 7d fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f65 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $41
c0101f67:	6a 29                	push   $0x29
  jmp __alltraps
c0101f69:	e9 74 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f6e <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $42
c0101f70:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f72:	e9 6b fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f77 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $43
c0101f79:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f7b:	e9 62 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f80 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f80:	6a 00                	push   $0x0
  pushl $44
c0101f82:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f84:	e9 59 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f89 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $45
c0101f8b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f8d:	e9 50 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f92 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $46
c0101f94:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f96:	e9 47 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101f9b <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f9b:	6a 00                	push   $0x0
  pushl $47
c0101f9d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f9f:	e9 3e fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fa4 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $48
c0101fa6:	6a 30                	push   $0x30
  jmp __alltraps
c0101fa8:	e9 35 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fad <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $49
c0101faf:	6a 31                	push   $0x31
  jmp __alltraps
c0101fb1:	e9 2c fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fb6 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $50
c0101fb8:	6a 32                	push   $0x32
  jmp __alltraps
c0101fba:	e9 23 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fbf <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $51
c0101fc1:	6a 33                	push   $0x33
  jmp __alltraps
c0101fc3:	e9 1a fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fc8 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $52
c0101fca:	6a 34                	push   $0x34
  jmp __alltraps
c0101fcc:	e9 11 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fd1 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $53
c0101fd3:	6a 35                	push   $0x35
  jmp __alltraps
c0101fd5:	e9 08 fe ff ff       	jmp    c0101de2 <__alltraps>

c0101fda <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $54
c0101fdc:	6a 36                	push   $0x36
  jmp __alltraps
c0101fde:	e9 ff fd ff ff       	jmp    c0101de2 <__alltraps>

c0101fe3 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $55
c0101fe5:	6a 37                	push   $0x37
  jmp __alltraps
c0101fe7:	e9 f6 fd ff ff       	jmp    c0101de2 <__alltraps>

c0101fec <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $56
c0101fee:	6a 38                	push   $0x38
  jmp __alltraps
c0101ff0:	e9 ed fd ff ff       	jmp    c0101de2 <__alltraps>

c0101ff5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $57
c0101ff7:	6a 39                	push   $0x39
  jmp __alltraps
c0101ff9:	e9 e4 fd ff ff       	jmp    c0101de2 <__alltraps>

c0101ffe <vector58>:
.globl vector58
vector58:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $58
c0102000:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102002:	e9 db fd ff ff       	jmp    c0101de2 <__alltraps>

c0102007 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $59
c0102009:	6a 3b                	push   $0x3b
  jmp __alltraps
c010200b:	e9 d2 fd ff ff       	jmp    c0101de2 <__alltraps>

c0102010 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $60
c0102012:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102014:	e9 c9 fd ff ff       	jmp    c0101de2 <__alltraps>

c0102019 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $61
c010201b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010201d:	e9 c0 fd ff ff       	jmp    c0101de2 <__alltraps>

c0102022 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $62
c0102024:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102026:	e9 b7 fd ff ff       	jmp    c0101de2 <__alltraps>

c010202b <vector63>:
.globl vector63
vector63:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $63
c010202d:	6a 3f                	push   $0x3f
  jmp __alltraps
c010202f:	e9 ae fd ff ff       	jmp    c0101de2 <__alltraps>

c0102034 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $64
c0102036:	6a 40                	push   $0x40
  jmp __alltraps
c0102038:	e9 a5 fd ff ff       	jmp    c0101de2 <__alltraps>

c010203d <vector65>:
.globl vector65
vector65:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $65
c010203f:	6a 41                	push   $0x41
  jmp __alltraps
c0102041:	e9 9c fd ff ff       	jmp    c0101de2 <__alltraps>

c0102046 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $66
c0102048:	6a 42                	push   $0x42
  jmp __alltraps
c010204a:	e9 93 fd ff ff       	jmp    c0101de2 <__alltraps>

c010204f <vector67>:
.globl vector67
vector67:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $67
c0102051:	6a 43                	push   $0x43
  jmp __alltraps
c0102053:	e9 8a fd ff ff       	jmp    c0101de2 <__alltraps>

c0102058 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $68
c010205a:	6a 44                	push   $0x44
  jmp __alltraps
c010205c:	e9 81 fd ff ff       	jmp    c0101de2 <__alltraps>

c0102061 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $69
c0102063:	6a 45                	push   $0x45
  jmp __alltraps
c0102065:	e9 78 fd ff ff       	jmp    c0101de2 <__alltraps>

c010206a <vector70>:
.globl vector70
vector70:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $70
c010206c:	6a 46                	push   $0x46
  jmp __alltraps
c010206e:	e9 6f fd ff ff       	jmp    c0101de2 <__alltraps>

c0102073 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $71
c0102075:	6a 47                	push   $0x47
  jmp __alltraps
c0102077:	e9 66 fd ff ff       	jmp    c0101de2 <__alltraps>

c010207c <vector72>:
.globl vector72
vector72:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $72
c010207e:	6a 48                	push   $0x48
  jmp __alltraps
c0102080:	e9 5d fd ff ff       	jmp    c0101de2 <__alltraps>

c0102085 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $73
c0102087:	6a 49                	push   $0x49
  jmp __alltraps
c0102089:	e9 54 fd ff ff       	jmp    c0101de2 <__alltraps>

c010208e <vector74>:
.globl vector74
vector74:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $74
c0102090:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102092:	e9 4b fd ff ff       	jmp    c0101de2 <__alltraps>

c0102097 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $75
c0102099:	6a 4b                	push   $0x4b
  jmp __alltraps
c010209b:	e9 42 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020a0 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $76
c01020a2:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020a4:	e9 39 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020a9 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $77
c01020ab:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020ad:	e9 30 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020b2 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $78
c01020b4:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020b6:	e9 27 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020bb <vector79>:
.globl vector79
vector79:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $79
c01020bd:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020bf:	e9 1e fd ff ff       	jmp    c0101de2 <__alltraps>

c01020c4 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $80
c01020c6:	6a 50                	push   $0x50
  jmp __alltraps
c01020c8:	e9 15 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020cd <vector81>:
.globl vector81
vector81:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $81
c01020cf:	6a 51                	push   $0x51
  jmp __alltraps
c01020d1:	e9 0c fd ff ff       	jmp    c0101de2 <__alltraps>

c01020d6 <vector82>:
.globl vector82
vector82:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $82
c01020d8:	6a 52                	push   $0x52
  jmp __alltraps
c01020da:	e9 03 fd ff ff       	jmp    c0101de2 <__alltraps>

c01020df <vector83>:
.globl vector83
vector83:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $83
c01020e1:	6a 53                	push   $0x53
  jmp __alltraps
c01020e3:	e9 fa fc ff ff       	jmp    c0101de2 <__alltraps>

c01020e8 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $84
c01020ea:	6a 54                	push   $0x54
  jmp __alltraps
c01020ec:	e9 f1 fc ff ff       	jmp    c0101de2 <__alltraps>

c01020f1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $85
c01020f3:	6a 55                	push   $0x55
  jmp __alltraps
c01020f5:	e9 e8 fc ff ff       	jmp    c0101de2 <__alltraps>

c01020fa <vector86>:
.globl vector86
vector86:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $86
c01020fc:	6a 56                	push   $0x56
  jmp __alltraps
c01020fe:	e9 df fc ff ff       	jmp    c0101de2 <__alltraps>

c0102103 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $87
c0102105:	6a 57                	push   $0x57
  jmp __alltraps
c0102107:	e9 d6 fc ff ff       	jmp    c0101de2 <__alltraps>

c010210c <vector88>:
.globl vector88
vector88:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $88
c010210e:	6a 58                	push   $0x58
  jmp __alltraps
c0102110:	e9 cd fc ff ff       	jmp    c0101de2 <__alltraps>

c0102115 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $89
c0102117:	6a 59                	push   $0x59
  jmp __alltraps
c0102119:	e9 c4 fc ff ff       	jmp    c0101de2 <__alltraps>

c010211e <vector90>:
.globl vector90
vector90:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $90
c0102120:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102122:	e9 bb fc ff ff       	jmp    c0101de2 <__alltraps>

c0102127 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $91
c0102129:	6a 5b                	push   $0x5b
  jmp __alltraps
c010212b:	e9 b2 fc ff ff       	jmp    c0101de2 <__alltraps>

c0102130 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $92
c0102132:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102134:	e9 a9 fc ff ff       	jmp    c0101de2 <__alltraps>

c0102139 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $93
c010213b:	6a 5d                	push   $0x5d
  jmp __alltraps
c010213d:	e9 a0 fc ff ff       	jmp    c0101de2 <__alltraps>

c0102142 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $94
c0102144:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102146:	e9 97 fc ff ff       	jmp    c0101de2 <__alltraps>

c010214b <vector95>:
.globl vector95
vector95:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $95
c010214d:	6a 5f                	push   $0x5f
  jmp __alltraps
c010214f:	e9 8e fc ff ff       	jmp    c0101de2 <__alltraps>

c0102154 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $96
c0102156:	6a 60                	push   $0x60
  jmp __alltraps
c0102158:	e9 85 fc ff ff       	jmp    c0101de2 <__alltraps>

c010215d <vector97>:
.globl vector97
vector97:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $97
c010215f:	6a 61                	push   $0x61
  jmp __alltraps
c0102161:	e9 7c fc ff ff       	jmp    c0101de2 <__alltraps>

c0102166 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $98
c0102168:	6a 62                	push   $0x62
  jmp __alltraps
c010216a:	e9 73 fc ff ff       	jmp    c0101de2 <__alltraps>

c010216f <vector99>:
.globl vector99
vector99:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $99
c0102171:	6a 63                	push   $0x63
  jmp __alltraps
c0102173:	e9 6a fc ff ff       	jmp    c0101de2 <__alltraps>

c0102178 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $100
c010217a:	6a 64                	push   $0x64
  jmp __alltraps
c010217c:	e9 61 fc ff ff       	jmp    c0101de2 <__alltraps>

c0102181 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $101
c0102183:	6a 65                	push   $0x65
  jmp __alltraps
c0102185:	e9 58 fc ff ff       	jmp    c0101de2 <__alltraps>

c010218a <vector102>:
.globl vector102
vector102:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $102
c010218c:	6a 66                	push   $0x66
  jmp __alltraps
c010218e:	e9 4f fc ff ff       	jmp    c0101de2 <__alltraps>

c0102193 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $103
c0102195:	6a 67                	push   $0x67
  jmp __alltraps
c0102197:	e9 46 fc ff ff       	jmp    c0101de2 <__alltraps>

c010219c <vector104>:
.globl vector104
vector104:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $104
c010219e:	6a 68                	push   $0x68
  jmp __alltraps
c01021a0:	e9 3d fc ff ff       	jmp    c0101de2 <__alltraps>

c01021a5 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $105
c01021a7:	6a 69                	push   $0x69
  jmp __alltraps
c01021a9:	e9 34 fc ff ff       	jmp    c0101de2 <__alltraps>

c01021ae <vector106>:
.globl vector106
vector106:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $106
c01021b0:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021b2:	e9 2b fc ff ff       	jmp    c0101de2 <__alltraps>

c01021b7 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $107
c01021b9:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021bb:	e9 22 fc ff ff       	jmp    c0101de2 <__alltraps>

c01021c0 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $108
c01021c2:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021c4:	e9 19 fc ff ff       	jmp    c0101de2 <__alltraps>

c01021c9 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $109
c01021cb:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021cd:	e9 10 fc ff ff       	jmp    c0101de2 <__alltraps>

c01021d2 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $110
c01021d4:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021d6:	e9 07 fc ff ff       	jmp    c0101de2 <__alltraps>

c01021db <vector111>:
.globl vector111
vector111:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $111
c01021dd:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021df:	e9 fe fb ff ff       	jmp    c0101de2 <__alltraps>

c01021e4 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $112
c01021e6:	6a 70                	push   $0x70
  jmp __alltraps
c01021e8:	e9 f5 fb ff ff       	jmp    c0101de2 <__alltraps>

c01021ed <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $113
c01021ef:	6a 71                	push   $0x71
  jmp __alltraps
c01021f1:	e9 ec fb ff ff       	jmp    c0101de2 <__alltraps>

c01021f6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $114
c01021f8:	6a 72                	push   $0x72
  jmp __alltraps
c01021fa:	e9 e3 fb ff ff       	jmp    c0101de2 <__alltraps>

c01021ff <vector115>:
.globl vector115
vector115:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $115
c0102201:	6a 73                	push   $0x73
  jmp __alltraps
c0102203:	e9 da fb ff ff       	jmp    c0101de2 <__alltraps>

c0102208 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $116
c010220a:	6a 74                	push   $0x74
  jmp __alltraps
c010220c:	e9 d1 fb ff ff       	jmp    c0101de2 <__alltraps>

c0102211 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $117
c0102213:	6a 75                	push   $0x75
  jmp __alltraps
c0102215:	e9 c8 fb ff ff       	jmp    c0101de2 <__alltraps>

c010221a <vector118>:
.globl vector118
vector118:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $118
c010221c:	6a 76                	push   $0x76
  jmp __alltraps
c010221e:	e9 bf fb ff ff       	jmp    c0101de2 <__alltraps>

c0102223 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $119
c0102225:	6a 77                	push   $0x77
  jmp __alltraps
c0102227:	e9 b6 fb ff ff       	jmp    c0101de2 <__alltraps>

c010222c <vector120>:
.globl vector120
vector120:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $120
c010222e:	6a 78                	push   $0x78
  jmp __alltraps
c0102230:	e9 ad fb ff ff       	jmp    c0101de2 <__alltraps>

c0102235 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $121
c0102237:	6a 79                	push   $0x79
  jmp __alltraps
c0102239:	e9 a4 fb ff ff       	jmp    c0101de2 <__alltraps>

c010223e <vector122>:
.globl vector122
vector122:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $122
c0102240:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102242:	e9 9b fb ff ff       	jmp    c0101de2 <__alltraps>

c0102247 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $123
c0102249:	6a 7b                	push   $0x7b
  jmp __alltraps
c010224b:	e9 92 fb ff ff       	jmp    c0101de2 <__alltraps>

c0102250 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $124
c0102252:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102254:	e9 89 fb ff ff       	jmp    c0101de2 <__alltraps>

c0102259 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $125
c010225b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010225d:	e9 80 fb ff ff       	jmp    c0101de2 <__alltraps>

c0102262 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $126
c0102264:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102266:	e9 77 fb ff ff       	jmp    c0101de2 <__alltraps>

c010226b <vector127>:
.globl vector127
vector127:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $127
c010226d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010226f:	e9 6e fb ff ff       	jmp    c0101de2 <__alltraps>

c0102274 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $128
c0102276:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010227b:	e9 62 fb ff ff       	jmp    c0101de2 <__alltraps>

c0102280 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102280:	6a 00                	push   $0x0
  pushl $129
c0102282:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102287:	e9 56 fb ff ff       	jmp    c0101de2 <__alltraps>

c010228c <vector130>:
.globl vector130
vector130:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $130
c010228e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102293:	e9 4a fb ff ff       	jmp    c0101de2 <__alltraps>

c0102298 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $131
c010229a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010229f:	e9 3e fb ff ff       	jmp    c0101de2 <__alltraps>

c01022a4 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $132
c01022a6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022ab:	e9 32 fb ff ff       	jmp    c0101de2 <__alltraps>

c01022b0 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $133
c01022b2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022b7:	e9 26 fb ff ff       	jmp    c0101de2 <__alltraps>

c01022bc <vector134>:
.globl vector134
vector134:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $134
c01022be:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022c3:	e9 1a fb ff ff       	jmp    c0101de2 <__alltraps>

c01022c8 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $135
c01022ca:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022cf:	e9 0e fb ff ff       	jmp    c0101de2 <__alltraps>

c01022d4 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $136
c01022d6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022db:	e9 02 fb ff ff       	jmp    c0101de2 <__alltraps>

c01022e0 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $137
c01022e2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022e7:	e9 f6 fa ff ff       	jmp    c0101de2 <__alltraps>

c01022ec <vector138>:
.globl vector138
vector138:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $138
c01022ee:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022f3:	e9 ea fa ff ff       	jmp    c0101de2 <__alltraps>

c01022f8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $139
c01022fa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022ff:	e9 de fa ff ff       	jmp    c0101de2 <__alltraps>

c0102304 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $140
c0102306:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010230b:	e9 d2 fa ff ff       	jmp    c0101de2 <__alltraps>

c0102310 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $141
c0102312:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102317:	e9 c6 fa ff ff       	jmp    c0101de2 <__alltraps>

c010231c <vector142>:
.globl vector142
vector142:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $142
c010231e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102323:	e9 ba fa ff ff       	jmp    c0101de2 <__alltraps>

c0102328 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $143
c010232a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010232f:	e9 ae fa ff ff       	jmp    c0101de2 <__alltraps>

c0102334 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $144
c0102336:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010233b:	e9 a2 fa ff ff       	jmp    c0101de2 <__alltraps>

c0102340 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $145
c0102342:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102347:	e9 96 fa ff ff       	jmp    c0101de2 <__alltraps>

c010234c <vector146>:
.globl vector146
vector146:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $146
c010234e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102353:	e9 8a fa ff ff       	jmp    c0101de2 <__alltraps>

c0102358 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $147
c010235a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010235f:	e9 7e fa ff ff       	jmp    c0101de2 <__alltraps>

c0102364 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $148
c0102366:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010236b:	e9 72 fa ff ff       	jmp    c0101de2 <__alltraps>

c0102370 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $149
c0102372:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102377:	e9 66 fa ff ff       	jmp    c0101de2 <__alltraps>

c010237c <vector150>:
.globl vector150
vector150:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $150
c010237e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102383:	e9 5a fa ff ff       	jmp    c0101de2 <__alltraps>

c0102388 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $151
c010238a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010238f:	e9 4e fa ff ff       	jmp    c0101de2 <__alltraps>

c0102394 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $152
c0102396:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010239b:	e9 42 fa ff ff       	jmp    c0101de2 <__alltraps>

c01023a0 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $153
c01023a2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023a7:	e9 36 fa ff ff       	jmp    c0101de2 <__alltraps>

c01023ac <vector154>:
.globl vector154
vector154:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $154
c01023ae:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023b3:	e9 2a fa ff ff       	jmp    c0101de2 <__alltraps>

c01023b8 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $155
c01023ba:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023bf:	e9 1e fa ff ff       	jmp    c0101de2 <__alltraps>

c01023c4 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $156
c01023c6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023cb:	e9 12 fa ff ff       	jmp    c0101de2 <__alltraps>

c01023d0 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $157
c01023d2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023d7:	e9 06 fa ff ff       	jmp    c0101de2 <__alltraps>

c01023dc <vector158>:
.globl vector158
vector158:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $158
c01023de:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023e3:	e9 fa f9 ff ff       	jmp    c0101de2 <__alltraps>

c01023e8 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $159
c01023ea:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023ef:	e9 ee f9 ff ff       	jmp    c0101de2 <__alltraps>

c01023f4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $160
c01023f6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023fb:	e9 e2 f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102400 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $161
c0102402:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102407:	e9 d6 f9 ff ff       	jmp    c0101de2 <__alltraps>

c010240c <vector162>:
.globl vector162
vector162:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $162
c010240e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102413:	e9 ca f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102418 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $163
c010241a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010241f:	e9 be f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102424 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $164
c0102426:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010242b:	e9 b2 f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102430 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $165
c0102432:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102437:	e9 a6 f9 ff ff       	jmp    c0101de2 <__alltraps>

c010243c <vector166>:
.globl vector166
vector166:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $166
c010243e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102443:	e9 9a f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102448 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $167
c010244a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010244f:	e9 8e f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102454 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $168
c0102456:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010245b:	e9 82 f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102460 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $169
c0102462:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102467:	e9 76 f9 ff ff       	jmp    c0101de2 <__alltraps>

c010246c <vector170>:
.globl vector170
vector170:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $170
c010246e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102473:	e9 6a f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102478 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $171
c010247a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010247f:	e9 5e f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102484 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $172
c0102486:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010248b:	e9 52 f9 ff ff       	jmp    c0101de2 <__alltraps>

c0102490 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $173
c0102492:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102497:	e9 46 f9 ff ff       	jmp    c0101de2 <__alltraps>

c010249c <vector174>:
.globl vector174
vector174:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $174
c010249e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024a3:	e9 3a f9 ff ff       	jmp    c0101de2 <__alltraps>

c01024a8 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $175
c01024aa:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024af:	e9 2e f9 ff ff       	jmp    c0101de2 <__alltraps>

c01024b4 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $176
c01024b6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024bb:	e9 22 f9 ff ff       	jmp    c0101de2 <__alltraps>

c01024c0 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $177
c01024c2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024c7:	e9 16 f9 ff ff       	jmp    c0101de2 <__alltraps>

c01024cc <vector178>:
.globl vector178
vector178:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $178
c01024ce:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024d3:	e9 0a f9 ff ff       	jmp    c0101de2 <__alltraps>

c01024d8 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $179
c01024da:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024df:	e9 fe f8 ff ff       	jmp    c0101de2 <__alltraps>

c01024e4 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $180
c01024e6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024eb:	e9 f2 f8 ff ff       	jmp    c0101de2 <__alltraps>

c01024f0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $181
c01024f2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024f7:	e9 e6 f8 ff ff       	jmp    c0101de2 <__alltraps>

c01024fc <vector182>:
.globl vector182
vector182:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $182
c01024fe:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102503:	e9 da f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102508 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $183
c010250a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010250f:	e9 ce f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102514 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $184
c0102516:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010251b:	e9 c2 f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102520 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $185
c0102522:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102527:	e9 b6 f8 ff ff       	jmp    c0101de2 <__alltraps>

c010252c <vector186>:
.globl vector186
vector186:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $186
c010252e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102533:	e9 aa f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102538 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $187
c010253a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010253f:	e9 9e f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102544 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $188
c0102546:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010254b:	e9 92 f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102550 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $189
c0102552:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102557:	e9 86 f8 ff ff       	jmp    c0101de2 <__alltraps>

c010255c <vector190>:
.globl vector190
vector190:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $190
c010255e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102563:	e9 7a f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102568 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $191
c010256a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010256f:	e9 6e f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102574 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $192
c0102576:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010257b:	e9 62 f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102580 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $193
c0102582:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102587:	e9 56 f8 ff ff       	jmp    c0101de2 <__alltraps>

c010258c <vector194>:
.globl vector194
vector194:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $194
c010258e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102593:	e9 4a f8 ff ff       	jmp    c0101de2 <__alltraps>

c0102598 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $195
c010259a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010259f:	e9 3e f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025a4 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $196
c01025a6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025ab:	e9 32 f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025b0 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $197
c01025b2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025b7:	e9 26 f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025bc <vector198>:
.globl vector198
vector198:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $198
c01025be:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025c3:	e9 1a f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025c8 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $199
c01025ca:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025cf:	e9 0e f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025d4 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $200
c01025d6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025db:	e9 02 f8 ff ff       	jmp    c0101de2 <__alltraps>

c01025e0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $201
c01025e2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025e7:	e9 f6 f7 ff ff       	jmp    c0101de2 <__alltraps>

c01025ec <vector202>:
.globl vector202
vector202:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $202
c01025ee:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025f3:	e9 ea f7 ff ff       	jmp    c0101de2 <__alltraps>

c01025f8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $203
c01025fa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025ff:	e9 de f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102604 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $204
c0102606:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010260b:	e9 d2 f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102610 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $205
c0102612:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102617:	e9 c6 f7 ff ff       	jmp    c0101de2 <__alltraps>

c010261c <vector206>:
.globl vector206
vector206:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $206
c010261e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102623:	e9 ba f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102628 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $207
c010262a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010262f:	e9 ae f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102634 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $208
c0102636:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010263b:	e9 a2 f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102640 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $209
c0102642:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102647:	e9 96 f7 ff ff       	jmp    c0101de2 <__alltraps>

c010264c <vector210>:
.globl vector210
vector210:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $210
c010264e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102653:	e9 8a f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102658 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $211
c010265a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010265f:	e9 7e f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102664 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $212
c0102666:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010266b:	e9 72 f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102670 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $213
c0102672:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102677:	e9 66 f7 ff ff       	jmp    c0101de2 <__alltraps>

c010267c <vector214>:
.globl vector214
vector214:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $214
c010267e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102683:	e9 5a f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102688 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $215
c010268a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010268f:	e9 4e f7 ff ff       	jmp    c0101de2 <__alltraps>

c0102694 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $216
c0102696:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010269b:	e9 42 f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026a0 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $217
c01026a2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026a7:	e9 36 f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026ac <vector218>:
.globl vector218
vector218:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $218
c01026ae:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026b3:	e9 2a f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026b8 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $219
c01026ba:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026bf:	e9 1e f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026c4 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $220
c01026c6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026cb:	e9 12 f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026d0 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $221
c01026d2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026d7:	e9 06 f7 ff ff       	jmp    c0101de2 <__alltraps>

c01026dc <vector222>:
.globl vector222
vector222:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $222
c01026de:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026e3:	e9 fa f6 ff ff       	jmp    c0101de2 <__alltraps>

c01026e8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $223
c01026ea:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026ef:	e9 ee f6 ff ff       	jmp    c0101de2 <__alltraps>

c01026f4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $224
c01026f6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026fb:	e9 e2 f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102700 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $225
c0102702:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102707:	e9 d6 f6 ff ff       	jmp    c0101de2 <__alltraps>

c010270c <vector226>:
.globl vector226
vector226:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $226
c010270e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102713:	e9 ca f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102718 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $227
c010271a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010271f:	e9 be f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102724 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $228
c0102726:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010272b:	e9 b2 f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102730 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $229
c0102732:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102737:	e9 a6 f6 ff ff       	jmp    c0101de2 <__alltraps>

c010273c <vector230>:
.globl vector230
vector230:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $230
c010273e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102743:	e9 9a f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102748 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $231
c010274a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010274f:	e9 8e f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102754 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $232
c0102756:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010275b:	e9 82 f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102760 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $233
c0102762:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102767:	e9 76 f6 ff ff       	jmp    c0101de2 <__alltraps>

c010276c <vector234>:
.globl vector234
vector234:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $234
c010276e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102773:	e9 6a f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102778 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $235
c010277a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010277f:	e9 5e f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102784 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $236
c0102786:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010278b:	e9 52 f6 ff ff       	jmp    c0101de2 <__alltraps>

c0102790 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $237
c0102792:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102797:	e9 46 f6 ff ff       	jmp    c0101de2 <__alltraps>

c010279c <vector238>:
.globl vector238
vector238:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $238
c010279e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027a3:	e9 3a f6 ff ff       	jmp    c0101de2 <__alltraps>

c01027a8 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $239
c01027aa:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027af:	e9 2e f6 ff ff       	jmp    c0101de2 <__alltraps>

c01027b4 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $240
c01027b6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027bb:	e9 22 f6 ff ff       	jmp    c0101de2 <__alltraps>

c01027c0 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $241
c01027c2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027c7:	e9 16 f6 ff ff       	jmp    c0101de2 <__alltraps>

c01027cc <vector242>:
.globl vector242
vector242:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $242
c01027ce:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027d3:	e9 0a f6 ff ff       	jmp    c0101de2 <__alltraps>

c01027d8 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $243
c01027da:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027df:	e9 fe f5 ff ff       	jmp    c0101de2 <__alltraps>

c01027e4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $244
c01027e6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027eb:	e9 f2 f5 ff ff       	jmp    c0101de2 <__alltraps>

c01027f0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $245
c01027f2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027f7:	e9 e6 f5 ff ff       	jmp    c0101de2 <__alltraps>

c01027fc <vector246>:
.globl vector246
vector246:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $246
c01027fe:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102803:	e9 da f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102808 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $247
c010280a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010280f:	e9 ce f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102814 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $248
c0102816:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010281b:	e9 c2 f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102820 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $249
c0102822:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102827:	e9 b6 f5 ff ff       	jmp    c0101de2 <__alltraps>

c010282c <vector250>:
.globl vector250
vector250:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $250
c010282e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102833:	e9 aa f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102838 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $251
c010283a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010283f:	e9 9e f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102844 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $252
c0102846:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010284b:	e9 92 f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102850 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $253
c0102852:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102857:	e9 86 f5 ff ff       	jmp    c0101de2 <__alltraps>

c010285c <vector254>:
.globl vector254
vector254:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $254
c010285e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102863:	e9 7a f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102868 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $255
c010286a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010286f:	e9 6e f5 ff ff       	jmp    c0101de2 <__alltraps>

c0102874 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102874:	55                   	push   %ebp
c0102875:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102877:	8b 55 08             	mov    0x8(%ebp),%edx
c010287a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010287f:	29 c2                	sub    %eax,%edx
c0102881:	89 d0                	mov    %edx,%eax
c0102883:	c1 f8 02             	sar    $0x2,%eax
c0102886:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010288c:	5d                   	pop    %ebp
c010288d:	c3                   	ret    

c010288e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010288e:	55                   	push   %ebp
c010288f:	89 e5                	mov    %esp,%ebp
c0102891:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102894:	8b 45 08             	mov    0x8(%ebp),%eax
c0102897:	89 04 24             	mov    %eax,(%esp)
c010289a:	e8 d5 ff ff ff       	call   c0102874 <page2ppn>
c010289f:	c1 e0 0c             	shl    $0xc,%eax
}
c01028a2:	c9                   	leave  
c01028a3:	c3                   	ret    

c01028a4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028a4:	55                   	push   %ebp
c01028a5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01028aa:	8b 00                	mov    (%eax),%eax
}
c01028ac:	5d                   	pop    %ebp
c01028ad:	c3                   	ret    

c01028ae <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028ae:	55                   	push   %ebp
c01028af:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028b7:	89 10                	mov    %edx,(%eax)
}
c01028b9:	5d                   	pop    %ebp
c01028ba:	c3                   	ret    

c01028bb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028bb:	55                   	push   %ebp
c01028bc:	89 e5                	mov    %esp,%ebp
c01028be:	83 ec 10             	sub    $0x10,%esp
c01028c1:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028ce:	89 50 04             	mov    %edx,0x4(%eax)
c01028d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028d4:	8b 50 04             	mov    0x4(%eax),%edx
c01028d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028da:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028dc:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01028e3:	00 00 00 
}
c01028e6:	c9                   	leave  
c01028e7:	c3                   	ret    

c01028e8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028e8:	55                   	push   %ebp
c01028e9:	89 e5                	mov    %esp,%ebp
c01028eb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01028ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028f2:	75 24                	jne    c0102918 <default_init_memmap+0x30>
c01028f4:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c01028fb:	c0 
c01028fc:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102903:	c0 
c0102904:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010290b:	00 
c010290c:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102913:	e8 ae e3 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c0102918:	8b 45 08             	mov    0x8(%ebp),%eax
c010291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010291e:	e9 dc 00 00 00       	jmp    c01029ff <default_init_memmap+0x117>
        assert(PageReserved(p));
c0102923:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102926:	83 c0 04             	add    $0x4,%eax
c0102929:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102930:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102933:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102936:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102939:	0f a3 10             	bt     %edx,(%eax)
c010293c:	19 c0                	sbb    %eax,%eax
c010293e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102941:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102945:	0f 95 c0             	setne  %al
c0102948:	0f b6 c0             	movzbl %al,%eax
c010294b:	85 c0                	test   %eax,%eax
c010294d:	75 24                	jne    c0102973 <default_init_memmap+0x8b>
c010294f:	c7 44 24 0c 21 66 10 	movl   $0xc0106621,0xc(%esp)
c0102956:	c0 
c0102957:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010295e:	c0 
c010295f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102966:	00 
c0102967:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010296e:	e8 53 e3 ff ff       	call   c0100cc6 <__panic>
        p->flags = 0;
c0102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c010297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102980:	83 c0 04             	add    $0x4,%eax
c0102983:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010298a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010298d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102993:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102999:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01029a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029a7:	00 
c01029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ab:	89 04 24             	mov    %eax,(%esp)
c01029ae:	e8 fb fe ff ff       	call   c01028ae <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b6:	83 c0 0c             	add    $0xc,%eax
c01029b9:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029c6:	8b 00                	mov    (%eax),%eax
c01029c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029dd:	89 10                	mov    %edx,(%eax)
c01029df:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029e2:	8b 10                	mov    (%eax),%edx
c01029e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029e7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029f9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029fb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a02:	89 d0                	mov    %edx,%eax
c0102a04:	c1 e0 02             	shl    $0x2,%eax
c0102a07:	01 d0                	add    %edx,%eax
c0102a09:	c1 e0 02             	shl    $0x2,%eax
c0102a0c:	89 c2                	mov    %eax,%edx
c0102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a11:	01 d0                	add    %edx,%eax
c0102a13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a16:	0f 85 07 ff ff ff    	jne    c0102923 <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a22:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102a25:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a2e:	01 d0                	add    %edx,%eax
c0102a30:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102a35:	c9                   	leave  
c0102a36:	c3                   	ret    

c0102a37 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a37:	55                   	push   %ebp
c0102a38:	89 e5                	mov    %esp,%ebp
c0102a3a:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a41:	75 24                	jne    c0102a67 <default_alloc_pages+0x30>
c0102a43:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c0102a4a:	c0 
c0102a4b:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102a52:	c0 
c0102a53:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102a5a:	00 
c0102a5b:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102a62:	e8 5f e2 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c0102a67:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a6f:	73 0a                	jae    c0102a7b <default_alloc_pages+0x44>
        return NULL;
c0102a71:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a76:	e9 0d 01 00 00       	jmp    c0102b88 <default_alloc_pages+0x151>
    }
    struct Page *page = NULL;
c0102a7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *le = &free_list;
c0102a82:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
c0102a89:	e9 d9 00 00 00       	jmp    c0102b67 <default_alloc_pages+0x130>
        page = le2page(le, page_link);
c0102a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a91:	83 e8 0c             	sub    $0xc,%eax
c0102a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (page->property >= n) {
c0102a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a9a:	8b 40 08             	mov    0x8(%eax),%eax
c0102a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aa0:	0f 82 c1 00 00 00    	jb     c0102b67 <default_alloc_pages+0x130>
            int i;
            for (i=0; i<n; i++) {
c0102aa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102aad:	eb 7c                	jmp    c0102b2b <default_alloc_pages+0xf4>
                 struct Page* tempp = le2page(le, page_link);
c0102aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab2:	83 e8 0c             	sub    $0xc,%eax
c0102ab5:	89 45 e8             	mov    %eax,-0x18(%ebp)
                 SetPageReserved(tempp);
c0102ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102abb:	83 c0 04             	add    $0x4,%eax
c0102abe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102ac8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102acb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ace:	0f ab 10             	bts    %edx,(%eax)
                 ClearPageProperty(tempp);
c0102ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad4:	83 c0 04             	add    $0x4,%eax
c0102ad7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102ade:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ae1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ae4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ae7:	0f b3 10             	btr    %edx,(%eax)
c0102aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aed:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102af0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102af3:	8b 40 04             	mov    0x4(%eax),%eax
                 temp = list_next(le);
c0102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102afc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b02:	8b 40 04             	mov    0x4(%eax),%eax
c0102b05:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b08:	8b 12                	mov    (%edx),%edx
c0102b0a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102b0d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b13:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b16:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b19:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b1f:	89 10                	mov    %edx,(%eax)
                 list_del(le);
                 le = temp;
c0102b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
        page = le2page(le, page_link);
        if (page->property >= n) {
            int i;
            for (i=0; i<n; i++) {
c0102b27:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b2e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b31:	0f 82 78 ff ff ff    	jb     c0102aaf <default_alloc_pages+0x78>
                 ClearPageProperty(tempp);
                 temp = list_next(le);
                 list_del(le);
                 le = temp;
            }
            size_t rest = page->property - n;
c0102b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b3a:	8b 40 08             	mov    0x8(%eax),%eax
c0102b3d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
            if (rest > 0) {
c0102b43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102b47:	74 0c                	je     c0102b55 <default_alloc_pages+0x11e>
                (le2page(le, page_link))->property = rest;
c0102b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4c:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b52:	89 42 08             	mov    %eax,0x8(%edx)
            }
            nr_free -= n;
c0102b55:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b5a:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b5d:	a3 58 89 11 c0       	mov    %eax,0xc0118958
            return page;
c0102b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b65:	eb 21                	jmp    c0102b88 <default_alloc_pages+0x151>
c0102b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b6a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b70:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
c0102b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b76:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102b7d:	0f 85 0b ff ff ff    	jne    c0102a8e <default_alloc_pages+0x57>
            }
            nr_free -= n;
            return page;
        }
    }
    return NULL;
c0102b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b88:	c9                   	leave  
c0102b89:	c3                   	ret    

c0102b8a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b8a:	55                   	push   %ebp
c0102b8b:	89 e5                	mov    %esp,%ebp
c0102b8d:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102b90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b94:	75 24                	jne    c0102bba <default_free_pages+0x30>
c0102b96:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c0102b9d:	c0 
c0102b9e:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102ba5:	c0 
c0102ba6:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0102bad:	00 
c0102bae:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102bb5:	e8 0c e1 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c0102bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = &free_list;
c0102bc0:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le=list_next(le)) != &free_list) {
c0102bc7:	eb 0d                	jmp    c0102bd6 <default_free_pages+0x4c>
        if ((le2page(le, page_link)) > base)
c0102bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bcc:	83 e8 0c             	sub    $0xc,%eax
c0102bcf:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bd2:	76 02                	jbe    c0102bd6 <default_free_pages+0x4c>
            break;
c0102bd4:	eb 18                	jmp    c0102bee <default_free_pages+0x64>
c0102bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bdf:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;

    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
c0102be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102be5:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102bec:	75 db                	jne    c0102bc9 <default_free_pages+0x3f>
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (p = base; p<base+n; p++) {
c0102bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bf4:	e9 9a 00 00 00       	jmp    c0102c93 <default_free_pages+0x109>
        set_page_ref(p, 0);
c0102bf9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c00:	00 
c0102c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c04:	89 04 24             	mov    %eax,(%esp)
c0102c07:	e8 a2 fc ff ff       	call   c01028ae <set_page_ref>
        ClearPageReserved(p);
c0102c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0f:	83 c0 04             	add    $0x4,%eax
c0102c12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102c22:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);
c0102c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c28:	83 c0 04             	add    $0x4,%eax
c0102c2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c32:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c38:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c3b:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_add_before(le, &(p->page_link));
c0102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4b:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c51:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102c54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c57:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c5a:	8b 00                	mov    (%eax),%eax
c0102c5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c5f:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102c62:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102c65:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c68:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c71:	89 10                	mov    %edx,(%eax)
c0102c73:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c76:	8b 10                	mov    (%eax),%edx
c0102c78:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c7b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c81:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c87:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c8a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c8d:	89 10                	mov    %edx,(%eax)
    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (p = base; p<base+n; p++) {
c0102c8f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c96:	89 d0                	mov    %edx,%eax
c0102c98:	c1 e0 02             	shl    $0x2,%eax
c0102c9b:	01 d0                	add    %edx,%eax
c0102c9d:	c1 e0 02             	shl    $0x2,%eax
c0102ca0:	89 c2                	mov    %eax,%edx
c0102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca5:	01 d0                	add    %edx,%eax
c0102ca7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102caa:	0f 87 49 ff ff ff    	ja     c0102bf9 <default_free_pages+0x6f>
        ClearPageReserved(p);
        SetPageProperty(p);
        p->property = 0;
        list_add_before(le, &(p->page_link));
    }
    base->property = n;
c0102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cb6:	89 50 08             	mov    %edx,0x8(%eax)
    p = le2page(le, page_link);
c0102cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cbc:	83 e8 0c             	sub    $0xc,%eax
c0102cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (base + n == p) {
c0102cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cc5:	89 d0                	mov    %edx,%eax
c0102cc7:	c1 e0 02             	shl    $0x2,%eax
c0102cca:	01 d0                	add    %edx,%eax
c0102ccc:	c1 e0 02             	shl    $0x2,%eax
c0102ccf:	89 c2                	mov    %eax,%edx
c0102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd4:	01 d0                	add    %edx,%eax
c0102cd6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cd9:	75 1e                	jne    c0102cf9 <default_free_pages+0x16f>
        base->property += p->property;
c0102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cde:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce4:	8b 40 08             	mov    0x8(%eax),%eax
c0102ce7:	01 c2                	add    %eax,%edx
c0102ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cec:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
c0102cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cfc:	83 c0 0c             	add    $0xc,%eax
c0102cff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d05:	8b 00                	mov    (%eax),%eax
c0102d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if ((le != &free_list) && (le2page(le, page_link)+1==base)) {
c0102d0a:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d11:	74 57                	je     c0102d6a <default_free_pages+0x1e0>
c0102d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d16:	83 c0 08             	add    $0x8,%eax
c0102d19:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d1c:	75 4c                	jne    c0102d6a <default_free_pages+0x1e0>
        while (le != &free_list) {
c0102d1e:	eb 41                	jmp    c0102d61 <default_free_pages+0x1d7>
            p = le2page(le, page_link);
c0102d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d23:	83 e8 0c             	sub    $0xc,%eax
c0102d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (p->property > 0) {
c0102d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d2c:	8b 40 08             	mov    0x8(%eax),%eax
c0102d2f:	85 c0                	test   %eax,%eax
c0102d31:	74 20                	je     c0102d53 <default_free_pages+0x1c9>
                p->property += base->property;
c0102d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d36:	8b 50 08             	mov    0x8(%eax),%edx
c0102d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d3c:	8b 40 08             	mov    0x8(%eax),%eax
c0102d3f:	01 c2                	add    %eax,%edx
c0102d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d44:	89 50 08             	mov    %edx,0x8(%eax)
                base->property = 0;
c0102d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                break;
c0102d51:	eb 17                	jmp    c0102d6a <default_free_pages+0x1e0>
c0102d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102d59:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d5c:	8b 00                	mov    (%eax),%eax
            }
            le = list_prev(le);
c0102d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        base->property += p->property;
        p->property = 0;
    }
    le = list_prev(&(base->page_link));
    if ((le != &free_list) && (le2page(le, page_link)+1==base)) {
        while (le != &free_list) {
c0102d61:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d68:	75 b6                	jne    c0102d20 <default_free_pages+0x196>
                break;
            }
            le = list_prev(le);
        }
    }
    nr_free += n;
c0102d6a:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102d70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d73:	01 d0                	add    %edx,%eax
c0102d75:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102d7a:	c9                   	leave  
c0102d7b:	c3                   	ret    

c0102d7c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102d7c:	55                   	push   %ebp
c0102d7d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102d7f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102d84:	5d                   	pop    %ebp
c0102d85:	c3                   	ret    

c0102d86 <basic_check>:

static void
basic_check(void) {
c0102d86:	55                   	push   %ebp
c0102d87:	89 e5                	mov    %esp,%ebp
c0102d89:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102d9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102da6:	e8 85 0e 00 00       	call   c0103c30 <alloc_pages>
c0102dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102dae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102db2:	75 24                	jne    c0102dd8 <basic_check+0x52>
c0102db4:	c7 44 24 0c 31 66 10 	movl   $0xc0106631,0xc(%esp)
c0102dbb:	c0 
c0102dbc:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102dc3:	c0 
c0102dc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0102dcb:	00 
c0102dcc:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102dd3:	e8 ee de ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102dd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ddf:	e8 4c 0e 00 00       	call   c0103c30 <alloc_pages>
c0102de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102deb:	75 24                	jne    c0102e11 <basic_check+0x8b>
c0102ded:	c7 44 24 0c 4d 66 10 	movl   $0xc010664d,0xc(%esp)
c0102df4:	c0 
c0102df5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102dfc:	c0 
c0102dfd:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102e04:	00 
c0102e05:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102e0c:	e8 b5 de ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e18:	e8 13 0e 00 00       	call   c0103c30 <alloc_pages>
c0102e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e24:	75 24                	jne    c0102e4a <basic_check+0xc4>
c0102e26:	c7 44 24 0c 69 66 10 	movl   $0xc0106669,0xc(%esp)
c0102e2d:	c0 
c0102e2e:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102e35:	c0 
c0102e36:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0102e3d:	00 
c0102e3e:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102e45:	e8 7c de ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e50:	74 10                	je     c0102e62 <basic_check+0xdc>
c0102e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e58:	74 08                	je     c0102e62 <basic_check+0xdc>
c0102e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e60:	75 24                	jne    c0102e86 <basic_check+0x100>
c0102e62:	c7 44 24 0c 88 66 10 	movl   $0xc0106688,0xc(%esp)
c0102e69:	c0 
c0102e6a:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102e71:	c0 
c0102e72:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0102e79:	00 
c0102e7a:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102e81:	e8 40 de ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e89:	89 04 24             	mov    %eax,(%esp)
c0102e8c:	e8 13 fa ff ff       	call   c01028a4 <page_ref>
c0102e91:	85 c0                	test   %eax,%eax
c0102e93:	75 1e                	jne    c0102eb3 <basic_check+0x12d>
c0102e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e98:	89 04 24             	mov    %eax,(%esp)
c0102e9b:	e8 04 fa ff ff       	call   c01028a4 <page_ref>
c0102ea0:	85 c0                	test   %eax,%eax
c0102ea2:	75 0f                	jne    c0102eb3 <basic_check+0x12d>
c0102ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea7:	89 04 24             	mov    %eax,(%esp)
c0102eaa:	e8 f5 f9 ff ff       	call   c01028a4 <page_ref>
c0102eaf:	85 c0                	test   %eax,%eax
c0102eb1:	74 24                	je     c0102ed7 <basic_check+0x151>
c0102eb3:	c7 44 24 0c ac 66 10 	movl   $0xc01066ac,0xc(%esp)
c0102eba:	c0 
c0102ebb:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102ec2:	c0 
c0102ec3:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102eca:	00 
c0102ecb:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102ed2:	e8 ef dd ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102eda:	89 04 24             	mov    %eax,(%esp)
c0102edd:	e8 ac f9 ff ff       	call   c010288e <page2pa>
c0102ee2:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ee8:	c1 e2 0c             	shl    $0xc,%edx
c0102eeb:	39 d0                	cmp    %edx,%eax
c0102eed:	72 24                	jb     c0102f13 <basic_check+0x18d>
c0102eef:	c7 44 24 0c e8 66 10 	movl   $0xc01066e8,0xc(%esp)
c0102ef6:	c0 
c0102ef7:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102efe:	c0 
c0102eff:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0102f06:	00 
c0102f07:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102f0e:	e8 b3 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f16:	89 04 24             	mov    %eax,(%esp)
c0102f19:	e8 70 f9 ff ff       	call   c010288e <page2pa>
c0102f1e:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f24:	c1 e2 0c             	shl    $0xc,%edx
c0102f27:	39 d0                	cmp    %edx,%eax
c0102f29:	72 24                	jb     c0102f4f <basic_check+0x1c9>
c0102f2b:	c7 44 24 0c 05 67 10 	movl   $0xc0106705,0xc(%esp)
c0102f32:	c0 
c0102f33:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102f3a:	c0 
c0102f3b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0102f42:	00 
c0102f43:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102f4a:	e8 77 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f52:	89 04 24             	mov    %eax,(%esp)
c0102f55:	e8 34 f9 ff ff       	call   c010288e <page2pa>
c0102f5a:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f60:	c1 e2 0c             	shl    $0xc,%edx
c0102f63:	39 d0                	cmp    %edx,%eax
c0102f65:	72 24                	jb     c0102f8b <basic_check+0x205>
c0102f67:	c7 44 24 0c 22 67 10 	movl   $0xc0106722,0xc(%esp)
c0102f6e:	c0 
c0102f6f:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102f76:	c0 
c0102f77:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0102f7e:	00 
c0102f7f:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102f86:	e8 3b dd ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0102f8b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102f90:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102f96:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f99:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f9c:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102fa9:	89 50 04             	mov    %edx,0x4(%eax)
c0102fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102faf:	8b 50 04             	mov    0x4(%eax),%edx
c0102fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fb5:	89 10                	mov    %edx,(%eax)
c0102fb7:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102fc1:	8b 40 04             	mov    0x4(%eax),%eax
c0102fc4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fc7:	0f 94 c0             	sete   %al
c0102fca:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102fcd:	85 c0                	test   %eax,%eax
c0102fcf:	75 24                	jne    c0102ff5 <basic_check+0x26f>
c0102fd1:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c0102fd8:	c0 
c0102fd9:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102fe0:	c0 
c0102fe1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102fe8:	00 
c0102fe9:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102ff0:	e8 d1 dc ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0102ff5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ffa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102ffd:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103004:	00 00 00 

    assert(alloc_page() == NULL);
c0103007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010300e:	e8 1d 0c 00 00       	call   c0103c30 <alloc_pages>
c0103013:	85 c0                	test   %eax,%eax
c0103015:	74 24                	je     c010303b <basic_check+0x2b5>
c0103017:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c010301e:	c0 
c010301f:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103026:	c0 
c0103027:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010302e:	00 
c010302f:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103036:	e8 8b dc ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c010303b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103042:	00 
c0103043:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103046:	89 04 24             	mov    %eax,(%esp)
c0103049:	e8 1a 0c 00 00       	call   c0103c68 <free_pages>
    free_page(p1);
c010304e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103055:	00 
c0103056:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103059:	89 04 24             	mov    %eax,(%esp)
c010305c:	e8 07 0c 00 00       	call   c0103c68 <free_pages>
    free_page(p2);
c0103061:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103068:	00 
c0103069:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010306c:	89 04 24             	mov    %eax,(%esp)
c010306f:	e8 f4 0b 00 00       	call   c0103c68 <free_pages>
    assert(nr_free == 3);
c0103074:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103079:	83 f8 03             	cmp    $0x3,%eax
c010307c:	74 24                	je     c01030a2 <basic_check+0x31c>
c010307e:	c7 44 24 0c 6b 67 10 	movl   $0xc010676b,0xc(%esp)
c0103085:	c0 
c0103086:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010308d:	c0 
c010308e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103095:	00 
c0103096:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010309d:	e8 24 dc ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01030a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030a9:	e8 82 0b 00 00       	call   c0103c30 <alloc_pages>
c01030ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01030b5:	75 24                	jne    c01030db <basic_check+0x355>
c01030b7:	c7 44 24 0c 31 66 10 	movl   $0xc0106631,0xc(%esp)
c01030be:	c0 
c01030bf:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01030c6:	c0 
c01030c7:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01030ce:	00 
c01030cf:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01030d6:	e8 eb db ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030e2:	e8 49 0b 00 00       	call   c0103c30 <alloc_pages>
c01030e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030ee:	75 24                	jne    c0103114 <basic_check+0x38e>
c01030f0:	c7 44 24 0c 4d 66 10 	movl   $0xc010664d,0xc(%esp)
c01030f7:	c0 
c01030f8:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01030ff:	c0 
c0103100:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103107:	00 
c0103108:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010310f:	e8 b2 db ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010311b:	e8 10 0b 00 00       	call   c0103c30 <alloc_pages>
c0103120:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103127:	75 24                	jne    c010314d <basic_check+0x3c7>
c0103129:	c7 44 24 0c 69 66 10 	movl   $0xc0106669,0xc(%esp)
c0103130:	c0 
c0103131:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103138:	c0 
c0103139:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103140:	00 
c0103141:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103148:	e8 79 db ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c010314d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103154:	e8 d7 0a 00 00       	call   c0103c30 <alloc_pages>
c0103159:	85 c0                	test   %eax,%eax
c010315b:	74 24                	je     c0103181 <basic_check+0x3fb>
c010315d:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103164:	c0 
c0103165:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010316c:	c0 
c010316d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103174:	00 
c0103175:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010317c:	e8 45 db ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c0103181:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103188:	00 
c0103189:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010318c:	89 04 24             	mov    %eax,(%esp)
c010318f:	e8 d4 0a 00 00       	call   c0103c68 <free_pages>
c0103194:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010319b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010319e:	8b 40 04             	mov    0x4(%eax),%eax
c01031a1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01031a4:	0f 94 c0             	sete   %al
c01031a7:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01031aa:	85 c0                	test   %eax,%eax
c01031ac:	74 24                	je     c01031d2 <basic_check+0x44c>
c01031ae:	c7 44 24 0c 78 67 10 	movl   $0xc0106778,0xc(%esp)
c01031b5:	c0 
c01031b6:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01031bd:	c0 
c01031be:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01031c5:	00 
c01031c6:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01031cd:	e8 f4 da ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01031d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031d9:	e8 52 0a 00 00       	call   c0103c30 <alloc_pages>
c01031de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01031e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01031e7:	74 24                	je     c010320d <basic_check+0x487>
c01031e9:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c01031f0:	c0 
c01031f1:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01031f8:	c0 
c01031f9:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103200:	00 
c0103201:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103208:	e8 b9 da ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c010320d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103214:	e8 17 0a 00 00       	call   c0103c30 <alloc_pages>
c0103219:	85 c0                	test   %eax,%eax
c010321b:	74 24                	je     c0103241 <basic_check+0x4bb>
c010321d:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103224:	c0 
c0103225:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010322c:	c0 
c010322d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103234:	00 
c0103235:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010323c:	e8 85 da ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0103241:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103246:	85 c0                	test   %eax,%eax
c0103248:	74 24                	je     c010326e <basic_check+0x4e8>
c010324a:	c7 44 24 0c a9 67 10 	movl   $0xc01067a9,0xc(%esp)
c0103251:	c0 
c0103252:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103259:	c0 
c010325a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103261:	00 
c0103262:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103269:	e8 58 da ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c010326e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103271:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103274:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103279:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103282:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103287:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010328e:	00 
c010328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103292:	89 04 24             	mov    %eax,(%esp)
c0103295:	e8 ce 09 00 00       	call   c0103c68 <free_pages>
    free_page(p1);
c010329a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032a1:	00 
c01032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032a5:	89 04 24             	mov    %eax,(%esp)
c01032a8:	e8 bb 09 00 00       	call   c0103c68 <free_pages>
    free_page(p2);
c01032ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032b4:	00 
c01032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032b8:	89 04 24             	mov    %eax,(%esp)
c01032bb:	e8 a8 09 00 00       	call   c0103c68 <free_pages>
}
c01032c0:	c9                   	leave  
c01032c1:	c3                   	ret    

c01032c2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01032c2:	55                   	push   %ebp
c01032c3:	89 e5                	mov    %esp,%ebp
c01032c5:	53                   	push   %ebx
c01032c6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01032cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01032d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01032da:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01032e1:	eb 6b                	jmp    c010334e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032e6:	83 e8 0c             	sub    $0xc,%eax
c01032e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032ef:	83 c0 04             	add    $0x4,%eax
c01032f2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01032f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01032ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103302:	0f a3 10             	bt     %edx,(%eax)
c0103305:	19 c0                	sbb    %eax,%eax
c0103307:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010330a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010330e:	0f 95 c0             	setne  %al
c0103311:	0f b6 c0             	movzbl %al,%eax
c0103314:	85 c0                	test   %eax,%eax
c0103316:	75 24                	jne    c010333c <default_check+0x7a>
c0103318:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c010331f:	c0 
c0103320:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103327:	c0 
c0103328:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010332f:	00 
c0103330:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103337:	e8 8a d9 ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c010333c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103340:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103343:	8b 50 08             	mov    0x8(%eax),%edx
c0103346:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103349:	01 d0                	add    %edx,%eax
c010334b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010334e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103351:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103354:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103357:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010335a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010335d:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103364:	0f 85 79 ff ff ff    	jne    c01032e3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010336a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010336d:	e8 28 09 00 00       	call   c0103c9a <nr_free_pages>
c0103372:	39 c3                	cmp    %eax,%ebx
c0103374:	74 24                	je     c010339a <default_check+0xd8>
c0103376:	c7 44 24 0c c6 67 10 	movl   $0xc01067c6,0xc(%esp)
c010337d:	c0 
c010337e:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103385:	c0 
c0103386:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010338d:	00 
c010338e:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103395:	e8 2c d9 ff ff       	call   c0100cc6 <__panic>

    basic_check();
c010339a:	e8 e7 f9 ff ff       	call   c0102d86 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010339f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01033a6:	e8 85 08 00 00       	call   c0103c30 <alloc_pages>
c01033ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01033ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033b2:	75 24                	jne    c01033d8 <default_check+0x116>
c01033b4:	c7 44 24 0c df 67 10 	movl   $0xc01067df,0xc(%esp)
c01033bb:	c0 
c01033bc:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01033c3:	c0 
c01033c4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01033cb:	00 
c01033cc:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01033d3:	e8 ee d8 ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c01033d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033db:	83 c0 04             	add    $0x4,%eax
c01033de:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01033e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01033eb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01033ee:	0f a3 10             	bt     %edx,(%eax)
c01033f1:	19 c0                	sbb    %eax,%eax
c01033f3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01033f6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01033fa:	0f 95 c0             	setne  %al
c01033fd:	0f b6 c0             	movzbl %al,%eax
c0103400:	85 c0                	test   %eax,%eax
c0103402:	74 24                	je     c0103428 <default_check+0x166>
c0103404:	c7 44 24 0c ea 67 10 	movl   $0xc01067ea,0xc(%esp)
c010340b:	c0 
c010340c:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103413:	c0 
c0103414:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010341b:	00 
c010341c:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103423:	e8 9e d8 ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0103428:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010342d:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103433:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103436:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103439:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103443:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103446:	89 50 04             	mov    %edx,0x4(%eax)
c0103449:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010344c:	8b 50 04             	mov    0x4(%eax),%edx
c010344f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103452:	89 10                	mov    %edx,(%eax)
c0103454:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010345b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010345e:	8b 40 04             	mov    0x4(%eax),%eax
c0103461:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103464:	0f 94 c0             	sete   %al
c0103467:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010346a:	85 c0                	test   %eax,%eax
c010346c:	75 24                	jne    c0103492 <default_check+0x1d0>
c010346e:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c0103475:	c0 
c0103476:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010347d:	c0 
c010347e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103485:	00 
c0103486:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010348d:	e8 34 d8 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103492:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103499:	e8 92 07 00 00       	call   c0103c30 <alloc_pages>
c010349e:	85 c0                	test   %eax,%eax
c01034a0:	74 24                	je     c01034c6 <default_check+0x204>
c01034a2:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01034a9:	c0 
c01034aa:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01034b1:	c0 
c01034b2:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01034b9:	00 
c01034ba:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01034c1:	e8 00 d8 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c01034c6:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01034cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01034ce:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01034d5:	00 00 00 

    free_pages(p0 + 2, 3);
c01034d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034db:	83 c0 28             	add    $0x28,%eax
c01034de:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01034e5:	00 
c01034e6:	89 04 24             	mov    %eax,(%esp)
c01034e9:	e8 7a 07 00 00       	call   c0103c68 <free_pages>
    assert(alloc_pages(4) == NULL);
c01034ee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01034f5:	e8 36 07 00 00       	call   c0103c30 <alloc_pages>
c01034fa:	85 c0                	test   %eax,%eax
c01034fc:	74 24                	je     c0103522 <default_check+0x260>
c01034fe:	c7 44 24 0c fc 67 10 	movl   $0xc01067fc,0xc(%esp)
c0103505:	c0 
c0103506:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010350d:	c0 
c010350e:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103515:	00 
c0103516:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010351d:	e8 a4 d7 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103525:	83 c0 28             	add    $0x28,%eax
c0103528:	83 c0 04             	add    $0x4,%eax
c010352b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103532:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103535:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103538:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010353b:	0f a3 10             	bt     %edx,(%eax)
c010353e:	19 c0                	sbb    %eax,%eax
c0103540:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103543:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103547:	0f 95 c0             	setne  %al
c010354a:	0f b6 c0             	movzbl %al,%eax
c010354d:	85 c0                	test   %eax,%eax
c010354f:	74 0e                	je     c010355f <default_check+0x29d>
c0103551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103554:	83 c0 28             	add    $0x28,%eax
c0103557:	8b 40 08             	mov    0x8(%eax),%eax
c010355a:	83 f8 03             	cmp    $0x3,%eax
c010355d:	74 24                	je     c0103583 <default_check+0x2c1>
c010355f:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c0103566:	c0 
c0103567:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010356e:	c0 
c010356f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103576:	00 
c0103577:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010357e:	e8 43 d7 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103583:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010358a:	e8 a1 06 00 00       	call   c0103c30 <alloc_pages>
c010358f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103592:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103596:	75 24                	jne    c01035bc <default_check+0x2fa>
c0103598:	c7 44 24 0c 40 68 10 	movl   $0xc0106840,0xc(%esp)
c010359f:	c0 
c01035a0:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01035a7:	c0 
c01035a8:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01035af:	00 
c01035b0:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01035b7:	e8 0a d7 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01035bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035c3:	e8 68 06 00 00       	call   c0103c30 <alloc_pages>
c01035c8:	85 c0                	test   %eax,%eax
c01035ca:	74 24                	je     c01035f0 <default_check+0x32e>
c01035cc:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01035d3:	c0 
c01035d4:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01035db:	c0 
c01035dc:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01035e3:	00 
c01035e4:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01035eb:	e8 d6 d6 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c01035f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035f3:	83 c0 28             	add    $0x28,%eax
c01035f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01035f9:	74 24                	je     c010361f <default_check+0x35d>
c01035fb:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c0103602:	c0 
c0103603:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010360a:	c0 
c010360b:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103612:	00 
c0103613:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010361a:	e8 a7 d6 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c010361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103622:	83 c0 14             	add    $0x14,%eax
c0103625:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103628:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010362f:	00 
c0103630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103633:	89 04 24             	mov    %eax,(%esp)
c0103636:	e8 2d 06 00 00       	call   c0103c68 <free_pages>
    free_pages(p1, 3);
c010363b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103642:	00 
c0103643:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103646:	89 04 24             	mov    %eax,(%esp)
c0103649:	e8 1a 06 00 00       	call   c0103c68 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103651:	83 c0 04             	add    $0x4,%eax
c0103654:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010365b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010365e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103661:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103664:	0f a3 10             	bt     %edx,(%eax)
c0103667:	19 c0                	sbb    %eax,%eax
c0103669:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010366c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103670:	0f 95 c0             	setne  %al
c0103673:	0f b6 c0             	movzbl %al,%eax
c0103676:	85 c0                	test   %eax,%eax
c0103678:	74 0b                	je     c0103685 <default_check+0x3c3>
c010367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010367d:	8b 40 08             	mov    0x8(%eax),%eax
c0103680:	83 f8 01             	cmp    $0x1,%eax
c0103683:	74 24                	je     c01036a9 <default_check+0x3e7>
c0103685:	c7 44 24 0c 6c 68 10 	movl   $0xc010686c,0xc(%esp)
c010368c:	c0 
c010368d:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103694:	c0 
c0103695:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010369c:	00 
c010369d:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01036a4:	e8 1d d6 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01036a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036ac:	83 c0 04             	add    $0x4,%eax
c01036af:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01036b6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01036bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01036bf:	0f a3 10             	bt     %edx,(%eax)
c01036c2:	19 c0                	sbb    %eax,%eax
c01036c4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01036c7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01036cb:	0f 95 c0             	setne  %al
c01036ce:	0f b6 c0             	movzbl %al,%eax
c01036d1:	85 c0                	test   %eax,%eax
c01036d3:	74 0b                	je     c01036e0 <default_check+0x41e>
c01036d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036d8:	8b 40 08             	mov    0x8(%eax),%eax
c01036db:	83 f8 03             	cmp    $0x3,%eax
c01036de:	74 24                	je     c0103704 <default_check+0x442>
c01036e0:	c7 44 24 0c 94 68 10 	movl   $0xc0106894,0xc(%esp)
c01036e7:	c0 
c01036e8:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01036ef:	c0 
c01036f0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01036f7:	00 
c01036f8:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01036ff:	e8 c2 d5 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103704:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010370b:	e8 20 05 00 00       	call   c0103c30 <alloc_pages>
c0103710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103713:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103716:	83 e8 14             	sub    $0x14,%eax
c0103719:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010371c:	74 24                	je     c0103742 <default_check+0x480>
c010371e:	c7 44 24 0c ba 68 10 	movl   $0xc01068ba,0xc(%esp)
c0103725:	c0 
c0103726:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010372d:	c0 
c010372e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103735:	00 
c0103736:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010373d:	e8 84 d5 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c0103742:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103749:	00 
c010374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010374d:	89 04 24             	mov    %eax,(%esp)
c0103750:	e8 13 05 00 00       	call   c0103c68 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103755:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010375c:	e8 cf 04 00 00       	call   c0103c30 <alloc_pages>
c0103761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103764:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103767:	83 c0 14             	add    $0x14,%eax
c010376a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010376d:	74 24                	je     c0103793 <default_check+0x4d1>
c010376f:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c0103776:	c0 
c0103777:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010377e:	c0 
c010377f:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103786:	00 
c0103787:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010378e:	e8 33 d5 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c0103793:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010379a:	00 
c010379b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010379e:	89 04 24             	mov    %eax,(%esp)
c01037a1:	e8 c2 04 00 00       	call   c0103c68 <free_pages>
    free_page(p2);
c01037a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037ad:	00 
c01037ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037b1:	89 04 24             	mov    %eax,(%esp)
c01037b4:	e8 af 04 00 00       	call   c0103c68 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01037b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037c0:	e8 6b 04 00 00       	call   c0103c30 <alloc_pages>
c01037c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037cc:	75 24                	jne    c01037f2 <default_check+0x530>
c01037ce:	c7 44 24 0c f8 68 10 	movl   $0xc01068f8,0xc(%esp)
c01037d5:	c0 
c01037d6:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01037dd:	c0 
c01037de:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01037e5:	00 
c01037e6:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01037ed:	e8 d4 d4 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01037f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037f9:	e8 32 04 00 00       	call   c0103c30 <alloc_pages>
c01037fe:	85 c0                	test   %eax,%eax
c0103800:	74 24                	je     c0103826 <default_check+0x564>
c0103802:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103809:	c0 
c010380a:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103811:	c0 
c0103812:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103819:	00 
c010381a:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103821:	e8 a0 d4 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0103826:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010382b:	85 c0                	test   %eax,%eax
c010382d:	74 24                	je     c0103853 <default_check+0x591>
c010382f:	c7 44 24 0c a9 67 10 	movl   $0xc01067a9,0xc(%esp)
c0103836:	c0 
c0103837:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010383e:	c0 
c010383f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103846:	00 
c0103847:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010384e:	e8 73 d4 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c0103853:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103856:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c010385b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010385e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103861:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103866:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010386c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103873:	00 
c0103874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103877:	89 04 24             	mov    %eax,(%esp)
c010387a:	e8 e9 03 00 00       	call   c0103c68 <free_pages>

    le = &free_list;
c010387f:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103886:	eb 1d                	jmp    c01038a5 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103888:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010388b:	83 e8 0c             	sub    $0xc,%eax
c010388e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103891:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103895:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010389b:	8b 40 08             	mov    0x8(%eax),%eax
c010389e:	29 c2                	sub    %eax,%edx
c01038a0:	89 d0                	mov    %edx,%eax
c01038a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038a8:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01038ab:	8b 45 88             	mov    -0x78(%ebp),%eax
c01038ae:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01038b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038b4:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01038bb:	75 cb                	jne    c0103888 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01038bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038c1:	74 24                	je     c01038e7 <default_check+0x625>
c01038c3:	c7 44 24 0c 16 69 10 	movl   $0xc0106916,0xc(%esp)
c01038ca:	c0 
c01038cb:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01038d2:	c0 
c01038d3:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01038da:	00 
c01038db:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01038e2:	e8 df d3 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c01038e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038eb:	74 24                	je     c0103911 <default_check+0x64f>
c01038ed:	c7 44 24 0c 21 69 10 	movl   $0xc0106921,0xc(%esp)
c01038f4:	c0 
c01038f5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01038fc:	c0 
c01038fd:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103904:	00 
c0103905:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010390c:	e8 b5 d3 ff ff       	call   c0100cc6 <__panic>
}
c0103911:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103917:	5b                   	pop    %ebx
c0103918:	5d                   	pop    %ebp
c0103919:	c3                   	ret    

c010391a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010391a:	55                   	push   %ebp
c010391b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010391d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103920:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103925:	29 c2                	sub    %eax,%edx
c0103927:	89 d0                	mov    %edx,%eax
c0103929:	c1 f8 02             	sar    $0x2,%eax
c010392c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103932:	5d                   	pop    %ebp
c0103933:	c3                   	ret    

c0103934 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103934:	55                   	push   %ebp
c0103935:	89 e5                	mov    %esp,%ebp
c0103937:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010393a:	8b 45 08             	mov    0x8(%ebp),%eax
c010393d:	89 04 24             	mov    %eax,(%esp)
c0103940:	e8 d5 ff ff ff       	call   c010391a <page2ppn>
c0103945:	c1 e0 0c             	shl    $0xc,%eax
}
c0103948:	c9                   	leave  
c0103949:	c3                   	ret    

c010394a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010394a:	55                   	push   %ebp
c010394b:	89 e5                	mov    %esp,%ebp
c010394d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103950:	8b 45 08             	mov    0x8(%ebp),%eax
c0103953:	c1 e8 0c             	shr    $0xc,%eax
c0103956:	89 c2                	mov    %eax,%edx
c0103958:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010395d:	39 c2                	cmp    %eax,%edx
c010395f:	72 1c                	jb     c010397d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103961:	c7 44 24 08 5c 69 10 	movl   $0xc010695c,0x8(%esp)
c0103968:	c0 
c0103969:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103970:	00 
c0103971:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c0103978:	e8 49 d3 ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c010397d:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103983:	8b 45 08             	mov    0x8(%ebp),%eax
c0103986:	c1 e8 0c             	shr    $0xc,%eax
c0103989:	89 c2                	mov    %eax,%edx
c010398b:	89 d0                	mov    %edx,%eax
c010398d:	c1 e0 02             	shl    $0x2,%eax
c0103990:	01 d0                	add    %edx,%eax
c0103992:	c1 e0 02             	shl    $0x2,%eax
c0103995:	01 c8                	add    %ecx,%eax
}
c0103997:	c9                   	leave  
c0103998:	c3                   	ret    

c0103999 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103999:	55                   	push   %ebp
c010399a:	89 e5                	mov    %esp,%ebp
c010399c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010399f:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a2:	89 04 24             	mov    %eax,(%esp)
c01039a5:	e8 8a ff ff ff       	call   c0103934 <page2pa>
c01039aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b0:	c1 e8 0c             	shr    $0xc,%eax
c01039b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039b6:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039bb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01039be:	72 23                	jb     c01039e3 <page2kva+0x4a>
c01039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039c7:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c01039ce:	c0 
c01039cf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01039d6:	00 
c01039d7:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c01039de:	e8 e3 d2 ff ff       	call   c0100cc6 <__panic>
c01039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01039eb:	c9                   	leave  
c01039ec:	c3                   	ret    

c01039ed <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01039ed:	55                   	push   %ebp
c01039ee:	89 e5                	mov    %esp,%ebp
c01039f0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01039f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f6:	83 e0 01             	and    $0x1,%eax
c01039f9:	85 c0                	test   %eax,%eax
c01039fb:	75 1c                	jne    c0103a19 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01039fd:	c7 44 24 08 b0 69 10 	movl   $0xc01069b0,0x8(%esp)
c0103a04:	c0 
c0103a05:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a0c:	00 
c0103a0d:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c0103a14:	e8 ad d2 ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a21:	89 04 24             	mov    %eax,(%esp)
c0103a24:	e8 21 ff ff ff       	call   c010394a <pa2page>
}
c0103a29:	c9                   	leave  
c0103a2a:	c3                   	ret    

c0103a2b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103a2b:	55                   	push   %ebp
c0103a2c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a31:	8b 00                	mov    (%eax),%eax
}
c0103a33:	5d                   	pop    %ebp
c0103a34:	c3                   	ret    

c0103a35 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103a35:	55                   	push   %ebp
c0103a36:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a3e:	89 10                	mov    %edx,(%eax)
}
c0103a40:	5d                   	pop    %ebp
c0103a41:	c3                   	ret    

c0103a42 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103a42:	55                   	push   %ebp
c0103a43:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103a45:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a48:	8b 00                	mov    (%eax),%eax
c0103a4a:	8d 50 01             	lea    0x1(%eax),%edx
c0103a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a50:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a55:	8b 00                	mov    (%eax),%eax
}
c0103a57:	5d                   	pop    %ebp
c0103a58:	c3                   	ret    

c0103a59 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103a59:	55                   	push   %ebp
c0103a5a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5f:	8b 00                	mov    (%eax),%eax
c0103a61:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a67:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6c:	8b 00                	mov    (%eax),%eax
}
c0103a6e:	5d                   	pop    %ebp
c0103a6f:	c3                   	ret    

c0103a70 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103a70:	55                   	push   %ebp
c0103a71:	89 e5                	mov    %esp,%ebp
c0103a73:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a76:	9c                   	pushf  
c0103a77:	58                   	pop    %eax
c0103a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a7e:	25 00 02 00 00       	and    $0x200,%eax
c0103a83:	85 c0                	test   %eax,%eax
c0103a85:	74 0c                	je     c0103a93 <__intr_save+0x23>
        intr_disable();
c0103a87:	e8 1d dc ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0103a8c:	b8 01 00 00 00       	mov    $0x1,%eax
c0103a91:	eb 05                	jmp    c0103a98 <__intr_save+0x28>
    }
    return 0;
c0103a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a98:	c9                   	leave  
c0103a99:	c3                   	ret    

c0103a9a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103a9a:	55                   	push   %ebp
c0103a9b:	89 e5                	mov    %esp,%ebp
c0103a9d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103aa4:	74 05                	je     c0103aab <__intr_restore+0x11>
        intr_enable();
c0103aa6:	e8 f8 db ff ff       	call   c01016a3 <intr_enable>
    }
}
c0103aab:	c9                   	leave  
c0103aac:	c3                   	ret    

c0103aad <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103aad:	55                   	push   %ebp
c0103aae:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ab6:	b8 23 00 00 00       	mov    $0x23,%eax
c0103abb:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103abd:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ac2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103ac4:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ac9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103acb:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ad0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103ad2:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ad7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103ad9:	ea e0 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103ae0
}
c0103ae0:	5d                   	pop    %ebp
c0103ae1:	c3                   	ret    

c0103ae2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103ae2:	55                   	push   %ebp
c0103ae3:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae8:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103aed:	5d                   	pop    %ebp
c0103aee:	c3                   	ret    

c0103aef <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103aef:	55                   	push   %ebp
c0103af0:	89 e5                	mov    %esp,%ebp
c0103af2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103af5:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103afa:	89 04 24             	mov    %eax,(%esp)
c0103afd:	e8 e0 ff ff ff       	call   c0103ae2 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b02:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b09:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b0b:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b12:	68 00 
c0103b14:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b19:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103b1f:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b24:	c1 e8 10             	shr    $0x10,%eax
c0103b27:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103b2c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b33:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b36:	83 c8 09             	or     $0x9,%eax
c0103b39:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b3e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b45:	83 e0 ef             	and    $0xffffffef,%eax
c0103b48:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b4d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b54:	83 e0 9f             	and    $0xffffff9f,%eax
c0103b57:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b5c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b63:	83 c8 80             	or     $0xffffff80,%eax
c0103b66:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b6b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b72:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b75:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b7a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b81:	83 e0 ef             	and    $0xffffffef,%eax
c0103b84:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b89:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b90:	83 e0 df             	and    $0xffffffdf,%eax
c0103b93:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b98:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b9f:	83 c8 40             	or     $0x40,%eax
c0103ba2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ba7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bae:	83 e0 7f             	and    $0x7f,%eax
c0103bb1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bb6:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bbb:	c1 e8 18             	shr    $0x18,%eax
c0103bbe:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103bc3:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103bca:	e8 de fe ff ff       	call   c0103aad <lgdt>
c0103bcf:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103bd5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103bd9:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103bdc:	c9                   	leave  
c0103bdd:	c3                   	ret    

c0103bde <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103bde:	55                   	push   %ebp
c0103bdf:	89 e5                	mov    %esp,%ebp
c0103be1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103be4:	c7 05 5c 89 11 c0 40 	movl   $0xc0106940,0xc011895c
c0103beb:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103bee:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103bf3:	8b 00                	mov    (%eax),%eax
c0103bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bf9:	c7 04 24 dc 69 10 c0 	movl   $0xc01069dc,(%esp)
c0103c00:	e8 37 c7 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c05:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c0a:	8b 40 04             	mov    0x4(%eax),%eax
c0103c0d:	ff d0                	call   *%eax
}
c0103c0f:	c9                   	leave  
c0103c10:	c3                   	ret    

c0103c11 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c11:	55                   	push   %ebp
c0103c12:	89 e5                	mov    %esp,%ebp
c0103c14:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c17:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c1c:	8b 40 08             	mov    0x8(%eax),%eax
c0103c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c26:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c29:	89 14 24             	mov    %edx,(%esp)
c0103c2c:	ff d0                	call   *%eax
}
c0103c2e:	c9                   	leave  
c0103c2f:	c3                   	ret    

c0103c30 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103c30:	55                   	push   %ebp
c0103c31:	89 e5                	mov    %esp,%ebp
c0103c33:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c3d:	e8 2e fe ff ff       	call   c0103a70 <__intr_save>
c0103c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103c45:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c4a:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c50:	89 14 24             	mov    %edx,(%esp)
c0103c53:	ff d0                	call   *%eax
c0103c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c5b:	89 04 24             	mov    %eax,(%esp)
c0103c5e:	e8 37 fe ff ff       	call   c0103a9a <__intr_restore>
    return page;
c0103c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c66:	c9                   	leave  
c0103c67:	c3                   	ret    

c0103c68 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c68:	55                   	push   %ebp
c0103c69:	89 e5                	mov    %esp,%ebp
c0103c6b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c6e:	e8 fd fd ff ff       	call   c0103a70 <__intr_save>
c0103c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c76:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c7b:	8b 40 10             	mov    0x10(%eax),%eax
c0103c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c81:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c85:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c88:	89 14 24             	mov    %edx,(%esp)
c0103c8b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c90:	89 04 24             	mov    %eax,(%esp)
c0103c93:	e8 02 fe ff ff       	call   c0103a9a <__intr_restore>
}
c0103c98:	c9                   	leave  
c0103c99:	c3                   	ret    

c0103c9a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c9a:	55                   	push   %ebp
c0103c9b:	89 e5                	mov    %esp,%ebp
c0103c9d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ca0:	e8 cb fd ff ff       	call   c0103a70 <__intr_save>
c0103ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103ca8:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cad:	8b 40 14             	mov    0x14(%eax),%eax
c0103cb0:	ff d0                	call   *%eax
c0103cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb8:	89 04 24             	mov    %eax,(%esp)
c0103cbb:	e8 da fd ff ff       	call   c0103a9a <__intr_restore>
    return ret;
c0103cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103cc3:	c9                   	leave  
c0103cc4:	c3                   	ret    

c0103cc5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103cc5:	55                   	push   %ebp
c0103cc6:	89 e5                	mov    %esp,%ebp
c0103cc8:	57                   	push   %edi
c0103cc9:	56                   	push   %esi
c0103cca:	53                   	push   %ebx
c0103ccb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103cd1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103cd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103ce6:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0103ced:	e8 4a c6 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103cf2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103cf9:	e9 15 01 00 00       	jmp    c0103e13 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103cfe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d04:	89 d0                	mov    %edx,%eax
c0103d06:	c1 e0 02             	shl    $0x2,%eax
c0103d09:	01 d0                	add    %edx,%eax
c0103d0b:	c1 e0 02             	shl    $0x2,%eax
c0103d0e:	01 c8                	add    %ecx,%eax
c0103d10:	8b 50 08             	mov    0x8(%eax),%edx
c0103d13:	8b 40 04             	mov    0x4(%eax),%eax
c0103d16:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d19:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103d1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d22:	89 d0                	mov    %edx,%eax
c0103d24:	c1 e0 02             	shl    $0x2,%eax
c0103d27:	01 d0                	add    %edx,%eax
c0103d29:	c1 e0 02             	shl    $0x2,%eax
c0103d2c:	01 c8                	add    %ecx,%eax
c0103d2e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d31:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d34:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d37:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d3a:	01 c8                	add    %ecx,%eax
c0103d3c:	11 da                	adc    %ebx,%edx
c0103d3e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103d41:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103d44:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d47:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d4a:	89 d0                	mov    %edx,%eax
c0103d4c:	c1 e0 02             	shl    $0x2,%eax
c0103d4f:	01 d0                	add    %edx,%eax
c0103d51:	c1 e0 02             	shl    $0x2,%eax
c0103d54:	01 c8                	add    %ecx,%eax
c0103d56:	83 c0 14             	add    $0x14,%eax
c0103d59:	8b 00                	mov    (%eax),%eax
c0103d5b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103d61:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d64:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d67:	83 c0 ff             	add    $0xffffffff,%eax
c0103d6a:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d6d:	89 c6                	mov    %eax,%esi
c0103d6f:	89 d7                	mov    %edx,%edi
c0103d71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d77:	89 d0                	mov    %edx,%eax
c0103d79:	c1 e0 02             	shl    $0x2,%eax
c0103d7c:	01 d0                	add    %edx,%eax
c0103d7e:	c1 e0 02             	shl    $0x2,%eax
c0103d81:	01 c8                	add    %ecx,%eax
c0103d83:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d86:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d89:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103d8f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103d93:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103d97:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103d9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d9e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103da1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103da5:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103da9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103dad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103db1:	c7 04 24 00 6a 10 c0 	movl   $0xc0106a00,(%esp)
c0103db8:	e8 7f c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103dbd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dc3:	89 d0                	mov    %edx,%eax
c0103dc5:	c1 e0 02             	shl    $0x2,%eax
c0103dc8:	01 d0                	add    %edx,%eax
c0103dca:	c1 e0 02             	shl    $0x2,%eax
c0103dcd:	01 c8                	add    %ecx,%eax
c0103dcf:	83 c0 14             	add    $0x14,%eax
c0103dd2:	8b 00                	mov    (%eax),%eax
c0103dd4:	83 f8 01             	cmp    $0x1,%eax
c0103dd7:	75 36                	jne    c0103e0f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ddf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103de2:	77 2b                	ja     c0103e0f <page_init+0x14a>
c0103de4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103de7:	72 05                	jb     c0103dee <page_init+0x129>
c0103de9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103dec:	73 21                	jae    c0103e0f <page_init+0x14a>
c0103dee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103df2:	77 1b                	ja     c0103e0f <page_init+0x14a>
c0103df4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103df8:	72 09                	jb     c0103e03 <page_init+0x13e>
c0103dfa:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e01:	77 0c                	ja     c0103e0f <page_init+0x14a>
                maxpa = end;
c0103e03:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e09:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e0f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e16:	8b 00                	mov    (%eax),%eax
c0103e18:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e1b:	0f 8f dd fe ff ff    	jg     c0103cfe <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103e21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e25:	72 1d                	jb     c0103e44 <page_init+0x17f>
c0103e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e2b:	77 09                	ja     c0103e36 <page_init+0x171>
c0103e2d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103e34:	76 0e                	jbe    c0103e44 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103e36:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103e3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e4a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103e4e:	c1 ea 0c             	shr    $0xc,%edx
c0103e51:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103e56:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103e5d:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103e62:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103e65:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103e68:	01 d0                	add    %edx,%eax
c0103e6a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103e6d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103e70:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e75:	f7 75 ac             	divl   -0x54(%ebp)
c0103e78:	89 d0                	mov    %edx,%eax
c0103e7a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103e7d:	29 c2                	sub    %eax,%edx
c0103e7f:	89 d0                	mov    %edx,%eax
c0103e81:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103e86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e8d:	eb 2f                	jmp    c0103ebe <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103e8f:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e98:	89 d0                	mov    %edx,%eax
c0103e9a:	c1 e0 02             	shl    $0x2,%eax
c0103e9d:	01 d0                	add    %edx,%eax
c0103e9f:	c1 e0 02             	shl    $0x2,%eax
c0103ea2:	01 c8                	add    %ecx,%eax
c0103ea4:	83 c0 04             	add    $0x4,%eax
c0103ea7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103eae:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103eb1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103eb4:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103eb7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103eba:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ebe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ec1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103ec6:	39 c2                	cmp    %eax,%edx
c0103ec8:	72 c5                	jb     c0103e8f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103eca:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103ed0:	89 d0                	mov    %edx,%eax
c0103ed2:	c1 e0 02             	shl    $0x2,%eax
c0103ed5:	01 d0                	add    %edx,%eax
c0103ed7:	c1 e0 02             	shl    $0x2,%eax
c0103eda:	89 c2                	mov    %eax,%edx
c0103edc:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103ee1:	01 d0                	add    %edx,%eax
c0103ee3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103ee6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103eed:	77 23                	ja     c0103f12 <page_init+0x24d>
c0103eef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103ef2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ef6:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c0103efd:	c0 
c0103efe:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f05:	00 
c0103f06:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0103f0d:	e8 b4 cd ff ff       	call   c0100cc6 <__panic>
c0103f12:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f15:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f1a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f24:	e9 74 01 00 00       	jmp    c010409d <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f29:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f2f:	89 d0                	mov    %edx,%eax
c0103f31:	c1 e0 02             	shl    $0x2,%eax
c0103f34:	01 d0                	add    %edx,%eax
c0103f36:	c1 e0 02             	shl    $0x2,%eax
c0103f39:	01 c8                	add    %ecx,%eax
c0103f3b:	8b 50 08             	mov    0x8(%eax),%edx
c0103f3e:	8b 40 04             	mov    0x4(%eax),%eax
c0103f41:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103f47:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f4d:	89 d0                	mov    %edx,%eax
c0103f4f:	c1 e0 02             	shl    $0x2,%eax
c0103f52:	01 d0                	add    %edx,%eax
c0103f54:	c1 e0 02             	shl    $0x2,%eax
c0103f57:	01 c8                	add    %ecx,%eax
c0103f59:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f5c:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f65:	01 c8                	add    %ecx,%eax
c0103f67:	11 da                	adc    %ebx,%edx
c0103f69:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103f6c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103f6f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f72:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f75:	89 d0                	mov    %edx,%eax
c0103f77:	c1 e0 02             	shl    $0x2,%eax
c0103f7a:	01 d0                	add    %edx,%eax
c0103f7c:	c1 e0 02             	shl    $0x2,%eax
c0103f7f:	01 c8                	add    %ecx,%eax
c0103f81:	83 c0 14             	add    $0x14,%eax
c0103f84:	8b 00                	mov    (%eax),%eax
c0103f86:	83 f8 01             	cmp    $0x1,%eax
c0103f89:	0f 85 0a 01 00 00    	jne    c0104099 <page_init+0x3d4>
            if (begin < freemem) {
c0103f8f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f92:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f97:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f9a:	72 17                	jb     c0103fb3 <page_init+0x2ee>
c0103f9c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f9f:	77 05                	ja     c0103fa6 <page_init+0x2e1>
c0103fa1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103fa4:	76 0d                	jbe    c0103fb3 <page_init+0x2ee>
                begin = freemem;
c0103fa6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103fa9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103fb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fb7:	72 1d                	jb     c0103fd6 <page_init+0x311>
c0103fb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fbd:	77 09                	ja     c0103fc8 <page_init+0x303>
c0103fbf:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103fc6:	76 0e                	jbe    c0103fd6 <page_init+0x311>
                end = KMEMSIZE;
c0103fc8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103fcf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103fd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fdc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103fdf:	0f 87 b4 00 00 00    	ja     c0104099 <page_init+0x3d4>
c0103fe5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103fe8:	72 09                	jb     c0103ff3 <page_init+0x32e>
c0103fea:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103fed:	0f 83 a6 00 00 00    	jae    c0104099 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103ff3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103ffa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103ffd:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104000:	01 d0                	add    %edx,%eax
c0104002:	83 e8 01             	sub    $0x1,%eax
c0104005:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104008:	8b 45 98             	mov    -0x68(%ebp),%eax
c010400b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104010:	f7 75 9c             	divl   -0x64(%ebp)
c0104013:	89 d0                	mov    %edx,%eax
c0104015:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104018:	29 c2                	sub    %eax,%edx
c010401a:	89 d0                	mov    %edx,%eax
c010401c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104021:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104024:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104027:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010402a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010402d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104030:	ba 00 00 00 00       	mov    $0x0,%edx
c0104035:	89 c7                	mov    %eax,%edi
c0104037:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010403d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104040:	89 d0                	mov    %edx,%eax
c0104042:	83 e0 00             	and    $0x0,%eax
c0104045:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104048:	8b 45 80             	mov    -0x80(%ebp),%eax
c010404b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010404e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104051:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104054:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104057:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010405a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010405d:	77 3a                	ja     c0104099 <page_init+0x3d4>
c010405f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104062:	72 05                	jb     c0104069 <page_init+0x3a4>
c0104064:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104067:	73 30                	jae    c0104099 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104069:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010406c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010406f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104072:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104075:	29 c8                	sub    %ecx,%eax
c0104077:	19 da                	sbb    %ebx,%edx
c0104079:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010407d:	c1 ea 0c             	shr    $0xc,%edx
c0104080:	89 c3                	mov    %eax,%ebx
c0104082:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104085:	89 04 24             	mov    %eax,(%esp)
c0104088:	e8 bd f8 ff ff       	call   c010394a <pa2page>
c010408d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104091:	89 04 24             	mov    %eax,(%esp)
c0104094:	e8 78 fb ff ff       	call   c0103c11 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104099:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010409d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040a0:	8b 00                	mov    (%eax),%eax
c01040a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040a5:	0f 8f 7e fe ff ff    	jg     c0103f29 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01040ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01040b1:	5b                   	pop    %ebx
c01040b2:	5e                   	pop    %esi
c01040b3:	5f                   	pop    %edi
c01040b4:	5d                   	pop    %ebp
c01040b5:	c3                   	ret    

c01040b6 <enable_paging>:

static void
enable_paging(void) {
c01040b6:	55                   	push   %ebp
c01040b7:	89 e5                	mov    %esp,%ebp
c01040b9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01040bc:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01040c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01040c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01040c7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01040ca:	0f 20 c0             	mov    %cr0,%eax
c01040cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01040d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01040d6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01040dd:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01040e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01040e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040ea:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01040ed:	c9                   	leave  
c01040ee:	c3                   	ret    

c01040ef <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01040ef:	55                   	push   %ebp
c01040f0:	89 e5                	mov    %esp,%ebp
c01040f2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01040f5:	8b 45 14             	mov    0x14(%ebp),%eax
c01040f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040fb:	31 d0                	xor    %edx,%eax
c01040fd:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104102:	85 c0                	test   %eax,%eax
c0104104:	74 24                	je     c010412a <boot_map_segment+0x3b>
c0104106:	c7 44 24 0c 62 6a 10 	movl   $0xc0106a62,0xc(%esp)
c010410d:	c0 
c010410e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104115:	c0 
c0104116:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010411d:	00 
c010411e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104125:	e8 9c cb ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010412a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104131:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104134:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104139:	89 c2                	mov    %eax,%edx
c010413b:	8b 45 10             	mov    0x10(%ebp),%eax
c010413e:	01 c2                	add    %eax,%edx
c0104140:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104143:	01 d0                	add    %edx,%eax
c0104145:	83 e8 01             	sub    $0x1,%eax
c0104148:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010414b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010414e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104153:	f7 75 f0             	divl   -0x10(%ebp)
c0104156:	89 d0                	mov    %edx,%eax
c0104158:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010415b:	29 c2                	sub    %eax,%edx
c010415d:	89 d0                	mov    %edx,%eax
c010415f:	c1 e8 0c             	shr    $0xc,%eax
c0104162:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104165:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104168:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010416b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010416e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104173:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104176:	8b 45 14             	mov    0x14(%ebp),%eax
c0104179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010417c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104184:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104187:	eb 6b                	jmp    c01041f4 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104189:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104190:	00 
c0104191:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104194:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104198:	8b 45 08             	mov    0x8(%ebp),%eax
c010419b:	89 04 24             	mov    %eax,(%esp)
c010419e:	e8 cc 01 00 00       	call   c010436f <get_pte>
c01041a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01041a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01041aa:	75 24                	jne    c01041d0 <boot_map_segment+0xe1>
c01041ac:	c7 44 24 0c 8e 6a 10 	movl   $0xc0106a8e,0xc(%esp)
c01041b3:	c0 
c01041b4:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01041bb:	c0 
c01041bc:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01041c3:	00 
c01041c4:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01041cb:	e8 f6 ca ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c01041d0:	8b 45 18             	mov    0x18(%ebp),%eax
c01041d3:	8b 55 14             	mov    0x14(%ebp),%edx
c01041d6:	09 d0                	or     %edx,%eax
c01041d8:	83 c8 01             	or     $0x1,%eax
c01041db:	89 c2                	mov    %eax,%edx
c01041dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041e0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01041e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041e6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01041ed:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01041f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041f8:	75 8f                	jne    c0104189 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01041fa:	c9                   	leave  
c01041fb:	c3                   	ret    

c01041fc <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01041fc:	55                   	push   %ebp
c01041fd:	89 e5                	mov    %esp,%ebp
c01041ff:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104209:	e8 22 fa ff ff       	call   c0103c30 <alloc_pages>
c010420e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104215:	75 1c                	jne    c0104233 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104217:	c7 44 24 08 9b 6a 10 	movl   $0xc0106a9b,0x8(%esp)
c010421e:	c0 
c010421f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104226:	00 
c0104227:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010422e:	e8 93 ca ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c0104233:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104236:	89 04 24             	mov    %eax,(%esp)
c0104239:	e8 5b f7 ff ff       	call   c0103999 <page2kva>
}
c010423e:	c9                   	leave  
c010423f:	c3                   	ret    

c0104240 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104240:	55                   	push   %ebp
c0104241:	89 e5                	mov    %esp,%ebp
c0104243:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104246:	e8 93 f9 ff ff       	call   c0103bde <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010424b:	e8 75 fa ff ff       	call   c0103cc5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104250:	e8 7b 04 00 00       	call   c01046d0 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104255:	e8 a2 ff ff ff       	call   c01041fc <boot_alloc_page>
c010425a:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010425f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104264:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010426b:	00 
c010426c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104273:	00 
c0104274:	89 04 24             	mov    %eax,(%esp)
c0104277:	e8 bd 1a 00 00       	call   c0105d39 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010427c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104281:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104284:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010428b:	77 23                	ja     c01042b0 <pmm_init+0x70>
c010428d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104290:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104294:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c010429b:	c0 
c010429c:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01042a3:	00 
c01042a4:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01042ab:	e8 16 ca ff ff       	call   c0100cc6 <__panic>
c01042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b3:	05 00 00 00 40       	add    $0x40000000,%eax
c01042b8:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01042bd:	e8 2c 04 00 00       	call   c01046ee <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01042c2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042c7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01042cd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042d5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01042dc:	77 23                	ja     c0104301 <pmm_init+0xc1>
c01042de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042e5:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c01042ec:	c0 
c01042ed:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01042f4:	00 
c01042f5:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01042fc:	e8 c5 c9 ff ff       	call   c0100cc6 <__panic>
c0104301:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104304:	05 00 00 00 40       	add    $0x40000000,%eax
c0104309:	83 c8 03             	or     $0x3,%eax
c010430c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010430e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104313:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010431a:	00 
c010431b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104322:	00 
c0104323:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010432a:	38 
c010432b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104332:	c0 
c0104333:	89 04 24             	mov    %eax,(%esp)
c0104336:	e8 b4 fd ff ff       	call   c01040ef <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010433b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104340:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104346:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010434c:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010434e:	e8 63 fd ff ff       	call   c01040b6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104353:	e8 97 f7 ff ff       	call   c0103aef <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104358:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010435d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104363:	e8 21 0a 00 00       	call   c0104d89 <check_boot_pgdir>

    print_pgdir();
c0104368:	e8 ae 0e 00 00       	call   c010521b <print_pgdir>

}
c010436d:	c9                   	leave  
c010436e:	c3                   	ret    

c010436f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010436f:	55                   	push   %ebp
c0104370:	89 e5                	mov    %esp,%ebp
c0104372:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104375:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104378:	c1 e8 16             	shr    $0x16,%eax
c010437b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104382:	8b 45 08             	mov    0x8(%ebp),%eax
c0104385:	01 d0                	add    %edx,%eax
c0104387:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page * page;
    if (!((*pdep) & PTE_P)) {
c010438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010438d:	8b 00                	mov    (%eax),%eax
c010438f:	83 e0 01             	and    $0x1,%eax
c0104392:	85 c0                	test   %eax,%eax
c0104394:	0f 85 b9 00 00 00    	jne    c0104453 <get_pte+0xe4>
        if (!create) {
c010439a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010439e:	75 0a                	jne    c01043aa <get_pte+0x3b>
            return NULL;
c01043a0:	b8 00 00 00 00       	mov    $0x0,%eax
c01043a5:	e9 05 01 00 00       	jmp    c01044af <get_pte+0x140>
        }
        page = alloc_page();
c01043aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043b1:	e8 7a f8 ff ff       	call   c0103c30 <alloc_pages>
c01043b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL) return NULL;
c01043b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043bd:	75 0a                	jne    c01043c9 <get_pte+0x5a>
c01043bf:	b8 00 00 00 00       	mov    $0x0,%eax
c01043c4:	e9 e6 00 00 00       	jmp    c01044af <get_pte+0x140>
        set_page_ref(page, 1);
c01043c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043d0:	00 
c01043d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d4:	89 04 24             	mov    %eax,(%esp)
c01043d7:	e8 59 f6 ff ff       	call   c0103a35 <set_page_ref>
        uintptr_t page_addr = page2pa(page);
c01043dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043df:	89 04 24             	mov    %eax,(%esp)
c01043e2:	e8 4d f5 ff ff       	call   c0103934 <page2pa>
c01043e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(page_addr), 0, PGSIZE);
c01043ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f3:	c1 e8 0c             	shr    $0xc,%eax
c01043f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043f9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01043fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104401:	72 23                	jb     c0104426 <get_pte+0xb7>
c0104403:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104406:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010440a:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104411:	c0 
c0104412:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c0104419:	00 
c010441a:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104421:	e8 a0 c8 ff ff       	call   c0100cc6 <__panic>
c0104426:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104429:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010442e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104435:	00 
c0104436:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010443d:	00 
c010443e:	89 04 24             	mov    %eax,(%esp)
c0104441:	e8 f3 18 00 00       	call   c0105d39 <memset>
        *pdep = page_addr | PTE_P | PTE_W | PTE_U;
c0104446:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104449:	83 c8 07             	or     $0x7,%eax
c010444c:	89 c2                	mov    %eax,%edx
c010444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104451:	89 10                	mov    %edx,(%eax)
    }
    return &(((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]);
c0104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104456:	8b 00                	mov    (%eax),%eax
c0104458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010445d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104460:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104463:	c1 e8 0c             	shr    $0xc,%eax
c0104466:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104469:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010446e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104471:	72 23                	jb     c0104496 <get_pte+0x127>
c0104473:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104476:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010447a:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104481:	c0 
c0104482:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c0104489:	00 
c010448a:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104491:	e8 30 c8 ff ff       	call   c0100cc6 <__panic>
c0104496:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104499:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010449e:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044a1:	c1 ea 0c             	shr    $0xc,%edx
c01044a4:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01044aa:	c1 e2 02             	shl    $0x2,%edx
c01044ad:	01 d0                	add    %edx,%eax
}
c01044af:	c9                   	leave  
c01044b0:	c3                   	ret    

c01044b1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01044b1:	55                   	push   %ebp
c01044b2:	89 e5                	mov    %esp,%ebp
c01044b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044be:	00 
c01044bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c9:	89 04 24             	mov    %eax,(%esp)
c01044cc:	e8 9e fe ff ff       	call   c010436f <get_pte>
c01044d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01044d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044d8:	74 08                	je     c01044e2 <get_page+0x31>
        *ptep_store = ptep;
c01044da:	8b 45 10             	mov    0x10(%ebp),%eax
c01044dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044e0:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01044e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044e6:	74 1b                	je     c0104503 <get_page+0x52>
c01044e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044eb:	8b 00                	mov    (%eax),%eax
c01044ed:	83 e0 01             	and    $0x1,%eax
c01044f0:	85 c0                	test   %eax,%eax
c01044f2:	74 0f                	je     c0104503 <get_page+0x52>
        return pa2page(*ptep);
c01044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f7:	8b 00                	mov    (%eax),%eax
c01044f9:	89 04 24             	mov    %eax,(%esp)
c01044fc:	e8 49 f4 ff ff       	call   c010394a <pa2page>
c0104501:	eb 05                	jmp    c0104508 <get_page+0x57>
    }
    return NULL;
c0104503:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104508:	c9                   	leave  
c0104509:	c3                   	ret    

c010450a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010450a:	55                   	push   %ebp
c010450b:	89 e5                	mov    %esp,%ebp
c010450d:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104510:	8b 45 10             	mov    0x10(%ebp),%eax
c0104513:	8b 00                	mov    (%eax),%eax
c0104515:	83 e0 01             	and    $0x1,%eax
c0104518:	85 c0                	test   %eax,%eax
c010451a:	74 58                	je     c0104574 <page_remove_pte+0x6a>
        struct Page* page = pte2page(*ptep);
c010451c:	8b 45 10             	mov    0x10(%ebp),%eax
c010451f:	8b 00                	mov    (%eax),%eax
c0104521:	89 04 24             	mov    %eax,(%esp)
c0104524:	e8 c4 f4 ff ff       	call   c01039ed <pte2page>
c0104529:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452f:	89 04 24             	mov    %eax,(%esp)
c0104532:	e8 22 f5 ff ff       	call   c0103a59 <page_ref_dec>
        if (page_ref(page) == 0) {
c0104537:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453a:	89 04 24             	mov    %eax,(%esp)
c010453d:	e8 e9 f4 ff ff       	call   c0103a2b <page_ref>
c0104542:	85 c0                	test   %eax,%eax
c0104544:	75 13                	jne    c0104559 <page_remove_pte+0x4f>
            free_page(page);
c0104546:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010454d:	00 
c010454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104551:	89 04 24             	mov    %eax,(%esp)
c0104554:	e8 0f f7 ff ff       	call   c0103c68 <free_pages>
        }
        *ptep = 0;
c0104559:	8b 45 10             	mov    0x10(%ebp),%eax
c010455c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104565:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104569:	8b 45 08             	mov    0x8(%ebp),%eax
c010456c:	89 04 24             	mov    %eax,(%esp)
c010456f:	e8 ff 00 00 00       	call   c0104673 <tlb_invalidate>
    }
}
c0104574:	c9                   	leave  
c0104575:	c3                   	ret    

c0104576 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104576:	55                   	push   %ebp
c0104577:	89 e5                	mov    %esp,%ebp
c0104579:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010457c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104583:	00 
c0104584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104587:	89 44 24 04          	mov    %eax,0x4(%esp)
c010458b:	8b 45 08             	mov    0x8(%ebp),%eax
c010458e:	89 04 24             	mov    %eax,(%esp)
c0104591:	e8 d9 fd ff ff       	call   c010436f <get_pte>
c0104596:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010459d:	74 19                	je     c01045b8 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b0:	89 04 24             	mov    %eax,(%esp)
c01045b3:	e8 52 ff ff ff       	call   c010450a <page_remove_pte>
    }
}
c01045b8:	c9                   	leave  
c01045b9:	c3                   	ret    

c01045ba <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01045ba:	55                   	push   %ebp
c01045bb:	89 e5                	mov    %esp,%ebp
c01045bd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01045c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045c7:	00 
c01045c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01045cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d2:	89 04 24             	mov    %eax,(%esp)
c01045d5:	e8 95 fd ff ff       	call   c010436f <get_pte>
c01045da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01045dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045e1:	75 0a                	jne    c01045ed <page_insert+0x33>
        return -E_NO_MEM;
c01045e3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01045e8:	e9 84 00 00 00       	jmp    c0104671 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01045ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f0:	89 04 24             	mov    %eax,(%esp)
c01045f3:	e8 4a f4 ff ff       	call   c0103a42 <page_ref_inc>
    if (*ptep & PTE_P) {
c01045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fb:	8b 00                	mov    (%eax),%eax
c01045fd:	83 e0 01             	and    $0x1,%eax
c0104600:	85 c0                	test   %eax,%eax
c0104602:	74 3e                	je     c0104642 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104607:	8b 00                	mov    (%eax),%eax
c0104609:	89 04 24             	mov    %eax,(%esp)
c010460c:	e8 dc f3 ff ff       	call   c01039ed <pte2page>
c0104611:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104614:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104617:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010461a:	75 0d                	jne    c0104629 <page_insert+0x6f>
            page_ref_dec(page);
c010461c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010461f:	89 04 24             	mov    %eax,(%esp)
c0104622:	e8 32 f4 ff ff       	call   c0103a59 <page_ref_dec>
c0104627:	eb 19                	jmp    c0104642 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104630:	8b 45 10             	mov    0x10(%ebp),%eax
c0104633:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104637:	8b 45 08             	mov    0x8(%ebp),%eax
c010463a:	89 04 24             	mov    %eax,(%esp)
c010463d:	e8 c8 fe ff ff       	call   c010450a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104642:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104645:	89 04 24             	mov    %eax,(%esp)
c0104648:	e8 e7 f2 ff ff       	call   c0103934 <page2pa>
c010464d:	0b 45 14             	or     0x14(%ebp),%eax
c0104650:	83 c8 01             	or     $0x1,%eax
c0104653:	89 c2                	mov    %eax,%edx
c0104655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104658:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010465a:	8b 45 10             	mov    0x10(%ebp),%eax
c010465d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104661:	8b 45 08             	mov    0x8(%ebp),%eax
c0104664:	89 04 24             	mov    %eax,(%esp)
c0104667:	e8 07 00 00 00       	call   c0104673 <tlb_invalidate>
    return 0;
c010466c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104671:	c9                   	leave  
c0104672:	c3                   	ret    

c0104673 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104673:	55                   	push   %ebp
c0104674:	89 e5                	mov    %esp,%ebp
c0104676:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104679:	0f 20 d8             	mov    %cr3,%eax
c010467c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010467f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104682:	89 c2                	mov    %eax,%edx
c0104684:	8b 45 08             	mov    0x8(%ebp),%eax
c0104687:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010468a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104691:	77 23                	ja     c01046b6 <tlb_invalidate+0x43>
c0104693:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104696:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010469a:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c01046a1:	c0 
c01046a2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01046a9:	00 
c01046aa:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01046b1:	e8 10 c6 ff ff       	call   c0100cc6 <__panic>
c01046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b9:	05 00 00 00 40       	add    $0x40000000,%eax
c01046be:	39 c2                	cmp    %eax,%edx
c01046c0:	75 0c                	jne    c01046ce <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01046c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01046c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046cb:	0f 01 38             	invlpg (%eax)
    }
}
c01046ce:	c9                   	leave  
c01046cf:	c3                   	ret    

c01046d0 <check_alloc_page>:

static void
check_alloc_page(void) {
c01046d0:	55                   	push   %ebp
c01046d1:	89 e5                	mov    %esp,%ebp
c01046d3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01046d6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01046db:	8b 40 18             	mov    0x18(%eax),%eax
c01046de:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01046e0:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01046e7:	e8 50 bc ff ff       	call   c010033c <cprintf>
}
c01046ec:	c9                   	leave  
c01046ed:	c3                   	ret    

c01046ee <check_pgdir>:

static void
check_pgdir(void) {
c01046ee:	55                   	push   %ebp
c01046ef:	89 e5                	mov    %esp,%ebp
c01046f1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01046f4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046f9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01046fe:	76 24                	jbe    c0104724 <check_pgdir+0x36>
c0104700:	c7 44 24 0c d3 6a 10 	movl   $0xc0106ad3,0xc(%esp)
c0104707:	c0 
c0104708:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010470f:	c0 
c0104710:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104717:	00 
c0104718:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010471f:	e8 a2 c5 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104724:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104729:	85 c0                	test   %eax,%eax
c010472b:	74 0e                	je     c010473b <check_pgdir+0x4d>
c010472d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104732:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104737:	85 c0                	test   %eax,%eax
c0104739:	74 24                	je     c010475f <check_pgdir+0x71>
c010473b:	c7 44 24 0c f0 6a 10 	movl   $0xc0106af0,0xc(%esp)
c0104742:	c0 
c0104743:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010474a:	c0 
c010474b:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104752:	00 
c0104753:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010475a:	e8 67 c5 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010475f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104764:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010476b:	00 
c010476c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104773:	00 
c0104774:	89 04 24             	mov    %eax,(%esp)
c0104777:	e8 35 fd ff ff       	call   c01044b1 <get_page>
c010477c:	85 c0                	test   %eax,%eax
c010477e:	74 24                	je     c01047a4 <check_pgdir+0xb6>
c0104780:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c0104787:	c0 
c0104788:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010478f:	c0 
c0104790:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104797:	00 
c0104798:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010479f:	e8 22 c5 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01047a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047ab:	e8 80 f4 ff ff       	call   c0103c30 <alloc_pages>
c01047b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01047b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01047bf:	00 
c01047c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047c7:	00 
c01047c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047cb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047cf:	89 04 24             	mov    %eax,(%esp)
c01047d2:	e8 e3 fd ff ff       	call   c01045ba <page_insert>
c01047d7:	85 c0                	test   %eax,%eax
c01047d9:	74 24                	je     c01047ff <check_pgdir+0x111>
c01047db:	c7 44 24 0c 50 6b 10 	movl   $0xc0106b50,0xc(%esp)
c01047e2:	c0 
c01047e3:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01047ea:	c0 
c01047eb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01047f2:	00 
c01047f3:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01047fa:	e8 c7 c4 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01047ff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010480b:	00 
c010480c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104813:	00 
c0104814:	89 04 24             	mov    %eax,(%esp)
c0104817:	e8 53 fb ff ff       	call   c010436f <get_pte>
c010481c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010481f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104823:	75 24                	jne    c0104849 <check_pgdir+0x15b>
c0104825:	c7 44 24 0c 7c 6b 10 	movl   $0xc0106b7c,0xc(%esp)
c010482c:	c0 
c010482d:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104834:	c0 
c0104835:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010483c:	00 
c010483d:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104844:	e8 7d c4 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104849:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010484c:	8b 00                	mov    (%eax),%eax
c010484e:	89 04 24             	mov    %eax,(%esp)
c0104851:	e8 f4 f0 ff ff       	call   c010394a <pa2page>
c0104856:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104859:	74 24                	je     c010487f <check_pgdir+0x191>
c010485b:	c7 44 24 0c a9 6b 10 	movl   $0xc0106ba9,0xc(%esp)
c0104862:	c0 
c0104863:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010486a:	c0 
c010486b:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104872:	00 
c0104873:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010487a:	e8 47 c4 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c010487f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104882:	89 04 24             	mov    %eax,(%esp)
c0104885:	e8 a1 f1 ff ff       	call   c0103a2b <page_ref>
c010488a:	83 f8 01             	cmp    $0x1,%eax
c010488d:	74 24                	je     c01048b3 <check_pgdir+0x1c5>
c010488f:	c7 44 24 0c be 6b 10 	movl   $0xc0106bbe,0xc(%esp)
c0104896:	c0 
c0104897:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010489e:	c0 
c010489f:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01048a6:	00 
c01048a7:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01048ae:	e8 13 c4 ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01048b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048b8:	8b 00                	mov    (%eax),%eax
c01048ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048c5:	c1 e8 0c             	shr    $0xc,%eax
c01048c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01048cb:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048d0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01048d3:	72 23                	jb     c01048f8 <check_pgdir+0x20a>
c01048d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048dc:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c01048e3:	c0 
c01048e4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01048eb:	00 
c01048ec:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01048f3:	e8 ce c3 ff ff       	call   c0100cc6 <__panic>
c01048f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048fb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104900:	83 c0 04             	add    $0x4,%eax
c0104903:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104906:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010490b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104912:	00 
c0104913:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010491a:	00 
c010491b:	89 04 24             	mov    %eax,(%esp)
c010491e:	e8 4c fa ff ff       	call   c010436f <get_pte>
c0104923:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104926:	74 24                	je     c010494c <check_pgdir+0x25e>
c0104928:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c010492f:	c0 
c0104930:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104937:	c0 
c0104938:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010493f:	00 
c0104940:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104947:	e8 7a c3 ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c010494c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104953:	e8 d8 f2 ff ff       	call   c0103c30 <alloc_pages>
c0104958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010495b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104960:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104967:	00 
c0104968:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010496f:	00 
c0104970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104973:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104977:	89 04 24             	mov    %eax,(%esp)
c010497a:	e8 3b fc ff ff       	call   c01045ba <page_insert>
c010497f:	85 c0                	test   %eax,%eax
c0104981:	74 24                	je     c01049a7 <check_pgdir+0x2b9>
c0104983:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c010498a:	c0 
c010498b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104992:	c0 
c0104993:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c010499a:	00 
c010499b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01049a2:	e8 1f c3 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01049a7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049b3:	00 
c01049b4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049bb:	00 
c01049bc:	89 04 24             	mov    %eax,(%esp)
c01049bf:	e8 ab f9 ff ff       	call   c010436f <get_pte>
c01049c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049cb:	75 24                	jne    c01049f1 <check_pgdir+0x303>
c01049cd:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c01049d4:	c0 
c01049d5:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01049dc:	c0 
c01049dd:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01049e4:	00 
c01049e5:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01049ec:	e8 d5 c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c01049f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f4:	8b 00                	mov    (%eax),%eax
c01049f6:	83 e0 04             	and    $0x4,%eax
c01049f9:	85 c0                	test   %eax,%eax
c01049fb:	75 24                	jne    c0104a21 <check_pgdir+0x333>
c01049fd:	c7 44 24 0c 60 6c 10 	movl   $0xc0106c60,0xc(%esp)
c0104a04:	c0 
c0104a05:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a0c:	c0 
c0104a0d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104a14:	00 
c0104a15:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a1c:	e8 a5 c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c0104a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a24:	8b 00                	mov    (%eax),%eax
c0104a26:	83 e0 02             	and    $0x2,%eax
c0104a29:	85 c0                	test   %eax,%eax
c0104a2b:	75 24                	jne    c0104a51 <check_pgdir+0x363>
c0104a2d:	c7 44 24 0c 6e 6c 10 	movl   $0xc0106c6e,0xc(%esp)
c0104a34:	c0 
c0104a35:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a3c:	c0 
c0104a3d:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104a44:	00 
c0104a45:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a4c:	e8 75 c2 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a51:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a56:	8b 00                	mov    (%eax),%eax
c0104a58:	83 e0 04             	and    $0x4,%eax
c0104a5b:	85 c0                	test   %eax,%eax
c0104a5d:	75 24                	jne    c0104a83 <check_pgdir+0x395>
c0104a5f:	c7 44 24 0c 7c 6c 10 	movl   $0xc0106c7c,0xc(%esp)
c0104a66:	c0 
c0104a67:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a6e:	c0 
c0104a6f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104a76:	00 
c0104a77:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a7e:	e8 43 c2 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c0104a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a86:	89 04 24             	mov    %eax,(%esp)
c0104a89:	e8 9d ef ff ff       	call   c0103a2b <page_ref>
c0104a8e:	83 f8 01             	cmp    $0x1,%eax
c0104a91:	74 24                	je     c0104ab7 <check_pgdir+0x3c9>
c0104a93:	c7 44 24 0c 92 6c 10 	movl   $0xc0106c92,0xc(%esp)
c0104a9a:	c0 
c0104a9b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104aa2:	c0 
c0104aa3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104aaa:	00 
c0104aab:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104ab2:	e8 0f c2 ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104ab7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104abc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104ac3:	00 
c0104ac4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104acb:	00 
c0104acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104acf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ad3:	89 04 24             	mov    %eax,(%esp)
c0104ad6:	e8 df fa ff ff       	call   c01045ba <page_insert>
c0104adb:	85 c0                	test   %eax,%eax
c0104add:	74 24                	je     c0104b03 <check_pgdir+0x415>
c0104adf:	c7 44 24 0c a4 6c 10 	movl   $0xc0106ca4,0xc(%esp)
c0104ae6:	c0 
c0104ae7:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104aee:	c0 
c0104aef:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104af6:	00 
c0104af7:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104afe:	e8 c3 c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c0104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b06:	89 04 24             	mov    %eax,(%esp)
c0104b09:	e8 1d ef ff ff       	call   c0103a2b <page_ref>
c0104b0e:	83 f8 02             	cmp    $0x2,%eax
c0104b11:	74 24                	je     c0104b37 <check_pgdir+0x449>
c0104b13:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c0104b1a:	c0 
c0104b1b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b22:	c0 
c0104b23:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b2a:	00 
c0104b2b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104b32:	e8 8f c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b3a:	89 04 24             	mov    %eax,(%esp)
c0104b3d:	e8 e9 ee ff ff       	call   c0103a2b <page_ref>
c0104b42:	85 c0                	test   %eax,%eax
c0104b44:	74 24                	je     c0104b6a <check_pgdir+0x47c>
c0104b46:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104b4d:	c0 
c0104b4e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b55:	c0 
c0104b56:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104b5d:	00 
c0104b5e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104b65:	e8 5c c1 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b6a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b76:	00 
c0104b77:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b7e:	00 
c0104b7f:	89 04 24             	mov    %eax,(%esp)
c0104b82:	e8 e8 f7 ff ff       	call   c010436f <get_pte>
c0104b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b8e:	75 24                	jne    c0104bb4 <check_pgdir+0x4c6>
c0104b90:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c0104b97:	c0 
c0104b98:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b9f:	c0 
c0104ba0:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104ba7:	00 
c0104ba8:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104baf:	e8 12 c1 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb7:	8b 00                	mov    (%eax),%eax
c0104bb9:	89 04 24             	mov    %eax,(%esp)
c0104bbc:	e8 89 ed ff ff       	call   c010394a <pa2page>
c0104bc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bc4:	74 24                	je     c0104bea <check_pgdir+0x4fc>
c0104bc6:	c7 44 24 0c a9 6b 10 	movl   $0xc0106ba9,0xc(%esp)
c0104bcd:	c0 
c0104bce:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104bd5:	c0 
c0104bd6:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104bdd:	00 
c0104bde:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104be5:	e8 dc c0 ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bed:	8b 00                	mov    (%eax),%eax
c0104bef:	83 e0 04             	and    $0x4,%eax
c0104bf2:	85 c0                	test   %eax,%eax
c0104bf4:	74 24                	je     c0104c1a <check_pgdir+0x52c>
c0104bf6:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104bfd:	c0 
c0104bfe:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104c05:	c0 
c0104c06:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c0d:	00 
c0104c0e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104c15:	e8 ac c0 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c1a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c26:	00 
c0104c27:	89 04 24             	mov    %eax,(%esp)
c0104c2a:	e8 47 f9 ff ff       	call   c0104576 <page_remove>
    assert(page_ref(p1) == 1);
c0104c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c32:	89 04 24             	mov    %eax,(%esp)
c0104c35:	e8 f1 ed ff ff       	call   c0103a2b <page_ref>
c0104c3a:	83 f8 01             	cmp    $0x1,%eax
c0104c3d:	74 24                	je     c0104c63 <check_pgdir+0x575>
c0104c3f:	c7 44 24 0c be 6b 10 	movl   $0xc0106bbe,0xc(%esp)
c0104c46:	c0 
c0104c47:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104c4e:	c0 
c0104c4f:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104c56:	00 
c0104c57:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104c5e:	e8 63 c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c66:	89 04 24             	mov    %eax,(%esp)
c0104c69:	e8 bd ed ff ff       	call   c0103a2b <page_ref>
c0104c6e:	85 c0                	test   %eax,%eax
c0104c70:	74 24                	je     c0104c96 <check_pgdir+0x5a8>
c0104c72:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104c79:	c0 
c0104c7a:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104c89:	00 
c0104c8a:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104c91:	e8 30 c0 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104c96:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c9b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ca2:	00 
c0104ca3:	89 04 24             	mov    %eax,(%esp)
c0104ca6:	e8 cb f8 ff ff       	call   c0104576 <page_remove>
    assert(page_ref(p1) == 0);
c0104cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cae:	89 04 24             	mov    %eax,(%esp)
c0104cb1:	e8 75 ed ff ff       	call   c0103a2b <page_ref>
c0104cb6:	85 c0                	test   %eax,%eax
c0104cb8:	74 24                	je     c0104cde <check_pgdir+0x5f0>
c0104cba:	c7 44 24 0c 09 6d 10 	movl   $0xc0106d09,0xc(%esp)
c0104cc1:	c0 
c0104cc2:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104cc9:	c0 
c0104cca:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104cd1:	00 
c0104cd2:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104cd9:	e8 e8 bf ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ce1:	89 04 24             	mov    %eax,(%esp)
c0104ce4:	e8 42 ed ff ff       	call   c0103a2b <page_ref>
c0104ce9:	85 c0                	test   %eax,%eax
c0104ceb:	74 24                	je     c0104d11 <check_pgdir+0x623>
c0104ced:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104cf4:	c0 
c0104cf5:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104cfc:	c0 
c0104cfd:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104d04:	00 
c0104d05:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104d0c:	e8 b5 bf ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104d11:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d16:	8b 00                	mov    (%eax),%eax
c0104d18:	89 04 24             	mov    %eax,(%esp)
c0104d1b:	e8 2a ec ff ff       	call   c010394a <pa2page>
c0104d20:	89 04 24             	mov    %eax,(%esp)
c0104d23:	e8 03 ed ff ff       	call   c0103a2b <page_ref>
c0104d28:	83 f8 01             	cmp    $0x1,%eax
c0104d2b:	74 24                	je     c0104d51 <check_pgdir+0x663>
c0104d2d:	c7 44 24 0c 1c 6d 10 	movl   $0xc0106d1c,0xc(%esp)
c0104d34:	c0 
c0104d35:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104d3c:	c0 
c0104d3d:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104d44:	00 
c0104d45:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104d4c:	e8 75 bf ff ff       	call   c0100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104d51:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d56:	8b 00                	mov    (%eax),%eax
c0104d58:	89 04 24             	mov    %eax,(%esp)
c0104d5b:	e8 ea eb ff ff       	call   c010394a <pa2page>
c0104d60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d67:	00 
c0104d68:	89 04 24             	mov    %eax,(%esp)
c0104d6b:	e8 f8 ee ff ff       	call   c0103c68 <free_pages>
    boot_pgdir[0] = 0;
c0104d70:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104d7b:	c7 04 24 42 6d 10 c0 	movl   $0xc0106d42,(%esp)
c0104d82:	e8 b5 b5 ff ff       	call   c010033c <cprintf>
}
c0104d87:	c9                   	leave  
c0104d88:	c3                   	ret    

c0104d89 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104d89:	55                   	push   %ebp
c0104d8a:	89 e5                	mov    %esp,%ebp
c0104d8c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d96:	e9 ca 00 00 00       	jmp    c0104e65 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da4:	c1 e8 0c             	shr    $0xc,%eax
c0104da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104daa:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104daf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104db2:	72 23                	jb     c0104dd7 <check_boot_pgdir+0x4e>
c0104db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104dbb:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104dc2:	c0 
c0104dc3:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104dca:	00 
c0104dcb:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104dd2:	e8 ef be ff ff       	call   c0100cc6 <__panic>
c0104dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dda:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ddf:	89 c2                	mov    %eax,%edx
c0104de1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104de6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ded:	00 
c0104dee:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104df2:	89 04 24             	mov    %eax,(%esp)
c0104df5:	e8 75 f5 ff ff       	call   c010436f <get_pte>
c0104dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104dfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e01:	75 24                	jne    c0104e27 <check_boot_pgdir+0x9e>
c0104e03:	c7 44 24 0c 5c 6d 10 	movl   $0xc0106d5c,0xc(%esp)
c0104e0a:	c0 
c0104e0b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104e12:	c0 
c0104e13:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104e1a:	00 
c0104e1b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104e22:	e8 9f be ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e2a:	8b 00                	mov    (%eax),%eax
c0104e2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e31:	89 c2                	mov    %eax,%edx
c0104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e36:	39 c2                	cmp    %eax,%edx
c0104e38:	74 24                	je     c0104e5e <check_boot_pgdir+0xd5>
c0104e3a:	c7 44 24 0c 99 6d 10 	movl   $0xc0106d99,0xc(%esp)
c0104e41:	c0 
c0104e42:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104e49:	c0 
c0104e4a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104e51:	00 
c0104e52:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104e59:	e8 68 be ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e5e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e68:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e6d:	39 c2                	cmp    %eax,%edx
c0104e6f:	0f 82 26 ff ff ff    	jb     c0104d9b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104e75:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e7a:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104e7f:	8b 00                	mov    (%eax),%eax
c0104e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e86:	89 c2                	mov    %eax,%edx
c0104e88:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e90:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104e97:	77 23                	ja     c0104ebc <check_boot_pgdir+0x133>
c0104e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ea0:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c0104ea7:	c0 
c0104ea8:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104eaf:	00 
c0104eb0:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104eb7:	e8 0a be ff ff       	call   c0100cc6 <__panic>
c0104ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ebf:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ec4:	39 c2                	cmp    %eax,%edx
c0104ec6:	74 24                	je     c0104eec <check_boot_pgdir+0x163>
c0104ec8:	c7 44 24 0c b0 6d 10 	movl   $0xc0106db0,0xc(%esp)
c0104ecf:	c0 
c0104ed0:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104ed7:	c0 
c0104ed8:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104edf:	00 
c0104ee0:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104ee7:	e8 da bd ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c0104eec:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ef1:	8b 00                	mov    (%eax),%eax
c0104ef3:	85 c0                	test   %eax,%eax
c0104ef5:	74 24                	je     c0104f1b <check_boot_pgdir+0x192>
c0104ef7:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104efe:	c0 
c0104eff:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104f06:	c0 
c0104f07:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0104f0e:	00 
c0104f0f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104f16:	e8 ab bd ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c0104f1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f22:	e8 09 ed ff ff       	call   c0103c30 <alloc_pages>
c0104f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104f2a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f2f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f36:	00 
c0104f37:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104f3e:	00 
c0104f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f42:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f46:	89 04 24             	mov    %eax,(%esp)
c0104f49:	e8 6c f6 ff ff       	call   c01045ba <page_insert>
c0104f4e:	85 c0                	test   %eax,%eax
c0104f50:	74 24                	je     c0104f76 <check_boot_pgdir+0x1ed>
c0104f52:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c0104f59:	c0 
c0104f5a:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104f61:	c0 
c0104f62:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0104f69:	00 
c0104f6a:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104f71:	e8 50 bd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c0104f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f79:	89 04 24             	mov    %eax,(%esp)
c0104f7c:	e8 aa ea ff ff       	call   c0103a2b <page_ref>
c0104f81:	83 f8 01             	cmp    $0x1,%eax
c0104f84:	74 24                	je     c0104faa <check_boot_pgdir+0x221>
c0104f86:	c7 44 24 0c 26 6e 10 	movl   $0xc0106e26,0xc(%esp)
c0104f8d:	c0 
c0104f8e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104f95:	c0 
c0104f96:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0104f9d:	00 
c0104f9e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104fa5:	e8 1c bd ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104faa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104faf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fb6:	00 
c0104fb7:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104fbe:	00 
c0104fbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fc2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fc6:	89 04 24             	mov    %eax,(%esp)
c0104fc9:	e8 ec f5 ff ff       	call   c01045ba <page_insert>
c0104fce:	85 c0                	test   %eax,%eax
c0104fd0:	74 24                	je     c0104ff6 <check_boot_pgdir+0x26d>
c0104fd2:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104fd9:	c0 
c0104fda:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104fe1:	c0 
c0104fe2:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0104fe9:	00 
c0104fea:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104ff1:	e8 d0 bc ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c0104ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ff9:	89 04 24             	mov    %eax,(%esp)
c0104ffc:	e8 2a ea ff ff       	call   c0103a2b <page_ref>
c0105001:	83 f8 02             	cmp    $0x2,%eax
c0105004:	74 24                	je     c010502a <check_boot_pgdir+0x2a1>
c0105006:	c7 44 24 0c 6f 6e 10 	movl   $0xc0106e6f,0xc(%esp)
c010500d:	c0 
c010500e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0105015:	c0 
c0105016:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010501d:	00 
c010501e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0105025:	e8 9c bc ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c010502a:	c7 45 dc 80 6e 10 c0 	movl   $0xc0106e80,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105031:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105034:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105038:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010503f:	e8 1e 0a 00 00       	call   c0105a62 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105044:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010504b:	00 
c010504c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105053:	e8 83 0a 00 00       	call   c0105adb <strcmp>
c0105058:	85 c0                	test   %eax,%eax
c010505a:	74 24                	je     c0105080 <check_boot_pgdir+0x2f7>
c010505c:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0105063:	c0 
c0105064:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010506b:	c0 
c010506c:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105073:	00 
c0105074:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010507b:	e8 46 bc ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105080:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105083:	89 04 24             	mov    %eax,(%esp)
c0105086:	e8 0e e9 ff ff       	call   c0103999 <page2kva>
c010508b:	05 00 01 00 00       	add    $0x100,%eax
c0105090:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105093:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010509a:	e8 6b 09 00 00       	call   c0105a0a <strlen>
c010509f:	85 c0                	test   %eax,%eax
c01050a1:	74 24                	je     c01050c7 <check_boot_pgdir+0x33e>
c01050a3:	c7 44 24 0c d0 6e 10 	movl   $0xc0106ed0,0xc(%esp)
c01050aa:	c0 
c01050ab:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01050b2:	c0 
c01050b3:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01050ba:	00 
c01050bb:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01050c2:	e8 ff bb ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c01050c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050ce:	00 
c01050cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050d2:	89 04 24             	mov    %eax,(%esp)
c01050d5:	e8 8e eb ff ff       	call   c0103c68 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01050da:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050df:	8b 00                	mov    (%eax),%eax
c01050e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050e6:	89 04 24             	mov    %eax,(%esp)
c01050e9:	e8 5c e8 ff ff       	call   c010394a <pa2page>
c01050ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050f5:	00 
c01050f6:	89 04 24             	mov    %eax,(%esp)
c01050f9:	e8 6a eb ff ff       	call   c0103c68 <free_pages>
    boot_pgdir[0] = 0;
c01050fe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105109:	c7 04 24 f4 6e 10 c0 	movl   $0xc0106ef4,(%esp)
c0105110:	e8 27 b2 ff ff       	call   c010033c <cprintf>
}
c0105115:	c9                   	leave  
c0105116:	c3                   	ret    

c0105117 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105117:	55                   	push   %ebp
c0105118:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010511a:	8b 45 08             	mov    0x8(%ebp),%eax
c010511d:	83 e0 04             	and    $0x4,%eax
c0105120:	85 c0                	test   %eax,%eax
c0105122:	74 07                	je     c010512b <perm2str+0x14>
c0105124:	b8 75 00 00 00       	mov    $0x75,%eax
c0105129:	eb 05                	jmp    c0105130 <perm2str+0x19>
c010512b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105130:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105135:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010513c:	8b 45 08             	mov    0x8(%ebp),%eax
c010513f:	83 e0 02             	and    $0x2,%eax
c0105142:	85 c0                	test   %eax,%eax
c0105144:	74 07                	je     c010514d <perm2str+0x36>
c0105146:	b8 77 00 00 00       	mov    $0x77,%eax
c010514b:	eb 05                	jmp    c0105152 <perm2str+0x3b>
c010514d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105152:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105157:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c010515e:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105163:	5d                   	pop    %ebp
c0105164:	c3                   	ret    

c0105165 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105165:	55                   	push   %ebp
c0105166:	89 e5                	mov    %esp,%ebp
c0105168:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010516b:	8b 45 10             	mov    0x10(%ebp),%eax
c010516e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105171:	72 0a                	jb     c010517d <get_pgtable_items+0x18>
        return 0;
c0105173:	b8 00 00 00 00       	mov    $0x0,%eax
c0105178:	e9 9c 00 00 00       	jmp    c0105219 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010517d:	eb 04                	jmp    c0105183 <get_pgtable_items+0x1e>
        start ++;
c010517f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105183:	8b 45 10             	mov    0x10(%ebp),%eax
c0105186:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105189:	73 18                	jae    c01051a3 <get_pgtable_items+0x3e>
c010518b:	8b 45 10             	mov    0x10(%ebp),%eax
c010518e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105195:	8b 45 14             	mov    0x14(%ebp),%eax
c0105198:	01 d0                	add    %edx,%eax
c010519a:	8b 00                	mov    (%eax),%eax
c010519c:	83 e0 01             	and    $0x1,%eax
c010519f:	85 c0                	test   %eax,%eax
c01051a1:	74 dc                	je     c010517f <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01051a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051a9:	73 69                	jae    c0105214 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01051ab:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01051af:	74 08                	je     c01051b9 <get_pgtable_items+0x54>
            *left_store = start;
c01051b1:	8b 45 18             	mov    0x18(%ebp),%eax
c01051b4:	8b 55 10             	mov    0x10(%ebp),%edx
c01051b7:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01051b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01051bc:	8d 50 01             	lea    0x1(%eax),%edx
c01051bf:	89 55 10             	mov    %edx,0x10(%ebp)
c01051c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01051cc:	01 d0                	add    %edx,%eax
c01051ce:	8b 00                	mov    (%eax),%eax
c01051d0:	83 e0 07             	and    $0x7,%eax
c01051d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051d6:	eb 04                	jmp    c01051dc <get_pgtable_items+0x77>
            start ++;
c01051d8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01051df:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051e2:	73 1d                	jae    c0105201 <get_pgtable_items+0x9c>
c01051e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01051e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01051f1:	01 d0                	add    %edx,%eax
c01051f3:	8b 00                	mov    (%eax),%eax
c01051f5:	83 e0 07             	and    $0x7,%eax
c01051f8:	89 c2                	mov    %eax,%edx
c01051fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051fd:	39 c2                	cmp    %eax,%edx
c01051ff:	74 d7                	je     c01051d8 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105201:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105205:	74 08                	je     c010520f <get_pgtable_items+0xaa>
            *right_store = start;
c0105207:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010520a:	8b 55 10             	mov    0x10(%ebp),%edx
c010520d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105212:	eb 05                	jmp    c0105219 <get_pgtable_items+0xb4>
    }
    return 0;
c0105214:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105219:	c9                   	leave  
c010521a:	c3                   	ret    

c010521b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010521b:	55                   	push   %ebp
c010521c:	89 e5                	mov    %esp,%ebp
c010521e:	57                   	push   %edi
c010521f:	56                   	push   %esi
c0105220:	53                   	push   %ebx
c0105221:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105224:	c7 04 24 14 6f 10 c0 	movl   $0xc0106f14,(%esp)
c010522b:	e8 0c b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105230:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105237:	e9 fa 00 00 00       	jmp    c0105336 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010523c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010523f:	89 04 24             	mov    %eax,(%esp)
c0105242:	e8 d0 fe ff ff       	call   c0105117 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105247:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010524a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010524d:	29 d1                	sub    %edx,%ecx
c010524f:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105251:	89 d6                	mov    %edx,%esi
c0105253:	c1 e6 16             	shl    $0x16,%esi
c0105256:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105259:	89 d3                	mov    %edx,%ebx
c010525b:	c1 e3 16             	shl    $0x16,%ebx
c010525e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105261:	89 d1                	mov    %edx,%ecx
c0105263:	c1 e1 16             	shl    $0x16,%ecx
c0105266:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105269:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010526c:	29 d7                	sub    %edx,%edi
c010526e:	89 fa                	mov    %edi,%edx
c0105270:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105274:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105278:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010527c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105280:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105284:	c7 04 24 45 6f 10 c0 	movl   $0xc0106f45,(%esp)
c010528b:	e8 ac b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105290:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105293:	c1 e0 0a             	shl    $0xa,%eax
c0105296:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105299:	eb 54                	jmp    c01052ef <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010529b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010529e:	89 04 24             	mov    %eax,(%esp)
c01052a1:	e8 71 fe ff ff       	call   c0105117 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01052a6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01052a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052ac:	29 d1                	sub    %edx,%ecx
c01052ae:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052b0:	89 d6                	mov    %edx,%esi
c01052b2:	c1 e6 0c             	shl    $0xc,%esi
c01052b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052b8:	89 d3                	mov    %edx,%ebx
c01052ba:	c1 e3 0c             	shl    $0xc,%ebx
c01052bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052c0:	c1 e2 0c             	shl    $0xc,%edx
c01052c3:	89 d1                	mov    %edx,%ecx
c01052c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01052c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052cb:	29 d7                	sub    %edx,%edi
c01052cd:	89 fa                	mov    %edi,%edx
c01052cf:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052d3:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052d7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052df:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052e3:	c7 04 24 64 6f 10 c0 	movl   $0xc0106f64,(%esp)
c01052ea:	e8 4d b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052ef:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01052f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052fa:	89 ce                	mov    %ecx,%esi
c01052fc:	c1 e6 0a             	shl    $0xa,%esi
c01052ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105302:	89 cb                	mov    %ecx,%ebx
c0105304:	c1 e3 0a             	shl    $0xa,%ebx
c0105307:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010530a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010530e:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105311:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105315:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105319:	89 44 24 08          	mov    %eax,0x8(%esp)
c010531d:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105321:	89 1c 24             	mov    %ebx,(%esp)
c0105324:	e8 3c fe ff ff       	call   c0105165 <get_pgtable_items>
c0105329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010532c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105330:	0f 85 65 ff ff ff    	jne    c010529b <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105336:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010533b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010533e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105341:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105345:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105348:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010534c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105350:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105354:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010535b:	00 
c010535c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105363:	e8 fd fd ff ff       	call   c0105165 <get_pgtable_items>
c0105368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010536b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010536f:	0f 85 c7 fe ff ff    	jne    c010523c <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105375:	c7 04 24 88 6f 10 c0 	movl   $0xc0106f88,(%esp)
c010537c:	e8 bb af ff ff       	call   c010033c <cprintf>
}
c0105381:	83 c4 4c             	add    $0x4c,%esp
c0105384:	5b                   	pop    %ebx
c0105385:	5e                   	pop    %esi
c0105386:	5f                   	pop    %edi
c0105387:	5d                   	pop    %ebp
c0105388:	c3                   	ret    

c0105389 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105389:	55                   	push   %ebp
c010538a:	89 e5                	mov    %esp,%ebp
c010538c:	83 ec 58             	sub    $0x58,%esp
c010538f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105392:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105395:	8b 45 14             	mov    0x14(%ebp),%eax
c0105398:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010539b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010539e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01053a7:	8b 45 18             	mov    0x18(%ebp),%eax
c01053aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053b6:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01053b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053c3:	74 1c                	je     c01053e1 <printnum+0x58>
c01053c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c8:	ba 00 00 00 00       	mov    $0x0,%edx
c01053cd:	f7 75 e4             	divl   -0x1c(%ebp)
c01053d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01053d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d6:	ba 00 00 00 00       	mov    $0x0,%edx
c01053db:	f7 75 e4             	divl   -0x1c(%ebp)
c01053de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053e7:	f7 75 e4             	divl   -0x1c(%ebp)
c01053ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01053f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01053fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053ff:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105402:	8b 45 18             	mov    0x18(%ebp),%eax
c0105405:	ba 00 00 00 00       	mov    $0x0,%edx
c010540a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010540d:	77 56                	ja     c0105465 <printnum+0xdc>
c010540f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105412:	72 05                	jb     c0105419 <printnum+0x90>
c0105414:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105417:	77 4c                	ja     c0105465 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105419:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010541c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010541f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105422:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105426:	89 54 24 14          	mov    %edx,0x14(%esp)
c010542a:	8b 45 18             	mov    0x18(%ebp),%eax
c010542d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105431:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105434:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105437:	89 44 24 08          	mov    %eax,0x8(%esp)
c010543b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010543f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105442:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105446:	8b 45 08             	mov    0x8(%ebp),%eax
c0105449:	89 04 24             	mov    %eax,(%esp)
c010544c:	e8 38 ff ff ff       	call   c0105389 <printnum>
c0105451:	eb 1c                	jmp    c010546f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105453:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105456:	89 44 24 04          	mov    %eax,0x4(%esp)
c010545a:	8b 45 20             	mov    0x20(%ebp),%eax
c010545d:	89 04 24             	mov    %eax,(%esp)
c0105460:	8b 45 08             	mov    0x8(%ebp),%eax
c0105463:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105465:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105469:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010546d:	7f e4                	jg     c0105453 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010546f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105472:	05 3c 70 10 c0       	add    $0xc010703c,%eax
c0105477:	0f b6 00             	movzbl (%eax),%eax
c010547a:	0f be c0             	movsbl %al,%eax
c010547d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105480:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105484:	89 04 24             	mov    %eax,(%esp)
c0105487:	8b 45 08             	mov    0x8(%ebp),%eax
c010548a:	ff d0                	call   *%eax
}
c010548c:	c9                   	leave  
c010548d:	c3                   	ret    

c010548e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010548e:	55                   	push   %ebp
c010548f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105491:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105495:	7e 14                	jle    c01054ab <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105497:	8b 45 08             	mov    0x8(%ebp),%eax
c010549a:	8b 00                	mov    (%eax),%eax
c010549c:	8d 48 08             	lea    0x8(%eax),%ecx
c010549f:	8b 55 08             	mov    0x8(%ebp),%edx
c01054a2:	89 0a                	mov    %ecx,(%edx)
c01054a4:	8b 50 04             	mov    0x4(%eax),%edx
c01054a7:	8b 00                	mov    (%eax),%eax
c01054a9:	eb 30                	jmp    c01054db <getuint+0x4d>
    }
    else if (lflag) {
c01054ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054af:	74 16                	je     c01054c7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01054b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054b4:	8b 00                	mov    (%eax),%eax
c01054b6:	8d 48 04             	lea    0x4(%eax),%ecx
c01054b9:	8b 55 08             	mov    0x8(%ebp),%edx
c01054bc:	89 0a                	mov    %ecx,(%edx)
c01054be:	8b 00                	mov    (%eax),%eax
c01054c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01054c5:	eb 14                	jmp    c01054db <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01054c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ca:	8b 00                	mov    (%eax),%eax
c01054cc:	8d 48 04             	lea    0x4(%eax),%ecx
c01054cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01054d2:	89 0a                	mov    %ecx,(%edx)
c01054d4:	8b 00                	mov    (%eax),%eax
c01054d6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01054db:	5d                   	pop    %ebp
c01054dc:	c3                   	ret    

c01054dd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01054dd:	55                   	push   %ebp
c01054de:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054e4:	7e 14                	jle    c01054fa <getint+0x1d>
        return va_arg(*ap, long long);
c01054e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e9:	8b 00                	mov    (%eax),%eax
c01054eb:	8d 48 08             	lea    0x8(%eax),%ecx
c01054ee:	8b 55 08             	mov    0x8(%ebp),%edx
c01054f1:	89 0a                	mov    %ecx,(%edx)
c01054f3:	8b 50 04             	mov    0x4(%eax),%edx
c01054f6:	8b 00                	mov    (%eax),%eax
c01054f8:	eb 28                	jmp    c0105522 <getint+0x45>
    }
    else if (lflag) {
c01054fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054fe:	74 12                	je     c0105512 <getint+0x35>
        return va_arg(*ap, long);
c0105500:	8b 45 08             	mov    0x8(%ebp),%eax
c0105503:	8b 00                	mov    (%eax),%eax
c0105505:	8d 48 04             	lea    0x4(%eax),%ecx
c0105508:	8b 55 08             	mov    0x8(%ebp),%edx
c010550b:	89 0a                	mov    %ecx,(%edx)
c010550d:	8b 00                	mov    (%eax),%eax
c010550f:	99                   	cltd   
c0105510:	eb 10                	jmp    c0105522 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105512:	8b 45 08             	mov    0x8(%ebp),%eax
c0105515:	8b 00                	mov    (%eax),%eax
c0105517:	8d 48 04             	lea    0x4(%eax),%ecx
c010551a:	8b 55 08             	mov    0x8(%ebp),%edx
c010551d:	89 0a                	mov    %ecx,(%edx)
c010551f:	8b 00                	mov    (%eax),%eax
c0105521:	99                   	cltd   
    }
}
c0105522:	5d                   	pop    %ebp
c0105523:	c3                   	ret    

c0105524 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105524:	55                   	push   %ebp
c0105525:	89 e5                	mov    %esp,%ebp
c0105527:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010552a:	8d 45 14             	lea    0x14(%ebp),%eax
c010552d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105530:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105533:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105537:	8b 45 10             	mov    0x10(%ebp),%eax
c010553a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010553e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105541:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105545:	8b 45 08             	mov    0x8(%ebp),%eax
c0105548:	89 04 24             	mov    %eax,(%esp)
c010554b:	e8 02 00 00 00       	call   c0105552 <vprintfmt>
    va_end(ap);
}
c0105550:	c9                   	leave  
c0105551:	c3                   	ret    

c0105552 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105552:	55                   	push   %ebp
c0105553:	89 e5                	mov    %esp,%ebp
c0105555:	56                   	push   %esi
c0105556:	53                   	push   %ebx
c0105557:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010555a:	eb 18                	jmp    c0105574 <vprintfmt+0x22>
            if (ch == '\0') {
c010555c:	85 db                	test   %ebx,%ebx
c010555e:	75 05                	jne    c0105565 <vprintfmt+0x13>
                return;
c0105560:	e9 d1 03 00 00       	jmp    c0105936 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010556c:	89 1c 24             	mov    %ebx,(%esp)
c010556f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105572:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105574:	8b 45 10             	mov    0x10(%ebp),%eax
c0105577:	8d 50 01             	lea    0x1(%eax),%edx
c010557a:	89 55 10             	mov    %edx,0x10(%ebp)
c010557d:	0f b6 00             	movzbl (%eax),%eax
c0105580:	0f b6 d8             	movzbl %al,%ebx
c0105583:	83 fb 25             	cmp    $0x25,%ebx
c0105586:	75 d4                	jne    c010555c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105588:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010558c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105596:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105599:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01055a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055a3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01055a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01055a9:	8d 50 01             	lea    0x1(%eax),%edx
c01055ac:	89 55 10             	mov    %edx,0x10(%ebp)
c01055af:	0f b6 00             	movzbl (%eax),%eax
c01055b2:	0f b6 d8             	movzbl %al,%ebx
c01055b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01055b8:	83 f8 55             	cmp    $0x55,%eax
c01055bb:	0f 87 44 03 00 00    	ja     c0105905 <vprintfmt+0x3b3>
c01055c1:	8b 04 85 60 70 10 c0 	mov    -0x3fef8fa0(,%eax,4),%eax
c01055c8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01055ce:	eb d6                	jmp    c01055a6 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01055d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01055d4:	eb d0                	jmp    c01055a6 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01055dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055e0:	89 d0                	mov    %edx,%eax
c01055e2:	c1 e0 02             	shl    $0x2,%eax
c01055e5:	01 d0                	add    %edx,%eax
c01055e7:	01 c0                	add    %eax,%eax
c01055e9:	01 d8                	add    %ebx,%eax
c01055eb:	83 e8 30             	sub    $0x30,%eax
c01055ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01055f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f4:	0f b6 00             	movzbl (%eax),%eax
c01055f7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01055fa:	83 fb 2f             	cmp    $0x2f,%ebx
c01055fd:	7e 0b                	jle    c010560a <vprintfmt+0xb8>
c01055ff:	83 fb 39             	cmp    $0x39,%ebx
c0105602:	7f 06                	jg     c010560a <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105604:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105608:	eb d3                	jmp    c01055dd <vprintfmt+0x8b>
            goto process_precision;
c010560a:	eb 33                	jmp    c010563f <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010560c:	8b 45 14             	mov    0x14(%ebp),%eax
c010560f:	8d 50 04             	lea    0x4(%eax),%edx
c0105612:	89 55 14             	mov    %edx,0x14(%ebp)
c0105615:	8b 00                	mov    (%eax),%eax
c0105617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010561a:	eb 23                	jmp    c010563f <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010561c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105620:	79 0c                	jns    c010562e <vprintfmt+0xdc>
                width = 0;
c0105622:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105629:	e9 78 ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>
c010562e:	e9 73 ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010563a:	e9 67 ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010563f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105643:	79 12                	jns    c0105657 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105648:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010564b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105652:	e9 4f ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>
c0105657:	e9 4a ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010565c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105660:	e9 41 ff ff ff       	jmp    c01055a6 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105665:	8b 45 14             	mov    0x14(%ebp),%eax
c0105668:	8d 50 04             	lea    0x4(%eax),%edx
c010566b:	89 55 14             	mov    %edx,0x14(%ebp)
c010566e:	8b 00                	mov    (%eax),%eax
c0105670:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105673:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105677:	89 04 24             	mov    %eax,(%esp)
c010567a:	8b 45 08             	mov    0x8(%ebp),%eax
c010567d:	ff d0                	call   *%eax
            break;
c010567f:	e9 ac 02 00 00       	jmp    c0105930 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105684:	8b 45 14             	mov    0x14(%ebp),%eax
c0105687:	8d 50 04             	lea    0x4(%eax),%edx
c010568a:	89 55 14             	mov    %edx,0x14(%ebp)
c010568d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010568f:	85 db                	test   %ebx,%ebx
c0105691:	79 02                	jns    c0105695 <vprintfmt+0x143>
                err = -err;
c0105693:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105695:	83 fb 06             	cmp    $0x6,%ebx
c0105698:	7f 0b                	jg     c01056a5 <vprintfmt+0x153>
c010569a:	8b 34 9d 20 70 10 c0 	mov    -0x3fef8fe0(,%ebx,4),%esi
c01056a1:	85 f6                	test   %esi,%esi
c01056a3:	75 23                	jne    c01056c8 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01056a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01056a9:	c7 44 24 08 4d 70 10 	movl   $0xc010704d,0x8(%esp)
c01056b0:	c0 
c01056b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bb:	89 04 24             	mov    %eax,(%esp)
c01056be:	e8 61 fe ff ff       	call   c0105524 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056c3:	e9 68 02 00 00       	jmp    c0105930 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01056c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01056cc:	c7 44 24 08 56 70 10 	movl   $0xc0107056,0x8(%esp)
c01056d3:	c0 
c01056d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056db:	8b 45 08             	mov    0x8(%ebp),%eax
c01056de:	89 04 24             	mov    %eax,(%esp)
c01056e1:	e8 3e fe ff ff       	call   c0105524 <printfmt>
            }
            break;
c01056e6:	e9 45 02 00 00       	jmp    c0105930 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01056eb:	8b 45 14             	mov    0x14(%ebp),%eax
c01056ee:	8d 50 04             	lea    0x4(%eax),%edx
c01056f1:	89 55 14             	mov    %edx,0x14(%ebp)
c01056f4:	8b 30                	mov    (%eax),%esi
c01056f6:	85 f6                	test   %esi,%esi
c01056f8:	75 05                	jne    c01056ff <vprintfmt+0x1ad>
                p = "(null)";
c01056fa:	be 59 70 10 c0       	mov    $0xc0107059,%esi
            }
            if (width > 0 && padc != '-') {
c01056ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105703:	7e 3e                	jle    c0105743 <vprintfmt+0x1f1>
c0105705:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105709:	74 38                	je     c0105743 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010570b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105711:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105715:	89 34 24             	mov    %esi,(%esp)
c0105718:	e8 15 03 00 00       	call   c0105a32 <strnlen>
c010571d:	29 c3                	sub    %eax,%ebx
c010571f:	89 d8                	mov    %ebx,%eax
c0105721:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105724:	eb 17                	jmp    c010573d <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105726:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010572a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010572d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105731:	89 04 24             	mov    %eax,(%esp)
c0105734:	8b 45 08             	mov    0x8(%ebp),%eax
c0105737:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105739:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010573d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105741:	7f e3                	jg     c0105726 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105743:	eb 38                	jmp    c010577d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105745:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105749:	74 1f                	je     c010576a <vprintfmt+0x218>
c010574b:	83 fb 1f             	cmp    $0x1f,%ebx
c010574e:	7e 05                	jle    c0105755 <vprintfmt+0x203>
c0105750:	83 fb 7e             	cmp    $0x7e,%ebx
c0105753:	7e 15                	jle    c010576a <vprintfmt+0x218>
                    putch('?', putdat);
c0105755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105758:	89 44 24 04          	mov    %eax,0x4(%esp)
c010575c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105763:	8b 45 08             	mov    0x8(%ebp),%eax
c0105766:	ff d0                	call   *%eax
c0105768:	eb 0f                	jmp    c0105779 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010576a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010576d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105771:	89 1c 24             	mov    %ebx,(%esp)
c0105774:	8b 45 08             	mov    0x8(%ebp),%eax
c0105777:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105779:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010577d:	89 f0                	mov    %esi,%eax
c010577f:	8d 70 01             	lea    0x1(%eax),%esi
c0105782:	0f b6 00             	movzbl (%eax),%eax
c0105785:	0f be d8             	movsbl %al,%ebx
c0105788:	85 db                	test   %ebx,%ebx
c010578a:	74 10                	je     c010579c <vprintfmt+0x24a>
c010578c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105790:	78 b3                	js     c0105745 <vprintfmt+0x1f3>
c0105792:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010579a:	79 a9                	jns    c0105745 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010579c:	eb 17                	jmp    c01057b5 <vprintfmt+0x263>
                putch(' ', putdat);
c010579e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01057ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01057af:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057b1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057b9:	7f e3                	jg     c010579e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01057bb:	e9 70 01 00 00       	jmp    c0105930 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c7:	8d 45 14             	lea    0x14(%ebp),%eax
c01057ca:	89 04 24             	mov    %eax,(%esp)
c01057cd:	e8 0b fd ff ff       	call   c01054dd <getint>
c01057d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057db:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057de:	85 d2                	test   %edx,%edx
c01057e0:	79 26                	jns    c0105808 <vprintfmt+0x2b6>
                putch('-', putdat);
c01057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01057f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f3:	ff d0                	call   *%eax
                num = -(long long)num;
c01057f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057fb:	f7 d8                	neg    %eax
c01057fd:	83 d2 00             	adc    $0x0,%edx
c0105800:	f7 da                	neg    %edx
c0105802:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105805:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105808:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010580f:	e9 a8 00 00 00       	jmp    c01058bc <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105814:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105817:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581b:	8d 45 14             	lea    0x14(%ebp),%eax
c010581e:	89 04 24             	mov    %eax,(%esp)
c0105821:	e8 68 fc ff ff       	call   c010548e <getuint>
c0105826:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105829:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010582c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105833:	e9 84 00 00 00       	jmp    c01058bc <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105838:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010583b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105842:	89 04 24             	mov    %eax,(%esp)
c0105845:	e8 44 fc ff ff       	call   c010548e <getuint>
c010584a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010584d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105850:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105857:	eb 63                	jmp    c01058bc <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105860:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105867:	8b 45 08             	mov    0x8(%ebp),%eax
c010586a:	ff d0                	call   *%eax
            putch('x', putdat);
c010586c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105873:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010587a:	8b 45 08             	mov    0x8(%ebp),%eax
c010587d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010587f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105882:	8d 50 04             	lea    0x4(%eax),%edx
c0105885:	89 55 14             	mov    %edx,0x14(%ebp)
c0105888:	8b 00                	mov    (%eax),%eax
c010588a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010588d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105894:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010589b:	eb 1f                	jmp    c01058bc <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010589d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a4:	8d 45 14             	lea    0x14(%ebp),%eax
c01058a7:	89 04 24             	mov    %eax,(%esp)
c01058aa:	e8 df fb ff ff       	call   c010548e <getuint>
c01058af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01058b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058bc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058c3:	89 54 24 18          	mov    %edx,0x18(%esp)
c01058c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058ca:	89 54 24 14          	mov    %edx,0x14(%esp)
c01058ce:	89 44 24 10          	mov    %eax,0x10(%esp)
c01058d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058d8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01058e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ea:	89 04 24             	mov    %eax,(%esp)
c01058ed:	e8 97 fa ff ff       	call   c0105389 <printnum>
            break;
c01058f2:	eb 3c                	jmp    c0105930 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fb:	89 1c 24             	mov    %ebx,(%esp)
c01058fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105901:	ff d0                	call   *%eax
            break;
c0105903:	eb 2b                	jmp    c0105930 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105905:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105908:	89 44 24 04          	mov    %eax,0x4(%esp)
c010590c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105913:	8b 45 08             	mov    0x8(%ebp),%eax
c0105916:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105918:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010591c:	eb 04                	jmp    c0105922 <vprintfmt+0x3d0>
c010591e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105922:	8b 45 10             	mov    0x10(%ebp),%eax
c0105925:	83 e8 01             	sub    $0x1,%eax
c0105928:	0f b6 00             	movzbl (%eax),%eax
c010592b:	3c 25                	cmp    $0x25,%al
c010592d:	75 ef                	jne    c010591e <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010592f:	90                   	nop
        }
    }
c0105930:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105931:	e9 3e fc ff ff       	jmp    c0105574 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105936:	83 c4 40             	add    $0x40,%esp
c0105939:	5b                   	pop    %ebx
c010593a:	5e                   	pop    %esi
c010593b:	5d                   	pop    %ebp
c010593c:	c3                   	ret    

c010593d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010593d:	55                   	push   %ebp
c010593e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105940:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105943:	8b 40 08             	mov    0x8(%eax),%eax
c0105946:	8d 50 01             	lea    0x1(%eax),%edx
c0105949:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010594f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105952:	8b 10                	mov    (%eax),%edx
c0105954:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105957:	8b 40 04             	mov    0x4(%eax),%eax
c010595a:	39 c2                	cmp    %eax,%edx
c010595c:	73 12                	jae    c0105970 <sprintputch+0x33>
        *b->buf ++ = ch;
c010595e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105961:	8b 00                	mov    (%eax),%eax
c0105963:	8d 48 01             	lea    0x1(%eax),%ecx
c0105966:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105969:	89 0a                	mov    %ecx,(%edx)
c010596b:	8b 55 08             	mov    0x8(%ebp),%edx
c010596e:	88 10                	mov    %dl,(%eax)
    }
}
c0105970:	5d                   	pop    %ebp
c0105971:	c3                   	ret    

c0105972 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105972:	55                   	push   %ebp
c0105973:	89 e5                	mov    %esp,%ebp
c0105975:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105978:	8d 45 14             	lea    0x14(%ebp),%eax
c010597b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010597e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105981:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105985:	8b 45 10             	mov    0x10(%ebp),%eax
c0105988:	89 44 24 08          	mov    %eax,0x8(%esp)
c010598c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105993:	8b 45 08             	mov    0x8(%ebp),%eax
c0105996:	89 04 24             	mov    %eax,(%esp)
c0105999:	e8 08 00 00 00       	call   c01059a6 <vsnprintf>
c010599e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01059a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059a4:	c9                   	leave  
c01059a5:	c3                   	ret    

c01059a6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01059a6:	55                   	push   %ebp
c01059a7:	89 e5                	mov    %esp,%ebp
c01059a9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01059ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01059af:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bb:	01 d0                	add    %edx,%eax
c01059bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059cb:	74 0a                	je     c01059d7 <vsnprintf+0x31>
c01059cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01059d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059d3:	39 c2                	cmp    %eax,%edx
c01059d5:	76 07                	jbe    c01059de <vsnprintf+0x38>
        return -E_INVAL;
c01059d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01059dc:	eb 2a                	jmp    c0105a08 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01059de:	8b 45 14             	mov    0x14(%ebp),%eax
c01059e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01059ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f3:	c7 04 24 3d 59 10 c0 	movl   $0xc010593d,(%esp)
c01059fa:	e8 53 fb ff ff       	call   c0105552 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01059ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a02:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a08:	c9                   	leave  
c0105a09:	c3                   	ret    

c0105a0a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a0a:	55                   	push   %ebp
c0105a0b:	89 e5                	mov    %esp,%ebp
c0105a0d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a17:	eb 04                	jmp    c0105a1d <strlen+0x13>
        cnt ++;
c0105a19:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a20:	8d 50 01             	lea    0x1(%eax),%edx
c0105a23:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a26:	0f b6 00             	movzbl (%eax),%eax
c0105a29:	84 c0                	test   %al,%al
c0105a2b:	75 ec                	jne    c0105a19 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a30:	c9                   	leave  
c0105a31:	c3                   	ret    

c0105a32 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a32:	55                   	push   %ebp
c0105a33:	89 e5                	mov    %esp,%ebp
c0105a35:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a3f:	eb 04                	jmp    c0105a45 <strnlen+0x13>
        cnt ++;
c0105a41:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a4b:	73 10                	jae    c0105a5d <strnlen+0x2b>
c0105a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a50:	8d 50 01             	lea    0x1(%eax),%edx
c0105a53:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a56:	0f b6 00             	movzbl (%eax),%eax
c0105a59:	84 c0                	test   %al,%al
c0105a5b:	75 e4                	jne    c0105a41 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a60:	c9                   	leave  
c0105a61:	c3                   	ret    

c0105a62 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a62:	55                   	push   %ebp
c0105a63:	89 e5                	mov    %esp,%ebp
c0105a65:	57                   	push   %edi
c0105a66:	56                   	push   %esi
c0105a67:	83 ec 20             	sub    $0x20,%esp
c0105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a7c:	89 d1                	mov    %edx,%ecx
c0105a7e:	89 c2                	mov    %eax,%edx
c0105a80:	89 ce                	mov    %ecx,%esi
c0105a82:	89 d7                	mov    %edx,%edi
c0105a84:	ac                   	lods   %ds:(%esi),%al
c0105a85:	aa                   	stos   %al,%es:(%edi)
c0105a86:	84 c0                	test   %al,%al
c0105a88:	75 fa                	jne    c0105a84 <strcpy+0x22>
c0105a8a:	89 fa                	mov    %edi,%edx
c0105a8c:	89 f1                	mov    %esi,%ecx
c0105a8e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a91:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a9a:	83 c4 20             	add    $0x20,%esp
c0105a9d:	5e                   	pop    %esi
c0105a9e:	5f                   	pop    %edi
c0105a9f:	5d                   	pop    %ebp
c0105aa0:	c3                   	ret    

c0105aa1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105aa1:	55                   	push   %ebp
c0105aa2:	89 e5                	mov    %esp,%ebp
c0105aa4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105aad:	eb 21                	jmp    c0105ad0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab2:	0f b6 10             	movzbl (%eax),%edx
c0105ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ab8:	88 10                	mov    %dl,(%eax)
c0105aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105abd:	0f b6 00             	movzbl (%eax),%eax
c0105ac0:	84 c0                	test   %al,%al
c0105ac2:	74 04                	je     c0105ac8 <strncpy+0x27>
            src ++;
c0105ac4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105ac8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105acc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ad4:	75 d9                	jne    c0105aaf <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ad9:	c9                   	leave  
c0105ada:	c3                   	ret    

c0105adb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105adb:	55                   	push   %ebp
c0105adc:	89 e5                	mov    %esp,%ebp
c0105ade:	57                   	push   %edi
c0105adf:	56                   	push   %esi
c0105ae0:	83 ec 20             	sub    $0x20,%esp
c0105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af5:	89 d1                	mov    %edx,%ecx
c0105af7:	89 c2                	mov    %eax,%edx
c0105af9:	89 ce                	mov    %ecx,%esi
c0105afb:	89 d7                	mov    %edx,%edi
c0105afd:	ac                   	lods   %ds:(%esi),%al
c0105afe:	ae                   	scas   %es:(%edi),%al
c0105aff:	75 08                	jne    c0105b09 <strcmp+0x2e>
c0105b01:	84 c0                	test   %al,%al
c0105b03:	75 f8                	jne    c0105afd <strcmp+0x22>
c0105b05:	31 c0                	xor    %eax,%eax
c0105b07:	eb 04                	jmp    c0105b0d <strcmp+0x32>
c0105b09:	19 c0                	sbb    %eax,%eax
c0105b0b:	0c 01                	or     $0x1,%al
c0105b0d:	89 fa                	mov    %edi,%edx
c0105b0f:	89 f1                	mov    %esi,%ecx
c0105b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b1d:	83 c4 20             	add    $0x20,%esp
c0105b20:	5e                   	pop    %esi
c0105b21:	5f                   	pop    %edi
c0105b22:	5d                   	pop    %ebp
c0105b23:	c3                   	ret    

c0105b24 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b24:	55                   	push   %ebp
c0105b25:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b27:	eb 0c                	jmp    c0105b35 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105b29:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b31:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b39:	74 1a                	je     c0105b55 <strncmp+0x31>
c0105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3e:	0f b6 00             	movzbl (%eax),%eax
c0105b41:	84 c0                	test   %al,%al
c0105b43:	74 10                	je     c0105b55 <strncmp+0x31>
c0105b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b48:	0f b6 10             	movzbl (%eax),%edx
c0105b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4e:	0f b6 00             	movzbl (%eax),%eax
c0105b51:	38 c2                	cmp    %al,%dl
c0105b53:	74 d4                	je     c0105b29 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b59:	74 18                	je     c0105b73 <strncmp+0x4f>
c0105b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5e:	0f b6 00             	movzbl (%eax),%eax
c0105b61:	0f b6 d0             	movzbl %al,%edx
c0105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b67:	0f b6 00             	movzbl (%eax),%eax
c0105b6a:	0f b6 c0             	movzbl %al,%eax
c0105b6d:	29 c2                	sub    %eax,%edx
c0105b6f:	89 d0                	mov    %edx,%eax
c0105b71:	eb 05                	jmp    c0105b78 <strncmp+0x54>
c0105b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b78:	5d                   	pop    %ebp
c0105b79:	c3                   	ret    

c0105b7a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b7a:	55                   	push   %ebp
c0105b7b:	89 e5                	mov    %esp,%ebp
c0105b7d:	83 ec 04             	sub    $0x4,%esp
c0105b80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b83:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b86:	eb 14                	jmp    c0105b9c <strchr+0x22>
        if (*s == c) {
c0105b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8b:	0f b6 00             	movzbl (%eax),%eax
c0105b8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b91:	75 05                	jne    c0105b98 <strchr+0x1e>
            return (char *)s;
c0105b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b96:	eb 13                	jmp    c0105bab <strchr+0x31>
        }
        s ++;
c0105b98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9f:	0f b6 00             	movzbl (%eax),%eax
c0105ba2:	84 c0                	test   %al,%al
c0105ba4:	75 e2                	jne    c0105b88 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bab:	c9                   	leave  
c0105bac:	c3                   	ret    

c0105bad <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105bad:	55                   	push   %ebp
c0105bae:	89 e5                	mov    %esp,%ebp
c0105bb0:	83 ec 04             	sub    $0x4,%esp
c0105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bb9:	eb 11                	jmp    c0105bcc <strfind+0x1f>
        if (*s == c) {
c0105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbe:	0f b6 00             	movzbl (%eax),%eax
c0105bc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105bc4:	75 02                	jne    c0105bc8 <strfind+0x1b>
            break;
c0105bc6:	eb 0e                	jmp    c0105bd6 <strfind+0x29>
        }
        s ++;
c0105bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcf:	0f b6 00             	movzbl (%eax),%eax
c0105bd2:	84 c0                	test   %al,%al
c0105bd4:	75 e5                	jne    c0105bbb <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105bd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bd9:	c9                   	leave  
c0105bda:	c3                   	ret    

c0105bdb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105bdb:	55                   	push   %ebp
c0105bdc:	89 e5                	mov    %esp,%ebp
c0105bde:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105be8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bef:	eb 04                	jmp    c0105bf5 <strtol+0x1a>
        s ++;
c0105bf1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	0f b6 00             	movzbl (%eax),%eax
c0105bfb:	3c 20                	cmp    $0x20,%al
c0105bfd:	74 f2                	je     c0105bf1 <strtol+0x16>
c0105bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c02:	0f b6 00             	movzbl (%eax),%eax
c0105c05:	3c 09                	cmp    $0x9,%al
c0105c07:	74 e8                	je     c0105bf1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0c:	0f b6 00             	movzbl (%eax),%eax
c0105c0f:	3c 2b                	cmp    $0x2b,%al
c0105c11:	75 06                	jne    c0105c19 <strtol+0x3e>
        s ++;
c0105c13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c17:	eb 15                	jmp    c0105c2e <strtol+0x53>
    }
    else if (*s == '-') {
c0105c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1c:	0f b6 00             	movzbl (%eax),%eax
c0105c1f:	3c 2d                	cmp    $0x2d,%al
c0105c21:	75 0b                	jne    c0105c2e <strtol+0x53>
        s ++, neg = 1;
c0105c23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c32:	74 06                	je     c0105c3a <strtol+0x5f>
c0105c34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c38:	75 24                	jne    c0105c5e <strtol+0x83>
c0105c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3d:	0f b6 00             	movzbl (%eax),%eax
c0105c40:	3c 30                	cmp    $0x30,%al
c0105c42:	75 1a                	jne    c0105c5e <strtol+0x83>
c0105c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c47:	83 c0 01             	add    $0x1,%eax
c0105c4a:	0f b6 00             	movzbl (%eax),%eax
c0105c4d:	3c 78                	cmp    $0x78,%al
c0105c4f:	75 0d                	jne    c0105c5e <strtol+0x83>
        s += 2, base = 16;
c0105c51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c5c:	eb 2a                	jmp    c0105c88 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c62:	75 17                	jne    c0105c7b <strtol+0xa0>
c0105c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c67:	0f b6 00             	movzbl (%eax),%eax
c0105c6a:	3c 30                	cmp    $0x30,%al
c0105c6c:	75 0d                	jne    c0105c7b <strtol+0xa0>
        s ++, base = 8;
c0105c6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c72:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c79:	eb 0d                	jmp    c0105c88 <strtol+0xad>
    }
    else if (base == 0) {
c0105c7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c7f:	75 07                	jne    c0105c88 <strtol+0xad>
        base = 10;
c0105c81:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8b:	0f b6 00             	movzbl (%eax),%eax
c0105c8e:	3c 2f                	cmp    $0x2f,%al
c0105c90:	7e 1b                	jle    c0105cad <strtol+0xd2>
c0105c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c95:	0f b6 00             	movzbl (%eax),%eax
c0105c98:	3c 39                	cmp    $0x39,%al
c0105c9a:	7f 11                	jg     c0105cad <strtol+0xd2>
            dig = *s - '0';
c0105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9f:	0f b6 00             	movzbl (%eax),%eax
c0105ca2:	0f be c0             	movsbl %al,%eax
c0105ca5:	83 e8 30             	sub    $0x30,%eax
c0105ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cab:	eb 48                	jmp    c0105cf5 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb0:	0f b6 00             	movzbl (%eax),%eax
c0105cb3:	3c 60                	cmp    $0x60,%al
c0105cb5:	7e 1b                	jle    c0105cd2 <strtol+0xf7>
c0105cb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cba:	0f b6 00             	movzbl (%eax),%eax
c0105cbd:	3c 7a                	cmp    $0x7a,%al
c0105cbf:	7f 11                	jg     c0105cd2 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc4:	0f b6 00             	movzbl (%eax),%eax
c0105cc7:	0f be c0             	movsbl %al,%eax
c0105cca:	83 e8 57             	sub    $0x57,%eax
c0105ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cd0:	eb 23                	jmp    c0105cf5 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd5:	0f b6 00             	movzbl (%eax),%eax
c0105cd8:	3c 40                	cmp    $0x40,%al
c0105cda:	7e 3d                	jle    c0105d19 <strtol+0x13e>
c0105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdf:	0f b6 00             	movzbl (%eax),%eax
c0105ce2:	3c 5a                	cmp    $0x5a,%al
c0105ce4:	7f 33                	jg     c0105d19 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce9:	0f b6 00             	movzbl (%eax),%eax
c0105cec:	0f be c0             	movsbl %al,%eax
c0105cef:	83 e8 37             	sub    $0x37,%eax
c0105cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf8:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cfb:	7c 02                	jl     c0105cff <strtol+0x124>
            break;
c0105cfd:	eb 1a                	jmp    c0105d19 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105cff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d06:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d0a:	89 c2                	mov    %eax,%edx
c0105d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d0f:	01 d0                	add    %edx,%eax
c0105d11:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105d14:	e9 6f ff ff ff       	jmp    c0105c88 <strtol+0xad>

    if (endptr) {
c0105d19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d1d:	74 08                	je     c0105d27 <strtol+0x14c>
        *endptr = (char *) s;
c0105d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d22:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d25:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d2b:	74 07                	je     c0105d34 <strtol+0x159>
c0105d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d30:	f7 d8                	neg    %eax
c0105d32:	eb 03                	jmp    c0105d37 <strtol+0x15c>
c0105d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d37:	c9                   	leave  
c0105d38:	c3                   	ret    

c0105d39 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d39:	55                   	push   %ebp
c0105d3a:	89 e5                	mov    %esp,%ebp
c0105d3c:	57                   	push   %edi
c0105d3d:	83 ec 24             	sub    $0x24,%esp
c0105d40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d43:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d46:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105d4a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d4d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105d50:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d53:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d5c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d60:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d63:	89 d7                	mov    %edx,%edi
c0105d65:	f3 aa                	rep stos %al,%es:(%edi)
c0105d67:	89 fa                	mov    %edi,%edx
c0105d69:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d6c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d72:	83 c4 24             	add    $0x24,%esp
c0105d75:	5f                   	pop    %edi
c0105d76:	5d                   	pop    %ebp
c0105d77:	c3                   	ret    

c0105d78 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d78:	55                   	push   %ebp
c0105d79:	89 e5                	mov    %esp,%ebp
c0105d7b:	57                   	push   %edi
c0105d7c:	56                   	push   %esi
c0105d7d:	53                   	push   %ebx
c0105d7e:	83 ec 30             	sub    $0x30,%esp
c0105d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d8d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d90:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d99:	73 42                	jae    c0105ddd <memmove+0x65>
c0105d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105da4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105daa:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105db0:	c1 e8 02             	shr    $0x2,%eax
c0105db3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105db5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dbb:	89 d7                	mov    %edx,%edi
c0105dbd:	89 c6                	mov    %eax,%esi
c0105dbf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dc1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105dc4:	83 e1 03             	and    $0x3,%ecx
c0105dc7:	74 02                	je     c0105dcb <memmove+0x53>
c0105dc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dcb:	89 f0                	mov    %esi,%eax
c0105dcd:	89 fa                	mov    %edi,%edx
c0105dcf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105dd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ddb:	eb 36                	jmp    c0105e13 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105de0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105de6:	01 c2                	add    %eax,%edx
c0105de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105deb:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105df1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105df7:	89 c1                	mov    %eax,%ecx
c0105df9:	89 d8                	mov    %ebx,%eax
c0105dfb:	89 d6                	mov    %edx,%esi
c0105dfd:	89 c7                	mov    %eax,%edi
c0105dff:	fd                   	std    
c0105e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e02:	fc                   	cld    
c0105e03:	89 f8                	mov    %edi,%eax
c0105e05:	89 f2                	mov    %esi,%edx
c0105e07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e0a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e13:	83 c4 30             	add    $0x30,%esp
c0105e16:	5b                   	pop    %ebx
c0105e17:	5e                   	pop    %esi
c0105e18:	5f                   	pop    %edi
c0105e19:	5d                   	pop    %ebp
c0105e1a:	c3                   	ret    

c0105e1b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e1b:	55                   	push   %ebp
c0105e1c:	89 e5                	mov    %esp,%ebp
c0105e1e:	57                   	push   %edi
c0105e1f:	56                   	push   %esi
c0105e20:	83 ec 20             	sub    $0x20,%esp
c0105e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e38:	c1 e8 02             	shr    $0x2,%eax
c0105e3b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e43:	89 d7                	mov    %edx,%edi
c0105e45:	89 c6                	mov    %eax,%esi
c0105e47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e49:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e4c:	83 e1 03             	and    $0x3,%ecx
c0105e4f:	74 02                	je     c0105e53 <memcpy+0x38>
c0105e51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e53:	89 f0                	mov    %esi,%eax
c0105e55:	89 fa                	mov    %edi,%edx
c0105e57:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e63:	83 c4 20             	add    $0x20,%esp
c0105e66:	5e                   	pop    %esi
c0105e67:	5f                   	pop    %edi
c0105e68:	5d                   	pop    %ebp
c0105e69:	c3                   	ret    

c0105e6a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e6a:	55                   	push   %ebp
c0105e6b:	89 e5                	mov    %esp,%ebp
c0105e6d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e7c:	eb 30                	jmp    c0105eae <memcmp+0x44>
        if (*s1 != *s2) {
c0105e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e81:	0f b6 10             	movzbl (%eax),%edx
c0105e84:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e87:	0f b6 00             	movzbl (%eax),%eax
c0105e8a:	38 c2                	cmp    %al,%dl
c0105e8c:	74 18                	je     c0105ea6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e91:	0f b6 00             	movzbl (%eax),%eax
c0105e94:	0f b6 d0             	movzbl %al,%edx
c0105e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e9a:	0f b6 00             	movzbl (%eax),%eax
c0105e9d:	0f b6 c0             	movzbl %al,%eax
c0105ea0:	29 c2                	sub    %eax,%edx
c0105ea2:	89 d0                	mov    %edx,%eax
c0105ea4:	eb 1a                	jmp    c0105ec0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105ea6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105eaa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105eae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eb4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eb7:	85 c0                	test   %eax,%eax
c0105eb9:	75 c3                	jne    c0105e7e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ec0:	c9                   	leave  
c0105ec1:	c3                   	ret    
