
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 aa 32 00 00       	call   1032d6 <memset>

    cons_init();                // init the console
  10002c:	e8 34 15 00 00       	call   101565 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 60 34 10 00 	movl   $0x103460,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 7c 34 10 00 	movl   $0x10347c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 c2 28 00 00       	call   10291c <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 49 16 00 00       	call   1016a8 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 9b 17 00 00       	call   1017ff <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 ef 0c 00 00       	call   100d58 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a8 15 00 00       	call   101616 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 f8 0b 00 00       	call   100c8a <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 81 34 10 00 	movl   $0x103481,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 8f 34 10 00 	movl   $0x10348f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 9d 34 10 00 	movl   $0x10349d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 ab 34 10 00 	movl   $0x1034ab,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 b9 34 10 00 	movl   $0x1034b9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 c8 34 10 00 	movl   $0x1034c8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 07 35 10 00 	movl   $0x103507,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 c1 12 00 00       	call   101591 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 e2 27 00 00       	call   102aef <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 48 12 00 00       	call   101591 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 15 12 00 00       	call   1015ba <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 0c 35 10 00    	movl   $0x10350c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 0c 35 10 00 	movl   $0x10350c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 6c 3d 10 00 	movl   $0x103d6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 70 b4 10 00 	movl   $0x10b470,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 71 b4 10 00 	movl   $0x10b471,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 5b d4 10 00 	movl   $0x10d45b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 88 2a 00 00       	call   10314a <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 16 35 10 00 	movl   $0x103516,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 2f 35 10 00 	movl   $0x10352f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 5f 34 10 	movl   $0x10345f,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 47 35 10 00 	movl   $0x103547,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 5f 35 10 00 	movl   $0x10355f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 77 35 10 00 	movl   $0x103577,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 90 35 10 00 	movl   $0x103590,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 ba 35 10 00 	movl   $0x1035ba,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 d6 35 10 00 	movl   $0x1035d6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	53                   	push   %ebx
  100994:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100997:	89 e8                	mov    %ebp,%eax
  100999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  10099c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	  uint32_t ebp = read_ebp();
  10099f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	  uint32_t eip = read_eip();
  1009a2:	e8 d8 ff ff ff       	call   10097f <read_eip>
  1009a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int i;
	  for (i=0; i<STACKFRAME_DEPTH; i++) {
  1009aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b1:	e9 89 00 00 00       	jmp    100a3f <print_stackframe+0xaf>
	     cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c4:	c7 04 24 e8 35 10 00 	movl   $0x1035e8,(%esp)
  1009cb:	e8 42 f9 ff ff       	call   100312 <cprintf>
	     uint32_t* arg = (uint32_t*)ebp+2;
  1009d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d3:	83 c0 08             	add    $0x8,%eax
  1009d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	     cprintf("args: 0x%08x 0x%08x 0x%08x 0x%08x\n", arg[0], arg[1], arg[2], arg[3]);
  1009d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009dc:	83 c0 0c             	add    $0xc,%eax
  1009df:	8b 18                	mov    (%eax),%ebx
  1009e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e4:	83 c0 08             	add    $0x8,%eax
  1009e7:	8b 08                	mov    (%eax),%ecx
  1009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ec:	83 c0 04             	add    $0x4,%eax
  1009ef:	8b 10                	mov    (%eax),%edx
  1009f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f4:	8b 00                	mov    (%eax),%eax
  1009f6:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  1009fa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a06:	c7 04 24 00 36 10 00 	movl   $0x103600,(%esp)
  100a0d:	e8 00 f9 ff ff       	call   100312 <cprintf>
	     print_debuginfo(eip-1);
  100a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a15:	83 e8 01             	sub    $0x1,%eax
  100a18:	89 04 24             	mov    %eax,(%esp)
  100a1b:	e8 bc fe ff ff       	call   1008dc <print_debuginfo>
	     eip = *((uint32_t*)ebp+1);
  100a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a23:	83 c0 04             	add    $0x4,%eax
  100a26:	8b 00                	mov    (%eax),%eax
  100a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	     ebp = *(uint32_t *)ebp;
  100a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2e:	8b 00                	mov    (%eax),%eax
  100a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	     if (ebp == 0) break;
  100a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a37:	75 02                	jne    100a3b <print_stackframe+0xab>
  100a39:	eb 0e                	jmp    100a49 <print_stackframe+0xb9>
      *                   the calling funciton's ebp = ss:[ebp]
      */
	  uint32_t ebp = read_ebp();
	  uint32_t eip = read_eip();
	  int i;
	  for (i=0; i<STACKFRAME_DEPTH; i++) {
  100a3b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a43:	0f 8e 6d ff ff ff    	jle    1009b6 <print_stackframe+0x26>
	     print_debuginfo(eip-1);
	     eip = *((uint32_t*)ebp+1);
	     ebp = *(uint32_t *)ebp;
	     if (ebp == 0) break;
	  }
}
  100a49:	83 c4 44             	add    $0x44,%esp
  100a4c:	5b                   	pop    %ebx
  100a4d:	5d                   	pop    %ebp
  100a4e:	c3                   	ret    

00100a4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4f:	55                   	push   %ebp
  100a50:	89 e5                	mov    %esp,%ebp
  100a52:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5c:	eb 0c                	jmp    100a6a <parse+0x1b>
            *buf ++ = '\0';
  100a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a61:	8d 50 01             	lea    0x1(%eax),%edx
  100a64:	89 55 08             	mov    %edx,0x8(%ebp)
  100a67:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6d:	0f b6 00             	movzbl (%eax),%eax
  100a70:	84 c0                	test   %al,%al
  100a72:	74 1d                	je     100a91 <parse+0x42>
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	0f be c0             	movsbl %al,%eax
  100a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a81:	c7 04 24 a4 36 10 00 	movl   $0x1036a4,(%esp)
  100a88:	e8 8a 26 00 00       	call   103117 <strchr>
  100a8d:	85 c0                	test   %eax,%eax
  100a8f:	75 cd                	jne    100a5e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	0f b6 00             	movzbl (%eax),%eax
  100a97:	84 c0                	test   %al,%al
  100a99:	75 02                	jne    100a9d <parse+0x4e>
            break;
  100a9b:	eb 67                	jmp    100b04 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a9d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa1:	75 14                	jne    100ab7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aaa:	00 
  100aab:	c7 04 24 a9 36 10 00 	movl   $0x1036a9,(%esp)
  100ab2:	e8 5b f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aba:	8d 50 01             	lea    0x1(%eax),%edx
  100abd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aca:	01 c2                	add    %eax,%edx
  100acc:	8b 45 08             	mov    0x8(%ebp),%eax
  100acf:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	eb 04                	jmp    100ad7 <parse+0x88>
            buf ++;
  100ad3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	0f b6 00             	movzbl (%eax),%eax
  100add:	84 c0                	test   %al,%al
  100adf:	74 1d                	je     100afe <parse+0xaf>
  100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae4:	0f b6 00             	movzbl (%eax),%eax
  100ae7:	0f be c0             	movsbl %al,%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 a4 36 10 00 	movl   $0x1036a4,(%esp)
  100af5:	e8 1d 26 00 00       	call   103117 <strchr>
  100afa:	85 c0                	test   %eax,%eax
  100afc:	74 d5                	je     100ad3 <parse+0x84>
            buf ++;
        }
    }
  100afe:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aff:	e9 66 ff ff ff       	jmp    100a6a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	89 04 24             	mov    %eax,(%esp)
  100b1c:	e8 2e ff ff ff       	call   100a4f <parse>
  100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	75 0a                	jne    100b34 <runcmd+0x2b>
        return 0;
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	e9 85 00 00 00       	jmp    100bb9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3b:	eb 5c                	jmp    100b99 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b43:	89 d0                	mov    %edx,%eax
  100b45:	01 c0                	add    %eax,%eax
  100b47:	01 d0                	add    %edx,%eax
  100b49:	c1 e0 02             	shl    $0x2,%eax
  100b4c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b57:	89 04 24             	mov    %eax,(%esp)
  100b5a:	e8 19 25 00 00       	call   103078 <strcmp>
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 32                	jne    100b95 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b66:	89 d0                	mov    %edx,%eax
  100b68:	01 c0                	add    %eax,%eax
  100b6a:	01 d0                	add    %edx,%eax
  100b6c:	c1 e0 02             	shl    $0x2,%eax
  100b6f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b74:	8b 40 08             	mov    0x8(%eax),%eax
  100b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b7a:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b80:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b84:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b87:	83 c2 04             	add    $0x4,%edx
  100b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8e:	89 0c 24             	mov    %ecx,(%esp)
  100b91:	ff d0                	call   *%eax
  100b93:	eb 24                	jmp    100bb9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9c:	83 f8 02             	cmp    $0x2,%eax
  100b9f:	76 9c                	jbe    100b3d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba8:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  100baf:	e8 5e f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb9:	c9                   	leave  
  100bba:	c3                   	ret    

00100bbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbb:	55                   	push   %ebp
  100bbc:	89 e5                	mov    %esp,%ebp
  100bbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc1:	c7 04 24 e0 36 10 00 	movl   $0x1036e0,(%esp)
  100bc8:	e8 45 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcd:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  100bd4:	e8 39 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdd:	74 0b                	je     100bea <kmonitor+0x2f>
        print_trapframe(tf);
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	89 04 24             	mov    %eax,(%esp)
  100be5:	e8 cd 0d 00 00       	call   1019b7 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bea:	c7 04 24 2d 37 10 00 	movl   $0x10372d,(%esp)
  100bf1:	e8 13 f6 ff ff       	call   100209 <readline>
  100bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bfd:	74 18                	je     100c17 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bff:	8b 45 08             	mov    0x8(%ebp),%eax
  100c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c09:	89 04 24             	mov    %eax,(%esp)
  100c0c:	e8 f8 fe ff ff       	call   100b09 <runcmd>
  100c11:	85 c0                	test   %eax,%eax
  100c13:	79 02                	jns    100c17 <kmonitor+0x5c>
                break;
  100c15:	eb 02                	jmp    100c19 <kmonitor+0x5e>
            }
        }
    }
  100c17:	eb d1                	jmp    100bea <kmonitor+0x2f>
}
  100c19:	c9                   	leave  
  100c1a:	c3                   	ret    

00100c1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c28:	eb 3f                	jmp    100c69 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2d:	89 d0                	mov    %edx,%eax
  100c2f:	01 c0                	add    %eax,%eax
  100c31:	01 d0                	add    %edx,%eax
  100c33:	c1 e0 02             	shl    $0x2,%eax
  100c36:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c41:	89 d0                	mov    %edx,%eax
  100c43:	01 c0                	add    %eax,%eax
  100c45:	01 d0                	add    %edx,%eax
  100c47:	c1 e0 02             	shl    $0x2,%eax
  100c4a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c59:	c7 04 24 31 37 10 00 	movl   $0x103731,(%esp)
  100c60:	e8 ad f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6c:	83 f8 02             	cmp    $0x2,%eax
  100c6f:	76 b9                	jbe    100c2a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c76:	c9                   	leave  
  100c77:	c3                   	ret    

00100c78 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7e:	e8 c3 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c88:	c9                   	leave  
  100c89:	c3                   	ret    

00100c8a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c90:	e8 fb fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca2:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca7:	85 c0                	test   %eax,%eax
  100ca9:	74 02                	je     100cad <__panic+0x11>
        goto panic_dead;
  100cab:	eb 48                	jmp    100cf5 <__panic+0x59>
    }
    is_panic = 1;
  100cad:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  100cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccb:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100cd2:	e8 3b f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce1:	89 04 24             	mov    %eax,(%esp)
  100ce4:	e8 f6 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce9:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100cf0:	e8 1d f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cf5:	e8 22 09 00 00       	call   10161c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d01:	e8 b5 fe ff ff       	call   100bbb <kmonitor>
    }
  100d06:	eb f2                	jmp    100cfa <__panic+0x5e>

00100d08 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d08:	55                   	push   %ebp
  100d09:	89 e5                	mov    %esp,%ebp
  100d0b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d0e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d17:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d22:	c7 04 24 58 37 10 00 	movl   $0x103758,(%esp)
  100d29:	e8 e4 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d35:	8b 45 10             	mov    0x10(%ebp),%eax
  100d38:	89 04 24             	mov    %eax,(%esp)
  100d3b:	e8 9f f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d40:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100d47:	e8 c6 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d4c:	c9                   	leave  
  100d4d:	c3                   	ret    

00100d4e <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d4e:	55                   	push   %ebp
  100d4f:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d51:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d56:	5d                   	pop    %ebp
  100d57:	c3                   	ret    

00100d58 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d58:	55                   	push   %ebp
  100d59:	89 e5                	mov    %esp,%ebp
  100d5b:	83 ec 28             	sub    $0x28,%esp
  100d5e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d64:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d68:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d6c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d70:	ee                   	out    %al,(%dx)
  100d71:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d77:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d7b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d83:	ee                   	out    %al,(%dx)
  100d84:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d8a:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d96:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d97:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d9e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da1:	c7 04 24 76 37 10 00 	movl   $0x103776,(%esp)
  100da8:	e8 65 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db4:	e8 c1 08 00 00       	call   10167a <pic_enable>
}
  100db9:	c9                   	leave  
  100dba:	c3                   	ret    

00100dbb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 10             	sub    $0x10,%esp
  100dc1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dcb:	89 c2                	mov    %eax,%edx
  100dcd:	ec                   	in     (%dx),%al
  100dce:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dd1:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ddb:	89 c2                	mov    %eax,%edx
  100ddd:	ec                   	in     (%dx),%al
  100dde:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de1:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100deb:	89 c2                	mov    %eax,%edx
  100ded:	ec                   	in     (%dx),%al
  100dee:	88 45 f5             	mov    %al,-0xb(%ebp)
  100df1:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100df7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dfb:	89 c2                	mov    %eax,%edx
  100dfd:	ec                   	in     (%dx),%al
  100dfe:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e01:	c9                   	leave  
  100e02:	c3                   	ret    

00100e03 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e03:	55                   	push   %ebp
  100e04:	89 e5                	mov    %esp,%ebp
  100e06:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e09:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e13:	0f b7 00             	movzwl (%eax),%eax
  100e16:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e25:	0f b7 00             	movzwl (%eax),%eax
  100e28:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2c:	74 12                	je     100e40 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e2e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e35:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3c:	b4 03 
  100e3e:	eb 13                	jmp    100e53 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e43:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e47:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4a:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e51:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e53:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5a:	0f b7 c0             	movzwl %ax,%eax
  100e5d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e61:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e65:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e69:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e6e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e75:	83 c0 01             	add    $0x1,%eax
  100e78:	0f b7 c0             	movzwl %ax,%eax
  100e7b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e83:	89 c2                	mov    %eax,%edx
  100e85:	ec                   	in     (%dx),%al
  100e86:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e89:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e8d:	0f b6 c0             	movzbl %al,%eax
  100e90:	c1 e0 08             	shl    $0x8,%eax
  100e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e96:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9d:	0f b7 c0             	movzwl %ax,%eax
  100ea0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ea4:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eb0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eb1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb8:	83 c0 01             	add    $0x1,%eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ecc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed0:	0f b6 c0             	movzbl %al,%eax
  100ed3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee7:	c9                   	leave  
  100ee8:	c3                   	ret    

00100ee9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee9:	55                   	push   %ebp
  100eea:	89 e5                	mov    %esp,%ebp
  100eec:	83 ec 48             	sub    $0x48,%esp
  100eef:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ef5:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100efd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f01:	ee                   	out    %al,(%dx)
  100f02:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f08:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f0c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f10:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
  100f15:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f1b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f1f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f23:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f27:	ee                   	out    %al,(%dx)
  100f28:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f2e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f32:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f36:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
  100f3b:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f41:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
  100f4e:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f54:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f58:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f5c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f60:	ee                   	out    %al,(%dx)
  100f61:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f67:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f6b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f6f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7a:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f7e:	89 c2                	mov    %eax,%edx
  100f80:	ec                   	in     (%dx),%al
  100f81:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f84:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f88:	3c ff                	cmp    $0xff,%al
  100f8a:	0f 95 c0             	setne  %al
  100f8d:	0f b6 c0             	movzbl %al,%eax
  100f90:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f95:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fa5:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fab:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100faf:	89 c2                	mov    %eax,%edx
  100fb1:	ec                   	in     (%dx),%al
  100fb2:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb5:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fba:	85 c0                	test   %eax,%eax
  100fbc:	74 0c                	je     100fca <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fbe:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fc5:	e8 b0 06 00 00       	call   10167a <pic_enable>
    }
}
  100fca:	c9                   	leave  
  100fcb:	c3                   	ret    

