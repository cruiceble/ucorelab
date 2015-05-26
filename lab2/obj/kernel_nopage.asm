
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
  100030:	ba c8 89 11 00       	mov    $0x1189c8,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 98 5e 00 00       	call   105eee <memset>

    cons_init();                // init the console
  100056:	e8 7c 15 00 00       	call   1015d7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 60 10 00 	movl   $0x106080,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 60 10 00 	movl   $0x10609c,(%esp)
  100070:	e8 d2 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100075:	e8 01 08 00 00       	call   10087b <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 71 43 00 00       	call   1043f5 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b7 16 00 00       	call   101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 2f 18 00 00       	call   1018bd <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 fa 0c 00 00       	call   100d8d <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 16 16 00 00       	call   1016ae <intr_enable>
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
  1000b7:	e8 03 0c 00 00       	call   100cbf <mon_backtrace>
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
  100155:	c7 04 24 a1 60 10 00 	movl   $0x1060a1,(%esp)
  10015c:	e8 e6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 60 10 00 	movl   $0x1060af,(%esp)
  10017c:	e8 c6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 60 10 00 	movl   $0x1060bd,(%esp)
  10019c:	e8 a6 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 60 10 00 	movl   $0x1060cb,(%esp)
  1001bc:	e8 86 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 60 10 00 	movl   $0x1060d9,(%esp)
  1001dc:	e8 66 01 00 00       	call   100347 <cprintf>
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
	asm volatile (
  1001f3:	83 ec 08             	sub    $0x8,%esp
  1001f6:	cd 78                	int    $0x78
  1001f8:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001fa:	5d                   	pop    %ebp
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001ff:	cd 79                	int    $0x79
  100201:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
  100208:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020b:	e8 1a ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100210:	c7 04 24 e8 60 10 00 	movl   $0x1060e8,(%esp)
  100217:	e8 2b 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  10021c:	e8 cf ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100221:	e8 04 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100226:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
  10022d:	e8 15 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  100232:	e8 c5 ff ff ff       	call   1001fc <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100237:	e8 ee fe ff ff       	call   10012a <lab1_print_cur_status>
}
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100248:	74 13                	je     10025d <readline+0x1f>
        cprintf("%s", prompt);
  10024a:	8b 45 08             	mov    0x8(%ebp),%eax
  10024d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100251:	c7 04 24 27 61 10 00 	movl   $0x106127,(%esp)
  100258:	e8 ea 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  10025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100264:	e8 66 01 00 00       	call   1003cf <getchar>
  100269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100270:	79 07                	jns    100279 <readline+0x3b>
            return NULL;
  100272:	b8 00 00 00 00       	mov    $0x0,%eax
  100277:	eb 79                	jmp    1002f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100279:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027d:	7e 28                	jle    1002a7 <readline+0x69>
  10027f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100286:	7f 1f                	jg     1002a7 <readline+0x69>
            cputchar(c);
  100288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 da 00 00 00       	call   10036d <cputchar>
            buf[i ++] = c;
  100293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100296:	8d 50 01             	lea    0x1(%eax),%edx
  100299:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10029f:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  1002a5:	eb 46                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ab:	75 17                	jne    1002c4 <readline+0x86>
  1002ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b1:	7e 11                	jle    1002c4 <readline+0x86>
            cputchar(c);
  1002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b6:	89 04 24             	mov    %eax,(%esp)
  1002b9:	e8 af 00 00 00       	call   10036d <cputchar>
            i --;
  1002be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c2:	eb 29                	jmp    1002ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c8:	74 06                	je     1002d0 <readline+0x92>
  1002ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002ce:	75 1d                	jne    1002ed <readline+0xaf>
            cputchar(c);
  1002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d3:	89 04 24             	mov    %eax,(%esp)
  1002d6:	e8 92 00 00 00       	call   10036d <cputchar>
            buf[i] = '\0';
  1002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002de:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e6:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002eb:	eb 05                	jmp    1002f2 <readline+0xb4>
        }
    }
  1002ed:	e9 72 ff ff ff       	jmp    100264 <readline+0x26>
}
  1002f2:	c9                   	leave  
  1002f3:	c3                   	ret    

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 fe 12 00 00       	call   101603 <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 c5 53 00 00       	call   105707 <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100356:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035a:	8b 45 08             	mov    0x8(%ebp),%eax
  10035d:	89 04 24             	mov    %eax,(%esp)
  100360:	e8 af ff ff ff       	call   100314 <vcprintf>
  100365:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036d:	55                   	push   %ebp
  10036e:	89 e5                	mov    %esp,%ebp
  100370:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100373:	8b 45 08             	mov    0x8(%ebp),%eax
  100376:	89 04 24             	mov    %eax,(%esp)
  100379:	e8 85 12 00 00       	call   101603 <cons_putc>
}
  10037e:	c9                   	leave  
  10037f:	c3                   	ret    

00100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038d:	eb 13                	jmp    1003a2 <cputs+0x22>
        cputch(c, &cnt);
  10038f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100396:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039a:	89 04 24             	mov    %eax,(%esp)
  10039d:	e8 52 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a5:	8d 50 01             	lea    0x1(%eax),%edx
  1003a8:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ab:	0f b6 00             	movzbl (%eax),%eax
  1003ae:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b5:	75 d8                	jne    10038f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003be:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c5:	e8 2a ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003cd:	c9                   	leave  
  1003ce:	c3                   	ret    

001003cf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003cf:	55                   	push   %ebp
  1003d0:	89 e5                	mov    %esp,%ebp
  1003d2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d5:	e8 65 12 00 00       	call   10163f <cons_getc>
  1003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e1:	74 f2                	je     1003d5 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e6:	c9                   	leave  
  1003e7:	c3                   	ret    

001003e8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e8:	55                   	push   %ebp
  1003e9:	89 e5                	mov    %esp,%ebp
  1003eb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f1:	8b 00                	mov    (%eax),%eax
  1003f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f9:	8b 00                	mov    (%eax),%eax
  1003fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100405:	e9 d2 00 00 00       	jmp    1004dc <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100410:	01 d0                	add    %edx,%eax
  100412:	89 c2                	mov    %eax,%edx
  100414:	c1 ea 1f             	shr    $0x1f,%edx
  100417:	01 d0                	add    %edx,%eax
  100419:	d1 f8                	sar    %eax
  10041b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100421:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100424:	eb 04                	jmp    10042a <stab_binsearch+0x42>
            m --;
  100426:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100430:	7c 1f                	jl     100451 <stab_binsearch+0x69>
  100432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100435:	89 d0                	mov    %edx,%eax
  100437:	01 c0                	add    %eax,%eax
  100439:	01 d0                	add    %edx,%eax
  10043b:	c1 e0 02             	shl    $0x2,%eax
  10043e:	89 c2                	mov    %eax,%edx
  100440:	8b 45 08             	mov    0x8(%ebp),%eax
  100443:	01 d0                	add    %edx,%eax
  100445:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100449:	0f b6 c0             	movzbl %al,%eax
  10044c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10044f:	75 d5                	jne    100426 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100457:	7d 0b                	jge    100464 <stab_binsearch+0x7c>
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100462:	eb 78                	jmp    1004dc <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046e:	89 d0                	mov    %edx,%eax
  100470:	01 c0                	add    %eax,%eax
  100472:	01 d0                	add    %edx,%eax
  100474:	c1 e0 02             	shl    $0x2,%eax
  100477:	89 c2                	mov    %eax,%edx
  100479:	8b 45 08             	mov    0x8(%ebp),%eax
  10047c:	01 d0                	add    %edx,%eax
  10047e:	8b 40 08             	mov    0x8(%eax),%eax
  100481:	3b 45 18             	cmp    0x18(%ebp),%eax
  100484:	73 13                	jae    100499 <stab_binsearch+0xb1>
            *region_left = m;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100491:	83 c0 01             	add    $0x1,%eax
  100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100497:	eb 43                	jmp    1004dc <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049c:	89 d0                	mov    %edx,%eax
  10049e:	01 c0                	add    %eax,%eax
  1004a0:	01 d0                	add    %edx,%eax
  1004a2:	c1 e0 02             	shl    $0x2,%eax
  1004a5:	89 c2                	mov    %eax,%edx
  1004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	8b 40 08             	mov    0x8(%eax),%eax
  1004af:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b2:	76 16                	jbe    1004ca <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1004bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c2:	83 e8 01             	sub    $0x1,%eax
  1004c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c8:	eb 12                	jmp    1004dc <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e2:	0f 8e 22 ff ff ff    	jle    10040a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ec:	75 0f                	jne    1004fd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f1:	8b 00                	mov    (%eax),%eax
  1004f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f9:	89 10                	mov    %edx,(%eax)
  1004fb:	eb 3f                	jmp    10053c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100500:	8b 00                	mov    (%eax),%eax
  100502:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100505:	eb 04                	jmp    10050b <stab_binsearch+0x123>
  100507:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100513:	7d 1f                	jge    100534 <stab_binsearch+0x14c>
  100515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100518:	89 d0                	mov    %edx,%eax
  10051a:	01 c0                	add    %eax,%eax
  10051c:	01 d0                	add    %edx,%eax
  10051e:	c1 e0 02             	shl    $0x2,%eax
  100521:	89 c2                	mov    %eax,%edx
  100523:	8b 45 08             	mov    0x8(%ebp),%eax
  100526:	01 d0                	add    %edx,%eax
  100528:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052c:	0f b6 c0             	movzbl %al,%eax
  10052f:	3b 45 14             	cmp    0x14(%ebp),%eax
  100532:	75 d3                	jne    100507 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053a:	89 10                	mov    %edx,(%eax)
    }
}
  10053c:	c9                   	leave  
  10053d:	c3                   	ret    

0010053e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053e:	55                   	push   %ebp
  10053f:	89 e5                	mov    %esp,%ebp
  100541:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 00 2c 61 10 00    	movl   $0x10612c,(%eax)
    info->eip_line = 0;
  10054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 40 08 2c 61 10 00 	movl   $0x10612c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056e:	8b 55 08             	mov    0x8(%ebp),%edx
  100571:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057e:	c7 45 f4 88 73 10 00 	movl   $0x107388,-0xc(%ebp)
    stab_end = __STAB_END__;
  100585:	c7 45 f0 a4 20 11 00 	movl   $0x1120a4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058c:	c7 45 ec a5 20 11 00 	movl   $0x1120a5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100593:	c7 45 e8 1b 4b 11 00 	movl   $0x114b1b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a0:	76 0d                	jbe    1005af <debuginfo_eip+0x71>
  1005a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a5:	83 e8 01             	sub    $0x1,%eax
  1005a8:	0f b6 00             	movzbl (%eax),%eax
  1005ab:	84 c0                	test   %al,%al
  1005ad:	74 0a                	je     1005b9 <debuginfo_eip+0x7b>
        return -1;
  1005af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b4:	e9 c0 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c6:	29 c2                	sub    %eax,%edx
  1005c8:	89 d0                	mov    %edx,%eax
  1005ca:	c1 f8 02             	sar    $0x2,%eax
  1005cd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d3:	83 e8 01             	sub    $0x1,%eax
  1005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e7:	00 
  1005e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f9:	89 04 24             	mov    %eax,(%esp)
  1005fc:	e8 e7 fd ff ff       	call   1003e8 <stab_binsearch>
    if (lfile == 0)
  100601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100604:	85 c0                	test   %eax,%eax
  100606:	75 0a                	jne    100612 <debuginfo_eip+0xd4>
        return -1;
  100608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060d:	e9 67 02 00 00       	jmp    100879 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061e:	8b 45 08             	mov    0x8(%ebp),%eax
  100621:	89 44 24 10          	mov    %eax,0x10(%esp)
  100625:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062c:	00 
  10062d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100630:	89 44 24 08          	mov    %eax,0x8(%esp)
  100634:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	89 04 24             	mov    %eax,(%esp)
  100641:	e8 a2 fd ff ff       	call   1003e8 <stab_binsearch>

    if (lfun <= rfun) {
  100646:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	7f 7c                	jg     1006cc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066d:	29 c1                	sub    %eax,%ecx
  10066f:	89 c8                	mov    %ecx,%eax
  100671:	39 c2                	cmp    %eax,%edx
  100673:	73 22                	jae    100697 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	89 d0                	mov    %edx,%eax
  10067c:	01 c0                	add    %eax,%eax
  10067e:	01 d0                	add    %edx,%eax
  100680:	c1 e0 02             	shl    $0x2,%eax
  100683:	89 c2                	mov    %eax,%edx
  100685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100688:	01 d0                	add    %edx,%eax
  10068a:	8b 10                	mov    (%eax),%edx
  10068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10068f:	01 c2                	add    %eax,%edx
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	89 d0                	mov    %edx,%eax
  10069e:	01 c0                	add    %eax,%eax
  1006a0:	01 d0                	add    %edx,%eax
  1006a2:	c1 e0 02             	shl    $0x2,%eax
  1006a5:	89 c2                	mov    %eax,%edx
  1006a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006aa:	01 d0                	add    %edx,%eax
  1006ac:	8b 50 08             	mov    0x8(%eax),%edx
  1006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b8:	8b 40 10             	mov    0x10(%eax),%eax
  1006bb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ca:	eb 15                	jmp    1006e1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e4:	8b 40 08             	mov    0x8(%eax),%eax
  1006e7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ee:	00 
  1006ef:	89 04 24             	mov    %eax,(%esp)
  1006f2:	e8 6b 56 00 00       	call   105d62 <strfind>
  1006f7:	89 c2                	mov    %eax,%edx
  1006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fc:	8b 40 08             	mov    0x8(%eax),%eax
  1006ff:	29 c2                	sub    %eax,%edx
  100701:	8b 45 0c             	mov    0xc(%ebp),%eax
  100704:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100707:	8b 45 08             	mov    0x8(%ebp),%eax
  10070a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100715:	00 
  100716:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100719:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100720:	89 44 24 04          	mov    %eax,0x4(%esp)
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	89 04 24             	mov    %eax,(%esp)
  10072a:	e8 b9 fc ff ff       	call   1003e8 <stab_binsearch>
    if (lline <= rline) {
  10072f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100732:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100735:	39 c2                	cmp    %eax,%edx
  100737:	7f 24                	jg     10075d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	89 d0                	mov    %edx,%eax
  100740:	01 c0                	add    %eax,%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	c1 e0 02             	shl    $0x2,%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100752:	0f b7 d0             	movzwl %ax,%edx
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075b:	eb 13                	jmp    100770 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100762:	e9 12 01 00 00       	jmp    100879 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	83 e8 01             	sub    $0x1,%eax
  10076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100770:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	39 c2                	cmp    %eax,%edx
  100778:	7c 56                	jl     1007d0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	89 d0                	mov    %edx,%eax
  100781:	01 c0                	add    %eax,%eax
  100783:	01 d0                	add    %edx,%eax
  100785:	c1 e0 02             	shl    $0x2,%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078d:	01 d0                	add    %edx,%eax
  10078f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100793:	3c 84                	cmp    $0x84,%al
  100795:	74 39                	je     1007d0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	89 d0                	mov    %edx,%eax
  10079e:	01 c0                	add    %eax,%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	c1 e0 02             	shl    $0x2,%eax
  1007a5:	89 c2                	mov    %eax,%edx
  1007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007aa:	01 d0                	add    %edx,%eax
  1007ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b0:	3c 64                	cmp    $0x64,%al
  1007b2:	75 b3                	jne    100767 <debuginfo_eip+0x229>
  1007b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	89 d0                	mov    %edx,%eax
  1007bb:	01 c0                	add    %eax,%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	c1 e0 02             	shl    $0x2,%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	8b 40 08             	mov    0x8(%eax),%eax
  1007cc:	85 c0                	test   %eax,%eax
  1007ce:	74 97                	je     100767 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	7c 46                	jl     100820 <debuginfo_eip+0x2e2>
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f7:	29 c1                	sub    %eax,%ecx
  1007f9:	89 c8                	mov    %ecx,%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 4a                	jge    100874 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	83 c0 01             	add    $0x1,%eax
  100830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100833:	eb 18                	jmp    10084d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100835:	8b 45 0c             	mov    0xc(%ebp),%eax
  100838:	8b 40 14             	mov    0x14(%eax),%eax
  10083b:	8d 50 01             	lea    0x1(%eax),%edx
  10083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100841:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100847:	83 c0 01             	add    $0x1,%eax
  10084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100850:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100853:	39 c2                	cmp    %eax,%edx
  100855:	7d 1d                	jge    100874 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	89 d0                	mov    %edx,%eax
  10085e:	01 c0                	add    %eax,%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	c1 e0 02             	shl    $0x2,%eax
  100865:	89 c2                	mov    %eax,%edx
  100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086a:	01 d0                	add    %edx,%eax
  10086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100870:	3c a0                	cmp    $0xa0,%al
  100872:	74 c1                	je     100835 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100879:	c9                   	leave  
  10087a:	c3                   	ret    

0010087b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087b:	55                   	push   %ebp
  10087c:	89 e5                	mov    %esp,%ebp
  10087e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100881:	c7 04 24 36 61 10 00 	movl   $0x106136,(%esp)
  100888:	e8 ba fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088d:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 4f 61 10 00 	movl   $0x10614f,(%esp)
  10089c:	e8 a6 fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a1:	c7 44 24 04 77 60 10 	movl   $0x106077,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 67 61 10 00 	movl   $0x106167,(%esp)
  1008b0:	e8 92 fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b5:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bc:	00 
  1008bd:	c7 04 24 7f 61 10 00 	movl   $0x10617f,(%esp)
  1008c4:	e8 7e fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c9:	c7 44 24 04 c8 89 11 	movl   $0x1189c8,0x4(%esp)
  1008d0:	00 
  1008d1:	c7 04 24 97 61 10 00 	movl   $0x106197,(%esp)
  1008d8:	e8 6a fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008dd:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  1008e2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e8:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008ed:	29 c2                	sub    %eax,%edx
  1008ef:	89 d0                	mov    %edx,%eax
  1008f1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	0f 48 c2             	cmovs  %edx,%eax
  1008fc:	c1 f8 0a             	sar    $0xa,%eax
  1008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100903:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  10090a:	e8 38 fa ff ff       	call   100347 <cprintf>
}
  10090f:	c9                   	leave  
  100910:	c3                   	ret    

00100911 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100911:	55                   	push   %ebp
  100912:	89 e5                	mov    %esp,%ebp
  100914:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100921:	8b 45 08             	mov    0x8(%ebp),%eax
  100924:	89 04 24             	mov    %eax,(%esp)
  100927:	e8 12 fc ff ff       	call   10053e <debuginfo_eip>
  10092c:	85 c0                	test   %eax,%eax
  10092e:	74 15                	je     100945 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100930:	8b 45 08             	mov    0x8(%ebp),%eax
  100933:	89 44 24 04          	mov    %eax,0x4(%esp)
  100937:	c7 04 24 da 61 10 00 	movl   $0x1061da,(%esp)
  10093e:	e8 04 fa ff ff       	call   100347 <cprintf>
  100943:	eb 6d                	jmp    1009b2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094c:	eb 1c                	jmp    10096a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100954:	01 d0                	add    %edx,%eax
  100956:	0f b6 00             	movzbl (%eax),%eax
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100962:	01 ca                	add    %ecx,%edx
  100964:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100966:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100970:	7f dc                	jg     10094e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100972:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097b:	01 d0                	add    %edx,%eax
  10097d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100980:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100983:	8b 55 08             	mov    0x8(%ebp),%edx
  100986:	89 d1                	mov    %edx,%ecx
  100988:	29 c1                	sub    %eax,%ecx
  10098a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100990:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100994:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099e:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a6:	c7 04 24 f6 61 10 00 	movl   $0x1061f6,(%esp)
  1009ad:	e8 95 f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b2:	c9                   	leave  
  1009b3:	c3                   	ret    

001009b4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b4:	55                   	push   %ebp
  1009b5:	89 e5                	mov    %esp,%ebp
  1009b7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009ba:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c3:	c9                   	leave  
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cb:	89 e8                	mov    %ebp,%eax
  1009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009d6:	e8 d9 ff ff ff       	call   1009b4 <read_eip>
  1009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e5:	e9 88 00 00 00       	jmp    100a72 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 08 62 10 00 	movl   $0x106208,(%esp)
  1009ff:	e8 43 f9 ff ff       	call   100347 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 25                	jmp    100a3b <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 24 62 10 00 	movl   $0x106224,(%esp)
  100a32:	e8 10 f9 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3f:	7e d5                	jle    100a16 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a41:	c7 04 24 2c 62 10 00 	movl   $0x10622c,(%esp)
  100a48:	e8 fa f8 ff ff       	call   100347 <cprintf>
        print_debuginfo(eip - 1);
  100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a50:	83 e8 01             	sub    $0x1,%eax
  100a53:	89 04 24             	mov    %eax,(%esp)
  100a56:	e8 b6 fe ff ff       	call   100911 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	83 c0 04             	add    $0x4,%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	8b 00                	mov    (%eax),%eax
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a76:	74 0a                	je     100a82 <print_stackframe+0xbd>
  100a78:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7c:	0f 8e 68 ff ff ff    	jle    1009ea <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a82:	c9                   	leave  
  100a83:	c3                   	ret    

00100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a91:	eb 0c                	jmp    100a9f <parse+0x1b>
            *buf ++ = '\0';
  100a93:	8b 45 08             	mov    0x8(%ebp),%eax
  100a96:	8d 50 01             	lea    0x1(%eax),%edx
  100a99:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	74 1d                	je     100ac6 <parse+0x42>
  100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aac:	0f b6 00             	movzbl (%eax),%eax
  100aaf:	0f be c0             	movsbl %al,%eax
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 b0 62 10 00 	movl   $0x1062b0,(%esp)
  100abd:	e8 6d 52 00 00       	call   105d2f <strchr>
  100ac2:	85 c0                	test   %eax,%eax
  100ac4:	75 cd                	jne    100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	0f b6 00             	movzbl (%eax),%eax
  100acc:	84 c0                	test   %al,%al
  100ace:	75 02                	jne    100ad2 <parse+0x4e>
            break;
  100ad0:	eb 67                	jmp    100b39 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad6:	75 14                	jne    100aec <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adf:	00 
  100ae0:	c7 04 24 b5 62 10 00 	movl   $0x1062b5,(%esp)
  100ae7:	e8 5b f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	8d 50 01             	lea    0x1(%eax),%edx
  100af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aff:	01 c2                	add    %eax,%edx
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b06:	eb 04                	jmp    100b0c <parse+0x88>
            buf ++;
  100b08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0f:	0f b6 00             	movzbl (%eax),%eax
  100b12:	84 c0                	test   %al,%al
  100b14:	74 1d                	je     100b33 <parse+0xaf>
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	0f b6 00             	movzbl (%eax),%eax
  100b1c:	0f be c0             	movsbl %al,%eax
  100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b23:	c7 04 24 b0 62 10 00 	movl   $0x1062b0,(%esp)
  100b2a:	e8 00 52 00 00       	call   105d2f <strchr>
  100b2f:	85 c0                	test   %eax,%eax
  100b31:	74 d5                	je     100b08 <parse+0x84>
            buf ++;
        }
    }
  100b33:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b34:	e9 66 ff ff ff       	jmp    100a9f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3c:	c9                   	leave  
  100b3d:	c3                   	ret    

00100b3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3e:	55                   	push   %ebp
  100b3f:	89 e5                	mov    %esp,%ebp
  100b41:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b44:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	89 04 24             	mov    %eax,(%esp)
  100b51:	e8 2e ff ff ff       	call   100a84 <parse>
  100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5d:	75 0a                	jne    100b69 <runcmd+0x2b>
        return 0;
  100b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b64:	e9 85 00 00 00       	jmp    100bee <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b70:	eb 5c                	jmp    100bce <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b72:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b78:	89 d0                	mov    %edx,%eax
  100b7a:	01 c0                	add    %eax,%eax
  100b7c:	01 d0                	add    %edx,%eax
  100b7e:	c1 e0 02             	shl    $0x2,%eax
  100b81:	05 20 70 11 00       	add    $0x117020,%eax
  100b86:	8b 00                	mov    (%eax),%eax
  100b88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8c:	89 04 24             	mov    %eax,(%esp)
  100b8f:	e8 fc 50 00 00       	call   105c90 <strcmp>
  100b94:	85 c0                	test   %eax,%eax
  100b96:	75 32                	jne    100bca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9b:	89 d0                	mov    %edx,%eax
  100b9d:	01 c0                	add    %eax,%eax
  100b9f:	01 d0                	add    %edx,%eax
  100ba1:	c1 e0 02             	shl    $0x2,%eax
  100ba4:	05 20 70 11 00       	add    $0x117020,%eax
  100ba9:	8b 40 08             	mov    0x8(%eax),%eax
  100bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100baf:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb5:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb9:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bbc:	83 c2 04             	add    $0x4,%edx
  100bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc3:	89 0c 24             	mov    %ecx,(%esp)
  100bc6:	ff d0                	call   *%eax
  100bc8:	eb 24                	jmp    100bee <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd1:	83 f8 02             	cmp    $0x2,%eax
  100bd4:	76 9c                	jbe    100b72 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	c7 04 24 d3 62 10 00 	movl   $0x1062d3,(%esp)
  100be4:	e8 5e f7 ff ff       	call   100347 <cprintf>
    return 0;
  100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bee:	c9                   	leave  
  100bef:	c3                   	ret    

00100bf0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf0:	55                   	push   %ebp
  100bf1:	89 e5                	mov    %esp,%ebp
  100bf3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf6:	c7 04 24 ec 62 10 00 	movl   $0x1062ec,(%esp)
  100bfd:	e8 45 f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c02:	c7 04 24 14 63 10 00 	movl   $0x106314,(%esp)
  100c09:	e8 39 f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c12:	74 0b                	je     100c1f <kmonitor+0x2f>
        print_trapframe(tf);
  100c14:	8b 45 08             	mov    0x8(%ebp),%eax
  100c17:	89 04 24             	mov    %eax,(%esp)
  100c1a:	e8 56 0e 00 00       	call   101a75 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1f:	c7 04 24 39 63 10 00 	movl   $0x106339,(%esp)
  100c26:	e8 13 f6 ff ff       	call   10023e <readline>
  100c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c32:	74 18                	je     100c4c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c34:	8b 45 08             	mov    0x8(%ebp),%eax
  100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3e:	89 04 24             	mov    %eax,(%esp)
  100c41:	e8 f8 fe ff ff       	call   100b3e <runcmd>
  100c46:	85 c0                	test   %eax,%eax
  100c48:	79 02                	jns    100c4c <kmonitor+0x5c>
                break;
  100c4a:	eb 02                	jmp    100c4e <kmonitor+0x5e>
            }
        }
    }
  100c4c:	eb d1                	jmp    100c1f <kmonitor+0x2f>
}
  100c4e:	c9                   	leave  
  100c4f:	c3                   	ret    

00100c50 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c50:	55                   	push   %ebp
  100c51:	89 e5                	mov    %esp,%ebp
  100c53:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5d:	eb 3f                	jmp    100c9e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c62:	89 d0                	mov    %edx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 d0                	add    %edx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 20 70 11 00       	add    $0x117020,%eax
  100c70:	8b 48 04             	mov    0x4(%eax),%ecx
  100c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c76:	89 d0                	mov    %edx,%eax
  100c78:	01 c0                	add    %eax,%eax
  100c7a:	01 d0                	add    %edx,%eax
  100c7c:	c1 e0 02             	shl    $0x2,%eax
  100c7f:	05 20 70 11 00       	add    $0x117020,%eax
  100c84:	8b 00                	mov    (%eax),%eax
  100c86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8e:	c7 04 24 3d 63 10 00 	movl   $0x10633d,(%esp)
  100c95:	e8 ad f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca1:	83 f8 02             	cmp    $0x2,%eax
  100ca4:	76 b9                	jbe    100c5f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cab:	c9                   	leave  
  100cac:	c3                   	ret    

00100cad <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cad:	55                   	push   %ebp
  100cae:	89 e5                	mov    %esp,%ebp
  100cb0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb3:	e8 c3 fb ff ff       	call   10087b <print_kerninfo>
    return 0;
  100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbd:	c9                   	leave  
  100cbe:	c3                   	ret    

00100cbf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbf:	55                   	push   %ebp
  100cc0:	89 e5                	mov    %esp,%ebp
  100cc2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc5:	e8 fb fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccf:	c9                   	leave  
  100cd0:	c3                   	ret    

00100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd7:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cdc:	85 c0                	test   %eax,%eax
  100cde:	74 02                	je     100ce2 <__panic+0x11>
        goto panic_dead;
  100ce0:	eb 48                	jmp    100d2a <__panic+0x59>
    }
    is_panic = 1;
  100ce2:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cec:	8d 45 14             	lea    0x14(%ebp),%eax
  100cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d00:	c7 04 24 46 63 10 00 	movl   $0x106346,(%esp)
  100d07:	e8 3b f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d13:	8b 45 10             	mov    0x10(%ebp),%eax
  100d16:	89 04 24             	mov    %eax,(%esp)
  100d19:	e8 f6 f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d1e:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  100d25:	e8 1d f6 ff ff       	call   100347 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d2a:	e8 85 09 00 00       	call   1016b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d36:	e8 b5 fe ff ff       	call   100bf0 <kmonitor>
    }
  100d3b:	eb f2                	jmp    100d2f <__panic+0x5e>

00100d3d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d43:	8d 45 14             	lea    0x14(%ebp),%eax
  100d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d50:	8b 45 08             	mov    0x8(%ebp),%eax
  100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d57:	c7 04 24 64 63 10 00 	movl   $0x106364,(%esp)
  100d5e:	e8 e4 f5 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6d:	89 04 24             	mov    %eax,(%esp)
  100d70:	e8 9f f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d75:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  100d7c:	e8 c6 f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d81:	c9                   	leave  
  100d82:	c3                   	ret    

00100d83 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d83:	55                   	push   %ebp
  100d84:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d86:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d8b:	5d                   	pop    %ebp
  100d8c:	c3                   	ret    

00100d8d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8d:	55                   	push   %ebp
  100d8e:	89 e5                	mov    %esp,%ebp
  100d90:	83 ec 28             	sub    $0x28,%esp
  100d93:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d99:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
  100da6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dac:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db8:	ee                   	out    %al,(%dx)
  100db9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dcb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dcc:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dd3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd6:	c7 04 24 82 63 10 00 	movl   $0x106382,(%esp)
  100ddd:	e8 65 f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de9:	e8 24 09 00 00       	call   101712 <pic_enable>
}
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df6:	9c                   	pushf  
  100df7:	58                   	pop    %eax
  100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfe:	25 00 02 00 00       	and    $0x200,%eax
  100e03:	85 c0                	test   %eax,%eax
  100e05:	74 0c                	je     100e13 <__intr_save+0x23>
        intr_disable();
  100e07:	e8 a8 08 00 00       	call   1016b4 <intr_disable>
        return 1;
  100e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  100e11:	eb 05                	jmp    100e18 <__intr_save+0x28>
    }
    return 0;
  100e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e18:	c9                   	leave  
  100e19:	c3                   	ret    

00100e1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e1a:	55                   	push   %ebp
  100e1b:	89 e5                	mov    %esp,%ebp
  100e1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e24:	74 05                	je     100e2b <__intr_restore+0x11>
        intr_enable();
  100e26:	e8 83 08 00 00       	call   1016ae <intr_enable>
    }
}
  100e2b:	c9                   	leave  
  100e2c:	c3                   	ret    

00100e2d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2d:	55                   	push   %ebp
  100e2e:	89 e5                	mov    %esp,%ebp
  100e30:	83 ec 10             	sub    $0x10,%esp
  100e33:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3d:	89 c2                	mov    %eax,%edx
  100e3f:	ec                   	in     (%dx),%al
  100e40:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e63:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e69:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e73:	c9                   	leave  
  100e74:	c3                   	ret    

00100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e75:	55                   	push   %ebp
  100e76:	89 e5                	mov    %esp,%ebp
  100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e85:	0f b7 00             	movzwl (%eax),%eax
  100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 00             	movzwl (%eax),%eax
  100e9a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9e:	74 12                	je     100eb2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea7:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eae:	b4 03 
  100eb0:	eb 13                	jmp    100ec5 <cga_init+0x50>
    } else {
        *cp = was;
  100eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ebc:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ec3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100edb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee7:	83 c0 01             	add    $0x1,%eax
  100eea:	0f b7 c0             	movzwl %ax,%eax
  100eed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef5:	89 c2                	mov    %eax,%edx
  100ef7:	ec                   	in     (%dx),%al
  100ef8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eff:	0f b6 c0             	movzbl %al,%eax
  100f02:	c1 e0 08             	shl    $0x8,%eax
  100f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f08:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f16:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f23:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f2a:	83 c0 01             	add    $0x1,%eax
  100f2d:	0f b7 c0             	movzwl %ax,%eax
  100f30:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f34:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f38:	89 c2                	mov    %eax,%edx
  100f3a:	ec                   	in     (%dx),%al
  100f3b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f42:	0f b6 c0             	movzbl %al,%eax
  100f45:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f4b:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f53:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f59:	c9                   	leave  
  100f5a:	c3                   	ret    

00100f5b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f5b:	55                   	push   %ebp
  100f5c:	89 e5                	mov    %esp,%ebp
  100f5e:	83 ec 48             	sub    $0x48,%esp
  100f61:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f67:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f7a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
  100f87:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f8d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f99:	ee                   	out    %al,(%dx)
  100f9a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fac:	ee                   	out    %al,(%dx)
  100fad:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fbb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
  100fc0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fce:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd2:	ee                   	out    %al,(%dx)
  100fd3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fdd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe5:	ee                   	out    %al,(%dx)
  100fe6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fec:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff0:	89 c2                	mov    %eax,%edx
  100ff2:	ec                   	in     (%dx),%al
  100ff3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ffa:	3c ff                	cmp    $0xff,%al
  100ffc:	0f 95 c0             	setne  %al
  100fff:	0f b6 c0             	movzbl %al,%eax
  101002:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101007:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101011:	89 c2                	mov    %eax,%edx
  101013:	ec                   	in     (%dx),%al
  101014:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101017:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10101d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101021:	89 c2                	mov    %eax,%edx
  101023:	ec                   	in     (%dx),%al
  101024:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101027:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10102c:	85 c0                	test   %eax,%eax
  10102e:	74 0c                	je     10103c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101030:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101037:	e8 d6 06 00 00       	call   101712 <pic_enable>
    }
}
  10103c:	c9                   	leave  
  10103d:	c3                   	ret    

