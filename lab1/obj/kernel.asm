
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
  100027:	e8 37 32 00 00       	call   103263 <memset>

    cons_init();                // init the console
  10002c:	e8 2e 15 00 00       	call   10155f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 00 34 10 00 	movl   $0x103400,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 1c 34 10 00 	movl   $0x10341c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 4f 28 00 00       	call   1028a9 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 43 16 00 00       	call   1016a2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 95 17 00 00       	call   1017f9 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 e9 0c 00 00       	call   100d52 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a2 15 00 00       	call   101610 <intr_enable>
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
  10008d:	e8 f2 0b 00 00       	call   100c84 <mon_backtrace>
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
  10012b:	c7 04 24 21 34 10 00 	movl   $0x103421,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 2f 34 10 00 	movl   $0x10342f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 3d 34 10 00 	movl   $0x10343d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 4b 34 10 00 	movl   $0x10344b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 59 34 10 00 	movl   $0x103459,(%esp)
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
  1001db:	c7 04 24 68 34 10 00 	movl   $0x103468,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 88 34 10 00 	movl   $0x103488,(%esp)
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
  10021c:	c7 04 24 a7 34 10 00 	movl   $0x1034a7,(%esp)
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
  1002cb:	e8 bb 12 00 00       	call   10158b <cons_putc>
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
  100308:	e8 6f 27 00 00       	call   102a7c <vprintfmt>
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
  100344:	e8 42 12 00 00       	call   10158b <cons_putc>
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
  1003a0:	e8 0f 12 00 00       	call   1015b4 <cons_getc>
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
  100512:	c7 00 ac 34 10 00    	movl   $0x1034ac,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 ac 34 10 00 	movl   $0x1034ac,0x8(%eax)
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
  100549:	c7 45 f4 0c 3d 10 00 	movl   $0x103d0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 1c b4 10 00 	movl   $0x10b41c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 1d b4 10 00 	movl   $0x10b41d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 08 d4 10 00 	movl   $0x10d408,-0x18(%ebp)

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
  1006bd:	e8 15 2a 00 00       	call   1030d7 <strfind>
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
  10084c:	c7 04 24 b6 34 10 00 	movl   $0x1034b6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 cf 34 10 00 	movl   $0x1034cf,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 ec 33 10 	movl   $0x1033ec,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 e7 34 10 00 	movl   $0x1034e7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 ff 34 10 00 	movl   $0x1034ff,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 17 35 10 00 	movl   $0x103517,(%esp)
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
  1008ce:	c7 04 24 30 35 10 00 	movl   $0x103530,(%esp)
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
  100902:	c7 04 24 5a 35 10 00 	movl   $0x10355a,(%esp)
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
  100971:	c7 04 24 76 35 10 00 	movl   $0x103576,(%esp)
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
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i=0;i<STACKFRAME_DEPTH;i++){
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 88 00 00 00       	jmp    100a3d <print_stackframe+0xad>
		//if (!ebp) break; 
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 88 35 10 00 	movl   $0x103588,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>
        uint32_t *args = (uint32_t *)ebp+2;
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	83 c0 08             	add    $0x8,%eax
  1009d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int j;
        for (j=0;j<4;j++){
  1009d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009df:	eb 25                	jmp    100a06 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  1009e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	8b 00                	mov    (%eax),%eax
  1009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f6:	c7 04 24 a4 35 10 00 	movl   $0x1035a4,(%esp)
  1009fd:	e8 10 f9 ff ff       	call   100312 <cprintf>
	for (i=0;i<STACKFRAME_DEPTH;i++){
		//if (!ebp) break; 
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp+2;
		int j;
        for (j=0;j<4;j++){
  100a02:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a06:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0a:	7e d5                	jle    1009e1 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a0c:	c7 04 24 ac 35 10 00 	movl   $0x1035ac,(%esp)
  100a13:	e8 fa f8 ff ff       	call   100312 <cprintf>
        print_debuginfo(eip-1);
  100a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1b:	83 e8 01             	sub    $0x1,%eax
  100a1e:	89 04 24             	mov    %eax,(%esp)
  100a21:	e8 b6 fe ff ff       	call   1008dc <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a29:	83 c0 04             	add    $0x4,%eax
  100a2c:	8b 00                	mov    (%eax),%eax
  100a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i;
	for (i=0;i<STACKFRAME_DEPTH;i++){
  100a39:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a41:	0f 8e 6e ff ff ff    	jle    1009b5 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip-1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
}
  100a47:	c9                   	leave  
  100a48:	c3                   	ret    

00100a49 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a49:	55                   	push   %ebp
  100a4a:	89 e5                	mov    %esp,%ebp
  100a4c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a56:	eb 0c                	jmp    100a64 <parse+0x1b>
            *buf ++ = '\0';
  100a58:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5b:	8d 50 01             	lea    0x1(%eax),%edx
  100a5e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a61:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a64:	8b 45 08             	mov    0x8(%ebp),%eax
  100a67:	0f b6 00             	movzbl (%eax),%eax
  100a6a:	84 c0                	test   %al,%al
  100a6c:	74 1d                	je     100a8b <parse+0x42>
  100a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a71:	0f b6 00             	movzbl (%eax),%eax
  100a74:	0f be c0             	movsbl %al,%eax
  100a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a7b:	c7 04 24 30 36 10 00 	movl   $0x103630,(%esp)
  100a82:	e8 1d 26 00 00       	call   1030a4 <strchr>
  100a87:	85 c0                	test   %eax,%eax
  100a89:	75 cd                	jne    100a58 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	0f b6 00             	movzbl (%eax),%eax
  100a91:	84 c0                	test   %al,%al
  100a93:	75 02                	jne    100a97 <parse+0x4e>
            break;
  100a95:	eb 67                	jmp    100afe <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a97:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a9b:	75 14                	jne    100ab1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a9d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aa4:	00 
  100aa5:	c7 04 24 35 36 10 00 	movl   $0x103635,(%esp)
  100aac:	e8 61 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab4:	8d 50 01             	lea    0x1(%eax),%edx
  100ab7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ac4:	01 c2                	add    %eax,%edx
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100acb:	eb 04                	jmp    100ad1 <parse+0x88>
            buf ++;
  100acd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad4:	0f b6 00             	movzbl (%eax),%eax
  100ad7:	84 c0                	test   %al,%al
  100ad9:	74 1d                	je     100af8 <parse+0xaf>
  100adb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ade:	0f b6 00             	movzbl (%eax),%eax
  100ae1:	0f be c0             	movsbl %al,%eax
  100ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae8:	c7 04 24 30 36 10 00 	movl   $0x103630,(%esp)
  100aef:	e8 b0 25 00 00       	call   1030a4 <strchr>
  100af4:	85 c0                	test   %eax,%eax
  100af6:	74 d5                	je     100acd <parse+0x84>
            buf ++;
        }
    }
  100af8:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af9:	e9 66 ff ff ff       	jmp    100a64 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b01:	c9                   	leave  
  100b02:	c3                   	ret    

00100b03 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b03:	55                   	push   %ebp
  100b04:	89 e5                	mov    %esp,%ebp
  100b06:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b09:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	89 04 24             	mov    %eax,(%esp)
  100b16:	e8 2e ff ff ff       	call   100a49 <parse>
  100b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b22:	75 0a                	jne    100b2e <runcmd+0x2b>
        return 0;
  100b24:	b8 00 00 00 00       	mov    $0x0,%eax
  100b29:	e9 85 00 00 00       	jmp    100bb3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b35:	eb 5c                	jmp    100b93 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b37:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b3d:	89 d0                	mov    %edx,%eax
  100b3f:	01 c0                	add    %eax,%eax
  100b41:	01 d0                	add    %edx,%eax
  100b43:	c1 e0 02             	shl    $0x2,%eax
  100b46:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b4b:	8b 00                	mov    (%eax),%eax
  100b4d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b51:	89 04 24             	mov    %eax,(%esp)
  100b54:	e8 ac 24 00 00       	call   103005 <strcmp>
  100b59:	85 c0                	test   %eax,%eax
  100b5b:	75 32                	jne    100b8f <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b60:	89 d0                	mov    %edx,%eax
  100b62:	01 c0                	add    %eax,%eax
  100b64:	01 d0                	add    %edx,%eax
  100b66:	c1 e0 02             	shl    $0x2,%eax
  100b69:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b6e:	8b 40 08             	mov    0x8(%eax),%eax
  100b71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b74:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b7e:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b81:	83 c2 04             	add    $0x4,%edx
  100b84:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b88:	89 0c 24             	mov    %ecx,(%esp)
  100b8b:	ff d0                	call   *%eax
  100b8d:	eb 24                	jmp    100bb3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b96:	83 f8 02             	cmp    $0x2,%eax
  100b99:	76 9c                	jbe    100b37 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba2:	c7 04 24 53 36 10 00 	movl   $0x103653,(%esp)
  100ba9:	e8 64 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb3:	c9                   	leave  
  100bb4:	c3                   	ret    

00100bb5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bb5:	55                   	push   %ebp
  100bb6:	89 e5                	mov    %esp,%ebp
  100bb8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bbb:	c7 04 24 6c 36 10 00 	movl   $0x10366c,(%esp)
  100bc2:	e8 4b f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bc7:	c7 04 24 94 36 10 00 	movl   $0x103694,(%esp)
  100bce:	e8 3f f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bd7:	74 0b                	je     100be4 <kmonitor+0x2f>
        print_trapframe(tf);
  100bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdc:	89 04 24             	mov    %eax,(%esp)
  100bdf:	e8 4e 0d 00 00       	call   101932 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100be4:	c7 04 24 b9 36 10 00 	movl   $0x1036b9,(%esp)
  100beb:	e8 19 f6 ff ff       	call   100209 <readline>
  100bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bf7:	74 18                	je     100c11 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c03:	89 04 24             	mov    %eax,(%esp)
  100c06:	e8 f8 fe ff ff       	call   100b03 <runcmd>
  100c0b:	85 c0                	test   %eax,%eax
  100c0d:	79 02                	jns    100c11 <kmonitor+0x5c>
                break;
  100c0f:	eb 02                	jmp    100c13 <kmonitor+0x5e>
            }
        }
    }
  100c11:	eb d1                	jmp    100be4 <kmonitor+0x2f>
}
  100c13:	c9                   	leave  
  100c14:	c3                   	ret    

00100c15 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c15:	55                   	push   %ebp
  100c16:	89 e5                	mov    %esp,%ebp
  100c18:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c22:	eb 3f                	jmp    100c63 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c27:	89 d0                	mov    %edx,%eax
  100c29:	01 c0                	add    %eax,%eax
  100c2b:	01 d0                	add    %edx,%eax
  100c2d:	c1 e0 02             	shl    $0x2,%eax
  100c30:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c35:	8b 48 04             	mov    0x4(%eax),%ecx
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c49:	8b 00                	mov    (%eax),%eax
  100c4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c53:	c7 04 24 bd 36 10 00 	movl   $0x1036bd,(%esp)
  100c5a:	e8 b3 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c66:	83 f8 02             	cmp    $0x2,%eax
  100c69:	76 b9                	jbe    100c24 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c70:	c9                   	leave  
  100c71:	c3                   	ret    

00100c72 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c72:	55                   	push   %ebp
  100c73:	89 e5                	mov    %esp,%ebp
  100c75:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c78:	e8 c9 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c82:	c9                   	leave  
  100c83:	c3                   	ret    

00100c84 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c84:	55                   	push   %ebp
  100c85:	89 e5                	mov    %esp,%ebp
  100c87:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c8a:	e8 01 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c94:	c9                   	leave  
  100c95:	c3                   	ret    

00100c96 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c96:	55                   	push   %ebp
  100c97:	89 e5                	mov    %esp,%ebp
  100c99:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c9c:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca1:	85 c0                	test   %eax,%eax
  100ca3:	74 02                	je     100ca7 <__panic+0x11>
        goto panic_dead;
  100ca5:	eb 48                	jmp    100cef <__panic+0x59>
    }
    is_panic = 1;
  100ca7:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cae:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb1:	8d 45 14             	lea    0x14(%ebp),%eax
  100cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc5:	c7 04 24 c6 36 10 00 	movl   $0x1036c6,(%esp)
  100ccc:	e8 41 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  100cdb:	89 04 24             	mov    %eax,(%esp)
  100cde:	e8 fc f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce3:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  100cea:	e8 23 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cef:	e8 22 09 00 00       	call   101616 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cfb:	e8 b5 fe ff ff       	call   100bb5 <kmonitor>
    }
  100d00:	eb f2                	jmp    100cf4 <__panic+0x5e>

00100d02 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d02:	55                   	push   %ebp
  100d03:	89 e5                	mov    %esp,%ebp
  100d05:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d08:	8d 45 14             	lea    0x14(%ebp),%eax
  100d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d11:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d15:	8b 45 08             	mov    0x8(%ebp),%eax
  100d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1c:	c7 04 24 e4 36 10 00 	movl   $0x1036e4,(%esp)
  100d23:	e8 ea f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d32:	89 04 24             	mov    %eax,(%esp)
  100d35:	e8 a5 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d3a:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  100d41:	e8 cc f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d46:	c9                   	leave  
  100d47:	c3                   	ret    

00100d48 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d48:	55                   	push   %ebp
  100d49:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d4b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d50:	5d                   	pop    %ebp
  100d51:	c3                   	ret    

00100d52 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d52:	55                   	push   %ebp
  100d53:	89 e5                	mov    %esp,%ebp
  100d55:	83 ec 28             	sub    $0x28,%esp
  100d58:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d62:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d66:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d6a:	ee                   	out    %al,(%dx)
  100d6b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d71:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d75:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d79:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7d:	ee                   	out    %al,(%dx)
  100d7e:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d84:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d88:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d8c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d90:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d91:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d98:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9b:	c7 04 24 02 37 10 00 	movl   $0x103702,(%esp)
  100da2:	e8 6b f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100da7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dae:	e8 c1 08 00 00       	call   101674 <pic_enable>
}
  100db3:	c9                   	leave  
  100db4:	c3                   	ret    

00100db5 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db5:	55                   	push   %ebp
  100db6:	89 e5                	mov    %esp,%ebp
  100db8:	83 ec 10             	sub    $0x10,%esp
  100dbb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dc5:	89 c2                	mov    %eax,%edx
  100dc7:	ec                   	in     (%dx),%al
  100dc8:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dcb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd5:	89 c2                	mov    %eax,%edx
  100dd7:	ec                   	in     (%dx),%al
  100dd8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ddb:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100de5:	89 c2                	mov    %eax,%edx
  100de7:	ec                   	in     (%dx),%al
  100de8:	88 45 f5             	mov    %al,-0xb(%ebp)
  100deb:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100df1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100df5:	89 c2                	mov    %eax,%edx
  100df7:	ec                   	in     (%dx),%al
  100df8:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dfb:	c9                   	leave  
  100dfc:	c3                   	ret    

00100dfd <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e03:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0d:	0f b7 00             	movzwl (%eax),%eax
  100e10:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e17:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1f:	0f b7 00             	movzwl (%eax),%eax
  100e22:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e26:	74 12                	je     100e3a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e28:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e2f:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e36:	b4 03 
  100e38:	eb 13                	jmp    100e4d <cga_init+0x50>
    } else {
        *cp = was;
  100e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e41:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e44:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e4b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e4d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e54:	0f b7 c0             	movzwl %ax,%eax
  100e57:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e5b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e5f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e67:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e68:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6f:	83 c0 01             	add    $0x1,%eax
  100e72:	0f b7 c0             	movzwl %ax,%eax
  100e75:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e79:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e7d:	89 c2                	mov    %eax,%edx
  100e7f:	ec                   	in     (%dx),%al
  100e80:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e83:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e87:	0f b6 c0             	movzbl %al,%eax
  100e8a:	c1 e0 08             	shl    $0x8,%eax
  100e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e90:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e97:	0f b7 c0             	movzwl %ax,%eax
  100e9a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e9e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ea6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eaa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb2:	83 c0 01             	add    $0x1,%eax
  100eb5:	0f b7 c0             	movzwl %ax,%eax
  100eb8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ebc:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ec0:	89 c2                	mov    %eax,%edx
  100ec2:	ec                   	in     (%dx),%al
  100ec3:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ec6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eca:	0f b6 c0             	movzbl %al,%eax
  100ecd:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100edb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee1:	c9                   	leave  
  100ee2:	c3                   	ret    

00100ee3 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee3:	55                   	push   %ebp
  100ee4:	89 e5                	mov    %esp,%ebp
  100ee6:	83 ec 48             	sub    $0x48,%esp
  100ee9:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eef:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ef7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100efb:	ee                   	out    %al,(%dx)
  100efc:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f02:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f06:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f0e:	ee                   	out    %al,(%dx)
  100f0f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f15:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f19:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f21:	ee                   	out    %al,(%dx)
  100f22:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f28:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f2c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f30:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
  100f35:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f3b:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f3f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f43:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f47:	ee                   	out    %al,(%dx)
  100f48:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f4e:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f52:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f56:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f5a:	ee                   	out    %al,(%dx)
  100f5b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f61:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f65:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f69:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f74:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f78:	89 c2                	mov    %eax,%edx
  100f7a:	ec                   	in     (%dx),%al
  100f7b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f7e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f82:	3c ff                	cmp    $0xff,%al
  100f84:	0f 95 c0             	setne  %al
  100f87:	0f b6 c0             	movzbl %al,%eax
  100f8a:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f8f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f95:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f9f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fa5:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100faf:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb4:	85 c0                	test   %eax,%eax
  100fb6:	74 0c                	je     100fc4 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fb8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fbf:	e8 b0 06 00 00       	call   101674 <pic_enable>
    }
}
  100fc4:	c9                   	leave  
  100fc5:	c3                   	ret    