00100fcc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fcc:	55                   	push   %ebp
  100fcd:	89 e5                	mov    %esp,%ebp
  100fcf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd9:	eb 09                	jmp    100fe4 <lpt_putc_sub+0x18>
        delay();
  100fdb:	e8 db fd ff ff       	call   100dbb <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fea:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff8:	84 c0                	test   %al,%al
  100ffa:	78 09                	js     101005 <lpt_putc_sub+0x39>
  100ffc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101003:	7e d6                	jle    100fdb <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101005:	8b 45 08             	mov    0x8(%ebp),%eax
  101008:	0f b6 c0             	movzbl %al,%eax
  10100b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101011:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101014:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101018:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10101c:	ee                   	out    %al,(%dx)
  10101d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101023:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101027:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10102b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102f:	ee                   	out    %al,(%dx)
  101030:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101036:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10103a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10103e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101042:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
  101048:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10104b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104f:	74 0d                	je     10105e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101051:	8b 45 08             	mov    0x8(%ebp),%eax
  101054:	89 04 24             	mov    %eax,(%esp)
  101057:	e8 70 ff ff ff       	call   100fcc <lpt_putc_sub>
  10105c:	eb 24                	jmp    101082 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10105e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101065:	e8 62 ff ff ff       	call   100fcc <lpt_putc_sub>
        lpt_putc_sub(' ');
  10106a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101071:	e8 56 ff ff ff       	call   100fcc <lpt_putc_sub>
        lpt_putc_sub('\b');
  101076:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107d:	e8 4a ff ff ff       	call   100fcc <lpt_putc_sub>
    }
}
  101082:	c9                   	leave  
  101083:	c3                   	ret    

00101084 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101084:	55                   	push   %ebp
  101085:	89 e5                	mov    %esp,%ebp
  101087:	53                   	push   %ebx
  101088:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10108b:	8b 45 08             	mov    0x8(%ebp),%eax
  10108e:	b0 00                	mov    $0x0,%al
  101090:	85 c0                	test   %eax,%eax
  101092:	75 07                	jne    10109b <cga_putc+0x17>
        c |= 0x0700;
  101094:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	0f b6 c0             	movzbl %al,%eax
  1010a1:	83 f8 0a             	cmp    $0xa,%eax
  1010a4:	74 4c                	je     1010f2 <cga_putc+0x6e>
  1010a6:	83 f8 0d             	cmp    $0xd,%eax
  1010a9:	74 57                	je     101102 <cga_putc+0x7e>
  1010ab:	83 f8 08             	cmp    $0x8,%eax
  1010ae:	0f 85 88 00 00 00    	jne    10113c <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bb:	66 85 c0             	test   %ax,%ax
  1010be:	74 30                	je     1010f0 <cga_putc+0x6c>
            crt_pos --;
  1010c0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c7:	83 e8 01             	sub    $0x1,%eax
  1010ca:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d0:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d5:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010dc:	0f b7 d2             	movzwl %dx,%edx
  1010df:	01 d2                	add    %edx,%edx
  1010e1:	01 c2                	add    %eax,%edx
  1010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e6:	b0 00                	mov    $0x0,%al
  1010e8:	83 c8 20             	or     $0x20,%eax
  1010eb:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ee:	eb 72                	jmp    101162 <cga_putc+0xde>
  1010f0:	eb 70                	jmp    101162 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f9:	83 c0 50             	add    $0x50,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101102:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101109:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101110:	0f b7 c1             	movzwl %cx,%eax
  101113:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101119:	c1 e8 10             	shr    $0x10,%eax
  10111c:	89 c2                	mov    %eax,%edx
  10111e:	66 c1 ea 06          	shr    $0x6,%dx
  101122:	89 d0                	mov    %edx,%eax
  101124:	c1 e0 02             	shl    $0x2,%eax
  101127:	01 d0                	add    %edx,%eax
  101129:	c1 e0 04             	shl    $0x4,%eax
  10112c:	29 c1                	sub    %eax,%ecx
  10112e:	89 ca                	mov    %ecx,%edx
  101130:	89 d8                	mov    %ebx,%eax
  101132:	29 d0                	sub    %edx,%eax
  101134:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10113a:	eb 26                	jmp    101162 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101142:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101149:	8d 50 01             	lea    0x1(%eax),%edx
  10114c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101153:	0f b7 c0             	movzwl %ax,%eax
  101156:	01 c0                	add    %eax,%eax
  101158:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10115b:	8b 45 08             	mov    0x8(%ebp),%eax
  10115e:	66 89 02             	mov    %ax,(%edx)
        break;
  101161:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101162:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101169:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116d:	76 5b                	jbe    1011ca <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10116f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101174:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101186:	00 
  101187:	89 54 24 04          	mov    %edx,0x4(%esp)
  10118b:	89 04 24             	mov    %eax,(%esp)
  10118e:	e8 82 21 00 00       	call   103315 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101193:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10119a:	eb 15                	jmp    1011b1 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10119c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a4:	01 d2                	add    %edx,%edx
  1011a6:	01 d0                	add    %edx,%eax
  1011a8:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b1:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b8:	7e e2                	jle    10119c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ba:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c1:	83 e8 50             	sub    $0x50,%eax
  1011c4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ca:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d1:	0f b7 c0             	movzwl %ax,%eax
  1011d4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011dc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011e0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e4:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ec:	66 c1 e8 08          	shr    $0x8,%ax
  1011f0:	0f b6 c0             	movzbl %al,%eax
  1011f3:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011fa:	83 c2 01             	add    $0x1,%edx
  1011fd:	0f b7 d2             	movzwl %dx,%edx
  101200:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101204:	88 45 ed             	mov    %al,-0x13(%ebp)
  101207:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10120b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10120f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101210:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101217:	0f b7 c0             	movzwl %ax,%eax
  10121a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10121e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101222:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101226:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10122a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10122b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101232:	0f b6 c0             	movzbl %al,%eax
  101235:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123c:	83 c2 01             	add    $0x1,%edx
  10123f:	0f b7 d2             	movzwl %dx,%edx
  101242:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101246:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101249:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101251:	ee                   	out    %al,(%dx)
}
  101252:	83 c4 34             	add    $0x34,%esp
  101255:	5b                   	pop    %ebx
  101256:	5d                   	pop    %ebp
  101257:	c3                   	ret    

00101258 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101258:	55                   	push   %ebp
  101259:	89 e5                	mov    %esp,%ebp
  10125b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101265:	eb 09                	jmp    101270 <serial_putc_sub+0x18>
        delay();
  101267:	e8 4f fb ff ff       	call   100dbb <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101270:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101276:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10127a:	89 c2                	mov    %eax,%edx
  10127c:	ec                   	in     (%dx),%al
  10127d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101280:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101284:	0f b6 c0             	movzbl %al,%eax
  101287:	83 e0 20             	and    $0x20,%eax
  10128a:	85 c0                	test   %eax,%eax
  10128c:	75 09                	jne    101297 <serial_putc_sub+0x3f>
  10128e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101295:	7e d0                	jle    101267 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101297:	8b 45 08             	mov    0x8(%ebp),%eax
  10129a:	0f b6 c0             	movzbl %al,%eax
  10129d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a3:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012aa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ae:	ee                   	out    %al,(%dx)
}
  1012af:	c9                   	leave  
  1012b0:	c3                   	ret    

001012b1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b1:	55                   	push   %ebp
  1012b2:	89 e5                	mov    %esp,%ebp
  1012b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012bb:	74 0d                	je     1012ca <serial_putc+0x19>
        serial_putc_sub(c);
  1012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c0:	89 04 24             	mov    %eax,(%esp)
  1012c3:	e8 90 ff ff ff       	call   101258 <serial_putc_sub>
  1012c8:	eb 24                	jmp    1012ee <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012d1:	e8 82 ff ff ff       	call   101258 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012dd:	e8 76 ff ff ff       	call   101258 <serial_putc_sub>
        serial_putc_sub('\b');
  1012e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e9:	e8 6a ff ff ff       	call   101258 <serial_putc_sub>
    }
}
  1012ee:	c9                   	leave  
  1012ef:	c3                   	ret    

001012f0 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f0:	55                   	push   %ebp
  1012f1:	89 e5                	mov    %esp,%ebp
  1012f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f6:	eb 33                	jmp    10132b <cons_intr+0x3b>
        if (c != 0) {
  1012f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012fc:	74 2d                	je     10132b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012fe:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101303:	8d 50 01             	lea    0x1(%eax),%edx
  101306:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10130c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10130f:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101315:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10131f:	75 0a                	jne    10132b <cons_intr+0x3b>
                cons.wpos = 0;
  101321:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101328:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	ff d0                	call   *%eax
  101330:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101333:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101337:	75 bf                	jne    1012f8 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101339:	c9                   	leave  
  10133a:	c3                   	ret    

0010133b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10133b:	55                   	push   %ebp
  10133c:	89 e5                	mov    %esp,%ebp
  10133e:	83 ec 10             	sub    $0x10,%esp
  101341:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101347:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134b:	89 c2                	mov    %eax,%edx
  10134d:	ec                   	in     (%dx),%al
  10134e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101351:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	83 e0 01             	and    $0x1,%eax
  10135b:	85 c0                	test   %eax,%eax
  10135d:	75 07                	jne    101366 <serial_proc_data+0x2b>
        return -1;
  10135f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101364:	eb 2a                	jmp    101390 <serial_proc_data+0x55>
  101366:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10136c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101370:	89 c2                	mov    %eax,%edx
  101372:	ec                   	in     (%dx),%al
  101373:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101376:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10137a:	0f b6 c0             	movzbl %al,%eax
  10137d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101380:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101384:	75 07                	jne    10138d <serial_proc_data+0x52>
        c = '\b';
  101386:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101390:	c9                   	leave  
  101391:	c3                   	ret    

00101392 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101392:	55                   	push   %ebp
  101393:	89 e5                	mov    %esp,%ebp
  101395:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101398:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10139d:	85 c0                	test   %eax,%eax
  10139f:	74 0c                	je     1013ad <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013a1:	c7 04 24 3b 13 10 00 	movl   $0x10133b,(%esp)
  1013a8:	e8 43 ff ff ff       	call   1012f0 <cons_intr>
    }
}
  1013ad:	c9                   	leave  
  1013ae:	c3                   	ret    

001013af <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013af:	55                   	push   %ebp
  1013b0:	89 e5                	mov    %esp,%ebp
  1013b2:	83 ec 38             	sub    $0x38,%esp
  1013b5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013bf:	89 c2                	mov    %eax,%edx
  1013c1:	ec                   	in     (%dx),%al
  1013c2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c9:	0f b6 c0             	movzbl %al,%eax
  1013cc:	83 e0 01             	and    $0x1,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	75 0a                	jne    1013dd <kbd_proc_data+0x2e>
        return -1;
  1013d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d8:	e9 59 01 00 00       	jmp    101536 <kbd_proc_data+0x187>
  1013dd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e7:	89 c2                	mov    %eax,%edx
  1013e9:	ec                   	in     (%dx),%al
  1013ea:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013ed:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013f1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f8:	75 17                	jne    101411 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013fa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ff:	83 c8 40             	or     $0x40,%eax
  101402:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101407:	b8 00 00 00 00       	mov    $0x0,%eax
  10140c:	e9 25 01 00 00       	jmp    101536 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101411:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101415:	84 c0                	test   %al,%al
  101417:	79 47                	jns    101460 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101419:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141e:	83 e0 40             	and    $0x40,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	75 09                	jne    10142e <kbd_proc_data+0x7f>
  101425:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101429:	83 e0 7f             	and    $0x7f,%eax
  10142c:	eb 04                	jmp    101432 <kbd_proc_data+0x83>
  10142e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101432:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101435:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101439:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101440:	83 c8 40             	or     $0x40,%eax
  101443:	0f b6 c0             	movzbl %al,%eax
  101446:	f7 d0                	not    %eax
  101448:	89 c2                	mov    %eax,%edx
  10144a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144f:	21 d0                	and    %edx,%eax
  101451:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101456:	b8 00 00 00 00       	mov    $0x0,%eax
  10145b:	e9 d6 00 00 00       	jmp    101536 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101460:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101465:	83 e0 40             	and    $0x40,%eax
  101468:	85 c0                	test   %eax,%eax
  10146a:	74 11                	je     10147d <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10146c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101470:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101475:	83 e0 bf             	and    $0xffffffbf,%eax
  101478:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101488:	0f b6 d0             	movzbl %al,%edx
  10148b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101490:	09 d0                	or     %edx,%eax
  101492:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a2:	0f b6 d0             	movzbl %al,%edx
  1014a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014aa:	31 d0                	xor    %edx,%eax
  1014ac:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014b1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b6:	83 e0 03             	and    $0x3,%eax
  1014b9:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c4:	01 d0                	add    %edx,%eax
  1014c6:	0f b6 00             	movzbl (%eax),%eax
  1014c9:	0f b6 c0             	movzbl %al,%eax
  1014cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d4:	83 e0 08             	and    $0x8,%eax
  1014d7:	85 c0                	test   %eax,%eax
  1014d9:	74 22                	je     1014fd <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014db:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014df:	7e 0c                	jle    1014ed <kbd_proc_data+0x13e>
  1014e1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e5:	7f 06                	jg     1014ed <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014eb:	eb 10                	jmp    1014fd <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014ed:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014f1:	7e 0a                	jle    1014fd <kbd_proc_data+0x14e>
  1014f3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f7:	7f 04                	jg     1014fd <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101502:	f7 d0                	not    %eax
  101504:	83 e0 06             	and    $0x6,%eax
  101507:	85 c0                	test   %eax,%eax
  101509:	75 28                	jne    101533 <kbd_proc_data+0x184>
  10150b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101512:	75 1f                	jne    101533 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101514:	c7 04 24 91 37 10 00 	movl   $0x103791,(%esp)
  10151b:	e8 f2 ed ff ff       	call   100312 <cprintf>
  101520:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101526:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10152e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101532:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101536:	c9                   	leave  
  101537:	c3                   	ret    

00101538 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101538:	55                   	push   %ebp
  101539:	89 e5                	mov    %esp,%ebp
  10153b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10153e:	c7 04 24 af 13 10 00 	movl   $0x1013af,(%esp)
  101545:	e8 a6 fd ff ff       	call   1012f0 <cons_intr>
}
  10154a:	c9                   	leave  
  10154b:	c3                   	ret    

0010154c <kbd_init>:

static void
kbd_init(void) {
  10154c:	55                   	push   %ebp
  10154d:	89 e5                	mov    %esp,%ebp
  10154f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101552:	e8 e1 ff ff ff       	call   101538 <kbd_intr>
    pic_enable(IRQ_KBD);
  101557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10155e:	e8 17 01 00 00       	call   10167a <pic_enable>
}
  101563:	c9                   	leave  
  101564:	c3                   	ret    

00101565 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101565:	55                   	push   %ebp
  101566:	89 e5                	mov    %esp,%ebp
  101568:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10156b:	e8 93 f8 ff ff       	call   100e03 <cga_init>
    serial_init();
  101570:	e8 74 f9 ff ff       	call   100ee9 <serial_init>
    kbd_init();
  101575:	e8 d2 ff ff ff       	call   10154c <kbd_init>
    if (!serial_exists) {
  10157a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10157f:	85 c0                	test   %eax,%eax
  101581:	75 0c                	jne    10158f <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101583:	c7 04 24 9d 37 10 00 	movl   $0x10379d,(%esp)
  10158a:	e8 83 ed ff ff       	call   100312 <cprintf>
    }
}
  10158f:	c9                   	leave  
  101590:	c3                   	ret    

00101591 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101591:	55                   	push   %ebp
  101592:	89 e5                	mov    %esp,%ebp
  101594:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101597:	8b 45 08             	mov    0x8(%ebp),%eax
  10159a:	89 04 24             	mov    %eax,(%esp)
  10159d:	e8 a3 fa ff ff       	call   101045 <lpt_putc>
    cga_putc(c);
  1015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a5:	89 04 24             	mov    %eax,(%esp)
  1015a8:	e8 d7 fa ff ff       	call   101084 <cga_putc>
    serial_putc(c);
  1015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b0:	89 04 24             	mov    %eax,(%esp)
  1015b3:	e8 f9 fc ff ff       	call   1012b1 <serial_putc>
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c0:	e8 cd fd ff ff       	call   101392 <serial_intr>
    kbd_intr();
  1015c5:	e8 6e ff ff ff       	call   101538 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ca:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d5:	39 c2                	cmp    %eax,%edx
  1015d7:	74 36                	je     10160f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015de:	8d 50 01             	lea    0x1(%eax),%edx
  1015e1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ee:	0f b6 c0             	movzbl %al,%eax
  1015f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015fe:	75 0a                	jne    10160a <cons_getc+0x50>
            cons.rpos = 0;
  101600:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101607:	00 00 00 
        }
        return c;
  10160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160d:	eb 05                	jmp    101614 <cons_getc+0x5a>
    }
    return 0;
  10160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101614:	c9                   	leave  
  101615:	c3                   	ret    

00101616 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101619:	fb                   	sti    
    sti();
}
  10161a:	5d                   	pop    %ebp
  10161b:	c3                   	ret    

0010161c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10161c:	55                   	push   %ebp
  10161d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10161f:	fa                   	cli    
    cli();
}
  101620:	5d                   	pop    %ebp
  101621:	c3                   	ret    

00101622 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101622:	55                   	push   %ebp
  101623:	89 e5                	mov    %esp,%ebp
  101625:	83 ec 14             	sub    $0x14,%esp
  101628:	8b 45 08             	mov    0x8(%ebp),%eax
  10162b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10162f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101633:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101639:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10163e:	85 c0                	test   %eax,%eax
  101640:	74 36                	je     101678 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101642:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101646:	0f b6 c0             	movzbl %al,%eax
  101649:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10164f:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101652:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101656:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10165a:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10165b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165f:	66 c1 e8 08          	shr    $0x8,%ax
  101663:	0f b6 c0             	movzbl %al,%eax
  101666:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10166c:	88 45 f9             	mov    %al,-0x7(%ebp)
  10166f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101673:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101677:	ee                   	out    %al,(%dx)
    }
}
  101678:	c9                   	leave  
  101679:	c3                   	ret    