0010103e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103e:	55                   	push   %ebp
  10103f:	89 e5                	mov    %esp,%ebp
  101041:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10104b:	eb 09                	jmp    101056 <lpt_putc_sub+0x18>
        delay();
  10104d:	e8 db fd ff ff       	call   100e2d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101052:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101056:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101060:	89 c2                	mov    %eax,%edx
  101062:	ec                   	in     (%dx),%al
  101063:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101066:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10106a:	84 c0                	test   %al,%al
  10106c:	78 09                	js     101077 <lpt_putc_sub+0x39>
  10106e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101075:	7e d6                	jle    10104d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101077:	8b 45 08             	mov    0x8(%ebp),%eax
  10107a:	0f b6 c0             	movzbl %al,%eax
  10107d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101083:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101086:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10108a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108e:	ee                   	out    %al,(%dx)
  10108f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101095:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101099:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a1:	ee                   	out    %al,(%dx)
  1010a2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b5:	c9                   	leave  
  1010b6:	c3                   	ret    

001010b7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b7:	55                   	push   %ebp
  1010b8:	89 e5                	mov    %esp,%ebp
  1010ba:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c1:	74 0d                	je     1010d0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c6:	89 04 24             	mov    %eax,(%esp)
  1010c9:	e8 70 ff ff ff       	call   10103e <lpt_putc_sub>
  1010ce:	eb 24                	jmp    1010f4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d7:	e8 62 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010dc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e3:	e8 56 ff ff ff       	call   10103e <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ef:	e8 4a ff ff ff       	call   10103e <lpt_putc_sub>
    }
}
  1010f4:	c9                   	leave  
  1010f5:	c3                   	ret    

001010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f6:	55                   	push   %ebp
  1010f7:	89 e5                	mov    %esp,%ebp
  1010f9:	53                   	push   %ebx
  1010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	b0 00                	mov    $0x0,%al
  101102:	85 c0                	test   %eax,%eax
  101104:	75 07                	jne    10110d <cga_putc+0x17>
        c |= 0x0700;
  101106:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	0f b6 c0             	movzbl %al,%eax
  101113:	83 f8 0a             	cmp    $0xa,%eax
  101116:	74 4c                	je     101164 <cga_putc+0x6e>
  101118:	83 f8 0d             	cmp    $0xd,%eax
  10111b:	74 57                	je     101174 <cga_putc+0x7e>
  10111d:	83 f8 08             	cmp    $0x8,%eax
  101120:	0f 85 88 00 00 00    	jne    1011ae <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101126:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112d:	66 85 c0             	test   %ax,%ax
  101130:	74 30                	je     101162 <cga_putc+0x6c>
            crt_pos --;
  101132:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101139:	83 e8 01             	sub    $0x1,%eax
  10113c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101142:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101147:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114e:	0f b7 d2             	movzwl %dx,%edx
  101151:	01 d2                	add    %edx,%edx
  101153:	01 c2                	add    %eax,%edx
  101155:	8b 45 08             	mov    0x8(%ebp),%eax
  101158:	b0 00                	mov    $0x0,%al
  10115a:	83 c8 20             	or     $0x20,%eax
  10115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101160:	eb 72                	jmp    1011d4 <cga_putc+0xde>
  101162:	eb 70                	jmp    1011d4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101164:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10116b:	83 c0 50             	add    $0x50,%eax
  10116e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101174:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10117b:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101182:	0f b7 c1             	movzwl %cx,%eax
  101185:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10118b:	c1 e8 10             	shr    $0x10,%eax
  10118e:	89 c2                	mov    %eax,%edx
  101190:	66 c1 ea 06          	shr    $0x6,%dx
  101194:	89 d0                	mov    %edx,%eax
  101196:	c1 e0 02             	shl    $0x2,%eax
  101199:	01 d0                	add    %edx,%eax
  10119b:	c1 e0 04             	shl    $0x4,%eax
  10119e:	29 c1                	sub    %eax,%ecx
  1011a0:	89 ca                	mov    %ecx,%edx
  1011a2:	89 d8                	mov    %ebx,%eax
  1011a4:	29 d0                	sub    %edx,%eax
  1011a6:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011ac:	eb 26                	jmp    1011d4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ae:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011bb:	8d 50 01             	lea    0x1(%eax),%edx
  1011be:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c5:	0f b7 c0             	movzwl %ax,%eax
  1011c8:	01 c0                	add    %eax,%eax
  1011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011db:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011df:	76 5b                	jbe    10123c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ec:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f8:	00 
  1011f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fd:	89 04 24             	mov    %eax,(%esp)
  101200:	e8 28 4d 00 00       	call   105f2d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101205:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120c:	eb 15                	jmp    101223 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101216:	01 d2                	add    %edx,%edx
  101218:	01 d0                	add    %edx,%eax
  10121a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10122a:	7e e2                	jle    10120e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101233:	83 e8 50             	sub    $0x50,%eax
  101236:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101243:	0f b7 c0             	movzwl %ax,%eax
  101246:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10124a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101257:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125e:	66 c1 e8 08          	shr    $0x8,%ax
  101262:	0f b6 c0             	movzbl %al,%eax
  101265:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10126c:	83 c2 01             	add    $0x1,%edx
  10126f:	0f b7 d2             	movzwl %dx,%edx
  101272:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101276:	88 45 ed             	mov    %al,-0x13(%ebp)
  101279:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10127d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101282:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101289:	0f b7 c0             	movzwl %ax,%eax
  10128c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101290:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101294:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101298:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a4:	0f b6 c0             	movzbl %al,%eax
  1012a7:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012ae:	83 c2 01             	add    $0x1,%edx
  1012b1:	0f b7 d2             	movzwl %dx,%edx
  1012b4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c3:	ee                   	out    %al,(%dx)
}
  1012c4:	83 c4 34             	add    $0x34,%esp
  1012c7:	5b                   	pop    %ebx
  1012c8:	5d                   	pop    %ebp
  1012c9:	c3                   	ret    

001012ca <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ca:	55                   	push   %ebp
  1012cb:	89 e5                	mov    %esp,%ebp
  1012cd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d7:	eb 09                	jmp    1012e2 <serial_putc_sub+0x18>
        delay();
  1012d9:	e8 4f fb ff ff       	call   100e2d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ec:	89 c2                	mov    %eax,%edx
  1012ee:	ec                   	in     (%dx),%al
  1012ef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f6:	0f b6 c0             	movzbl %al,%eax
  1012f9:	83 e0 20             	and    $0x20,%eax
  1012fc:	85 c0                	test   %eax,%eax
  1012fe:	75 09                	jne    101309 <serial_putc_sub+0x3f>
  101300:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101307:	7e d0                	jle    1012d9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101309:	8b 45 08             	mov    0x8(%ebp),%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101315:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101318:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10131c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101320:	ee                   	out    %al,(%dx)
}
  101321:	c9                   	leave  
  101322:	c3                   	ret    

00101323 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101323:	55                   	push   %ebp
  101324:	89 e5                	mov    %esp,%ebp
  101326:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101329:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132d:	74 0d                	je     10133c <serial_putc+0x19>
        serial_putc_sub(c);
  10132f:	8b 45 08             	mov    0x8(%ebp),%eax
  101332:	89 04 24             	mov    %eax,(%esp)
  101335:	e8 90 ff ff ff       	call   1012ca <serial_putc_sub>
  10133a:	eb 24                	jmp    101360 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10133c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101343:	e8 82 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub(' ');
  101348:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134f:	e8 76 ff ff ff       	call   1012ca <serial_putc_sub>
        serial_putc_sub('\b');
  101354:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10135b:	e8 6a ff ff ff       	call   1012ca <serial_putc_sub>
    }
}
  101360:	c9                   	leave  
  101361:	c3                   	ret    

00101362 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101362:	55                   	push   %ebp
  101363:	89 e5                	mov    %esp,%ebp
  101365:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101368:	eb 33                	jmp    10139d <cons_intr+0x3b>
        if (c != 0) {
  10136a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136e:	74 2d                	je     10139d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101370:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101375:	8d 50 01             	lea    0x1(%eax),%edx
  101378:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101381:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101387:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10138c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101391:	75 0a                	jne    10139d <cons_intr+0x3b>
                cons.wpos = 0;
  101393:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10139a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10139d:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a0:	ff d0                	call   *%eax
  1013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a9:	75 bf                	jne    10136a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 10             	sub    $0x10,%esp
  1013b3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 07                	jne    1013d8 <serial_proc_data+0x2b>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	eb 2a                	jmp    101402 <serial_proc_data+0x55>
  1013d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e2:	89 c2                	mov    %eax,%edx
  1013e4:	ec                   	in     (%dx),%al
  1013e5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ec:	0f b6 c0             	movzbl %al,%eax
  1013ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f6:	75 07                	jne    1013ff <serial_proc_data+0x52>
        c = '\b';
  1013f8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101402:	c9                   	leave  
  101403:	c3                   	ret    

00101404 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101404:	55                   	push   %ebp
  101405:	89 e5                	mov    %esp,%ebp
  101407:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10140a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140f:	85 c0                	test   %eax,%eax
  101411:	74 0c                	je     10141f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101413:	c7 04 24 ad 13 10 00 	movl   $0x1013ad,(%esp)
  10141a:	e8 43 ff ff ff       	call   101362 <cons_intr>
    }
}
  10141f:	c9                   	leave  
  101420:	c3                   	ret    

00101421 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 38             	sub    $0x38,%esp
  101427:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101431:	89 c2                	mov    %eax,%edx
  101433:	ec                   	in     (%dx),%al
  101434:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101437:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10143b:	0f b6 c0             	movzbl %al,%eax
  10143e:	83 e0 01             	and    $0x1,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	75 0a                	jne    10144f <kbd_proc_data+0x2e>
        return -1;
  101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10144a:	e9 59 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
  10144f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101455:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101459:	89 c2                	mov    %eax,%edx
  10145b:	ec                   	in     (%dx),%al
  10145c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101463:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101466:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10146a:	75 17                	jne    101483 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10146c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101471:	83 c8 40             	or     $0x40,%eax
  101474:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101479:	b8 00 00 00 00       	mov    $0x0,%eax
  10147e:	e9 25 01 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101487:	84 c0                	test   %al,%al
  101489:	79 47                	jns    1014d2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10148b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101490:	83 e0 40             	and    $0x40,%eax
  101493:	85 c0                	test   %eax,%eax
  101495:	75 09                	jne    1014a0 <kbd_proc_data+0x7f>
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	83 e0 7f             	and    $0x7f,%eax
  10149e:	eb 04                	jmp    1014a4 <kbd_proc_data+0x83>
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b2:	83 c8 40             	or     $0x40,%eax
  1014b5:	0f b6 c0             	movzbl %al,%eax
  1014b8:	f7 d0                	not    %eax
  1014ba:	89 c2                	mov    %eax,%edx
  1014bc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c1:	21 d0                	and    %edx,%eax
  1014c3:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cd:	e9 d6 00 00 00       	jmp    1015a8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d7:	83 e0 40             	and    $0x40,%eax
  1014da:	85 c0                	test   %eax,%eax
  1014dc:	74 11                	je     1014ef <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014de:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ea:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f3:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014fa:	0f b6 d0             	movzbl %al,%edx
  1014fd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101502:	09 d0                	or     %edx,%eax
  101504:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150d:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101514:	0f b6 d0             	movzbl %al,%edx
  101517:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151c:	31 d0                	xor    %edx,%eax
  10151e:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101523:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101528:	83 e0 03             	and    $0x3,%eax
  10152b:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101532:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101536:	01 d0                	add    %edx,%eax
  101538:	0f b6 00             	movzbl (%eax),%eax
  10153b:	0f b6 c0             	movzbl %al,%eax
  10153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101541:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101546:	83 e0 08             	and    $0x8,%eax
  101549:	85 c0                	test   %eax,%eax
  10154b:	74 22                	je     10156f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10154d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101551:	7e 0c                	jle    10155f <kbd_proc_data+0x13e>
  101553:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101557:	7f 06                	jg     10155f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101559:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155d:	eb 10                	jmp    10156f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101563:	7e 0a                	jle    10156f <kbd_proc_data+0x14e>
  101565:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101569:	7f 04                	jg     10156f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10156b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101574:	f7 d0                	not    %eax
  101576:	83 e0 06             	and    $0x6,%eax
  101579:	85 c0                	test   %eax,%eax
  10157b:	75 28                	jne    1015a5 <kbd_proc_data+0x184>
  10157d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101584:	75 1f                	jne    1015a5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101586:	c7 04 24 9d 63 10 00 	movl   $0x10639d,(%esp)
  10158d:	e8 b5 ed ff ff       	call   100347 <cprintf>
  101592:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101598:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10159c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a8:	c9                   	leave  
  1015a9:	c3                   	ret    

001015aa <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b0:	c7 04 24 21 14 10 00 	movl   $0x101421,(%esp)
  1015b7:	e8 a6 fd ff ff       	call   101362 <cons_intr>
}
  1015bc:	c9                   	leave  
  1015bd:	c3                   	ret    

001015be <kbd_init>:

static void
kbd_init(void) {
  1015be:	55                   	push   %ebp
  1015bf:	89 e5                	mov    %esp,%ebp
  1015c1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c4:	e8 e1 ff ff ff       	call   1015aa <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d0:	e8 3d 01 00 00       	call   101712 <pic_enable>
}
  1015d5:	c9                   	leave  
  1015d6:	c3                   	ret    

001015d7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d7:	55                   	push   %ebp
  1015d8:	89 e5                	mov    %esp,%ebp
  1015da:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015dd:	e8 93 f8 ff ff       	call   100e75 <cga_init>
    serial_init();
  1015e2:	e8 74 f9 ff ff       	call   100f5b <serial_init>
    kbd_init();
  1015e7:	e8 d2 ff ff ff       	call   1015be <kbd_init>
    if (!serial_exists) {
  1015ec:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015f1:	85 c0                	test   %eax,%eax
  1015f3:	75 0c                	jne    101601 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f5:	c7 04 24 a9 63 10 00 	movl   $0x1063a9,(%esp)
  1015fc:	e8 46 ed ff ff       	call   100347 <cprintf>
    }
}
  101601:	c9                   	leave  
  101602:	c3                   	ret    

00101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101603:	55                   	push   %ebp
  101604:	89 e5                	mov    %esp,%ebp
  101606:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101609:	e8 e2 f7 ff ff       	call   100df0 <__intr_save>
  10160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 9b fa ff ff       	call   1010b7 <lpt_putc>
        cga_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 cf fa ff ff       	call   1010f6 <cga_putc>
        serial_putc(c);
  101627:	8b 45 08             	mov    0x8(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 f1 fc ff ff       	call   101323 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 dd f7 ff ff       	call   100e1a <__intr_restore>
}
  10163d:	c9                   	leave  
  10163e:	c3                   	ret    

0010163f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163f:	55                   	push   %ebp
  101640:	89 e5                	mov    %esp,%ebp
  101642:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164c:	e8 9f f7 ff ff       	call   100df0 <__intr_save>
  101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101654:	e8 ab fd ff ff       	call   101404 <serial_intr>
        kbd_intr();
  101659:	e8 4c ff ff ff       	call   1015aa <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165e:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101664:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101669:	39 c2                	cmp    %eax,%edx
  10166b:	74 31                	je     10169e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101672:	8d 50 01             	lea    0x1(%eax),%edx
  101675:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10167b:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101682:	0f b6 c0             	movzbl %al,%eax
  101685:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101688:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10168d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101692:	75 0a                	jne    10169e <cons_getc+0x5f>
                cons.rpos = 0;
  101694:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10169b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a1:	89 04 24             	mov    %eax,(%esp)
  1016a4:	e8 71 f7 ff ff       	call   100e1a <__intr_restore>
    return c;
  1016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016ac:	c9                   	leave  
  1016ad:	c3                   	ret    

001016ae <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016b1:	fb                   	sti    
    sti();
}
  1016b2:	5d                   	pop    %ebp
  1016b3:	c3                   	ret    

001016b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b7:	fa                   	cli    
    cli();
}
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 14             	sub    $0x14,%esp
  1016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016cb:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016d1:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d6:	85 c0                	test   %eax,%eax
  1016d8:	74 36                	je     101710 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016ea:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f7:	66 c1 e8 08          	shr    $0x8,%ax
  1016fb:	0f b6 c0             	movzbl %al,%eax
  1016fe:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101704:	88 45 f9             	mov    %al,-0x7(%ebp)
  101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
    }
}
  101710:	c9                   	leave  
  101711:	c3                   	ret    

00101712 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101712:	55                   	push   %ebp
  101713:	89 e5                	mov    %esp,%ebp
  101715:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101718:	8b 45 08             	mov    0x8(%ebp),%eax
  10171b:	ba 01 00 00 00       	mov    $0x1,%edx
  101720:	89 c1                	mov    %eax,%ecx
  101722:	d3 e2                	shl    %cl,%edx
  101724:	89 d0                	mov    %edx,%eax
  101726:	f7 d0                	not    %eax
  101728:	89 c2                	mov    %eax,%edx
  10172a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101731:	21 d0                	and    %edx,%eax
  101733:	0f b7 c0             	movzwl %ax,%eax
  101736:	89 04 24             	mov    %eax,(%esp)
  101739:	e8 7c ff ff ff       	call   1016ba <pic_setmask>
}
  10173e:	c9                   	leave  
  10173f:	c3                   	ret    

00101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101740:	55                   	push   %ebp
  101741:	89 e5                	mov    %esp,%ebp
  101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101746:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10174d:	00 00 00 
  101750:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101756:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101769:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10176d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101771:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101780:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101784:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101793:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101797:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
  1017c2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017cc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d4:	ee                   	out    %al,(%dx)
  1017d5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017db:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
  1017e8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ee:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017fa:	ee                   	out    %al,(%dx)
  1017fb:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101801:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101805:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101809:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10180d:	ee                   	out    %al,(%dx)
  10180e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101814:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101818:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101820:	ee                   	out    %al,(%dx)
  101821:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101827:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10182b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101833:	ee                   	out    %al,(%dx)
  101834:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10183a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101842:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101846:	ee                   	out    %al,(%dx)
  101847:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10184d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101851:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101855:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101859:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10185a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101861:	66 83 f8 ff          	cmp    $0xffff,%ax
  101865:	74 12                	je     101879 <pic_init+0x139>
        pic_setmask(irq_mask);
  101867:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186e:	0f b7 c0             	movzwl %ax,%eax
  101871:	89 04 24             	mov    %eax,(%esp)
  101874:	e8 41 fe ff ff       	call   1016ba <pic_setmask>
    }
}
  101879:	c9                   	leave  
  10187a:	c3                   	ret    

0010187b <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10187b:	55                   	push   %ebp
  10187c:	89 e5                	mov    %esp,%ebp
  10187e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101881:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101888:	00 
  101889:	c7 04 24 e0 63 10 00 	movl   $0x1063e0,(%esp)
  101890:	e8 b2 ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101895:	c7 04 24 ea 63 10 00 	movl   $0x1063ea,(%esp)
  10189c:	e8 a6 ea ff ff       	call   100347 <cprintf>
    panic("EOT: kernel seems ok.");
  1018a1:	c7 44 24 08 f8 63 10 	movl   $0x1063f8,0x8(%esp)
  1018a8:	00 
  1018a9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018b0:	00 
  1018b1:	c7 04 24 0e 64 10 00 	movl   $0x10640e,(%esp)
  1018b8:	e8 14 f4 ff ff       	call   100cd1 <__panic>

001018bd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018bd:	55                   	push   %ebp
  1018be:	89 e5                	mov    %esp,%ebp
  1018c0:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ca:	e9 c3 00 00 00       	jmp    101992 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018d9:	89 c2                	mov    %eax,%edx
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e5:	00 
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018f0:	00 08 00 
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018fd:	00 
  1018fe:	83 e2 e0             	and    $0xffffffe0,%edx
  101901:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190b:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101912:	00 
  101913:	83 e2 1f             	and    $0x1f,%edx
  101916:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101927:	00 
  101928:	83 e2 f0             	and    $0xfffffff0,%edx
  10192b:	83 ca 0e             	or     $0xe,%edx
  10192e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193f:	00 
  101940:	83 e2 ef             	and    $0xffffffef,%edx
  101943:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101954:	00 
  101955:	83 e2 9f             	and    $0xffffff9f,%edx
  101958:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101962:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101969:	00 
  10196a:	83 ca 80             	or     $0xffffff80,%edx
  10196d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10197e:	c1 e8 10             	shr    $0x10,%eax
  101981:	89 c2                	mov    %eax,%edx
  101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101986:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10198d:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10198e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	3d ff 00 00 00       	cmp    $0xff,%eax
  10199a:	0f 86 2f ff ff ff    	jbe    1018cf <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019a0:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019a5:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1019ab:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019b2:	08 00 
  1019b4:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019bb:	83 e0 e0             	and    $0xffffffe0,%eax
  1019be:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019c3:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019ca:	83 e0 1f             	and    $0x1f,%eax
  1019cd:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019d2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d9:	83 e0 f0             	and    $0xfffffff0,%eax
  1019dc:	83 c8 0e             	or     $0xe,%eax
  1019df:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e4:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019eb:	83 e0 ef             	and    $0xffffffef,%eax
  1019ee:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019f3:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019fa:	83 c8 60             	or     $0x60,%eax
  1019fd:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a02:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a09:	83 c8 80             	or     $0xffffff80,%eax
  101a0c:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a11:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a16:	c1 e8 10             	shr    $0x10,%eax
  101a19:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a1f:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a29:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a2c:	c9                   	leave  
  101a2d:	c3                   	ret    

00101a2e <trapname>:

static const char *
trapname(int trapno) {
  101a2e:	55                   	push   %ebp
  101a2f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	83 f8 13             	cmp    $0x13,%eax
  101a37:	77 0c                	ja     101a45 <trapname+0x17>
        return excnames[trapno];
  101a39:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3c:	8b 04 85 60 67 10 00 	mov    0x106760(,%eax,4),%eax
  101a43:	eb 18                	jmp    101a5d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a45:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a49:	7e 0d                	jle    101a58 <trapname+0x2a>
  101a4b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a4f:	7f 07                	jg     101a58 <trapname+0x2a>
        return "Hardware Interrupt";
  101a51:	b8 1f 64 10 00       	mov    $0x10641f,%eax
  101a56:	eb 05                	jmp    101a5d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a58:	b8 32 64 10 00       	mov    $0x106432,%eax
}
  101a5d:	5d                   	pop    %ebp
  101a5e:	c3                   	ret    

00101a5f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a5f:	55                   	push   %ebp
  101a60:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a69:	66 83 f8 08          	cmp    $0x8,%ax
  101a6d:	0f 94 c0             	sete   %al
  101a70:	0f b6 c0             	movzbl %al,%eax
}
  101a73:	5d                   	pop    %ebp
  101a74:	c3                   	ret    

00101a75 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a75:	55                   	push   %ebp
  101a76:	89 e5                	mov    %esp,%ebp
  101a78:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a82:	c7 04 24 73 64 10 00 	movl   $0x106473,(%esp)
  101a89:	e8 b9 e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a91:	89 04 24             	mov    %eax,(%esp)
  101a94:	e8 a1 01 00 00       	call   101c3a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa0:	0f b7 c0             	movzwl %ax,%eax
  101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa7:	c7 04 24 84 64 10 00 	movl   $0x106484,(%esp)
  101aae:	e8 94 e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aba:	0f b7 c0             	movzwl %ax,%eax
  101abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac1:	c7 04 24 97 64 10 00 	movl   $0x106497,(%esp)
  101ac8:	e8 7a e8 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad4:	0f b7 c0             	movzwl %ax,%eax
  101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adb:	c7 04 24 aa 64 10 00 	movl   $0x1064aa,(%esp)
  101ae2:	e8 60 e8 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101aee:	0f b7 c0             	movzwl %ax,%eax
  101af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af5:	c7 04 24 bd 64 10 00 	movl   $0x1064bd,(%esp)
  101afc:	e8 46 e8 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b01:	8b 45 08             	mov    0x8(%ebp),%eax
  101b04:	8b 40 30             	mov    0x30(%eax),%eax
  101b07:	89 04 24             	mov    %eax,(%esp)
  101b0a:	e8 1f ff ff ff       	call   101a2e <trapname>
  101b0f:	8b 55 08             	mov    0x8(%ebp),%edx
  101b12:	8b 52 30             	mov    0x30(%edx),%edx
  101b15:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b19:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b1d:	c7 04 24 d0 64 10 00 	movl   $0x1064d0,(%esp)
  101b24:	e8 1e e8 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2c:	8b 40 34             	mov    0x34(%eax),%eax
  101b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b33:	c7 04 24 e2 64 10 00 	movl   $0x1064e2,(%esp)
  101b3a:	e8 08 e8 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	8b 40 38             	mov    0x38(%eax),%eax
  101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b49:	c7 04 24 f1 64 10 00 	movl   $0x1064f1,(%esp)
  101b50:	e8 f2 e7 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b5c:	0f b7 c0             	movzwl %ax,%eax
  101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b63:	c7 04 24 00 65 10 00 	movl   $0x106500,(%esp)
  101b6a:	e8 d8 e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	8b 40 40             	mov    0x40(%eax),%eax
  101b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b79:	c7 04 24 13 65 10 00 	movl   $0x106513,(%esp)
  101b80:	e8 c2 e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b93:	eb 3e                	jmp    101bd3 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 50 40             	mov    0x40(%eax),%edx
  101b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b9e:	21 d0                	and    %edx,%eax
  101ba0:	85 c0                	test   %eax,%eax
  101ba2:	74 28                	je     101bcc <print_trapframe+0x157>
  101ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba7:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bae:	85 c0                	test   %eax,%eax
  101bb0:	74 1a                	je     101bcc <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb5:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc0:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  101bc7:	e8 7b e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bcc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bd0:	d1 65 f0             	shll   -0x10(%ebp)
  101bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd6:	83 f8 17             	cmp    $0x17,%eax
  101bd9:	76 ba                	jbe    101b95 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bde:	8b 40 40             	mov    0x40(%eax),%eax
  101be1:	25 00 30 00 00       	and    $0x3000,%eax
  101be6:	c1 e8 0c             	shr    $0xc,%eax
  101be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bed:	c7 04 24 26 65 10 00 	movl   $0x106526,(%esp)
  101bf4:	e8 4e e7 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfc:	89 04 24             	mov    %eax,(%esp)
  101bff:	e8 5b fe ff ff       	call   101a5f <trap_in_kernel>
  101c04:	85 c0                	test   %eax,%eax
  101c06:	75 30                	jne    101c38 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 44             	mov    0x44(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 2f 65 10 00 	movl   $0x10652f,(%esp)
  101c19:	e8 29 e7 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c21:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c25:	0f b7 c0             	movzwl %ax,%eax
  101c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2c:	c7 04 24 3e 65 10 00 	movl   $0x10653e,(%esp)
  101c33:	e8 0f e7 ff ff       	call   100347 <cprintf>
    }
}
  101c38:	c9                   	leave  
  101c39:	c3                   	ret    

00101c3a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3a:	55                   	push   %ebp
  101c3b:	89 e5                	mov    %esp,%ebp
  101c3d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 00                	mov    (%eax),%eax
  101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c49:	c7 04 24 51 65 10 00 	movl   $0x106551,(%esp)
  101c50:	e8 f2 e6 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c55:	8b 45 08             	mov    0x8(%ebp),%eax
  101c58:	8b 40 04             	mov    0x4(%eax),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 60 65 10 00 	movl   $0x106560,(%esp)
  101c66:	e8 dc e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	8b 40 08             	mov    0x8(%eax),%eax
  101c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c75:	c7 04 24 6f 65 10 00 	movl   $0x10656f,(%esp)
  101c7c:	e8 c6 e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	8b 40 0c             	mov    0xc(%eax),%eax
  101c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8b:	c7 04 24 7e 65 10 00 	movl   $0x10657e,(%esp)
  101c92:	e8 b0 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c97:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9a:	8b 40 10             	mov    0x10(%eax),%eax
  101c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca1:	c7 04 24 8d 65 10 00 	movl   $0x10658d,(%esp)
  101ca8:	e8 9a e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cad:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb0:	8b 40 14             	mov    0x14(%eax),%eax
  101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb7:	c7 04 24 9c 65 10 00 	movl   $0x10659c,(%esp)
  101cbe:	e8 84 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc6:	8b 40 18             	mov    0x18(%eax),%eax
  101cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccd:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  101cd4:	e8 6e e6 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce3:	c7 04 24 ba 65 10 00 	movl   $0x1065ba,(%esp)
  101cea:	e8 58 e6 ff ff       	call   100347 <cprintf>
}
  101cef:	c9                   	leave  
  101cf0:	c3                   	ret    

00101cf1 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf1:	55                   	push   %ebp
  101cf2:	89 e5                	mov    %esp,%ebp
  101cf4:	57                   	push   %edi
  101cf5:	56                   	push   %esi
  101cf6:	53                   	push   %ebx
  101cf7:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfd:	8b 40 30             	mov    0x30(%eax),%eax
  101d00:	83 f8 2f             	cmp    $0x2f,%eax
  101d03:	77 21                	ja     101d26 <trap_dispatch+0x35>
  101d05:	83 f8 2e             	cmp    $0x2e,%eax
  101d08:	0f 83 ec 01 00 00    	jae    101efa <trap_dispatch+0x209>
  101d0e:	83 f8 21             	cmp    $0x21,%eax
  101d11:	0f 84 8a 00 00 00    	je     101da1 <trap_dispatch+0xb0>
  101d17:	83 f8 24             	cmp    $0x24,%eax
  101d1a:	74 5c                	je     101d78 <trap_dispatch+0x87>
  101d1c:	83 f8 20             	cmp    $0x20,%eax
  101d1f:	74 1c                	je     101d3d <trap_dispatch+0x4c>
  101d21:	e9 9c 01 00 00       	jmp    101ec2 <trap_dispatch+0x1d1>
  101d26:	83 f8 78             	cmp    $0x78,%eax
  101d29:	0f 84 9b 00 00 00    	je     101dca <trap_dispatch+0xd9>
  101d2f:	83 f8 79             	cmp    $0x79,%eax
  101d32:	0f 84 11 01 00 00    	je     101e49 <trap_dispatch+0x158>
  101d38:	e9 85 01 00 00       	jmp    101ec2 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d3d:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d42:	83 c0 01             	add    $0x1,%eax
  101d45:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d4a:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d50:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d55:	89 c8                	mov    %ecx,%eax
  101d57:	f7 e2                	mul    %edx
  101d59:	89 d0                	mov    %edx,%eax
  101d5b:	c1 e8 05             	shr    $0x5,%eax
  101d5e:	6b c0 64             	imul   $0x64,%eax,%eax
  101d61:	29 c1                	sub    %eax,%ecx
  101d63:	89 c8                	mov    %ecx,%eax
  101d65:	85 c0                	test   %eax,%eax
  101d67:	75 0a                	jne    101d73 <trap_dispatch+0x82>
            print_ticks();
  101d69:	e8 0d fb ff ff       	call   10187b <print_ticks>
        }
        break;
  101d6e:	e9 88 01 00 00       	jmp    101efb <trap_dispatch+0x20a>
  101d73:	e9 83 01 00 00       	jmp    101efb <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d78:	e8 c2 f8 ff ff       	call   10163f <cons_getc>
  101d7d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d80:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d84:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d88:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d90:	c7 04 24 c9 65 10 00 	movl   $0x1065c9,(%esp)
  101d97:	e8 ab e5 ff ff       	call   100347 <cprintf>
        break;
  101d9c:	e9 5a 01 00 00       	jmp    101efb <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101da1:	e8 99 f8 ff ff       	call   10163f <cons_getc>
  101da6:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da9:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dad:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101db1:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db9:	c7 04 24 db 65 10 00 	movl   $0x1065db,(%esp)
  101dc0:	e8 82 e5 ff ff       	call   100347 <cprintf>
        break;
  101dc5:	e9 31 01 00 00       	jmp    101efb <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101dca:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd1:	66 83 f8 1b          	cmp    $0x1b,%ax
  101dd5:	74 6d                	je     101e44 <trap_dispatch+0x153>
            switchk2u = *tf;
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	ba 60 89 11 00       	mov    $0x118960,%edx
  101ddf:	89 c3                	mov    %eax,%ebx
  101de1:	b8 13 00 00 00       	mov    $0x13,%eax
  101de6:	89 d7                	mov    %edx,%edi
  101de8:	89 de                	mov    %ebx,%esi
  101dea:	89 c1                	mov    %eax,%ecx
  101dec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101dee:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101df5:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101df7:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101dfe:	23 00 
  101e00:	0f b7 05 a8 89 11 00 	movzwl 0x1189a8,%eax
  101e07:	66 a3 88 89 11 00    	mov    %ax,0x118988
  101e0d:	0f b7 05 88 89 11 00 	movzwl 0x118988,%eax
  101e14:	66 a3 8c 89 11 00    	mov    %ax,0x11898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1d:	83 c0 44             	add    $0x44,%eax
  101e20:	a3 a4 89 11 00       	mov    %eax,0x1189a4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e25:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101e2a:	80 cc 30             	or     $0x30,%ah
  101e2d:	a3 a0 89 11 00       	mov    %eax,0x1189a0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e32:	8b 45 08             	mov    0x8(%ebp),%eax
  101e35:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e38:	b8 60 89 11 00       	mov    $0x118960,%eax
  101e3d:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e3f:	e9 b7 00 00 00       	jmp    101efb <trap_dispatch+0x20a>
  101e44:	e9 b2 00 00 00       	jmp    101efb <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e49:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e50:	66 83 f8 08          	cmp    $0x8,%ax
  101e54:	74 6a                	je     101ec0 <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101e56:	8b 45 08             	mov    0x8(%ebp),%eax
  101e59:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e62:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e72:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e76:	8b 45 08             	mov    0x8(%ebp),%eax
  101e79:	8b 40 40             	mov    0x40(%eax),%eax
  101e7c:	80 e4 cf             	and    $0xcf,%ah
  101e7f:	89 c2                	mov    %eax,%edx
  101e81:	8b 45 08             	mov    0x8(%ebp),%eax
  101e84:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e87:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8a:	8b 40 44             	mov    0x44(%eax),%eax
  101e8d:	83 e8 44             	sub    $0x44,%eax
  101e90:	a3 ac 89 11 00       	mov    %eax,0x1189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e95:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101e9a:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ea1:	00 
  101ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  101ea5:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ea9:	89 04 24             	mov    %eax,(%esp)
  101eac:	e8 7c 40 00 00       	call   105f2d <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb4:	8d 50 fc             	lea    -0x4(%eax),%edx
  101eb7:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101ebc:	89 02                	mov    %eax,(%edx)
        }
        break;
  101ebe:	eb 3b                	jmp    101efb <trap_dispatch+0x20a>
  101ec0:	eb 39                	jmp    101efb <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ec9:	0f b7 c0             	movzwl %ax,%eax
  101ecc:	83 e0 03             	and    $0x3,%eax
  101ecf:	85 c0                	test   %eax,%eax
  101ed1:	75 28                	jne    101efb <trap_dispatch+0x20a>
            print_trapframe(tf);
  101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed6:	89 04 24             	mov    %eax,(%esp)
  101ed9:	e8 97 fb ff ff       	call   101a75 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ede:	c7 44 24 08 ea 65 10 	movl   $0x1065ea,0x8(%esp)
  101ee5:	00 
  101ee6:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101eed:	00 
  101eee:	c7 04 24 0e 64 10 00 	movl   $0x10640e,(%esp)
  101ef5:	e8 d7 ed ff ff       	call   100cd1 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101efa:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101efb:	83 c4 2c             	add    $0x2c,%esp
  101efe:	5b                   	pop    %ebx
  101eff:	5e                   	pop    %esi
  101f00:	5f                   	pop    %edi
  101f01:	5d                   	pop    %ebp
  101f02:	c3                   	ret    