00100fc6 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc6:	55                   	push   %ebp
  100fc7:	89 e5                	mov    %esp,%ebp
  100fc9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd3:	eb 09                	jmp    100fde <lpt_putc_sub+0x18>
        delay();
  100fd5:	e8 db fd ff ff       	call   100db5 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fde:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fe8:	89 c2                	mov    %eax,%edx
  100fea:	ec                   	in     (%dx),%al
  100feb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff2:	84 c0                	test   %al,%al
  100ff4:	78 09                	js     100fff <lpt_putc_sub+0x39>
  100ff6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ffd:	7e d6                	jle    100fd5 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fff:	8b 45 08             	mov    0x8(%ebp),%eax
  101002:	0f b6 c0             	movzbl %al,%eax
  101005:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10100b:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10100e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101012:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
  101017:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10101d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101021:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101025:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101029:	ee                   	out    %al,(%dx)
  10102a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101030:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101034:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101038:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10103c:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10103d:	c9                   	leave  
  10103e:	c3                   	ret    

0010103f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103f:	55                   	push   %ebp
  101040:	89 e5                	mov    %esp,%ebp
  101042:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101045:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101049:	74 0d                	je     101058 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10104b:	8b 45 08             	mov    0x8(%ebp),%eax
  10104e:	89 04 24             	mov    %eax,(%esp)
  101051:	e8 70 ff ff ff       	call   100fc6 <lpt_putc_sub>
  101056:	eb 24                	jmp    10107c <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101058:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10105f:	e8 62 ff ff ff       	call   100fc6 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101064:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10106b:	e8 56 ff ff ff       	call   100fc6 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101070:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101077:	e8 4a ff ff ff       	call   100fc6 <lpt_putc_sub>
    }
}
  10107c:	c9                   	leave  
  10107d:	c3                   	ret    

0010107e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107e:	55                   	push   %ebp
  10107f:	89 e5                	mov    %esp,%ebp
  101081:	53                   	push   %ebx
  101082:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101085:	8b 45 08             	mov    0x8(%ebp),%eax
  101088:	b0 00                	mov    $0x0,%al
  10108a:	85 c0                	test   %eax,%eax
  10108c:	75 07                	jne    101095 <cga_putc+0x17>
        c |= 0x0700;
  10108e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	0f b6 c0             	movzbl %al,%eax
  10109b:	83 f8 0a             	cmp    $0xa,%eax
  10109e:	74 4c                	je     1010ec <cga_putc+0x6e>
  1010a0:	83 f8 0d             	cmp    $0xd,%eax
  1010a3:	74 57                	je     1010fc <cga_putc+0x7e>
  1010a5:	83 f8 08             	cmp    $0x8,%eax
  1010a8:	0f 85 88 00 00 00    	jne    101136 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010ae:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b5:	66 85 c0             	test   %ax,%ax
  1010b8:	74 30                	je     1010ea <cga_putc+0x6c>
            crt_pos --;
  1010ba:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c1:	83 e8 01             	sub    $0x1,%eax
  1010c4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ca:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010cf:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d6:	0f b7 d2             	movzwl %dx,%edx
  1010d9:	01 d2                	add    %edx,%edx
  1010db:	01 c2                	add    %eax,%edx
  1010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e0:	b0 00                	mov    $0x0,%al
  1010e2:	83 c8 20             	or     $0x20,%eax
  1010e5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e8:	eb 72                	jmp    10115c <cga_putc+0xde>
  1010ea:	eb 70                	jmp    10115c <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010ec:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f3:	83 c0 50             	add    $0x50,%eax
  1010f6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010fc:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101103:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10110a:	0f b7 c1             	movzwl %cx,%eax
  10110d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101113:	c1 e8 10             	shr    $0x10,%eax
  101116:	89 c2                	mov    %eax,%edx
  101118:	66 c1 ea 06          	shr    $0x6,%dx
  10111c:	89 d0                	mov    %edx,%eax
  10111e:	c1 e0 02             	shl    $0x2,%eax
  101121:	01 d0                	add    %edx,%eax
  101123:	c1 e0 04             	shl    $0x4,%eax
  101126:	29 c1                	sub    %eax,%ecx
  101128:	89 ca                	mov    %ecx,%edx
  10112a:	89 d8                	mov    %ebx,%eax
  10112c:	29 d0                	sub    %edx,%eax
  10112e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101134:	eb 26                	jmp    10115c <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101136:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10113c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101143:	8d 50 01             	lea    0x1(%eax),%edx
  101146:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10114d:	0f b7 c0             	movzwl %ax,%eax
  101150:	01 c0                	add    %eax,%eax
  101152:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101155:	8b 45 08             	mov    0x8(%ebp),%eax
  101158:	66 89 02             	mov    %ax,(%edx)
        break;
  10115b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10115c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101163:	66 3d cf 07          	cmp    $0x7cf,%ax
  101167:	76 5b                	jbe    1011c4 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101169:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101174:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101179:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101180:	00 
  101181:	89 54 24 04          	mov    %edx,0x4(%esp)
  101185:	89 04 24             	mov    %eax,(%esp)
  101188:	e8 15 21 00 00       	call   1032a2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101194:	eb 15                	jmp    1011ab <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101196:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10119e:	01 d2                	add    %edx,%edx
  1011a0:	01 d0                	add    %edx,%eax
  1011a2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011ab:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b2:	7e e2                	jle    101196 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011bb:	83 e8 50             	sub    $0x50,%eax
  1011be:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011cb:	0f b7 c0             	movzwl %ax,%eax
  1011ce:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011d6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011da:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011de:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011df:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e6:	66 c1 e8 08          	shr    $0x8,%ax
  1011ea:	0f b6 c0             	movzbl %al,%eax
  1011ed:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f4:	83 c2 01             	add    $0x1,%edx
  1011f7:	0f b7 d2             	movzwl %dx,%edx
  1011fa:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011fe:	88 45 ed             	mov    %al,-0x13(%ebp)
  101201:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101205:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101209:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101211:	0f b7 c0             	movzwl %ax,%eax
  101214:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101218:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10121c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101220:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101224:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101225:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10122c:	0f b6 c0             	movzbl %al,%eax
  10122f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101236:	83 c2 01             	add    $0x1,%edx
  101239:	0f b7 d2             	movzwl %dx,%edx
  10123c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101240:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101243:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101247:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
}
  10124c:	83 c4 34             	add    $0x34,%esp
  10124f:	5b                   	pop    %ebx
  101250:	5d                   	pop    %ebp
  101251:	c3                   	ret    

00101252 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101252:	55                   	push   %ebp
  101253:	89 e5                	mov    %esp,%ebp
  101255:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10125f:	eb 09                	jmp    10126a <serial_putc_sub+0x18>
        delay();
  101261:	e8 4f fb ff ff       	call   100db5 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101270:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101274:	89 c2                	mov    %eax,%edx
  101276:	ec                   	in     (%dx),%al
  101277:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10127e:	0f b6 c0             	movzbl %al,%eax
  101281:	83 e0 20             	and    $0x20,%eax
  101284:	85 c0                	test   %eax,%eax
  101286:	75 09                	jne    101291 <serial_putc_sub+0x3f>
  101288:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10128f:	7e d0                	jle    101261 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101291:	8b 45 08             	mov    0x8(%ebp),%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10129d:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012a8:	ee                   	out    %al,(%dx)
}
  1012a9:	c9                   	leave  
  1012aa:	c3                   	ret    

001012ab <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012ab:	55                   	push   %ebp
  1012ac:	89 e5                	mov    %esp,%ebp
  1012ae:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b5:	74 0d                	je     1012c4 <serial_putc+0x19>
        serial_putc_sub(c);
  1012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ba:	89 04 24             	mov    %eax,(%esp)
  1012bd:	e8 90 ff ff ff       	call   101252 <serial_putc_sub>
  1012c2:	eb 24                	jmp    1012e8 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012cb:	e8 82 ff ff ff       	call   101252 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012d7:	e8 76 ff ff ff       	call   101252 <serial_putc_sub>
        serial_putc_sub('\b');
  1012dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e3:	e8 6a ff ff ff       	call   101252 <serial_putc_sub>
    }
}
  1012e8:	c9                   	leave  
  1012e9:	c3                   	ret    

001012ea <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
  1012ed:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f0:	eb 33                	jmp    101325 <cons_intr+0x3b>
        if (c != 0) {
  1012f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f6:	74 2d                	je     101325 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fd:	8d 50 01             	lea    0x1(%eax),%edx
  101300:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101309:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101314:	3d 00 02 00 00       	cmp    $0x200,%eax
  101319:	75 0a                	jne    101325 <cons_intr+0x3b>
                cons.wpos = 0;
  10131b:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101322:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101325:	8b 45 08             	mov    0x8(%ebp),%eax
  101328:	ff d0                	call   *%eax
  10132a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10132d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101331:	75 bf                	jne    1012f2 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101333:	c9                   	leave  
  101334:	c3                   	ret    

00101335 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101335:	55                   	push   %ebp
  101336:	89 e5                	mov    %esp,%ebp
  101338:	83 ec 10             	sub    $0x10,%esp
  10133b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101341:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101345:	89 c2                	mov    %eax,%edx
  101347:	ec                   	in     (%dx),%al
  101348:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10134b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134f:	0f b6 c0             	movzbl %al,%eax
  101352:	83 e0 01             	and    $0x1,%eax
  101355:	85 c0                	test   %eax,%eax
  101357:	75 07                	jne    101360 <serial_proc_data+0x2b>
        return -1;
  101359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135e:	eb 2a                	jmp    10138a <serial_proc_data+0x55>
  101360:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101366:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10136a:	89 c2                	mov    %eax,%edx
  10136c:	ec                   	in     (%dx),%al
  10136d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101370:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101374:	0f b6 c0             	movzbl %al,%eax
  101377:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10137a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137e:	75 07                	jne    101387 <serial_proc_data+0x52>
        c = '\b';
  101380:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10138a:	c9                   	leave  
  10138b:	c3                   	ret    

0010138c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10138c:	55                   	push   %ebp
  10138d:	89 e5                	mov    %esp,%ebp
  10138f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101392:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101397:	85 c0                	test   %eax,%eax
  101399:	74 0c                	je     1013a7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10139b:	c7 04 24 35 13 10 00 	movl   $0x101335,(%esp)
  1013a2:	e8 43 ff ff ff       	call   1012ea <cons_intr>
    }
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 38             	sub    $0x38,%esp
  1013af:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013b9:	89 c2                	mov    %eax,%edx
  1013bb:	ec                   	in     (%dx),%al
  1013bc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c3:	0f b6 c0             	movzbl %al,%eax
  1013c6:	83 e0 01             	and    $0x1,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	75 0a                	jne    1013d7 <kbd_proc_data+0x2e>
        return -1;
  1013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d2:	e9 59 01 00 00       	jmp    101530 <kbd_proc_data+0x187>
  1013d7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e1:	89 c2                	mov    %eax,%edx
  1013e3:	ec                   	in     (%dx),%al
  1013e4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013e7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013eb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013ee:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f2:	75 17                	jne    10140b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f9:	83 c8 40             	or     $0x40,%eax
  1013fc:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101401:	b8 00 00 00 00       	mov    $0x0,%eax
  101406:	e9 25 01 00 00       	jmp    101530 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10140b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140f:	84 c0                	test   %al,%al
  101411:	79 47                	jns    10145a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101413:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101418:	83 e0 40             	and    $0x40,%eax
  10141b:	85 c0                	test   %eax,%eax
  10141d:	75 09                	jne    101428 <kbd_proc_data+0x7f>
  10141f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101423:	83 e0 7f             	and    $0x7f,%eax
  101426:	eb 04                	jmp    10142c <kbd_proc_data+0x83>
  101428:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10142f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101433:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143a:	83 c8 40             	or     $0x40,%eax
  10143d:	0f b6 c0             	movzbl %al,%eax
  101440:	f7 d0                	not    %eax
  101442:	89 c2                	mov    %eax,%edx
  101444:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101449:	21 d0                	and    %edx,%eax
  10144b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101450:	b8 00 00 00 00       	mov    $0x0,%eax
  101455:	e9 d6 00 00 00       	jmp    101530 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10145a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145f:	83 e0 40             	and    $0x40,%eax
  101462:	85 c0                	test   %eax,%eax
  101464:	74 11                	je     101477 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101466:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146f:	83 e0 bf             	and    $0xffffffbf,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101482:	0f b6 d0             	movzbl %al,%edx
  101485:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148a:	09 d0                	or     %edx,%eax
  10148c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101495:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10149c:	0f b6 d0             	movzbl %al,%edx
  10149f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a4:	31 d0                	xor    %edx,%eax
  1014a6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ab:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b0:	83 e0 03             	and    $0x3,%eax
  1014b3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ba:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014be:	01 d0                	add    %edx,%eax
  1014c0:	0f b6 00             	movzbl (%eax),%eax
  1014c3:	0f b6 c0             	movzbl %al,%eax
  1014c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014c9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ce:	83 e0 08             	and    $0x8,%eax
  1014d1:	85 c0                	test   %eax,%eax
  1014d3:	74 22                	je     1014f7 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014d9:	7e 0c                	jle    1014e7 <kbd_proc_data+0x13e>
  1014db:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014df:	7f 06                	jg     1014e7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e5:	eb 10                	jmp    1014f7 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014e7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014eb:	7e 0a                	jle    1014f7 <kbd_proc_data+0x14e>
  1014ed:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f1:	7f 04                	jg     1014f7 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014f7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014fc:	f7 d0                	not    %eax
  1014fe:	83 e0 06             	and    $0x6,%eax
  101501:	85 c0                	test   %eax,%eax
  101503:	75 28                	jne    10152d <kbd_proc_data+0x184>
  101505:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10150c:	75 1f                	jne    10152d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10150e:	c7 04 24 1d 37 10 00 	movl   $0x10371d,(%esp)
  101515:	e8 f8 ed ff ff       	call   100312 <cprintf>
  10151a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101520:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101524:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101528:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10152c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101530:	c9                   	leave  
  101531:	c3                   	ret    

00101532 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101532:	55                   	push   %ebp
  101533:	89 e5                	mov    %esp,%ebp
  101535:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101538:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  10153f:	e8 a6 fd ff ff       	call   1012ea <cons_intr>
}
  101544:	c9                   	leave  
  101545:	c3                   	ret    

00101546 <kbd_init>:

static void
kbd_init(void) {
  101546:	55                   	push   %ebp
  101547:	89 e5                	mov    %esp,%ebp
  101549:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10154c:	e8 e1 ff ff ff       	call   101532 <kbd_intr>
    pic_enable(IRQ_KBD);
  101551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101558:	e8 17 01 00 00       	call   101674 <pic_enable>
}
  10155d:	c9                   	leave  
  10155e:	c3                   	ret    

0010155f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155f:	55                   	push   %ebp
  101560:	89 e5                	mov    %esp,%ebp
  101562:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101565:	e8 93 f8 ff ff       	call   100dfd <cga_init>
    serial_init();
  10156a:	e8 74 f9 ff ff       	call   100ee3 <serial_init>
    kbd_init();
  10156f:	e8 d2 ff ff ff       	call   101546 <kbd_init>
    if (!serial_exists) {
  101574:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101579:	85 c0                	test   %eax,%eax
  10157b:	75 0c                	jne    101589 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10157d:	c7 04 24 29 37 10 00 	movl   $0x103729,(%esp)
  101584:	e8 89 ed ff ff       	call   100312 <cprintf>
    }
}
  101589:	c9                   	leave  
  10158a:	c3                   	ret    

0010158b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158b:	55                   	push   %ebp
  10158c:	89 e5                	mov    %esp,%ebp
  10158e:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101591:	8b 45 08             	mov    0x8(%ebp),%eax
  101594:	89 04 24             	mov    %eax,(%esp)
  101597:	e8 a3 fa ff ff       	call   10103f <lpt_putc>
    cga_putc(c);
  10159c:	8b 45 08             	mov    0x8(%ebp),%eax
  10159f:	89 04 24             	mov    %eax,(%esp)
  1015a2:	e8 d7 fa ff ff       	call   10107e <cga_putc>
    serial_putc(c);
  1015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015aa:	89 04 24             	mov    %eax,(%esp)
  1015ad:	e8 f9 fc ff ff       	call   1012ab <serial_putc>
}
  1015b2:	c9                   	leave  
  1015b3:	c3                   	ret    

001015b4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015b4:	55                   	push   %ebp
  1015b5:	89 e5                	mov    %esp,%ebp
  1015b7:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ba:	e8 cd fd ff ff       	call   10138c <serial_intr>
    kbd_intr();
  1015bf:	e8 6e ff ff ff       	call   101532 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015c4:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ca:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015cf:	39 c2                	cmp    %eax,%edx
  1015d1:	74 36                	je     101609 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d3:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d8:	8d 50 01             	lea    0x1(%eax),%edx
  1015db:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e1:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e8:	0f b6 c0             	movzbl %al,%eax
  1015eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015ee:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f8:	75 0a                	jne    101604 <cons_getc+0x50>
            cons.rpos = 0;
  1015fa:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101601:	00 00 00 
        }
        return c;
  101604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101607:	eb 05                	jmp    10160e <cons_getc+0x5a>
    }
    return 0;
  101609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10160e:	c9                   	leave  
  10160f:	c3                   	ret    

00101610 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101613:	fb                   	sti    
    sti();
}
  101614:	5d                   	pop    %ebp
  101615:	c3                   	ret    

00101616 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101619:	fa                   	cli    
    cli();
}
  10161a:	5d                   	pop    %ebp
  10161b:	c3                   	ret    