0010167a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167a:	55                   	push   %ebp
  10167b:	89 e5                	mov    %esp,%ebp
  10167d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101680:	8b 45 08             	mov    0x8(%ebp),%eax
  101683:	ba 01 00 00 00       	mov    $0x1,%edx
  101688:	89 c1                	mov    %eax,%ecx
  10168a:	d3 e2                	shl    %cl,%edx
  10168c:	89 d0                	mov    %edx,%eax
  10168e:	f7 d0                	not    %eax
  101690:	89 c2                	mov    %eax,%edx
  101692:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101699:	21 d0                	and    %edx,%eax
  10169b:	0f b7 c0             	movzwl %ax,%eax
  10169e:	89 04 24             	mov    %eax,(%esp)
  1016a1:	e8 7c ff ff ff       	call   101622 <pic_setmask>
}
  1016a6:	c9                   	leave  
  1016a7:	c3                   	ret    

001016a8 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a8:	55                   	push   %ebp
  1016a9:	89 e5                	mov    %esp,%ebp
  1016ab:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016ae:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016b5:	00 00 00 
  1016b8:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016be:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ca:	ee                   	out    %al,(%dx)
  1016cb:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016d1:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016dd:	ee                   	out    %al,(%dx)
  1016de:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016e4:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
  1016f1:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016f7:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016fb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016ff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101703:	ee                   	out    %al,(%dx)
  101704:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10170a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10170e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101712:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101716:	ee                   	out    %al,(%dx)
  101717:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10171d:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101721:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101725:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101729:	ee                   	out    %al,(%dx)
  10172a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101730:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101734:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101738:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10173c:	ee                   	out    %al,(%dx)
  10173d:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101743:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101747:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10174b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10174f:	ee                   	out    %al,(%dx)
  101750:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101756:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10175a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10175e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101769:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10176d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101771:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10177c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101780:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101784:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10178f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101793:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101797:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a2:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017a6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017aa:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017b5:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017b9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017bd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c2:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c9:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017cd:	74 12                	je     1017e1 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017cf:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d6:	0f b7 c0             	movzwl %ax,%eax
  1017d9:	89 04 24             	mov    %eax,(%esp)
  1017dc:	e8 41 fe ff ff       	call   101622 <pic_setmask>
    }
}
  1017e1:	c9                   	leave  
  1017e2:	c3                   	ret    

001017e3 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017e3:	55                   	push   %ebp
  1017e4:	89 e5                	mov    %esp,%ebp
  1017e6:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017f0:	00 
  1017f1:	c7 04 24 c0 37 10 00 	movl   $0x1037c0,(%esp)
  1017f8:	e8 15 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017fd:	c9                   	leave  
  1017fe:	c3                   	ret    

001017ff <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017ff:	55                   	push   %ebp
  101800:	89 e5                	mov    %esp,%ebp
  101802:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	  extern uintptr_t __vectors[];
	  int i;
	  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
  101805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10180c:	e9 c3 00 00 00       	jmp    1018d4 <idt_init+0xd5>
	      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101814:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10181b:	89 c2                	mov    %eax,%edx
  10181d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101820:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101827:	00 
  101828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182b:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101832:	00 08 00 
  101835:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101838:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10183f:	00 
  101840:	83 e2 e0             	and    $0xffffffe0,%edx
  101843:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101854:	00 
  101855:	83 e2 1f             	and    $0x1f,%edx
  101858:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101862:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101869:	00 
  10186a:	83 e2 f0             	and    $0xfffffff0,%edx
  10186d:	83 ca 0e             	or     $0xe,%edx
  101870:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101881:	00 
  101882:	83 e2 ef             	and    $0xffffffef,%edx
  101885:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101896:	00 
  101897:	83 e2 9f             	and    $0xffffff9f,%edx
  10189a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ab:	00 
  1018ac:	83 ca 80             	or     $0xffffff80,%edx
  1018af:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b9:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018c0:	c1 e8 10             	shr    $0x10,%eax
  1018c3:	89 c2                	mov    %eax,%edx
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018cf:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	  extern uintptr_t __vectors[];
	  int i;
	  for (i=0; i < sizeof(idt)/ sizeof(struct gatedesc); i ++) {
  1018d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018dc:	0f 86 2f ff ff ff    	jbe    101811 <idt_init+0x12>
	      SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	  }
	  SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018e2:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018e7:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018ed:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018f4:	08 00 
  1018f6:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018fd:	83 e0 e0             	and    $0xffffffe0,%eax
  101900:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101905:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190c:	83 e0 1f             	and    $0x1f,%eax
  10190f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101914:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10191b:	83 e0 f0             	and    $0xfffffff0,%eax
  10191e:	83 c8 0e             	or     $0xe,%eax
  101921:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101926:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192d:	83 e0 ef             	and    $0xffffffef,%eax
  101930:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101935:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193c:	83 c8 60             	or     $0x60,%eax
  10193f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101944:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194b:	83 c8 80             	or     $0xffffff80,%eax
  10194e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101953:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101958:	c1 e8 10             	shr    $0x10,%eax
  10195b:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101961:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101968:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10196b:	0f 01 18             	lidtl  (%eax)
	  lidt(&idt_pd);
}
  10196e:	c9                   	leave  
  10196f:	c3                   	ret    

00101970 <trapname>:

static const char *
trapname(int trapno) {
  101970:	55                   	push   %ebp
  101971:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101973:	8b 45 08             	mov    0x8(%ebp),%eax
  101976:	83 f8 13             	cmp    $0x13,%eax
  101979:	77 0c                	ja     101987 <trapname+0x17>
        return excnames[trapno];
  10197b:	8b 45 08             	mov    0x8(%ebp),%eax
  10197e:	8b 04 85 20 3b 10 00 	mov    0x103b20(,%eax,4),%eax
  101985:	eb 18                	jmp    10199f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101987:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10198b:	7e 0d                	jle    10199a <trapname+0x2a>
  10198d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101991:	7f 07                	jg     10199a <trapname+0x2a>
        return "Hardware Interrupt";
  101993:	b8 ca 37 10 00       	mov    $0x1037ca,%eax
  101998:	eb 05                	jmp    10199f <trapname+0x2f>
    }
    return "(unknown trap)";
  10199a:	b8 dd 37 10 00       	mov    $0x1037dd,%eax
}
  10199f:	5d                   	pop    %ebp
  1019a0:	c3                   	ret    

001019a1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019a1:	55                   	push   %ebp
  1019a2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019ab:	66 83 f8 08          	cmp    $0x8,%ax
  1019af:	0f 94 c0             	sete   %al
  1019b2:	0f b6 c0             	movzbl %al,%eax
}
  1019b5:	5d                   	pop    %ebp
  1019b6:	c3                   	ret    

001019b7 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019b7:	55                   	push   %ebp
  1019b8:	89 e5                	mov    %esp,%ebp
  1019ba:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c4:	c7 04 24 1e 38 10 00 	movl   $0x10381e,(%esp)
  1019cb:	e8 42 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	89 04 24             	mov    %eax,(%esp)
  1019d6:	e8 a1 01 00 00       	call   101b7c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019e2:	0f b7 c0             	movzwl %ax,%eax
  1019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e9:	c7 04 24 2f 38 10 00 	movl   $0x10382f,(%esp)
  1019f0:	e8 1d e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019fc:	0f b7 c0             	movzwl %ax,%eax
  1019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a03:	c7 04 24 42 38 10 00 	movl   $0x103842,(%esp)
  101a0a:	e8 03 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a16:	0f b7 c0             	movzwl %ax,%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 55 38 10 00 	movl   $0x103855,(%esp)
  101a24:	e8 e9 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a30:	0f b7 c0             	movzwl %ax,%eax
  101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a37:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  101a3e:	e8 cf e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	8b 40 30             	mov    0x30(%eax),%eax
  101a49:	89 04 24             	mov    %eax,(%esp)
  101a4c:	e8 1f ff ff ff       	call   101970 <trapname>
  101a51:	8b 55 08             	mov    0x8(%ebp),%edx
  101a54:	8b 52 30             	mov    0x30(%edx),%edx
  101a57:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a5f:	c7 04 24 7b 38 10 00 	movl   $0x10387b,(%esp)
  101a66:	e8 a7 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	8b 40 34             	mov    0x34(%eax),%eax
  101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a75:	c7 04 24 8d 38 10 00 	movl   $0x10388d,(%esp)
  101a7c:	e8 91 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	8b 40 38             	mov    0x38(%eax),%eax
  101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8b:	c7 04 24 9c 38 10 00 	movl   $0x10389c,(%esp)
  101a92:	e8 7b e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a97:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a9e:	0f b7 c0             	movzwl %ax,%eax
  101aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa5:	c7 04 24 ab 38 10 00 	movl   $0x1038ab,(%esp)
  101aac:	e8 61 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab4:	8b 40 40             	mov    0x40(%eax),%eax
  101ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abb:	c7 04 24 be 38 10 00 	movl   $0x1038be,(%esp)
  101ac2:	e8 4b e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ac7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ace:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ad5:	eb 3e                	jmp    101b15 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	8b 50 40             	mov    0x40(%eax),%edx
  101add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ae0:	21 d0                	and    %edx,%eax
  101ae2:	85 c0                	test   %eax,%eax
  101ae4:	74 28                	je     101b0e <print_trapframe+0x157>
  101ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae9:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101af0:	85 c0                	test   %eax,%eax
  101af2:	74 1a                	je     101b0e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af7:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 cd 38 10 00 	movl   $0x1038cd,(%esp)
  101b09:	e8 04 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b12:	d1 65 f0             	shll   -0x10(%ebp)
  101b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b18:	83 f8 17             	cmp    $0x17,%eax
  101b1b:	76 ba                	jbe    101ad7 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	8b 40 40             	mov    0x40(%eax),%eax
  101b23:	25 00 30 00 00       	and    $0x3000,%eax
  101b28:	c1 e8 0c             	shr    $0xc,%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 d1 38 10 00 	movl   $0x1038d1,(%esp)
  101b36:	e8 d7 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	89 04 24             	mov    %eax,(%esp)
  101b41:	e8 5b fe ff ff       	call   1019a1 <trap_in_kernel>
  101b46:	85 c0                	test   %eax,%eax
  101b48:	75 30                	jne    101b7a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	8b 40 44             	mov    0x44(%eax),%eax
  101b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b54:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  101b5b:	e8 b2 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b67:	0f b7 c0             	movzwl %ax,%eax
  101b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6e:	c7 04 24 e9 38 10 00 	movl   $0x1038e9,(%esp)
  101b75:	e8 98 e7 ff ff       	call   100312 <cprintf>
    }
}
  101b7a:	c9                   	leave  
  101b7b:	c3                   	ret    