00101f03 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f03:	55                   	push   %ebp
  101f04:	89 e5                	mov    %esp,%ebp
  101f06:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f09:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0c:	89 04 24             	mov    %eax,(%esp)
  101f0f:	e8 dd fd ff ff       	call   101cf1 <trap_dispatch>
}
  101f14:	c9                   	leave  
  101f15:	c3                   	ret    

00101f16 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f16:	1e                   	push   %ds
    pushl %es
  101f17:	06                   	push   %es
    pushl %fs
  101f18:	0f a0                	push   %fs
    pushl %gs
  101f1a:	0f a8                	push   %gs
    pushal
  101f1c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f1d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f22:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f24:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f26:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f27:	e8 d7 ff ff ff       	call   101f03 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f2c:	5c                   	pop    %esp

00101f2d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f2d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f2e:	0f a9                	pop    %gs
    popl %fs
  101f30:	0f a1                	pop    %fs
    popl %es
  101f32:	07                   	pop    %es
    popl %ds
  101f33:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f34:	83 c4 08             	add    $0x8,%esp
    iret
  101f37:	cf                   	iret   

00101f38 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $0
  101f3a:	6a 00                	push   $0x0
  jmp __alltraps
  101f3c:	e9 d5 ff ff ff       	jmp    101f16 <__alltraps>

00101f41 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $1
  101f43:	6a 01                	push   $0x1
  jmp __alltraps
  101f45:	e9 cc ff ff ff       	jmp    101f16 <__alltraps>

00101f4a <vector2>:
.globl vector2
vector2:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $2
  101f4c:	6a 02                	push   $0x2
  jmp __alltraps
  101f4e:	e9 c3 ff ff ff       	jmp    101f16 <__alltraps>

00101f53 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $3
  101f55:	6a 03                	push   $0x3
  jmp __alltraps
  101f57:	e9 ba ff ff ff       	jmp    101f16 <__alltraps>

00101f5c <vector4>:
.globl vector4
vector4:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $4
  101f5e:	6a 04                	push   $0x4
  jmp __alltraps
  101f60:	e9 b1 ff ff ff       	jmp    101f16 <__alltraps>

00101f65 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $5
  101f67:	6a 05                	push   $0x5
  jmp __alltraps
  101f69:	e9 a8 ff ff ff       	jmp    101f16 <__alltraps>

00101f6e <vector6>:
.globl vector6
vector6:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $6
  101f70:	6a 06                	push   $0x6
  jmp __alltraps
  101f72:	e9 9f ff ff ff       	jmp    101f16 <__alltraps>

00101f77 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $7
  101f79:	6a 07                	push   $0x7
  jmp __alltraps
  101f7b:	e9 96 ff ff ff       	jmp    101f16 <__alltraps>

00101f80 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f80:	6a 08                	push   $0x8
  jmp __alltraps
  101f82:	e9 8f ff ff ff       	jmp    101f16 <__alltraps>

00101f87 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f87:	6a 09                	push   $0x9
  jmp __alltraps
  101f89:	e9 88 ff ff ff       	jmp    101f16 <__alltraps>

00101f8e <vector10>:
.globl vector10
vector10:
  pushl $10
  101f8e:	6a 0a                	push   $0xa
  jmp __alltraps
  101f90:	e9 81 ff ff ff       	jmp    101f16 <__alltraps>

00101f95 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f95:	6a 0b                	push   $0xb
  jmp __alltraps
  101f97:	e9 7a ff ff ff       	jmp    101f16 <__alltraps>

00101f9c <vector12>:
.globl vector12
vector12:
  pushl $12
  101f9c:	6a 0c                	push   $0xc
  jmp __alltraps
  101f9e:	e9 73 ff ff ff       	jmp    101f16 <__alltraps>

00101fa3 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fa3:	6a 0d                	push   $0xd
  jmp __alltraps
  101fa5:	e9 6c ff ff ff       	jmp    101f16 <__alltraps>

00101faa <vector14>:
.globl vector14
vector14:
  pushl $14
  101faa:	6a 0e                	push   $0xe
  jmp __alltraps
  101fac:	e9 65 ff ff ff       	jmp    101f16 <__alltraps>

00101fb1 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $15
  101fb3:	6a 0f                	push   $0xf
  jmp __alltraps
  101fb5:	e9 5c ff ff ff       	jmp    101f16 <__alltraps>

00101fba <vector16>:
.globl vector16
vector16:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $16
  101fbc:	6a 10                	push   $0x10
  jmp __alltraps
  101fbe:	e9 53 ff ff ff       	jmp    101f16 <__alltraps>

00101fc3 <vector17>:
.globl vector17
vector17:
  pushl $17
  101fc3:	6a 11                	push   $0x11
  jmp __alltraps
  101fc5:	e9 4c ff ff ff       	jmp    101f16 <__alltraps>

00101fca <vector18>:
.globl vector18
vector18:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $18
  101fcc:	6a 12                	push   $0x12
  jmp __alltraps
  101fce:	e9 43 ff ff ff       	jmp    101f16 <__alltraps>

00101fd3 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $19
  101fd5:	6a 13                	push   $0x13
  jmp __alltraps
  101fd7:	e9 3a ff ff ff       	jmp    101f16 <__alltraps>

00101fdc <vector20>:
.globl vector20
vector20:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $20
  101fde:	6a 14                	push   $0x14
  jmp __alltraps
  101fe0:	e9 31 ff ff ff       	jmp    101f16 <__alltraps>

00101fe5 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $21
  101fe7:	6a 15                	push   $0x15
  jmp __alltraps
  101fe9:	e9 28 ff ff ff       	jmp    101f16 <__alltraps>

00101fee <vector22>:
.globl vector22
vector22:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $22
  101ff0:	6a 16                	push   $0x16
  jmp __alltraps
  101ff2:	e9 1f ff ff ff       	jmp    101f16 <__alltraps>

00101ff7 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $23
  101ff9:	6a 17                	push   $0x17
  jmp __alltraps
  101ffb:	e9 16 ff ff ff       	jmp    101f16 <__alltraps>

00102000 <vector24>:
.globl vector24
vector24:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $24
  102002:	6a 18                	push   $0x18
  jmp __alltraps
  102004:	e9 0d ff ff ff       	jmp    101f16 <__alltraps>

00102009 <vector25>:
.globl vector25
vector25:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $25
  10200b:	6a 19                	push   $0x19
  jmp __alltraps
  10200d:	e9 04 ff ff ff       	jmp    101f16 <__alltraps>

00102012 <vector26>:
.globl vector26
vector26:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $26
  102014:	6a 1a                	push   $0x1a
  jmp __alltraps
  102016:	e9 fb fe ff ff       	jmp    101f16 <__alltraps>

0010201b <vector27>:
.globl vector27
vector27:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $27
  10201d:	6a 1b                	push   $0x1b
  jmp __alltraps
  10201f:	e9 f2 fe ff ff       	jmp    101f16 <__alltraps>

00102024 <vector28>:
.globl vector28
vector28:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $28
  102026:	6a 1c                	push   $0x1c
  jmp __alltraps
  102028:	e9 e9 fe ff ff       	jmp    101f16 <__alltraps>

0010202d <vector29>:
.globl vector29
vector29:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $29
  10202f:	6a 1d                	push   $0x1d
  jmp __alltraps
  102031:	e9 e0 fe ff ff       	jmp    101f16 <__alltraps>

00102036 <vector30>:
.globl vector30
vector30:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $30
  102038:	6a 1e                	push   $0x1e
  jmp __alltraps
  10203a:	e9 d7 fe ff ff       	jmp    101f16 <__alltraps>

0010203f <vector31>:
.globl vector31
vector31:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $31
  102041:	6a 1f                	push   $0x1f
  jmp __alltraps
  102043:	e9 ce fe ff ff       	jmp    101f16 <__alltraps>

00102048 <vector32>:
.globl vector32
vector32:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $32
  10204a:	6a 20                	push   $0x20
  jmp __alltraps
  10204c:	e9 c5 fe ff ff       	jmp    101f16 <__alltraps>

00102051 <vector33>:
.globl vector33
vector33:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $33
  102053:	6a 21                	push   $0x21
  jmp __alltraps
  102055:	e9 bc fe ff ff       	jmp    101f16 <__alltraps>

0010205a <vector34>:
.globl vector34
vector34:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $34
  10205c:	6a 22                	push   $0x22
  jmp __alltraps
  10205e:	e9 b3 fe ff ff       	jmp    101f16 <__alltraps>

00102063 <vector35>:
.globl vector35
vector35:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $35
  102065:	6a 23                	push   $0x23
  jmp __alltraps
  102067:	e9 aa fe ff ff       	jmp    101f16 <__alltraps>

0010206c <vector36>:
.globl vector36
vector36:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $36
  10206e:	6a 24                	push   $0x24
  jmp __alltraps
  102070:	e9 a1 fe ff ff       	jmp    101f16 <__alltraps>

00102075 <vector37>:
.globl vector37
vector37:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $37
  102077:	6a 25                	push   $0x25
  jmp __alltraps
  102079:	e9 98 fe ff ff       	jmp    101f16 <__alltraps>

0010207e <vector38>:
.globl vector38
vector38:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $38
  102080:	6a 26                	push   $0x26
  jmp __alltraps
  102082:	e9 8f fe ff ff       	jmp    101f16 <__alltraps>

00102087 <vector39>:
.globl vector39
vector39:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $39
  102089:	6a 27                	push   $0x27
  jmp __alltraps
  10208b:	e9 86 fe ff ff       	jmp    101f16 <__alltraps>

00102090 <vector40>:
.globl vector40
vector40:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $40
  102092:	6a 28                	push   $0x28
  jmp __alltraps
  102094:	e9 7d fe ff ff       	jmp    101f16 <__alltraps>

00102099 <vector41>:
.globl vector41
vector41:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $41
  10209b:	6a 29                	push   $0x29
  jmp __alltraps
  10209d:	e9 74 fe ff ff       	jmp    101f16 <__alltraps>

001020a2 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $42
  1020a4:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020a6:	e9 6b fe ff ff       	jmp    101f16 <__alltraps>

001020ab <vector43>:
.globl vector43
vector43:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $43
  1020ad:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020af:	e9 62 fe ff ff       	jmp    101f16 <__alltraps>

001020b4 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $44
  1020b6:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020b8:	e9 59 fe ff ff       	jmp    101f16 <__alltraps>

001020bd <vector45>:
.globl vector45
vector45:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $45
  1020bf:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020c1:	e9 50 fe ff ff       	jmp    101f16 <__alltraps>

001020c6 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $46
  1020c8:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020ca:	e9 47 fe ff ff       	jmp    101f16 <__alltraps>

001020cf <vector47>:
.globl vector47
vector47:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $47
  1020d1:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020d3:	e9 3e fe ff ff       	jmp    101f16 <__alltraps>

001020d8 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $48
  1020da:	6a 30                	push   $0x30
  jmp __alltraps
  1020dc:	e9 35 fe ff ff       	jmp    101f16 <__alltraps>

001020e1 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $49
  1020e3:	6a 31                	push   $0x31
  jmp __alltraps
  1020e5:	e9 2c fe ff ff       	jmp    101f16 <__alltraps>

001020ea <vector50>:
.globl vector50
vector50:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $50
  1020ec:	6a 32                	push   $0x32
  jmp __alltraps
  1020ee:	e9 23 fe ff ff       	jmp    101f16 <__alltraps>

001020f3 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $51
  1020f5:	6a 33                	push   $0x33
  jmp __alltraps
  1020f7:	e9 1a fe ff ff       	jmp    101f16 <__alltraps>

001020fc <vector52>:
.globl vector52
vector52:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $52
  1020fe:	6a 34                	push   $0x34
  jmp __alltraps
  102100:	e9 11 fe ff ff       	jmp    101f16 <__alltraps>

00102105 <vector53>:
.globl vector53
vector53:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $53
  102107:	6a 35                	push   $0x35
  jmp __alltraps
  102109:	e9 08 fe ff ff       	jmp    101f16 <__alltraps>

0010210e <vector54>:
.globl vector54
vector54:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $54
  102110:	6a 36                	push   $0x36
  jmp __alltraps
  102112:	e9 ff fd ff ff       	jmp    101f16 <__alltraps>

00102117 <vector55>:
.globl vector55
vector55:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $55
  102119:	6a 37                	push   $0x37
  jmp __alltraps
  10211b:	e9 f6 fd ff ff       	jmp    101f16 <__alltraps>

00102120 <vector56>:
.globl vector56
vector56:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $56
  102122:	6a 38                	push   $0x38
  jmp __alltraps
  102124:	e9 ed fd ff ff       	jmp    101f16 <__alltraps>

00102129 <vector57>:
.globl vector57
vector57:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $57
  10212b:	6a 39                	push   $0x39
  jmp __alltraps
  10212d:	e9 e4 fd ff ff       	jmp    101f16 <__alltraps>

00102132 <vector58>:
.globl vector58
vector58:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $58
  102134:	6a 3a                	push   $0x3a
  jmp __alltraps
  102136:	e9 db fd ff ff       	jmp    101f16 <__alltraps>

0010213b <vector59>:
.globl vector59
vector59:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $59
  10213d:	6a 3b                	push   $0x3b
  jmp __alltraps
  10213f:	e9 d2 fd ff ff       	jmp    101f16 <__alltraps>

00102144 <vector60>:
.globl vector60
vector60:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $60
  102146:	6a 3c                	push   $0x3c
  jmp __alltraps
  102148:	e9 c9 fd ff ff       	jmp    101f16 <__alltraps>

0010214d <vector61>:
.globl vector61
vector61:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $61
  10214f:	6a 3d                	push   $0x3d
  jmp __alltraps
  102151:	e9 c0 fd ff ff       	jmp    101f16 <__alltraps>

00102156 <vector62>:
.globl vector62
vector62:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $62
  102158:	6a 3e                	push   $0x3e
  jmp __alltraps
  10215a:	e9 b7 fd ff ff       	jmp    101f16 <__alltraps>

0010215f <vector63>:
.globl vector63
vector63:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $63
  102161:	6a 3f                	push   $0x3f
  jmp __alltraps
  102163:	e9 ae fd ff ff       	jmp    101f16 <__alltraps>

00102168 <vector64>:
.globl vector64
vector64:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $64
  10216a:	6a 40                	push   $0x40
  jmp __alltraps
  10216c:	e9 a5 fd ff ff       	jmp    101f16 <__alltraps>

00102171 <vector65>:
.globl vector65
vector65:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $65
  102173:	6a 41                	push   $0x41
  jmp __alltraps
  102175:	e9 9c fd ff ff       	jmp    101f16 <__alltraps>

0010217a <vector66>:
.globl vector66
vector66:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $66
  10217c:	6a 42                	push   $0x42
  jmp __alltraps
  10217e:	e9 93 fd ff ff       	jmp    101f16 <__alltraps>

00102183 <vector67>:
.globl vector67
vector67:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $67
  102185:	6a 43                	push   $0x43
  jmp __alltraps
  102187:	e9 8a fd ff ff       	jmp    101f16 <__alltraps>

0010218c <vector68>:
.globl vector68
vector68:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $68
  10218e:	6a 44                	push   $0x44
  jmp __alltraps
  102190:	e9 81 fd ff ff       	jmp    101f16 <__alltraps>

00102195 <vector69>:
.globl vector69
vector69:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $69
  102197:	6a 45                	push   $0x45
  jmp __alltraps
  102199:	e9 78 fd ff ff       	jmp    101f16 <__alltraps>

0010219e <vector70>:
.globl vector70
vector70:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $70
  1021a0:	6a 46                	push   $0x46
  jmp __alltraps
  1021a2:	e9 6f fd ff ff       	jmp    101f16 <__alltraps>

001021a7 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $71
  1021a9:	6a 47                	push   $0x47
  jmp __alltraps
  1021ab:	e9 66 fd ff ff       	jmp    101f16 <__alltraps>

001021b0 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $72
  1021b2:	6a 48                	push   $0x48
  jmp __alltraps
  1021b4:	e9 5d fd ff ff       	jmp    101f16 <__alltraps>

001021b9 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $73
  1021bb:	6a 49                	push   $0x49
  jmp __alltraps
  1021bd:	e9 54 fd ff ff       	jmp    101f16 <__alltraps>

001021c2 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $74
  1021c4:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021c6:	e9 4b fd ff ff       	jmp    101f16 <__alltraps>

001021cb <vector75>:
.globl vector75
vector75:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $75
  1021cd:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021cf:	e9 42 fd ff ff       	jmp    101f16 <__alltraps>

001021d4 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $76
  1021d6:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021d8:	e9 39 fd ff ff       	jmp    101f16 <__alltraps>

001021dd <vector77>:
.globl vector77
vector77:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $77
  1021df:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021e1:	e9 30 fd ff ff       	jmp    101f16 <__alltraps>

001021e6 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $78
  1021e8:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021ea:	e9 27 fd ff ff       	jmp    101f16 <__alltraps>

001021ef <vector79>:
.globl vector79
vector79:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $79
  1021f1:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021f3:	e9 1e fd ff ff       	jmp    101f16 <__alltraps>

001021f8 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $80
  1021fa:	6a 50                	push   $0x50
  jmp __alltraps
  1021fc:	e9 15 fd ff ff       	jmp    101f16 <__alltraps>

00102201 <vector81>:
.globl vector81
vector81:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $81
  102203:	6a 51                	push   $0x51
  jmp __alltraps
  102205:	e9 0c fd ff ff       	jmp    101f16 <__alltraps>

0010220a <vector82>:
.globl vector82
vector82:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $82
  10220c:	6a 52                	push   $0x52
  jmp __alltraps
  10220e:	e9 03 fd ff ff       	jmp    101f16 <__alltraps>

00102213 <vector83>:
.globl vector83
vector83:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $83
  102215:	6a 53                	push   $0x53
  jmp __alltraps
  102217:	e9 fa fc ff ff       	jmp    101f16 <__alltraps>

0010221c <vector84>:
.globl vector84
vector84:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $84
  10221e:	6a 54                	push   $0x54
  jmp __alltraps
  102220:	e9 f1 fc ff ff       	jmp    101f16 <__alltraps>

00102225 <vector85>:
.globl vector85
vector85:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $85
  102227:	6a 55                	push   $0x55
  jmp __alltraps
  102229:	e9 e8 fc ff ff       	jmp    101f16 <__alltraps>

0010222e <vector86>:
.globl vector86
vector86:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $86
  102230:	6a 56                	push   $0x56
  jmp __alltraps
  102232:	e9 df fc ff ff       	jmp    101f16 <__alltraps>

00102237 <vector87>:
.globl vector87
vector87:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $87
  102239:	6a 57                	push   $0x57
  jmp __alltraps
  10223b:	e9 d6 fc ff ff       	jmp    101f16 <__alltraps>

00102240 <vector88>:
.globl vector88
vector88:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $88
  102242:	6a 58                	push   $0x58
  jmp __alltraps
  102244:	e9 cd fc ff ff       	jmp    101f16 <__alltraps>

00102249 <vector89>:
.globl vector89
vector89:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $89
  10224b:	6a 59                	push   $0x59
  jmp __alltraps
  10224d:	e9 c4 fc ff ff       	jmp    101f16 <__alltraps>

00102252 <vector90>:
.globl vector90
vector90:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $90
  102254:	6a 5a                	push   $0x5a
  jmp __alltraps
  102256:	e9 bb fc ff ff       	jmp    101f16 <__alltraps>

0010225b <vector91>:
.globl vector91
vector91:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $91
  10225d:	6a 5b                	push   $0x5b
  jmp __alltraps
  10225f:	e9 b2 fc ff ff       	jmp    101f16 <__alltraps>

00102264 <vector92>:
.globl vector92
vector92:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $92
  102266:	6a 5c                	push   $0x5c
  jmp __alltraps
  102268:	e9 a9 fc ff ff       	jmp    101f16 <__alltraps>

0010226d <vector93>:
.globl vector93
vector93:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $93
  10226f:	6a 5d                	push   $0x5d
  jmp __alltraps
  102271:	e9 a0 fc ff ff       	jmp    101f16 <__alltraps>

00102276 <vector94>:
.globl vector94
vector94:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $94
  102278:	6a 5e                	push   $0x5e
  jmp __alltraps
  10227a:	e9 97 fc ff ff       	jmp    101f16 <__alltraps>

0010227f <vector95>:
.globl vector95
vector95:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $95
  102281:	6a 5f                	push   $0x5f
  jmp __alltraps
  102283:	e9 8e fc ff ff       	jmp    101f16 <__alltraps>

00102288 <vector96>:
.globl vector96
vector96:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $96
  10228a:	6a 60                	push   $0x60
  jmp __alltraps
  10228c:	e9 85 fc ff ff       	jmp    101f16 <__alltraps>

00102291 <vector97>:
.globl vector97
vector97:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $97
  102293:	6a 61                	push   $0x61
  jmp __alltraps
  102295:	e9 7c fc ff ff       	jmp    101f16 <__alltraps>

0010229a <vector98>:
.globl vector98
vector98:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $98
  10229c:	6a 62                	push   $0x62
  jmp __alltraps
  10229e:	e9 73 fc ff ff       	jmp    101f16 <__alltraps>

001022a3 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $99
  1022a5:	6a 63                	push   $0x63
  jmp __alltraps
  1022a7:	e9 6a fc ff ff       	jmp    101f16 <__alltraps>

001022ac <vector100>:
.globl vector100
vector100:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $100
  1022ae:	6a 64                	push   $0x64
  jmp __alltraps
  1022b0:	e9 61 fc ff ff       	jmp    101f16 <__alltraps>

001022b5 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $101
  1022b7:	6a 65                	push   $0x65
  jmp __alltraps
  1022b9:	e9 58 fc ff ff       	jmp    101f16 <__alltraps>

001022be <vector102>:
.globl vector102
vector102:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $102
  1022c0:	6a 66                	push   $0x66
  jmp __alltraps
  1022c2:	e9 4f fc ff ff       	jmp    101f16 <__alltraps>

001022c7 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $103
  1022c9:	6a 67                	push   $0x67
  jmp __alltraps
  1022cb:	e9 46 fc ff ff       	jmp    101f16 <__alltraps>

001022d0 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $104
  1022d2:	6a 68                	push   $0x68
  jmp __alltraps
  1022d4:	e9 3d fc ff ff       	jmp    101f16 <__alltraps>

001022d9 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $105
  1022db:	6a 69                	push   $0x69
  jmp __alltraps
  1022dd:	e9 34 fc ff ff       	jmp    101f16 <__alltraps>

001022e2 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $106
  1022e4:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022e6:	e9 2b fc ff ff       	jmp    101f16 <__alltraps>

001022eb <vector107>:
.globl vector107
vector107:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $107
  1022ed:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022ef:	e9 22 fc ff ff       	jmp    101f16 <__alltraps>

001022f4 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $108
  1022f6:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022f8:	e9 19 fc ff ff       	jmp    101f16 <__alltraps>

001022fd <vector109>:
.globl vector109
vector109:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $109
  1022ff:	6a 6d                	push   $0x6d
  jmp __alltraps
  102301:	e9 10 fc ff ff       	jmp    101f16 <__alltraps>

00102306 <vector110>:
.globl vector110
vector110:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $110
  102308:	6a 6e                	push   $0x6e
  jmp __alltraps
  10230a:	e9 07 fc ff ff       	jmp    101f16 <__alltraps>

0010230f <vector111>:
.globl vector111
vector111:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $111
  102311:	6a 6f                	push   $0x6f
  jmp __alltraps
  102313:	e9 fe fb ff ff       	jmp    101f16 <__alltraps>

00102318 <vector112>:
.globl vector112
vector112:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $112
  10231a:	6a 70                	push   $0x70
  jmp __alltraps
  10231c:	e9 f5 fb ff ff       	jmp    101f16 <__alltraps>

00102321 <vector113>:
.globl vector113
vector113:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $113
  102323:	6a 71                	push   $0x71
  jmp __alltraps
  102325:	e9 ec fb ff ff       	jmp    101f16 <__alltraps>

0010232a <vector114>:
.globl vector114
vector114:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $114
  10232c:	6a 72                	push   $0x72
  jmp __alltraps
  10232e:	e9 e3 fb ff ff       	jmp    101f16 <__alltraps>

00102333 <vector115>:
.globl vector115
vector115:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $115
  102335:	6a 73                	push   $0x73
  jmp __alltraps
  102337:	e9 da fb ff ff       	jmp    101f16 <__alltraps>

0010233c <vector116>:
.globl vector116
vector116:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $116
  10233e:	6a 74                	push   $0x74
  jmp __alltraps
  102340:	e9 d1 fb ff ff       	jmp    101f16 <__alltraps>

00102345 <vector117>:
.globl vector117
vector117:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $117
  102347:	6a 75                	push   $0x75
  jmp __alltraps
  102349:	e9 c8 fb ff ff       	jmp    101f16 <__alltraps>

0010234e <vector118>:
.globl vector118
vector118:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $118
  102350:	6a 76                	push   $0x76
  jmp __alltraps
  102352:	e9 bf fb ff ff       	jmp    101f16 <__alltraps>

00102357 <vector119>:
.globl vector119
vector119:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $119
  102359:	6a 77                	push   $0x77
  jmp __alltraps
  10235b:	e9 b6 fb ff ff       	jmp    101f16 <__alltraps>

00102360 <vector120>:
.globl vector120
vector120:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $120
  102362:	6a 78                	push   $0x78
  jmp __alltraps
  102364:	e9 ad fb ff ff       	jmp    101f16 <__alltraps>

00102369 <vector121>:
.globl vector121
vector121:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $121
  10236b:	6a 79                	push   $0x79
  jmp __alltraps
  10236d:	e9 a4 fb ff ff       	jmp    101f16 <__alltraps>

00102372 <vector122>:
.globl vector122
vector122:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $122
  102374:	6a 7a                	push   $0x7a
  jmp __alltraps
  102376:	e9 9b fb ff ff       	jmp    101f16 <__alltraps>

0010237b <vector123>:
.globl vector123
vector123:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $123
  10237d:	6a 7b                	push   $0x7b
  jmp __alltraps
  10237f:	e9 92 fb ff ff       	jmp    101f16 <__alltraps>

00102384 <vector124>:
.globl vector124
vector124:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $124
  102386:	6a 7c                	push   $0x7c
  jmp __alltraps
  102388:	e9 89 fb ff ff       	jmp    101f16 <__alltraps>

0010238d <vector125>:
.globl vector125
vector125:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $125
  10238f:	6a 7d                	push   $0x7d
  jmp __alltraps
  102391:	e9 80 fb ff ff       	jmp    101f16 <__alltraps>

00102396 <vector126>:
.globl vector126
vector126:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $126
  102398:	6a 7e                	push   $0x7e
  jmp __alltraps
  10239a:	e9 77 fb ff ff       	jmp    101f16 <__alltraps>

0010239f <vector127>:
.globl vector127
vector127:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $127
  1023a1:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023a3:	e9 6e fb ff ff       	jmp    101f16 <__alltraps>

001023a8 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $128
  1023aa:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023af:	e9 62 fb ff ff       	jmp    101f16 <__alltraps>

001023b4 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $129
  1023b6:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023bb:	e9 56 fb ff ff       	jmp    101f16 <__alltraps>

001023c0 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $130
  1023c2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023c7:	e9 4a fb ff ff       	jmp    101f16 <__alltraps>

001023cc <vector131>:
.globl vector131
vector131:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $131
  1023ce:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023d3:	e9 3e fb ff ff       	jmp    101f16 <__alltraps>

001023d8 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $132
  1023da:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023df:	e9 32 fb ff ff       	jmp    101f16 <__alltraps>

001023e4 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $133
  1023e6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023eb:	e9 26 fb ff ff       	jmp    101f16 <__alltraps>

001023f0 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $134
  1023f2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023f7:	e9 1a fb ff ff       	jmp    101f16 <__alltraps>

001023fc <vector135>:
.globl vector135
vector135:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $135
  1023fe:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102403:	e9 0e fb ff ff       	jmp    101f16 <__alltraps>

00102408 <vector136>:
.globl vector136
vector136:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $136
  10240a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10240f:	e9 02 fb ff ff       	jmp    101f16 <__alltraps>

00102414 <vector137>:
.globl vector137
vector137:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $137
  102416:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10241b:	e9 f6 fa ff ff       	jmp    101f16 <__alltraps>

00102420 <vector138>:
.globl vector138
vector138:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $138
  102422:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102427:	e9 ea fa ff ff       	jmp    101f16 <__alltraps>

0010242c <vector139>:
.globl vector139
vector139:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $139
  10242e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102433:	e9 de fa ff ff       	jmp    101f16 <__alltraps>

00102438 <vector140>:
.globl vector140
vector140:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $140
  10243a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10243f:	e9 d2 fa ff ff       	jmp    101f16 <__alltraps>

00102444 <vector141>:
.globl vector141
vector141:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $141
  102446:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10244b:	e9 c6 fa ff ff       	jmp    101f16 <__alltraps>

00102450 <vector142>:
.globl vector142
vector142:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $142
  102452:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102457:	e9 ba fa ff ff       	jmp    101f16 <__alltraps>

0010245c <vector143>:
.globl vector143
vector143:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $143
  10245e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102463:	e9 ae fa ff ff       	jmp    101f16 <__alltraps>

00102468 <vector144>:
.globl vector144
vector144:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $144
  10246a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10246f:	e9 a2 fa ff ff       	jmp    101f16 <__alltraps>

00102474 <vector145>:
.globl vector145
vector145:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $145
  102476:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10247b:	e9 96 fa ff ff       	jmp    101f16 <__alltraps>

00102480 <vector146>:
.globl vector146
vector146:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $146
  102482:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102487:	e9 8a fa ff ff       	jmp    101f16 <__alltraps>

0010248c <vector147>:
.globl vector147
vector147:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $147
  10248e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102493:	e9 7e fa ff ff       	jmp    101f16 <__alltraps>

00102498 <vector148>:
.globl vector148
vector148:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $148
  10249a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10249f:	e9 72 fa ff ff       	jmp    101f16 <__alltraps>

001024a4 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $149
  1024a6:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024ab:	e9 66 fa ff ff       	jmp    101f16 <__alltraps>

001024b0 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $150
  1024b2:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024b7:	e9 5a fa ff ff       	jmp    101f16 <__alltraps>

001024bc <vector151>:
.globl vector151
vector151:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $151
  1024be:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024c3:	e9 4e fa ff ff       	jmp    101f16 <__alltraps>

001024c8 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $152
  1024ca:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024cf:	e9 42 fa ff ff       	jmp    101f16 <__alltraps>

001024d4 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $153
  1024d6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024db:	e9 36 fa ff ff       	jmp    101f16 <__alltraps>

001024e0 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $154
  1024e2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024e7:	e9 2a fa ff ff       	jmp    101f16 <__alltraps>

001024ec <vector155>:
.globl vector155
vector155:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $155
  1024ee:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024f3:	e9 1e fa ff ff       	jmp    101f16 <__alltraps>

001024f8 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $156
  1024fa:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024ff:	e9 12 fa ff ff       	jmp    101f16 <__alltraps>

00102504 <vector157>:
.globl vector157
vector157:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $157
  102506:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10250b:	e9 06 fa ff ff       	jmp    101f16 <__alltraps>

00102510 <vector158>:
.globl vector158
vector158:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $158
  102512:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102517:	e9 fa f9 ff ff       	jmp    101f16 <__alltraps>

0010251c <vector159>:
.globl vector159
vector159:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $159
  10251e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102523:	e9 ee f9 ff ff       	jmp    101f16 <__alltraps>

00102528 <vector160>:
.globl vector160
vector160:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $160
  10252a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10252f:	e9 e2 f9 ff ff       	jmp    101f16 <__alltraps>

00102534 <vector161>:
.globl vector161
vector161:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $161
  102536:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10253b:	e9 d6 f9 ff ff       	jmp    101f16 <__alltraps>

00102540 <vector162>:
.globl vector162
vector162:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $162
  102542:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102547:	e9 ca f9 ff ff       	jmp    101f16 <__alltraps>

0010254c <vector163>:
.globl vector163
vector163:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $163
  10254e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102553:	e9 be f9 ff ff       	jmp    101f16 <__alltraps>

00102558 <vector164>:
.globl vector164
vector164:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $164
  10255a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10255f:	e9 b2 f9 ff ff       	jmp    101f16 <__alltraps>

00102564 <vector165>:
.globl vector165
vector165:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $165
  102566:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10256b:	e9 a6 f9 ff ff       	jmp    101f16 <__alltraps>

00102570 <vector166>:
.globl vector166
vector166:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $166
  102572:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102577:	e9 9a f9 ff ff       	jmp    101f16 <__alltraps>

0010257c <vector167>:
.globl vector167
vector167:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $167
  10257e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102583:	e9 8e f9 ff ff       	jmp    101f16 <__alltraps>

00102588 <vector168>:
.globl vector168
vector168:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $168
  10258a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10258f:	e9 82 f9 ff ff       	jmp    101f16 <__alltraps>