0010161c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10161c:	55                   	push   %ebp
  10161d:	89 e5                	mov    %esp,%ebp
  10161f:	83 ec 14             	sub    $0x14,%esp
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101629:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162d:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101633:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101638:	85 c0                	test   %eax,%eax
  10163a:	74 36                	je     101672 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10163c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101640:	0f b6 c0             	movzbl %al,%eax
  101643:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101649:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10164c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101650:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101654:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101655:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101659:	66 c1 e8 08          	shr    $0x8,%ax
  10165d:	0f b6 c0             	movzbl %al,%eax
  101660:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101666:	88 45 f9             	mov    %al,-0x7(%ebp)
  101669:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10166d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101671:	ee                   	out    %al,(%dx)
    }
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
  101677:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10167a:	8b 45 08             	mov    0x8(%ebp),%eax
  10167d:	ba 01 00 00 00       	mov    $0x1,%edx
  101682:	89 c1                	mov    %eax,%ecx
  101684:	d3 e2                	shl    %cl,%edx
  101686:	89 d0                	mov    %edx,%eax
  101688:	f7 d0                	not    %eax
  10168a:	89 c2                	mov    %eax,%edx
  10168c:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101693:	21 d0                	and    %edx,%eax
  101695:	0f b7 c0             	movzwl %ax,%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 7c ff ff ff       	call   10161c <pic_setmask>
}
  1016a0:	c9                   	leave  
  1016a1:	c3                   	ret    

001016a2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
  1016a5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016a8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016af:	00 00 00 
  1016b2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b8:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016bc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c4:	ee                   	out    %al,(%dx)
  1016c5:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016cb:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d7:	ee                   	out    %al,(%dx)
  1016d8:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016de:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016e6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
  1016eb:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016f1:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016f5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016f9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016fd:	ee                   	out    %al,(%dx)
  1016fe:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101704:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101708:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10170c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101710:	ee                   	out    %al,(%dx)
  101711:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101717:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10171b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10171f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101723:	ee                   	out    %al,(%dx)
  101724:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10172a:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10172e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101732:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101736:	ee                   	out    %al,(%dx)
  101737:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10173d:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101741:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101745:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101749:	ee                   	out    %al,(%dx)
  10174a:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101750:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101754:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101758:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10175c:	ee                   	out    %al,(%dx)
  10175d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101763:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101767:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10176b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
  101770:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101776:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10177a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10177e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101789:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10178d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101791:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10179c:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017a0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017a4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017af:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017b3:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017b7:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017bc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c3:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c7:	74 12                	je     1017db <pic_init+0x139>
        pic_setmask(irq_mask);
  1017c9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d0:	0f b7 c0             	movzwl %ax,%eax
  1017d3:	89 04 24             	mov    %eax,(%esp)
  1017d6:	e8 41 fe ff ff       	call   10161c <pic_setmask>
    }
}
  1017db:	c9                   	leave  
  1017dc:	c3                   	ret    

001017dd <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
  1017e0:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e3:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017ea:	00 
  1017eb:	c7 04 24 60 37 10 00 	movl   $0x103760,(%esp)
  1017f2:	e8 1b eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017f7:	c9                   	leave  
  1017f8:	c3                   	ret    

001017f9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f9:	55                   	push   %ebp
  1017fa:	89 e5                	mov    %esp,%ebp
  1017fc:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1017ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101806:	e9 c3 00 00 00       	jmp    1018ce <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180e:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101815:	89 c2                	mov    %eax,%edx
  101817:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181a:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101821:	00 
  101822:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101825:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10182c:	00 08 00 
  10182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101832:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101839:	00 
  10183a:	83 e2 e0             	and    $0xffffffe0,%edx
  10183d:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101844:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101847:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10184e:	00 
  10184f:	83 e2 1f             	and    $0x1f,%edx
  101852:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101863:	00 
  101864:	83 e2 f0             	and    $0xfffffff0,%edx
  101867:	83 ca 0e             	or     $0xe,%edx
  10186a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101874:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10187b:	00 
  10187c:	83 e2 ef             	and    $0xffffffef,%edx
  10187f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101886:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101889:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101890:	00 
  101891:	83 e2 9f             	and    $0xffffff9f,%edx
  101894:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189e:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a5:	00 
  1018a6:	83 ca 80             	or     $0xffffff80,%edx
  1018a9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ba:	c1 e8 10             	shr    $0x10,%eax
  1018bd:	89 c2                	mov    %eax,%edx
  1018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018c9:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018d6:	0f 86 2f ff ff ff    	jbe    10180b <idt_init+0x12>
  1018dc:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1018e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018e6:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
  1018e9:	c9                   	leave  
  1018ea:	c3                   	ret    

001018eb <trapname>:

static const char *
trapname(int trapno) {
  1018eb:	55                   	push   %ebp
  1018ec:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f1:	83 f8 13             	cmp    $0x13,%eax
  1018f4:	77 0c                	ja     101902 <trapname+0x17>
        return excnames[trapno];
  1018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f9:	8b 04 85 c0 3a 10 00 	mov    0x103ac0(,%eax,4),%eax
  101900:	eb 18                	jmp    10191a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101902:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101906:	7e 0d                	jle    101915 <trapname+0x2a>
  101908:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10190c:	7f 07                	jg     101915 <trapname+0x2a>
        return "Hardware Interrupt";
  10190e:	b8 6a 37 10 00       	mov    $0x10376a,%eax
  101913:	eb 05                	jmp    10191a <trapname+0x2f>
    }
    return "(unknown trap)";
  101915:	b8 7d 37 10 00       	mov    $0x10377d,%eax
}
  10191a:	5d                   	pop    %ebp
  10191b:	c3                   	ret    

0010191c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10191c:	55                   	push   %ebp
  10191d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10191f:	8b 45 08             	mov    0x8(%ebp),%eax
  101922:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101926:	66 83 f8 08          	cmp    $0x8,%ax
  10192a:	0f 94 c0             	sete   %al
  10192d:	0f b6 c0             	movzbl %al,%eax
}
  101930:	5d                   	pop    %ebp
  101931:	c3                   	ret    

00101932 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101932:	55                   	push   %ebp
  101933:	89 e5                	mov    %esp,%ebp
  101935:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101938:	8b 45 08             	mov    0x8(%ebp),%eax
  10193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10193f:	c7 04 24 be 37 10 00 	movl   $0x1037be,(%esp)
  101946:	e8 c7 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  10194b:	8b 45 08             	mov    0x8(%ebp),%eax
  10194e:	89 04 24             	mov    %eax,(%esp)
  101951:	e8 a1 01 00 00       	call   101af7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10195d:	0f b7 c0             	movzwl %ax,%eax
  101960:	89 44 24 04          	mov    %eax,0x4(%esp)
  101964:	c7 04 24 cf 37 10 00 	movl   $0x1037cf,(%esp)
  10196b:	e8 a2 e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101970:	8b 45 08             	mov    0x8(%ebp),%eax
  101973:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101977:	0f b7 c0             	movzwl %ax,%eax
  10197a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10197e:	c7 04 24 e2 37 10 00 	movl   $0x1037e2,(%esp)
  101985:	e8 88 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10198a:	8b 45 08             	mov    0x8(%ebp),%eax
  10198d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101991:	0f b7 c0             	movzwl %ax,%eax
  101994:	89 44 24 04          	mov    %eax,0x4(%esp)
  101998:	c7 04 24 f5 37 10 00 	movl   $0x1037f5,(%esp)
  10199f:	e8 6e e9 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a7:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019ab:	0f b7 c0             	movzwl %ax,%eax
  1019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b2:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  1019b9:	e8 54 e9 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019be:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c1:	8b 40 30             	mov    0x30(%eax),%eax
  1019c4:	89 04 24             	mov    %eax,(%esp)
  1019c7:	e8 1f ff ff ff       	call   1018eb <trapname>
  1019cc:	8b 55 08             	mov    0x8(%ebp),%edx
  1019cf:	8b 52 30             	mov    0x30(%edx),%edx
  1019d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1019d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1019da:	c7 04 24 1b 38 10 00 	movl   $0x10381b,(%esp)
  1019e1:	e8 2c e9 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e9:	8b 40 34             	mov    0x34(%eax),%eax
  1019ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f0:	c7 04 24 2d 38 10 00 	movl   $0x10382d,(%esp)
  1019f7:	e8 16 e9 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ff:	8b 40 38             	mov    0x38(%eax),%eax
  101a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a06:	c7 04 24 3c 38 10 00 	movl   $0x10383c,(%esp)
  101a0d:	e8 00 e9 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a12:	8b 45 08             	mov    0x8(%ebp),%eax
  101a15:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a19:	0f b7 c0             	movzwl %ax,%eax
  101a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a20:	c7 04 24 4b 38 10 00 	movl   $0x10384b,(%esp)
  101a27:	e8 e6 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	8b 40 40             	mov    0x40(%eax),%eax
  101a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a36:	c7 04 24 5e 38 10 00 	movl   $0x10385e,(%esp)
  101a3d:	e8 d0 e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a49:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a50:	eb 3e                	jmp    101a90 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	8b 50 40             	mov    0x40(%eax),%edx
  101a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a5b:	21 d0                	and    %edx,%eax
  101a5d:	85 c0                	test   %eax,%eax
  101a5f:	74 28                	je     101a89 <print_trapframe+0x157>
  101a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a64:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a6b:	85 c0                	test   %eax,%eax
  101a6d:	74 1a                	je     101a89 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a72:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 6d 38 10 00 	movl   $0x10386d,(%esp)
  101a84:	e8 89 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101a8d:	d1 65 f0             	shll   -0x10(%ebp)
  101a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a93:	83 f8 17             	cmp    $0x17,%eax
  101a96:	76 ba                	jbe    101a52 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	8b 40 40             	mov    0x40(%eax),%eax
  101a9e:	25 00 30 00 00       	and    $0x3000,%eax
  101aa3:	c1 e8 0c             	shr    $0xc,%eax
  101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aaa:	c7 04 24 71 38 10 00 	movl   $0x103871,(%esp)
  101ab1:	e8 5c e8 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	89 04 24             	mov    %eax,(%esp)
  101abc:	e8 5b fe ff ff       	call   10191c <trap_in_kernel>
  101ac1:	85 c0                	test   %eax,%eax
  101ac3:	75 30                	jne    101af5 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 40 44             	mov    0x44(%eax),%eax
  101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acf:	c7 04 24 7a 38 10 00 	movl   $0x10387a,(%esp)
  101ad6:	e8 37 e8 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101adb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ade:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ae2:	0f b7 c0             	movzwl %ax,%eax
  101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae9:	c7 04 24 89 38 10 00 	movl   $0x103889,(%esp)
  101af0:	e8 1d e8 ff ff       	call   100312 <cprintf>
    }
}
  101af5:	c9                   	leave  
  101af6:	c3                   	ret    

00101af7 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101af7:	55                   	push   %ebp
  101af8:	89 e5                	mov    %esp,%ebp
  101afa:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101afd:	8b 45 08             	mov    0x8(%ebp),%eax
  101b00:	8b 00                	mov    (%eax),%eax
  101b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b06:	c7 04 24 9c 38 10 00 	movl   $0x10389c,(%esp)
  101b0d:	e8 00 e8 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b12:	8b 45 08             	mov    0x8(%ebp),%eax
  101b15:	8b 40 04             	mov    0x4(%eax),%eax
  101b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1c:	c7 04 24 ab 38 10 00 	movl   $0x1038ab,(%esp)
  101b23:	e8 ea e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	8b 40 08             	mov    0x8(%eax),%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 ba 38 10 00 	movl   $0x1038ba,(%esp)
  101b39:	e8 d4 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 0c             	mov    0xc(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 c9 38 10 00 	movl   $0x1038c9,(%esp)
  101b4f:	e8 be e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	8b 40 10             	mov    0x10(%eax),%eax
  101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5e:	c7 04 24 d8 38 10 00 	movl   $0x1038d8,(%esp)
  101b65:	e8 a8 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	8b 40 14             	mov    0x14(%eax),%eax
  101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b74:	c7 04 24 e7 38 10 00 	movl   $0x1038e7,(%esp)
  101b7b:	e8 92 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b80:	8b 45 08             	mov    0x8(%ebp),%eax
  101b83:	8b 40 18             	mov    0x18(%eax),%eax
  101b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8a:	c7 04 24 f6 38 10 00 	movl   $0x1038f6,(%esp)
  101b91:	e8 7c e7 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba0:	c7 04 24 05 39 10 00 	movl   $0x103905,(%esp)
  101ba7:	e8 66 e7 ff ff       	call   100312 <cprintf>
}
  101bac:	c9                   	leave  
  101bad:	c3                   	ret    

00101bae <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bae:	55                   	push   %ebp
  101baf:	89 e5                	mov    %esp,%ebp
  101bb1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 30             	mov    0x30(%eax),%eax
  101bba:	83 f8 2f             	cmp    $0x2f,%eax
  101bbd:	77 21                	ja     101be0 <trap_dispatch+0x32>
  101bbf:	83 f8 2e             	cmp    $0x2e,%eax
  101bc2:	0f 83 04 01 00 00    	jae    101ccc <trap_dispatch+0x11e>
  101bc8:	83 f8 21             	cmp    $0x21,%eax
  101bcb:	0f 84 81 00 00 00    	je     101c52 <trap_dispatch+0xa4>
  101bd1:	83 f8 24             	cmp    $0x24,%eax
  101bd4:	74 56                	je     101c2c <trap_dispatch+0x7e>
  101bd6:	83 f8 20             	cmp    $0x20,%eax
  101bd9:	74 16                	je     101bf1 <trap_dispatch+0x43>
  101bdb:	e9 b4 00 00 00       	jmp    101c94 <trap_dispatch+0xe6>
  101be0:	83 e8 78             	sub    $0x78,%eax
  101be3:	83 f8 01             	cmp    $0x1,%eax
  101be6:	0f 87 a8 00 00 00    	ja     101c94 <trap_dispatch+0xe6>
  101bec:	e9 87 00 00 00       	jmp    101c78 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
  101bf1:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101bf6:	83 c0 01             	add    $0x1,%eax
  101bf9:	a3 08 f9 10 00       	mov    %eax,0x10f908
		if (ticks%TICK_NUM==0) {
  101bfe:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c04:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c09:	89 c8                	mov    %ecx,%eax
  101c0b:	f7 e2                	mul    %edx
  101c0d:	89 d0                	mov    %edx,%eax
  101c0f:	c1 e8 05             	shr    $0x5,%eax
  101c12:	6b c0 64             	imul   $0x64,%eax,%eax
  101c15:	29 c1                	sub    %eax,%ecx
  101c17:	89 c8                	mov    %ecx,%eax
  101c19:	85 c0                	test   %eax,%eax
  101c1b:	75 0a                	jne    101c27 <trap_dispatch+0x79>
            print_ticks();
  101c1d:	e8 bb fb ff ff       	call   1017dd <print_ticks>
        }
        break;
  101c22:	e9 a6 00 00 00       	jmp    101ccd <trap_dispatch+0x11f>
  101c27:	e9 a1 00 00 00       	jmp    101ccd <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c2c:	e8 83 f9 ff ff       	call   1015b4 <cons_getc>
  101c31:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c34:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c38:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 14 39 10 00 	movl   $0x103914,(%esp)
  101c4b:	e8 c2 e6 ff ff       	call   100312 <cprintf>
        break;
  101c50:	eb 7b                	jmp    101ccd <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c52:	e8 5d f9 ff ff       	call   1015b4 <cons_getc>
  101c57:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c5a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c5e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c62:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6a:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  101c71:	e8 9c e6 ff ff       	call   100312 <cprintf>
        break;
  101c76:	eb 55                	jmp    101ccd <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c78:	c7 44 24 08 35 39 10 	movl   $0x103935,0x8(%esp)
  101c7f:	00 
  101c80:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101c87:	00 
  101c88:	c7 04 24 45 39 10 00 	movl   $0x103945,(%esp)
  101c8f:	e8 02 f0 ff ff       	call   100c96 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c9b:	0f b7 c0             	movzwl %ax,%eax
  101c9e:	83 e0 03             	and    $0x3,%eax
  101ca1:	85 c0                	test   %eax,%eax
  101ca3:	75 28                	jne    101ccd <trap_dispatch+0x11f>
            print_trapframe(tf);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	89 04 24             	mov    %eax,(%esp)
  101cab:	e8 82 fc ff ff       	call   101932 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101cb0:	c7 44 24 08 56 39 10 	movl   $0x103956,0x8(%esp)
  101cb7:	00 
  101cb8:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101cbf:	00 
  101cc0:	c7 04 24 45 39 10 00 	movl   $0x103945,(%esp)
  101cc7:	e8 ca ef ff ff       	call   100c96 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ccc:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ccd:	c9                   	leave  
  101cce:	c3                   	ret    

00101ccf <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ccf:	55                   	push   %ebp
  101cd0:	89 e5                	mov    %esp,%ebp
  101cd2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd8:	89 04 24             	mov    %eax,(%esp)
  101cdb:	e8 ce fe ff ff       	call   101bae <trap_dispatch>
}
  101ce0:	c9                   	leave  
  101ce1:	c3                   	ret    

00101ce2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ce2:	1e                   	push   %ds
    pushl %es
  101ce3:	06                   	push   %es
    pushl %fs
  101ce4:	0f a0                	push   %fs
    pushl %gs
  101ce6:	0f a8                	push   %gs
    pushal
  101ce8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ce9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101cee:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101cf0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101cf2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101cf3:	e8 d7 ff ff ff       	call   101ccf <trap>

    # pop the pushed stack pointer
    popl %esp
  101cf8:	5c                   	pop    %esp

00101cf9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101cf9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101cfa:	0f a9                	pop    %gs
    popl %fs
  101cfc:	0f a1                	pop    %fs
    popl %es
  101cfe:	07                   	pop    %es
    popl %ds
  101cff:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d00:	83 c4 08             	add    $0x8,%esp
    iret
  101d03:	cf                   	iret   

00101d04 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d04:	6a 00                	push   $0x0
  pushl $0
  101d06:	6a 00                	push   $0x0
  jmp __alltraps
  101d08:	e9 d5 ff ff ff       	jmp    101ce2 <__alltraps>