00101b7c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b7c:	55                   	push   %ebp
  101b7d:	89 e5                	mov    %esp,%ebp
  101b7f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	8b 00                	mov    (%eax),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  101b92:	e8 7b e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 40 04             	mov    0x4(%eax),%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 0b 39 10 00 	movl   $0x10390b,(%esp)
  101ba8:	e8 65 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 40 08             	mov    0x8(%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  101bbe:	e8 4f e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 29 39 10 00 	movl   $0x103929,(%esp)
  101bd4:	e8 39 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 10             	mov    0x10(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 38 39 10 00 	movl   $0x103938,(%esp)
  101bea:	e8 23 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 14             	mov    0x14(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 47 39 10 00 	movl   $0x103947,(%esp)
  101c00:	e8 0d e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	8b 40 18             	mov    0x18(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 56 39 10 00 	movl   $0x103956,(%esp)
  101c16:	e8 f7 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 65 39 10 00 	movl   $0x103965,(%esp)
  101c2c:	e8 e1 e6 ff ff       	call   100312 <cprintf>
}
  101c31:	c9                   	leave  
  101c32:	c3                   	ret    

00101c33 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c33:	55                   	push   %ebp
  101c34:	89 e5                	mov    %esp,%ebp
  101c36:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c39:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3c:	8b 40 30             	mov    0x30(%eax),%eax
  101c3f:	83 f8 2f             	cmp    $0x2f,%eax
  101c42:	77 1d                	ja     101c61 <trap_dispatch+0x2e>
  101c44:	83 f8 2e             	cmp    $0x2e,%eax
  101c47:	0f 83 f2 00 00 00    	jae    101d3f <trap_dispatch+0x10c>
  101c4d:	83 f8 21             	cmp    $0x21,%eax
  101c50:	74 73                	je     101cc5 <trap_dispatch+0x92>
  101c52:	83 f8 24             	cmp    $0x24,%eax
  101c55:	74 48                	je     101c9f <trap_dispatch+0x6c>
  101c57:	83 f8 20             	cmp    $0x20,%eax
  101c5a:	74 13                	je     101c6f <trap_dispatch+0x3c>
  101c5c:	e9 a6 00 00 00       	jmp    101d07 <trap_dispatch+0xd4>
  101c61:	83 e8 78             	sub    $0x78,%eax
  101c64:	83 f8 01             	cmp    $0x1,%eax
  101c67:	0f 87 9a 00 00 00    	ja     101d07 <trap_dispatch+0xd4>
  101c6d:	eb 7c                	jmp    101ceb <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101c6f:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c74:	83 c0 01             	add    $0x1,%eax
  101c77:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks == TICK_NUM) {
  101c7c:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c81:	83 f8 64             	cmp    $0x64,%eax
  101c84:	75 14                	jne    101c9a <trap_dispatch+0x67>
        	print_ticks();
  101c86:	e8 58 fb ff ff       	call   1017e3 <print_ticks>
        	ticks = 0;
  101c8b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c92:	00 00 00 
        }
        break;
  101c95:	e9 a6 00 00 00       	jmp    101d40 <trap_dispatch+0x10d>
  101c9a:	e9 a1 00 00 00       	jmp    101d40 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c9f:	e8 16 f9 ff ff       	call   1015ba <cons_getc>
  101ca4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ca7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cab:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101caf:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb7:	c7 04 24 74 39 10 00 	movl   $0x103974,(%esp)
  101cbe:	e8 4f e6 ff ff       	call   100312 <cprintf>
        break;
  101cc3:	eb 7b                	jmp    101d40 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cc5:	e8 f0 f8 ff ff       	call   1015ba <cons_getc>
  101cca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ccd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdd:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  101ce4:	e8 29 e6 ff ff       	call   100312 <cprintf>
        break;
  101ce9:	eb 55                	jmp    101d40 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101ceb:	c7 44 24 08 95 39 10 	movl   $0x103995,0x8(%esp)
  101cf2:	00 
  101cf3:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101cfa:	00 
  101cfb:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101d02:	e8 95 ef ff ff       	call   100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d0e:	0f b7 c0             	movzwl %ax,%eax
  101d11:	83 e0 03             	and    $0x3,%eax
  101d14:	85 c0                	test   %eax,%eax
  101d16:	75 28                	jne    101d40 <trap_dispatch+0x10d>
            print_trapframe(tf);
  101d18:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1b:	89 04 24             	mov    %eax,(%esp)
  101d1e:	e8 94 fc ff ff       	call   1019b7 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d23:	c7 44 24 08 b6 39 10 	movl   $0x1039b6,0x8(%esp)
  101d2a:	00 
  101d2b:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101d32:	00 
  101d33:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101d3a:	e8 5d ef ff ff       	call   100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d3f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d40:	c9                   	leave  
  101d41:	c3                   	ret    

00101d42 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d42:	55                   	push   %ebp
  101d43:	89 e5                	mov    %esp,%ebp
  101d45:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d48:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4b:	89 04 24             	mov    %eax,(%esp)
  101d4e:	e8 e0 fe ff ff       	call   101c33 <trap_dispatch>
}
  101d53:	c9                   	leave  
  101d54:	c3                   	ret    

00101d55 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d55:	1e                   	push   %ds
    pushl %es
  101d56:	06                   	push   %es
    pushl %fs
  101d57:	0f a0                	push   %fs
    pushl %gs
  101d59:	0f a8                	push   %gs
    pushal
  101d5b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d5c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d61:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d63:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d65:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d66:	e8 d7 ff ff ff       	call   101d42 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d6b:	5c                   	pop    %esp

00101d6c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d6c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d6d:	0f a9                	pop    %gs
    popl %fs
  101d6f:	0f a1                	pop    %fs
    popl %es
  101d71:	07                   	pop    %es
    popl %ds
  101d72:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d73:	83 c4 08             	add    $0x8,%esp
    iret
  101d76:	cf                   	iret   

00101d77 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d77:	6a 00                	push   $0x0
  pushl $0
  101d79:	6a 00                	push   $0x0
  jmp __alltraps
  101d7b:	e9 d5 ff ff ff       	jmp    101d55 <__alltraps>

00101d80 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d80:	6a 00                	push   $0x0
  pushl $1
  101d82:	6a 01                	push   $0x1
  jmp __alltraps
  101d84:	e9 cc ff ff ff       	jmp    101d55 <__alltraps>

00101d89 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d89:	6a 00                	push   $0x0
  pushl $2
  101d8b:	6a 02                	push   $0x2
  jmp __alltraps
  101d8d:	e9 c3 ff ff ff       	jmp    101d55 <__alltraps>

00101d92 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d92:	6a 00                	push   $0x0
  pushl $3
  101d94:	6a 03                	push   $0x3
  jmp __alltraps
  101d96:	e9 ba ff ff ff       	jmp    101d55 <__alltraps>

00101d9b <vector4>:
.globl vector4
vector4:
  pushl $0
  101d9b:	6a 00                	push   $0x0
  pushl $4
  101d9d:	6a 04                	push   $0x4
  jmp __alltraps
  101d9f:	e9 b1 ff ff ff       	jmp    101d55 <__alltraps>

00101da4 <vector5>:
.globl vector5
vector5:
  pushl $0
  101da4:	6a 00                	push   $0x0
  pushl $5
  101da6:	6a 05                	push   $0x5
  jmp __alltraps
  101da8:	e9 a8 ff ff ff       	jmp    101d55 <__alltraps>

00101dad <vector6>:
.globl vector6
vector6:
  pushl $0
  101dad:	6a 00                	push   $0x0
  pushl $6
  101daf:	6a 06                	push   $0x6
  jmp __alltraps
  101db1:	e9 9f ff ff ff       	jmp    101d55 <__alltraps>

00101db6 <vector7>:
.globl vector7
vector7:
  pushl $0
  101db6:	6a 00                	push   $0x0
  pushl $7
  101db8:	6a 07                	push   $0x7
  jmp __alltraps
  101dba:	e9 96 ff ff ff       	jmp    101d55 <__alltraps>

00101dbf <vector8>:
.globl vector8
vector8:
  pushl $8
  101dbf:	6a 08                	push   $0x8
  jmp __alltraps
  101dc1:	e9 8f ff ff ff       	jmp    101d55 <__alltraps>

00101dc6 <vector9>:
.globl vector9
vector9:
  pushl $9
  101dc6:	6a 09                	push   $0x9
  jmp __alltraps
  101dc8:	e9 88 ff ff ff       	jmp    101d55 <__alltraps>

00101dcd <vector10>:
.globl vector10
vector10:
  pushl $10
  101dcd:	6a 0a                	push   $0xa
  jmp __alltraps
  101dcf:	e9 81 ff ff ff       	jmp    101d55 <__alltraps>

00101dd4 <vector11>:
.globl vector11
vector11:
  pushl $11
  101dd4:	6a 0b                	push   $0xb
  jmp __alltraps
  101dd6:	e9 7a ff ff ff       	jmp    101d55 <__alltraps>

00101ddb <vector12>:
.globl vector12
vector12:
  pushl $12
  101ddb:	6a 0c                	push   $0xc
  jmp __alltraps
  101ddd:	e9 73 ff ff ff       	jmp    101d55 <__alltraps>

00101de2 <vector13>:
.globl vector13
vector13:
  pushl $13
  101de2:	6a 0d                	push   $0xd
  jmp __alltraps
  101de4:	e9 6c ff ff ff       	jmp    101d55 <__alltraps>

00101de9 <vector14>:
.globl vector14
vector14:
  pushl $14
  101de9:	6a 0e                	push   $0xe
  jmp __alltraps
  101deb:	e9 65 ff ff ff       	jmp    101d55 <__alltraps>

00101df0 <vector15>:
.globl vector15
vector15:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $15
  101df2:	6a 0f                	push   $0xf
  jmp __alltraps
  101df4:	e9 5c ff ff ff       	jmp    101d55 <__alltraps>

00101df9 <vector16>:
.globl vector16
vector16:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $16
  101dfb:	6a 10                	push   $0x10
  jmp __alltraps
  101dfd:	e9 53 ff ff ff       	jmp    101d55 <__alltraps>

00101e02 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e02:	6a 11                	push   $0x11
  jmp __alltraps
  101e04:	e9 4c ff ff ff       	jmp    101d55 <__alltraps>

00101e09 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e09:	6a 00                	push   $0x0
  pushl $18
  101e0b:	6a 12                	push   $0x12
  jmp __alltraps
  101e0d:	e9 43 ff ff ff       	jmp    101d55 <__alltraps>

00101e12 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e12:	6a 00                	push   $0x0
  pushl $19
  101e14:	6a 13                	push   $0x13
  jmp __alltraps
  101e16:	e9 3a ff ff ff       	jmp    101d55 <__alltraps>

00101e1b <vector20>:
.globl vector20
vector20:
  pushl $0
  101e1b:	6a 00                	push   $0x0
  pushl $20
  101e1d:	6a 14                	push   $0x14
  jmp __alltraps
  101e1f:	e9 31 ff ff ff       	jmp    101d55 <__alltraps>

00101e24 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $21
  101e26:	6a 15                	push   $0x15
  jmp __alltraps
  101e28:	e9 28 ff ff ff       	jmp    101d55 <__alltraps>

00101e2d <vector22>:
.globl vector22
vector22:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $22
  101e2f:	6a 16                	push   $0x16
  jmp __alltraps
  101e31:	e9 1f ff ff ff       	jmp    101d55 <__alltraps>

00101e36 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $23
  101e38:	6a 17                	push   $0x17
  jmp __alltraps
  101e3a:	e9 16 ff ff ff       	jmp    101d55 <__alltraps>

00101e3f <vector24>:
.globl vector24
vector24:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $24
  101e41:	6a 18                	push   $0x18
  jmp __alltraps
  101e43:	e9 0d ff ff ff       	jmp    101d55 <__alltraps>

00101e48 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $25
  101e4a:	6a 19                	push   $0x19
  jmp __alltraps
  101e4c:	e9 04 ff ff ff       	jmp    101d55 <__alltraps>

00101e51 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $26
  101e53:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e55:	e9 fb fe ff ff       	jmp    101d55 <__alltraps>

00101e5a <vector27>:
.globl vector27
vector27:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $27
  101e5c:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e5e:	e9 f2 fe ff ff       	jmp    101d55 <__alltraps>

00101e63 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $28
  101e65:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e67:	e9 e9 fe ff ff       	jmp    101d55 <__alltraps>

00101e6c <vector29>:
.globl vector29
vector29:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $29
  101e6e:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e70:	e9 e0 fe ff ff       	jmp    101d55 <__alltraps>

00101e75 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $30
  101e77:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e79:	e9 d7 fe ff ff       	jmp    101d55 <__alltraps>

00101e7e <vector31>:
.globl vector31
vector31:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $31
  101e80:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e82:	e9 ce fe ff ff       	jmp    101d55 <__alltraps>

00101e87 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $32
  101e89:	6a 20                	push   $0x20
  jmp __alltraps
  101e8b:	e9 c5 fe ff ff       	jmp    101d55 <__alltraps>

00101e90 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $33
  101e92:	6a 21                	push   $0x21
  jmp __alltraps
  101e94:	e9 bc fe ff ff       	jmp    101d55 <__alltraps>

00101e99 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $34
  101e9b:	6a 22                	push   $0x22
  jmp __alltraps
  101e9d:	e9 b3 fe ff ff       	jmp    101d55 <__alltraps>

00101ea2 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $35
  101ea4:	6a 23                	push   $0x23
  jmp __alltraps
  101ea6:	e9 aa fe ff ff       	jmp    101d55 <__alltraps>

00101eab <vector36>:
.globl vector36
vector36:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $36
  101ead:	6a 24                	push   $0x24
  jmp __alltraps
  101eaf:	e9 a1 fe ff ff       	jmp    101d55 <__alltraps>

00101eb4 <vector37>:
.globl vector37
vector37:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $37
  101eb6:	6a 25                	push   $0x25
  jmp __alltraps
  101eb8:	e9 98 fe ff ff       	jmp    101d55 <__alltraps>

00101ebd <vector38>:
.globl vector38
vector38:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $38
  101ebf:	6a 26                	push   $0x26
  jmp __alltraps
  101ec1:	e9 8f fe ff ff       	jmp    101d55 <__alltraps>

00101ec6 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $39
  101ec8:	6a 27                	push   $0x27
  jmp __alltraps
  101eca:	e9 86 fe ff ff       	jmp    101d55 <__alltraps>

00101ecf <vector40>:
.globl vector40
vector40:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $40
  101ed1:	6a 28                	push   $0x28
  jmp __alltraps
  101ed3:	e9 7d fe ff ff       	jmp    101d55 <__alltraps>

00101ed8 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $41
  101eda:	6a 29                	push   $0x29
  jmp __alltraps
  101edc:	e9 74 fe ff ff       	jmp    101d55 <__alltraps>

00101ee1 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $42
  101ee3:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ee5:	e9 6b fe ff ff       	jmp    101d55 <__alltraps>

00101eea <vector43>:
.globl vector43
vector43:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $43
  101eec:	6a 2b                	push   $0x2b
  jmp __alltraps
  101eee:	e9 62 fe ff ff       	jmp    101d55 <__alltraps>

00101ef3 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $44
  101ef5:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ef7:	e9 59 fe ff ff       	jmp    101d55 <__alltraps>

00101efc <vector45>:
.globl vector45
vector45:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $45
  101efe:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f00:	e9 50 fe ff ff       	jmp    101d55 <__alltraps>

00101f05 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $46
  101f07:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f09:	e9 47 fe ff ff       	jmp    101d55 <__alltraps>

00101f0e <vector47>:
.globl vector47
vector47:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $47
  101f10:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f12:	e9 3e fe ff ff       	jmp    101d55 <__alltraps>

00101f17 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $48
  101f19:	6a 30                	push   $0x30
  jmp __alltraps
  101f1b:	e9 35 fe ff ff       	jmp    101d55 <__alltraps>

00101f20 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $49
  101f22:	6a 31                	push   $0x31
  jmp __alltraps
  101f24:	e9 2c fe ff ff       	jmp    101d55 <__alltraps>

00101f29 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $50
  101f2b:	6a 32                	push   $0x32
  jmp __alltraps
  101f2d:	e9 23 fe ff ff       	jmp    101d55 <__alltraps>

00101f32 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $51
  101f34:	6a 33                	push   $0x33
  jmp __alltraps
  101f36:	e9 1a fe ff ff       	jmp    101d55 <__alltraps>

00101f3b <vector52>:
.globl vector52
vector52:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $52
  101f3d:	6a 34                	push   $0x34
  jmp __alltraps
  101f3f:	e9 11 fe ff ff       	jmp    101d55 <__alltraps>

00101f44 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $53
  101f46:	6a 35                	push   $0x35
  jmp __alltraps
  101f48:	e9 08 fe ff ff       	jmp    101d55 <__alltraps>

00101f4d <vector54>:
.globl vector54
vector54:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $54
  101f4f:	6a 36                	push   $0x36
  jmp __alltraps
  101f51:	e9 ff fd ff ff       	jmp    101d55 <__alltraps>

00101f56 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $55
  101f58:	6a 37                	push   $0x37
  jmp __alltraps
  101f5a:	e9 f6 fd ff ff       	jmp    101d55 <__alltraps>

00101f5f <vector56>:
.globl vector56
vector56:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $56
  101f61:	6a 38                	push   $0x38
  jmp __alltraps
  101f63:	e9 ed fd ff ff       	jmp    101d55 <__alltraps>

00101f68 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $57
  101f6a:	6a 39                	push   $0x39
  jmp __alltraps
  101f6c:	e9 e4 fd ff ff       	jmp    101d55 <__alltraps>

00101f71 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $58
  101f73:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f75:	e9 db fd ff ff       	jmp    101d55 <__alltraps>

00101f7a <vector59>:
.globl vector59
vector59:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $59
  101f7c:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f7e:	e9 d2 fd ff ff       	jmp    101d55 <__alltraps>

00101f83 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $60
  101f85:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f87:	e9 c9 fd ff ff       	jmp    101d55 <__alltraps>

00101f8c <vector61>:
.globl vector61
vector61:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $61
  101f8e:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f90:	e9 c0 fd ff ff       	jmp    101d55 <__alltraps>

00101f95 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $62
  101f97:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f99:	e9 b7 fd ff ff       	jmp    101d55 <__alltraps>

00101f9e <vector63>:
.globl vector63
vector63:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $63
  101fa0:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fa2:	e9 ae fd ff ff       	jmp    101d55 <__alltraps>

00101fa7 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $64
  101fa9:	6a 40                	push   $0x40
  jmp __alltraps
  101fab:	e9 a5 fd ff ff       	jmp    101d55 <__alltraps>

00101fb0 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $65
  101fb2:	6a 41                	push   $0x41
  jmp __alltraps
  101fb4:	e9 9c fd ff ff       	jmp    101d55 <__alltraps>

00101fb9 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $66
  101fbb:	6a 42                	push   $0x42
  jmp __alltraps
  101fbd:	e9 93 fd ff ff       	jmp    101d55 <__alltraps>

00101fc2 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $67
  101fc4:	6a 43                	push   $0x43
  jmp __alltraps
  101fc6:	e9 8a fd ff ff       	jmp    101d55 <__alltraps>

00101fcb <vector68>:
.globl vector68
vector68:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $68
  101fcd:	6a 44                	push   $0x44
  jmp __alltraps
  101fcf:	e9 81 fd ff ff       	jmp    101d55 <__alltraps>

00101fd4 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $69
  101fd6:	6a 45                	push   $0x45
  jmp __alltraps
  101fd8:	e9 78 fd ff ff       	jmp    101d55 <__alltraps>

00101fdd <vector70>:
.globl vector70
vector70:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $70
  101fdf:	6a 46                	push   $0x46
  jmp __alltraps
  101fe1:	e9 6f fd ff ff       	jmp    101d55 <__alltraps>

00101fe6 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $71
  101fe8:	6a 47                	push   $0x47
  jmp __alltraps
  101fea:	e9 66 fd ff ff       	jmp    101d55 <__alltraps>

00101fef <vector72>:
.globl vector72
vector72:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $72
  101ff1:	6a 48                	push   $0x48
  jmp __alltraps
  101ff3:	e9 5d fd ff ff       	jmp    101d55 <__alltraps>

00101ff8 <vector73>:
.globl vector73
vector73:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $73
  101ffa:	6a 49                	push   $0x49
  jmp __alltraps
  101ffc:	e9 54 fd ff ff       	jmp    101d55 <__alltraps>

00102001 <vector74>:
.globl vector74
vector74:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $74
  102003:	6a 4a                	push   $0x4a
  jmp __alltraps
  102005:	e9 4b fd ff ff       	jmp    101d55 <__alltraps>

0010200a <vector75>:
.globl vector75
vector75:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $75
  10200c:	6a 4b                	push   $0x4b
  jmp __alltraps
  10200e:	e9 42 fd ff ff       	jmp    101d55 <__alltraps>

00102013 <vector76>:
.globl vector76
vector76:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $76
  102015:	6a 4c                	push   $0x4c
  jmp __alltraps
  102017:	e9 39 fd ff ff       	jmp    101d55 <__alltraps>

0010201c <vector77>:
.globl vector77
vector77:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $77
  10201e:	6a 4d                	push   $0x4d
  jmp __alltraps
  102020:	e9 30 fd ff ff       	jmp    101d55 <__alltraps>

00102025 <vector78>:
.globl vector78
vector78:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $78
  102027:	6a 4e                	push   $0x4e
  jmp __alltraps
  102029:	e9 27 fd ff ff       	jmp    101d55 <__alltraps>

0010202e <vector79>:
.globl vector79
vector79:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $79
  102030:	6a 4f                	push   $0x4f
  jmp __alltraps
  102032:	e9 1e fd ff ff       	jmp    101d55 <__alltraps>

00102037 <vector80>:
.globl vector80
vector80:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $80
  102039:	6a 50                	push   $0x50
  jmp __alltraps
  10203b:	e9 15 fd ff ff       	jmp    101d55 <__alltraps>

00102040 <vector81>:
.globl vector81
vector81:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $81
  102042:	6a 51                	push   $0x51
  jmp __alltraps
  102044:	e9 0c fd ff ff       	jmp    101d55 <__alltraps>

00102049 <vector82>:
.globl vector82
vector82:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $82
  10204b:	6a 52                	push   $0x52
  jmp __alltraps
  10204d:	e9 03 fd ff ff       	jmp    101d55 <__alltraps>

00102052 <vector83>:
.globl vector83
vector83:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $83
  102054:	6a 53                	push   $0x53
  jmp __alltraps
  102056:	e9 fa fc ff ff       	jmp    101d55 <__alltraps>

0010205b <vector84>:
.globl vector84
vector84:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $84
  10205d:	6a 54                	push   $0x54
  jmp __alltraps
  10205f:	e9 f1 fc ff ff       	jmp    101d55 <__alltraps>

00102064 <vector85>:
.globl vector85
vector85:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $85
  102066:	6a 55                	push   $0x55
  jmp __alltraps
  102068:	e9 e8 fc ff ff       	jmp    101d55 <__alltraps>

0010206d <vector86>:
.globl vector86
vector86:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $86
  10206f:	6a 56                	push   $0x56
  jmp __alltraps
  102071:	e9 df fc ff ff       	jmp    101d55 <__alltraps>

00102076 <vector87>:
.globl vector87
vector87:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $87
  102078:	6a 57                	push   $0x57
  jmp __alltraps
  10207a:	e9 d6 fc ff ff       	jmp    101d55 <__alltraps>

0010207f <vector88>:
.globl vector88
vector88:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $88
  102081:	6a 58                	push   $0x58
  jmp __alltraps
  102083:	e9 cd fc ff ff       	jmp    101d55 <__alltraps>

00102088 <vector89>:
.globl vector89
vector89:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $89
  10208a:	6a 59                	push   $0x59
  jmp __alltraps
  10208c:	e9 c4 fc ff ff       	jmp    101d55 <__alltraps>

00102091 <vector90>:
.globl vector90
vector90:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $90
  102093:	6a 5a                	push   $0x5a
  jmp __alltraps
  102095:	e9 bb fc ff ff       	jmp    101d55 <__alltraps>

0010209a <vector91>:
.globl vector91
vector91:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $91
  10209c:	6a 5b                	push   $0x5b
  jmp __alltraps
  10209e:	e9 b2 fc ff ff       	jmp    101d55 <__alltraps>

001020a3 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $92
  1020a5:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020a7:	e9 a9 fc ff ff       	jmp    101d55 <__alltraps>

001020ac <vector93>:
.globl vector93
vector93:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $93
  1020ae:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020b0:	e9 a0 fc ff ff       	jmp    101d55 <__alltraps>

001020b5 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $94
  1020b7:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020b9:	e9 97 fc ff ff       	jmp    101d55 <__alltraps>

001020be <vector95>:
.globl vector95
vector95:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $95
  1020c0:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020c2:	e9 8e fc ff ff       	jmp    101d55 <__alltraps>

001020c7 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $96
  1020c9:	6a 60                	push   $0x60
  jmp __alltraps
  1020cb:	e9 85 fc ff ff       	jmp    101d55 <__alltraps>

001020d0 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $97
  1020d2:	6a 61                	push   $0x61
  jmp __alltraps
  1020d4:	e9 7c fc ff ff       	jmp    101d55 <__alltraps>

001020d9 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $98
  1020db:	6a 62                	push   $0x62
  jmp __alltraps
  1020dd:	e9 73 fc ff ff       	jmp    101d55 <__alltraps>

001020e2 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $99
  1020e4:	6a 63                	push   $0x63
  jmp __alltraps
  1020e6:	e9 6a fc ff ff       	jmp    101d55 <__alltraps>

001020eb <vector100>:
.globl vector100
vector100:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $100
  1020ed:	6a 64                	push   $0x64
  jmp __alltraps
  1020ef:	e9 61 fc ff ff       	jmp    101d55 <__alltraps>

001020f4 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $101
  1020f6:	6a 65                	push   $0x65
  jmp __alltraps
  1020f8:	e9 58 fc ff ff       	jmp    101d55 <__alltraps>

001020fd <vector102>:
.globl vector102
vector102:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $102
  1020ff:	6a 66                	push   $0x66
  jmp __alltraps
  102101:	e9 4f fc ff ff       	jmp    101d55 <__alltraps>

00102106 <vector103>:
.globl vector103
vector103:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $103
  102108:	6a 67                	push   $0x67
  jmp __alltraps
  10210a:	e9 46 fc ff ff       	jmp    101d55 <__alltraps>

0010210f <vector104>:
.globl vector104
vector104:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $104
  102111:	6a 68                	push   $0x68
  jmp __alltraps
  102113:	e9 3d fc ff ff       	jmp    101d55 <__alltraps>

00102118 <vector105>:
.globl vector105
vector105:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $105
  10211a:	6a 69                	push   $0x69
  jmp __alltraps
  10211c:	e9 34 fc ff ff       	jmp    101d55 <__alltraps>

00102121 <vector106>:
.globl vector106
vector106:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $106
  102123:	6a 6a                	push   $0x6a
  jmp __alltraps
  102125:	e9 2b fc ff ff       	jmp    101d55 <__alltraps>

0010212a <vector107>:
.globl vector107
vector107:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $107
  10212c:	6a 6b                	push   $0x6b
  jmp __alltraps
  10212e:	e9 22 fc ff ff       	jmp    101d55 <__alltraps>

00102133 <vector108>:
.globl vector108
vector108:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $108
  102135:	6a 6c                	push   $0x6c
  jmp __alltraps
  102137:	e9 19 fc ff ff       	jmp    101d55 <__alltraps>

0010213c <vector109>:
.globl vector109
vector109:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $109
  10213e:	6a 6d                	push   $0x6d
  jmp __alltraps
  102140:	e9 10 fc ff ff       	jmp    101d55 <__alltraps>

00102145 <vector110>:
.globl vector110
vector110:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $110
  102147:	6a 6e                	push   $0x6e
  jmp __alltraps
  102149:	e9 07 fc ff ff       	jmp    101d55 <__alltraps>

0010214e <vector111>:
.globl vector111
vector111:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $111
  102150:	6a 6f                	push   $0x6f
  jmp __alltraps
  102152:	e9 fe fb ff ff       	jmp    101d55 <__alltraps>

00102157 <vector112>:
.globl vector112
vector112:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $112
  102159:	6a 70                	push   $0x70
  jmp __alltraps
  10215b:	e9 f5 fb ff ff       	jmp    101d55 <__alltraps>

00102160 <vector113>:
.globl vector113
vector113:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $113
  102162:	6a 71                	push   $0x71
  jmp __alltraps
  102164:	e9 ec fb ff ff       	jmp    101d55 <__alltraps>

00102169 <vector114>:
.globl vector114
vector114:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $114
  10216b:	6a 72                	push   $0x72
  jmp __alltraps
  10216d:	e9 e3 fb ff ff       	jmp    101d55 <__alltraps>

00102172 <vector115>:
.globl vector115
vector115:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $115
  102174:	6a 73                	push   $0x73
  jmp __alltraps
  102176:	e9 da fb ff ff       	jmp    101d55 <__alltraps>

0010217b <vector116>:
.globl vector116
vector116:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $116
  10217d:	6a 74                	push   $0x74
  jmp __alltraps
  10217f:	e9 d1 fb ff ff       	jmp    101d55 <__alltraps>

00102184 <vector117>:
.globl vector117
vector117:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $117
  102186:	6a 75                	push   $0x75
  jmp __alltraps
  102188:	e9 c8 fb ff ff       	jmp    101d55 <__alltraps>

0010218d <vector118>:
.globl vector118
vector118:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $118
  10218f:	6a 76                	push   $0x76
  jmp __alltraps
  102191:	e9 bf fb ff ff       	jmp    101d55 <__alltraps>

00102196 <vector119>:
.globl vector119
vector119:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $119
  102198:	6a 77                	push   $0x77
  jmp __alltraps
  10219a:	e9 b6 fb ff ff       	jmp    101d55 <__alltraps>

0010219f <vector120>:
.globl vector120
vector120:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $120
  1021a1:	6a 78                	push   $0x78
  jmp __alltraps
  1021a3:	e9 ad fb ff ff       	jmp    101d55 <__alltraps>

001021a8 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $121
  1021aa:	6a 79                	push   $0x79
  jmp __alltraps
  1021ac:	e9 a4 fb ff ff       	jmp    101d55 <__alltraps>

001021b1 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $122
  1021b3:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021b5:	e9 9b fb ff ff       	jmp    101d55 <__alltraps>

001021ba <vector123>:
.globl vector123
vector123:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $123
  1021bc:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021be:	e9 92 fb ff ff       	jmp    101d55 <__alltraps>

001021c3 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $124
  1021c5:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021c7:	e9 89 fb ff ff       	jmp    101d55 <__alltraps>

001021cc <vector125>:
.globl vector125
vector125:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $125
  1021ce:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021d0:	e9 80 fb ff ff       	jmp    101d55 <__alltraps>

001021d5 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $126
  1021d7:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021d9:	e9 77 fb ff ff       	jmp    101d55 <__alltraps>

001021de <vector127>:
.globl vector127
vector127:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $127
  1021e0:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021e2:	e9 6e fb ff ff       	jmp    101d55 <__alltraps>

001021e7 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $128
  1021e9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021ee:	e9 62 fb ff ff       	jmp    101d55 <__alltraps>

001021f3 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $129
  1021f5:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021fa:	e9 56 fb ff ff       	jmp    101d55 <__alltraps>

001021ff <vector130>:
.globl vector130
vector130:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $130
  102201:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102206:	e9 4a fb ff ff       	jmp    101d55 <__alltraps>

0010220b <vector131>:
.globl vector131
vector131:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $131
  10220d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102212:	e9 3e fb ff ff       	jmp    101d55 <__alltraps>

00102217 <vector132>:
.globl vector132
vector132:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $132
  102219:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10221e:	e9 32 fb ff ff       	jmp    101d55 <__alltraps>

00102223 <vector133>:
.globl vector133
vector133:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $133
  102225:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10222a:	e9 26 fb ff ff       	jmp    101d55 <__alltraps>

0010222f <vector134>:
.globl vector134
vector134:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $134
  102231:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102236:	e9 1a fb ff ff       	jmp    101d55 <__alltraps>

0010223b <vector135>:
.globl vector135
vector135:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $135
  10223d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102242:	e9 0e fb ff ff       	jmp    101d55 <__alltraps>

00102247 <vector136>:
.globl vector136
vector136:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $136
  102249:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10224e:	e9 02 fb ff ff       	jmp    101d55 <__alltraps>

00102253 <vector137>:
.globl vector137
vector137:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $137
  102255:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10225a:	e9 f6 fa ff ff       	jmp    101d55 <__alltraps>

0010225f <vector138>:
.globl vector138
vector138:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $138
  102261:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102266:	e9 ea fa ff ff       	jmp    101d55 <__alltraps>

0010226b <vector139>:
.globl vector139
vector139:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $139
  10226d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102272:	e9 de fa ff ff       	jmp    101d55 <__alltraps>

00102277 <vector140>:
.globl vector140
vector140:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $140
  102279:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10227e:	e9 d2 fa ff ff       	jmp    101d55 <__alltraps>

00102283 <vector141>:
.globl vector141
vector141:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $141
  102285:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10228a:	e9 c6 fa ff ff       	jmp    101d55 <__alltraps>

0010228f <vector142>:
.globl vector142
vector142:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $142
  102291:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102296:	e9 ba fa ff ff       	jmp    101d55 <__alltraps>

0010229b <vector143>:
.globl vector143
vector143:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $143
  10229d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022a2:	e9 ae fa ff ff       	jmp    101d55 <__alltraps>

001022a7 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $144
  1022a9:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022ae:	e9 a2 fa ff ff       	jmp    101d55 <__alltraps>

001022b3 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $145
  1022b5:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022ba:	e9 96 fa ff ff       	jmp    101d55 <__alltraps>

001022bf <vector146>:
.globl vector146
vector146:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $146
  1022c1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022c6:	e9 8a fa ff ff       	jmp    101d55 <__alltraps>

001022cb <vector147>:
.globl vector147
vector147:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $147
  1022cd:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022d2:	e9 7e fa ff ff       	jmp    101d55 <__alltraps>

001022d7 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $148
  1022d9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022de:	e9 72 fa ff ff       	jmp    101d55 <__alltraps>

001022e3 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $149
  1022e5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022ea:	e9 66 fa ff ff       	jmp    101d55 <__alltraps>

001022ef <vector150>:
.globl vector150
vector150:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $150
  1022f1:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022f6:	e9 5a fa ff ff       	jmp    101d55 <__alltraps>

001022fb <vector151>:
.globl vector151
vector151:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $151
  1022fd:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102302:	e9 4e fa ff ff       	jmp    101d55 <__alltraps>

00102307 <vector152>:
.globl vector152
vector152:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $152
  102309:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10230e:	e9 42 fa ff ff       	jmp    101d55 <__alltraps>

00102313 <vector153>:
.globl vector153
vector153:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $153
  102315:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10231a:	e9 36 fa ff ff       	jmp    101d55 <__alltraps>

0010231f <vector154>:
.globl vector154
vector154:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $154
  102321:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102326:	e9 2a fa ff ff       	jmp    101d55 <__alltraps>

0010232b <vector155>:
.globl vector155
vector155:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $155
  10232d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102332:	e9 1e fa ff ff       	jmp    101d55 <__alltraps>

00102337 <vector156>:
.globl vector156
vector156:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $156
  102339:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10233e:	e9 12 fa ff ff       	jmp    101d55 <__alltraps>

00102343 <vector157>:
.globl vector157
vector157:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $157
  102345:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10234a:	e9 06 fa ff ff       	jmp    101d55 <__alltraps>

0010234f <vector158>:
.globl vector158
vector158:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $158
  102351:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102356:	e9 fa f9 ff ff       	jmp    101d55 <__alltraps>

0010235b <vector159>:
.globl vector159
vector159:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $159
  10235d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102362:	e9 ee f9 ff ff       	jmp    101d55 <__alltraps>

00102367 <vector160>:
.globl vector160
vector160:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $160
  102369:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10236e:	e9 e2 f9 ff ff       	jmp    101d55 <__alltraps>

00102373 <vector161>:
.globl vector161
vector161:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $161
  102375:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10237a:	e9 d6 f9 ff ff       	jmp    101d55 <__alltraps>

0010237f <vector162>:
.globl vector162
vector162:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $162
  102381:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102386:	e9 ca f9 ff ff       	jmp    101d55 <__alltraps>

0010238b <vector163>:
.globl vector163
vector163:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $163
  10238d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102392:	e9 be f9 ff ff       	jmp    101d55 <__alltraps>

00102397 <vector164>:
.globl vector164
vector164:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $164
  102399:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10239e:	e9 b2 f9 ff ff       	jmp    101d55 <__alltraps>

001023a3 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $165
  1023a5:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023aa:	e9 a6 f9 ff ff       	jmp    101d55 <__alltraps>

001023af <vector166>:
.globl vector166
vector166:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $166
  1023b1:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023b6:	e9 9a f9 ff ff       	jmp    101d55 <__alltraps>

001023bb <vector167>:
.globl vector167
vector167:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $167
  1023bd:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023c2:	e9 8e f9 ff ff       	jmp    101d55 <__alltraps>

001023c7 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $168
  1023c9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023ce:	e9 82 f9 ff ff       	jmp    101d55 <__alltraps>

001023d3 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $169
  1023d5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023da:	e9 76 f9 ff ff       	jmp    101d55 <__alltraps>

001023df <vector170>:
.globl vector170
vector170:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $170
  1023e1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023e6:	e9 6a f9 ff ff       	jmp    101d55 <__alltraps>

001023eb <vector171>:
.globl vector171
vector171:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $171
  1023ed:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023f2:	e9 5e f9 ff ff       	jmp    101d55 <__alltraps>

001023f7 <vector172>:
.globl vector172
vector172:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $172
  1023f9:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023fe:	e9 52 f9 ff ff       	jmp    101d55 <__alltraps>

00102403 <vector173>:
.globl vector173
vector173:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $173
  102405:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10240a:	e9 46 f9 ff ff       	jmp    101d55 <__alltraps>

0010240f <vector174>:
.globl vector174
vector174:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $174
  102411:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102416:	e9 3a f9 ff ff       	jmp    101d55 <__alltraps>

0010241b <vector175>:
.globl vector175
vector175:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $175
  10241d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102422:	e9 2e f9 ff ff       	jmp    101d55 <__alltraps>

00102427 <vector176>:
.globl vector176
vector176:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $176
  102429:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10242e:	e9 22 f9 ff ff       	jmp    101d55 <__alltraps>

00102433 <vector177>:
.globl vector177
vector177:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $177
  102435:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10243a:	e9 16 f9 ff ff       	jmp    101d55 <__alltraps>

0010243f <vector178>:
.globl vector178
vector178:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $178
  102441:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102446:	e9 0a f9 ff ff       	jmp    101d55 <__alltraps>

0010244b <vector179>:
.globl vector179
vector179:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $179
  10244d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102452:	e9 fe f8 ff ff       	jmp    101d55 <__alltraps>

00102457 <vector180>:
.globl vector180
vector180:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $180
  102459:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10245e:	e9 f2 f8 ff ff       	jmp    101d55 <__alltraps>

00102463 <vector181>:
.globl vector181
vector181:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $181
  102465:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10246a:	e9 e6 f8 ff ff       	jmp    101d55 <__alltraps>

0010246f <vector182>:
.globl vector182
vector182:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $182
  102471:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102476:	e9 da f8 ff ff       	jmp    101d55 <__alltraps>

0010247b <vector183>:
.globl vector183
vector183:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $183
  10247d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102482:	e9 ce f8 ff ff       	jmp    101d55 <__alltraps>

00102487 <vector184>:
.globl vector184
vector184:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $184
  102489:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10248e:	e9 c2 f8 ff ff       	jmp    101d55 <__alltraps>

00102493 <vector185>:
.globl vector185
vector185:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $185
  102495:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10249a:	e9 b6 f8 ff ff       	jmp    101d55 <__alltraps>

0010249f <vector186>:
.globl vector186
vector186:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $186
  1024a1:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024a6:	e9 aa f8 ff ff       	jmp    101d55 <__alltraps>

001024ab <vector187>:
.globl vector187
vector187:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $187
  1024ad:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024b2:	e9 9e f8 ff ff       	jmp    101d55 <__alltraps>

001024b7 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $188
  1024b9:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024be:	e9 92 f8 ff ff       	jmp    101d55 <__alltraps>

001024c3 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $189
  1024c5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024ca:	e9 86 f8 ff ff       	jmp    101d55 <__alltraps>

001024cf <vector190>:
.globl vector190
vector190:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $190
  1024d1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024d6:	e9 7a f8 ff ff       	jmp    101d55 <__alltraps>

001024db <vector191>:
.globl vector191
vector191:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $191
  1024dd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024e2:	e9 6e f8 ff ff       	jmp    101d55 <__alltraps>

001024e7 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $192
  1024e9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024ee:	e9 62 f8 ff ff       	jmp    101d55 <__alltraps>

001024f3 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $193
  1024f5:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024fa:	e9 56 f8 ff ff       	jmp    101d55 <__alltraps>

001024ff <vector194>:
.globl vector194
vector194:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $194
  102501:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102506:	e9 4a f8 ff ff       	jmp    101d55 <__alltraps>

0010250b <vector195>:
.globl vector195
vector195:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $195
  10250d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102512:	e9 3e f8 ff ff       	jmp    101d55 <__alltraps>

00102517 <vector196>:
.globl vector196
vector196:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $196
  102519:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10251e:	e9 32 f8 ff ff       	jmp    101d55 <__alltraps>

00102523 <vector197>:
.globl vector197
vector197:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $197
  102525:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10252a:	e9 26 f8 ff ff       	jmp    101d55 <__alltraps>

0010252f <vector198>:
.globl vector198
vector198:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $198
  102531:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102536:	e9 1a f8 ff ff       	jmp    101d55 <__alltraps>

0010253b <vector199>:
.globl vector199
vector199:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $199
  10253d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102542:	e9 0e f8 ff ff       	jmp    101d55 <__alltraps>

00102547 <vector200>:
.globl vector200
vector200:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $200
  102549:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10254e:	e9 02 f8 ff ff       	jmp    101d55 <__alltraps>

00102553 <vector201>:
.globl vector201
vector201:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $201
  102555:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10255a:	e9 f6 f7 ff ff       	jmp    101d55 <__alltraps>

0010255f <vector202>:
.globl vector202
vector202:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $202
  102561:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102566:	e9 ea f7 ff ff       	jmp    101d55 <__alltraps>

0010256b <vector203>:
.globl vector203
vector203:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $203
  10256d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102572:	e9 de f7 ff ff       	jmp    101d55 <__alltraps>

00102577 <vector204>:
.globl vector204
vector204:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $204
  102579:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10257e:	e9 d2 f7 ff ff       	jmp    101d55 <__alltraps>

00102583 <vector205>:
.globl vector205
vector205:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $205
  102585:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10258a:	e9 c6 f7 ff ff       	jmp    101d55 <__alltraps>

0010258f <vector206>:
.globl vector206
vector206:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $206
  102591:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102596:	e9 ba f7 ff ff       	jmp    101d55 <__alltraps>

0010259b <vector207>:
.globl vector207
vector207:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $207
  10259d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025a2:	e9 ae f7 ff ff       	jmp    101d55 <__alltraps>

001025a7 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $208
  1025a9:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025ae:	e9 a2 f7 ff ff       	jmp    101d55 <__alltraps>

001025b3 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $209
  1025b5:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025ba:	e9 96 f7 ff ff       	jmp    101d55 <__alltraps>

001025bf <vector210>:
.globl vector210
vector210:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $210
  1025c1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025c6:	e9 8a f7 ff ff       	jmp    101d55 <__alltraps>

001025cb <vector211>:
.globl vector211
vector211:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $211
  1025cd:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025d2:	e9 7e f7 ff ff       	jmp    101d55 <__alltraps>

001025d7 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $212
  1025d9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025de:	e9 72 f7 ff ff       	jmp    101d55 <__alltraps>

001025e3 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $213
  1025e5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025ea:	e9 66 f7 ff ff       	jmp    101d55 <__alltraps>

001025ef <vector214>:
.globl vector214
vector214:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $214
  1025f1:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025f6:	e9 5a f7 ff ff       	jmp    101d55 <__alltraps>

001025fb <vector215>:
.globl vector215
vector215:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $215
  1025fd:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102602:	e9 4e f7 ff ff       	jmp    101d55 <__alltraps>

00102607 <vector216>:
.globl vector216
vector216:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $216
  102609:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10260e:	e9 42 f7 ff ff       	jmp    101d55 <__alltraps>

00102613 <vector217>:
.globl vector217
vector217:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $217
  102615:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10261a:	e9 36 f7 ff ff       	jmp    101d55 <__alltraps>

0010261f <vector218>:
.globl vector218
vector218:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $218
  102621:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102626:	e9 2a f7 ff ff       	jmp    101d55 <__alltraps>

0010262b <vector219>:
.globl vector219
vector219:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $219
  10262d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102632:	e9 1e f7 ff ff       	jmp    101d55 <__alltraps>

00102637 <vector220>:
.globl vector220
vector220:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $220
  102639:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10263e:	e9 12 f7 ff ff       	jmp    101d55 <__alltraps>

00102643 <vector221>:
.globl vector221
vector221:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $221
  102645:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10264a:	e9 06 f7 ff ff       	jmp    101d55 <__alltraps>

0010264f <vector222>:
.globl vector222
vector222:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $222
  102651:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102656:	e9 fa f6 ff ff       	jmp    101d55 <__alltraps>

0010265b <vector223>:
.globl vector223
vector223:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $223
  10265d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102662:	e9 ee f6 ff ff       	jmp    101d55 <__alltraps>

00102667 <vector224>:
.globl vector224
vector224:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $224
  102669:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10266e:	e9 e2 f6 ff ff       	jmp    101d55 <__alltraps>

00102673 <vector225>:
.globl vector225
vector225:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $225
  102675:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10267a:	e9 d6 f6 ff ff       	jmp    101d55 <__alltraps>

0010267f <vector226>:
.globl vector226
vector226:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $226
  102681:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102686:	e9 ca f6 ff ff       	jmp    101d55 <__alltraps>

0010268b <vector227>:
.globl vector227
vector227:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $227
  10268d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102692:	e9 be f6 ff ff       	jmp    101d55 <__alltraps>

00102697 <vector228>:
.globl vector228
vector228:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $228
  102699:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10269e:	e9 b2 f6 ff ff       	jmp    101d55 <__alltraps>

001026a3 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $229
  1026a5:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026aa:	e9 a6 f6 ff ff       	jmp    101d55 <__alltraps>

001026af <vector230>:
.globl vector230
vector230:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $230
  1026b1:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026b6:	e9 9a f6 ff ff       	jmp    101d55 <__alltraps>

001026bb <vector231>:
.globl vector231
vector231:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $231
  1026bd:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026c2:	e9 8e f6 ff ff       	jmp    101d55 <__alltraps>

001026c7 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $232
  1026c9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026ce:	e9 82 f6 ff ff       	jmp    101d55 <__alltraps>

001026d3 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $233
  1026d5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026da:	e9 76 f6 ff ff       	jmp    101d55 <__alltraps>

001026df <vector234>:
.globl vector234
vector234:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $234
  1026e1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026e6:	e9 6a f6 ff ff       	jmp    101d55 <__alltraps>

001026eb <vector235>:
.globl vector235
vector235:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $235
  1026ed:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026f2:	e9 5e f6 ff ff       	jmp    101d55 <__alltraps>

001026f7 <vector236>:
.globl vector236
vector236:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $236
  1026f9:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026fe:	e9 52 f6 ff ff       	jmp    101d55 <__alltraps>

00102703 <vector237>:
.globl vector237
vector237:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $237
  102705:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10270a:	e9 46 f6 ff ff       	jmp    101d55 <__alltraps>

0010270f <vector238>:
.globl vector238
vector238:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $238
  102711:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102716:	e9 3a f6 ff ff       	jmp    101d55 <__alltraps>

0010271b <vector239>:
.globl vector239
vector239:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $239
  10271d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102722:	e9 2e f6 ff ff       	jmp    101d55 <__alltraps>

00102727 <vector240>:
.globl vector240
vector240:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $240
  102729:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10272e:	e9 22 f6 ff ff       	jmp    101d55 <__alltraps>

00102733 <vector241>:
.globl vector241
vector241:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $241
  102735:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10273a:	e9 16 f6 ff ff       	jmp    101d55 <__alltraps>

0010273f <vector242>:
.globl vector242
vector242:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $242
  102741:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102746:	e9 0a f6 ff ff       	jmp    101d55 <__alltraps>

0010274b <vector243>:
.globl vector243
vector243:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $243
  10274d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102752:	e9 fe f5 ff ff       	jmp    101d55 <__alltraps>

00102757 <vector244>:
.globl vector244
vector244:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $244
  102759:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10275e:	e9 f2 f5 ff ff       	jmp    101d55 <__alltraps>

00102763 <vector245>:
.globl vector245
vector245:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $245
  102765:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10276a:	e9 e6 f5 ff ff       	jmp    101d55 <__alltraps>

0010276f <vector246>:
.globl vector246
vector246:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $246
  102771:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102776:	e9 da f5 ff ff       	jmp    101d55 <__alltraps>

0010277b <vector247>:
.globl vector247
vector247:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $247
  10277d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102782:	e9 ce f5 ff ff       	jmp    101d55 <__alltraps>

00102787 <vector248>:
.globl vector248
vector248:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $248
  102789:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10278e:	e9 c2 f5 ff ff       	jmp    101d55 <__alltraps>

00102793 <vector249>:
.globl vector249
vector249:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $249
  102795:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10279a:	e9 b6 f5 ff ff       	jmp    101d55 <__alltraps>

0010279f <vector250>:
.globl vector250
vector250:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $250
  1027a1:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027a6:	e9 aa f5 ff ff       	jmp    101d55 <__alltraps>

001027ab <vector251>:
.globl vector251
vector251:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $251
  1027ad:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027b2:	e9 9e f5 ff ff       	jmp    101d55 <__alltraps>

001027b7 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $252
  1027b9:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027be:	e9 92 f5 ff ff       	jmp    101d55 <__alltraps>

001027c3 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $253
  1027c5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027ca:	e9 86 f5 ff ff       	jmp    101d55 <__alltraps>

001027cf <vector254>:
.globl vector254
vector254:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $254
  1027d1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027d6:	e9 7a f5 ff ff       	jmp    101d55 <__alltraps>

001027db <vector255>:
.globl vector255
vector255:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $255
  1027dd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027e2:	e9 6e f5 ff ff       	jmp    101d55 <__alltraps>

001027e7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027e7:	55                   	push   %ebp
  1027e8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1027ed:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027f0:	b8 23 00 00 00       	mov    $0x23,%eax
  1027f5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027f7:	b8 23 00 00 00       	mov    $0x23,%eax
  1027fc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1027fe:	b8 10 00 00 00       	mov    $0x10,%eax
  102803:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102805:	b8 10 00 00 00       	mov    $0x10,%eax
  10280a:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10280c:	b8 10 00 00 00       	mov    $0x10,%eax
  102811:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102813:	ea 1a 28 10 00 08 00 	ljmp   $0x8,$0x10281a
}
  10281a:	5d                   	pop    %ebp
  10281b:	c3                   	ret    