00102594 <vector169>:
.globl vector169
vector169:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $169
  102596:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10259b:	e9 76 f9 ff ff       	jmp    101f16 <__alltraps>

001025a0 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $170
  1025a2:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025a7:	e9 6a f9 ff ff       	jmp    101f16 <__alltraps>

001025ac <vector171>:
.globl vector171
vector171:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $171
  1025ae:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025b3:	e9 5e f9 ff ff       	jmp    101f16 <__alltraps>

001025b8 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $172
  1025ba:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025bf:	e9 52 f9 ff ff       	jmp    101f16 <__alltraps>

001025c4 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $173
  1025c6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025cb:	e9 46 f9 ff ff       	jmp    101f16 <__alltraps>

001025d0 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $174
  1025d2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025d7:	e9 3a f9 ff ff       	jmp    101f16 <__alltraps>

001025dc <vector175>:
.globl vector175
vector175:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $175
  1025de:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025e3:	e9 2e f9 ff ff       	jmp    101f16 <__alltraps>

001025e8 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $176
  1025ea:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025ef:	e9 22 f9 ff ff       	jmp    101f16 <__alltraps>

001025f4 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $177
  1025f6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025fb:	e9 16 f9 ff ff       	jmp    101f16 <__alltraps>

00102600 <vector178>:
.globl vector178
vector178:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $178
  102602:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102607:	e9 0a f9 ff ff       	jmp    101f16 <__alltraps>

0010260c <vector179>:
.globl vector179
vector179:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $179
  10260e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102613:	e9 fe f8 ff ff       	jmp    101f16 <__alltraps>

00102618 <vector180>:
.globl vector180
vector180:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $180
  10261a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10261f:	e9 f2 f8 ff ff       	jmp    101f16 <__alltraps>

00102624 <vector181>:
.globl vector181
vector181:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $181
  102626:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10262b:	e9 e6 f8 ff ff       	jmp    101f16 <__alltraps>

00102630 <vector182>:
.globl vector182
vector182:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $182
  102632:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102637:	e9 da f8 ff ff       	jmp    101f16 <__alltraps>

0010263c <vector183>:
.globl vector183
vector183:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $183
  10263e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102643:	e9 ce f8 ff ff       	jmp    101f16 <__alltraps>

00102648 <vector184>:
.globl vector184
vector184:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $184
  10264a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10264f:	e9 c2 f8 ff ff       	jmp    101f16 <__alltraps>

00102654 <vector185>:
.globl vector185
vector185:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $185
  102656:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10265b:	e9 b6 f8 ff ff       	jmp    101f16 <__alltraps>

00102660 <vector186>:
.globl vector186
vector186:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $186
  102662:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102667:	e9 aa f8 ff ff       	jmp    101f16 <__alltraps>

0010266c <vector187>:
.globl vector187
vector187:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $187
  10266e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102673:	e9 9e f8 ff ff       	jmp    101f16 <__alltraps>

00102678 <vector188>:
.globl vector188
vector188:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $188
  10267a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10267f:	e9 92 f8 ff ff       	jmp    101f16 <__alltraps>

00102684 <vector189>:
.globl vector189
vector189:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $189
  102686:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10268b:	e9 86 f8 ff ff       	jmp    101f16 <__alltraps>

00102690 <vector190>:
.globl vector190
vector190:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $190
  102692:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102697:	e9 7a f8 ff ff       	jmp    101f16 <__alltraps>

0010269c <vector191>:
.globl vector191
vector191:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $191
  10269e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026a3:	e9 6e f8 ff ff       	jmp    101f16 <__alltraps>

001026a8 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $192
  1026aa:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026af:	e9 62 f8 ff ff       	jmp    101f16 <__alltraps>

001026b4 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $193
  1026b6:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026bb:	e9 56 f8 ff ff       	jmp    101f16 <__alltraps>

001026c0 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $194
  1026c2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026c7:	e9 4a f8 ff ff       	jmp    101f16 <__alltraps>

001026cc <vector195>:
.globl vector195
vector195:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $195
  1026ce:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026d3:	e9 3e f8 ff ff       	jmp    101f16 <__alltraps>

001026d8 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $196
  1026da:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026df:	e9 32 f8 ff ff       	jmp    101f16 <__alltraps>

001026e4 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $197
  1026e6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026eb:	e9 26 f8 ff ff       	jmp    101f16 <__alltraps>

001026f0 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $198
  1026f2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026f7:	e9 1a f8 ff ff       	jmp    101f16 <__alltraps>

001026fc <vector199>:
.globl vector199
vector199:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $199
  1026fe:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102703:	e9 0e f8 ff ff       	jmp    101f16 <__alltraps>

00102708 <vector200>:
.globl vector200
vector200:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $200
  10270a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10270f:	e9 02 f8 ff ff       	jmp    101f16 <__alltraps>

00102714 <vector201>:
.globl vector201
vector201:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $201
  102716:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10271b:	e9 f6 f7 ff ff       	jmp    101f16 <__alltraps>

00102720 <vector202>:
.globl vector202
vector202:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $202
  102722:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102727:	e9 ea f7 ff ff       	jmp    101f16 <__alltraps>

0010272c <vector203>:
.globl vector203
vector203:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $203
  10272e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102733:	e9 de f7 ff ff       	jmp    101f16 <__alltraps>

00102738 <vector204>:
.globl vector204
vector204:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $204
  10273a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10273f:	e9 d2 f7 ff ff       	jmp    101f16 <__alltraps>

00102744 <vector205>:
.globl vector205
vector205:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $205
  102746:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10274b:	e9 c6 f7 ff ff       	jmp    101f16 <__alltraps>

00102750 <vector206>:
.globl vector206
vector206:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $206
  102752:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102757:	e9 ba f7 ff ff       	jmp    101f16 <__alltraps>

0010275c <vector207>:
.globl vector207
vector207:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $207
  10275e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102763:	e9 ae f7 ff ff       	jmp    101f16 <__alltraps>

00102768 <vector208>:
.globl vector208
vector208:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $208
  10276a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10276f:	e9 a2 f7 ff ff       	jmp    101f16 <__alltraps>

00102774 <vector209>:
.globl vector209
vector209:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $209
  102776:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10277b:	e9 96 f7 ff ff       	jmp    101f16 <__alltraps>

00102780 <vector210>:
.globl vector210
vector210:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $210
  102782:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102787:	e9 8a f7 ff ff       	jmp    101f16 <__alltraps>

0010278c <vector211>:
.globl vector211
vector211:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $211
  10278e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102793:	e9 7e f7 ff ff       	jmp    101f16 <__alltraps>

00102798 <vector212>:
.globl vector212
vector212:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $212
  10279a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10279f:	e9 72 f7 ff ff       	jmp    101f16 <__alltraps>

001027a4 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $213
  1027a6:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027ab:	e9 66 f7 ff ff       	jmp    101f16 <__alltraps>

001027b0 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $214
  1027b2:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027b7:	e9 5a f7 ff ff       	jmp    101f16 <__alltraps>

001027bc <vector215>:
.globl vector215
vector215:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $215
  1027be:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027c3:	e9 4e f7 ff ff       	jmp    101f16 <__alltraps>

001027c8 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $216
  1027ca:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027cf:	e9 42 f7 ff ff       	jmp    101f16 <__alltraps>

001027d4 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $217
  1027d6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027db:	e9 36 f7 ff ff       	jmp    101f16 <__alltraps>

001027e0 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $218
  1027e2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027e7:	e9 2a f7 ff ff       	jmp    101f16 <__alltraps>

001027ec <vector219>:
.globl vector219
vector219:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $219
  1027ee:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027f3:	e9 1e f7 ff ff       	jmp    101f16 <__alltraps>

001027f8 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $220
  1027fa:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027ff:	e9 12 f7 ff ff       	jmp    101f16 <__alltraps>

00102804 <vector221>:
.globl vector221
vector221:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $221
  102806:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10280b:	e9 06 f7 ff ff       	jmp    101f16 <__alltraps>

00102810 <vector222>:
.globl vector222
vector222:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $222
  102812:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102817:	e9 fa f6 ff ff       	jmp    101f16 <__alltraps>

0010281c <vector223>:
.globl vector223
vector223:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $223
  10281e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102823:	e9 ee f6 ff ff       	jmp    101f16 <__alltraps>

00102828 <vector224>:
.globl vector224
vector224:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $224
  10282a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10282f:	e9 e2 f6 ff ff       	jmp    101f16 <__alltraps>

00102834 <vector225>:
.globl vector225
vector225:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $225
  102836:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10283b:	e9 d6 f6 ff ff       	jmp    101f16 <__alltraps>

00102840 <vector226>:
.globl vector226
vector226:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $226
  102842:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102847:	e9 ca f6 ff ff       	jmp    101f16 <__alltraps>

0010284c <vector227>:
.globl vector227
vector227:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $227
  10284e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102853:	e9 be f6 ff ff       	jmp    101f16 <__alltraps>

00102858 <vector228>:
.globl vector228
vector228:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $228
  10285a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10285f:	e9 b2 f6 ff ff       	jmp    101f16 <__alltraps>

00102864 <vector229>:
.globl vector229
vector229:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $229
  102866:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10286b:	e9 a6 f6 ff ff       	jmp    101f16 <__alltraps>

00102870 <vector230>:
.globl vector230
vector230:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $230
  102872:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102877:	e9 9a f6 ff ff       	jmp    101f16 <__alltraps>

0010287c <vector231>:
.globl vector231
vector231:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $231
  10287e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102883:	e9 8e f6 ff ff       	jmp    101f16 <__alltraps>

00102888 <vector232>:
.globl vector232
vector232:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $232
  10288a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10288f:	e9 82 f6 ff ff       	jmp    101f16 <__alltraps>

00102894 <vector233>:
.globl vector233
vector233:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $233
  102896:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10289b:	e9 76 f6 ff ff       	jmp    101f16 <__alltraps>

001028a0 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $234
  1028a2:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028a7:	e9 6a f6 ff ff       	jmp    101f16 <__alltraps>

001028ac <vector235>:
.globl vector235
vector235:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $235
  1028ae:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028b3:	e9 5e f6 ff ff       	jmp    101f16 <__alltraps>

001028b8 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $236
  1028ba:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028bf:	e9 52 f6 ff ff       	jmp    101f16 <__alltraps>

001028c4 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $237
  1028c6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028cb:	e9 46 f6 ff ff       	jmp    101f16 <__alltraps>

001028d0 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $238
  1028d2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028d7:	e9 3a f6 ff ff       	jmp    101f16 <__alltraps>

001028dc <vector239>:
.globl vector239
vector239:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $239
  1028de:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028e3:	e9 2e f6 ff ff       	jmp    101f16 <__alltraps>

001028e8 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $240
  1028ea:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028ef:	e9 22 f6 ff ff       	jmp    101f16 <__alltraps>

001028f4 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $241
  1028f6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028fb:	e9 16 f6 ff ff       	jmp    101f16 <__alltraps>

00102900 <vector242>:
.globl vector242
vector242:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $242
  102902:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102907:	e9 0a f6 ff ff       	jmp    101f16 <__alltraps>

0010290c <vector243>:
.globl vector243
vector243:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $243
  10290e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102913:	e9 fe f5 ff ff       	jmp    101f16 <__alltraps>

00102918 <vector244>:
.globl vector244
vector244:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $244
  10291a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10291f:	e9 f2 f5 ff ff       	jmp    101f16 <__alltraps>

00102924 <vector245>:
.globl vector245
vector245:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $245
  102926:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10292b:	e9 e6 f5 ff ff       	jmp    101f16 <__alltraps>

00102930 <vector246>:
.globl vector246
vector246:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $246
  102932:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102937:	e9 da f5 ff ff       	jmp    101f16 <__alltraps>

0010293c <vector247>:
.globl vector247
vector247:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $247
  10293e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102943:	e9 ce f5 ff ff       	jmp    101f16 <__alltraps>

00102948 <vector248>:
.globl vector248
vector248:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $248
  10294a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10294f:	e9 c2 f5 ff ff       	jmp    101f16 <__alltraps>

00102954 <vector249>:
.globl vector249
vector249:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $249
  102956:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10295b:	e9 b6 f5 ff ff       	jmp    101f16 <__alltraps>

00102960 <vector250>:
.globl vector250
vector250:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $250
  102962:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102967:	e9 aa f5 ff ff       	jmp    101f16 <__alltraps>

0010296c <vector251>:
.globl vector251
vector251:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $251
  10296e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102973:	e9 9e f5 ff ff       	jmp    101f16 <__alltraps>

00102978 <vector252>:
.globl vector252
vector252:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $252
  10297a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10297f:	e9 92 f5 ff ff       	jmp    101f16 <__alltraps>

00102984 <vector253>:
.globl vector253
vector253:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $253
  102986:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10298b:	e9 86 f5 ff ff       	jmp    101f16 <__alltraps>

00102990 <vector254>:
.globl vector254
vector254:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $254
  102992:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102997:	e9 7a f5 ff ff       	jmp    101f16 <__alltraps>

0010299c <vector255>:
.globl vector255
vector255:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $255
  10299e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029a3:	e9 6e f5 ff ff       	jmp    101f16 <__alltraps>

001029a8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029a8:	55                   	push   %ebp
  1029a9:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1029ab:	8b 55 08             	mov    0x8(%ebp),%edx
  1029ae:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1029b3:	29 c2                	sub    %eax,%edx
  1029b5:	89 d0                	mov    %edx,%eax
  1029b7:	c1 f8 02             	sar    $0x2,%eax
  1029ba:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1029c0:	5d                   	pop    %ebp
  1029c1:	c3                   	ret    

001029c2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029c2:	55                   	push   %ebp
  1029c3:	89 e5                	mov    %esp,%ebp
  1029c5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cb:	89 04 24             	mov    %eax,(%esp)
  1029ce:	e8 d5 ff ff ff       	call   1029a8 <page2ppn>
  1029d3:	c1 e0 0c             	shl    $0xc,%eax
}
  1029d6:	c9                   	leave  
  1029d7:	c3                   	ret    

001029d8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1029d8:	55                   	push   %ebp
  1029d9:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029db:	8b 45 08             	mov    0x8(%ebp),%eax
  1029de:	8b 00                	mov    (%eax),%eax
}
  1029e0:	5d                   	pop    %ebp
  1029e1:	c3                   	ret    

001029e2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029e2:	55                   	push   %ebp
  1029e3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029eb:	89 10                	mov    %edx,(%eax)
}
  1029ed:	5d                   	pop    %ebp
  1029ee:	c3                   	ret    

001029ef <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1029ef:	55                   	push   %ebp
  1029f0:	89 e5                	mov    %esp,%ebp
  1029f2:	83 ec 10             	sub    $0x10,%esp
  1029f5:	c7 45 fc b0 89 11 00 	movl   $0x1189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a02:	89 50 04             	mov    %edx,0x4(%eax)
  102a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a08:	8b 50 04             	mov    0x4(%eax),%edx
  102a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a0e:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102a10:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  102a17:	00 00 00 
}
  102a1a:	c9                   	leave  
  102a1b:	c3                   	ret    

00102a1c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102a1c:	55                   	push   %ebp
  102a1d:	89 e5                	mov    %esp,%ebp
  102a1f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102a22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a26:	75 24                	jne    102a4c <default_init_memmap+0x30>
  102a28:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  102a2f:	00 
  102a30:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102a37:	00 
  102a38:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102a3f:	00 
  102a40:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102a47:	e8 85 e2 ff ff       	call   100cd1 <__panic>
    struct Page *p = base;
  102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102a52:	e9 de 00 00 00       	jmp    102b35 <default_init_memmap+0x119>
        assert(PageReserved(p));
  102a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5a:	83 c0 04             	add    $0x4,%eax
  102a5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a6d:	0f a3 10             	bt     %edx,(%eax)
  102a70:	19 c0                	sbb    %eax,%eax
  102a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a79:	0f 95 c0             	setne  %al
  102a7c:	0f b6 c0             	movzbl %al,%eax
  102a7f:	85 c0                	test   %eax,%eax
  102a81:	75 24                	jne    102aa7 <default_init_memmap+0x8b>
  102a83:	c7 44 24 0c e1 67 10 	movl   $0x1067e1,0xc(%esp)
  102a8a:	00 
  102a8b:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102a92:	00 
  102a93:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102a9a:	00 
  102a9b:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102aa2:	e8 2a e2 ff ff       	call   100cd1 <__panic>
        p->flags = p->property = 0;
  102aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aaa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab4:	8b 50 08             	mov    0x8(%eax),%edx
  102ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aba:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
  102abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac0:	83 c0 04             	add    $0x4,%eax
  102ac3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102aca:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ad3:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  102ad6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102add:	00 
  102ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae1:	89 04 24             	mov    %eax,(%esp)
  102ae4:	e8 f9 fe ff ff       	call   1029e2 <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
  102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aec:	83 c0 0c             	add    $0xc,%eax
  102aef:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
  102af6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102af9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102afc:	8b 00                	mov    (%eax),%eax
  102afe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b01:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b04:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b13:	89 10                	mov    %edx,(%eax)
  102b15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b18:	8b 10                	mov    (%eax),%edx
  102b1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b23:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b26:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b2c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b2f:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102b31:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b38:	89 d0                	mov    %edx,%eax
  102b3a:	c1 e0 02             	shl    $0x2,%eax
  102b3d:	01 d0                	add    %edx,%eax
  102b3f:	c1 e0 02             	shl    $0x2,%eax
  102b42:	89 c2                	mov    %eax,%edx
  102b44:	8b 45 08             	mov    0x8(%ebp),%eax
  102b47:	01 d0                	add    %edx,%eax
  102b49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102b4c:	0f 85 05 ff ff ff    	jne    102a57 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
		SetPageProperty(p);
        set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  102b52:	8b 45 08             	mov    0x8(%ebp),%eax
  102b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b58:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102b5b:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b64:	01 d0                	add    %edx,%eax
  102b66:	a3 b8 89 11 00       	mov    %eax,0x1189b8
}
  102b6b:	c9                   	leave  
  102b6c:	c3                   	ret    

00102b6d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102b6d:	55                   	push   %ebp
  102b6e:	89 e5                	mov    %esp,%ebp
  102b70:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b77:	75 24                	jne    102b9d <default_alloc_pages+0x30>
  102b79:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  102b80:	00 
  102b81:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102b88:	00 
  102b89:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102b90:	00 
  102b91:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102b98:	e8 34 e1 ff ff       	call   100cd1 <__panic>
    if (n > nr_free) {
  102b9d:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102ba2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ba5:	73 0a                	jae    102bb1 <default_alloc_pages+0x44>
        return NULL;
  102ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  102bac:	e9 40 01 00 00       	jmp    102cf1 <default_alloc_pages+0x184>
    }

    //struct Page *page = NULL;
    list_entry_t *le = &free_list;
  102bb1:	c7 45 f4 b0 89 11 00 	movl   $0x1189b0,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102bb8:	e9 13 01 00 00       	jmp    102cd0 <default_alloc_pages+0x163>
        struct Page *p = le2page(le, page_link);
  102bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc0:	83 e8 0c             	sub    $0xc,%eax
  102bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bc9:	8b 40 08             	mov    0x8(%eax),%eax
  102bcc:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bcf:	0f 82 fb 00 00 00    	jb     102cd0 <default_alloc_pages+0x163>
			int i;
           for (i=0; i<n; i++) {
  102bd5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102bdc:	eb 7c                	jmp    102c5a <default_alloc_pages+0xed>
				struct Page* t = le2page(le,page_link);
  102bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be1:	83 e8 0c             	sub    $0xc,%eax
  102be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				SetPageReserved(t);
  102be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bea:	83 c0 04             	add    $0x4,%eax
  102bed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102bf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102bfd:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(t);
  102c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c03:	83 c0 04             	add    $0x4,%eax
  102c06:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c13:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c16:	0f b3 10             	btr    %edx,(%eax)
  102c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c22:	8b 40 04             	mov    0x4(%eax),%eax
				list_entry_t * next = list_next(le);
  102c25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c31:	8b 40 04             	mov    0x4(%eax),%eax
  102c34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c37:	8b 12                	mov    (%edx),%edx
  102c39:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102c3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c42:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c45:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c4b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c4e:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = next;
  102c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
			int i;
           for (i=0; i<n; i++) {
  102c56:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c60:	0f 82 78 ff ff ff    	jb     102bde <default_alloc_pages+0x71>
				ClearPageProperty(t);
				list_entry_t * next = list_next(le);
				list_del(le);
				le = next;
		}
		if(p->property>n){
  102c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c69:	8b 40 08             	mov    0x8(%eax),%eax
  102c6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c6f:	76 12                	jbe    102c83 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
  102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c74:	8d 50 f4             	lea    -0xc(%eax),%edx
  102c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c7a:	8b 40 08             	mov    0x8(%eax),%eax
  102c7d:	2b 45 08             	sub    0x8(%ebp),%eax
  102c80:	89 42 08             	mov    %eax,0x8(%edx)
        }
        nr_free -= n;
  102c83:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102c88:	2b 45 08             	sub    0x8(%ebp),%eax
  102c8b:	a3 b8 89 11 00       	mov    %eax,0x1189b8
        ClearPageProperty(p);
  102c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c93:	83 c0 04             	add    $0x4,%eax
  102c96:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102c9d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102ca0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ca3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ca6:	0f b3 10             	btr    %edx,(%eax)
		p->property = n;
  102ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cac:	8b 55 08             	mov    0x8(%ebp),%edx
  102caf:	89 50 08             	mov    %edx,0x8(%eax)
 		SetPageReserved(p);
  102cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cb5:	83 c0 04             	add    $0x4,%eax
  102cb8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102cbf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cc2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102cc5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cc8:	0f ab 10             	bts    %edx,(%eax)
		return p;
  102ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cce:	eb 21                	jmp    102cf1 <default_alloc_pages+0x184>
  102cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd3:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102cd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102cd9:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    //struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cdf:	81 7d f4 b0 89 11 00 	cmpl   $0x1189b0,-0xc(%ebp)
  102ce6:	0f 85 d1 fe ff ff    	jne    102bbd <default_alloc_pages+0x50>
    }

    
        
    }
    return NULL;
  102cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102cf1:	c9                   	leave  
  102cf2:	c3                   	ret    

