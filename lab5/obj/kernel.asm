
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 12 00 	lgdtl  0x12a018
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
c010001e:	bc 00 a0 12 c0       	mov    $0xc012a000,%esp
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
c0100030:	ba b8 f0 19 c0       	mov    $0xc019f0b8,%edx
c0100035:	b8 2a bf 19 c0       	mov    $0xc019bf2a,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 2a bf 19 c0 	movl   $0xc019bf2a,(%esp)
c0100051:	e8 89 bb 00 00       	call   c010bbdf <memset>

    cons_init();                // init the console
c0100056:	e8 80 16 00 00       	call   c01016db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 bd 10 c0 	movl   $0xc010bd80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c bd 10 c0 	movl   $0xc010bd9c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 05 09 00 00       	call   c010097f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 e3 55 00 00       	call   c0105667 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 20 00 00       	call   c01020b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 a8 21 00 00       	call   c0102236 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 db 84 00 00       	call   c010856e <vmm_init>
    proc_init();                // init process table
c0100093:	e8 0a ab 00 00       	call   c010aba2 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 6f 17 00 00       	call   c010180c <ide_init>
    swap_init();                // init swap
c010009d:	e8 6e 6c 00 00       	call   c0106d10 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 ea 0d 00 00       	call   c0100e91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 7b 1f 00 00       	call   c0102027 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 b0 ac 00 00       	call   c010ad61 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f0 0c 00 00       	call   c0100dc3 <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 a1 bd 10 c0 	movl   $0xc010bda1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 af bd 10 c0 	movl   $0xc010bdaf,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 bd bd 10 c0 	movl   $0xc010bdbd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 cb bd 10 c0 	movl   $0xc010bdcb,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 d9 bd 10 c0 	movl   $0xc010bdd9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 40 bf 19 c0       	mov    %eax,0xc019bf40
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 e8 bd 10 c0 	movl   $0xc010bde8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 08 be 10 c0 	movl   $0xc010be08,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 27 be 10 c0 	movl   $0xc010be27,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 60 bf 19 c0    	mov    %dl,-0x3fe640a0(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 60 bf 19 c0       	add    $0xc019bf60,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 60 bf 19 c0       	mov    $0xc019bf60,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 f6 13 00 00       	call   c0101707 <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 d2 af 00 00       	call   c010b320 <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 7d 13 00 00       	call   c0101707 <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 5d 13 00 00       	call   c0101743 <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 2c be 10 c0    	movl   $0xc010be2c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 2c be 10 c0 	movl   $0xc010be2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058a:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100591:	76 21                	jbe    c01005b4 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100593:	c7 45 f4 60 e5 10 c0 	movl   $0xc010e560,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059a:	c7 45 f0 04 28 12 c0 	movl   $0xc0122804,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a1:	c7 45 ec 05 28 12 c0 	movl   $0xc0122805,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005a8:	c7 45 e8 cc 74 12 c0 	movl   $0xc01274cc,-0x18(%ebp)
c01005af:	e9 ea 00 00 00       	jmp    c010069e <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b4:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005bb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c0:	85 c0                	test   %eax,%eax
c01005c2:	74 11                	je     c01005d5 <debuginfo_eip+0x8b>
c01005c4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c9:	8b 40 18             	mov    0x18(%eax),%eax
c01005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d3:	75 0a                	jne    c01005df <debuginfo_eip+0x95>
            return -1;
c01005d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005da:	e9 9e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005e9:	00 
c01005ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f1:	00 
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 cc 88 00 00       	call   c0108ecd <user_mem_check>
c0100601:	85 c0                	test   %eax,%eax
c0100603:	75 0a                	jne    c010060f <debuginfo_eip+0xc5>
            return -1;
c0100605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060a:	e9 6e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	8b 40 04             	mov    0x4(%eax),%eax
c010061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100623:	8b 40 08             	mov    0x8(%eax),%eax
c0100626:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c0100629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062c:	8b 40 0c             	mov    0xc(%eax),%eax
c010062f:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100638:	29 c2                	sub    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100644:	00 
c0100645:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100650:	89 04 24             	mov    %eax,(%esp)
c0100653:	e8 75 88 00 00       	call   c0108ecd <user_mem_check>
c0100658:	85 c0                	test   %eax,%eax
c010065a:	75 0a                	jne    c0100666 <debuginfo_eip+0x11c>
            return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 17 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c0100666:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066c:	29 c2                	sub    %eax,%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010067c:	00 
c010067d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100688:	89 04 24             	mov    %eax,(%esp)
c010068b:	e8 3d 88 00 00       	call   c0108ecd <user_mem_check>
c0100690:	85 c0                	test   %eax,%eax
c0100692:	75 0a                	jne    c010069e <debuginfo_eip+0x154>
            return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 df 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a4:	76 0d                	jbe    c01006b3 <debuginfo_eip+0x169>
c01006a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a9:	83 e8 01             	sub    $0x1,%eax
c01006ac:	0f b6 00             	movzbl (%eax),%eax
c01006af:	84 c0                	test   %al,%al
c01006b1:	74 0a                	je     c01006bd <debuginfo_eip+0x173>
        return -1;
c01006b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b8:	e9 c0 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ca:	29 c2                	sub    %eax,%edx
c01006cc:	89 d0                	mov    %edx,%eax
c01006ce:	c1 f8 02             	sar    $0x2,%eax
c01006d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006d7:	83 e8 01             	sub    $0x1,%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ef fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c0100705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100708:	85 c0                	test   %eax,%eax
c010070a:	75 0a                	jne    c0100716 <debuginfo_eip+0x1cc>
        return -1;
c010070c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100711:	e9 67 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100716:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010071c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010071f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100722:	8b 45 08             	mov    0x8(%ebp),%eax
c0100725:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100729:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100730:	00 
c0100731:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100734:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100738:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010073b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100742:	89 04 24             	mov    %eax,(%esp)
c0100745:	e8 aa fc ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c010074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100750:	39 c2                	cmp    %eax,%edx
c0100752:	7f 7c                	jg     c01007d0 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	89 d0                	mov    %edx,%eax
c010075b:	01 c0                	add    %eax,%eax
c010075d:	01 d0                	add    %edx,%eax
c010075f:	c1 e0 02             	shl    $0x2,%eax
c0100762:	89 c2                	mov    %eax,%edx
c0100764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	8b 10                	mov    (%eax),%edx
c010076b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100771:	29 c1                	sub    %eax,%ecx
c0100773:	89 c8                	mov    %ecx,%eax
c0100775:	39 c2                	cmp    %eax,%edx
c0100777:	73 22                	jae    c010079b <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077c:	89 c2                	mov    %eax,%edx
c010077e:	89 d0                	mov    %edx,%eax
c0100780:	01 c0                	add    %eax,%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	c1 e0 02             	shl    $0x2,%eax
c0100787:	89 c2                	mov    %eax,%edx
c0100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078c:	01 d0                	add    %edx,%eax
c010078e:	8b 10                	mov    (%eax),%edx
c0100790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100793:	01 c2                	add    %eax,%edx
c0100795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100798:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	8b 50 08             	mov    0x8(%eax),%edx
c01007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bc:	8b 40 10             	mov    0x10(%eax),%eax
c01007bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007ce:	eb 15                	jmp    c01007e5 <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e8:	8b 40 08             	mov    0x8(%eax),%eax
c01007eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f2:	00 
c01007f3:	89 04 24             	mov    %eax,(%esp)
c01007f6:	e8 58 b2 00 00       	call   c010ba53 <strfind>
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	29 c2                	sub    %eax,%edx
c0100805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100808:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100812:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100819:	00 
c010081a:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100821:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082b:	89 04 24             	mov    %eax,(%esp)
c010082e:	e8 c1 fb ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c0100833:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100836:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100839:	39 c2                	cmp    %eax,%edx
c010083b:	7f 24                	jg     c0100861 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c010083d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	89 d0                	mov    %edx,%eax
c0100844:	01 c0                	add    %eax,%eax
c0100846:	01 d0                	add    %edx,%eax
c0100848:	c1 e0 02             	shl    $0x2,%eax
c010084b:	89 c2                	mov    %eax,%edx
c010084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100850:	01 d0                	add    %edx,%eax
c0100852:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100856:	0f b7 d0             	movzwl %ax,%edx
c0100859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010085c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085f:	eb 13                	jmp    c0100874 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100866:	e9 12 01 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010086b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010086e:	83 e8 01             	sub    $0x1,%eax
c0100871:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100874:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087a:	39 c2                	cmp    %eax,%edx
c010087c:	7c 56                	jl     c01008d4 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c010087e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	89 d0                	mov    %edx,%eax
c0100885:	01 c0                	add    %eax,%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	c1 e0 02             	shl    $0x2,%eax
c010088c:	89 c2                	mov    %eax,%edx
c010088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100891:	01 d0                	add    %edx,%eax
c0100893:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100897:	3c 84                	cmp    $0x84,%al
c0100899:	74 39                	je     c01008d4 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010089b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b4:	3c 64                	cmp    $0x64,%al
c01008b6:	75 b3                	jne    c010086b <debuginfo_eip+0x321>
c01008b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008bb:	89 c2                	mov    %eax,%edx
c01008bd:	89 d0                	mov    %edx,%eax
c01008bf:	01 c0                	add    %eax,%eax
c01008c1:	01 d0                	add    %edx,%eax
c01008c3:	c1 e0 02             	shl    $0x2,%eax
c01008c6:	89 c2                	mov    %eax,%edx
c01008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cb:	01 d0                	add    %edx,%eax
c01008cd:	8b 40 08             	mov    0x8(%eax),%eax
c01008d0:	85 c0                	test   %eax,%eax
c01008d2:	74 97                	je     c010086b <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008da:	39 c2                	cmp    %eax,%edx
c01008dc:	7c 46                	jl     c0100924 <debuginfo_eip+0x3da>
c01008de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e1:	89 c2                	mov    %eax,%edx
c01008e3:	89 d0                	mov    %edx,%eax
c01008e5:	01 c0                	add    %eax,%eax
c01008e7:	01 d0                	add    %edx,%eax
c01008e9:	c1 e0 02             	shl    $0x2,%eax
c01008ec:	89 c2                	mov    %eax,%edx
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f1:	01 d0                	add    %edx,%eax
c01008f3:	8b 10                	mov    (%eax),%edx
c01008f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008fb:	29 c1                	sub    %eax,%ecx
c01008fd:	89 c8                	mov    %ecx,%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	73 21                	jae    c0100924 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100903:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091d:	01 c2                	add    %eax,%edx
c010091f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100922:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 4a                	jge    c0100978 <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 c0 01             	add    $0x1,%eax
c0100934:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100937:	eb 18                	jmp    c0100951 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100948:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010094b:	83 c0 01             	add    $0x1,%eax
c010094e:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100951:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100954:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100957:	39 c2                	cmp    %eax,%edx
c0100959:	7d 1d                	jge    c0100978 <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010095e:	89 c2                	mov    %eax,%edx
c0100960:	89 d0                	mov    %edx,%eax
c0100962:	01 c0                	add    %eax,%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	c1 e0 02             	shl    $0x2,%eax
c0100969:	89 c2                	mov    %eax,%edx
c010096b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096e:	01 d0                	add    %edx,%eax
c0100970:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100974:	3c a0                	cmp    $0xa0,%al
c0100976:	74 c1                	je     c0100939 <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097d:	c9                   	leave  
c010097e:	c3                   	ret    

c010097f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097f:	55                   	push   %ebp
c0100980:	89 e5                	mov    %esp,%ebp
c0100982:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100985:	c7 04 24 36 be 10 c0 	movl   $0xc010be36,(%esp)
c010098c:	e8 c2 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100991:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100998:	c0 
c0100999:	c7 04 24 4f be 10 c0 	movl   $0xc010be4f,(%esp)
c01009a0:	e8 ae f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a5:	c7 44 24 04 68 bd 10 	movl   $0xc010bd68,0x4(%esp)
c01009ac:	c0 
c01009ad:	c7 04 24 67 be 10 c0 	movl   $0xc010be67,(%esp)
c01009b4:	e8 9a f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009b9:	c7 44 24 04 2a bf 19 	movl   $0xc019bf2a,0x4(%esp)
c01009c0:	c0 
c01009c1:	c7 04 24 7f be 10 c0 	movl   $0xc010be7f,(%esp)
c01009c8:	e8 86 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cd:	c7 44 24 04 b8 f0 19 	movl   $0xc019f0b8,0x4(%esp)
c01009d4:	c0 
c01009d5:	c7 04 24 97 be 10 c0 	movl   $0xc010be97,(%esp)
c01009dc:	e8 72 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e1:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c01009e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f1:	29 c2                	sub    %eax,%edx
c01009f3:	89 d0                	mov    %edx,%eax
c01009f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009fb:	85 c0                	test   %eax,%eax
c01009fd:	0f 48 c2             	cmovs  %edx,%eax
c0100a00:	c1 f8 0a             	sar    $0xa,%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 b0 be 10 c0 	movl   $0xc010beb0,(%esp)
c0100a0e:	e8 40 f9 ff ff       	call   c0100353 <cprintf>
}
c0100a13:	c9                   	leave  
c0100a14:	c3                   	ret    

c0100a15 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a15:	55                   	push   %ebp
c0100a16:	89 e5                	mov    %esp,%ebp
c0100a18:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a28:	89 04 24             	mov    %eax,(%esp)
c0100a2b:	e8 1a fb ff ff       	call   c010054a <debuginfo_eip>
c0100a30:	85 c0                	test   %eax,%eax
c0100a32:	74 15                	je     c0100a49 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 da be 10 c0 	movl   $0xc010beda,(%esp)
c0100a42:	e8 0c f9 ff ff       	call   c0100353 <cprintf>
c0100a47:	eb 6d                	jmp    c0100ab6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a50:	eb 1c                	jmp    c0100a6e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a66:	01 ca                	add    %ecx,%edx
c0100a68:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a74:	7f dc                	jg     c0100a52 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a76:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7f:	01 d0                	add    %edx,%eax
c0100a81:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8a:	89 d1                	mov    %edx,%ecx
c0100a8c:	29 c1                	sub    %eax,%ecx
c0100a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a94:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 f6 be 10 c0 	movl   $0xc010bef6,(%esp)
c0100ab1:	e8 9d f8 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100ab6:	c9                   	leave  
c0100ab7:	c3                   	ret    

c0100ab8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ab8:	55                   	push   %ebp
c0100ab9:	89 e5                	mov    %esp,%ebp
c0100abb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100abe:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100acf:	89 e8                	mov    %ebp,%eax
c0100ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ada:	e8 d9 ff ff ff       	call   c0100ab8 <read_eip>
c0100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100ae2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ae9:	e9 88 00 00 00       	jmp    c0100b76 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afc:	c7 04 24 08 bf 10 c0 	movl   $0xc010bf08,(%esp)
c0100b03:	e8 4b f8 ff ff       	call   c0100353 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	83 c0 08             	add    $0x8,%eax
c0100b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b18:	eb 25                	jmp    c0100b3f <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b27:	01 d0                	add    %edx,%eax
c0100b29:	8b 00                	mov    (%eax),%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 24 bf 10 c0 	movl   $0xc010bf24,(%esp)
c0100b36:	e8 18 f8 ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100b3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b43:	7e d5                	jle    c0100b1a <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100b45:	c7 04 24 2c bf 10 c0 	movl   $0xc010bf2c,(%esp)
c0100b4c:	e8 02 f8 ff ff       	call   c0100353 <cprintf>
        print_debuginfo(eip - 1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	83 e8 01             	sub    $0x1,%eax
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 b6 fe ff ff       	call   c0100a15 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	83 c0 04             	add    $0x4,%eax
c0100b65:	8b 00                	mov    (%eax),%eax
c0100b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7a:	74 0a                	je     c0100b86 <print_stackframe+0xbd>
c0100b7c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b80:	0f 8e 68 ff ff ff    	jle    c0100aee <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100b86:	c9                   	leave  
c0100b87:	c3                   	ret    

c0100b88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b88:	55                   	push   %ebp
c0100b89:	89 e5                	mov    %esp,%ebp
c0100b8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b95:	eb 0c                	jmp    c0100ba3 <parse+0x1b>
            *buf ++ = '\0';
c0100b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	74 1d                	je     c0100bca <parse+0x42>
c0100bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb0:	0f b6 00             	movzbl (%eax),%eax
c0100bb3:	0f be c0             	movsbl %al,%eax
c0100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bba:	c7 04 24 b0 bf 10 c0 	movl   $0xc010bfb0,(%esp)
c0100bc1:	e8 5a ae 00 00       	call   c010ba20 <strchr>
c0100bc6:	85 c0                	test   %eax,%eax
c0100bc8:	75 cd                	jne    c0100b97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcd:	0f b6 00             	movzbl (%eax),%eax
c0100bd0:	84 c0                	test   %al,%al
c0100bd2:	75 02                	jne    c0100bd6 <parse+0x4e>
            break;
c0100bd4:	eb 67                	jmp    c0100c3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bda:	75 14                	jne    c0100bf0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bdc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be3:	00 
c0100be4:	c7 04 24 b5 bf 10 c0 	movl   $0xc010bfb5,(%esp)
c0100beb:	e8 63 f7 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf3:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c03:	01 c2                	add    %eax,%edx
c0100c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0a:	eb 04                	jmp    c0100c10 <parse+0x88>
            buf ++;
c0100c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	0f b6 00             	movzbl (%eax),%eax
c0100c16:	84 c0                	test   %al,%al
c0100c18:	74 1d                	je     c0100c37 <parse+0xaf>
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	0f b6 00             	movzbl (%eax),%eax
c0100c20:	0f be c0             	movsbl %al,%eax
c0100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c27:	c7 04 24 b0 bf 10 c0 	movl   $0xc010bfb0,(%esp)
c0100c2e:	e8 ed ad 00 00       	call   c010ba20 <strchr>
c0100c33:	85 c0                	test   %eax,%eax
c0100c35:	74 d5                	je     c0100c0c <parse+0x84>
            buf ++;
        }
    }
c0100c37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c38:	e9 66 ff ff ff       	jmp    c0100ba3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c40:	c9                   	leave  
c0100c41:	c3                   	ret    

c0100c42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c42:	55                   	push   %ebp
c0100c43:	89 e5                	mov    %esp,%ebp
c0100c45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c52:	89 04 24             	mov    %eax,(%esp)
c0100c55:	e8 2e ff ff ff       	call   c0100b88 <parse>
c0100c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c61:	75 0a                	jne    c0100c6d <runcmd+0x2b>
        return 0;
c0100c63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c68:	e9 85 00 00 00       	jmp    c0100cf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c74:	eb 5c                	jmp    c0100cd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c90:	89 04 24             	mov    %eax,(%esp)
c0100c93:	e8 e9 ac 00 00       	call   c010b981 <strcmp>
c0100c98:	85 c0                	test   %eax,%eax
c0100c9a:	75 32                	jne    c0100cce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9f:	89 d0                	mov    %edx,%eax
c0100ca1:	01 c0                	add    %eax,%eax
c0100ca3:	01 d0                	add    %edx,%eax
c0100ca5:	c1 e0 02             	shl    $0x2,%eax
c0100ca8:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100cad:	8b 40 08             	mov    0x8(%eax),%eax
c0100cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cc0:	83 c2 04             	add    $0x4,%edx
c0100cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100cc7:	89 0c 24             	mov    %ecx,(%esp)
c0100cca:	ff d0                	call   *%eax
c0100ccc:	eb 24                	jmp    c0100cf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd5:	83 f8 02             	cmp    $0x2,%eax
c0100cd8:	76 9c                	jbe    c0100c76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce1:	c7 04 24 d3 bf 10 c0 	movl   $0xc010bfd3,(%esp)
c0100ce8:	e8 66 f6 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf2:	c9                   	leave  
c0100cf3:	c3                   	ret    

c0100cf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf4:	55                   	push   %ebp
c0100cf5:	89 e5                	mov    %esp,%ebp
c0100cf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cfa:	c7 04 24 ec bf 10 c0 	movl   $0xc010bfec,(%esp)
c0100d01:	e8 4d f6 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d06:	c7 04 24 14 c0 10 c0 	movl   $0xc010c014,(%esp)
c0100d0d:	e8 41 f6 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d16:	74 0b                	je     c0100d23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 c8 16 00 00       	call   c01023eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d23:	c7 04 24 39 c0 10 c0 	movl   $0xc010c039,(%esp)
c0100d2a:	e8 1b f5 ff ff       	call   c010024a <readline>
c0100d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d36:	74 18                	je     c0100d50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d42:	89 04 24             	mov    %eax,(%esp)
c0100d45:	e8 f8 fe ff ff       	call   c0100c42 <runcmd>
c0100d4a:	85 c0                	test   %eax,%eax
c0100d4c:	79 02                	jns    c0100d50 <kmonitor+0x5c>
                break;
c0100d4e:	eb 02                	jmp    c0100d52 <kmonitor+0x5e>
            }
        }
    }
c0100d50:	eb d1                	jmp    c0100d23 <kmonitor+0x2f>
}
c0100d52:	c9                   	leave  
c0100d53:	c3                   	ret    

c0100d54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d54:	55                   	push   %ebp
c0100d55:	89 e5                	mov    %esp,%ebp
c0100d57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d61:	eb 3f                	jmp    c0100da2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d66:	89 d0                	mov    %edx,%eax
c0100d68:	01 c0                	add    %eax,%eax
c0100d6a:	01 d0                	add    %edx,%eax
c0100d6c:	c1 e0 02             	shl    $0x2,%eax
c0100d6f:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7a:	89 d0                	mov    %edx,%eax
c0100d7c:	01 c0                	add    %eax,%eax
c0100d7e:	01 d0                	add    %edx,%eax
c0100d80:	c1 e0 02             	shl    $0x2,%eax
c0100d83:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d88:	8b 00                	mov    (%eax),%eax
c0100d8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d92:	c7 04 24 3d c0 10 c0 	movl   $0xc010c03d,(%esp)
c0100d99:	e8 b5 f5 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da5:	83 f8 02             	cmp    $0x2,%eax
c0100da8:	76 b9                	jbe    c0100d63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100daf:	c9                   	leave  
c0100db0:	c3                   	ret    

c0100db1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
c0100db4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db7:	e8 c3 fb ff ff       	call   c010097f <print_kerninfo>
    return 0;
c0100dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    

c0100dc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc3:	55                   	push   %ebp
c0100dc4:	89 e5                	mov    %esp,%ebp
c0100dc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc9:	e8 fb fc ff ff       	call   c0100ac9 <print_stackframe>
    return 0;
c0100dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd3:	c9                   	leave  
c0100dd4:	c3                   	ret    

c0100dd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dd5:	55                   	push   %ebp
c0100dd6:	89 e5                	mov    %esp,%ebp
c0100dd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ddb:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
c0100de0:	85 c0                	test   %eax,%eax
c0100de2:	74 02                	je     c0100de6 <__panic+0x11>
        goto panic_dead;
c0100de4:	eb 48                	jmp    c0100e2e <__panic+0x59>
    }
    is_panic = 1;
c0100de6:	c7 05 60 c3 19 c0 01 	movl   $0x1,0xc019c360
c0100ded:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100df0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100df9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e04:	c7 04 24 46 c0 10 c0 	movl   $0xc010c046,(%esp)
c0100e0b:	e8 43 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e1a:	89 04 24             	mov    %eax,(%esp)
c0100e1d:	e8 fe f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e22:	c7 04 24 62 c0 10 c0 	movl   $0xc010c062,(%esp)
c0100e29:	e8 25 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e2e:	e8 fa 11 00 00       	call   c010202d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e3a:	e8 b5 fe ff ff       	call   c0100cf4 <kmonitor>
    }
c0100e3f:	eb f2                	jmp    c0100e33 <__panic+0x5e>

c0100e41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e5b:	c7 04 24 64 c0 10 c0 	movl   $0xc010c064,(%esp)
c0100e62:	e8 ec f4 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e71:	89 04 24             	mov    %eax,(%esp)
c0100e74:	e8 a7 f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e79:	c7 04 24 62 c0 10 c0 	movl   $0xc010c062,(%esp)
c0100e80:	e8 ce f4 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e8a:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
}
c0100e8f:	5d                   	pop    %ebp
c0100e90:	c3                   	ret    

c0100e91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e91:	55                   	push   %ebp
c0100e92:	89 e5                	mov    %esp,%ebp
c0100e94:	83 ec 28             	sub    $0x28,%esp
c0100e97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ea5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ea9:	ee                   	out    %al,(%dx)
c0100eaa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eb0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eb4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ebc:	ee                   	out    %al,(%dx)
c0100ebd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ec3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ec7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ecb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ecf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ed0:	c7 05 b4 ef 19 c0 00 	movl   $0x0,0xc019efb4
c0100ed7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100eda:	c7 04 24 82 c0 10 c0 	movl   $0xc010c082,(%esp)
c0100ee1:	e8 6d f4 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ee6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100eed:	e8 99 11 00 00       	call   c010208b <pic_enable>
}
c0100ef2:	c9                   	leave  
c0100ef3:	c3                   	ret    

c0100ef4 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ef4:	55                   	push   %ebp
c0100ef5:	89 e5                	mov    %esp,%ebp
c0100ef7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100efa:	9c                   	pushf  
c0100efb:	58                   	pop    %eax
c0100efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100f02:	25 00 02 00 00       	and    $0x200,%eax
c0100f07:	85 c0                	test   %eax,%eax
c0100f09:	74 0c                	je     c0100f17 <__intr_save+0x23>
        intr_disable();
c0100f0b:	e8 1d 11 00 00       	call   c010202d <intr_disable>
        return 1;
c0100f10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f15:	eb 05                	jmp    c0100f1c <__intr_save+0x28>
    }
    return 0;
c0100f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f1c:	c9                   	leave  
c0100f1d:	c3                   	ret    

c0100f1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f1e:	55                   	push   %ebp
c0100f1f:	89 e5                	mov    %esp,%ebp
c0100f21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f28:	74 05                	je     c0100f2f <__intr_restore+0x11>
        intr_enable();
c0100f2a:	e8 f8 10 00 00       	call   c0102027 <intr_enable>
    }
}
c0100f2f:	c9                   	leave  
c0100f30:	c3                   	ret    

c0100f31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f31:	55                   	push   %ebp
c0100f32:	89 e5                	mov    %esp,%ebp
c0100f34:	83 ec 10             	sub    $0x10,%esp
c0100f37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f41:	89 c2                	mov    %eax,%edx
c0100f43:	ec                   	in     (%dx),%al
c0100f44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f51:	89 c2                	mov    %eax,%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f71:	89 c2                	mov    %eax,%edx
c0100f73:	ec                   	in     (%dx),%al
c0100f74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f89:	0f b7 00             	movzwl (%eax),%eax
c0100f8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f9b:	0f b7 00             	movzwl (%eax),%eax
c0100f9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fa2:	74 12                	je     c0100fb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fa4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fab:	66 c7 05 86 c3 19 c0 	movw   $0x3b4,0xc019c386
c0100fb2:	b4 03 
c0100fb4:	eb 13                	jmp    c0100fc9 <cga_init+0x50>
    } else {
        *cp = was;
c0100fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fbd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fc0:	66 c7 05 86 c3 19 c0 	movw   $0x3d4,0xc019c386
c0100fc7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fc9:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100fd0:	0f b7 c0             	movzwl %ax,%eax
c0100fd3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fd7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fdf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fe4:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100feb:	83 c0 01             	add    $0x1,%eax
c0100fee:	0f b7 c0             	movzwl %ax,%eax
c0100ff1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff9:	89 c2                	mov    %eax,%edx
c0100ffb:	ec                   	in     (%dx),%al
c0100ffc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	c1 e0 08             	shl    $0x8,%eax
c0101009:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010100c:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101013:	0f b7 c0             	movzwl %ax,%eax
c0101016:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010101a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101022:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101026:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101027:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010102e:	83 c0 01             	add    $0x1,%eax
c0101031:	0f b7 c0             	movzwl %ax,%eax
c0101034:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101038:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010103c:	89 c2                	mov    %eax,%edx
c010103e:	ec                   	in     (%dx),%al
c010103f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0101042:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101046:	0f b6 c0             	movzbl %al,%eax
c0101049:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c010104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010104f:	a3 80 c3 19 c0       	mov    %eax,0xc019c380
    crt_pos = pos;
c0101054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101057:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 48             	sub    $0x48,%esp
c0101065:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010106b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c010107e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101082:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101086:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101091:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101095:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101099:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010a4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
c01010b1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010b7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010c3:	ee                   	out    %al,(%dx)
c01010c4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010ca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010d6:	ee                   	out    %al,(%dx)
c01010d7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010dd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
c01010ea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010f0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010f4:	89 c2                	mov    %eax,%edx
c01010f6:	ec                   	in     (%dx),%al
c01010f7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010fe:	3c ff                	cmp    $0xff,%al
c0101100:	0f 95 c0             	setne  %al
c0101103:	0f b6 c0             	movzbl %al,%eax
c0101106:	a3 88 c3 19 c0       	mov    %eax,0xc019c388
c010110b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101111:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101115:	89 c2                	mov    %eax,%edx
c0101117:	ec                   	in     (%dx),%al
c0101118:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010111b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101121:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101125:	89 c2                	mov    %eax,%edx
c0101127:	ec                   	in     (%dx),%al
c0101128:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010112b:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101130:	85 c0                	test   %eax,%eax
c0101132:	74 0c                	je     c0101140 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101134:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010113b:	e8 4b 0f 00 00       	call   c010208b <pic_enable>
    }
}
c0101140:	c9                   	leave  
c0101141:	c3                   	ret    

c0101142 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101142:	55                   	push   %ebp
c0101143:	89 e5                	mov    %esp,%ebp
c0101145:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010114f:	eb 09                	jmp    c010115a <lpt_putc_sub+0x18>
        delay();
c0101151:	e8 db fd ff ff       	call   c0100f31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010115a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101160:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101164:	89 c2                	mov    %eax,%edx
c0101166:	ec                   	in     (%dx),%al
c0101167:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010116a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010116e:	84 c0                	test   %al,%al
c0101170:	78 09                	js     c010117b <lpt_putc_sub+0x39>
c0101172:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101179:	7e d6                	jle    c0101151 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010117b:	8b 45 08             	mov    0x8(%ebp),%eax
c010117e:	0f b6 c0             	movzbl %al,%eax
c0101181:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101187:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010118a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010118e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101192:	ee                   	out    %al,(%dx)
c0101193:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101199:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010119d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a5:	ee                   	out    %al,(%dx)
c01011a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011b9:	c9                   	leave  
c01011ba:	c3                   	ret    

c01011bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011bb:	55                   	push   %ebp
c01011bc:	89 e5                	mov    %esp,%ebp
c01011be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011c5:	74 0d                	je     c01011d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	89 04 24             	mov    %eax,(%esp)
c01011cd:	e8 70 ff ff ff       	call   c0101142 <lpt_putc_sub>
c01011d2:	eb 24                	jmp    c01011f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011db:	e8 62 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011e7:	e8 56 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011f3:	e8 4a ff ff ff       	call   c0101142 <lpt_putc_sub>
    }
}
c01011f8:	c9                   	leave  
c01011f9:	c3                   	ret    

c01011fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011fa:	55                   	push   %ebp
c01011fb:	89 e5                	mov    %esp,%ebp
c01011fd:	53                   	push   %ebx
c01011fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101201:	8b 45 08             	mov    0x8(%ebp),%eax
c0101204:	b0 00                	mov    $0x0,%al
c0101206:	85 c0                	test   %eax,%eax
c0101208:	75 07                	jne    c0101211 <cga_putc+0x17>
        c |= 0x0700;
c010120a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101211:	8b 45 08             	mov    0x8(%ebp),%eax
c0101214:	0f b6 c0             	movzbl %al,%eax
c0101217:	83 f8 0a             	cmp    $0xa,%eax
c010121a:	74 4c                	je     c0101268 <cga_putc+0x6e>
c010121c:	83 f8 0d             	cmp    $0xd,%eax
c010121f:	74 57                	je     c0101278 <cga_putc+0x7e>
c0101221:	83 f8 08             	cmp    $0x8,%eax
c0101224:	0f 85 88 00 00 00    	jne    c01012b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010122a:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101231:	66 85 c0             	test   %ax,%ax
c0101234:	74 30                	je     c0101266 <cga_putc+0x6c>
            crt_pos --;
c0101236:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010123d:	83 e8 01             	sub    $0x1,%eax
c0101240:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101246:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c010124b:	0f b7 15 84 c3 19 c0 	movzwl 0xc019c384,%edx
c0101252:	0f b7 d2             	movzwl %dx,%edx
c0101255:	01 d2                	add    %edx,%edx
c0101257:	01 c2                	add    %eax,%edx
c0101259:	8b 45 08             	mov    0x8(%ebp),%eax
c010125c:	b0 00                	mov    $0x0,%al
c010125e:	83 c8 20             	or     $0x20,%eax
c0101261:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101264:	eb 72                	jmp    c01012d8 <cga_putc+0xde>
c0101266:	eb 70                	jmp    c01012d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101268:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010126f:	83 c0 50             	add    $0x50,%eax
c0101272:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101278:	0f b7 1d 84 c3 19 c0 	movzwl 0xc019c384,%ebx
c010127f:	0f b7 0d 84 c3 19 c0 	movzwl 0xc019c384,%ecx
c0101286:	0f b7 c1             	movzwl %cx,%eax
c0101289:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010128f:	c1 e8 10             	shr    $0x10,%eax
c0101292:	89 c2                	mov    %eax,%edx
c0101294:	66 c1 ea 06          	shr    $0x6,%dx
c0101298:	89 d0                	mov    %edx,%eax
c010129a:	c1 e0 02             	shl    $0x2,%eax
c010129d:	01 d0                	add    %edx,%eax
c010129f:	c1 e0 04             	shl    $0x4,%eax
c01012a2:	29 c1                	sub    %eax,%ecx
c01012a4:	89 ca                	mov    %ecx,%edx
c01012a6:	89 d8                	mov    %ebx,%eax
c01012a8:	29 d0                	sub    %edx,%eax
c01012aa:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
        break;
c01012b0:	eb 26                	jmp    c01012d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012b2:	8b 0d 80 c3 19 c0    	mov    0xc019c380,%ecx
c01012b8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	66 89 15 84 c3 19 c0 	mov    %dx,0xc019c384
c01012c9:	0f b7 c0             	movzwl %ax,%eax
c01012cc:	01 c0                	add    %eax,%eax
c01012ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01012d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012d8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012e3:	76 5b                	jbe    c0101340 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012e5:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012f0:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012fc:	00 
c01012fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101301:	89 04 24             	mov    %eax,(%esp)
c0101304:	e8 15 a9 00 00       	call   c010bc1e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101309:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101310:	eb 15                	jmp    c0101327 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101312:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c0101317:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010131a:	01 d2                	add    %edx,%edx
c010131c:	01 d0                	add    %edx,%eax
c010131e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101327:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010132e:	7e e2                	jle    c0101312 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101330:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101337:	83 e8 50             	sub    $0x50,%eax
c010133a:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101340:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101347:	0f b7 c0             	movzwl %ax,%eax
c010134a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010134e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101352:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101356:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010135b:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101362:	66 c1 e8 08          	shr    $0x8,%ax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c0101370:	83 c2 01             	add    $0x1,%edx
c0101373:	0f b7 d2             	movzwl %dx,%edx
c0101376:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010137a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010137d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101381:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101385:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101386:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010138d:	0f b7 c0             	movzwl %ax,%eax
c0101390:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101394:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101398:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010139c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013a1:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c01013b2:	83 c2 01             	add    $0x1,%edx
c01013b5:	0f b7 d2             	movzwl %dx,%edx
c01013b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013c7:	ee                   	out    %al,(%dx)
}
c01013c8:	83 c4 34             	add    $0x34,%esp
c01013cb:	5b                   	pop    %ebx
c01013cc:	5d                   	pop    %ebp
c01013cd:	c3                   	ret    

c01013ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013db:	eb 09                	jmp    c01013e6 <serial_putc_sub+0x18>
        delay();
c01013dd:	e8 4f fb ff ff       	call   c0100f31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f0:	89 c2                	mov    %eax,%edx
c01013f2:	ec                   	in     (%dx),%al
c01013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013fa:	0f b6 c0             	movzbl %al,%eax
c01013fd:	83 e0 20             	and    $0x20,%eax
c0101400:	85 c0                	test   %eax,%eax
c0101402:	75 09                	jne    c010140d <serial_putc_sub+0x3f>
c0101404:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010140b:	7e d0                	jle    c01013dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010140d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101410:	0f b6 c0             	movzbl %al,%eax
c0101413:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101419:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010141c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101420:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101424:	ee                   	out    %al,(%dx)
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010142d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101431:	74 0d                	je     c0101440 <serial_putc+0x19>
        serial_putc_sub(c);
c0101433:	8b 45 08             	mov    0x8(%ebp),%eax
c0101436:	89 04 24             	mov    %eax,(%esp)
c0101439:	e8 90 ff ff ff       	call   c01013ce <serial_putc_sub>
c010143e:	eb 24                	jmp    c0101464 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101440:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101447:	e8 82 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub(' ');
c010144c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101453:	e8 76 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101458:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010145f:	e8 6a ff ff ff       	call   c01013ce <serial_putc_sub>
    }
}
c0101464:	c9                   	leave  
c0101465:	c3                   	ret    

c0101466 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101466:	55                   	push   %ebp
c0101467:	89 e5                	mov    %esp,%ebp
c0101469:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010146c:	eb 33                	jmp    c01014a1 <cons_intr+0x3b>
        if (c != 0) {
c010146e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101472:	74 2d                	je     c01014a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101474:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101479:	8d 50 01             	lea    0x1(%eax),%edx
c010147c:	89 15 a4 c5 19 c0    	mov    %edx,0xc019c5a4
c0101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101485:	88 90 a0 c3 19 c0    	mov    %dl,-0x3fe63c60(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010148b:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101490:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101495:	75 0a                	jne    c01014a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101497:	c7 05 a4 c5 19 c0 00 	movl   $0x0,0xc019c5a4
c010149e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01014a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01014a4:	ff d0                	call   *%eax
c01014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014ad:	75 bf                	jne    c010146e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014af:	c9                   	leave  
c01014b0:	c3                   	ret    

c01014b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014b1:	55                   	push   %ebp
c01014b2:	89 e5                	mov    %esp,%ebp
c01014b4:	83 ec 10             	sub    $0x10,%esp
c01014b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	ec                   	in     (%dx),%al
c01014c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014cb:	0f b6 c0             	movzbl %al,%eax
c01014ce:	83 e0 01             	and    $0x1,%eax
c01014d1:	85 c0                	test   %eax,%eax
c01014d3:	75 07                	jne    c01014dc <serial_proc_data+0x2b>
        return -1;
c01014d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014da:	eb 2a                	jmp    c0101506 <serial_proc_data+0x55>
c01014dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014e6:	89 c2                	mov    %eax,%edx
c01014e8:	ec                   	in     (%dx),%al
c01014e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014f0:	0f b6 c0             	movzbl %al,%eax
c01014f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014fa:	75 07                	jne    c0101503 <serial_proc_data+0x52>
        c = '\b';
c01014fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101503:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101506:	c9                   	leave  
c0101507:	c3                   	ret    

c0101508 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101508:	55                   	push   %ebp
c0101509:	89 e5                	mov    %esp,%ebp
c010150b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010150e:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101513:	85 c0                	test   %eax,%eax
c0101515:	74 0c                	je     c0101523 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101517:	c7 04 24 b1 14 10 c0 	movl   $0xc01014b1,(%esp)
c010151e:	e8 43 ff ff ff       	call   c0101466 <cons_intr>
    }
}
c0101523:	c9                   	leave  
c0101524:	c3                   	ret    

c0101525 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101525:	55                   	push   %ebp
c0101526:	89 e5                	mov    %esp,%ebp
c0101528:	83 ec 38             	sub    $0x38,%esp
c010152b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101531:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	ec                   	in     (%dx),%al
c0101538:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010153b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	83 e0 01             	and    $0x1,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	75 0a                	jne    c0101553 <kbd_proc_data+0x2e>
        return -1;
c0101549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010154e:	e9 59 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
c0101553:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010155d:	89 c2                	mov    %eax,%edx
c010155f:	ec                   	in     (%dx),%al
c0101560:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101563:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101567:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010156a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010156e:	75 17                	jne    c0101587 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101570:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101575:	83 c8 40             	or     $0x40,%eax
c0101578:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c010157d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101582:	e9 25 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101587:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158b:	84 c0                	test   %al,%al
c010158d:	79 47                	jns    c01015d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010158f:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101594:	83 e0 40             	and    $0x40,%eax
c0101597:	85 c0                	test   %eax,%eax
c0101599:	75 09                	jne    c01015a4 <kbd_proc_data+0x7f>
c010159b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010159f:	83 e0 7f             	and    $0x7f,%eax
c01015a2:	eb 04                	jmp    c01015a8 <kbd_proc_data+0x83>
c01015a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015af:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015b6:	83 c8 40             	or     $0x40,%eax
c01015b9:	0f b6 c0             	movzbl %al,%eax
c01015bc:	f7 d0                	not    %eax
c01015be:	89 c2                	mov    %eax,%edx
c01015c0:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015c5:	21 d0                	and    %edx,%eax
c01015c7:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c01015cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01015d1:	e9 d6 00 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015d6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015db:	83 e0 40             	and    $0x40,%eax
c01015de:	85 c0                	test   %eax,%eax
c01015e0:	74 11                	je     c01015f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015e6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01015ee:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    }

    shift |= shiftcode[data];
c01015f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f7:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015fe:	0f b6 d0             	movzbl %al,%edx
c0101601:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101606:	09 d0                	or     %edx,%eax
c0101608:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    shift ^= togglecode[data];
c010160d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101611:	0f b6 80 60 a1 12 c0 	movzbl -0x3fed5ea0(%eax),%eax
c0101618:	0f b6 d0             	movzbl %al,%edx
c010161b:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101620:	31 d0                	xor    %edx,%eax
c0101622:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101627:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010162c:	83 e0 03             	and    $0x3,%eax
c010162f:	8b 14 85 60 a5 12 c0 	mov    -0x3fed5aa0(,%eax,4),%edx
c0101636:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163a:	01 d0                	add    %edx,%eax
c010163c:	0f b6 00             	movzbl (%eax),%eax
c010163f:	0f b6 c0             	movzbl %al,%eax
c0101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101645:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010164a:	83 e0 08             	and    $0x8,%eax
c010164d:	85 c0                	test   %eax,%eax
c010164f:	74 22                	je     c0101673 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101651:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101655:	7e 0c                	jle    c0101663 <kbd_proc_data+0x13e>
c0101657:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010165b:	7f 06                	jg     c0101663 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010165d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101661:	eb 10                	jmp    c0101673 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101663:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101667:	7e 0a                	jle    c0101673 <kbd_proc_data+0x14e>
c0101669:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010166d:	7f 04                	jg     c0101673 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010166f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101673:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101678:	f7 d0                	not    %eax
c010167a:	83 e0 06             	and    $0x6,%eax
c010167d:	85 c0                	test   %eax,%eax
c010167f:	75 28                	jne    c01016a9 <kbd_proc_data+0x184>
c0101681:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101688:	75 1f                	jne    c01016a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010168a:	c7 04 24 9d c0 10 c0 	movl   $0xc010c09d,(%esp)
c0101691:	e8 bd ec ff ff       	call   c0100353 <cprintf>
c0101696:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010169c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
c01016b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016b4:	c7 04 24 25 15 10 c0 	movl   $0xc0101525,(%esp)
c01016bb:	e8 a6 fd ff ff       	call   c0101466 <cons_intr>
}
c01016c0:	c9                   	leave  
c01016c1:	c3                   	ret    

c01016c2 <kbd_init>:

static void
kbd_init(void) {
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
c01016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c8:	e8 e1 ff ff ff       	call   c01016ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d4:	e8 b2 09 00 00       	call   c010208b <pic_enable>
}
c01016d9:	c9                   	leave  
c01016da:	c3                   	ret    

c01016db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016db:	55                   	push   %ebp
c01016dc:	89 e5                	mov    %esp,%ebp
c01016de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e1:	e8 93 f8 ff ff       	call   c0100f79 <cga_init>
    serial_init();
c01016e6:	e8 74 f9 ff ff       	call   c010105f <serial_init>
    kbd_init();
c01016eb:	e8 d2 ff ff ff       	call   c01016c2 <kbd_init>
    if (!serial_exists) {
c01016f0:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c01016f5:	85 c0                	test   %eax,%eax
c01016f7:	75 0c                	jne    c0101705 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016f9:	c7 04 24 a9 c0 10 c0 	movl   $0xc010c0a9,(%esp)
c0101700:	e8 4e ec ff ff       	call   c0100353 <cprintf>
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010170d:	e8 e2 f7 ff ff       	call   c0100ef4 <__intr_save>
c0101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101715:	8b 45 08             	mov    0x8(%ebp),%eax
c0101718:	89 04 24             	mov    %eax,(%esp)
c010171b:	e8 9b fa ff ff       	call   c01011bb <lpt_putc>
        cga_putc(c);
c0101720:	8b 45 08             	mov    0x8(%ebp),%eax
c0101723:	89 04 24             	mov    %eax,(%esp)
c0101726:	e8 cf fa ff ff       	call   c01011fa <cga_putc>
        serial_putc(c);
c010172b:	8b 45 08             	mov    0x8(%ebp),%eax
c010172e:	89 04 24             	mov    %eax,(%esp)
c0101731:	e8 f1 fc ff ff       	call   c0101427 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101739:	89 04 24             	mov    %eax,(%esp)
c010173c:	e8 dd f7 ff ff       	call   c0100f1e <__intr_restore>
}
c0101741:	c9                   	leave  
c0101742:	c3                   	ret    

c0101743 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
c0101746:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101750:	e8 9f f7 ff ff       	call   c0100ef4 <__intr_save>
c0101755:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101758:	e8 ab fd ff ff       	call   c0101508 <serial_intr>
        kbd_intr();
c010175d:	e8 4c ff ff ff       	call   c01016ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101762:	8b 15 a0 c5 19 c0    	mov    0xc019c5a0,%edx
c0101768:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c010176d:	39 c2                	cmp    %eax,%edx
c010176f:	74 31                	je     c01017a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101771:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101776:	8d 50 01             	lea    0x1(%eax),%edx
c0101779:	89 15 a0 c5 19 c0    	mov    %edx,0xc019c5a0
c010177f:	0f b6 80 a0 c3 19 c0 	movzbl -0x3fe63c60(%eax),%eax
c0101786:	0f b6 c0             	movzbl %al,%eax
c0101789:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010178c:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101791:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101796:	75 0a                	jne    c01017a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101798:	c7 05 a0 c5 19 c0 00 	movl   $0x0,0xc019c5a0
c010179f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017a5:	89 04 24             	mov    %eax,(%esp)
c01017a8:	e8 71 f7 ff ff       	call   c0100f1e <__intr_restore>
    return c;
c01017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017b0:	c9                   	leave  
c01017b1:	c3                   	ret    

c01017b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017b2:	55                   	push   %ebp
c01017b3:	89 e5                	mov    %esp,%ebp
c01017b5:	83 ec 14             	sub    $0x14,%esp
c01017b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017bf:	90                   	nop
c01017c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017d2:	89 c2                	mov    %eax,%edx
c01017d4:	ec                   	in     (%dx),%al
c01017d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017dc:	0f b6 c0             	movzbl %al,%eax
c01017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e5:	25 80 00 00 00       	and    $0x80,%eax
c01017ea:	85 c0                	test   %eax,%eax
c01017ec:	75 d2                	jne    c01017c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017f2:	74 11                	je     c0101805 <ide_wait_ready+0x53>
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	83 e0 21             	and    $0x21,%eax
c01017fa:	85 c0                	test   %eax,%eax
c01017fc:	74 07                	je     c0101805 <ide_wait_ready+0x53>
        return -1;
c01017fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101803:	eb 05                	jmp    c010180a <ide_wait_ready+0x58>
    }
    return 0;
c0101805:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010180a:	c9                   	leave  
c010180b:	c3                   	ret    

c010180c <ide_init>:

void
ide_init(void) {
c010180c:	55                   	push   %ebp
c010180d:	89 e5                	mov    %esp,%ebp
c010180f:	57                   	push   %edi
c0101810:	53                   	push   %ebx
c0101811:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101817:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010181d:	e9 d6 02 00 00       	jmp    c0101af8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101822:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101826:	c1 e0 03             	shl    $0x3,%eax
c0101829:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101830:	29 c2                	sub    %eax,%edx
c0101832:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101838:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010183b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010183f:	66 d1 e8             	shr    %ax
c0101842:	0f b7 c0             	movzwl %ax,%eax
c0101845:	0f b7 04 85 c8 c0 10 	movzwl -0x3fef3f38(,%eax,4),%eax
c010184c:	c0 
c010184d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101851:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010185c:	00 
c010185d:	89 04 24             	mov    %eax,(%esp)
c0101860:	e8 4d ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101865:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101869:	83 e0 01             	and    $0x1,%eax
c010186c:	c1 e0 04             	shl    $0x4,%eax
c010186f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101872:	0f b6 c0             	movzbl %al,%eax
c0101875:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101879:	83 c2 06             	add    $0x6,%edx
c010187c:	0f b7 d2             	movzwl %dx,%edx
c010187f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101883:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101886:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010188a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010188f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010189a:	00 
c010189b:	89 04 24             	mov    %eax,(%esp)
c010189e:	e8 0f ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01018a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018a7:	83 c0 07             	add    $0x7,%eax
c01018aa:	0f b7 c0             	movzwl %ax,%eax
c01018ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018c9:	00 
c01018ca:	89 04 24             	mov    %eax,(%esp)
c01018cd:	e8 e0 fe ff ff       	call   c01017b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018d6:	83 c0 07             	add    $0x7,%eax
c01018d9:	0f b7 c0             	movzwl %ax,%eax
c01018dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018e4:	89 c2                	mov    %eax,%edx
c01018e6:	ec                   	in     (%dx),%al
c01018e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018ee:	84 c0                	test   %al,%al
c01018f0:	0f 84 f7 01 00 00    	je     c0101aed <ide_init+0x2e1>
c01018f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101901:	00 
c0101902:	89 04 24             	mov    %eax,(%esp)
c0101905:	e8 a8 fe ff ff       	call   c01017b2 <ide_wait_ready>
c010190a:	85 c0                	test   %eax,%eax
c010190c:	0f 85 db 01 00 00    	jne    c0101aed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101912:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101916:	c1 e0 03             	shl    $0x3,%eax
c0101919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101920:	29 c2                	sub    %eax,%edx
c0101922:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101928:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010192b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010192f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101932:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101938:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010193b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101942:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101945:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101948:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010194b:	89 cb                	mov    %ecx,%ebx
c010194d:	89 df                	mov    %ebx,%edi
c010194f:	89 c1                	mov    %eax,%ecx
c0101951:	fc                   	cld    
c0101952:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101954:	89 c8                	mov    %ecx,%eax
c0101956:	89 fb                	mov    %edi,%ebx
c0101958:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010195b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010195e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010196a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101970:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101973:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101976:	25 00 00 00 04       	and    $0x4000000,%eax
c010197b:	85 c0                	test   %eax,%eax
c010197d:	74 0e                	je     c010198d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010197f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101982:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101988:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010198b:	eb 09                	jmp    c0101996 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010198d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101990:	8b 40 78             	mov    0x78(%eax),%eax
c0101993:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101996:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199a:	c1 e0 03             	shl    $0x3,%eax
c010199d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a4:	29 c2                	sub    %eax,%edx
c01019a6:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b6:	c1 e0 03             	shl    $0x3,%eax
c01019b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c0:	29 c2                	sub    %eax,%edx
c01019c2:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019d1:	83 c0 62             	add    $0x62,%eax
c01019d4:	0f b7 00             	movzwl (%eax),%eax
c01019d7:	0f b7 c0             	movzwl %ax,%eax
c01019da:	25 00 02 00 00       	and    $0x200,%eax
c01019df:	85 c0                	test   %eax,%eax
c01019e1:	75 24                	jne    c0101a07 <ide_init+0x1fb>
c01019e3:	c7 44 24 0c d0 c0 10 	movl   $0xc010c0d0,0xc(%esp)
c01019ea:	c0 
c01019eb:	c7 44 24 08 13 c1 10 	movl   $0xc010c113,0x8(%esp)
c01019f2:	c0 
c01019f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019fa:	00 
c01019fb:	c7 04 24 28 c1 10 c0 	movl   $0xc010c128,(%esp)
c0101a02:	e8 ce f3 ff ff       	call   c0100dd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a07:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0b:	c1 e0 03             	shl    $0x3,%eax
c0101a0e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a15:	29 c2                	sub    %eax,%edx
c0101a17:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101a1d:	83 c0 0c             	add    $0xc,%eax
c0101a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a26:	83 c0 36             	add    $0x36,%eax
c0101a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a2c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a3a:	eb 34                	jmp    c0101a70 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a42:	01 c2                	add    %eax,%edx
c0101a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a47:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a4d:	01 c8                	add    %ecx,%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	88 02                	mov    %al,(%edx)
c0101a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a57:	8d 50 01             	lea    0x1(%eax),%edx
c0101a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a5d:	01 c2                	add    %eax,%edx
c0101a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a62:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a65:	01 c8                	add    %ecx,%eax
c0101a67:	0f b6 00             	movzbl (%eax),%eax
c0101a6a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a6c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a76:	72 c4                	jb     c0101a3c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a7e:	01 d0                	add    %edx,%eax
c0101a80:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a89:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a8c:	85 c0                	test   %eax,%eax
c0101a8e:	74 0f                	je     c0101a9f <ide_init+0x293>
c0101a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a96:	01 d0                	add    %edx,%eax
c0101a98:	0f b6 00             	movzbl (%eax),%eax
c0101a9b:	3c 20                	cmp    $0x20,%al
c0101a9d:	74 d9                	je     c0101a78 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a9f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aa3:	c1 e0 03             	shl    $0x3,%eax
c0101aa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aad:	29 c2                	sub    %eax,%edx
c0101aaf:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ab5:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101ab8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101abc:	c1 e0 03             	shl    $0x3,%eax
c0101abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac6:	29 c2                	sub    %eax,%edx
c0101ac8:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ace:	8b 50 08             	mov    0x8(%eax),%edx
c0101ad1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ad5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ad9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 3a c1 10 c0 	movl   $0xc010c13a,(%esp)
c0101ae8:	e8 66 e8 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101af1:	83 c0 01             	add    $0x1,%eax
c0101af4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101af8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101afd:	0f 86 1f fd ff ff    	jbe    c0101822 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101b03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b0a:	e8 7c 05 00 00       	call   c010208b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b16:	e8 70 05 00 00       	call   c010208b <pic_enable>
}
c0101b1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b21:	5b                   	pop    %ebx
c0101b22:	5f                   	pop    %edi
c0101b23:	5d                   	pop    %ebp
c0101b24:	c3                   	ret    

c0101b25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b25:	55                   	push   %ebp
c0101b26:	89 e5                	mov    %esp,%ebp
c0101b28:	83 ec 04             	sub    $0x4,%esp
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b37:	77 24                	ja     c0101b5d <ide_device_valid+0x38>
c0101b39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b3d:	c1 e0 03             	shl    $0x3,%eax
c0101b40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b47:	29 c2                	sub    %eax,%edx
c0101b49:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b4f:	0f b6 00             	movzbl (%eax),%eax
c0101b52:	84 c0                	test   %al,%al
c0101b54:	74 07                	je     c0101b5d <ide_device_valid+0x38>
c0101b56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b5b:	eb 05                	jmp    c0101b62 <ide_device_valid+0x3d>
c0101b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 08             	sub    $0x8,%esp
c0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b75:	89 04 24             	mov    %eax,(%esp)
c0101b78:	e8 a8 ff ff ff       	call   c0101b25 <ide_device_valid>
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1b                	je     c0101b9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b85:	c1 e0 03             	shl    $0x3,%eax
c0101b88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b8f:	29 c2                	sub    %eax,%edx
c0101b91:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b97:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9a:	eb 05                	jmp    c0101ba1 <ide_device_size+0x3d>
    }
    return 0;
c0101b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ba1:	c9                   	leave  
c0101ba2:	c3                   	ret    

c0101ba3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ba3:	55                   	push   %ebp
c0101ba4:	89 e5                	mov    %esp,%ebp
c0101ba6:	57                   	push   %edi
c0101ba7:	53                   	push   %ebx
c0101ba8:	83 ec 50             	sub    $0x50,%esp
c0101bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bb2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bb9:	77 24                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bbb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bc0:	77 1d                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bc2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc6:	c1 e0 03             	shl    $0x3,%eax
c0101bc9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bd0:	29 c2                	sub    %eax,%edx
c0101bd2:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101bd8:	0f b6 00             	movzbl (%eax),%eax
c0101bdb:	84 c0                	test   %al,%al
c0101bdd:	75 24                	jne    c0101c03 <ide_read_secs+0x60>
c0101bdf:	c7 44 24 0c 58 c1 10 	movl   $0xc010c158,0xc(%esp)
c0101be6:	c0 
c0101be7:	c7 44 24 08 13 c1 10 	movl   $0xc010c113,0x8(%esp)
c0101bee:	c0 
c0101bef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bf6:	00 
c0101bf7:	c7 04 24 28 c1 10 c0 	movl   $0xc010c128,(%esp)
c0101bfe:	e8 d2 f1 ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c0a:	77 0f                	ja     c0101c1b <ide_read_secs+0x78>
c0101c0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c12:	01 d0                	add    %edx,%eax
c0101c14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c19:	76 24                	jbe    c0101c3f <ide_read_secs+0x9c>
c0101c1b:	c7 44 24 0c 80 c1 10 	movl   $0xc010c180,0xc(%esp)
c0101c22:	c0 
c0101c23:	c7 44 24 08 13 c1 10 	movl   $0xc010c113,0x8(%esp)
c0101c2a:	c0 
c0101c2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c32:	00 
c0101c33:	c7 04 24 28 c1 10 c0 	movl   $0xc010c128,(%esp)
c0101c3a:	e8 96 f1 ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c43:	66 d1 e8             	shr    %ax
c0101c46:	0f b7 c0             	movzwl %ax,%eax
c0101c49:	0f b7 04 85 c8 c0 10 	movzwl -0x3fef3f38(,%eax,4),%eax
c0101c50:	c0 
c0101c51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c59:	66 d1 e8             	shr    %ax
c0101c5c:	0f b7 c0             	movzwl %ax,%eax
c0101c5f:	0f b7 04 85 ca c0 10 	movzwl -0x3fef3f36(,%eax,4),%eax
c0101c66:	c0 
c0101c67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c76:	00 
c0101c77:	89 04 24             	mov    %eax,(%esp)
c0101c7a:	e8 33 fb ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c83:	83 c0 02             	add    $0x2,%eax
c0101c86:	0f b7 c0             	movzwl %ax,%eax
c0101c89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c9d:	0f b6 c0             	movzbl %al,%eax
c0101ca0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ca4:	83 c2 02             	add    $0x2,%edx
c0101ca7:	0f b7 d2             	movzwl %dx,%edx
c0101caa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cbd:	0f b6 c0             	movzbl %al,%eax
c0101cc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cc4:	83 c2 03             	add    $0x3,%edx
c0101cc7:	0f b7 d2             	movzwl %dx,%edx
c0101cca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101cd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101cd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cdd:	c1 e8 08             	shr    $0x8,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ce7:	83 c2 04             	add    $0x4,%edx
c0101cea:	0f b7 d2             	movzwl %dx,%edx
c0101ced:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101cf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d00:	c1 e8 10             	shr    $0x10,%eax
c0101d03:	0f b6 c0             	movzbl %al,%eax
c0101d06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d0a:	83 c2 05             	add    $0x5,%edx
c0101d0d:	0f b7 d2             	movzwl %dx,%edx
c0101d10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d24:	83 e0 01             	and    $0x1,%eax
c0101d27:	c1 e0 04             	shl    $0x4,%eax
c0101d2a:	89 c2                	mov    %eax,%edx
c0101d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d2f:	c1 e8 18             	shr    $0x18,%eax
c0101d32:	83 e0 0f             	and    $0xf,%eax
c0101d35:	09 d0                	or     %edx,%eax
c0101d37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d3a:	0f b6 c0             	movzbl %al,%eax
c0101d3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d41:	83 c2 06             	add    $0x6,%edx
c0101d44:	0f b7 d2             	movzwl %dx,%edx
c0101d47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d5b:	83 c0 07             	add    $0x7,%eax
c0101d5e:	0f b7 c0             	movzwl %ax,%eax
c0101d61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d79:	eb 5a                	jmp    c0101dd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d86:	00 
c0101d87:	89 04 24             	mov    %eax,(%esp)
c0101d8a:	e8 23 fa ff ff       	call   c01017b2 <ide_wait_ready>
c0101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d96:	74 02                	je     c0101d9a <ide_read_secs+0x1f7>
            goto out;
c0101d98:	eb 41                	jmp    c0101ddb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101da1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101da7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101dae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101db1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101db7:	89 cb                	mov    %ecx,%ebx
c0101db9:	89 df                	mov    %ebx,%edi
c0101dbb:	89 c1                	mov    %eax,%ecx
c0101dbd:	fc                   	cld    
c0101dbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dc0:	89 c8                	mov    %ecx,%eax
c0101dc2:	89 fb                	mov    %edi,%ebx
c0101dc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dd9:	75 a0                	jne    c0101d7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dde:	83 c4 50             	add    $0x50,%esp
c0101de1:	5b                   	pop    %ebx
c0101de2:	5f                   	pop    %edi
c0101de3:	5d                   	pop    %ebp
c0101de4:	c3                   	ret    

c0101de5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	56                   	push   %esi
c0101de9:	53                   	push   %ebx
c0101dea:	83 ec 50             	sub    $0x50,%esp
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101df4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101dfb:	77 24                	ja     c0101e21 <ide_write_secs+0x3c>
c0101dfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101e02:	77 1d                	ja     c0101e21 <ide_write_secs+0x3c>
c0101e04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e08:	c1 e0 03             	shl    $0x3,%eax
c0101e0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e12:	29 c2                	sub    %eax,%edx
c0101e14:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101e1a:	0f b6 00             	movzbl (%eax),%eax
c0101e1d:	84 c0                	test   %al,%al
c0101e1f:	75 24                	jne    c0101e45 <ide_write_secs+0x60>
c0101e21:	c7 44 24 0c 58 c1 10 	movl   $0xc010c158,0xc(%esp)
c0101e28:	c0 
c0101e29:	c7 44 24 08 13 c1 10 	movl   $0xc010c113,0x8(%esp)
c0101e30:	c0 
c0101e31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e38:	00 
c0101e39:	c7 04 24 28 c1 10 c0 	movl   $0xc010c128,(%esp)
c0101e40:	e8 90 ef ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e4c:	77 0f                	ja     c0101e5d <ide_write_secs+0x78>
c0101e4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e54:	01 d0                	add    %edx,%eax
c0101e56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e5b:	76 24                	jbe    c0101e81 <ide_write_secs+0x9c>
c0101e5d:	c7 44 24 0c 80 c1 10 	movl   $0xc010c180,0xc(%esp)
c0101e64:	c0 
c0101e65:	c7 44 24 08 13 c1 10 	movl   $0xc010c113,0x8(%esp)
c0101e6c:	c0 
c0101e6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e74:	00 
c0101e75:	c7 04 24 28 c1 10 c0 	movl   $0xc010c128,(%esp)
c0101e7c:	e8 54 ef ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e85:	66 d1 e8             	shr    %ax
c0101e88:	0f b7 c0             	movzwl %ax,%eax
c0101e8b:	0f b7 04 85 c8 c0 10 	movzwl -0x3fef3f38(,%eax,4),%eax
c0101e92:	c0 
c0101e93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e9b:	66 d1 e8             	shr    %ax
c0101e9e:	0f b7 c0             	movzwl %ax,%eax
c0101ea1:	0f b7 04 85 ca c0 10 	movzwl -0x3fef3f36(,%eax,4),%eax
c0101ea8:	c0 
c0101ea9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ead:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101eb8:	00 
c0101eb9:	89 04 24             	mov    %eax,(%esp)
c0101ebc:	e8 f1 f8 ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ec1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ec5:	83 c0 02             	add    $0x2,%eax
c0101ec8:	0f b7 c0             	movzwl %ax,%eax
c0101ecb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ecf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ed7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101edb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101edc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101edf:	0f b6 c0             	movzbl %al,%eax
c0101ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee6:	83 c2 02             	add    $0x2,%edx
c0101ee9:	0f b7 d2             	movzwl %dx,%edx
c0101eec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ef0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ef3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ef7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101efb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eff:	0f b6 c0             	movzbl %al,%eax
c0101f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f06:	83 c2 03             	add    $0x3,%edx
c0101f09:	0f b7 d2             	movzwl %dx,%edx
c0101f0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f1f:	c1 e8 08             	shr    $0x8,%eax
c0101f22:	0f b6 c0             	movzbl %al,%eax
c0101f25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f29:	83 c2 04             	add    $0x4,%edx
c0101f2c:	0f b7 d2             	movzwl %dx,%edx
c0101f2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f42:	c1 e8 10             	shr    $0x10,%eax
c0101f45:	0f b6 c0             	movzbl %al,%eax
c0101f48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f4c:	83 c2 05             	add    $0x5,%edx
c0101f4f:	0f b7 d2             	movzwl %dx,%edx
c0101f52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f66:	83 e0 01             	and    $0x1,%eax
c0101f69:	c1 e0 04             	shl    $0x4,%eax
c0101f6c:	89 c2                	mov    %eax,%edx
c0101f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f71:	c1 e8 18             	shr    $0x18,%eax
c0101f74:	83 e0 0f             	and    $0xf,%eax
c0101f77:	09 d0                	or     %edx,%eax
c0101f79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f83:	83 c2 06             	add    $0x6,%edx
c0101f86:	0f b7 d2             	movzwl %dx,%edx
c0101f89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f9d:	83 c0 07             	add    $0x7,%eax
c0101fa0:	0f b7 c0             	movzwl %ax,%eax
c0101fa3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fa7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101faf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fbb:	eb 5a                	jmp    c0102017 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fbd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fc8:	00 
c0101fc9:	89 04 24             	mov    %eax,(%esp)
c0101fcc:	e8 e1 f7 ff ff       	call   c01017b2 <ide_wait_ready>
c0101fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fd8:	74 02                	je     c0101fdc <ide_write_secs+0x1f7>
            goto out;
c0101fda:	eb 41                	jmp    c010201d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fdc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fe0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fe6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fe9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ff0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ff3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ff6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ff9:	89 cb                	mov    %ecx,%ebx
c0101ffb:	89 de                	mov    %ebx,%esi
c0101ffd:	89 c1                	mov    %eax,%ecx
c0101fff:	fc                   	cld    
c0102000:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0102002:	89 c8                	mov    %ecx,%eax
c0102004:	89 f3                	mov    %esi,%ebx
c0102006:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0102009:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010200c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0102010:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0102017:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010201b:	75 a0                	jne    c0101fbd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102020:	83 c4 50             	add    $0x50,%esp
c0102023:	5b                   	pop    %ebx
c0102024:	5e                   	pop    %esi
c0102025:	5d                   	pop    %ebp
c0102026:	c3                   	ret    

c0102027 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102027:	55                   	push   %ebp
c0102028:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010202a:	fb                   	sti    
    sti();
}
c010202b:	5d                   	pop    %ebp
c010202c:	c3                   	ret    

c010202d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010202d:	55                   	push   %ebp
c010202e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102030:	fa                   	cli    
    cli();
}
c0102031:	5d                   	pop    %ebp
c0102032:	c3                   	ret    

c0102033 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0102033:	55                   	push   %ebp
c0102034:	89 e5                	mov    %esp,%ebp
c0102036:	83 ec 14             	sub    $0x14,%esp
c0102039:	8b 45 08             	mov    0x8(%ebp),%eax
c010203c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102040:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102044:	66 a3 70 a5 12 c0    	mov    %ax,0xc012a570
    if (did_init) {
c010204a:	a1 a0 c6 19 c0       	mov    0xc019c6a0,%eax
c010204f:	85 c0                	test   %eax,%eax
c0102051:	74 36                	je     c0102089 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102053:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102057:	0f b6 c0             	movzbl %al,%eax
c010205a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102060:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102063:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102067:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010206b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010206c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102070:	66 c1 e8 08          	shr    $0x8,%ax
c0102074:	0f b6 c0             	movzbl %al,%eax
c0102077:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010207d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102084:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102088:	ee                   	out    %al,(%dx)
    }
}
c0102089:	c9                   	leave  
c010208a:	c3                   	ret    

c010208b <pic_enable>:

void
pic_enable(unsigned int irq) {
c010208b:	55                   	push   %ebp
c010208c:	89 e5                	mov    %esp,%ebp
c010208e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102091:	8b 45 08             	mov    0x8(%ebp),%eax
c0102094:	ba 01 00 00 00       	mov    $0x1,%edx
c0102099:	89 c1                	mov    %eax,%ecx
c010209b:	d3 e2                	shl    %cl,%edx
c010209d:	89 d0                	mov    %edx,%eax
c010209f:	f7 d0                	not    %eax
c01020a1:	89 c2                	mov    %eax,%edx
c01020a3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01020aa:	21 d0                	and    %edx,%eax
c01020ac:	0f b7 c0             	movzwl %ax,%eax
c01020af:	89 04 24             	mov    %eax,(%esp)
c01020b2:	e8 7c ff ff ff       	call   c0102033 <pic_setmask>
}
c01020b7:	c9                   	leave  
c01020b8:	c3                   	ret    

c01020b9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020b9:	55                   	push   %ebp
c01020ba:	89 e5                	mov    %esp,%ebp
c01020bc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020bf:	c7 05 a0 c6 19 c0 01 	movl   $0x1,0xc019c6a0
c01020c6:	00 00 00 
c01020c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020cf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020db:	ee                   	out    %al,(%dx)
c01020dc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020e2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020ea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020ee:	ee                   	out    %al,(%dx)
c01020ef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020f5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102101:	ee                   	out    %al,(%dx)
c0102102:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102108:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010210c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102110:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102114:	ee                   	out    %al,(%dx)
c0102115:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010211b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010211f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102123:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102127:	ee                   	out    %al,(%dx)
c0102128:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010212e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102132:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102136:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010213a:	ee                   	out    %al,(%dx)
c010213b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102141:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102145:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102149:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010214d:	ee                   	out    %al,(%dx)
c010214e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102154:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102158:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010215c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102160:	ee                   	out    %al,(%dx)
c0102161:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102167:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010216b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010216f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102173:	ee                   	out    %al,(%dx)
c0102174:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010217a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010217e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102182:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102186:	ee                   	out    %al,(%dx)
c0102187:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010218d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102191:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102195:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102199:	ee                   	out    %al,(%dx)
c010219a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01021a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01021a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021ac:	ee                   	out    %al,(%dx)
c01021ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021bf:	ee                   	out    %al,(%dx)
c01021c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021d3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021de:	74 12                	je     c01021f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021e0:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021e7:	0f b7 c0             	movzwl %ax,%eax
c01021ea:	89 04 24             	mov    %eax,(%esp)
c01021ed:	e8 41 fe ff ff       	call   c0102033 <pic_setmask>
    }
}
c01021f2:	c9                   	leave  
c01021f3:	c3                   	ret    

c01021f4 <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01021f4:	55                   	push   %ebp
c01021f5:	89 e5                	mov    %esp,%ebp
c01021f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102201:	00 
c0102202:	c7 04 24 c0 c1 10 c0 	movl   $0xc010c1c0,(%esp)
c0102209:	e8 45 e1 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010220e:	c7 04 24 ca c1 10 c0 	movl   $0xc010c1ca,(%esp)
c0102215:	e8 39 e1 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c010221a:	c7 44 24 08 d8 c1 10 	movl   $0xc010c1d8,0x8(%esp)
c0102221:	c0 
c0102222:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0102229:	00 
c010222a:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c0102231:	e8 9f eb ff ff       	call   c0100dd5 <__panic>

c0102236 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102236:	55                   	push   %ebp
c0102237:	89 e5                	mov    %esp,%ebp
c0102239:	83 ec 10             	sub    $0x10,%esp
     /* LAB5 YOUR CODE */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010223c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102243:	e9 c3 00 00 00       	jmp    c010230b <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102248:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010224b:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c0102252:	89 c2                	mov    %eax,%edx
c0102254:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102257:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c010225e:	c0 
c010225f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102262:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c0102269:	c0 08 00 
c010226c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226f:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102276:	c0 
c0102277:	83 e2 e0             	and    $0xffffffe0,%edx
c010227a:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102281:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102284:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c010228b:	c0 
c010228c:	83 e2 1f             	and    $0x1f,%edx
c010228f:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102296:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102299:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022a0:	c0 
c01022a1:	83 e2 f0             	and    $0xfffffff0,%edx
c01022a4:	83 ca 0e             	or     $0xe,%edx
c01022a7:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b1:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022b8:	c0 
c01022b9:	83 e2 ef             	and    $0xffffffef,%edx
c01022bc:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022c6:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022cd:	c0 
c01022ce:	83 e2 9f             	and    $0xffffff9f,%edx
c01022d1:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022db:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022e2:	c0 
c01022e3:	83 ca 80             	or     $0xffffff80,%edx
c01022e6:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f0:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01022f7:	c1 e8 10             	shr    $0x10,%eax
c01022fa:	89 c2                	mov    %eax,%edx
c01022fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ff:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c0102306:	c0 
     /* LAB5 YOUR CODE */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102307:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010230b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010230e:	3d ff 00 00 00       	cmp    $0xff,%eax
c0102313:	0f 86 2f ff ff ff    	jbe    c0102248 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c0102319:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c010231e:	66 a3 c0 ca 19 c0    	mov    %ax,0xc019cac0
c0102324:	66 c7 05 c2 ca 19 c0 	movw   $0x8,0xc019cac2
c010232b:	08 00 
c010232d:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c0102334:	83 e0 e0             	and    $0xffffffe0,%eax
c0102337:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c010233c:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c0102343:	83 e0 1f             	and    $0x1f,%eax
c0102346:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c010234b:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102352:	83 c8 0f             	or     $0xf,%eax
c0102355:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c010235a:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102361:	83 e0 ef             	and    $0xffffffef,%eax
c0102364:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102369:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102370:	83 c8 60             	or     $0x60,%eax
c0102373:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102378:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c010237f:	83 c8 80             	or     $0xffffff80,%eax
c0102382:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102387:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c010238c:	c1 e8 10             	shr    $0x10,%eax
c010238f:	66 a3 c6 ca 19 c0    	mov    %ax,0xc019cac6
c0102395:	c7 45 f8 80 a5 12 c0 	movl   $0xc012a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010239c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010239f:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c01023a2:	c9                   	leave  
c01023a3:	c3                   	ret    

c01023a4 <trapname>:

static const char *
trapname(int trapno) {
c01023a4:	55                   	push   %ebp
c01023a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01023a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023aa:	83 f8 13             	cmp    $0x13,%eax
c01023ad:	77 0c                	ja     c01023bb <trapname+0x17>
        return excnames[trapno];
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	8b 04 85 60 c6 10 c0 	mov    -0x3fef39a0(,%eax,4),%eax
c01023b9:	eb 18                	jmp    c01023d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01023bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01023bf:	7e 0d                	jle    c01023ce <trapname+0x2a>
c01023c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01023c5:	7f 07                	jg     c01023ce <trapname+0x2a>
        return "Hardware Interrupt";
c01023c7:	b8 ff c1 10 c0       	mov    $0xc010c1ff,%eax
c01023cc:	eb 05                	jmp    c01023d3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01023ce:	b8 12 c2 10 c0       	mov    $0xc010c212,%eax
}
c01023d3:	5d                   	pop    %ebp
c01023d4:	c3                   	ret    

c01023d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01023d5:	55                   	push   %ebp
c01023d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01023d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023df:	66 83 f8 08          	cmp    $0x8,%ax
c01023e3:	0f 94 c0             	sete   %al
c01023e6:	0f b6 c0             	movzbl %al,%eax
}
c01023e9:	5d                   	pop    %ebp
c01023ea:	c3                   	ret    

c01023eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01023eb:	55                   	push   %ebp
c01023ec:	89 e5                	mov    %esp,%ebp
c01023ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01023f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f8:	c7 04 24 53 c2 10 c0 	movl   $0xc010c253,(%esp)
c01023ff:	e8 4f df ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c0102404:	8b 45 08             	mov    0x8(%ebp),%eax
c0102407:	89 04 24             	mov    %eax,(%esp)
c010240a:	e8 a1 01 00 00       	call   c01025b0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102416:	0f b7 c0             	movzwl %ax,%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 64 c2 10 c0 	movl   $0xc010c264,(%esp)
c0102424:	e8 2a df ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102429:	8b 45 08             	mov    0x8(%ebp),%eax
c010242c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102430:	0f b7 c0             	movzwl %ax,%eax
c0102433:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102437:	c7 04 24 77 c2 10 c0 	movl   $0xc010c277,(%esp)
c010243e:	e8 10 df ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102443:	8b 45 08             	mov    0x8(%ebp),%eax
c0102446:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010244a:	0f b7 c0             	movzwl %ax,%eax
c010244d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102451:	c7 04 24 8a c2 10 c0 	movl   $0xc010c28a,(%esp)
c0102458:	e8 f6 de ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010245d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102460:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102464:	0f b7 c0             	movzwl %ax,%eax
c0102467:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246b:	c7 04 24 9d c2 10 c0 	movl   $0xc010c29d,(%esp)
c0102472:	e8 dc de ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102477:	8b 45 08             	mov    0x8(%ebp),%eax
c010247a:	8b 40 30             	mov    0x30(%eax),%eax
c010247d:	89 04 24             	mov    %eax,(%esp)
c0102480:	e8 1f ff ff ff       	call   c01023a4 <trapname>
c0102485:	8b 55 08             	mov    0x8(%ebp),%edx
c0102488:	8b 52 30             	mov    0x30(%edx),%edx
c010248b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010248f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102493:	c7 04 24 b0 c2 10 c0 	movl   $0xc010c2b0,(%esp)
c010249a:	e8 b4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010249f:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a2:	8b 40 34             	mov    0x34(%eax),%eax
c01024a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a9:	c7 04 24 c2 c2 10 c0 	movl   $0xc010c2c2,(%esp)
c01024b0:	e8 9e de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01024b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b8:	8b 40 38             	mov    0x38(%eax),%eax
c01024bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bf:	c7 04 24 d1 c2 10 c0 	movl   $0xc010c2d1,(%esp)
c01024c6:	e8 88 de ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01024cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01024d2:	0f b7 c0             	movzwl %ax,%eax
c01024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d9:	c7 04 24 e0 c2 10 c0 	movl   $0xc010c2e0,(%esp)
c01024e0:	e8 6e de ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 40             	mov    0x40(%eax),%eax
c01024eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ef:	c7 04 24 f3 c2 10 c0 	movl   $0xc010c2f3,(%esp)
c01024f6:	e8 58 de ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102509:	eb 3e                	jmp    c0102549 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010250b:	8b 45 08             	mov    0x8(%ebp),%eax
c010250e:	8b 50 40             	mov    0x40(%eax),%edx
c0102511:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102514:	21 d0                	and    %edx,%eax
c0102516:	85 c0                	test   %eax,%eax
c0102518:	74 28                	je     c0102542 <print_trapframe+0x157>
c010251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010251d:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c0102524:	85 c0                	test   %eax,%eax
c0102526:	74 1a                	je     c0102542 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010252b:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c0102532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102536:	c7 04 24 02 c3 10 c0 	movl   $0xc010c302,(%esp)
c010253d:	e8 11 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102546:	d1 65 f0             	shll   -0x10(%ebp)
c0102549:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010254c:	83 f8 17             	cmp    $0x17,%eax
c010254f:	76 ba                	jbe    c010250b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102551:	8b 45 08             	mov    0x8(%ebp),%eax
c0102554:	8b 40 40             	mov    0x40(%eax),%eax
c0102557:	25 00 30 00 00       	and    $0x3000,%eax
c010255c:	c1 e8 0c             	shr    $0xc,%eax
c010255f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102563:	c7 04 24 06 c3 10 c0 	movl   $0xc010c306,(%esp)
c010256a:	e8 e4 dd ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c010256f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102572:	89 04 24             	mov    %eax,(%esp)
c0102575:	e8 5b fe ff ff       	call   c01023d5 <trap_in_kernel>
c010257a:	85 c0                	test   %eax,%eax
c010257c:	75 30                	jne    c01025ae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010257e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102581:	8b 40 44             	mov    0x44(%eax),%eax
c0102584:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102588:	c7 04 24 0f c3 10 c0 	movl   $0xc010c30f,(%esp)
c010258f:	e8 bf dd ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102594:	8b 45 08             	mov    0x8(%ebp),%eax
c0102597:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010259b:	0f b7 c0             	movzwl %ax,%eax
c010259e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025a2:	c7 04 24 1e c3 10 c0 	movl   $0xc010c31e,(%esp)
c01025a9:	e8 a5 dd ff ff       	call   c0100353 <cprintf>
    }
}
c01025ae:	c9                   	leave  
c01025af:	c3                   	ret    

c01025b0 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01025b0:	55                   	push   %ebp
c01025b1:	89 e5                	mov    %esp,%ebp
c01025b3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01025b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b9:	8b 00                	mov    (%eax),%eax
c01025bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025bf:	c7 04 24 31 c3 10 c0 	movl   $0xc010c331,(%esp)
c01025c6:	e8 88 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01025cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ce:	8b 40 04             	mov    0x4(%eax),%eax
c01025d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025d5:	c7 04 24 40 c3 10 c0 	movl   $0xc010c340,(%esp)
c01025dc:	e8 72 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e4:	8b 40 08             	mov    0x8(%eax),%eax
c01025e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025eb:	c7 04 24 4f c3 10 c0 	movl   $0xc010c34f,(%esp)
c01025f2:	e8 5c dd ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	8b 40 0c             	mov    0xc(%eax),%eax
c01025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102601:	c7 04 24 5e c3 10 c0 	movl   $0xc010c35e,(%esp)
c0102608:	e8 46 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010260d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102610:	8b 40 10             	mov    0x10(%eax),%eax
c0102613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102617:	c7 04 24 6d c3 10 c0 	movl   $0xc010c36d,(%esp)
c010261e:	e8 30 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102623:	8b 45 08             	mov    0x8(%ebp),%eax
c0102626:	8b 40 14             	mov    0x14(%eax),%eax
c0102629:	89 44 24 04          	mov    %eax,0x4(%esp)
c010262d:	c7 04 24 7c c3 10 c0 	movl   $0xc010c37c,(%esp)
c0102634:	e8 1a dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102639:	8b 45 08             	mov    0x8(%ebp),%eax
c010263c:	8b 40 18             	mov    0x18(%eax),%eax
c010263f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102643:	c7 04 24 8b c3 10 c0 	movl   $0xc010c38b,(%esp)
c010264a:	e8 04 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010264f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102652:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102655:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102659:	c7 04 24 9a c3 10 c0 	movl   $0xc010c39a,(%esp)
c0102660:	e8 ee dc ff ff       	call   c0100353 <cprintf>
}
c0102665:	c9                   	leave  
c0102666:	c3                   	ret    

c0102667 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102667:	55                   	push   %ebp
c0102668:	89 e5                	mov    %esp,%ebp
c010266a:	53                   	push   %ebx
c010266b:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010266e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102671:	8b 40 34             	mov    0x34(%eax),%eax
c0102674:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102677:	85 c0                	test   %eax,%eax
c0102679:	74 07                	je     c0102682 <print_pgfault+0x1b>
c010267b:	b9 a9 c3 10 c0       	mov    $0xc010c3a9,%ecx
c0102680:	eb 05                	jmp    c0102687 <print_pgfault+0x20>
c0102682:	b9 ba c3 10 c0       	mov    $0xc010c3ba,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102687:	8b 45 08             	mov    0x8(%ebp),%eax
c010268a:	8b 40 34             	mov    0x34(%eax),%eax
c010268d:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102690:	85 c0                	test   %eax,%eax
c0102692:	74 07                	je     c010269b <print_pgfault+0x34>
c0102694:	ba 57 00 00 00       	mov    $0x57,%edx
c0102699:	eb 05                	jmp    c01026a0 <print_pgfault+0x39>
c010269b:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01026a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a3:	8b 40 34             	mov    0x34(%eax),%eax
c01026a6:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01026a9:	85 c0                	test   %eax,%eax
c01026ab:	74 07                	je     c01026b4 <print_pgfault+0x4d>
c01026ad:	b8 55 00 00 00       	mov    $0x55,%eax
c01026b2:	eb 05                	jmp    c01026b9 <print_pgfault+0x52>
c01026b4:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01026b9:	0f 20 d3             	mov    %cr2,%ebx
c01026bc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01026bf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01026c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01026c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01026ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01026ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01026d2:	c7 04 24 c8 c3 10 c0 	movl   $0xc010c3c8,(%esp)
c01026d9:	e8 75 dc ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01026de:	83 c4 34             	add    $0x34,%esp
c01026e1:	5b                   	pop    %ebx
c01026e2:	5d                   	pop    %ebp
c01026e3:	c3                   	ret    

c01026e4 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026e4:	55                   	push   %ebp
c01026e5:	89 e5                	mov    %esp,%ebp
c01026e7:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c01026ea:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01026ef:	85 c0                	test   %eax,%eax
c01026f1:	74 0b                	je     c01026fe <pgfault_handler+0x1a>
            print_pgfault(tf);
c01026f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f6:	89 04 24             	mov    %eax,(%esp)
c01026f9:	e8 69 ff ff ff       	call   c0102667 <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c01026fe:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0102703:	85 c0                	test   %eax,%eax
c0102705:	74 3d                	je     c0102744 <pgfault_handler+0x60>
        assert(current == idleproc);
c0102707:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010270d:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c0102712:	39 c2                	cmp    %eax,%edx
c0102714:	74 24                	je     c010273a <pgfault_handler+0x56>
c0102716:	c7 44 24 0c eb c3 10 	movl   $0xc010c3eb,0xc(%esp)
c010271d:	c0 
c010271e:	c7 44 24 08 ff c3 10 	movl   $0xc010c3ff,0x8(%esp)
c0102725:	c0 
c0102726:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c010272d:	00 
c010272e:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c0102735:	e8 9b e6 ff ff       	call   c0100dd5 <__panic>
        mm = check_mm_struct;
c010273a:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102742:	eb 46                	jmp    c010278a <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c0102744:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102749:	85 c0                	test   %eax,%eax
c010274b:	75 32                	jne    c010277f <pgfault_handler+0x9b>
            print_trapframe(tf);
c010274d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102750:	89 04 24             	mov    %eax,(%esp)
c0102753:	e8 93 fc ff ff       	call   c01023eb <print_trapframe>
            print_pgfault(tf);
c0102758:	8b 45 08             	mov    0x8(%ebp),%eax
c010275b:	89 04 24             	mov    %eax,(%esp)
c010275e:	e8 04 ff ff ff       	call   c0102667 <print_pgfault>
            panic("unhandled page fault.\n");
c0102763:	c7 44 24 08 14 c4 10 	movl   $0xc010c414,0x8(%esp)
c010276a:	c0 
c010276b:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102772:	00 
c0102773:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c010277a:	e8 56 e6 ff ff       	call   c0100dd5 <__panic>
        }
        mm = current->mm;
c010277f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102784:	8b 40 18             	mov    0x18(%eax),%eax
c0102787:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010278a:	0f 20 d0             	mov    %cr2,%eax
c010278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c0102790:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c0102793:	89 c2                	mov    %eax,%edx
c0102795:	8b 45 08             	mov    0x8(%ebp),%eax
c0102798:	8b 40 34             	mov    0x34(%eax),%eax
c010279b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010279f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027a6:	89 04 24             	mov    %eax,(%esp)
c01027a9:	e8 d1 64 00 00       	call   c0108c7f <do_pgfault>
}
c01027ae:	c9                   	leave  
c01027af:	c3                   	ret    

c01027b0 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01027b0:	55                   	push   %ebp
c01027b1:	89 e5                	mov    %esp,%ebp
c01027b3:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c01027b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c01027bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c0:	8b 40 30             	mov    0x30(%eax),%eax
c01027c3:	83 f8 2f             	cmp    $0x2f,%eax
c01027c6:	77 38                	ja     c0102800 <trap_dispatch+0x50>
c01027c8:	83 f8 2e             	cmp    $0x2e,%eax
c01027cb:	0f 83 c3 01 00 00    	jae    c0102994 <trap_dispatch+0x1e4>
c01027d1:	83 f8 20             	cmp    $0x20,%eax
c01027d4:	0f 84 bd 01 00 00    	je     c0102997 <trap_dispatch+0x1e7>
c01027da:	83 f8 20             	cmp    $0x20,%eax
c01027dd:	77 0a                	ja     c01027e9 <trap_dispatch+0x39>
c01027df:	83 f8 0e             	cmp    $0xe,%eax
c01027e2:	74 3e                	je     c0102822 <trap_dispatch+0x72>
c01027e4:	e9 63 01 00 00       	jmp    c010294c <trap_dispatch+0x19c>
c01027e9:	83 f8 21             	cmp    $0x21,%eax
c01027ec:	0f 84 18 01 00 00    	je     c010290a <trap_dispatch+0x15a>
c01027f2:	83 f8 24             	cmp    $0x24,%eax
c01027f5:	0f 84 e6 00 00 00    	je     c01028e1 <trap_dispatch+0x131>
c01027fb:	e9 4c 01 00 00       	jmp    c010294c <trap_dispatch+0x19c>
c0102800:	83 f8 78             	cmp    $0x78,%eax
c0102803:	0f 82 43 01 00 00    	jb     c010294c <trap_dispatch+0x19c>
c0102809:	83 f8 79             	cmp    $0x79,%eax
c010280c:	0f 86 1e 01 00 00    	jbe    c0102930 <trap_dispatch+0x180>
c0102812:	3d 80 00 00 00       	cmp    $0x80,%eax
c0102817:	0f 84 ba 00 00 00    	je     c01028d7 <trap_dispatch+0x127>
c010281d:	e9 2a 01 00 00       	jmp    c010294c <trap_dispatch+0x19c>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102822:	8b 45 08             	mov    0x8(%ebp),%eax
c0102825:	89 04 24             	mov    %eax,(%esp)
c0102828:	e8 b7 fe ff ff       	call   c01026e4 <pgfault_handler>
c010282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102834:	0f 84 98 00 00 00    	je     c01028d2 <trap_dispatch+0x122>
            print_trapframe(tf);
c010283a:	8b 45 08             	mov    0x8(%ebp),%eax
c010283d:	89 04 24             	mov    %eax,(%esp)
c0102840:	e8 a6 fb ff ff       	call   c01023eb <print_trapframe>
            if (current == NULL) {
c0102845:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010284a:	85 c0                	test   %eax,%eax
c010284c:	75 23                	jne    c0102871 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c010284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102851:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102855:	c7 44 24 08 2c c4 10 	movl   $0xc010c42c,0x8(%esp)
c010285c:	c0 
c010285d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102864:	00 
c0102865:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c010286c:	e8 64 e5 ff ff       	call   c0100dd5 <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c0102871:	8b 45 08             	mov    0x8(%ebp),%eax
c0102874:	89 04 24             	mov    %eax,(%esp)
c0102877:	e8 59 fb ff ff       	call   c01023d5 <trap_in_kernel>
c010287c:	85 c0                	test   %eax,%eax
c010287e:	74 23                	je     c01028a3 <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102883:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102887:	c7 44 24 08 4c c4 10 	movl   $0xc010c44c,0x8(%esp)
c010288e:	c0 
c010288f:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0102896:	00 
c0102897:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c010289e:	e8 32 e5 ff ff       	call   c0100dd5 <__panic>
                }
                cprintf("killed by kernel.\n");
c01028a3:	c7 04 24 7a c4 10 c0 	movl   $0xc010c47a,(%esp)
c01028aa:	e8 a4 da ff ff       	call   c0100353 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c01028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01028b6:	c7 44 24 08 90 c4 10 	movl   $0xc010c490,0x8(%esp)
c01028bd:	c0 
c01028be:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01028c5:	00 
c01028c6:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c01028cd:	e8 03 e5 ff ff       	call   c0100dd5 <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c01028d2:	e9 c1 00 00 00       	jmp    c0102998 <trap_dispatch+0x1e8>
    case T_SYSCALL:
        syscall();
c01028d7:	e8 90 87 00 00       	call   c010b06c <syscall>
        break;
c01028dc:	e9 b7 00 00 00       	jmp    c0102998 <trap_dispatch+0x1e8>
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
  
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01028e1:	e8 5d ee ff ff       	call   c0101743 <cons_getc>
c01028e6:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01028e9:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028ed:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028f9:	c7 04 24 b9 c4 10 c0 	movl   $0xc010c4b9,(%esp)
c0102900:	e8 4e da ff ff       	call   c0100353 <cprintf>
        break;
c0102905:	e9 8e 00 00 00       	jmp    c0102998 <trap_dispatch+0x1e8>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010290a:	e8 34 ee ff ff       	call   c0101743 <cons_getc>
c010290f:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102912:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102916:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010291a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010291e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102922:	c7 04 24 cb c4 10 c0 	movl   $0xc010c4cb,(%esp)
c0102929:	e8 25 da ff ff       	call   c0100353 <cprintf>
        break;
c010292e:	eb 68                	jmp    c0102998 <trap_dispatch+0x1e8>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102930:	c7 44 24 08 da c4 10 	movl   $0xc010c4da,0x8(%esp)
c0102937:	c0 
c0102938:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010293f:	00 
c0102940:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c0102947:	e8 89 e4 ff ff       	call   c0100dd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c010294c:	8b 45 08             	mov    0x8(%ebp),%eax
c010294f:	89 04 24             	mov    %eax,(%esp)
c0102952:	e8 94 fa ff ff       	call   c01023eb <print_trapframe>
        if (current != NULL) {
c0102957:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010295c:	85 c0                	test   %eax,%eax
c010295e:	74 18                	je     c0102978 <trap_dispatch+0x1c8>
            cprintf("unhandled trap.\n");
c0102960:	c7 04 24 ea c4 10 c0 	movl   $0xc010c4ea,(%esp)
c0102967:	e8 e7 d9 ff ff       	call   c0100353 <cprintf>
            do_exit(-E_KILLED);
c010296c:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102973:	e8 97 74 00 00       	call   c0109e0f <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102978:	c7 44 24 08 fb c4 10 	movl   $0xc010c4fb,0x8(%esp)
c010297f:	c0 
c0102980:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0102987:	00 
c0102988:	c7 04 24 ee c1 10 c0 	movl   $0xc010c1ee,(%esp)
c010298f:	e8 41 e4 ff ff       	call   c0100dd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102994:	90                   	nop
c0102995:	eb 01                	jmp    c0102998 <trap_dispatch+0x1e8>
        /* LAB5 YOUR CODE */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
  
        break;
c0102997:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c0102998:	c9                   	leave  
c0102999:	c3                   	ret    

c010299a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010299a:	55                   	push   %ebp
c010299b:	89 e5                	mov    %esp,%ebp
c010299d:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c01029a0:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029a5:	85 c0                	test   %eax,%eax
c01029a7:	75 0d                	jne    c01029b6 <trap+0x1c>
        trap_dispatch(tf);
c01029a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ac:	89 04 24             	mov    %eax,(%esp)
c01029af:	e8 fc fd ff ff       	call   c01027b0 <trap_dispatch>
c01029b4:	eb 6c                	jmp    c0102a22 <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c01029b6:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029bb:	8b 40 3c             	mov    0x3c(%eax),%eax
c01029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c01029c1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01029c9:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c01029cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01029cf:	89 04 24             	mov    %eax,(%esp)
c01029d2:	e8 fe f9 ff ff       	call   c01023d5 <trap_in_kernel>
c01029d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c01029da:	8b 45 08             	mov    0x8(%ebp),%eax
c01029dd:	89 04 24             	mov    %eax,(%esp)
c01029e0:	e8 cb fd ff ff       	call   c01027b0 <trap_dispatch>
    
        current->tf = otf;
c01029e5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01029ed:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c01029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01029f4:	75 2c                	jne    c0102a22 <trap+0x88>
            if (current->flags & PF_EXITING) {
c01029f6:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029fb:	8b 40 44             	mov    0x44(%eax),%eax
c01029fe:	83 e0 01             	and    $0x1,%eax
c0102a01:	85 c0                	test   %eax,%eax
c0102a03:	74 0c                	je     c0102a11 <trap+0x77>
                do_exit(-E_KILLED);
c0102a05:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102a0c:	e8 fe 73 00 00       	call   c0109e0f <do_exit>
            }
            if (current->need_resched) {
c0102a11:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a16:	8b 40 10             	mov    0x10(%eax),%eax
c0102a19:	85 c0                	test   %eax,%eax
c0102a1b:	74 05                	je     c0102a22 <trap+0x88>
                schedule();
c0102a1d:	e8 52 84 00 00       	call   c010ae74 <schedule>
            }
        }
    }
}
c0102a22:	c9                   	leave  
c0102a23:	c3                   	ret    

c0102a24 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a24:	1e                   	push   %ds
    pushl %es
c0102a25:	06                   	push   %es
    pushl %fs
c0102a26:	0f a0                	push   %fs
    pushl %gs
c0102a28:	0f a8                	push   %gs
    pushal
c0102a2a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a2b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a30:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a32:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a34:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a35:	e8 60 ff ff ff       	call   c010299a <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a3a:	5c                   	pop    %esp

c0102a3b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a3b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a3c:	0f a9                	pop    %gs
    popl %fs
c0102a3e:	0f a1                	pop    %fs
    popl %es
c0102a40:	07                   	pop    %es
    popl %ds
c0102a41:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a42:	83 c4 08             	add    $0x8,%esp
    iret
c0102a45:	cf                   	iret   

c0102a46 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102a46:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102a4a:	e9 ec ff ff ff       	jmp    c0102a3b <__trapret>

c0102a4f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102a4f:	6a 00                	push   $0x0
  pushl $0
c0102a51:	6a 00                	push   $0x0
  jmp __alltraps
c0102a53:	e9 cc ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a58 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102a58:	6a 00                	push   $0x0
  pushl $1
c0102a5a:	6a 01                	push   $0x1
  jmp __alltraps
c0102a5c:	e9 c3 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a61 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102a61:	6a 00                	push   $0x0
  pushl $2
c0102a63:	6a 02                	push   $0x2
  jmp __alltraps
c0102a65:	e9 ba ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a6a <vector3>:
.globl vector3
vector3:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $3
c0102a6c:	6a 03                	push   $0x3
  jmp __alltraps
c0102a6e:	e9 b1 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a73 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102a73:	6a 00                	push   $0x0
  pushl $4
c0102a75:	6a 04                	push   $0x4
  jmp __alltraps
c0102a77:	e9 a8 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a7c <vector5>:
.globl vector5
vector5:
  pushl $0
c0102a7c:	6a 00                	push   $0x0
  pushl $5
c0102a7e:	6a 05                	push   $0x5
  jmp __alltraps
c0102a80:	e9 9f ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a85 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102a85:	6a 00                	push   $0x0
  pushl $6
c0102a87:	6a 06                	push   $0x6
  jmp __alltraps
c0102a89:	e9 96 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a8e <vector7>:
.globl vector7
vector7:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $7
c0102a90:	6a 07                	push   $0x7
  jmp __alltraps
c0102a92:	e9 8d ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a97 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102a97:	6a 08                	push   $0x8
  jmp __alltraps
c0102a99:	e9 86 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102a9e <vector9>:
.globl vector9
vector9:
  pushl $9
c0102a9e:	6a 09                	push   $0x9
  jmp __alltraps
c0102aa0:	e9 7f ff ff ff       	jmp    c0102a24 <__alltraps>

c0102aa5 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102aa5:	6a 0a                	push   $0xa
  jmp __alltraps
c0102aa7:	e9 78 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102aac <vector11>:
.globl vector11
vector11:
  pushl $11
c0102aac:	6a 0b                	push   $0xb
  jmp __alltraps
c0102aae:	e9 71 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ab3 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102ab3:	6a 0c                	push   $0xc
  jmp __alltraps
c0102ab5:	e9 6a ff ff ff       	jmp    c0102a24 <__alltraps>

c0102aba <vector13>:
.globl vector13
vector13:
  pushl $13
c0102aba:	6a 0d                	push   $0xd
  jmp __alltraps
c0102abc:	e9 63 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ac1 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102ac1:	6a 0e                	push   $0xe
  jmp __alltraps
c0102ac3:	e9 5c ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ac8 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102ac8:	6a 00                	push   $0x0
  pushl $15
c0102aca:	6a 0f                	push   $0xf
  jmp __alltraps
c0102acc:	e9 53 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ad1 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $16
c0102ad3:	6a 10                	push   $0x10
  jmp __alltraps
c0102ad5:	e9 4a ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ada <vector17>:
.globl vector17
vector17:
  pushl $17
c0102ada:	6a 11                	push   $0x11
  jmp __alltraps
c0102adc:	e9 43 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102ae1 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $18
c0102ae3:	6a 12                	push   $0x12
  jmp __alltraps
c0102ae5:	e9 3a ff ff ff       	jmp    c0102a24 <__alltraps>

c0102aea <vector19>:
.globl vector19
vector19:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $19
c0102aec:	6a 13                	push   $0x13
  jmp __alltraps
c0102aee:	e9 31 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102af3 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $20
c0102af5:	6a 14                	push   $0x14
  jmp __alltraps
c0102af7:	e9 28 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102afc <vector21>:
.globl vector21
vector21:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $21
c0102afe:	6a 15                	push   $0x15
  jmp __alltraps
c0102b00:	e9 1f ff ff ff       	jmp    c0102a24 <__alltraps>

c0102b05 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $22
c0102b07:	6a 16                	push   $0x16
  jmp __alltraps
c0102b09:	e9 16 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102b0e <vector23>:
.globl vector23
vector23:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $23
c0102b10:	6a 17                	push   $0x17
  jmp __alltraps
c0102b12:	e9 0d ff ff ff       	jmp    c0102a24 <__alltraps>

c0102b17 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $24
c0102b19:	6a 18                	push   $0x18
  jmp __alltraps
c0102b1b:	e9 04 ff ff ff       	jmp    c0102a24 <__alltraps>

c0102b20 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $25
c0102b22:	6a 19                	push   $0x19
  jmp __alltraps
c0102b24:	e9 fb fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b29 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $26
c0102b2b:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102b2d:	e9 f2 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b32 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $27
c0102b34:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102b36:	e9 e9 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b3b <vector28>:
.globl vector28
vector28:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $28
c0102b3d:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102b3f:	e9 e0 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b44 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $29
c0102b46:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102b48:	e9 d7 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b4d <vector30>:
.globl vector30
vector30:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $30
c0102b4f:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102b51:	e9 ce fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b56 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $31
c0102b58:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102b5a:	e9 c5 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b5f <vector32>:
.globl vector32
vector32:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $32
c0102b61:	6a 20                	push   $0x20
  jmp __alltraps
c0102b63:	e9 bc fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b68 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $33
c0102b6a:	6a 21                	push   $0x21
  jmp __alltraps
c0102b6c:	e9 b3 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b71 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $34
c0102b73:	6a 22                	push   $0x22
  jmp __alltraps
c0102b75:	e9 aa fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b7a <vector35>:
.globl vector35
vector35:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $35
c0102b7c:	6a 23                	push   $0x23
  jmp __alltraps
c0102b7e:	e9 a1 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b83 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $36
c0102b85:	6a 24                	push   $0x24
  jmp __alltraps
c0102b87:	e9 98 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b8c <vector37>:
.globl vector37
vector37:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $37
c0102b8e:	6a 25                	push   $0x25
  jmp __alltraps
c0102b90:	e9 8f fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b95 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $38
c0102b97:	6a 26                	push   $0x26
  jmp __alltraps
c0102b99:	e9 86 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102b9e <vector39>:
.globl vector39
vector39:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $39
c0102ba0:	6a 27                	push   $0x27
  jmp __alltraps
c0102ba2:	e9 7d fe ff ff       	jmp    c0102a24 <__alltraps>

c0102ba7 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $40
c0102ba9:	6a 28                	push   $0x28
  jmp __alltraps
c0102bab:	e9 74 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bb0 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $41
c0102bb2:	6a 29                	push   $0x29
  jmp __alltraps
c0102bb4:	e9 6b fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bb9 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $42
c0102bbb:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102bbd:	e9 62 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bc2 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $43
c0102bc4:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102bc6:	e9 59 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bcb <vector44>:
.globl vector44
vector44:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $44
c0102bcd:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102bcf:	e9 50 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bd4 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $45
c0102bd6:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102bd8:	e9 47 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bdd <vector46>:
.globl vector46
vector46:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $46
c0102bdf:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102be1:	e9 3e fe ff ff       	jmp    c0102a24 <__alltraps>

c0102be6 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $47
c0102be8:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102bea:	e9 35 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bef <vector48>:
.globl vector48
vector48:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $48
c0102bf1:	6a 30                	push   $0x30
  jmp __alltraps
c0102bf3:	e9 2c fe ff ff       	jmp    c0102a24 <__alltraps>

c0102bf8 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $49
c0102bfa:	6a 31                	push   $0x31
  jmp __alltraps
c0102bfc:	e9 23 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102c01 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $50
c0102c03:	6a 32                	push   $0x32
  jmp __alltraps
c0102c05:	e9 1a fe ff ff       	jmp    c0102a24 <__alltraps>

c0102c0a <vector51>:
.globl vector51
vector51:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $51
c0102c0c:	6a 33                	push   $0x33
  jmp __alltraps
c0102c0e:	e9 11 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102c13 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $52
c0102c15:	6a 34                	push   $0x34
  jmp __alltraps
c0102c17:	e9 08 fe ff ff       	jmp    c0102a24 <__alltraps>

c0102c1c <vector53>:
.globl vector53
vector53:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $53
c0102c1e:	6a 35                	push   $0x35
  jmp __alltraps
c0102c20:	e9 ff fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c25 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $54
c0102c27:	6a 36                	push   $0x36
  jmp __alltraps
c0102c29:	e9 f6 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c2e <vector55>:
.globl vector55
vector55:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $55
c0102c30:	6a 37                	push   $0x37
  jmp __alltraps
c0102c32:	e9 ed fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c37 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $56
c0102c39:	6a 38                	push   $0x38
  jmp __alltraps
c0102c3b:	e9 e4 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c40 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $57
c0102c42:	6a 39                	push   $0x39
  jmp __alltraps
c0102c44:	e9 db fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c49 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $58
c0102c4b:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102c4d:	e9 d2 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c52 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $59
c0102c54:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102c56:	e9 c9 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c5b <vector60>:
.globl vector60
vector60:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $60
c0102c5d:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102c5f:	e9 c0 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c64 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $61
c0102c66:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102c68:	e9 b7 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c6d <vector62>:
.globl vector62
vector62:
  pushl $0
c0102c6d:	6a 00                	push   $0x0
  pushl $62
c0102c6f:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102c71:	e9 ae fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c76 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102c76:	6a 00                	push   $0x0
  pushl $63
c0102c78:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102c7a:	e9 a5 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c7f <vector64>:
.globl vector64
vector64:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $64
c0102c81:	6a 40                	push   $0x40
  jmp __alltraps
c0102c83:	e9 9c fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c88 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $65
c0102c8a:	6a 41                	push   $0x41
  jmp __alltraps
c0102c8c:	e9 93 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c91 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102c91:	6a 00                	push   $0x0
  pushl $66
c0102c93:	6a 42                	push   $0x42
  jmp __alltraps
c0102c95:	e9 8a fd ff ff       	jmp    c0102a24 <__alltraps>

c0102c9a <vector67>:
.globl vector67
vector67:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $67
c0102c9c:	6a 43                	push   $0x43
  jmp __alltraps
c0102c9e:	e9 81 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102ca3 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $68
c0102ca5:	6a 44                	push   $0x44
  jmp __alltraps
c0102ca7:	e9 78 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cac <vector69>:
.globl vector69
vector69:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $69
c0102cae:	6a 45                	push   $0x45
  jmp __alltraps
c0102cb0:	e9 6f fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cb5 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102cb5:	6a 00                	push   $0x0
  pushl $70
c0102cb7:	6a 46                	push   $0x46
  jmp __alltraps
c0102cb9:	e9 66 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cbe <vector71>:
.globl vector71
vector71:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $71
c0102cc0:	6a 47                	push   $0x47
  jmp __alltraps
c0102cc2:	e9 5d fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cc7 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $72
c0102cc9:	6a 48                	push   $0x48
  jmp __alltraps
c0102ccb:	e9 54 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cd0 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $73
c0102cd2:	6a 49                	push   $0x49
  jmp __alltraps
c0102cd4:	e9 4b fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cd9 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102cd9:	6a 00                	push   $0x0
  pushl $74
c0102cdb:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102cdd:	e9 42 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102ce2 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $75
c0102ce4:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ce6:	e9 39 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102ceb <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $76
c0102ced:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102cef:	e9 30 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cf4 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $77
c0102cf6:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102cf8:	e9 27 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102cfd <vector78>:
.globl vector78
vector78:
  pushl $0
c0102cfd:	6a 00                	push   $0x0
  pushl $78
c0102cff:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102d01:	e9 1e fd ff ff       	jmp    c0102a24 <__alltraps>

c0102d06 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $79
c0102d08:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102d0a:	e9 15 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102d0f <vector80>:
.globl vector80
vector80:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $80
c0102d11:	6a 50                	push   $0x50
  jmp __alltraps
c0102d13:	e9 0c fd ff ff       	jmp    c0102a24 <__alltraps>

c0102d18 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $81
c0102d1a:	6a 51                	push   $0x51
  jmp __alltraps
c0102d1c:	e9 03 fd ff ff       	jmp    c0102a24 <__alltraps>

c0102d21 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102d21:	6a 00                	push   $0x0
  pushl $82
c0102d23:	6a 52                	push   $0x52
  jmp __alltraps
c0102d25:	e9 fa fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d2a <vector83>:
.globl vector83
vector83:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $83
c0102d2c:	6a 53                	push   $0x53
  jmp __alltraps
c0102d2e:	e9 f1 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d33 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102d33:	6a 00                	push   $0x0
  pushl $84
c0102d35:	6a 54                	push   $0x54
  jmp __alltraps
c0102d37:	e9 e8 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d3c <vector85>:
.globl vector85
vector85:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $85
c0102d3e:	6a 55                	push   $0x55
  jmp __alltraps
c0102d40:	e9 df fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d45 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102d45:	6a 00                	push   $0x0
  pushl $86
c0102d47:	6a 56                	push   $0x56
  jmp __alltraps
c0102d49:	e9 d6 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d4e <vector87>:
.globl vector87
vector87:
  pushl $0
c0102d4e:	6a 00                	push   $0x0
  pushl $87
c0102d50:	6a 57                	push   $0x57
  jmp __alltraps
c0102d52:	e9 cd fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d57 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102d57:	6a 00                	push   $0x0
  pushl $88
c0102d59:	6a 58                	push   $0x58
  jmp __alltraps
c0102d5b:	e9 c4 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d60 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $89
c0102d62:	6a 59                	push   $0x59
  jmp __alltraps
c0102d64:	e9 bb fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d69 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102d69:	6a 00                	push   $0x0
  pushl $90
c0102d6b:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102d6d:	e9 b2 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d72 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102d72:	6a 00                	push   $0x0
  pushl $91
c0102d74:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102d76:	e9 a9 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d7b <vector92>:
.globl vector92
vector92:
  pushl $0
c0102d7b:	6a 00                	push   $0x0
  pushl $92
c0102d7d:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102d7f:	e9 a0 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d84 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $93
c0102d86:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102d88:	e9 97 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d8d <vector94>:
.globl vector94
vector94:
  pushl $0
c0102d8d:	6a 00                	push   $0x0
  pushl $94
c0102d8f:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102d91:	e9 8e fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d96 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102d96:	6a 00                	push   $0x0
  pushl $95
c0102d98:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102d9a:	e9 85 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102d9f <vector96>:
.globl vector96
vector96:
  pushl $0
c0102d9f:	6a 00                	push   $0x0
  pushl $96
c0102da1:	6a 60                	push   $0x60
  jmp __alltraps
c0102da3:	e9 7c fc ff ff       	jmp    c0102a24 <__alltraps>

c0102da8 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $97
c0102daa:	6a 61                	push   $0x61
  jmp __alltraps
c0102dac:	e9 73 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102db1 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102db1:	6a 00                	push   $0x0
  pushl $98
c0102db3:	6a 62                	push   $0x62
  jmp __alltraps
c0102db5:	e9 6a fc ff ff       	jmp    c0102a24 <__alltraps>

c0102dba <vector99>:
.globl vector99
vector99:
  pushl $0
c0102dba:	6a 00                	push   $0x0
  pushl $99
c0102dbc:	6a 63                	push   $0x63
  jmp __alltraps
c0102dbe:	e9 61 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102dc3 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102dc3:	6a 00                	push   $0x0
  pushl $100
c0102dc5:	6a 64                	push   $0x64
  jmp __alltraps
c0102dc7:	e9 58 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102dcc <vector101>:
.globl vector101
vector101:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $101
c0102dce:	6a 65                	push   $0x65
  jmp __alltraps
c0102dd0:	e9 4f fc ff ff       	jmp    c0102a24 <__alltraps>

c0102dd5 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102dd5:	6a 00                	push   $0x0
  pushl $102
c0102dd7:	6a 66                	push   $0x66
  jmp __alltraps
c0102dd9:	e9 46 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102dde <vector103>:
.globl vector103
vector103:
  pushl $0
c0102dde:	6a 00                	push   $0x0
  pushl $103
c0102de0:	6a 67                	push   $0x67
  jmp __alltraps
c0102de2:	e9 3d fc ff ff       	jmp    c0102a24 <__alltraps>

c0102de7 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102de7:	6a 00                	push   $0x0
  pushl $104
c0102de9:	6a 68                	push   $0x68
  jmp __alltraps
c0102deb:	e9 34 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102df0 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $105
c0102df2:	6a 69                	push   $0x69
  jmp __alltraps
c0102df4:	e9 2b fc ff ff       	jmp    c0102a24 <__alltraps>

c0102df9 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102df9:	6a 00                	push   $0x0
  pushl $106
c0102dfb:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102dfd:	e9 22 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102e02 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102e02:	6a 00                	push   $0x0
  pushl $107
c0102e04:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102e06:	e9 19 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102e0b <vector108>:
.globl vector108
vector108:
  pushl $0
c0102e0b:	6a 00                	push   $0x0
  pushl $108
c0102e0d:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102e0f:	e9 10 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102e14 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $109
c0102e16:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102e18:	e9 07 fc ff ff       	jmp    c0102a24 <__alltraps>

c0102e1d <vector110>:
.globl vector110
vector110:
  pushl $0
c0102e1d:	6a 00                	push   $0x0
  pushl $110
c0102e1f:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102e21:	e9 fe fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e26 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102e26:	6a 00                	push   $0x0
  pushl $111
c0102e28:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102e2a:	e9 f5 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e2f <vector112>:
.globl vector112
vector112:
  pushl $0
c0102e2f:	6a 00                	push   $0x0
  pushl $112
c0102e31:	6a 70                	push   $0x70
  jmp __alltraps
c0102e33:	e9 ec fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e38 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $113
c0102e3a:	6a 71                	push   $0x71
  jmp __alltraps
c0102e3c:	e9 e3 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e41 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102e41:	6a 00                	push   $0x0
  pushl $114
c0102e43:	6a 72                	push   $0x72
  jmp __alltraps
c0102e45:	e9 da fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e4a <vector115>:
.globl vector115
vector115:
  pushl $0
c0102e4a:	6a 00                	push   $0x0
  pushl $115
c0102e4c:	6a 73                	push   $0x73
  jmp __alltraps
c0102e4e:	e9 d1 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e53 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102e53:	6a 00                	push   $0x0
  pushl $116
c0102e55:	6a 74                	push   $0x74
  jmp __alltraps
c0102e57:	e9 c8 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e5c <vector117>:
.globl vector117
vector117:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $117
c0102e5e:	6a 75                	push   $0x75
  jmp __alltraps
c0102e60:	e9 bf fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e65 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102e65:	6a 00                	push   $0x0
  pushl $118
c0102e67:	6a 76                	push   $0x76
  jmp __alltraps
c0102e69:	e9 b6 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e6e <vector119>:
.globl vector119
vector119:
  pushl $0
c0102e6e:	6a 00                	push   $0x0
  pushl $119
c0102e70:	6a 77                	push   $0x77
  jmp __alltraps
c0102e72:	e9 ad fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e77 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102e77:	6a 00                	push   $0x0
  pushl $120
c0102e79:	6a 78                	push   $0x78
  jmp __alltraps
c0102e7b:	e9 a4 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e80 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $121
c0102e82:	6a 79                	push   $0x79
  jmp __alltraps
c0102e84:	e9 9b fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e89 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102e89:	6a 00                	push   $0x0
  pushl $122
c0102e8b:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102e8d:	e9 92 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e92 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102e92:	6a 00                	push   $0x0
  pushl $123
c0102e94:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102e96:	e9 89 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102e9b <vector124>:
.globl vector124
vector124:
  pushl $0
c0102e9b:	6a 00                	push   $0x0
  pushl $124
c0102e9d:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102e9f:	e9 80 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ea4 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $125
c0102ea6:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102ea8:	e9 77 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ead <vector126>:
.globl vector126
vector126:
  pushl $0
c0102ead:	6a 00                	push   $0x0
  pushl $126
c0102eaf:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102eb1:	e9 6e fb ff ff       	jmp    c0102a24 <__alltraps>

c0102eb6 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102eb6:	6a 00                	push   $0x0
  pushl $127
c0102eb8:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102eba:	e9 65 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ebf <vector128>:
.globl vector128
vector128:
  pushl $0
c0102ebf:	6a 00                	push   $0x0
  pushl $128
c0102ec1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102ec6:	e9 59 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ecb <vector129>:
.globl vector129
vector129:
  pushl $0
c0102ecb:	6a 00                	push   $0x0
  pushl $129
c0102ecd:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102ed2:	e9 4d fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ed7 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102ed7:	6a 00                	push   $0x0
  pushl $130
c0102ed9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102ede:	e9 41 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102ee3 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102ee3:	6a 00                	push   $0x0
  pushl $131
c0102ee5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102eea:	e9 35 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102eef <vector132>:
.globl vector132
vector132:
  pushl $0
c0102eef:	6a 00                	push   $0x0
  pushl $132
c0102ef1:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102ef6:	e9 29 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102efb <vector133>:
.globl vector133
vector133:
  pushl $0
c0102efb:	6a 00                	push   $0x0
  pushl $133
c0102efd:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102f02:	e9 1d fb ff ff       	jmp    c0102a24 <__alltraps>

c0102f07 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102f07:	6a 00                	push   $0x0
  pushl $134
c0102f09:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102f0e:	e9 11 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102f13 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102f13:	6a 00                	push   $0x0
  pushl $135
c0102f15:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102f1a:	e9 05 fb ff ff       	jmp    c0102a24 <__alltraps>

c0102f1f <vector136>:
.globl vector136
vector136:
  pushl $0
c0102f1f:	6a 00                	push   $0x0
  pushl $136
c0102f21:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102f26:	e9 f9 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f2b <vector137>:
.globl vector137
vector137:
  pushl $0
c0102f2b:	6a 00                	push   $0x0
  pushl $137
c0102f2d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102f32:	e9 ed fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f37 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102f37:	6a 00                	push   $0x0
  pushl $138
c0102f39:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102f3e:	e9 e1 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f43 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102f43:	6a 00                	push   $0x0
  pushl $139
c0102f45:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102f4a:	e9 d5 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f4f <vector140>:
.globl vector140
vector140:
  pushl $0
c0102f4f:	6a 00                	push   $0x0
  pushl $140
c0102f51:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102f56:	e9 c9 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f5b <vector141>:
.globl vector141
vector141:
  pushl $0
c0102f5b:	6a 00                	push   $0x0
  pushl $141
c0102f5d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102f62:	e9 bd fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f67 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102f67:	6a 00                	push   $0x0
  pushl $142
c0102f69:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102f6e:	e9 b1 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f73 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102f73:	6a 00                	push   $0x0
  pushl $143
c0102f75:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102f7a:	e9 a5 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f7f <vector144>:
.globl vector144
vector144:
  pushl $0
c0102f7f:	6a 00                	push   $0x0
  pushl $144
c0102f81:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102f86:	e9 99 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f8b <vector145>:
.globl vector145
vector145:
  pushl $0
c0102f8b:	6a 00                	push   $0x0
  pushl $145
c0102f8d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102f92:	e9 8d fa ff ff       	jmp    c0102a24 <__alltraps>

c0102f97 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102f97:	6a 00                	push   $0x0
  pushl $146
c0102f99:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102f9e:	e9 81 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102fa3 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102fa3:	6a 00                	push   $0x0
  pushl $147
c0102fa5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102faa:	e9 75 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102faf <vector148>:
.globl vector148
vector148:
  pushl $0
c0102faf:	6a 00                	push   $0x0
  pushl $148
c0102fb1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102fb6:	e9 69 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102fbb <vector149>:
.globl vector149
vector149:
  pushl $0
c0102fbb:	6a 00                	push   $0x0
  pushl $149
c0102fbd:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102fc2:	e9 5d fa ff ff       	jmp    c0102a24 <__alltraps>

c0102fc7 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102fc7:	6a 00                	push   $0x0
  pushl $150
c0102fc9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102fce:	e9 51 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102fd3 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102fd3:	6a 00                	push   $0x0
  pushl $151
c0102fd5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102fda:	e9 45 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102fdf <vector152>:
.globl vector152
vector152:
  pushl $0
c0102fdf:	6a 00                	push   $0x0
  pushl $152
c0102fe1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102fe6:	e9 39 fa ff ff       	jmp    c0102a24 <__alltraps>

c0102feb <vector153>:
.globl vector153
vector153:
  pushl $0
c0102feb:	6a 00                	push   $0x0
  pushl $153
c0102fed:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102ff2:	e9 2d fa ff ff       	jmp    c0102a24 <__alltraps>

c0102ff7 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102ff7:	6a 00                	push   $0x0
  pushl $154
c0102ff9:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102ffe:	e9 21 fa ff ff       	jmp    c0102a24 <__alltraps>

c0103003 <vector155>:
.globl vector155
vector155:
  pushl $0
c0103003:	6a 00                	push   $0x0
  pushl $155
c0103005:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010300a:	e9 15 fa ff ff       	jmp    c0102a24 <__alltraps>

c010300f <vector156>:
.globl vector156
vector156:
  pushl $0
c010300f:	6a 00                	push   $0x0
  pushl $156
c0103011:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0103016:	e9 09 fa ff ff       	jmp    c0102a24 <__alltraps>

c010301b <vector157>:
.globl vector157
vector157:
  pushl $0
c010301b:	6a 00                	push   $0x0
  pushl $157
c010301d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0103022:	e9 fd f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103027 <vector158>:
.globl vector158
vector158:
  pushl $0
c0103027:	6a 00                	push   $0x0
  pushl $158
c0103029:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010302e:	e9 f1 f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103033 <vector159>:
.globl vector159
vector159:
  pushl $0
c0103033:	6a 00                	push   $0x0
  pushl $159
c0103035:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010303a:	e9 e5 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010303f <vector160>:
.globl vector160
vector160:
  pushl $0
c010303f:	6a 00                	push   $0x0
  pushl $160
c0103041:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0103046:	e9 d9 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010304b <vector161>:
.globl vector161
vector161:
  pushl $0
c010304b:	6a 00                	push   $0x0
  pushl $161
c010304d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0103052:	e9 cd f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103057 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103057:	6a 00                	push   $0x0
  pushl $162
c0103059:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010305e:	e9 c1 f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103063 <vector163>:
.globl vector163
vector163:
  pushl $0
c0103063:	6a 00                	push   $0x0
  pushl $163
c0103065:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010306a:	e9 b5 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010306f <vector164>:
.globl vector164
vector164:
  pushl $0
c010306f:	6a 00                	push   $0x0
  pushl $164
c0103071:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0103076:	e9 a9 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010307b <vector165>:
.globl vector165
vector165:
  pushl $0
c010307b:	6a 00                	push   $0x0
  pushl $165
c010307d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0103082:	e9 9d f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103087 <vector166>:
.globl vector166
vector166:
  pushl $0
c0103087:	6a 00                	push   $0x0
  pushl $166
c0103089:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010308e:	e9 91 f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103093 <vector167>:
.globl vector167
vector167:
  pushl $0
c0103093:	6a 00                	push   $0x0
  pushl $167
c0103095:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010309a:	e9 85 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010309f <vector168>:
.globl vector168
vector168:
  pushl $0
c010309f:	6a 00                	push   $0x0
  pushl $168
c01030a1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01030a6:	e9 79 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030ab <vector169>:
.globl vector169
vector169:
  pushl $0
c01030ab:	6a 00                	push   $0x0
  pushl $169
c01030ad:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01030b2:	e9 6d f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030b7 <vector170>:
.globl vector170
vector170:
  pushl $0
c01030b7:	6a 00                	push   $0x0
  pushl $170
c01030b9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01030be:	e9 61 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030c3 <vector171>:
.globl vector171
vector171:
  pushl $0
c01030c3:	6a 00                	push   $0x0
  pushl $171
c01030c5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01030ca:	e9 55 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030cf <vector172>:
.globl vector172
vector172:
  pushl $0
c01030cf:	6a 00                	push   $0x0
  pushl $172
c01030d1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01030d6:	e9 49 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030db <vector173>:
.globl vector173
vector173:
  pushl $0
c01030db:	6a 00                	push   $0x0
  pushl $173
c01030dd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01030e2:	e9 3d f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030e7 <vector174>:
.globl vector174
vector174:
  pushl $0
c01030e7:	6a 00                	push   $0x0
  pushl $174
c01030e9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01030ee:	e9 31 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030f3 <vector175>:
.globl vector175
vector175:
  pushl $0
c01030f3:	6a 00                	push   $0x0
  pushl $175
c01030f5:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01030fa:	e9 25 f9 ff ff       	jmp    c0102a24 <__alltraps>

c01030ff <vector176>:
.globl vector176
vector176:
  pushl $0
c01030ff:	6a 00                	push   $0x0
  pushl $176
c0103101:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0103106:	e9 19 f9 ff ff       	jmp    c0102a24 <__alltraps>

c010310b <vector177>:
.globl vector177
vector177:
  pushl $0
c010310b:	6a 00                	push   $0x0
  pushl $177
c010310d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0103112:	e9 0d f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103117 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103117:	6a 00                	push   $0x0
  pushl $178
c0103119:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010311e:	e9 01 f9 ff ff       	jmp    c0102a24 <__alltraps>

c0103123 <vector179>:
.globl vector179
vector179:
  pushl $0
c0103123:	6a 00                	push   $0x0
  pushl $179
c0103125:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010312a:	e9 f5 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010312f <vector180>:
.globl vector180
vector180:
  pushl $0
c010312f:	6a 00                	push   $0x0
  pushl $180
c0103131:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0103136:	e9 e9 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010313b <vector181>:
.globl vector181
vector181:
  pushl $0
c010313b:	6a 00                	push   $0x0
  pushl $181
c010313d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0103142:	e9 dd f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103147 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103147:	6a 00                	push   $0x0
  pushl $182
c0103149:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010314e:	e9 d1 f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103153 <vector183>:
.globl vector183
vector183:
  pushl $0
c0103153:	6a 00                	push   $0x0
  pushl $183
c0103155:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010315a:	e9 c5 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010315f <vector184>:
.globl vector184
vector184:
  pushl $0
c010315f:	6a 00                	push   $0x0
  pushl $184
c0103161:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0103166:	e9 b9 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010316b <vector185>:
.globl vector185
vector185:
  pushl $0
c010316b:	6a 00                	push   $0x0
  pushl $185
c010316d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0103172:	e9 ad f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103177 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103177:	6a 00                	push   $0x0
  pushl $186
c0103179:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010317e:	e9 a1 f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103183 <vector187>:
.globl vector187
vector187:
  pushl $0
c0103183:	6a 00                	push   $0x0
  pushl $187
c0103185:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010318a:	e9 95 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010318f <vector188>:
.globl vector188
vector188:
  pushl $0
c010318f:	6a 00                	push   $0x0
  pushl $188
c0103191:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0103196:	e9 89 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010319b <vector189>:
.globl vector189
vector189:
  pushl $0
c010319b:	6a 00                	push   $0x0
  pushl $189
c010319d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01031a2:	e9 7d f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031a7 <vector190>:
.globl vector190
vector190:
  pushl $0
c01031a7:	6a 00                	push   $0x0
  pushl $190
c01031a9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01031ae:	e9 71 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031b3 <vector191>:
.globl vector191
vector191:
  pushl $0
c01031b3:	6a 00                	push   $0x0
  pushl $191
c01031b5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01031ba:	e9 65 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031bf <vector192>:
.globl vector192
vector192:
  pushl $0
c01031bf:	6a 00                	push   $0x0
  pushl $192
c01031c1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01031c6:	e9 59 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031cb <vector193>:
.globl vector193
vector193:
  pushl $0
c01031cb:	6a 00                	push   $0x0
  pushl $193
c01031cd:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01031d2:	e9 4d f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031d7 <vector194>:
.globl vector194
vector194:
  pushl $0
c01031d7:	6a 00                	push   $0x0
  pushl $194
c01031d9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01031de:	e9 41 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031e3 <vector195>:
.globl vector195
vector195:
  pushl $0
c01031e3:	6a 00                	push   $0x0
  pushl $195
c01031e5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01031ea:	e9 35 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031ef <vector196>:
.globl vector196
vector196:
  pushl $0
c01031ef:	6a 00                	push   $0x0
  pushl $196
c01031f1:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01031f6:	e9 29 f8 ff ff       	jmp    c0102a24 <__alltraps>

c01031fb <vector197>:
.globl vector197
vector197:
  pushl $0
c01031fb:	6a 00                	push   $0x0
  pushl $197
c01031fd:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103202:	e9 1d f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103207 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103207:	6a 00                	push   $0x0
  pushl $198
c0103209:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010320e:	e9 11 f8 ff ff       	jmp    c0102a24 <__alltraps>

c0103213 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103213:	6a 00                	push   $0x0
  pushl $199
c0103215:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010321a:	e9 05 f8 ff ff       	jmp    c0102a24 <__alltraps>

c010321f <vector200>:
.globl vector200
vector200:
  pushl $0
c010321f:	6a 00                	push   $0x0
  pushl $200
c0103221:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103226:	e9 f9 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010322b <vector201>:
.globl vector201
vector201:
  pushl $0
c010322b:	6a 00                	push   $0x0
  pushl $201
c010322d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103232:	e9 ed f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103237 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103237:	6a 00                	push   $0x0
  pushl $202
c0103239:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010323e:	e9 e1 f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103243 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103243:	6a 00                	push   $0x0
  pushl $203
c0103245:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010324a:	e9 d5 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010324f <vector204>:
.globl vector204
vector204:
  pushl $0
c010324f:	6a 00                	push   $0x0
  pushl $204
c0103251:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103256:	e9 c9 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010325b <vector205>:
.globl vector205
vector205:
  pushl $0
c010325b:	6a 00                	push   $0x0
  pushl $205
c010325d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103262:	e9 bd f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103267 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103267:	6a 00                	push   $0x0
  pushl $206
c0103269:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010326e:	e9 b1 f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103273 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103273:	6a 00                	push   $0x0
  pushl $207
c0103275:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010327a:	e9 a5 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010327f <vector208>:
.globl vector208
vector208:
  pushl $0
c010327f:	6a 00                	push   $0x0
  pushl $208
c0103281:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103286:	e9 99 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010328b <vector209>:
.globl vector209
vector209:
  pushl $0
c010328b:	6a 00                	push   $0x0
  pushl $209
c010328d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103292:	e9 8d f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103297 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103297:	6a 00                	push   $0x0
  pushl $210
c0103299:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010329e:	e9 81 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032a3 <vector211>:
.globl vector211
vector211:
  pushl $0
c01032a3:	6a 00                	push   $0x0
  pushl $211
c01032a5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01032aa:	e9 75 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032af <vector212>:
.globl vector212
vector212:
  pushl $0
c01032af:	6a 00                	push   $0x0
  pushl $212
c01032b1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01032b6:	e9 69 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032bb <vector213>:
.globl vector213
vector213:
  pushl $0
c01032bb:	6a 00                	push   $0x0
  pushl $213
c01032bd:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01032c2:	e9 5d f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032c7 <vector214>:
.globl vector214
vector214:
  pushl $0
c01032c7:	6a 00                	push   $0x0
  pushl $214
c01032c9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01032ce:	e9 51 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032d3 <vector215>:
.globl vector215
vector215:
  pushl $0
c01032d3:	6a 00                	push   $0x0
  pushl $215
c01032d5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01032da:	e9 45 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032df <vector216>:
.globl vector216
vector216:
  pushl $0
c01032df:	6a 00                	push   $0x0
  pushl $216
c01032e1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01032e6:	e9 39 f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032eb <vector217>:
.globl vector217
vector217:
  pushl $0
c01032eb:	6a 00                	push   $0x0
  pushl $217
c01032ed:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01032f2:	e9 2d f7 ff ff       	jmp    c0102a24 <__alltraps>

c01032f7 <vector218>:
.globl vector218
vector218:
  pushl $0
c01032f7:	6a 00                	push   $0x0
  pushl $218
c01032f9:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01032fe:	e9 21 f7 ff ff       	jmp    c0102a24 <__alltraps>

c0103303 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103303:	6a 00                	push   $0x0
  pushl $219
c0103305:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010330a:	e9 15 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010330f <vector220>:
.globl vector220
vector220:
  pushl $0
c010330f:	6a 00                	push   $0x0
  pushl $220
c0103311:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103316:	e9 09 f7 ff ff       	jmp    c0102a24 <__alltraps>

c010331b <vector221>:
.globl vector221
vector221:
  pushl $0
c010331b:	6a 00                	push   $0x0
  pushl $221
c010331d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103322:	e9 fd f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103327 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103327:	6a 00                	push   $0x0
  pushl $222
c0103329:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010332e:	e9 f1 f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103333 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103333:	6a 00                	push   $0x0
  pushl $223
c0103335:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010333a:	e9 e5 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010333f <vector224>:
.globl vector224
vector224:
  pushl $0
c010333f:	6a 00                	push   $0x0
  pushl $224
c0103341:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103346:	e9 d9 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010334b <vector225>:
.globl vector225
vector225:
  pushl $0
c010334b:	6a 00                	push   $0x0
  pushl $225
c010334d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103352:	e9 cd f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103357 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103357:	6a 00                	push   $0x0
  pushl $226
c0103359:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010335e:	e9 c1 f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103363 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103363:	6a 00                	push   $0x0
  pushl $227
c0103365:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010336a:	e9 b5 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010336f <vector228>:
.globl vector228
vector228:
  pushl $0
c010336f:	6a 00                	push   $0x0
  pushl $228
c0103371:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103376:	e9 a9 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010337b <vector229>:
.globl vector229
vector229:
  pushl $0
c010337b:	6a 00                	push   $0x0
  pushl $229
c010337d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103382:	e9 9d f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103387 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103387:	6a 00                	push   $0x0
  pushl $230
c0103389:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010338e:	e9 91 f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103393 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103393:	6a 00                	push   $0x0
  pushl $231
c0103395:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010339a:	e9 85 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010339f <vector232>:
.globl vector232
vector232:
  pushl $0
c010339f:	6a 00                	push   $0x0
  pushl $232
c01033a1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01033a6:	e9 79 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033ab <vector233>:
.globl vector233
vector233:
  pushl $0
c01033ab:	6a 00                	push   $0x0
  pushl $233
c01033ad:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01033b2:	e9 6d f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033b7 <vector234>:
.globl vector234
vector234:
  pushl $0
c01033b7:	6a 00                	push   $0x0
  pushl $234
c01033b9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01033be:	e9 61 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033c3 <vector235>:
.globl vector235
vector235:
  pushl $0
c01033c3:	6a 00                	push   $0x0
  pushl $235
c01033c5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01033ca:	e9 55 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033cf <vector236>:
.globl vector236
vector236:
  pushl $0
c01033cf:	6a 00                	push   $0x0
  pushl $236
c01033d1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01033d6:	e9 49 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033db <vector237>:
.globl vector237
vector237:
  pushl $0
c01033db:	6a 00                	push   $0x0
  pushl $237
c01033dd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01033e2:	e9 3d f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033e7 <vector238>:
.globl vector238
vector238:
  pushl $0
c01033e7:	6a 00                	push   $0x0
  pushl $238
c01033e9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01033ee:	e9 31 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033f3 <vector239>:
.globl vector239
vector239:
  pushl $0
c01033f3:	6a 00                	push   $0x0
  pushl $239
c01033f5:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01033fa:	e9 25 f6 ff ff       	jmp    c0102a24 <__alltraps>

c01033ff <vector240>:
.globl vector240
vector240:
  pushl $0
c01033ff:	6a 00                	push   $0x0
  pushl $240
c0103401:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103406:	e9 19 f6 ff ff       	jmp    c0102a24 <__alltraps>

c010340b <vector241>:
.globl vector241
vector241:
  pushl $0
c010340b:	6a 00                	push   $0x0
  pushl $241
c010340d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103412:	e9 0d f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103417 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103417:	6a 00                	push   $0x0
  pushl $242
c0103419:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010341e:	e9 01 f6 ff ff       	jmp    c0102a24 <__alltraps>

c0103423 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103423:	6a 00                	push   $0x0
  pushl $243
c0103425:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010342a:	e9 f5 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010342f <vector244>:
.globl vector244
vector244:
  pushl $0
c010342f:	6a 00                	push   $0x0
  pushl $244
c0103431:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103436:	e9 e9 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010343b <vector245>:
.globl vector245
vector245:
  pushl $0
c010343b:	6a 00                	push   $0x0
  pushl $245
c010343d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103442:	e9 dd f5 ff ff       	jmp    c0102a24 <__alltraps>

c0103447 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103447:	6a 00                	push   $0x0
  pushl $246
c0103449:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010344e:	e9 d1 f5 ff ff       	jmp    c0102a24 <__alltraps>

c0103453 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103453:	6a 00                	push   $0x0
  pushl $247
c0103455:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010345a:	e9 c5 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010345f <vector248>:
.globl vector248
vector248:
  pushl $0
c010345f:	6a 00                	push   $0x0
  pushl $248
c0103461:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103466:	e9 b9 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010346b <vector249>:
.globl vector249
vector249:
  pushl $0
c010346b:	6a 00                	push   $0x0
  pushl $249
c010346d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103472:	e9 ad f5 ff ff       	jmp    c0102a24 <__alltraps>

c0103477 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103477:	6a 00                	push   $0x0
  pushl $250
c0103479:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010347e:	e9 a1 f5 ff ff       	jmp    c0102a24 <__alltraps>

c0103483 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103483:	6a 00                	push   $0x0
  pushl $251
c0103485:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010348a:	e9 95 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010348f <vector252>:
.globl vector252
vector252:
  pushl $0
c010348f:	6a 00                	push   $0x0
  pushl $252
c0103491:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103496:	e9 89 f5 ff ff       	jmp    c0102a24 <__alltraps>

c010349b <vector253>:
.globl vector253
vector253:
  pushl $0
c010349b:	6a 00                	push   $0x0
  pushl $253
c010349d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01034a2:	e9 7d f5 ff ff       	jmp    c0102a24 <__alltraps>

c01034a7 <vector254>:
.globl vector254
vector254:
  pushl $0
c01034a7:	6a 00                	push   $0x0
  pushl $254
c01034a9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01034ae:	e9 71 f5 ff ff       	jmp    c0102a24 <__alltraps>

c01034b3 <vector255>:
.globl vector255
vector255:
  pushl $0
c01034b3:	6a 00                	push   $0x0
  pushl $255
c01034b5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01034ba:	e9 65 f5 ff ff       	jmp    c0102a24 <__alltraps>

c01034bf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01034bf:	55                   	push   %ebp
c01034c0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01034c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01034c5:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01034ca:	29 c2                	sub    %eax,%edx
c01034cc:	89 d0                	mov    %edx,%eax
c01034ce:	c1 f8 05             	sar    $0x5,%eax
}
c01034d1:	5d                   	pop    %ebp
c01034d2:	c3                   	ret    

c01034d3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01034d3:	55                   	push   %ebp
c01034d4:	89 e5                	mov    %esp,%ebp
c01034d6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01034d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01034dc:	89 04 24             	mov    %eax,(%esp)
c01034df:	e8 db ff ff ff       	call   c01034bf <page2ppn>
c01034e4:	c1 e0 0c             	shl    $0xc,%eax
}
c01034e7:	c9                   	leave  
c01034e8:	c3                   	ret    

c01034e9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01034e9:	55                   	push   %ebp
c01034ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01034ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ef:	8b 00                	mov    (%eax),%eax
}
c01034f1:	5d                   	pop    %ebp
c01034f2:	c3                   	ret    

c01034f3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01034f3:	55                   	push   %ebp
c01034f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01034f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01034f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034fc:	89 10                	mov    %edx,(%eax)
}
c01034fe:	5d                   	pop    %ebp
c01034ff:	c3                   	ret    

c0103500 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103500:	55                   	push   %ebp
c0103501:	89 e5                	mov    %esp,%ebp
c0103503:	83 ec 10             	sub    $0x10,%esp
c0103506:	c7 45 fc b8 ef 19 c0 	movl   $0xc019efb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010350d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103510:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103513:	89 50 04             	mov    %edx,0x4(%eax)
c0103516:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103519:	8b 50 04             	mov    0x4(%eax),%edx
c010351c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010351f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103521:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103528:	00 00 00 
}
c010352b:	c9                   	leave  
c010352c:	c3                   	ret    

c010352d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010352d:	55                   	push   %ebp
c010352e:	89 e5                	mov    %esp,%ebp
c0103530:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103533:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103537:	75 24                	jne    c010355d <default_init_memmap+0x30>
c0103539:	c7 44 24 0c b0 c6 10 	movl   $0xc010c6b0,0xc(%esp)
c0103540:	c0 
c0103541:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103548:	c0 
c0103549:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103550:	00 
c0103551:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103558:	e8 78 d8 ff ff       	call   c0100dd5 <__panic>
    struct Page *p = base;
c010355d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103560:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103563:	e9 dc 00 00 00       	jmp    c0103644 <default_init_memmap+0x117>
        assert(PageReserved(p));
c0103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356b:	83 c0 04             	add    $0x4,%eax
c010356e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103575:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103578:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010357b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010357e:	0f a3 10             	bt     %edx,(%eax)
c0103581:	19 c0                	sbb    %eax,%eax
c0103583:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103586:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010358a:	0f 95 c0             	setne  %al
c010358d:	0f b6 c0             	movzbl %al,%eax
c0103590:	85 c0                	test   %eax,%eax
c0103592:	75 24                	jne    c01035b8 <default_init_memmap+0x8b>
c0103594:	c7 44 24 0c e1 c6 10 	movl   $0xc010c6e1,0xc(%esp)
c010359b:	c0 
c010359c:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01035a3:	c0 
c01035a4:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01035ab:	00 
c01035ac:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01035b3:	e8 1d d8 ff ff       	call   c0100dd5 <__panic>
        p->flags = 0;
c01035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c5:	83 c0 04             	add    $0x4,%eax
c01035c8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01035cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035d8:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01035e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01035ec:	00 
c01035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f0:	89 04 24             	mov    %eax,(%esp)
c01035f3:	e8 fb fe ff ff       	call   c01034f3 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fb:	83 c0 0c             	add    $0xc,%eax
c01035fe:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
c0103605:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103608:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010360b:	8b 00                	mov    (%eax),%eax
c010360d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103613:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103616:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103619:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010361c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010361f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103622:	89 10                	mov    %edx,(%eax)
c0103624:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103627:	8b 10                	mov    (%eax),%edx
c0103629:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010362c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103632:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103635:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010363b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010363e:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103640:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103644:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103647:	c1 e0 05             	shl    $0x5,%eax
c010364a:	89 c2                	mov    %eax,%edx
c010364c:	8b 45 08             	mov    0x8(%ebp),%eax
c010364f:	01 d0                	add    %edx,%eax
c0103651:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103654:	0f 85 0e ff ff ff    	jne    c0103568 <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c010365a:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103660:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103663:	01 d0                	add    %edx,%eax
c0103665:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
    //first block
    base->property = n;
c010366a:	8b 45 08             	mov    0x8(%ebp),%eax
c010366d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103670:	89 50 08             	mov    %edx,0x8(%eax)
}
c0103673:	c9                   	leave  
c0103674:	c3                   	ret    

c0103675 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103675:	55                   	push   %ebp
c0103676:	89 e5                	mov    %esp,%ebp
c0103678:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010367b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010367f:	75 24                	jne    c01036a5 <default_alloc_pages+0x30>
c0103681:	c7 44 24 0c b0 c6 10 	movl   $0xc010c6b0,0xc(%esp)
c0103688:	c0 
c0103689:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103690:	c0 
c0103691:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0103698:	00 
c0103699:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01036a0:	e8 30 d7 ff ff       	call   c0100dd5 <__panic>
    if (n > nr_free) {
c01036a5:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01036aa:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036ad:	73 0a                	jae    c01036b9 <default_alloc_pages+0x44>
        return NULL;
c01036af:	b8 00 00 00 00       	mov    $0x0,%eax
c01036b4:	e9 37 01 00 00       	jmp    c01037f0 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c01036b9:	c7 45 f4 b8 ef 19 c0 	movl   $0xc019efb8,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c01036c0:	e9 0a 01 00 00       	jmp    c01037cf <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c01036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c8:	83 e8 0c             	sub    $0xc,%eax
c01036cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c01036ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036d1:	8b 40 08             	mov    0x8(%eax),%eax
c01036d4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036d7:	0f 82 f2 00 00 00    	jb     c01037cf <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c01036dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01036e4:	eb 7c                	jmp    c0103762 <default_alloc_pages+0xed>
c01036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01036ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036ef:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c01036f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c01036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f8:	83 e8 0c             	sub    $0xc,%eax
c01036fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c01036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103701:	83 c0 04             	add    $0x4,%eax
c0103704:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010370b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010370e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103711:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103714:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c0103717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010371a:	83 c0 04             	add    $0x4,%eax
c010371d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103724:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010372a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010372d:	0f b3 10             	btr    %edx,(%eax)
c0103730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103733:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103736:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103739:	8b 40 04             	mov    0x4(%eax),%eax
c010373c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010373f:	8b 12                	mov    (%edx),%edx
c0103741:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103744:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103747:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010374a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010374d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103750:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103753:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103756:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c0103758:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010375b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c010375e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0103762:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103765:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103768:	0f 82 78 ff ff ff    	jb     c01036e6 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c010376e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103771:	8b 40 08             	mov    0x8(%eax),%eax
c0103774:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103777:	76 12                	jbe    c010378b <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c0103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377c:	8d 50 f4             	lea    -0xc(%eax),%edx
c010377f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103782:	8b 40 08             	mov    0x8(%eax),%eax
c0103785:	2b 45 08             	sub    0x8(%ebp),%eax
c0103788:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c010378b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010378e:	83 c0 04             	add    $0x4,%eax
c0103791:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103798:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010379b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010379e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01037a1:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c01037a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a7:	83 c0 04             	add    $0x4,%eax
c01037aa:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01037b1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037b4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01037b7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01037ba:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c01037bd:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01037c2:	2b 45 08             	sub    0x8(%ebp),%eax
c01037c5:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
        return p;
c01037ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037cd:	eb 21                	jmp    c01037f0 <default_alloc_pages+0x17b>
c01037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01037d8:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c01037db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037de:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c01037e5:	0f 85 da fe ff ff    	jne    c01036c5 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c01037eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01037f0:	c9                   	leave  
c01037f1:	c3                   	ret    

c01037f2 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01037f2:	55                   	push   %ebp
c01037f3:	89 e5                	mov    %esp,%ebp
c01037f5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01037f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01037fc:	75 24                	jne    c0103822 <default_free_pages+0x30>
c01037fe:	c7 44 24 0c b0 c6 10 	movl   $0xc010c6b0,0xc(%esp)
c0103805:	c0 
c0103806:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010380d:	c0 
c010380e:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0103815:	00 
c0103816:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010381d:	e8 b3 d5 ff ff       	call   c0100dd5 <__panic>
    assert(PageReserved(base));
c0103822:	8b 45 08             	mov    0x8(%ebp),%eax
c0103825:	83 c0 04             	add    $0x4,%eax
c0103828:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010382f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103832:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103835:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103838:	0f a3 10             	bt     %edx,(%eax)
c010383b:	19 c0                	sbb    %eax,%eax
c010383d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103840:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103844:	0f 95 c0             	setne  %al
c0103847:	0f b6 c0             	movzbl %al,%eax
c010384a:	85 c0                	test   %eax,%eax
c010384c:	75 24                	jne    c0103872 <default_free_pages+0x80>
c010384e:	c7 44 24 0c f1 c6 10 	movl   $0xc010c6f1,0xc(%esp)
c0103855:	c0 
c0103856:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010385d:	c0 
c010385e:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0103865:	00 
c0103866:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010386d:	e8 63 d5 ff ff       	call   c0100dd5 <__panic>

    list_entry_t *le = &free_list;
c0103872:	c7 45 f4 b8 ef 19 c0 	movl   $0xc019efb8,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0103879:	eb 13                	jmp    c010388e <default_free_pages+0x9c>
      p = le2page(le, page_link);
c010387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010387e:	83 e8 0c             	sub    $0xc,%eax
c0103881:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0103884:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103887:	3b 45 08             	cmp    0x8(%ebp),%eax
c010388a:	76 02                	jbe    c010388e <default_free_pages+0x9c>
        break;
c010388c:	eb 18                	jmp    c01038a6 <default_free_pages+0xb4>
c010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103891:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103894:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103897:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010389a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010389d:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c01038a4:	75 d5                	jne    c010387b <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01038a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038ac:	eb 4b                	jmp    c01038f9 <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c01038ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038b1:	8d 50 0c             	lea    0xc(%eax),%edx
c01038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01038ba:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01038bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038c0:	8b 00                	mov    (%eax),%eax
c01038c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01038c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01038c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01038cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01038d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01038d7:	89 10                	mov    %edx,(%eax)
c01038d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038dc:	8b 10                	mov    (%eax),%edx
c01038de:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01038e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01038ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01038ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038f0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01038f3:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01038f5:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c01038f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038fc:	c1 e0 05             	shl    $0x5,%eax
c01038ff:	89 c2                	mov    %eax,%edx
c0103901:	8b 45 08             	mov    0x8(%ebp),%eax
c0103904:	01 d0                	add    %edx,%eax
c0103906:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103909:	77 a3                	ja     c01038ae <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010390b:	8b 45 08             	mov    0x8(%ebp),%eax
c010390e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103915:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010391c:	00 
c010391d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103920:	89 04 24             	mov    %eax,(%esp)
c0103923:	e8 cb fb ff ff       	call   c01034f3 <set_page_ref>
    ClearPageProperty(base);
c0103928:	8b 45 08             	mov    0x8(%ebp),%eax
c010392b:	83 c0 04             	add    $0x4,%eax
c010392e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103935:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103938:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010393b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010393e:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0103941:	8b 45 08             	mov    0x8(%ebp),%eax
c0103944:	83 c0 04             	add    $0x4,%eax
c0103947:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010394e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103951:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103954:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103957:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c010395a:	8b 45 08             	mov    0x8(%ebp),%eax
c010395d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103960:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103966:	83 e8 0c             	sub    $0xc,%eax
c0103969:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c010396c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010396f:	c1 e0 05             	shl    $0x5,%eax
c0103972:	89 c2                	mov    %eax,%edx
c0103974:	8b 45 08             	mov    0x8(%ebp),%eax
c0103977:	01 d0                	add    %edx,%eax
c0103979:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010397c:	75 1e                	jne    c010399c <default_free_pages+0x1aa>
      base->property += p->property;
c010397e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103981:	8b 50 08             	mov    0x8(%eax),%edx
c0103984:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103987:	8b 40 08             	mov    0x8(%eax),%eax
c010398a:	01 c2                	add    %eax,%edx
c010398c:	8b 45 08             	mov    0x8(%ebp),%eax
c010398f:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0103992:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103995:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c010399c:	8b 45 08             	mov    0x8(%ebp),%eax
c010399f:	83 c0 0c             	add    $0xc,%eax
c01039a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01039a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01039a8:	8b 00                	mov    (%eax),%eax
c01039aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c01039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b0:	83 e8 0c             	sub    $0xc,%eax
c01039b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c01039b6:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c01039bd:	74 57                	je     c0103a16 <default_free_pages+0x224>
c01039bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c2:	83 e8 20             	sub    $0x20,%eax
c01039c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01039c8:	75 4c                	jne    c0103a16 <default_free_pages+0x224>
      while(le!=&free_list){
c01039ca:	eb 41                	jmp    c0103a0d <default_free_pages+0x21b>
        if(p->property){
c01039cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039cf:	8b 40 08             	mov    0x8(%eax),%eax
c01039d2:	85 c0                	test   %eax,%eax
c01039d4:	74 20                	je     c01039f6 <default_free_pages+0x204>
          p->property += base->property;
c01039d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039d9:	8b 50 08             	mov    0x8(%eax),%edx
c01039dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01039df:	8b 40 08             	mov    0x8(%eax),%eax
c01039e2:	01 c2                	add    %eax,%edx
c01039e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039e7:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c01039ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c01039f4:	eb 20                	jmp    c0103a16 <default_free_pages+0x224>
c01039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01039fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01039ff:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a07:	83 e8 0c             	sub    $0xc,%eax
c0103a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0103a0d:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c0103a14:	75 b6                	jne    c01039cc <default_free_pages+0x1da>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0103a16:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a1f:	01 d0                	add    %edx,%eax
c0103a21:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
    return ;
c0103a26:	90                   	nop
}
c0103a27:	c9                   	leave  
c0103a28:	c3                   	ret    

c0103a29 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103a29:	55                   	push   %ebp
c0103a2a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103a2c:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
}
c0103a31:	5d                   	pop    %ebp
c0103a32:	c3                   	ret    

c0103a33 <basic_check>:

static void
basic_check(void) {
c0103a33:	55                   	push   %ebp
c0103a34:	89 e5                	mov    %esp,%ebp
c0103a36:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103a4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a53:	e8 dc 15 00 00       	call   c0105034 <alloc_pages>
c0103a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a5f:	75 24                	jne    c0103a85 <basic_check+0x52>
c0103a61:	c7 44 24 0c 04 c7 10 	movl   $0xc010c704,0xc(%esp)
c0103a68:	c0 
c0103a69:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103a70:	c0 
c0103a71:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0103a78:	00 
c0103a79:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103a80:	e8 50 d3 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a8c:	e8 a3 15 00 00       	call   c0105034 <alloc_pages>
c0103a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a98:	75 24                	jne    c0103abe <basic_check+0x8b>
c0103a9a:	c7 44 24 0c 20 c7 10 	movl   $0xc010c720,0xc(%esp)
c0103aa1:	c0 
c0103aa2:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103aa9:	c0 
c0103aaa:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103ab1:	00 
c0103ab2:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103ab9:	e8 17 d3 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103abe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ac5:	e8 6a 15 00 00       	call   c0105034 <alloc_pages>
c0103aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ad1:	75 24                	jne    c0103af7 <basic_check+0xc4>
c0103ad3:	c7 44 24 0c 3c c7 10 	movl   $0xc010c73c,0xc(%esp)
c0103ada:	c0 
c0103adb:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103ae2:	c0 
c0103ae3:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0103aea:	00 
c0103aeb:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103af2:	e8 de d2 ff ff       	call   c0100dd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103afa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103afd:	74 10                	je     c0103b0f <basic_check+0xdc>
c0103aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b05:	74 08                	je     c0103b0f <basic_check+0xdc>
c0103b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b0a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b0d:	75 24                	jne    c0103b33 <basic_check+0x100>
c0103b0f:	c7 44 24 0c 58 c7 10 	movl   $0xc010c758,0xc(%esp)
c0103b16:	c0 
c0103b17:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103b1e:	c0 
c0103b1f:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103b26:	00 
c0103b27:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103b2e:	e8 a2 d2 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b36:	89 04 24             	mov    %eax,(%esp)
c0103b39:	e8 ab f9 ff ff       	call   c01034e9 <page_ref>
c0103b3e:	85 c0                	test   %eax,%eax
c0103b40:	75 1e                	jne    c0103b60 <basic_check+0x12d>
c0103b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b45:	89 04 24             	mov    %eax,(%esp)
c0103b48:	e8 9c f9 ff ff       	call   c01034e9 <page_ref>
c0103b4d:	85 c0                	test   %eax,%eax
c0103b4f:	75 0f                	jne    c0103b60 <basic_check+0x12d>
c0103b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b54:	89 04 24             	mov    %eax,(%esp)
c0103b57:	e8 8d f9 ff ff       	call   c01034e9 <page_ref>
c0103b5c:	85 c0                	test   %eax,%eax
c0103b5e:	74 24                	je     c0103b84 <basic_check+0x151>
c0103b60:	c7 44 24 0c 7c c7 10 	movl   $0xc010c77c,0xc(%esp)
c0103b67:	c0 
c0103b68:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103b6f:	c0 
c0103b70:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103b77:	00 
c0103b78:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103b7f:	e8 51 d2 ff ff       	call   c0100dd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b87:	89 04 24             	mov    %eax,(%esp)
c0103b8a:	e8 44 f9 ff ff       	call   c01034d3 <page2pa>
c0103b8f:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103b95:	c1 e2 0c             	shl    $0xc,%edx
c0103b98:	39 d0                	cmp    %edx,%eax
c0103b9a:	72 24                	jb     c0103bc0 <basic_check+0x18d>
c0103b9c:	c7 44 24 0c b8 c7 10 	movl   $0xc010c7b8,0xc(%esp)
c0103ba3:	c0 
c0103ba4:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103bab:	c0 
c0103bac:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103bb3:	00 
c0103bb4:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103bbb:	e8 15 d2 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bc3:	89 04 24             	mov    %eax,(%esp)
c0103bc6:	e8 08 f9 ff ff       	call   c01034d3 <page2pa>
c0103bcb:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103bd1:	c1 e2 0c             	shl    $0xc,%edx
c0103bd4:	39 d0                	cmp    %edx,%eax
c0103bd6:	72 24                	jb     c0103bfc <basic_check+0x1c9>
c0103bd8:	c7 44 24 0c d5 c7 10 	movl   $0xc010c7d5,0xc(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103be7:	c0 
c0103be8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103bef:	00 
c0103bf0:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103bf7:	e8 d9 d1 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bff:	89 04 24             	mov    %eax,(%esp)
c0103c02:	e8 cc f8 ff ff       	call   c01034d3 <page2pa>
c0103c07:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103c0d:	c1 e2 0c             	shl    $0xc,%edx
c0103c10:	39 d0                	cmp    %edx,%eax
c0103c12:	72 24                	jb     c0103c38 <basic_check+0x205>
c0103c14:	c7 44 24 0c f2 c7 10 	movl   $0xc010c7f2,0xc(%esp)
c0103c1b:	c0 
c0103c1c:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103c23:	c0 
c0103c24:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103c2b:	00 
c0103c2c:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103c33:	e8 9d d1 ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103c38:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0103c3d:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0103c43:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103c46:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103c49:	c7 45 e0 b8 ef 19 c0 	movl   $0xc019efb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c53:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103c56:	89 50 04             	mov    %edx,0x4(%eax)
c0103c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c5c:	8b 50 04             	mov    0x4(%eax),%edx
c0103c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c62:	89 10                	mov    %edx,(%eax)
c0103c64:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103c6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c6e:	8b 40 04             	mov    0x4(%eax),%eax
c0103c71:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103c74:	0f 94 c0             	sete   %al
c0103c77:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103c7a:	85 c0                	test   %eax,%eax
c0103c7c:	75 24                	jne    c0103ca2 <basic_check+0x26f>
c0103c7e:	c7 44 24 0c 0f c8 10 	movl   $0xc010c80f,0xc(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103c8d:	c0 
c0103c8e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103c95:	00 
c0103c96:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103c9d:	e8 33 d1 ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103ca2:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103ca7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103caa:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103cb1:	00 00 00 

    assert(alloc_page() == NULL);
c0103cb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cbb:	e8 74 13 00 00       	call   c0105034 <alloc_pages>
c0103cc0:	85 c0                	test   %eax,%eax
c0103cc2:	74 24                	je     c0103ce8 <basic_check+0x2b5>
c0103cc4:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c0103ccb:	c0 
c0103ccc:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103cd3:	c0 
c0103cd4:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103cdb:	00 
c0103cdc:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103ce3:	e8 ed d0 ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103ce8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cef:	00 
c0103cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cf3:	89 04 24             	mov    %eax,(%esp)
c0103cf6:	e8 a4 13 00 00       	call   c010509f <free_pages>
    free_page(p1);
c0103cfb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d02:	00 
c0103d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d06:	89 04 24             	mov    %eax,(%esp)
c0103d09:	e8 91 13 00 00       	call   c010509f <free_pages>
    free_page(p2);
c0103d0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d15:	00 
c0103d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d19:	89 04 24             	mov    %eax,(%esp)
c0103d1c:	e8 7e 13 00 00       	call   c010509f <free_pages>
    assert(nr_free == 3);
c0103d21:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103d26:	83 f8 03             	cmp    $0x3,%eax
c0103d29:	74 24                	je     c0103d4f <basic_check+0x31c>
c0103d2b:	c7 44 24 0c 3b c8 10 	movl   $0xc010c83b,0xc(%esp)
c0103d32:	c0 
c0103d33:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103d3a:	c0 
c0103d3b:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103d42:	00 
c0103d43:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103d4a:	e8 86 d0 ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103d4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d56:	e8 d9 12 00 00       	call   c0105034 <alloc_pages>
c0103d5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103d62:	75 24                	jne    c0103d88 <basic_check+0x355>
c0103d64:	c7 44 24 0c 04 c7 10 	movl   $0xc010c704,0xc(%esp)
c0103d6b:	c0 
c0103d6c:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103d73:	c0 
c0103d74:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103d7b:	00 
c0103d7c:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103d83:	e8 4d d0 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d8f:	e8 a0 12 00 00       	call   c0105034 <alloc_pages>
c0103d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d9b:	75 24                	jne    c0103dc1 <basic_check+0x38e>
c0103d9d:	c7 44 24 0c 20 c7 10 	movl   $0xc010c720,0xc(%esp)
c0103da4:	c0 
c0103da5:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103dac:	c0 
c0103dad:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103db4:	00 
c0103db5:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103dbc:	e8 14 d0 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103dc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dc8:	e8 67 12 00 00       	call   c0105034 <alloc_pages>
c0103dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103dd4:	75 24                	jne    c0103dfa <basic_check+0x3c7>
c0103dd6:	c7 44 24 0c 3c c7 10 	movl   $0xc010c73c,0xc(%esp)
c0103ddd:	c0 
c0103dde:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103de5:	c0 
c0103de6:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103ded:	00 
c0103dee:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103df5:	e8 db cf ff ff       	call   c0100dd5 <__panic>

    assert(alloc_page() == NULL);
c0103dfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e01:	e8 2e 12 00 00       	call   c0105034 <alloc_pages>
c0103e06:	85 c0                	test   %eax,%eax
c0103e08:	74 24                	je     c0103e2e <basic_check+0x3fb>
c0103e0a:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c0103e11:	c0 
c0103e12:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103e19:	c0 
c0103e1a:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103e21:	00 
c0103e22:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103e29:	e8 a7 cf ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103e2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e35:	00 
c0103e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e39:	89 04 24             	mov    %eax,(%esp)
c0103e3c:	e8 5e 12 00 00       	call   c010509f <free_pages>
c0103e41:	c7 45 d8 b8 ef 19 c0 	movl   $0xc019efb8,-0x28(%ebp)
c0103e48:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103e4b:	8b 40 04             	mov    0x4(%eax),%eax
c0103e4e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103e51:	0f 94 c0             	sete   %al
c0103e54:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103e57:	85 c0                	test   %eax,%eax
c0103e59:	74 24                	je     c0103e7f <basic_check+0x44c>
c0103e5b:	c7 44 24 0c 48 c8 10 	movl   $0xc010c848,0xc(%esp)
c0103e62:	c0 
c0103e63:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103e6a:	c0 
c0103e6b:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103e72:	00 
c0103e73:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103e7a:	e8 56 cf ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103e7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e86:	e8 a9 11 00 00       	call   c0105034 <alloc_pages>
c0103e8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e91:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103e94:	74 24                	je     c0103eba <basic_check+0x487>
c0103e96:	c7 44 24 0c 60 c8 10 	movl   $0xc010c860,0xc(%esp)
c0103e9d:	c0 
c0103e9e:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103ea5:	c0 
c0103ea6:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103ead:	00 
c0103eae:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103eb5:	e8 1b cf ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0103eba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ec1:	e8 6e 11 00 00       	call   c0105034 <alloc_pages>
c0103ec6:	85 c0                	test   %eax,%eax
c0103ec8:	74 24                	je     c0103eee <basic_check+0x4bb>
c0103eca:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c0103ed1:	c0 
c0103ed2:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103ed9:	c0 
c0103eda:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103ee1:	00 
c0103ee2:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103ee9:	e8 e7 ce ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c0103eee:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103ef3:	85 c0                	test   %eax,%eax
c0103ef5:	74 24                	je     c0103f1b <basic_check+0x4e8>
c0103ef7:	c7 44 24 0c 79 c8 10 	movl   $0xc010c879,0xc(%esp)
c0103efe:	c0 
c0103eff:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103f06:	c0 
c0103f07:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103f0e:	00 
c0103f0f:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103f16:	e8 ba ce ff ff       	call   c0100dd5 <__panic>
    free_list = free_list_store;
c0103f1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f21:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0103f26:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    nr_free = nr_free_store;
c0103f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f2f:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_page(p);
c0103f34:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f3b:	00 
c0103f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f3f:	89 04 24             	mov    %eax,(%esp)
c0103f42:	e8 58 11 00 00       	call   c010509f <free_pages>
    free_page(p1);
c0103f47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f4e:	00 
c0103f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f52:	89 04 24             	mov    %eax,(%esp)
c0103f55:	e8 45 11 00 00       	call   c010509f <free_pages>
    free_page(p2);
c0103f5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f61:	00 
c0103f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f65:	89 04 24             	mov    %eax,(%esp)
c0103f68:	e8 32 11 00 00       	call   c010509f <free_pages>
}
c0103f6d:	c9                   	leave  
c0103f6e:	c3                   	ret    

c0103f6f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103f6f:	55                   	push   %ebp
c0103f70:	89 e5                	mov    %esp,%ebp
c0103f72:	53                   	push   %ebx
c0103f73:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103f79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103f80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103f87:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103f8e:	eb 6b                	jmp    c0103ffb <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f93:	83 e8 0c             	sub    $0xc,%eax
c0103f96:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f9c:	83 c0 04             	add    $0x4,%eax
c0103f9f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103fa6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fa9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103fac:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103faf:	0f a3 10             	bt     %edx,(%eax)
c0103fb2:	19 c0                	sbb    %eax,%eax
c0103fb4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103fb7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103fbb:	0f 95 c0             	setne  %al
c0103fbe:	0f b6 c0             	movzbl %al,%eax
c0103fc1:	85 c0                	test   %eax,%eax
c0103fc3:	75 24                	jne    c0103fe9 <default_check+0x7a>
c0103fc5:	c7 44 24 0c 86 c8 10 	movl   $0xc010c886,0xc(%esp)
c0103fcc:	c0 
c0103fcd:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0103fd4:	c0 
c0103fd5:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103fdc:	00 
c0103fdd:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0103fe4:	e8 ec cd ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0103fe9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ff0:	8b 50 08             	mov    0x8(%eax),%edx
c0103ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ff6:	01 d0                	add    %edx,%eax
c0103ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ffe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104001:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104004:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104007:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010400a:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c0104011:	0f 85 79 ff ff ff    	jne    c0103f90 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104017:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010401a:	e8 b2 10 00 00       	call   c01050d1 <nr_free_pages>
c010401f:	39 c3                	cmp    %eax,%ebx
c0104021:	74 24                	je     c0104047 <default_check+0xd8>
c0104023:	c7 44 24 0c 96 c8 10 	movl   $0xc010c896,0xc(%esp)
c010402a:	c0 
c010402b:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0104032:	c0 
c0104033:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010403a:	00 
c010403b:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0104042:	e8 8e cd ff ff       	call   c0100dd5 <__panic>

    basic_check();
c0104047:	e8 e7 f9 ff ff       	call   c0103a33 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010404c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104053:	e8 dc 0f 00 00       	call   c0105034 <alloc_pages>
c0104058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010405b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010405f:	75 24                	jne    c0104085 <default_check+0x116>
c0104061:	c7 44 24 0c af c8 10 	movl   $0xc010c8af,0xc(%esp)
c0104068:	c0 
c0104069:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0104070:	c0 
c0104071:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104078:	00 
c0104079:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0104080:	e8 50 cd ff ff       	call   c0100dd5 <__panic>
    assert(!PageProperty(p0));
c0104085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104088:	83 c0 04             	add    $0x4,%eax
c010408b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104092:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104095:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104098:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010409b:	0f a3 10             	bt     %edx,(%eax)
c010409e:	19 c0                	sbb    %eax,%eax
c01040a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01040a3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01040a7:	0f 95 c0             	setne  %al
c01040aa:	0f b6 c0             	movzbl %al,%eax
c01040ad:	85 c0                	test   %eax,%eax
c01040af:	74 24                	je     c01040d5 <default_check+0x166>
c01040b1:	c7 44 24 0c ba c8 10 	movl   $0xc010c8ba,0xc(%esp)
c01040b8:	c0 
c01040b9:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01040c0:	c0 
c01040c1:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01040c8:	00 
c01040c9:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01040d0:	e8 00 cd ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c01040d5:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c01040da:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c01040e0:	89 45 80             	mov    %eax,-0x80(%ebp)
c01040e3:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01040e6:	c7 45 b4 b8 ef 19 c0 	movl   $0xc019efb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01040ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040f0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040f3:	89 50 04             	mov    %edx,0x4(%eax)
c01040f6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040f9:	8b 50 04             	mov    0x4(%eax),%edx
c01040fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040ff:	89 10                	mov    %edx,(%eax)
c0104101:	c7 45 b0 b8 ef 19 c0 	movl   $0xc019efb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104108:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010410b:	8b 40 04             	mov    0x4(%eax),%eax
c010410e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104111:	0f 94 c0             	sete   %al
c0104114:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104117:	85 c0                	test   %eax,%eax
c0104119:	75 24                	jne    c010413f <default_check+0x1d0>
c010411b:	c7 44 24 0c 0f c8 10 	movl   $0xc010c80f,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010413a:	e8 96 cc ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c010413f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104146:	e8 e9 0e 00 00       	call   c0105034 <alloc_pages>
c010414b:	85 c0                	test   %eax,%eax
c010414d:	74 24                	je     c0104173 <default_check+0x204>
c010414f:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c0104156:	c0 
c0104157:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010415e:	c0 
c010415f:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0104166:	00 
c0104167:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010416e:	e8 62 cc ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104173:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0104178:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010417b:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0104182:	00 00 00 

    free_pages(p0 + 2, 3);
c0104185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104188:	83 c0 40             	add    $0x40,%eax
c010418b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104192:	00 
c0104193:	89 04 24             	mov    %eax,(%esp)
c0104196:	e8 04 0f 00 00       	call   c010509f <free_pages>
    assert(alloc_pages(4) == NULL);
c010419b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01041a2:	e8 8d 0e 00 00       	call   c0105034 <alloc_pages>
c01041a7:	85 c0                	test   %eax,%eax
c01041a9:	74 24                	je     c01041cf <default_check+0x260>
c01041ab:	c7 44 24 0c cc c8 10 	movl   $0xc010c8cc,0xc(%esp)
c01041b2:	c0 
c01041b3:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01041ba:	c0 
c01041bb:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01041c2:	00 
c01041c3:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01041ca:	e8 06 cc ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01041cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041d2:	83 c0 40             	add    $0x40,%eax
c01041d5:	83 c0 04             	add    $0x4,%eax
c01041d8:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01041df:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041e2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01041e5:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01041e8:	0f a3 10             	bt     %edx,(%eax)
c01041eb:	19 c0                	sbb    %eax,%eax
c01041ed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01041f0:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01041f4:	0f 95 c0             	setne  %al
c01041f7:	0f b6 c0             	movzbl %al,%eax
c01041fa:	85 c0                	test   %eax,%eax
c01041fc:	74 0e                	je     c010420c <default_check+0x29d>
c01041fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104201:	83 c0 40             	add    $0x40,%eax
c0104204:	8b 40 08             	mov    0x8(%eax),%eax
c0104207:	83 f8 03             	cmp    $0x3,%eax
c010420a:	74 24                	je     c0104230 <default_check+0x2c1>
c010420c:	c7 44 24 0c e4 c8 10 	movl   $0xc010c8e4,0xc(%esp)
c0104213:	c0 
c0104214:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010421b:	c0 
c010421c:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0104223:	00 
c0104224:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010422b:	e8 a5 cb ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104230:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104237:	e8 f8 0d 00 00       	call   c0105034 <alloc_pages>
c010423c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010423f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104243:	75 24                	jne    c0104269 <default_check+0x2fa>
c0104245:	c7 44 24 0c 10 c9 10 	movl   $0xc010c910,0xc(%esp)
c010424c:	c0 
c010424d:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0104254:	c0 
c0104255:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010425c:	00 
c010425d:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0104264:	e8 6c cb ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0104269:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104270:	e8 bf 0d 00 00       	call   c0105034 <alloc_pages>
c0104275:	85 c0                	test   %eax,%eax
c0104277:	74 24                	je     c010429d <default_check+0x32e>
c0104279:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c0104280:	c0 
c0104281:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0104288:	c0 
c0104289:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104290:	00 
c0104291:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0104298:	e8 38 cb ff ff       	call   c0100dd5 <__panic>
    assert(p0 + 2 == p1);
c010429d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042a0:	83 c0 40             	add    $0x40,%eax
c01042a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01042a6:	74 24                	je     c01042cc <default_check+0x35d>
c01042a8:	c7 44 24 0c 2e c9 10 	movl   $0xc010c92e,0xc(%esp)
c01042af:	c0 
c01042b0:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01042b7:	c0 
c01042b8:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01042bf:	00 
c01042c0:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01042c7:	e8 09 cb ff ff       	call   c0100dd5 <__panic>

    p2 = p0 + 1;
c01042cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042cf:	83 c0 20             	add    $0x20,%eax
c01042d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01042d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042dc:	00 
c01042dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042e0:	89 04 24             	mov    %eax,(%esp)
c01042e3:	e8 b7 0d 00 00       	call   c010509f <free_pages>
    free_pages(p1, 3);
c01042e8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01042ef:	00 
c01042f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042f3:	89 04 24             	mov    %eax,(%esp)
c01042f6:	e8 a4 0d 00 00       	call   c010509f <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01042fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042fe:	83 c0 04             	add    $0x4,%eax
c0104301:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104308:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010430b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010430e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104311:	0f a3 10             	bt     %edx,(%eax)
c0104314:	19 c0                	sbb    %eax,%eax
c0104316:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104319:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010431d:	0f 95 c0             	setne  %al
c0104320:	0f b6 c0             	movzbl %al,%eax
c0104323:	85 c0                	test   %eax,%eax
c0104325:	74 0b                	je     c0104332 <default_check+0x3c3>
c0104327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010432a:	8b 40 08             	mov    0x8(%eax),%eax
c010432d:	83 f8 01             	cmp    $0x1,%eax
c0104330:	74 24                	je     c0104356 <default_check+0x3e7>
c0104332:	c7 44 24 0c 3c c9 10 	movl   $0xc010c93c,0xc(%esp)
c0104339:	c0 
c010433a:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c0104341:	c0 
c0104342:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0104349:	00 
c010434a:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c0104351:	e8 7f ca ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104356:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104359:	83 c0 04             	add    $0x4,%eax
c010435c:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104363:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104366:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104369:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010436c:	0f a3 10             	bt     %edx,(%eax)
c010436f:	19 c0                	sbb    %eax,%eax
c0104371:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104374:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104378:	0f 95 c0             	setne  %al
c010437b:	0f b6 c0             	movzbl %al,%eax
c010437e:	85 c0                	test   %eax,%eax
c0104380:	74 0b                	je     c010438d <default_check+0x41e>
c0104382:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104385:	8b 40 08             	mov    0x8(%eax),%eax
c0104388:	83 f8 03             	cmp    $0x3,%eax
c010438b:	74 24                	je     c01043b1 <default_check+0x442>
c010438d:	c7 44 24 0c 64 c9 10 	movl   $0xc010c964,0xc(%esp)
c0104394:	c0 
c0104395:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010439c:	c0 
c010439d:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01043a4:	00 
c01043a5:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01043ac:	e8 24 ca ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01043b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043b8:	e8 77 0c 00 00       	call   c0105034 <alloc_pages>
c01043bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043c3:	83 e8 20             	sub    $0x20,%eax
c01043c6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01043c9:	74 24                	je     c01043ef <default_check+0x480>
c01043cb:	c7 44 24 0c 8a c9 10 	movl   $0xc010c98a,0xc(%esp)
c01043d2:	c0 
c01043d3:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01043da:	c0 
c01043db:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01043e2:	00 
c01043e3:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01043ea:	e8 e6 c9 ff ff       	call   c0100dd5 <__panic>
    free_page(p0);
c01043ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043f6:	00 
c01043f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043fa:	89 04 24             	mov    %eax,(%esp)
c01043fd:	e8 9d 0c 00 00       	call   c010509f <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104402:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104409:	e8 26 0c 00 00       	call   c0105034 <alloc_pages>
c010440e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104411:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104414:	83 c0 20             	add    $0x20,%eax
c0104417:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010441a:	74 24                	je     c0104440 <default_check+0x4d1>
c010441c:	c7 44 24 0c a8 c9 10 	movl   $0xc010c9a8,0xc(%esp)
c0104423:	c0 
c0104424:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010442b:	c0 
c010442c:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104433:	00 
c0104434:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010443b:	e8 95 c9 ff ff       	call   c0100dd5 <__panic>

    free_pages(p0, 2);
c0104440:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104447:	00 
c0104448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010444b:	89 04 24             	mov    %eax,(%esp)
c010444e:	e8 4c 0c 00 00       	call   c010509f <free_pages>
    free_page(p2);
c0104453:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010445a:	00 
c010445b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010445e:	89 04 24             	mov    %eax,(%esp)
c0104461:	e8 39 0c 00 00       	call   c010509f <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104466:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010446d:	e8 c2 0b 00 00       	call   c0105034 <alloc_pages>
c0104472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104475:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104479:	75 24                	jne    c010449f <default_check+0x530>
c010447b:	c7 44 24 0c c8 c9 10 	movl   $0xc010c9c8,0xc(%esp)
c0104482:	c0 
c0104483:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010448a:	c0 
c010448b:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104492:	00 
c0104493:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010449a:	e8 36 c9 ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c010449f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044a6:	e8 89 0b 00 00       	call   c0105034 <alloc_pages>
c01044ab:	85 c0                	test   %eax,%eax
c01044ad:	74 24                	je     c01044d3 <default_check+0x564>
c01044af:	c7 44 24 0c 26 c8 10 	movl   $0xc010c826,0xc(%esp)
c01044b6:	c0 
c01044b7:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01044be:	c0 
c01044bf:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01044c6:	00 
c01044c7:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01044ce:	e8 02 c9 ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c01044d3:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01044d8:	85 c0                	test   %eax,%eax
c01044da:	74 24                	je     c0104500 <default_check+0x591>
c01044dc:	c7 44 24 0c 79 c8 10 	movl   $0xc010c879,0xc(%esp)
c01044e3:	c0 
c01044e4:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01044eb:	c0 
c01044ec:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01044f3:	00 
c01044f4:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01044fb:	e8 d5 c8 ff ff       	call   c0100dd5 <__panic>
    nr_free = nr_free_store;
c0104500:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104503:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_list = free_list_store;
c0104508:	8b 45 80             	mov    -0x80(%ebp),%eax
c010450b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010450e:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0104513:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    free_pages(p0, 5);
c0104519:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104520:	00 
c0104521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104524:	89 04 24             	mov    %eax,(%esp)
c0104527:	e8 73 0b 00 00       	call   c010509f <free_pages>

    le = &free_list;
c010452c:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104533:	eb 1d                	jmp    c0104552 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104535:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104538:	83 e8 0c             	sub    $0xc,%eax
c010453b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010453e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104542:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104548:	8b 40 08             	mov    0x8(%eax),%eax
c010454b:	29 c2                	sub    %eax,%edx
c010454d:	89 d0                	mov    %edx,%eax
c010454f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104552:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104555:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104558:	8b 45 88             	mov    -0x78(%ebp),%eax
c010455b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010455e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104561:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c0104568:	75 cb                	jne    c0104535 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010456a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010456e:	74 24                	je     c0104594 <default_check+0x625>
c0104570:	c7 44 24 0c e6 c9 10 	movl   $0xc010c9e6,0xc(%esp)
c0104577:	c0 
c0104578:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c010457f:	c0 
c0104580:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0104587:	00 
c0104588:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c010458f:	e8 41 c8 ff ff       	call   c0100dd5 <__panic>
    assert(total == 0);
c0104594:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104598:	74 24                	je     c01045be <default_check+0x64f>
c010459a:	c7 44 24 0c f1 c9 10 	movl   $0xc010c9f1,0xc(%esp)
c01045a1:	c0 
c01045a2:	c7 44 24 08 b6 c6 10 	movl   $0xc010c6b6,0x8(%esp)
c01045a9:	c0 
c01045aa:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01045b1:	00 
c01045b2:	c7 04 24 cb c6 10 c0 	movl   $0xc010c6cb,(%esp)
c01045b9:	e8 17 c8 ff ff       	call   c0100dd5 <__panic>
}
c01045be:	81 c4 94 00 00 00    	add    $0x94,%esp
c01045c4:	5b                   	pop    %ebx
c01045c5:	5d                   	pop    %ebp
c01045c6:	c3                   	ret    

c01045c7 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01045c7:	55                   	push   %ebp
c01045c8:	89 e5                	mov    %esp,%ebp
c01045ca:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01045cd:	9c                   	pushf  
c01045ce:	58                   	pop    %eax
c01045cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01045d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01045d5:	25 00 02 00 00       	and    $0x200,%eax
c01045da:	85 c0                	test   %eax,%eax
c01045dc:	74 0c                	je     c01045ea <__intr_save+0x23>
        intr_disable();
c01045de:	e8 4a da ff ff       	call   c010202d <intr_disable>
        return 1;
c01045e3:	b8 01 00 00 00       	mov    $0x1,%eax
c01045e8:	eb 05                	jmp    c01045ef <__intr_save+0x28>
    }
    return 0;
c01045ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045ef:	c9                   	leave  
c01045f0:	c3                   	ret    

c01045f1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01045f1:	55                   	push   %ebp
c01045f2:	89 e5                	mov    %esp,%ebp
c01045f4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01045f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01045fb:	74 05                	je     c0104602 <__intr_restore+0x11>
        intr_enable();
c01045fd:	e8 25 da ff ff       	call   c0102027 <intr_enable>
    }
}
c0104602:	c9                   	leave  
c0104603:	c3                   	ret    

c0104604 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104604:	55                   	push   %ebp
c0104605:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104607:	8b 55 08             	mov    0x8(%ebp),%edx
c010460a:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010460f:	29 c2                	sub    %eax,%edx
c0104611:	89 d0                	mov    %edx,%eax
c0104613:	c1 f8 05             	sar    $0x5,%eax
}
c0104616:	5d                   	pop    %ebp
c0104617:	c3                   	ret    

c0104618 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104618:	55                   	push   %ebp
c0104619:	89 e5                	mov    %esp,%ebp
c010461b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010461e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104621:	89 04 24             	mov    %eax,(%esp)
c0104624:	e8 db ff ff ff       	call   c0104604 <page2ppn>
c0104629:	c1 e0 0c             	shl    $0xc,%eax
}
c010462c:	c9                   	leave  
c010462d:	c3                   	ret    

c010462e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010462e:	55                   	push   %ebp
c010462f:	89 e5                	mov    %esp,%ebp
c0104631:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104634:	8b 45 08             	mov    0x8(%ebp),%eax
c0104637:	c1 e8 0c             	shr    $0xc,%eax
c010463a:	89 c2                	mov    %eax,%edx
c010463c:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104641:	39 c2                	cmp    %eax,%edx
c0104643:	72 1c                	jb     c0104661 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104645:	c7 44 24 08 2c ca 10 	movl   $0xc010ca2c,0x8(%esp)
c010464c:	c0 
c010464d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104654:	00 
c0104655:	c7 04 24 4b ca 10 c0 	movl   $0xc010ca4b,(%esp)
c010465c:	e8 74 c7 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104661:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104666:	8b 55 08             	mov    0x8(%ebp),%edx
c0104669:	c1 ea 0c             	shr    $0xc,%edx
c010466c:	c1 e2 05             	shl    $0x5,%edx
c010466f:	01 d0                	add    %edx,%eax
}
c0104671:	c9                   	leave  
c0104672:	c3                   	ret    

c0104673 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104673:	55                   	push   %ebp
c0104674:	89 e5                	mov    %esp,%ebp
c0104676:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104679:	8b 45 08             	mov    0x8(%ebp),%eax
c010467c:	89 04 24             	mov    %eax,(%esp)
c010467f:	e8 94 ff ff ff       	call   c0104618 <page2pa>
c0104684:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104687:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010468a:	c1 e8 0c             	shr    $0xc,%eax
c010468d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104690:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104695:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104698:	72 23                	jb     c01046bd <page2kva+0x4a>
c010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046a1:	c7 44 24 08 5c ca 10 	movl   $0xc010ca5c,0x8(%esp)
c01046a8:	c0 
c01046a9:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01046b0:	00 
c01046b1:	c7 04 24 4b ca 10 c0 	movl   $0xc010ca4b,(%esp)
c01046b8:	e8 18 c7 ff ff       	call   c0100dd5 <__panic>
c01046bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01046c5:	c9                   	leave  
c01046c6:	c3                   	ret    

c01046c7 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01046c7:	55                   	push   %ebp
c01046c8:	89 e5                	mov    %esp,%ebp
c01046ca:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01046cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046d3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01046da:	77 23                	ja     c01046ff <kva2page+0x38>
c01046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046e3:	c7 44 24 08 80 ca 10 	movl   $0xc010ca80,0x8(%esp)
c01046ea:	c0 
c01046eb:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01046f2:	00 
c01046f3:	c7 04 24 4b ca 10 c0 	movl   $0xc010ca4b,(%esp)
c01046fa:	e8 d6 c6 ff ff       	call   c0100dd5 <__panic>
c01046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104702:	05 00 00 00 40       	add    $0x40000000,%eax
c0104707:	89 04 24             	mov    %eax,(%esp)
c010470a:	e8 1f ff ff ff       	call   c010462e <pa2page>
}
c010470f:	c9                   	leave  
c0104710:	c3                   	ret    

c0104711 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104711:	55                   	push   %ebp
c0104712:	89 e5                	mov    %esp,%ebp
c0104714:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c0104717:	8b 45 0c             	mov    0xc(%ebp),%eax
c010471a:	ba 01 00 00 00       	mov    $0x1,%edx
c010471f:	89 c1                	mov    %eax,%ecx
c0104721:	d3 e2                	shl    %cl,%edx
c0104723:	89 d0                	mov    %edx,%eax
c0104725:	89 04 24             	mov    %eax,(%esp)
c0104728:	e8 07 09 00 00       	call   c0105034 <alloc_pages>
c010472d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104734:	75 07                	jne    c010473d <__slob_get_free_pages+0x2c>
    return NULL;
c0104736:	b8 00 00 00 00       	mov    $0x0,%eax
c010473b:	eb 0b                	jmp    c0104748 <__slob_get_free_pages+0x37>
  return page2kva(page);
c010473d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104740:	89 04 24             	mov    %eax,(%esp)
c0104743:	e8 2b ff ff ff       	call   c0104673 <page2kva>
}
c0104748:	c9                   	leave  
c0104749:	c3                   	ret    

c010474a <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010474a:	55                   	push   %ebp
c010474b:	89 e5                	mov    %esp,%ebp
c010474d:	53                   	push   %ebx
c010474e:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104754:	ba 01 00 00 00       	mov    $0x1,%edx
c0104759:	89 c1                	mov    %eax,%ecx
c010475b:	d3 e2                	shl    %cl,%edx
c010475d:	89 d0                	mov    %edx,%eax
c010475f:	89 c3                	mov    %eax,%ebx
c0104761:	8b 45 08             	mov    0x8(%ebp),%eax
c0104764:	89 04 24             	mov    %eax,(%esp)
c0104767:	e8 5b ff ff ff       	call   c01046c7 <kva2page>
c010476c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104770:	89 04 24             	mov    %eax,(%esp)
c0104773:	e8 27 09 00 00       	call   c010509f <free_pages>
}
c0104778:	83 c4 14             	add    $0x14,%esp
c010477b:	5b                   	pop    %ebx
c010477c:	5d                   	pop    %ebp
c010477d:	c3                   	ret    

c010477e <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c010477e:	55                   	push   %ebp
c010477f:	89 e5                	mov    %esp,%ebp
c0104781:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104784:	8b 45 08             	mov    0x8(%ebp),%eax
c0104787:	83 c0 08             	add    $0x8,%eax
c010478a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c010478f:	76 24                	jbe    c01047b5 <slob_alloc+0x37>
c0104791:	c7 44 24 0c a4 ca 10 	movl   $0xc010caa4,0xc(%esp)
c0104798:	c0 
c0104799:	c7 44 24 08 c3 ca 10 	movl   $0xc010cac3,0x8(%esp)
c01047a0:	c0 
c01047a1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01047a8:	00 
c01047a9:	c7 04 24 d8 ca 10 c0 	movl   $0xc010cad8,(%esp)
c01047b0:	e8 20 c6 ff ff       	call   c0100dd5 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01047b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c01047bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01047c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c6:	83 c0 07             	add    $0x7,%eax
c01047c9:	c1 e8 03             	shr    $0x3,%eax
c01047cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01047cf:	e8 f3 fd ff ff       	call   c01045c7 <__intr_save>
c01047d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01047d7:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01047dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01047df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e2:	8b 40 04             	mov    0x4(%eax),%eax
c01047e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01047e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047ec:	74 25                	je     c0104813 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01047ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01047f4:	01 d0                	add    %edx,%eax
c01047f6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01047f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01047fc:	f7 d8                	neg    %eax
c01047fe:	21 d0                	and    %edx,%eax
c0104800:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104803:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104806:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104809:	29 c2                	sub    %eax,%edx
c010480b:	89 d0                	mov    %edx,%eax
c010480d:	c1 f8 03             	sar    $0x3,%eax
c0104810:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104813:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104816:	8b 00                	mov    (%eax),%eax
c0104818:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010481b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010481e:	01 ca                	add    %ecx,%edx
c0104820:	39 d0                	cmp    %edx,%eax
c0104822:	0f 8c aa 00 00 00    	jl     c01048d2 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104828:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010482c:	74 38                	je     c0104866 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c010482e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104831:	8b 00                	mov    (%eax),%eax
c0104833:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104836:	89 c2                	mov    %eax,%edx
c0104838:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010483b:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c010483d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104840:	8b 50 04             	mov    0x4(%eax),%edx
c0104843:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104846:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104849:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010484c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010484f:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104852:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104855:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104858:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010485a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104860:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104863:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104866:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104869:	8b 00                	mov    (%eax),%eax
c010486b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010486e:	75 0e                	jne    c010487e <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104870:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104873:	8b 50 04             	mov    0x4(%eax),%edx
c0104876:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104879:	89 50 04             	mov    %edx,0x4(%eax)
c010487c:	eb 3c                	jmp    c01048ba <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c010487e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104881:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104888:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010488b:	01 c2                	add    %eax,%edx
c010488d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104890:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104896:	8b 40 04             	mov    0x4(%eax),%eax
c0104899:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010489c:	8b 12                	mov    (%edx),%edx
c010489e:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01048a1:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01048a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a6:	8b 40 04             	mov    0x4(%eax),%eax
c01048a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048ac:	8b 52 04             	mov    0x4(%edx),%edx
c01048af:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01048b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01048b8:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c01048ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bd:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08
			spin_unlock_irqrestore(&slob_lock, flags);
c01048c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048c5:	89 04 24             	mov    %eax,(%esp)
c01048c8:	e8 24 fd ff ff       	call   c01045f1 <__intr_restore>
			return cur;
c01048cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d0:	eb 7f                	jmp    c0104951 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c01048d2:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01048d7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01048da:	75 61                	jne    c010493d <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c01048dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048df:	89 04 24             	mov    %eax,(%esp)
c01048e2:	e8 0a fd ff ff       	call   c01045f1 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01048e7:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01048ee:	75 07                	jne    c01048f7 <slob_alloc+0x179>
				return 0;
c01048f0:	b8 00 00 00 00       	mov    $0x0,%eax
c01048f5:	eb 5a                	jmp    c0104951 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01048f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048fe:	00 
c01048ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104902:	89 04 24             	mov    %eax,(%esp)
c0104905:	e8 07 fe ff ff       	call   c0104711 <__slob_get_free_pages>
c010490a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c010490d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104911:	75 07                	jne    c010491a <slob_alloc+0x19c>
				return 0;
c0104913:	b8 00 00 00 00       	mov    $0x0,%eax
c0104918:	eb 37                	jmp    c0104951 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c010491a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104921:	00 
c0104922:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104925:	89 04 24             	mov    %eax,(%esp)
c0104928:	e8 26 00 00 00       	call   c0104953 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c010492d:	e8 95 fc ff ff       	call   c01045c7 <__intr_save>
c0104932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104935:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c010493a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c010493d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104940:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104943:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104946:	8b 40 04             	mov    0x4(%eax),%eax
c0104949:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c010494c:	e9 97 fe ff ff       	jmp    c01047e8 <slob_alloc+0x6a>
}
c0104951:	c9                   	leave  
c0104952:	c3                   	ret    

c0104953 <slob_free>:

static void slob_free(void *block, int size)
{
c0104953:	55                   	push   %ebp
c0104954:	89 e5                	mov    %esp,%ebp
c0104956:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104959:	8b 45 08             	mov    0x8(%ebp),%eax
c010495c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c010495f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104963:	75 05                	jne    c010496a <slob_free+0x17>
		return;
c0104965:	e9 ff 00 00 00       	jmp    c0104a69 <slob_free+0x116>

	if (size)
c010496a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010496e:	74 10                	je     c0104980 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104970:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104973:	83 c0 07             	add    $0x7,%eax
c0104976:	c1 e8 03             	shr    $0x3,%eax
c0104979:	89 c2                	mov    %eax,%edx
c010497b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497e:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104980:	e8 42 fc ff ff       	call   c01045c7 <__intr_save>
c0104985:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104988:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c010498d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104990:	eb 27                	jmp    c01049b9 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104992:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104995:	8b 40 04             	mov    0x4(%eax),%eax
c0104998:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010499b:	77 13                	ja     c01049b0 <slob_free+0x5d>
c010499d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049a3:	77 27                	ja     c01049cc <slob_free+0x79>
c01049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a8:	8b 40 04             	mov    0x4(%eax),%eax
c01049ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049ae:	77 1c                	ja     c01049cc <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01049b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b3:	8b 40 04             	mov    0x4(%eax),%eax
c01049b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049bf:	76 d1                	jbe    c0104992 <slob_free+0x3f>
c01049c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c4:	8b 40 04             	mov    0x4(%eax),%eax
c01049c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049ca:	76 c6                	jbe    c0104992 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c01049cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049cf:	8b 00                	mov    (%eax),%eax
c01049d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01049d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049db:	01 c2                	add    %eax,%edx
c01049dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e0:	8b 40 04             	mov    0x4(%eax),%eax
c01049e3:	39 c2                	cmp    %eax,%edx
c01049e5:	75 25                	jne    c0104a0c <slob_free+0xb9>
		b->units += cur->next->units;
c01049e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ea:	8b 10                	mov    (%eax),%edx
c01049ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ef:	8b 40 04             	mov    0x4(%eax),%eax
c01049f2:	8b 00                	mov    (%eax),%eax
c01049f4:	01 c2                	add    %eax,%edx
c01049f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f9:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c01049fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049fe:	8b 40 04             	mov    0x4(%eax),%eax
c0104a01:	8b 50 04             	mov    0x4(%eax),%edx
c0104a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a07:	89 50 04             	mov    %edx,0x4(%eax)
c0104a0a:	eb 0c                	jmp    c0104a18 <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a0f:	8b 50 04             	mov    0x4(%eax),%edx
c0104a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a15:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a1b:	8b 00                	mov    (%eax),%eax
c0104a1d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a27:	01 d0                	add    %edx,%eax
c0104a29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a2c:	75 1f                	jne    c0104a4d <slob_free+0xfa>
		cur->units += b->units;
c0104a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a31:	8b 10                	mov    (%eax),%edx
c0104a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a36:	8b 00                	mov    (%eax),%eax
c0104a38:	01 c2                	add    %eax,%edx
c0104a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a3d:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a42:	8b 50 04             	mov    0x4(%eax),%edx
c0104a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a48:	89 50 04             	mov    %edx,0x4(%eax)
c0104a4b:	eb 09                	jmp    c0104a56 <slob_free+0x103>
	} else
		cur->next = b;
c0104a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104a53:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a59:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a61:	89 04 24             	mov    %eax,(%esp)
c0104a64:	e8 88 fb ff ff       	call   c01045f1 <__intr_restore>
}
c0104a69:	c9                   	leave  
c0104a6a:	c3                   	ret    

c0104a6b <slob_init>:



void
slob_init(void) {
c0104a6b:	55                   	push   %ebp
c0104a6c:	89 e5                	mov    %esp,%ebp
c0104a6e:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104a71:	c7 04 24 ea ca 10 c0 	movl   $0xc010caea,(%esp)
c0104a78:	e8 d6 b8 ff ff       	call   c0100353 <cprintf>
}
c0104a7d:	c9                   	leave  
c0104a7e:	c3                   	ret    

c0104a7f <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104a7f:	55                   	push   %ebp
c0104a80:	89 e5                	mov    %esp,%ebp
c0104a82:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104a85:	e8 e1 ff ff ff       	call   c0104a6b <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104a8a:	c7 04 24 fe ca 10 c0 	movl   $0xc010cafe,(%esp)
c0104a91:	e8 bd b8 ff ff       	call   c0100353 <cprintf>
}
c0104a96:	c9                   	leave  
c0104a97:	c3                   	ret    

c0104a98 <slob_allocated>:

size_t
slob_allocated(void) {
c0104a98:	55                   	push   %ebp
c0104a99:	89 e5                	mov    %esp,%ebp
  return 0;
c0104a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104aa0:	5d                   	pop    %ebp
c0104aa1:	c3                   	ret    

c0104aa2 <kallocated>:

size_t
kallocated(void) {
c0104aa2:	55                   	push   %ebp
c0104aa3:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104aa5:	e8 ee ff ff ff       	call   c0104a98 <slob_allocated>
}
c0104aaa:	5d                   	pop    %ebp
c0104aab:	c3                   	ret    

c0104aac <find_order>:

static int find_order(int size)
{
c0104aac:	55                   	push   %ebp
c0104aad:	89 e5                	mov    %esp,%ebp
c0104aaf:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104ab2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104ab9:	eb 07                	jmp    c0104ac2 <find_order+0x16>
		order++;
c0104abb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104abf:	d1 7d 08             	sarl   0x8(%ebp)
c0104ac2:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104ac9:	7f f0                	jg     c0104abb <find_order+0xf>
		order++;
	return order;
c0104acb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104ace:	c9                   	leave  
c0104acf:	c3                   	ret    

c0104ad0 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104ad0:	55                   	push   %ebp
c0104ad1:	89 e5                	mov    %esp,%ebp
c0104ad3:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104ad6:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104add:	77 38                	ja     c0104b17 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae2:	8d 50 08             	lea    0x8(%eax),%edx
c0104ae5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aec:	00 
c0104aed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104af0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104af4:	89 14 24             	mov    %edx,(%esp)
c0104af7:	e8 82 fc ff ff       	call   c010477e <slob_alloc>
c0104afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b03:	74 08                	je     c0104b0d <__kmalloc+0x3d>
c0104b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b08:	83 c0 08             	add    $0x8,%eax
c0104b0b:	eb 05                	jmp    c0104b12 <__kmalloc+0x42>
c0104b0d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b12:	e9 a6 00 00 00       	jmp    c0104bbd <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104b17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b1e:	00 
c0104b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b26:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104b2d:	e8 4c fc ff ff       	call   c010477e <slob_alloc>
c0104b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104b35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b39:	75 07                	jne    c0104b42 <__kmalloc+0x72>
		return 0;
c0104b3b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b40:	eb 7b                	jmp    c0104bbd <__kmalloc+0xed>

	bb->order = find_order(size);
c0104b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b45:	89 04 24             	mov    %eax,(%esp)
c0104b48:	e8 5f ff ff ff       	call   c0104aac <find_order>
c0104b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b50:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b55:	8b 00                	mov    (%eax),%eax
c0104b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b5e:	89 04 24             	mov    %eax,(%esp)
c0104b61:	e8 ab fb ff ff       	call   c0104711 <__slob_get_free_pages>
c0104b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b69:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b6f:	8b 40 04             	mov    0x4(%eax),%eax
c0104b72:	85 c0                	test   %eax,%eax
c0104b74:	74 2f                	je     c0104ba5 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104b76:	e8 4c fa ff ff       	call   c01045c7 <__intr_save>
c0104b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104b7e:	8b 15 c4 ce 19 c0    	mov    0xc019cec4,%edx
c0104b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b87:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8d:	a3 c4 ce 19 c0       	mov    %eax,0xc019cec4
		spin_unlock_irqrestore(&block_lock, flags);
c0104b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b95:	89 04 24             	mov    %eax,(%esp)
c0104b98:	e8 54 fa ff ff       	call   c01045f1 <__intr_restore>
		return bb->pages;
c0104b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ba0:	8b 40 04             	mov    0x4(%eax),%eax
c0104ba3:	eb 18                	jmp    c0104bbd <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104ba5:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104bac:	00 
c0104bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb0:	89 04 24             	mov    %eax,(%esp)
c0104bb3:	e8 9b fd ff ff       	call   c0104953 <slob_free>
	return 0;
c0104bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104bbd:	c9                   	leave  
c0104bbe:	c3                   	ret    

c0104bbf <kmalloc>:

void *
kmalloc(size_t size)
{
c0104bbf:	55                   	push   %ebp
c0104bc0:	89 e5                	mov    %esp,%ebp
c0104bc2:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104bc5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104bcc:	00 
c0104bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bd0:	89 04 24             	mov    %eax,(%esp)
c0104bd3:	e8 f8 fe ff ff       	call   c0104ad0 <__kmalloc>
}
c0104bd8:	c9                   	leave  
c0104bd9:	c3                   	ret    

c0104bda <kfree>:


void kfree(void *block)
{
c0104bda:	55                   	push   %ebp
c0104bdb:	89 e5                	mov    %esp,%ebp
c0104bdd:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104be0:	c7 45 f0 c4 ce 19 c0 	movl   $0xc019cec4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104be7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104beb:	75 05                	jne    c0104bf2 <kfree+0x18>
		return;
c0104bed:	e9 a2 00 00 00       	jmp    c0104c94 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104bf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bf5:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bfa:	85 c0                	test   %eax,%eax
c0104bfc:	75 7f                	jne    c0104c7d <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104bfe:	e8 c4 f9 ff ff       	call   c01045c7 <__intr_save>
c0104c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104c06:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c0e:	eb 5c                	jmp    c0104c6c <kfree+0x92>
			if (bb->pages == block) {
c0104c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c13:	8b 40 04             	mov    0x4(%eax),%eax
c0104c16:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104c19:	75 3f                	jne    c0104c5a <kfree+0x80>
				*last = bb->next;
c0104c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1e:	8b 50 08             	mov    0x8(%eax),%edx
c0104c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c24:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c29:	89 04 24             	mov    %eax,(%esp)
c0104c2c:	e8 c0 f9 ff ff       	call   c01045f1 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c34:	8b 10                	mov    (%eax),%edx
c0104c36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c39:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c3d:	89 04 24             	mov    %eax,(%esp)
c0104c40:	e8 05 fb ff ff       	call   c010474a <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104c45:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104c4c:	00 
c0104c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c50:	89 04 24             	mov    %eax,(%esp)
c0104c53:	e8 fb fc ff ff       	call   c0104953 <slob_free>
				return;
c0104c58:	eb 3a                	jmp    c0104c94 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c5d:	83 c0 08             	add    $0x8,%eax
c0104c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c66:	8b 40 08             	mov    0x8(%eax),%eax
c0104c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c70:	75 9e                	jne    c0104c10 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c75:	89 04 24             	mov    %eax,(%esp)
c0104c78:	e8 74 f9 ff ff       	call   c01045f1 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c80:	83 e8 08             	sub    $0x8,%eax
c0104c83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c8a:	00 
c0104c8b:	89 04 24             	mov    %eax,(%esp)
c0104c8e:	e8 c0 fc ff ff       	call   c0104953 <slob_free>
	return;
c0104c93:	90                   	nop
}
c0104c94:	c9                   	leave  
c0104c95:	c3                   	ret    

c0104c96 <ksize>:


unsigned int ksize(const void *block)
{
c0104c96:	55                   	push   %ebp
c0104c97:	89 e5                	mov    %esp,%ebp
c0104c99:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104c9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ca0:	75 07                	jne    c0104ca9 <ksize+0x13>
		return 0;
c0104ca2:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ca7:	eb 6b                	jmp    c0104d14 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cac:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104cb1:	85 c0                	test   %eax,%eax
c0104cb3:	75 54                	jne    c0104d09 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104cb5:	e8 0d f9 ff ff       	call   c01045c7 <__intr_save>
c0104cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104cbd:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cc5:	eb 31                	jmp    c0104cf8 <ksize+0x62>
			if (bb->pages == block) {
c0104cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cca:	8b 40 04             	mov    0x4(%eax),%eax
c0104ccd:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104cd0:	75 1d                	jne    c0104cef <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd5:	89 04 24             	mov    %eax,(%esp)
c0104cd8:	e8 14 f9 ff ff       	call   c01045f1 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce0:	8b 00                	mov    (%eax),%eax
c0104ce2:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104ce7:	89 c1                	mov    %eax,%ecx
c0104ce9:	d3 e2                	shl    %cl,%edx
c0104ceb:	89 d0                	mov    %edx,%eax
c0104ced:	eb 25                	jmp    c0104d14 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf2:	8b 40 08             	mov    0x8(%eax),%eax
c0104cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cfc:	75 c9                	jne    c0104cc7 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d01:	89 04 24             	mov    %eax,(%esp)
c0104d04:	e8 e8 f8 ff ff       	call   c01045f1 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d0c:	83 e8 08             	sub    $0x8,%eax
c0104d0f:	8b 00                	mov    (%eax),%eax
c0104d11:	c1 e0 03             	shl    $0x3,%eax
}
c0104d14:	c9                   	leave  
c0104d15:	c3                   	ret    

c0104d16 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104d16:	55                   	push   %ebp
c0104d17:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104d19:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d1c:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104d21:	29 c2                	sub    %eax,%edx
c0104d23:	89 d0                	mov    %edx,%eax
c0104d25:	c1 f8 05             	sar    $0x5,%eax
}
c0104d28:	5d                   	pop    %ebp
c0104d29:	c3                   	ret    

c0104d2a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104d2a:	55                   	push   %ebp
c0104d2b:	89 e5                	mov    %esp,%ebp
c0104d2d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d33:	89 04 24             	mov    %eax,(%esp)
c0104d36:	e8 db ff ff ff       	call   c0104d16 <page2ppn>
c0104d3b:	c1 e0 0c             	shl    $0xc,%eax
}
c0104d3e:	c9                   	leave  
c0104d3f:	c3                   	ret    

c0104d40 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104d40:	55                   	push   %ebp
c0104d41:	89 e5                	mov    %esp,%ebp
c0104d43:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d49:	c1 e8 0c             	shr    $0xc,%eax
c0104d4c:	89 c2                	mov    %eax,%edx
c0104d4e:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104d53:	39 c2                	cmp    %eax,%edx
c0104d55:	72 1c                	jb     c0104d73 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104d57:	c7 44 24 08 1c cb 10 	movl   $0xc010cb1c,0x8(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104d66:	00 
c0104d67:	c7 04 24 3b cb 10 c0 	movl   $0xc010cb3b,(%esp)
c0104d6e:	e8 62 c0 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104d73:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104d78:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d7b:	c1 ea 0c             	shr    $0xc,%edx
c0104d7e:	c1 e2 05             	shl    $0x5,%edx
c0104d81:	01 d0                	add    %edx,%eax
}
c0104d83:	c9                   	leave  
c0104d84:	c3                   	ret    

c0104d85 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104d85:	55                   	push   %ebp
c0104d86:	89 e5                	mov    %esp,%ebp
c0104d88:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d8e:	89 04 24             	mov    %eax,(%esp)
c0104d91:	e8 94 ff ff ff       	call   c0104d2a <page2pa>
c0104d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9c:	c1 e8 0c             	shr    $0xc,%eax
c0104d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104da2:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104da7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104daa:	72 23                	jb     c0104dcf <page2kva+0x4a>
c0104dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104db3:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c0104dba:	c0 
c0104dbb:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104dc2:	00 
c0104dc3:	c7 04 24 3b cb 10 c0 	movl   $0xc010cb3b,(%esp)
c0104dca:	e8 06 c0 ff ff       	call   c0100dd5 <__panic>
c0104dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104dd7:	c9                   	leave  
c0104dd8:	c3                   	ret    

c0104dd9 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104dd9:	55                   	push   %ebp
c0104dda:	89 e5                	mov    %esp,%ebp
c0104ddc:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104ddf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104de2:	83 e0 01             	and    $0x1,%eax
c0104de5:	85 c0                	test   %eax,%eax
c0104de7:	75 1c                	jne    c0104e05 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104de9:	c7 44 24 08 70 cb 10 	movl   $0xc010cb70,0x8(%esp)
c0104df0:	c0 
c0104df1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104df8:	00 
c0104df9:	c7 04 24 3b cb 10 c0 	movl   $0xc010cb3b,(%esp)
c0104e00:	e8 d0 bf ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e0d:	89 04 24             	mov    %eax,(%esp)
c0104e10:	e8 2b ff ff ff       	call   c0104d40 <pa2page>
}
c0104e15:	c9                   	leave  
c0104e16:	c3                   	ret    

c0104e17 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104e17:	55                   	push   %ebp
c0104e18:	89 e5                	mov    %esp,%ebp
c0104e1a:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e25:	89 04 24             	mov    %eax,(%esp)
c0104e28:	e8 13 ff ff ff       	call   c0104d40 <pa2page>
}
c0104e2d:	c9                   	leave  
c0104e2e:	c3                   	ret    

c0104e2f <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104e2f:	55                   	push   %ebp
c0104e30:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e35:	8b 00                	mov    (%eax),%eax
}
c0104e37:	5d                   	pop    %ebp
c0104e38:	c3                   	ret    

c0104e39 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104e39:	55                   	push   %ebp
c0104e3a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e42:	89 10                	mov    %edx,(%eax)
}
c0104e44:	5d                   	pop    %ebp
c0104e45:	c3                   	ret    

c0104e46 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104e46:	55                   	push   %ebp
c0104e47:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e4c:	8b 00                	mov    (%eax),%eax
c0104e4e:	8d 50 01             	lea    0x1(%eax),%edx
c0104e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e54:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e56:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e59:	8b 00                	mov    (%eax),%eax
}
c0104e5b:	5d                   	pop    %ebp
c0104e5c:	c3                   	ret    

c0104e5d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104e5d:	55                   	push   %ebp
c0104e5e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e63:	8b 00                	mov    (%eax),%eax
c0104e65:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104e68:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e6b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e70:	8b 00                	mov    (%eax),%eax
}
c0104e72:	5d                   	pop    %ebp
c0104e73:	c3                   	ret    

c0104e74 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104e74:	55                   	push   %ebp
c0104e75:	89 e5                	mov    %esp,%ebp
c0104e77:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104e7a:	9c                   	pushf  
c0104e7b:	58                   	pop    %eax
c0104e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104e82:	25 00 02 00 00       	and    $0x200,%eax
c0104e87:	85 c0                	test   %eax,%eax
c0104e89:	74 0c                	je     c0104e97 <__intr_save+0x23>
        intr_disable();
c0104e8b:	e8 9d d1 ff ff       	call   c010202d <intr_disable>
        return 1;
c0104e90:	b8 01 00 00 00       	mov    $0x1,%eax
c0104e95:	eb 05                	jmp    c0104e9c <__intr_save+0x28>
    }
    return 0;
c0104e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104e9c:	c9                   	leave  
c0104e9d:	c3                   	ret    

c0104e9e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104e9e:	55                   	push   %ebp
c0104e9f:	89 e5                	mov    %esp,%ebp
c0104ea1:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104ea4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ea8:	74 05                	je     c0104eaf <__intr_restore+0x11>
        intr_enable();
c0104eaa:	e8 78 d1 ff ff       	call   c0102027 <intr_enable>
    }
}
c0104eaf:	c9                   	leave  
c0104eb0:	c3                   	ret    

c0104eb1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104eb1:	55                   	push   %ebp
c0104eb2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eb7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104eba:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ebf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104ec1:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ec6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104ec8:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ecd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104ecf:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ed4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104ed6:	b8 10 00 00 00       	mov    $0x10,%eax
c0104edb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104edd:	ea e4 4e 10 c0 08 00 	ljmp   $0x8,$0xc0104ee4
}
c0104ee4:	5d                   	pop    %ebp
c0104ee5:	c3                   	ret    

c0104ee6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104ee6:	55                   	push   %ebp
c0104ee7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eec:	a3 04 cf 19 c0       	mov    %eax,0xc019cf04
}
c0104ef1:	5d                   	pop    %ebp
c0104ef2:	c3                   	ret    

c0104ef3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104ef3:	55                   	push   %ebp
c0104ef4:	89 e5                	mov    %esp,%ebp
c0104ef6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104ef9:	b8 00 a0 12 c0       	mov    $0xc012a000,%eax
c0104efe:	89 04 24             	mov    %eax,(%esp)
c0104f01:	e8 e0 ff ff ff       	call   c0104ee6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104f06:	66 c7 05 08 cf 19 c0 	movw   $0x10,0xc019cf08
c0104f0d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104f0f:	66 c7 05 48 aa 12 c0 	movw   $0x68,0xc012aa48
c0104f16:	68 00 
c0104f18:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104f1d:	66 a3 4a aa 12 c0    	mov    %ax,0xc012aa4a
c0104f23:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104f28:	c1 e8 10             	shr    $0x10,%eax
c0104f2b:	a2 4c aa 12 c0       	mov    %al,0xc012aa4c
c0104f30:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f37:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f3a:	83 c8 09             	or     $0x9,%eax
c0104f3d:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f42:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f49:	83 e0 ef             	and    $0xffffffef,%eax
c0104f4c:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f51:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f58:	83 e0 9f             	and    $0xffffff9f,%eax
c0104f5b:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f60:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f67:	83 c8 80             	or     $0xffffff80,%eax
c0104f6a:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f6f:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f76:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f79:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104f7e:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f85:	83 e0 ef             	and    $0xffffffef,%eax
c0104f88:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104f8d:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f94:	83 e0 df             	and    $0xffffffdf,%eax
c0104f97:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104f9c:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104fa3:	83 c8 40             	or     $0x40,%eax
c0104fa6:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104fab:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104fb2:	83 e0 7f             	and    $0x7f,%eax
c0104fb5:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104fba:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104fbf:	c1 e8 18             	shr    $0x18,%eax
c0104fc2:	a2 4f aa 12 c0       	mov    %al,0xc012aa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104fc7:	c7 04 24 50 aa 12 c0 	movl   $0xc012aa50,(%esp)
c0104fce:	e8 de fe ff ff       	call   c0104eb1 <lgdt>
c0104fd3:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104fd9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104fdd:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104fe0:	c9                   	leave  
c0104fe1:	c3                   	ret    

c0104fe2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104fe2:	55                   	push   %ebp
c0104fe3:	89 e5                	mov    %esp,%ebp
c0104fe5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104fe8:	c7 05 c4 ef 19 c0 10 	movl   $0xc010ca10,0xc019efc4
c0104fef:	ca 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104ff2:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0104ff7:	8b 00                	mov    (%eax),%eax
c0104ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ffd:	c7 04 24 9c cb 10 c0 	movl   $0xc010cb9c,(%esp)
c0105004:	e8 4a b3 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0105009:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010500e:	8b 40 04             	mov    0x4(%eax),%eax
c0105011:	ff d0                	call   *%eax
}
c0105013:	c9                   	leave  
c0105014:	c3                   	ret    

c0105015 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105015:	55                   	push   %ebp
c0105016:	89 e5                	mov    %esp,%ebp
c0105018:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010501b:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105020:	8b 40 08             	mov    0x8(%eax),%eax
c0105023:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105026:	89 54 24 04          	mov    %edx,0x4(%esp)
c010502a:	8b 55 08             	mov    0x8(%ebp),%edx
c010502d:	89 14 24             	mov    %edx,(%esp)
c0105030:	ff d0                	call   *%eax
}
c0105032:	c9                   	leave  
c0105033:	c3                   	ret    

c0105034 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0105034:	55                   	push   %ebp
c0105035:	89 e5                	mov    %esp,%ebp
c0105037:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010503a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0105041:	e8 2e fe ff ff       	call   c0104e74 <__intr_save>
c0105046:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0105049:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010504e:	8b 40 0c             	mov    0xc(%eax),%eax
c0105051:	8b 55 08             	mov    0x8(%ebp),%edx
c0105054:	89 14 24             	mov    %edx,(%esp)
c0105057:	ff d0                	call   *%eax
c0105059:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c010505c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010505f:	89 04 24             	mov    %eax,(%esp)
c0105062:	e8 37 fe ff ff       	call   c0104e9e <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0105067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010506b:	75 2d                	jne    c010509a <alloc_pages+0x66>
c010506d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0105071:	77 27                	ja     c010509a <alloc_pages+0x66>
c0105073:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0105078:	85 c0                	test   %eax,%eax
c010507a:	74 1e                	je     c010509a <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010507c:	8b 55 08             	mov    0x8(%ebp),%edx
c010507f:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0105084:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010508b:	00 
c010508c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105090:	89 04 24             	mov    %eax,(%esp)
c0105093:	e8 84 1d 00 00       	call   c0106e1c <swap_out>
    }
c0105098:	eb a7                	jmp    c0105041 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010509a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010509d:	c9                   	leave  
c010509e:	c3                   	ret    

c010509f <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010509f:	55                   	push   %ebp
c01050a0:	89 e5                	mov    %esp,%ebp
c01050a2:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01050a5:	e8 ca fd ff ff       	call   c0104e74 <__intr_save>
c01050aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01050ad:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050b2:	8b 40 10             	mov    0x10(%eax),%eax
c01050b5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050b8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01050bf:	89 14 24             	mov    %edx,(%esp)
c01050c2:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01050c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c7:	89 04 24             	mov    %eax,(%esp)
c01050ca:	e8 cf fd ff ff       	call   c0104e9e <__intr_restore>
}
c01050cf:	c9                   	leave  
c01050d0:	c3                   	ret    

c01050d1 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01050d1:	55                   	push   %ebp
c01050d2:	89 e5                	mov    %esp,%ebp
c01050d4:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01050d7:	e8 98 fd ff ff       	call   c0104e74 <__intr_save>
c01050dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01050df:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050e4:	8b 40 14             	mov    0x14(%eax),%eax
c01050e7:	ff d0                	call   *%eax
c01050e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01050ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050ef:	89 04 24             	mov    %eax,(%esp)
c01050f2:	e8 a7 fd ff ff       	call   c0104e9e <__intr_restore>
    return ret;
c01050f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01050fa:	c9                   	leave  
c01050fb:	c3                   	ret    

c01050fc <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01050fc:	55                   	push   %ebp
c01050fd:	89 e5                	mov    %esp,%ebp
c01050ff:	57                   	push   %edi
c0105100:	56                   	push   %esi
c0105101:	53                   	push   %ebx
c0105102:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0105108:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010510f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105116:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010511d:	c7 04 24 b3 cb 10 c0 	movl   $0xc010cbb3,(%esp)
c0105124:	e8 2a b2 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105129:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105130:	e9 15 01 00 00       	jmp    c010524a <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105135:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105138:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010513b:	89 d0                	mov    %edx,%eax
c010513d:	c1 e0 02             	shl    $0x2,%eax
c0105140:	01 d0                	add    %edx,%eax
c0105142:	c1 e0 02             	shl    $0x2,%eax
c0105145:	01 c8                	add    %ecx,%eax
c0105147:	8b 50 08             	mov    0x8(%eax),%edx
c010514a:	8b 40 04             	mov    0x4(%eax),%eax
c010514d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105150:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105153:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105156:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105159:	89 d0                	mov    %edx,%eax
c010515b:	c1 e0 02             	shl    $0x2,%eax
c010515e:	01 d0                	add    %edx,%eax
c0105160:	c1 e0 02             	shl    $0x2,%eax
c0105163:	01 c8                	add    %ecx,%eax
c0105165:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105168:	8b 58 10             	mov    0x10(%eax),%ebx
c010516b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010516e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105171:	01 c8                	add    %ecx,%eax
c0105173:	11 da                	adc    %ebx,%edx
c0105175:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105178:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010517b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010517e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105181:	89 d0                	mov    %edx,%eax
c0105183:	c1 e0 02             	shl    $0x2,%eax
c0105186:	01 d0                	add    %edx,%eax
c0105188:	c1 e0 02             	shl    $0x2,%eax
c010518b:	01 c8                	add    %ecx,%eax
c010518d:	83 c0 14             	add    $0x14,%eax
c0105190:	8b 00                	mov    (%eax),%eax
c0105192:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0105198:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010519b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010519e:	83 c0 ff             	add    $0xffffffff,%eax
c01051a1:	83 d2 ff             	adc    $0xffffffff,%edx
c01051a4:	89 c6                	mov    %eax,%esi
c01051a6:	89 d7                	mov    %edx,%edi
c01051a8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051ae:	89 d0                	mov    %edx,%eax
c01051b0:	c1 e0 02             	shl    $0x2,%eax
c01051b3:	01 d0                	add    %edx,%eax
c01051b5:	c1 e0 02             	shl    $0x2,%eax
c01051b8:	01 c8                	add    %ecx,%eax
c01051ba:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051bd:	8b 58 10             	mov    0x10(%eax),%ebx
c01051c0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01051c6:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01051ca:	89 74 24 14          	mov    %esi,0x14(%esp)
c01051ce:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01051d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01051d5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01051d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051dc:	89 54 24 10          	mov    %edx,0x10(%esp)
c01051e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01051e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01051e8:	c7 04 24 c0 cb 10 c0 	movl   $0xc010cbc0,(%esp)
c01051ef:	e8 5f b1 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01051f4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051fa:	89 d0                	mov    %edx,%eax
c01051fc:	c1 e0 02             	shl    $0x2,%eax
c01051ff:	01 d0                	add    %edx,%eax
c0105201:	c1 e0 02             	shl    $0x2,%eax
c0105204:	01 c8                	add    %ecx,%eax
c0105206:	83 c0 14             	add    $0x14,%eax
c0105209:	8b 00                	mov    (%eax),%eax
c010520b:	83 f8 01             	cmp    $0x1,%eax
c010520e:	75 36                	jne    c0105246 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0105210:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105213:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105216:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105219:	77 2b                	ja     c0105246 <page_init+0x14a>
c010521b:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010521e:	72 05                	jb     c0105225 <page_init+0x129>
c0105220:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105223:	73 21                	jae    c0105246 <page_init+0x14a>
c0105225:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105229:	77 1b                	ja     c0105246 <page_init+0x14a>
c010522b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010522f:	72 09                	jb     c010523a <page_init+0x13e>
c0105231:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105238:	77 0c                	ja     c0105246 <page_init+0x14a>
                maxpa = end;
c010523a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010523d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105240:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105243:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105246:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010524a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010524d:	8b 00                	mov    (%eax),%eax
c010524f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105252:	0f 8f dd fe ff ff    	jg     c0105135 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105258:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010525c:	72 1d                	jb     c010527b <page_init+0x17f>
c010525e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105262:	77 09                	ja     c010526d <page_init+0x171>
c0105264:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010526b:	76 0e                	jbe    c010527b <page_init+0x17f>
        maxpa = KMEMSIZE;
c010526d:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105274:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010527b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010527e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105281:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105285:	c1 ea 0c             	shr    $0xc,%edx
c0105288:	a3 e0 ce 19 c0       	mov    %eax,0xc019cee0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010528d:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0105294:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c0105299:	8d 50 ff             	lea    -0x1(%eax),%edx
c010529c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010529f:	01 d0                	add    %edx,%eax
c01052a1:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01052a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01052a7:	ba 00 00 00 00       	mov    $0x0,%edx
c01052ac:	f7 75 ac             	divl   -0x54(%ebp)
c01052af:	89 d0                	mov    %edx,%eax
c01052b1:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01052b4:	29 c2                	sub    %eax,%edx
c01052b6:	89 d0                	mov    %edx,%eax
c01052b8:	a3 cc ef 19 c0       	mov    %eax,0xc019efcc

    for (i = 0; i < npage; i ++) {
c01052bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01052c4:	eb 27                	jmp    c01052ed <page_init+0x1f1>
        SetPageReserved(pages + i);
c01052c6:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01052cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052ce:	c1 e2 05             	shl    $0x5,%edx
c01052d1:	01 d0                	add    %edx,%eax
c01052d3:	83 c0 04             	add    $0x4,%eax
c01052d6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01052dd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01052e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01052e3:	8b 55 90             	mov    -0x70(%ebp),%edx
c01052e6:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01052e9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f0:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01052f5:	39 c2                	cmp    %eax,%edx
c01052f7:	72 cd                	jb     c01052c6 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01052f9:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01052fe:	c1 e0 05             	shl    $0x5,%eax
c0105301:	89 c2                	mov    %eax,%edx
c0105303:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0105308:	01 d0                	add    %edx,%eax
c010530a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010530d:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105314:	77 23                	ja     c0105339 <page_init+0x23d>
c0105316:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010531d:	c7 44 24 08 f0 cb 10 	movl   $0xc010cbf0,0x8(%esp)
c0105324:	c0 
c0105325:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010532c:	00 
c010532d:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105334:	e8 9c ba ff ff       	call   c0100dd5 <__panic>
c0105339:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010533c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105341:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105344:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010534b:	e9 74 01 00 00       	jmp    c01054c4 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105350:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105353:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105356:	89 d0                	mov    %edx,%eax
c0105358:	c1 e0 02             	shl    $0x2,%eax
c010535b:	01 d0                	add    %edx,%eax
c010535d:	c1 e0 02             	shl    $0x2,%eax
c0105360:	01 c8                	add    %ecx,%eax
c0105362:	8b 50 08             	mov    0x8(%eax),%edx
c0105365:	8b 40 04             	mov    0x4(%eax),%eax
c0105368:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010536b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010536e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105371:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105374:	89 d0                	mov    %edx,%eax
c0105376:	c1 e0 02             	shl    $0x2,%eax
c0105379:	01 d0                	add    %edx,%eax
c010537b:	c1 e0 02             	shl    $0x2,%eax
c010537e:	01 c8                	add    %ecx,%eax
c0105380:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105383:	8b 58 10             	mov    0x10(%eax),%ebx
c0105386:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105389:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010538c:	01 c8                	add    %ecx,%eax
c010538e:	11 da                	adc    %ebx,%edx
c0105390:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105393:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105396:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105399:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010539c:	89 d0                	mov    %edx,%eax
c010539e:	c1 e0 02             	shl    $0x2,%eax
c01053a1:	01 d0                	add    %edx,%eax
c01053a3:	c1 e0 02             	shl    $0x2,%eax
c01053a6:	01 c8                	add    %ecx,%eax
c01053a8:	83 c0 14             	add    $0x14,%eax
c01053ab:	8b 00                	mov    (%eax),%eax
c01053ad:	83 f8 01             	cmp    $0x1,%eax
c01053b0:	0f 85 0a 01 00 00    	jne    c01054c0 <page_init+0x3c4>
            if (begin < freemem) {
c01053b6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053b9:	ba 00 00 00 00       	mov    $0x0,%edx
c01053be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053c1:	72 17                	jb     c01053da <page_init+0x2de>
c01053c3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053c6:	77 05                	ja     c01053cd <page_init+0x2d1>
c01053c8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053cb:	76 0d                	jbe    c01053da <page_init+0x2de>
                begin = freemem;
c01053cd:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053d3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01053da:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053de:	72 1d                	jb     c01053fd <page_init+0x301>
c01053e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053e4:	77 09                	ja     c01053ef <page_init+0x2f3>
c01053e6:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01053ed:	76 0e                	jbe    c01053fd <page_init+0x301>
                end = KMEMSIZE;
c01053ef:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01053f6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01053fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105400:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105403:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105406:	0f 87 b4 00 00 00    	ja     c01054c0 <page_init+0x3c4>
c010540c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010540f:	72 09                	jb     c010541a <page_init+0x31e>
c0105411:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105414:	0f 83 a6 00 00 00    	jae    c01054c0 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c010541a:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105421:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105424:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105427:	01 d0                	add    %edx,%eax
c0105429:	83 e8 01             	sub    $0x1,%eax
c010542c:	89 45 98             	mov    %eax,-0x68(%ebp)
c010542f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105432:	ba 00 00 00 00       	mov    $0x0,%edx
c0105437:	f7 75 9c             	divl   -0x64(%ebp)
c010543a:	89 d0                	mov    %edx,%eax
c010543c:	8b 55 98             	mov    -0x68(%ebp),%edx
c010543f:	29 c2                	sub    %eax,%edx
c0105441:	89 d0                	mov    %edx,%eax
c0105443:	ba 00 00 00 00       	mov    $0x0,%edx
c0105448:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010544b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010544e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105451:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105454:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105457:	ba 00 00 00 00       	mov    $0x0,%edx
c010545c:	89 c7                	mov    %eax,%edi
c010545e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105464:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105467:	89 d0                	mov    %edx,%eax
c0105469:	83 e0 00             	and    $0x0,%eax
c010546c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010546f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105472:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105475:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105478:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010547b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010547e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105481:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105484:	77 3a                	ja     c01054c0 <page_init+0x3c4>
c0105486:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105489:	72 05                	jb     c0105490 <page_init+0x394>
c010548b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010548e:	73 30                	jae    c01054c0 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105490:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0105493:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0105496:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105499:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010549c:	29 c8                	sub    %ecx,%eax
c010549e:	19 da                	sbb    %ebx,%edx
c01054a0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01054a4:	c1 ea 0c             	shr    $0xc,%edx
c01054a7:	89 c3                	mov    %eax,%ebx
c01054a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054ac:	89 04 24             	mov    %eax,(%esp)
c01054af:	e8 8c f8 ff ff       	call   c0104d40 <pa2page>
c01054b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01054b8:	89 04 24             	mov    %eax,(%esp)
c01054bb:	e8 55 fb ff ff       	call   c0105015 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01054c0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01054c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01054c7:	8b 00                	mov    (%eax),%eax
c01054c9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01054cc:	0f 8f 7e fe ff ff    	jg     c0105350 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01054d2:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01054d8:	5b                   	pop    %ebx
c01054d9:	5e                   	pop    %esi
c01054da:	5f                   	pop    %edi
c01054db:	5d                   	pop    %ebp
c01054dc:	c3                   	ret    

c01054dd <enable_paging>:

static void
enable_paging(void) {
c01054dd:	55                   	push   %ebp
c01054de:	89 e5                	mov    %esp,%ebp
c01054e0:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01054e3:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c01054e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01054eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054ee:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01054f1:	0f 20 c0             	mov    %cr0,%eax
c01054f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01054f7:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01054fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01054fd:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105504:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105508:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010550b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010550e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105511:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105514:	c9                   	leave  
c0105515:	c3                   	ret    

c0105516 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105516:	55                   	push   %ebp
c0105517:	89 e5                	mov    %esp,%ebp
c0105519:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010551c:	8b 45 14             	mov    0x14(%ebp),%eax
c010551f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105522:	31 d0                	xor    %edx,%eax
c0105524:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105529:	85 c0                	test   %eax,%eax
c010552b:	74 24                	je     c0105551 <boot_map_segment+0x3b>
c010552d:	c7 44 24 0c 22 cc 10 	movl   $0xc010cc22,0xc(%esp)
c0105534:	c0 
c0105535:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010553c:	c0 
c010553d:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105544:	00 
c0105545:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010554c:	e8 84 b8 ff ff       	call   c0100dd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105551:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010555b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105560:	89 c2                	mov    %eax,%edx
c0105562:	8b 45 10             	mov    0x10(%ebp),%eax
c0105565:	01 c2                	add    %eax,%edx
c0105567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010556a:	01 d0                	add    %edx,%eax
c010556c:	83 e8 01             	sub    $0x1,%eax
c010556f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105572:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105575:	ba 00 00 00 00       	mov    $0x0,%edx
c010557a:	f7 75 f0             	divl   -0x10(%ebp)
c010557d:	89 d0                	mov    %edx,%eax
c010557f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105582:	29 c2                	sub    %eax,%edx
c0105584:	89 d0                	mov    %edx,%eax
c0105586:	c1 e8 0c             	shr    $0xc,%eax
c0105589:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010558c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010558f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105592:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010559a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010559d:	8b 45 14             	mov    0x14(%ebp),%eax
c01055a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055ab:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01055ae:	eb 6b                	jmp    c010561b <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01055b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01055b7:	00 
c01055b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c2:	89 04 24             	mov    %eax,(%esp)
c01055c5:	e8 d1 01 00 00       	call   c010579b <get_pte>
c01055ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01055cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01055d1:	75 24                	jne    c01055f7 <boot_map_segment+0xe1>
c01055d3:	c7 44 24 0c 4e cc 10 	movl   $0xc010cc4e,0xc(%esp)
c01055da:	c0 
c01055db:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01055e2:	c0 
c01055e3:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01055ea:	00 
c01055eb:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01055f2:	e8 de b7 ff ff       	call   c0100dd5 <__panic>
        *ptep = pa | PTE_P | perm;
c01055f7:	8b 45 18             	mov    0x18(%ebp),%eax
c01055fa:	8b 55 14             	mov    0x14(%ebp),%edx
c01055fd:	09 d0                	or     %edx,%eax
c01055ff:	83 c8 01             	or     $0x1,%eax
c0105602:	89 c2                	mov    %eax,%edx
c0105604:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105607:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105609:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010560d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105614:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010561b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010561f:	75 8f                	jne    c01055b0 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105621:	c9                   	leave  
c0105622:	c3                   	ret    

c0105623 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105623:	55                   	push   %ebp
c0105624:	89 e5                	mov    %esp,%ebp
c0105626:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105630:	e8 ff f9 ff ff       	call   c0105034 <alloc_pages>
c0105635:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010563c:	75 1c                	jne    c010565a <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010563e:	c7 44 24 08 5b cc 10 	movl   $0xc010cc5b,0x8(%esp)
c0105645:	c0 
c0105646:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010564d:	00 
c010564e:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105655:	e8 7b b7 ff ff       	call   c0100dd5 <__panic>
    }
    return page2kva(p);
c010565a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010565d:	89 04 24             	mov    %eax,(%esp)
c0105660:	e8 20 f7 ff ff       	call   c0104d85 <page2kva>
}
c0105665:	c9                   	leave  
c0105666:	c3                   	ret    

c0105667 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105667:	55                   	push   %ebp
c0105668:	89 e5                	mov    %esp,%ebp
c010566a:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010566d:	e8 70 f9 ff ff       	call   c0104fe2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105672:	e8 85 fa ff ff       	call   c01050fc <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105677:	e8 58 09 00 00       	call   c0105fd4 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010567c:	e8 a2 ff ff ff       	call   c0105623 <boot_alloc_page>
c0105681:	a3 e4 ce 19 c0       	mov    %eax,0xc019cee4
    memset(boot_pgdir, 0, PGSIZE);
c0105686:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010568b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105692:	00 
c0105693:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010569a:	00 
c010569b:	89 04 24             	mov    %eax,(%esp)
c010569e:	e8 3c 65 00 00       	call   c010bbdf <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01056a3:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056ab:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01056b2:	77 23                	ja     c01056d7 <pmm_init+0x70>
c01056b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056bb:	c7 44 24 08 f0 cb 10 	movl   $0xc010cbf0,0x8(%esp)
c01056c2:	c0 
c01056c3:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01056ca:	00 
c01056cb:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01056d2:	e8 fe b6 ff ff       	call   c0100dd5 <__panic>
c01056d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056da:	05 00 00 00 40       	add    $0x40000000,%eax
c01056df:	a3 c8 ef 19 c0       	mov    %eax,0xc019efc8

    check_pgdir();
c01056e4:	e8 09 09 00 00       	call   c0105ff2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01056e9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056ee:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01056f4:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056fc:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105703:	77 23                	ja     c0105728 <pmm_init+0xc1>
c0105705:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105708:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010570c:	c7 44 24 08 f0 cb 10 	movl   $0xc010cbf0,0x8(%esp)
c0105713:	c0 
c0105714:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c010571b:	00 
c010571c:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105723:	e8 ad b6 ff ff       	call   c0100dd5 <__panic>
c0105728:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010572b:	05 00 00 00 40       	add    $0x40000000,%eax
c0105730:	83 c8 03             	or     $0x3,%eax
c0105733:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105735:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010573a:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105741:	00 
c0105742:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105749:	00 
c010574a:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105751:	38 
c0105752:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105759:	c0 
c010575a:	89 04 24             	mov    %eax,(%esp)
c010575d:	e8 b4 fd ff ff       	call   c0105516 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105762:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105767:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c010576d:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0105773:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105775:	e8 63 fd ff ff       	call   c01054dd <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010577a:	e8 74 f7 ff ff       	call   c0104ef3 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010577f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010578a:	e8 fe 0e 00 00       	call   c010668d <check_boot_pgdir>

    print_pgdir();
c010578f:	e8 8b 13 00 00       	call   c0106b1f <print_pgdir>
    
    kmalloc_init();
c0105794:	e8 e6 f2 ff ff       	call   c0104a7f <kmalloc_init>

}
c0105799:	c9                   	leave  
c010579a:	c3                   	ret    

c010579b <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010579b:	55                   	push   %ebp
c010579c:	89 e5                	mov    %esp,%ebp
c010579e:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a4:	c1 e8 16             	shr    $0x16,%eax
c01057a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b1:	01 d0                	add    %edx,%eax
c01057b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01057b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b9:	8b 00                	mov    (%eax),%eax
c01057bb:	83 e0 01             	and    $0x1,%eax
c01057be:	85 c0                	test   %eax,%eax
c01057c0:	0f 85 af 00 00 00    	jne    c0105875 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01057c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057ca:	74 15                	je     c01057e1 <get_pte+0x46>
c01057cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01057d3:	e8 5c f8 ff ff       	call   c0105034 <alloc_pages>
c01057d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01057df:	75 0a                	jne    c01057eb <get_pte+0x50>
            return NULL;
c01057e1:	b8 00 00 00 00       	mov    $0x0,%eax
c01057e6:	e9 e6 00 00 00       	jmp    c01058d1 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01057eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057f2:	00 
c01057f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f6:	89 04 24             	mov    %eax,(%esp)
c01057f9:	e8 3b f6 ff ff       	call   c0104e39 <set_page_ref>
        uintptr_t pa = page2pa(page);
c01057fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105801:	89 04 24             	mov    %eax,(%esp)
c0105804:	e8 21 f5 ff ff       	call   c0104d2a <page2pa>
c0105809:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010580c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010580f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105812:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105815:	c1 e8 0c             	shr    $0xc,%eax
c0105818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010581b:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105820:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105823:	72 23                	jb     c0105848 <get_pte+0xad>
c0105825:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105828:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010582c:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c0105833:	c0 
c0105834:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c010583b:	00 
c010583c:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105843:	e8 8d b5 ff ff       	call   c0100dd5 <__panic>
c0105848:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010584b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105850:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105857:	00 
c0105858:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010585f:	00 
c0105860:	89 04 24             	mov    %eax,(%esp)
c0105863:	e8 77 63 00 00       	call   c010bbdf <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0105868:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010586b:	83 c8 07             	or     $0x7,%eax
c010586e:	89 c2                	mov    %eax,%edx
c0105870:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105873:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0105875:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105878:	8b 00                	mov    (%eax),%eax
c010587a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010587f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105882:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105885:	c1 e8 0c             	shr    $0xc,%eax
c0105888:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010588b:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105890:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105893:	72 23                	jb     c01058b8 <get_pte+0x11d>
c0105895:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105898:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010589c:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c01058a3:	c0 
c01058a4:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c01058ab:	00 
c01058ac:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01058b3:	e8 1d b5 ff ff       	call   c0100dd5 <__panic>
c01058b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058bb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058c3:	c1 ea 0c             	shr    $0xc,%edx
c01058c6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01058cc:	c1 e2 02             	shl    $0x2,%edx
c01058cf:	01 d0                	add    %edx,%eax
}
c01058d1:	c9                   	leave  
c01058d2:	c3                   	ret    

c01058d3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01058d3:	55                   	push   %ebp
c01058d4:	89 e5                	mov    %esp,%ebp
c01058d6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01058d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01058e0:	00 
c01058e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058eb:	89 04 24             	mov    %eax,(%esp)
c01058ee:	e8 a8 fe ff ff       	call   c010579b <get_pte>
c01058f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01058f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058fa:	74 08                	je     c0105904 <get_page+0x31>
        *ptep_store = ptep;
c01058fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01058ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105902:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105908:	74 1b                	je     c0105925 <get_page+0x52>
c010590a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590d:	8b 00                	mov    (%eax),%eax
c010590f:	83 e0 01             	and    $0x1,%eax
c0105912:	85 c0                	test   %eax,%eax
c0105914:	74 0f                	je     c0105925 <get_page+0x52>
        return pa2page(*ptep);
c0105916:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105919:	8b 00                	mov    (%eax),%eax
c010591b:	89 04 24             	mov    %eax,(%esp)
c010591e:	e8 1d f4 ff ff       	call   c0104d40 <pa2page>
c0105923:	eb 05                	jmp    c010592a <get_page+0x57>
    }
    return NULL;
c0105925:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010592a:	c9                   	leave  
c010592b:	c3                   	ret    

c010592c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010592c:	55                   	push   %ebp
c010592d:	89 e5                	mov    %esp,%ebp
c010592f:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0105932:	8b 45 10             	mov    0x10(%ebp),%eax
c0105935:	8b 00                	mov    (%eax),%eax
c0105937:	83 e0 01             	and    $0x1,%eax
c010593a:	85 c0                	test   %eax,%eax
c010593c:	74 4d                	je     c010598b <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c010593e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105941:	8b 00                	mov    (%eax),%eax
c0105943:	89 04 24             	mov    %eax,(%esp)
c0105946:	e8 8e f4 ff ff       	call   c0104dd9 <pte2page>
c010594b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105951:	89 04 24             	mov    %eax,(%esp)
c0105954:	e8 04 f5 ff ff       	call   c0104e5d <page_ref_dec>
c0105959:	85 c0                	test   %eax,%eax
c010595b:	75 13                	jne    c0105970 <page_remove_pte+0x44>
            free_page(page);
c010595d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105964:	00 
c0105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105968:	89 04 24             	mov    %eax,(%esp)
c010596b:	e8 2f f7 ff ff       	call   c010509f <free_pages>
        }
        *ptep = 0;
c0105970:	8b 45 10             	mov    0x10(%ebp),%eax
c0105973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105979:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105980:	8b 45 08             	mov    0x8(%ebp),%eax
c0105983:	89 04 24             	mov    %eax,(%esp)
c0105986:	e8 18 05 00 00       	call   c0105ea3 <tlb_invalidate>
    }
}
c010598b:	c9                   	leave  
c010598c:	c3                   	ret    

c010598d <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c010598d:	55                   	push   %ebp
c010598e:	89 e5                	mov    %esp,%ebp
c0105990:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105993:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105996:	25 ff 0f 00 00       	and    $0xfff,%eax
c010599b:	85 c0                	test   %eax,%eax
c010599d:	75 0c                	jne    c01059ab <unmap_range+0x1e>
c010599f:	8b 45 10             	mov    0x10(%ebp),%eax
c01059a2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059a7:	85 c0                	test   %eax,%eax
c01059a9:	74 24                	je     c01059cf <unmap_range+0x42>
c01059ab:	c7 44 24 0c 74 cc 10 	movl   $0xc010cc74,0xc(%esp)
c01059b2:	c0 
c01059b3:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01059ba:	c0 
c01059bb:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c01059c2:	00 
c01059c3:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01059ca:	e8 06 b4 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c01059cf:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01059d6:	76 11                	jbe    c01059e9 <unmap_range+0x5c>
c01059d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059db:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059de:	73 09                	jae    c01059e9 <unmap_range+0x5c>
c01059e0:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c01059e7:	76 24                	jbe    c0105a0d <unmap_range+0x80>
c01059e9:	c7 44 24 0c 9d cc 10 	movl   $0xc010cc9d,0xc(%esp)
c01059f0:	c0 
c01059f1:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01059f8:	c0 
c01059f9:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
c0105a00:	00 
c0105a01:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105a08:	e8 c8 b3 ff ff       	call   c0100dd5 <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105a0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a14:	00 
c0105a15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1f:	89 04 24             	mov    %eax,(%esp)
c0105a22:	e8 74 fd ff ff       	call   c010579b <get_pte>
c0105a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a2e:	75 18                	jne    c0105a48 <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105a30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a33:	05 00 00 40 00       	add    $0x400000,%eax
c0105a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3e:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105a43:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105a46:	eb 29                	jmp    c0105a71 <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a4b:	8b 00                	mov    (%eax),%eax
c0105a4d:	85 c0                	test   %eax,%eax
c0105a4f:	74 19                	je     c0105a6a <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c0105a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a54:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a62:	89 04 24             	mov    %eax,(%esp)
c0105a65:	e8 c2 fe ff ff       	call   c010592c <page_remove_pte>
        }
        start += PGSIZE;
c0105a6a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105a71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a75:	74 08                	je     c0105a7f <unmap_range+0xf2>
c0105a77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105a7d:	72 8e                	jb     c0105a0d <unmap_range+0x80>
}
c0105a7f:	c9                   	leave  
c0105a80:	c3                   	ret    

c0105a81 <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105a81:	55                   	push   %ebp
c0105a82:	89 e5                	mov    %esp,%ebp
c0105a84:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105a87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8a:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a8f:	85 c0                	test   %eax,%eax
c0105a91:	75 0c                	jne    c0105a9f <exit_range+0x1e>
c0105a93:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a96:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a9b:	85 c0                	test   %eax,%eax
c0105a9d:	74 24                	je     c0105ac3 <exit_range+0x42>
c0105a9f:	c7 44 24 0c 74 cc 10 	movl   $0xc010cc74,0xc(%esp)
c0105aa6:	c0 
c0105aa7:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105aae:	c0 
c0105aaf:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0105ab6:	00 
c0105ab7:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105abe:	e8 12 b3 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105ac3:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105aca:	76 11                	jbe    c0105add <exit_range+0x5c>
c0105acc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acf:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105ad2:	73 09                	jae    c0105add <exit_range+0x5c>
c0105ad4:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105adb:	76 24                	jbe    c0105b01 <exit_range+0x80>
c0105add:	c7 44 24 0c 9d cc 10 	movl   $0xc010cc9d,0xc(%esp)
c0105ae4:	c0 
c0105ae5:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105aec:	c0 
c0105aed:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0105af4:	00 
c0105af5:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105afc:	e8 d4 b2 ff ff       	call   c0100dd5 <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105b01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b0a:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105b0f:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b15:	c1 e8 16             	shr    $0x16,%eax
c0105b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b28:	01 d0                	add    %edx,%eax
c0105b2a:	8b 00                	mov    (%eax),%eax
c0105b2c:	83 e0 01             	and    $0x1,%eax
c0105b2f:	85 c0                	test   %eax,%eax
c0105b31:	74 3e                	je     c0105b71 <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b40:	01 d0                	add    %edx,%eax
c0105b42:	8b 00                	mov    (%eax),%eax
c0105b44:	89 04 24             	mov    %eax,(%esp)
c0105b47:	e8 cb f2 ff ff       	call   c0104e17 <pde2page>
c0105b4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b53:	00 
c0105b54:	89 04 24             	mov    %eax,(%esp)
c0105b57:	e8 43 f5 ff ff       	call   c010509f <free_pages>
            pgdir[pde_idx] = 0;
c0105b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b69:	01 d0                	add    %edx,%eax
c0105b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c0105b71:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b7c:	74 08                	je     c0105b86 <exit_range+0x105>
c0105b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b81:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105b84:	72 8c                	jb     c0105b12 <exit_range+0x91>
}
c0105b86:	c9                   	leave  
c0105b87:	c3                   	ret    

c0105b88 <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105b88:	55                   	push   %ebp
c0105b89:	89 e5                	mov    %esp,%ebp
c0105b8b:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105b8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b91:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105b96:	85 c0                	test   %eax,%eax
c0105b98:	75 0c                	jne    c0105ba6 <copy_range+0x1e>
c0105b9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b9d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105ba2:	85 c0                	test   %eax,%eax
c0105ba4:	74 24                	je     c0105bca <copy_range+0x42>
c0105ba6:	c7 44 24 0c 74 cc 10 	movl   $0xc010cc74,0xc(%esp)
c0105bad:	c0 
c0105bae:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105bb5:	c0 
c0105bb6:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0105bbd:	00 
c0105bbe:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105bc5:	e8 0b b2 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105bca:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105bd1:	76 11                	jbe    c0105be4 <copy_range+0x5c>
c0105bd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bd6:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105bd9:	73 09                	jae    c0105be4 <copy_range+0x5c>
c0105bdb:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105be2:	76 24                	jbe    c0105c08 <copy_range+0x80>
c0105be4:	c7 44 24 0c 9d cc 10 	movl   $0xc010cc9d,0xc(%esp)
c0105beb:	c0 
c0105bec:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105bf3:	c0 
c0105bf4:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0105bfb:	00 
c0105bfc:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105c03:	e8 cd b1 ff ff       	call   c0100dd5 <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105c08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c0f:	00 
c0105c10:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c1a:	89 04 24             	mov    %eax,(%esp)
c0105c1d:	e8 79 fb ff ff       	call   c010579b <get_pte>
c0105c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c29:	75 1b                	jne    c0105c46 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105c2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c2e:	05 00 00 40 00       	add    $0x400000,%eax
c0105c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c39:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105c3e:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105c41:	e9 47 01 00 00       	jmp    c0105d8d <copy_range+0x205>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c49:	8b 00                	mov    (%eax),%eax
c0105c4b:	83 e0 01             	and    $0x1,%eax
c0105c4e:	85 c0                	test   %eax,%eax
c0105c50:	0f 84 30 01 00 00    	je     c0105d86 <copy_range+0x1fe>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105c56:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105c5d:	00 
c0105c5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c68:	89 04 24             	mov    %eax,(%esp)
c0105c6b:	e8 2b fb ff ff       	call   c010579b <get_pte>
c0105c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105c77:	75 0a                	jne    c0105c83 <copy_range+0xfb>
                return -E_NO_MEM;
c0105c79:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105c7e:	e9 21 01 00 00       	jmp    c0105da4 <copy_range+0x21c>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c86:	8b 00                	mov    (%eax),%eax
c0105c88:	83 e0 07             	and    $0x7,%eax
c0105c8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c91:	8b 00                	mov    (%eax),%eax
c0105c93:	89 04 24             	mov    %eax,(%esp)
c0105c96:	e8 3e f1 ff ff       	call   c0104dd9 <pte2page>
c0105c9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105c9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ca5:	e8 8a f3 ff ff       	call   c0105034 <alloc_pages>
c0105caa:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105cad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cb1:	75 24                	jne    c0105cd7 <copy_range+0x14f>
c0105cb3:	c7 44 24 0c b5 cc 10 	movl   $0xc010ccb5,0xc(%esp)
c0105cba:	c0 
c0105cbb:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105cc2:	c0 
c0105cc3:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105cca:	00 
c0105ccb:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105cd2:	e8 fe b0 ff ff       	call   c0100dd5 <__panic>
        assert(npage!=NULL);
c0105cd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105cdb:	75 24                	jne    c0105d01 <copy_range+0x179>
c0105cdd:	c7 44 24 0c c0 cc 10 	movl   $0xc010ccc0,0xc(%esp)
c0105ce4:	c0 
c0105ce5:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105cec:	c0 
c0105ced:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105cf4:	00 
c0105cf5:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105cfc:	e8 d4 b0 ff ff       	call   c0100dd5 <__panic>
        int ret=0;
c0105d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        void *va1,*va2;
		va1 = page2kva(page);
c0105d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d0b:	89 04 24             	mov    %eax,(%esp)
c0105d0e:	e8 72 f0 ff ff       	call   c0104d85 <page2kva>
c0105d13:	89 45 d8             	mov    %eax,-0x28(%ebp)
        va2 = page2kva(npage);
c0105d16:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d19:	89 04 24             	mov    %eax,(%esp)
c0105d1c:	e8 64 f0 ff ff       	call   c0104d85 <page2kva>
c0105d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(va2,va1,PGSIZE);
c0105d24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105d2b:	00 
c0105d2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d36:	89 04 24             	mov    %eax,(%esp)
c0105d39:	e8 83 5f 00 00       	call   c010bcc1 <memcpy>
        assert(page_insert(to, npage, start, perm) == 0);
c0105d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d41:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d45:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d48:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d53:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d56:	89 04 24             	mov    %eax,(%esp)
c0105d59:	e8 8c 00 00 00       	call   c0105dea <page_insert>
c0105d5e:	85 c0                	test   %eax,%eax
c0105d60:	74 24                	je     c0105d86 <copy_range+0x1fe>
c0105d62:	c7 44 24 0c cc cc 10 	movl   $0xc010cccc,0xc(%esp)
c0105d69:	c0 
c0105d6a:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105d71:	c0 
c0105d72:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105d79:	00 
c0105d7a:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105d81:	e8 4f b0 ff ff       	call   c0100dd5 <__panic>
        }
        start += PGSIZE;
c0105d86:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d91:	74 0c                	je     c0105d9f <copy_range+0x217>
c0105d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d96:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105d99:	0f 82 69 fe ff ff    	jb     c0105c08 <copy_range+0x80>
    return 0;
c0105d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105da4:	c9                   	leave  
c0105da5:	c3                   	ret    

c0105da6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105da6:	55                   	push   %ebp
c0105da7:	89 e5                	mov    %esp,%ebp
c0105da9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105dac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105db3:	00 
c0105db4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105db7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbe:	89 04 24             	mov    %eax,(%esp)
c0105dc1:	e8 d5 f9 ff ff       	call   c010579b <get_pte>
c0105dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105dcd:	74 19                	je     c0105de8 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de0:	89 04 24             	mov    %eax,(%esp)
c0105de3:	e8 44 fb ff ff       	call   c010592c <page_remove_pte>
    }
}
c0105de8:	c9                   	leave  
c0105de9:	c3                   	ret    

c0105dea <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105dea:	55                   	push   %ebp
c0105deb:	89 e5                	mov    %esp,%ebp
c0105ded:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105df0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105df7:	00 
c0105df8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e02:	89 04 24             	mov    %eax,(%esp)
c0105e05:	e8 91 f9 ff ff       	call   c010579b <get_pte>
c0105e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e11:	75 0a                	jne    c0105e1d <page_insert+0x33>
        return -E_NO_MEM;
c0105e13:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105e18:	e9 84 00 00 00       	jmp    c0105ea1 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e20:	89 04 24             	mov    %eax,(%esp)
c0105e23:	e8 1e f0 ff ff       	call   c0104e46 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e2b:	8b 00                	mov    (%eax),%eax
c0105e2d:	83 e0 01             	and    $0x1,%eax
c0105e30:	85 c0                	test   %eax,%eax
c0105e32:	74 3e                	je     c0105e72 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e37:	8b 00                	mov    (%eax),%eax
c0105e39:	89 04 24             	mov    %eax,(%esp)
c0105e3c:	e8 98 ef ff ff       	call   c0104dd9 <pte2page>
c0105e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e47:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e4a:	75 0d                	jne    c0105e59 <page_insert+0x6f>
            page_ref_dec(page);
c0105e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e4f:	89 04 24             	mov    %eax,(%esp)
c0105e52:	e8 06 f0 ff ff       	call   c0104e5d <page_ref_dec>
c0105e57:	eb 19                	jmp    c0105e72 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e60:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e6a:	89 04 24             	mov    %eax,(%esp)
c0105e6d:	e8 ba fa ff ff       	call   c010592c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105e72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e75:	89 04 24             	mov    %eax,(%esp)
c0105e78:	e8 ad ee ff ff       	call   c0104d2a <page2pa>
c0105e7d:	0b 45 14             	or     0x14(%ebp),%eax
c0105e80:	83 c8 01             	or     $0x1,%eax
c0105e83:	89 c2                	mov    %eax,%edx
c0105e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e88:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105e8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e94:	89 04 24             	mov    %eax,(%esp)
c0105e97:	e8 07 00 00 00       	call   c0105ea3 <tlb_invalidate>
    return 0;
c0105e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ea1:	c9                   	leave  
c0105ea2:	c3                   	ret    

c0105ea3 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105ea3:	55                   	push   %ebp
c0105ea4:	89 e5                	mov    %esp,%ebp
c0105ea6:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105ea9:	0f 20 d8             	mov    %cr3,%eax
c0105eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105eb2:	89 c2                	mov    %eax,%edx
c0105eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eba:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105ec1:	77 23                	ja     c0105ee6 <tlb_invalidate+0x43>
c0105ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ec6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105eca:	c7 44 24 08 f0 cb 10 	movl   $0xc010cbf0,0x8(%esp)
c0105ed1:	c0 
c0105ed2:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105ed9:	00 
c0105eda:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105ee1:	e8 ef ae ff ff       	call   c0100dd5 <__panic>
c0105ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ee9:	05 00 00 00 40       	add    $0x40000000,%eax
c0105eee:	39 c2                	cmp    %eax,%edx
c0105ef0:	75 0c                	jne    c0105efe <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105efb:	0f 01 38             	invlpg (%eax)
    }
}
c0105efe:	c9                   	leave  
c0105eff:	c3                   	ret    

c0105f00 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105f00:	55                   	push   %ebp
c0105f01:	89 e5                	mov    %esp,%ebp
c0105f03:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105f06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f0d:	e8 22 f1 ff ff       	call   c0105034 <alloc_pages>
c0105f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f19:	0f 84 b0 00 00 00    	je     c0105fcf <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105f1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f22:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f29:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f37:	89 04 24             	mov    %eax,(%esp)
c0105f3a:	e8 ab fe ff ff       	call   c0105dea <page_insert>
c0105f3f:	85 c0                	test   %eax,%eax
c0105f41:	74 1a                	je     c0105f5d <pgdir_alloc_page+0x5d>
            free_page(page);
c0105f43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f4a:	00 
c0105f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4e:	89 04 24             	mov    %eax,(%esp)
c0105f51:	e8 49 f1 ff ff       	call   c010509f <free_pages>
            return NULL;
c0105f56:	b8 00 00 00 00       	mov    $0x0,%eax
c0105f5b:	eb 75                	jmp    c0105fd2 <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0105f5d:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0105f62:	85 c0                	test   %eax,%eax
c0105f64:	74 69                	je     c0105fcf <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c0105f66:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0105f6b:	85 c0                	test   %eax,%eax
c0105f6d:	74 60                	je     c0105fcf <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0105f6f:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0105f74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105f7b:	00 
c0105f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f7f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105f83:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105f86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f8a:	89 04 24             	mov    %eax,(%esp)
c0105f8d:	e8 3e 0e 00 00       	call   c0106dd0 <swap_map_swappable>
                page->pra_vaddr=la;
c0105f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f95:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105f98:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c0105f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f9e:	89 04 24             	mov    %eax,(%esp)
c0105fa1:	e8 89 ee ff ff       	call   c0104e2f <page_ref>
c0105fa6:	83 f8 01             	cmp    $0x1,%eax
c0105fa9:	74 24                	je     c0105fcf <pgdir_alloc_page+0xcf>
c0105fab:	c7 44 24 0c f5 cc 10 	movl   $0xc010ccf5,0xc(%esp)
c0105fb2:	c0 
c0105fb3:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0105fba:	c0 
c0105fbb:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c0105fc2:	00 
c0105fc3:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0105fca:	e8 06 ae ff ff       	call   c0100dd5 <__panic>
            }
        }

    }

    return page;
c0105fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105fd2:	c9                   	leave  
c0105fd3:	c3                   	ret    

c0105fd4 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105fd4:	55                   	push   %ebp
c0105fd5:	89 e5                	mov    %esp,%ebp
c0105fd7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105fda:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105fdf:	8b 40 18             	mov    0x18(%eax),%eax
c0105fe2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105fe4:	c7 04 24 0c cd 10 c0 	movl   $0xc010cd0c,(%esp)
c0105feb:	e8 63 a3 ff ff       	call   c0100353 <cprintf>
}
c0105ff0:	c9                   	leave  
c0105ff1:	c3                   	ret    

c0105ff2 <check_pgdir>:

static void
check_pgdir(void) {
c0105ff2:	55                   	push   %ebp
c0105ff3:	89 e5                	mov    %esp,%ebp
c0105ff5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105ff8:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105ffd:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0106002:	76 24                	jbe    c0106028 <check_pgdir+0x36>
c0106004:	c7 44 24 0c 2b cd 10 	movl   $0xc010cd2b,0xc(%esp)
c010600b:	c0 
c010600c:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106013:	c0 
c0106014:	c7 44 24 04 82 02 00 	movl   $0x282,0x4(%esp)
c010601b:	00 
c010601c:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106023:	e8 ad ad ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0106028:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010602d:	85 c0                	test   %eax,%eax
c010602f:	74 0e                	je     c010603f <check_pgdir+0x4d>
c0106031:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106036:	25 ff 0f 00 00       	and    $0xfff,%eax
c010603b:	85 c0                	test   %eax,%eax
c010603d:	74 24                	je     c0106063 <check_pgdir+0x71>
c010603f:	c7 44 24 0c 48 cd 10 	movl   $0xc010cd48,0xc(%esp)
c0106046:	c0 
c0106047:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010604e:	c0 
c010604f:	c7 44 24 04 83 02 00 	movl   $0x283,0x4(%esp)
c0106056:	00 
c0106057:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010605e:	e8 72 ad ff ff       	call   c0100dd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0106063:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106068:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010606f:	00 
c0106070:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106077:	00 
c0106078:	89 04 24             	mov    %eax,(%esp)
c010607b:	e8 53 f8 ff ff       	call   c01058d3 <get_page>
c0106080:	85 c0                	test   %eax,%eax
c0106082:	74 24                	je     c01060a8 <check_pgdir+0xb6>
c0106084:	c7 44 24 0c 80 cd 10 	movl   $0xc010cd80,0xc(%esp)
c010608b:	c0 
c010608c:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106093:	c0 
c0106094:	c7 44 24 04 84 02 00 	movl   $0x284,0x4(%esp)
c010609b:	00 
c010609c:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01060a3:	e8 2d ad ff ff       	call   c0100dd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01060a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060af:	e8 80 ef ff ff       	call   c0105034 <alloc_pages>
c01060b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01060b7:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01060bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01060c3:	00 
c01060c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01060cb:	00 
c01060cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060cf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060d3:	89 04 24             	mov    %eax,(%esp)
c01060d6:	e8 0f fd ff ff       	call   c0105dea <page_insert>
c01060db:	85 c0                	test   %eax,%eax
c01060dd:	74 24                	je     c0106103 <check_pgdir+0x111>
c01060df:	c7 44 24 0c a8 cd 10 	movl   $0xc010cda8,0xc(%esp)
c01060e6:	c0 
c01060e7:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01060ee:	c0 
c01060ef:	c7 44 24 04 88 02 00 	movl   $0x288,0x4(%esp)
c01060f6:	00 
c01060f7:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01060fe:	e8 d2 ac ff ff       	call   c0100dd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0106103:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106108:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010610f:	00 
c0106110:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106117:	00 
c0106118:	89 04 24             	mov    %eax,(%esp)
c010611b:	e8 7b f6 ff ff       	call   c010579b <get_pte>
c0106120:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106123:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106127:	75 24                	jne    c010614d <check_pgdir+0x15b>
c0106129:	c7 44 24 0c d4 cd 10 	movl   $0xc010cdd4,0xc(%esp)
c0106130:	c0 
c0106131:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106138:	c0 
c0106139:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
c0106140:	00 
c0106141:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106148:	e8 88 ac ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c010614d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106150:	8b 00                	mov    (%eax),%eax
c0106152:	89 04 24             	mov    %eax,(%esp)
c0106155:	e8 e6 eb ff ff       	call   c0104d40 <pa2page>
c010615a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010615d:	74 24                	je     c0106183 <check_pgdir+0x191>
c010615f:	c7 44 24 0c 01 ce 10 	movl   $0xc010ce01,0xc(%esp)
c0106166:	c0 
c0106167:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010616e:	c0 
c010616f:	c7 44 24 04 8c 02 00 	movl   $0x28c,0x4(%esp)
c0106176:	00 
c0106177:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010617e:	e8 52 ac ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 1);
c0106183:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106186:	89 04 24             	mov    %eax,(%esp)
c0106189:	e8 a1 ec ff ff       	call   c0104e2f <page_ref>
c010618e:	83 f8 01             	cmp    $0x1,%eax
c0106191:	74 24                	je     c01061b7 <check_pgdir+0x1c5>
c0106193:	c7 44 24 0c 16 ce 10 	movl   $0xc010ce16,0xc(%esp)
c010619a:	c0 
c010619b:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01061a2:	c0 
c01061a3:	c7 44 24 04 8d 02 00 	movl   $0x28d,0x4(%esp)
c01061aa:	00 
c01061ab:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01061b2:	e8 1e ac ff ff       	call   c0100dd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01061b7:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01061bc:	8b 00                	mov    (%eax),%eax
c01061be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01061c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061c9:	c1 e8 0c             	shr    $0xc,%eax
c01061cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061cf:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01061d4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01061d7:	72 23                	jb     c01061fc <check_pgdir+0x20a>
c01061d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061e0:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c01061e7:	c0 
c01061e8:	c7 44 24 04 8f 02 00 	movl   $0x28f,0x4(%esp)
c01061ef:	00 
c01061f0:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01061f7:	e8 d9 ab ff ff       	call   c0100dd5 <__panic>
c01061fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061ff:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106204:	83 c0 04             	add    $0x4,%eax
c0106207:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010620a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010620f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106216:	00 
c0106217:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010621e:	00 
c010621f:	89 04 24             	mov    %eax,(%esp)
c0106222:	e8 74 f5 ff ff       	call   c010579b <get_pte>
c0106227:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010622a:	74 24                	je     c0106250 <check_pgdir+0x25e>
c010622c:	c7 44 24 0c 28 ce 10 	movl   $0xc010ce28,0xc(%esp)
c0106233:	c0 
c0106234:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010623b:	c0 
c010623c:	c7 44 24 04 90 02 00 	movl   $0x290,0x4(%esp)
c0106243:	00 
c0106244:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010624b:	e8 85 ab ff ff       	call   c0100dd5 <__panic>

    p2 = alloc_page();
c0106250:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106257:	e8 d8 ed ff ff       	call   c0105034 <alloc_pages>
c010625c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010625f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106264:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010626b:	00 
c010626c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106273:	00 
c0106274:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106277:	89 54 24 04          	mov    %edx,0x4(%esp)
c010627b:	89 04 24             	mov    %eax,(%esp)
c010627e:	e8 67 fb ff ff       	call   c0105dea <page_insert>
c0106283:	85 c0                	test   %eax,%eax
c0106285:	74 24                	je     c01062ab <check_pgdir+0x2b9>
c0106287:	c7 44 24 0c 50 ce 10 	movl   $0xc010ce50,0xc(%esp)
c010628e:	c0 
c010628f:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106296:	c0 
c0106297:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c010629e:	00 
c010629f:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01062a6:	e8 2a ab ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01062ab:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01062b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062b7:	00 
c01062b8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01062bf:	00 
c01062c0:	89 04 24             	mov    %eax,(%esp)
c01062c3:	e8 d3 f4 ff ff       	call   c010579b <get_pte>
c01062c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01062cf:	75 24                	jne    c01062f5 <check_pgdir+0x303>
c01062d1:	c7 44 24 0c 88 ce 10 	movl   $0xc010ce88,0xc(%esp)
c01062d8:	c0 
c01062d9:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01062e0:	c0 
c01062e1:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c01062e8:	00 
c01062e9:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01062f0:	e8 e0 aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_U);
c01062f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062f8:	8b 00                	mov    (%eax),%eax
c01062fa:	83 e0 04             	and    $0x4,%eax
c01062fd:	85 c0                	test   %eax,%eax
c01062ff:	75 24                	jne    c0106325 <check_pgdir+0x333>
c0106301:	c7 44 24 0c b8 ce 10 	movl   $0xc010ceb8,0xc(%esp)
c0106308:	c0 
c0106309:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106310:	c0 
c0106311:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c0106318:	00 
c0106319:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106320:	e8 b0 aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_W);
c0106325:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106328:	8b 00                	mov    (%eax),%eax
c010632a:	83 e0 02             	and    $0x2,%eax
c010632d:	85 c0                	test   %eax,%eax
c010632f:	75 24                	jne    c0106355 <check_pgdir+0x363>
c0106331:	c7 44 24 0c c6 ce 10 	movl   $0xc010cec6,0xc(%esp)
c0106338:	c0 
c0106339:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106340:	c0 
c0106341:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c0106348:	00 
c0106349:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106350:	e8 80 aa ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0106355:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010635a:	8b 00                	mov    (%eax),%eax
c010635c:	83 e0 04             	and    $0x4,%eax
c010635f:	85 c0                	test   %eax,%eax
c0106361:	75 24                	jne    c0106387 <check_pgdir+0x395>
c0106363:	c7 44 24 0c d4 ce 10 	movl   $0xc010ced4,0xc(%esp)
c010636a:	c0 
c010636b:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106372:	c0 
c0106373:	c7 44 24 04 97 02 00 	movl   $0x297,0x4(%esp)
c010637a:	00 
c010637b:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106382:	e8 4e aa ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 1);
c0106387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010638a:	89 04 24             	mov    %eax,(%esp)
c010638d:	e8 9d ea ff ff       	call   c0104e2f <page_ref>
c0106392:	83 f8 01             	cmp    $0x1,%eax
c0106395:	74 24                	je     c01063bb <check_pgdir+0x3c9>
c0106397:	c7 44 24 0c ea ce 10 	movl   $0xc010ceea,0xc(%esp)
c010639e:	c0 
c010639f:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01063a6:	c0 
c01063a7:	c7 44 24 04 98 02 00 	movl   $0x298,0x4(%esp)
c01063ae:	00 
c01063af:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01063b6:	e8 1a aa ff ff       	call   c0100dd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01063bb:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01063c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01063c7:	00 
c01063c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01063cf:	00 
c01063d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063d3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063d7:	89 04 24             	mov    %eax,(%esp)
c01063da:	e8 0b fa ff ff       	call   c0105dea <page_insert>
c01063df:	85 c0                	test   %eax,%eax
c01063e1:	74 24                	je     c0106407 <check_pgdir+0x415>
c01063e3:	c7 44 24 0c fc ce 10 	movl   $0xc010cefc,0xc(%esp)
c01063ea:	c0 
c01063eb:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01063f2:	c0 
c01063f3:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c01063fa:	00 
c01063fb:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106402:	e8 ce a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 2);
c0106407:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010640a:	89 04 24             	mov    %eax,(%esp)
c010640d:	e8 1d ea ff ff       	call   c0104e2f <page_ref>
c0106412:	83 f8 02             	cmp    $0x2,%eax
c0106415:	74 24                	je     c010643b <check_pgdir+0x449>
c0106417:	c7 44 24 0c 28 cf 10 	movl   $0xc010cf28,0xc(%esp)
c010641e:	c0 
c010641f:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106426:	c0 
c0106427:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c010642e:	00 
c010642f:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106436:	e8 9a a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c010643b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010643e:	89 04 24             	mov    %eax,(%esp)
c0106441:	e8 e9 e9 ff ff       	call   c0104e2f <page_ref>
c0106446:	85 c0                	test   %eax,%eax
c0106448:	74 24                	je     c010646e <check_pgdir+0x47c>
c010644a:	c7 44 24 0c 3a cf 10 	movl   $0xc010cf3a,0xc(%esp)
c0106451:	c0 
c0106452:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106459:	c0 
c010645a:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c0106461:	00 
c0106462:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106469:	e8 67 a9 ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010646e:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106473:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010647a:	00 
c010647b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106482:	00 
c0106483:	89 04 24             	mov    %eax,(%esp)
c0106486:	e8 10 f3 ff ff       	call   c010579b <get_pte>
c010648b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010648e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106492:	75 24                	jne    c01064b8 <check_pgdir+0x4c6>
c0106494:	c7 44 24 0c 88 ce 10 	movl   $0xc010ce88,0xc(%esp)
c010649b:	c0 
c010649c:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01064a3:	c0 
c01064a4:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c01064ab:	00 
c01064ac:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01064b3:	e8 1d a9 ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c01064b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064bb:	8b 00                	mov    (%eax),%eax
c01064bd:	89 04 24             	mov    %eax,(%esp)
c01064c0:	e8 7b e8 ff ff       	call   c0104d40 <pa2page>
c01064c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01064c8:	74 24                	je     c01064ee <check_pgdir+0x4fc>
c01064ca:	c7 44 24 0c 01 ce 10 	movl   $0xc010ce01,0xc(%esp)
c01064d1:	c0 
c01064d2:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01064d9:	c0 
c01064da:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c01064e1:	00 
c01064e2:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01064e9:	e8 e7 a8 ff ff       	call   c0100dd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c01064ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064f1:	8b 00                	mov    (%eax),%eax
c01064f3:	83 e0 04             	and    $0x4,%eax
c01064f6:	85 c0                	test   %eax,%eax
c01064f8:	74 24                	je     c010651e <check_pgdir+0x52c>
c01064fa:	c7 44 24 0c 4c cf 10 	movl   $0xc010cf4c,0xc(%esp)
c0106501:	c0 
c0106502:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106509:	c0 
c010650a:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c0106511:	00 
c0106512:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106519:	e8 b7 a8 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c010651e:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106523:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010652a:	00 
c010652b:	89 04 24             	mov    %eax,(%esp)
c010652e:	e8 73 f8 ff ff       	call   c0105da6 <page_remove>
    assert(page_ref(p1) == 1);
c0106533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106536:	89 04 24             	mov    %eax,(%esp)
c0106539:	e8 f1 e8 ff ff       	call   c0104e2f <page_ref>
c010653e:	83 f8 01             	cmp    $0x1,%eax
c0106541:	74 24                	je     c0106567 <check_pgdir+0x575>
c0106543:	c7 44 24 0c 16 ce 10 	movl   $0xc010ce16,0xc(%esp)
c010654a:	c0 
c010654b:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106552:	c0 
c0106553:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c010655a:	00 
c010655b:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106562:	e8 6e a8 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c0106567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010656a:	89 04 24             	mov    %eax,(%esp)
c010656d:	e8 bd e8 ff ff       	call   c0104e2f <page_ref>
c0106572:	85 c0                	test   %eax,%eax
c0106574:	74 24                	je     c010659a <check_pgdir+0x5a8>
c0106576:	c7 44 24 0c 3a cf 10 	movl   $0xc010cf3a,0xc(%esp)
c010657d:	c0 
c010657e:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106585:	c0 
c0106586:	c7 44 24 04 a3 02 00 	movl   $0x2a3,0x4(%esp)
c010658d:	00 
c010658e:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106595:	e8 3b a8 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010659a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010659f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01065a6:	00 
c01065a7:	89 04 24             	mov    %eax,(%esp)
c01065aa:	e8 f7 f7 ff ff       	call   c0105da6 <page_remove>
    assert(page_ref(p1) == 0);
c01065af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065b2:	89 04 24             	mov    %eax,(%esp)
c01065b5:	e8 75 e8 ff ff       	call   c0104e2f <page_ref>
c01065ba:	85 c0                	test   %eax,%eax
c01065bc:	74 24                	je     c01065e2 <check_pgdir+0x5f0>
c01065be:	c7 44 24 0c 61 cf 10 	movl   $0xc010cf61,0xc(%esp)
c01065c5:	c0 
c01065c6:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01065cd:	c0 
c01065ce:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c01065d5:	00 
c01065d6:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01065dd:	e8 f3 a7 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c01065e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065e5:	89 04 24             	mov    %eax,(%esp)
c01065e8:	e8 42 e8 ff ff       	call   c0104e2f <page_ref>
c01065ed:	85 c0                	test   %eax,%eax
c01065ef:	74 24                	je     c0106615 <check_pgdir+0x623>
c01065f1:	c7 44 24 0c 3a cf 10 	movl   $0xc010cf3a,0xc(%esp)
c01065f8:	c0 
c01065f9:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106600:	c0 
c0106601:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c0106608:	00 
c0106609:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106610:	e8 c0 a7 ff ff       	call   c0100dd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0106615:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010661a:	8b 00                	mov    (%eax),%eax
c010661c:	89 04 24             	mov    %eax,(%esp)
c010661f:	e8 1c e7 ff ff       	call   c0104d40 <pa2page>
c0106624:	89 04 24             	mov    %eax,(%esp)
c0106627:	e8 03 e8 ff ff       	call   c0104e2f <page_ref>
c010662c:	83 f8 01             	cmp    $0x1,%eax
c010662f:	74 24                	je     c0106655 <check_pgdir+0x663>
c0106631:	c7 44 24 0c 74 cf 10 	movl   $0xc010cf74,0xc(%esp)
c0106638:	c0 
c0106639:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106640:	c0 
c0106641:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c0106648:	00 
c0106649:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106650:	e8 80 a7 ff ff       	call   c0100dd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0106655:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010665a:	8b 00                	mov    (%eax),%eax
c010665c:	89 04 24             	mov    %eax,(%esp)
c010665f:	e8 dc e6 ff ff       	call   c0104d40 <pa2page>
c0106664:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010666b:	00 
c010666c:	89 04 24             	mov    %eax,(%esp)
c010666f:	e8 2b ea ff ff       	call   c010509f <free_pages>
    boot_pgdir[0] = 0;
c0106674:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010667f:	c7 04 24 9a cf 10 c0 	movl   $0xc010cf9a,(%esp)
c0106686:	e8 c8 9c ff ff       	call   c0100353 <cprintf>
}
c010668b:	c9                   	leave  
c010668c:	c3                   	ret    

c010668d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010668d:	55                   	push   %ebp
c010668e:	89 e5                	mov    %esp,%ebp
c0106690:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010669a:	e9 ca 00 00 00       	jmp    c0106769 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010669f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066a8:	c1 e8 0c             	shr    $0xc,%eax
c01066ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01066ae:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01066b3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01066b6:	72 23                	jb     c01066db <check_boot_pgdir+0x4e>
c01066b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01066bf:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c01066c6:	c0 
c01066c7:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c01066ce:	00 
c01066cf:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01066d6:	e8 fa a6 ff ff       	call   c0100dd5 <__panic>
c01066db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066de:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01066e3:	89 c2                	mov    %eax,%edx
c01066e5:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01066ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01066f1:	00 
c01066f2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066f6:	89 04 24             	mov    %eax,(%esp)
c01066f9:	e8 9d f0 ff ff       	call   c010579b <get_pte>
c01066fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106701:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106705:	75 24                	jne    c010672b <check_boot_pgdir+0x9e>
c0106707:	c7 44 24 0c b4 cf 10 	movl   $0xc010cfb4,0xc(%esp)
c010670e:	c0 
c010670f:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106716:	c0 
c0106717:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c010671e:	00 
c010671f:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106726:	e8 aa a6 ff ff       	call   c0100dd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010672b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010672e:	8b 00                	mov    (%eax),%eax
c0106730:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106735:	89 c2                	mov    %eax,%edx
c0106737:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010673a:	39 c2                	cmp    %eax,%edx
c010673c:	74 24                	je     c0106762 <check_boot_pgdir+0xd5>
c010673e:	c7 44 24 0c f1 cf 10 	movl   $0xc010cff1,0xc(%esp)
c0106745:	c0 
c0106746:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010674d:	c0 
c010674e:	c7 44 24 04 b6 02 00 	movl   $0x2b6,0x4(%esp)
c0106755:	00 
c0106756:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010675d:	e8 73 a6 ff ff       	call   c0100dd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106762:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106769:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010676c:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106771:	39 c2                	cmp    %eax,%edx
c0106773:	0f 82 26 ff ff ff    	jb     c010669f <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106779:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010677e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106783:	8b 00                	mov    (%eax),%eax
c0106785:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010678a:	89 c2                	mov    %eax,%edx
c010678c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106794:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010679b:	77 23                	ja     c01067c0 <check_boot_pgdir+0x133>
c010679d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067a4:	c7 44 24 08 f0 cb 10 	movl   $0xc010cbf0,0x8(%esp)
c01067ab:	c0 
c01067ac:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01067b3:	00 
c01067b4:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01067bb:	e8 15 a6 ff ff       	call   c0100dd5 <__panic>
c01067c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067c3:	05 00 00 00 40       	add    $0x40000000,%eax
c01067c8:	39 c2                	cmp    %eax,%edx
c01067ca:	74 24                	je     c01067f0 <check_boot_pgdir+0x163>
c01067cc:	c7 44 24 0c 08 d0 10 	movl   $0xc010d008,0xc(%esp)
c01067d3:	c0 
c01067d4:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01067db:	c0 
c01067dc:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01067e3:	00 
c01067e4:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01067eb:	e8 e5 a5 ff ff       	call   c0100dd5 <__panic>

    assert(boot_pgdir[0] == 0);
c01067f0:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01067f5:	8b 00                	mov    (%eax),%eax
c01067f7:	85 c0                	test   %eax,%eax
c01067f9:	74 24                	je     c010681f <check_boot_pgdir+0x192>
c01067fb:	c7 44 24 0c 3c d0 10 	movl   $0xc010d03c,0xc(%esp)
c0106802:	c0 
c0106803:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010680a:	c0 
c010680b:	c7 44 24 04 bb 02 00 	movl   $0x2bb,0x4(%esp)
c0106812:	00 
c0106813:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010681a:	e8 b6 a5 ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    p = alloc_page();
c010681f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106826:	e8 09 e8 ff ff       	call   c0105034 <alloc_pages>
c010682b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010682e:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106833:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010683a:	00 
c010683b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106842:	00 
c0106843:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106846:	89 54 24 04          	mov    %edx,0x4(%esp)
c010684a:	89 04 24             	mov    %eax,(%esp)
c010684d:	e8 98 f5 ff ff       	call   c0105dea <page_insert>
c0106852:	85 c0                	test   %eax,%eax
c0106854:	74 24                	je     c010687a <check_boot_pgdir+0x1ed>
c0106856:	c7 44 24 0c 50 d0 10 	movl   $0xc010d050,0xc(%esp)
c010685d:	c0 
c010685e:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106865:	c0 
c0106866:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c010686d:	00 
c010686e:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106875:	e8 5b a5 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 1);
c010687a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010687d:	89 04 24             	mov    %eax,(%esp)
c0106880:	e8 aa e5 ff ff       	call   c0104e2f <page_ref>
c0106885:	83 f8 01             	cmp    $0x1,%eax
c0106888:	74 24                	je     c01068ae <check_boot_pgdir+0x221>
c010688a:	c7 44 24 0c 7e d0 10 	movl   $0xc010d07e,0xc(%esp)
c0106891:	c0 
c0106892:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106899:	c0 
c010689a:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c01068a1:	00 
c01068a2:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01068a9:	e8 27 a5 ff ff       	call   c0100dd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01068ae:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01068b3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01068ba:	00 
c01068bb:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01068c2:	00 
c01068c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01068c6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068ca:	89 04 24             	mov    %eax,(%esp)
c01068cd:	e8 18 f5 ff ff       	call   c0105dea <page_insert>
c01068d2:	85 c0                	test   %eax,%eax
c01068d4:	74 24                	je     c01068fa <check_boot_pgdir+0x26d>
c01068d6:	c7 44 24 0c 90 d0 10 	movl   $0xc010d090,0xc(%esp)
c01068dd:	c0 
c01068de:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01068e5:	c0 
c01068e6:	c7 44 24 04 c1 02 00 	movl   $0x2c1,0x4(%esp)
c01068ed:	00 
c01068ee:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01068f5:	e8 db a4 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 2);
c01068fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068fd:	89 04 24             	mov    %eax,(%esp)
c0106900:	e8 2a e5 ff ff       	call   c0104e2f <page_ref>
c0106905:	83 f8 02             	cmp    $0x2,%eax
c0106908:	74 24                	je     c010692e <check_boot_pgdir+0x2a1>
c010690a:	c7 44 24 0c c7 d0 10 	movl   $0xc010d0c7,0xc(%esp)
c0106911:	c0 
c0106912:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c0106919:	c0 
c010691a:	c7 44 24 04 c2 02 00 	movl   $0x2c2,0x4(%esp)
c0106921:	00 
c0106922:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c0106929:	e8 a7 a4 ff ff       	call   c0100dd5 <__panic>

    const char *str = "ucore: Hello world!!";
c010692e:	c7 45 dc d8 d0 10 c0 	movl   $0xc010d0d8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106935:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106938:	89 44 24 04          	mov    %eax,0x4(%esp)
c010693c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106943:	e8 c0 4f 00 00       	call   c010b908 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106948:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010694f:	00 
c0106950:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106957:	e8 25 50 00 00       	call   c010b981 <strcmp>
c010695c:	85 c0                	test   %eax,%eax
c010695e:	74 24                	je     c0106984 <check_boot_pgdir+0x2f7>
c0106960:	c7 44 24 0c f0 d0 10 	movl   $0xc010d0f0,0xc(%esp)
c0106967:	c0 
c0106968:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c010696f:	c0 
c0106970:	c7 44 24 04 c6 02 00 	movl   $0x2c6,0x4(%esp)
c0106977:	00 
c0106978:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c010697f:	e8 51 a4 ff ff       	call   c0100dd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106984:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106987:	89 04 24             	mov    %eax,(%esp)
c010698a:	e8 f6 e3 ff ff       	call   c0104d85 <page2kva>
c010698f:	05 00 01 00 00       	add    $0x100,%eax
c0106994:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106997:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010699e:	e8 0d 4f 00 00       	call   c010b8b0 <strlen>
c01069a3:	85 c0                	test   %eax,%eax
c01069a5:	74 24                	je     c01069cb <check_boot_pgdir+0x33e>
c01069a7:	c7 44 24 0c 28 d1 10 	movl   $0xc010d128,0xc(%esp)
c01069ae:	c0 
c01069af:	c7 44 24 08 39 cc 10 	movl   $0xc010cc39,0x8(%esp)
c01069b6:	c0 
c01069b7:	c7 44 24 04 c9 02 00 	movl   $0x2c9,0x4(%esp)
c01069be:	00 
c01069bf:	c7 04 24 14 cc 10 c0 	movl   $0xc010cc14,(%esp)
c01069c6:	e8 0a a4 ff ff       	call   c0100dd5 <__panic>

    free_page(p);
c01069cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069d2:	00 
c01069d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01069d6:	89 04 24             	mov    %eax,(%esp)
c01069d9:	e8 c1 e6 ff ff       	call   c010509f <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01069de:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01069e3:	8b 00                	mov    (%eax),%eax
c01069e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069ea:	89 04 24             	mov    %eax,(%esp)
c01069ed:	e8 4e e3 ff ff       	call   c0104d40 <pa2page>
c01069f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069f9:	00 
c01069fa:	89 04 24             	mov    %eax,(%esp)
c01069fd:	e8 9d e6 ff ff       	call   c010509f <free_pages>
    boot_pgdir[0] = 0;
c0106a02:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106a07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106a0d:	c7 04 24 4c d1 10 c0 	movl   $0xc010d14c,(%esp)
c0106a14:	e8 3a 99 ff ff       	call   c0100353 <cprintf>
}
c0106a19:	c9                   	leave  
c0106a1a:	c3                   	ret    

c0106a1b <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106a1b:	55                   	push   %ebp
c0106a1c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a21:	83 e0 04             	and    $0x4,%eax
c0106a24:	85 c0                	test   %eax,%eax
c0106a26:	74 07                	je     c0106a2f <perm2str+0x14>
c0106a28:	b8 75 00 00 00       	mov    $0x75,%eax
c0106a2d:	eb 05                	jmp    c0106a34 <perm2str+0x19>
c0106a2f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106a34:	a2 68 cf 19 c0       	mov    %al,0xc019cf68
    str[1] = 'r';
c0106a39:	c6 05 69 cf 19 c0 72 	movb   $0x72,0xc019cf69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a43:	83 e0 02             	and    $0x2,%eax
c0106a46:	85 c0                	test   %eax,%eax
c0106a48:	74 07                	je     c0106a51 <perm2str+0x36>
c0106a4a:	b8 77 00 00 00       	mov    $0x77,%eax
c0106a4f:	eb 05                	jmp    c0106a56 <perm2str+0x3b>
c0106a51:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106a56:	a2 6a cf 19 c0       	mov    %al,0xc019cf6a
    str[3] = '\0';
c0106a5b:	c6 05 6b cf 19 c0 00 	movb   $0x0,0xc019cf6b
    return str;
c0106a62:	b8 68 cf 19 c0       	mov    $0xc019cf68,%eax
}
c0106a67:	5d                   	pop    %ebp
c0106a68:	c3                   	ret    

c0106a69 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106a69:	55                   	push   %ebp
c0106a6a:	89 e5                	mov    %esp,%ebp
c0106a6c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106a6f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a72:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106a75:	72 0a                	jb     c0106a81 <get_pgtable_items+0x18>
        return 0;
c0106a77:	b8 00 00 00 00       	mov    $0x0,%eax
c0106a7c:	e9 9c 00 00 00       	jmp    c0106b1d <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106a81:	eb 04                	jmp    c0106a87 <get_pgtable_items+0x1e>
        start ++;
c0106a83:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106a87:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106a8d:	73 18                	jae    c0106aa7 <get_pgtable_items+0x3e>
c0106a8f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106a99:	8b 45 14             	mov    0x14(%ebp),%eax
c0106a9c:	01 d0                	add    %edx,%eax
c0106a9e:	8b 00                	mov    (%eax),%eax
c0106aa0:	83 e0 01             	and    $0x1,%eax
c0106aa3:	85 c0                	test   %eax,%eax
c0106aa5:	74 dc                	je     c0106a83 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106aa7:	8b 45 10             	mov    0x10(%ebp),%eax
c0106aaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106aad:	73 69                	jae    c0106b18 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106aaf:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106ab3:	74 08                	je     c0106abd <get_pgtable_items+0x54>
            *left_store = start;
c0106ab5:	8b 45 18             	mov    0x18(%ebp),%eax
c0106ab8:	8b 55 10             	mov    0x10(%ebp),%edx
c0106abb:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106abd:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ac0:	8d 50 01             	lea    0x1(%eax),%edx
c0106ac3:	89 55 10             	mov    %edx,0x10(%ebp)
c0106ac6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106acd:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ad0:	01 d0                	add    %edx,%eax
c0106ad2:	8b 00                	mov    (%eax),%eax
c0106ad4:	83 e0 07             	and    $0x7,%eax
c0106ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106ada:	eb 04                	jmp    c0106ae0 <get_pgtable_items+0x77>
            start ++;
c0106adc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106ae0:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ae3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106ae6:	73 1d                	jae    c0106b05 <get_pgtable_items+0x9c>
c0106ae8:	8b 45 10             	mov    0x10(%ebp),%eax
c0106aeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106af2:	8b 45 14             	mov    0x14(%ebp),%eax
c0106af5:	01 d0                	add    %edx,%eax
c0106af7:	8b 00                	mov    (%eax),%eax
c0106af9:	83 e0 07             	and    $0x7,%eax
c0106afc:	89 c2                	mov    %eax,%edx
c0106afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b01:	39 c2                	cmp    %eax,%edx
c0106b03:	74 d7                	je     c0106adc <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106b05:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106b09:	74 08                	je     c0106b13 <get_pgtable_items+0xaa>
            *right_store = start;
c0106b0b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106b0e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106b11:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b16:	eb 05                	jmp    c0106b1d <get_pgtable_items+0xb4>
    }
    return 0;
c0106b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b1d:	c9                   	leave  
c0106b1e:	c3                   	ret    

c0106b1f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106b1f:	55                   	push   %ebp
c0106b20:	89 e5                	mov    %esp,%ebp
c0106b22:	57                   	push   %edi
c0106b23:	56                   	push   %esi
c0106b24:	53                   	push   %ebx
c0106b25:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106b28:	c7 04 24 6c d1 10 c0 	movl   $0xc010d16c,(%esp)
c0106b2f:	e8 1f 98 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106b34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106b3b:	e9 fa 00 00 00       	jmp    c0106c3a <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106b40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b43:	89 04 24             	mov    %eax,(%esp)
c0106b46:	e8 d0 fe ff ff       	call   c0106a1b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106b4b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106b4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b51:	29 d1                	sub    %edx,%ecx
c0106b53:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106b55:	89 d6                	mov    %edx,%esi
c0106b57:	c1 e6 16             	shl    $0x16,%esi
c0106b5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106b5d:	89 d3                	mov    %edx,%ebx
c0106b5f:	c1 e3 16             	shl    $0x16,%ebx
c0106b62:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b65:	89 d1                	mov    %edx,%ecx
c0106b67:	c1 e1 16             	shl    $0x16,%ecx
c0106b6a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106b6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b70:	29 d7                	sub    %edx,%edi
c0106b72:	89 fa                	mov    %edi,%edx
c0106b74:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106b78:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106b7c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106b80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106b84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b88:	c7 04 24 9d d1 10 c0 	movl   $0xc010d19d,(%esp)
c0106b8f:	e8 bf 97 ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b97:	c1 e0 0a             	shl    $0xa,%eax
c0106b9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106b9d:	eb 54                	jmp    c0106bf3 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ba2:	89 04 24             	mov    %eax,(%esp)
c0106ba5:	e8 71 fe ff ff       	call   c0106a1b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106baa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106bad:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106bb0:	29 d1                	sub    %edx,%ecx
c0106bb2:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106bb4:	89 d6                	mov    %edx,%esi
c0106bb6:	c1 e6 0c             	shl    $0xc,%esi
c0106bb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106bbc:	89 d3                	mov    %edx,%ebx
c0106bbe:	c1 e3 0c             	shl    $0xc,%ebx
c0106bc1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106bc4:	c1 e2 0c             	shl    $0xc,%edx
c0106bc7:	89 d1                	mov    %edx,%ecx
c0106bc9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106bcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106bcf:	29 d7                	sub    %edx,%edi
c0106bd1:	89 fa                	mov    %edi,%edx
c0106bd3:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106bd7:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106bdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106bdf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106be3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106be7:	c7 04 24 bc d1 10 c0 	movl   $0xc010d1bc,(%esp)
c0106bee:	e8 60 97 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106bf3:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106bfb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106bfe:	89 ce                	mov    %ecx,%esi
c0106c00:	c1 e6 0a             	shl    $0xa,%esi
c0106c03:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106c06:	89 cb                	mov    %ecx,%ebx
c0106c08:	c1 e3 0a             	shl    $0xa,%ebx
c0106c0b:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106c0e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106c12:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106c15:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106c19:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106c1d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c21:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106c25:	89 1c 24             	mov    %ebx,(%esp)
c0106c28:	e8 3c fe ff ff       	call   c0106a69 <get_pgtable_items>
c0106c2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c34:	0f 85 65 ff ff ff    	jne    c0106b9f <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106c3a:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c42:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106c45:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106c49:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106c4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106c50:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106c54:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c58:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106c5f:	00 
c0106c60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106c67:	e8 fd fd ff ff       	call   c0106a69 <get_pgtable_items>
c0106c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c73:	0f 85 c7 fe ff ff    	jne    c0106b40 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106c79:	c7 04 24 e0 d1 10 c0 	movl   $0xc010d1e0,(%esp)
c0106c80:	e8 ce 96 ff ff       	call   c0100353 <cprintf>
}
c0106c85:	83 c4 4c             	add    $0x4c,%esp
c0106c88:	5b                   	pop    %ebx
c0106c89:	5e                   	pop    %esi
c0106c8a:	5f                   	pop    %edi
c0106c8b:	5d                   	pop    %ebp
c0106c8c:	c3                   	ret    

c0106c8d <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106c8d:	55                   	push   %ebp
c0106c8e:	89 e5                	mov    %esp,%ebp
c0106c90:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c96:	c1 e8 0c             	shr    $0xc,%eax
c0106c99:	89 c2                	mov    %eax,%edx
c0106c9b:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106ca0:	39 c2                	cmp    %eax,%edx
c0106ca2:	72 1c                	jb     c0106cc0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106ca4:	c7 44 24 08 14 d2 10 	movl   $0xc010d214,0x8(%esp)
c0106cab:	c0 
c0106cac:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106cb3:	00 
c0106cb4:	c7 04 24 33 d2 10 c0 	movl   $0xc010d233,(%esp)
c0106cbb:	e8 15 a1 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106cc0:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0106cc5:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cc8:	c1 ea 0c             	shr    $0xc,%edx
c0106ccb:	c1 e2 05             	shl    $0x5,%edx
c0106cce:	01 d0                	add    %edx,%eax
}
c0106cd0:	c9                   	leave  
c0106cd1:	c3                   	ret    

c0106cd2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106cd2:	55                   	push   %ebp
c0106cd3:	89 e5                	mov    %esp,%ebp
c0106cd5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cdb:	83 e0 01             	and    $0x1,%eax
c0106cde:	85 c0                	test   %eax,%eax
c0106ce0:	75 1c                	jne    c0106cfe <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106ce2:	c7 44 24 08 44 d2 10 	movl   $0xc010d244,0x8(%esp)
c0106ce9:	c0 
c0106cea:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106cf1:	00 
c0106cf2:	c7 04 24 33 d2 10 c0 	movl   $0xc010d233,(%esp)
c0106cf9:	e8 d7 a0 ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106d06:	89 04 24             	mov    %eax,(%esp)
c0106d09:	e8 7f ff ff ff       	call   c0106c8d <pa2page>
}
c0106d0e:	c9                   	leave  
c0106d0f:	c3                   	ret    

c0106d10 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106d10:	55                   	push   %ebp
c0106d11:	89 e5                	mov    %esp,%ebp
c0106d13:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106d16:	e8 53 23 00 00       	call   c010906e <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106d1b:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d20:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106d25:	76 0c                	jbe    c0106d33 <swap_init+0x23>
c0106d27:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d2c:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106d31:	76 25                	jbe    c0106d58 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106d33:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d38:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106d3c:	c7 44 24 08 65 d2 10 	movl   $0xc010d265,0x8(%esp)
c0106d43:	c0 
c0106d44:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106d4b:	00 
c0106d4c:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0106d53:	e8 7d a0 ff ff       	call   c0100dd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106d58:	c7 05 74 cf 19 c0 60 	movl   $0xc012aa60,0xc019cf74
c0106d5f:	aa 12 c0 
     int r = sm->init();
c0106d62:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106d67:	8b 40 04             	mov    0x4(%eax),%eax
c0106d6a:	ff d0                	call   *%eax
c0106d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d73:	75 26                	jne    c0106d9b <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106d75:	c7 05 6c cf 19 c0 01 	movl   $0x1,0xc019cf6c
c0106d7c:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106d7f:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106d84:	8b 00                	mov    (%eax),%eax
c0106d86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d8a:	c7 04 24 8f d2 10 c0 	movl   $0xc010d28f,(%esp)
c0106d91:	e8 bd 95 ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106d96:	e8 a4 04 00 00       	call   c010723f <check_swap>
     }

     return r;
c0106d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106d9e:	c9                   	leave  
c0106d9f:	c3                   	ret    

c0106da0 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106da0:	55                   	push   %ebp
c0106da1:	89 e5                	mov    %esp,%ebp
c0106da3:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106da6:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106dab:	8b 40 08             	mov    0x8(%eax),%eax
c0106dae:	8b 55 08             	mov    0x8(%ebp),%edx
c0106db1:	89 14 24             	mov    %edx,(%esp)
c0106db4:	ff d0                	call   *%eax
}
c0106db6:	c9                   	leave  
c0106db7:	c3                   	ret    

c0106db8 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106db8:	55                   	push   %ebp
c0106db9:	89 e5                	mov    %esp,%ebp
c0106dbb:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106dbe:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106dc3:	8b 40 0c             	mov    0xc(%eax),%eax
c0106dc6:	8b 55 08             	mov    0x8(%ebp),%edx
c0106dc9:	89 14 24             	mov    %edx,(%esp)
c0106dcc:	ff d0                	call   *%eax
}
c0106dce:	c9                   	leave  
c0106dcf:	c3                   	ret    

c0106dd0 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106dd0:	55                   	push   %ebp
c0106dd1:	89 e5                	mov    %esp,%ebp
c0106dd3:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106dd6:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106ddb:	8b 40 10             	mov    0x10(%eax),%eax
c0106dde:	8b 55 14             	mov    0x14(%ebp),%edx
c0106de1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106de5:	8b 55 10             	mov    0x10(%ebp),%edx
c0106de8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106dec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106def:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106df3:	8b 55 08             	mov    0x8(%ebp),%edx
c0106df6:	89 14 24             	mov    %edx,(%esp)
c0106df9:	ff d0                	call   *%eax
}
c0106dfb:	c9                   	leave  
c0106dfc:	c3                   	ret    

c0106dfd <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106dfd:	55                   	push   %ebp
c0106dfe:	89 e5                	mov    %esp,%ebp
c0106e00:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106e03:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e08:	8b 40 14             	mov    0x14(%eax),%eax
c0106e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e0e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e12:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e15:	89 14 24             	mov    %edx,(%esp)
c0106e18:	ff d0                	call   *%eax
}
c0106e1a:	c9                   	leave  
c0106e1b:	c3                   	ret    

c0106e1c <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106e1c:	55                   	push   %ebp
c0106e1d:	89 e5                	mov    %esp,%ebp
c0106e1f:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106e22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106e29:	e9 5a 01 00 00       	jmp    c0106f88 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106e2e:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e33:	8b 40 18             	mov    0x18(%eax),%eax
c0106e36:	8b 55 10             	mov    0x10(%ebp),%edx
c0106e39:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106e3d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106e40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e44:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e47:	89 14 24             	mov    %edx,(%esp)
c0106e4a:	ff d0                	call   *%eax
c0106e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106e4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e53:	74 18                	je     c0106e6d <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e5c:	c7 04 24 a4 d2 10 c0 	movl   $0xc010d2a4,(%esp)
c0106e63:	e8 eb 94 ff ff       	call   c0100353 <cprintf>
c0106e68:	e9 27 01 00 00       	jmp    c0106f94 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e70:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106e73:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e79:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106e83:	00 
c0106e84:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e87:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e8b:	89 04 24             	mov    %eax,(%esp)
c0106e8e:	e8 08 e9 ff ff       	call   c010579b <get_pte>
c0106e93:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e99:	8b 00                	mov    (%eax),%eax
c0106e9b:	83 e0 01             	and    $0x1,%eax
c0106e9e:	85 c0                	test   %eax,%eax
c0106ea0:	75 24                	jne    c0106ec6 <swap_out+0xaa>
c0106ea2:	c7 44 24 0c d1 d2 10 	movl   $0xc010d2d1,0xc(%esp)
c0106ea9:	c0 
c0106eaa:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0106eb1:	c0 
c0106eb2:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106eb9:	00 
c0106eba:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0106ec1:	e8 0f 9f ff ff       	call   c0100dd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ecc:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106ecf:	c1 ea 0c             	shr    $0xc,%edx
c0106ed2:	83 c2 01             	add    $0x1,%edx
c0106ed5:	c1 e2 08             	shl    $0x8,%edx
c0106ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106edc:	89 14 24             	mov    %edx,(%esp)
c0106edf:	e8 44 22 00 00       	call   c0109128 <swapfs_write>
c0106ee4:	85 c0                	test   %eax,%eax
c0106ee6:	74 34                	je     c0106f1c <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106ee8:	c7 04 24 fb d2 10 c0 	movl   $0xc010d2fb,(%esp)
c0106eef:	e8 5f 94 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106ef4:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106ef9:	8b 40 10             	mov    0x10(%eax),%eax
c0106efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106eff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106f06:	00 
c0106f07:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106f0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f0e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f12:	8b 55 08             	mov    0x8(%ebp),%edx
c0106f15:	89 14 24             	mov    %edx,(%esp)
c0106f18:	ff d0                	call   *%eax
c0106f1a:	eb 68                	jmp    c0106f84 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f1f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f22:	c1 e8 0c             	shr    $0xc,%eax
c0106f25:	83 c0 01             	add    $0x1,%eax
c0106f28:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f2f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f3a:	c7 04 24 14 d3 10 c0 	movl   $0xc010d314,(%esp)
c0106f41:	e8 0d 94 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f49:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f4c:	c1 e8 0c             	shr    $0xc,%eax
c0106f4f:	83 c0 01             	add    $0x1,%eax
c0106f52:	c1 e0 08             	shl    $0x8,%eax
c0106f55:	89 c2                	mov    %eax,%edx
c0106f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f5a:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106f66:	00 
c0106f67:	89 04 24             	mov    %eax,(%esp)
c0106f6a:	e8 30 e1 ff ff       	call   c010509f <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f72:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f75:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f78:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f7c:	89 04 24             	mov    %eax,(%esp)
c0106f7f:	e8 1f ef ff ff       	call   c0105ea3 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106f84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f8b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106f8e:	0f 85 9a fe ff ff    	jne    c0106e2e <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106f97:	c9                   	leave  
c0106f98:	c3                   	ret    

c0106f99 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106f99:	55                   	push   %ebp
c0106f9a:	89 e5                	mov    %esp,%ebp
c0106f9c:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106f9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106fa6:	e8 89 e0 ff ff       	call   c0105034 <alloc_pages>
c0106fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106fb2:	75 24                	jne    c0106fd8 <swap_in+0x3f>
c0106fb4:	c7 44 24 0c 54 d3 10 	movl   $0xc010d354,0xc(%esp)
c0106fbb:	c0 
c0106fbc:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0106fc3:	c0 
c0106fc4:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0106fcb:	00 
c0106fcc:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0106fd3:	e8 fd 9d ff ff       	call   c0100dd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fdb:	8b 40 0c             	mov    0xc(%eax),%eax
c0106fde:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fe5:	00 
c0106fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106fe9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106fed:	89 04 24             	mov    %eax,(%esp)
c0106ff0:	e8 a6 e7 ff ff       	call   c010579b <get_pte>
c0106ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ffb:	8b 00                	mov    (%eax),%eax
c0106ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107000:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107004:	89 04 24             	mov    %eax,(%esp)
c0107007:	e8 aa 20 00 00       	call   c01090b6 <swapfs_read>
c010700c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010700f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107013:	74 2a                	je     c010703f <swap_in+0xa6>
     {
        assert(r!=0);
c0107015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107019:	75 24                	jne    c010703f <swap_in+0xa6>
c010701b:	c7 44 24 0c 61 d3 10 	movl   $0xc010d361,0xc(%esp)
c0107022:	c0 
c0107023:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010702a:	c0 
c010702b:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0107032:	00 
c0107033:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010703a:	e8 96 9d ff ff       	call   c0100dd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c010703f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107042:	8b 00                	mov    (%eax),%eax
c0107044:	c1 e8 08             	shr    $0x8,%eax
c0107047:	89 c2                	mov    %eax,%edx
c0107049:	8b 45 0c             	mov    0xc(%ebp),%eax
c010704c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107050:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107054:	c7 04 24 68 d3 10 c0 	movl   $0xc010d368,(%esp)
c010705b:	e8 f3 92 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0107060:	8b 45 10             	mov    0x10(%ebp),%eax
c0107063:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107066:	89 10                	mov    %edx,(%eax)
     return 0;
c0107068:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010706d:	c9                   	leave  
c010706e:	c3                   	ret    

c010706f <check_content_set>:



static inline void
check_content_set(void)
{
c010706f:	55                   	push   %ebp
c0107070:	89 e5                	mov    %esp,%ebp
c0107072:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0107075:	b8 00 10 00 00       	mov    $0x1000,%eax
c010707a:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010707d:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107082:	83 f8 01             	cmp    $0x1,%eax
c0107085:	74 24                	je     c01070ab <check_content_set+0x3c>
c0107087:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c010708e:	c0 
c010708f:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107096:	c0 
c0107097:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010709e:	00 
c010709f:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01070a6:	e8 2a 9d ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01070ab:	b8 10 10 00 00       	mov    $0x1010,%eax
c01070b0:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01070b3:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01070b8:	83 f8 01             	cmp    $0x1,%eax
c01070bb:	74 24                	je     c01070e1 <check_content_set+0x72>
c01070bd:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c01070c4:	c0 
c01070c5:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01070cc:	c0 
c01070cd:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01070d4:	00 
c01070d5:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01070dc:	e8 f4 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01070e1:	b8 00 20 00 00       	mov    $0x2000,%eax
c01070e6:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01070e9:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01070ee:	83 f8 02             	cmp    $0x2,%eax
c01070f1:	74 24                	je     c0107117 <check_content_set+0xa8>
c01070f3:	c7 44 24 0c b5 d3 10 	movl   $0xc010d3b5,0xc(%esp)
c01070fa:	c0 
c01070fb:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107102:	c0 
c0107103:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010710a:	00 
c010710b:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107112:	e8 be 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0107117:	b8 10 20 00 00       	mov    $0x2010,%eax
c010711c:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010711f:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107124:	83 f8 02             	cmp    $0x2,%eax
c0107127:	74 24                	je     c010714d <check_content_set+0xde>
c0107129:	c7 44 24 0c b5 d3 10 	movl   $0xc010d3b5,0xc(%esp)
c0107130:	c0 
c0107131:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107138:	c0 
c0107139:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0107140:	00 
c0107141:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107148:	e8 88 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c010714d:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107152:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0107155:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010715a:	83 f8 03             	cmp    $0x3,%eax
c010715d:	74 24                	je     c0107183 <check_content_set+0x114>
c010715f:	c7 44 24 0c c4 d3 10 	movl   $0xc010d3c4,0xc(%esp)
c0107166:	c0 
c0107167:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010716e:	c0 
c010716f:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0107176:	00 
c0107177:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010717e:	e8 52 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0107183:	b8 10 30 00 00       	mov    $0x3010,%eax
c0107188:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010718b:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107190:	83 f8 03             	cmp    $0x3,%eax
c0107193:	74 24                	je     c01071b9 <check_content_set+0x14a>
c0107195:	c7 44 24 0c c4 d3 10 	movl   $0xc010d3c4,0xc(%esp)
c010719c:	c0 
c010719d:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01071a4:	c0 
c01071a5:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01071ac:	00 
c01071ad:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01071b4:	e8 1c 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01071b9:	b8 00 40 00 00       	mov    $0x4000,%eax
c01071be:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01071c1:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071c6:	83 f8 04             	cmp    $0x4,%eax
c01071c9:	74 24                	je     c01071ef <check_content_set+0x180>
c01071cb:	c7 44 24 0c d3 d3 10 	movl   $0xc010d3d3,0xc(%esp)
c01071d2:	c0 
c01071d3:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01071da:	c0 
c01071db:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01071e2:	00 
c01071e3:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01071ea:	e8 e6 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01071ef:	b8 10 40 00 00       	mov    $0x4010,%eax
c01071f4:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01071f7:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071fc:	83 f8 04             	cmp    $0x4,%eax
c01071ff:	74 24                	je     c0107225 <check_content_set+0x1b6>
c0107201:	c7 44 24 0c d3 d3 10 	movl   $0xc010d3d3,0xc(%esp)
c0107208:	c0 
c0107209:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107210:	c0 
c0107211:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0107218:	00 
c0107219:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107220:	e8 b0 9b ff ff       	call   c0100dd5 <__panic>
}
c0107225:	c9                   	leave  
c0107226:	c3                   	ret    

c0107227 <check_content_access>:

static inline int
check_content_access(void)
{
c0107227:	55                   	push   %ebp
c0107228:	89 e5                	mov    %esp,%ebp
c010722a:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010722d:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0107232:	8b 40 1c             	mov    0x1c(%eax),%eax
c0107235:	ff d0                	call   *%eax
c0107237:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010723a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010723d:	c9                   	leave  
c010723e:	c3                   	ret    

c010723f <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010723f:	55                   	push   %ebp
c0107240:	89 e5                	mov    %esp,%ebp
c0107242:	53                   	push   %ebx
c0107243:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0107246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010724d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0107254:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010725b:	eb 6b                	jmp    c01072c8 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c010725d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107260:	83 e8 0c             	sub    $0xc,%eax
c0107263:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0107266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107269:	83 c0 04             	add    $0x4,%eax
c010726c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0107273:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107276:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0107279:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010727c:	0f a3 10             	bt     %edx,(%eax)
c010727f:	19 c0                	sbb    %eax,%eax
c0107281:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0107284:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107288:	0f 95 c0             	setne  %al
c010728b:	0f b6 c0             	movzbl %al,%eax
c010728e:	85 c0                	test   %eax,%eax
c0107290:	75 24                	jne    c01072b6 <check_swap+0x77>
c0107292:	c7 44 24 0c e2 d3 10 	movl   $0xc010d3e2,0xc(%esp)
c0107299:	c0 
c010729a:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01072a1:	c0 
c01072a2:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01072a9:	00 
c01072aa:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01072b1:	e8 1f 9b ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c01072b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01072ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072bd:	8b 50 08             	mov    0x8(%eax),%edx
c01072c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072c3:	01 d0                	add    %edx,%eax
c01072c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072cb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01072ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01072d1:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01072d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01072d7:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c01072de:	0f 85 79 ff ff ff    	jne    c010725d <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01072e4:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01072e7:	e8 e5 dd ff ff       	call   c01050d1 <nr_free_pages>
c01072ec:	39 c3                	cmp    %eax,%ebx
c01072ee:	74 24                	je     c0107314 <check_swap+0xd5>
c01072f0:	c7 44 24 0c f2 d3 10 	movl   $0xc010d3f2,0xc(%esp)
c01072f7:	c0 
c01072f8:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01072ff:	c0 
c0107300:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0107307:	00 
c0107308:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010730f:	e8 c1 9a ff ff       	call   c0100dd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0107314:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107317:	89 44 24 08          	mov    %eax,0x8(%esp)
c010731b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010731e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107322:	c7 04 24 0c d4 10 c0 	movl   $0xc010d40c,(%esp)
c0107329:	e8 25 90 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010732e:	e8 a8 0a 00 00       	call   c0107ddb <mm_create>
c0107333:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0107336:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010733a:	75 24                	jne    c0107360 <check_swap+0x121>
c010733c:	c7 44 24 0c 32 d4 10 	movl   $0xc010d432,0xc(%esp)
c0107343:	c0 
c0107344:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010734b:	c0 
c010734c:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0107353:	00 
c0107354:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010735b:	e8 75 9a ff ff       	call   c0100dd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0107360:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0107365:	85 c0                	test   %eax,%eax
c0107367:	74 24                	je     c010738d <check_swap+0x14e>
c0107369:	c7 44 24 0c 3d d4 10 	movl   $0xc010d43d,0xc(%esp)
c0107370:	c0 
c0107371:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107378:	c0 
c0107379:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107380:	00 
c0107381:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107388:	e8 48 9a ff ff       	call   c0100dd5 <__panic>

     check_mm_struct = mm;
c010738d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107390:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107395:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c010739b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010739e:	89 50 0c             	mov    %edx,0xc(%eax)
c01073a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073a4:	8b 40 0c             	mov    0xc(%eax),%eax
c01073a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01073aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073ad:	8b 00                	mov    (%eax),%eax
c01073af:	85 c0                	test   %eax,%eax
c01073b1:	74 24                	je     c01073d7 <check_swap+0x198>
c01073b3:	c7 44 24 0c 55 d4 10 	movl   $0xc010d455,0xc(%esp)
c01073ba:	c0 
c01073bb:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01073c2:	c0 
c01073c3:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01073ca:	00 
c01073cb:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01073d2:	e8 fe 99 ff ff       	call   c0100dd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01073d7:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01073de:	00 
c01073df:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01073e6:	00 
c01073e7:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01073ee:	e8 81 0a 00 00       	call   c0107e74 <vma_create>
c01073f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01073f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01073fa:	75 24                	jne    c0107420 <check_swap+0x1e1>
c01073fc:	c7 44 24 0c 63 d4 10 	movl   $0xc010d463,0xc(%esp)
c0107403:	c0 
c0107404:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010740b:	c0 
c010740c:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107413:	00 
c0107414:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010741b:	e8 b5 99 ff ff       	call   c0100dd5 <__panic>

     insert_vma_struct(mm, vma);
c0107420:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107423:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107427:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010742a:	89 04 24             	mov    %eax,(%esp)
c010742d:	e8 d2 0b 00 00       	call   c0108004 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0107432:	c7 04 24 70 d4 10 c0 	movl   $0xc010d470,(%esp)
c0107439:	e8 15 8f ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c010743e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0107445:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107448:	8b 40 0c             	mov    0xc(%eax),%eax
c010744b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107452:	00 
c0107453:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010745a:	00 
c010745b:	89 04 24             	mov    %eax,(%esp)
c010745e:	e8 38 e3 ff ff       	call   c010579b <get_pte>
c0107463:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0107466:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010746a:	75 24                	jne    c0107490 <check_swap+0x251>
c010746c:	c7 44 24 0c a4 d4 10 	movl   $0xc010d4a4,0xc(%esp)
c0107473:	c0 
c0107474:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010747b:	c0 
c010747c:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107483:	00 
c0107484:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010748b:	e8 45 99 ff ff       	call   c0100dd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0107490:	c7 04 24 b8 d4 10 c0 	movl   $0xc010d4b8,(%esp)
c0107497:	e8 b7 8e ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010749c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01074a3:	e9 a3 00 00 00       	jmp    c010754b <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01074a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01074af:	e8 80 db ff ff       	call   c0105034 <alloc_pages>
c01074b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01074b7:	89 04 95 e0 ef 19 c0 	mov    %eax,-0x3fe61020(,%edx,4)
          assert(check_rp[i] != NULL );
c01074be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074c1:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01074c8:	85 c0                	test   %eax,%eax
c01074ca:	75 24                	jne    c01074f0 <check_swap+0x2b1>
c01074cc:	c7 44 24 0c dc d4 10 	movl   $0xc010d4dc,0xc(%esp)
c01074d3:	c0 
c01074d4:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01074db:	c0 
c01074dc:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01074e3:	00 
c01074e4:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01074eb:	e8 e5 98 ff ff       	call   c0100dd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c01074f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074f3:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01074fa:	83 c0 04             	add    $0x4,%eax
c01074fd:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0107504:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107507:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010750a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010750d:	0f a3 10             	bt     %edx,(%eax)
c0107510:	19 c0                	sbb    %eax,%eax
c0107512:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0107515:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0107519:	0f 95 c0             	setne  %al
c010751c:	0f b6 c0             	movzbl %al,%eax
c010751f:	85 c0                	test   %eax,%eax
c0107521:	74 24                	je     c0107547 <check_swap+0x308>
c0107523:	c7 44 24 0c f0 d4 10 	movl   $0xc010d4f0,0xc(%esp)
c010752a:	c0 
c010752b:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107532:	c0 
c0107533:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010753a:	00 
c010753b:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107542:	e8 8e 98 ff ff       	call   c0100dd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107547:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010754b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010754f:	0f 8e 53 ff ff ff    	jle    c01074a8 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0107555:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c010755a:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0107560:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107563:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0107566:	c7 45 a8 b8 ef 19 c0 	movl   $0xc019efb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010756d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107570:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0107573:	89 50 04             	mov    %edx,0x4(%eax)
c0107576:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107579:	8b 50 04             	mov    0x4(%eax),%edx
c010757c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010757f:	89 10                	mov    %edx,(%eax)
c0107581:	c7 45 a4 b8 ef 19 c0 	movl   $0xc019efb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0107588:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010758b:	8b 40 04             	mov    0x4(%eax),%eax
c010758e:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0107591:	0f 94 c0             	sete   %al
c0107594:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0107597:	85 c0                	test   %eax,%eax
c0107599:	75 24                	jne    c01075bf <check_swap+0x380>
c010759b:	c7 44 24 0c 0b d5 10 	movl   $0xc010d50b,0xc(%esp)
c01075a2:	c0 
c01075a3:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01075aa:	c0 
c01075ab:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01075b2:	00 
c01075b3:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01075ba:	e8 16 98 ff ff       	call   c0100dd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01075bf:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01075c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01075c7:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c01075ce:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01075d8:	eb 1e                	jmp    c01075f8 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01075da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075dd:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01075e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01075eb:	00 
c01075ec:	89 04 24             	mov    %eax,(%esp)
c01075ef:	e8 ab da ff ff       	call   c010509f <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01075f8:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01075fc:	7e dc                	jle    c01075da <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01075fe:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0107603:	83 f8 04             	cmp    $0x4,%eax
c0107606:	74 24                	je     c010762c <check_swap+0x3ed>
c0107608:	c7 44 24 0c 24 d5 10 	movl   $0xc010d524,0xc(%esp)
c010760f:	c0 
c0107610:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107617:	c0 
c0107618:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010761f:	00 
c0107620:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107627:	e8 a9 97 ff ff       	call   c0100dd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010762c:	c7 04 24 48 d5 10 c0 	movl   $0xc010d548,(%esp)
c0107633:	e8 1b 8d ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0107638:	c7 05 78 cf 19 c0 00 	movl   $0x0,0xc019cf78
c010763f:	00 00 00 
     
     check_content_set();
c0107642:	e8 28 fa ff ff       	call   c010706f <check_content_set>
     assert( nr_free == 0);         
c0107647:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010764c:	85 c0                	test   %eax,%eax
c010764e:	74 24                	je     c0107674 <check_swap+0x435>
c0107650:	c7 44 24 0c 6f d5 10 	movl   $0xc010d56f,0xc(%esp)
c0107657:	c0 
c0107658:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010765f:	c0 
c0107660:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0107667:	00 
c0107668:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010766f:	e8 61 97 ff ff       	call   c0100dd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107674:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010767b:	eb 26                	jmp    c01076a3 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c010767d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107680:	c7 04 85 00 f0 19 c0 	movl   $0xffffffff,-0x3fe61000(,%eax,4)
c0107687:	ff ff ff ff 
c010768b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010768e:	8b 14 85 00 f0 19 c0 	mov    -0x3fe61000(,%eax,4),%edx
c0107695:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107698:	89 14 85 40 f0 19 c0 	mov    %edx,-0x3fe60fc0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010769f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01076a3:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01076a7:	7e d4                	jle    c010767d <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01076a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01076b0:	e9 eb 00 00 00       	jmp    c01077a0 <check_swap+0x561>
         check_ptep[i]=0;
c01076b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076b8:	c7 04 85 94 f0 19 c0 	movl   $0x0,-0x3fe60f6c(,%eax,4)
c01076bf:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01076c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076c6:	83 c0 01             	add    $0x1,%eax
c01076c9:	c1 e0 0c             	shl    $0xc,%eax
c01076cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01076d3:	00 
c01076d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076db:	89 04 24             	mov    %eax,(%esp)
c01076de:	e8 b8 e0 ff ff       	call   c010579b <get_pte>
c01076e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01076e6:	89 04 95 94 f0 19 c0 	mov    %eax,-0x3fe60f6c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01076ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076f0:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c01076f7:	85 c0                	test   %eax,%eax
c01076f9:	75 24                	jne    c010771f <check_swap+0x4e0>
c01076fb:	c7 44 24 0c 7c d5 10 	movl   $0xc010d57c,0xc(%esp)
c0107702:	c0 
c0107703:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c010770a:	c0 
c010770b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107712:	00 
c0107713:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c010771a:	e8 b6 96 ff ff       	call   c0100dd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010771f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107722:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107729:	8b 00                	mov    (%eax),%eax
c010772b:	89 04 24             	mov    %eax,(%esp)
c010772e:	e8 9f f5 ff ff       	call   c0106cd2 <pte2page>
c0107733:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107736:	8b 14 95 e0 ef 19 c0 	mov    -0x3fe61020(,%edx,4),%edx
c010773d:	39 d0                	cmp    %edx,%eax
c010773f:	74 24                	je     c0107765 <check_swap+0x526>
c0107741:	c7 44 24 0c 94 d5 10 	movl   $0xc010d594,0xc(%esp)
c0107748:	c0 
c0107749:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107750:	c0 
c0107751:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107758:	00 
c0107759:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107760:	e8 70 96 ff ff       	call   c0100dd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107765:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107768:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c010776f:	8b 00                	mov    (%eax),%eax
c0107771:	83 e0 01             	and    $0x1,%eax
c0107774:	85 c0                	test   %eax,%eax
c0107776:	75 24                	jne    c010779c <check_swap+0x55d>
c0107778:	c7 44 24 0c bc d5 10 	movl   $0xc010d5bc,0xc(%esp)
c010777f:	c0 
c0107780:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c0107787:	c0 
c0107788:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010778f:	00 
c0107790:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c0107797:	e8 39 96 ff ff       	call   c0100dd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010779c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01077a0:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01077a4:	0f 8e 0b ff ff ff    	jle    c01076b5 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01077aa:	c7 04 24 d8 d5 10 c0 	movl   $0xc010d5d8,(%esp)
c01077b1:	e8 9d 8b ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01077b6:	e8 6c fa ff ff       	call   c0107227 <check_content_access>
c01077bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01077be:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01077c2:	74 24                	je     c01077e8 <check_swap+0x5a9>
c01077c4:	c7 44 24 0c fe d5 10 	movl   $0xc010d5fe,0xc(%esp)
c01077cb:	c0 
c01077cc:	c7 44 24 08 e6 d2 10 	movl   $0xc010d2e6,0x8(%esp)
c01077d3:	c0 
c01077d4:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01077db:	00 
c01077dc:	c7 04 24 80 d2 10 c0 	movl   $0xc010d280,(%esp)
c01077e3:	e8 ed 95 ff ff       	call   c0100dd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01077e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01077ef:	eb 1e                	jmp    c010780f <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01077f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077f4:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01077fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107802:	00 
c0107803:	89 04 24             	mov    %eax,(%esp)
c0107806:	e8 94 d8 ff ff       	call   c010509f <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010780b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010780f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107813:	7e dc                	jle    c01077f1 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pa2page(pgdir[0]));
c0107815:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107818:	8b 00                	mov    (%eax),%eax
c010781a:	89 04 24             	mov    %eax,(%esp)
c010781d:	e8 6b f4 ff ff       	call   c0106c8d <pa2page>
c0107822:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107829:	00 
c010782a:	89 04 24             	mov    %eax,(%esp)
c010782d:	e8 6d d8 ff ff       	call   c010509f <free_pages>
     pgdir[0] = 0;
c0107832:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107835:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c010783b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010783e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c0107845:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107848:	89 04 24             	mov    %eax,(%esp)
c010784b:	e8 e4 08 00 00       	call   c0108134 <mm_destroy>
     check_mm_struct = NULL;
c0107850:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0107857:	00 00 00 
     
     nr_free = nr_free_store;
c010785a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010785d:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
     free_list = free_list_store;
c0107862:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107865:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107868:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c010786d:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc

     
     le = &free_list;
c0107873:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010787a:	eb 1d                	jmp    c0107899 <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c010787c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010787f:	83 e8 0c             	sub    $0xc,%eax
c0107882:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107885:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107889:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010788c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010788f:	8b 40 08             	mov    0x8(%eax),%eax
c0107892:	29 c2                	sub    %eax,%edx
c0107894:	89 d0                	mov    %edx,%eax
c0107896:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107899:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010789c:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010789f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01078a2:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01078a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01078a8:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c01078af:	75 cb                	jne    c010787c <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c01078b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01078b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078bf:	c7 04 24 05 d6 10 c0 	movl   $0xc010d605,(%esp)
c01078c6:	e8 88 8a ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01078cb:	c7 04 24 1f d6 10 c0 	movl   $0xc010d61f,(%esp)
c01078d2:	e8 7c 8a ff ff       	call   c0100353 <cprintf>
}
c01078d7:	83 c4 74             	add    $0x74,%esp
c01078da:	5b                   	pop    %ebx
c01078db:	5d                   	pop    %ebp
c01078dc:	c3                   	ret    

c01078dd <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01078dd:	55                   	push   %ebp
c01078de:	89 e5                	mov    %esp,%ebp
c01078e0:	83 ec 10             	sub    $0x10,%esp
c01078e3:	c7 45 fc a4 f0 19 c0 	movl   $0xc019f0a4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01078ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01078f0:	89 50 04             	mov    %edx,0x4(%eax)
c01078f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078f6:	8b 50 04             	mov    0x4(%eax),%edx
c01078f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078fc:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01078fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0107901:	c7 40 14 a4 f0 19 c0 	movl   $0xc019f0a4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107908:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010790d:	c9                   	leave  
c010790e:	c3                   	ret    

c010790f <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010790f:	55                   	push   %ebp
c0107910:	89 e5                	mov    %esp,%ebp
c0107912:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107915:	8b 45 08             	mov    0x8(%ebp),%eax
c0107918:	8b 40 14             	mov    0x14(%eax),%eax
c010791b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c010791e:	8b 45 10             	mov    0x10(%ebp),%eax
c0107921:	83 c0 14             	add    $0x14,%eax
c0107924:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010792b:	74 06                	je     c0107933 <_fifo_map_swappable+0x24>
c010792d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107931:	75 24                	jne    c0107957 <_fifo_map_swappable+0x48>
c0107933:	c7 44 24 0c 38 d6 10 	movl   $0xc010d638,0xc(%esp)
c010793a:	c0 
c010793b:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107942:	c0 
c0107943:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010794a:	00 
c010794b:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107952:	e8 7e 94 ff ff       	call   c0100dd5 <__panic>
c0107957:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010795a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010795d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107960:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107963:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107969:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010796c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010796f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107972:	8b 40 04             	mov    0x4(%eax),%eax
c0107975:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107978:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010797b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010797e:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107981:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107984:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107987:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010798a:	89 10                	mov    %edx,(%eax)
c010798c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010798f:	8b 10                	mov    (%eax),%edx
c0107991:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107994:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107997:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010799a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010799d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01079a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01079a6:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c01079a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01079ad:	c9                   	leave  
c01079ae:	c3                   	ret    

c01079af <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01079af:	55                   	push   %ebp
c01079b0:	89 e5                	mov    %esp,%ebp
c01079b2:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01079b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01079b8:	8b 40 14             	mov    0x14(%eax),%eax
c01079bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01079be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079c2:	75 24                	jne    c01079e8 <_fifo_swap_out_victim+0x39>
c01079c4:	c7 44 24 0c 7f d6 10 	movl   $0xc010d67f,0xc(%esp)
c01079cb:	c0 
c01079cc:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c01079d3:	c0 
c01079d4:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01079db:	00 
c01079dc:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c01079e3:	e8 ed 93 ff ff       	call   c0100dd5 <__panic>
     assert(in_tick==0);
c01079e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01079ec:	74 24                	je     c0107a12 <_fifo_swap_out_victim+0x63>
c01079ee:	c7 44 24 0c 8c d6 10 	movl   $0xc010d68c,0xc(%esp)
c01079f5:	c0 
c01079f6:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c01079fd:	c0 
c01079fe:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107a05:	00 
c0107a06:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107a0d:	e8 c3 93 ff ff       	call   c0100dd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     /* Select the tail */
     list_entry_t *le = head->prev;
c0107a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a15:	8b 00                	mov    (%eax),%eax
c0107a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0107a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107a20:	75 24                	jne    c0107a46 <_fifo_swap_out_victim+0x97>
c0107a22:	c7 44 24 0c 97 d6 10 	movl   $0xc010d697,0xc(%esp)
c0107a29:	c0 
c0107a2a:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107a31:	c0 
c0107a32:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0107a39:	00 
c0107a3a:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107a41:	e8 8f 93 ff ff       	call   c0100dd5 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c0107a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a49:	83 e8 14             	sub    $0x14,%eax
c0107a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a52:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a58:	8b 40 04             	mov    0x4(%eax),%eax
c0107a5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107a5e:	8b 12                	mov    (%edx),%edx
c0107a60:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107a6c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a75:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c0107a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107a7b:	75 24                	jne    c0107aa1 <_fifo_swap_out_victim+0xf2>
c0107a7d:	c7 44 24 0c a0 d6 10 	movl   $0xc010d6a0,0xc(%esp)
c0107a84:	c0 
c0107a85:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107a8c:	c0 
c0107a8d:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
c0107a94:	00 
c0107a95:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107a9c:	e8 34 93 ff ff       	call   c0100dd5 <__panic>
     *ptr_page = p;
c0107aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107aa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107aa7:	89 10                	mov    %edx,(%eax)
     return 0;
c0107aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107aae:	c9                   	leave  
c0107aaf:	c3                   	ret    

c0107ab0 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107ab0:	55                   	push   %ebp
c0107ab1:	89 e5                	mov    %esp,%ebp
c0107ab3:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107ab6:	c7 04 24 ac d6 10 c0 	movl   $0xc010d6ac,(%esp)
c0107abd:	e8 91 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107ac2:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107ac7:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107aca:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107acf:	83 f8 04             	cmp    $0x4,%eax
c0107ad2:	74 24                	je     c0107af8 <_fifo_check_swap+0x48>
c0107ad4:	c7 44 24 0c d2 d6 10 	movl   $0xc010d6d2,0xc(%esp)
c0107adb:	c0 
c0107adc:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107ae3:	c0 
c0107ae4:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0107aeb:	00 
c0107aec:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107af3:	e8 dd 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107af8:	c7 04 24 e4 d6 10 c0 	movl   $0xc010d6e4,(%esp)
c0107aff:	e8 4f 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107b04:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107b09:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107b0c:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b11:	83 f8 04             	cmp    $0x4,%eax
c0107b14:	74 24                	je     c0107b3a <_fifo_check_swap+0x8a>
c0107b16:	c7 44 24 0c d2 d6 10 	movl   $0xc010d6d2,0xc(%esp)
c0107b1d:	c0 
c0107b1e:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107b25:	c0 
c0107b26:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0107b2d:	00 
c0107b2e:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107b35:	e8 9b 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107b3a:	c7 04 24 0c d7 10 c0 	movl   $0xc010d70c,(%esp)
c0107b41:	e8 0d 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107b46:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107b4b:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107b4e:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b53:	83 f8 04             	cmp    $0x4,%eax
c0107b56:	74 24                	je     c0107b7c <_fifo_check_swap+0xcc>
c0107b58:	c7 44 24 0c d2 d6 10 	movl   $0xc010d6d2,0xc(%esp)
c0107b5f:	c0 
c0107b60:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107b67:	c0 
c0107b68:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107b6f:	00 
c0107b70:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107b77:	e8 59 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107b7c:	c7 04 24 34 d7 10 c0 	movl   $0xc010d734,(%esp)
c0107b83:	e8 cb 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107b88:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107b8d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107b90:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b95:	83 f8 04             	cmp    $0x4,%eax
c0107b98:	74 24                	je     c0107bbe <_fifo_check_swap+0x10e>
c0107b9a:	c7 44 24 0c d2 d6 10 	movl   $0xc010d6d2,0xc(%esp)
c0107ba1:	c0 
c0107ba2:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107ba9:	c0 
c0107baa:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107bb1:	00 
c0107bb2:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107bb9:	e8 17 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107bbe:	c7 04 24 5c d7 10 c0 	movl   $0xc010d75c,(%esp)
c0107bc5:	e8 89 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107bca:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107bcf:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107bd2:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107bd7:	83 f8 05             	cmp    $0x5,%eax
c0107bda:	74 24                	je     c0107c00 <_fifo_check_swap+0x150>
c0107bdc:	c7 44 24 0c 82 d7 10 	movl   $0xc010d782,0xc(%esp)
c0107be3:	c0 
c0107be4:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107beb:	c0 
c0107bec:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107bf3:	00 
c0107bf4:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107bfb:	e8 d5 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107c00:	c7 04 24 34 d7 10 c0 	movl   $0xc010d734,(%esp)
c0107c07:	e8 47 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107c0c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107c11:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107c14:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c19:	83 f8 05             	cmp    $0x5,%eax
c0107c1c:	74 24                	je     c0107c42 <_fifo_check_swap+0x192>
c0107c1e:	c7 44 24 0c 82 d7 10 	movl   $0xc010d782,0xc(%esp)
c0107c25:	c0 
c0107c26:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107c2d:	c0 
c0107c2e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0107c35:	00 
c0107c36:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107c3d:	e8 93 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107c42:	c7 04 24 e4 d6 10 c0 	movl   $0xc010d6e4,(%esp)
c0107c49:	e8 05 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107c4e:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107c53:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107c56:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c5b:	83 f8 06             	cmp    $0x6,%eax
c0107c5e:	74 24                	je     c0107c84 <_fifo_check_swap+0x1d4>
c0107c60:	c7 44 24 0c 91 d7 10 	movl   $0xc010d791,0xc(%esp)
c0107c67:	c0 
c0107c68:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107c6f:	c0 
c0107c70:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107c77:	00 
c0107c78:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107c7f:	e8 51 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107c84:	c7 04 24 34 d7 10 c0 	movl   $0xc010d734,(%esp)
c0107c8b:	e8 c3 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107c90:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107c95:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107c98:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c9d:	83 f8 07             	cmp    $0x7,%eax
c0107ca0:	74 24                	je     c0107cc6 <_fifo_check_swap+0x216>
c0107ca2:	c7 44 24 0c a0 d7 10 	movl   $0xc010d7a0,0xc(%esp)
c0107ca9:	c0 
c0107caa:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107cb1:	c0 
c0107cb2:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107cb9:	00 
c0107cba:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107cc1:	e8 0f 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107cc6:	c7 04 24 ac d6 10 c0 	movl   $0xc010d6ac,(%esp)
c0107ccd:	e8 81 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107cd2:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107cd7:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107cda:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107cdf:	83 f8 08             	cmp    $0x8,%eax
c0107ce2:	74 24                	je     c0107d08 <_fifo_check_swap+0x258>
c0107ce4:	c7 44 24 0c af d7 10 	movl   $0xc010d7af,0xc(%esp)
c0107ceb:	c0 
c0107cec:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107cf3:	c0 
c0107cf4:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107cfb:	00 
c0107cfc:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107d03:	e8 cd 90 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107d08:	c7 04 24 0c d7 10 c0 	movl   $0xc010d70c,(%esp)
c0107d0f:	e8 3f 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107d14:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107d19:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107d1c:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107d21:	83 f8 09             	cmp    $0x9,%eax
c0107d24:	74 24                	je     c0107d4a <_fifo_check_swap+0x29a>
c0107d26:	c7 44 24 0c be d7 10 	movl   $0xc010d7be,0xc(%esp)
c0107d2d:	c0 
c0107d2e:	c7 44 24 08 56 d6 10 	movl   $0xc010d656,0x8(%esp)
c0107d35:	c0 
c0107d36:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107d3d:	00 
c0107d3e:	c7 04 24 6b d6 10 c0 	movl   $0xc010d66b,(%esp)
c0107d45:	e8 8b 90 ff ff       	call   c0100dd5 <__panic>
    return 0;
c0107d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d4f:	c9                   	leave  
c0107d50:	c3                   	ret    

c0107d51 <_fifo_init>:


static int
_fifo_init(void)
{
c0107d51:	55                   	push   %ebp
c0107d52:	89 e5                	mov    %esp,%ebp
    return 0;
c0107d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d59:	5d                   	pop    %ebp
c0107d5a:	c3                   	ret    

c0107d5b <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107d5b:	55                   	push   %ebp
c0107d5c:	89 e5                	mov    %esp,%ebp
    return 0;
c0107d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d63:	5d                   	pop    %ebp
c0107d64:	c3                   	ret    

c0107d65 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107d65:	55                   	push   %ebp
c0107d66:	89 e5                	mov    %esp,%ebp
c0107d68:	b8 00 00 00 00       	mov    $0x0,%eax
c0107d6d:	5d                   	pop    %ebp
c0107d6e:	c3                   	ret    

c0107d6f <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107d6f:	55                   	push   %ebp
c0107d70:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107d7b:	5d                   	pop    %ebp
c0107d7c:	c3                   	ret    

c0107d7d <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107d7d:	55                   	push   %ebp
c0107d7e:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d83:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107d86:	5d                   	pop    %ebp
c0107d87:	c3                   	ret    

c0107d88 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107d88:	55                   	push   %ebp
c0107d89:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107d91:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107d94:	5d                   	pop    %ebp
c0107d95:	c3                   	ret    

c0107d96 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107d96:	55                   	push   %ebp
c0107d97:	89 e5                	mov    %esp,%ebp
c0107d99:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d9f:	c1 e8 0c             	shr    $0xc,%eax
c0107da2:	89 c2                	mov    %eax,%edx
c0107da4:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0107da9:	39 c2                	cmp    %eax,%edx
c0107dab:	72 1c                	jb     c0107dc9 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107dad:	c7 44 24 08 e0 d7 10 	movl   $0xc010d7e0,0x8(%esp)
c0107db4:	c0 
c0107db5:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107dbc:	00 
c0107dbd:	c7 04 24 ff d7 10 c0 	movl   $0xc010d7ff,(%esp)
c0107dc4:	e8 0c 90 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0107dc9:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0107dce:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dd1:	c1 ea 0c             	shr    $0xc,%edx
c0107dd4:	c1 e2 05             	shl    $0x5,%edx
c0107dd7:	01 d0                	add    %edx,%eax
}
c0107dd9:	c9                   	leave  
c0107dda:	c3                   	ret    

c0107ddb <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107ddb:	55                   	push   %ebp
c0107ddc:	89 e5                	mov    %esp,%ebp
c0107dde:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107de1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107de8:	e8 d2 cd ff ff       	call   c0104bbf <kmalloc>
c0107ded:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107df4:	74 79                	je     c0107e6f <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107dff:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107e02:	89 50 04             	mov    %edx,0x4(%eax)
c0107e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e08:	8b 50 04             	mov    0x4(%eax),%edx
c0107e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e0e:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e27:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107e2e:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0107e33:	85 c0                	test   %eax,%eax
c0107e35:	74 0d                	je     c0107e44 <mm_create+0x69>
c0107e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e3a:	89 04 24             	mov    %eax,(%esp)
c0107e3d:	e8 5e ef ff ff       	call   c0106da0 <swap_init_mm>
c0107e42:	eb 0a                	jmp    c0107e4e <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e47:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0107e4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107e55:	00 
c0107e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e59:	89 04 24             	mov    %eax,(%esp)
c0107e5c:	e8 27 ff ff ff       	call   c0107d88 <set_mm_count>
        lock_init(&(mm->mm_lock));
c0107e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e64:	83 c0 1c             	add    $0x1c,%eax
c0107e67:	89 04 24             	mov    %eax,(%esp)
c0107e6a:	e8 00 ff ff ff       	call   c0107d6f <lock_init>
    }    
    return mm;
c0107e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107e72:	c9                   	leave  
c0107e73:	c3                   	ret    

c0107e74 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107e74:	55                   	push   %ebp
c0107e75:	89 e5                	mov    %esp,%ebp
c0107e77:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107e7a:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107e81:	e8 39 cd ff ff       	call   c0104bbf <kmalloc>
c0107e86:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e8d:	74 1b                	je     c0107eaa <vma_create+0x36>
        vma->vm_start = vm_start;
c0107e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e92:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e95:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107e9e:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ea4:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ea7:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107ead:	c9                   	leave  
c0107eae:	c3                   	ret    

c0107eaf <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107eaf:	55                   	push   %ebp
c0107eb0:	89 e5                	mov    %esp,%ebp
c0107eb2:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107ebc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107ec0:	0f 84 95 00 00 00    	je     c0107f5b <find_vma+0xac>
        vma = mm->mmap_cache;
c0107ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ec9:	8b 40 08             	mov    0x8(%eax),%eax
c0107ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107ecf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107ed3:	74 16                	je     c0107eeb <find_vma+0x3c>
c0107ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ed8:	8b 40 04             	mov    0x4(%eax),%eax
c0107edb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ede:	77 0b                	ja     c0107eeb <find_vma+0x3c>
c0107ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ee3:	8b 40 08             	mov    0x8(%eax),%eax
c0107ee6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ee9:	77 61                	ja     c0107f4c <find_vma+0x9d>
                bool found = 0;
c0107eeb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107ef2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107efe:	eb 28                	jmp    c0107f28 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f03:	83 e8 10             	sub    $0x10,%eax
c0107f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f0c:	8b 40 04             	mov    0x4(%eax),%eax
c0107f0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f12:	77 14                	ja     c0107f28 <find_vma+0x79>
c0107f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f17:	8b 40 08             	mov    0x8(%eax),%eax
c0107f1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f1d:	76 09                	jbe    c0107f28 <find_vma+0x79>
                        found = 1;
c0107f1f:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107f26:	eb 17                	jmp    c0107f3f <find_vma+0x90>
c0107f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f31:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107f3d:	75 c1                	jne    c0107f00 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107f3f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107f43:	75 07                	jne    c0107f4c <find_vma+0x9d>
                    vma = NULL;
c0107f45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107f50:	74 09                	je     c0107f5b <find_vma+0xac>
            mm->mmap_cache = vma;
c0107f52:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107f58:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107f5e:	c9                   	leave  
c0107f5f:	c3                   	ret    

c0107f60 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107f60:	55                   	push   %ebp
c0107f61:	89 e5                	mov    %esp,%ebp
c0107f63:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107f66:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f69:	8b 50 04             	mov    0x4(%eax),%edx
c0107f6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6f:	8b 40 08             	mov    0x8(%eax),%eax
c0107f72:	39 c2                	cmp    %eax,%edx
c0107f74:	72 24                	jb     c0107f9a <check_vma_overlap+0x3a>
c0107f76:	c7 44 24 0c 0d d8 10 	movl   $0xc010d80d,0xc(%esp)
c0107f7d:	c0 
c0107f7e:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0107f85:	c0 
c0107f86:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107f8d:	00 
c0107f8e:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0107f95:	e8 3b 8e ff ff       	call   c0100dd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107f9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f9d:	8b 50 08             	mov    0x8(%eax),%edx
c0107fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fa3:	8b 40 04             	mov    0x4(%eax),%eax
c0107fa6:	39 c2                	cmp    %eax,%edx
c0107fa8:	76 24                	jbe    c0107fce <check_vma_overlap+0x6e>
c0107faa:	c7 44 24 0c 50 d8 10 	movl   $0xc010d850,0xc(%esp)
c0107fb1:	c0 
c0107fb2:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0107fb9:	c0 
c0107fba:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107fc1:	00 
c0107fc2:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0107fc9:	e8 07 8e ff ff       	call   c0100dd5 <__panic>
    assert(next->vm_start < next->vm_end);
c0107fce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fd1:	8b 50 04             	mov    0x4(%eax),%edx
c0107fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fd7:	8b 40 08             	mov    0x8(%eax),%eax
c0107fda:	39 c2                	cmp    %eax,%edx
c0107fdc:	72 24                	jb     c0108002 <check_vma_overlap+0xa2>
c0107fde:	c7 44 24 0c 6f d8 10 	movl   $0xc010d86f,0xc(%esp)
c0107fe5:	c0 
c0107fe6:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0107fed:	c0 
c0107fee:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107ff5:	00 
c0107ff6:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0107ffd:	e8 d3 8d ff ff       	call   c0100dd5 <__panic>
}
c0108002:	c9                   	leave  
c0108003:	c3                   	ret    

c0108004 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0108004:	55                   	push   %ebp
c0108005:	89 e5                	mov    %esp,%ebp
c0108007:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c010800a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010800d:	8b 50 04             	mov    0x4(%eax),%edx
c0108010:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108013:	8b 40 08             	mov    0x8(%eax),%eax
c0108016:	39 c2                	cmp    %eax,%edx
c0108018:	72 24                	jb     c010803e <insert_vma_struct+0x3a>
c010801a:	c7 44 24 0c 8d d8 10 	movl   $0xc010d88d,0xc(%esp)
c0108021:	c0 
c0108022:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108029:	c0 
c010802a:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0108031:	00 
c0108032:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108039:	e8 97 8d ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010803e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108041:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0108044:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108047:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010804a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010804d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0108050:	eb 21                	jmp    c0108073 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0108052:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108055:	83 e8 10             	sub    $0x10,%eax
c0108058:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010805b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010805e:	8b 50 04             	mov    0x4(%eax),%edx
c0108061:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108064:	8b 40 04             	mov    0x4(%eax),%eax
c0108067:	39 c2                	cmp    %eax,%edx
c0108069:	76 02                	jbe    c010806d <insert_vma_struct+0x69>
                break;
c010806b:	eb 1d                	jmp    c010808a <insert_vma_struct+0x86>
            }
            le_prev = le;
c010806d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108070:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108073:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108076:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108079:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010807c:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010807f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108082:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108085:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108088:	75 c8                	jne    c0108052 <insert_vma_struct+0x4e>
c010808a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010808d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108090:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108093:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0108096:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010809c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010809f:	74 15                	je     c01080b6 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01080a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080a4:	8d 50 f0             	lea    -0x10(%eax),%edx
c01080a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080ae:	89 14 24             	mov    %edx,(%esp)
c01080b1:	e8 aa fe ff ff       	call   c0107f60 <check_vma_overlap>
    }
    if (le_next != list) {
c01080b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080bc:	74 15                	je     c01080d3 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01080be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080c1:	83 e8 10             	sub    $0x10,%eax
c01080c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080cb:	89 04 24             	mov    %eax,(%esp)
c01080ce:	e8 8d fe ff ff       	call   c0107f60 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01080d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01080d9:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01080db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080de:	8d 50 10             	lea    0x10(%eax),%edx
c01080e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01080e7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01080ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01080ed:	8b 40 04             	mov    0x4(%eax),%eax
c01080f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01080f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01080f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01080f9:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01080fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01080ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108102:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108105:	89 10                	mov    %edx,(%eax)
c0108107:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010810a:	8b 10                	mov    (%eax),%edx
c010810c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010810f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108112:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108115:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108118:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010811b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010811e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108121:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0108123:	8b 45 08             	mov    0x8(%ebp),%eax
c0108126:	8b 40 10             	mov    0x10(%eax),%eax
c0108129:	8d 50 01             	lea    0x1(%eax),%edx
c010812c:	8b 45 08             	mov    0x8(%ebp),%eax
c010812f:	89 50 10             	mov    %edx,0x10(%eax)
}
c0108132:	c9                   	leave  
c0108133:	c3                   	ret    

c0108134 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0108134:	55                   	push   %ebp
c0108135:	89 e5                	mov    %esp,%ebp
c0108137:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c010813a:	8b 45 08             	mov    0x8(%ebp),%eax
c010813d:	89 04 24             	mov    %eax,(%esp)
c0108140:	e8 38 fc ff ff       	call   c0107d7d <mm_count>
c0108145:	85 c0                	test   %eax,%eax
c0108147:	74 24                	je     c010816d <mm_destroy+0x39>
c0108149:	c7 44 24 0c a9 d8 10 	movl   $0xc010d8a9,0xc(%esp)
c0108150:	c0 
c0108151:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108158:	c0 
c0108159:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0108160:	00 
c0108161:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108168:	e8 68 8c ff ff       	call   c0100dd5 <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c010816d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108170:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0108173:	eb 36                	jmp    c01081ab <mm_destroy+0x77>
c0108175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108178:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010817b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010817e:	8b 40 04             	mov    0x4(%eax),%eax
c0108181:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108184:	8b 12                	mov    (%edx),%edx
c0108186:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010818c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010818f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108192:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0108195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108198:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010819b:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c010819d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081a0:	83 e8 10             	sub    $0x10,%eax
c01081a3:	89 04 24             	mov    %eax,(%esp)
c01081a6:	e8 2f ca ff ff       	call   c0104bda <kfree>
c01081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01081b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081b4:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01081b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01081ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01081c0:	75 b3                	jne    c0108175 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01081c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01081c5:	89 04 24             	mov    %eax,(%esp)
c01081c8:	e8 0d ca ff ff       	call   c0104bda <kfree>
    mm=NULL;
c01081cd:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01081d4:	c9                   	leave  
c01081d5:	c3                   	ret    

c01081d6 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c01081d6:	55                   	push   %ebp
c01081d7:	89 e5                	mov    %esp,%ebp
c01081d9:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c01081dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01081e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01081ed:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c01081f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01081f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081fa:	01 c2                	add    %eax,%edx
c01081fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081ff:	01 d0                	add    %edx,%eax
c0108201:	83 e8 01             	sub    $0x1,%eax
c0108204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010820a:	ba 00 00 00 00       	mov    $0x0,%edx
c010820f:	f7 75 e8             	divl   -0x18(%ebp)
c0108212:	89 d0                	mov    %edx,%eax
c0108214:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108217:	29 c2                	sub    %eax,%edx
c0108219:	89 d0                	mov    %edx,%eax
c010821b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c010821e:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c0108225:	76 11                	jbe    c0108238 <mm_map+0x62>
c0108227:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010822a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010822d:	73 09                	jae    c0108238 <mm_map+0x62>
c010822f:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c0108236:	76 0a                	jbe    c0108242 <mm_map+0x6c>
        return -E_INVAL;
c0108238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010823d:	e9 ae 00 00 00       	jmp    c01082f0 <mm_map+0x11a>
    }

    assert(mm != NULL);
c0108242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108246:	75 24                	jne    c010826c <mm_map+0x96>
c0108248:	c7 44 24 0c bb d8 10 	movl   $0xc010d8bb,0xc(%esp)
c010824f:	c0 
c0108250:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108257:	c0 
c0108258:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c010825f:	00 
c0108260:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108267:	e8 69 8b ff ff       	call   c0100dd5 <__panic>

    int ret = -E_INVAL;
c010826c:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c0108273:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108276:	89 44 24 04          	mov    %eax,0x4(%esp)
c010827a:	8b 45 08             	mov    0x8(%ebp),%eax
c010827d:	89 04 24             	mov    %eax,(%esp)
c0108280:	e8 2a fc ff ff       	call   c0107eaf <find_vma>
c0108285:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108288:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010828c:	74 0d                	je     c010829b <mm_map+0xc5>
c010828e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108291:	8b 40 04             	mov    0x4(%eax),%eax
c0108294:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108297:	73 02                	jae    c010829b <mm_map+0xc5>
        goto out;
c0108299:	eb 52                	jmp    c01082ed <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c010829b:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c01082a2:	8b 45 14             	mov    0x14(%ebp),%eax
c01082a5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082b3:	89 04 24             	mov    %eax,(%esp)
c01082b6:	e8 b9 fb ff ff       	call   c0107e74 <vma_create>
c01082bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01082be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01082c2:	75 02                	jne    c01082c6 <mm_map+0xf0>
        goto out;
c01082c4:	eb 27                	jmp    c01082ed <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c01082c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01082d0:	89 04 24             	mov    %eax,(%esp)
c01082d3:	e8 2c fd ff ff       	call   c0108004 <insert_vma_struct>
    if (vma_store != NULL) {
c01082d8:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01082dc:	74 08                	je     c01082e6 <mm_map+0x110>
        *vma_store = vma;
c01082de:	8b 45 18             	mov    0x18(%ebp),%eax
c01082e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01082e4:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c01082e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c01082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01082f0:	c9                   	leave  
c01082f1:	c3                   	ret    

c01082f2 <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c01082f2:	55                   	push   %ebp
c01082f3:	89 e5                	mov    %esp,%ebp
c01082f5:	56                   	push   %esi
c01082f6:	53                   	push   %ebx
c01082f7:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c01082fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01082fe:	74 06                	je     c0108306 <dup_mmap+0x14>
c0108300:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108304:	75 24                	jne    c010832a <dup_mmap+0x38>
c0108306:	c7 44 24 0c c6 d8 10 	movl   $0xc010d8c6,0xc(%esp)
c010830d:	c0 
c010830e:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108315:	c0 
c0108316:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010831d:	00 
c010831e:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108325:	e8 ab 8a ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c010832a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010832d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108330:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108333:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c0108336:	e9 92 00 00 00       	jmp    c01083cd <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c010833b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010833e:	83 e8 10             	sub    $0x10,%eax
c0108341:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c0108344:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108347:	8b 48 0c             	mov    0xc(%eax),%ecx
c010834a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010834d:	8b 50 08             	mov    0x8(%eax),%edx
c0108350:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108353:	8b 40 04             	mov    0x4(%eax),%eax
c0108356:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010835a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010835e:	89 04 24             	mov    %eax,(%esp)
c0108361:	e8 0e fb ff ff       	call   c0107e74 <vma_create>
c0108366:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c0108369:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010836d:	75 07                	jne    c0108376 <dup_mmap+0x84>
            return -E_NO_MEM;
c010836f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108374:	eb 76                	jmp    c01083ec <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c0108376:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108379:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108380:	89 04 24             	mov    %eax,(%esp)
c0108383:	e8 7c fc ff ff       	call   c0108004 <insert_vma_struct>

        bool share = 0;
c0108388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c010838f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108392:	8b 58 08             	mov    0x8(%eax),%ebx
c0108395:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108398:	8b 48 04             	mov    0x4(%eax),%ecx
c010839b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010839e:	8b 50 0c             	mov    0xc(%eax),%edx
c01083a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a4:	8b 40 0c             	mov    0xc(%eax),%eax
c01083a7:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01083aa:	89 74 24 10          	mov    %esi,0x10(%esp)
c01083ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01083b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01083b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083ba:	89 04 24             	mov    %eax,(%esp)
c01083bd:	e8 c6 d7 ff ff       	call   c0105b88 <copy_range>
c01083c2:	85 c0                	test   %eax,%eax
c01083c4:	74 07                	je     c01083cd <dup_mmap+0xdb>
            return -E_NO_MEM;
c01083c6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01083cb:	eb 1f                	jmp    c01083ec <dup_mmap+0xfa>
c01083cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01083d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083d6:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c01083d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01083db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01083e1:	0f 85 54 ff ff ff    	jne    c010833b <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c01083e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01083ec:	83 c4 40             	add    $0x40,%esp
c01083ef:	5b                   	pop    %ebx
c01083f0:	5e                   	pop    %esi
c01083f1:	5d                   	pop    %ebp
c01083f2:	c3                   	ret    

c01083f3 <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c01083f3:	55                   	push   %ebp
c01083f4:	89 e5                	mov    %esp,%ebp
c01083f6:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c01083f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01083fd:	74 0f                	je     c010840e <exit_mmap+0x1b>
c01083ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108402:	89 04 24             	mov    %eax,(%esp)
c0108405:	e8 73 f9 ff ff       	call   c0107d7d <mm_count>
c010840a:	85 c0                	test   %eax,%eax
c010840c:	74 24                	je     c0108432 <exit_mmap+0x3f>
c010840e:	c7 44 24 0c e4 d8 10 	movl   $0xc010d8e4,0xc(%esp)
c0108415:	c0 
c0108416:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c010841d:	c0 
c010841e:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0108425:	00 
c0108426:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c010842d:	e8 a3 89 ff ff       	call   c0100dd5 <__panic>
    pde_t *pgdir = mm->pgdir;
c0108432:	8b 45 08             	mov    0x8(%ebp),%eax
c0108435:	8b 40 0c             	mov    0xc(%eax),%eax
c0108438:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c010843b:	8b 45 08             	mov    0x8(%ebp),%eax
c010843e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108441:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c0108447:	eb 28                	jmp    c0108471 <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108449:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010844c:	83 e8 10             	sub    $0x10,%eax
c010844f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c0108452:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108455:	8b 50 08             	mov    0x8(%eax),%edx
c0108458:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010845b:	8b 40 04             	mov    0x4(%eax),%eax
c010845e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108466:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108469:	89 04 24             	mov    %eax,(%esp)
c010846c:	e8 1c d5 ff ff       	call   c010598d <unmap_range>
c0108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108474:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108477:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010847a:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c010847d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108480:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108483:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108486:	75 c1                	jne    c0108449 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108488:	eb 28                	jmp    c01084b2 <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c010848a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010848d:	83 e8 10             	sub    $0x10,%eax
c0108490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c0108493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108496:	8b 50 08             	mov    0x8(%eax),%edx
c0108499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010849c:	8b 40 04             	mov    0x4(%eax),%eax
c010849f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084aa:	89 04 24             	mov    %eax,(%esp)
c01084ad:	e8 cf d5 ff ff       	call   c0105a81 <exit_range>
c01084b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01084b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084bb:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01084be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01084c7:	75 c1                	jne    c010848a <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c01084c9:	c9                   	leave  
c01084ca:	c3                   	ret    

c01084cb <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c01084cb:	55                   	push   %ebp
c01084cc:	89 e5                	mov    %esp,%ebp
c01084ce:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c01084d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01084d4:	8b 55 18             	mov    0x18(%ebp),%edx
c01084d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01084db:	8b 55 14             	mov    0x14(%ebp),%edx
c01084de:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01084e9:	89 04 24             	mov    %eax,(%esp)
c01084ec:	e8 dc 09 00 00       	call   c0108ecd <user_mem_check>
c01084f1:	85 c0                	test   %eax,%eax
c01084f3:	75 07                	jne    c01084fc <copy_from_user+0x31>
        return 0;
c01084f5:	b8 00 00 00 00       	mov    $0x0,%eax
c01084fa:	eb 1e                	jmp    c010851a <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c01084fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01084ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108503:	8b 45 10             	mov    0x10(%ebp),%eax
c0108506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010850a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010850d:	89 04 24             	mov    %eax,(%esp)
c0108510:	e8 ac 37 00 00       	call   c010bcc1 <memcpy>
    return 1;
c0108515:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010851a:	c9                   	leave  
c010851b:	c3                   	ret    

c010851c <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c010851c:	55                   	push   %ebp
c010851d:	89 e5                	mov    %esp,%ebp
c010851f:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c0108522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108525:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010852c:	00 
c010852d:	8b 55 14             	mov    0x14(%ebp),%edx
c0108530:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108534:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108538:	8b 45 08             	mov    0x8(%ebp),%eax
c010853b:	89 04 24             	mov    %eax,(%esp)
c010853e:	e8 8a 09 00 00       	call   c0108ecd <user_mem_check>
c0108543:	85 c0                	test   %eax,%eax
c0108545:	75 07                	jne    c010854e <copy_to_user+0x32>
        return 0;
c0108547:	b8 00 00 00 00       	mov    $0x0,%eax
c010854c:	eb 1e                	jmp    c010856c <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c010854e:	8b 45 14             	mov    0x14(%ebp),%eax
c0108551:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108555:	8b 45 10             	mov    0x10(%ebp),%eax
c0108558:	89 44 24 04          	mov    %eax,0x4(%esp)
c010855c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010855f:	89 04 24             	mov    %eax,(%esp)
c0108562:	e8 5a 37 00 00       	call   c010bcc1 <memcpy>
    return 1;
c0108567:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010856c:	c9                   	leave  
c010856d:	c3                   	ret    

c010856e <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010856e:	55                   	push   %ebp
c010856f:	89 e5                	mov    %esp,%ebp
c0108571:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0108574:	e8 02 00 00 00       	call   c010857b <check_vmm>
}
c0108579:	c9                   	leave  
c010857a:	c3                   	ret    

c010857b <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010857b:	55                   	push   %ebp
c010857c:	89 e5                	mov    %esp,%ebp
c010857e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108581:	e8 4b cb ff ff       	call   c01050d1 <nr_free_pages>
c0108586:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0108589:	e8 13 00 00 00       	call   c01085a1 <check_vma_struct>
    check_pgfault();
c010858e:	e8 a7 04 00 00       	call   c0108a3a <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0108593:	c7 04 24 04 d9 10 c0 	movl   $0xc010d904,(%esp)
c010859a:	e8 b4 7d ff ff       	call   c0100353 <cprintf>
}
c010859f:	c9                   	leave  
c01085a0:	c3                   	ret    

c01085a1 <check_vma_struct>:

static void
check_vma_struct(void) {
c01085a1:	55                   	push   %ebp
c01085a2:	89 e5                	mov    %esp,%ebp
c01085a4:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01085a7:	e8 25 cb ff ff       	call   c01050d1 <nr_free_pages>
c01085ac:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01085af:	e8 27 f8 ff ff       	call   c0107ddb <mm_create>
c01085b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01085b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085bb:	75 24                	jne    c01085e1 <check_vma_struct+0x40>
c01085bd:	c7 44 24 0c bb d8 10 	movl   $0xc010d8bb,0xc(%esp)
c01085c4:	c0 
c01085c5:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c01085cc:	c0 
c01085cd:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01085d4:	00 
c01085d5:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c01085dc:	e8 f4 87 ff ff       	call   c0100dd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01085e1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01085e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01085eb:	89 d0                	mov    %edx,%eax
c01085ed:	c1 e0 02             	shl    $0x2,%eax
c01085f0:	01 d0                	add    %edx,%eax
c01085f2:	01 c0                	add    %eax,%eax
c01085f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01085f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085fd:	eb 70                	jmp    c010866f <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01085ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108602:	89 d0                	mov    %edx,%eax
c0108604:	c1 e0 02             	shl    $0x2,%eax
c0108607:	01 d0                	add    %edx,%eax
c0108609:	83 c0 02             	add    $0x2,%eax
c010860c:	89 c1                	mov    %eax,%ecx
c010860e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108611:	89 d0                	mov    %edx,%eax
c0108613:	c1 e0 02             	shl    $0x2,%eax
c0108616:	01 d0                	add    %edx,%eax
c0108618:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010861f:	00 
c0108620:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0108624:	89 04 24             	mov    %eax,(%esp)
c0108627:	e8 48 f8 ff ff       	call   c0107e74 <vma_create>
c010862c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c010862f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108633:	75 24                	jne    c0108659 <check_vma_struct+0xb8>
c0108635:	c7 44 24 0c 1c d9 10 	movl   $0xc010d91c,0xc(%esp)
c010863c:	c0 
c010863d:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108644:	c0 
c0108645:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c010864c:	00 
c010864d:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108654:	e8 7c 87 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c0108659:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010865c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108660:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108663:	89 04 24             	mov    %eax,(%esp)
c0108666:	e8 99 f9 ff ff       	call   c0108004 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c010866b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010866f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108673:	7f 8a                	jg     c01085ff <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108678:	83 c0 01             	add    $0x1,%eax
c010867b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010867e:	eb 70                	jmp    c01086f0 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0108680:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108683:	89 d0                	mov    %edx,%eax
c0108685:	c1 e0 02             	shl    $0x2,%eax
c0108688:	01 d0                	add    %edx,%eax
c010868a:	83 c0 02             	add    $0x2,%eax
c010868d:	89 c1                	mov    %eax,%ecx
c010868f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108692:	89 d0                	mov    %edx,%eax
c0108694:	c1 e0 02             	shl    $0x2,%eax
c0108697:	01 d0                	add    %edx,%eax
c0108699:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01086a0:	00 
c01086a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01086a5:	89 04 24             	mov    %eax,(%esp)
c01086a8:	e8 c7 f7 ff ff       	call   c0107e74 <vma_create>
c01086ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01086b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01086b4:	75 24                	jne    c01086da <check_vma_struct+0x139>
c01086b6:	c7 44 24 0c 1c d9 10 	movl   $0xc010d91c,0xc(%esp)
c01086bd:	c0 
c01086be:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c01086c5:	c0 
c01086c6:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01086cd:	00 
c01086ce:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c01086d5:	e8 fb 86 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c01086da:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01086dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086e4:	89 04 24             	mov    %eax,(%esp)
c01086e7:	e8 18 f9 ff ff       	call   c0108004 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01086ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01086f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01086f6:	7e 88                	jle    c0108680 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01086f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01086fe:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0108701:	8b 40 04             	mov    0x4(%eax),%eax
c0108704:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0108707:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c010870e:	e9 97 00 00 00       	jmp    c01087aa <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0108713:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108716:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108719:	75 24                	jne    c010873f <check_vma_struct+0x19e>
c010871b:	c7 44 24 0c 28 d9 10 	movl   $0xc010d928,0xc(%esp)
c0108722:	c0 
c0108723:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c010872a:	c0 
c010872b:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0108732:	00 
c0108733:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c010873a:	e8 96 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c010873f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108742:	83 e8 10             	sub    $0x10,%eax
c0108745:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010874b:	8b 48 04             	mov    0x4(%eax),%ecx
c010874e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108751:	89 d0                	mov    %edx,%eax
c0108753:	c1 e0 02             	shl    $0x2,%eax
c0108756:	01 d0                	add    %edx,%eax
c0108758:	39 c1                	cmp    %eax,%ecx
c010875a:	75 17                	jne    c0108773 <check_vma_struct+0x1d2>
c010875c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010875f:	8b 48 08             	mov    0x8(%eax),%ecx
c0108762:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108765:	89 d0                	mov    %edx,%eax
c0108767:	c1 e0 02             	shl    $0x2,%eax
c010876a:	01 d0                	add    %edx,%eax
c010876c:	83 c0 02             	add    $0x2,%eax
c010876f:	39 c1                	cmp    %eax,%ecx
c0108771:	74 24                	je     c0108797 <check_vma_struct+0x1f6>
c0108773:	c7 44 24 0c 40 d9 10 	movl   $0xc010d940,0xc(%esp)
c010877a:	c0 
c010877b:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108782:	c0 
c0108783:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c010878a:	00 
c010878b:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108792:	e8 3e 86 ff ff       	call   c0100dd5 <__panic>
c0108797:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010879a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010879d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01087a0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01087a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01087a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01087aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087ad:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01087b0:	0f 8e 5d ff ff ff    	jle    c0108713 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01087b6:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01087bd:	e9 cd 01 00 00       	jmp    c010898f <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01087c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087cc:	89 04 24             	mov    %eax,(%esp)
c01087cf:	e8 db f6 ff ff       	call   c0107eaf <find_vma>
c01087d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c01087d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01087db:	75 24                	jne    c0108801 <check_vma_struct+0x260>
c01087dd:	c7 44 24 0c 75 d9 10 	movl   $0xc010d975,0xc(%esp)
c01087e4:	c0 
c01087e5:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c01087ec:	c0 
c01087ed:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01087f4:	00 
c01087f5:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c01087fc:	e8 d4 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0108801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108804:	83 c0 01             	add    $0x1,%eax
c0108807:	89 44 24 04          	mov    %eax,0x4(%esp)
c010880b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010880e:	89 04 24             	mov    %eax,(%esp)
c0108811:	e8 99 f6 ff ff       	call   c0107eaf <find_vma>
c0108816:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0108819:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010881d:	75 24                	jne    c0108843 <check_vma_struct+0x2a2>
c010881f:	c7 44 24 0c 82 d9 10 	movl   $0xc010d982,0xc(%esp)
c0108826:	c0 
c0108827:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c010882e:	c0 
c010882f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0108836:	00 
c0108837:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c010883e:	e8 92 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0108843:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108846:	83 c0 02             	add    $0x2,%eax
c0108849:	89 44 24 04          	mov    %eax,0x4(%esp)
c010884d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108850:	89 04 24             	mov    %eax,(%esp)
c0108853:	e8 57 f6 ff ff       	call   c0107eaf <find_vma>
c0108858:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010885b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010885f:	74 24                	je     c0108885 <check_vma_struct+0x2e4>
c0108861:	c7 44 24 0c 8f d9 10 	movl   $0xc010d98f,0xc(%esp)
c0108868:	c0 
c0108869:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108870:	c0 
c0108871:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108878:	00 
c0108879:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108880:	e8 50 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0108885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108888:	83 c0 03             	add    $0x3,%eax
c010888b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010888f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108892:	89 04 24             	mov    %eax,(%esp)
c0108895:	e8 15 f6 ff ff       	call   c0107eaf <find_vma>
c010889a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c010889d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01088a1:	74 24                	je     c01088c7 <check_vma_struct+0x326>
c01088a3:	c7 44 24 0c 9c d9 10 	movl   $0xc010d99c,0xc(%esp)
c01088aa:	c0 
c01088ab:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c01088b2:	c0 
c01088b3:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01088ba:	00 
c01088bb:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c01088c2:	e8 0e 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01088c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ca:	83 c0 04             	add    $0x4,%eax
c01088cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088d4:	89 04 24             	mov    %eax,(%esp)
c01088d7:	e8 d3 f5 ff ff       	call   c0107eaf <find_vma>
c01088dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c01088df:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01088e3:	74 24                	je     c0108909 <check_vma_struct+0x368>
c01088e5:	c7 44 24 0c a9 d9 10 	movl   $0xc010d9a9,0xc(%esp)
c01088ec:	c0 
c01088ed:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c01088f4:	c0 
c01088f5:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01088fc:	00 
c01088fd:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108904:	e8 cc 84 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0108909:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010890c:	8b 50 04             	mov    0x4(%eax),%edx
c010890f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108912:	39 c2                	cmp    %eax,%edx
c0108914:	75 10                	jne    c0108926 <check_vma_struct+0x385>
c0108916:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108919:	8b 50 08             	mov    0x8(%eax),%edx
c010891c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010891f:	83 c0 02             	add    $0x2,%eax
c0108922:	39 c2                	cmp    %eax,%edx
c0108924:	74 24                	je     c010894a <check_vma_struct+0x3a9>
c0108926:	c7 44 24 0c b8 d9 10 	movl   $0xc010d9b8,0xc(%esp)
c010892d:	c0 
c010892e:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108935:	c0 
c0108936:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c010893d:	00 
c010893e:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108945:	e8 8b 84 ff ff       	call   c0100dd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010894a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010894d:	8b 50 04             	mov    0x4(%eax),%edx
c0108950:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108953:	39 c2                	cmp    %eax,%edx
c0108955:	75 10                	jne    c0108967 <check_vma_struct+0x3c6>
c0108957:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010895a:	8b 50 08             	mov    0x8(%eax),%edx
c010895d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108960:	83 c0 02             	add    $0x2,%eax
c0108963:	39 c2                	cmp    %eax,%edx
c0108965:	74 24                	je     c010898b <check_vma_struct+0x3ea>
c0108967:	c7 44 24 0c e8 d9 10 	movl   $0xc010d9e8,0xc(%esp)
c010896e:	c0 
c010896f:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108976:	c0 
c0108977:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010897e:	00 
c010897f:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108986:	e8 4a 84 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010898b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010898f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108992:	89 d0                	mov    %edx,%eax
c0108994:	c1 e0 02             	shl    $0x2,%eax
c0108997:	01 d0                	add    %edx,%eax
c0108999:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010899c:	0f 8d 20 fe ff ff    	jge    c01087c2 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01089a2:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01089a9:	eb 70                	jmp    c0108a1b <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01089ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089b5:	89 04 24             	mov    %eax,(%esp)
c01089b8:	e8 f2 f4 ff ff       	call   c0107eaf <find_vma>
c01089bd:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01089c0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01089c4:	74 27                	je     c01089ed <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01089c6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01089c9:	8b 50 08             	mov    0x8(%eax),%edx
c01089cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01089cf:	8b 40 04             	mov    0x4(%eax),%eax
c01089d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01089d6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01089da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089e1:	c7 04 24 18 da 10 c0 	movl   $0xc010da18,(%esp)
c01089e8:	e8 66 79 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01089ed:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01089f1:	74 24                	je     c0108a17 <check_vma_struct+0x476>
c01089f3:	c7 44 24 0c 3d da 10 	movl   $0xc010da3d,0xc(%esp)
c01089fa:	c0 
c01089fb:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108a02:	c0 
c0108a03:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0108a0a:	00 
c0108a0b:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108a12:	e8 be 83 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108a17:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a1f:	79 8a                	jns    c01089ab <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a24:	89 04 24             	mov    %eax,(%esp)
c0108a27:	e8 08 f7 ff ff       	call   c0108134 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108a2c:	c7 04 24 54 da 10 c0 	movl   $0xc010da54,(%esp)
c0108a33:	e8 1b 79 ff ff       	call   c0100353 <cprintf>
}
c0108a38:	c9                   	leave  
c0108a39:	c3                   	ret    

c0108a3a <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108a3a:	55                   	push   %ebp
c0108a3b:	89 e5                	mov    %esp,%ebp
c0108a3d:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108a40:	e8 8c c6 ff ff       	call   c01050d1 <nr_free_pages>
c0108a45:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108a48:	e8 8e f3 ff ff       	call   c0107ddb <mm_create>
c0108a4d:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac
    assert(check_mm_struct != NULL);
c0108a52:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108a57:	85 c0                	test   %eax,%eax
c0108a59:	75 24                	jne    c0108a7f <check_pgfault+0x45>
c0108a5b:	c7 44 24 0c 73 da 10 	movl   $0xc010da73,0xc(%esp)
c0108a62:	c0 
c0108a63:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108a6a:	c0 
c0108a6b:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108a72:	00 
c0108a73:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108a7a:	e8 56 83 ff ff       	call   c0100dd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108a7f:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108a87:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0108a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a90:	89 50 0c             	mov    %edx,0xc(%eax)
c0108a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a96:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a9f:	8b 00                	mov    (%eax),%eax
c0108aa1:	85 c0                	test   %eax,%eax
c0108aa3:	74 24                	je     c0108ac9 <check_pgfault+0x8f>
c0108aa5:	c7 44 24 0c 8b da 10 	movl   $0xc010da8b,0xc(%esp)
c0108aac:	c0 
c0108aad:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108ab4:	c0 
c0108ab5:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108abc:	00 
c0108abd:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108ac4:	e8 0c 83 ff ff       	call   c0100dd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108ac9:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0108ad0:	00 
c0108ad1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108ad8:	00 
c0108ad9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108ae0:	e8 8f f3 ff ff       	call   c0107e74 <vma_create>
c0108ae5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108ae8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108aec:	75 24                	jne    c0108b12 <check_pgfault+0xd8>
c0108aee:	c7 44 24 0c 1c d9 10 	movl   $0xc010d91c,0xc(%esp)
c0108af5:	c0 
c0108af6:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108afd:	c0 
c0108afe:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108b05:	00 
c0108b06:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108b0d:	e8 c3 82 ff ff       	call   c0100dd5 <__panic>

    insert_vma_struct(mm, vma);
c0108b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b1c:	89 04 24             	mov    %eax,(%esp)
c0108b1f:	e8 e0 f4 ff ff       	call   c0108004 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108b24:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b35:	89 04 24             	mov    %eax,(%esp)
c0108b38:	e8 72 f3 ff ff       	call   c0107eaf <find_vma>
c0108b3d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108b40:	74 24                	je     c0108b66 <check_pgfault+0x12c>
c0108b42:	c7 44 24 0c 99 da 10 	movl   $0xc010da99,0xc(%esp)
c0108b49:	c0 
c0108b4a:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108b51:	c0 
c0108b52:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108b59:	00 
c0108b5a:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108b61:	e8 6f 82 ff ff       	call   c0100dd5 <__panic>

    int i, sum = 0;
c0108b66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108b6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108b74:	eb 17                	jmp    c0108b8d <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b79:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b7c:	01 d0                	add    %edx,%eax
c0108b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b81:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b86:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108b89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108b8d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108b91:	7e e3                	jle    c0108b76 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108b93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108b9a:	eb 15                	jmp    c0108bb1 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba2:	01 d0                	add    %edx,%eax
c0108ba4:	0f b6 00             	movzbl (%eax),%eax
c0108ba7:	0f be c0             	movsbl %al,%eax
c0108baa:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108bad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108bb1:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108bb5:	7e e5                	jle    c0108b9c <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108bb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108bbb:	74 24                	je     c0108be1 <check_pgfault+0x1a7>
c0108bbd:	c7 44 24 0c b3 da 10 	movl   $0xc010dab3,0xc(%esp)
c0108bc4:	c0 
c0108bc5:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108bcc:	c0 
c0108bcd:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0108bd4:	00 
c0108bd5:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108bdc:	e8 f4 81 ff ff       	call   c0100dd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108be1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108be4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108be7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108bef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bf6:	89 04 24             	mov    %eax,(%esp)
c0108bf9:	e8 a8 d1 ff ff       	call   c0105da6 <page_remove>
    free_page(pa2page(pgdir[0]));
c0108bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c01:	8b 00                	mov    (%eax),%eax
c0108c03:	89 04 24             	mov    %eax,(%esp)
c0108c06:	e8 8b f1 ff ff       	call   c0107d96 <pa2page>
c0108c0b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108c12:	00 
c0108c13:	89 04 24             	mov    %eax,(%esp)
c0108c16:	e8 84 c4 ff ff       	call   c010509f <free_pages>
    pgdir[0] = 0;
c0108c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c27:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c31:	89 04 24             	mov    %eax,(%esp)
c0108c34:	e8 fb f4 ff ff       	call   c0108134 <mm_destroy>
    check_mm_struct = NULL;
c0108c39:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0108c40:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108c43:	e8 89 c4 ff ff       	call   c01050d1 <nr_free_pages>
c0108c48:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108c4b:	74 24                	je     c0108c71 <check_pgfault+0x237>
c0108c4d:	c7 44 24 0c bc da 10 	movl   $0xc010dabc,0xc(%esp)
c0108c54:	c0 
c0108c55:	c7 44 24 08 2b d8 10 	movl   $0xc010d82b,0x8(%esp)
c0108c5c:	c0 
c0108c5d:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108c64:	00 
c0108c65:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108c6c:	e8 64 81 ff ff       	call   c0100dd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108c71:	c7 04 24 e3 da 10 c0 	movl   $0xc010dae3,(%esp)
c0108c78:	e8 d6 76 ff ff       	call   c0100353 <cprintf>
}
c0108c7d:	c9                   	leave  
c0108c7e:	c3                   	ret    

c0108c7f <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108c7f:	55                   	push   %ebp
c0108c80:	89 e5                	mov    %esp,%ebp
c0108c82:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108c85:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108c8c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c96:	89 04 24             	mov    %eax,(%esp)
c0108c99:	e8 11 f2 ff ff       	call   c0107eaf <find_vma>
c0108c9e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108ca1:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0108ca6:	83 c0 01             	add    $0x1,%eax
c0108ca9:	a3 78 cf 19 c0       	mov    %eax,0xc019cf78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108cae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108cb2:	74 0b                	je     c0108cbf <do_pgfault+0x40>
c0108cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108cb7:	8b 40 04             	mov    0x4(%eax),%eax
c0108cba:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108cbd:	76 18                	jbe    c0108cd7 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108cbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cc6:	c7 04 24 00 db 10 c0 	movl   $0xc010db00,(%esp)
c0108ccd:	e8 81 76 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108cd2:	e9 f1 01 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
    }
    //check the error_code
    switch (error_code & 3) {
c0108cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cda:	83 e0 03             	and    $0x3,%eax
c0108cdd:	85 c0                	test   %eax,%eax
c0108cdf:	74 36                	je     c0108d17 <do_pgfault+0x98>
c0108ce1:	83 f8 01             	cmp    $0x1,%eax
c0108ce4:	74 20                	je     c0108d06 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ce9:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cec:	83 e0 02             	and    $0x2,%eax
c0108cef:	85 c0                	test   %eax,%eax
c0108cf1:	75 11                	jne    c0108d04 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108cf3:	c7 04 24 30 db 10 c0 	movl   $0xc010db30,(%esp)
c0108cfa:	e8 54 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108cff:	e9 c4 01 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
        }
        break;
c0108d04:	eb 2f                	jmp    c0108d35 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108d06:	c7 04 24 90 db 10 c0 	movl   $0xc010db90,(%esp)
c0108d0d:	e8 41 76 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108d12:	e9 b1 01 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d1a:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d1d:	83 e0 05             	and    $0x5,%eax
c0108d20:	85 c0                	test   %eax,%eax
c0108d22:	75 11                	jne    c0108d35 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108d24:	c7 04 24 c8 db 10 c0 	movl   $0xc010dbc8,(%esp)
c0108d2b:	e8 23 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108d30:	e9 93 01 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108d35:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d3f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d42:	83 e0 02             	and    $0x2,%eax
c0108d45:	85 c0                	test   %eax,%eax
c0108d47:	74 04                	je     c0108d4d <do_pgfault+0xce>
        perm |= PTE_W;
c0108d49:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108d4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d50:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108d5b:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108d5e:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108d65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            goto failed;
        }
   }
#endif
   
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c0108d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d6f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d72:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108d79:	00 
c0108d7a:	8b 55 10             	mov    0x10(%ebp),%edx
c0108d7d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d81:	89 04 24             	mov    %eax,(%esp)
c0108d84:	e8 12 ca ff ff       	call   c010579b <get_pte>
c0108d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108d90:	75 11                	jne    c0108da3 <do_pgfault+0x124>
        cprintf("get_pte in do_pgfault failed\n");
c0108d92:	c7 04 24 2b dc 10 c0 	movl   $0xc010dc2b,(%esp)
c0108d99:	e8 b5 75 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108d9e:	e9 25 01 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
    }
    
    if (*ptep == 0) { 
c0108da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108da6:	8b 00                	mov    (%eax),%eax
c0108da8:	85 c0                	test   %eax,%eax
c0108daa:	75 35                	jne    c0108de1 <do_pgfault+0x162>
			if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0108dac:	8b 45 08             	mov    0x8(%ebp),%eax
c0108daf:	8b 40 0c             	mov    0xc(%eax),%eax
c0108db2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108db5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108db9:	8b 55 10             	mov    0x10(%ebp),%edx
c0108dbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108dc0:	89 04 24             	mov    %eax,(%esp)
c0108dc3:	e8 38 d1 ff ff       	call   c0105f00 <pgdir_alloc_page>
c0108dc8:	85 c0                	test   %eax,%eax
c0108dca:	0f 85 f1 00 00 00    	jne    c0108ec1 <do_pgfault+0x242>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0108dd0:	c7 04 24 4c dc 10 c0 	movl   $0xc010dc4c,(%esp)
c0108dd7:	e8 77 75 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108ddc:	e9 e7 00 00 00       	jmp    c0108ec8 <do_pgfault+0x249>
        }
    }
    else {
        struct Page *page=NULL;
c0108de1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        cprintf("do pgfault: ptep %x, pte %x\n",ptep, *ptep);
c0108de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108deb:	8b 00                	mov    (%eax),%eax
c0108ded:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108df4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108df8:	c7 04 24 73 dc 10 c0 	movl   $0xc010dc73,(%esp)
c0108dff:	e8 4f 75 ff ff       	call   c0100353 <cprintf>
        if (*ptep & PTE_P) {           
c0108e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e07:	8b 00                	mov    (%eax),%eax
c0108e09:	83 e0 01             	and    $0x1,%eax
c0108e0c:	85 c0                	test   %eax,%eax
c0108e0e:	74 1c                	je     c0108e2c <do_pgfault+0x1ad>
            panic("error write a non-writable pte");
c0108e10:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c0108e17:	c0 
c0108e18:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0108e1f:	00 
c0108e20:	c7 04 24 40 d8 10 c0 	movl   $0xc010d840,(%esp)
c0108e27:	e8 a9 7f ff ff       	call   c0100dd5 <__panic>
        } else{
           if(swap_init_ok) {               
c0108e2c:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0108e31:	85 c0                	test   %eax,%eax
c0108e33:	74 30                	je     c0108e65 <do_pgfault+0x1e6>
               if ((ret = swap_in(mm, addr, &page)) != 0) {
c0108e35:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108e38:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e46:	89 04 24             	mov    %eax,(%esp)
c0108e49:	e8 4b e1 ff ff       	call   c0106f99 <swap_in>
c0108e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e55:	74 26                	je     c0108e7d <do_pgfault+0x1fe>
                   cprintf("swap_in in do_pgfault failed\n");
c0108e57:	c7 04 24 af dc 10 c0 	movl   $0xc010dcaf,(%esp)
c0108e5e:	e8 f0 74 ff ff       	call   c0100353 <cprintf>
                   goto failed;
c0108e63:	eb 63                	jmp    c0108ec8 <do_pgfault+0x249>
               }    

           }  
           else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108e65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e68:	8b 00                	mov    (%eax),%eax
c0108e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e6e:	c7 04 24 d0 dc 10 c0 	movl   $0xc010dcd0,(%esp)
c0108e75:	e8 d9 74 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108e7a:	90                   	nop
c0108e7b:	eb 4b                	jmp    c0108ec8 <do_pgfault+0x249>
           }
       } 
       page_insert(mm->pgdir, page, addr, perm);
c0108e7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e83:	8b 40 0c             	mov    0xc(%eax),%eax
c0108e86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108e89:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108e8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108e90:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108e94:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108e98:	89 04 24             	mov    %eax,(%esp)
c0108e9b:	e8 4a cf ff ff       	call   c0105dea <page_insert>
       swap_map_swappable(mm, addr, page, 1);
c0108ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ea3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108eaa:	00 
c0108eab:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108eaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eb9:	89 04 24             	mov    %eax,(%esp)
c0108ebc:	e8 0f df ff ff       	call   c0106dd0 <swap_map_swappable>
   }
   ret = 0;
c0108ec1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108ecb:	c9                   	leave  
c0108ecc:	c3                   	ret    

c0108ecd <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c0108ecd:	55                   	push   %ebp
c0108ece:	89 e5                	mov    %esp,%ebp
c0108ed0:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0108ed3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108ed7:	0f 84 e0 00 00 00    	je     c0108fbd <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c0108edd:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0108ee4:	76 1c                	jbe    c0108f02 <user_mem_check+0x35>
c0108ee6:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108eec:	01 d0                	add    %edx,%eax
c0108eee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108ef1:	76 0f                	jbe    c0108f02 <user_mem_check+0x35>
c0108ef3:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ef9:	01 d0                	add    %edx,%eax
c0108efb:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c0108f00:	76 0a                	jbe    c0108f0c <user_mem_check+0x3f>
            return 0;
c0108f02:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f07:	e9 e2 00 00 00       	jmp    c0108fee <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0108f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108f12:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f15:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f18:	01 d0                	add    %edx,%eax
c0108f1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0108f1d:	e9 88 00 00 00       	jmp    c0108faa <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0108f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108f25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f2c:	89 04 24             	mov    %eax,(%esp)
c0108f2f:	e8 7b ef ff ff       	call   c0107eaf <find_vma>
c0108f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108f3b:	74 0b                	je     c0108f48 <user_mem_check+0x7b>
c0108f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f40:	8b 40 04             	mov    0x4(%eax),%eax
c0108f43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108f46:	76 0a                	jbe    c0108f52 <user_mem_check+0x85>
                return 0;
c0108f48:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f4d:	e9 9c 00 00 00       	jmp    c0108fee <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0108f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f55:	8b 50 0c             	mov    0xc(%eax),%edx
c0108f58:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108f5c:	74 07                	je     c0108f65 <user_mem_check+0x98>
c0108f5e:	b8 02 00 00 00       	mov    $0x2,%eax
c0108f63:	eb 05                	jmp    c0108f6a <user_mem_check+0x9d>
c0108f65:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f6a:	21 d0                	and    %edx,%eax
c0108f6c:	85 c0                	test   %eax,%eax
c0108f6e:	75 07                	jne    c0108f77 <user_mem_check+0xaa>
                return 0;
c0108f70:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f75:	eb 77                	jmp    c0108fee <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0108f77:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108f7b:	74 24                	je     c0108fa1 <user_mem_check+0xd4>
c0108f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f80:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f83:	83 e0 08             	and    $0x8,%eax
c0108f86:	85 c0                	test   %eax,%eax
c0108f88:	74 17                	je     c0108fa1 <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0108f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f8d:	8b 40 04             	mov    0x4(%eax),%eax
c0108f90:	05 00 10 00 00       	add    $0x1000,%eax
c0108f95:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108f98:	76 07                	jbe    c0108fa1 <user_mem_check+0xd4>
                    return 0;
c0108f9a:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f9f:	eb 4d                	jmp    c0108fee <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0108fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fa4:	8b 40 08             	mov    0x8(%eax),%eax
c0108fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0108faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108fad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108fb0:	0f 82 6c ff ff ff    	jb     c0108f22 <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0108fb6:	b8 01 00 00 00       	mov    $0x1,%eax
c0108fbb:	eb 31                	jmp    c0108fee <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0108fbd:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c0108fc4:	76 23                	jbe    c0108fe9 <user_mem_check+0x11c>
c0108fc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0108fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108fcc:	01 d0                	add    %edx,%eax
c0108fce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108fd1:	76 16                	jbe    c0108fe9 <user_mem_check+0x11c>
c0108fd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0108fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108fd9:	01 d0                	add    %edx,%eax
c0108fdb:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c0108fe0:	77 07                	ja     c0108fe9 <user_mem_check+0x11c>
c0108fe2:	b8 01 00 00 00       	mov    $0x1,%eax
c0108fe7:	eb 05                	jmp    c0108fee <user_mem_check+0x121>
c0108fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108fee:	c9                   	leave  
c0108fef:	c3                   	ret    

c0108ff0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108ff0:	55                   	push   %ebp
c0108ff1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108ff3:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ff6:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0108ffb:	29 c2                	sub    %eax,%edx
c0108ffd:	89 d0                	mov    %edx,%eax
c0108fff:	c1 f8 05             	sar    $0x5,%eax
}
c0109002:	5d                   	pop    %ebp
c0109003:	c3                   	ret    

c0109004 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0109004:	55                   	push   %ebp
c0109005:	89 e5                	mov    %esp,%ebp
c0109007:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010900a:	8b 45 08             	mov    0x8(%ebp),%eax
c010900d:	89 04 24             	mov    %eax,(%esp)
c0109010:	e8 db ff ff ff       	call   c0108ff0 <page2ppn>
c0109015:	c1 e0 0c             	shl    $0xc,%eax
}
c0109018:	c9                   	leave  
c0109019:	c3                   	ret    

c010901a <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010901a:	55                   	push   %ebp
c010901b:	89 e5                	mov    %esp,%ebp
c010901d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109020:	8b 45 08             	mov    0x8(%ebp),%eax
c0109023:	89 04 24             	mov    %eax,(%esp)
c0109026:	e8 d9 ff ff ff       	call   c0109004 <page2pa>
c010902b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010902e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109031:	c1 e8 0c             	shr    $0xc,%eax
c0109034:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109037:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010903c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010903f:	72 23                	jb     c0109064 <page2kva+0x4a>
c0109041:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109044:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109048:	c7 44 24 08 f8 dc 10 	movl   $0xc010dcf8,0x8(%esp)
c010904f:	c0 
c0109050:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109057:	00 
c0109058:	c7 04 24 1b dd 10 c0 	movl   $0xc010dd1b,(%esp)
c010905f:	e8 71 7d ff ff       	call   c0100dd5 <__panic>
c0109064:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109067:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010906c:	c9                   	leave  
c010906d:	c3                   	ret    

c010906e <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c010906e:	55                   	push   %ebp
c010906f:	89 e5                	mov    %esp,%ebp
c0109071:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0109074:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010907b:	e8 a5 8a ff ff       	call   c0101b25 <ide_device_valid>
c0109080:	85 c0                	test   %eax,%eax
c0109082:	75 1c                	jne    c01090a0 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0109084:	c7 44 24 08 29 dd 10 	movl   $0xc010dd29,0x8(%esp)
c010908b:	c0 
c010908c:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0109093:	00 
c0109094:	c7 04 24 43 dd 10 c0 	movl   $0xc010dd43,(%esp)
c010909b:	e8 35 7d ff ff       	call   c0100dd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01090a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01090a7:	e8 b8 8a ff ff       	call   c0101b64 <ide_device_size>
c01090ac:	c1 e8 03             	shr    $0x3,%eax
c01090af:	a3 7c f0 19 c0       	mov    %eax,0xc019f07c
}
c01090b4:	c9                   	leave  
c01090b5:	c3                   	ret    

c01090b6 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01090b6:	55                   	push   %ebp
c01090b7:	89 e5                	mov    %esp,%ebp
c01090b9:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01090bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090bf:	89 04 24             	mov    %eax,(%esp)
c01090c2:	e8 53 ff ff ff       	call   c010901a <page2kva>
c01090c7:	8b 55 08             	mov    0x8(%ebp),%edx
c01090ca:	c1 ea 08             	shr    $0x8,%edx
c01090cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01090d4:	74 0b                	je     c01090e1 <swapfs_read+0x2b>
c01090d6:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c01090dc:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01090df:	72 23                	jb     c0109104 <swapfs_read+0x4e>
c01090e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01090e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01090e8:	c7 44 24 08 54 dd 10 	movl   $0xc010dd54,0x8(%esp)
c01090ef:	c0 
c01090f0:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01090f7:	00 
c01090f8:	c7 04 24 43 dd 10 c0 	movl   $0xc010dd43,(%esp)
c01090ff:	e8 d1 7c ff ff       	call   c0100dd5 <__panic>
c0109104:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109107:	c1 e2 03             	shl    $0x3,%edx
c010910a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0109111:	00 
c0109112:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109116:	89 54 24 04          	mov    %edx,0x4(%esp)
c010911a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109121:	e8 7d 8a ff ff       	call   c0101ba3 <ide_read_secs>
}
c0109126:	c9                   	leave  
c0109127:	c3                   	ret    

c0109128 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0109128:	55                   	push   %ebp
c0109129:	89 e5                	mov    %esp,%ebp
c010912b:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010912e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109131:	89 04 24             	mov    %eax,(%esp)
c0109134:	e8 e1 fe ff ff       	call   c010901a <page2kva>
c0109139:	8b 55 08             	mov    0x8(%ebp),%edx
c010913c:	c1 ea 08             	shr    $0x8,%edx
c010913f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109146:	74 0b                	je     c0109153 <swapfs_write+0x2b>
c0109148:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c010914e:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0109151:	72 23                	jb     c0109176 <swapfs_write+0x4e>
c0109153:	8b 45 08             	mov    0x8(%ebp),%eax
c0109156:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010915a:	c7 44 24 08 54 dd 10 	movl   $0xc010dd54,0x8(%esp)
c0109161:	c0 
c0109162:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0109169:	00 
c010916a:	c7 04 24 43 dd 10 c0 	movl   $0xc010dd43,(%esp)
c0109171:	e8 5f 7c ff ff       	call   c0100dd5 <__panic>
c0109176:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109179:	c1 e2 03             	shl    $0x3,%edx
c010917c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0109183:	00 
c0109184:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109188:	89 54 24 04          	mov    %edx,0x4(%esp)
c010918c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109193:	e8 4d 8c ff ff       	call   c0101de5 <ide_write_secs>
}
c0109198:	c9                   	leave  
c0109199:	c3                   	ret    

c010919a <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010919a:	52                   	push   %edx
    call *%ebx              # call fn
c010919b:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c010919d:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c010919e:	e8 6c 0c 00 00       	call   c0109e0f <do_exit>

c01091a3 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c01091a3:	55                   	push   %ebp
c01091a4:	89 e5                	mov    %esp,%ebp
c01091a6:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c01091a9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01091af:	0f ab 02             	bts    %eax,(%edx)
c01091b2:	19 c0                	sbb    %eax,%eax
c01091b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c01091b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01091bb:	0f 95 c0             	setne  %al
c01091be:	0f b6 c0             	movzbl %al,%eax
}
c01091c1:	c9                   	leave  
c01091c2:	c3                   	ret    

c01091c3 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c01091c3:	55                   	push   %ebp
c01091c4:	89 e5                	mov    %esp,%ebp
c01091c6:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c01091c9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01091cf:	0f b3 02             	btr    %eax,(%edx)
c01091d2:	19 c0                	sbb    %eax,%eax
c01091d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c01091d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01091db:	0f 95 c0             	setne  %al
c01091de:	0f b6 c0             	movzbl %al,%eax
}
c01091e1:	c9                   	leave  
c01091e2:	c3                   	ret    

c01091e3 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01091e3:	55                   	push   %ebp
c01091e4:	89 e5                	mov    %esp,%ebp
c01091e6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01091e9:	9c                   	pushf  
c01091ea:	58                   	pop    %eax
c01091eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01091ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01091f1:	25 00 02 00 00       	and    $0x200,%eax
c01091f6:	85 c0                	test   %eax,%eax
c01091f8:	74 0c                	je     c0109206 <__intr_save+0x23>
        intr_disable();
c01091fa:	e8 2e 8e ff ff       	call   c010202d <intr_disable>
        return 1;
c01091ff:	b8 01 00 00 00       	mov    $0x1,%eax
c0109204:	eb 05                	jmp    c010920b <__intr_save+0x28>
    }
    return 0;
c0109206:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010920b:	c9                   	leave  
c010920c:	c3                   	ret    

c010920d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010920d:	55                   	push   %ebp
c010920e:	89 e5                	mov    %esp,%ebp
c0109210:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109217:	74 05                	je     c010921e <__intr_restore+0x11>
        intr_enable();
c0109219:	e8 09 8e ff ff       	call   c0102027 <intr_enable>
    }
}
c010921e:	c9                   	leave  
c010921f:	c3                   	ret    

c0109220 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0109220:	55                   	push   %ebp
c0109221:	89 e5                	mov    %esp,%ebp
c0109223:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c0109226:	8b 45 08             	mov    0x8(%ebp),%eax
c0109229:	89 44 24 04          	mov    %eax,0x4(%esp)
c010922d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109234:	e8 6a ff ff ff       	call   c01091a3 <test_and_set_bit>
c0109239:	85 c0                	test   %eax,%eax
c010923b:	0f 94 c0             	sete   %al
c010923e:	0f b6 c0             	movzbl %al,%eax
}
c0109241:	c9                   	leave  
c0109242:	c3                   	ret    

c0109243 <lock>:

static inline void
lock(lock_t *lock) {
c0109243:	55                   	push   %ebp
c0109244:	89 e5                	mov    %esp,%ebp
c0109246:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c0109249:	eb 05                	jmp    c0109250 <lock+0xd>
        schedule();
c010924b:	e8 24 1c 00 00       	call   c010ae74 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0109250:	8b 45 08             	mov    0x8(%ebp),%eax
c0109253:	89 04 24             	mov    %eax,(%esp)
c0109256:	e8 c5 ff ff ff       	call   c0109220 <try_lock>
c010925b:	85 c0                	test   %eax,%eax
c010925d:	74 ec                	je     c010924b <lock+0x8>
        schedule();
    }
}
c010925f:	c9                   	leave  
c0109260:	c3                   	ret    

c0109261 <unlock>:

static inline void
unlock(lock_t *lock) {
c0109261:	55                   	push   %ebp
c0109262:	89 e5                	mov    %esp,%ebp
c0109264:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c0109267:	8b 45 08             	mov    0x8(%ebp),%eax
c010926a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010926e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109275:	e8 49 ff ff ff       	call   c01091c3 <test_and_clear_bit>
c010927a:	85 c0                	test   %eax,%eax
c010927c:	75 1c                	jne    c010929a <unlock+0x39>
        panic("Unlock failed.\n");
c010927e:	c7 44 24 08 74 dd 10 	movl   $0xc010dd74,0x8(%esp)
c0109285:	c0 
c0109286:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c010928d:	00 
c010928e:	c7 04 24 84 dd 10 c0 	movl   $0xc010dd84,(%esp)
c0109295:	e8 3b 7b ff ff       	call   c0100dd5 <__panic>
    }
}
c010929a:	c9                   	leave  
c010929b:	c3                   	ret    

c010929c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010929c:	55                   	push   %ebp
c010929d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010929f:	8b 55 08             	mov    0x8(%ebp),%edx
c01092a2:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01092a7:	29 c2                	sub    %eax,%edx
c01092a9:	89 d0                	mov    %edx,%eax
c01092ab:	c1 f8 05             	sar    $0x5,%eax
}
c01092ae:	5d                   	pop    %ebp
c01092af:	c3                   	ret    

c01092b0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01092b0:	55                   	push   %ebp
c01092b1:	89 e5                	mov    %esp,%ebp
c01092b3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01092b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b9:	89 04 24             	mov    %eax,(%esp)
c01092bc:	e8 db ff ff ff       	call   c010929c <page2ppn>
c01092c1:	c1 e0 0c             	shl    $0xc,%eax
}
c01092c4:	c9                   	leave  
c01092c5:	c3                   	ret    

c01092c6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01092c6:	55                   	push   %ebp
c01092c7:	89 e5                	mov    %esp,%ebp
c01092c9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01092cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01092cf:	c1 e8 0c             	shr    $0xc,%eax
c01092d2:	89 c2                	mov    %eax,%edx
c01092d4:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01092d9:	39 c2                	cmp    %eax,%edx
c01092db:	72 1c                	jb     c01092f9 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01092dd:	c7 44 24 08 98 dd 10 	movl   $0xc010dd98,0x8(%esp)
c01092e4:	c0 
c01092e5:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01092ec:	00 
c01092ed:	c7 04 24 b7 dd 10 c0 	movl   $0xc010ddb7,(%esp)
c01092f4:	e8 dc 7a ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c01092f9:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01092fe:	8b 55 08             	mov    0x8(%ebp),%edx
c0109301:	c1 ea 0c             	shr    $0xc,%edx
c0109304:	c1 e2 05             	shl    $0x5,%edx
c0109307:	01 d0                	add    %edx,%eax
}
c0109309:	c9                   	leave  
c010930a:	c3                   	ret    

c010930b <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010930b:	55                   	push   %ebp
c010930c:	89 e5                	mov    %esp,%ebp
c010930e:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109311:	8b 45 08             	mov    0x8(%ebp),%eax
c0109314:	89 04 24             	mov    %eax,(%esp)
c0109317:	e8 94 ff ff ff       	call   c01092b0 <page2pa>
c010931c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010931f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109322:	c1 e8 0c             	shr    $0xc,%eax
c0109325:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109328:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010932d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109330:	72 23                	jb     c0109355 <page2kva+0x4a>
c0109332:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109335:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109339:	c7 44 24 08 c8 dd 10 	movl   $0xc010ddc8,0x8(%esp)
c0109340:	c0 
c0109341:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109348:	00 
c0109349:	c7 04 24 b7 dd 10 c0 	movl   $0xc010ddb7,(%esp)
c0109350:	e8 80 7a ff ff       	call   c0100dd5 <__panic>
c0109355:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109358:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010935d:	c9                   	leave  
c010935e:	c3                   	ret    

c010935f <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010935f:	55                   	push   %ebp
c0109360:	89 e5                	mov    %esp,%ebp
c0109362:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0109365:	8b 45 08             	mov    0x8(%ebp),%eax
c0109368:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010936b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0109372:	77 23                	ja     c0109397 <kva2page+0x38>
c0109374:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109377:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010937b:	c7 44 24 08 ec dd 10 	movl   $0xc010ddec,0x8(%esp)
c0109382:	c0 
c0109383:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010938a:	00 
c010938b:	c7 04 24 b7 dd 10 c0 	movl   $0xc010ddb7,(%esp)
c0109392:	e8 3e 7a ff ff       	call   c0100dd5 <__panic>
c0109397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010939a:	05 00 00 00 40       	add    $0x40000000,%eax
c010939f:	89 04 24             	mov    %eax,(%esp)
c01093a2:	e8 1f ff ff ff       	call   c01092c6 <pa2page>
}
c01093a7:	c9                   	leave  
c01093a8:	c3                   	ret    

c01093a9 <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c01093a9:	55                   	push   %ebp
c01093aa:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c01093ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01093af:	8b 40 18             	mov    0x18(%eax),%eax
c01093b2:	8d 50 01             	lea    0x1(%eax),%edx
c01093b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b8:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01093bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01093be:	8b 40 18             	mov    0x18(%eax),%eax
}
c01093c1:	5d                   	pop    %ebp
c01093c2:	c3                   	ret    

c01093c3 <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c01093c3:	55                   	push   %ebp
c01093c4:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c01093c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c9:	8b 40 18             	mov    0x18(%eax),%eax
c01093cc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01093cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01093d2:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01093d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093d8:	8b 40 18             	mov    0x18(%eax),%eax
}
c01093db:	5d                   	pop    %ebp
c01093dc:	c3                   	ret    

c01093dd <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c01093dd:	55                   	push   %ebp
c01093de:	89 e5                	mov    %esp,%ebp
c01093e0:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01093e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01093e7:	74 0e                	je     c01093f7 <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c01093e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ec:	83 c0 1c             	add    $0x1c,%eax
c01093ef:	89 04 24             	mov    %eax,(%esp)
c01093f2:	e8 4c fe ff ff       	call   c0109243 <lock>
    }
}
c01093f7:	c9                   	leave  
c01093f8:	c3                   	ret    

c01093f9 <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c01093f9:	55                   	push   %ebp
c01093fa:	89 e5                	mov    %esp,%ebp
c01093fc:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01093ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109403:	74 0e                	je     c0109413 <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c0109405:	8b 45 08             	mov    0x8(%ebp),%eax
c0109408:	83 c0 1c             	add    $0x1c,%eax
c010940b:	89 04 24             	mov    %eax,(%esp)
c010940e:	e8 4e fe ff ff       	call   c0109261 <unlock>
    }
}
c0109413:	c9                   	leave  
c0109414:	c3                   	ret    

c0109415 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0109415:	55                   	push   %ebp
c0109416:	89 e5                	mov    %esp,%ebp
c0109418:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c010941b:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c0109422:	e8 98 b7 ff ff       	call   c0104bbf <kmalloc>
c0109427:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c010942a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010942e:	0f 84 cd 00 00 00    	je     c0109501 <alloc_proc+0xec>
    /*
     * below fields(add in LAB5) in proc_struct need to be initialized	
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
	 */
		proc->state = PROC_UNINIT;
c0109434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109440:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs = 0;
c0109447:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010944a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c0109451:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109454:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c010945b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010945e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c0109465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109468:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c010946f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109472:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c0109479:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010947c:	83 c0 1c             	add    $0x1c,%eax
c010947f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0109486:	00 
c0109487:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010948e:	00 
c010948f:	89 04 24             	mov    %eax,(%esp)
c0109492:	e8 48 27 00 00       	call   c010bbdf <memset>
        proc->tf = NULL;
c0109497:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010949a:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;
c01094a1:	8b 15 c8 ef 19 c0    	mov    0xc019efc8,%edx
c01094a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094aa:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c01094ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094b0:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN);
c01094b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094ba:	83 c0 48             	add    $0x48,%eax
c01094bd:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01094c4:	00 
c01094c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01094cc:	00 
c01094cd:	89 04 24             	mov    %eax,(%esp)
c01094d0:	e8 0a 27 00 00       	call   c010bbdf <memset>
        proc->wait_state = 0;
c01094d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094d8:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
        proc->cptr = proc->optr = proc->yptr = NULL;
c01094df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094e2:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
c01094e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094ec:	8b 50 74             	mov    0x74(%eax),%edx
c01094ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094f2:	89 50 78             	mov    %edx,0x78(%eax)
c01094f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094f8:	8b 50 78             	mov    0x78(%eax),%edx
c01094fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094fe:	89 50 70             	mov    %edx,0x70(%eax)
    }
    return proc;
c0109501:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109504:	c9                   	leave  
c0109505:	c3                   	ret    

c0109506 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0109506:	55                   	push   %ebp
c0109507:	89 e5                	mov    %esp,%ebp
c0109509:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010950c:	8b 45 08             	mov    0x8(%ebp),%eax
c010950f:	83 c0 48             	add    $0x48,%eax
c0109512:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109519:	00 
c010951a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109521:	00 
c0109522:	89 04 24             	mov    %eax,(%esp)
c0109525:	e8 b5 26 00 00       	call   c010bbdf <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010952a:	8b 45 08             	mov    0x8(%ebp),%eax
c010952d:	8d 50 48             	lea    0x48(%eax),%edx
c0109530:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109537:	00 
c0109538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010953b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010953f:	89 14 24             	mov    %edx,(%esp)
c0109542:	e8 7a 27 00 00       	call   c010bcc1 <memcpy>
}
c0109547:	c9                   	leave  
c0109548:	c3                   	ret    

c0109549 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0109549:	55                   	push   %ebp
c010954a:	89 e5                	mov    %esp,%ebp
c010954c:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c010954f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109556:	00 
c0109557:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010955e:	00 
c010955f:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109566:	e8 74 26 00 00       	call   c010bbdf <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010956b:	8b 45 08             	mov    0x8(%ebp),%eax
c010956e:	83 c0 48             	add    $0x48,%eax
c0109571:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109578:	00 
c0109579:	89 44 24 04          	mov    %eax,0x4(%esp)
c010957d:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109584:	e8 38 27 00 00       	call   c010bcc1 <memcpy>
}
c0109589:	c9                   	leave  
c010958a:	c3                   	ret    

c010958b <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c010958b:	55                   	push   %ebp
c010958c:	89 e5                	mov    %esp,%ebp
c010958e:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c0109591:	8b 45 08             	mov    0x8(%ebp),%eax
c0109594:	83 c0 58             	add    $0x58,%eax
c0109597:	c7 45 fc b0 f0 19 c0 	movl   $0xc019f0b0,-0x4(%ebp)
c010959e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01095a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01095a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01095ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095b0:	8b 40 04             	mov    0x4(%eax),%eax
c01095b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01095b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01095b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01095bc:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01095bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01095c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01095c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01095c8:	89 10                	mov    %edx,(%eax)
c01095ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01095cd:	8b 10                	mov    (%eax),%edx
c01095cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01095d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01095d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01095db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01095de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095e4:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c01095e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e9:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c01095f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f3:	8b 40 14             	mov    0x14(%eax),%eax
c01095f6:	8b 50 70             	mov    0x70(%eax),%edx
c01095f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01095fc:	89 50 78             	mov    %edx,0x78(%eax)
c01095ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109602:	8b 40 78             	mov    0x78(%eax),%eax
c0109605:	85 c0                	test   %eax,%eax
c0109607:	74 0c                	je     c0109615 <set_links+0x8a>
        proc->optr->yptr = proc;
c0109609:	8b 45 08             	mov    0x8(%ebp),%eax
c010960c:	8b 40 78             	mov    0x78(%eax),%eax
c010960f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109612:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c0109615:	8b 45 08             	mov    0x8(%ebp),%eax
c0109618:	8b 40 14             	mov    0x14(%eax),%eax
c010961b:	8b 55 08             	mov    0x8(%ebp),%edx
c010961e:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c0109621:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109626:	83 c0 01             	add    $0x1,%eax
c0109629:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c010962e:	c9                   	leave  
c010962f:	c3                   	ret    

c0109630 <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c0109630:	55                   	push   %ebp
c0109631:	89 e5                	mov    %esp,%ebp
c0109633:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c0109636:	8b 45 08             	mov    0x8(%ebp),%eax
c0109639:	83 c0 58             	add    $0x58,%eax
c010963c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010963f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109642:	8b 40 04             	mov    0x4(%eax),%eax
c0109645:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109648:	8b 12                	mov    (%edx),%edx
c010964a:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010964d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109650:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109653:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109656:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010965c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010965f:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c0109661:	8b 45 08             	mov    0x8(%ebp),%eax
c0109664:	8b 40 78             	mov    0x78(%eax),%eax
c0109667:	85 c0                	test   %eax,%eax
c0109669:	74 0f                	je     c010967a <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c010966b:	8b 45 08             	mov    0x8(%ebp),%eax
c010966e:	8b 40 78             	mov    0x78(%eax),%eax
c0109671:	8b 55 08             	mov    0x8(%ebp),%edx
c0109674:	8b 52 74             	mov    0x74(%edx),%edx
c0109677:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c010967a:	8b 45 08             	mov    0x8(%ebp),%eax
c010967d:	8b 40 74             	mov    0x74(%eax),%eax
c0109680:	85 c0                	test   %eax,%eax
c0109682:	74 11                	je     c0109695 <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c0109684:	8b 45 08             	mov    0x8(%ebp),%eax
c0109687:	8b 40 74             	mov    0x74(%eax),%eax
c010968a:	8b 55 08             	mov    0x8(%ebp),%edx
c010968d:	8b 52 78             	mov    0x78(%edx),%edx
c0109690:	89 50 78             	mov    %edx,0x78(%eax)
c0109693:	eb 0f                	jmp    c01096a4 <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c0109695:	8b 45 08             	mov    0x8(%ebp),%eax
c0109698:	8b 40 14             	mov    0x14(%eax),%eax
c010969b:	8b 55 08             	mov    0x8(%ebp),%edx
c010969e:	8b 52 78             	mov    0x78(%edx),%edx
c01096a1:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c01096a4:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c01096a9:	83 e8 01             	sub    $0x1,%eax
c01096ac:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c01096b1:	c9                   	leave  
c01096b2:	c3                   	ret    

c01096b3 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01096b3:	55                   	push   %ebp
c01096b4:	89 e5                	mov    %esp,%ebp
c01096b6:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01096b9:	c7 45 f8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01096c0:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096c5:	83 c0 01             	add    $0x1,%eax
c01096c8:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c01096cd:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096d2:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01096d7:	7e 0c                	jle    c01096e5 <get_pid+0x32>
        last_pid = 1;
c01096d9:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c01096e0:	00 00 00 
        goto inside;
c01096e3:	eb 13                	jmp    c01096f8 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01096e5:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c01096eb:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01096f0:	39 c2                	cmp    %eax,%edx
c01096f2:	0f 8c ac 00 00 00    	jl     c01097a4 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01096f8:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c01096ff:	20 00 00 
    repeat:
        le = list;
c0109702:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109705:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0109708:	eb 7f                	jmp    c0109789 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c010970a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010970d:	83 e8 58             	sub    $0x58,%eax
c0109710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0109713:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109716:	8b 50 04             	mov    0x4(%eax),%edx
c0109719:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010971e:	39 c2                	cmp    %eax,%edx
c0109720:	75 3e                	jne    c0109760 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0109722:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109727:	83 c0 01             	add    $0x1,%eax
c010972a:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c010972f:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c0109735:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010973a:	39 c2                	cmp    %eax,%edx
c010973c:	7c 4b                	jl     c0109789 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c010973e:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109743:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109748:	7e 0a                	jle    c0109754 <get_pid+0xa1>
                        last_pid = 1;
c010974a:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c0109751:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0109754:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c010975b:	20 00 00 
                    goto repeat;
c010975e:	eb a2                	jmp    c0109702 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0109760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109763:	8b 50 04             	mov    0x4(%eax),%edx
c0109766:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010976b:	39 c2                	cmp    %eax,%edx
c010976d:	7e 1a                	jle    c0109789 <get_pid+0xd6>
c010976f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109772:	8b 50 04             	mov    0x4(%eax),%edx
c0109775:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010977a:	39 c2                	cmp    %eax,%edx
c010977c:	7d 0b                	jge    c0109789 <get_pid+0xd6>
                next_safe = proc->pid;
c010977e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109781:	8b 40 04             	mov    0x4(%eax),%eax
c0109784:	a3 84 aa 12 c0       	mov    %eax,0xc012aa84
c0109789:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010978c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010978f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109792:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0109795:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109798:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010979b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010979e:	0f 85 66 ff ff ff    	jne    c010970a <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c01097a4:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
}
c01097a9:	c9                   	leave  
c01097aa:	c3                   	ret    

c01097ab <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c01097ab:	55                   	push   %ebp
c01097ac:	89 e5                	mov    %esp,%ebp
c01097ae:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01097b1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01097b6:	39 45 08             	cmp    %eax,0x8(%ebp)
c01097b9:	74 63                	je     c010981e <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01097bb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01097c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01097c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01097c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01097c9:	e8 15 fa ff ff       	call   c01091e3 <__intr_save>
c01097ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01097d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01097d4:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88
            load_esp0(next->kstack + KSTACKSIZE);
c01097d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097dc:	8b 40 0c             	mov    0xc(%eax),%eax
c01097df:	05 00 20 00 00       	add    $0x2000,%eax
c01097e4:	89 04 24             	mov    %eax,(%esp)
c01097e7:	e8 fa b6 ff ff       	call   c0104ee6 <load_esp0>
            lcr3(next->cr3);
c01097ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097ef:	8b 40 40             	mov    0x40(%eax),%eax
c01097f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01097f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097f8:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01097fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097fe:	8d 50 1c             	lea    0x1c(%eax),%edx
c0109801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109804:	83 c0 1c             	add    $0x1c,%eax
c0109807:	89 54 24 04          	mov    %edx,0x4(%esp)
c010980b:	89 04 24             	mov    %eax,(%esp)
c010980e:	e8 69 15 00 00       	call   c010ad7c <switch_to>
        }
        local_intr_restore(intr_flag);
c0109813:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109816:	89 04 24             	mov    %eax,(%esp)
c0109819:	e8 ef f9 ff ff       	call   c010920d <__intr_restore>
    }
}
c010981e:	c9                   	leave  
c010981f:	c3                   	ret    

c0109820 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0109820:	55                   	push   %ebp
c0109821:	89 e5                	mov    %esp,%ebp
c0109823:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0109826:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010982b:	8b 40 3c             	mov    0x3c(%eax),%eax
c010982e:	89 04 24             	mov    %eax,(%esp)
c0109831:	e8 10 92 ff ff       	call   c0102a46 <forkrets>
}
c0109836:	c9                   	leave  
c0109837:	c3                   	ret    

c0109838 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0109838:	55                   	push   %ebp
c0109839:	89 e5                	mov    %esp,%ebp
c010983b:	53                   	push   %ebx
c010983c:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c010983f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109842:	8d 58 60             	lea    0x60(%eax),%ebx
c0109845:	8b 45 08             	mov    0x8(%ebp),%eax
c0109848:	8b 40 04             	mov    0x4(%eax),%eax
c010984b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109852:	00 
c0109853:	89 04 24             	mov    %eax,(%esp)
c0109856:	e8 d7 18 00 00       	call   c010b132 <hash32>
c010985b:	c1 e0 03             	shl    $0x3,%eax
c010985e:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109863:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109866:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0109869:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010986c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010986f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109872:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109875:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109878:	8b 40 04             	mov    0x4(%eax),%eax
c010987b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010987e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109881:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109884:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109887:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010988a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010988d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109890:	89 10                	mov    %edx,(%eax)
c0109892:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109895:	8b 10                	mov    (%eax),%edx
c0109897:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010989a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010989d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01098a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01098a3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01098a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01098a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01098ac:	89 10                	mov    %edx,(%eax)
}
c01098ae:	83 c4 34             	add    $0x34,%esp
c01098b1:	5b                   	pop    %ebx
c01098b2:	5d                   	pop    %ebp
c01098b3:	c3                   	ret    

c01098b4 <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c01098b4:	55                   	push   %ebp
c01098b5:	89 e5                	mov    %esp,%ebp
c01098b7:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c01098ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01098bd:	83 c0 60             	add    $0x60,%eax
c01098c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01098c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098c6:	8b 40 04             	mov    0x4(%eax),%eax
c01098c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01098cc:	8b 12                	mov    (%edx),%edx
c01098ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01098d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01098d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01098dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01098e3:	89 10                	mov    %edx,(%eax)
}
c01098e5:	c9                   	leave  
c01098e6:	c3                   	ret    

c01098e7 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c01098e7:	55                   	push   %ebp
c01098e8:	89 e5                	mov    %esp,%ebp
c01098ea:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c01098ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01098f1:	7e 5f                	jle    c0109952 <find_proc+0x6b>
c01098f3:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01098fa:	7f 56                	jg     c0109952 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c01098fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01098ff:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109906:	00 
c0109907:	89 04 24             	mov    %eax,(%esp)
c010990a:	e8 23 18 00 00       	call   c010b132 <hash32>
c010990f:	c1 e0 03             	shl    $0x3,%eax
c0109912:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010991a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010991d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0109920:	eb 19                	jmp    c010993b <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0109922:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109925:	83 e8 60             	sub    $0x60,%eax
c0109928:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c010992b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010992e:	8b 40 04             	mov    0x4(%eax),%eax
c0109931:	3b 45 08             	cmp    0x8(%ebp),%eax
c0109934:	75 05                	jne    c010993b <find_proc+0x54>
                return proc;
c0109936:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109939:	eb 1c                	jmp    c0109957 <find_proc+0x70>
c010993b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010993e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109941:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109944:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109947:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010994a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010994d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0109950:	75 d0                	jne    c0109922 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0109952:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109957:	c9                   	leave  
c0109958:	c3                   	ret    

c0109959 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0109959:	55                   	push   %ebp
c010995a:	89 e5                	mov    %esp,%ebp
c010995c:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c010995f:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109966:	00 
c0109967:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010996e:	00 
c010996f:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109972:	89 04 24             	mov    %eax,(%esp)
c0109975:	e8 65 22 00 00       	call   c010bbdf <memset>
    tf.tf_cs = KERNEL_CS;
c010997a:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0109980:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0109986:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010998a:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c010998e:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0109992:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0109996:	8b 45 08             	mov    0x8(%ebp),%eax
c0109999:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c010999c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010999f:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c01099a2:	b8 9a 91 10 c0       	mov    $0xc010919a,%eax
c01099a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c01099aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01099ad:	80 cc 01             	or     $0x1,%ah
c01099b0:	89 c2                	mov    %eax,%edx
c01099b2:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01099b5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01099b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01099c0:	00 
c01099c1:	89 14 24             	mov    %edx,(%esp)
c01099c4:	e8 25 03 00 00       	call   c0109cee <do_fork>
}
c01099c9:	c9                   	leave  
c01099ca:	c3                   	ret    

c01099cb <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c01099cb:	55                   	push   %ebp
c01099cc:	89 e5                	mov    %esp,%ebp
c01099ce:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c01099d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01099d8:	e8 57 b6 ff ff       	call   c0105034 <alloc_pages>
c01099dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01099e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01099e4:	74 1a                	je     c0109a00 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c01099e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099e9:	89 04 24             	mov    %eax,(%esp)
c01099ec:	e8 1a f9 ff ff       	call   c010930b <page2kva>
c01099f1:	89 c2                	mov    %eax,%edx
c01099f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01099f6:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c01099f9:	b8 00 00 00 00       	mov    $0x0,%eax
c01099fe:	eb 05                	jmp    c0109a05 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0109a00:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0109a05:	c9                   	leave  
c0109a06:	c3                   	ret    

c0109a07 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0109a07:	55                   	push   %ebp
c0109a08:	89 e5                	mov    %esp,%ebp
c0109a0a:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0109a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a10:	8b 40 0c             	mov    0xc(%eax),%eax
c0109a13:	89 04 24             	mov    %eax,(%esp)
c0109a16:	e8 44 f9 ff ff       	call   c010935f <kva2page>
c0109a1b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0109a22:	00 
c0109a23:	89 04 24             	mov    %eax,(%esp)
c0109a26:	e8 74 b6 ff ff       	call   c010509f <free_pages>
}
c0109a2b:	c9                   	leave  
c0109a2c:	c3                   	ret    

c0109a2d <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c0109a2d:	55                   	push   %ebp
c0109a2e:	89 e5                	mov    %esp,%ebp
c0109a30:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c0109a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109a3a:	e8 f5 b5 ff ff       	call   c0105034 <alloc_pages>
c0109a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109a46:	75 0a                	jne    c0109a52 <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109a48:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0109a4d:	e9 80 00 00 00       	jmp    c0109ad2 <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c0109a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109a55:	89 04 24             	mov    %eax,(%esp)
c0109a58:	e8 ae f8 ff ff       	call   c010930b <page2kva>
c0109a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c0109a60:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0109a65:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0109a6c:	00 
c0109a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a74:	89 04 24             	mov    %eax,(%esp)
c0109a77:	e8 45 22 00 00       	call   c010bcc1 <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c0109a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a7f:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0109a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a88:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a8b:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109a92:	77 23                	ja     c0109ab7 <setup_pgdir+0x8a>
c0109a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109a9b:	c7 44 24 08 ec dd 10 	movl   $0xc010ddec,0x8(%esp)
c0109aa2:	c0 
c0109aa3:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0109aaa:	00 
c0109aab:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109ab2:	e8 1e 73 ff ff       	call   c0100dd5 <__panic>
c0109ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109aba:	05 00 00 00 40       	add    $0x40000000,%eax
c0109abf:	83 c8 03             	or     $0x3,%eax
c0109ac2:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109aca:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c0109acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109ad2:	c9                   	leave  
c0109ad3:	c3                   	ret    

c0109ad4 <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109ad4:	55                   	push   %ebp
c0109ad5:	89 e5                	mov    %esp,%ebp
c0109ad7:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0109add:	8b 40 0c             	mov    0xc(%eax),%eax
c0109ae0:	89 04 24             	mov    %eax,(%esp)
c0109ae3:	e8 77 f8 ff ff       	call   c010935f <kva2page>
c0109ae8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109aef:	00 
c0109af0:	89 04 24             	mov    %eax,(%esp)
c0109af3:	e8 a7 b5 ff ff       	call   c010509f <free_pages>
}
c0109af8:	c9                   	leave  
c0109af9:	c3                   	ret    

c0109afa <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109afa:	55                   	push   %ebp
c0109afb:	89 e5                	mov    %esp,%ebp
c0109afd:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c0109b00:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109b05:	8b 40 18             	mov    0x18(%eax),%eax
c0109b08:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109b0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109b0f:	75 0a                	jne    c0109b1b <copy_mm+0x21>
        return 0;
c0109b11:	b8 00 00 00 00       	mov    $0x0,%eax
c0109b16:	e9 f9 00 00 00       	jmp    c0109c14 <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c0109b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b1e:	25 00 01 00 00       	and    $0x100,%eax
c0109b23:	85 c0                	test   %eax,%eax
c0109b25:	74 08                	je     c0109b2f <copy_mm+0x35>
        mm = oldmm;
c0109b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109b2d:	eb 78                	jmp    c0109ba7 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c0109b2f:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109b36:	e8 a0 e2 ff ff       	call   c0107ddb <mm_create>
c0109b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109b42:	75 05                	jne    c0109b49 <copy_mm+0x4f>
        goto bad_mm;
c0109b44:	e9 c8 00 00 00       	jmp    c0109c11 <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c0109b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b4c:	89 04 24             	mov    %eax,(%esp)
c0109b4f:	e8 d9 fe ff ff       	call   c0109a2d <setup_pgdir>
c0109b54:	85 c0                	test   %eax,%eax
c0109b56:	74 05                	je     c0109b5d <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109b58:	e9 a9 00 00 00       	jmp    c0109c06 <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c0109b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b60:	89 04 24             	mov    %eax,(%esp)
c0109b63:	e8 75 f8 ff ff       	call   c01093dd <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b72:	89 04 24             	mov    %eax,(%esp)
c0109b75:	e8 78 e7 ff ff       	call   c01082f2 <dup_mmap>
c0109b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c0109b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b80:	89 04 24             	mov    %eax,(%esp)
c0109b83:	e8 71 f8 ff ff       	call   c01093f9 <unlock_mm>

    if (ret != 0) {
c0109b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109b8c:	74 19                	je     c0109ba7 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c0109b8e:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b92:	89 04 24             	mov    %eax,(%esp)
c0109b95:	e8 59 e8 ff ff       	call   c01083f3 <exit_mmap>
    put_pgdir(mm);
c0109b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b9d:	89 04 24             	mov    %eax,(%esp)
c0109ba0:	e8 2f ff ff ff       	call   c0109ad4 <put_pgdir>
c0109ba5:	eb 5f                	jmp    c0109c06 <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109baa:	89 04 24             	mov    %eax,(%esp)
c0109bad:	e8 f7 f7 ff ff       	call   c01093a9 <mm_count_inc>
    proc->mm = mm;
c0109bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109bb8:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c0109bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bbe:	8b 40 0c             	mov    0xc(%eax),%eax
c0109bc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109bc4:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c0109bcb:	77 23                	ja     c0109bf0 <copy_mm+0xf6>
c0109bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109bd4:	c7 44 24 08 ec dd 10 	movl   $0xc010ddec,0x8(%esp)
c0109bdb:	c0 
c0109bdc:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c0109be3:	00 
c0109be4:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109beb:	e8 e5 71 ff ff       	call   c0100dd5 <__panic>
c0109bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bf3:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bfc:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109bff:	b8 00 00 00 00       	mov    $0x0,%eax
c0109c04:	eb 0e                	jmp    c0109c14 <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109c09:	89 04 24             	mov    %eax,(%esp)
c0109c0c:	e8 23 e5 ff ff       	call   c0108134 <mm_destroy>
bad_mm:
    return ret;
c0109c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0109c14:	c9                   	leave  
c0109c15:	c3                   	ret    

c0109c16 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109c16:	55                   	push   %ebp
c0109c17:	89 e5                	mov    %esp,%ebp
c0109c19:	57                   	push   %edi
c0109c1a:	56                   	push   %esi
c0109c1b:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c1f:	8b 40 0c             	mov    0xc(%eax),%eax
c0109c22:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109c27:	89 c2                	mov    %eax,%edx
c0109c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c2c:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c32:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c35:	8b 55 10             	mov    0x10(%ebp),%edx
c0109c38:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109c3d:	89 c1                	mov    %eax,%ecx
c0109c3f:	83 e1 01             	and    $0x1,%ecx
c0109c42:	85 c9                	test   %ecx,%ecx
c0109c44:	74 0e                	je     c0109c54 <copy_thread+0x3e>
c0109c46:	0f b6 0a             	movzbl (%edx),%ecx
c0109c49:	88 08                	mov    %cl,(%eax)
c0109c4b:	83 c0 01             	add    $0x1,%eax
c0109c4e:	83 c2 01             	add    $0x1,%edx
c0109c51:	83 eb 01             	sub    $0x1,%ebx
c0109c54:	89 c1                	mov    %eax,%ecx
c0109c56:	83 e1 02             	and    $0x2,%ecx
c0109c59:	85 c9                	test   %ecx,%ecx
c0109c5b:	74 0f                	je     c0109c6c <copy_thread+0x56>
c0109c5d:	0f b7 0a             	movzwl (%edx),%ecx
c0109c60:	66 89 08             	mov    %cx,(%eax)
c0109c63:	83 c0 02             	add    $0x2,%eax
c0109c66:	83 c2 02             	add    $0x2,%edx
c0109c69:	83 eb 02             	sub    $0x2,%ebx
c0109c6c:	89 d9                	mov    %ebx,%ecx
c0109c6e:	c1 e9 02             	shr    $0x2,%ecx
c0109c71:	89 c7                	mov    %eax,%edi
c0109c73:	89 d6                	mov    %edx,%esi
c0109c75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c77:	89 f2                	mov    %esi,%edx
c0109c79:	89 f8                	mov    %edi,%eax
c0109c7b:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109c80:	89 de                	mov    %ebx,%esi
c0109c82:	83 e6 02             	and    $0x2,%esi
c0109c85:	85 f6                	test   %esi,%esi
c0109c87:	74 0b                	je     c0109c94 <copy_thread+0x7e>
c0109c89:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0109c8d:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109c91:	83 c1 02             	add    $0x2,%ecx
c0109c94:	83 e3 01             	and    $0x1,%ebx
c0109c97:	85 db                	test   %ebx,%ebx
c0109c99:	74 07                	je     c0109ca2 <copy_thread+0x8c>
c0109c9b:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109c9f:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ca5:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ca8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cb2:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109cb8:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0109cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cbe:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109cc1:	8b 55 08             	mov    0x8(%ebp),%edx
c0109cc4:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109cc7:	8b 52 40             	mov    0x40(%edx),%edx
c0109cca:	80 ce 02             	or     $0x2,%dh
c0109ccd:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109cd0:	ba 20 98 10 c0       	mov    $0xc0109820,%edx
c0109cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cd8:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cde:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ce1:	89 c2                	mov    %eax,%edx
c0109ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ce6:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109ce9:	5b                   	pop    %ebx
c0109cea:	5e                   	pop    %esi
c0109ceb:	5f                   	pop    %edi
c0109cec:	5d                   	pop    %ebp
c0109ced:	c3                   	ret    

c0109cee <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109cee:	55                   	push   %ebp
c0109cef:	89 e5                	mov    %esp,%ebp
c0109cf1:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109cf4:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109cfb:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109d00:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109d05:	7e 05                	jle    c0109d0c <do_fork+0x1e>
        goto fork_out;
c0109d07:	e9 ef 00 00 00       	jmp    c0109dfb <do_fork+0x10d>
    }
    ret = -E_NO_MEM;
c0109d0c:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    if ((proc = alloc_proc()) == NULL) {
c0109d13:	e8 fd f6 ff ff       	call   c0109415 <alloc_proc>
c0109d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109d1f:	75 05                	jne    c0109d26 <do_fork+0x38>
        goto fork_out;
c0109d21:	e9 d5 00 00 00       	jmp    c0109dfb <do_fork+0x10d>
    *    set_links:  set the relation links of process.  ALSO SEE: remove_links:  lean the relation links of process 
    *    -------------------
	*    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */
	proc->parent = current;
c0109d26:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d2f:	89 50 14             	mov    %edx,0x14(%eax)
    assert(current->wait_state == 0);
c0109d32:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109d37:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109d3a:	85 c0                	test   %eax,%eax
c0109d3c:	74 24                	je     c0109d62 <do_fork+0x74>
c0109d3e:	c7 44 24 0c 24 de 10 	movl   $0xc010de24,0xc(%esp)
c0109d45:	c0 
c0109d46:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c0109d4d:	c0 
c0109d4e:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
c0109d55:	00 
c0109d56:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109d5d:	e8 73 70 ff ff       	call   c0100dd5 <__panic>

    if (setup_kstack(proc) != 0) {
c0109d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d65:	89 04 24             	mov    %eax,(%esp)
c0109d68:	e8 5e fc ff ff       	call   c01099cb <setup_kstack>
c0109d6d:	85 c0                	test   %eax,%eax
c0109d6f:	74 05                	je     c0109d76 <do_fork+0x88>
        goto bad_fork_cleanup_proc;
c0109d71:	e9 8a 00 00 00       	jmp    c0109e00 <do_fork+0x112>
    }
    if (copy_mm(clone_flags, proc) != 0) {
c0109d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d80:	89 04 24             	mov    %eax,(%esp)
c0109d83:	e8 72 fd ff ff       	call   c0109afa <copy_mm>
c0109d88:	85 c0                	test   %eax,%eax
c0109d8a:	74 0e                	je     c0109d9a <do_fork+0xac>
        goto bad_fork_cleanup_kstack;
c0109d8c:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d90:	89 04 24             	mov    %eax,(%esp)
c0109d93:	e8 6f fc ff ff       	call   c0109a07 <put_kstack>
c0109d98:	eb 66                	jmp    c0109e00 <do_fork+0x112>
        goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);
c0109d9a:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109da1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dab:	89 04 24             	mov    %eax,(%esp)
c0109dae:	e8 63 fe ff ff       	call   c0109c16 <copy_thread>

    bool intr_flag;
    local_intr_save(intr_flag);
c0109db3:	e8 2b f4 ff ff       	call   c01091e3 <__intr_save>
c0109db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        proc->pid = get_pid();
c0109dbb:	e8 f3 f8 ff ff       	call   c01096b3 <get_pid>
c0109dc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109dc3:	89 42 04             	mov    %eax,0x4(%edx)
        hash_proc(proc);
c0109dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dc9:	89 04 24             	mov    %eax,(%esp)
c0109dcc:	e8 67 fa ff ff       	call   c0109838 <hash_proc>
        set_links(proc);
c0109dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dd4:	89 04 24             	mov    %eax,(%esp)
c0109dd7:	e8 af f7 ff ff       	call   c010958b <set_links>

    }
    local_intr_restore(intr_flag);
c0109ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ddf:	89 04 24             	mov    %eax,(%esp)
c0109de2:	e8 26 f4 ff ff       	call   c010920d <__intr_restore>

    wakeup_proc(proc);
c0109de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dea:	89 04 24             	mov    %eax,(%esp)
c0109ded:	e8 fe 0f 00 00       	call   c010adf0 <wakeup_proc>

    ret = proc->pid;
c0109df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109df5:	8b 40 04             	mov    0x4(%eax),%eax
c0109df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
fork_out:
    return ret;
c0109dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dfe:	eb 0d                	jmp    c0109e0d <do_fork+0x11f>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0109e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e03:	89 04 24             	mov    %eax,(%esp)
c0109e06:	e8 cf ad ff ff       	call   c0104bda <kfree>
    goto fork_out;
c0109e0b:	eb ee                	jmp    c0109dfb <do_fork+0x10d>
}
c0109e0d:	c9                   	leave  
c0109e0e:	c3                   	ret    

c0109e0f <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109e0f:	55                   	push   %ebp
c0109e10:	89 e5                	mov    %esp,%ebp
c0109e12:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c0109e15:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109e1b:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c0109e20:	39 c2                	cmp    %eax,%edx
c0109e22:	75 1c                	jne    c0109e40 <do_exit+0x31>
        panic("idleproc exit.\n");
c0109e24:	c7 44 24 08 52 de 10 	movl   $0xc010de52,0x8(%esp)
c0109e2b:	c0 
c0109e2c:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c0109e33:	00 
c0109e34:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109e3b:	e8 95 6f ff ff       	call   c0100dd5 <__panic>
    }
    if (current == initproc) {
c0109e40:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109e46:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109e4b:	39 c2                	cmp    %eax,%edx
c0109e4d:	75 1c                	jne    c0109e6b <do_exit+0x5c>
        panic("initproc exit.\n");
c0109e4f:	c7 44 24 08 62 de 10 	movl   $0xc010de62,0x8(%esp)
c0109e56:	c0 
c0109e57:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
c0109e5e:	00 
c0109e5f:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109e66:	e8 6a 6f ff ff       	call   c0100dd5 <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c0109e6b:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e70:	8b 40 18             	mov    0x18(%eax),%eax
c0109e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c0109e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109e7a:	74 4a                	je     c0109ec6 <do_exit+0xb7>
        lcr3(boot_cr3);
c0109e7c:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c0109e81:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e87:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c0109e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e8d:	89 04 24             	mov    %eax,(%esp)
c0109e90:	e8 2e f5 ff ff       	call   c01093c3 <mm_count_dec>
c0109e95:	85 c0                	test   %eax,%eax
c0109e97:	75 21                	jne    c0109eba <do_exit+0xab>
            exit_mmap(mm);
c0109e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e9c:	89 04 24             	mov    %eax,(%esp)
c0109e9f:	e8 4f e5 ff ff       	call   c01083f3 <exit_mmap>
            put_pgdir(mm);
c0109ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ea7:	89 04 24             	mov    %eax,(%esp)
c0109eaa:	e8 25 fc ff ff       	call   c0109ad4 <put_pgdir>
            mm_destroy(mm);
c0109eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109eb2:	89 04 24             	mov    %eax,(%esp)
c0109eb5:	e8 7a e2 ff ff       	call   c0108134 <mm_destroy>
        }
        current->mm = NULL;
c0109eba:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ebf:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c0109ec6:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ecb:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c0109ed1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ed6:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ed9:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c0109edc:	e8 02 f3 ff ff       	call   c01091e3 <__intr_save>
c0109ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c0109ee4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ee9:	8b 40 14             	mov    0x14(%eax),%eax
c0109eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c0109eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ef2:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109ef5:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109efa:	75 10                	jne    c0109f0c <do_exit+0xfd>
            wakeup_proc(proc);
c0109efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109eff:	89 04 24             	mov    %eax,(%esp)
c0109f02:	e8 e9 0e 00 00       	call   c010adf0 <wakeup_proc>
        }
        while (current->cptr != NULL) {
c0109f07:	e9 8b 00 00 00       	jmp    c0109f97 <do_exit+0x188>
c0109f0c:	e9 86 00 00 00       	jmp    c0109f97 <do_exit+0x188>
            proc = current->cptr;
c0109f11:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f16:	8b 40 70             	mov    0x70(%eax),%eax
c0109f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c0109f1c:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f21:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f24:	8b 52 78             	mov    0x78(%edx),%edx
c0109f27:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c0109f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f2d:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c0109f34:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f39:	8b 50 70             	mov    0x70(%eax),%edx
c0109f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f3f:	89 50 78             	mov    %edx,0x78(%eax)
c0109f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f45:	8b 40 78             	mov    0x78(%eax),%eax
c0109f48:	85 c0                	test   %eax,%eax
c0109f4a:	74 0e                	je     c0109f5a <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c0109f4c:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f51:	8b 40 70             	mov    0x70(%eax),%eax
c0109f54:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f57:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c0109f5a:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c0109f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f63:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c0109f66:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f6e:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c0109f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f74:	8b 00                	mov    (%eax),%eax
c0109f76:	83 f8 03             	cmp    $0x3,%eax
c0109f79:	75 1c                	jne    c0109f97 <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c0109f7b:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f80:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109f83:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109f88:	75 0d                	jne    c0109f97 <do_exit+0x188>
                    wakeup_proc(initproc);
c0109f8a:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f8f:	89 04 24             	mov    %eax,(%esp)
c0109f92:	e8 59 0e 00 00       	call   c010adf0 <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c0109f97:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f9c:	8b 40 70             	mov    0x70(%eax),%eax
c0109f9f:	85 c0                	test   %eax,%eax
c0109fa1:	0f 85 6a ff ff ff    	jne    c0109f11 <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c0109fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109faa:	89 04 24             	mov    %eax,(%esp)
c0109fad:	e8 5b f2 ff ff       	call   c010920d <__intr_restore>
    
    schedule();
c0109fb2:	e8 bd 0e 00 00       	call   c010ae74 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c0109fb7:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109fbc:	8b 40 04             	mov    0x4(%eax),%eax
c0109fbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109fc3:	c7 44 24 08 74 de 10 	movl   $0xc010de74,0x8(%esp)
c0109fca:	c0 
c0109fcb:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0109fd2:	00 
c0109fd3:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c0109fda:	e8 f6 6d ff ff       	call   c0100dd5 <__panic>

c0109fdf <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c0109fdf:	55                   	push   %ebp
c0109fe0:	89 e5                	mov    %esp,%ebp
c0109fe2:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c0109fe5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109fea:	8b 40 18             	mov    0x18(%eax),%eax
c0109fed:	85 c0                	test   %eax,%eax
c0109fef:	74 1c                	je     c010a00d <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c0109ff1:	c7 44 24 08 94 de 10 	movl   $0xc010de94,0x8(%esp)
c0109ff8:	c0 
c0109ff9:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c010a000:	00 
c010a001:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a008:	e8 c8 6d ff ff       	call   c0100dd5 <__panic>
    }

    int ret = -E_NO_MEM;
c010a00d:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c010a014:	e8 c2 dd ff ff       	call   c0107ddb <mm_create>
c010a019:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010a01c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010a020:	75 06                	jne    c010a028 <load_icode+0x49>
        goto bad_mm;
c010a022:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c010a023:	e9 ef 05 00 00       	jmp    c010a617 <load_icode+0x638>
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c010a028:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a02b:	89 04 24             	mov    %eax,(%esp)
c010a02e:	e8 fa f9 ff ff       	call   c0109a2d <setup_pgdir>
c010a033:	85 c0                	test   %eax,%eax
c010a035:	74 05                	je     c010a03c <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c010a037:	e9 f6 05 00 00       	jmp    c010a632 <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c010a03c:	8b 45 08             	mov    0x8(%ebp),%eax
c010a03f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c010a042:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a045:	8b 50 1c             	mov    0x1c(%eax),%edx
c010a048:	8b 45 08             	mov    0x8(%ebp),%eax
c010a04b:	01 d0                	add    %edx,%eax
c010a04d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c010a050:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a053:	8b 00                	mov    (%eax),%eax
c010a055:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c010a05a:	74 0c                	je     c010a068 <load_icode+0x89>
        ret = -E_INVAL_ELF;
c010a05c:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c010a063:	e9 bf 05 00 00       	jmp    c010a627 <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c010a068:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a06b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010a06f:	0f b7 c0             	movzwl %ax,%eax
c010a072:	c1 e0 05             	shl    $0x5,%eax
c010a075:	89 c2                	mov    %eax,%edx
c010a077:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a07a:	01 d0                	add    %edx,%eax
c010a07c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c010a07f:	e9 13 03 00 00       	jmp    c010a397 <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c010a084:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a087:	8b 00                	mov    (%eax),%eax
c010a089:	83 f8 01             	cmp    $0x1,%eax
c010a08c:	74 05                	je     c010a093 <load_icode+0xb4>
            continue ;
c010a08e:	e9 00 03 00 00       	jmp    c010a393 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c010a093:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a096:	8b 50 10             	mov    0x10(%eax),%edx
c010a099:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a09c:	8b 40 14             	mov    0x14(%eax),%eax
c010a09f:	39 c2                	cmp    %eax,%edx
c010a0a1:	76 0c                	jbe    c010a0af <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c010a0a3:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c010a0aa:	e9 6d 05 00 00       	jmp    c010a61c <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c010a0af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0b2:	8b 40 10             	mov    0x10(%eax),%eax
c010a0b5:	85 c0                	test   %eax,%eax
c010a0b7:	75 05                	jne    c010a0be <load_icode+0xdf>
            continue ;
c010a0b9:	e9 d5 02 00 00       	jmp    c010a393 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c010a0be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010a0c5:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c010a0cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0cf:	8b 40 18             	mov    0x18(%eax),%eax
c010a0d2:	83 e0 01             	and    $0x1,%eax
c010a0d5:	85 c0                	test   %eax,%eax
c010a0d7:	74 04                	je     c010a0dd <load_icode+0xfe>
c010a0d9:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c010a0dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0e0:	8b 40 18             	mov    0x18(%eax),%eax
c010a0e3:	83 e0 02             	and    $0x2,%eax
c010a0e6:	85 c0                	test   %eax,%eax
c010a0e8:	74 04                	je     c010a0ee <load_icode+0x10f>
c010a0ea:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c010a0ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0f1:	8b 40 18             	mov    0x18(%eax),%eax
c010a0f4:	83 e0 04             	and    $0x4,%eax
c010a0f7:	85 c0                	test   %eax,%eax
c010a0f9:	74 04                	je     c010a0ff <load_icode+0x120>
c010a0fb:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c010a0ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a102:	83 e0 02             	and    $0x2,%eax
c010a105:	85 c0                	test   %eax,%eax
c010a107:	74 04                	je     c010a10d <load_icode+0x12e>
c010a109:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c010a10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a110:	8b 50 14             	mov    0x14(%eax),%edx
c010a113:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a116:	8b 40 08             	mov    0x8(%eax),%eax
c010a119:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a120:	00 
c010a121:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a124:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a128:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a12c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a130:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a133:	89 04 24             	mov    %eax,(%esp)
c010a136:	e8 9b e0 ff ff       	call   c01081d6 <mm_map>
c010a13b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a13e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a142:	74 05                	je     c010a149 <load_icode+0x16a>
            goto bad_cleanup_mmap;
c010a144:	e9 d3 04 00 00       	jmp    c010a61c <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c010a149:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a14c:	8b 50 04             	mov    0x4(%eax),%edx
c010a14f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a152:	01 d0                	add    %edx,%eax
c010a154:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c010a157:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a15a:	8b 40 08             	mov    0x8(%eax),%eax
c010a15d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a160:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a163:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010a166:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010a169:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010a16e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c010a171:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c010a178:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a17b:	8b 50 08             	mov    0x8(%eax),%edx
c010a17e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a181:	8b 40 10             	mov    0x10(%eax),%eax
c010a184:	01 d0                	add    %edx,%eax
c010a186:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a189:	e9 90 00 00 00       	jmp    c010a21e <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a18e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a191:	8b 40 0c             	mov    0xc(%eax),%eax
c010a194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a197:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a19b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a19e:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a1a2:	89 04 24             	mov    %eax,(%esp)
c010a1a5:	e8 56 bd ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a1aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a1ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a1b1:	75 05                	jne    c010a1b8 <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c010a1b3:	e9 64 04 00 00       	jmp    c010a61c <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a1b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a1bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a1be:	29 c2                	sub    %eax,%edx
c010a1c0:	89 d0                	mov    %edx,%eax
c010a1c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a1c5:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a1ca:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a1cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a1d0:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a1d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a1da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a1dd:	73 0d                	jae    c010a1ec <load_icode+0x20d>
                size -= la - end;
c010a1df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a1e2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a1e5:	29 c2                	sub    %eax,%edx
c010a1e7:	89 d0                	mov    %edx,%eax
c010a1e9:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c010a1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a1ef:	89 04 24             	mov    %eax,(%esp)
c010a1f2:	e8 14 f1 ff ff       	call   c010930b <page2kva>
c010a1f7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a1fa:	01 c2                	add    %eax,%edx
c010a1fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a203:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010a206:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a20a:	89 14 24             	mov    %edx,(%esp)
c010a20d:	e8 af 1a 00 00       	call   c010bcc1 <memcpy>
            start += size, from += size;
c010a212:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a215:	01 45 d8             	add    %eax,-0x28(%ebp)
c010a218:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a21b:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a21e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a221:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a224:	0f 82 64 ff ff ff    	jb     c010a18e <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c010a22a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a22d:	8b 50 08             	mov    0x8(%eax),%edx
c010a230:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a233:	8b 40 14             	mov    0x14(%eax),%eax
c010a236:	01 d0                	add    %edx,%eax
c010a238:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c010a23b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a23e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a241:	0f 83 b0 00 00 00    	jae    c010a2f7 <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c010a247:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a24a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a24d:	75 05                	jne    c010a254 <load_icode+0x275>
                continue ;
c010a24f:	e9 3f 01 00 00       	jmp    c010a393 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c010a254:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a257:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a25a:	29 c2                	sub    %eax,%edx
c010a25c:	89 d0                	mov    %edx,%eax
c010a25e:	05 00 10 00 00       	add    $0x1000,%eax
c010a263:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a266:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a26b:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a26e:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c010a271:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a274:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a277:	73 0d                	jae    c010a286 <load_icode+0x2a7>
                size -= la - end;
c010a279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a27c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a27f:	29 c2                	sub    %eax,%edx
c010a281:	89 d0                	mov    %edx,%eax
c010a283:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a286:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a289:	89 04 24             	mov    %eax,(%esp)
c010a28c:	e8 7a f0 ff ff       	call   c010930b <page2kva>
c010a291:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a294:	01 c2                	add    %eax,%edx
c010a296:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a299:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a2a4:	00 
c010a2a5:	89 14 24             	mov    %edx,(%esp)
c010a2a8:	e8 32 19 00 00       	call   c010bbdf <memset>
            start += size;
c010a2ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a2b0:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c010a2b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a2b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a2b9:	73 08                	jae    c010a2c3 <load_icode+0x2e4>
c010a2bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a2be:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a2c1:	74 34                	je     c010a2f7 <load_icode+0x318>
c010a2c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a2c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a2c9:	72 08                	jb     c010a2d3 <load_icode+0x2f4>
c010a2cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a2ce:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a2d1:	74 24                	je     c010a2f7 <load_icode+0x318>
c010a2d3:	c7 44 24 0c bc de 10 	movl   $0xc010debc,0xc(%esp)
c010a2da:	c0 
c010a2db:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010a2e2:	c0 
c010a2e3:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c010a2ea:	00 
c010a2eb:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a2f2:	e8 de 6a ff ff       	call   c0100dd5 <__panic>
        }
        while (start < end) {
c010a2f7:	e9 8b 00 00 00       	jmp    c010a387 <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a2fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a2ff:	8b 40 0c             	mov    0xc(%eax),%eax
c010a302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a305:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a309:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a30c:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a310:	89 04 24             	mov    %eax,(%esp)
c010a313:	e8 e8 bb ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a318:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a31b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a31f:	75 05                	jne    c010a326 <load_icode+0x347>
                goto bad_cleanup_mmap;
c010a321:	e9 f6 02 00 00       	jmp    c010a61c <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a326:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a329:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a32c:	29 c2                	sub    %eax,%edx
c010a32e:	89 d0                	mov    %edx,%eax
c010a330:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a333:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a338:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a33b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a33e:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a345:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a34b:	73 0d                	jae    c010a35a <load_icode+0x37b>
                size -= la - end;
c010a34d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a350:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a353:	29 c2                	sub    %eax,%edx
c010a355:	89 d0                	mov    %edx,%eax
c010a357:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a35a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a35d:	89 04 24             	mov    %eax,(%esp)
c010a360:	e8 a6 ef ff ff       	call   c010930b <page2kva>
c010a365:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a368:	01 c2                	add    %eax,%edx
c010a36a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a36d:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a371:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a378:	00 
c010a379:	89 14 24             	mov    %edx,(%esp)
c010a37c:	e8 5e 18 00 00       	call   c010bbdf <memset>
            start += size;
c010a381:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a384:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a387:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a38a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a38d:	0f 82 69 ff ff ff    	jb     c010a2fc <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a393:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a397:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a39a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a39d:	0f 82 e1 fc ff ff    	jb     c010a084 <load_icode+0xa5>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a3a3:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a3aa:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a3b1:	00 
c010a3b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a3b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a3b9:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a3c0:	00 
c010a3c1:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a3c8:	af 
c010a3c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a3cc:	89 04 24             	mov    %eax,(%esp)
c010a3cf:	e8 02 de ff ff       	call   c01081d6 <mm_map>
c010a3d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a3d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a3db:	74 05                	je     c010a3e2 <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a3dd:	e9 3a 02 00 00       	jmp    c010a61c <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a3e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a3e5:	8b 40 0c             	mov    0xc(%eax),%eax
c010a3e8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a3ef:	00 
c010a3f0:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a3f7:	af 
c010a3f8:	89 04 24             	mov    %eax,(%esp)
c010a3fb:	e8 00 bb ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a400:	85 c0                	test   %eax,%eax
c010a402:	75 24                	jne    c010a428 <load_icode+0x449>
c010a404:	c7 44 24 0c f8 de 10 	movl   $0xc010def8,0xc(%esp)
c010a40b:	c0 
c010a40c:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010a413:	c0 
c010a414:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c010a41b:	00 
c010a41c:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a423:	e8 ad 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a428:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a42b:	8b 40 0c             	mov    0xc(%eax),%eax
c010a42e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a435:	00 
c010a436:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a43d:	af 
c010a43e:	89 04 24             	mov    %eax,(%esp)
c010a441:	e8 ba ba ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a446:	85 c0                	test   %eax,%eax
c010a448:	75 24                	jne    c010a46e <load_icode+0x48f>
c010a44a:	c7 44 24 0c 3c df 10 	movl   $0xc010df3c,0xc(%esp)
c010a451:	c0 
c010a452:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010a459:	c0 
c010a45a:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
c010a461:	00 
c010a462:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a469:	e8 67 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a46e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a471:	8b 40 0c             	mov    0xc(%eax),%eax
c010a474:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a47b:	00 
c010a47c:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a483:	af 
c010a484:	89 04 24             	mov    %eax,(%esp)
c010a487:	e8 74 ba ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a48c:	85 c0                	test   %eax,%eax
c010a48e:	75 24                	jne    c010a4b4 <load_icode+0x4d5>
c010a490:	c7 44 24 0c 80 df 10 	movl   $0xc010df80,0xc(%esp)
c010a497:	c0 
c010a498:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010a49f:	c0 
c010a4a0:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
c010a4a7:	00 
c010a4a8:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a4af:	e8 21 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a4b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4b7:	8b 40 0c             	mov    0xc(%eax),%eax
c010a4ba:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a4c1:	00 
c010a4c2:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a4c9:	af 
c010a4ca:	89 04 24             	mov    %eax,(%esp)
c010a4cd:	e8 2e ba ff ff       	call   c0105f00 <pgdir_alloc_page>
c010a4d2:	85 c0                	test   %eax,%eax
c010a4d4:	75 24                	jne    c010a4fa <load_icode+0x51b>
c010a4d6:	c7 44 24 0c c4 df 10 	movl   $0xc010dfc4,0xc(%esp)
c010a4dd:	c0 
c010a4de:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010a4e5:	c0 
c010a4e6:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
c010a4ed:	00 
c010a4ee:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a4f5:	e8 db 68 ff ff       	call   c0100dd5 <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a4fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4fd:	89 04 24             	mov    %eax,(%esp)
c010a500:	e8 a4 ee ff ff       	call   c01093a9 <mm_count_inc>
    current->mm = mm;
c010a505:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a50a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a50d:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a510:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a515:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a518:	8b 52 0c             	mov    0xc(%edx),%edx
c010a51b:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a51e:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a525:	77 23                	ja     c010a54a <load_icode+0x56b>
c010a527:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a52a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a52e:	c7 44 24 08 ec dd 10 	movl   $0xc010ddec,0x8(%esp)
c010a535:	c0 
c010a536:	c7 44 24 04 76 02 00 	movl   $0x276,0x4(%esp)
c010a53d:	00 
c010a53e:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a545:	e8 8b 68 ff ff       	call   c0100dd5 <__panic>
c010a54a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a54d:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a553:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a556:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a559:	8b 40 0c             	mov    0xc(%eax),%eax
c010a55c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a55f:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a566:	77 23                	ja     c010a58b <load_icode+0x5ac>
c010a568:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a56b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a56f:	c7 44 24 08 ec dd 10 	movl   $0xc010ddec,0x8(%esp)
c010a576:	c0 
c010a577:	c7 44 24 04 77 02 00 	movl   $0x277,0x4(%esp)
c010a57e:	00 
c010a57f:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a586:	e8 4a 68 ff ff       	call   c0100dd5 <__panic>
c010a58b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a58e:	05 00 00 00 40       	add    $0x40000000,%eax
c010a593:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a596:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a599:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a59c:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a5a1:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a5a4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a5a7:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a5ae:	00 
c010a5af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a5b6:	00 
c010a5b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5ba:	89 04 24             	mov    %eax,(%esp)
c010a5bd:	e8 1d 16 00 00       	call   c010bbdf <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a5c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5c5:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a5cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5ce:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a5d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5d7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a5db:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5de:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a5e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5e5:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a5e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5ec:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a5f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5f3:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a5fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a5fd:	8b 50 18             	mov    0x18(%eax),%edx
c010a600:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a603:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a606:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a609:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    ret = 0;
c010a610:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a61a:	eb 23                	jmp    c010a63f <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a61c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a61f:	89 04 24             	mov    %eax,(%esp)
c010a622:	e8 cc dd ff ff       	call   c01083f3 <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a627:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a62a:	89 04 24             	mov    %eax,(%esp)
c010a62d:	e8 a2 f4 ff ff       	call   c0109ad4 <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a632:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a635:	89 04 24             	mov    %eax,(%esp)
c010a638:	e8 f7 da ff ff       	call   c0108134 <mm_destroy>
bad_mm:
    goto out;
c010a63d:	eb d8                	jmp    c010a617 <load_icode+0x638>
}
c010a63f:	c9                   	leave  
c010a640:	c3                   	ret    

c010a641 <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a641:	55                   	push   %ebp
c010a642:	89 e5                	mov    %esp,%ebp
c010a644:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a647:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a64c:	8b 40 18             	mov    0x18(%eax),%eax
c010a64f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a652:	8b 45 08             	mov    0x8(%ebp),%eax
c010a655:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a65c:	00 
c010a65d:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a660:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a664:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a66b:	89 04 24             	mov    %eax,(%esp)
c010a66e:	e8 5a e8 ff ff       	call   c0108ecd <user_mem_check>
c010a673:	85 c0                	test   %eax,%eax
c010a675:	75 0a                	jne    c010a681 <do_execve+0x40>
        return -E_INVAL;
c010a677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a67c:	e9 f4 00 00 00       	jmp    c010a775 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a681:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a685:	76 07                	jbe    c010a68e <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a687:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a68e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a695:	00 
c010a696:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a69d:	00 
c010a69e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a6a1:	89 04 24             	mov    %eax,(%esp)
c010a6a4:	e8 36 15 00 00       	call   c010bbdf <memset>
    memcpy(local_name, name, len);
c010a6a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a6ac:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a6b0:	8b 45 08             	mov    0x8(%ebp),%eax
c010a6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a6b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a6ba:	89 04 24             	mov    %eax,(%esp)
c010a6bd:	e8 ff 15 00 00       	call   c010bcc1 <memcpy>

    if (mm != NULL) {
c010a6c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a6c6:	74 4a                	je     c010a712 <do_execve+0xd1>
        lcr3(boot_cr3);
c010a6c8:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010a6cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a6d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a6d3:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6d9:	89 04 24             	mov    %eax,(%esp)
c010a6dc:	e8 e2 ec ff ff       	call   c01093c3 <mm_count_dec>
c010a6e1:	85 c0                	test   %eax,%eax
c010a6e3:	75 21                	jne    c010a706 <do_execve+0xc5>
            exit_mmap(mm);
c010a6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6e8:	89 04 24             	mov    %eax,(%esp)
c010a6eb:	e8 03 dd ff ff       	call   c01083f3 <exit_mmap>
            put_pgdir(mm);
c010a6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6f3:	89 04 24             	mov    %eax,(%esp)
c010a6f6:	e8 d9 f3 ff ff       	call   c0109ad4 <put_pgdir>
            mm_destroy(mm);
c010a6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6fe:	89 04 24             	mov    %eax,(%esp)
c010a701:	e8 2e da ff ff       	call   c0108134 <mm_destroy>
        }
        current->mm = NULL;
c010a706:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a70b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a712:	8b 45 14             	mov    0x14(%ebp),%eax
c010a715:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a719:	8b 45 10             	mov    0x10(%ebp),%eax
c010a71c:	89 04 24             	mov    %eax,(%esp)
c010a71f:	e8 bb f8 ff ff       	call   c0109fdf <load_icode>
c010a724:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a72b:	74 2f                	je     c010a75c <do_execve+0x11b>
        goto execve_exit;
c010a72d:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a731:	89 04 24             	mov    %eax,(%esp)
c010a734:	e8 d6 f6 ff ff       	call   c0109e0f <do_exit>
    panic("already exit: %e.\n", ret);
c010a739:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a73c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a740:	c7 44 24 08 07 e0 10 	movl   $0xc010e007,0x8(%esp)
c010a747:	c0 
c010a748:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c010a74f:	00 
c010a750:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a757:	e8 79 66 ff ff       	call   c0100dd5 <__panic>
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a75c:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a761:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a764:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a768:	89 04 24             	mov    %eax,(%esp)
c010a76b:	e8 96 ed ff ff       	call   c0109506 <set_proc_name>
    return 0;
c010a770:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a775:	c9                   	leave  
c010a776:	c3                   	ret    

c010a777 <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a777:	55                   	push   %ebp
c010a778:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a77a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a77f:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a786:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a78b:	5d                   	pop    %ebp
c010a78c:	c3                   	ret    

c010a78d <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a78d:	55                   	push   %ebp
c010a78e:	89 e5                	mov    %esp,%ebp
c010a790:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a793:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a798:	8b 40 18             	mov    0x18(%eax),%eax
c010a79b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a79e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a7a2:	74 30                	je     c010a7d4 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a7a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a7a7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a7ae:	00 
c010a7af:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a7b6:	00 
c010a7b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a7bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a7be:	89 04 24             	mov    %eax,(%esp)
c010a7c1:	e8 07 e7 ff ff       	call   c0108ecd <user_mem_check>
c010a7c6:	85 c0                	test   %eax,%eax
c010a7c8:	75 0a                	jne    c010a7d4 <do_wait+0x47>
            return -E_INVAL;
c010a7ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a7cf:	e9 4b 01 00 00       	jmp    c010a91f <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a7d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a7db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a7df:	74 39                	je     c010a81a <do_wait+0x8d>
        proc = find_proc(pid);
c010a7e1:	8b 45 08             	mov    0x8(%ebp),%eax
c010a7e4:	89 04 24             	mov    %eax,(%esp)
c010a7e7:	e8 fb f0 ff ff       	call   c01098e7 <find_proc>
c010a7ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a7ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a7f3:	74 54                	je     c010a849 <do_wait+0xbc>
c010a7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a7f8:	8b 50 14             	mov    0x14(%eax),%edx
c010a7fb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a800:	39 c2                	cmp    %eax,%edx
c010a802:	75 45                	jne    c010a849 <do_wait+0xbc>
            haskid = 1;
c010a804:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a80e:	8b 00                	mov    (%eax),%eax
c010a810:	83 f8 03             	cmp    $0x3,%eax
c010a813:	75 34                	jne    c010a849 <do_wait+0xbc>
                goto found;
c010a815:	e9 80 00 00 00       	jmp    c010a89a <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010a81a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a81f:	8b 40 70             	mov    0x70(%eax),%eax
c010a822:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010a825:	eb 1c                	jmp    c010a843 <do_wait+0xb6>
            haskid = 1;
c010a827:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a831:	8b 00                	mov    (%eax),%eax
c010a833:	83 f8 03             	cmp    $0x3,%eax
c010a836:	75 02                	jne    c010a83a <do_wait+0xad>
                goto found;
c010a838:	eb 60                	jmp    c010a89a <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010a83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a83d:	8b 40 78             	mov    0x78(%eax),%eax
c010a840:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a847:	75 de                	jne    c010a827 <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010a849:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a84d:	74 41                	je     c010a890 <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010a84f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a854:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010a85a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a85f:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010a866:	e8 09 06 00 00       	call   c010ae74 <schedule>
        if (current->flags & PF_EXITING) {
c010a86b:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a870:	8b 40 44             	mov    0x44(%eax),%eax
c010a873:	83 e0 01             	and    $0x1,%eax
c010a876:	85 c0                	test   %eax,%eax
c010a878:	74 11                	je     c010a88b <do_wait+0xfe>
            do_exit(-E_KILLED);
c010a87a:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010a881:	e8 89 f5 ff ff       	call   c0109e0f <do_exit>
        }
        goto repeat;
c010a886:	e9 49 ff ff ff       	jmp    c010a7d4 <do_wait+0x47>
c010a88b:	e9 44 ff ff ff       	jmp    c010a7d4 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010a890:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010a895:	e9 85 00 00 00       	jmp    c010a91f <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010a89a:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010a89f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a8a2:	74 0a                	je     c010a8ae <do_wait+0x121>
c010a8a4:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a8a9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a8ac:	75 1c                	jne    c010a8ca <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010a8ae:	c7 44 24 08 1a e0 10 	movl   $0xc010e01a,0x8(%esp)
c010a8b5:	c0 
c010a8b6:	c7 44 24 04 f2 02 00 	movl   $0x2f2,0x4(%esp)
c010a8bd:	00 
c010a8be:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010a8c5:	e8 0b 65 ff ff       	call   c0100dd5 <__panic>
    }
    if (code_store != NULL) {
c010a8ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a8ce:	74 0b                	je     c010a8db <do_wait+0x14e>
        *code_store = proc->exit_code;
c010a8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8d3:	8b 50 68             	mov    0x68(%eax),%edx
c010a8d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a8d9:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010a8db:	e8 03 e9 ff ff       	call   c01091e3 <__intr_save>
c010a8e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010a8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8e6:	89 04 24             	mov    %eax,(%esp)
c010a8e9:	e8 c6 ef ff ff       	call   c01098b4 <unhash_proc>
        remove_links(proc);
c010a8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8f1:	89 04 24             	mov    %eax,(%esp)
c010a8f4:	e8 37 ed ff ff       	call   c0109630 <remove_links>
    }
    local_intr_restore(intr_flag);
c010a8f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a8fc:	89 04 24             	mov    %eax,(%esp)
c010a8ff:	e8 09 e9 ff ff       	call   c010920d <__intr_restore>
    put_kstack(proc);
c010a904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a907:	89 04 24             	mov    %eax,(%esp)
c010a90a:	e8 f8 f0 ff ff       	call   c0109a07 <put_kstack>
    kfree(proc);
c010a90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a912:	89 04 24             	mov    %eax,(%esp)
c010a915:	e8 c0 a2 ff ff       	call   c0104bda <kfree>
    return 0;
c010a91a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a91f:	c9                   	leave  
c010a920:	c3                   	ret    

c010a921 <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010a921:	55                   	push   %ebp
c010a922:	89 e5                	mov    %esp,%ebp
c010a924:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010a927:	8b 45 08             	mov    0x8(%ebp),%eax
c010a92a:	89 04 24             	mov    %eax,(%esp)
c010a92d:	e8 b5 ef ff ff       	call   c01098e7 <find_proc>
c010a932:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a939:	74 41                	je     c010a97c <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010a93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a93e:	8b 40 44             	mov    0x44(%eax),%eax
c010a941:	83 e0 01             	and    $0x1,%eax
c010a944:	85 c0                	test   %eax,%eax
c010a946:	75 2d                	jne    c010a975 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010a948:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a94b:	8b 40 44             	mov    0x44(%eax),%eax
c010a94e:	83 c8 01             	or     $0x1,%eax
c010a951:	89 c2                	mov    %eax,%edx
c010a953:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a956:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010a959:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a95c:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a95f:	85 c0                	test   %eax,%eax
c010a961:	79 0b                	jns    c010a96e <do_kill+0x4d>
                wakeup_proc(proc);
c010a963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a966:	89 04 24             	mov    %eax,(%esp)
c010a969:	e8 82 04 00 00       	call   c010adf0 <wakeup_proc>
            }
            return 0;
c010a96e:	b8 00 00 00 00       	mov    $0x0,%eax
c010a973:	eb 0c                	jmp    c010a981 <do_kill+0x60>
        }
        return -E_KILLED;
c010a975:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010a97a:	eb 05                	jmp    c010a981 <do_kill+0x60>
    }
    return -E_INVAL;
c010a97c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010a981:	c9                   	leave  
c010a982:	c3                   	ret    

c010a983 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010a983:	55                   	push   %ebp
c010a984:	89 e5                	mov    %esp,%ebp
c010a986:	57                   	push   %edi
c010a987:	56                   	push   %esi
c010a988:	53                   	push   %ebx
c010a989:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010a98c:	8b 45 08             	mov    0x8(%ebp),%eax
c010a98f:	89 04 24             	mov    %eax,(%esp)
c010a992:	e8 19 0f 00 00       	call   c010b8b0 <strlen>
c010a997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010a99a:	b8 04 00 00 00       	mov    $0x4,%eax
c010a99f:	8b 55 08             	mov    0x8(%ebp),%edx
c010a9a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010a9a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010a9a8:	8b 75 10             	mov    0x10(%ebp),%esi
c010a9ab:	89 f7                	mov    %esi,%edi
c010a9ad:	cd 80                	int    $0x80
c010a9af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010a9b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010a9b5:	83 c4 2c             	add    $0x2c,%esp
c010a9b8:	5b                   	pop    %ebx
c010a9b9:	5e                   	pop    %esi
c010a9ba:	5f                   	pop    %edi
c010a9bb:	5d                   	pop    %ebp
c010a9bc:	c3                   	ret    

c010a9bd <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010a9bd:	55                   	push   %ebp
c010a9be:	89 e5                	mov    %esp,%ebp
c010a9c0:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010a9c3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a9c8:	8b 40 04             	mov    0x4(%eax),%eax
c010a9cb:	c7 44 24 08 36 e0 10 	movl   $0xc010e036,0x8(%esp)
c010a9d2:	c0 
c010a9d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a9d7:	c7 04 24 40 e0 10 c0 	movl   $0xc010e040,(%esp)
c010a9de:	e8 70 59 ff ff       	call   c0100353 <cprintf>
c010a9e3:	b8 e2 78 00 00       	mov    $0x78e2,%eax
c010a9e8:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a9ec:	c7 44 24 04 79 f8 15 	movl   $0xc015f879,0x4(%esp)
c010a9f3:	c0 
c010a9f4:	c7 04 24 36 e0 10 c0 	movl   $0xc010e036,(%esp)
c010a9fb:	e8 83 ff ff ff       	call   c010a983 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010aa00:	c7 44 24 08 67 e0 10 	movl   $0xc010e067,0x8(%esp)
c010aa07:	c0 
c010aa08:	c7 44 24 04 3b 03 00 	movl   $0x33b,0x4(%esp)
c010aa0f:	00 
c010aa10:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010aa17:	e8 b9 63 ff ff       	call   c0100dd5 <__panic>

c010aa1c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010aa1c:	55                   	push   %ebp
c010aa1d:	89 e5                	mov    %esp,%ebp
c010aa1f:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010aa22:	e8 aa a6 ff ff       	call   c01050d1 <nr_free_pages>
c010aa27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010aa2a:	e8 73 a0 ff ff       	call   c0104aa2 <kallocated>
c010aa2f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010aa32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010aa39:	00 
c010aa3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010aa41:	00 
c010aa42:	c7 04 24 bd a9 10 c0 	movl   $0xc010a9bd,(%esp)
c010aa49:	e8 0b ef ff ff       	call   c0109959 <kernel_thread>
c010aa4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010aa51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010aa55:	7f 1c                	jg     c010aa73 <init_main+0x57>
        panic("create user_main failed.\n");
c010aa57:	c7 44 24 08 81 e0 10 	movl   $0xc010e081,0x8(%esp)
c010aa5e:	c0 
c010aa5f:	c7 44 24 04 46 03 00 	movl   $0x346,0x4(%esp)
c010aa66:	00 
c010aa67:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010aa6e:	e8 62 63 ff ff       	call   c0100dd5 <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010aa73:	eb 05                	jmp    c010aa7a <init_main+0x5e>
        schedule();
c010aa75:	e8 fa 03 00 00       	call   c010ae74 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010aa7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010aa81:	00 
c010aa82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010aa89:	e8 ff fc ff ff       	call   c010a78d <do_wait>
c010aa8e:	85 c0                	test   %eax,%eax
c010aa90:	74 e3                	je     c010aa75 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010aa92:	c7 04 24 9c e0 10 c0 	movl   $0xc010e09c,(%esp)
c010aa99:	e8 b5 58 ff ff       	call   c0100353 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010aa9e:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aaa3:	8b 40 70             	mov    0x70(%eax),%eax
c010aaa6:	85 c0                	test   %eax,%eax
c010aaa8:	75 18                	jne    c010aac2 <init_main+0xa6>
c010aaaa:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aaaf:	8b 40 74             	mov    0x74(%eax),%eax
c010aab2:	85 c0                	test   %eax,%eax
c010aab4:	75 0c                	jne    c010aac2 <init_main+0xa6>
c010aab6:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aabb:	8b 40 78             	mov    0x78(%eax),%eax
c010aabe:	85 c0                	test   %eax,%eax
c010aac0:	74 24                	je     c010aae6 <init_main+0xca>
c010aac2:	c7 44 24 0c c0 e0 10 	movl   $0xc010e0c0,0xc(%esp)
c010aac9:	c0 
c010aaca:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010aad1:	c0 
c010aad2:	c7 44 24 04 4e 03 00 	movl   $0x34e,0x4(%esp)
c010aad9:	00 
c010aada:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010aae1:	e8 ef 62 ff ff       	call   c0100dd5 <__panic>
    assert(nr_process == 2);
c010aae6:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010aaeb:	83 f8 02             	cmp    $0x2,%eax
c010aaee:	74 24                	je     c010ab14 <init_main+0xf8>
c010aaf0:	c7 44 24 0c 0b e1 10 	movl   $0xc010e10b,0xc(%esp)
c010aaf7:	c0 
c010aaf8:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010aaff:	c0 
c010ab00:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
c010ab07:	00 
c010ab08:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ab0f:	e8 c1 62 ff ff       	call   c0100dd5 <__panic>
c010ab14:	c7 45 e8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x18(%ebp)
c010ab1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ab1e:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010ab21:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010ab27:	83 c2 58             	add    $0x58,%edx
c010ab2a:	39 d0                	cmp    %edx,%eax
c010ab2c:	74 24                	je     c010ab52 <init_main+0x136>
c010ab2e:	c7 44 24 0c 1c e1 10 	movl   $0xc010e11c,0xc(%esp)
c010ab35:	c0 
c010ab36:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010ab3d:	c0 
c010ab3e:	c7 44 24 04 50 03 00 	movl   $0x350,0x4(%esp)
c010ab45:	00 
c010ab46:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ab4d:	e8 83 62 ff ff       	call   c0100dd5 <__panic>
c010ab52:	c7 45 e4 b0 f0 19 c0 	movl   $0xc019f0b0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010ab59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ab5c:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010ab5e:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010ab64:	83 c2 58             	add    $0x58,%edx
c010ab67:	39 d0                	cmp    %edx,%eax
c010ab69:	74 24                	je     c010ab8f <init_main+0x173>
c010ab6b:	c7 44 24 0c 4c e1 10 	movl   $0xc010e14c,0xc(%esp)
c010ab72:	c0 
c010ab73:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010ab7a:	c0 
c010ab7b:	c7 44 24 04 51 03 00 	movl   $0x351,0x4(%esp)
c010ab82:	00 
c010ab83:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ab8a:	e8 46 62 ff ff       	call   c0100dd5 <__panic>

    cprintf("init check memory pass.\n");
c010ab8f:	c7 04 24 7c e1 10 c0 	movl   $0xc010e17c,(%esp)
c010ab96:	e8 b8 57 ff ff       	call   c0100353 <cprintf>
    return 0;
c010ab9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010aba0:	c9                   	leave  
c010aba1:	c3                   	ret    

c010aba2 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010aba2:	55                   	push   %ebp
c010aba3:	89 e5                	mov    %esp,%ebp
c010aba5:	83 ec 28             	sub    $0x28,%esp
c010aba8:	c7 45 ec b0 f0 19 c0 	movl   $0xc019f0b0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010abaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010abb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010abb5:	89 50 04             	mov    %edx,0x4(%eax)
c010abb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010abbb:	8b 50 04             	mov    0x4(%eax),%edx
c010abbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010abc1:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010abc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010abca:	eb 26                	jmp    c010abf2 <proc_init+0x50>
        list_init(hash_list + i);
c010abcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010abcf:	c1 e0 03             	shl    $0x3,%eax
c010abd2:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c010abd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010abda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010abe0:	89 50 04             	mov    %edx,0x4(%eax)
c010abe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abe6:	8b 50 04             	mov    0x4(%eax),%edx
c010abe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abec:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010abee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010abf2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010abf9:	7e d1                	jle    c010abcc <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010abfb:	e8 15 e8 ff ff       	call   c0109415 <alloc_proc>
c010ac00:	a3 80 cf 19 c0       	mov    %eax,0xc019cf80
c010ac05:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac0a:	85 c0                	test   %eax,%eax
c010ac0c:	75 1c                	jne    c010ac2a <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010ac0e:	c7 44 24 08 95 e1 10 	movl   $0xc010e195,0x8(%esp)
c010ac15:	c0 
c010ac16:	c7 44 24 04 63 03 00 	movl   $0x363,0x4(%esp)
c010ac1d:	00 
c010ac1e:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ac25:	e8 ab 61 ff ff       	call   c0100dd5 <__panic>
    }

    idleproc->pid = 0;
c010ac2a:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010ac36:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac3b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010ac41:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac46:	ba 00 80 12 c0       	mov    $0xc0128000,%edx
c010ac4b:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010ac4e:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac53:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010ac5a:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac5f:	c7 44 24 04 ad e1 10 	movl   $0xc010e1ad,0x4(%esp)
c010ac66:	c0 
c010ac67:	89 04 24             	mov    %eax,(%esp)
c010ac6a:	e8 97 e8 ff ff       	call   c0109506 <set_proc_name>
    nr_process ++;
c010ac6f:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010ac74:	83 c0 01             	add    $0x1,%eax
c010ac77:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0

    current = idleproc;
c010ac7c:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac81:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88

    int pid = kernel_thread(init_main, NULL, 0);
c010ac86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010ac8d:	00 
c010ac8e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac95:	00 
c010ac96:	c7 04 24 1c aa 10 c0 	movl   $0xc010aa1c,(%esp)
c010ac9d:	e8 b7 ec ff ff       	call   c0109959 <kernel_thread>
c010aca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010aca5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aca9:	7f 1c                	jg     c010acc7 <proc_init+0x125>
        panic("create init_main failed.\n");
c010acab:	c7 44 24 08 b2 e1 10 	movl   $0xc010e1b2,0x8(%esp)
c010acb2:	c0 
c010acb3:	c7 44 24 04 71 03 00 	movl   $0x371,0x4(%esp)
c010acba:	00 
c010acbb:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010acc2:	e8 0e 61 ff ff       	call   c0100dd5 <__panic>
    }

    initproc = find_proc(pid);
c010acc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010acca:	89 04 24             	mov    %eax,(%esp)
c010accd:	e8 15 ec ff ff       	call   c01098e7 <find_proc>
c010acd2:	a3 84 cf 19 c0       	mov    %eax,0xc019cf84
    set_proc_name(initproc, "init");
c010acd7:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010acdc:	c7 44 24 04 cc e1 10 	movl   $0xc010e1cc,0x4(%esp)
c010ace3:	c0 
c010ace4:	89 04 24             	mov    %eax,(%esp)
c010ace7:	e8 1a e8 ff ff       	call   c0109506 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010acec:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010acf1:	85 c0                	test   %eax,%eax
c010acf3:	74 0c                	je     c010ad01 <proc_init+0x15f>
c010acf5:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010acfa:	8b 40 04             	mov    0x4(%eax),%eax
c010acfd:	85 c0                	test   %eax,%eax
c010acff:	74 24                	je     c010ad25 <proc_init+0x183>
c010ad01:	c7 44 24 0c d4 e1 10 	movl   $0xc010e1d4,0xc(%esp)
c010ad08:	c0 
c010ad09:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010ad10:	c0 
c010ad11:	c7 44 24 04 77 03 00 	movl   $0x377,0x4(%esp)
c010ad18:	00 
c010ad19:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ad20:	e8 b0 60 ff ff       	call   c0100dd5 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010ad25:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ad2a:	85 c0                	test   %eax,%eax
c010ad2c:	74 0d                	je     c010ad3b <proc_init+0x199>
c010ad2e:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ad33:	8b 40 04             	mov    0x4(%eax),%eax
c010ad36:	83 f8 01             	cmp    $0x1,%eax
c010ad39:	74 24                	je     c010ad5f <proc_init+0x1bd>
c010ad3b:	c7 44 24 0c fc e1 10 	movl   $0xc010e1fc,0xc(%esp)
c010ad42:	c0 
c010ad43:	c7 44 24 08 3d de 10 	movl   $0xc010de3d,0x8(%esp)
c010ad4a:	c0 
c010ad4b:	c7 44 24 04 78 03 00 	movl   $0x378,0x4(%esp)
c010ad52:	00 
c010ad53:	c7 04 24 10 de 10 c0 	movl   $0xc010de10,(%esp)
c010ad5a:	e8 76 60 ff ff       	call   c0100dd5 <__panic>
}
c010ad5f:	c9                   	leave  
c010ad60:	c3                   	ret    

c010ad61 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010ad61:	55                   	push   %ebp
c010ad62:	89 e5                	mov    %esp,%ebp
c010ad64:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010ad67:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ad6c:	8b 40 10             	mov    0x10(%eax),%eax
c010ad6f:	85 c0                	test   %eax,%eax
c010ad71:	74 07                	je     c010ad7a <cpu_idle+0x19>
            schedule();
c010ad73:	e8 fc 00 00 00       	call   c010ae74 <schedule>
        }
    }
c010ad78:	eb ed                	jmp    c010ad67 <cpu_idle+0x6>
c010ad7a:	eb eb                	jmp    c010ad67 <cpu_idle+0x6>

c010ad7c <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010ad7c:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010ad80:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010ad82:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010ad85:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010ad88:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010ad8b:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010ad8e:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010ad91:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010ad94:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010ad97:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010ad9b:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010ad9e:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010ada1:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010ada4:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010ada7:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010adaa:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010adad:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010adb0:	ff 30                	pushl  (%eax)

    ret
c010adb2:	c3                   	ret    

c010adb3 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010adb3:	55                   	push   %ebp
c010adb4:	89 e5                	mov    %esp,%ebp
c010adb6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010adb9:	9c                   	pushf  
c010adba:	58                   	pop    %eax
c010adbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010adbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010adc1:	25 00 02 00 00       	and    $0x200,%eax
c010adc6:	85 c0                	test   %eax,%eax
c010adc8:	74 0c                	je     c010add6 <__intr_save+0x23>
        intr_disable();
c010adca:	e8 5e 72 ff ff       	call   c010202d <intr_disable>
        return 1;
c010adcf:	b8 01 00 00 00       	mov    $0x1,%eax
c010add4:	eb 05                	jmp    c010addb <__intr_save+0x28>
    }
    return 0;
c010add6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010addb:	c9                   	leave  
c010addc:	c3                   	ret    

c010addd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010addd:	55                   	push   %ebp
c010adde:	89 e5                	mov    %esp,%ebp
c010ade0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010ade3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010ade7:	74 05                	je     c010adee <__intr_restore+0x11>
        intr_enable();
c010ade9:	e8 39 72 ff ff       	call   c0102027 <intr_enable>
    }
}
c010adee:	c9                   	leave  
c010adef:	c3                   	ret    

c010adf0 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010adf0:	55                   	push   %ebp
c010adf1:	89 e5                	mov    %esp,%ebp
c010adf3:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010adf6:	8b 45 08             	mov    0x8(%ebp),%eax
c010adf9:	8b 00                	mov    (%eax),%eax
c010adfb:	83 f8 03             	cmp    $0x3,%eax
c010adfe:	75 24                	jne    c010ae24 <wakeup_proc+0x34>
c010ae00:	c7 44 24 0c 23 e2 10 	movl   $0xc010e223,0xc(%esp)
c010ae07:	c0 
c010ae08:	c7 44 24 08 3e e2 10 	movl   $0xc010e23e,0x8(%esp)
c010ae0f:	c0 
c010ae10:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010ae17:	00 
c010ae18:	c7 04 24 53 e2 10 c0 	movl   $0xc010e253,(%esp)
c010ae1f:	e8 b1 5f ff ff       	call   c0100dd5 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010ae24:	e8 8a ff ff ff       	call   c010adb3 <__intr_save>
c010ae29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010ae2c:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae2f:	8b 00                	mov    (%eax),%eax
c010ae31:	83 f8 02             	cmp    $0x2,%eax
c010ae34:	74 15                	je     c010ae4b <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010ae36:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae39:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010ae3f:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae42:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010ae49:	eb 1c                	jmp    c010ae67 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010ae4b:	c7 44 24 08 69 e2 10 	movl   $0xc010e269,0x8(%esp)
c010ae52:	c0 
c010ae53:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010ae5a:	00 
c010ae5b:	c7 04 24 53 e2 10 c0 	movl   $0xc010e253,(%esp)
c010ae62:	e8 da 5f ff ff       	call   c0100e41 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010ae67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae6a:	89 04 24             	mov    %eax,(%esp)
c010ae6d:	e8 6b ff ff ff       	call   c010addd <__intr_restore>
}
c010ae72:	c9                   	leave  
c010ae73:	c3                   	ret    

c010ae74 <schedule>:

void
schedule(void) {
c010ae74:	55                   	push   %ebp
c010ae75:	89 e5                	mov    %esp,%ebp
c010ae77:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010ae7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010ae81:	e8 2d ff ff ff       	call   c010adb3 <__intr_save>
c010ae86:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010ae89:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ae8e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010ae95:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010ae9b:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aea0:	39 c2                	cmp    %eax,%edx
c010aea2:	74 0a                	je     c010aeae <schedule+0x3a>
c010aea4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aea9:	83 c0 58             	add    $0x58,%eax
c010aeac:	eb 05                	jmp    c010aeb3 <schedule+0x3f>
c010aeae:	b8 b0 f0 19 c0       	mov    $0xc019f0b0,%eax
c010aeb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010aeb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010aeb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010aec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010aec5:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010aec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aecb:	81 7d f4 b0 f0 19 c0 	cmpl   $0xc019f0b0,-0xc(%ebp)
c010aed2:	74 15                	je     c010aee9 <schedule+0x75>
                next = le2proc(le, list_link);
c010aed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aed7:	83 e8 58             	sub    $0x58,%eax
c010aeda:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010aedd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aee0:	8b 00                	mov    (%eax),%eax
c010aee2:	83 f8 02             	cmp    $0x2,%eax
c010aee5:	75 02                	jne    c010aee9 <schedule+0x75>
                    break;
c010aee7:	eb 08                	jmp    c010aef1 <schedule+0x7d>
                }
            }
        } while (le != last);
c010aee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aeec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010aeef:	75 cb                	jne    c010aebc <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010aef1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aef5:	74 0a                	je     c010af01 <schedule+0x8d>
c010aef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aefa:	8b 00                	mov    (%eax),%eax
c010aefc:	83 f8 02             	cmp    $0x2,%eax
c010aeff:	74 08                	je     c010af09 <schedule+0x95>
            next = idleproc;
c010af01:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010af06:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010af09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af0c:	8b 40 08             	mov    0x8(%eax),%eax
c010af0f:	8d 50 01             	lea    0x1(%eax),%edx
c010af12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af15:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010af18:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010af1d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010af20:	74 0b                	je     c010af2d <schedule+0xb9>
            proc_run(next);
c010af22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af25:	89 04 24             	mov    %eax,(%esp)
c010af28:	e8 7e e8 ff ff       	call   c01097ab <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010af2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010af30:	89 04 24             	mov    %eax,(%esp)
c010af33:	e8 a5 fe ff ff       	call   c010addd <__intr_restore>
}
c010af38:	c9                   	leave  
c010af39:	c3                   	ret    

c010af3a <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010af3a:	55                   	push   %ebp
c010af3b:	89 e5                	mov    %esp,%ebp
c010af3d:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010af40:	8b 45 08             	mov    0x8(%ebp),%eax
c010af43:	8b 00                	mov    (%eax),%eax
c010af45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010af48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af4b:	89 04 24             	mov    %eax,(%esp)
c010af4e:	e8 bc ee ff ff       	call   c0109e0f <do_exit>
}
c010af53:	c9                   	leave  
c010af54:	c3                   	ret    

c010af55 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010af55:	55                   	push   %ebp
c010af56:	89 e5                	mov    %esp,%ebp
c010af58:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010af5b:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010af60:	8b 40 3c             	mov    0x3c(%eax),%eax
c010af63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010af66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af69:	8b 40 44             	mov    0x44(%eax),%eax
c010af6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010af6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af72:	89 44 24 08          	mov    %eax,0x8(%esp)
c010af76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af79:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010af84:	e8 65 ed ff ff       	call   c0109cee <do_fork>
}
c010af89:	c9                   	leave  
c010af8a:	c3                   	ret    

c010af8b <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010af8b:	55                   	push   %ebp
c010af8c:	89 e5                	mov    %esp,%ebp
c010af8e:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010af91:	8b 45 08             	mov    0x8(%ebp),%eax
c010af94:	8b 00                	mov    (%eax),%eax
c010af96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010af99:	8b 45 08             	mov    0x8(%ebp),%eax
c010af9c:	83 c0 04             	add    $0x4,%eax
c010af9f:	8b 00                	mov    (%eax),%eax
c010afa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010afa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010afa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c010afab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010afae:	89 04 24             	mov    %eax,(%esp)
c010afb1:	e8 d7 f7 ff ff       	call   c010a78d <do_wait>
}
c010afb6:	c9                   	leave  
c010afb7:	c3                   	ret    

c010afb8 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010afb8:	55                   	push   %ebp
c010afb9:	89 e5                	mov    %esp,%ebp
c010afbb:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010afbe:	8b 45 08             	mov    0x8(%ebp),%eax
c010afc1:	8b 00                	mov    (%eax),%eax
c010afc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010afc6:	8b 45 08             	mov    0x8(%ebp),%eax
c010afc9:	8b 40 04             	mov    0x4(%eax),%eax
c010afcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010afcf:	8b 45 08             	mov    0x8(%ebp),%eax
c010afd2:	83 c0 08             	add    $0x8,%eax
c010afd5:	8b 00                	mov    (%eax),%eax
c010afd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010afda:	8b 45 08             	mov    0x8(%ebp),%eax
c010afdd:	8b 40 0c             	mov    0xc(%eax),%eax
c010afe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010afe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010afe6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010afea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010afed:	89 44 24 08          	mov    %eax,0x8(%esp)
c010aff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aff4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010aff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010affb:	89 04 24             	mov    %eax,(%esp)
c010affe:	e8 3e f6 ff ff       	call   c010a641 <do_execve>
}
c010b003:	c9                   	leave  
c010b004:	c3                   	ret    

c010b005 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010b005:	55                   	push   %ebp
c010b006:	89 e5                	mov    %esp,%ebp
c010b008:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010b00b:	e8 67 f7 ff ff       	call   c010a777 <do_yield>
}
c010b010:	c9                   	leave  
c010b011:	c3                   	ret    

c010b012 <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010b012:	55                   	push   %ebp
c010b013:	89 e5                	mov    %esp,%ebp
c010b015:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b018:	8b 45 08             	mov    0x8(%ebp),%eax
c010b01b:	8b 00                	mov    (%eax),%eax
c010b01d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010b020:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b023:	89 04 24             	mov    %eax,(%esp)
c010b026:	e8 f6 f8 ff ff       	call   c010a921 <do_kill>
}
c010b02b:	c9                   	leave  
c010b02c:	c3                   	ret    

c010b02d <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010b02d:	55                   	push   %ebp
c010b02e:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010b030:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b035:	8b 40 04             	mov    0x4(%eax),%eax
}
c010b038:	5d                   	pop    %ebp
c010b039:	c3                   	ret    

c010b03a <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010b03a:	55                   	push   %ebp
c010b03b:	89 e5                	mov    %esp,%ebp
c010b03d:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010b040:	8b 45 08             	mov    0x8(%ebp),%eax
c010b043:	8b 00                	mov    (%eax),%eax
c010b045:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010b048:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b04b:	89 04 24             	mov    %eax,(%esp)
c010b04e:	e8 26 53 ff ff       	call   c0100379 <cputchar>
    return 0;
c010b053:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b058:	c9                   	leave  
c010b059:	c3                   	ret    

c010b05a <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010b05a:	55                   	push   %ebp
c010b05b:	89 e5                	mov    %esp,%ebp
c010b05d:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010b060:	e8 ba ba ff ff       	call   c0106b1f <print_pgdir>
    return 0;
c010b065:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b06a:	c9                   	leave  
c010b06b:	c3                   	ret    

c010b06c <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010b06c:	55                   	push   %ebp
c010b06d:	89 e5                	mov    %esp,%ebp
c010b06f:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010b072:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b077:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b07a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010b07d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b080:	8b 40 1c             	mov    0x1c(%eax),%eax
c010b083:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010b086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b08a:	78 5e                	js     c010b0ea <syscall+0x7e>
c010b08c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b08f:	83 f8 1f             	cmp    $0x1f,%eax
c010b092:	77 56                	ja     c010b0ea <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010b094:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b097:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b09e:	85 c0                	test   %eax,%eax
c010b0a0:	74 48                	je     c010b0ea <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010b0a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0a5:	8b 40 14             	mov    0x14(%eax),%eax
c010b0a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010b0ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0ae:	8b 40 18             	mov    0x18(%eax),%eax
c010b0b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b0b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0b7:	8b 40 10             	mov    0x10(%eax),%eax
c010b0ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b0bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0c0:	8b 00                	mov    (%eax),%eax
c010b0c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b0c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0c8:	8b 40 04             	mov    0x4(%eax),%eax
c010b0cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b0ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0d1:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b0d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010b0db:	89 14 24             	mov    %edx,(%esp)
c010b0de:	ff d0                	call   *%eax
c010b0e0:	89 c2                	mov    %eax,%edx
c010b0e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0e5:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010b0e8:	eb 46                	jmp    c010b130 <syscall+0xc4>
        }
    }
    print_trapframe(tf);
c010b0ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0ed:	89 04 24             	mov    %eax,(%esp)
c010b0f0:	e8 f6 72 ff ff       	call   c01023eb <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b0f5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b0fa:	8d 50 48             	lea    0x48(%eax),%edx
c010b0fd:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b102:	8b 40 04             	mov    0x4(%eax),%eax
c010b105:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b109:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b10d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b110:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b114:	c7 44 24 08 84 e2 10 	movl   $0xc010e284,0x8(%esp)
c010b11b:	c0 
c010b11c:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010b123:	00 
c010b124:	c7 04 24 b0 e2 10 c0 	movl   $0xc010e2b0,(%esp)
c010b12b:	e8 a5 5c ff ff       	call   c0100dd5 <__panic>
            num, current->pid, current->name);
}
c010b130:	c9                   	leave  
c010b131:	c3                   	ret    

c010b132 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b132:	55                   	push   %ebp
c010b133:	89 e5                	mov    %esp,%ebp
c010b135:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b138:	8b 45 08             	mov    0x8(%ebp),%eax
c010b13b:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b141:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010b144:	b8 20 00 00 00       	mov    $0x20,%eax
c010b149:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b14c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010b14f:	89 c1                	mov    %eax,%ecx
c010b151:	d3 ea                	shr    %cl,%edx
c010b153:	89 d0                	mov    %edx,%eax
}
c010b155:	c9                   	leave  
c010b156:	c3                   	ret    

c010b157 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b157:	55                   	push   %ebp
c010b158:	89 e5                	mov    %esp,%ebp
c010b15a:	83 ec 58             	sub    $0x58,%esp
c010b15d:	8b 45 10             	mov    0x10(%ebp),%eax
c010b160:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b163:	8b 45 14             	mov    0x14(%ebp),%eax
c010b166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b169:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b16c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b16f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b172:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b175:	8b 45 18             	mov    0x18(%ebp),%eax
c010b178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b17b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b17e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b181:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b184:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010b187:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b18a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b18d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b191:	74 1c                	je     c010b1af <printnum+0x58>
c010b193:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b196:	ba 00 00 00 00       	mov    $0x0,%edx
c010b19b:	f7 75 e4             	divl   -0x1c(%ebp)
c010b19e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b1a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b1a4:	ba 00 00 00 00       	mov    $0x0,%edx
c010b1a9:	f7 75 e4             	divl   -0x1c(%ebp)
c010b1ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b1af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b1b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b1b5:	f7 75 e4             	divl   -0x1c(%ebp)
c010b1b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b1bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010b1be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b1c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b1c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b1c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b1cd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b1d0:	8b 45 18             	mov    0x18(%ebp),%eax
c010b1d3:	ba 00 00 00 00       	mov    $0x0,%edx
c010b1d8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b1db:	77 56                	ja     c010b233 <printnum+0xdc>
c010b1dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b1e0:	72 05                	jb     c010b1e7 <printnum+0x90>
c010b1e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b1e5:	77 4c                	ja     c010b233 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b1e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b1ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b1ed:	8b 45 20             	mov    0x20(%ebp),%eax
c010b1f0:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b1f4:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b1f8:	8b 45 18             	mov    0x18(%ebp),%eax
c010b1fb:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b1ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b202:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b205:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b209:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b20d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b210:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b214:	8b 45 08             	mov    0x8(%ebp),%eax
c010b217:	89 04 24             	mov    %eax,(%esp)
c010b21a:	e8 38 ff ff ff       	call   c010b157 <printnum>
c010b21f:	eb 1c                	jmp    c010b23d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b221:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b224:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b228:	8b 45 20             	mov    0x20(%ebp),%eax
c010b22b:	89 04 24             	mov    %eax,(%esp)
c010b22e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b231:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b233:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b237:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b23b:	7f e4                	jg     c010b221 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b23d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b240:	05 e4 e3 10 c0       	add    $0xc010e3e4,%eax
c010b245:	0f b6 00             	movzbl (%eax),%eax
c010b248:	0f be c0             	movsbl %al,%eax
c010b24b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b24e:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b252:	89 04 24             	mov    %eax,(%esp)
c010b255:	8b 45 08             	mov    0x8(%ebp),%eax
c010b258:	ff d0                	call   *%eax
}
c010b25a:	c9                   	leave  
c010b25b:	c3                   	ret    

c010b25c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b25c:	55                   	push   %ebp
c010b25d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b25f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b263:	7e 14                	jle    c010b279 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b265:	8b 45 08             	mov    0x8(%ebp),%eax
c010b268:	8b 00                	mov    (%eax),%eax
c010b26a:	8d 48 08             	lea    0x8(%eax),%ecx
c010b26d:	8b 55 08             	mov    0x8(%ebp),%edx
c010b270:	89 0a                	mov    %ecx,(%edx)
c010b272:	8b 50 04             	mov    0x4(%eax),%edx
c010b275:	8b 00                	mov    (%eax),%eax
c010b277:	eb 30                	jmp    c010b2a9 <getuint+0x4d>
    }
    else if (lflag) {
c010b279:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b27d:	74 16                	je     c010b295 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b27f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b282:	8b 00                	mov    (%eax),%eax
c010b284:	8d 48 04             	lea    0x4(%eax),%ecx
c010b287:	8b 55 08             	mov    0x8(%ebp),%edx
c010b28a:	89 0a                	mov    %ecx,(%edx)
c010b28c:	8b 00                	mov    (%eax),%eax
c010b28e:	ba 00 00 00 00       	mov    $0x0,%edx
c010b293:	eb 14                	jmp    c010b2a9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b295:	8b 45 08             	mov    0x8(%ebp),%eax
c010b298:	8b 00                	mov    (%eax),%eax
c010b29a:	8d 48 04             	lea    0x4(%eax),%ecx
c010b29d:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2a0:	89 0a                	mov    %ecx,(%edx)
c010b2a2:	8b 00                	mov    (%eax),%eax
c010b2a4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b2a9:	5d                   	pop    %ebp
c010b2aa:	c3                   	ret    

c010b2ab <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b2ab:	55                   	push   %ebp
c010b2ac:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b2ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b2b2:	7e 14                	jle    c010b2c8 <getint+0x1d>
        return va_arg(*ap, long long);
c010b2b4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2b7:	8b 00                	mov    (%eax),%eax
c010b2b9:	8d 48 08             	lea    0x8(%eax),%ecx
c010b2bc:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2bf:	89 0a                	mov    %ecx,(%edx)
c010b2c1:	8b 50 04             	mov    0x4(%eax),%edx
c010b2c4:	8b 00                	mov    (%eax),%eax
c010b2c6:	eb 28                	jmp    c010b2f0 <getint+0x45>
    }
    else if (lflag) {
c010b2c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b2cc:	74 12                	je     c010b2e0 <getint+0x35>
        return va_arg(*ap, long);
c010b2ce:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2d1:	8b 00                	mov    (%eax),%eax
c010b2d3:	8d 48 04             	lea    0x4(%eax),%ecx
c010b2d6:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2d9:	89 0a                	mov    %ecx,(%edx)
c010b2db:	8b 00                	mov    (%eax),%eax
c010b2dd:	99                   	cltd   
c010b2de:	eb 10                	jmp    c010b2f0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b2e0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2e3:	8b 00                	mov    (%eax),%eax
c010b2e5:	8d 48 04             	lea    0x4(%eax),%ecx
c010b2e8:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2eb:	89 0a                	mov    %ecx,(%edx)
c010b2ed:	8b 00                	mov    (%eax),%eax
c010b2ef:	99                   	cltd   
    }
}
c010b2f0:	5d                   	pop    %ebp
c010b2f1:	c3                   	ret    

c010b2f2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b2f2:	55                   	push   %ebp
c010b2f3:	89 e5                	mov    %esp,%ebp
c010b2f5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b2f8:	8d 45 14             	lea    0x14(%ebp),%eax
c010b2fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b2fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b301:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b305:	8b 45 10             	mov    0x10(%ebp),%eax
c010b308:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b30c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b30f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b313:	8b 45 08             	mov    0x8(%ebp),%eax
c010b316:	89 04 24             	mov    %eax,(%esp)
c010b319:	e8 02 00 00 00       	call   c010b320 <vprintfmt>
    va_end(ap);
}
c010b31e:	c9                   	leave  
c010b31f:	c3                   	ret    

c010b320 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b320:	55                   	push   %ebp
c010b321:	89 e5                	mov    %esp,%ebp
c010b323:	56                   	push   %esi
c010b324:	53                   	push   %ebx
c010b325:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b328:	eb 18                	jmp    c010b342 <vprintfmt+0x22>
            if (ch == '\0') {
c010b32a:	85 db                	test   %ebx,%ebx
c010b32c:	75 05                	jne    c010b333 <vprintfmt+0x13>
                return;
c010b32e:	e9 d1 03 00 00       	jmp    c010b704 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b333:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b33a:	89 1c 24             	mov    %ebx,(%esp)
c010b33d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b340:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b342:	8b 45 10             	mov    0x10(%ebp),%eax
c010b345:	8d 50 01             	lea    0x1(%eax),%edx
c010b348:	89 55 10             	mov    %edx,0x10(%ebp)
c010b34b:	0f b6 00             	movzbl (%eax),%eax
c010b34e:	0f b6 d8             	movzbl %al,%ebx
c010b351:	83 fb 25             	cmp    $0x25,%ebx
c010b354:	75 d4                	jne    c010b32a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b356:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b35a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b364:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b367:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b36e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b371:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b374:	8b 45 10             	mov    0x10(%ebp),%eax
c010b377:	8d 50 01             	lea    0x1(%eax),%edx
c010b37a:	89 55 10             	mov    %edx,0x10(%ebp)
c010b37d:	0f b6 00             	movzbl (%eax),%eax
c010b380:	0f b6 d8             	movzbl %al,%ebx
c010b383:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b386:	83 f8 55             	cmp    $0x55,%eax
c010b389:	0f 87 44 03 00 00    	ja     c010b6d3 <vprintfmt+0x3b3>
c010b38f:	8b 04 85 08 e4 10 c0 	mov    -0x3fef1bf8(,%eax,4),%eax
c010b396:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b398:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b39c:	eb d6                	jmp    c010b374 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b39e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b3a2:	eb d0                	jmp    c010b374 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b3a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b3ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b3ae:	89 d0                	mov    %edx,%eax
c010b3b0:	c1 e0 02             	shl    $0x2,%eax
c010b3b3:	01 d0                	add    %edx,%eax
c010b3b5:	01 c0                	add    %eax,%eax
c010b3b7:	01 d8                	add    %ebx,%eax
c010b3b9:	83 e8 30             	sub    $0x30,%eax
c010b3bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b3bf:	8b 45 10             	mov    0x10(%ebp),%eax
c010b3c2:	0f b6 00             	movzbl (%eax),%eax
c010b3c5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b3c8:	83 fb 2f             	cmp    $0x2f,%ebx
c010b3cb:	7e 0b                	jle    c010b3d8 <vprintfmt+0xb8>
c010b3cd:	83 fb 39             	cmp    $0x39,%ebx
c010b3d0:	7f 06                	jg     c010b3d8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b3d2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b3d6:	eb d3                	jmp    c010b3ab <vprintfmt+0x8b>
            goto process_precision;
c010b3d8:	eb 33                	jmp    c010b40d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b3da:	8b 45 14             	mov    0x14(%ebp),%eax
c010b3dd:	8d 50 04             	lea    0x4(%eax),%edx
c010b3e0:	89 55 14             	mov    %edx,0x14(%ebp)
c010b3e3:	8b 00                	mov    (%eax),%eax
c010b3e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b3e8:	eb 23                	jmp    c010b40d <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b3ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b3ee:	79 0c                	jns    c010b3fc <vprintfmt+0xdc>
                width = 0;
c010b3f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b3f7:	e9 78 ff ff ff       	jmp    c010b374 <vprintfmt+0x54>
c010b3fc:	e9 73 ff ff ff       	jmp    c010b374 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b401:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b408:	e9 67 ff ff ff       	jmp    c010b374 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b40d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b411:	79 12                	jns    c010b425 <vprintfmt+0x105>
                width = precision, precision = -1;
c010b413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b416:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b419:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b420:	e9 4f ff ff ff       	jmp    c010b374 <vprintfmt+0x54>
c010b425:	e9 4a ff ff ff       	jmp    c010b374 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b42a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b42e:	e9 41 ff ff ff       	jmp    c010b374 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b433:	8b 45 14             	mov    0x14(%ebp),%eax
c010b436:	8d 50 04             	lea    0x4(%eax),%edx
c010b439:	89 55 14             	mov    %edx,0x14(%ebp)
c010b43c:	8b 00                	mov    (%eax),%eax
c010b43e:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b441:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b445:	89 04 24             	mov    %eax,(%esp)
c010b448:	8b 45 08             	mov    0x8(%ebp),%eax
c010b44b:	ff d0                	call   *%eax
            break;
c010b44d:	e9 ac 02 00 00       	jmp    c010b6fe <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b452:	8b 45 14             	mov    0x14(%ebp),%eax
c010b455:	8d 50 04             	lea    0x4(%eax),%edx
c010b458:	89 55 14             	mov    %edx,0x14(%ebp)
c010b45b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b45d:	85 db                	test   %ebx,%ebx
c010b45f:	79 02                	jns    c010b463 <vprintfmt+0x143>
                err = -err;
c010b461:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b463:	83 fb 18             	cmp    $0x18,%ebx
c010b466:	7f 0b                	jg     c010b473 <vprintfmt+0x153>
c010b468:	8b 34 9d 80 e3 10 c0 	mov    -0x3fef1c80(,%ebx,4),%esi
c010b46f:	85 f6                	test   %esi,%esi
c010b471:	75 23                	jne    c010b496 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b473:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b477:	c7 44 24 08 f5 e3 10 	movl   $0xc010e3f5,0x8(%esp)
c010b47e:	c0 
c010b47f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b482:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b486:	8b 45 08             	mov    0x8(%ebp),%eax
c010b489:	89 04 24             	mov    %eax,(%esp)
c010b48c:	e8 61 fe ff ff       	call   c010b2f2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b491:	e9 68 02 00 00       	jmp    c010b6fe <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b496:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b49a:	c7 44 24 08 fe e3 10 	movl   $0xc010e3fe,0x8(%esp)
c010b4a1:	c0 
c010b4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b4a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4a9:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4ac:	89 04 24             	mov    %eax,(%esp)
c010b4af:	e8 3e fe ff ff       	call   c010b2f2 <printfmt>
            }
            break;
c010b4b4:	e9 45 02 00 00       	jmp    c010b6fe <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b4b9:	8b 45 14             	mov    0x14(%ebp),%eax
c010b4bc:	8d 50 04             	lea    0x4(%eax),%edx
c010b4bf:	89 55 14             	mov    %edx,0x14(%ebp)
c010b4c2:	8b 30                	mov    (%eax),%esi
c010b4c4:	85 f6                	test   %esi,%esi
c010b4c6:	75 05                	jne    c010b4cd <vprintfmt+0x1ad>
                p = "(null)";
c010b4c8:	be 01 e4 10 c0       	mov    $0xc010e401,%esi
            }
            if (width > 0 && padc != '-') {
c010b4cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b4d1:	7e 3e                	jle    c010b511 <vprintfmt+0x1f1>
c010b4d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b4d7:	74 38                	je     c010b511 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b4d9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b4dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b4df:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4e3:	89 34 24             	mov    %esi,(%esp)
c010b4e6:	e8 ed 03 00 00       	call   c010b8d8 <strnlen>
c010b4eb:	29 c3                	sub    %eax,%ebx
c010b4ed:	89 d8                	mov    %ebx,%eax
c010b4ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b4f2:	eb 17                	jmp    c010b50b <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b4f4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b4f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b4fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b4ff:	89 04 24             	mov    %eax,(%esp)
c010b502:	8b 45 08             	mov    0x8(%ebp),%eax
c010b505:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b507:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b50b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b50f:	7f e3                	jg     c010b4f4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b511:	eb 38                	jmp    c010b54b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b513:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b517:	74 1f                	je     c010b538 <vprintfmt+0x218>
c010b519:	83 fb 1f             	cmp    $0x1f,%ebx
c010b51c:	7e 05                	jle    c010b523 <vprintfmt+0x203>
c010b51e:	83 fb 7e             	cmp    $0x7e,%ebx
c010b521:	7e 15                	jle    c010b538 <vprintfmt+0x218>
                    putch('?', putdat);
c010b523:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b526:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b52a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b531:	8b 45 08             	mov    0x8(%ebp),%eax
c010b534:	ff d0                	call   *%eax
c010b536:	eb 0f                	jmp    c010b547 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b53b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b53f:	89 1c 24             	mov    %ebx,(%esp)
c010b542:	8b 45 08             	mov    0x8(%ebp),%eax
c010b545:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b547:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b54b:	89 f0                	mov    %esi,%eax
c010b54d:	8d 70 01             	lea    0x1(%eax),%esi
c010b550:	0f b6 00             	movzbl (%eax),%eax
c010b553:	0f be d8             	movsbl %al,%ebx
c010b556:	85 db                	test   %ebx,%ebx
c010b558:	74 10                	je     c010b56a <vprintfmt+0x24a>
c010b55a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b55e:	78 b3                	js     c010b513 <vprintfmt+0x1f3>
c010b560:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b568:	79 a9                	jns    c010b513 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b56a:	eb 17                	jmp    c010b583 <vprintfmt+0x263>
                putch(' ', putdat);
c010b56c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b56f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b573:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b57a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b57d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b57f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b583:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b587:	7f e3                	jg     c010b56c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b589:	e9 70 01 00 00       	jmp    c010b6fe <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b58e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b591:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b595:	8d 45 14             	lea    0x14(%ebp),%eax
c010b598:	89 04 24             	mov    %eax,(%esp)
c010b59b:	e8 0b fd ff ff       	call   c010b2ab <getint>
c010b5a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b5a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b5a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b5ac:	85 d2                	test   %edx,%edx
c010b5ae:	79 26                	jns    c010b5d6 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b5b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5b7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b5be:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5c1:	ff d0                	call   *%eax
                num = -(long long)num;
c010b5c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b5c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b5c9:	f7 d8                	neg    %eax
c010b5cb:	83 d2 00             	adc    $0x0,%edx
c010b5ce:	f7 da                	neg    %edx
c010b5d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b5d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b5dd:	e9 a8 00 00 00       	jmp    c010b68a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b5e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5e9:	8d 45 14             	lea    0x14(%ebp),%eax
c010b5ec:	89 04 24             	mov    %eax,(%esp)
c010b5ef:	e8 68 fc ff ff       	call   c010b25c <getuint>
c010b5f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b5fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b601:	e9 84 00 00 00       	jmp    c010b68a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b606:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b609:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b60d:	8d 45 14             	lea    0x14(%ebp),%eax
c010b610:	89 04 24             	mov    %eax,(%esp)
c010b613:	e8 44 fc ff ff       	call   c010b25c <getuint>
c010b618:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b61b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b61e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b625:	eb 63                	jmp    c010b68a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b62a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b62e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b635:	8b 45 08             	mov    0x8(%ebp),%eax
c010b638:	ff d0                	call   *%eax
            putch('x', putdat);
c010b63a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b63d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b641:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b648:	8b 45 08             	mov    0x8(%ebp),%eax
c010b64b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b64d:	8b 45 14             	mov    0x14(%ebp),%eax
c010b650:	8d 50 04             	lea    0x4(%eax),%edx
c010b653:	89 55 14             	mov    %edx,0x14(%ebp)
c010b656:	8b 00                	mov    (%eax),%eax
c010b658:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b65b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b662:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b669:	eb 1f                	jmp    c010b68a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b66b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b66e:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b672:	8d 45 14             	lea    0x14(%ebp),%eax
c010b675:	89 04 24             	mov    %eax,(%esp)
c010b678:	e8 df fb ff ff       	call   c010b25c <getuint>
c010b67d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b680:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b683:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b68a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b68e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b691:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b695:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b698:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b69c:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b6a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b6a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b6a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b6aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b6ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6b5:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b8:	89 04 24             	mov    %eax,(%esp)
c010b6bb:	e8 97 fa ff ff       	call   c010b157 <printnum>
            break;
c010b6c0:	eb 3c                	jmp    c010b6fe <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b6c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6c9:	89 1c 24             	mov    %ebx,(%esp)
c010b6cc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6cf:	ff d0                	call   *%eax
            break;
c010b6d1:	eb 2b                	jmp    c010b6fe <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b6d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b6e1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6e4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b6e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b6ea:	eb 04                	jmp    c010b6f0 <vprintfmt+0x3d0>
c010b6ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b6f0:	8b 45 10             	mov    0x10(%ebp),%eax
c010b6f3:	83 e8 01             	sub    $0x1,%eax
c010b6f6:	0f b6 00             	movzbl (%eax),%eax
c010b6f9:	3c 25                	cmp    $0x25,%al
c010b6fb:	75 ef                	jne    c010b6ec <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b6fd:	90                   	nop
        }
    }
c010b6fe:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b6ff:	e9 3e fc ff ff       	jmp    c010b342 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b704:	83 c4 40             	add    $0x40,%esp
c010b707:	5b                   	pop    %ebx
c010b708:	5e                   	pop    %esi
c010b709:	5d                   	pop    %ebp
c010b70a:	c3                   	ret    

c010b70b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b70b:	55                   	push   %ebp
c010b70c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b70e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b711:	8b 40 08             	mov    0x8(%eax),%eax
c010b714:	8d 50 01             	lea    0x1(%eax),%edx
c010b717:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b71a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b71d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b720:	8b 10                	mov    (%eax),%edx
c010b722:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b725:	8b 40 04             	mov    0x4(%eax),%eax
c010b728:	39 c2                	cmp    %eax,%edx
c010b72a:	73 12                	jae    c010b73e <sprintputch+0x33>
        *b->buf ++ = ch;
c010b72c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b72f:	8b 00                	mov    (%eax),%eax
c010b731:	8d 48 01             	lea    0x1(%eax),%ecx
c010b734:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b737:	89 0a                	mov    %ecx,(%edx)
c010b739:	8b 55 08             	mov    0x8(%ebp),%edx
c010b73c:	88 10                	mov    %dl,(%eax)
    }
}
c010b73e:	5d                   	pop    %ebp
c010b73f:	c3                   	ret    

c010b740 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b740:	55                   	push   %ebp
c010b741:	89 e5                	mov    %esp,%ebp
c010b743:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b746:	8d 45 14             	lea    0x14(%ebp),%eax
c010b749:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b74f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b753:	8b 45 10             	mov    0x10(%ebp),%eax
c010b756:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b75a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b75d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b761:	8b 45 08             	mov    0x8(%ebp),%eax
c010b764:	89 04 24             	mov    %eax,(%esp)
c010b767:	e8 08 00 00 00       	call   c010b774 <vsnprintf>
c010b76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b772:	c9                   	leave  
c010b773:	c3                   	ret    

c010b774 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b774:	55                   	push   %ebp
c010b775:	89 e5                	mov    %esp,%ebp
c010b777:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b77a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b77d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b780:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b783:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b786:	8b 45 08             	mov    0x8(%ebp),%eax
c010b789:	01 d0                	add    %edx,%eax
c010b78b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b78e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b795:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b799:	74 0a                	je     c010b7a5 <vsnprintf+0x31>
c010b79b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b7a1:	39 c2                	cmp    %eax,%edx
c010b7a3:	76 07                	jbe    c010b7ac <vsnprintf+0x38>
        return -E_INVAL;
c010b7a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b7aa:	eb 2a                	jmp    c010b7d6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b7ac:	8b 45 14             	mov    0x14(%ebp),%eax
c010b7af:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b7b3:	8b 45 10             	mov    0x10(%ebp),%eax
c010b7b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b7ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b7bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7c1:	c7 04 24 0b b7 10 c0 	movl   $0xc010b70b,(%esp)
c010b7c8:	e8 53 fb ff ff       	call   c010b320 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b7cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b7d0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b7d6:	c9                   	leave  
c010b7d7:	c3                   	ret    

c010b7d8 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b7d8:	55                   	push   %ebp
c010b7d9:	89 e5                	mov    %esp,%ebp
c010b7db:	57                   	push   %edi
c010b7dc:	56                   	push   %esi
c010b7dd:	53                   	push   %ebx
c010b7de:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b7e1:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b7e6:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b7ec:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b7f2:	6b f0 05             	imul   $0x5,%eax,%esi
c010b7f5:	01 f7                	add    %esi,%edi
c010b7f7:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b7fc:	f7 e6                	mul    %esi
c010b7fe:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b801:	89 f2                	mov    %esi,%edx
c010b803:	83 c0 0b             	add    $0xb,%eax
c010b806:	83 d2 00             	adc    $0x0,%edx
c010b809:	89 c7                	mov    %eax,%edi
c010b80b:	83 e7 ff             	and    $0xffffffff,%edi
c010b80e:	89 f9                	mov    %edi,%ecx
c010b810:	0f b7 da             	movzwl %dx,%ebx
c010b813:	89 0d 20 ab 12 c0    	mov    %ecx,0xc012ab20
c010b819:	89 1d 24 ab 12 c0    	mov    %ebx,0xc012ab24
    unsigned long long result = (next >> 12);
c010b81f:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b824:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b82a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010b82e:	c1 ea 0c             	shr    $0xc,%edx
c010b831:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b834:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010b837:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010b83e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b841:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b844:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b847:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b84a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b84d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b850:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b854:	74 1c                	je     c010b872 <rand+0x9a>
c010b856:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b859:	ba 00 00 00 00       	mov    $0x0,%edx
c010b85e:	f7 75 dc             	divl   -0x24(%ebp)
c010b861:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b864:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b867:	ba 00 00 00 00       	mov    $0x0,%edx
c010b86c:	f7 75 dc             	divl   -0x24(%ebp)
c010b86f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b872:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b875:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b878:	f7 75 dc             	divl   -0x24(%ebp)
c010b87b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b87e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b881:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b884:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b887:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b88a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010b88d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010b890:	83 c4 24             	add    $0x24,%esp
c010b893:	5b                   	pop    %ebx
c010b894:	5e                   	pop    %esi
c010b895:	5f                   	pop    %edi
c010b896:	5d                   	pop    %ebp
c010b897:	c3                   	ret    

c010b898 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010b898:	55                   	push   %ebp
c010b899:	89 e5                	mov    %esp,%ebp
    next = seed;
c010b89b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b89e:	ba 00 00 00 00       	mov    $0x0,%edx
c010b8a3:	a3 20 ab 12 c0       	mov    %eax,0xc012ab20
c010b8a8:	89 15 24 ab 12 c0    	mov    %edx,0xc012ab24
}
c010b8ae:	5d                   	pop    %ebp
c010b8af:	c3                   	ret    

c010b8b0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010b8b0:	55                   	push   %ebp
c010b8b1:	89 e5                	mov    %esp,%ebp
c010b8b3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b8b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010b8bd:	eb 04                	jmp    c010b8c3 <strlen+0x13>
        cnt ++;
c010b8bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010b8c3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8c6:	8d 50 01             	lea    0x1(%eax),%edx
c010b8c9:	89 55 08             	mov    %edx,0x8(%ebp)
c010b8cc:	0f b6 00             	movzbl (%eax),%eax
c010b8cf:	84 c0                	test   %al,%al
c010b8d1:	75 ec                	jne    c010b8bf <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010b8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b8d6:	c9                   	leave  
c010b8d7:	c3                   	ret    

c010b8d8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010b8d8:	55                   	push   %ebp
c010b8d9:	89 e5                	mov    %esp,%ebp
c010b8db:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b8de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010b8e5:	eb 04                	jmp    c010b8eb <strnlen+0x13>
        cnt ++;
c010b8e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010b8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b8ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010b8f1:	73 10                	jae    c010b903 <strnlen+0x2b>
c010b8f3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8f6:	8d 50 01             	lea    0x1(%eax),%edx
c010b8f9:	89 55 08             	mov    %edx,0x8(%ebp)
c010b8fc:	0f b6 00             	movzbl (%eax),%eax
c010b8ff:	84 c0                	test   %al,%al
c010b901:	75 e4                	jne    c010b8e7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010b903:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b906:	c9                   	leave  
c010b907:	c3                   	ret    

c010b908 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010b908:	55                   	push   %ebp
c010b909:	89 e5                	mov    %esp,%ebp
c010b90b:	57                   	push   %edi
c010b90c:	56                   	push   %esi
c010b90d:	83 ec 20             	sub    $0x20,%esp
c010b910:	8b 45 08             	mov    0x8(%ebp),%eax
c010b913:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b916:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b919:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010b91c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b922:	89 d1                	mov    %edx,%ecx
c010b924:	89 c2                	mov    %eax,%edx
c010b926:	89 ce                	mov    %ecx,%esi
c010b928:	89 d7                	mov    %edx,%edi
c010b92a:	ac                   	lods   %ds:(%esi),%al
c010b92b:	aa                   	stos   %al,%es:(%edi)
c010b92c:	84 c0                	test   %al,%al
c010b92e:	75 fa                	jne    c010b92a <strcpy+0x22>
c010b930:	89 fa                	mov    %edi,%edx
c010b932:	89 f1                	mov    %esi,%ecx
c010b934:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010b937:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b93a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010b93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010b940:	83 c4 20             	add    $0x20,%esp
c010b943:	5e                   	pop    %esi
c010b944:	5f                   	pop    %edi
c010b945:	5d                   	pop    %ebp
c010b946:	c3                   	ret    

c010b947 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010b947:	55                   	push   %ebp
c010b948:	89 e5                	mov    %esp,%ebp
c010b94a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010b94d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b950:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010b953:	eb 21                	jmp    c010b976 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010b955:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b958:	0f b6 10             	movzbl (%eax),%edx
c010b95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b95e:	88 10                	mov    %dl,(%eax)
c010b960:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b963:	0f b6 00             	movzbl (%eax),%eax
c010b966:	84 c0                	test   %al,%al
c010b968:	74 04                	je     c010b96e <strncpy+0x27>
            src ++;
c010b96a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010b96e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010b972:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010b976:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b97a:	75 d9                	jne    c010b955 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010b97c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b97f:	c9                   	leave  
c010b980:	c3                   	ret    

c010b981 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010b981:	55                   	push   %ebp
c010b982:	89 e5                	mov    %esp,%ebp
c010b984:	57                   	push   %edi
c010b985:	56                   	push   %esi
c010b986:	83 ec 20             	sub    $0x20,%esp
c010b989:	8b 45 08             	mov    0x8(%ebp),%eax
c010b98c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b98f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b992:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010b995:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b998:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b99b:	89 d1                	mov    %edx,%ecx
c010b99d:	89 c2                	mov    %eax,%edx
c010b99f:	89 ce                	mov    %ecx,%esi
c010b9a1:	89 d7                	mov    %edx,%edi
c010b9a3:	ac                   	lods   %ds:(%esi),%al
c010b9a4:	ae                   	scas   %es:(%edi),%al
c010b9a5:	75 08                	jne    c010b9af <strcmp+0x2e>
c010b9a7:	84 c0                	test   %al,%al
c010b9a9:	75 f8                	jne    c010b9a3 <strcmp+0x22>
c010b9ab:	31 c0                	xor    %eax,%eax
c010b9ad:	eb 04                	jmp    c010b9b3 <strcmp+0x32>
c010b9af:	19 c0                	sbb    %eax,%eax
c010b9b1:	0c 01                	or     $0x1,%al
c010b9b3:	89 fa                	mov    %edi,%edx
c010b9b5:	89 f1                	mov    %esi,%ecx
c010b9b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b9ba:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010b9bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010b9c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010b9c3:	83 c4 20             	add    $0x20,%esp
c010b9c6:	5e                   	pop    %esi
c010b9c7:	5f                   	pop    %edi
c010b9c8:	5d                   	pop    %ebp
c010b9c9:	c3                   	ret    

c010b9ca <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010b9ca:	55                   	push   %ebp
c010b9cb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b9cd:	eb 0c                	jmp    c010b9db <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010b9cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b9d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b9d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b9db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b9df:	74 1a                	je     c010b9fb <strncmp+0x31>
c010b9e1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9e4:	0f b6 00             	movzbl (%eax),%eax
c010b9e7:	84 c0                	test   %al,%al
c010b9e9:	74 10                	je     c010b9fb <strncmp+0x31>
c010b9eb:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9ee:	0f b6 10             	movzbl (%eax),%edx
c010b9f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9f4:	0f b6 00             	movzbl (%eax),%eax
c010b9f7:	38 c2                	cmp    %al,%dl
c010b9f9:	74 d4                	je     c010b9cf <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010b9fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b9ff:	74 18                	je     c010ba19 <strncmp+0x4f>
c010ba01:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba04:	0f b6 00             	movzbl (%eax),%eax
c010ba07:	0f b6 d0             	movzbl %al,%edx
c010ba0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba0d:	0f b6 00             	movzbl (%eax),%eax
c010ba10:	0f b6 c0             	movzbl %al,%eax
c010ba13:	29 c2                	sub    %eax,%edx
c010ba15:	89 d0                	mov    %edx,%eax
c010ba17:	eb 05                	jmp    c010ba1e <strncmp+0x54>
c010ba19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ba1e:	5d                   	pop    %ebp
c010ba1f:	c3                   	ret    

c010ba20 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010ba20:	55                   	push   %ebp
c010ba21:	89 e5                	mov    %esp,%ebp
c010ba23:	83 ec 04             	sub    $0x4,%esp
c010ba26:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010ba2c:	eb 14                	jmp    c010ba42 <strchr+0x22>
        if (*s == c) {
c010ba2e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba31:	0f b6 00             	movzbl (%eax),%eax
c010ba34:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010ba37:	75 05                	jne    c010ba3e <strchr+0x1e>
            return (char *)s;
c010ba39:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba3c:	eb 13                	jmp    c010ba51 <strchr+0x31>
        }
        s ++;
c010ba3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010ba42:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba45:	0f b6 00             	movzbl (%eax),%eax
c010ba48:	84 c0                	test   %al,%al
c010ba4a:	75 e2                	jne    c010ba2e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010ba4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ba51:	c9                   	leave  
c010ba52:	c3                   	ret    

c010ba53 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010ba53:	55                   	push   %ebp
c010ba54:	89 e5                	mov    %esp,%ebp
c010ba56:	83 ec 04             	sub    $0x4,%esp
c010ba59:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba5c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010ba5f:	eb 11                	jmp    c010ba72 <strfind+0x1f>
        if (*s == c) {
c010ba61:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba64:	0f b6 00             	movzbl (%eax),%eax
c010ba67:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010ba6a:	75 02                	jne    c010ba6e <strfind+0x1b>
            break;
c010ba6c:	eb 0e                	jmp    c010ba7c <strfind+0x29>
        }
        s ++;
c010ba6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010ba72:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba75:	0f b6 00             	movzbl (%eax),%eax
c010ba78:	84 c0                	test   %al,%al
c010ba7a:	75 e5                	jne    c010ba61 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010ba7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010ba7f:	c9                   	leave  
c010ba80:	c3                   	ret    

c010ba81 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010ba81:	55                   	push   %ebp
c010ba82:	89 e5                	mov    %esp,%ebp
c010ba84:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010ba87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010ba8e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010ba95:	eb 04                	jmp    c010ba9b <strtol+0x1a>
        s ++;
c010ba97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010ba9b:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba9e:	0f b6 00             	movzbl (%eax),%eax
c010baa1:	3c 20                	cmp    $0x20,%al
c010baa3:	74 f2                	je     c010ba97 <strtol+0x16>
c010baa5:	8b 45 08             	mov    0x8(%ebp),%eax
c010baa8:	0f b6 00             	movzbl (%eax),%eax
c010baab:	3c 09                	cmp    $0x9,%al
c010baad:	74 e8                	je     c010ba97 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010baaf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bab2:	0f b6 00             	movzbl (%eax),%eax
c010bab5:	3c 2b                	cmp    $0x2b,%al
c010bab7:	75 06                	jne    c010babf <strtol+0x3e>
        s ++;
c010bab9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010babd:	eb 15                	jmp    c010bad4 <strtol+0x53>
    }
    else if (*s == '-') {
c010babf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bac2:	0f b6 00             	movzbl (%eax),%eax
c010bac5:	3c 2d                	cmp    $0x2d,%al
c010bac7:	75 0b                	jne    c010bad4 <strtol+0x53>
        s ++, neg = 1;
c010bac9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bacd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010bad4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bad8:	74 06                	je     c010bae0 <strtol+0x5f>
c010bada:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010bade:	75 24                	jne    c010bb04 <strtol+0x83>
c010bae0:	8b 45 08             	mov    0x8(%ebp),%eax
c010bae3:	0f b6 00             	movzbl (%eax),%eax
c010bae6:	3c 30                	cmp    $0x30,%al
c010bae8:	75 1a                	jne    c010bb04 <strtol+0x83>
c010baea:	8b 45 08             	mov    0x8(%ebp),%eax
c010baed:	83 c0 01             	add    $0x1,%eax
c010baf0:	0f b6 00             	movzbl (%eax),%eax
c010baf3:	3c 78                	cmp    $0x78,%al
c010baf5:	75 0d                	jne    c010bb04 <strtol+0x83>
        s += 2, base = 16;
c010baf7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010bafb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010bb02:	eb 2a                	jmp    c010bb2e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010bb04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bb08:	75 17                	jne    c010bb21 <strtol+0xa0>
c010bb0a:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb0d:	0f b6 00             	movzbl (%eax),%eax
c010bb10:	3c 30                	cmp    $0x30,%al
c010bb12:	75 0d                	jne    c010bb21 <strtol+0xa0>
        s ++, base = 8;
c010bb14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bb18:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010bb1f:	eb 0d                	jmp    c010bb2e <strtol+0xad>
    }
    else if (base == 0) {
c010bb21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bb25:	75 07                	jne    c010bb2e <strtol+0xad>
        base = 10;
c010bb27:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010bb2e:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb31:	0f b6 00             	movzbl (%eax),%eax
c010bb34:	3c 2f                	cmp    $0x2f,%al
c010bb36:	7e 1b                	jle    c010bb53 <strtol+0xd2>
c010bb38:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb3b:	0f b6 00             	movzbl (%eax),%eax
c010bb3e:	3c 39                	cmp    $0x39,%al
c010bb40:	7f 11                	jg     c010bb53 <strtol+0xd2>
            dig = *s - '0';
c010bb42:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb45:	0f b6 00             	movzbl (%eax),%eax
c010bb48:	0f be c0             	movsbl %al,%eax
c010bb4b:	83 e8 30             	sub    $0x30,%eax
c010bb4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb51:	eb 48                	jmp    c010bb9b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010bb53:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb56:	0f b6 00             	movzbl (%eax),%eax
c010bb59:	3c 60                	cmp    $0x60,%al
c010bb5b:	7e 1b                	jle    c010bb78 <strtol+0xf7>
c010bb5d:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb60:	0f b6 00             	movzbl (%eax),%eax
c010bb63:	3c 7a                	cmp    $0x7a,%al
c010bb65:	7f 11                	jg     c010bb78 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010bb67:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb6a:	0f b6 00             	movzbl (%eax),%eax
c010bb6d:	0f be c0             	movsbl %al,%eax
c010bb70:	83 e8 57             	sub    $0x57,%eax
c010bb73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb76:	eb 23                	jmp    c010bb9b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010bb78:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb7b:	0f b6 00             	movzbl (%eax),%eax
c010bb7e:	3c 40                	cmp    $0x40,%al
c010bb80:	7e 3d                	jle    c010bbbf <strtol+0x13e>
c010bb82:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb85:	0f b6 00             	movzbl (%eax),%eax
c010bb88:	3c 5a                	cmp    $0x5a,%al
c010bb8a:	7f 33                	jg     c010bbbf <strtol+0x13e>
            dig = *s - 'A' + 10;
c010bb8c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb8f:	0f b6 00             	movzbl (%eax),%eax
c010bb92:	0f be c0             	movsbl %al,%eax
c010bb95:	83 e8 37             	sub    $0x37,%eax
c010bb98:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010bb9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bb9e:	3b 45 10             	cmp    0x10(%ebp),%eax
c010bba1:	7c 02                	jl     c010bba5 <strtol+0x124>
            break;
c010bba3:	eb 1a                	jmp    c010bbbf <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010bba5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bbac:	0f af 45 10          	imul   0x10(%ebp),%eax
c010bbb0:	89 c2                	mov    %eax,%edx
c010bbb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bbb5:	01 d0                	add    %edx,%eax
c010bbb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010bbba:	e9 6f ff ff ff       	jmp    c010bb2e <strtol+0xad>

    if (endptr) {
c010bbbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010bbc3:	74 08                	je     c010bbcd <strtol+0x14c>
        *endptr = (char *) s;
c010bbc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbc8:	8b 55 08             	mov    0x8(%ebp),%edx
c010bbcb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010bbcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010bbd1:	74 07                	je     c010bbda <strtol+0x159>
c010bbd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bbd6:	f7 d8                	neg    %eax
c010bbd8:	eb 03                	jmp    c010bbdd <strtol+0x15c>
c010bbda:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010bbdd:	c9                   	leave  
c010bbde:	c3                   	ret    

c010bbdf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010bbdf:	55                   	push   %ebp
c010bbe0:	89 e5                	mov    %esp,%ebp
c010bbe2:	57                   	push   %edi
c010bbe3:	83 ec 24             	sub    $0x24,%esp
c010bbe6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbe9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010bbec:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010bbf0:	8b 55 08             	mov    0x8(%ebp),%edx
c010bbf3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010bbf6:	88 45 f7             	mov    %al,-0x9(%ebp)
c010bbf9:	8b 45 10             	mov    0x10(%ebp),%eax
c010bbfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bbff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010bc02:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010bc06:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010bc09:	89 d7                	mov    %edx,%edi
c010bc0b:	f3 aa                	rep stos %al,%es:(%edi)
c010bc0d:	89 fa                	mov    %edi,%edx
c010bc0f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010bc12:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010bc15:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010bc18:	83 c4 24             	add    $0x24,%esp
c010bc1b:	5f                   	pop    %edi
c010bc1c:	5d                   	pop    %ebp
c010bc1d:	c3                   	ret    

c010bc1e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010bc1e:	55                   	push   %ebp
c010bc1f:	89 e5                	mov    %esp,%ebp
c010bc21:	57                   	push   %edi
c010bc22:	56                   	push   %esi
c010bc23:	53                   	push   %ebx
c010bc24:	83 ec 30             	sub    $0x30,%esp
c010bc27:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bc2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc30:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bc33:	8b 45 10             	mov    0x10(%ebp),%eax
c010bc36:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010bc39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010bc3f:	73 42                	jae    c010bc83 <memmove+0x65>
c010bc41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010bc47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010bc4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc50:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bc53:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010bc56:	c1 e8 02             	shr    $0x2,%eax
c010bc59:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bc5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bc5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010bc61:	89 d7                	mov    %edx,%edi
c010bc63:	89 c6                	mov    %eax,%esi
c010bc65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bc67:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010bc6a:	83 e1 03             	and    $0x3,%ecx
c010bc6d:	74 02                	je     c010bc71 <memmove+0x53>
c010bc6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bc71:	89 f0                	mov    %esi,%eax
c010bc73:	89 fa                	mov    %edi,%edx
c010bc75:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010bc78:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010bc7b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bc7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010bc81:	eb 36                	jmp    c010bcb9 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010bc83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc86:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bc89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc8c:	01 c2                	add    %eax,%edx
c010bc8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc91:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010bc94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc97:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010bc9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc9d:	89 c1                	mov    %eax,%ecx
c010bc9f:	89 d8                	mov    %ebx,%eax
c010bca1:	89 d6                	mov    %edx,%esi
c010bca3:	89 c7                	mov    %eax,%edi
c010bca5:	fd                   	std    
c010bca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bca8:	fc                   	cld    
c010bca9:	89 f8                	mov    %edi,%eax
c010bcab:	89 f2                	mov    %esi,%edx
c010bcad:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010bcb0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010bcb3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bcb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bcb9:	83 c4 30             	add    $0x30,%esp
c010bcbc:	5b                   	pop    %ebx
c010bcbd:	5e                   	pop    %esi
c010bcbe:	5f                   	pop    %edi
c010bcbf:	5d                   	pop    %ebp
c010bcc0:	c3                   	ret    

c010bcc1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010bcc1:	55                   	push   %ebp
c010bcc2:	89 e5                	mov    %esp,%ebp
c010bcc4:	57                   	push   %edi
c010bcc5:	56                   	push   %esi
c010bcc6:	83 ec 20             	sub    $0x20,%esp
c010bcc9:	8b 45 08             	mov    0x8(%ebp),%eax
c010bccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bccf:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bcd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bcd5:	8b 45 10             	mov    0x10(%ebp),%eax
c010bcd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bcdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bcde:	c1 e8 02             	shr    $0x2,%eax
c010bce1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bce9:	89 d7                	mov    %edx,%edi
c010bceb:	89 c6                	mov    %eax,%esi
c010bced:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bcef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010bcf2:	83 e1 03             	and    $0x3,%ecx
c010bcf5:	74 02                	je     c010bcf9 <memcpy+0x38>
c010bcf7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bcf9:	89 f0                	mov    %esi,%eax
c010bcfb:	89 fa                	mov    %edi,%edx
c010bcfd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010bd00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010bd03:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bd06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010bd09:	83 c4 20             	add    $0x20,%esp
c010bd0c:	5e                   	pop    %esi
c010bd0d:	5f                   	pop    %edi
c010bd0e:	5d                   	pop    %ebp
c010bd0f:	c3                   	ret    

c010bd10 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010bd10:	55                   	push   %ebp
c010bd11:	89 e5                	mov    %esp,%ebp
c010bd13:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010bd16:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010bd1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bd1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010bd22:	eb 30                	jmp    c010bd54 <memcmp+0x44>
        if (*s1 != *s2) {
c010bd24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bd27:	0f b6 10             	movzbl (%eax),%edx
c010bd2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bd2d:	0f b6 00             	movzbl (%eax),%eax
c010bd30:	38 c2                	cmp    %al,%dl
c010bd32:	74 18                	je     c010bd4c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bd34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bd37:	0f b6 00             	movzbl (%eax),%eax
c010bd3a:	0f b6 d0             	movzbl %al,%edx
c010bd3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bd40:	0f b6 00             	movzbl (%eax),%eax
c010bd43:	0f b6 c0             	movzbl %al,%eax
c010bd46:	29 c2                	sub    %eax,%edx
c010bd48:	89 d0                	mov    %edx,%eax
c010bd4a:	eb 1a                	jmp    c010bd66 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010bd4c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bd50:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010bd54:	8b 45 10             	mov    0x10(%ebp),%eax
c010bd57:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bd5a:	89 55 10             	mov    %edx,0x10(%ebp)
c010bd5d:	85 c0                	test   %eax,%eax
c010bd5f:	75 c3                	jne    c010bd24 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010bd61:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bd66:	c9                   	leave  
c010bd67:	c3                   	ret    