0010281c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10281c:	55                   	push   %ebp
  10281d:	89 e5                	mov    %esp,%ebp
  10281f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102822:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102827:	05 00 04 00 00       	add    $0x400,%eax
  10282c:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102831:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102838:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10283a:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102841:	68 00 
  102843:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102848:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10284e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102853:	c1 e8 10             	shr    $0x10,%eax
  102856:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10285b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102862:	83 e0 f0             	and    $0xfffffff0,%eax
  102865:	83 c8 09             	or     $0x9,%eax
  102868:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10286d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102874:	83 c8 10             	or     $0x10,%eax
  102877:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10287c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102883:	83 e0 9f             	and    $0xffffff9f,%eax
  102886:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102892:	83 c8 80             	or     $0xffffff80,%eax
  102895:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028a1:	83 e0 f0             	and    $0xfffffff0,%eax
  1028a4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028a9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028b0:	83 e0 ef             	and    $0xffffffef,%eax
  1028b3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028b8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028bf:	83 e0 df             	and    $0xffffffdf,%eax
  1028c2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028c7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ce:	83 c8 40             	or     $0x40,%eax
  1028d1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028dd:	83 e0 7f             	and    $0x7f,%eax
  1028e0:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028ea:	c1 e8 18             	shr    $0x18,%eax
  1028ed:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028f2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028f9:	83 e0 ef             	and    $0xffffffef,%eax
  1028fc:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102901:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102908:	e8 da fe ff ff       	call   1027e7 <lgdt>
  10290d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102913:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102917:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10291a:	c9                   	leave  
  10291b:	c3                   	ret    