00101d0d <vector1>:
.globl vector1
vector1:
  pushl $0
  101d0d:	6a 00                	push   $0x0
  pushl $1
  101d0f:	6a 01                	push   $0x1
  jmp __alltraps
  101d11:	e9 cc ff ff ff       	jmp    101ce2 <__alltraps>

00101d16 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d16:	6a 00                	push   $0x0
  pushl $2
  101d18:	6a 02                	push   $0x2
  jmp __alltraps
  101d1a:	e9 c3 ff ff ff       	jmp    101ce2 <__alltraps>

00101d1f <vector3>:
.globl vector3
vector3:
  pushl $0
  101d1f:	6a 00                	push   $0x0
  pushl $3
  101d21:	6a 03                	push   $0x3
  jmp __alltraps
  101d23:	e9 ba ff ff ff       	jmp    101ce2 <__alltraps>

00101d28 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d28:	6a 00                	push   $0x0
  pushl $4
  101d2a:	6a 04                	push   $0x4
  jmp __alltraps
  101d2c:	e9 b1 ff ff ff       	jmp    101ce2 <__alltraps>

00101d31 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d31:	6a 00                	push   $0x0
  pushl $5
  101d33:	6a 05                	push   $0x5
  jmp __alltraps
  101d35:	e9 a8 ff ff ff       	jmp    101ce2 <__alltraps>

00101d3a <vector6>:
.globl vector6
vector6:
  pushl $0
  101d3a:	6a 00                	push   $0x0
  pushl $6
  101d3c:	6a 06                	push   $0x6
  jmp __alltraps
  101d3e:	e9 9f ff ff ff       	jmp    101ce2 <__alltraps>

00101d43 <vector7>:
.globl vector7
vector7:
  pushl $0
  101d43:	6a 00                	push   $0x0
  pushl $7
  101d45:	6a 07                	push   $0x7
  jmp __alltraps
  101d47:	e9 96 ff ff ff       	jmp    101ce2 <__alltraps>

00101d4c <vector8>:
.globl vector8
vector8:
  pushl $8
  101d4c:	6a 08                	push   $0x8
  jmp __alltraps
  101d4e:	e9 8f ff ff ff       	jmp    101ce2 <__alltraps>

00101d53 <vector9>:
.globl vector9
vector9:
  pushl $9
  101d53:	6a 09                	push   $0x9
  jmp __alltraps
  101d55:	e9 88 ff ff ff       	jmp    101ce2 <__alltraps>

00101d5a <vector10>:
.globl vector10
vector10:
  pushl $10
  101d5a:	6a 0a                	push   $0xa
  jmp __alltraps
  101d5c:	e9 81 ff ff ff       	jmp    101ce2 <__alltraps>

00101d61 <vector11>:
.globl vector11
vector11:
  pushl $11
  101d61:	6a 0b                	push   $0xb
  jmp __alltraps
  101d63:	e9 7a ff ff ff       	jmp    101ce2 <__alltraps>

00101d68 <vector12>:
.globl vector12
vector12:
  pushl $12
  101d68:	6a 0c                	push   $0xc
  jmp __alltraps
  101d6a:	e9 73 ff ff ff       	jmp    101ce2 <__alltraps>

00101d6f <vector13>:
.globl vector13
vector13:
  pushl $13
  101d6f:	6a 0d                	push   $0xd
  jmp __alltraps
  101d71:	e9 6c ff ff ff       	jmp    101ce2 <__alltraps>

00101d76 <vector14>:
.globl vector14
vector14:
  pushl $14
  101d76:	6a 0e                	push   $0xe
  jmp __alltraps
  101d78:	e9 65 ff ff ff       	jmp    101ce2 <__alltraps>

00101d7d <vector15>:
.globl vector15
vector15:
  pushl $0
  101d7d:	6a 00                	push   $0x0
  pushl $15
  101d7f:	6a 0f                	push   $0xf
  jmp __alltraps
  101d81:	e9 5c ff ff ff       	jmp    101ce2 <__alltraps>

00101d86 <vector16>:
.globl vector16
vector16:
  pushl $0
  101d86:	6a 00                	push   $0x0
  pushl $16
  101d88:	6a 10                	push   $0x10
  jmp __alltraps
  101d8a:	e9 53 ff ff ff       	jmp    101ce2 <__alltraps>

00101d8f <vector17>:
.globl vector17
vector17:
  pushl $17
  101d8f:	6a 11                	push   $0x11
  jmp __alltraps
  101d91:	e9 4c ff ff ff       	jmp    101ce2 <__alltraps>

00101d96 <vector18>:
.globl vector18
vector18:
  pushl $0
  101d96:	6a 00                	push   $0x0
  pushl $18
  101d98:	6a 12                	push   $0x12
  jmp __alltraps
  101d9a:	e9 43 ff ff ff       	jmp    101ce2 <__alltraps>

00101d9f <vector19>:
.globl vector19
vector19:
  pushl $0
  101d9f:	6a 00                	push   $0x0
  pushl $19
  101da1:	6a 13                	push   $0x13
  jmp __alltraps
  101da3:	e9 3a ff ff ff       	jmp    101ce2 <__alltraps>

00101da8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101da8:	6a 00                	push   $0x0
  pushl $20
  101daa:	6a 14                	push   $0x14
  jmp __alltraps
  101dac:	e9 31 ff ff ff       	jmp    101ce2 <__alltraps>

00101db1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101db1:	6a 00                	push   $0x0
  pushl $21
  101db3:	6a 15                	push   $0x15
  jmp __alltraps
  101db5:	e9 28 ff ff ff       	jmp    101ce2 <__alltraps>

00101dba <vector22>:
.globl vector22
vector22:
  pushl $0
  101dba:	6a 00                	push   $0x0
  pushl $22
  101dbc:	6a 16                	push   $0x16
  jmp __alltraps
  101dbe:	e9 1f ff ff ff       	jmp    101ce2 <__alltraps>

00101dc3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101dc3:	6a 00                	push   $0x0
  pushl $23
  101dc5:	6a 17                	push   $0x17
  jmp __alltraps
  101dc7:	e9 16 ff ff ff       	jmp    101ce2 <__alltraps>

00101dcc <vector24>:
.globl vector24
vector24:
  pushl $0
  101dcc:	6a 00                	push   $0x0
  pushl $24
  101dce:	6a 18                	push   $0x18
  jmp __alltraps
  101dd0:	e9 0d ff ff ff       	jmp    101ce2 <__alltraps>

00101dd5 <vector25>:
.globl vector25
vector25:
  pushl $0
  101dd5:	6a 00                	push   $0x0
  pushl $25
  101dd7:	6a 19                	push   $0x19
  jmp __alltraps
  101dd9:	e9 04 ff ff ff       	jmp    101ce2 <__alltraps>

00101dde <vector26>:
.globl vector26
vector26:
  pushl $0
  101dde:	6a 00                	push   $0x0
  pushl $26
  101de0:	6a 1a                	push   $0x1a
  jmp __alltraps
  101de2:	e9 fb fe ff ff       	jmp    101ce2 <__alltraps>

00101de7 <vector27>:
.globl vector27
vector27:
  pushl $0
  101de7:	6a 00                	push   $0x0
  pushl $27
  101de9:	6a 1b                	push   $0x1b
  jmp __alltraps
  101deb:	e9 f2 fe ff ff       	jmp    101ce2 <__alltraps>

00101df0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $28
  101df2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101df4:	e9 e9 fe ff ff       	jmp    101ce2 <__alltraps>

00101df9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $29
  101dfb:	6a 1d                	push   $0x1d
  jmp __alltraps
  101dfd:	e9 e0 fe ff ff       	jmp    101ce2 <__alltraps>

00101e02 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $30
  101e04:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e06:	e9 d7 fe ff ff       	jmp    101ce2 <__alltraps>

00101e0b <vector31>:
.globl vector31
vector31:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $31
  101e0d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e0f:	e9 ce fe ff ff       	jmp    101ce2 <__alltraps>

00101e14 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $32
  101e16:	6a 20                	push   $0x20
  jmp __alltraps
  101e18:	e9 c5 fe ff ff       	jmp    101ce2 <__alltraps>

00101e1d <vector33>:
.globl vector33
vector33:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $33
  101e1f:	6a 21                	push   $0x21
  jmp __alltraps
  101e21:	e9 bc fe ff ff       	jmp    101ce2 <__alltraps>

00101e26 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $34
  101e28:	6a 22                	push   $0x22
  jmp __alltraps
  101e2a:	e9 b3 fe ff ff       	jmp    101ce2 <__alltraps>

00101e2f <vector35>:
.globl vector35
vector35:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $35
  101e31:	6a 23                	push   $0x23
  jmp __alltraps
  101e33:	e9 aa fe ff ff       	jmp    101ce2 <__alltraps>

00101e38 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $36
  101e3a:	6a 24                	push   $0x24
  jmp __alltraps
  101e3c:	e9 a1 fe ff ff       	jmp    101ce2 <__alltraps>

00101e41 <vector37>:
.globl vector37
vector37:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $37
  101e43:	6a 25                	push   $0x25
  jmp __alltraps
  101e45:	e9 98 fe ff ff       	jmp    101ce2 <__alltraps>

00101e4a <vector38>:
.globl vector38
vector38:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $38
  101e4c:	6a 26                	push   $0x26
  jmp __alltraps
  101e4e:	e9 8f fe ff ff       	jmp    101ce2 <__alltraps>

00101e53 <vector39>:
.globl vector39
vector39:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $39
  101e55:	6a 27                	push   $0x27
  jmp __alltraps
  101e57:	e9 86 fe ff ff       	jmp    101ce2 <__alltraps>

00101e5c <vector40>:
.globl vector40
vector40:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $40
  101e5e:	6a 28                	push   $0x28
  jmp __alltraps
  101e60:	e9 7d fe ff ff       	jmp    101ce2 <__alltraps>

00101e65 <vector41>:
.globl vector41
vector41:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $41
  101e67:	6a 29                	push   $0x29
  jmp __alltraps
  101e69:	e9 74 fe ff ff       	jmp    101ce2 <__alltraps>

00101e6e <vector42>:
.globl vector42
vector42:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $42
  101e70:	6a 2a                	push   $0x2a
  jmp __alltraps
  101e72:	e9 6b fe ff ff       	jmp    101ce2 <__alltraps>

00101e77 <vector43>:
.globl vector43
vector43:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $43
  101e79:	6a 2b                	push   $0x2b
  jmp __alltraps
  101e7b:	e9 62 fe ff ff       	jmp    101ce2 <__alltraps>

00101e80 <vector44>:
.globl vector44
vector44:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $44
  101e82:	6a 2c                	push   $0x2c
  jmp __alltraps
  101e84:	e9 59 fe ff ff       	jmp    101ce2 <__alltraps>

00101e89 <vector45>:
.globl vector45
vector45:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $45
  101e8b:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e8d:	e9 50 fe ff ff       	jmp    101ce2 <__alltraps>

00101e92 <vector46>:
.globl vector46
vector46:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $46
  101e94:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e96:	e9 47 fe ff ff       	jmp    101ce2 <__alltraps>

00101e9b <vector47>:
.globl vector47
vector47:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $47
  101e9d:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e9f:	e9 3e fe ff ff       	jmp    101ce2 <__alltraps>

00101ea4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $48
  101ea6:	6a 30                	push   $0x30
  jmp __alltraps
  101ea8:	e9 35 fe ff ff       	jmp    101ce2 <__alltraps>

00101ead <vector49>:
.globl vector49
vector49:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $49
  101eaf:	6a 31                	push   $0x31
  jmp __alltraps
  101eb1:	e9 2c fe ff ff       	jmp    101ce2 <__alltraps>

00101eb6 <vector50>:
.globl vector50
vector50:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $50
  101eb8:	6a 32                	push   $0x32
  jmp __alltraps
  101eba:	e9 23 fe ff ff       	jmp    101ce2 <__alltraps>

00101ebf <vector51>:
.globl vector51
vector51:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $51
  101ec1:	6a 33                	push   $0x33
  jmp __alltraps
  101ec3:	e9 1a fe ff ff       	jmp    101ce2 <__alltraps>

00101ec8 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $52
  101eca:	6a 34                	push   $0x34
  jmp __alltraps
  101ecc:	e9 11 fe ff ff       	jmp    101ce2 <__alltraps>

00101ed1 <vector53>:
.globl vector53
vector53:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $53
  101ed3:	6a 35                	push   $0x35
  jmp __alltraps
  101ed5:	e9 08 fe ff ff       	jmp    101ce2 <__alltraps>

00101eda <vector54>:
.globl vector54
vector54:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $54
  101edc:	6a 36                	push   $0x36
  jmp __alltraps
  101ede:	e9 ff fd ff ff       	jmp    101ce2 <__alltraps>

00101ee3 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $55
  101ee5:	6a 37                	push   $0x37
  jmp __alltraps
  101ee7:	e9 f6 fd ff ff       	jmp    101ce2 <__alltraps>

00101eec <vector56>:
.globl vector56
vector56:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $56
  101eee:	6a 38                	push   $0x38
  jmp __alltraps
  101ef0:	e9 ed fd ff ff       	jmp    101ce2 <__alltraps>

00101ef5 <vector57>:
.globl vector57
vector57:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $57
  101ef7:	6a 39                	push   $0x39
  jmp __alltraps
  101ef9:	e9 e4 fd ff ff       	jmp    101ce2 <__alltraps>

00101efe <vector58>:
.globl vector58
vector58:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $58
  101f00:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f02:	e9 db fd ff ff       	jmp    101ce2 <__alltraps>

00101f07 <vector59>:
.globl vector59
vector59:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $59
  101f09:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f0b:	e9 d2 fd ff ff       	jmp    101ce2 <__alltraps>

00101f10 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $60
  101f12:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f14:	e9 c9 fd ff ff       	jmp    101ce2 <__alltraps>

00101f19 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $61
  101f1b:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f1d:	e9 c0 fd ff ff       	jmp    101ce2 <__alltraps>

00101f22 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $62
  101f24:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f26:	e9 b7 fd ff ff       	jmp    101ce2 <__alltraps>

00101f2b <vector63>:
.globl vector63
vector63:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $63
  101f2d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f2f:	e9 ae fd ff ff       	jmp    101ce2 <__alltraps>

00101f34 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $64
  101f36:	6a 40                	push   $0x40
  jmp __alltraps
  101f38:	e9 a5 fd ff ff       	jmp    101ce2 <__alltraps>

00101f3d <vector65>:
.globl vector65
vector65:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $65
  101f3f:	6a 41                	push   $0x41
  jmp __alltraps
  101f41:	e9 9c fd ff ff       	jmp    101ce2 <__alltraps>

00101f46 <vector66>:
.globl vector66
vector66:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $66
  101f48:	6a 42                	push   $0x42
  jmp __alltraps
  101f4a:	e9 93 fd ff ff       	jmp    101ce2 <__alltraps>

00101f4f <vector67>:
.globl vector67
vector67:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $67
  101f51:	6a 43                	push   $0x43
  jmp __alltraps
  101f53:	e9 8a fd ff ff       	jmp    101ce2 <__alltraps>

00101f58 <vector68>:
.globl vector68
vector68:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $68
  101f5a:	6a 44                	push   $0x44
  jmp __alltraps
  101f5c:	e9 81 fd ff ff       	jmp    101ce2 <__alltraps>

00101f61 <vector69>:
.globl vector69
vector69:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $69
  101f63:	6a 45                	push   $0x45
  jmp __alltraps
  101f65:	e9 78 fd ff ff       	jmp    101ce2 <__alltraps>

00101f6a <vector70>:
.globl vector70
vector70:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $70
  101f6c:	6a 46                	push   $0x46
  jmp __alltraps
  101f6e:	e9 6f fd ff ff       	jmp    101ce2 <__alltraps>

00101f73 <vector71>:
.globl vector71
vector71:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $71
  101f75:	6a 47                	push   $0x47
  jmp __alltraps
  101f77:	e9 66 fd ff ff       	jmp    101ce2 <__alltraps>

00101f7c <vector72>:
.globl vector72
vector72:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $72
  101f7e:	6a 48                	push   $0x48
  jmp __alltraps
  101f80:	e9 5d fd ff ff       	jmp    101ce2 <__alltraps>

00101f85 <vector73>:
.globl vector73
vector73:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $73
  101f87:	6a 49                	push   $0x49
  jmp __alltraps
  101f89:	e9 54 fd ff ff       	jmp    101ce2 <__alltraps>

00101f8e <vector74>:
.globl vector74
vector74:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $74
  101f90:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f92:	e9 4b fd ff ff       	jmp    101ce2 <__alltraps>

00101f97 <vector75>:
.globl vector75
vector75:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $75
  101f99:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f9b:	e9 42 fd ff ff       	jmp    101ce2 <__alltraps>

00101fa0 <vector76>:
.globl vector76
vector76:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $76
  101fa2:	6a 4c                	push   $0x4c
  jmp __alltraps
  101fa4:	e9 39 fd ff ff       	jmp    101ce2 <__alltraps>

00101fa9 <vector77>:
.globl vector77
vector77:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $77
  101fab:	6a 4d                	push   $0x4d
  jmp __alltraps
  101fad:	e9 30 fd ff ff       	jmp    101ce2 <__alltraps>

00101fb2 <vector78>:
.globl vector78
vector78:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $78
  101fb4:	6a 4e                	push   $0x4e
  jmp __alltraps
  101fb6:	e9 27 fd ff ff       	jmp    101ce2 <__alltraps>

00101fbb <vector79>:
.globl vector79
vector79:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $79
  101fbd:	6a 4f                	push   $0x4f
  jmp __alltraps
  101fbf:	e9 1e fd ff ff       	jmp    101ce2 <__alltraps>

00101fc4 <vector80>:
.globl vector80
vector80:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $80
  101fc6:	6a 50                	push   $0x50
  jmp __alltraps
  101fc8:	e9 15 fd ff ff       	jmp    101ce2 <__alltraps>