00102cf3 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102cf3:	55                   	push   %ebp
  102cf4:	89 e5                	mov    %esp,%ebp
  102cf6:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cfd:	75 24                	jne    102d23 <default_free_pages+0x30>
  102cff:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  102d06:	00 
  102d07:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102d0e:	00 
  102d0f:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102d16:	00 
  102d17:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102d1e:	e8 ae df ff ff       	call   100cd1 <__panic>
    assert(PageReserved(base));
  102d23:	8b 45 08             	mov    0x8(%ebp),%eax
  102d26:	83 c0 04             	add    $0x4,%eax
  102d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102d30:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d39:	0f a3 10             	bt     %edx,(%eax)
  102d3c:	19 c0                	sbb    %eax,%eax
  102d3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  102d41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d45:	0f 95 c0             	setne  %al
  102d48:	0f b6 c0             	movzbl %al,%eax
  102d4b:	85 c0                	test   %eax,%eax
  102d4d:	75 24                	jne    102d73 <default_free_pages+0x80>
  102d4f:	c7 44 24 0c f1 67 10 	movl   $0x1067f1,0xc(%esp)
  102d56:	00 
  102d57:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102d5e:	00 
  102d5f:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  102d66:	00 
  102d67:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102d6e:	e8 5e df ff ff       	call   100cd1 <__panic>
    list_entry_t *pos = &free_list;
  102d73:	c7 45 f4 b0 89 11 00 	movl   $0x1189b0,-0xc(%ebp)
    struct Page * t;
    while((pos=list_next(pos)) != &free_list) {
  102d7a:	eb 13                	jmp    102d8f <default_free_pages+0x9c>
      t = le2page(pos, page_link);
  102d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7f:	83 e8 0c             	sub    $0xc,%eax
  102d82:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(t>base){
  102d85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d88:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d8b:	76 02                	jbe    102d8f <default_free_pages+0x9c>
        break;
  102d8d:	eb 18                	jmp    102da7 <default_free_pages+0xb4>
  102d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102d95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d98:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    list_entry_t *pos = &free_list;
    struct Page * t;
    while((pos=list_next(pos)) != &free_list) {
  102d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d9e:	81 7d f4 b0 89 11 00 	cmpl   $0x1189b0,-0xc(%ebp)
  102da5:	75 d5                	jne    102d7c <default_free_pages+0x89>
      if(t>base){
        break;
      }
    }
	struct Page *pp;
	for(pp=base;pp<base+n;pp++){
  102da7:	8b 45 08             	mov    0x8(%ebp),%eax
  102daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dad:	eb 4b                	jmp    102dfa <default_free_pages+0x107>
      list_add_before(pos, &(pp->page_link));
  102daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db2:	8d 50 0c             	lea    0xc(%eax),%edx
  102db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102dbb:	89 55 d0             	mov    %edx,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102dbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102dc1:	8b 00                	mov    (%eax),%eax
  102dc3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102dc6:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102dc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102dcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102dcf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102dd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102dd5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102dd8:	89 10                	mov    %edx,(%eax)
  102dda:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ddd:	8b 10                	mov    (%eax),%edx
  102ddf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102de2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102de5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102de8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102deb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102dee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102df1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102df4:	89 10                	mov    %edx,(%eax)
      if(t>base){
        break;
      }
    }
	struct Page *pp;
	for(pp=base;pp<base+n;pp++){
  102df6:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dfd:	89 d0                	mov    %edx,%eax
  102dff:	c1 e0 02             	shl    $0x2,%eax
  102e02:	01 d0                	add    %edx,%eax
  102e04:	c1 e0 02             	shl    $0x2,%eax
  102e07:	89 c2                	mov    %eax,%edx
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	01 d0                	add    %edx,%eax
  102e0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e11:	77 9c                	ja     102daf <default_free_pages+0xbc>
      list_add_before(pos, &(pp->page_link));
    }
	base->flags = 0;
  102e13:	8b 45 08             	mov    0x8(%ebp),%eax
  102e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102e1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e24:	00 
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
  102e28:	89 04 24             	mov    %eax,(%esp)
  102e2b:	e8 b2 fb ff ff       	call   1029e2 <set_page_ref>
    ClearPageProperty(base);
  102e30:	8b 45 08             	mov    0x8(%ebp),%eax
  102e33:	83 c0 04             	add    $0x4,%eax
  102e36:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102e3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e40:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e43:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102e46:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102e49:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4c:	83 c0 04             	add    $0x4,%eax
  102e4f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102e56:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e5c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102e5f:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e68:	89 50 08             	mov    %edx,0x8(%eax)
	struct Page * p = le2page(pos,page_link);
  102e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6e:	83 e8 0c             	sub    $0xc,%eax
  102e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (p == base + n){
  102e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e77:	89 d0                	mov    %edx,%eax
  102e79:	c1 e0 02             	shl    $0x2,%eax
  102e7c:	01 d0                	add    %edx,%eax
  102e7e:	c1 e0 02             	shl    $0x2,%eax
  102e81:	89 c2                	mov    %eax,%edx
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	01 d0                	add    %edx,%eax
  102e88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e8b:	75 1e                	jne    102eab <default_free_pages+0x1b8>
		base->property += p->property;
  102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e90:	8b 50 08             	mov    0x8(%eax),%edx
  102e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e96:	8b 40 08             	mov    0x8(%eax),%eax
  102e99:	01 c2                	add    %eax,%edx
  102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9e:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  102ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ea4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
    pos = list_prev(&(base->page_link));
  102eab:	8b 45 08             	mov    0x8(%ebp),%eax
  102eae:	83 c0 0c             	add    $0xc,%eax
  102eb1:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102eb4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102eb7:	8b 00                	mov    (%eax),%eax
  102eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(pos,page_link);
  102ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ebf:	83 e8 0c             	sub    $0xc,%eax
  102ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (p==base-1){
  102ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec8:	83 e8 14             	sub    $0x14,%eax
  102ecb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102ece:	75 4e                	jne    102f1e <default_free_pages+0x22b>
    while (pos != &free_list) {
  102ed0:	eb 43                	jmp    102f15 <default_free_pages+0x222>
        if (p->property==0){
  102ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed5:	8b 40 08             	mov    0x8(%eax),%eax
  102ed8:	85 c0                	test   %eax,%eax
  102eda:	75 19                	jne    102ef5 <default_free_pages+0x202>
  102edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102edf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102ee2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102ee5:	8b 00                	mov    (%eax),%eax
			pos = list_prev(pos);
  102ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			p = le2page(pos,page_link);
  102eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eed:	83 e8 0c             	sub    $0xc,%eax
  102ef0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ef3:	eb 20                	jmp    102f15 <default_free_pages+0x222>
		} else {
			p->property += base->property;
  102ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ef8:	8b 50 08             	mov    0x8(%eax),%edx
  102efb:	8b 45 08             	mov    0x8(%ebp),%eax
  102efe:	8b 40 08             	mov    0x8(%eax),%eax
  102f01:	01 c2                	add    %eax,%edx
  102f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f06:	89 50 08             	mov    %edx,0x8(%eax)
			base->property = 0;
  102f09:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			break;
  102f13:	eb 09                	jmp    102f1e <default_free_pages+0x22b>
		p->property = 0;
	}
    pos = list_prev(&(base->page_link));
	p = le2page(pos,page_link);
	if (p==base-1){
    while (pos != &free_list) {
  102f15:	81 7d f4 b0 89 11 00 	cmpl   $0x1189b0,-0xc(%ebp)
  102f1c:	75 b4                	jne    102ed2 <default_free_pages+0x1df>
			break;
		}
        }
    }

    nr_free += n;
  102f1e:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f27:	01 d0                	add    %edx,%eax
  102f29:	a3 b8 89 11 00       	mov    %eax,0x1189b8
    return;
  102f2e:	90                   	nop
}
  102f2f:	c9                   	leave  
  102f30:	c3                   	ret    

00102f31 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102f31:	55                   	push   %ebp
  102f32:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102f34:	a1 b8 89 11 00       	mov    0x1189b8,%eax
}
  102f39:	5d                   	pop    %ebp
  102f3a:	c3                   	ret    

00102f3b <basic_check>:

static void
basic_check(void) {
  102f3b:	55                   	push   %ebp
  102f3c:	89 e5                	mov    %esp,%ebp
  102f3e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102f41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f5b:	e8 85 0e 00 00       	call   103de5 <alloc_pages>
  102f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f67:	75 24                	jne    102f8d <basic_check+0x52>
  102f69:	c7 44 24 0c 04 68 10 	movl   $0x106804,0xc(%esp)
  102f70:	00 
  102f71:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102f78:	00 
  102f79:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102f80:	00 
  102f81:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102f88:	e8 44 dd ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f94:	e8 4c 0e 00 00       	call   103de5 <alloc_pages>
  102f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fa0:	75 24                	jne    102fc6 <basic_check+0x8b>
  102fa2:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  102fa9:	00 
  102faa:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102fb1:	00 
  102fb2:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102fb9:	00 
  102fba:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102fc1:	e8 0b dd ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fcd:	e8 13 0e 00 00       	call   103de5 <alloc_pages>
  102fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fd9:	75 24                	jne    102fff <basic_check+0xc4>
  102fdb:	c7 44 24 0c 3c 68 10 	movl   $0x10683c,0xc(%esp)
  102fe2:	00 
  102fe3:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  102fea:	00 
  102feb:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102ff2:	00 
  102ff3:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  102ffa:	e8 d2 dc ff ff       	call   100cd1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103002:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103005:	74 10                	je     103017 <basic_check+0xdc>
  103007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10300a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10300d:	74 08                	je     103017 <basic_check+0xdc>
  10300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103012:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103015:	75 24                	jne    10303b <basic_check+0x100>
  103017:	c7 44 24 0c 58 68 10 	movl   $0x106858,0xc(%esp)
  10301e:	00 
  10301f:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103026:	00 
  103027:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  10302e:	00 
  10302f:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103036:	e8 96 dc ff ff       	call   100cd1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10303e:	89 04 24             	mov    %eax,(%esp)
  103041:	e8 92 f9 ff ff       	call   1029d8 <page_ref>
  103046:	85 c0                	test   %eax,%eax
  103048:	75 1e                	jne    103068 <basic_check+0x12d>
  10304a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304d:	89 04 24             	mov    %eax,(%esp)
  103050:	e8 83 f9 ff ff       	call   1029d8 <page_ref>
  103055:	85 c0                	test   %eax,%eax
  103057:	75 0f                	jne    103068 <basic_check+0x12d>
  103059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10305c:	89 04 24             	mov    %eax,(%esp)
  10305f:	e8 74 f9 ff ff       	call   1029d8 <page_ref>
  103064:	85 c0                	test   %eax,%eax
  103066:	74 24                	je     10308c <basic_check+0x151>
  103068:	c7 44 24 0c 7c 68 10 	movl   $0x10687c,0xc(%esp)
  10306f:	00 
  103070:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103077:	00 
  103078:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  10307f:	00 
  103080:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103087:	e8 45 dc ff ff       	call   100cd1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10308c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10308f:	89 04 24             	mov    %eax,(%esp)
  103092:	e8 2b f9 ff ff       	call   1029c2 <page2pa>
  103097:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10309d:	c1 e2 0c             	shl    $0xc,%edx
  1030a0:	39 d0                	cmp    %edx,%eax
  1030a2:	72 24                	jb     1030c8 <basic_check+0x18d>
  1030a4:	c7 44 24 0c b8 68 10 	movl   $0x1068b8,0xc(%esp)
  1030ab:	00 
  1030ac:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1030b3:	00 
  1030b4:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  1030bb:	00 
  1030bc:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1030c3:	e8 09 dc ff ff       	call   100cd1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1030c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030cb:	89 04 24             	mov    %eax,(%esp)
  1030ce:	e8 ef f8 ff ff       	call   1029c2 <page2pa>
  1030d3:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1030d9:	c1 e2 0c             	shl    $0xc,%edx
  1030dc:	39 d0                	cmp    %edx,%eax
  1030de:	72 24                	jb     103104 <basic_check+0x1c9>
  1030e0:	c7 44 24 0c d5 68 10 	movl   $0x1068d5,0xc(%esp)
  1030e7:	00 
  1030e8:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1030ef:	00 
  1030f0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1030f7:	00 
  1030f8:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1030ff:	e8 cd db ff ff       	call   100cd1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103107:	89 04 24             	mov    %eax,(%esp)
  10310a:	e8 b3 f8 ff ff       	call   1029c2 <page2pa>
  10310f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103115:	c1 e2 0c             	shl    $0xc,%edx
  103118:	39 d0                	cmp    %edx,%eax
  10311a:	72 24                	jb     103140 <basic_check+0x205>
  10311c:	c7 44 24 0c f2 68 10 	movl   $0x1068f2,0xc(%esp)
  103123:	00 
  103124:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  10312b:	00 
  10312c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  103133:	00 
  103134:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  10313b:	e8 91 db ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  103140:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  103145:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  10314b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10314e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103151:	c7 45 e0 b0 89 11 00 	movl   $0x1189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10315b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10315e:	89 50 04             	mov    %edx,0x4(%eax)
  103161:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103164:	8b 50 04             	mov    0x4(%eax),%edx
  103167:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10316a:	89 10                	mov    %edx,(%eax)
  10316c:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103176:	8b 40 04             	mov    0x4(%eax),%eax
  103179:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10317c:	0f 94 c0             	sete   %al
  10317f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103182:	85 c0                	test   %eax,%eax
  103184:	75 24                	jne    1031aa <basic_check+0x26f>
  103186:	c7 44 24 0c 0f 69 10 	movl   $0x10690f,0xc(%esp)
  10318d:	00 
  10318e:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103195:	00 
  103196:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10319d:	00 
  10319e:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1031a5:	e8 27 db ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  1031aa:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1031af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1031b2:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  1031b9:	00 00 00 

    assert(alloc_page() == NULL);
  1031bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031c3:	e8 1d 0c 00 00       	call   103de5 <alloc_pages>
  1031c8:	85 c0                	test   %eax,%eax
  1031ca:	74 24                	je     1031f0 <basic_check+0x2b5>
  1031cc:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  1031d3:	00 
  1031d4:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1031db:	00 
  1031dc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  1031e3:	00 
  1031e4:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1031eb:	e8 e1 da ff ff       	call   100cd1 <__panic>

    free_page(p0);
  1031f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031f7:	00 
  1031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031fb:	89 04 24             	mov    %eax,(%esp)
  1031fe:	e8 1a 0c 00 00       	call   103e1d <free_pages>
    free_page(p1);
  103203:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10320a:	00 
  10320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10320e:	89 04 24             	mov    %eax,(%esp)
  103211:	e8 07 0c 00 00       	call   103e1d <free_pages>
    free_page(p2);
  103216:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10321d:	00 
  10321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103221:	89 04 24             	mov    %eax,(%esp)
  103224:	e8 f4 0b 00 00       	call   103e1d <free_pages>
    assert(nr_free == 3);
  103229:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  10322e:	83 f8 03             	cmp    $0x3,%eax
  103231:	74 24                	je     103257 <basic_check+0x31c>
  103233:	c7 44 24 0c 3b 69 10 	movl   $0x10693b,0xc(%esp)
  10323a:	00 
  10323b:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103242:	00 
  103243:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  10324a:	00 
  10324b:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103252:	e8 7a da ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103257:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10325e:	e8 82 0b 00 00       	call   103de5 <alloc_pages>
  103263:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103266:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10326a:	75 24                	jne    103290 <basic_check+0x355>
  10326c:	c7 44 24 0c 04 68 10 	movl   $0x106804,0xc(%esp)
  103273:	00 
  103274:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  10327b:	00 
  10327c:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  103283:	00 
  103284:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  10328b:	e8 41 da ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103297:	e8 49 0b 00 00       	call   103de5 <alloc_pages>
  10329c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10329f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032a3:	75 24                	jne    1032c9 <basic_check+0x38e>
  1032a5:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  1032ac:	00 
  1032ad:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1032b4:	00 
  1032b5:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1032bc:	00 
  1032bd:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1032c4:	e8 08 da ff ff       	call   100cd1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1032c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032d0:	e8 10 0b 00 00       	call   103de5 <alloc_pages>
  1032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032dc:	75 24                	jne    103302 <basic_check+0x3c7>
  1032de:	c7 44 24 0c 3c 68 10 	movl   $0x10683c,0xc(%esp)
  1032e5:	00 
  1032e6:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1032ed:	00 
  1032ee:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1032f5:	00 
  1032f6:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1032fd:	e8 cf d9 ff ff       	call   100cd1 <__panic>

    assert(alloc_page() == NULL);
  103302:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103309:	e8 d7 0a 00 00       	call   103de5 <alloc_pages>
  10330e:	85 c0                	test   %eax,%eax
  103310:	74 24                	je     103336 <basic_check+0x3fb>
  103312:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  103319:	00 
  10331a:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103321:	00 
  103322:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  103329:	00 
  10332a:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103331:	e8 9b d9 ff ff       	call   100cd1 <__panic>

    free_page(p0);
  103336:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333d:	00 
  10333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103341:	89 04 24             	mov    %eax,(%esp)
  103344:	e8 d4 0a 00 00       	call   103e1d <free_pages>
  103349:	c7 45 d8 b0 89 11 00 	movl   $0x1189b0,-0x28(%ebp)
  103350:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103353:	8b 40 04             	mov    0x4(%eax),%eax
  103356:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103359:	0f 94 c0             	sete   %al
  10335c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10335f:	85 c0                	test   %eax,%eax
  103361:	74 24                	je     103387 <basic_check+0x44c>
  103363:	c7 44 24 0c 48 69 10 	movl   $0x106948,0xc(%esp)
  10336a:	00 
  10336b:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103372:	00 
  103373:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  10337a:	00 
  10337b:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103382:	e8 4a d9 ff ff       	call   100cd1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103387:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10338e:	e8 52 0a 00 00       	call   103de5 <alloc_pages>
  103393:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103399:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10339c:	74 24                	je     1033c2 <basic_check+0x487>
  10339e:	c7 44 24 0c 60 69 10 	movl   $0x106960,0xc(%esp)
  1033a5:	00 
  1033a6:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1033ad:	00 
  1033ae:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1033b5:	00 
  1033b6:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1033bd:	e8 0f d9 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  1033c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c9:	e8 17 0a 00 00       	call   103de5 <alloc_pages>
  1033ce:	85 c0                	test   %eax,%eax
  1033d0:	74 24                	je     1033f6 <basic_check+0x4bb>
  1033d2:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  1033d9:	00 
  1033da:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1033e1:	00 
  1033e2:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1033e9:	00 
  1033ea:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1033f1:	e8 db d8 ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  1033f6:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1033fb:	85 c0                	test   %eax,%eax
  1033fd:	74 24                	je     103423 <basic_check+0x4e8>
  1033ff:	c7 44 24 0c 79 69 10 	movl   $0x106979,0xc(%esp)
  103406:	00 
  103407:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  10340e:	00 
  10340f:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  103416:	00 
  103417:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  10341e:	e8 ae d8 ff ff       	call   100cd1 <__panic>
    free_list = free_list_store;
  103423:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103426:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103429:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  10342e:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    nr_free = nr_free_store;
  103434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103437:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_page(p);
  10343c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103443:	00 
  103444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103447:	89 04 24             	mov    %eax,(%esp)
  10344a:	e8 ce 09 00 00       	call   103e1d <free_pages>
    free_page(p1);
  10344f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103456:	00 
  103457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10345a:	89 04 24             	mov    %eax,(%esp)
  10345d:	e8 bb 09 00 00       	call   103e1d <free_pages>
    free_page(p2);
  103462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103469:	00 
  10346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10346d:	89 04 24             	mov    %eax,(%esp)
  103470:	e8 a8 09 00 00       	call   103e1d <free_pages>
}
  103475:	c9                   	leave  
  103476:	c3                   	ret    

00103477 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103477:	55                   	push   %ebp
  103478:	89 e5                	mov    %esp,%ebp
  10347a:	53                   	push   %ebx
  10347b:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103481:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10348f:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103496:	eb 6b                	jmp    103503 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10349b:	83 e8 0c             	sub    $0xc,%eax
  10349e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1034a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034a4:	83 c0 04             	add    $0x4,%eax
  1034a7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1034ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1034b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1034b7:	0f a3 10             	bt     %edx,(%eax)
  1034ba:	19 c0                	sbb    %eax,%eax
  1034bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1034bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1034c3:	0f 95 c0             	setne  %al
  1034c6:	0f b6 c0             	movzbl %al,%eax
  1034c9:	85 c0                	test   %eax,%eax
  1034cb:	75 24                	jne    1034f1 <default_check+0x7a>
  1034cd:	c7 44 24 0c 86 69 10 	movl   $0x106986,0xc(%esp)
  1034d4:	00 
  1034d5:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1034dc:	00 
  1034dd:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1034e4:	00 
  1034e5:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1034ec:	e8 e0 d7 ff ff       	call   100cd1 <__panic>
        count ++, total += p->property;
  1034f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f8:	8b 50 08             	mov    0x8(%eax),%edx
  1034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034fe:	01 d0                	add    %edx,%eax
  103500:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103506:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103509:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10350c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10350f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103512:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103519:	0f 85 79 ff ff ff    	jne    103498 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10351f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103522:	e8 28 09 00 00       	call   103e4f <nr_free_pages>
  103527:	39 c3                	cmp    %eax,%ebx
  103529:	74 24                	je     10354f <default_check+0xd8>
  10352b:	c7 44 24 0c 96 69 10 	movl   $0x106996,0xc(%esp)
  103532:	00 
  103533:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  10353a:	00 
  10353b:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  103542:	00 
  103543:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  10354a:	e8 82 d7 ff ff       	call   100cd1 <__panic>

    basic_check();
  10354f:	e8 e7 f9 ff ff       	call   102f3b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103554:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10355b:	e8 85 08 00 00       	call   103de5 <alloc_pages>
  103560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103563:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103567:	75 24                	jne    10358d <default_check+0x116>
  103569:	c7 44 24 0c af 69 10 	movl   $0x1069af,0xc(%esp)
  103570:	00 
  103571:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103578:	00 
  103579:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103580:	00 
  103581:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103588:	e8 44 d7 ff ff       	call   100cd1 <__panic>
    assert(!PageProperty(p0));
  10358d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103590:	83 c0 04             	add    $0x4,%eax
  103593:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10359a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10359d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1035a0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1035a3:	0f a3 10             	bt     %edx,(%eax)
  1035a6:	19 c0                	sbb    %eax,%eax
  1035a8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1035ab:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1035af:	0f 95 c0             	setne  %al
  1035b2:	0f b6 c0             	movzbl %al,%eax
  1035b5:	85 c0                	test   %eax,%eax
  1035b7:	74 24                	je     1035dd <default_check+0x166>
  1035b9:	c7 44 24 0c ba 69 10 	movl   $0x1069ba,0xc(%esp)
  1035c0:	00 
  1035c1:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1035c8:	00 
  1035c9:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1035d0:	00 
  1035d1:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1035d8:	e8 f4 d6 ff ff       	call   100cd1 <__panic>

    list_entry_t free_list_store = free_list;
  1035dd:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  1035e2:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  1035e8:	89 45 80             	mov    %eax,-0x80(%ebp)
  1035eb:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1035ee:	c7 45 b4 b0 89 11 00 	movl   $0x1189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1035f5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035f8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1035fb:	89 50 04             	mov    %edx,0x4(%eax)
  1035fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103601:	8b 50 04             	mov    0x4(%eax),%edx
  103604:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103607:	89 10                	mov    %edx,(%eax)
  103609:	c7 45 b0 b0 89 11 00 	movl   $0x1189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103610:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103613:	8b 40 04             	mov    0x4(%eax),%eax
  103616:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103619:	0f 94 c0             	sete   %al
  10361c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10361f:	85 c0                	test   %eax,%eax
  103621:	75 24                	jne    103647 <default_check+0x1d0>
  103623:	c7 44 24 0c 0f 69 10 	movl   $0x10690f,0xc(%esp)
  10362a:	00 
  10362b:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103632:	00 
  103633:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  10363a:	00 
  10363b:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103642:	e8 8a d6 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  103647:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10364e:	e8 92 07 00 00       	call   103de5 <alloc_pages>
  103653:	85 c0                	test   %eax,%eax
  103655:	74 24                	je     10367b <default_check+0x204>
  103657:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  10365e:	00 
  10365f:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103666:	00 
  103667:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  10366e:	00 
  10366f:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103676:	e8 56 d6 ff ff       	call   100cd1 <__panic>

    unsigned int nr_free_store = nr_free;
  10367b:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103680:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103683:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  10368a:	00 00 00 

    free_pages(p0 + 2, 3);
  10368d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103690:	83 c0 28             	add    $0x28,%eax
  103693:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10369a:	00 
  10369b:	89 04 24             	mov    %eax,(%esp)
  10369e:	e8 7a 07 00 00       	call   103e1d <free_pages>
    assert(alloc_pages(4) == NULL);
  1036a3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1036aa:	e8 36 07 00 00       	call   103de5 <alloc_pages>
  1036af:	85 c0                	test   %eax,%eax
  1036b1:	74 24                	je     1036d7 <default_check+0x260>
  1036b3:	c7 44 24 0c cc 69 10 	movl   $0x1069cc,0xc(%esp)
  1036ba:	00 
  1036bb:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1036c2:	00 
  1036c3:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1036ca:	00 
  1036cb:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1036d2:	e8 fa d5 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1036d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036da:	83 c0 28             	add    $0x28,%eax
  1036dd:	83 c0 04             	add    $0x4,%eax
  1036e0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1036e7:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1036ed:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1036f0:	0f a3 10             	bt     %edx,(%eax)
  1036f3:	19 c0                	sbb    %eax,%eax
  1036f5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1036f8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1036fc:	0f 95 c0             	setne  %al
  1036ff:	0f b6 c0             	movzbl %al,%eax
  103702:	85 c0                	test   %eax,%eax
  103704:	74 0e                	je     103714 <default_check+0x29d>
  103706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103709:	83 c0 28             	add    $0x28,%eax
  10370c:	8b 40 08             	mov    0x8(%eax),%eax
  10370f:	83 f8 03             	cmp    $0x3,%eax
  103712:	74 24                	je     103738 <default_check+0x2c1>
  103714:	c7 44 24 0c e4 69 10 	movl   $0x1069e4,0xc(%esp)
  10371b:	00 
  10371c:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103723:	00 
  103724:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10372b:	00 
  10372c:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103733:	e8 99 d5 ff ff       	call   100cd1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103738:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10373f:	e8 a1 06 00 00       	call   103de5 <alloc_pages>
  103744:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103747:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10374b:	75 24                	jne    103771 <default_check+0x2fa>
  10374d:	c7 44 24 0c 10 6a 10 	movl   $0x106a10,0xc(%esp)
  103754:	00 
  103755:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  10375c:	00 
  10375d:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103764:	00 
  103765:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  10376c:	e8 60 d5 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  103771:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103778:	e8 68 06 00 00       	call   103de5 <alloc_pages>
  10377d:	85 c0                	test   %eax,%eax
  10377f:	74 24                	je     1037a5 <default_check+0x32e>
  103781:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  103788:	00 
  103789:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103790:	00 
  103791:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103798:	00 
  103799:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1037a0:	e8 2c d5 ff ff       	call   100cd1 <__panic>
    assert(p0 + 2 == p1);
  1037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037a8:	83 c0 28             	add    $0x28,%eax
  1037ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1037ae:	74 24                	je     1037d4 <default_check+0x35d>
  1037b0:	c7 44 24 0c 2e 6a 10 	movl   $0x106a2e,0xc(%esp)
  1037b7:	00 
  1037b8:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1037bf:	00 
  1037c0:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1037c7:	00 
  1037c8:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1037cf:	e8 fd d4 ff ff       	call   100cd1 <__panic>

    p2 = p0 + 1;
  1037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037d7:	83 c0 14             	add    $0x14,%eax
  1037da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1037dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037e4:	00 
  1037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037e8:	89 04 24             	mov    %eax,(%esp)
  1037eb:	e8 2d 06 00 00       	call   103e1d <free_pages>
    free_pages(p1, 3);
  1037f0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037f7:	00 
  1037f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037fb:	89 04 24             	mov    %eax,(%esp)
  1037fe:	e8 1a 06 00 00       	call   103e1d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103806:	83 c0 04             	add    $0x4,%eax
  103809:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103810:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103813:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103816:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103819:	0f a3 10             	bt     %edx,(%eax)
  10381c:	19 c0                	sbb    %eax,%eax
  10381e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103821:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103825:	0f 95 c0             	setne  %al
  103828:	0f b6 c0             	movzbl %al,%eax
  10382b:	85 c0                	test   %eax,%eax
  10382d:	74 0b                	je     10383a <default_check+0x3c3>
  10382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103832:	8b 40 08             	mov    0x8(%eax),%eax
  103835:	83 f8 01             	cmp    $0x1,%eax
  103838:	74 24                	je     10385e <default_check+0x3e7>
  10383a:	c7 44 24 0c 3c 6a 10 	movl   $0x106a3c,0xc(%esp)
  103841:	00 
  103842:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103849:	00 
  10384a:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103851:	00 
  103852:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103859:	e8 73 d4 ff ff       	call   100cd1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10385e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103861:	83 c0 04             	add    $0x4,%eax
  103864:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10386b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10386e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103871:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103874:	0f a3 10             	bt     %edx,(%eax)
  103877:	19 c0                	sbb    %eax,%eax
  103879:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10387c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103880:	0f 95 c0             	setne  %al
  103883:	0f b6 c0             	movzbl %al,%eax
  103886:	85 c0                	test   %eax,%eax
  103888:	74 0b                	je     103895 <default_check+0x41e>
  10388a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10388d:	8b 40 08             	mov    0x8(%eax),%eax
  103890:	83 f8 03             	cmp    $0x3,%eax
  103893:	74 24                	je     1038b9 <default_check+0x442>
  103895:	c7 44 24 0c 64 6a 10 	movl   $0x106a64,0xc(%esp)
  10389c:	00 
  10389d:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1038a4:	00 
  1038a5:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1038ac:	00 
  1038ad:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1038b4:	e8 18 d4 ff ff       	call   100cd1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1038b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038c0:	e8 20 05 00 00       	call   103de5 <alloc_pages>
  1038c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038cb:	83 e8 14             	sub    $0x14,%eax
  1038ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038d1:	74 24                	je     1038f7 <default_check+0x480>
  1038d3:	c7 44 24 0c 8a 6a 10 	movl   $0x106a8a,0xc(%esp)
  1038da:	00 
  1038db:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1038e2:	00 
  1038e3:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1038ea:	00 
  1038eb:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1038f2:	e8 da d3 ff ff       	call   100cd1 <__panic>
    free_page(p0);
  1038f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038fe:	00 
  1038ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103902:	89 04 24             	mov    %eax,(%esp)
  103905:	e8 13 05 00 00       	call   103e1d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10390a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103911:	e8 cf 04 00 00       	call   103de5 <alloc_pages>
  103916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103919:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10391c:	83 c0 14             	add    $0x14,%eax
  10391f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103922:	74 24                	je     103948 <default_check+0x4d1>
  103924:	c7 44 24 0c a8 6a 10 	movl   $0x106aa8,0xc(%esp)
  10392b:	00 
  10392c:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103933:	00 
  103934:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  10393b:	00 
  10393c:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103943:	e8 89 d3 ff ff       	call   100cd1 <__panic>

    free_pages(p0, 2);
  103948:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10394f:	00 
  103950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103953:	89 04 24             	mov    %eax,(%esp)
  103956:	e8 c2 04 00 00       	call   103e1d <free_pages>
    free_page(p2);
  10395b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103962:	00 
  103963:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103966:	89 04 24             	mov    %eax,(%esp)
  103969:	e8 af 04 00 00       	call   103e1d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10396e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103975:	e8 6b 04 00 00       	call   103de5 <alloc_pages>
  10397a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10397d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103981:	75 24                	jne    1039a7 <default_check+0x530>
  103983:	c7 44 24 0c c8 6a 10 	movl   $0x106ac8,0xc(%esp)
  10398a:	00 
  10398b:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103992:	00 
  103993:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10399a:	00 
  10399b:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1039a2:	e8 2a d3 ff ff       	call   100cd1 <__panic>
    assert(alloc_page() == NULL);
  1039a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039ae:	e8 32 04 00 00       	call   103de5 <alloc_pages>
  1039b3:	85 c0                	test   %eax,%eax
  1039b5:	74 24                	je     1039db <default_check+0x564>
  1039b7:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  1039be:	00 
  1039bf:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1039c6:	00 
  1039c7:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1039ce:	00 
  1039cf:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  1039d6:	e8 f6 d2 ff ff       	call   100cd1 <__panic>

    assert(nr_free == 0);
  1039db:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1039e0:	85 c0                	test   %eax,%eax
  1039e2:	74 24                	je     103a08 <default_check+0x591>
  1039e4:	c7 44 24 0c 79 69 10 	movl   $0x106979,0xc(%esp)
  1039eb:	00 
  1039ec:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  1039f3:	00 
  1039f4:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1039fb:	00 
  1039fc:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103a03:	e8 c9 d2 ff ff       	call   100cd1 <__panic>
    nr_free = nr_free_store;
  103a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a0b:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_list = free_list_store;
  103a10:	8b 45 80             	mov    -0x80(%ebp),%eax
  103a13:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103a16:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  103a1b:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    free_pages(p0, 5);
  103a21:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103a28:	00 
  103a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a2c:	89 04 24             	mov    %eax,(%esp)
  103a2f:	e8 e9 03 00 00       	call   103e1d <free_pages>

    le = &free_list;
  103a34:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103a3b:	eb 1d                	jmp    103a5a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a40:	83 e8 0c             	sub    $0xc,%eax
  103a43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103a46:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103a4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103a50:	8b 40 08             	mov    0x8(%eax),%eax
  103a53:	29 c2                	sub    %eax,%edx
  103a55:	89 d0                	mov    %edx,%eax
  103a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a5d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103a60:	8b 45 88             	mov    -0x78(%ebp),%eax
  103a63:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a69:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103a70:	75 cb                	jne    103a3d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a76:	74 24                	je     103a9c <default_check+0x625>
  103a78:	c7 44 24 0c e6 6a 10 	movl   $0x106ae6,0xc(%esp)
  103a7f:	00 
  103a80:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103a87:	00 
  103a88:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  103a8f:	00 
  103a90:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103a97:	e8 35 d2 ff ff       	call   100cd1 <__panic>
    assert(total == 0);
  103a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aa0:	74 24                	je     103ac6 <default_check+0x64f>
  103aa2:	c7 44 24 0c f1 6a 10 	movl   $0x106af1,0xc(%esp)
  103aa9:	00 
  103aaa:	c7 44 24 08 b6 67 10 	movl   $0x1067b6,0x8(%esp)
  103ab1:	00 
  103ab2:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103ab9:	00 
  103aba:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  103ac1:	e8 0b d2 ff ff       	call   100cd1 <__panic>
}
  103ac6:	81 c4 94 00 00 00    	add    $0x94,%esp
  103acc:	5b                   	pop    %ebx
  103acd:	5d                   	pop    %ebp
  103ace:	c3                   	ret    

00103acf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103acf:	55                   	push   %ebp
  103ad0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  103ad5:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  103ada:	29 c2                	sub    %eax,%edx
  103adc:	89 d0                	mov    %edx,%eax
  103ade:	c1 f8 02             	sar    $0x2,%eax
  103ae1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103ae7:	5d                   	pop    %ebp
  103ae8:	c3                   	ret    

00103ae9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103ae9:	55                   	push   %ebp
  103aea:	89 e5                	mov    %esp,%ebp
  103aec:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103aef:	8b 45 08             	mov    0x8(%ebp),%eax
  103af2:	89 04 24             	mov    %eax,(%esp)
  103af5:	e8 d5 ff ff ff       	call   103acf <page2ppn>
  103afa:	c1 e0 0c             	shl    $0xc,%eax
}
  103afd:	c9                   	leave  
  103afe:	c3                   	ret    

00103aff <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103aff:	55                   	push   %ebp
  103b00:	89 e5                	mov    %esp,%ebp
  103b02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103b05:	8b 45 08             	mov    0x8(%ebp),%eax
  103b08:	c1 e8 0c             	shr    $0xc,%eax
  103b0b:	89 c2                	mov    %eax,%edx
  103b0d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b12:	39 c2                	cmp    %eax,%edx
  103b14:	72 1c                	jb     103b32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103b16:	c7 44 24 08 2c 6b 10 	movl   $0x106b2c,0x8(%esp)
  103b1d:	00 
  103b1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103b25:	00 
  103b26:	c7 04 24 4b 6b 10 00 	movl   $0x106b4b,(%esp)
  103b2d:	e8 9f d1 ff ff       	call   100cd1 <__panic>
    }
    return &pages[PPN(pa)];
  103b32:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  103b38:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3b:	c1 e8 0c             	shr    $0xc,%eax
  103b3e:	89 c2                	mov    %eax,%edx
  103b40:	89 d0                	mov    %edx,%eax
  103b42:	c1 e0 02             	shl    $0x2,%eax
  103b45:	01 d0                	add    %edx,%eax
  103b47:	c1 e0 02             	shl    $0x2,%eax
  103b4a:	01 c8                	add    %ecx,%eax
}
  103b4c:	c9                   	leave  
  103b4d:	c3                   	ret    

00103b4e <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103b4e:	55                   	push   %ebp
  103b4f:	89 e5                	mov    %esp,%ebp
  103b51:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103b54:	8b 45 08             	mov    0x8(%ebp),%eax
  103b57:	89 04 24             	mov    %eax,(%esp)
  103b5a:	e8 8a ff ff ff       	call   103ae9 <page2pa>
  103b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b65:	c1 e8 0c             	shr    $0xc,%eax
  103b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b6b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b70:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b73:	72 23                	jb     103b98 <page2kva+0x4a>
  103b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b78:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b7c:	c7 44 24 08 5c 6b 10 	movl   $0x106b5c,0x8(%esp)
  103b83:	00 
  103b84:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b8b:	00 
  103b8c:	c7 04 24 4b 6b 10 00 	movl   $0x106b4b,(%esp)
  103b93:	e8 39 d1 ff ff       	call   100cd1 <__panic>
  103b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ba0:	c9                   	leave  
  103ba1:	c3                   	ret    

00103ba2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103ba2:	55                   	push   %ebp
  103ba3:	89 e5                	mov    %esp,%ebp
  103ba5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  103bab:	83 e0 01             	and    $0x1,%eax
  103bae:	85 c0                	test   %eax,%eax
  103bb0:	75 1c                	jne    103bce <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103bb2:	c7 44 24 08 80 6b 10 	movl   $0x106b80,0x8(%esp)
  103bb9:	00 
  103bba:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103bc1:	00 
  103bc2:	c7 04 24 4b 6b 10 00 	movl   $0x106b4b,(%esp)
  103bc9:	e8 03 d1 ff ff       	call   100cd1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103bce:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bd6:	89 04 24             	mov    %eax,(%esp)
  103bd9:	e8 21 ff ff ff       	call   103aff <pa2page>
}
  103bde:	c9                   	leave  
  103bdf:	c3                   	ret    

00103be0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103be0:	55                   	push   %ebp
  103be1:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103be3:	8b 45 08             	mov    0x8(%ebp),%eax
  103be6:	8b 00                	mov    (%eax),%eax
}
  103be8:	5d                   	pop    %ebp
  103be9:	c3                   	ret    

00103bea <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103bea:	55                   	push   %ebp
  103beb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103bed:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  103bf3:	89 10                	mov    %edx,(%eax)
}
  103bf5:	5d                   	pop    %ebp
  103bf6:	c3                   	ret    

00103bf7 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103bf7:	55                   	push   %ebp
  103bf8:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  103bfd:	8b 00                	mov    (%eax),%eax
  103bff:	8d 50 01             	lea    0x1(%eax),%edx
  103c02:	8b 45 08             	mov    0x8(%ebp),%eax
  103c05:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c07:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0a:	8b 00                	mov    (%eax),%eax
}
  103c0c:	5d                   	pop    %ebp
  103c0d:	c3                   	ret    

00103c0e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103c0e:	55                   	push   %ebp
  103c0f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103c11:	8b 45 08             	mov    0x8(%ebp),%eax
  103c14:	8b 00                	mov    (%eax),%eax
  103c16:	8d 50 ff             	lea    -0x1(%eax),%edx
  103c19:	8b 45 08             	mov    0x8(%ebp),%eax
  103c1c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103c21:	8b 00                	mov    (%eax),%eax
}
  103c23:	5d                   	pop    %ebp
  103c24:	c3                   	ret    

00103c25 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103c25:	55                   	push   %ebp
  103c26:	89 e5                	mov    %esp,%ebp
  103c28:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103c2b:	9c                   	pushf  
  103c2c:	58                   	pop    %eax
  103c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103c33:	25 00 02 00 00       	and    $0x200,%eax
  103c38:	85 c0                	test   %eax,%eax
  103c3a:	74 0c                	je     103c48 <__intr_save+0x23>
        intr_disable();
  103c3c:	e8 73 da ff ff       	call   1016b4 <intr_disable>
        return 1;
  103c41:	b8 01 00 00 00       	mov    $0x1,%eax
  103c46:	eb 05                	jmp    103c4d <__intr_save+0x28>
    }
    return 0;
  103c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103c4d:	c9                   	leave  
  103c4e:	c3                   	ret    

00103c4f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103c4f:	55                   	push   %ebp
  103c50:	89 e5                	mov    %esp,%ebp
  103c52:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103c55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103c59:	74 05                	je     103c60 <__intr_restore+0x11>
        intr_enable();
  103c5b:	e8 4e da ff ff       	call   1016ae <intr_enable>
    }
}
  103c60:	c9                   	leave  
  103c61:	c3                   	ret    

00103c62 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103c62:	55                   	push   %ebp
  103c63:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c65:	8b 45 08             	mov    0x8(%ebp),%eax
  103c68:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c6b:	b8 23 00 00 00       	mov    $0x23,%eax
  103c70:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c72:	b8 23 00 00 00       	mov    $0x23,%eax
  103c77:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103c79:	b8 10 00 00 00       	mov    $0x10,%eax
  103c7e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103c80:	b8 10 00 00 00       	mov    $0x10,%eax
  103c85:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103c87:	b8 10 00 00 00       	mov    $0x10,%eax
  103c8c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103c8e:	ea 95 3c 10 00 08 00 	ljmp   $0x8,$0x103c95
}
  103c95:	5d                   	pop    %ebp
  103c96:	c3                   	ret    

00103c97 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c97:	55                   	push   %ebp
  103c98:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c9d:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103ca2:	5d                   	pop    %ebp
  103ca3:	c3                   	ret    

00103ca4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103ca4:	55                   	push   %ebp
  103ca5:	89 e5                	mov    %esp,%ebp
  103ca7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103caa:	b8 00 70 11 00       	mov    $0x117000,%eax
  103caf:	89 04 24             	mov    %eax,(%esp)
  103cb2:	e8 e0 ff ff ff       	call   103c97 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103cb7:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103cbe:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103cc0:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103cc7:	68 00 
  103cc9:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103cce:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103cd4:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103cd9:	c1 e8 10             	shr    $0x10,%eax
  103cdc:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103ce1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ce8:	83 e0 f0             	and    $0xfffffff0,%eax
  103ceb:	83 c8 09             	or     $0x9,%eax
  103cee:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cf3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cfa:	83 e0 ef             	and    $0xffffffef,%eax
  103cfd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d02:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d09:	83 e0 9f             	and    $0xffffff9f,%eax
  103d0c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d11:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d18:	83 c8 80             	or     $0xffffff80,%eax
  103d1b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d20:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d27:	83 e0 f0             	and    $0xfffffff0,%eax
  103d2a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d2f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d36:	83 e0 ef             	and    $0xffffffef,%eax
  103d39:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d3e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d45:	83 e0 df             	and    $0xffffffdf,%eax
  103d48:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d4d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d54:	83 c8 40             	or     $0x40,%eax
  103d57:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d5c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d63:	83 e0 7f             	and    $0x7f,%eax
  103d66:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d6b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103d70:	c1 e8 18             	shr    $0x18,%eax
  103d73:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103d78:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103d7f:	e8 de fe ff ff       	call   103c62 <lgdt>
  103d84:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103d8a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103d8e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103d91:	c9                   	leave  
  103d92:	c3                   	ret    

00103d93 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103d93:	55                   	push   %ebp
  103d94:	89 e5                	mov    %esp,%ebp
  103d96:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d99:	c7 05 bc 89 11 00 10 	movl   $0x106b10,0x1189bc
  103da0:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103da3:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103da8:	8b 00                	mov    (%eax),%eax
  103daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  103dae:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  103db5:	e8 8d c5 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  103dba:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103dbf:	8b 40 04             	mov    0x4(%eax),%eax
  103dc2:	ff d0                	call   *%eax
}
  103dc4:	c9                   	leave  
  103dc5:	c3                   	ret    

00103dc6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103dc6:	55                   	push   %ebp
  103dc7:	89 e5                	mov    %esp,%ebp
  103dc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103dcc:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103dd1:	8b 40 08             	mov    0x8(%eax),%eax
  103dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103dd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  103dde:	89 14 24             	mov    %edx,(%esp)
  103de1:	ff d0                	call   *%eax
}
  103de3:	c9                   	leave  
  103de4:	c3                   	ret    

00103de5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103de5:	55                   	push   %ebp
  103de6:	89 e5                	mov    %esp,%ebp
  103de8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103df2:	e8 2e fe ff ff       	call   103c25 <__intr_save>
  103df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103dfa:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103dff:	8b 40 0c             	mov    0xc(%eax),%eax
  103e02:	8b 55 08             	mov    0x8(%ebp),%edx
  103e05:	89 14 24             	mov    %edx,(%esp)
  103e08:	ff d0                	call   *%eax
  103e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e10:	89 04 24             	mov    %eax,(%esp)
  103e13:	e8 37 fe ff ff       	call   103c4f <__intr_restore>
    return page;
  103e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103e1b:	c9                   	leave  
  103e1c:	c3                   	ret    

00103e1d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103e1d:	55                   	push   %ebp
  103e1e:	89 e5                	mov    %esp,%ebp
  103e20:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103e23:	e8 fd fd ff ff       	call   103c25 <__intr_save>
  103e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103e2b:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e30:	8b 40 10             	mov    0x10(%eax),%eax
  103e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e36:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  103e3d:	89 14 24             	mov    %edx,(%esp)
  103e40:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e45:	89 04 24             	mov    %eax,(%esp)
  103e48:	e8 02 fe ff ff       	call   103c4f <__intr_restore>
}
  103e4d:	c9                   	leave  
  103e4e:	c3                   	ret    