0010291c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10291c:	55                   	push   %ebp
  10291d:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10291f:	e8 f8 fe ff ff       	call   10281c <gdt_init>
}
  102924:	5d                   	pop    %ebp
  102925:	c3                   	ret    

00102926 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102926:	55                   	push   %ebp
  102927:	89 e5                	mov    %esp,%ebp
  102929:	83 ec 58             	sub    $0x58,%esp
  10292c:	8b 45 10             	mov    0x10(%ebp),%eax
  10292f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102932:	8b 45 14             	mov    0x14(%ebp),%eax
  102935:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102938:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10293b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10293e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102941:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102944:	8b 45 18             	mov    0x18(%ebp),%eax
  102947:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10294a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10294d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102950:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102953:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10295c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102960:	74 1c                	je     10297e <printnum+0x58>
  102962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102965:	ba 00 00 00 00       	mov    $0x0,%edx
  10296a:	f7 75 e4             	divl   -0x1c(%ebp)
  10296d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102973:	ba 00 00 00 00       	mov    $0x0,%edx
  102978:	f7 75 e4             	divl   -0x1c(%ebp)
  10297b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10297e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102984:	f7 75 e4             	divl   -0x1c(%ebp)
  102987:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10298a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10298d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102993:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102996:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102999:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10299c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10299f:	8b 45 18             	mov    0x18(%ebp),%eax
  1029a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1029a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029aa:	77 56                	ja     102a02 <printnum+0xdc>
  1029ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029af:	72 05                	jb     1029b6 <printnum+0x90>
  1029b1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029b4:	77 4c                	ja     102a02 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029bc:	8b 45 20             	mov    0x20(%ebp),%eax
  1029bf:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029c3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029c7:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e6:	89 04 24             	mov    %eax,(%esp)
  1029e9:	e8 38 ff ff ff       	call   102926 <printnum>
  1029ee:	eb 1c                	jmp    102a0c <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1029f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f7:	8b 45 20             	mov    0x20(%ebp),%eax
  1029fa:	89 04 24             	mov    %eax,(%esp)
  1029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  102a00:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a02:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a06:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a0a:	7f e4                	jg     1029f0 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a0f:	05 f0 3b 10 00       	add    $0x103bf0,%eax
  102a14:	0f b6 00             	movzbl (%eax),%eax
  102a17:	0f be c0             	movsbl %al,%eax
  102a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a21:	89 04 24             	mov    %eax,(%esp)
  102a24:	8b 45 08             	mov    0x8(%ebp),%eax
  102a27:	ff d0                	call   *%eax
}
  102a29:	c9                   	leave  
  102a2a:	c3                   	ret    

00102a2b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a2b:	55                   	push   %ebp
  102a2c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a32:	7e 14                	jle    102a48 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a34:	8b 45 08             	mov    0x8(%ebp),%eax
  102a37:	8b 00                	mov    (%eax),%eax
  102a39:	8d 48 08             	lea    0x8(%eax),%ecx
  102a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a3f:	89 0a                	mov    %ecx,(%edx)
  102a41:	8b 50 04             	mov    0x4(%eax),%edx
  102a44:	8b 00                	mov    (%eax),%eax
  102a46:	eb 30                	jmp    102a78 <getuint+0x4d>
    }
    else if (lflag) {
  102a48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a4c:	74 16                	je     102a64 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a51:	8b 00                	mov    (%eax),%eax
  102a53:	8d 48 04             	lea    0x4(%eax),%ecx
  102a56:	8b 55 08             	mov    0x8(%ebp),%edx
  102a59:	89 0a                	mov    %ecx,(%edx)
  102a5b:	8b 00                	mov    (%eax),%eax
  102a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  102a62:	eb 14                	jmp    102a78 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a64:	8b 45 08             	mov    0x8(%ebp),%eax
  102a67:	8b 00                	mov    (%eax),%eax
  102a69:	8d 48 04             	lea    0x4(%eax),%ecx
  102a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a6f:	89 0a                	mov    %ecx,(%edx)
  102a71:	8b 00                	mov    (%eax),%eax
  102a73:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a78:	5d                   	pop    %ebp
  102a79:	c3                   	ret    

00102a7a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a7a:	55                   	push   %ebp
  102a7b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a7d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a81:	7e 14                	jle    102a97 <getint+0x1d>
        return va_arg(*ap, long long);
  102a83:	8b 45 08             	mov    0x8(%ebp),%eax
  102a86:	8b 00                	mov    (%eax),%eax
  102a88:	8d 48 08             	lea    0x8(%eax),%ecx
  102a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  102a8e:	89 0a                	mov    %ecx,(%edx)
  102a90:	8b 50 04             	mov    0x4(%eax),%edx
  102a93:	8b 00                	mov    (%eax),%eax
  102a95:	eb 28                	jmp    102abf <getint+0x45>
    }
    else if (lflag) {
  102a97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a9b:	74 12                	je     102aaf <getint+0x35>
        return va_arg(*ap, long);
  102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa0:	8b 00                	mov    (%eax),%eax
  102aa2:	8d 48 04             	lea    0x4(%eax),%ecx
  102aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa8:	89 0a                	mov    %ecx,(%edx)
  102aaa:	8b 00                	mov    (%eax),%eax
  102aac:	99                   	cltd   
  102aad:	eb 10                	jmp    102abf <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	8b 00                	mov    (%eax),%eax
  102ab4:	8d 48 04             	lea    0x4(%eax),%ecx
  102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  102aba:	89 0a                	mov    %ecx,(%edx)
  102abc:	8b 00                	mov    (%eax),%eax
  102abe:	99                   	cltd   
    }
}
  102abf:	5d                   	pop    %ebp
  102ac0:	c3                   	ret    