00101fcd <vector81>:
.globl vector81
vector81:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $81
  101fcf:	6a 51                	push   $0x51
  jmp __alltraps
  101fd1:	e9 0c fd ff ff       	jmp    101ce2 <__alltraps>

00101fd6 <vector82>:
.globl vector82
vector82:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $82
  101fd8:	6a 52                	push   $0x52
  jmp __alltraps
  101fda:	e9 03 fd ff ff       	jmp    101ce2 <__alltraps>

00101fdf <vector83>:
.globl vector83
vector83:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $83
  101fe1:	6a 53                	push   $0x53
  jmp __alltraps
  101fe3:	e9 fa fc ff ff       	jmp    101ce2 <__alltraps>

00101fe8 <vector84>:
.globl vector84
vector84:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $84
  101fea:	6a 54                	push   $0x54
  jmp __alltraps
  101fec:	e9 f1 fc ff ff       	jmp    101ce2 <__alltraps>

00101ff1 <vector85>:
.globl vector85
vector85:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $85
  101ff3:	6a 55                	push   $0x55
  jmp __alltraps
  101ff5:	e9 e8 fc ff ff       	jmp    101ce2 <__alltraps>

00101ffa <vector86>:
.globl vector86
vector86:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $86
  101ffc:	6a 56                	push   $0x56
  jmp __alltraps
  101ffe:	e9 df fc ff ff       	jmp    101ce2 <__alltraps>

00102003 <vector87>:
.globl vector87
vector87:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $87
  102005:	6a 57                	push   $0x57
  jmp __alltraps
  102007:	e9 d6 fc ff ff       	jmp    101ce2 <__alltraps>

0010200c <vector88>:
.globl vector88
vector88:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $88
  10200e:	6a 58                	push   $0x58
  jmp __alltraps
  102010:	e9 cd fc ff ff       	jmp    101ce2 <__alltraps>

00102015 <vector89>:
.globl vector89
vector89:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $89
  102017:	6a 59                	push   $0x59
  jmp __alltraps
  102019:	e9 c4 fc ff ff       	jmp    101ce2 <__alltraps>

0010201e <vector90>:
.globl vector90
vector90:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $90
  102020:	6a 5a                	push   $0x5a
  jmp __alltraps
  102022:	e9 bb fc ff ff       	jmp    101ce2 <__alltraps>

00102027 <vector91>:
.globl vector91
vector91:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $91
  102029:	6a 5b                	push   $0x5b
  jmp __alltraps
  10202b:	e9 b2 fc ff ff       	jmp    101ce2 <__alltraps>

00102030 <vector92>:
.globl vector92
vector92:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $92
  102032:	6a 5c                	push   $0x5c
  jmp __alltraps
  102034:	e9 a9 fc ff ff       	jmp    101ce2 <__alltraps>

00102039 <vector93>:
.globl vector93
vector93:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $93
  10203b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10203d:	e9 a0 fc ff ff       	jmp    101ce2 <__alltraps>

00102042 <vector94>:
.globl vector94
vector94:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $94
  102044:	6a 5e                	push   $0x5e
  jmp __alltraps
  102046:	e9 97 fc ff ff       	jmp    101ce2 <__alltraps>

0010204b <vector95>:
.globl vector95
vector95:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $95
  10204d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10204f:	e9 8e fc ff ff       	jmp    101ce2 <__alltraps>

00102054 <vector96>:
.globl vector96
vector96:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $96
  102056:	6a 60                	push   $0x60
  jmp __alltraps
  102058:	e9 85 fc ff ff       	jmp    101ce2 <__alltraps>

0010205d <vector97>:
.globl vector97
vector97:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $97
  10205f:	6a 61                	push   $0x61
  jmp __alltraps
  102061:	e9 7c fc ff ff       	jmp    101ce2 <__alltraps>

00102066 <vector98>:
.globl vector98
vector98:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $98
  102068:	6a 62                	push   $0x62
  jmp __alltraps
  10206a:	e9 73 fc ff ff       	jmp    101ce2 <__alltraps>

0010206f <vector99>:
.globl vector99
vector99:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $99
  102071:	6a 63                	push   $0x63
  jmp __alltraps
  102073:	e9 6a fc ff ff       	jmp    101ce2 <__alltraps>

00102078 <vector100>:
.globl vector100
vector100:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $100
  10207a:	6a 64                	push   $0x64
  jmp __alltraps
  10207c:	e9 61 fc ff ff       	jmp    101ce2 <__alltraps>

00102081 <vector101>:
.globl vector101
vector101:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $101
  102083:	6a 65                	push   $0x65
  jmp __alltraps
  102085:	e9 58 fc ff ff       	jmp    101ce2 <__alltraps>

0010208a <vector102>:
.globl vector102
vector102:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $102
  10208c:	6a 66                	push   $0x66
  jmp __alltraps
  10208e:	e9 4f fc ff ff       	jmp    101ce2 <__alltraps>

00102093 <vector103>:
.globl vector103
vector103:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $103
  102095:	6a 67                	push   $0x67
  jmp __alltraps
  102097:	e9 46 fc ff ff       	jmp    101ce2 <__alltraps>

0010209c <vector104>:
.globl vector104
vector104:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $104
  10209e:	6a 68                	push   $0x68
  jmp __alltraps
  1020a0:	e9 3d fc ff ff       	jmp    101ce2 <__alltraps>

001020a5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $105
  1020a7:	6a 69                	push   $0x69
  jmp __alltraps
  1020a9:	e9 34 fc ff ff       	jmp    101ce2 <__alltraps>

001020ae <vector106>:
.globl vector106
vector106:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $106
  1020b0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1020b2:	e9 2b fc ff ff       	jmp    101ce2 <__alltraps>

001020b7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $107
  1020b9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1020bb:	e9 22 fc ff ff       	jmp    101ce2 <__alltraps>

001020c0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $108
  1020c2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1020c4:	e9 19 fc ff ff       	jmp    101ce2 <__alltraps>

001020c9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $109
  1020cb:	6a 6d                	push   $0x6d
  jmp __alltraps
  1020cd:	e9 10 fc ff ff       	jmp    101ce2 <__alltraps>

001020d2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $110
  1020d4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1020d6:	e9 07 fc ff ff       	jmp    101ce2 <__alltraps>

001020db <vector111>:
.globl vector111
vector111:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $111
  1020dd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1020df:	e9 fe fb ff ff       	jmp    101ce2 <__alltraps>

001020e4 <vector112>:
.globl vector112
vector112:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $112
  1020e6:	6a 70                	push   $0x70
  jmp __alltraps
  1020e8:	e9 f5 fb ff ff       	jmp    101ce2 <__alltraps>

001020ed <vector113>:
.globl vector113
vector113:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $113
  1020ef:	6a 71                	push   $0x71
  jmp __alltraps
  1020f1:	e9 ec fb ff ff       	jmp    101ce2 <__alltraps>

001020f6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $114
  1020f8:	6a 72                	push   $0x72
  jmp __alltraps
  1020fa:	e9 e3 fb ff ff       	jmp    101ce2 <__alltraps>

001020ff <vector115>:
.globl vector115
vector115:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $115
  102101:	6a 73                	push   $0x73
  jmp __alltraps
  102103:	e9 da fb ff ff       	jmp    101ce2 <__alltraps>

00102108 <vector116>:
.globl vector116
vector116:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $116
  10210a:	6a 74                	push   $0x74
  jmp __alltraps
  10210c:	e9 d1 fb ff ff       	jmp    101ce2 <__alltraps>

00102111 <vector117>:
.globl vector117
vector117:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $117
  102113:	6a 75                	push   $0x75
  jmp __alltraps
  102115:	e9 c8 fb ff ff       	jmp    101ce2 <__alltraps>

0010211a <vector118>:
.globl vector118
vector118:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $118
  10211c:	6a 76                	push   $0x76
  jmp __alltraps
  10211e:	e9 bf fb ff ff       	jmp    101ce2 <__alltraps>

00102123 <vector119>:
.globl vector119
vector119:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $119
  102125:	6a 77                	push   $0x77
  jmp __alltraps
  102127:	e9 b6 fb ff ff       	jmp    101ce2 <__alltraps>

0010212c <vector120>:
.globl vector120
vector120:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $120
  10212e:	6a 78                	push   $0x78
  jmp __alltraps
  102130:	e9 ad fb ff ff       	jmp    101ce2 <__alltraps>

00102135 <vector121>:
.globl vector121
vector121:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $121
  102137:	6a 79                	push   $0x79
  jmp __alltraps
  102139:	e9 a4 fb ff ff       	jmp    101ce2 <__alltraps>

0010213e <vector122>:
.globl vector122
vector122:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $122
  102140:	6a 7a                	push   $0x7a
  jmp __alltraps
  102142:	e9 9b fb ff ff       	jmp    101ce2 <__alltraps>

00102147 <vector123>:
.globl vector123
vector123:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $123
  102149:	6a 7b                	push   $0x7b
  jmp __alltraps
  10214b:	e9 92 fb ff ff       	jmp    101ce2 <__alltraps>

00102150 <vector124>:
.globl vector124
vector124:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $124
  102152:	6a 7c                	push   $0x7c
  jmp __alltraps
  102154:	e9 89 fb ff ff       	jmp    101ce2 <__alltraps>

00102159 <vector125>:
.globl vector125
vector125:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $125
  10215b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10215d:	e9 80 fb ff ff       	jmp    101ce2 <__alltraps>

00102162 <vector126>:
.globl vector126
vector126:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $126
  102164:	6a 7e                	push   $0x7e
  jmp __alltraps
  102166:	e9 77 fb ff ff       	jmp    101ce2 <__alltraps>

0010216b <vector127>:
.globl vector127
vector127:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $127
  10216d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10216f:	e9 6e fb ff ff       	jmp    101ce2 <__alltraps>

00102174 <vector128>:
.globl vector128
vector128:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $128
  102176:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10217b:	e9 62 fb ff ff       	jmp    101ce2 <__alltraps>

00102180 <vector129>:
.globl vector129
vector129:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $129
  102182:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102187:	e9 56 fb ff ff       	jmp    101ce2 <__alltraps>

0010218c <vector130>:
.globl vector130
vector130:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $130
  10218e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102193:	e9 4a fb ff ff       	jmp    101ce2 <__alltraps>

00102198 <vector131>:
.globl vector131
vector131:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $131
  10219a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10219f:	e9 3e fb ff ff       	jmp    101ce2 <__alltraps>

001021a4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $132
  1021a6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1021ab:	e9 32 fb ff ff       	jmp    101ce2 <__alltraps>

001021b0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $133
  1021b2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1021b7:	e9 26 fb ff ff       	jmp    101ce2 <__alltraps>

001021bc <vector134>:
.globl vector134
vector134:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $134
  1021be:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1021c3:	e9 1a fb ff ff       	jmp    101ce2 <__alltraps>

001021c8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $135
  1021ca:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1021cf:	e9 0e fb ff ff       	jmp    101ce2 <__alltraps>

001021d4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $136
  1021d6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1021db:	e9 02 fb ff ff       	jmp    101ce2 <__alltraps>

001021e0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $137
  1021e2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1021e7:	e9 f6 fa ff ff       	jmp    101ce2 <__alltraps>

001021ec <vector138>:
.globl vector138
vector138:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $138
  1021ee:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1021f3:	e9 ea fa ff ff       	jmp    101ce2 <__alltraps>

001021f8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $139
  1021fa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1021ff:	e9 de fa ff ff       	jmp    101ce2 <__alltraps>

00102204 <vector140>:
.globl vector140
vector140:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $140
  102206:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10220b:	e9 d2 fa ff ff       	jmp    101ce2 <__alltraps>

00102210 <vector141>:
.globl vector141
vector141:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $141
  102212:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102217:	e9 c6 fa ff ff       	jmp    101ce2 <__alltraps>

0010221c <vector142>:
.globl vector142
vector142:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $142
  10221e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102223:	e9 ba fa ff ff       	jmp    101ce2 <__alltraps>

00102228 <vector143>:
.globl vector143
vector143:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $143
  10222a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10222f:	e9 ae fa ff ff       	jmp    101ce2 <__alltraps>

00102234 <vector144>:
.globl vector144
vector144:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $144
  102236:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10223b:	e9 a2 fa ff ff       	jmp    101ce2 <__alltraps>

00102240 <vector145>:
.globl vector145
vector145:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $145
  102242:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102247:	e9 96 fa ff ff       	jmp    101ce2 <__alltraps>

0010224c <vector146>:
.globl vector146
vector146:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $146
  10224e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102253:	e9 8a fa ff ff       	jmp    101ce2 <__alltraps>

00102258 <vector147>:
.globl vector147
vector147:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $147
  10225a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10225f:	e9 7e fa ff ff       	jmp    101ce2 <__alltraps>

00102264 <vector148>:
.globl vector148
vector148:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $148
  102266:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10226b:	e9 72 fa ff ff       	jmp    101ce2 <__alltraps>

00102270 <vector149>:
.globl vector149
vector149:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $149
  102272:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102277:	e9 66 fa ff ff       	jmp    101ce2 <__alltraps>

0010227c <vector150>:
.globl vector150
vector150:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $150
  10227e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102283:	e9 5a fa ff ff       	jmp    101ce2 <__alltraps>

00102288 <vector151>:
.globl vector151
vector151:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $151
  10228a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10228f:	e9 4e fa ff ff       	jmp    101ce2 <__alltraps>

00102294 <vector152>:
.globl vector152
vector152:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $152
  102296:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10229b:	e9 42 fa ff ff       	jmp    101ce2 <__alltraps>

001022a0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $153
  1022a2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1022a7:	e9 36 fa ff ff       	jmp    101ce2 <__alltraps>

001022ac <vector154>:
.globl vector154
vector154:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $154
  1022ae:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1022b3:	e9 2a fa ff ff       	jmp    101ce2 <__alltraps>

001022b8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $155
  1022ba:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1022bf:	e9 1e fa ff ff       	jmp    101ce2 <__alltraps>

001022c4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $156
  1022c6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1022cb:	e9 12 fa ff ff       	jmp    101ce2 <__alltraps>

001022d0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $157
  1022d2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1022d7:	e9 06 fa ff ff       	jmp    101ce2 <__alltraps>

001022dc <vector158>:
.globl vector158
vector158:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $158
  1022de:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1022e3:	e9 fa f9 ff ff       	jmp    101ce2 <__alltraps>

001022e8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $159
  1022ea:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1022ef:	e9 ee f9 ff ff       	jmp    101ce2 <__alltraps>

001022f4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $160
  1022f6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1022fb:	e9 e2 f9 ff ff       	jmp    101ce2 <__alltraps>

00102300 <vector161>:
.globl vector161
vector161:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $161
  102302:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102307:	e9 d6 f9 ff ff       	jmp    101ce2 <__alltraps>

0010230c <vector162>:
.globl vector162
vector162:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $162
  10230e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102313:	e9 ca f9 ff ff       	jmp    101ce2 <__alltraps>

00102318 <vector163>:
.globl vector163
vector163:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $163
  10231a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10231f:	e9 be f9 ff ff       	jmp    101ce2 <__alltraps>

00102324 <vector164>:
.globl vector164
vector164:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $164
  102326:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10232b:	e9 b2 f9 ff ff       	jmp    101ce2 <__alltraps>

00102330 <vector165>:
.globl vector165
vector165:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $165
  102332:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102337:	e9 a6 f9 ff ff       	jmp    101ce2 <__alltraps>

0010233c <vector166>:
.globl vector166
vector166:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $166
  10233e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102343:	e9 9a f9 ff ff       	jmp    101ce2 <__alltraps>

00102348 <vector167>:
.globl vector167
vector167:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $167
  10234a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10234f:	e9 8e f9 ff ff       	jmp    101ce2 <__alltraps>

00102354 <vector168>:
.globl vector168
vector168:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $168
  102356:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10235b:	e9 82 f9 ff ff       	jmp    101ce2 <__alltraps>

00102360 <vector169>:
.globl vector169
vector169:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $169
  102362:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102367:	e9 76 f9 ff ff       	jmp    101ce2 <__alltraps>

0010236c <vector170>:
.globl vector170
vector170:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $170
  10236e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102373:	e9 6a f9 ff ff       	jmp    101ce2 <__alltraps>

00102378 <vector171>:
.globl vector171
vector171:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $171
  10237a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10237f:	e9 5e f9 ff ff       	jmp    101ce2 <__alltraps>

00102384 <vector172>:
.globl vector172
vector172:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $172
  102386:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10238b:	e9 52 f9 ff ff       	jmp    101ce2 <__alltraps>

00102390 <vector173>:
.globl vector173
vector173:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $173
  102392:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102397:	e9 46 f9 ff ff       	jmp    101ce2 <__alltraps>

0010239c <vector174>:
.globl vector174
vector174:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $174
  10239e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1023a3:	e9 3a f9 ff ff       	jmp    101ce2 <__alltraps>

001023a8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $175
  1023aa:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1023af:	e9 2e f9 ff ff       	jmp    101ce2 <__alltraps>

001023b4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $176
  1023b6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1023bb:	e9 22 f9 ff ff       	jmp    101ce2 <__alltraps>

001023c0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $177
  1023c2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1023c7:	e9 16 f9 ff ff       	jmp    101ce2 <__alltraps>

001023cc <vector178>:
.globl vector178
vector178:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $178
  1023ce:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1023d3:	e9 0a f9 ff ff       	jmp    101ce2 <__alltraps>

001023d8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $179
  1023da:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1023df:	e9 fe f8 ff ff       	jmp    101ce2 <__alltraps>

001023e4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $180
  1023e6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1023eb:	e9 f2 f8 ff ff       	jmp    101ce2 <__alltraps>

001023f0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $181
  1023f2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1023f7:	e9 e6 f8 ff ff       	jmp    101ce2 <__alltraps>