00103e4f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103e4f:	55                   	push   %ebp
  103e50:	89 e5                	mov    %esp,%ebp
  103e52:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103e55:	e8 cb fd ff ff       	call   103c25 <__intr_save>
  103e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103e5d:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e62:	8b 40 14             	mov    0x14(%eax),%eax
  103e65:	ff d0                	call   *%eax
  103e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e6d:	89 04 24             	mov    %eax,(%esp)
  103e70:	e8 da fd ff ff       	call   103c4f <__intr_restore>
    return ret;
  103e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103e78:	c9                   	leave  
  103e79:	c3                   	ret    

00103e7a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103e7a:	55                   	push   %ebp
  103e7b:	89 e5                	mov    %esp,%ebp
  103e7d:	57                   	push   %edi
  103e7e:	56                   	push   %esi
  103e7f:	53                   	push   %ebx
  103e80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103e86:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103e8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103e94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e9b:	c7 04 24 c3 6b 10 00 	movl   $0x106bc3,(%esp)
  103ea2:	e8 a0 c4 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ea7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103eae:	e9 15 01 00 00       	jmp    103fc8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103eb3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103eb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eb9:	89 d0                	mov    %edx,%eax
  103ebb:	c1 e0 02             	shl    $0x2,%eax
  103ebe:	01 d0                	add    %edx,%eax
  103ec0:	c1 e0 02             	shl    $0x2,%eax
  103ec3:	01 c8                	add    %ecx,%eax
  103ec5:	8b 50 08             	mov    0x8(%eax),%edx
  103ec8:	8b 40 04             	mov    0x4(%eax),%eax
  103ecb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103ece:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103ed1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ed4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ed7:	89 d0                	mov    %edx,%eax
  103ed9:	c1 e0 02             	shl    $0x2,%eax
  103edc:	01 d0                	add    %edx,%eax
  103ede:	c1 e0 02             	shl    $0x2,%eax
  103ee1:	01 c8                	add    %ecx,%eax
  103ee3:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ee6:	8b 58 10             	mov    0x10(%eax),%ebx
  103ee9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103eec:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103eef:	01 c8                	add    %ecx,%eax
  103ef1:	11 da                	adc    %ebx,%edx
  103ef3:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103ef6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103ef9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103efc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eff:	89 d0                	mov    %edx,%eax
  103f01:	c1 e0 02             	shl    $0x2,%eax
  103f04:	01 d0                	add    %edx,%eax
  103f06:	c1 e0 02             	shl    $0x2,%eax
  103f09:	01 c8                	add    %ecx,%eax
  103f0b:	83 c0 14             	add    $0x14,%eax
  103f0e:	8b 00                	mov    (%eax),%eax
  103f10:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103f16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f19:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f1c:	83 c0 ff             	add    $0xffffffff,%eax
  103f1f:	83 d2 ff             	adc    $0xffffffff,%edx
  103f22:	89 c6                	mov    %eax,%esi
  103f24:	89 d7                	mov    %edx,%edi
  103f26:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f2c:	89 d0                	mov    %edx,%eax
  103f2e:	c1 e0 02             	shl    $0x2,%eax
  103f31:	01 d0                	add    %edx,%eax
  103f33:	c1 e0 02             	shl    $0x2,%eax
  103f36:	01 c8                	add    %ecx,%eax
  103f38:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f3b:	8b 58 10             	mov    0x10(%eax),%ebx
  103f3e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103f44:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103f48:	89 74 24 14          	mov    %esi,0x14(%esp)
  103f4c:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103f50:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f5a:	89 54 24 10          	mov    %edx,0x10(%esp)
  103f5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f66:	c7 04 24 d0 6b 10 00 	movl   $0x106bd0,(%esp)
  103f6d:	e8 d5 c3 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103f72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f78:	89 d0                	mov    %edx,%eax
  103f7a:	c1 e0 02             	shl    $0x2,%eax
  103f7d:	01 d0                	add    %edx,%eax
  103f7f:	c1 e0 02             	shl    $0x2,%eax
  103f82:	01 c8                	add    %ecx,%eax
  103f84:	83 c0 14             	add    $0x14,%eax
  103f87:	8b 00                	mov    (%eax),%eax
  103f89:	83 f8 01             	cmp    $0x1,%eax
  103f8c:	75 36                	jne    103fc4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f94:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f97:	77 2b                	ja     103fc4 <page_init+0x14a>
  103f99:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f9c:	72 05                	jb     103fa3 <page_init+0x129>
  103f9e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103fa1:	73 21                	jae    103fc4 <page_init+0x14a>
  103fa3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103fa7:	77 1b                	ja     103fc4 <page_init+0x14a>
  103fa9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103fad:	72 09                	jb     103fb8 <page_init+0x13e>
  103faf:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103fb6:	77 0c                	ja     103fc4 <page_init+0x14a>
                maxpa = end;
  103fb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103fbb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103fc1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fc4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fc8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103fcb:	8b 00                	mov    (%eax),%eax
  103fcd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103fd0:	0f 8f dd fe ff ff    	jg     103eb3 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103fda:	72 1d                	jb     103ff9 <page_init+0x17f>
  103fdc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103fe0:	77 09                	ja     103feb <page_init+0x171>
  103fe2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103fe9:	76 0e                	jbe    103ff9 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103feb:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ff2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103fff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104003:	c1 ea 0c             	shr    $0xc,%edx
  104006:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10400b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  104012:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  104017:	8d 50 ff             	lea    -0x1(%eax),%edx
  10401a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10401d:	01 d0                	add    %edx,%eax
  10401f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104022:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104025:	ba 00 00 00 00       	mov    $0x0,%edx
  10402a:	f7 75 ac             	divl   -0x54(%ebp)
  10402d:	89 d0                	mov    %edx,%eax
  10402f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104032:	29 c2                	sub    %eax,%edx
  104034:	89 d0                	mov    %edx,%eax
  104036:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    for (i = 0; i < npage; i ++) {
  10403b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104042:	eb 2f                	jmp    104073 <page_init+0x1f9>
        SetPageReserved(pages + i);
  104044:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  10404a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10404d:	89 d0                	mov    %edx,%eax
  10404f:	c1 e0 02             	shl    $0x2,%eax
  104052:	01 d0                	add    %edx,%eax
  104054:	c1 e0 02             	shl    $0x2,%eax
  104057:	01 c8                	add    %ecx,%eax
  104059:	83 c0 04             	add    $0x4,%eax
  10405c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104063:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104066:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104069:	8b 55 90             	mov    -0x70(%ebp),%edx
  10406c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10406f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104073:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104076:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10407b:	39 c2                	cmp    %eax,%edx
  10407d:	72 c5                	jb     104044 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10407f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104085:	89 d0                	mov    %edx,%eax
  104087:	c1 e0 02             	shl    $0x2,%eax
  10408a:	01 d0                	add    %edx,%eax
  10408c:	c1 e0 02             	shl    $0x2,%eax
  10408f:	89 c2                	mov    %eax,%edx
  104091:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104096:	01 d0                	add    %edx,%eax
  104098:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10409b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1040a2:	77 23                	ja     1040c7 <page_init+0x24d>
  1040a4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1040a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040ab:	c7 44 24 08 00 6c 10 	movl   $0x106c00,0x8(%esp)
  1040b2:	00 
  1040b3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1040ba:	00 
  1040bb:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1040c2:	e8 0a cc ff ff       	call   100cd1 <__panic>
  1040c7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1040ca:	05 00 00 00 40       	add    $0x40000000,%eax
  1040cf:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1040d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1040d9:	e9 74 01 00 00       	jmp    104252 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1040de:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040e4:	89 d0                	mov    %edx,%eax
  1040e6:	c1 e0 02             	shl    $0x2,%eax
  1040e9:	01 d0                	add    %edx,%eax
  1040eb:	c1 e0 02             	shl    $0x2,%eax
  1040ee:	01 c8                	add    %ecx,%eax
  1040f0:	8b 50 08             	mov    0x8(%eax),%edx
  1040f3:	8b 40 04             	mov    0x4(%eax),%eax
  1040f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1040fc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104102:	89 d0                	mov    %edx,%eax
  104104:	c1 e0 02             	shl    $0x2,%eax
  104107:	01 d0                	add    %edx,%eax
  104109:	c1 e0 02             	shl    $0x2,%eax
  10410c:	01 c8                	add    %ecx,%eax
  10410e:	8b 48 0c             	mov    0xc(%eax),%ecx
  104111:	8b 58 10             	mov    0x10(%eax),%ebx
  104114:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104117:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10411a:	01 c8                	add    %ecx,%eax
  10411c:	11 da                	adc    %ebx,%edx
  10411e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104121:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104124:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104127:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10412a:	89 d0                	mov    %edx,%eax
  10412c:	c1 e0 02             	shl    $0x2,%eax
  10412f:	01 d0                	add    %edx,%eax
  104131:	c1 e0 02             	shl    $0x2,%eax
  104134:	01 c8                	add    %ecx,%eax
  104136:	83 c0 14             	add    $0x14,%eax
  104139:	8b 00                	mov    (%eax),%eax
  10413b:	83 f8 01             	cmp    $0x1,%eax
  10413e:	0f 85 0a 01 00 00    	jne    10424e <page_init+0x3d4>
            if (begin < freemem) {
  104144:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104147:	ba 00 00 00 00       	mov    $0x0,%edx
  10414c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10414f:	72 17                	jb     104168 <page_init+0x2ee>
  104151:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104154:	77 05                	ja     10415b <page_init+0x2e1>
  104156:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104159:	76 0d                	jbe    104168 <page_init+0x2ee>
                begin = freemem;
  10415b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10415e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104161:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104168:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10416c:	72 1d                	jb     10418b <page_init+0x311>
  10416e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104172:	77 09                	ja     10417d <page_init+0x303>
  104174:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10417b:	76 0e                	jbe    10418b <page_init+0x311>
                end = KMEMSIZE;
  10417d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104184:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10418b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10418e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104191:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104194:	0f 87 b4 00 00 00    	ja     10424e <page_init+0x3d4>
  10419a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10419d:	72 09                	jb     1041a8 <page_init+0x32e>
  10419f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1041a2:	0f 83 a6 00 00 00    	jae    10424e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1041a8:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1041af:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041b2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1041b5:	01 d0                	add    %edx,%eax
  1041b7:	83 e8 01             	sub    $0x1,%eax
  1041ba:	89 45 98             	mov    %eax,-0x68(%ebp)
  1041bd:	8b 45 98             	mov    -0x68(%ebp),%eax
  1041c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1041c5:	f7 75 9c             	divl   -0x64(%ebp)
  1041c8:	89 d0                	mov    %edx,%eax
  1041ca:	8b 55 98             	mov    -0x68(%ebp),%edx
  1041cd:	29 c2                	sub    %eax,%edx
  1041cf:	89 d0                	mov    %edx,%eax
  1041d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1041d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1041dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041df:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1041e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1041e5:	ba 00 00 00 00       	mov    $0x0,%edx
  1041ea:	89 c7                	mov    %eax,%edi
  1041ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1041f2:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1041f5:	89 d0                	mov    %edx,%eax
  1041f7:	83 e0 00             	and    $0x0,%eax
  1041fa:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1041fd:	8b 45 80             	mov    -0x80(%ebp),%eax
  104200:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104203:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104206:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104209:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10420c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10420f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104212:	77 3a                	ja     10424e <page_init+0x3d4>
  104214:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104217:	72 05                	jb     10421e <page_init+0x3a4>
  104219:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10421c:	73 30                	jae    10424e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10421e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104221:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104224:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104227:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10422a:	29 c8                	sub    %ecx,%eax
  10422c:	19 da                	sbb    %ebx,%edx
  10422e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104232:	c1 ea 0c             	shr    $0xc,%edx
  104235:	89 c3                	mov    %eax,%ebx
  104237:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10423a:	89 04 24             	mov    %eax,(%esp)
  10423d:	e8 bd f8 ff ff       	call   103aff <pa2page>
  104242:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104246:	89 04 24             	mov    %eax,(%esp)
  104249:	e8 78 fb ff ff       	call   103dc6 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10424e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104252:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104255:	8b 00                	mov    (%eax),%eax
  104257:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10425a:	0f 8f 7e fe ff ff    	jg     1040de <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104260:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104266:	5b                   	pop    %ebx
  104267:	5e                   	pop    %esi
  104268:	5f                   	pop    %edi
  104269:	5d                   	pop    %ebp
  10426a:	c3                   	ret    

0010426b <enable_paging>:

static void
enable_paging(void) {
  10426b:	55                   	push   %ebp
  10426c:	89 e5                	mov    %esp,%ebp
  10426e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104271:	a1 c0 89 11 00       	mov    0x1189c0,%eax
  104276:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104279:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10427c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10427f:	0f 20 c0             	mov    %cr0,%eax
  104282:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104285:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104288:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10428b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104292:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104299:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10429c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10429f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1042a2:	c9                   	leave  
  1042a3:	c3                   	ret    

001042a4 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1042a4:	55                   	push   %ebp
  1042a5:	89 e5                	mov    %esp,%ebp
  1042a7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1042aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1042ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042b0:	31 d0                	xor    %edx,%eax
  1042b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042b7:	85 c0                	test   %eax,%eax
  1042b9:	74 24                	je     1042df <boot_map_segment+0x3b>
  1042bb:	c7 44 24 0c 32 6c 10 	movl   $0x106c32,0xc(%esp)
  1042c2:	00 
  1042c3:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1042ca:	00 
  1042cb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1042d2:	00 
  1042d3:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1042da:	e8 f2 c9 ff ff       	call   100cd1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1042df:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1042e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042e9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042ee:	89 c2                	mov    %eax,%edx
  1042f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1042f3:	01 c2                	add    %eax,%edx
  1042f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f8:	01 d0                	add    %edx,%eax
  1042fa:	83 e8 01             	sub    $0x1,%eax
  1042fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104303:	ba 00 00 00 00       	mov    $0x0,%edx
  104308:	f7 75 f0             	divl   -0x10(%ebp)
  10430b:	89 d0                	mov    %edx,%eax
  10430d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104310:	29 c2                	sub    %eax,%edx
  104312:	89 d0                	mov    %edx,%eax
  104314:	c1 e8 0c             	shr    $0xc,%eax
  104317:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10431a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10431d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104320:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104323:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104328:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10432b:	8b 45 14             	mov    0x14(%ebp),%eax
  10432e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104334:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104339:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10433c:	eb 6b                	jmp    1043a9 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10433e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104345:	00 
  104346:	8b 45 0c             	mov    0xc(%ebp),%eax
  104349:	89 44 24 04          	mov    %eax,0x4(%esp)
  10434d:	8b 45 08             	mov    0x8(%ebp),%eax
  104350:	89 04 24             	mov    %eax,(%esp)
  104353:	e8 cc 01 00 00       	call   104524 <get_pte>
  104358:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10435b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10435f:	75 24                	jne    104385 <boot_map_segment+0xe1>
  104361:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104368:	00 
  104369:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104370:	00 
  104371:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104378:	00 
  104379:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104380:	e8 4c c9 ff ff       	call   100cd1 <__panic>
        *ptep = pa | PTE_P | perm;
  104385:	8b 45 18             	mov    0x18(%ebp),%eax
  104388:	8b 55 14             	mov    0x14(%ebp),%edx
  10438b:	09 d0                	or     %edx,%eax
  10438d:	83 c8 01             	or     $0x1,%eax
  104390:	89 c2                	mov    %eax,%edx
  104392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104395:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104397:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10439b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1043a2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1043a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1043ad:	75 8f                	jne    10433e <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1043af:	c9                   	leave  
  1043b0:	c3                   	ret    

001043b1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1043b1:	55                   	push   %ebp
  1043b2:	89 e5                	mov    %esp,%ebp
  1043b4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1043b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1043be:	e8 22 fa ff ff       	call   103de5 <alloc_pages>
  1043c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1043c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1043ca:	75 1c                	jne    1043e8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1043cc:	c7 44 24 08 6b 6c 10 	movl   $0x106c6b,0x8(%esp)
  1043d3:	00 
  1043d4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1043db:	00 
  1043dc:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1043e3:	e8 e9 c8 ff ff       	call   100cd1 <__panic>
    }
    return page2kva(p);
  1043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043eb:	89 04 24             	mov    %eax,(%esp)
  1043ee:	e8 5b f7 ff ff       	call   103b4e <page2kva>
}
  1043f3:	c9                   	leave  
  1043f4:	c3                   	ret    

001043f5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1043f5:	55                   	push   %ebp
  1043f6:	89 e5                	mov    %esp,%ebp
  1043f8:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1043fb:	e8 93 f9 ff ff       	call   103d93 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104400:	e8 75 fa ff ff       	call   103e7a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104405:	e8 7b 04 00 00       	call   104885 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10440a:	e8 a2 ff ff ff       	call   1043b1 <boot_alloc_page>
  10440f:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104414:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104419:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104420:	00 
  104421:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104428:	00 
  104429:	89 04 24             	mov    %eax,(%esp)
  10442c:	e8 bd 1a 00 00       	call   105eee <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104431:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104439:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104440:	77 23                	ja     104465 <pmm_init+0x70>
  104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104445:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104449:	c7 44 24 08 00 6c 10 	movl   $0x106c00,0x8(%esp)
  104450:	00 
  104451:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104458:	00 
  104459:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104460:	e8 6c c8 ff ff       	call   100cd1 <__panic>
  104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104468:	05 00 00 00 40       	add    $0x40000000,%eax
  10446d:	a3 c0 89 11 00       	mov    %eax,0x1189c0

    check_pgdir();
  104472:	e8 2c 04 00 00       	call   1048a3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104477:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10447c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104482:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104487:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10448a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104491:	77 23                	ja     1044b6 <pmm_init+0xc1>
  104493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104496:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10449a:	c7 44 24 08 00 6c 10 	movl   $0x106c00,0x8(%esp)
  1044a1:	00 
  1044a2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1044a9:	00 
  1044aa:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1044b1:	e8 1b c8 ff ff       	call   100cd1 <__panic>
  1044b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044b9:	05 00 00 00 40       	add    $0x40000000,%eax
  1044be:	83 c8 03             	or     $0x3,%eax
  1044c1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1044c3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044c8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1044cf:	00 
  1044d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1044d7:	00 
  1044d8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1044df:	38 
  1044e0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1044e7:	c0 
  1044e8:	89 04 24             	mov    %eax,(%esp)
  1044eb:	e8 b4 fd ff ff       	call   1042a4 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1044f0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044f5:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1044fb:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104501:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104503:	e8 63 fd ff ff       	call   10426b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104508:	e8 97 f7 ff ff       	call   103ca4 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10450d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104518:	e8 21 0a 00 00       	call   104f3e <check_boot_pgdir>

    print_pgdir();
  10451d:	e8 ae 0e 00 00       	call   1053d0 <print_pgdir>

}
  104522:	c9                   	leave  
  104523:	c3                   	ret    

00104524 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104524:	55                   	push   %ebp
  104525:	89 e5                	mov    %esp,%ebp
  104527:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
  10452a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10452d:	c1 e8 16             	shr    $0x16,%eax
  104530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104537:	8b 45 08             	mov    0x8(%ebp),%eax
  10453a:	01 d0                	add    %edx,%eax
  10453c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P)){
  10453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104542:	8b 00                	mov    (%eax),%eax
  104544:	83 e0 01             	and    $0x1,%eax
  104547:	85 c0                	test   %eax,%eax
  104549:	0f 85 b9 00 00 00    	jne    104608 <get_pte+0xe4>
		if (!create){
  10454f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104553:	75 0a                	jne    10455f <get_pte+0x3b>
			return NULL;
  104555:	b8 00 00 00 00       	mov    $0x0,%eax
  10455a:	e9 0b 01 00 00       	jmp    10466a <get_pte+0x146>
		}
		struct Page* p = alloc_page();
  10455f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104566:	e8 7a f8 ff ff       	call   103de5 <alloc_pages>
  10456b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (p==NULL){
  10456e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104572:	75 0a                	jne    10457e <get_pte+0x5a>
			return NULL;
  104574:	b8 00 00 00 00       	mov    $0x0,%eax
  104579:	e9 ec 00 00 00       	jmp    10466a <get_pte+0x146>
		}
		set_page_ref(p,1);
  10457e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104585:	00 
  104586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104589:	89 04 24             	mov    %eax,(%esp)
  10458c:	e8 59 f6 ff ff       	call   103bea <set_page_ref>
		uintptr_t ad = page2pa(p);
  104591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104594:	89 04 24             	mov    %eax,(%esp)
  104597:	e8 4d f5 ff ff       	call   103ae9 <page2pa>
  10459c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(ad),0,PGSIZE);
  10459f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1045a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045a8:	c1 e8 0c             	shr    $0xc,%eax
  1045ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045ae:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1045b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1045b6:	72 23                	jb     1045db <get_pte+0xb7>
  1045b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045bf:	c7 44 24 08 5c 6b 10 	movl   $0x106b5c,0x8(%esp)
  1045c6:	00 
  1045c7:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  1045ce:	00 
  1045cf:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1045d6:	e8 f6 c6 ff ff       	call   100cd1 <__panic>
  1045db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045de:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1045ea:	00 
  1045eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045f2:	00 
  1045f3:	89 04 24             	mov    %eax,(%esp)
  1045f6:	e8 f3 18 00 00       	call   105eee <memset>
		*pdep = ad|PTE_U|PTE_W|PTE_P;//have problem
  1045fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045fe:	83 c8 07             	or     $0x7,%eax
  104601:	89 c2                	mov    %eax,%edx
  104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104606:	89 10                	mov    %edx,(%eax)
	}
	uintptr_t d = PDE_ADDR(*pdep);
  104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10460b:	8b 00                	mov    (%eax),%eax
  10460d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104612:	89 45 e0             	mov    %eax,-0x20(%ebp)
	return &((pte_t*)KADDR(d))[PTX(la)];
  104615:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104618:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10461b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10461e:	c1 e8 0c             	shr    $0xc,%eax
  104621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104624:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104629:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10462c:	72 23                	jb     104651 <get_pte+0x12d>
  10462e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104631:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104635:	c7 44 24 08 5c 6b 10 	movl   $0x106b5c,0x8(%esp)
  10463c:	00 
  10463d:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
  104644:	00 
  104645:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10464c:	e8 80 c6 ff ff       	call   100cd1 <__panic>
  104651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104654:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104659:	8b 55 0c             	mov    0xc(%ebp),%edx
  10465c:	c1 ea 0c             	shr    $0xc,%edx
  10465f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104665:	c1 e2 02             	shl    $0x2,%edx
  104668:	01 d0                	add    %edx,%eax
}
  10466a:	c9                   	leave  
  10466b:	c3                   	ret    

0010466c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10466c:	55                   	push   %ebp
  10466d:	89 e5                	mov    %esp,%ebp
  10466f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104672:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104679:	00 
  10467a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10467d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104681:	8b 45 08             	mov    0x8(%ebp),%eax
  104684:	89 04 24             	mov    %eax,(%esp)
  104687:	e8 98 fe ff ff       	call   104524 <get_pte>
  10468c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10468f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104693:	74 08                	je     10469d <get_page+0x31>
        *ptep_store = ptep;
  104695:	8b 45 10             	mov    0x10(%ebp),%eax
  104698:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10469b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10469d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046a1:	74 1b                	je     1046be <get_page+0x52>
  1046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a6:	8b 00                	mov    (%eax),%eax
  1046a8:	83 e0 01             	and    $0x1,%eax
  1046ab:	85 c0                	test   %eax,%eax
  1046ad:	74 0f                	je     1046be <get_page+0x52>
        return pa2page(*ptep);
  1046af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b2:	8b 00                	mov    (%eax),%eax
  1046b4:	89 04 24             	mov    %eax,(%esp)
  1046b7:	e8 43 f4 ff ff       	call   103aff <pa2page>
  1046bc:	eb 05                	jmp    1046c3 <get_page+0x57>
    }
    return NULL;
  1046be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1046c3:	c9                   	leave  
  1046c4:	c3                   	ret    

001046c5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1046c5:	55                   	push   %ebp
  1046c6:	89 e5                	mov    %esp,%ebp
  1046c8:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if (*ptep & PTE_P) {
  1046cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ce:	8b 00                	mov    (%eax),%eax
  1046d0:	83 e0 01             	and    $0x1,%eax
  1046d3:	85 c0                	test   %eax,%eax
  1046d5:	74 52                	je     104729 <page_remove_pte+0x64>
		struct Page* p = pte2page(*ptep);
  1046d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1046da:	8b 00                	mov    (%eax),%eax
  1046dc:	89 04 24             	mov    %eax,(%esp)
  1046df:	e8 be f4 ff ff       	call   103ba2 <pte2page>
  1046e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		page_ref_dec(p);
  1046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ea:	89 04 24             	mov    %eax,(%esp)
  1046ed:	e8 1c f5 ff ff       	call   103c0e <page_ref_dec>
		if (p->ref==0){
  1046f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f5:	8b 00                	mov    (%eax),%eax
  1046f7:	85 c0                	test   %eax,%eax
  1046f9:	75 13                	jne    10470e <page_remove_pte+0x49>
			free_page(p);
  1046fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104702:	00 
  104703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104706:	89 04 24             	mov    %eax,(%esp)
  104709:	e8 0f f7 ff ff       	call   103e1d <free_pages>
		}
		*ptep = 0;
  10470e:	8b 45 10             	mov    0x10(%ebp),%eax
  104711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
  104717:	8b 45 0c             	mov    0xc(%ebp),%eax
  10471a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10471e:	8b 45 08             	mov    0x8(%ebp),%eax
  104721:	89 04 24             	mov    %eax,(%esp)
  104724:	e8 ff 00 00 00       	call   104828 <tlb_invalidate>
	}
}
  104729:	c9                   	leave  
  10472a:	c3                   	ret    

0010472b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10472b:	55                   	push   %ebp
  10472c:	89 e5                	mov    %esp,%ebp
  10472e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104731:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104738:	00 
  104739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10473c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104740:	8b 45 08             	mov    0x8(%ebp),%eax
  104743:	89 04 24             	mov    %eax,(%esp)
  104746:	e8 d9 fd ff ff       	call   104524 <get_pte>
  10474b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10474e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104752:	74 19                	je     10476d <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104757:	89 44 24 08          	mov    %eax,0x8(%esp)
  10475b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10475e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104762:	8b 45 08             	mov    0x8(%ebp),%eax
  104765:	89 04 24             	mov    %eax,(%esp)
  104768:	e8 58 ff ff ff       	call   1046c5 <page_remove_pte>
    }
}
  10476d:	c9                   	leave  
  10476e:	c3                   	ret    

0010476f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10476f:	55                   	push   %ebp
  104770:	89 e5                	mov    %esp,%ebp
  104772:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104775:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10477c:	00 
  10477d:	8b 45 10             	mov    0x10(%ebp),%eax
  104780:	89 44 24 04          	mov    %eax,0x4(%esp)
  104784:	8b 45 08             	mov    0x8(%ebp),%eax
  104787:	89 04 24             	mov    %eax,(%esp)
  10478a:	e8 95 fd ff ff       	call   104524 <get_pte>
  10478f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104796:	75 0a                	jne    1047a2 <page_insert+0x33>
        return -E_NO_MEM;
  104798:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10479d:	e9 84 00 00 00       	jmp    104826 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a5:	89 04 24             	mov    %eax,(%esp)
  1047a8:	e8 4a f4 ff ff       	call   103bf7 <page_ref_inc>
    if (*ptep & PTE_P) {
  1047ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b0:	8b 00                	mov    (%eax),%eax
  1047b2:	83 e0 01             	and    $0x1,%eax
  1047b5:	85 c0                	test   %eax,%eax
  1047b7:	74 3e                	je     1047f7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bc:	8b 00                	mov    (%eax),%eax
  1047be:	89 04 24             	mov    %eax,(%esp)
  1047c1:	e8 dc f3 ff ff       	call   103ba2 <pte2page>
  1047c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1047c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1047cf:	75 0d                	jne    1047de <page_insert+0x6f>
            page_ref_dec(page);
  1047d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d4:	89 04 24             	mov    %eax,(%esp)
  1047d7:	e8 32 f4 ff ff       	call   103c0e <page_ref_dec>
  1047dc:	eb 19                	jmp    1047f7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1047e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ef:	89 04 24             	mov    %eax,(%esp)
  1047f2:	e8 ce fe ff ff       	call   1046c5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1047f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047fa:	89 04 24             	mov    %eax,(%esp)
  1047fd:	e8 e7 f2 ff ff       	call   103ae9 <page2pa>
  104802:	0b 45 14             	or     0x14(%ebp),%eax
  104805:	83 c8 01             	or     $0x1,%eax
  104808:	89 c2                	mov    %eax,%edx
  10480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10480d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10480f:	8b 45 10             	mov    0x10(%ebp),%eax
  104812:	89 44 24 04          	mov    %eax,0x4(%esp)
  104816:	8b 45 08             	mov    0x8(%ebp),%eax
  104819:	89 04 24             	mov    %eax,(%esp)
  10481c:	e8 07 00 00 00       	call   104828 <tlb_invalidate>
    return 0;
  104821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104826:	c9                   	leave  
  104827:	c3                   	ret    

00104828 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104828:	55                   	push   %ebp
  104829:	89 e5                	mov    %esp,%ebp
  10482b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10482e:	0f 20 d8             	mov    %cr3,%eax
  104831:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104834:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104837:	89 c2                	mov    %eax,%edx
  104839:	8b 45 08             	mov    0x8(%ebp),%eax
  10483c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10483f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104846:	77 23                	ja     10486b <tlb_invalidate+0x43>
  104848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10484b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10484f:	c7 44 24 08 00 6c 10 	movl   $0x106c00,0x8(%esp)
  104856:	00 
  104857:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  10485e:	00 
  10485f:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104866:	e8 66 c4 ff ff       	call   100cd1 <__panic>
  10486b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486e:	05 00 00 00 40       	add    $0x40000000,%eax
  104873:	39 c2                	cmp    %eax,%edx
  104875:	75 0c                	jne    104883 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10487a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10487d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104880:	0f 01 38             	invlpg (%eax)
    }
}
  104883:	c9                   	leave  
  104884:	c3                   	ret    

00104885 <check_alloc_page>:

static void
check_alloc_page(void) {
  104885:	55                   	push   %ebp
  104886:	89 e5                	mov    %esp,%ebp
  104888:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10488b:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104890:	8b 40 18             	mov    0x18(%eax),%eax
  104893:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104895:	c7 04 24 84 6c 10 00 	movl   $0x106c84,(%esp)
  10489c:	e8 a6 ba ff ff       	call   100347 <cprintf>
}
  1048a1:	c9                   	leave  
  1048a2:	c3                   	ret    

001048a3 <check_pgdir>:

static void
check_pgdir(void) {
  1048a3:	55                   	push   %ebp
  1048a4:	89 e5                	mov    %esp,%ebp
  1048a6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1048a9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048ae:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1048b3:	76 24                	jbe    1048d9 <check_pgdir+0x36>
  1048b5:	c7 44 24 0c a3 6c 10 	movl   $0x106ca3,0xc(%esp)
  1048bc:	00 
  1048bd:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1048c4:	00 
  1048c5:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1048cc:	00 
  1048cd:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1048d4:	e8 f8 c3 ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1048d9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048de:	85 c0                	test   %eax,%eax
  1048e0:	74 0e                	je     1048f0 <check_pgdir+0x4d>
  1048e2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048e7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1048ec:	85 c0                	test   %eax,%eax
  1048ee:	74 24                	je     104914 <check_pgdir+0x71>
  1048f0:	c7 44 24 0c c0 6c 10 	movl   $0x106cc0,0xc(%esp)
  1048f7:	00 
  1048f8:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1048ff:	00 
  104900:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104907:	00 
  104908:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10490f:	e8 bd c3 ff ff       	call   100cd1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104914:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104919:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104920:	00 
  104921:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104928:	00 
  104929:	89 04 24             	mov    %eax,(%esp)
  10492c:	e8 3b fd ff ff       	call   10466c <get_page>
  104931:	85 c0                	test   %eax,%eax
  104933:	74 24                	je     104959 <check_pgdir+0xb6>
  104935:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  10493c:	00 
  10493d:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104944:	00 
  104945:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10494c:	00 
  10494d:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104954:	e8 78 c3 ff ff       	call   100cd1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104959:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104960:	e8 80 f4 ff ff       	call   103de5 <alloc_pages>
  104965:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104968:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10496d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104974:	00 
  104975:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10497c:	00 
  10497d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104980:	89 54 24 04          	mov    %edx,0x4(%esp)
  104984:	89 04 24             	mov    %eax,(%esp)
  104987:	e8 e3 fd ff ff       	call   10476f <page_insert>
  10498c:	85 c0                	test   %eax,%eax
  10498e:	74 24                	je     1049b4 <check_pgdir+0x111>
  104990:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104997:	00 
  104998:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  10499f:	00 
  1049a0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1049a7:	00 
  1049a8:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1049af:	e8 1d c3 ff ff       	call   100cd1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1049b4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049c0:	00 
  1049c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049c8:	00 
  1049c9:	89 04 24             	mov    %eax,(%esp)
  1049cc:	e8 53 fb ff ff       	call   104524 <get_pte>
  1049d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049d8:	75 24                	jne    1049fe <check_pgdir+0x15b>
  1049da:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  1049e1:	00 
  1049e2:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1049e9:	00 
  1049ea:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1049f1:	00 
  1049f2:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1049f9:	e8 d3 c2 ff ff       	call   100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
  1049fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a01:	8b 00                	mov    (%eax),%eax
  104a03:	89 04 24             	mov    %eax,(%esp)
  104a06:	e8 f4 f0 ff ff       	call   103aff <pa2page>
  104a0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a0e:	74 24                	je     104a34 <check_pgdir+0x191>
  104a10:	c7 44 24 0c 79 6d 10 	movl   $0x106d79,0xc(%esp)
  104a17:	00 
  104a18:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104a1f:	00 
  104a20:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104a27:	00 
  104a28:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104a2f:	e8 9d c2 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 1);
  104a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a37:	89 04 24             	mov    %eax,(%esp)
  104a3a:	e8 a1 f1 ff ff       	call   103be0 <page_ref>
  104a3f:	83 f8 01             	cmp    $0x1,%eax
  104a42:	74 24                	je     104a68 <check_pgdir+0x1c5>
  104a44:	c7 44 24 0c 8e 6d 10 	movl   $0x106d8e,0xc(%esp)
  104a4b:	00 
  104a4c:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104a53:	00 
  104a54:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104a5b:	00 
  104a5c:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104a63:	e8 69 c2 ff ff       	call   100cd1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104a68:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a6d:	8b 00                	mov    (%eax),%eax
  104a6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a7a:	c1 e8 0c             	shr    $0xc,%eax
  104a7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a80:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104a85:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a88:	72 23                	jb     104aad <check_pgdir+0x20a>
  104a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a91:	c7 44 24 08 5c 6b 10 	movl   $0x106b5c,0x8(%esp)
  104a98:	00 
  104a99:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104aa0:	00 
  104aa1:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104aa8:	e8 24 c2 ff ff       	call   100cd1 <__panic>
  104aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ab0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ab5:	83 c0 04             	add    $0x4,%eax
  104ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104abb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ac0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ac7:	00 
  104ac8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104acf:	00 
  104ad0:	89 04 24             	mov    %eax,(%esp)
  104ad3:	e8 4c fa ff ff       	call   104524 <get_pte>
  104ad8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104adb:	74 24                	je     104b01 <check_pgdir+0x25e>
  104add:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104ae4:	00 
  104ae5:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104aec:	00 
  104aed:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104af4:	00 
  104af5:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104afc:	e8 d0 c1 ff ff       	call   100cd1 <__panic>

    p2 = alloc_page();
  104b01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b08:	e8 d8 f2 ff ff       	call   103de5 <alloc_pages>
  104b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104b10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b15:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b24:	00 
  104b25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b28:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b2c:	89 04 24             	mov    %eax,(%esp)
  104b2f:	e8 3b fc ff ff       	call   10476f <page_insert>
  104b34:	85 c0                	test   %eax,%eax
  104b36:	74 24                	je     104b5c <check_pgdir+0x2b9>
  104b38:	c7 44 24 0c c8 6d 10 	movl   $0x106dc8,0xc(%esp)
  104b3f:	00 
  104b40:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104b47:	00 
  104b48:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104b4f:	00 
  104b50:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104b57:	e8 75 c1 ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b5c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b68:	00 
  104b69:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b70:	00 
  104b71:	89 04 24             	mov    %eax,(%esp)
  104b74:	e8 ab f9 ff ff       	call   104524 <get_pte>
  104b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b80:	75 24                	jne    104ba6 <check_pgdir+0x303>
  104b82:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104b89:	00 
  104b8a:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104b91:	00 
  104b92:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104b99:	00 
  104b9a:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104ba1:	e8 2b c1 ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_U);
  104ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ba9:	8b 00                	mov    (%eax),%eax
  104bab:	83 e0 04             	and    $0x4,%eax
  104bae:	85 c0                	test   %eax,%eax
  104bb0:	75 24                	jne    104bd6 <check_pgdir+0x333>
  104bb2:	c7 44 24 0c 30 6e 10 	movl   $0x106e30,0xc(%esp)
  104bb9:	00 
  104bba:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104bc1:	00 
  104bc2:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104bc9:	00 
  104bca:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104bd1:	e8 fb c0 ff ff       	call   100cd1 <__panic>
    assert(*ptep & PTE_W);
  104bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bd9:	8b 00                	mov    (%eax),%eax
  104bdb:	83 e0 02             	and    $0x2,%eax
  104bde:	85 c0                	test   %eax,%eax
  104be0:	75 24                	jne    104c06 <check_pgdir+0x363>
  104be2:	c7 44 24 0c 3e 6e 10 	movl   $0x106e3e,0xc(%esp)
  104be9:	00 
  104bea:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104bf1:	00 
  104bf2:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104bf9:	00 
  104bfa:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104c01:	e8 cb c0 ff ff       	call   100cd1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104c06:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c0b:	8b 00                	mov    (%eax),%eax
  104c0d:	83 e0 04             	and    $0x4,%eax
  104c10:	85 c0                	test   %eax,%eax
  104c12:	75 24                	jne    104c38 <check_pgdir+0x395>
  104c14:	c7 44 24 0c 4c 6e 10 	movl   $0x106e4c,0xc(%esp)
  104c1b:	00 
  104c1c:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104c23:	00 
  104c24:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104c2b:	00 
  104c2c:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104c33:	e8 99 c0 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 1);
  104c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c3b:	89 04 24             	mov    %eax,(%esp)
  104c3e:	e8 9d ef ff ff       	call   103be0 <page_ref>
  104c43:	83 f8 01             	cmp    $0x1,%eax
  104c46:	74 24                	je     104c6c <check_pgdir+0x3c9>
  104c48:	c7 44 24 0c 62 6e 10 	movl   $0x106e62,0xc(%esp)
  104c4f:	00 
  104c50:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104c57:	00 
  104c58:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104c5f:	00 
  104c60:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104c67:	e8 65 c0 ff ff       	call   100cd1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104c6c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104c78:	00 
  104c79:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c80:	00 
  104c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c84:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c88:	89 04 24             	mov    %eax,(%esp)
  104c8b:	e8 df fa ff ff       	call   10476f <page_insert>
  104c90:	85 c0                	test   %eax,%eax
  104c92:	74 24                	je     104cb8 <check_pgdir+0x415>
  104c94:	c7 44 24 0c 74 6e 10 	movl   $0x106e74,0xc(%esp)
  104c9b:	00 
  104c9c:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104ca3:	00 
  104ca4:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104cab:	00 
  104cac:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104cb3:	e8 19 c0 ff ff       	call   100cd1 <__panic>
    assert(page_ref(p1) == 2);
  104cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cbb:	89 04 24             	mov    %eax,(%esp)
  104cbe:	e8 1d ef ff ff       	call   103be0 <page_ref>
  104cc3:	83 f8 02             	cmp    $0x2,%eax
  104cc6:	74 24                	je     104cec <check_pgdir+0x449>
  104cc8:	c7 44 24 0c a0 6e 10 	movl   $0x106ea0,0xc(%esp)
  104ccf:	00 
  104cd0:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104cd7:	00 
  104cd8:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104cdf:	00 
  104ce0:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104ce7:	e8 e5 bf ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  104cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cef:	89 04 24             	mov    %eax,(%esp)
  104cf2:	e8 e9 ee ff ff       	call   103be0 <page_ref>
  104cf7:	85 c0                	test   %eax,%eax
  104cf9:	74 24                	je     104d1f <check_pgdir+0x47c>
  104cfb:	c7 44 24 0c b2 6e 10 	movl   $0x106eb2,0xc(%esp)
  104d02:	00 
  104d03:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104d0a:	00 
  104d0b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d12:	00 
  104d13:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104d1a:	e8 b2 bf ff ff       	call   100cd1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104d1f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d33:	00 
  104d34:	89 04 24             	mov    %eax,(%esp)
  104d37:	e8 e8 f7 ff ff       	call   104524 <get_pte>
  104d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d43:	75 24                	jne    104d69 <check_pgdir+0x4c6>
  104d45:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104d4c:	00 
  104d4d:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104d54:	00 
  104d55:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d5c:	00 
  104d5d:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104d64:	e8 68 bf ff ff       	call   100cd1 <__panic>
    assert(pa2page(*ptep) == p1);
  104d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d6c:	8b 00                	mov    (%eax),%eax
  104d6e:	89 04 24             	mov    %eax,(%esp)
  104d71:	e8 89 ed ff ff       	call   103aff <pa2page>
  104d76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d79:	74 24                	je     104d9f <check_pgdir+0x4fc>
  104d7b:	c7 44 24 0c 79 6d 10 	movl   $0x106d79,0xc(%esp)
  104d82:	00 
  104d83:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104d8a:	00 
  104d8b:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104d92:	00 
  104d93:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104d9a:	e8 32 bf ff ff       	call   100cd1 <__panic>
    assert((*ptep & PTE_U) == 0);
  104d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104da2:	8b 00                	mov    (%eax),%eax
  104da4:	83 e0 04             	and    $0x4,%eax
  104da7:	85 c0                	test   %eax,%eax
  104da9:	74 24                	je     104dcf <check_pgdir+0x52c>
  104dab:	c7 44 24 0c c4 6e 10 	movl   $0x106ec4,0xc(%esp)
  104db2:	00 
  104db3:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104dba:	00 
  104dbb:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104dc2:	00 
  104dc3:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104dca:	e8 02 bf ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, 0x0);
  104dcf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dd4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ddb:	00 
  104ddc:	89 04 24             	mov    %eax,(%esp)
  104ddf:	e8 47 f9 ff ff       	call   10472b <page_remove>
    assert(page_ref(p1) == 1);
  104de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104de7:	89 04 24             	mov    %eax,(%esp)
  104dea:	e8 f1 ed ff ff       	call   103be0 <page_ref>
  104def:	83 f8 01             	cmp    $0x1,%eax
  104df2:	74 24                	je     104e18 <check_pgdir+0x575>
  104df4:	c7 44 24 0c 8e 6d 10 	movl   $0x106d8e,0xc(%esp)
  104dfb:	00 
  104dfc:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104e03:	00 
  104e04:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104e0b:	00 
  104e0c:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104e13:	e8 b9 be ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  104e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e1b:	89 04 24             	mov    %eax,(%esp)
  104e1e:	e8 bd ed ff ff       	call   103be0 <page_ref>
  104e23:	85 c0                	test   %eax,%eax
  104e25:	74 24                	je     104e4b <check_pgdir+0x5a8>
  104e27:	c7 44 24 0c b2 6e 10 	movl   $0x106eb2,0xc(%esp)
  104e2e:	00 
  104e2f:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104e36:	00 
  104e37:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104e3e:	00 
  104e3f:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104e46:	e8 86 be ff ff       	call   100cd1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104e4b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e50:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e57:	00 
  104e58:	89 04 24             	mov    %eax,(%esp)
  104e5b:	e8 cb f8 ff ff       	call   10472b <page_remove>
    assert(page_ref(p1) == 0);
  104e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e63:	89 04 24             	mov    %eax,(%esp)
  104e66:	e8 75 ed ff ff       	call   103be0 <page_ref>
  104e6b:	85 c0                	test   %eax,%eax
  104e6d:	74 24                	je     104e93 <check_pgdir+0x5f0>
  104e6f:	c7 44 24 0c d9 6e 10 	movl   $0x106ed9,0xc(%esp)
  104e76:	00 
  104e77:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104e7e:	00 
  104e7f:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104e86:	00 
  104e87:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104e8e:	e8 3e be ff ff       	call   100cd1 <__panic>
    assert(page_ref(p2) == 0);
  104e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e96:	89 04 24             	mov    %eax,(%esp)
  104e99:	e8 42 ed ff ff       	call   103be0 <page_ref>
  104e9e:	85 c0                	test   %eax,%eax
  104ea0:	74 24                	je     104ec6 <check_pgdir+0x623>
  104ea2:	c7 44 24 0c b2 6e 10 	movl   $0x106eb2,0xc(%esp)
  104ea9:	00 
  104eaa:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104eb1:	00 
  104eb2:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104eb9:	00 
  104eba:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104ec1:	e8 0b be ff ff       	call   100cd1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104ec6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ecb:	8b 00                	mov    (%eax),%eax
  104ecd:	89 04 24             	mov    %eax,(%esp)
  104ed0:	e8 2a ec ff ff       	call   103aff <pa2page>
  104ed5:	89 04 24             	mov    %eax,(%esp)
  104ed8:	e8 03 ed ff ff       	call   103be0 <page_ref>
  104edd:	83 f8 01             	cmp    $0x1,%eax
  104ee0:	74 24                	je     104f06 <check_pgdir+0x663>
  104ee2:	c7 44 24 0c ec 6e 10 	movl   $0x106eec,0xc(%esp)
  104ee9:	00 
  104eea:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104ef1:	00 
  104ef2:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104ef9:	00 
  104efa:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104f01:	e8 cb bd ff ff       	call   100cd1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104f06:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f0b:	8b 00                	mov    (%eax),%eax
  104f0d:	89 04 24             	mov    %eax,(%esp)
  104f10:	e8 ea eb ff ff       	call   103aff <pa2page>
  104f15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f1c:	00 
  104f1d:	89 04 24             	mov    %eax,(%esp)
  104f20:	e8 f8 ee ff ff       	call   103e1d <free_pages>
    boot_pgdir[0] = 0;
  104f25:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104f30:	c7 04 24 12 6f 10 00 	movl   $0x106f12,(%esp)
  104f37:	e8 0b b4 ff ff       	call   100347 <cprintf>
}
  104f3c:	c9                   	leave  
  104f3d:	c3                   	ret    

00104f3e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104f3e:	55                   	push   %ebp
  104f3f:	89 e5                	mov    %esp,%ebp
  104f41:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f4b:	e9 ca 00 00 00       	jmp    10501a <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f59:	c1 e8 0c             	shr    $0xc,%eax
  104f5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f5f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f64:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104f67:	72 23                	jb     104f8c <check_boot_pgdir+0x4e>
  104f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f70:	c7 44 24 08 5c 6b 10 	movl   $0x106b5c,0x8(%esp)
  104f77:	00 
  104f78:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104f7f:	00 
  104f80:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104f87:	e8 45 bd ff ff       	call   100cd1 <__panic>
  104f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f8f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f94:	89 c2                	mov    %eax,%edx
  104f96:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104fa2:	00 
  104fa3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fa7:	89 04 24             	mov    %eax,(%esp)
  104faa:	e8 75 f5 ff ff       	call   104524 <get_pte>
  104faf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104fb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104fb6:	75 24                	jne    104fdc <check_boot_pgdir+0x9e>
  104fb8:	c7 44 24 0c 2c 6f 10 	movl   $0x106f2c,0xc(%esp)
  104fbf:	00 
  104fc0:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104fc7:	00 
  104fc8:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104fcf:	00 
  104fd0:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  104fd7:	e8 f5 bc ff ff       	call   100cd1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fdf:	8b 00                	mov    (%eax),%eax
  104fe1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104fe6:	89 c2                	mov    %eax,%edx
  104fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104feb:	39 c2                	cmp    %eax,%edx
  104fed:	74 24                	je     105013 <check_boot_pgdir+0xd5>
  104fef:	c7 44 24 0c 69 6f 10 	movl   $0x106f69,0xc(%esp)
  104ff6:	00 
  104ff7:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  104ffe:	00 
  104fff:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  105006:	00 
  105007:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10500e:	e8 be bc ff ff       	call   100cd1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105013:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10501a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10501d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  105022:	39 c2                	cmp    %eax,%edx
  105024:	0f 82 26 ff ff ff    	jb     104f50 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10502a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10502f:	05 ac 0f 00 00       	add    $0xfac,%eax
  105034:	8b 00                	mov    (%eax),%eax
  105036:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10503b:	89 c2                	mov    %eax,%edx
  10503d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105042:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105045:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  10504c:	77 23                	ja     105071 <check_boot_pgdir+0x133>
  10504e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105051:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105055:	c7 44 24 08 00 6c 10 	movl   $0x106c00,0x8(%esp)
  10505c:	00 
  10505d:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105064:	00 
  105065:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10506c:	e8 60 bc ff ff       	call   100cd1 <__panic>
  105071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105074:	05 00 00 00 40       	add    $0x40000000,%eax
  105079:	39 c2                	cmp    %eax,%edx
  10507b:	74 24                	je     1050a1 <check_boot_pgdir+0x163>
  10507d:	c7 44 24 0c 80 6f 10 	movl   $0x106f80,0xc(%esp)
  105084:	00 
  105085:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  10508c:	00 
  10508d:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105094:	00 
  105095:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10509c:	e8 30 bc ff ff       	call   100cd1 <__panic>

    assert(boot_pgdir[0] == 0);
  1050a1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050a6:	8b 00                	mov    (%eax),%eax
  1050a8:	85 c0                	test   %eax,%eax
  1050aa:	74 24                	je     1050d0 <check_boot_pgdir+0x192>
  1050ac:	c7 44 24 0c b4 6f 10 	movl   $0x106fb4,0xc(%esp)
  1050b3:	00 
  1050b4:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1050bb:	00 
  1050bc:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1050c3:	00 
  1050c4:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1050cb:	e8 01 bc ff ff       	call   100cd1 <__panic>

    struct Page *p;
    p = alloc_page();
  1050d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050d7:	e8 09 ed ff ff       	call   103de5 <alloc_pages>
  1050dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1050df:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050e4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050eb:	00 
  1050ec:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1050f3:	00 
  1050f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1050f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050fb:	89 04 24             	mov    %eax,(%esp)
  1050fe:	e8 6c f6 ff ff       	call   10476f <page_insert>
  105103:	85 c0                	test   %eax,%eax
  105105:	74 24                	je     10512b <check_boot_pgdir+0x1ed>
  105107:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  10510e:	00 
  10510f:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  105116:	00 
  105117:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  10511e:	00 
  10511f:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  105126:	e8 a6 bb ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 1);
  10512b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10512e:	89 04 24             	mov    %eax,(%esp)
  105131:	e8 aa ea ff ff       	call   103be0 <page_ref>
  105136:	83 f8 01             	cmp    $0x1,%eax
  105139:	74 24                	je     10515f <check_boot_pgdir+0x221>
  10513b:	c7 44 24 0c f6 6f 10 	movl   $0x106ff6,0xc(%esp)
  105142:	00 
  105143:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  10514a:	00 
  10514b:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105152:	00 
  105153:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  10515a:	e8 72 bb ff ff       	call   100cd1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10515f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105164:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10516b:	00 
  10516c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105173:	00 
  105174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105177:	89 54 24 04          	mov    %edx,0x4(%esp)
  10517b:	89 04 24             	mov    %eax,(%esp)
  10517e:	e8 ec f5 ff ff       	call   10476f <page_insert>
  105183:	85 c0                	test   %eax,%eax
  105185:	74 24                	je     1051ab <check_boot_pgdir+0x26d>
  105187:	c7 44 24 0c 08 70 10 	movl   $0x107008,0xc(%esp)
  10518e:	00 
  10518f:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  105196:	00 
  105197:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  10519e:	00 
  10519f:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1051a6:	e8 26 bb ff ff       	call   100cd1 <__panic>
    assert(page_ref(p) == 2);
  1051ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051ae:	89 04 24             	mov    %eax,(%esp)
  1051b1:	e8 2a ea ff ff       	call   103be0 <page_ref>
  1051b6:	83 f8 02             	cmp    $0x2,%eax
  1051b9:	74 24                	je     1051df <check_boot_pgdir+0x2a1>
  1051bb:	c7 44 24 0c 3f 70 10 	movl   $0x10703f,0xc(%esp)
  1051c2:	00 
  1051c3:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  1051ca:	00 
  1051cb:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1051d2:	00 
  1051d3:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  1051da:	e8 f2 ba ff ff       	call   100cd1 <__panic>

    const char *str = "ucore: Hello world!!";
  1051df:	c7 45 dc 50 70 10 00 	movl   $0x107050,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1051e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051ed:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051f4:	e8 1e 0a 00 00       	call   105c17 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1051f9:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105200:	00 
  105201:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105208:	e8 83 0a 00 00       	call   105c90 <strcmp>
  10520d:	85 c0                	test   %eax,%eax
  10520f:	74 24                	je     105235 <check_boot_pgdir+0x2f7>
  105211:	c7 44 24 0c 68 70 10 	movl   $0x107068,0xc(%esp)
  105218:	00 
  105219:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  105220:	00 
  105221:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  105228:	00 
  105229:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  105230:	e8 9c ba ff ff       	call   100cd1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105238:	89 04 24             	mov    %eax,(%esp)
  10523b:	e8 0e e9 ff ff       	call   103b4e <page2kva>
  105240:	05 00 01 00 00       	add    $0x100,%eax
  105245:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105248:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10524f:	e8 6b 09 00 00       	call   105bbf <strlen>
  105254:	85 c0                	test   %eax,%eax
  105256:	74 24                	je     10527c <check_boot_pgdir+0x33e>
  105258:	c7 44 24 0c a0 70 10 	movl   $0x1070a0,0xc(%esp)
  10525f:	00 
  105260:	c7 44 24 08 49 6c 10 	movl   $0x106c49,0x8(%esp)
  105267:	00 
  105268:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  10526f:	00 
  105270:	c7 04 24 24 6c 10 00 	movl   $0x106c24,(%esp)
  105277:	e8 55 ba ff ff       	call   100cd1 <__panic>

    free_page(p);
  10527c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105283:	00 
  105284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105287:	89 04 24             	mov    %eax,(%esp)
  10528a:	e8 8e eb ff ff       	call   103e1d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10528f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105294:	8b 00                	mov    (%eax),%eax
  105296:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10529b:	89 04 24             	mov    %eax,(%esp)
  10529e:	e8 5c e8 ff ff       	call   103aff <pa2page>
  1052a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052aa:	00 
  1052ab:	89 04 24             	mov    %eax,(%esp)
  1052ae:	e8 6a eb ff ff       	call   103e1d <free_pages>
    boot_pgdir[0] = 0;
  1052b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1052b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1052be:	c7 04 24 c4 70 10 00 	movl   $0x1070c4,(%esp)
  1052c5:	e8 7d b0 ff ff       	call   100347 <cprintf>
}
  1052ca:	c9                   	leave  
  1052cb:	c3                   	ret    

001052cc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1052cc:	55                   	push   %ebp
  1052cd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1052cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1052d2:	83 e0 04             	and    $0x4,%eax
  1052d5:	85 c0                	test   %eax,%eax
  1052d7:	74 07                	je     1052e0 <perm2str+0x14>
  1052d9:	b8 75 00 00 00       	mov    $0x75,%eax
  1052de:	eb 05                	jmp    1052e5 <perm2str+0x19>
  1052e0:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1052e5:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1052ea:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1052f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f4:	83 e0 02             	and    $0x2,%eax
  1052f7:	85 c0                	test   %eax,%eax
  1052f9:	74 07                	je     105302 <perm2str+0x36>
  1052fb:	b8 77 00 00 00       	mov    $0x77,%eax
  105300:	eb 05                	jmp    105307 <perm2str+0x3b>
  105302:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105307:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10530c:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105313:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105318:	5d                   	pop    %ebp
  105319:	c3                   	ret    

0010531a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10531a:	55                   	push   %ebp
  10531b:	89 e5                	mov    %esp,%ebp
  10531d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105320:	8b 45 10             	mov    0x10(%ebp),%eax
  105323:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105326:	72 0a                	jb     105332 <get_pgtable_items+0x18>
        return 0;
  105328:	b8 00 00 00 00       	mov    $0x0,%eax
  10532d:	e9 9c 00 00 00       	jmp    1053ce <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105332:	eb 04                	jmp    105338 <get_pgtable_items+0x1e>
        start ++;
  105334:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105338:	8b 45 10             	mov    0x10(%ebp),%eax
  10533b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10533e:	73 18                	jae    105358 <get_pgtable_items+0x3e>
  105340:	8b 45 10             	mov    0x10(%ebp),%eax
  105343:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10534a:	8b 45 14             	mov    0x14(%ebp),%eax
  10534d:	01 d0                	add    %edx,%eax
  10534f:	8b 00                	mov    (%eax),%eax
  105351:	83 e0 01             	and    $0x1,%eax
  105354:	85 c0                	test   %eax,%eax
  105356:	74 dc                	je     105334 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105358:	8b 45 10             	mov    0x10(%ebp),%eax
  10535b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10535e:	73 69                	jae    1053c9 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105360:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105364:	74 08                	je     10536e <get_pgtable_items+0x54>
            *left_store = start;
  105366:	8b 45 18             	mov    0x18(%ebp),%eax
  105369:	8b 55 10             	mov    0x10(%ebp),%edx
  10536c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10536e:	8b 45 10             	mov    0x10(%ebp),%eax
  105371:	8d 50 01             	lea    0x1(%eax),%edx
  105374:	89 55 10             	mov    %edx,0x10(%ebp)
  105377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10537e:	8b 45 14             	mov    0x14(%ebp),%eax
  105381:	01 d0                	add    %edx,%eax
  105383:	8b 00                	mov    (%eax),%eax
  105385:	83 e0 07             	and    $0x7,%eax
  105388:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10538b:	eb 04                	jmp    105391 <get_pgtable_items+0x77>
            start ++;
  10538d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105391:	8b 45 10             	mov    0x10(%ebp),%eax
  105394:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105397:	73 1d                	jae    1053b6 <get_pgtable_items+0x9c>
  105399:	8b 45 10             	mov    0x10(%ebp),%eax
  10539c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1053a3:	8b 45 14             	mov    0x14(%ebp),%eax
  1053a6:	01 d0                	add    %edx,%eax
  1053a8:	8b 00                	mov    (%eax),%eax
  1053aa:	83 e0 07             	and    $0x7,%eax
  1053ad:	89 c2                	mov    %eax,%edx
  1053af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1053b2:	39 c2                	cmp    %eax,%edx
  1053b4:	74 d7                	je     10538d <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1053b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1053ba:	74 08                	je     1053c4 <get_pgtable_items+0xaa>
            *right_store = start;
  1053bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1053bf:	8b 55 10             	mov    0x10(%ebp),%edx
  1053c2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1053c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1053c7:	eb 05                	jmp    1053ce <get_pgtable_items+0xb4>
    }
    return 0;
  1053c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1053ce:	c9                   	leave  
  1053cf:	c3                   	ret    

001053d0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1053d0:	55                   	push   %ebp
  1053d1:	89 e5                	mov    %esp,%ebp
  1053d3:	57                   	push   %edi
  1053d4:	56                   	push   %esi
  1053d5:	53                   	push   %ebx
  1053d6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1053d9:	c7 04 24 e4 70 10 00 	movl   $0x1070e4,(%esp)
  1053e0:	e8 62 af ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  1053e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053ec:	e9 fa 00 00 00       	jmp    1054eb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053f4:	89 04 24             	mov    %eax,(%esp)
  1053f7:	e8 d0 fe ff ff       	call   1052cc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1053fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105402:	29 d1                	sub    %edx,%ecx
  105404:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105406:	89 d6                	mov    %edx,%esi
  105408:	c1 e6 16             	shl    $0x16,%esi
  10540b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10540e:	89 d3                	mov    %edx,%ebx
  105410:	c1 e3 16             	shl    $0x16,%ebx
  105413:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105416:	89 d1                	mov    %edx,%ecx
  105418:	c1 e1 16             	shl    $0x16,%ecx
  10541b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10541e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105421:	29 d7                	sub    %edx,%edi
  105423:	89 fa                	mov    %edi,%edx
  105425:	89 44 24 14          	mov    %eax,0x14(%esp)
  105429:	89 74 24 10          	mov    %esi,0x10(%esp)
  10542d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105431:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105435:	89 54 24 04          	mov    %edx,0x4(%esp)
  105439:	c7 04 24 15 71 10 00 	movl   $0x107115,(%esp)
  105440:	e8 02 af ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105448:	c1 e0 0a             	shl    $0xa,%eax
  10544b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10544e:	eb 54                	jmp    1054a4 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105453:	89 04 24             	mov    %eax,(%esp)
  105456:	e8 71 fe ff ff       	call   1052cc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10545b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10545e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105461:	29 d1                	sub    %edx,%ecx
  105463:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105465:	89 d6                	mov    %edx,%esi
  105467:	c1 e6 0c             	shl    $0xc,%esi
  10546a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10546d:	89 d3                	mov    %edx,%ebx
  10546f:	c1 e3 0c             	shl    $0xc,%ebx
  105472:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105475:	c1 e2 0c             	shl    $0xc,%edx
  105478:	89 d1                	mov    %edx,%ecx
  10547a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10547d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105480:	29 d7                	sub    %edx,%edi
  105482:	89 fa                	mov    %edi,%edx
  105484:	89 44 24 14          	mov    %eax,0x14(%esp)
  105488:	89 74 24 10          	mov    %esi,0x10(%esp)
  10548c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105490:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105494:	89 54 24 04          	mov    %edx,0x4(%esp)
  105498:	c7 04 24 34 71 10 00 	movl   $0x107134,(%esp)
  10549f:	e8 a3 ae ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1054a4:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1054a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1054ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1054af:	89 ce                	mov    %ecx,%esi
  1054b1:	c1 e6 0a             	shl    $0xa,%esi
  1054b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1054b7:	89 cb                	mov    %ecx,%ebx
  1054b9:	c1 e3 0a             	shl    $0xa,%ebx
  1054bc:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1054bf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1054c3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1054c6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1054ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  1054d6:	89 1c 24             	mov    %ebx,(%esp)
  1054d9:	e8 3c fe ff ff       	call   10531a <get_pgtable_items>
  1054de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054e5:	0f 85 65 ff ff ff    	jne    105450 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1054eb:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1054f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054f3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1054f6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1054fa:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1054fd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105501:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105505:	89 44 24 08          	mov    %eax,0x8(%esp)
  105509:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105510:	00 
  105511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105518:	e8 fd fd ff ff       	call   10531a <get_pgtable_items>
  10551d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105524:	0f 85 c7 fe ff ff    	jne    1053f1 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10552a:	c7 04 24 58 71 10 00 	movl   $0x107158,(%esp)
  105531:	e8 11 ae ff ff       	call   100347 <cprintf>
}
  105536:	83 c4 4c             	add    $0x4c,%esp
  105539:	5b                   	pop    %ebx
  10553a:	5e                   	pop    %esi
  10553b:	5f                   	pop    %edi
  10553c:	5d                   	pop    %ebp
  10553d:	c3                   	ret    

0010553e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10553e:	55                   	push   %ebp
  10553f:	89 e5                	mov    %esp,%ebp
  105541:	83 ec 58             	sub    $0x58,%esp
  105544:	8b 45 10             	mov    0x10(%ebp),%eax
  105547:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10554a:	8b 45 14             	mov    0x14(%ebp),%eax
  10554d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105550:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105553:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105556:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105559:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10555c:	8b 45 18             	mov    0x18(%ebp),%eax
  10555f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105565:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105568:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10556b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10556e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105574:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105578:	74 1c                	je     105596 <printnum+0x58>
  10557a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10557d:	ba 00 00 00 00       	mov    $0x0,%edx
  105582:	f7 75 e4             	divl   -0x1c(%ebp)
  105585:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10558b:	ba 00 00 00 00       	mov    $0x0,%edx
  105590:	f7 75 e4             	divl   -0x1c(%ebp)
  105593:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10559c:	f7 75 e4             	divl   -0x1c(%ebp)
  10559f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1055a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1055a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1055ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1055b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055b4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1055b7:	8b 45 18             	mov    0x18(%ebp),%eax
  1055ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1055bf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1055c2:	77 56                	ja     10561a <printnum+0xdc>
  1055c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1055c7:	72 05                	jb     1055ce <printnum+0x90>
  1055c9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1055cc:	77 4c                	ja     10561a <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1055ce:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1055d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1055d4:	8b 45 20             	mov    0x20(%ebp),%eax
  1055d7:	89 44 24 18          	mov    %eax,0x18(%esp)
  1055db:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055df:	8b 45 18             	mov    0x18(%ebp),%eax
  1055e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1055e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fe:	89 04 24             	mov    %eax,(%esp)
  105601:	e8 38 ff ff ff       	call   10553e <printnum>
  105606:	eb 1c                	jmp    105624 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105608:	8b 45 0c             	mov    0xc(%ebp),%eax
  10560b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560f:	8b 45 20             	mov    0x20(%ebp),%eax
  105612:	89 04 24             	mov    %eax,(%esp)
  105615:	8b 45 08             	mov    0x8(%ebp),%eax
  105618:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10561a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10561e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105622:	7f e4                	jg     105608 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105627:	05 0c 72 10 00       	add    $0x10720c,%eax
  10562c:	0f b6 00             	movzbl (%eax),%eax
  10562f:	0f be c0             	movsbl %al,%eax
  105632:	8b 55 0c             	mov    0xc(%ebp),%edx
  105635:	89 54 24 04          	mov    %edx,0x4(%esp)
  105639:	89 04 24             	mov    %eax,(%esp)
  10563c:	8b 45 08             	mov    0x8(%ebp),%eax
  10563f:	ff d0                	call   *%eax
}
  105641:	c9                   	leave  
  105642:	c3                   	ret    

00105643 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105643:	55                   	push   %ebp
  105644:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105646:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10564a:	7e 14                	jle    105660 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10564c:	8b 45 08             	mov    0x8(%ebp),%eax
  10564f:	8b 00                	mov    (%eax),%eax
  105651:	8d 48 08             	lea    0x8(%eax),%ecx
  105654:	8b 55 08             	mov    0x8(%ebp),%edx
  105657:	89 0a                	mov    %ecx,(%edx)
  105659:	8b 50 04             	mov    0x4(%eax),%edx
  10565c:	8b 00                	mov    (%eax),%eax
  10565e:	eb 30                	jmp    105690 <getuint+0x4d>
    }
    else if (lflag) {
  105660:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105664:	74 16                	je     10567c <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105666:	8b 45 08             	mov    0x8(%ebp),%eax
  105669:	8b 00                	mov    (%eax),%eax
  10566b:	8d 48 04             	lea    0x4(%eax),%ecx
  10566e:	8b 55 08             	mov    0x8(%ebp),%edx
  105671:	89 0a                	mov    %ecx,(%edx)
  105673:	8b 00                	mov    (%eax),%eax
  105675:	ba 00 00 00 00       	mov    $0x0,%edx
  10567a:	eb 14                	jmp    105690 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10567c:	8b 45 08             	mov    0x8(%ebp),%eax
  10567f:	8b 00                	mov    (%eax),%eax
  105681:	8d 48 04             	lea    0x4(%eax),%ecx
  105684:	8b 55 08             	mov    0x8(%ebp),%edx
  105687:	89 0a                	mov    %ecx,(%edx)
  105689:	8b 00                	mov    (%eax),%eax
  10568b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105690:	5d                   	pop    %ebp
  105691:	c3                   	ret    

00105692 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105692:	55                   	push   %ebp
  105693:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105695:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105699:	7e 14                	jle    1056af <getint+0x1d>
        return va_arg(*ap, long long);
  10569b:	8b 45 08             	mov    0x8(%ebp),%eax
  10569e:	8b 00                	mov    (%eax),%eax
  1056a0:	8d 48 08             	lea    0x8(%eax),%ecx
  1056a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1056a6:	89 0a                	mov    %ecx,(%edx)
  1056a8:	8b 50 04             	mov    0x4(%eax),%edx
  1056ab:	8b 00                	mov    (%eax),%eax
  1056ad:	eb 28                	jmp    1056d7 <getint+0x45>
    }
    else if (lflag) {
  1056af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056b3:	74 12                	je     1056c7 <getint+0x35>
        return va_arg(*ap, long);
  1056b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b8:	8b 00                	mov    (%eax),%eax
  1056ba:	8d 48 04             	lea    0x4(%eax),%ecx
  1056bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1056c0:	89 0a                	mov    %ecx,(%edx)
  1056c2:	8b 00                	mov    (%eax),%eax
  1056c4:	99                   	cltd   
  1056c5:	eb 10                	jmp    1056d7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1056c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ca:	8b 00                	mov    (%eax),%eax
  1056cc:	8d 48 04             	lea    0x4(%eax),%ecx
  1056cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1056d2:	89 0a                	mov    %ecx,(%edx)
  1056d4:	8b 00                	mov    (%eax),%eax
  1056d6:	99                   	cltd   
    }
}
  1056d7:	5d                   	pop    %ebp
  1056d8:	c3                   	ret    