00102ac1 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ac1:	55                   	push   %ebp
  102ac2:	89 e5                	mov    %esp,%ebp
  102ac4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102ac7:	8d 45 14             	lea    0x14(%ebp),%eax
  102aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ad0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ad7:	89 44 24 08          	mov    %eax,0x8(%esp)
  102adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae5:	89 04 24             	mov    %eax,(%esp)
  102ae8:	e8 02 00 00 00       	call   102aef <vprintfmt>
    va_end(ap);
}
  102aed:	c9                   	leave  
  102aee:	c3                   	ret    

00102aef <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102aef:	55                   	push   %ebp
  102af0:	89 e5                	mov    %esp,%ebp
  102af2:	56                   	push   %esi
  102af3:	53                   	push   %ebx
  102af4:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102af7:	eb 18                	jmp    102b11 <vprintfmt+0x22>
            if (ch == '\0') {
  102af9:	85 db                	test   %ebx,%ebx
  102afb:	75 05                	jne    102b02 <vprintfmt+0x13>
                return;
  102afd:	e9 d1 03 00 00       	jmp    102ed3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b05:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b09:	89 1c 24             	mov    %ebx,(%esp)
  102b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0f:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b11:	8b 45 10             	mov    0x10(%ebp),%eax
  102b14:	8d 50 01             	lea    0x1(%eax),%edx
  102b17:	89 55 10             	mov    %edx,0x10(%ebp)
  102b1a:	0f b6 00             	movzbl (%eax),%eax
  102b1d:	0f b6 d8             	movzbl %al,%ebx
  102b20:	83 fb 25             	cmp    $0x25,%ebx
  102b23:	75 d4                	jne    102af9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b25:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b29:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b33:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b36:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b40:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b43:	8b 45 10             	mov    0x10(%ebp),%eax
  102b46:	8d 50 01             	lea    0x1(%eax),%edx
  102b49:	89 55 10             	mov    %edx,0x10(%ebp)
  102b4c:	0f b6 00             	movzbl (%eax),%eax
  102b4f:	0f b6 d8             	movzbl %al,%ebx
  102b52:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b55:	83 f8 55             	cmp    $0x55,%eax
  102b58:	0f 87 44 03 00 00    	ja     102ea2 <vprintfmt+0x3b3>
  102b5e:	8b 04 85 14 3c 10 00 	mov    0x103c14(,%eax,4),%eax
  102b65:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b67:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b6b:	eb d6                	jmp    102b43 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b6d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b71:	eb d0                	jmp    102b43 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b7d:	89 d0                	mov    %edx,%eax
  102b7f:	c1 e0 02             	shl    $0x2,%eax
  102b82:	01 d0                	add    %edx,%eax
  102b84:	01 c0                	add    %eax,%eax
  102b86:	01 d8                	add    %ebx,%eax
  102b88:	83 e8 30             	sub    $0x30,%eax
  102b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  102b91:	0f b6 00             	movzbl (%eax),%eax
  102b94:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102b97:	83 fb 2f             	cmp    $0x2f,%ebx
  102b9a:	7e 0b                	jle    102ba7 <vprintfmt+0xb8>
  102b9c:	83 fb 39             	cmp    $0x39,%ebx
  102b9f:	7f 06                	jg     102ba7 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ba1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102ba5:	eb d3                	jmp    102b7a <vprintfmt+0x8b>
            goto process_precision;
  102ba7:	eb 33                	jmp    102bdc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  102bac:	8d 50 04             	lea    0x4(%eax),%edx
  102baf:	89 55 14             	mov    %edx,0x14(%ebp)
  102bb2:	8b 00                	mov    (%eax),%eax
  102bb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bb7:	eb 23                	jmp    102bdc <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bb9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bbd:	79 0c                	jns    102bcb <vprintfmt+0xdc>
                width = 0;
  102bbf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bc6:	e9 78 ff ff ff       	jmp    102b43 <vprintfmt+0x54>
  102bcb:	e9 73 ff ff ff       	jmp    102b43 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bd0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bd7:	e9 67 ff ff ff       	jmp    102b43 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102bdc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102be0:	79 12                	jns    102bf4 <vprintfmt+0x105>
                width = precision, precision = -1;
  102be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102be5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102be8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102bef:	e9 4f ff ff ff       	jmp    102b43 <vprintfmt+0x54>
  102bf4:	e9 4a ff ff ff       	jmp    102b43 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102bf9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102bfd:	e9 41 ff ff ff       	jmp    102b43 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c02:	8b 45 14             	mov    0x14(%ebp),%eax
  102c05:	8d 50 04             	lea    0x4(%eax),%edx
  102c08:	89 55 14             	mov    %edx,0x14(%ebp)
  102c0b:	8b 00                	mov    (%eax),%eax
  102c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c10:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c14:	89 04 24             	mov    %eax,(%esp)
  102c17:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1a:	ff d0                	call   *%eax
            break;
  102c1c:	e9 ac 02 00 00       	jmp    102ecd <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c21:	8b 45 14             	mov    0x14(%ebp),%eax
  102c24:	8d 50 04             	lea    0x4(%eax),%edx
  102c27:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c2c:	85 db                	test   %ebx,%ebx
  102c2e:	79 02                	jns    102c32 <vprintfmt+0x143>
                err = -err;
  102c30:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c32:	83 fb 06             	cmp    $0x6,%ebx
  102c35:	7f 0b                	jg     102c42 <vprintfmt+0x153>
  102c37:	8b 34 9d d4 3b 10 00 	mov    0x103bd4(,%ebx,4),%esi
  102c3e:	85 f6                	test   %esi,%esi
  102c40:	75 23                	jne    102c65 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c42:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c46:	c7 44 24 08 01 3c 10 	movl   $0x103c01,0x8(%esp)
  102c4d:	00 
  102c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c55:	8b 45 08             	mov    0x8(%ebp),%eax
  102c58:	89 04 24             	mov    %eax,(%esp)
  102c5b:	e8 61 fe ff ff       	call   102ac1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c60:	e9 68 02 00 00       	jmp    102ecd <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c65:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c69:	c7 44 24 08 0a 3c 10 	movl   $0x103c0a,0x8(%esp)
  102c70:	00 
  102c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c78:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7b:	89 04 24             	mov    %eax,(%esp)
  102c7e:	e8 3e fe ff ff       	call   102ac1 <printfmt>
            }
            break;
  102c83:	e9 45 02 00 00       	jmp    102ecd <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c88:	8b 45 14             	mov    0x14(%ebp),%eax
  102c8b:	8d 50 04             	lea    0x4(%eax),%edx
  102c8e:	89 55 14             	mov    %edx,0x14(%ebp)
  102c91:	8b 30                	mov    (%eax),%esi
  102c93:	85 f6                	test   %esi,%esi
  102c95:	75 05                	jne    102c9c <vprintfmt+0x1ad>
                p = "(null)";
  102c97:	be 0d 3c 10 00       	mov    $0x103c0d,%esi
            }
            if (width > 0 && padc != '-') {
  102c9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ca0:	7e 3e                	jle    102ce0 <vprintfmt+0x1f1>
  102ca2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102ca6:	74 38                	je     102ce0 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ca8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cb2:	89 34 24             	mov    %esi,(%esp)
  102cb5:	e8 15 03 00 00       	call   102fcf <strnlen>
  102cba:	29 c3                	sub    %eax,%ebx
  102cbc:	89 d8                	mov    %ebx,%eax
  102cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cc1:	eb 17                	jmp    102cda <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102cc3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cca:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cce:	89 04 24             	mov    %eax,(%esp)
  102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cd6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cde:	7f e3                	jg     102cc3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ce0:	eb 38                	jmp    102d1a <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ce2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ce6:	74 1f                	je     102d07 <vprintfmt+0x218>
  102ce8:	83 fb 1f             	cmp    $0x1f,%ebx
  102ceb:	7e 05                	jle    102cf2 <vprintfmt+0x203>
  102ced:	83 fb 7e             	cmp    $0x7e,%ebx
  102cf0:	7e 15                	jle    102d07 <vprintfmt+0x218>
                    putch('?', putdat);
  102cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d00:	8b 45 08             	mov    0x8(%ebp),%eax
  102d03:	ff d0                	call   *%eax
  102d05:	eb 0f                	jmp    102d16 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d0e:	89 1c 24             	mov    %ebx,(%esp)
  102d11:	8b 45 08             	mov    0x8(%ebp),%eax
  102d14:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d16:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d1a:	89 f0                	mov    %esi,%eax
  102d1c:	8d 70 01             	lea    0x1(%eax),%esi
  102d1f:	0f b6 00             	movzbl (%eax),%eax
  102d22:	0f be d8             	movsbl %al,%ebx
  102d25:	85 db                	test   %ebx,%ebx
  102d27:	74 10                	je     102d39 <vprintfmt+0x24a>
  102d29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d2d:	78 b3                	js     102ce2 <vprintfmt+0x1f3>
  102d2f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d37:	79 a9                	jns    102ce2 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d39:	eb 17                	jmp    102d52 <vprintfmt+0x263>
                putch(' ', putdat);
  102d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d42:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d49:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d4e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d56:	7f e3                	jg     102d3b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d58:	e9 70 01 00 00       	jmp    102ecd <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d64:	8d 45 14             	lea    0x14(%ebp),%eax
  102d67:	89 04 24             	mov    %eax,(%esp)
  102d6a:	e8 0b fd ff ff       	call   102a7a <getint>
  102d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d72:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d7b:	85 d2                	test   %edx,%edx
  102d7d:	79 26                	jns    102da5 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d90:	ff d0                	call   *%eax
                num = -(long long)num;
  102d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d98:	f7 d8                	neg    %eax
  102d9a:	83 d2 00             	adc    $0x0,%edx
  102d9d:	f7 da                	neg    %edx
  102d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102da2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102da5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dac:	e9 a8 00 00 00       	jmp    102e59 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102db8:	8d 45 14             	lea    0x14(%ebp),%eax
  102dbb:	89 04 24             	mov    %eax,(%esp)
  102dbe:	e8 68 fc ff ff       	call   102a2b <getuint>
  102dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102dc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dd0:	e9 84 00 00 00       	jmp    102e59 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ddc:	8d 45 14             	lea    0x14(%ebp),%eax
  102ddf:	89 04 24             	mov    %eax,(%esp)
  102de2:	e8 44 fc ff ff       	call   102a2b <getuint>
  102de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102ded:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102df4:	eb 63                	jmp    102e59 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dfd:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e04:	8b 45 08             	mov    0x8(%ebp),%eax
  102e07:	ff d0                	call   *%eax
            putch('x', putdat);
  102e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e10:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e17:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  102e1f:	8d 50 04             	lea    0x4(%eax),%edx
  102e22:	89 55 14             	mov    %edx,0x14(%ebp)
  102e25:	8b 00                	mov    (%eax),%eax
  102e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e38:	eb 1f                	jmp    102e59 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e41:	8d 45 14             	lea    0x14(%ebp),%eax
  102e44:	89 04 24             	mov    %eax,(%esp)
  102e47:	e8 df fb ff ff       	call   102a2b <getuint>
  102e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e60:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e67:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e75:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e79:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e80:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e84:	8b 45 08             	mov    0x8(%ebp),%eax
  102e87:	89 04 24             	mov    %eax,(%esp)
  102e8a:	e8 97 fa ff ff       	call   102926 <printnum>
            break;
  102e8f:	eb 3c                	jmp    102ecd <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e98:	89 1c 24             	mov    %ebx,(%esp)
  102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9e:	ff d0                	call   *%eax
            break;
  102ea0:	eb 2b                	jmp    102ecd <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb3:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102eb5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102eb9:	eb 04                	jmp    102ebf <vprintfmt+0x3d0>
  102ebb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  102ec2:	83 e8 01             	sub    $0x1,%eax
  102ec5:	0f b6 00             	movzbl (%eax),%eax
  102ec8:	3c 25                	cmp    $0x25,%al
  102eca:	75 ef                	jne    102ebb <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ecc:	90                   	nop
        }
    }
  102ecd:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ece:	e9 3e fc ff ff       	jmp    102b11 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ed3:	83 c4 40             	add    $0x40,%esp
  102ed6:	5b                   	pop    %ebx
  102ed7:	5e                   	pop    %esi
  102ed8:	5d                   	pop    %ebp
  102ed9:	c3                   	ret    

00102eda <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102eda:	55                   	push   %ebp
  102edb:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee0:	8b 40 08             	mov    0x8(%eax),%eax
  102ee3:	8d 50 01             	lea    0x1(%eax),%edx
  102ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eef:	8b 10                	mov    (%eax),%edx
  102ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef4:	8b 40 04             	mov    0x4(%eax),%eax
  102ef7:	39 c2                	cmp    %eax,%edx
  102ef9:	73 12                	jae    102f0d <sprintputch+0x33>
        *b->buf ++ = ch;
  102efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102efe:	8b 00                	mov    (%eax),%eax
  102f00:	8d 48 01             	lea    0x1(%eax),%ecx
  102f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f06:	89 0a                	mov    %ecx,(%edx)
  102f08:	8b 55 08             	mov    0x8(%ebp),%edx
  102f0b:	88 10                	mov    %dl,(%eax)
    }
}
  102f0d:	5d                   	pop    %ebp
  102f0e:	c3                   	ret    

00102f0f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f0f:	55                   	push   %ebp
  102f10:	89 e5                	mov    %esp,%ebp
  102f12:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f15:	8d 45 14             	lea    0x14(%ebp),%eax
  102f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f22:	8b 45 10             	mov    0x10(%ebp),%eax
  102f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f30:	8b 45 08             	mov    0x8(%ebp),%eax
  102f33:	89 04 24             	mov    %eax,(%esp)
  102f36:	e8 08 00 00 00       	call   102f43 <vsnprintf>
  102f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f41:	c9                   	leave  
  102f42:	c3                   	ret    

00102f43 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f43:	55                   	push   %ebp
  102f44:	89 e5                	mov    %esp,%ebp
  102f46:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f49:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f52:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f55:	8b 45 08             	mov    0x8(%ebp),%eax
  102f58:	01 d0                	add    %edx,%eax
  102f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f68:	74 0a                	je     102f74 <vsnprintf+0x31>
  102f6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f70:	39 c2                	cmp    %eax,%edx
  102f72:	76 07                	jbe    102f7b <vsnprintf+0x38>
        return -E_INVAL;
  102f74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f79:	eb 2a                	jmp    102fa5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f82:	8b 45 10             	mov    0x10(%ebp),%eax
  102f85:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f89:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f90:	c7 04 24 da 2e 10 00 	movl   $0x102eda,(%esp)
  102f97:	e8 53 fb ff ff       	call   102aef <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f9f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fa5:	c9                   	leave  
  102fa6:	c3                   	ret    

00102fa7 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fa7:	55                   	push   %ebp
  102fa8:	89 e5                	mov    %esp,%ebp
  102faa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fb4:	eb 04                	jmp    102fba <strlen+0x13>
        cnt ++;
  102fb6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fba:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbd:	8d 50 01             	lea    0x1(%eax),%edx
  102fc0:	89 55 08             	mov    %edx,0x8(%ebp)
  102fc3:	0f b6 00             	movzbl (%eax),%eax
  102fc6:	84 c0                	test   %al,%al
  102fc8:	75 ec                	jne    102fb6 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fcd:	c9                   	leave  
  102fce:	c3                   	ret    

00102fcf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fcf:	55                   	push   %ebp
  102fd0:	89 e5                	mov    %esp,%ebp
  102fd2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102fdc:	eb 04                	jmp    102fe2 <strnlen+0x13>
        cnt ++;
  102fde:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fe5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102fe8:	73 10                	jae    102ffa <strnlen+0x2b>
  102fea:	8b 45 08             	mov    0x8(%ebp),%eax
  102fed:	8d 50 01             	lea    0x1(%eax),%edx
  102ff0:	89 55 08             	mov    %edx,0x8(%ebp)
  102ff3:	0f b6 00             	movzbl (%eax),%eax
  102ff6:	84 c0                	test   %al,%al
  102ff8:	75 e4                	jne    102fde <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ffd:	c9                   	leave  
  102ffe:	c3                   	ret    