001023fc <vector182>:
.globl vector182
vector182:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $182
  1023fe:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102403:	e9 da f8 ff ff       	jmp    101ce2 <__alltraps>

00102408 <vector183>:
.globl vector183
vector183:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $183
  10240a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10240f:	e9 ce f8 ff ff       	jmp    101ce2 <__alltraps>

00102414 <vector184>:
.globl vector184
vector184:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $184
  102416:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10241b:	e9 c2 f8 ff ff       	jmp    101ce2 <__alltraps>

00102420 <vector185>:
.globl vector185
vector185:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $185
  102422:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102427:	e9 b6 f8 ff ff       	jmp    101ce2 <__alltraps>

0010242c <vector186>:
.globl vector186
vector186:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $186
  10242e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102433:	e9 aa f8 ff ff       	jmp    101ce2 <__alltraps>

00102438 <vector187>:
.globl vector187
vector187:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $187
  10243a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10243f:	e9 9e f8 ff ff       	jmp    101ce2 <__alltraps>

00102444 <vector188>:
.globl vector188
vector188:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $188
  102446:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10244b:	e9 92 f8 ff ff       	jmp    101ce2 <__alltraps>

00102450 <vector189>:
.globl vector189
vector189:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $189
  102452:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102457:	e9 86 f8 ff ff       	jmp    101ce2 <__alltraps>

0010245c <vector190>:
.globl vector190
vector190:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $190
  10245e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102463:	e9 7a f8 ff ff       	jmp    101ce2 <__alltraps>

00102468 <vector191>:
.globl vector191
vector191:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $191
  10246a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10246f:	e9 6e f8 ff ff       	jmp    101ce2 <__alltraps>

00102474 <vector192>:
.globl vector192
vector192:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $192
  102476:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10247b:	e9 62 f8 ff ff       	jmp    101ce2 <__alltraps>

00102480 <vector193>:
.globl vector193
vector193:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $193
  102482:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102487:	e9 56 f8 ff ff       	jmp    101ce2 <__alltraps>

0010248c <vector194>:
.globl vector194
vector194:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $194
  10248e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102493:	e9 4a f8 ff ff       	jmp    101ce2 <__alltraps>

00102498 <vector195>:
.globl vector195
vector195:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $195
  10249a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10249f:	e9 3e f8 ff ff       	jmp    101ce2 <__alltraps>

001024a4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $196
  1024a6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1024ab:	e9 32 f8 ff ff       	jmp    101ce2 <__alltraps>

001024b0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $197
  1024b2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1024b7:	e9 26 f8 ff ff       	jmp    101ce2 <__alltraps>

001024bc <vector198>:
.globl vector198
vector198:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $198
  1024be:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1024c3:	e9 1a f8 ff ff       	jmp    101ce2 <__alltraps>

001024c8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $199
  1024ca:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1024cf:	e9 0e f8 ff ff       	jmp    101ce2 <__alltraps>

001024d4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $200
  1024d6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1024db:	e9 02 f8 ff ff       	jmp    101ce2 <__alltraps>

001024e0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $201
  1024e2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1024e7:	e9 f6 f7 ff ff       	jmp    101ce2 <__alltraps>

001024ec <vector202>:
.globl vector202
vector202:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $202
  1024ee:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1024f3:	e9 ea f7 ff ff       	jmp    101ce2 <__alltraps>

001024f8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $203
  1024fa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1024ff:	e9 de f7 ff ff       	jmp    101ce2 <__alltraps>

00102504 <vector204>:
.globl vector204
vector204:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $204
  102506:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10250b:	e9 d2 f7 ff ff       	jmp    101ce2 <__alltraps>

00102510 <vector205>:
.globl vector205
vector205:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $205
  102512:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102517:	e9 c6 f7 ff ff       	jmp    101ce2 <__alltraps>

0010251c <vector206>:
.globl vector206
vector206:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $206
  10251e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102523:	e9 ba f7 ff ff       	jmp    101ce2 <__alltraps>

00102528 <vector207>:
.globl vector207
vector207:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $207
  10252a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10252f:	e9 ae f7 ff ff       	jmp    101ce2 <__alltraps>

00102534 <vector208>:
.globl vector208
vector208:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $208
  102536:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10253b:	e9 a2 f7 ff ff       	jmp    101ce2 <__alltraps>

00102540 <vector209>:
.globl vector209
vector209:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $209
  102542:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102547:	e9 96 f7 ff ff       	jmp    101ce2 <__alltraps>

0010254c <vector210>:
.globl vector210
vector210:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $210
  10254e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102553:	e9 8a f7 ff ff       	jmp    101ce2 <__alltraps>

00102558 <vector211>:
.globl vector211
vector211:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $211
  10255a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10255f:	e9 7e f7 ff ff       	jmp    101ce2 <__alltraps>

00102564 <vector212>:
.globl vector212
vector212:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $212
  102566:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10256b:	e9 72 f7 ff ff       	jmp    101ce2 <__alltraps>

00102570 <vector213>:
.globl vector213
vector213:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $213
  102572:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102577:	e9 66 f7 ff ff       	jmp    101ce2 <__alltraps>

0010257c <vector214>:
.globl vector214
vector214:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $214
  10257e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102583:	e9 5a f7 ff ff       	jmp    101ce2 <__alltraps>

00102588 <vector215>:
.globl vector215
vector215:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $215
  10258a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10258f:	e9 4e f7 ff ff       	jmp    101ce2 <__alltraps>

00102594 <vector216>:
.globl vector216
vector216:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $216
  102596:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10259b:	e9 42 f7 ff ff       	jmp    101ce2 <__alltraps>

001025a0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $217
  1025a2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1025a7:	e9 36 f7 ff ff       	jmp    101ce2 <__alltraps>

001025ac <vector218>:
.globl vector218
vector218:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $218
  1025ae:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1025b3:	e9 2a f7 ff ff       	jmp    101ce2 <__alltraps>

001025b8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $219
  1025ba:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1025bf:	e9 1e f7 ff ff       	jmp    101ce2 <__alltraps>

001025c4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $220
  1025c6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1025cb:	e9 12 f7 ff ff       	jmp    101ce2 <__alltraps>

001025d0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $221
  1025d2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1025d7:	e9 06 f7 ff ff       	jmp    101ce2 <__alltraps>

001025dc <vector222>:
.globl vector222
vector222:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $222
  1025de:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1025e3:	e9 fa f6 ff ff       	jmp    101ce2 <__alltraps>

001025e8 <vector223>:
.globl vector223
vector223:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $223
  1025ea:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1025ef:	e9 ee f6 ff ff       	jmp    101ce2 <__alltraps>

001025f4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $224
  1025f6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1025fb:	e9 e2 f6 ff ff       	jmp    101ce2 <__alltraps>

00102600 <vector225>:
.globl vector225
vector225:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $225
  102602:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102607:	e9 d6 f6 ff ff       	jmp    101ce2 <__alltraps>

0010260c <vector226>:
.globl vector226
vector226:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $226
  10260e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102613:	e9 ca f6 ff ff       	jmp    101ce2 <__alltraps>

00102618 <vector227>:
.globl vector227
vector227:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $227
  10261a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10261f:	e9 be f6 ff ff       	jmp    101ce2 <__alltraps>

00102624 <vector228>:
.globl vector228
vector228:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $228
  102626:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10262b:	e9 b2 f6 ff ff       	jmp    101ce2 <__alltraps>

00102630 <vector229>:
.globl vector229
vector229:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $229
  102632:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102637:	e9 a6 f6 ff ff       	jmp    101ce2 <__alltraps>

0010263c <vector230>:
.globl vector230
vector230:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $230
  10263e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102643:	e9 9a f6 ff ff       	jmp    101ce2 <__alltraps>

00102648 <vector231>:
.globl vector231
vector231:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $231
  10264a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10264f:	e9 8e f6 ff ff       	jmp    101ce2 <__alltraps>

00102654 <vector232>:
.globl vector232
vector232:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $232
  102656:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10265b:	e9 82 f6 ff ff       	jmp    101ce2 <__alltraps>

00102660 <vector233>:
.globl vector233
vector233:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $233
  102662:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102667:	e9 76 f6 ff ff       	jmp    101ce2 <__alltraps>

0010266c <vector234>:
.globl vector234
vector234:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $234
  10266e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102673:	e9 6a f6 ff ff       	jmp    101ce2 <__alltraps>

00102678 <vector235>:
.globl vector235
vector235:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $235
  10267a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10267f:	e9 5e f6 ff ff       	jmp    101ce2 <__alltraps>

00102684 <vector236>:
.globl vector236
vector236:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $236
  102686:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10268b:	e9 52 f6 ff ff       	jmp    101ce2 <__alltraps>

00102690 <vector237>:
.globl vector237
vector237:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $237
  102692:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102697:	e9 46 f6 ff ff       	jmp    101ce2 <__alltraps>

0010269c <vector238>:
.globl vector238
vector238:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $238
  10269e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1026a3:	e9 3a f6 ff ff       	jmp    101ce2 <__alltraps>

001026a8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $239
  1026aa:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1026af:	e9 2e f6 ff ff       	jmp    101ce2 <__alltraps>

001026b4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $240
  1026b6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1026bb:	e9 22 f6 ff ff       	jmp    101ce2 <__alltraps>

001026c0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $241
  1026c2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1026c7:	e9 16 f6 ff ff       	jmp    101ce2 <__alltraps>

001026cc <vector242>:
.globl vector242
vector242:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $242
  1026ce:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1026d3:	e9 0a f6 ff ff       	jmp    101ce2 <__alltraps>

001026d8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $243
  1026da:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1026df:	e9 fe f5 ff ff       	jmp    101ce2 <__alltraps>

001026e4 <vector244>:
.globl vector244
vector244:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $244
  1026e6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1026eb:	e9 f2 f5 ff ff       	jmp    101ce2 <__alltraps>

001026f0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $245
  1026f2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1026f7:	e9 e6 f5 ff ff       	jmp    101ce2 <__alltraps>

001026fc <vector246>:
.globl vector246
vector246:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $246
  1026fe:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102703:	e9 da f5 ff ff       	jmp    101ce2 <__alltraps>

00102708 <vector247>:
.globl vector247
vector247:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $247
  10270a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10270f:	e9 ce f5 ff ff       	jmp    101ce2 <__alltraps>

00102714 <vector248>:
.globl vector248
vector248:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $248
  102716:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10271b:	e9 c2 f5 ff ff       	jmp    101ce2 <__alltraps>

00102720 <vector249>:
.globl vector249
vector249:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $249
  102722:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102727:	e9 b6 f5 ff ff       	jmp    101ce2 <__alltraps>

0010272c <vector250>:
.globl vector250
vector250:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $250
  10272e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102733:	e9 aa f5 ff ff       	jmp    101ce2 <__alltraps>

00102738 <vector251>:
.globl vector251
vector251:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $251
  10273a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10273f:	e9 9e f5 ff ff       	jmp    101ce2 <__alltraps>

00102744 <vector252>:
.globl vector252
vector252:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $252
  102746:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10274b:	e9 92 f5 ff ff       	jmp    101ce2 <__alltraps>

00102750 <vector253>:
.globl vector253
vector253:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $253
  102752:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102757:	e9 86 f5 ff ff       	jmp    101ce2 <__alltraps>

0010275c <vector254>:
.globl vector254
vector254:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $254
  10275e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102763:	e9 7a f5 ff ff       	jmp    101ce2 <__alltraps>

00102768 <vector255>:
.globl vector255
vector255:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $255
  10276a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10276f:	e9 6e f5 ff ff       	jmp    101ce2 <__alltraps>

00102774 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102774:	55                   	push   %ebp
  102775:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102777:	8b 45 08             	mov    0x8(%ebp),%eax
  10277a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10277d:	b8 23 00 00 00       	mov    $0x23,%eax
  102782:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102784:	b8 23 00 00 00       	mov    $0x23,%eax
  102789:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10278b:	b8 10 00 00 00       	mov    $0x10,%eax
  102790:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102792:	b8 10 00 00 00       	mov    $0x10,%eax
  102797:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102799:	b8 10 00 00 00       	mov    $0x10,%eax
  10279e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1027a0:	ea a7 27 10 00 08 00 	ljmp   $0x8,$0x1027a7
}
  1027a7:	5d                   	pop    %ebp
  1027a8:	c3                   	ret    

001027a9 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027a9:	55                   	push   %ebp
  1027aa:	89 e5                	mov    %esp,%ebp
  1027ac:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027af:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1027b4:	05 00 04 00 00       	add    $0x400,%eax
  1027b9:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1027be:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1027c5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1027c7:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1027ce:	68 00 
  1027d0:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1027d5:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1027db:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1027e0:	c1 e8 10             	shr    $0x10,%eax
  1027e3:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1027e8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1027ef:	83 e0 f0             	and    $0xfffffff0,%eax
  1027f2:	83 c8 09             	or     $0x9,%eax
  1027f5:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1027fa:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102801:	83 c8 10             	or     $0x10,%eax
  102804:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102809:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102810:	83 e0 9f             	and    $0xffffff9f,%eax
  102813:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102818:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10281f:	83 c8 80             	or     $0xffffff80,%eax
  102822:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102827:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10282e:	83 e0 f0             	and    $0xfffffff0,%eax
  102831:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102836:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10283d:	83 e0 ef             	and    $0xffffffef,%eax
  102840:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102845:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10284c:	83 e0 df             	and    $0xffffffdf,%eax
  10284f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102854:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10285b:	83 c8 40             	or     $0x40,%eax
  10285e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102863:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10286a:	83 e0 7f             	and    $0x7f,%eax
  10286d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102872:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102877:	c1 e8 18             	shr    $0x18,%eax
  10287a:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10287f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102886:	83 e0 ef             	and    $0xffffffef,%eax
  102889:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10288e:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102895:	e8 da fe ff ff       	call   102774 <lgdt>
  10289a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1028a0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1028a4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1028a7:	c9                   	leave  
  1028a8:	c3                   	ret    

001028a9 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1028a9:	55                   	push   %ebp
  1028aa:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1028ac:	e8 f8 fe ff ff       	call   1027a9 <gdt_init>
}
  1028b1:	5d                   	pop    %ebp
  1028b2:	c3                   	ret    

001028b3 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1028b3:	55                   	push   %ebp
  1028b4:	89 e5                	mov    %esp,%ebp
  1028b6:	83 ec 58             	sub    $0x58,%esp
  1028b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1028bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1028bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1028c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1028c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1028c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1028cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1028ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1028d1:	8b 45 18             	mov    0x18(%ebp),%eax
  1028d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1028da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1028dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1028e0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1028ed:	74 1c                	je     10290b <printnum+0x58>
  1028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028f2:	ba 00 00 00 00       	mov    $0x0,%edx
  1028f7:	f7 75 e4             	divl   -0x1c(%ebp)
  1028fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102900:	ba 00 00 00 00       	mov    $0x0,%edx
  102905:	f7 75 e4             	divl   -0x1c(%ebp)
  102908:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10290b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102911:	f7 75 e4             	divl   -0x1c(%ebp)
  102914:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10291a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10291d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102920:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102923:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102929:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10292c:	8b 45 18             	mov    0x18(%ebp),%eax
  10292f:	ba 00 00 00 00       	mov    $0x0,%edx
  102934:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102937:	77 56                	ja     10298f <printnum+0xdc>
  102939:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10293c:	72 05                	jb     102943 <printnum+0x90>
  10293e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102941:	77 4c                	ja     10298f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102943:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102946:	8d 50 ff             	lea    -0x1(%eax),%edx
  102949:	8b 45 20             	mov    0x20(%ebp),%eax
  10294c:	89 44 24 18          	mov    %eax,0x18(%esp)
  102950:	89 54 24 14          	mov    %edx,0x14(%esp)
  102954:	8b 45 18             	mov    0x18(%ebp),%eax
  102957:	89 44 24 10          	mov    %eax,0x10(%esp)
  10295b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10295e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102961:	89 44 24 08          	mov    %eax,0x8(%esp)
  102965:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102969:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102970:	8b 45 08             	mov    0x8(%ebp),%eax
  102973:	89 04 24             	mov    %eax,(%esp)
  102976:	e8 38 ff ff ff       	call   1028b3 <printnum>
  10297b:	eb 1c                	jmp    102999 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10297d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102980:	89 44 24 04          	mov    %eax,0x4(%esp)
  102984:	8b 45 20             	mov    0x20(%ebp),%eax
  102987:	89 04 24             	mov    %eax,(%esp)
  10298a:	8b 45 08             	mov    0x8(%ebp),%eax
  10298d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10298f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102993:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102997:	7f e4                	jg     10297d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102999:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10299c:	05 90 3b 10 00       	add    $0x103b90,%eax
  1029a1:	0f b6 00             	movzbl (%eax),%eax
  1029a4:	0f be c0             	movsbl %al,%eax
  1029a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1029ae:	89 04 24             	mov    %eax,(%esp)
  1029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b4:	ff d0                	call   *%eax
}
  1029b6:	c9                   	leave  
  1029b7:	c3                   	ret    