001056d9 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1056d9:	55                   	push   %ebp
  1056da:	89 e5                	mov    %esp,%ebp
  1056dc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1056df:	8d 45 14             	lea    0x14(%ebp),%eax
  1056e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1056e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1056ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fd:	89 04 24             	mov    %eax,(%esp)
  105700:	e8 02 00 00 00       	call   105707 <vprintfmt>
    va_end(ap);
}
  105705:	c9                   	leave  
  105706:	c3                   	ret    

00105707 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105707:	55                   	push   %ebp
  105708:	89 e5                	mov    %esp,%ebp
  10570a:	56                   	push   %esi
  10570b:	53                   	push   %ebx
  10570c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10570f:	eb 18                	jmp    105729 <vprintfmt+0x22>
            if (ch == '\0') {
  105711:	85 db                	test   %ebx,%ebx
  105713:	75 05                	jne    10571a <vprintfmt+0x13>
                return;
  105715:	e9 d1 03 00 00       	jmp    105aeb <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10571a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105721:	89 1c 24             	mov    %ebx,(%esp)
  105724:	8b 45 08             	mov    0x8(%ebp),%eax
  105727:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105729:	8b 45 10             	mov    0x10(%ebp),%eax
  10572c:	8d 50 01             	lea    0x1(%eax),%edx
  10572f:	89 55 10             	mov    %edx,0x10(%ebp)
  105732:	0f b6 00             	movzbl (%eax),%eax
  105735:	0f b6 d8             	movzbl %al,%ebx
  105738:	83 fb 25             	cmp    $0x25,%ebx
  10573b:	75 d4                	jne    105711 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10573d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105741:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10574b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10574e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105755:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105758:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10575b:	8b 45 10             	mov    0x10(%ebp),%eax
  10575e:	8d 50 01             	lea    0x1(%eax),%edx
  105761:	89 55 10             	mov    %edx,0x10(%ebp)
  105764:	0f b6 00             	movzbl (%eax),%eax
  105767:	0f b6 d8             	movzbl %al,%ebx
  10576a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10576d:	83 f8 55             	cmp    $0x55,%eax
  105770:	0f 87 44 03 00 00    	ja     105aba <vprintfmt+0x3b3>
  105776:	8b 04 85 30 72 10 00 	mov    0x107230(,%eax,4),%eax
  10577d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10577f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105783:	eb d6                	jmp    10575b <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105785:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105789:	eb d0                	jmp    10575b <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10578b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105792:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105795:	89 d0                	mov    %edx,%eax
  105797:	c1 e0 02             	shl    $0x2,%eax
  10579a:	01 d0                	add    %edx,%eax
  10579c:	01 c0                	add    %eax,%eax
  10579e:	01 d8                	add    %ebx,%eax
  1057a0:	83 e8 30             	sub    $0x30,%eax
  1057a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1057a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1057a9:	0f b6 00             	movzbl (%eax),%eax
  1057ac:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1057af:	83 fb 2f             	cmp    $0x2f,%ebx
  1057b2:	7e 0b                	jle    1057bf <vprintfmt+0xb8>
  1057b4:	83 fb 39             	cmp    $0x39,%ebx
  1057b7:	7f 06                	jg     1057bf <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1057b9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1057bd:	eb d3                	jmp    105792 <vprintfmt+0x8b>
            goto process_precision;
  1057bf:	eb 33                	jmp    1057f4 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1057c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1057c4:	8d 50 04             	lea    0x4(%eax),%edx
  1057c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1057ca:	8b 00                	mov    (%eax),%eax
  1057cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1057cf:	eb 23                	jmp    1057f4 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1057d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057d5:	79 0c                	jns    1057e3 <vprintfmt+0xdc>
                width = 0;
  1057d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1057de:	e9 78 ff ff ff       	jmp    10575b <vprintfmt+0x54>
  1057e3:	e9 73 ff ff ff       	jmp    10575b <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1057e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1057ef:	e9 67 ff ff ff       	jmp    10575b <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1057f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057f8:	79 12                	jns    10580c <vprintfmt+0x105>
                width = precision, precision = -1;
  1057fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105800:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105807:	e9 4f ff ff ff       	jmp    10575b <vprintfmt+0x54>
  10580c:	e9 4a ff ff ff       	jmp    10575b <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105811:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105815:	e9 41 ff ff ff       	jmp    10575b <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10581a:	8b 45 14             	mov    0x14(%ebp),%eax
  10581d:	8d 50 04             	lea    0x4(%eax),%edx
  105820:	89 55 14             	mov    %edx,0x14(%ebp)
  105823:	8b 00                	mov    (%eax),%eax
  105825:	8b 55 0c             	mov    0xc(%ebp),%edx
  105828:	89 54 24 04          	mov    %edx,0x4(%esp)
  10582c:	89 04 24             	mov    %eax,(%esp)
  10582f:	8b 45 08             	mov    0x8(%ebp),%eax
  105832:	ff d0                	call   *%eax
            break;
  105834:	e9 ac 02 00 00       	jmp    105ae5 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105839:	8b 45 14             	mov    0x14(%ebp),%eax
  10583c:	8d 50 04             	lea    0x4(%eax),%edx
  10583f:	89 55 14             	mov    %edx,0x14(%ebp)
  105842:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105844:	85 db                	test   %ebx,%ebx
  105846:	79 02                	jns    10584a <vprintfmt+0x143>
                err = -err;
  105848:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10584a:	83 fb 06             	cmp    $0x6,%ebx
  10584d:	7f 0b                	jg     10585a <vprintfmt+0x153>
  10584f:	8b 34 9d f0 71 10 00 	mov    0x1071f0(,%ebx,4),%esi
  105856:	85 f6                	test   %esi,%esi
  105858:	75 23                	jne    10587d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10585a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10585e:	c7 44 24 08 1d 72 10 	movl   $0x10721d,0x8(%esp)
  105865:	00 
  105866:	8b 45 0c             	mov    0xc(%ebp),%eax
  105869:	89 44 24 04          	mov    %eax,0x4(%esp)
  10586d:	8b 45 08             	mov    0x8(%ebp),%eax
  105870:	89 04 24             	mov    %eax,(%esp)
  105873:	e8 61 fe ff ff       	call   1056d9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105878:	e9 68 02 00 00       	jmp    105ae5 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10587d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105881:	c7 44 24 08 26 72 10 	movl   $0x107226,0x8(%esp)
  105888:	00 
  105889:	8b 45 0c             	mov    0xc(%ebp),%eax
  10588c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105890:	8b 45 08             	mov    0x8(%ebp),%eax
  105893:	89 04 24             	mov    %eax,(%esp)
  105896:	e8 3e fe ff ff       	call   1056d9 <printfmt>
            }
            break;
  10589b:	e9 45 02 00 00       	jmp    105ae5 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1058a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1058a3:	8d 50 04             	lea    0x4(%eax),%edx
  1058a6:	89 55 14             	mov    %edx,0x14(%ebp)
  1058a9:	8b 30                	mov    (%eax),%esi
  1058ab:	85 f6                	test   %esi,%esi
  1058ad:	75 05                	jne    1058b4 <vprintfmt+0x1ad>
                p = "(null)";
  1058af:	be 29 72 10 00       	mov    $0x107229,%esi
            }
            if (width > 0 && padc != '-') {
  1058b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058b8:	7e 3e                	jle    1058f8 <vprintfmt+0x1f1>
  1058ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1058be:	74 38                	je     1058f8 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058c0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1058c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ca:	89 34 24             	mov    %esi,(%esp)
  1058cd:	e8 15 03 00 00       	call   105be7 <strnlen>
  1058d2:	29 c3                	sub    %eax,%ebx
  1058d4:	89 d8                	mov    %ebx,%eax
  1058d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058d9:	eb 17                	jmp    1058f2 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1058db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1058df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058e6:	89 04 24             	mov    %eax,(%esp)
  1058e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ec:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058ee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058f6:	7f e3                	jg     1058db <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058f8:	eb 38                	jmp    105932 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1058fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1058fe:	74 1f                	je     10591f <vprintfmt+0x218>
  105900:	83 fb 1f             	cmp    $0x1f,%ebx
  105903:	7e 05                	jle    10590a <vprintfmt+0x203>
  105905:	83 fb 7e             	cmp    $0x7e,%ebx
  105908:	7e 15                	jle    10591f <vprintfmt+0x218>
                    putch('?', putdat);
  10590a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10590d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105911:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105918:	8b 45 08             	mov    0x8(%ebp),%eax
  10591b:	ff d0                	call   *%eax
  10591d:	eb 0f                	jmp    10592e <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10591f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105922:	89 44 24 04          	mov    %eax,0x4(%esp)
  105926:	89 1c 24             	mov    %ebx,(%esp)
  105929:	8b 45 08             	mov    0x8(%ebp),%eax
  10592c:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10592e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105932:	89 f0                	mov    %esi,%eax
  105934:	8d 70 01             	lea    0x1(%eax),%esi
  105937:	0f b6 00             	movzbl (%eax),%eax
  10593a:	0f be d8             	movsbl %al,%ebx
  10593d:	85 db                	test   %ebx,%ebx
  10593f:	74 10                	je     105951 <vprintfmt+0x24a>
  105941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105945:	78 b3                	js     1058fa <vprintfmt+0x1f3>
  105947:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10594b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10594f:	79 a9                	jns    1058fa <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105951:	eb 17                	jmp    10596a <vprintfmt+0x263>
                putch(' ', putdat);
  105953:	8b 45 0c             	mov    0xc(%ebp),%eax
  105956:	89 44 24 04          	mov    %eax,0x4(%esp)
  10595a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105961:	8b 45 08             	mov    0x8(%ebp),%eax
  105964:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105966:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10596a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10596e:	7f e3                	jg     105953 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105970:	e9 70 01 00 00       	jmp    105ae5 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105978:	89 44 24 04          	mov    %eax,0x4(%esp)
  10597c:	8d 45 14             	lea    0x14(%ebp),%eax
  10597f:	89 04 24             	mov    %eax,(%esp)
  105982:	e8 0b fd ff ff       	call   105692 <getint>
  105987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10598a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10598d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105993:	85 d2                	test   %edx,%edx
  105995:	79 26                	jns    1059bd <vprintfmt+0x2b6>
                putch('-', putdat);
  105997:	8b 45 0c             	mov    0xc(%ebp),%eax
  10599a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1059a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a8:	ff d0                	call   *%eax
                num = -(long long)num;
  1059aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059b0:	f7 d8                	neg    %eax
  1059b2:	83 d2 00             	adc    $0x0,%edx
  1059b5:	f7 da                	neg    %edx
  1059b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1059bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059c4:	e9 a8 00 00 00       	jmp    105a71 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1059c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d0:	8d 45 14             	lea    0x14(%ebp),%eax
  1059d3:	89 04 24             	mov    %eax,(%esp)
  1059d6:	e8 68 fc ff ff       	call   105643 <getuint>
  1059db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1059e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059e8:	e9 84 00 00 00       	jmp    105a71 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1059ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1059f7:	89 04 24             	mov    %eax,(%esp)
  1059fa:	e8 44 fc ff ff       	call   105643 <getuint>
  1059ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a02:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105a05:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105a0c:	eb 63                	jmp    105a71 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a15:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1f:	ff d0                	call   *%eax
            putch('x', putdat);
  105a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a28:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a32:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105a34:	8b 45 14             	mov    0x14(%ebp),%eax
  105a37:	8d 50 04             	lea    0x4(%eax),%edx
  105a3a:	89 55 14             	mov    %edx,0x14(%ebp)
  105a3d:	8b 00                	mov    (%eax),%eax
  105a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105a49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105a50:	eb 1f                	jmp    105a71 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a59:	8d 45 14             	lea    0x14(%ebp),%eax
  105a5c:	89 04 24             	mov    %eax,(%esp)
  105a5f:	e8 df fb ff ff       	call   105643 <getuint>
  105a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a78:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a7f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a83:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9f:	89 04 24             	mov    %eax,(%esp)
  105aa2:	e8 97 fa ff ff       	call   10553e <printnum>
            break;
  105aa7:	eb 3c                	jmp    105ae5 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab0:	89 1c 24             	mov    %ebx,(%esp)
  105ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab6:	ff d0                	call   *%eax
            break;
  105ab8:	eb 2b                	jmp    105ae5 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  105acb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105acd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ad1:	eb 04                	jmp    105ad7 <vprintfmt+0x3d0>
  105ad3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  105ada:	83 e8 01             	sub    $0x1,%eax
  105add:	0f b6 00             	movzbl (%eax),%eax
  105ae0:	3c 25                	cmp    $0x25,%al
  105ae2:	75 ef                	jne    105ad3 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105ae4:	90                   	nop
        }
    }
  105ae5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ae6:	e9 3e fc ff ff       	jmp    105729 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105aeb:	83 c4 40             	add    $0x40,%esp
  105aee:	5b                   	pop    %ebx
  105aef:	5e                   	pop    %esi
  105af0:	5d                   	pop    %ebp
  105af1:	c3                   	ret    

00105af2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105af2:	55                   	push   %ebp
  105af3:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af8:	8b 40 08             	mov    0x8(%eax),%eax
  105afb:	8d 50 01             	lea    0x1(%eax),%edx
  105afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b01:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b07:	8b 10                	mov    (%eax),%edx
  105b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b0c:	8b 40 04             	mov    0x4(%eax),%eax
  105b0f:	39 c2                	cmp    %eax,%edx
  105b11:	73 12                	jae    105b25 <sprintputch+0x33>
        *b->buf ++ = ch;
  105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b16:	8b 00                	mov    (%eax),%eax
  105b18:	8d 48 01             	lea    0x1(%eax),%ecx
  105b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b1e:	89 0a                	mov    %ecx,(%edx)
  105b20:	8b 55 08             	mov    0x8(%ebp),%edx
  105b23:	88 10                	mov    %dl,(%eax)
    }
}
  105b25:	5d                   	pop    %ebp
  105b26:	c3                   	ret    

00105b27 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105b27:	55                   	push   %ebp
  105b28:	89 e5                	mov    %esp,%ebp
  105b2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  105b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b48:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4b:	89 04 24             	mov    %eax,(%esp)
  105b4e:	e8 08 00 00 00       	call   105b5b <vsnprintf>
  105b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b59:	c9                   	leave  
  105b5a:	c3                   	ret    

00105b5b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105b5b:	55                   	push   %ebp
  105b5c:	89 e5                	mov    %esp,%ebp
  105b5e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105b61:	8b 45 08             	mov    0x8(%ebp),%eax
  105b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b70:	01 d0                	add    %edx,%eax
  105b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b80:	74 0a                	je     105b8c <vsnprintf+0x31>
  105b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b88:	39 c2                	cmp    %eax,%edx
  105b8a:	76 07                	jbe    105b93 <vsnprintf+0x38>
        return -E_INVAL;
  105b8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b91:	eb 2a                	jmp    105bbd <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b93:	8b 45 14             	mov    0x14(%ebp),%eax
  105b96:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  105b9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ba1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba8:	c7 04 24 f2 5a 10 00 	movl   $0x105af2,(%esp)
  105baf:	e8 53 fb ff ff       	call   105707 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105bb7:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bbd:	c9                   	leave  
  105bbe:	c3                   	ret    

00105bbf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105bbf:	55                   	push   %ebp
  105bc0:	89 e5                	mov    %esp,%ebp
  105bc2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105bcc:	eb 04                	jmp    105bd2 <strlen+0x13>
        cnt ++;
  105bce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd5:	8d 50 01             	lea    0x1(%eax),%edx
  105bd8:	89 55 08             	mov    %edx,0x8(%ebp)
  105bdb:	0f b6 00             	movzbl (%eax),%eax
  105bde:	84 c0                	test   %al,%al
  105be0:	75 ec                	jne    105bce <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105be5:	c9                   	leave  
  105be6:	c3                   	ret    

00105be7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105be7:	55                   	push   %ebp
  105be8:	89 e5                	mov    %esp,%ebp
  105bea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105bed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105bf4:	eb 04                	jmp    105bfa <strnlen+0x13>
        cnt ++;
  105bf6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bfd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105c00:	73 10                	jae    105c12 <strnlen+0x2b>
  105c02:	8b 45 08             	mov    0x8(%ebp),%eax
  105c05:	8d 50 01             	lea    0x1(%eax),%edx
  105c08:	89 55 08             	mov    %edx,0x8(%ebp)
  105c0b:	0f b6 00             	movzbl (%eax),%eax
  105c0e:	84 c0                	test   %al,%al
  105c10:	75 e4                	jne    105bf6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c15:	c9                   	leave  
  105c16:	c3                   	ret    

00105c17 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105c17:	55                   	push   %ebp
  105c18:	89 e5                	mov    %esp,%ebp
  105c1a:	57                   	push   %edi
  105c1b:	56                   	push   %esi
  105c1c:	83 ec 20             	sub    $0x20,%esp
  105c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105c2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c31:	89 d1                	mov    %edx,%ecx
  105c33:	89 c2                	mov    %eax,%edx
  105c35:	89 ce                	mov    %ecx,%esi
  105c37:	89 d7                	mov    %edx,%edi
  105c39:	ac                   	lods   %ds:(%esi),%al
  105c3a:	aa                   	stos   %al,%es:(%edi)
  105c3b:	84 c0                	test   %al,%al
  105c3d:	75 fa                	jne    105c39 <strcpy+0x22>
  105c3f:	89 fa                	mov    %edi,%edx
  105c41:	89 f1                	mov    %esi,%ecx
  105c43:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c46:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105c49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105c4f:	83 c4 20             	add    $0x20,%esp
  105c52:	5e                   	pop    %esi
  105c53:	5f                   	pop    %edi
  105c54:	5d                   	pop    %ebp
  105c55:	c3                   	ret    

00105c56 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105c56:	55                   	push   %ebp
  105c57:	89 e5                	mov    %esp,%ebp
  105c59:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105c62:	eb 21                	jmp    105c85 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c67:	0f b6 10             	movzbl (%eax),%edx
  105c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c6d:	88 10                	mov    %dl,(%eax)
  105c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c72:	0f b6 00             	movzbl (%eax),%eax
  105c75:	84 c0                	test   %al,%al
  105c77:	74 04                	je     105c7d <strncpy+0x27>
            src ++;
  105c79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105c7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c81:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105c85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c89:	75 d9                	jne    105c64 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c8e:	c9                   	leave  
  105c8f:	c3                   	ret    

00105c90 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c90:	55                   	push   %ebp
  105c91:	89 e5                	mov    %esp,%ebp
  105c93:	57                   	push   %edi
  105c94:	56                   	push   %esi
  105c95:	83 ec 20             	sub    $0x20,%esp
  105c98:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105caa:	89 d1                	mov    %edx,%ecx
  105cac:	89 c2                	mov    %eax,%edx
  105cae:	89 ce                	mov    %ecx,%esi
  105cb0:	89 d7                	mov    %edx,%edi
  105cb2:	ac                   	lods   %ds:(%esi),%al
  105cb3:	ae                   	scas   %es:(%edi),%al
  105cb4:	75 08                	jne    105cbe <strcmp+0x2e>
  105cb6:	84 c0                	test   %al,%al
  105cb8:	75 f8                	jne    105cb2 <strcmp+0x22>
  105cba:	31 c0                	xor    %eax,%eax
  105cbc:	eb 04                	jmp    105cc2 <strcmp+0x32>
  105cbe:	19 c0                	sbb    %eax,%eax
  105cc0:	0c 01                	or     $0x1,%al
  105cc2:	89 fa                	mov    %edi,%edx
  105cc4:	89 f1                	mov    %esi,%ecx
  105cc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105cc9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ccc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105cd2:	83 c4 20             	add    $0x20,%esp
  105cd5:	5e                   	pop    %esi
  105cd6:	5f                   	pop    %edi
  105cd7:	5d                   	pop    %ebp
  105cd8:	c3                   	ret    

00105cd9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105cd9:	55                   	push   %ebp
  105cda:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105cdc:	eb 0c                	jmp    105cea <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105cde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ce2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ce6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105cea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cee:	74 1a                	je     105d0a <strncmp+0x31>
  105cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf3:	0f b6 00             	movzbl (%eax),%eax
  105cf6:	84 c0                	test   %al,%al
  105cf8:	74 10                	je     105d0a <strncmp+0x31>
  105cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfd:	0f b6 10             	movzbl (%eax),%edx
  105d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d03:	0f b6 00             	movzbl (%eax),%eax
  105d06:	38 c2                	cmp    %al,%dl
  105d08:	74 d4                	je     105cde <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d0e:	74 18                	je     105d28 <strncmp+0x4f>
  105d10:	8b 45 08             	mov    0x8(%ebp),%eax
  105d13:	0f b6 00             	movzbl (%eax),%eax
  105d16:	0f b6 d0             	movzbl %al,%edx
  105d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d1c:	0f b6 00             	movzbl (%eax),%eax
  105d1f:	0f b6 c0             	movzbl %al,%eax
  105d22:	29 c2                	sub    %eax,%edx
  105d24:	89 d0                	mov    %edx,%eax
  105d26:	eb 05                	jmp    105d2d <strncmp+0x54>
  105d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d2d:	5d                   	pop    %ebp
  105d2e:	c3                   	ret    

00105d2f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105d2f:	55                   	push   %ebp
  105d30:	89 e5                	mov    %esp,%ebp
  105d32:	83 ec 04             	sub    $0x4,%esp
  105d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d38:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d3b:	eb 14                	jmp    105d51 <strchr+0x22>
        if (*s == c) {
  105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d40:	0f b6 00             	movzbl (%eax),%eax
  105d43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d46:	75 05                	jne    105d4d <strchr+0x1e>
            return (char *)s;
  105d48:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4b:	eb 13                	jmp    105d60 <strchr+0x31>
        }
        s ++;
  105d4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105d51:	8b 45 08             	mov    0x8(%ebp),%eax
  105d54:	0f b6 00             	movzbl (%eax),%eax
  105d57:	84 c0                	test   %al,%al
  105d59:	75 e2                	jne    105d3d <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d60:	c9                   	leave  
  105d61:	c3                   	ret    

00105d62 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105d62:	55                   	push   %ebp
  105d63:	89 e5                	mov    %esp,%ebp
  105d65:	83 ec 04             	sub    $0x4,%esp
  105d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d6e:	eb 11                	jmp    105d81 <strfind+0x1f>
        if (*s == c) {
  105d70:	8b 45 08             	mov    0x8(%ebp),%eax
  105d73:	0f b6 00             	movzbl (%eax),%eax
  105d76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d79:	75 02                	jne    105d7d <strfind+0x1b>
            break;
  105d7b:	eb 0e                	jmp    105d8b <strfind+0x29>
        }
        s ++;
  105d7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105d81:	8b 45 08             	mov    0x8(%ebp),%eax
  105d84:	0f b6 00             	movzbl (%eax),%eax
  105d87:	84 c0                	test   %al,%al
  105d89:	75 e5                	jne    105d70 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105d8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d8e:	c9                   	leave  
  105d8f:	c3                   	ret    

00105d90 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d90:	55                   	push   %ebp
  105d91:	89 e5                	mov    %esp,%ebp
  105d93:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105d96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105da4:	eb 04                	jmp    105daa <strtol+0x1a>
        s ++;
  105da6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105daa:	8b 45 08             	mov    0x8(%ebp),%eax
  105dad:	0f b6 00             	movzbl (%eax),%eax
  105db0:	3c 20                	cmp    $0x20,%al
  105db2:	74 f2                	je     105da6 <strtol+0x16>
  105db4:	8b 45 08             	mov    0x8(%ebp),%eax
  105db7:	0f b6 00             	movzbl (%eax),%eax
  105dba:	3c 09                	cmp    $0x9,%al
  105dbc:	74 e8                	je     105da6 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc1:	0f b6 00             	movzbl (%eax),%eax
  105dc4:	3c 2b                	cmp    $0x2b,%al
  105dc6:	75 06                	jne    105dce <strtol+0x3e>
        s ++;
  105dc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dcc:	eb 15                	jmp    105de3 <strtol+0x53>
    }
    else if (*s == '-') {
  105dce:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd1:	0f b6 00             	movzbl (%eax),%eax
  105dd4:	3c 2d                	cmp    $0x2d,%al
  105dd6:	75 0b                	jne    105de3 <strtol+0x53>
        s ++, neg = 1;
  105dd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ddc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105de3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105de7:	74 06                	je     105def <strtol+0x5f>
  105de9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105ded:	75 24                	jne    105e13 <strtol+0x83>
  105def:	8b 45 08             	mov    0x8(%ebp),%eax
  105df2:	0f b6 00             	movzbl (%eax),%eax
  105df5:	3c 30                	cmp    $0x30,%al
  105df7:	75 1a                	jne    105e13 <strtol+0x83>
  105df9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfc:	83 c0 01             	add    $0x1,%eax
  105dff:	0f b6 00             	movzbl (%eax),%eax
  105e02:	3c 78                	cmp    $0x78,%al
  105e04:	75 0d                	jne    105e13 <strtol+0x83>
        s += 2, base = 16;
  105e06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105e0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105e11:	eb 2a                	jmp    105e3d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e17:	75 17                	jne    105e30 <strtol+0xa0>
  105e19:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1c:	0f b6 00             	movzbl (%eax),%eax
  105e1f:	3c 30                	cmp    $0x30,%al
  105e21:	75 0d                	jne    105e30 <strtol+0xa0>
        s ++, base = 8;
  105e23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e27:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105e2e:	eb 0d                	jmp    105e3d <strtol+0xad>
    }
    else if (base == 0) {
  105e30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e34:	75 07                	jne    105e3d <strtol+0xad>
        base = 10;
  105e36:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e40:	0f b6 00             	movzbl (%eax),%eax
  105e43:	3c 2f                	cmp    $0x2f,%al
  105e45:	7e 1b                	jle    105e62 <strtol+0xd2>
  105e47:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4a:	0f b6 00             	movzbl (%eax),%eax
  105e4d:	3c 39                	cmp    $0x39,%al
  105e4f:	7f 11                	jg     105e62 <strtol+0xd2>
            dig = *s - '0';
  105e51:	8b 45 08             	mov    0x8(%ebp),%eax
  105e54:	0f b6 00             	movzbl (%eax),%eax
  105e57:	0f be c0             	movsbl %al,%eax
  105e5a:	83 e8 30             	sub    $0x30,%eax
  105e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e60:	eb 48                	jmp    105eaa <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105e62:	8b 45 08             	mov    0x8(%ebp),%eax
  105e65:	0f b6 00             	movzbl (%eax),%eax
  105e68:	3c 60                	cmp    $0x60,%al
  105e6a:	7e 1b                	jle    105e87 <strtol+0xf7>
  105e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e6f:	0f b6 00             	movzbl (%eax),%eax
  105e72:	3c 7a                	cmp    $0x7a,%al
  105e74:	7f 11                	jg     105e87 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105e76:	8b 45 08             	mov    0x8(%ebp),%eax
  105e79:	0f b6 00             	movzbl (%eax),%eax
  105e7c:	0f be c0             	movsbl %al,%eax
  105e7f:	83 e8 57             	sub    $0x57,%eax
  105e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e85:	eb 23                	jmp    105eaa <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e87:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8a:	0f b6 00             	movzbl (%eax),%eax
  105e8d:	3c 40                	cmp    $0x40,%al
  105e8f:	7e 3d                	jle    105ece <strtol+0x13e>
  105e91:	8b 45 08             	mov    0x8(%ebp),%eax
  105e94:	0f b6 00             	movzbl (%eax),%eax
  105e97:	3c 5a                	cmp    $0x5a,%al
  105e99:	7f 33                	jg     105ece <strtol+0x13e>
            dig = *s - 'A' + 10;
  105e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e9e:	0f b6 00             	movzbl (%eax),%eax
  105ea1:	0f be c0             	movsbl %al,%eax
  105ea4:	83 e8 37             	sub    $0x37,%eax
  105ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ead:	3b 45 10             	cmp    0x10(%ebp),%eax
  105eb0:	7c 02                	jl     105eb4 <strtol+0x124>
            break;
  105eb2:	eb 1a                	jmp    105ece <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105eb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ebb:	0f af 45 10          	imul   0x10(%ebp),%eax
  105ebf:	89 c2                	mov    %eax,%edx
  105ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ec4:	01 d0                	add    %edx,%eax
  105ec6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105ec9:	e9 6f ff ff ff       	jmp    105e3d <strtol+0xad>

    if (endptr) {
  105ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ed2:	74 08                	je     105edc <strtol+0x14c>
        *endptr = (char *) s;
  105ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  105eda:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ee0:	74 07                	je     105ee9 <strtol+0x159>
  105ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ee5:	f7 d8                	neg    %eax
  105ee7:	eb 03                	jmp    105eec <strtol+0x15c>
  105ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105eec:	c9                   	leave  
  105eed:	c3                   	ret    

00105eee <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105eee:	55                   	push   %ebp
  105eef:	89 e5                	mov    %esp,%ebp
  105ef1:	57                   	push   %edi
  105ef2:	83 ec 24             	sub    $0x24,%esp
  105ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105efb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105eff:	8b 55 08             	mov    0x8(%ebp),%edx
  105f02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105f05:	88 45 f7             	mov    %al,-0x9(%ebp)
  105f08:	8b 45 10             	mov    0x10(%ebp),%eax
  105f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105f0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105f11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105f15:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105f18:	89 d7                	mov    %edx,%edi
  105f1a:	f3 aa                	rep stos %al,%es:(%edi)
  105f1c:	89 fa                	mov    %edi,%edx
  105f1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105f21:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105f27:	83 c4 24             	add    $0x24,%esp
  105f2a:	5f                   	pop    %edi
  105f2b:	5d                   	pop    %ebp
  105f2c:	c3                   	ret    

00105f2d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105f2d:	55                   	push   %ebp
  105f2e:	89 e5                	mov    %esp,%ebp
  105f30:	57                   	push   %edi
  105f31:	56                   	push   %esi
  105f32:	53                   	push   %ebx
  105f33:	83 ec 30             	sub    $0x30,%esp
  105f36:	8b 45 08             	mov    0x8(%ebp),%eax
  105f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105f42:	8b 45 10             	mov    0x10(%ebp),%eax
  105f45:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105f4e:	73 42                	jae    105f92 <memmove+0x65>
  105f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f65:	c1 e8 02             	shr    $0x2,%eax
  105f68:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f70:	89 d7                	mov    %edx,%edi
  105f72:	89 c6                	mov    %eax,%esi
  105f74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f76:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f79:	83 e1 03             	and    $0x3,%ecx
  105f7c:	74 02                	je     105f80 <memmove+0x53>
  105f7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f80:	89 f0                	mov    %esi,%eax
  105f82:	89 fa                	mov    %edi,%edx
  105f84:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105f8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f90:	eb 36                	jmp    105fc8 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f95:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f9b:	01 c2                	add    %eax,%edx
  105f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fa0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fa6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fac:	89 c1                	mov    %eax,%ecx
  105fae:	89 d8                	mov    %ebx,%eax
  105fb0:	89 d6                	mov    %edx,%esi
  105fb2:	89 c7                	mov    %eax,%edi
  105fb4:	fd                   	std    
  105fb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105fb7:	fc                   	cld    
  105fb8:	89 f8                	mov    %edi,%eax
  105fba:	89 f2                	mov    %esi,%edx
  105fbc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105fbf:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105fc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105fc8:	83 c4 30             	add    $0x30,%esp
  105fcb:	5b                   	pop    %ebx
  105fcc:	5e                   	pop    %esi
  105fcd:	5f                   	pop    %edi
  105fce:	5d                   	pop    %ebp
  105fcf:	c3                   	ret    

00105fd0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105fd0:	55                   	push   %ebp
  105fd1:	89 e5                	mov    %esp,%ebp
  105fd3:	57                   	push   %edi
  105fd4:	56                   	push   %esi
  105fd5:	83 ec 20             	sub    $0x20,%esp
  105fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  105fe7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fed:	c1 e8 02             	shr    $0x2,%eax
  105ff0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ff8:	89 d7                	mov    %edx,%edi
  105ffa:	89 c6                	mov    %eax,%esi
  105ffc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ffe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106001:	83 e1 03             	and    $0x3,%ecx
  106004:	74 02                	je     106008 <memcpy+0x38>
  106006:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106008:	89 f0                	mov    %esi,%eax
  10600a:	89 fa                	mov    %edi,%edx
  10600c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10600f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106012:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106018:	83 c4 20             	add    $0x20,%esp
  10601b:	5e                   	pop    %esi
  10601c:	5f                   	pop    %edi
  10601d:	5d                   	pop    %ebp
  10601e:	c3                   	ret    

0010601f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10601f:	55                   	push   %ebp
  106020:	89 e5                	mov    %esp,%ebp
  106022:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106025:	8b 45 08             	mov    0x8(%ebp),%eax
  106028:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10602b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10602e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106031:	eb 30                	jmp    106063 <memcmp+0x44>
        if (*s1 != *s2) {
  106033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106036:	0f b6 10             	movzbl (%eax),%edx
  106039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10603c:	0f b6 00             	movzbl (%eax),%eax
  10603f:	38 c2                	cmp    %al,%dl
  106041:	74 18                	je     10605b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106046:	0f b6 00             	movzbl (%eax),%eax
  106049:	0f b6 d0             	movzbl %al,%edx
  10604c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10604f:	0f b6 00             	movzbl (%eax),%eax
  106052:	0f b6 c0             	movzbl %al,%eax
  106055:	29 c2                	sub    %eax,%edx
  106057:	89 d0                	mov    %edx,%eax
  106059:	eb 1a                	jmp    106075 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10605b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10605f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106063:	8b 45 10             	mov    0x10(%ebp),%eax
  106066:	8d 50 ff             	lea    -0x1(%eax),%edx
  106069:	89 55 10             	mov    %edx,0x10(%ebp)
  10606c:	85 c0                	test   %eax,%eax
  10606e:	75 c3                	jne    106033 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106075:	c9                   	leave  
  106076:	c3                   	ret    