00102fff <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102fff:	55                   	push   %ebp
  103000:	89 e5                	mov    %esp,%ebp
  103002:	57                   	push   %edi
  103003:	56                   	push   %esi
  103004:	83 ec 20             	sub    $0x20,%esp
  103007:	8b 45 08             	mov    0x8(%ebp),%eax
  10300a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103010:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103013:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103019:	89 d1                	mov    %edx,%ecx
  10301b:	89 c2                	mov    %eax,%edx
  10301d:	89 ce                	mov    %ecx,%esi
  10301f:	89 d7                	mov    %edx,%edi
  103021:	ac                   	lods   %ds:(%esi),%al
  103022:	aa                   	stos   %al,%es:(%edi)
  103023:	84 c0                	test   %al,%al
  103025:	75 fa                	jne    103021 <strcpy+0x22>
  103027:	89 fa                	mov    %edi,%edx
  103029:	89 f1                	mov    %esi,%ecx
  10302b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10302e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103031:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103034:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103037:	83 c4 20             	add    $0x20,%esp
  10303a:	5e                   	pop    %esi
  10303b:	5f                   	pop    %edi
  10303c:	5d                   	pop    %ebp
  10303d:	c3                   	ret    

0010303e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10303e:	55                   	push   %ebp
  10303f:	89 e5                	mov    %esp,%ebp
  103041:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103044:	8b 45 08             	mov    0x8(%ebp),%eax
  103047:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10304a:	eb 21                	jmp    10306d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10304c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304f:	0f b6 10             	movzbl (%eax),%edx
  103052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103055:	88 10                	mov    %dl,(%eax)
  103057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10305a:	0f b6 00             	movzbl (%eax),%eax
  10305d:	84 c0                	test   %al,%al
  10305f:	74 04                	je     103065 <strncpy+0x27>
            src ++;
  103061:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103065:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103069:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10306d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103071:	75 d9                	jne    10304c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103076:	c9                   	leave  
  103077:	c3                   	ret    

00103078 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103078:	55                   	push   %ebp
  103079:	89 e5                	mov    %esp,%ebp
  10307b:	57                   	push   %edi
  10307c:	56                   	push   %esi
  10307d:	83 ec 20             	sub    $0x20,%esp
  103080:	8b 45 08             	mov    0x8(%ebp),%eax
  103083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103086:	8b 45 0c             	mov    0xc(%ebp),%eax
  103089:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10308c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10308f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103092:	89 d1                	mov    %edx,%ecx
  103094:	89 c2                	mov    %eax,%edx
  103096:	89 ce                	mov    %ecx,%esi
  103098:	89 d7                	mov    %edx,%edi
  10309a:	ac                   	lods   %ds:(%esi),%al
  10309b:	ae                   	scas   %es:(%edi),%al
  10309c:	75 08                	jne    1030a6 <strcmp+0x2e>
  10309e:	84 c0                	test   %al,%al
  1030a0:	75 f8                	jne    10309a <strcmp+0x22>
  1030a2:	31 c0                	xor    %eax,%eax
  1030a4:	eb 04                	jmp    1030aa <strcmp+0x32>
  1030a6:	19 c0                	sbb    %eax,%eax
  1030a8:	0c 01                	or     $0x1,%al
  1030aa:	89 fa                	mov    %edi,%edx
  1030ac:	89 f1                	mov    %esi,%ecx
  1030ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030ba:	83 c4 20             	add    $0x20,%esp
  1030bd:	5e                   	pop    %esi
  1030be:	5f                   	pop    %edi
  1030bf:	5d                   	pop    %ebp
  1030c0:	c3                   	ret    

001030c1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030c1:	55                   	push   %ebp
  1030c2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030c4:	eb 0c                	jmp    1030d2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030c6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030d6:	74 1a                	je     1030f2 <strncmp+0x31>
  1030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030db:	0f b6 00             	movzbl (%eax),%eax
  1030de:	84 c0                	test   %al,%al
  1030e0:	74 10                	je     1030f2 <strncmp+0x31>
  1030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e5:	0f b6 10             	movzbl (%eax),%edx
  1030e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030eb:	0f b6 00             	movzbl (%eax),%eax
  1030ee:	38 c2                	cmp    %al,%dl
  1030f0:	74 d4                	je     1030c6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030f6:	74 18                	je     103110 <strncmp+0x4f>
  1030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fb:	0f b6 00             	movzbl (%eax),%eax
  1030fe:	0f b6 d0             	movzbl %al,%edx
  103101:	8b 45 0c             	mov    0xc(%ebp),%eax
  103104:	0f b6 00             	movzbl (%eax),%eax
  103107:	0f b6 c0             	movzbl %al,%eax
  10310a:	29 c2                	sub    %eax,%edx
  10310c:	89 d0                	mov    %edx,%eax
  10310e:	eb 05                	jmp    103115 <strncmp+0x54>
  103110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103115:	5d                   	pop    %ebp
  103116:	c3                   	ret    

00103117 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103117:	55                   	push   %ebp
  103118:	89 e5                	mov    %esp,%ebp
  10311a:	83 ec 04             	sub    $0x4,%esp
  10311d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103120:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103123:	eb 14                	jmp    103139 <strchr+0x22>
        if (*s == c) {
  103125:	8b 45 08             	mov    0x8(%ebp),%eax
  103128:	0f b6 00             	movzbl (%eax),%eax
  10312b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10312e:	75 05                	jne    103135 <strchr+0x1e>
            return (char *)s;
  103130:	8b 45 08             	mov    0x8(%ebp),%eax
  103133:	eb 13                	jmp    103148 <strchr+0x31>
        }
        s ++;
  103135:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103139:	8b 45 08             	mov    0x8(%ebp),%eax
  10313c:	0f b6 00             	movzbl (%eax),%eax
  10313f:	84 c0                	test   %al,%al
  103141:	75 e2                	jne    103125 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103148:	c9                   	leave  
  103149:	c3                   	ret    

0010314a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10314a:	55                   	push   %ebp
  10314b:	89 e5                	mov    %esp,%ebp
  10314d:	83 ec 04             	sub    $0x4,%esp
  103150:	8b 45 0c             	mov    0xc(%ebp),%eax
  103153:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103156:	eb 11                	jmp    103169 <strfind+0x1f>
        if (*s == c) {
  103158:	8b 45 08             	mov    0x8(%ebp),%eax
  10315b:	0f b6 00             	movzbl (%eax),%eax
  10315e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103161:	75 02                	jne    103165 <strfind+0x1b>
            break;
  103163:	eb 0e                	jmp    103173 <strfind+0x29>
        }
        s ++;
  103165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103169:	8b 45 08             	mov    0x8(%ebp),%eax
  10316c:	0f b6 00             	movzbl (%eax),%eax
  10316f:	84 c0                	test   %al,%al
  103171:	75 e5                	jne    103158 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103176:	c9                   	leave  
  103177:	c3                   	ret    

00103178 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103178:	55                   	push   %ebp
  103179:	89 e5                	mov    %esp,%ebp
  10317b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10317e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103185:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10318c:	eb 04                	jmp    103192 <strtol+0x1a>
        s ++;
  10318e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103192:	8b 45 08             	mov    0x8(%ebp),%eax
  103195:	0f b6 00             	movzbl (%eax),%eax
  103198:	3c 20                	cmp    $0x20,%al
  10319a:	74 f2                	je     10318e <strtol+0x16>
  10319c:	8b 45 08             	mov    0x8(%ebp),%eax
  10319f:	0f b6 00             	movzbl (%eax),%eax
  1031a2:	3c 09                	cmp    $0x9,%al
  1031a4:	74 e8                	je     10318e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a9:	0f b6 00             	movzbl (%eax),%eax
  1031ac:	3c 2b                	cmp    $0x2b,%al
  1031ae:	75 06                	jne    1031b6 <strtol+0x3e>
        s ++;
  1031b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031b4:	eb 15                	jmp    1031cb <strtol+0x53>
    }
    else if (*s == '-') {
  1031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b9:	0f b6 00             	movzbl (%eax),%eax
  1031bc:	3c 2d                	cmp    $0x2d,%al
  1031be:	75 0b                	jne    1031cb <strtol+0x53>
        s ++, neg = 1;
  1031c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031cf:	74 06                	je     1031d7 <strtol+0x5f>
  1031d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031d5:	75 24                	jne    1031fb <strtol+0x83>
  1031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	3c 30                	cmp    $0x30,%al
  1031df:	75 1a                	jne    1031fb <strtol+0x83>
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	83 c0 01             	add    $0x1,%eax
  1031e7:	0f b6 00             	movzbl (%eax),%eax
  1031ea:	3c 78                	cmp    $0x78,%al
  1031ec:	75 0d                	jne    1031fb <strtol+0x83>
        s += 2, base = 16;
  1031ee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1031f2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1031f9:	eb 2a                	jmp    103225 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1031fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031ff:	75 17                	jne    103218 <strtol+0xa0>
  103201:	8b 45 08             	mov    0x8(%ebp),%eax
  103204:	0f b6 00             	movzbl (%eax),%eax
  103207:	3c 30                	cmp    $0x30,%al
  103209:	75 0d                	jne    103218 <strtol+0xa0>
        s ++, base = 8;
  10320b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10320f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103216:	eb 0d                	jmp    103225 <strtol+0xad>
    }
    else if (base == 0) {
  103218:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10321c:	75 07                	jne    103225 <strtol+0xad>
        base = 10;
  10321e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103225:	8b 45 08             	mov    0x8(%ebp),%eax
  103228:	0f b6 00             	movzbl (%eax),%eax
  10322b:	3c 2f                	cmp    $0x2f,%al
  10322d:	7e 1b                	jle    10324a <strtol+0xd2>
  10322f:	8b 45 08             	mov    0x8(%ebp),%eax
  103232:	0f b6 00             	movzbl (%eax),%eax
  103235:	3c 39                	cmp    $0x39,%al
  103237:	7f 11                	jg     10324a <strtol+0xd2>
            dig = *s - '0';
  103239:	8b 45 08             	mov    0x8(%ebp),%eax
  10323c:	0f b6 00             	movzbl (%eax),%eax
  10323f:	0f be c0             	movsbl %al,%eax
  103242:	83 e8 30             	sub    $0x30,%eax
  103245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103248:	eb 48                	jmp    103292 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10324a:	8b 45 08             	mov    0x8(%ebp),%eax
  10324d:	0f b6 00             	movzbl (%eax),%eax
  103250:	3c 60                	cmp    $0x60,%al
  103252:	7e 1b                	jle    10326f <strtol+0xf7>
  103254:	8b 45 08             	mov    0x8(%ebp),%eax
  103257:	0f b6 00             	movzbl (%eax),%eax
  10325a:	3c 7a                	cmp    $0x7a,%al
  10325c:	7f 11                	jg     10326f <strtol+0xf7>
            dig = *s - 'a' + 10;
  10325e:	8b 45 08             	mov    0x8(%ebp),%eax
  103261:	0f b6 00             	movzbl (%eax),%eax
  103264:	0f be c0             	movsbl %al,%eax
  103267:	83 e8 57             	sub    $0x57,%eax
  10326a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10326d:	eb 23                	jmp    103292 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10326f:	8b 45 08             	mov    0x8(%ebp),%eax
  103272:	0f b6 00             	movzbl (%eax),%eax
  103275:	3c 40                	cmp    $0x40,%al
  103277:	7e 3d                	jle    1032b6 <strtol+0x13e>
  103279:	8b 45 08             	mov    0x8(%ebp),%eax
  10327c:	0f b6 00             	movzbl (%eax),%eax
  10327f:	3c 5a                	cmp    $0x5a,%al
  103281:	7f 33                	jg     1032b6 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103283:	8b 45 08             	mov    0x8(%ebp),%eax
  103286:	0f b6 00             	movzbl (%eax),%eax
  103289:	0f be c0             	movsbl %al,%eax
  10328c:	83 e8 37             	sub    $0x37,%eax
  10328f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103295:	3b 45 10             	cmp    0x10(%ebp),%eax
  103298:	7c 02                	jl     10329c <strtol+0x124>
            break;
  10329a:	eb 1a                	jmp    1032b6 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10329c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032a7:	89 c2                	mov    %eax,%edx
  1032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ac:	01 d0                	add    %edx,%eax
  1032ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032b1:	e9 6f ff ff ff       	jmp    103225 <strtol+0xad>

    if (endptr) {
  1032b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032ba:	74 08                	je     1032c4 <strtol+0x14c>
        *endptr = (char *) s;
  1032bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032bf:	8b 55 08             	mov    0x8(%ebp),%edx
  1032c2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032c8:	74 07                	je     1032d1 <strtol+0x159>
  1032ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032cd:	f7 d8                	neg    %eax
  1032cf:	eb 03                	jmp    1032d4 <strtol+0x15c>
  1032d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032d4:	c9                   	leave  
  1032d5:	c3                   	ret    

001032d6 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032d6:	55                   	push   %ebp
  1032d7:	89 e5                	mov    %esp,%ebp
  1032d9:	57                   	push   %edi
  1032da:	83 ec 24             	sub    $0x24,%esp
  1032dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032e3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1032ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032ed:	88 45 f7             	mov    %al,-0x9(%ebp)
  1032f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1032f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1032f9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1032fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103300:	89 d7                	mov    %edx,%edi
  103302:	f3 aa                	rep stos %al,%es:(%edi)
  103304:	89 fa                	mov    %edi,%edx
  103306:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103309:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10330c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10330f:	83 c4 24             	add    $0x24,%esp
  103312:	5f                   	pop    %edi
  103313:	5d                   	pop    %ebp
  103314:	c3                   	ret    

00103315 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103315:	55                   	push   %ebp
  103316:	89 e5                	mov    %esp,%ebp
  103318:	57                   	push   %edi
  103319:	56                   	push   %esi
  10331a:	53                   	push   %ebx
  10331b:	83 ec 30             	sub    $0x30,%esp
  10331e:	8b 45 08             	mov    0x8(%ebp),%eax
  103321:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103324:	8b 45 0c             	mov    0xc(%ebp),%eax
  103327:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10332a:	8b 45 10             	mov    0x10(%ebp),%eax
  10332d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103333:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103336:	73 42                	jae    10337a <memmove+0x65>
  103338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103347:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10334a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10334d:	c1 e8 02             	shr    $0x2,%eax
  103350:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103358:	89 d7                	mov    %edx,%edi
  10335a:	89 c6                	mov    %eax,%esi
  10335c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10335e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103361:	83 e1 03             	and    $0x3,%ecx
  103364:	74 02                	je     103368 <memmove+0x53>
  103366:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103368:	89 f0                	mov    %esi,%eax
  10336a:	89 fa                	mov    %edi,%edx
  10336c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10336f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103372:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103378:	eb 36                	jmp    1033b0 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103383:	01 c2                	add    %eax,%edx
  103385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103388:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103394:	89 c1                	mov    %eax,%ecx
  103396:	89 d8                	mov    %ebx,%eax
  103398:	89 d6                	mov    %edx,%esi
  10339a:	89 c7                	mov    %eax,%edi
  10339c:	fd                   	std    
  10339d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10339f:	fc                   	cld    
  1033a0:	89 f8                	mov    %edi,%eax
  1033a2:	89 f2                	mov    %esi,%edx
  1033a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033a7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033b0:	83 c4 30             	add    $0x30,%esp
  1033b3:	5b                   	pop    %ebx
  1033b4:	5e                   	pop    %esi
  1033b5:	5f                   	pop    %edi
  1033b6:	5d                   	pop    %ebp
  1033b7:	c3                   	ret    

001033b8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033b8:	55                   	push   %ebp
  1033b9:	89 e5                	mov    %esp,%ebp
  1033bb:	57                   	push   %edi
  1033bc:	56                   	push   %esi
  1033bd:	83 ec 20             	sub    $0x20,%esp
  1033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1033cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d5:	c1 e8 02             	shr    $0x2,%eax
  1033d8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e0:	89 d7                	mov    %edx,%edi
  1033e2:	89 c6                	mov    %eax,%esi
  1033e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033e6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033e9:	83 e1 03             	and    $0x3,%ecx
  1033ec:	74 02                	je     1033f0 <memcpy+0x38>
  1033ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033f0:	89 f0                	mov    %esi,%eax
  1033f2:	89 fa                	mov    %edi,%edx
  1033f4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1033fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103400:	83 c4 20             	add    $0x20,%esp
  103403:	5e                   	pop    %esi
  103404:	5f                   	pop    %edi
  103405:	5d                   	pop    %ebp
  103406:	c3                   	ret    

00103407 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103407:	55                   	push   %ebp
  103408:	89 e5                	mov    %esp,%ebp
  10340a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10340d:	8b 45 08             	mov    0x8(%ebp),%eax
  103410:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103413:	8b 45 0c             	mov    0xc(%ebp),%eax
  103416:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103419:	eb 30                	jmp    10344b <memcmp+0x44>
        if (*s1 != *s2) {
  10341b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10341e:	0f b6 10             	movzbl (%eax),%edx
  103421:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103424:	0f b6 00             	movzbl (%eax),%eax
  103427:	38 c2                	cmp    %al,%dl
  103429:	74 18                	je     103443 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10342b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10342e:	0f b6 00             	movzbl (%eax),%eax
  103431:	0f b6 d0             	movzbl %al,%edx
  103434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103437:	0f b6 00             	movzbl (%eax),%eax
  10343a:	0f b6 c0             	movzbl %al,%eax
  10343d:	29 c2                	sub    %eax,%edx
  10343f:	89 d0                	mov    %edx,%eax
  103441:	eb 1a                	jmp    10345d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103443:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103447:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10344b:	8b 45 10             	mov    0x10(%ebp),%eax
  10344e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103451:	89 55 10             	mov    %edx,0x10(%ebp)
  103454:	85 c0                	test   %eax,%eax
  103456:	75 c3                	jne    10341b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103458:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10345d:	c9                   	leave  
  10345e:	c3                   	ret    