001029b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1029b8:	55                   	push   %ebp
  1029b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1029bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1029bf:	7e 14                	jle    1029d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c4:	8b 00                	mov    (%eax),%eax
  1029c6:	8d 48 08             	lea    0x8(%eax),%ecx
  1029c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1029cc:	89 0a                	mov    %ecx,(%edx)
  1029ce:	8b 50 04             	mov    0x4(%eax),%edx
  1029d1:	8b 00                	mov    (%eax),%eax
  1029d3:	eb 30                	jmp    102a05 <getuint+0x4d>
    }
    else if (lflag) {
  1029d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029d9:	74 16                	je     1029f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1029db:	8b 45 08             	mov    0x8(%ebp),%eax
  1029de:	8b 00                	mov    (%eax),%eax
  1029e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1029e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1029e6:	89 0a                	mov    %ecx,(%edx)
  1029e8:	8b 00                	mov    (%eax),%eax
  1029ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1029ef:	eb 14                	jmp    102a05 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f4:	8b 00                	mov    (%eax),%eax
  1029f6:	8d 48 04             	lea    0x4(%eax),%ecx
  1029f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1029fc:	89 0a                	mov    %ecx,(%edx)
  1029fe:	8b 00                	mov    (%eax),%eax
  102a00:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a05:	5d                   	pop    %ebp
  102a06:	c3                   	ret    

00102a07 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a07:	55                   	push   %ebp
  102a08:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a0a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a0e:	7e 14                	jle    102a24 <getint+0x1d>
        return va_arg(*ap, long long);
  102a10:	8b 45 08             	mov    0x8(%ebp),%eax
  102a13:	8b 00                	mov    (%eax),%eax
  102a15:	8d 48 08             	lea    0x8(%eax),%ecx
  102a18:	8b 55 08             	mov    0x8(%ebp),%edx
  102a1b:	89 0a                	mov    %ecx,(%edx)
  102a1d:	8b 50 04             	mov    0x4(%eax),%edx
  102a20:	8b 00                	mov    (%eax),%eax
  102a22:	eb 28                	jmp    102a4c <getint+0x45>
    }
    else if (lflag) {
  102a24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a28:	74 12                	je     102a3c <getint+0x35>
        return va_arg(*ap, long);
  102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2d:	8b 00                	mov    (%eax),%eax
  102a2f:	8d 48 04             	lea    0x4(%eax),%ecx
  102a32:	8b 55 08             	mov    0x8(%ebp),%edx
  102a35:	89 0a                	mov    %ecx,(%edx)
  102a37:	8b 00                	mov    (%eax),%eax
  102a39:	99                   	cltd   
  102a3a:	eb 10                	jmp    102a4c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3f:	8b 00                	mov    (%eax),%eax
  102a41:	8d 48 04             	lea    0x4(%eax),%ecx
  102a44:	8b 55 08             	mov    0x8(%ebp),%edx
  102a47:	89 0a                	mov    %ecx,(%edx)
  102a49:	8b 00                	mov    (%eax),%eax
  102a4b:	99                   	cltd   
    }
}
  102a4c:	5d                   	pop    %ebp
  102a4d:	c3                   	ret    

00102a4e <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102a4e:	55                   	push   %ebp
  102a4f:	89 e5                	mov    %esp,%ebp
  102a51:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102a54:	8d 45 14             	lea    0x14(%ebp),%eax
  102a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a61:	8b 45 10             	mov    0x10(%ebp),%eax
  102a64:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a72:	89 04 24             	mov    %eax,(%esp)
  102a75:	e8 02 00 00 00       	call   102a7c <vprintfmt>
    va_end(ap);
}
  102a7a:	c9                   	leave  
  102a7b:	c3                   	ret    

00102a7c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102a7c:	55                   	push   %ebp
  102a7d:	89 e5                	mov    %esp,%ebp
  102a7f:	56                   	push   %esi
  102a80:	53                   	push   %ebx
  102a81:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102a84:	eb 18                	jmp    102a9e <vprintfmt+0x22>
            if (ch == '\0') {
  102a86:	85 db                	test   %ebx,%ebx
  102a88:	75 05                	jne    102a8f <vprintfmt+0x13>
                return;
  102a8a:	e9 d1 03 00 00       	jmp    102e60 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a96:	89 1c 24             	mov    %ebx,(%esp)
  102a99:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102a9e:	8b 45 10             	mov    0x10(%ebp),%eax
  102aa1:	8d 50 01             	lea    0x1(%eax),%edx
  102aa4:	89 55 10             	mov    %edx,0x10(%ebp)
  102aa7:	0f b6 00             	movzbl (%eax),%eax
  102aaa:	0f b6 d8             	movzbl %al,%ebx
  102aad:	83 fb 25             	cmp    $0x25,%ebx
  102ab0:	75 d4                	jne    102a86 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102ab2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102ab6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ac0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ac3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102acd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ad3:	8d 50 01             	lea    0x1(%eax),%edx
  102ad6:	89 55 10             	mov    %edx,0x10(%ebp)
  102ad9:	0f b6 00             	movzbl (%eax),%eax
  102adc:	0f b6 d8             	movzbl %al,%ebx
  102adf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ae2:	83 f8 55             	cmp    $0x55,%eax
  102ae5:	0f 87 44 03 00 00    	ja     102e2f <vprintfmt+0x3b3>
  102aeb:	8b 04 85 b4 3b 10 00 	mov    0x103bb4(,%eax,4),%eax
  102af2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102af4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102af8:	eb d6                	jmp    102ad0 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102afa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102afe:	eb d0                	jmp    102ad0 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b0a:	89 d0                	mov    %edx,%eax
  102b0c:	c1 e0 02             	shl    $0x2,%eax
  102b0f:	01 d0                	add    %edx,%eax
  102b11:	01 c0                	add    %eax,%eax
  102b13:	01 d8                	add    %ebx,%eax
  102b15:	83 e8 30             	sub    $0x30,%eax
  102b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  102b1e:	0f b6 00             	movzbl (%eax),%eax
  102b21:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102b24:	83 fb 2f             	cmp    $0x2f,%ebx
  102b27:	7e 0b                	jle    102b34 <vprintfmt+0xb8>
  102b29:	83 fb 39             	cmp    $0x39,%ebx
  102b2c:	7f 06                	jg     102b34 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b2e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102b32:	eb d3                	jmp    102b07 <vprintfmt+0x8b>
            goto process_precision;
  102b34:	eb 33                	jmp    102b69 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102b36:	8b 45 14             	mov    0x14(%ebp),%eax
  102b39:	8d 50 04             	lea    0x4(%eax),%edx
  102b3c:	89 55 14             	mov    %edx,0x14(%ebp)
  102b3f:	8b 00                	mov    (%eax),%eax
  102b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102b44:	eb 23                	jmp    102b69 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102b46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b4a:	79 0c                	jns    102b58 <vprintfmt+0xdc>
                width = 0;
  102b4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102b53:	e9 78 ff ff ff       	jmp    102ad0 <vprintfmt+0x54>
  102b58:	e9 73 ff ff ff       	jmp    102ad0 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102b5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102b64:	e9 67 ff ff ff       	jmp    102ad0 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102b69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b6d:	79 12                	jns    102b81 <vprintfmt+0x105>
                width = precision, precision = -1;
  102b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102b7c:	e9 4f ff ff ff       	jmp    102ad0 <vprintfmt+0x54>
  102b81:	e9 4a ff ff ff       	jmp    102ad0 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102b86:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102b8a:	e9 41 ff ff ff       	jmp    102ad0 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  102b92:	8d 50 04             	lea    0x4(%eax),%edx
  102b95:	89 55 14             	mov    %edx,0x14(%ebp)
  102b98:	8b 00                	mov    (%eax),%eax
  102b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b9d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ba1:	89 04 24             	mov    %eax,(%esp)
  102ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba7:	ff d0                	call   *%eax
            break;
  102ba9:	e9 ac 02 00 00       	jmp    102e5a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102bae:	8b 45 14             	mov    0x14(%ebp),%eax
  102bb1:	8d 50 04             	lea    0x4(%eax),%edx
  102bb4:	89 55 14             	mov    %edx,0x14(%ebp)
  102bb7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102bb9:	85 db                	test   %ebx,%ebx
  102bbb:	79 02                	jns    102bbf <vprintfmt+0x143>
                err = -err;
  102bbd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102bbf:	83 fb 06             	cmp    $0x6,%ebx
  102bc2:	7f 0b                	jg     102bcf <vprintfmt+0x153>
  102bc4:	8b 34 9d 74 3b 10 00 	mov    0x103b74(,%ebx,4),%esi
  102bcb:	85 f6                	test   %esi,%esi
  102bcd:	75 23                	jne    102bf2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102bcf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102bd3:	c7 44 24 08 a1 3b 10 	movl   $0x103ba1,0x8(%esp)
  102bda:	00 
  102bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  102be2:	8b 45 08             	mov    0x8(%ebp),%eax
  102be5:	89 04 24             	mov    %eax,(%esp)
  102be8:	e8 61 fe ff ff       	call   102a4e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102bed:	e9 68 02 00 00       	jmp    102e5a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102bf2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102bf6:	c7 44 24 08 aa 3b 10 	movl   $0x103baa,0x8(%esp)
  102bfd:	00 
  102bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c05:	8b 45 08             	mov    0x8(%ebp),%eax
  102c08:	89 04 24             	mov    %eax,(%esp)
  102c0b:	e8 3e fe ff ff       	call   102a4e <printfmt>
            }
            break;
  102c10:	e9 45 02 00 00       	jmp    102e5a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c15:	8b 45 14             	mov    0x14(%ebp),%eax
  102c18:	8d 50 04             	lea    0x4(%eax),%edx
  102c1b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c1e:	8b 30                	mov    (%eax),%esi
  102c20:	85 f6                	test   %esi,%esi
  102c22:	75 05                	jne    102c29 <vprintfmt+0x1ad>
                p = "(null)";
  102c24:	be ad 3b 10 00       	mov    $0x103bad,%esi
            }
            if (width > 0 && padc != '-') {
  102c29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c2d:	7e 3e                	jle    102c6d <vprintfmt+0x1f1>
  102c2f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102c33:	74 38                	je     102c6d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102c35:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c3f:	89 34 24             	mov    %esi,(%esp)
  102c42:	e8 15 03 00 00       	call   102f5c <strnlen>
  102c47:	29 c3                	sub    %eax,%ebx
  102c49:	89 d8                	mov    %ebx,%eax
  102c4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c4e:	eb 17                	jmp    102c67 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102c50:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c57:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c5b:	89 04 24             	mov    %eax,(%esp)
  102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c61:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102c63:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102c67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c6b:	7f e3                	jg     102c50 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102c6d:	eb 38                	jmp    102ca7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102c6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102c73:	74 1f                	je     102c94 <vprintfmt+0x218>
  102c75:	83 fb 1f             	cmp    $0x1f,%ebx
  102c78:	7e 05                	jle    102c7f <vprintfmt+0x203>
  102c7a:	83 fb 7e             	cmp    $0x7e,%ebx
  102c7d:	7e 15                	jle    102c94 <vprintfmt+0x218>
                    putch('?', putdat);
  102c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c86:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c90:	ff d0                	call   *%eax
  102c92:	eb 0f                	jmp    102ca3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c9b:	89 1c 24             	mov    %ebx,(%esp)
  102c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ca3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ca7:	89 f0                	mov    %esi,%eax
  102ca9:	8d 70 01             	lea    0x1(%eax),%esi
  102cac:	0f b6 00             	movzbl (%eax),%eax
  102caf:	0f be d8             	movsbl %al,%ebx
  102cb2:	85 db                	test   %ebx,%ebx
  102cb4:	74 10                	je     102cc6 <vprintfmt+0x24a>
  102cb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cba:	78 b3                	js     102c6f <vprintfmt+0x1f3>
  102cbc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102cc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cc4:	79 a9                	jns    102c6f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102cc6:	eb 17                	jmp    102cdf <vprintfmt+0x263>
                putch(' ', putdat);
  102cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ccf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd9:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102cdb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cdf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ce3:	7f e3                	jg     102cc8 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102ce5:	e9 70 01 00 00       	jmp    102e5a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf1:	8d 45 14             	lea    0x14(%ebp),%eax
  102cf4:	89 04 24             	mov    %eax,(%esp)
  102cf7:	e8 0b fd ff ff       	call   102a07 <getint>
  102cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d08:	85 d2                	test   %edx,%edx
  102d0a:	79 26                	jns    102d32 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d13:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1d:	ff d0                	call   *%eax
                num = -(long long)num;
  102d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d25:	f7 d8                	neg    %eax
  102d27:	83 d2 00             	adc    $0x0,%edx
  102d2a:	f7 da                	neg    %edx
  102d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102d32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102d39:	e9 a8 00 00 00       	jmp    102de6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d45:	8d 45 14             	lea    0x14(%ebp),%eax
  102d48:	89 04 24             	mov    %eax,(%esp)
  102d4b:	e8 68 fc ff ff       	call   1029b8 <getuint>
  102d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d53:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102d56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102d5d:	e9 84 00 00 00       	jmp    102de6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d69:	8d 45 14             	lea    0x14(%ebp),%eax
  102d6c:	89 04 24             	mov    %eax,(%esp)
  102d6f:	e8 44 fc ff ff       	call   1029b8 <getuint>
  102d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d77:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102d7a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102d81:	eb 63                	jmp    102de6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d8a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102d91:	8b 45 08             	mov    0x8(%ebp),%eax
  102d94:	ff d0                	call   *%eax
            putch('x', putdat);
  102d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d9d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102da4:	8b 45 08             	mov    0x8(%ebp),%eax
  102da7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102da9:	8b 45 14             	mov    0x14(%ebp),%eax
  102dac:	8d 50 04             	lea    0x4(%eax),%edx
  102daf:	89 55 14             	mov    %edx,0x14(%ebp)
  102db2:	8b 00                	mov    (%eax),%eax
  102db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102dbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102dc5:	eb 1f                	jmp    102de6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dca:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dce:	8d 45 14             	lea    0x14(%ebp),%eax
  102dd1:	89 04 24             	mov    %eax,(%esp)
  102dd4:	e8 df fb ff ff       	call   1029b8 <getuint>
  102dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ddc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102ddf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102de6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ded:	89 54 24 18          	mov    %edx,0x18(%esp)
  102df1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102df4:	89 54 24 14          	mov    %edx,0x14(%esp)
  102df8:	89 44 24 10          	mov    %eax,0x10(%esp)
  102dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e02:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e06:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e11:	8b 45 08             	mov    0x8(%ebp),%eax
  102e14:	89 04 24             	mov    %eax,(%esp)
  102e17:	e8 97 fa ff ff       	call   1028b3 <printnum>
            break;
  102e1c:	eb 3c                	jmp    102e5a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e25:	89 1c 24             	mov    %ebx,(%esp)
  102e28:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2b:	ff d0                	call   *%eax
            break;
  102e2d:	eb 2b                	jmp    102e5a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e36:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e40:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102e42:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102e46:	eb 04                	jmp    102e4c <vprintfmt+0x3d0>
  102e48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  102e4f:	83 e8 01             	sub    $0x1,%eax
  102e52:	0f b6 00             	movzbl (%eax),%eax
  102e55:	3c 25                	cmp    $0x25,%al
  102e57:	75 ef                	jne    102e48 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102e59:	90                   	nop
        }
    }
  102e5a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e5b:	e9 3e fc ff ff       	jmp    102a9e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102e60:	83 c4 40             	add    $0x40,%esp
  102e63:	5b                   	pop    %ebx
  102e64:	5e                   	pop    %esi
  102e65:	5d                   	pop    %ebp
  102e66:	c3                   	ret    

00102e67 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102e67:	55                   	push   %ebp
  102e68:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e6d:	8b 40 08             	mov    0x8(%eax),%eax
  102e70:	8d 50 01             	lea    0x1(%eax),%edx
  102e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e76:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e7c:	8b 10                	mov    (%eax),%edx
  102e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e81:	8b 40 04             	mov    0x4(%eax),%eax
  102e84:	39 c2                	cmp    %eax,%edx
  102e86:	73 12                	jae    102e9a <sprintputch+0x33>
        *b->buf ++ = ch;
  102e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e8b:	8b 00                	mov    (%eax),%eax
  102e8d:	8d 48 01             	lea    0x1(%eax),%ecx
  102e90:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e93:	89 0a                	mov    %ecx,(%edx)
  102e95:	8b 55 08             	mov    0x8(%ebp),%edx
  102e98:	88 10                	mov    %dl,(%eax)
    }
}
  102e9a:	5d                   	pop    %ebp
  102e9b:	c3                   	ret    

00102e9c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102e9c:	55                   	push   %ebp
  102e9d:	89 e5                	mov    %esp,%ebp
  102e9f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102ea2:	8d 45 14             	lea    0x14(%ebp),%eax
  102ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec0:	89 04 24             	mov    %eax,(%esp)
  102ec3:	e8 08 00 00 00       	call   102ed0 <vsnprintf>
  102ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ece:	c9                   	leave  
  102ecf:	c3                   	ret    

00102ed0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102ed0:	55                   	push   %ebp
  102ed1:	89 e5                	mov    %esp,%ebp
  102ed3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102edf:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee5:	01 d0                	add    %edx,%eax
  102ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ef5:	74 0a                	je     102f01 <vsnprintf+0x31>
  102ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102efd:	39 c2                	cmp    %eax,%edx
  102eff:	76 07                	jbe    102f08 <vsnprintf+0x38>
        return -E_INVAL;
  102f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f06:	eb 2a                	jmp    102f32 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f08:	8b 45 14             	mov    0x14(%ebp),%eax
  102f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  102f12:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f1d:	c7 04 24 67 2e 10 00 	movl   $0x102e67,(%esp)
  102f24:	e8 53 fb ff ff       	call   102a7c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f2c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f32:	c9                   	leave  
  102f33:	c3                   	ret    

00102f34 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102f34:	55                   	push   %ebp
  102f35:	89 e5                	mov    %esp,%ebp
  102f37:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102f41:	eb 04                	jmp    102f47 <strlen+0x13>
        cnt ++;
  102f43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102f47:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4a:	8d 50 01             	lea    0x1(%eax),%edx
  102f4d:	89 55 08             	mov    %edx,0x8(%ebp)
  102f50:	0f b6 00             	movzbl (%eax),%eax
  102f53:	84 c0                	test   %al,%al
  102f55:	75 ec                	jne    102f43 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102f5a:	c9                   	leave  
  102f5b:	c3                   	ret    

00102f5c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102f5c:	55                   	push   %ebp
  102f5d:	89 e5                	mov    %esp,%ebp
  102f5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102f62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102f69:	eb 04                	jmp    102f6f <strnlen+0x13>
        cnt ++;
  102f6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102f75:	73 10                	jae    102f87 <strnlen+0x2b>
  102f77:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7a:	8d 50 01             	lea    0x1(%eax),%edx
  102f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  102f80:	0f b6 00             	movzbl (%eax),%eax
  102f83:	84 c0                	test   %al,%al
  102f85:	75 e4                	jne    102f6b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102f8a:	c9                   	leave  
  102f8b:	c3                   	ret    

00102f8c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102f8c:	55                   	push   %ebp
  102f8d:	89 e5                	mov    %esp,%ebp
  102f8f:	57                   	push   %edi
  102f90:	56                   	push   %esi
  102f91:	83 ec 20             	sub    $0x20,%esp
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fa6:	89 d1                	mov    %edx,%ecx
  102fa8:	89 c2                	mov    %eax,%edx
  102faa:	89 ce                	mov    %ecx,%esi
  102fac:	89 d7                	mov    %edx,%edi
  102fae:	ac                   	lods   %ds:(%esi),%al
  102faf:	aa                   	stos   %al,%es:(%edi)
  102fb0:	84 c0                	test   %al,%al
  102fb2:	75 fa                	jne    102fae <strcpy+0x22>
  102fb4:	89 fa                	mov    %edi,%edx
  102fb6:	89 f1                	mov    %esi,%ecx
  102fb8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fbb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102fc4:	83 c4 20             	add    $0x20,%esp
  102fc7:	5e                   	pop    %esi
  102fc8:	5f                   	pop    %edi
  102fc9:	5d                   	pop    %ebp
  102fca:	c3                   	ret    

00102fcb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102fcb:	55                   	push   %ebp
  102fcc:	89 e5                	mov    %esp,%ebp
  102fce:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102fd7:	eb 21                	jmp    102ffa <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fdc:	0f b6 10             	movzbl (%eax),%edx
  102fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fe2:	88 10                	mov    %dl,(%eax)
  102fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fe7:	0f b6 00             	movzbl (%eax),%eax
  102fea:	84 c0                	test   %al,%al
  102fec:	74 04                	je     102ff2 <strncpy+0x27>
            src ++;
  102fee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102ff2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ff6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ffe:	75 d9                	jne    102fd9 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103000:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103003:	c9                   	leave  
  103004:	c3                   	ret    

00103005 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103005:	55                   	push   %ebp
  103006:	89 e5                	mov    %esp,%ebp
  103008:	57                   	push   %edi
  103009:	56                   	push   %esi
  10300a:	83 ec 20             	sub    $0x20,%esp
  10300d:	8b 45 08             	mov    0x8(%ebp),%eax
  103010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103013:	8b 45 0c             	mov    0xc(%ebp),%eax
  103016:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301f:	89 d1                	mov    %edx,%ecx
  103021:	89 c2                	mov    %eax,%edx
  103023:	89 ce                	mov    %ecx,%esi
  103025:	89 d7                	mov    %edx,%edi
  103027:	ac                   	lods   %ds:(%esi),%al
  103028:	ae                   	scas   %es:(%edi),%al
  103029:	75 08                	jne    103033 <strcmp+0x2e>
  10302b:	84 c0                	test   %al,%al
  10302d:	75 f8                	jne    103027 <strcmp+0x22>
  10302f:	31 c0                	xor    %eax,%eax
  103031:	eb 04                	jmp    103037 <strcmp+0x32>
  103033:	19 c0                	sbb    %eax,%eax
  103035:	0c 01                	or     $0x1,%al
  103037:	89 fa                	mov    %edi,%edx
  103039:	89 f1                	mov    %esi,%ecx
  10303b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10303e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103041:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103044:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103047:	83 c4 20             	add    $0x20,%esp
  10304a:	5e                   	pop    %esi
  10304b:	5f                   	pop    %edi
  10304c:	5d                   	pop    %ebp
  10304d:	c3                   	ret    

0010304e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10304e:	55                   	push   %ebp
  10304f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103051:	eb 0c                	jmp    10305f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103053:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103057:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10305b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10305f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103063:	74 1a                	je     10307f <strncmp+0x31>
  103065:	8b 45 08             	mov    0x8(%ebp),%eax
  103068:	0f b6 00             	movzbl (%eax),%eax
  10306b:	84 c0                	test   %al,%al
  10306d:	74 10                	je     10307f <strncmp+0x31>
  10306f:	8b 45 08             	mov    0x8(%ebp),%eax
  103072:	0f b6 10             	movzbl (%eax),%edx
  103075:	8b 45 0c             	mov    0xc(%ebp),%eax
  103078:	0f b6 00             	movzbl (%eax),%eax
  10307b:	38 c2                	cmp    %al,%dl
  10307d:	74 d4                	je     103053 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10307f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103083:	74 18                	je     10309d <strncmp+0x4f>
  103085:	8b 45 08             	mov    0x8(%ebp),%eax
  103088:	0f b6 00             	movzbl (%eax),%eax
  10308b:	0f b6 d0             	movzbl %al,%edx
  10308e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103091:	0f b6 00             	movzbl (%eax),%eax
  103094:	0f b6 c0             	movzbl %al,%eax
  103097:	29 c2                	sub    %eax,%edx
  103099:	89 d0                	mov    %edx,%eax
  10309b:	eb 05                	jmp    1030a2 <strncmp+0x54>
  10309d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030a2:	5d                   	pop    %ebp
  1030a3:	c3                   	ret    

001030a4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1030a4:	55                   	push   %ebp
  1030a5:	89 e5                	mov    %esp,%ebp
  1030a7:	83 ec 04             	sub    $0x4,%esp
  1030aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ad:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1030b0:	eb 14                	jmp    1030c6 <strchr+0x22>
        if (*s == c) {
  1030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b5:	0f b6 00             	movzbl (%eax),%eax
  1030b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1030bb:	75 05                	jne    1030c2 <strchr+0x1e>
            return (char *)s;
  1030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c0:	eb 13                	jmp    1030d5 <strchr+0x31>
        }
        s ++;
  1030c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	0f b6 00             	movzbl (%eax),%eax
  1030cc:	84 c0                	test   %al,%al
  1030ce:	75 e2                	jne    1030b2 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1030d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030d5:	c9                   	leave  
  1030d6:	c3                   	ret    

001030d7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1030d7:	55                   	push   %ebp
  1030d8:	89 e5                	mov    %esp,%ebp
  1030da:	83 ec 04             	sub    $0x4,%esp
  1030dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1030e3:	eb 11                	jmp    1030f6 <strfind+0x1f>
        if (*s == c) {
  1030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e8:	0f b6 00             	movzbl (%eax),%eax
  1030eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1030ee:	75 02                	jne    1030f2 <strfind+0x1b>
            break;
  1030f0:	eb 0e                	jmp    103100 <strfind+0x29>
        }
        s ++;
  1030f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f9:	0f b6 00             	movzbl (%eax),%eax
  1030fc:	84 c0                	test   %al,%al
  1030fe:	75 e5                	jne    1030e5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103100:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103103:	c9                   	leave  
  103104:	c3                   	ret    

00103105 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103105:	55                   	push   %ebp
  103106:	89 e5                	mov    %esp,%ebp
  103108:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10310b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103112:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103119:	eb 04                	jmp    10311f <strtol+0x1a>
        s ++;
  10311b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10311f:	8b 45 08             	mov    0x8(%ebp),%eax
  103122:	0f b6 00             	movzbl (%eax),%eax
  103125:	3c 20                	cmp    $0x20,%al
  103127:	74 f2                	je     10311b <strtol+0x16>
  103129:	8b 45 08             	mov    0x8(%ebp),%eax
  10312c:	0f b6 00             	movzbl (%eax),%eax
  10312f:	3c 09                	cmp    $0x9,%al
  103131:	74 e8                	je     10311b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103133:	8b 45 08             	mov    0x8(%ebp),%eax
  103136:	0f b6 00             	movzbl (%eax),%eax
  103139:	3c 2b                	cmp    $0x2b,%al
  10313b:	75 06                	jne    103143 <strtol+0x3e>
        s ++;
  10313d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103141:	eb 15                	jmp    103158 <strtol+0x53>
    }
    else if (*s == '-') {
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	0f b6 00             	movzbl (%eax),%eax
  103149:	3c 2d                	cmp    $0x2d,%al
  10314b:	75 0b                	jne    103158 <strtol+0x53>
        s ++, neg = 1;
  10314d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103151:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10315c:	74 06                	je     103164 <strtol+0x5f>
  10315e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103162:	75 24                	jne    103188 <strtol+0x83>
  103164:	8b 45 08             	mov    0x8(%ebp),%eax
  103167:	0f b6 00             	movzbl (%eax),%eax
  10316a:	3c 30                	cmp    $0x30,%al
  10316c:	75 1a                	jne    103188 <strtol+0x83>
  10316e:	8b 45 08             	mov    0x8(%ebp),%eax
  103171:	83 c0 01             	add    $0x1,%eax
  103174:	0f b6 00             	movzbl (%eax),%eax
  103177:	3c 78                	cmp    $0x78,%al
  103179:	75 0d                	jne    103188 <strtol+0x83>
        s += 2, base = 16;
  10317b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10317f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103186:	eb 2a                	jmp    1031b2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103188:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10318c:	75 17                	jne    1031a5 <strtol+0xa0>
  10318e:	8b 45 08             	mov    0x8(%ebp),%eax
  103191:	0f b6 00             	movzbl (%eax),%eax
  103194:	3c 30                	cmp    $0x30,%al
  103196:	75 0d                	jne    1031a5 <strtol+0xa0>
        s ++, base = 8;
  103198:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10319c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1031a3:	eb 0d                	jmp    1031b2 <strtol+0xad>
    }
    else if (base == 0) {
  1031a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031a9:	75 07                	jne    1031b2 <strtol+0xad>
        base = 10;
  1031ab:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b5:	0f b6 00             	movzbl (%eax),%eax
  1031b8:	3c 2f                	cmp    $0x2f,%al
  1031ba:	7e 1b                	jle    1031d7 <strtol+0xd2>
  1031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bf:	0f b6 00             	movzbl (%eax),%eax
  1031c2:	3c 39                	cmp    $0x39,%al
  1031c4:	7f 11                	jg     1031d7 <strtol+0xd2>
            dig = *s - '0';
  1031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c9:	0f b6 00             	movzbl (%eax),%eax
  1031cc:	0f be c0             	movsbl %al,%eax
  1031cf:	83 e8 30             	sub    $0x30,%eax
  1031d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031d5:	eb 48                	jmp    10321f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	3c 60                	cmp    $0x60,%al
  1031df:	7e 1b                	jle    1031fc <strtol+0xf7>
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	0f b6 00             	movzbl (%eax),%eax
  1031e7:	3c 7a                	cmp    $0x7a,%al
  1031e9:	7f 11                	jg     1031fc <strtol+0xf7>
            dig = *s - 'a' + 10;
  1031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ee:	0f b6 00             	movzbl (%eax),%eax
  1031f1:	0f be c0             	movsbl %al,%eax
  1031f4:	83 e8 57             	sub    $0x57,%eax
  1031f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031fa:	eb 23                	jmp    10321f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ff:	0f b6 00             	movzbl (%eax),%eax
  103202:	3c 40                	cmp    $0x40,%al
  103204:	7e 3d                	jle    103243 <strtol+0x13e>
  103206:	8b 45 08             	mov    0x8(%ebp),%eax
  103209:	0f b6 00             	movzbl (%eax),%eax
  10320c:	3c 5a                	cmp    $0x5a,%al
  10320e:	7f 33                	jg     103243 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103210:	8b 45 08             	mov    0x8(%ebp),%eax
  103213:	0f b6 00             	movzbl (%eax),%eax
  103216:	0f be c0             	movsbl %al,%eax
  103219:	83 e8 37             	sub    $0x37,%eax
  10321c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103222:	3b 45 10             	cmp    0x10(%ebp),%eax
  103225:	7c 02                	jl     103229 <strtol+0x124>
            break;
  103227:	eb 1a                	jmp    103243 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103229:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10322d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103230:	0f af 45 10          	imul   0x10(%ebp),%eax
  103234:	89 c2                	mov    %eax,%edx
  103236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103239:	01 d0                	add    %edx,%eax
  10323b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10323e:	e9 6f ff ff ff       	jmp    1031b2 <strtol+0xad>

    if (endptr) {
  103243:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103247:	74 08                	je     103251 <strtol+0x14c>
        *endptr = (char *) s;
  103249:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324c:	8b 55 08             	mov    0x8(%ebp),%edx
  10324f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103251:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103255:	74 07                	je     10325e <strtol+0x159>
  103257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10325a:	f7 d8                	neg    %eax
  10325c:	eb 03                	jmp    103261 <strtol+0x15c>
  10325e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103261:	c9                   	leave  
  103262:	c3                   	ret    

00103263 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103263:	55                   	push   %ebp
  103264:	89 e5                	mov    %esp,%ebp
  103266:	57                   	push   %edi
  103267:	83 ec 24             	sub    $0x24,%esp
  10326a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10326d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103270:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103274:	8b 55 08             	mov    0x8(%ebp),%edx
  103277:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10327a:	88 45 f7             	mov    %al,-0x9(%ebp)
  10327d:	8b 45 10             	mov    0x10(%ebp),%eax
  103280:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103283:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103286:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10328a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10328d:	89 d7                	mov    %edx,%edi
  10328f:	f3 aa                	rep stos %al,%es:(%edi)
  103291:	89 fa                	mov    %edi,%edx
  103293:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103296:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103299:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10329c:	83 c4 24             	add    $0x24,%esp
  10329f:	5f                   	pop    %edi
  1032a0:	5d                   	pop    %ebp
  1032a1:	c3                   	ret    

001032a2 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1032a2:	55                   	push   %ebp
  1032a3:	89 e5                	mov    %esp,%ebp
  1032a5:	57                   	push   %edi
  1032a6:	56                   	push   %esi
  1032a7:	53                   	push   %ebx
  1032a8:	83 ec 30             	sub    $0x30,%esp
  1032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1032ba:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032c3:	73 42                	jae    103307 <memmove+0x65>
  1032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1032d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032da:	c1 e8 02             	shr    $0x2,%eax
  1032dd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1032df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032e5:	89 d7                	mov    %edx,%edi
  1032e7:	89 c6                	mov    %eax,%esi
  1032e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1032eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1032ee:	83 e1 03             	and    $0x3,%ecx
  1032f1:	74 02                	je     1032f5 <memmove+0x53>
  1032f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1032f5:	89 f0                	mov    %esi,%eax
  1032f7:	89 fa                	mov    %edi,%edx
  1032f9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1032fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1032ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103305:	eb 36                	jmp    10333d <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10330a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10330d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103310:	01 c2                	add    %eax,%edx
  103312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103315:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10331b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103321:	89 c1                	mov    %eax,%ecx
  103323:	89 d8                	mov    %ebx,%eax
  103325:	89 d6                	mov    %edx,%esi
  103327:	89 c7                	mov    %eax,%edi
  103329:	fd                   	std    
  10332a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10332c:	fc                   	cld    
  10332d:	89 f8                	mov    %edi,%eax
  10332f:	89 f2                	mov    %esi,%edx
  103331:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103334:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103337:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  10333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10333d:	83 c4 30             	add    $0x30,%esp
  103340:	5b                   	pop    %ebx
  103341:	5e                   	pop    %esi
  103342:	5f                   	pop    %edi
  103343:	5d                   	pop    %ebp
  103344:	c3                   	ret    

00103345 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103345:	55                   	push   %ebp
  103346:	89 e5                	mov    %esp,%ebp
  103348:	57                   	push   %edi
  103349:	56                   	push   %esi
  10334a:	83 ec 20             	sub    $0x20,%esp
  10334d:	8b 45 08             	mov    0x8(%ebp),%eax
  103350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103353:	8b 45 0c             	mov    0xc(%ebp),%eax
  103356:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103359:	8b 45 10             	mov    0x10(%ebp),%eax
  10335c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103362:	c1 e8 02             	shr    $0x2,%eax
  103365:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10336a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10336d:	89 d7                	mov    %edx,%edi
  10336f:	89 c6                	mov    %eax,%esi
  103371:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103373:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103376:	83 e1 03             	and    $0x3,%ecx
  103379:	74 02                	je     10337d <memcpy+0x38>
  10337b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10337d:	89 f0                	mov    %esi,%eax
  10337f:	89 fa                	mov    %edi,%edx
  103381:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103384:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103387:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10338d:	83 c4 20             	add    $0x20,%esp
  103390:	5e                   	pop    %esi
  103391:	5f                   	pop    %edi
  103392:	5d                   	pop    %ebp
  103393:	c3                   	ret    

00103394 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103394:	55                   	push   %ebp
  103395:	89 e5                	mov    %esp,%ebp
  103397:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1033a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1033a6:	eb 30                	jmp    1033d8 <memcmp+0x44>
        if (*s1 != *s2) {
  1033a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033ab:	0f b6 10             	movzbl (%eax),%edx
  1033ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033b1:	0f b6 00             	movzbl (%eax),%eax
  1033b4:	38 c2                	cmp    %al,%dl
  1033b6:	74 18                	je     1033d0 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1033b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033bb:	0f b6 00             	movzbl (%eax),%eax
  1033be:	0f b6 d0             	movzbl %al,%edx
  1033c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033c4:	0f b6 00             	movzbl (%eax),%eax
  1033c7:	0f b6 c0             	movzbl %al,%eax
  1033ca:	29 c2                	sub    %eax,%edx
  1033cc:	89 d0                	mov    %edx,%eax
  1033ce:	eb 1a                	jmp    1033ea <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1033d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1033d4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1033d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1033db:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033de:	89 55 10             	mov    %edx,0x10(%ebp)
  1033e1:	85 c0                	test   %eax,%eax
  1033e3:	75 c3                	jne    1033a8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1033e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033ea:	c9                   	leave  
  1033eb:	c3                   	ret    
