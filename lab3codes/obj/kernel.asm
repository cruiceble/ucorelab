
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 00 12 00 	lgdtl  0x120018
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
c010001e:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
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
c0100030:	ba b0 1b 12 c0       	mov    $0xc0121bb0,%edx
c0100035:	b8 68 0a 12 c0       	mov    $0xc0120a68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 0a 12 c0 	movl   $0xc0120a68,(%esp)
c0100051:	e8 40 89 00 00       	call   c0108996 <memset>

    cons_init();                // init the console
c0100056:	e8 80 15 00 00       	call   c01015db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 8b 10 c0 	movl   $0xc0108b20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 8b 10 c0 	movl   $0xc0108b3c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 cc 4b 00 00       	call   c0104c50 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 1f 00 00       	call   c0101fb9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 82 20 00 00       	call   c0102110 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 59 73 00 00       	call   c01073ec <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 74 16 00 00       	call   c010170c <ide_init>
    swap_init();                // init swap
c0100098:	e8 84 5f 00 00       	call   c0106021 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 ef 0c 00 00       	call   c0100d91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 80 1e 00 00       	call   c0101f27 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 f8 0b 00 00       	call   c0100cc3 <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 41 8b 10 c0 	movl   $0xc0108b41,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 4f 8b 10 c0 	movl   $0xc0108b4f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 5d 8b 10 c0 	movl   $0xc0108b5d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 8b 10 c0 	movl   $0xc0108b6b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 79 8b 10 c0 	movl   $0xc0108b79,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 0a 12 c0       	mov    %eax,0xc0120a80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 88 8b 10 c0 	movl   $0xc0108b88,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 a8 8b 10 c0 	movl   $0xc0108ba8,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 c7 8b 10 c0 	movl   $0xc0108bc7,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 0a 12 c0    	mov    %dl,-0x3fedf560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 0a 12 c0       	add    $0xc0120aa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 0a 12 c0       	mov    $0xc0120aa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 fe 12 00 00       	call   c0101607 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 91 7d 00 00       	call   c01080d7 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 85 12 00 00       	call   c0101607 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 65 12 00 00       	call   c0101643 <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 cc 8b 10 c0    	movl   $0xc0108bcc,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 cc 8b 10 c0 	movl   $0xc0108bcc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 68 aa 10 c0 	movl   $0xc010aa68,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 f8 97 11 c0 	movl   $0xc01197f8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec f9 97 11 c0 	movl   $0xc01197f9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 a8 d0 11 c0 	movl   $0xc011d0a8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 0f 81 00 00       	call   c010880a <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 d6 8b 10 c0 	movl   $0xc0108bd6,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 ef 8b 10 c0 	movl   $0xc0108bef,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 1f 8b 10 	movl   $0xc0108b1f,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 07 8c 10 c0 	movl   $0xc0108c07,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 0a 12 	movl   $0xc0120a68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 1f 8c 10 c0 	movl   $0xc0108c1f,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 1b 12 	movl   $0xc0121bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 37 8c 10 c0 	movl   $0xc0108c37,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 50 8c 10 c0 	movl   $0xc0108c50,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 7a 8c 10 c0 	movl   $0xc0108c7a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 96 8c 10 c0 	movl   $0xc0108c96,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	e9 88 00 00 00       	jmp    c0100a76 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fc:	c7 04 24 a8 8c 10 c0 	movl   $0xc0108ca8,(%esp)
c0100a03:	e8 43 f9 ff ff       	call   c010034b <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0b:	83 c0 08             	add    $0x8,%eax
c0100a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a18:	eb 25                	jmp    c0100a3f <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a27:	01 d0                	add    %edx,%eax
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2f:	c7 04 24 c4 8c 10 c0 	movl   $0xc0108cc4,(%esp)
c0100a36:	e8 10 f9 ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a43:	7e d5                	jle    c0100a1a <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a45:	c7 04 24 cc 8c 10 c0 	movl   $0xc0108ccc,(%esp)
c0100a4c:	e8 fa f8 ff ff       	call   c010034b <cprintf>
        print_debuginfo(eip - 1);
c0100a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a54:	83 e8 01             	sub    $0x1,%eax
c0100a57:	89 04 24             	mov    %eax,(%esp)
c0100a5a:	e8 b6 fe ff ff       	call   c0100915 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a62:	83 c0 04             	add    $0x4,%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a7a:	74 0a                	je     c0100a86 <print_stackframe+0xbd>
c0100a7c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a80:	0f 8e 68 ff ff ff    	jle    c01009ee <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a86:	c9                   	leave  
c0100a87:	c3                   	ret    

c0100a88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a88:	55                   	push   %ebp
c0100a89:	89 e5                	mov    %esp,%ebp
c0100a8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a95:	eb 0c                	jmp    c0100aa3 <parse+0x1b>
            *buf ++ = '\0';
c0100a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	0f b6 00             	movzbl (%eax),%eax
c0100aa9:	84 c0                	test   %al,%al
c0100aab:	74 1d                	je     c0100aca <parse+0x42>
c0100aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab0:	0f b6 00             	movzbl (%eax),%eax
c0100ab3:	0f be c0             	movsbl %al,%eax
c0100ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aba:	c7 04 24 50 8d 10 c0 	movl   $0xc0108d50,(%esp)
c0100ac1:	e8 11 7d 00 00       	call   c01087d7 <strchr>
c0100ac6:	85 c0                	test   %eax,%eax
c0100ac8:	75 cd                	jne    c0100a97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acd:	0f b6 00             	movzbl (%eax),%eax
c0100ad0:	84 c0                	test   %al,%al
c0100ad2:	75 02                	jne    c0100ad6 <parse+0x4e>
            break;
c0100ad4:	eb 67                	jmp    c0100b3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ada:	75 14                	jne    c0100af0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100adc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae3:	00 
c0100ae4:	c7 04 24 55 8d 10 c0 	movl   $0xc0108d55,(%esp)
c0100aeb:	e8 5b f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af3:	8d 50 01             	lea    0x1(%eax),%edx
c0100af6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b03:	01 c2                	add    %eax,%edx
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	eb 04                	jmp    c0100b10 <parse+0x88>
            buf ++;
c0100b0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	0f b6 00             	movzbl (%eax),%eax
c0100b16:	84 c0                	test   %al,%al
c0100b18:	74 1d                	je     c0100b37 <parse+0xaf>
c0100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1d:	0f b6 00             	movzbl (%eax),%eax
c0100b20:	0f be c0             	movsbl %al,%eax
c0100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b27:	c7 04 24 50 8d 10 c0 	movl   $0xc0108d50,(%esp)
c0100b2e:	e8 a4 7c 00 00       	call   c01087d7 <strchr>
c0100b33:	85 c0                	test   %eax,%eax
c0100b35:	74 d5                	je     c0100b0c <parse+0x84>
            buf ++;
        }
    }
c0100b37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b38:	e9 66 ff ff ff       	jmp    c0100aa3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b40:	c9                   	leave  
c0100b41:	c3                   	ret    

c0100b42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b42:	55                   	push   %ebp
c0100b43:	89 e5                	mov    %esp,%ebp
c0100b45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	89 04 24             	mov    %eax,(%esp)
c0100b55:	e8 2e ff ff ff       	call   c0100a88 <parse>
c0100b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b61:	75 0a                	jne    c0100b6d <runcmd+0x2b>
        return 0;
c0100b63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b68:	e9 85 00 00 00       	jmp    c0100bf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b74:	eb 5c                	jmp    c0100bd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7c:	89 d0                	mov    %edx,%eax
c0100b7e:	01 c0                	add    %eax,%eax
c0100b80:	01 d0                	add    %edx,%eax
c0100b82:	c1 e0 02             	shl    $0x2,%eax
c0100b85:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100b8a:	8b 00                	mov    (%eax),%eax
c0100b8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b90:	89 04 24             	mov    %eax,(%esp)
c0100b93:	e8 a0 7b 00 00       	call   c0108738 <strcmp>
c0100b98:	85 c0                	test   %eax,%eax
c0100b9a:	75 32                	jne    c0100bce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9f:	89 d0                	mov    %edx,%eax
c0100ba1:	01 c0                	add    %eax,%eax
c0100ba3:	01 d0                	add    %edx,%eax
c0100ba5:	c1 e0 02             	shl    $0x2,%eax
c0100ba8:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100bad:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc0:	83 c2 04             	add    $0x4,%edx
c0100bc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc7:	89 0c 24             	mov    %ecx,(%esp)
c0100bca:	ff d0                	call   *%eax
c0100bcc:	eb 24                	jmp    c0100bf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd5:	83 f8 02             	cmp    $0x2,%eax
c0100bd8:	76 9c                	jbe    c0100b76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be1:	c7 04 24 73 8d 10 c0 	movl   $0xc0108d73,(%esp)
c0100be8:	e8 5e f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf2:	c9                   	leave  
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 8c 8d 10 c0 	movl   $0xc0108d8c,(%esp)
c0100c01:	e8 45 f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 b4 8d 10 c0 	movl   $0xc0108db4,(%esp)
c0100c0d:	e8 39 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 26 16 00 00       	call   c0102249 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 d9 8d 10 c0 	movl   $0xc0108dd9,(%esp)
c0100c2a:	e8 13 f6 ff ff       	call   c0100242 <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 18                	je     c0100c50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f8 fe ff ff       	call   c0100b42 <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	79 02                	jns    c0100c50 <kmonitor+0x5c>
                break;
c0100c4e:	eb 02                	jmp    c0100c52 <kmonitor+0x5e>
            }
        }
    }
c0100c50:	eb d1                	jmp    c0100c23 <kmonitor+0x2f>
}
c0100c52:	c9                   	leave  
c0100c53:	c3                   	ret    

c0100c54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c54:	55                   	push   %ebp
c0100c55:	89 e5                	mov    %esp,%ebp
c0100c57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c61:	eb 3f                	jmp    c0100ca2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c66:	89 d0                	mov    %edx,%eax
c0100c68:	01 c0                	add    %eax,%eax
c0100c6a:	01 d0                	add    %edx,%eax
c0100c6c:	c1 e0 02             	shl    $0x2,%eax
c0100c6f:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7a:	89 d0                	mov    %edx,%eax
c0100c7c:	01 c0                	add    %eax,%eax
c0100c7e:	01 d0                	add    %edx,%eax
c0100c80:	c1 e0 02             	shl    $0x2,%eax
c0100c83:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c88:	8b 00                	mov    (%eax),%eax
c0100c8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c92:	c7 04 24 dd 8d 10 c0 	movl   $0xc0108ddd,(%esp)
c0100c99:	e8 ad f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca5:	83 f8 02             	cmp    $0x2,%eax
c0100ca8:	76 b9                	jbe    c0100c63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	c9                   	leave  
c0100cb0:	c3                   	ret    

c0100cb1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb1:	55                   	push   %ebp
c0100cb2:	89 e5                	mov    %esp,%ebp
c0100cb4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb7:	e8 c3 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc1:	c9                   	leave  
c0100cc2:	c3                   	ret    

c0100cc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc3:	55                   	push   %ebp
c0100cc4:	89 e5                	mov    %esp,%ebp
c0100cc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc9:	e8 fb fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd3:	c9                   	leave  
c0100cd4:	c3                   	ret    

c0100cd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd5:	55                   	push   %ebp
c0100cd6:	89 e5                	mov    %esp,%ebp
c0100cd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdb:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
c0100ce0:	85 c0                	test   %eax,%eax
c0100ce2:	74 02                	je     c0100ce6 <__panic+0x11>
        goto panic_dead;
c0100ce4:	eb 48                	jmp    c0100d2e <__panic+0x59>
    }
    is_panic = 1;
c0100ce6:	c7 05 a0 0e 12 c0 01 	movl   $0x1,0xc0120ea0
c0100ced:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d04:	c7 04 24 e6 8d 10 c0 	movl   $0xc0108de6,(%esp)
c0100d0b:	e8 3b f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1a:	89 04 24             	mov    %eax,(%esp)
c0100d1d:	e8 f6 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d22:	c7 04 24 02 8e 10 c0 	movl   $0xc0108e02,(%esp)
c0100d29:	e8 1d f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2e:	e8 fa 11 00 00       	call   c0101f2d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d3a:	e8 b5 fe ff ff       	call   c0100bf4 <kmonitor>
    }
c0100d3f:	eb f2                	jmp    c0100d33 <__panic+0x5e>

c0100d41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d41:	55                   	push   %ebp
c0100d42:	89 e5                	mov    %esp,%ebp
c0100d44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5b:	c7 04 24 04 8e 10 c0 	movl   $0xc0108e04,(%esp)
c0100d62:	e8 e4 f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d71:	89 04 24             	mov    %eax,(%esp)
c0100d74:	e8 9f f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d79:	c7 04 24 02 8e 10 c0 	movl   $0xc0108e02,(%esp)
c0100d80:	e8 c6 f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d85:	c9                   	leave  
c0100d86:	c3                   	ret    

c0100d87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d87:	55                   	push   %ebp
c0100d88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d8a:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
}
c0100d8f:	5d                   	pop    %ebp
c0100d90:	c3                   	ret    

c0100d91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d91:	55                   	push   %ebp
c0100d92:	89 e5                	mov    %esp,%ebp
c0100d94:	83 ec 28             	sub    $0x28,%esp
c0100d97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da9:	ee                   	out    %al,(%dx)
c0100daa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbc:	ee                   	out    %al,(%dx)
c0100dbd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dcf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd0:	c7 05 bc 1a 12 c0 00 	movl   $0x0,0xc0121abc
c0100dd7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dda:	c7 04 24 22 8e 10 c0 	movl   $0xc0108e22,(%esp)
c0100de1:	e8 65 f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100de6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ded:	e8 99 11 00 00       	call   c0101f8b <pic_enable>
}
c0100df2:	c9                   	leave  
c0100df3:	c3                   	ret    

c0100df4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df4:	55                   	push   %ebp
c0100df5:	89 e5                	mov    %esp,%ebp
c0100df7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfa:	9c                   	pushf  
c0100dfb:	58                   	pop    %eax
c0100dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e02:	25 00 02 00 00       	and    $0x200,%eax
c0100e07:	85 c0                	test   %eax,%eax
c0100e09:	74 0c                	je     c0100e17 <__intr_save+0x23>
        intr_disable();
c0100e0b:	e8 1d 11 00 00       	call   c0101f2d <intr_disable>
        return 1;
c0100e10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e15:	eb 05                	jmp    c0100e1c <__intr_save+0x28>
    }
    return 0;
c0100e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1c:	c9                   	leave  
c0100e1d:	c3                   	ret    

c0100e1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1e:	55                   	push   %ebp
c0100e1f:	89 e5                	mov    %esp,%ebp
c0100e21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e28:	74 05                	je     c0100e2f <__intr_restore+0x11>
        intr_enable();
c0100e2a:	e8 f8 10 00 00       	call   c0101f27 <intr_enable>
    }
}
c0100e2f:	c9                   	leave  
c0100e30:	c3                   	ret    

c0100e31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e31:	55                   	push   %ebp
c0100e32:	89 e5                	mov    %esp,%ebp
c0100e34:	83 ec 10             	sub    $0x10,%esp
c0100e37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e41:	89 c2                	mov    %eax,%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e51:	89 c2                	mov    %eax,%edx
c0100e53:	ec                   	in     (%dx),%al
c0100e54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e61:	89 c2                	mov    %eax,%edx
c0100e63:	ec                   	in     (%dx),%al
c0100e64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e71:	89 c2                	mov    %eax,%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e77:	c9                   	leave  
c0100e78:	c3                   	ret    

c0100e79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e79:	55                   	push   %ebp
c0100e7a:	89 e5                	mov    %esp,%ebp
c0100e7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	0f b7 00             	movzwl (%eax),%eax
c0100e8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	0f b7 00             	movzwl (%eax),%eax
c0100e9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea2:	74 12                	je     c0100eb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eab:	66 c7 05 c6 0e 12 c0 	movw   $0x3b4,0xc0120ec6
c0100eb2:	b4 03 
c0100eb4:	eb 13                	jmp    c0100ec9 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec0:	66 c7 05 c6 0e 12 c0 	movw   $0x3d4,0xc0120ec6
c0100ec7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec9:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100ed0:	0f b7 c0             	movzwl %ax,%eax
c0100ed3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100edb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100edf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee4:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100eeb:	83 c0 01             	add    $0x1,%eax
c0100eee:	0f b7 c0             	movzwl %ax,%eax
c0100ef1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef9:	89 c2                	mov    %eax,%edx
c0100efb:	ec                   	in     (%dx),%al
c0100efc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f03:	0f b6 c0             	movzbl %al,%eax
c0100f06:	c1 e0 08             	shl    $0x8,%eax
c0100f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0c:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f13:	0f b7 c0             	movzwl %ax,%eax
c0100f16:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f22:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f26:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f27:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f2e:	83 c0 01             	add    $0x1,%eax
c0100f31:	0f b7 c0             	movzwl %ax,%eax
c0100f34:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f38:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3c:	89 c2                	mov    %eax,%edx
c0100f3e:	ec                   	in     (%dx),%al
c0100f3f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f42:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f46:	0f b6 c0             	movzbl %al,%eax
c0100f49:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4f:	a3 c0 0e 12 c0       	mov    %eax,0xc0120ec0
    crt_pos = pos;
c0100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f57:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
}
c0100f5d:	c9                   	leave  
c0100f5e:	c3                   	ret    

c0100f5f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5f:	55                   	push   %ebp
c0100f60:	89 e5                	mov    %esp,%ebp
c0100f62:	83 ec 48             	sub    $0x48,%esp
c0100f65:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f73:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f77:	ee                   	out    %al,(%dx)
c0100f78:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f82:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8a:	ee                   	out    %al,(%dx)
c0100f8b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f91:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
c0100f9e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb0:	ee                   	out    %al,(%dx)
c0100fb1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc3:	ee                   	out    %al,(%dx)
c0100fc4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd6:	ee                   	out    %al,(%dx)
c0100fd7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe9:	ee                   	out    %al,(%dx)
c0100fea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff4:	89 c2                	mov    %eax,%edx
c0100ff6:	ec                   	in     (%dx),%al
c0100ff7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffe:	3c ff                	cmp    $0xff,%al
c0101000:	0f 95 c0             	setne  %al
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	a3 c8 0e 12 c0       	mov    %eax,0xc0120ec8
c010100b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101011:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101015:	89 c2                	mov    %eax,%edx
c0101017:	ec                   	in     (%dx),%al
c0101018:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101021:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101025:	89 c2                	mov    %eax,%edx
c0101027:	ec                   	in     (%dx),%al
c0101028:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102b:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101030:	85 c0                	test   %eax,%eax
c0101032:	74 0c                	je     c0101040 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101034:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103b:	e8 4b 0f 00 00       	call   c0101f8b <pic_enable>
    }
}
c0101040:	c9                   	leave  
c0101041:	c3                   	ret    

c0101042 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101042:	55                   	push   %ebp
c0101043:	89 e5                	mov    %esp,%ebp
c0101045:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104f:	eb 09                	jmp    c010105a <lpt_putc_sub+0x18>
        delay();
c0101051:	e8 db fd ff ff       	call   c0100e31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101056:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101060:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101064:	89 c2                	mov    %eax,%edx
c0101066:	ec                   	in     (%dx),%al
c0101067:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106e:	84 c0                	test   %al,%al
c0101070:	78 09                	js     c010107b <lpt_putc_sub+0x39>
c0101072:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101079:	7e d6                	jle    c0101051 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107b:	8b 45 08             	mov    0x8(%ebp),%eax
c010107e:	0f b6 c0             	movzbl %al,%eax
c0101081:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101087:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101092:	ee                   	out    %al,(%dx)
c0101093:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101099:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a5:	ee                   	out    %al,(%dx)
c01010a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b9:	c9                   	leave  
c01010ba:	c3                   	ret    

c01010bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010bb:	55                   	push   %ebp
c01010bc:	89 e5                	mov    %esp,%ebp
c01010be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c5:	74 0d                	je     c01010d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ca:	89 04 24             	mov    %eax,(%esp)
c01010cd:	e8 70 ff ff ff       	call   c0101042 <lpt_putc_sub>
c01010d2:	eb 24                	jmp    c01010f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010db:	e8 62 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e7:	e8 56 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f3:	e8 4a ff ff ff       	call   c0101042 <lpt_putc_sub>
    }
}
c01010f8:	c9                   	leave  
c01010f9:	c3                   	ret    

c01010fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fa:	55                   	push   %ebp
c01010fb:	89 e5                	mov    %esp,%ebp
c01010fd:	53                   	push   %ebx
c01010fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	b0 00                	mov    $0x0,%al
c0101106:	85 c0                	test   %eax,%eax
c0101108:	75 07                	jne    c0101111 <cga_putc+0x17>
        c |= 0x0700;
c010110a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101111:	8b 45 08             	mov    0x8(%ebp),%eax
c0101114:	0f b6 c0             	movzbl %al,%eax
c0101117:	83 f8 0a             	cmp    $0xa,%eax
c010111a:	74 4c                	je     c0101168 <cga_putc+0x6e>
c010111c:	83 f8 0d             	cmp    $0xd,%eax
c010111f:	74 57                	je     c0101178 <cga_putc+0x7e>
c0101121:	83 f8 08             	cmp    $0x8,%eax
c0101124:	0f 85 88 00 00 00    	jne    c01011b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112a:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101131:	66 85 c0             	test   %ax,%ax
c0101134:	74 30                	je     c0101166 <cga_putc+0x6c>
            crt_pos --;
c0101136:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010113d:	83 e8 01             	sub    $0x1,%eax
c0101140:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101146:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c010114b:	0f b7 15 c4 0e 12 c0 	movzwl 0xc0120ec4,%edx
c0101152:	0f b7 d2             	movzwl %dx,%edx
c0101155:	01 d2                	add    %edx,%edx
c0101157:	01 c2                	add    %eax,%edx
c0101159:	8b 45 08             	mov    0x8(%ebp),%eax
c010115c:	b0 00                	mov    $0x0,%al
c010115e:	83 c8 20             	or     $0x20,%eax
c0101161:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101164:	eb 72                	jmp    c01011d8 <cga_putc+0xde>
c0101166:	eb 70                	jmp    c01011d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101168:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010116f:	83 c0 50             	add    $0x50,%eax
c0101172:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101178:	0f b7 1d c4 0e 12 c0 	movzwl 0xc0120ec4,%ebx
c010117f:	0f b7 0d c4 0e 12 c0 	movzwl 0xc0120ec4,%ecx
c0101186:	0f b7 c1             	movzwl %cx,%eax
c0101189:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118f:	c1 e8 10             	shr    $0x10,%eax
c0101192:	89 c2                	mov    %eax,%edx
c0101194:	66 c1 ea 06          	shr    $0x6,%dx
c0101198:	89 d0                	mov    %edx,%eax
c010119a:	c1 e0 02             	shl    $0x2,%eax
c010119d:	01 d0                	add    %edx,%eax
c010119f:	c1 e0 04             	shl    $0x4,%eax
c01011a2:	29 c1                	sub    %eax,%ecx
c01011a4:	89 ca                	mov    %ecx,%edx
c01011a6:	89 d8                	mov    %ebx,%eax
c01011a8:	29 d0                	sub    %edx,%eax
c01011aa:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c01011b0:	eb 26                	jmp    c01011d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b2:	8b 0d c0 0e 12 c0    	mov    0xc0120ec0,%ecx
c01011b8:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011bf:	8d 50 01             	lea    0x1(%eax),%edx
c01011c2:	66 89 15 c4 0e 12 c0 	mov    %dx,0xc0120ec4
c01011c9:	0f b7 c0             	movzwl %ax,%eax
c01011cc:	01 c0                	add    %eax,%eax
c01011ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d8:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e3:	76 5b                	jbe    c0101240 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e5:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f0:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fc:	00 
c01011fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101201:	89 04 24             	mov    %eax,(%esp)
c0101204:	e8 cc 77 00 00       	call   c01089d5 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101209:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101210:	eb 15                	jmp    c0101227 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101212:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101217:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121a:	01 d2                	add    %edx,%edx
c010121c:	01 d0                	add    %edx,%eax
c010121e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101223:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101227:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122e:	7e e2                	jle    c0101212 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101230:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101237:	83 e8 50             	sub    $0x50,%eax
c010123a:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101240:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0101247:	0f b7 c0             	movzwl %ax,%eax
c010124a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101252:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101256:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125b:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101262:	66 c1 e8 08          	shr    $0x8,%ax
c0101266:	0f b6 c0             	movzbl %al,%eax
c0101269:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c0101270:	83 c2 01             	add    $0x1,%edx
c0101273:	0f b7 d2             	movzwl %dx,%edx
c0101276:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101281:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101285:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101286:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c010128d:	0f b7 c0             	movzwl %ax,%eax
c0101290:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101294:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101298:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a1:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01012a8:	0f b6 c0             	movzbl %al,%eax
c01012ab:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c01012b2:	83 c2 01             	add    $0x1,%edx
c01012b5:	0f b7 d2             	movzwl %dx,%edx
c01012b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	83 c4 34             	add    $0x34,%esp
c01012cb:	5b                   	pop    %ebx
c01012cc:	5d                   	pop    %ebp
c01012cd:	c3                   	ret    

c01012ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ce:	55                   	push   %ebp
c01012cf:	89 e5                	mov    %esp,%ebp
c01012d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012db:	eb 09                	jmp    c01012e6 <serial_putc_sub+0x18>
        delay();
c01012dd:	e8 4f fb ff ff       	call   c0100e31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f0:	89 c2                	mov    %eax,%edx
c01012f2:	ec                   	in     (%dx),%al
c01012f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fa:	0f b6 c0             	movzbl %al,%eax
c01012fd:	83 e0 20             	and    $0x20,%eax
c0101300:	85 c0                	test   %eax,%eax
c0101302:	75 09                	jne    c010130d <serial_putc_sub+0x3f>
c0101304:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130b:	7e d0                	jle    c01012dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101310:	0f b6 c0             	movzbl %al,%eax
c0101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101319:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101320:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101324:	ee                   	out    %al,(%dx)
}
c0101325:	c9                   	leave  
c0101326:	c3                   	ret    

c0101327 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101327:	55                   	push   %ebp
c0101328:	89 e5                	mov    %esp,%ebp
c010132a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101331:	74 0d                	je     c0101340 <serial_putc+0x19>
        serial_putc_sub(c);
c0101333:	8b 45 08             	mov    0x8(%ebp),%eax
c0101336:	89 04 24             	mov    %eax,(%esp)
c0101339:	e8 90 ff ff ff       	call   c01012ce <serial_putc_sub>
c010133e:	eb 24                	jmp    c0101364 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101340:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101347:	e8 82 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub(' ');
c010134c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101353:	e8 76 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101358:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135f:	e8 6a ff ff ff       	call   c01012ce <serial_putc_sub>
    }
}
c0101364:	c9                   	leave  
c0101365:	c3                   	ret    

c0101366 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101366:	55                   	push   %ebp
c0101367:	89 e5                	mov    %esp,%ebp
c0101369:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136c:	eb 33                	jmp    c01013a1 <cons_intr+0x3b>
        if (c != 0) {
c010136e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101372:	74 2d                	je     c01013a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101374:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101379:	8d 50 01             	lea    0x1(%eax),%edx
c010137c:	89 15 e4 10 12 c0    	mov    %edx,0xc01210e4
c0101382:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101385:	88 90 e0 0e 12 c0    	mov    %dl,-0x3fedf120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138b:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101390:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101395:	75 0a                	jne    c01013a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101397:	c7 05 e4 10 12 c0 00 	movl   $0x0,0xc01210e4
c010139e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a4:	ff d0                	call   *%eax
c01013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ad:	75 bf                	jne    c010136e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013af:	c9                   	leave  
c01013b0:	c3                   	ret    

c01013b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b1:	55                   	push   %ebp
c01013b2:	89 e5                	mov    %esp,%ebp
c01013b4:	83 ec 10             	sub    $0x10,%esp
c01013b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c1:	89 c2                	mov    %eax,%edx
c01013c3:	ec                   	in     (%dx),%al
c01013c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cb:	0f b6 c0             	movzbl %al,%eax
c01013ce:	83 e0 01             	and    $0x1,%eax
c01013d1:	85 c0                	test   %eax,%eax
c01013d3:	75 07                	jne    c01013dc <serial_proc_data+0x2b>
        return -1;
c01013d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013da:	eb 2a                	jmp    c0101406 <serial_proc_data+0x55>
c01013dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e6:	89 c2                	mov    %eax,%edx
c01013e8:	ec                   	in     (%dx),%al
c01013e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f0:	0f b6 c0             	movzbl %al,%eax
c01013f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fa:	75 07                	jne    c0101403 <serial_proc_data+0x52>
        c = '\b';
c01013fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101406:	c9                   	leave  
c0101407:	c3                   	ret    

c0101408 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101408:	55                   	push   %ebp
c0101409:	89 e5                	mov    %esp,%ebp
c010140b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140e:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101413:	85 c0                	test   %eax,%eax
c0101415:	74 0c                	je     c0101423 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101417:	c7 04 24 b1 13 10 c0 	movl   $0xc01013b1,(%esp)
c010141e:	e8 43 ff ff ff       	call   c0101366 <cons_intr>
    }
}
c0101423:	c9                   	leave  
c0101424:	c3                   	ret    

c0101425 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101425:	55                   	push   %ebp
c0101426:	89 e5                	mov    %esp,%ebp
c0101428:	83 ec 38             	sub    $0x38,%esp
c010142b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101431:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101435:	89 c2                	mov    %eax,%edx
c0101437:	ec                   	in     (%dx),%al
c0101438:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143f:	0f b6 c0             	movzbl %al,%eax
c0101442:	83 e0 01             	and    $0x1,%eax
c0101445:	85 c0                	test   %eax,%eax
c0101447:	75 0a                	jne    c0101453 <kbd_proc_data+0x2e>
        return -1;
c0101449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144e:	e9 59 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
c0101453:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101459:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145d:	89 c2                	mov    %eax,%edx
c010145f:	ec                   	in     (%dx),%al
c0101460:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101463:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101467:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146e:	75 17                	jne    c0101487 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101470:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101475:	83 c8 40             	or     $0x40,%eax
c0101478:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c010147d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101482:	e9 25 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148b:	84 c0                	test   %al,%al
c010148d:	79 47                	jns    c01014d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148f:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101494:	83 e0 40             	and    $0x40,%eax
c0101497:	85 c0                	test   %eax,%eax
c0101499:	75 09                	jne    c01014a4 <kbd_proc_data+0x7f>
c010149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149f:	83 e0 7f             	and    $0x7f,%eax
c01014a2:	eb 04                	jmp    c01014a8 <kbd_proc_data+0x83>
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014b6:	83 c8 40             	or     $0x40,%eax
c01014b9:	0f b6 c0             	movzbl %al,%eax
c01014bc:	f7 d0                	not    %eax
c01014be:	89 c2                	mov    %eax,%edx
c01014c0:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014c5:	21 d0                	and    %edx,%eax
c01014c7:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c01014cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d1:	e9 d6 00 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d6:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014db:	83 e0 40             	and    $0x40,%eax
c01014de:	85 c0                	test   %eax,%eax
c01014e0:	74 11                	je     c01014f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e6:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ee:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    }

    shift |= shiftcode[data];
c01014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f7:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014fe:	0f b6 d0             	movzbl %al,%edx
c0101501:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101506:	09 d0                	or     %edx,%eax
c0101508:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    shift ^= togglecode[data];
c010150d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101511:	0f b6 80 60 01 12 c0 	movzbl -0x3fedfea0(%eax),%eax
c0101518:	0f b6 d0             	movzbl %al,%edx
c010151b:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101520:	31 d0                	xor    %edx,%eax
c0101522:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101527:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010152c:	83 e0 03             	and    $0x3,%eax
c010152f:	8b 14 85 60 05 12 c0 	mov    -0x3fedfaa0(,%eax,4),%edx
c0101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153a:	01 d0                	add    %edx,%eax
c010153c:	0f b6 00             	movzbl (%eax),%eax
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101545:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010154a:	83 e0 08             	and    $0x8,%eax
c010154d:	85 c0                	test   %eax,%eax
c010154f:	74 22                	je     c0101573 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101551:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101555:	7e 0c                	jle    c0101563 <kbd_proc_data+0x13e>
c0101557:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155b:	7f 06                	jg     c0101563 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101561:	eb 10                	jmp    c0101573 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101563:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101567:	7e 0a                	jle    c0101573 <kbd_proc_data+0x14e>
c0101569:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156d:	7f 04                	jg     c0101573 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101573:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101578:	f7 d0                	not    %eax
c010157a:	83 e0 06             	and    $0x6,%eax
c010157d:	85 c0                	test   %eax,%eax
c010157f:	75 28                	jne    c01015a9 <kbd_proc_data+0x184>
c0101581:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101588:	75 1f                	jne    c01015a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158a:	c7 04 24 3d 8e 10 c0 	movl   $0xc0108e3d,(%esp)
c0101591:	e8 b5 ed ff ff       	call   c010034b <cprintf>
c0101596:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ac:	c9                   	leave  
c01015ad:	c3                   	ret    

c01015ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ae:	55                   	push   %ebp
c01015af:	89 e5                	mov    %esp,%ebp
c01015b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b4:	c7 04 24 25 14 10 c0 	movl   $0xc0101425,(%esp)
c01015bb:	e8 a6 fd ff ff       	call   c0101366 <cons_intr>
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <kbd_init>:

static void
kbd_init(void) {
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c8:	e8 e1 ff ff ff       	call   c01015ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d4:	e8 b2 09 00 00       	call   c0101f8b <pic_enable>
}
c01015d9:	c9                   	leave  
c01015da:	c3                   	ret    

c01015db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015db:	55                   	push   %ebp
c01015dc:	89 e5                	mov    %esp,%ebp
c01015de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e1:	e8 93 f8 ff ff       	call   c0100e79 <cga_init>
    serial_init();
c01015e6:	e8 74 f9 ff ff       	call   c0100f5f <serial_init>
    kbd_init();
c01015eb:	e8 d2 ff ff ff       	call   c01015c2 <kbd_init>
    if (!serial_exists) {
c01015f0:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c01015f5:	85 c0                	test   %eax,%eax
c01015f7:	75 0c                	jne    c0101605 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f9:	c7 04 24 49 8e 10 c0 	movl   $0xc0108e49,(%esp)
c0101600:	e8 46 ed ff ff       	call   c010034b <cprintf>
    }
}
c0101605:	c9                   	leave  
c0101606:	c3                   	ret    

c0101607 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101607:	55                   	push   %ebp
c0101608:	89 e5                	mov    %esp,%ebp
c010160a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160d:	e8 e2 f7 ff ff       	call   c0100df4 <__intr_save>
c0101612:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101615:	8b 45 08             	mov    0x8(%ebp),%eax
c0101618:	89 04 24             	mov    %eax,(%esp)
c010161b:	e8 9b fa ff ff       	call   c01010bb <lpt_putc>
        cga_putc(c);
c0101620:	8b 45 08             	mov    0x8(%ebp),%eax
c0101623:	89 04 24             	mov    %eax,(%esp)
c0101626:	e8 cf fa ff ff       	call   c01010fa <cga_putc>
        serial_putc(c);
c010162b:	8b 45 08             	mov    0x8(%ebp),%eax
c010162e:	89 04 24             	mov    %eax,(%esp)
c0101631:	e8 f1 fc ff ff       	call   c0101327 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101639:	89 04 24             	mov    %eax,(%esp)
c010163c:	e8 dd f7 ff ff       	call   c0100e1e <__intr_restore>
}
c0101641:	c9                   	leave  
c0101642:	c3                   	ret    

c0101643 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101650:	e8 9f f7 ff ff       	call   c0100df4 <__intr_save>
c0101655:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101658:	e8 ab fd ff ff       	call   c0101408 <serial_intr>
        kbd_intr();
c010165d:	e8 4c ff ff ff       	call   c01015ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101662:	8b 15 e0 10 12 c0    	mov    0xc01210e0,%edx
c0101668:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c010166d:	39 c2                	cmp    %eax,%edx
c010166f:	74 31                	je     c01016a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101671:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101676:	8d 50 01             	lea    0x1(%eax),%edx
c0101679:	89 15 e0 10 12 c0    	mov    %edx,0xc01210e0
c010167f:	0f b6 80 e0 0e 12 c0 	movzbl -0x3fedf120(%eax),%eax
c0101686:	0f b6 c0             	movzbl %al,%eax
c0101689:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168c:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101691:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101696:	75 0a                	jne    c01016a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101698:	c7 05 e0 10 12 c0 00 	movl   $0x0,0xc01210e0
c010169f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a5:	89 04 24             	mov    %eax,(%esp)
c01016a8:	e8 71 f7 ff ff       	call   c0100e1e <__intr_restore>
    return c;
c01016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
c01016b5:	83 ec 14             	sub    $0x14,%esp
c01016b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016bf:	90                   	nop
c01016c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c4:	83 c0 07             	add    $0x7,%eax
c01016c7:	0f b7 c0             	movzwl %ax,%eax
c01016ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d2:	89 c2                	mov    %eax,%edx
c01016d4:	ec                   	in     (%dx),%al
c01016d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e5:	25 80 00 00 00       	and    $0x80,%eax
c01016ea:	85 c0                	test   %eax,%eax
c01016ec:	75 d2                	jne    c01016c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f2:	74 11                	je     c0101705 <ide_wait_ready+0x53>
c01016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f7:	83 e0 21             	and    $0x21,%eax
c01016fa:	85 c0                	test   %eax,%eax
c01016fc:	74 07                	je     c0101705 <ide_wait_ready+0x53>
        return -1;
c01016fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101703:	eb 05                	jmp    c010170a <ide_wait_ready+0x58>
    }
    return 0;
c0101705:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <ide_init>:

void
ide_init(void) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	57                   	push   %edi
c0101710:	53                   	push   %ebx
c0101711:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101717:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010171d:	e9 d6 02 00 00       	jmp    c01019f8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101722:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101726:	c1 e0 03             	shl    $0x3,%eax
c0101729:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101730:	29 c2                	sub    %eax,%edx
c0101732:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101738:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010173b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010173f:	66 d1 e8             	shr    %ax
c0101742:	0f b7 c0             	movzwl %ax,%eax
c0101745:	0f b7 04 85 68 8e 10 	movzwl -0x3fef7198(,%eax,4),%eax
c010174c:	c0 
c010174d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101751:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010175c:	00 
c010175d:	89 04 24             	mov    %eax,(%esp)
c0101760:	e8 4d ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101765:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101769:	83 e0 01             	and    $0x1,%eax
c010176c:	c1 e0 04             	shl    $0x4,%eax
c010176f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101772:	0f b6 c0             	movzbl %al,%eax
c0101775:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101779:	83 c2 06             	add    $0x6,%edx
c010177c:	0f b7 d2             	movzwl %dx,%edx
c010177f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101783:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101786:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010178a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010178f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101793:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010179a:	00 
c010179b:	89 04 24             	mov    %eax,(%esp)
c010179e:	e8 0f ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a7:	83 c0 07             	add    $0x7,%eax
c01017aa:	0f b7 c0             	movzwl %ax,%eax
c01017ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017c9:	00 
c01017ca:	89 04 24             	mov    %eax,(%esp)
c01017cd:	e8 e0 fe ff ff       	call   c01016b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d6:	83 c0 07             	add    $0x7,%eax
c01017d9:	0f b7 c0             	movzwl %ax,%eax
c01017dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017e4:	89 c2                	mov    %eax,%edx
c01017e6:	ec                   	in     (%dx),%al
c01017e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ee:	84 c0                	test   %al,%al
c01017f0:	0f 84 f7 01 00 00    	je     c01019ed <ide_init+0x2e1>
c01017f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101801:	00 
c0101802:	89 04 24             	mov    %eax,(%esp)
c0101805:	e8 a8 fe ff ff       	call   c01016b2 <ide_wait_ready>
c010180a:	85 c0                	test   %eax,%eax
c010180c:	0f 85 db 01 00 00    	jne    c01019ed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101812:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101816:	c1 e0 03             	shl    $0x3,%eax
c0101819:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101820:	29 c2                	sub    %eax,%edx
c0101822:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101828:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010182f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101832:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101838:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101842:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101845:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101848:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184b:	89 cb                	mov    %ecx,%ebx
c010184d:	89 df                	mov    %ebx,%edi
c010184f:	89 c1                	mov    %eax,%ecx
c0101851:	fc                   	cld    
c0101852:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101854:	89 c8                	mov    %ecx,%eax
c0101856:	89 fb                	mov    %edi,%ebx
c0101858:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010185e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101870:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101873:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101876:	25 00 00 00 04       	and    $0x4000000,%eax
c010187b:	85 c0                	test   %eax,%eax
c010187d:	74 0e                	je     c010188d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010187f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101882:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101888:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010188b:	eb 09                	jmp    c0101896 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010188d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101890:	8b 40 78             	mov    0x78(%eax),%eax
c0101893:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101896:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010189a:	c1 e0 03             	shl    $0x3,%eax
c010189d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018a4:	29 c2                	sub    %eax,%edx
c01018a6:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b6:	c1 e0 03             	shl    $0x3,%eax
c01018b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c0:	29 c2                	sub    %eax,%edx
c01018c2:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d1:	83 c0 62             	add    $0x62,%eax
c01018d4:	0f b7 00             	movzwl (%eax),%eax
c01018d7:	0f b7 c0             	movzwl %ax,%eax
c01018da:	25 00 02 00 00       	and    $0x200,%eax
c01018df:	85 c0                	test   %eax,%eax
c01018e1:	75 24                	jne    c0101907 <ide_init+0x1fb>
c01018e3:	c7 44 24 0c 70 8e 10 	movl   $0xc0108e70,0xc(%esp)
c01018ea:	c0 
c01018eb:	c7 44 24 08 b3 8e 10 	movl   $0xc0108eb3,0x8(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018fa:	00 
c01018fb:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0101902:	e8 ce f3 ff ff       	call   c0100cd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101907:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010190b:	c1 e0 03             	shl    $0x3,%eax
c010190e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101915:	29 c2                	sub    %eax,%edx
c0101917:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c010191d:	83 c0 0c             	add    $0xc,%eax
c0101920:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101926:	83 c0 36             	add    $0x36,%eax
c0101929:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010192c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101933:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010193a:	eb 34                	jmp    c0101970 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010193c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010193f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101942:	01 c2                	add    %eax,%edx
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8d 48 01             	lea    0x1(%eax),%ecx
c010194a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010194d:	01 c8                	add    %ecx,%eax
c010194f:	0f b6 00             	movzbl (%eax),%eax
c0101952:	88 02                	mov    %al,(%edx)
c0101954:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101957:	8d 50 01             	lea    0x1(%eax),%edx
c010195a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010195d:	01 c2                	add    %eax,%edx
c010195f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101962:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101965:	01 c8                	add    %ecx,%eax
c0101967:	0f b6 00             	movzbl (%eax),%eax
c010196a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010196c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101970:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101973:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101976:	72 c4                	jb     c010193c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010197e:	01 d0                	add    %edx,%eax
c0101980:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101986:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101989:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010198c:	85 c0                	test   %eax,%eax
c010198e:	74 0f                	je     c010199f <ide_init+0x293>
c0101990:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101993:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101996:	01 d0                	add    %edx,%eax
c0101998:	0f b6 00             	movzbl (%eax),%eax
c010199b:	3c 20                	cmp    $0x20,%al
c010199d:	74 d9                	je     c0101978 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010199f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019a3:	c1 e0 03             	shl    $0x3,%eax
c01019a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ad:	29 c2                	sub    %eax,%edx
c01019af:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019b5:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019b8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019bc:	c1 e0 03             	shl    $0x3,%eax
c01019bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c6:	29 c2                	sub    %eax,%edx
c01019c8:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019ce:	8b 50 08             	mov    0x8(%eax),%edx
c01019d1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e1:	c7 04 24 da 8e 10 c0 	movl   $0xc0108eda,(%esp)
c01019e8:	e8 5e e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f1:	83 c0 01             	add    $0x1,%eax
c01019f4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019f8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019fd:	0f 86 1f fd ff ff    	jbe    c0101722 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a0a:	e8 7c 05 00 00       	call   c0101f8b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a16:	e8 70 05 00 00       	call   c0101f8b <pic_enable>
}
c0101a1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a21:	5b                   	pop    %ebx
c0101a22:	5f                   	pop    %edi
c0101a23:	5d                   	pop    %ebp
c0101a24:	c3                   	ret    

c0101a25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a25:	55                   	push   %ebp
c0101a26:	89 e5                	mov    %esp,%ebp
c0101a28:	83 ec 04             	sub    $0x4,%esp
c0101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a37:	77 24                	ja     c0101a5d <ide_device_valid+0x38>
c0101a39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3d:	c1 e0 03             	shl    $0x3,%eax
c0101a40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a47:	29 c2                	sub    %eax,%edx
c0101a49:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	84 c0                	test   %al,%al
c0101a54:	74 07                	je     c0101a5d <ide_device_valid+0x38>
c0101a56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a5b:	eb 05                	jmp    c0101a62 <ide_device_valid+0x3d>
c0101a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a62:	c9                   	leave  
c0101a63:	c3                   	ret    

c0101a64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a64:	55                   	push   %ebp
c0101a65:	89 e5                	mov    %esp,%ebp
c0101a67:	83 ec 08             	sub    $0x8,%esp
c0101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a75:	89 04 24             	mov    %eax,(%esp)
c0101a78:	e8 a8 ff ff ff       	call   c0101a25 <ide_device_valid>
c0101a7d:	85 c0                	test   %eax,%eax
c0101a7f:	74 1b                	je     c0101a9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a85:	c1 e0 03             	shl    $0x3,%eax
c0101a88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a8f:	29 c2                	sub    %eax,%edx
c0101a91:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a97:	8b 40 08             	mov    0x8(%eax),%eax
c0101a9a:	eb 05                	jmp    c0101aa1 <ide_device_size+0x3d>
    }
    return 0;
c0101a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa1:	c9                   	leave  
c0101aa2:	c3                   	ret    

c0101aa3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aa3:	55                   	push   %ebp
c0101aa4:	89 e5                	mov    %esp,%ebp
c0101aa6:	57                   	push   %edi
c0101aa7:	53                   	push   %ebx
c0101aa8:	83 ec 50             	sub    $0x50,%esp
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ab9:	77 24                	ja     c0101adf <ide_read_secs+0x3c>
c0101abb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac0:	77 1d                	ja     c0101adf <ide_read_secs+0x3c>
c0101ac2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac6:	c1 e0 03             	shl    $0x3,%eax
c0101ac9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad0:	29 c2                	sub    %eax,%edx
c0101ad2:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101ad8:	0f b6 00             	movzbl (%eax),%eax
c0101adb:	84 c0                	test   %al,%al
c0101add:	75 24                	jne    c0101b03 <ide_read_secs+0x60>
c0101adf:	c7 44 24 0c f8 8e 10 	movl   $0xc0108ef8,0xc(%esp)
c0101ae6:	c0 
c0101ae7:	c7 44 24 08 b3 8e 10 	movl   $0xc0108eb3,0x8(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af6:	00 
c0101af7:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0101afe:	e8 d2 f1 ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b0a:	77 0f                	ja     c0101b1b <ide_read_secs+0x78>
c0101b0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b12:	01 d0                	add    %edx,%eax
c0101b14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b19:	76 24                	jbe    c0101b3f <ide_read_secs+0x9c>
c0101b1b:	c7 44 24 0c 20 8f 10 	movl   $0xc0108f20,0xc(%esp)
c0101b22:	c0 
c0101b23:	c7 44 24 08 b3 8e 10 	movl   $0xc0108eb3,0x8(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b32:	00 
c0101b33:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0101b3a:	e8 96 f1 ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b43:	66 d1 e8             	shr    %ax
c0101b46:	0f b7 c0             	movzwl %ax,%eax
c0101b49:	0f b7 04 85 68 8e 10 	movzwl -0x3fef7198(,%eax,4),%eax
c0101b50:	c0 
c0101b51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b59:	66 d1 e8             	shr    %ax
c0101b5c:	0f b7 c0             	movzwl %ax,%eax
c0101b5f:	0f b7 04 85 6a 8e 10 	movzwl -0x3fef7196(,%eax,4),%eax
c0101b66:	c0 
c0101b67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b76:	00 
c0101b77:	89 04 24             	mov    %eax,(%esp)
c0101b7a:	e8 33 fb ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b83:	83 c0 02             	add    $0x2,%eax
c0101b86:	0f b7 c0             	movzwl %ax,%eax
c0101b89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b9d:	0f b6 c0             	movzbl %al,%eax
c0101ba0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ba4:	83 c2 02             	add    $0x2,%edx
c0101ba7:	0f b7 d2             	movzwl %dx,%edx
c0101baa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbd:	0f b6 c0             	movzbl %al,%eax
c0101bc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc4:	83 c2 03             	add    $0x3,%edx
c0101bc7:	0f b7 d2             	movzwl %dx,%edx
c0101bca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bdd:	c1 e8 08             	shr    $0x8,%eax
c0101be0:	0f b6 c0             	movzbl %al,%eax
c0101be3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be7:	83 c2 04             	add    $0x4,%edx
c0101bea:	0f b7 d2             	movzwl %dx,%edx
c0101bed:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c00:	c1 e8 10             	shr    $0x10,%eax
c0101c03:	0f b6 c0             	movzbl %al,%eax
c0101c06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c0a:	83 c2 05             	add    $0x5,%edx
c0101c0d:	0f b7 d2             	movzwl %dx,%edx
c0101c10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c24:	83 e0 01             	and    $0x1,%eax
c0101c27:	c1 e0 04             	shl    $0x4,%eax
c0101c2a:	89 c2                	mov    %eax,%edx
c0101c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c2f:	c1 e8 18             	shr    $0x18,%eax
c0101c32:	83 e0 0f             	and    $0xf,%eax
c0101c35:	09 d0                	or     %edx,%eax
c0101c37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c3a:	0f b6 c0             	movzbl %al,%eax
c0101c3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c41:	83 c2 06             	add    $0x6,%edx
c0101c44:	0f b7 d2             	movzwl %dx,%edx
c0101c47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c5b:	83 c0 07             	add    $0x7,%eax
c0101c5e:	0f b7 c0             	movzwl %ax,%eax
c0101c61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c79:	eb 5a                	jmp    c0101cd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c86:	00 
c0101c87:	89 04 24             	mov    %eax,(%esp)
c0101c8a:	e8 23 fa ff ff       	call   c01016b2 <ide_wait_ready>
c0101c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c96:	74 02                	je     c0101c9a <ide_read_secs+0x1f7>
            goto out;
c0101c98:	eb 41                	jmp    c0101cdb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ca4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb7:	89 cb                	mov    %ecx,%ebx
c0101cb9:	89 df                	mov    %ebx,%edi
c0101cbb:	89 c1                	mov    %eax,%ecx
c0101cbd:	fc                   	cld    
c0101cbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc0:	89 c8                	mov    %ecx,%eax
c0101cc2:	89 fb                	mov    %edi,%ebx
c0101cc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cd9:	75 a0                	jne    c0101c7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cde:	83 c4 50             	add    $0x50,%esp
c0101ce1:	5b                   	pop    %ebx
c0101ce2:	5f                   	pop    %edi
c0101ce3:	5d                   	pop    %ebp
c0101ce4:	c3                   	ret    

c0101ce5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ce5:	55                   	push   %ebp
c0101ce6:	89 e5                	mov    %esp,%ebp
c0101ce8:	56                   	push   %esi
c0101ce9:	53                   	push   %ebx
c0101cea:	83 ec 50             	sub    $0x50,%esp
c0101ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cf4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cfb:	77 24                	ja     c0101d21 <ide_write_secs+0x3c>
c0101cfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d02:	77 1d                	ja     c0101d21 <ide_write_secs+0x3c>
c0101d04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d08:	c1 e0 03             	shl    $0x3,%eax
c0101d0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d12:	29 c2                	sub    %eax,%edx
c0101d14:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101d1a:	0f b6 00             	movzbl (%eax),%eax
c0101d1d:	84 c0                	test   %al,%al
c0101d1f:	75 24                	jne    c0101d45 <ide_write_secs+0x60>
c0101d21:	c7 44 24 0c f8 8e 10 	movl   $0xc0108ef8,0xc(%esp)
c0101d28:	c0 
c0101d29:	c7 44 24 08 b3 8e 10 	movl   $0xc0108eb3,0x8(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d38:	00 
c0101d39:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0101d40:	e8 90 ef ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d4c:	77 0f                	ja     c0101d5d <ide_write_secs+0x78>
c0101d4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d54:	01 d0                	add    %edx,%eax
c0101d56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d5b:	76 24                	jbe    c0101d81 <ide_write_secs+0x9c>
c0101d5d:	c7 44 24 0c 20 8f 10 	movl   $0xc0108f20,0xc(%esp)
c0101d64:	c0 
c0101d65:	c7 44 24 08 b3 8e 10 	movl   $0xc0108eb3,0x8(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d74:	00 
c0101d75:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0101d7c:	e8 54 ef ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d85:	66 d1 e8             	shr    %ax
c0101d88:	0f b7 c0             	movzwl %ax,%eax
c0101d8b:	0f b7 04 85 68 8e 10 	movzwl -0x3fef7198(,%eax,4),%eax
c0101d92:	c0 
c0101d93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d9b:	66 d1 e8             	shr    %ax
c0101d9e:	0f b7 c0             	movzwl %ax,%eax
c0101da1:	0f b7 04 85 6a 8e 10 	movzwl -0x3fef7196(,%eax,4),%eax
c0101da8:	c0 
c0101da9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101db8:	00 
c0101db9:	89 04 24             	mov    %eax,(%esp)
c0101dbc:	e8 f1 f8 ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dc5:	83 c0 02             	add    $0x2,%eax
c0101dc8:	0f b7 c0             	movzwl %ax,%eax
c0101dcb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dcf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dd3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ddb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ddc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ddf:	0f b6 c0             	movzbl %al,%eax
c0101de2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de6:	83 c2 02             	add    $0x2,%edx
c0101de9:	0f b7 d2             	movzwl %dx,%edx
c0101dec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101df3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101dfb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101dff:	0f b6 c0             	movzbl %al,%eax
c0101e02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e06:	83 c2 03             	add    $0x3,%edx
c0101e09:	0f b7 d2             	movzwl %dx,%edx
c0101e0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1f:	c1 e8 08             	shr    $0x8,%eax
c0101e22:	0f b6 c0             	movzbl %al,%eax
c0101e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e29:	83 c2 04             	add    $0x4,%edx
c0101e2c:	0f b7 d2             	movzwl %dx,%edx
c0101e2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e42:	c1 e8 10             	shr    $0x10,%eax
c0101e45:	0f b6 c0             	movzbl %al,%eax
c0101e48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4c:	83 c2 05             	add    $0x5,%edx
c0101e4f:	0f b7 d2             	movzwl %dx,%edx
c0101e52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e66:	83 e0 01             	and    $0x1,%eax
c0101e69:	c1 e0 04             	shl    $0x4,%eax
c0101e6c:	89 c2                	mov    %eax,%edx
c0101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e71:	c1 e8 18             	shr    $0x18,%eax
c0101e74:	83 e0 0f             	and    $0xf,%eax
c0101e77:	09 d0                	or     %edx,%eax
c0101e79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e7c:	0f b6 c0             	movzbl %al,%eax
c0101e7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e83:	83 c2 06             	add    $0x6,%edx
c0101e86:	0f b7 d2             	movzwl %dx,%edx
c0101e89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e9d:	83 c0 07             	add    $0x7,%eax
c0101ea0:	0f b7 c0             	movzwl %ax,%eax
c0101ea3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eaf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ebb:	eb 5a                	jmp    c0101f17 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ebd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ec8:	00 
c0101ec9:	89 04 24             	mov    %eax,(%esp)
c0101ecc:	e8 e1 f7 ff ff       	call   c01016b2 <ide_wait_ready>
c0101ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ed8:	74 02                	je     c0101edc <ide_write_secs+0x1f7>
            goto out;
c0101eda:	eb 41                	jmp    c0101f1d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101edc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ee3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ee9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ef3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ef9:	89 cb                	mov    %ecx,%ebx
c0101efb:	89 de                	mov    %ebx,%esi
c0101efd:	89 c1                	mov    %eax,%ecx
c0101eff:	fc                   	cld    
c0101f00:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f02:	89 c8                	mov    %ecx,%eax
c0101f04:	89 f3                	mov    %esi,%ebx
c0101f06:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f09:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f0c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f10:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f17:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f1b:	75 a0                	jne    c0101ebd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f20:	83 c4 50             	add    $0x50,%esp
c0101f23:	5b                   	pop    %ebx
c0101f24:	5e                   	pop    %esi
c0101f25:	5d                   	pop    %ebp
c0101f26:	c3                   	ret    

c0101f27 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f27:	55                   	push   %ebp
c0101f28:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f2a:	fb                   	sti    
    sti();
}
c0101f2b:	5d                   	pop    %ebp
c0101f2c:	c3                   	ret    

c0101f2d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f2d:	55                   	push   %ebp
c0101f2e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f30:	fa                   	cli    
    cli();
}
c0101f31:	5d                   	pop    %ebp
c0101f32:	c3                   	ret    

c0101f33 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f33:	55                   	push   %ebp
c0101f34:	89 e5                	mov    %esp,%ebp
c0101f36:	83 ec 14             	sub    $0x14,%esp
c0101f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f40:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f44:	66 a3 70 05 12 c0    	mov    %ax,0xc0120570
    if (did_init) {
c0101f4a:	a1 e0 11 12 c0       	mov    0xc01211e0,%eax
c0101f4f:	85 c0                	test   %eax,%eax
c0101f51:	74 36                	je     c0101f89 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f53:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f57:	0f b6 c0             	movzbl %al,%eax
c0101f5a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f60:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f63:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f67:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f6b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f6c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f70:	66 c1 e8 08          	shr    $0x8,%ax
c0101f74:	0f b6 c0             	movzbl %al,%eax
c0101f77:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f7d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f80:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f84:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
    }
}
c0101f89:	c9                   	leave  
c0101f8a:	c3                   	ret    

c0101f8b <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f8b:	55                   	push   %ebp
c0101f8c:	89 e5                	mov    %esp,%ebp
c0101f8e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f94:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f99:	89 c1                	mov    %eax,%ecx
c0101f9b:	d3 e2                	shl    %cl,%edx
c0101f9d:	89 d0                	mov    %edx,%eax
c0101f9f:	f7 d0                	not    %eax
c0101fa1:	89 c2                	mov    %eax,%edx
c0101fa3:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0101faa:	21 d0                	and    %edx,%eax
c0101fac:	0f b7 c0             	movzwl %ax,%eax
c0101faf:	89 04 24             	mov    %eax,(%esp)
c0101fb2:	e8 7c ff ff ff       	call   c0101f33 <pic_setmask>
}
c0101fb7:	c9                   	leave  
c0101fb8:	c3                   	ret    

c0101fb9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fb9:	55                   	push   %ebp
c0101fba:	89 e5                	mov    %esp,%ebp
c0101fbc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fbf:	c7 05 e0 11 12 c0 01 	movl   $0x1,0xc01211e0
c0101fc6:	00 00 00 
c0101fc9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fcf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fd3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fdb:	ee                   	out    %al,(%dx)
c0101fdc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fee:	ee                   	out    %al,(%dx)
c0101fef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ff5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ff9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ffd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102001:	ee                   	out    %al,(%dx)
c0102002:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102008:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010200c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102010:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102014:	ee                   	out    %al,(%dx)
c0102015:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010201b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010201f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102023:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102027:	ee                   	out    %al,(%dx)
c0102028:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010202e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102032:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102036:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010203a:	ee                   	out    %al,(%dx)
c010203b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102041:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102045:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102049:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010204d:	ee                   	out    %al,(%dx)
c010204e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102054:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102058:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010205c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102060:	ee                   	out    %al,(%dx)
c0102061:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102067:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010206b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010206f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102073:	ee                   	out    %al,(%dx)
c0102074:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010207a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010207e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102082:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102086:	ee                   	out    %al,(%dx)
c0102087:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010208d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102091:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102095:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102099:	ee                   	out    %al,(%dx)
c010209a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020ac:	ee                   	out    %al,(%dx)
c01020ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020bf:	ee                   	out    %al,(%dx)
c01020c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020d3:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020de:	74 12                	je     c01020f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e0:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020e7:	0f b7 c0             	movzwl %ax,%eax
c01020ea:	89 04 24             	mov    %eax,(%esp)
c01020ed:	e8 41 fe ff ff       	call   c0101f33 <pic_setmask>
    }
}
c01020f2:	c9                   	leave  
c01020f3:	c3                   	ret    

c01020f4 <print_ticks>:
#include <swap.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
c01020f4:	55                   	push   %ebp
c01020f5:	89 e5                	mov    %esp,%ebp
c01020f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102101:	00 
c0102102:	c7 04 24 60 8f 10 c0 	movl   $0xc0108f60,(%esp)
c0102109:	e8 3d e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010210e:	c9                   	leave  
c010210f:	c3                   	ret    

c0102110 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102110:	55                   	push   %ebp
c0102111:	89 e5                	mov    %esp,%ebp
c0102113:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010211d:	e9 c3 00 00 00       	jmp    c01021e5 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102122:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102125:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c010212c:	89 c2                	mov    %eax,%edx
c010212e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102131:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c0102138:	c0 
c0102139:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213c:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c0102143:	c0 08 00 
c0102146:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102149:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102150:	c0 
c0102151:	83 e2 e0             	and    $0xffffffe0,%edx
c0102154:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c010215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215e:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102165:	c0 
c0102166:	83 e2 1f             	and    $0x1f,%edx
c0102169:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102173:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c010217a:	c0 
c010217b:	83 e2 f0             	and    $0xfffffff0,%edx
c010217e:	83 ca 0e             	or     $0xe,%edx
c0102181:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102192:	c0 
c0102193:	83 e2 ef             	and    $0xffffffef,%edx
c0102196:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 e2 9f             	and    $0xffffff9f,%edx
c01021ab:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b5:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021bc:	c0 
c01021bd:	83 ca 80             	or     $0xffffff80,%edx
c01021c0:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ca:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01021d1:	c1 e8 10             	shr    $0x10,%eax
c01021d4:	89 c2                	mov    %eax,%edx
c01021d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d9:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c01021e0:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e8:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021ed:	0f 86 2f ff ff ff    	jbe    c0102122 <idt_init+0x12>
c01021f3:	c7 45 f8 80 05 12 c0 	movl   $0xc0120580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01021fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021fd:	0f 01 18             	lidtl  (%eax)
    }
	// set for switch from user to kernel
   // SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
	// load the IDT
    lidt(&idt_pd);
}
c0102200:	c9                   	leave  
c0102201:	c3                   	ret    

c0102202 <trapname>:

static const char *
trapname(int trapno) {
c0102202:	55                   	push   %ebp
c0102203:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102205:	8b 45 08             	mov    0x8(%ebp),%eax
c0102208:	83 f8 13             	cmp    $0x13,%eax
c010220b:	77 0c                	ja     c0102219 <trapname+0x17>
        return excnames[trapno];
c010220d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102210:	8b 04 85 40 93 10 c0 	mov    -0x3fef6cc0(,%eax,4),%eax
c0102217:	eb 18                	jmp    c0102231 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102219:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010221d:	7e 0d                	jle    c010222c <trapname+0x2a>
c010221f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102223:	7f 07                	jg     c010222c <trapname+0x2a>
        return "Hardware Interrupt";
c0102225:	b8 6a 8f 10 c0       	mov    $0xc0108f6a,%eax
c010222a:	eb 05                	jmp    c0102231 <trapname+0x2f>
    }
    return "(unknown trap)";
c010222c:	b8 7d 8f 10 c0       	mov    $0xc0108f7d,%eax
}
c0102231:	5d                   	pop    %ebp
c0102232:	c3                   	ret    

c0102233 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102233:	55                   	push   %ebp
c0102234:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102236:	8b 45 08             	mov    0x8(%ebp),%eax
c0102239:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010223d:	66 83 f8 08          	cmp    $0x8,%ax
c0102241:	0f 94 c0             	sete   %al
c0102244:	0f b6 c0             	movzbl %al,%eax
}
c0102247:	5d                   	pop    %ebp
c0102248:	c3                   	ret    

c0102249 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102249:	55                   	push   %ebp
c010224a:	89 e5                	mov    %esp,%ebp
c010224c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010224f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102252:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102256:	c7 04 24 be 8f 10 c0 	movl   $0xc0108fbe,(%esp)
c010225d:	e8 e9 e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c0102262:	8b 45 08             	mov    0x8(%ebp),%eax
c0102265:	89 04 24             	mov    %eax,(%esp)
c0102268:	e8 a1 01 00 00       	call   c010240e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010226d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102270:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102274:	0f b7 c0             	movzwl %ax,%eax
c0102277:	89 44 24 04          	mov    %eax,0x4(%esp)
c010227b:	c7 04 24 cf 8f 10 c0 	movl   $0xc0108fcf,(%esp)
c0102282:	e8 c4 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102287:	8b 45 08             	mov    0x8(%ebp),%eax
c010228a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010228e:	0f b7 c0             	movzwl %ax,%eax
c0102291:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102295:	c7 04 24 e2 8f 10 c0 	movl   $0xc0108fe2,(%esp)
c010229c:	e8 aa e0 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022a8:	0f b7 c0             	movzwl %ax,%eax
c01022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022af:	c7 04 24 f5 8f 10 c0 	movl   $0xc0108ff5,(%esp)
c01022b6:	e8 90 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01022be:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022c2:	0f b7 c0             	movzwl %ax,%eax
c01022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022c9:	c7 04 24 08 90 10 c0 	movl   $0xc0109008,(%esp)
c01022d0:	e8 76 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d8:	8b 40 30             	mov    0x30(%eax),%eax
c01022db:	89 04 24             	mov    %eax,(%esp)
c01022de:	e8 1f ff ff ff       	call   c0102202 <trapname>
c01022e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01022e6:	8b 52 30             	mov    0x30(%edx),%edx
c01022e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01022ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01022f1:	c7 04 24 1b 90 10 c0 	movl   $0xc010901b,(%esp)
c01022f8:	e8 4e e0 ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01022fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102300:	8b 40 34             	mov    0x34(%eax),%eax
c0102303:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102307:	c7 04 24 2d 90 10 c0 	movl   $0xc010902d,(%esp)
c010230e:	e8 38 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102313:	8b 45 08             	mov    0x8(%ebp),%eax
c0102316:	8b 40 38             	mov    0x38(%eax),%eax
c0102319:	89 44 24 04          	mov    %eax,0x4(%esp)
c010231d:	c7 04 24 3c 90 10 c0 	movl   $0xc010903c,(%esp)
c0102324:	e8 22 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102329:	8b 45 08             	mov    0x8(%ebp),%eax
c010232c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102330:	0f b7 c0             	movzwl %ax,%eax
c0102333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102337:	c7 04 24 4b 90 10 c0 	movl   $0xc010904b,(%esp)
c010233e:	e8 08 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102343:	8b 45 08             	mov    0x8(%ebp),%eax
c0102346:	8b 40 40             	mov    0x40(%eax),%eax
c0102349:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234d:	c7 04 24 5e 90 10 c0 	movl   $0xc010905e,(%esp)
c0102354:	e8 f2 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102367:	eb 3e                	jmp    c01023a7 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102369:	8b 45 08             	mov    0x8(%ebp),%eax
c010236c:	8b 50 40             	mov    0x40(%eax),%edx
c010236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102372:	21 d0                	and    %edx,%eax
c0102374:	85 c0                	test   %eax,%eax
c0102376:	74 28                	je     c01023a0 <print_trapframe+0x157>
c0102378:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010237b:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c0102382:	85 c0                	test   %eax,%eax
c0102384:	74 1a                	je     c01023a0 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102389:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c0102390:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102394:	c7 04 24 6d 90 10 c0 	movl   $0xc010906d,(%esp)
c010239b:	e8 ab df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023a4:	d1 65 f0             	shll   -0x10(%ebp)
c01023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023aa:	83 f8 17             	cmp    $0x17,%eax
c01023ad:	76 ba                	jbe    c0102369 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	8b 40 40             	mov    0x40(%eax),%eax
c01023b5:	25 00 30 00 00       	and    $0x3000,%eax
c01023ba:	c1 e8 0c             	shr    $0xc,%eax
c01023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c1:	c7 04 24 71 90 10 c0 	movl   $0xc0109071,(%esp)
c01023c8:	e8 7e df ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c01023cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d0:	89 04 24             	mov    %eax,(%esp)
c01023d3:	e8 5b fe ff ff       	call   c0102233 <trap_in_kernel>
c01023d8:	85 c0                	test   %eax,%eax
c01023da:	75 30                	jne    c010240c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023df:	8b 40 44             	mov    0x44(%eax),%eax
c01023e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e6:	c7 04 24 7a 90 10 c0 	movl   $0xc010907a,(%esp)
c01023ed:	e8 59 df ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01023f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01023f9:	0f b7 c0             	movzwl %ax,%eax
c01023fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102400:	c7 04 24 89 90 10 c0 	movl   $0xc0109089,(%esp)
c0102407:	e8 3f df ff ff       	call   c010034b <cprintf>
    }
}
c010240c:	c9                   	leave  
c010240d:	c3                   	ret    

c010240e <print_regs>:

void
print_regs(struct pushregs *regs) {
c010240e:	55                   	push   %ebp
c010240f:	89 e5                	mov    %esp,%ebp
c0102411:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102414:	8b 45 08             	mov    0x8(%ebp),%eax
c0102417:	8b 00                	mov    (%eax),%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 9c 90 10 c0 	movl   $0xc010909c,(%esp)
c0102424:	e8 22 df ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102429:	8b 45 08             	mov    0x8(%ebp),%eax
c010242c:	8b 40 04             	mov    0x4(%eax),%eax
c010242f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102433:	c7 04 24 ab 90 10 c0 	movl   $0xc01090ab,(%esp)
c010243a:	e8 0c df ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010243f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102442:	8b 40 08             	mov    0x8(%eax),%eax
c0102445:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102449:	c7 04 24 ba 90 10 c0 	movl   $0xc01090ba,(%esp)
c0102450:	e8 f6 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102455:	8b 45 08             	mov    0x8(%ebp),%eax
c0102458:	8b 40 0c             	mov    0xc(%eax),%eax
c010245b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010245f:	c7 04 24 c9 90 10 c0 	movl   $0xc01090c9,(%esp)
c0102466:	e8 e0 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010246b:	8b 45 08             	mov    0x8(%ebp),%eax
c010246e:	8b 40 10             	mov    0x10(%eax),%eax
c0102471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102475:	c7 04 24 d8 90 10 c0 	movl   $0xc01090d8,(%esp)
c010247c:	e8 ca de ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102481:	8b 45 08             	mov    0x8(%ebp),%eax
c0102484:	8b 40 14             	mov    0x14(%eax),%eax
c0102487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248b:	c7 04 24 e7 90 10 c0 	movl   $0xc01090e7,(%esp)
c0102492:	e8 b4 de ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102497:	8b 45 08             	mov    0x8(%ebp),%eax
c010249a:	8b 40 18             	mov    0x18(%eax),%eax
c010249d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a1:	c7 04 24 f6 90 10 c0 	movl   $0xc01090f6,(%esp)
c01024a8:	e8 9e de ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b7:	c7 04 24 05 91 10 c0 	movl   $0xc0109105,(%esp)
c01024be:	e8 88 de ff ff       	call   c010034b <cprintf>
}
c01024c3:	c9                   	leave  
c01024c4:	c3                   	ret    

c01024c5 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024c5:	55                   	push   %ebp
c01024c6:	89 e5                	mov    %esp,%ebp
c01024c8:	53                   	push   %ebx
c01024c9:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cf:	8b 40 34             	mov    0x34(%eax),%eax
c01024d2:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024d5:	85 c0                	test   %eax,%eax
c01024d7:	74 07                	je     c01024e0 <print_pgfault+0x1b>
c01024d9:	b9 14 91 10 c0       	mov    $0xc0109114,%ecx
c01024de:	eb 05                	jmp    c01024e5 <print_pgfault+0x20>
c01024e0:	b9 25 91 10 c0       	mov    $0xc0109125,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 34             	mov    0x34(%eax),%eax
c01024eb:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024ee:	85 c0                	test   %eax,%eax
c01024f0:	74 07                	je     c01024f9 <print_pgfault+0x34>
c01024f2:	ba 57 00 00 00       	mov    $0x57,%edx
c01024f7:	eb 05                	jmp    c01024fe <print_pgfault+0x39>
c01024f9:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01024fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102501:	8b 40 34             	mov    0x34(%eax),%eax
c0102504:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102507:	85 c0                	test   %eax,%eax
c0102509:	74 07                	je     c0102512 <print_pgfault+0x4d>
c010250b:	b8 55 00 00 00       	mov    $0x55,%eax
c0102510:	eb 05                	jmp    c0102517 <print_pgfault+0x52>
c0102512:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102517:	0f 20 d3             	mov    %cr2,%ebx
c010251a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010251d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102520:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102524:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102528:	89 44 24 08          	mov    %eax,0x8(%esp)
c010252c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102530:	c7 04 24 34 91 10 c0 	movl   $0xc0109134,(%esp)
c0102537:	e8 0f de ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010253c:	83 c4 34             	add    $0x34,%esp
c010253f:	5b                   	pop    %ebx
c0102540:	5d                   	pop    %ebp
c0102541:	c3                   	ret    

c0102542 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102542:	55                   	push   %ebp
c0102543:	89 e5                	mov    %esp,%ebp
c0102545:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102548:	8b 45 08             	mov    0x8(%ebp),%eax
c010254b:	89 04 24             	mov    %eax,(%esp)
c010254e:	e8 72 ff ff ff       	call   c01024c5 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102553:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0102558:	85 c0                	test   %eax,%eax
c010255a:	74 28                	je     c0102584 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010255c:	0f 20 d0             	mov    %cr2,%eax
c010255f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102562:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102565:	89 c1                	mov    %eax,%ecx
c0102567:	8b 45 08             	mov    0x8(%ebp),%eax
c010256a:	8b 50 34             	mov    0x34(%eax),%edx
c010256d:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0102572:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102576:	89 54 24 04          	mov    %edx,0x4(%esp)
c010257a:	89 04 24             	mov    %eax,(%esp)
c010257d:	e8 d7 55 00 00       	call   c0107b59 <do_pgfault>
c0102582:	eb 1c                	jmp    c01025a0 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102584:	c7 44 24 08 57 91 10 	movl   $0xc0109157,0x8(%esp)
c010258b:	c0 
c010258c:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102593:	00 
c0102594:	c7 04 24 6e 91 10 c0 	movl   $0xc010916e,(%esp)
c010259b:	e8 35 e7 ff ff       	call   c0100cd5 <__panic>
}
c01025a0:	c9                   	leave  
c01025a1:	c3                   	ret    

c01025a2 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025a2:	55                   	push   %ebp
c01025a3:	89 e5                	mov    %esp,%ebp
c01025a5:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ab:	8b 40 30             	mov    0x30(%eax),%eax
c01025ae:	83 f8 24             	cmp    $0x24,%eax
c01025b1:	0f 84 c2 00 00 00    	je     c0102679 <trap_dispatch+0xd7>
c01025b7:	83 f8 24             	cmp    $0x24,%eax
c01025ba:	77 18                	ja     c01025d4 <trap_dispatch+0x32>
c01025bc:	83 f8 20             	cmp    $0x20,%eax
c01025bf:	74 7d                	je     c010263e <trap_dispatch+0x9c>
c01025c1:	83 f8 21             	cmp    $0x21,%eax
c01025c4:	0f 84 d5 00 00 00    	je     c010269f <trap_dispatch+0xfd>
c01025ca:	83 f8 0e             	cmp    $0xe,%eax
c01025cd:	74 28                	je     c01025f7 <trap_dispatch+0x55>
c01025cf:	e9 0d 01 00 00       	jmp    c01026e1 <trap_dispatch+0x13f>
c01025d4:	83 f8 2e             	cmp    $0x2e,%eax
c01025d7:	0f 82 04 01 00 00    	jb     c01026e1 <trap_dispatch+0x13f>
c01025dd:	83 f8 2f             	cmp    $0x2f,%eax
c01025e0:	0f 86 33 01 00 00    	jbe    c0102719 <trap_dispatch+0x177>
c01025e6:	83 e8 78             	sub    $0x78,%eax
c01025e9:	83 f8 01             	cmp    $0x1,%eax
c01025ec:	0f 87 ef 00 00 00    	ja     c01026e1 <trap_dispatch+0x13f>
c01025f2:	e9 ce 00 00 00       	jmp    c01026c5 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	89 04 24             	mov    %eax,(%esp)
c01025fd:	e8 40 ff ff ff       	call   c0102542 <pgfault_handler>
c0102602:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102609:	74 2e                	je     c0102639 <trap_dispatch+0x97>
            print_trapframe(tf);
c010260b:	8b 45 08             	mov    0x8(%ebp),%eax
c010260e:	89 04 24             	mov    %eax,(%esp)
c0102611:	e8 33 fc ff ff       	call   c0102249 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102616:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102619:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010261d:	c7 44 24 08 7f 91 10 	movl   $0xc010917f,0x8(%esp)
c0102624:	c0 
c0102625:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c010262c:	00 
c010262d:	c7 04 24 6e 91 10 c0 	movl   $0xc010916e,(%esp)
c0102634:	e8 9c e6 ff ff       	call   c0100cd5 <__panic>
        }
        break;
c0102639:	e9 dc 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c010263e:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c0102643:	83 c0 01             	add    $0x1,%eax
c0102646:	a3 bc 1a 12 c0       	mov    %eax,0xc0121abc
        if (ticks % TICK_NUM == 0) {
c010264b:	8b 0d bc 1a 12 c0    	mov    0xc0121abc,%ecx
c0102651:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102656:	89 c8                	mov    %ecx,%eax
c0102658:	f7 e2                	mul    %edx
c010265a:	89 d0                	mov    %edx,%eax
c010265c:	c1 e8 05             	shr    $0x5,%eax
c010265f:	6b c0 64             	imul   $0x64,%eax,%eax
c0102662:	29 c1                	sub    %eax,%ecx
c0102664:	89 c8                	mov    %ecx,%eax
c0102666:	85 c0                	test   %eax,%eax
c0102668:	75 0a                	jne    c0102674 <trap_dispatch+0xd2>
            print_ticks();
c010266a:	e8 85 fa ff ff       	call   c01020f4 <print_ticks>
        }
        break;
c010266f:	e9 a6 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
c0102674:	e9 a1 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102679:	e8 c5 ef ff ff       	call   c0101643 <cons_getc>
c010267e:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102681:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102685:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102689:	89 54 24 08          	mov    %edx,0x8(%esp)
c010268d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102691:	c7 04 24 9a 91 10 c0 	movl   $0xc010919a,(%esp)
c0102698:	e8 ae dc ff ff       	call   c010034b <cprintf>
        break;
c010269d:	eb 7b                	jmp    c010271a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010269f:	e8 9f ef ff ff       	call   c0101643 <cons_getc>
c01026a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026a7:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026ab:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026af:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026b7:	c7 04 24 ac 91 10 c0 	movl   $0xc01091ac,(%esp)
c01026be:	e8 88 dc ff ff       	call   c010034b <cprintf>
        break;
c01026c3:	eb 55                	jmp    c010271a <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026c5:	c7 44 24 08 bb 91 10 	movl   $0xc01091bb,0x8(%esp)
c01026cc:	c0 
c01026cd:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01026d4:	00 
c01026d5:	c7 04 24 6e 91 10 c0 	movl   $0xc010916e,(%esp)
c01026dc:	e8 f4 e5 ff ff       	call   c0100cd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01026e8:	0f b7 c0             	movzwl %ax,%eax
c01026eb:	83 e0 03             	and    $0x3,%eax
c01026ee:	85 c0                	test   %eax,%eax
c01026f0:	75 28                	jne    c010271a <trap_dispatch+0x178>
            print_trapframe(tf);
c01026f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f5:	89 04 24             	mov    %eax,(%esp)
c01026f8:	e8 4c fb ff ff       	call   c0102249 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01026fd:	c7 44 24 08 cb 91 10 	movl   $0xc01091cb,0x8(%esp)
c0102704:	c0 
c0102705:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010270c:	00 
c010270d:	c7 04 24 6e 91 10 c0 	movl   $0xc010916e,(%esp)
c0102714:	e8 bc e5 ff ff       	call   c0100cd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102719:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010271a:	c9                   	leave  
c010271b:	c3                   	ret    

c010271c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010271c:	55                   	push   %ebp
c010271d:	89 e5                	mov    %esp,%ebp
c010271f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102722:	8b 45 08             	mov    0x8(%ebp),%eax
c0102725:	89 04 24             	mov    %eax,(%esp)
c0102728:	e8 75 fe ff ff       	call   c01025a2 <trap_dispatch>
}
c010272d:	c9                   	leave  
c010272e:	c3                   	ret    

c010272f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010272f:	1e                   	push   %ds
    pushl %es
c0102730:	06                   	push   %es
    pushl %fs
c0102731:	0f a0                	push   %fs
    pushl %gs
c0102733:	0f a8                	push   %gs
    pushal
c0102735:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102736:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010273b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010273d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010273f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102740:	e8 d7 ff ff ff       	call   c010271c <trap>

    # pop the pushed stack pointer
    popl %esp
c0102745:	5c                   	pop    %esp

c0102746 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102746:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102747:	0f a9                	pop    %gs
    popl %fs
c0102749:	0f a1                	pop    %fs
    popl %es
c010274b:	07                   	pop    %es
    popl %ds
c010274c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010274d:	83 c4 08             	add    $0x8,%esp
    iret
c0102750:	cf                   	iret   

c0102751 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $0
c0102753:	6a 00                	push   $0x0
  jmp __alltraps
c0102755:	e9 d5 ff ff ff       	jmp    c010272f <__alltraps>

c010275a <vector1>:
.globl vector1
vector1:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $1
c010275c:	6a 01                	push   $0x1
  jmp __alltraps
c010275e:	e9 cc ff ff ff       	jmp    c010272f <__alltraps>

c0102763 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $2
c0102765:	6a 02                	push   $0x2
  jmp __alltraps
c0102767:	e9 c3 ff ff ff       	jmp    c010272f <__alltraps>

c010276c <vector3>:
.globl vector3
vector3:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $3
c010276e:	6a 03                	push   $0x3
  jmp __alltraps
c0102770:	e9 ba ff ff ff       	jmp    c010272f <__alltraps>

c0102775 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $4
c0102777:	6a 04                	push   $0x4
  jmp __alltraps
c0102779:	e9 b1 ff ff ff       	jmp    c010272f <__alltraps>

c010277e <vector5>:
.globl vector5
vector5:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $5
c0102780:	6a 05                	push   $0x5
  jmp __alltraps
c0102782:	e9 a8 ff ff ff       	jmp    c010272f <__alltraps>

c0102787 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $6
c0102789:	6a 06                	push   $0x6
  jmp __alltraps
c010278b:	e9 9f ff ff ff       	jmp    c010272f <__alltraps>

c0102790 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $7
c0102792:	6a 07                	push   $0x7
  jmp __alltraps
c0102794:	e9 96 ff ff ff       	jmp    c010272f <__alltraps>

c0102799 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102799:	6a 08                	push   $0x8
  jmp __alltraps
c010279b:	e9 8f ff ff ff       	jmp    c010272f <__alltraps>

c01027a0 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027a0:	6a 09                	push   $0x9
  jmp __alltraps
c01027a2:	e9 88 ff ff ff       	jmp    c010272f <__alltraps>

c01027a7 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027a7:	6a 0a                	push   $0xa
  jmp __alltraps
c01027a9:	e9 81 ff ff ff       	jmp    c010272f <__alltraps>

c01027ae <vector11>:
.globl vector11
vector11:
  pushl $11
c01027ae:	6a 0b                	push   $0xb
  jmp __alltraps
c01027b0:	e9 7a ff ff ff       	jmp    c010272f <__alltraps>

c01027b5 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027b5:	6a 0c                	push   $0xc
  jmp __alltraps
c01027b7:	e9 73 ff ff ff       	jmp    c010272f <__alltraps>

c01027bc <vector13>:
.globl vector13
vector13:
  pushl $13
c01027bc:	6a 0d                	push   $0xd
  jmp __alltraps
c01027be:	e9 6c ff ff ff       	jmp    c010272f <__alltraps>

c01027c3 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027c3:	6a 0e                	push   $0xe
  jmp __alltraps
c01027c5:	e9 65 ff ff ff       	jmp    c010272f <__alltraps>

c01027ca <vector15>:
.globl vector15
vector15:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $15
c01027cc:	6a 0f                	push   $0xf
  jmp __alltraps
c01027ce:	e9 5c ff ff ff       	jmp    c010272f <__alltraps>

c01027d3 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $16
c01027d5:	6a 10                	push   $0x10
  jmp __alltraps
c01027d7:	e9 53 ff ff ff       	jmp    c010272f <__alltraps>

c01027dc <vector17>:
.globl vector17
vector17:
  pushl $17
c01027dc:	6a 11                	push   $0x11
  jmp __alltraps
c01027de:	e9 4c ff ff ff       	jmp    c010272f <__alltraps>

c01027e3 <vector18>:
.globl vector18
vector18:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $18
c01027e5:	6a 12                	push   $0x12
  jmp __alltraps
c01027e7:	e9 43 ff ff ff       	jmp    c010272f <__alltraps>

c01027ec <vector19>:
.globl vector19
vector19:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $19
c01027ee:	6a 13                	push   $0x13
  jmp __alltraps
c01027f0:	e9 3a ff ff ff       	jmp    c010272f <__alltraps>

c01027f5 <vector20>:
.globl vector20
vector20:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $20
c01027f7:	6a 14                	push   $0x14
  jmp __alltraps
c01027f9:	e9 31 ff ff ff       	jmp    c010272f <__alltraps>

c01027fe <vector21>:
.globl vector21
vector21:
  pushl $0
c01027fe:	6a 00                	push   $0x0
  pushl $21
c0102800:	6a 15                	push   $0x15
  jmp __alltraps
c0102802:	e9 28 ff ff ff       	jmp    c010272f <__alltraps>

c0102807 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $22
c0102809:	6a 16                	push   $0x16
  jmp __alltraps
c010280b:	e9 1f ff ff ff       	jmp    c010272f <__alltraps>

c0102810 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $23
c0102812:	6a 17                	push   $0x17
  jmp __alltraps
c0102814:	e9 16 ff ff ff       	jmp    c010272f <__alltraps>

c0102819 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $24
c010281b:	6a 18                	push   $0x18
  jmp __alltraps
c010281d:	e9 0d ff ff ff       	jmp    c010272f <__alltraps>

c0102822 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102822:	6a 00                	push   $0x0
  pushl $25
c0102824:	6a 19                	push   $0x19
  jmp __alltraps
c0102826:	e9 04 ff ff ff       	jmp    c010272f <__alltraps>

c010282b <vector26>:
.globl vector26
vector26:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $26
c010282d:	6a 1a                	push   $0x1a
  jmp __alltraps
c010282f:	e9 fb fe ff ff       	jmp    c010272f <__alltraps>

c0102834 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $27
c0102836:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102838:	e9 f2 fe ff ff       	jmp    c010272f <__alltraps>

c010283d <vector28>:
.globl vector28
vector28:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $28
c010283f:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102841:	e9 e9 fe ff ff       	jmp    c010272f <__alltraps>

c0102846 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102846:	6a 00                	push   $0x0
  pushl $29
c0102848:	6a 1d                	push   $0x1d
  jmp __alltraps
c010284a:	e9 e0 fe ff ff       	jmp    c010272f <__alltraps>

c010284f <vector30>:
.globl vector30
vector30:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $30
c0102851:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102853:	e9 d7 fe ff ff       	jmp    c010272f <__alltraps>

c0102858 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $31
c010285a:	6a 1f                	push   $0x1f
  jmp __alltraps
c010285c:	e9 ce fe ff ff       	jmp    c010272f <__alltraps>

c0102861 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $32
c0102863:	6a 20                	push   $0x20
  jmp __alltraps
c0102865:	e9 c5 fe ff ff       	jmp    c010272f <__alltraps>

c010286a <vector33>:
.globl vector33
vector33:
  pushl $0
c010286a:	6a 00                	push   $0x0
  pushl $33
c010286c:	6a 21                	push   $0x21
  jmp __alltraps
c010286e:	e9 bc fe ff ff       	jmp    c010272f <__alltraps>

c0102873 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $34
c0102875:	6a 22                	push   $0x22
  jmp __alltraps
c0102877:	e9 b3 fe ff ff       	jmp    c010272f <__alltraps>

c010287c <vector35>:
.globl vector35
vector35:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $35
c010287e:	6a 23                	push   $0x23
  jmp __alltraps
c0102880:	e9 aa fe ff ff       	jmp    c010272f <__alltraps>

c0102885 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $36
c0102887:	6a 24                	push   $0x24
  jmp __alltraps
c0102889:	e9 a1 fe ff ff       	jmp    c010272f <__alltraps>

c010288e <vector37>:
.globl vector37
vector37:
  pushl $0
c010288e:	6a 00                	push   $0x0
  pushl $37
c0102890:	6a 25                	push   $0x25
  jmp __alltraps
c0102892:	e9 98 fe ff ff       	jmp    c010272f <__alltraps>

c0102897 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $38
c0102899:	6a 26                	push   $0x26
  jmp __alltraps
c010289b:	e9 8f fe ff ff       	jmp    c010272f <__alltraps>

c01028a0 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $39
c01028a2:	6a 27                	push   $0x27
  jmp __alltraps
c01028a4:	e9 86 fe ff ff       	jmp    c010272f <__alltraps>

c01028a9 <vector40>:
.globl vector40
vector40:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $40
c01028ab:	6a 28                	push   $0x28
  jmp __alltraps
c01028ad:	e9 7d fe ff ff       	jmp    c010272f <__alltraps>

c01028b2 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028b2:	6a 00                	push   $0x0
  pushl $41
c01028b4:	6a 29                	push   $0x29
  jmp __alltraps
c01028b6:	e9 74 fe ff ff       	jmp    c010272f <__alltraps>

c01028bb <vector42>:
.globl vector42
vector42:
  pushl $0
c01028bb:	6a 00                	push   $0x0
  pushl $42
c01028bd:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028bf:	e9 6b fe ff ff       	jmp    c010272f <__alltraps>

c01028c4 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $43
c01028c6:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028c8:	e9 62 fe ff ff       	jmp    c010272f <__alltraps>

c01028cd <vector44>:
.globl vector44
vector44:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $44
c01028cf:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028d1:	e9 59 fe ff ff       	jmp    c010272f <__alltraps>

c01028d6 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028d6:	6a 00                	push   $0x0
  pushl $45
c01028d8:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028da:	e9 50 fe ff ff       	jmp    c010272f <__alltraps>

c01028df <vector46>:
.globl vector46
vector46:
  pushl $0
c01028df:	6a 00                	push   $0x0
  pushl $46
c01028e1:	6a 2e                	push   $0x2e
  jmp __alltraps
c01028e3:	e9 47 fe ff ff       	jmp    c010272f <__alltraps>

c01028e8 <vector47>:
.globl vector47
vector47:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $47
c01028ea:	6a 2f                	push   $0x2f
  jmp __alltraps
c01028ec:	e9 3e fe ff ff       	jmp    c010272f <__alltraps>

c01028f1 <vector48>:
.globl vector48
vector48:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $48
c01028f3:	6a 30                	push   $0x30
  jmp __alltraps
c01028f5:	e9 35 fe ff ff       	jmp    c010272f <__alltraps>

c01028fa <vector49>:
.globl vector49
vector49:
  pushl $0
c01028fa:	6a 00                	push   $0x0
  pushl $49
c01028fc:	6a 31                	push   $0x31
  jmp __alltraps
c01028fe:	e9 2c fe ff ff       	jmp    c010272f <__alltraps>

c0102903 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102903:	6a 00                	push   $0x0
  pushl $50
c0102905:	6a 32                	push   $0x32
  jmp __alltraps
c0102907:	e9 23 fe ff ff       	jmp    c010272f <__alltraps>

c010290c <vector51>:
.globl vector51
vector51:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $51
c010290e:	6a 33                	push   $0x33
  jmp __alltraps
c0102910:	e9 1a fe ff ff       	jmp    c010272f <__alltraps>

c0102915 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $52
c0102917:	6a 34                	push   $0x34
  jmp __alltraps
c0102919:	e9 11 fe ff ff       	jmp    c010272f <__alltraps>

c010291e <vector53>:
.globl vector53
vector53:
  pushl $0
c010291e:	6a 00                	push   $0x0
  pushl $53
c0102920:	6a 35                	push   $0x35
  jmp __alltraps
c0102922:	e9 08 fe ff ff       	jmp    c010272f <__alltraps>

c0102927 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102927:	6a 00                	push   $0x0
  pushl $54
c0102929:	6a 36                	push   $0x36
  jmp __alltraps
c010292b:	e9 ff fd ff ff       	jmp    c010272f <__alltraps>

c0102930 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102930:	6a 00                	push   $0x0
  pushl $55
c0102932:	6a 37                	push   $0x37
  jmp __alltraps
c0102934:	e9 f6 fd ff ff       	jmp    c010272f <__alltraps>

c0102939 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $56
c010293b:	6a 38                	push   $0x38
  jmp __alltraps
c010293d:	e9 ed fd ff ff       	jmp    c010272f <__alltraps>

c0102942 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102942:	6a 00                	push   $0x0
  pushl $57
c0102944:	6a 39                	push   $0x39
  jmp __alltraps
c0102946:	e9 e4 fd ff ff       	jmp    c010272f <__alltraps>

c010294b <vector58>:
.globl vector58
vector58:
  pushl $0
c010294b:	6a 00                	push   $0x0
  pushl $58
c010294d:	6a 3a                	push   $0x3a
  jmp __alltraps
c010294f:	e9 db fd ff ff       	jmp    c010272f <__alltraps>

c0102954 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102954:	6a 00                	push   $0x0
  pushl $59
c0102956:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102958:	e9 d2 fd ff ff       	jmp    c010272f <__alltraps>

c010295d <vector60>:
.globl vector60
vector60:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $60
c010295f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102961:	e9 c9 fd ff ff       	jmp    c010272f <__alltraps>

c0102966 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102966:	6a 00                	push   $0x0
  pushl $61
c0102968:	6a 3d                	push   $0x3d
  jmp __alltraps
c010296a:	e9 c0 fd ff ff       	jmp    c010272f <__alltraps>

c010296f <vector62>:
.globl vector62
vector62:
  pushl $0
c010296f:	6a 00                	push   $0x0
  pushl $62
c0102971:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102973:	e9 b7 fd ff ff       	jmp    c010272f <__alltraps>

c0102978 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $63
c010297a:	6a 3f                	push   $0x3f
  jmp __alltraps
c010297c:	e9 ae fd ff ff       	jmp    c010272f <__alltraps>

c0102981 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $64
c0102983:	6a 40                	push   $0x40
  jmp __alltraps
c0102985:	e9 a5 fd ff ff       	jmp    c010272f <__alltraps>

c010298a <vector65>:
.globl vector65
vector65:
  pushl $0
c010298a:	6a 00                	push   $0x0
  pushl $65
c010298c:	6a 41                	push   $0x41
  jmp __alltraps
c010298e:	e9 9c fd ff ff       	jmp    c010272f <__alltraps>

c0102993 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102993:	6a 00                	push   $0x0
  pushl $66
c0102995:	6a 42                	push   $0x42
  jmp __alltraps
c0102997:	e9 93 fd ff ff       	jmp    c010272f <__alltraps>

c010299c <vector67>:
.globl vector67
vector67:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $67
c010299e:	6a 43                	push   $0x43
  jmp __alltraps
c01029a0:	e9 8a fd ff ff       	jmp    c010272f <__alltraps>

c01029a5 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $68
c01029a7:	6a 44                	push   $0x44
  jmp __alltraps
c01029a9:	e9 81 fd ff ff       	jmp    c010272f <__alltraps>

c01029ae <vector69>:
.globl vector69
vector69:
  pushl $0
c01029ae:	6a 00                	push   $0x0
  pushl $69
c01029b0:	6a 45                	push   $0x45
  jmp __alltraps
c01029b2:	e9 78 fd ff ff       	jmp    c010272f <__alltraps>

c01029b7 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029b7:	6a 00                	push   $0x0
  pushl $70
c01029b9:	6a 46                	push   $0x46
  jmp __alltraps
c01029bb:	e9 6f fd ff ff       	jmp    c010272f <__alltraps>

c01029c0 <vector71>:
.globl vector71
vector71:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $71
c01029c2:	6a 47                	push   $0x47
  jmp __alltraps
c01029c4:	e9 66 fd ff ff       	jmp    c010272f <__alltraps>

c01029c9 <vector72>:
.globl vector72
vector72:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $72
c01029cb:	6a 48                	push   $0x48
  jmp __alltraps
c01029cd:	e9 5d fd ff ff       	jmp    c010272f <__alltraps>

c01029d2 <vector73>:
.globl vector73
vector73:
  pushl $0
c01029d2:	6a 00                	push   $0x0
  pushl $73
c01029d4:	6a 49                	push   $0x49
  jmp __alltraps
c01029d6:	e9 54 fd ff ff       	jmp    c010272f <__alltraps>

c01029db <vector74>:
.globl vector74
vector74:
  pushl $0
c01029db:	6a 00                	push   $0x0
  pushl $74
c01029dd:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029df:	e9 4b fd ff ff       	jmp    c010272f <__alltraps>

c01029e4 <vector75>:
.globl vector75
vector75:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $75
c01029e6:	6a 4b                	push   $0x4b
  jmp __alltraps
c01029e8:	e9 42 fd ff ff       	jmp    c010272f <__alltraps>

c01029ed <vector76>:
.globl vector76
vector76:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $76
c01029ef:	6a 4c                	push   $0x4c
  jmp __alltraps
c01029f1:	e9 39 fd ff ff       	jmp    c010272f <__alltraps>

c01029f6 <vector77>:
.globl vector77
vector77:
  pushl $0
c01029f6:	6a 00                	push   $0x0
  pushl $77
c01029f8:	6a 4d                	push   $0x4d
  jmp __alltraps
c01029fa:	e9 30 fd ff ff       	jmp    c010272f <__alltraps>

c01029ff <vector78>:
.globl vector78
vector78:
  pushl $0
c01029ff:	6a 00                	push   $0x0
  pushl $78
c0102a01:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a03:	e9 27 fd ff ff       	jmp    c010272f <__alltraps>

c0102a08 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $79
c0102a0a:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a0c:	e9 1e fd ff ff       	jmp    c010272f <__alltraps>

c0102a11 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $80
c0102a13:	6a 50                	push   $0x50
  jmp __alltraps
c0102a15:	e9 15 fd ff ff       	jmp    c010272f <__alltraps>

c0102a1a <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a1a:	6a 00                	push   $0x0
  pushl $81
c0102a1c:	6a 51                	push   $0x51
  jmp __alltraps
c0102a1e:	e9 0c fd ff ff       	jmp    c010272f <__alltraps>

c0102a23 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a23:	6a 00                	push   $0x0
  pushl $82
c0102a25:	6a 52                	push   $0x52
  jmp __alltraps
c0102a27:	e9 03 fd ff ff       	jmp    c010272f <__alltraps>

c0102a2c <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $83
c0102a2e:	6a 53                	push   $0x53
  jmp __alltraps
c0102a30:	e9 fa fc ff ff       	jmp    c010272f <__alltraps>

c0102a35 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $84
c0102a37:	6a 54                	push   $0x54
  jmp __alltraps
c0102a39:	e9 f1 fc ff ff       	jmp    c010272f <__alltraps>

c0102a3e <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a3e:	6a 00                	push   $0x0
  pushl $85
c0102a40:	6a 55                	push   $0x55
  jmp __alltraps
c0102a42:	e9 e8 fc ff ff       	jmp    c010272f <__alltraps>

c0102a47 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a47:	6a 00                	push   $0x0
  pushl $86
c0102a49:	6a 56                	push   $0x56
  jmp __alltraps
c0102a4b:	e9 df fc ff ff       	jmp    c010272f <__alltraps>

c0102a50 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a50:	6a 00                	push   $0x0
  pushl $87
c0102a52:	6a 57                	push   $0x57
  jmp __alltraps
c0102a54:	e9 d6 fc ff ff       	jmp    c010272f <__alltraps>

c0102a59 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $88
c0102a5b:	6a 58                	push   $0x58
  jmp __alltraps
c0102a5d:	e9 cd fc ff ff       	jmp    c010272f <__alltraps>

c0102a62 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a62:	6a 00                	push   $0x0
  pushl $89
c0102a64:	6a 59                	push   $0x59
  jmp __alltraps
c0102a66:	e9 c4 fc ff ff       	jmp    c010272f <__alltraps>

c0102a6b <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a6b:	6a 00                	push   $0x0
  pushl $90
c0102a6d:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a6f:	e9 bb fc ff ff       	jmp    c010272f <__alltraps>

c0102a74 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a74:	6a 00                	push   $0x0
  pushl $91
c0102a76:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a78:	e9 b2 fc ff ff       	jmp    c010272f <__alltraps>

c0102a7d <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $92
c0102a7f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102a81:	e9 a9 fc ff ff       	jmp    c010272f <__alltraps>

c0102a86 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a86:	6a 00                	push   $0x0
  pushl $93
c0102a88:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a8a:	e9 a0 fc ff ff       	jmp    c010272f <__alltraps>

c0102a8f <vector94>:
.globl vector94
vector94:
  pushl $0
c0102a8f:	6a 00                	push   $0x0
  pushl $94
c0102a91:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102a93:	e9 97 fc ff ff       	jmp    c010272f <__alltraps>

c0102a98 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102a98:	6a 00                	push   $0x0
  pushl $95
c0102a9a:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102a9c:	e9 8e fc ff ff       	jmp    c010272f <__alltraps>

c0102aa1 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $96
c0102aa3:	6a 60                	push   $0x60
  jmp __alltraps
c0102aa5:	e9 85 fc ff ff       	jmp    c010272f <__alltraps>

c0102aaa <vector97>:
.globl vector97
vector97:
  pushl $0
c0102aaa:	6a 00                	push   $0x0
  pushl $97
c0102aac:	6a 61                	push   $0x61
  jmp __alltraps
c0102aae:	e9 7c fc ff ff       	jmp    c010272f <__alltraps>

c0102ab3 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ab3:	6a 00                	push   $0x0
  pushl $98
c0102ab5:	6a 62                	push   $0x62
  jmp __alltraps
c0102ab7:	e9 73 fc ff ff       	jmp    c010272f <__alltraps>

c0102abc <vector99>:
.globl vector99
vector99:
  pushl $0
c0102abc:	6a 00                	push   $0x0
  pushl $99
c0102abe:	6a 63                	push   $0x63
  jmp __alltraps
c0102ac0:	e9 6a fc ff ff       	jmp    c010272f <__alltraps>

c0102ac5 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $100
c0102ac7:	6a 64                	push   $0x64
  jmp __alltraps
c0102ac9:	e9 61 fc ff ff       	jmp    c010272f <__alltraps>

c0102ace <vector101>:
.globl vector101
vector101:
  pushl $0
c0102ace:	6a 00                	push   $0x0
  pushl $101
c0102ad0:	6a 65                	push   $0x65
  jmp __alltraps
c0102ad2:	e9 58 fc ff ff       	jmp    c010272f <__alltraps>

c0102ad7 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ad7:	6a 00                	push   $0x0
  pushl $102
c0102ad9:	6a 66                	push   $0x66
  jmp __alltraps
c0102adb:	e9 4f fc ff ff       	jmp    c010272f <__alltraps>

c0102ae0 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102ae0:	6a 00                	push   $0x0
  pushl $103
c0102ae2:	6a 67                	push   $0x67
  jmp __alltraps
c0102ae4:	e9 46 fc ff ff       	jmp    c010272f <__alltraps>

c0102ae9 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $104
c0102aeb:	6a 68                	push   $0x68
  jmp __alltraps
c0102aed:	e9 3d fc ff ff       	jmp    c010272f <__alltraps>

c0102af2 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102af2:	6a 00                	push   $0x0
  pushl $105
c0102af4:	6a 69                	push   $0x69
  jmp __alltraps
c0102af6:	e9 34 fc ff ff       	jmp    c010272f <__alltraps>

c0102afb <vector106>:
.globl vector106
vector106:
  pushl $0
c0102afb:	6a 00                	push   $0x0
  pushl $106
c0102afd:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102aff:	e9 2b fc ff ff       	jmp    c010272f <__alltraps>

c0102b04 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b04:	6a 00                	push   $0x0
  pushl $107
c0102b06:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b08:	e9 22 fc ff ff       	jmp    c010272f <__alltraps>

c0102b0d <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $108
c0102b0f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b11:	e9 19 fc ff ff       	jmp    c010272f <__alltraps>

c0102b16 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b16:	6a 00                	push   $0x0
  pushl $109
c0102b18:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b1a:	e9 10 fc ff ff       	jmp    c010272f <__alltraps>

c0102b1f <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b1f:	6a 00                	push   $0x0
  pushl $110
c0102b21:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b23:	e9 07 fc ff ff       	jmp    c010272f <__alltraps>

c0102b28 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b28:	6a 00                	push   $0x0
  pushl $111
c0102b2a:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b2c:	e9 fe fb ff ff       	jmp    c010272f <__alltraps>

c0102b31 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $112
c0102b33:	6a 70                	push   $0x70
  jmp __alltraps
c0102b35:	e9 f5 fb ff ff       	jmp    c010272f <__alltraps>

c0102b3a <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b3a:	6a 00                	push   $0x0
  pushl $113
c0102b3c:	6a 71                	push   $0x71
  jmp __alltraps
c0102b3e:	e9 ec fb ff ff       	jmp    c010272f <__alltraps>

c0102b43 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b43:	6a 00                	push   $0x0
  pushl $114
c0102b45:	6a 72                	push   $0x72
  jmp __alltraps
c0102b47:	e9 e3 fb ff ff       	jmp    c010272f <__alltraps>

c0102b4c <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b4c:	6a 00                	push   $0x0
  pushl $115
c0102b4e:	6a 73                	push   $0x73
  jmp __alltraps
c0102b50:	e9 da fb ff ff       	jmp    c010272f <__alltraps>

c0102b55 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $116
c0102b57:	6a 74                	push   $0x74
  jmp __alltraps
c0102b59:	e9 d1 fb ff ff       	jmp    c010272f <__alltraps>

c0102b5e <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b5e:	6a 00                	push   $0x0
  pushl $117
c0102b60:	6a 75                	push   $0x75
  jmp __alltraps
c0102b62:	e9 c8 fb ff ff       	jmp    c010272f <__alltraps>

c0102b67 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b67:	6a 00                	push   $0x0
  pushl $118
c0102b69:	6a 76                	push   $0x76
  jmp __alltraps
c0102b6b:	e9 bf fb ff ff       	jmp    c010272f <__alltraps>

c0102b70 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b70:	6a 00                	push   $0x0
  pushl $119
c0102b72:	6a 77                	push   $0x77
  jmp __alltraps
c0102b74:	e9 b6 fb ff ff       	jmp    c010272f <__alltraps>

c0102b79 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $120
c0102b7b:	6a 78                	push   $0x78
  jmp __alltraps
c0102b7d:	e9 ad fb ff ff       	jmp    c010272f <__alltraps>

c0102b82 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b82:	6a 00                	push   $0x0
  pushl $121
c0102b84:	6a 79                	push   $0x79
  jmp __alltraps
c0102b86:	e9 a4 fb ff ff       	jmp    c010272f <__alltraps>

c0102b8b <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b8b:	6a 00                	push   $0x0
  pushl $122
c0102b8d:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102b8f:	e9 9b fb ff ff       	jmp    c010272f <__alltraps>

c0102b94 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102b94:	6a 00                	push   $0x0
  pushl $123
c0102b96:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102b98:	e9 92 fb ff ff       	jmp    c010272f <__alltraps>

c0102b9d <vector124>:
.globl vector124
vector124:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $124
c0102b9f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ba1:	e9 89 fb ff ff       	jmp    c010272f <__alltraps>

c0102ba6 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ba6:	6a 00                	push   $0x0
  pushl $125
c0102ba8:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102baa:	e9 80 fb ff ff       	jmp    c010272f <__alltraps>

c0102baf <vector126>:
.globl vector126
vector126:
  pushl $0
c0102baf:	6a 00                	push   $0x0
  pushl $126
c0102bb1:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bb3:	e9 77 fb ff ff       	jmp    c010272f <__alltraps>

c0102bb8 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bb8:	6a 00                	push   $0x0
  pushl $127
c0102bba:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bbc:	e9 6e fb ff ff       	jmp    c010272f <__alltraps>

c0102bc1 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $128
c0102bc3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102bc8:	e9 62 fb ff ff       	jmp    c010272f <__alltraps>

c0102bcd <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $129
c0102bcf:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102bd4:	e9 56 fb ff ff       	jmp    c010272f <__alltraps>

c0102bd9 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $130
c0102bdb:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102be0:	e9 4a fb ff ff       	jmp    c010272f <__alltraps>

c0102be5 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102be5:	6a 00                	push   $0x0
  pushl $131
c0102be7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102bec:	e9 3e fb ff ff       	jmp    c010272f <__alltraps>

c0102bf1 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $132
c0102bf3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102bf8:	e9 32 fb ff ff       	jmp    c010272f <__alltraps>

c0102bfd <vector133>:
.globl vector133
vector133:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $133
c0102bff:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c04:	e9 26 fb ff ff       	jmp    c010272f <__alltraps>

c0102c09 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c09:	6a 00                	push   $0x0
  pushl $134
c0102c0b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c10:	e9 1a fb ff ff       	jmp    c010272f <__alltraps>

c0102c15 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $135
c0102c17:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c1c:	e9 0e fb ff ff       	jmp    c010272f <__alltraps>

c0102c21 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $136
c0102c23:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c28:	e9 02 fb ff ff       	jmp    c010272f <__alltraps>

c0102c2d <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c2d:	6a 00                	push   $0x0
  pushl $137
c0102c2f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c34:	e9 f6 fa ff ff       	jmp    c010272f <__alltraps>

c0102c39 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $138
c0102c3b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c40:	e9 ea fa ff ff       	jmp    c010272f <__alltraps>

c0102c45 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c45:	6a 00                	push   $0x0
  pushl $139
c0102c47:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c4c:	e9 de fa ff ff       	jmp    c010272f <__alltraps>

c0102c51 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $140
c0102c53:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c58:	e9 d2 fa ff ff       	jmp    c010272f <__alltraps>

c0102c5d <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c5d:	6a 00                	push   $0x0
  pushl $141
c0102c5f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c64:	e9 c6 fa ff ff       	jmp    c010272f <__alltraps>

c0102c69 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c69:	6a 00                	push   $0x0
  pushl $142
c0102c6b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c70:	e9 ba fa ff ff       	jmp    c010272f <__alltraps>

c0102c75 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $143
c0102c77:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c7c:	e9 ae fa ff ff       	jmp    c010272f <__alltraps>

c0102c81 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102c81:	6a 00                	push   $0x0
  pushl $144
c0102c83:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c88:	e9 a2 fa ff ff       	jmp    c010272f <__alltraps>

c0102c8d <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c8d:	6a 00                	push   $0x0
  pushl $145
c0102c8f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102c94:	e9 96 fa ff ff       	jmp    c010272f <__alltraps>

c0102c99 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102c99:	6a 00                	push   $0x0
  pushl $146
c0102c9b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ca0:	e9 8a fa ff ff       	jmp    c010272f <__alltraps>

c0102ca5 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102ca5:	6a 00                	push   $0x0
  pushl $147
c0102ca7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cac:	e9 7e fa ff ff       	jmp    c010272f <__alltraps>

c0102cb1 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cb1:	6a 00                	push   $0x0
  pushl $148
c0102cb3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cb8:	e9 72 fa ff ff       	jmp    c010272f <__alltraps>

c0102cbd <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cbd:	6a 00                	push   $0x0
  pushl $149
c0102cbf:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102cc4:	e9 66 fa ff ff       	jmp    c010272f <__alltraps>

c0102cc9 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cc9:	6a 00                	push   $0x0
  pushl $150
c0102ccb:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102cd0:	e9 5a fa ff ff       	jmp    c010272f <__alltraps>

c0102cd5 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102cd5:	6a 00                	push   $0x0
  pushl $151
c0102cd7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102cdc:	e9 4e fa ff ff       	jmp    c010272f <__alltraps>

c0102ce1 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102ce1:	6a 00                	push   $0x0
  pushl $152
c0102ce3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102ce8:	e9 42 fa ff ff       	jmp    c010272f <__alltraps>

c0102ced <vector153>:
.globl vector153
vector153:
  pushl $0
c0102ced:	6a 00                	push   $0x0
  pushl $153
c0102cef:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102cf4:	e9 36 fa ff ff       	jmp    c010272f <__alltraps>

c0102cf9 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102cf9:	6a 00                	push   $0x0
  pushl $154
c0102cfb:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d00:	e9 2a fa ff ff       	jmp    c010272f <__alltraps>

c0102d05 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d05:	6a 00                	push   $0x0
  pushl $155
c0102d07:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d0c:	e9 1e fa ff ff       	jmp    c010272f <__alltraps>

c0102d11 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d11:	6a 00                	push   $0x0
  pushl $156
c0102d13:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d18:	e9 12 fa ff ff       	jmp    c010272f <__alltraps>

c0102d1d <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d1d:	6a 00                	push   $0x0
  pushl $157
c0102d1f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d24:	e9 06 fa ff ff       	jmp    c010272f <__alltraps>

c0102d29 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d29:	6a 00                	push   $0x0
  pushl $158
c0102d2b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d30:	e9 fa f9 ff ff       	jmp    c010272f <__alltraps>

c0102d35 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d35:	6a 00                	push   $0x0
  pushl $159
c0102d37:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d3c:	e9 ee f9 ff ff       	jmp    c010272f <__alltraps>

c0102d41 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d41:	6a 00                	push   $0x0
  pushl $160
c0102d43:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d48:	e9 e2 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d4d <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d4d:	6a 00                	push   $0x0
  pushl $161
c0102d4f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d54:	e9 d6 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d59 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d59:	6a 00                	push   $0x0
  pushl $162
c0102d5b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d60:	e9 ca f9 ff ff       	jmp    c010272f <__alltraps>

c0102d65 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d65:	6a 00                	push   $0x0
  pushl $163
c0102d67:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d6c:	e9 be f9 ff ff       	jmp    c010272f <__alltraps>

c0102d71 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d71:	6a 00                	push   $0x0
  pushl $164
c0102d73:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d78:	e9 b2 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d7d <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d7d:	6a 00                	push   $0x0
  pushl $165
c0102d7f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d84:	e9 a6 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d89 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d89:	6a 00                	push   $0x0
  pushl $166
c0102d8b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102d90:	e9 9a f9 ff ff       	jmp    c010272f <__alltraps>

c0102d95 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102d95:	6a 00                	push   $0x0
  pushl $167
c0102d97:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102d9c:	e9 8e f9 ff ff       	jmp    c010272f <__alltraps>

c0102da1 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102da1:	6a 00                	push   $0x0
  pushl $168
c0102da3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102da8:	e9 82 f9 ff ff       	jmp    c010272f <__alltraps>

c0102dad <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dad:	6a 00                	push   $0x0
  pushl $169
c0102daf:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102db4:	e9 76 f9 ff ff       	jmp    c010272f <__alltraps>

c0102db9 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102db9:	6a 00                	push   $0x0
  pushl $170
c0102dbb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102dc0:	e9 6a f9 ff ff       	jmp    c010272f <__alltraps>

c0102dc5 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102dc5:	6a 00                	push   $0x0
  pushl $171
c0102dc7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102dcc:	e9 5e f9 ff ff       	jmp    c010272f <__alltraps>

c0102dd1 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102dd1:	6a 00                	push   $0x0
  pushl $172
c0102dd3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102dd8:	e9 52 f9 ff ff       	jmp    c010272f <__alltraps>

c0102ddd <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ddd:	6a 00                	push   $0x0
  pushl $173
c0102ddf:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102de4:	e9 46 f9 ff ff       	jmp    c010272f <__alltraps>

c0102de9 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102de9:	6a 00                	push   $0x0
  pushl $174
c0102deb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102df0:	e9 3a f9 ff ff       	jmp    c010272f <__alltraps>

c0102df5 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102df5:	6a 00                	push   $0x0
  pushl $175
c0102df7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102dfc:	e9 2e f9 ff ff       	jmp    c010272f <__alltraps>

c0102e01 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e01:	6a 00                	push   $0x0
  pushl $176
c0102e03:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e08:	e9 22 f9 ff ff       	jmp    c010272f <__alltraps>

c0102e0d <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e0d:	6a 00                	push   $0x0
  pushl $177
c0102e0f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e14:	e9 16 f9 ff ff       	jmp    c010272f <__alltraps>

c0102e19 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e19:	6a 00                	push   $0x0
  pushl $178
c0102e1b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e20:	e9 0a f9 ff ff       	jmp    c010272f <__alltraps>

c0102e25 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e25:	6a 00                	push   $0x0
  pushl $179
c0102e27:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e2c:	e9 fe f8 ff ff       	jmp    c010272f <__alltraps>

c0102e31 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e31:	6a 00                	push   $0x0
  pushl $180
c0102e33:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e38:	e9 f2 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e3d <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e3d:	6a 00                	push   $0x0
  pushl $181
c0102e3f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e44:	e9 e6 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e49 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e49:	6a 00                	push   $0x0
  pushl $182
c0102e4b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e50:	e9 da f8 ff ff       	jmp    c010272f <__alltraps>

c0102e55 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e55:	6a 00                	push   $0x0
  pushl $183
c0102e57:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e5c:	e9 ce f8 ff ff       	jmp    c010272f <__alltraps>

c0102e61 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e61:	6a 00                	push   $0x0
  pushl $184
c0102e63:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e68:	e9 c2 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e6d <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e6d:	6a 00                	push   $0x0
  pushl $185
c0102e6f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e74:	e9 b6 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e79 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e79:	6a 00                	push   $0x0
  pushl $186
c0102e7b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e80:	e9 aa f8 ff ff       	jmp    c010272f <__alltraps>

c0102e85 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e85:	6a 00                	push   $0x0
  pushl $187
c0102e87:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e8c:	e9 9e f8 ff ff       	jmp    c010272f <__alltraps>

c0102e91 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102e91:	6a 00                	push   $0x0
  pushl $188
c0102e93:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102e98:	e9 92 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e9d <vector189>:
.globl vector189
vector189:
  pushl $0
c0102e9d:	6a 00                	push   $0x0
  pushl $189
c0102e9f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ea4:	e9 86 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ea9 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102ea9:	6a 00                	push   $0x0
  pushl $190
c0102eab:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102eb0:	e9 7a f8 ff ff       	jmp    c010272f <__alltraps>

c0102eb5 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102eb5:	6a 00                	push   $0x0
  pushl $191
c0102eb7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102ebc:	e9 6e f8 ff ff       	jmp    c010272f <__alltraps>

c0102ec1 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ec1:	6a 00                	push   $0x0
  pushl $192
c0102ec3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ec8:	e9 62 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ecd <vector193>:
.globl vector193
vector193:
  pushl $0
c0102ecd:	6a 00                	push   $0x0
  pushl $193
c0102ecf:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ed4:	e9 56 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ed9 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ed9:	6a 00                	push   $0x0
  pushl $194
c0102edb:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102ee0:	e9 4a f8 ff ff       	jmp    c010272f <__alltraps>

c0102ee5 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102ee5:	6a 00                	push   $0x0
  pushl $195
c0102ee7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102eec:	e9 3e f8 ff ff       	jmp    c010272f <__alltraps>

c0102ef1 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102ef1:	6a 00                	push   $0x0
  pushl $196
c0102ef3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ef8:	e9 32 f8 ff ff       	jmp    c010272f <__alltraps>

c0102efd <vector197>:
.globl vector197
vector197:
  pushl $0
c0102efd:	6a 00                	push   $0x0
  pushl $197
c0102eff:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f04:	e9 26 f8 ff ff       	jmp    c010272f <__alltraps>

c0102f09 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f09:	6a 00                	push   $0x0
  pushl $198
c0102f0b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f10:	e9 1a f8 ff ff       	jmp    c010272f <__alltraps>

c0102f15 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f15:	6a 00                	push   $0x0
  pushl $199
c0102f17:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f1c:	e9 0e f8 ff ff       	jmp    c010272f <__alltraps>

c0102f21 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f21:	6a 00                	push   $0x0
  pushl $200
c0102f23:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f28:	e9 02 f8 ff ff       	jmp    c010272f <__alltraps>

c0102f2d <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f2d:	6a 00                	push   $0x0
  pushl $201
c0102f2f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f34:	e9 f6 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f39 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f39:	6a 00                	push   $0x0
  pushl $202
c0102f3b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f40:	e9 ea f7 ff ff       	jmp    c010272f <__alltraps>

c0102f45 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f45:	6a 00                	push   $0x0
  pushl $203
c0102f47:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f4c:	e9 de f7 ff ff       	jmp    c010272f <__alltraps>

c0102f51 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f51:	6a 00                	push   $0x0
  pushl $204
c0102f53:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f58:	e9 d2 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f5d <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f5d:	6a 00                	push   $0x0
  pushl $205
c0102f5f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f64:	e9 c6 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f69 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f69:	6a 00                	push   $0x0
  pushl $206
c0102f6b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f70:	e9 ba f7 ff ff       	jmp    c010272f <__alltraps>

c0102f75 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f75:	6a 00                	push   $0x0
  pushl $207
c0102f77:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f7c:	e9 ae f7 ff ff       	jmp    c010272f <__alltraps>

c0102f81 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102f81:	6a 00                	push   $0x0
  pushl $208
c0102f83:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f88:	e9 a2 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f8d <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f8d:	6a 00                	push   $0x0
  pushl $209
c0102f8f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102f94:	e9 96 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f99 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102f99:	6a 00                	push   $0x0
  pushl $210
c0102f9b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fa0:	e9 8a f7 ff ff       	jmp    c010272f <__alltraps>

c0102fa5 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fa5:	6a 00                	push   $0x0
  pushl $211
c0102fa7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fac:	e9 7e f7 ff ff       	jmp    c010272f <__alltraps>

c0102fb1 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fb1:	6a 00                	push   $0x0
  pushl $212
c0102fb3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fb8:	e9 72 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fbd <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fbd:	6a 00                	push   $0x0
  pushl $213
c0102fbf:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fc4:	e9 66 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fc9 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fc9:	6a 00                	push   $0x0
  pushl $214
c0102fcb:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fd0:	e9 5a f7 ff ff       	jmp    c010272f <__alltraps>

c0102fd5 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102fd5:	6a 00                	push   $0x0
  pushl $215
c0102fd7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102fdc:	e9 4e f7 ff ff       	jmp    c010272f <__alltraps>

c0102fe1 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102fe1:	6a 00                	push   $0x0
  pushl $216
c0102fe3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102fe8:	e9 42 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fed <vector217>:
.globl vector217
vector217:
  pushl $0
c0102fed:	6a 00                	push   $0x0
  pushl $217
c0102fef:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102ff4:	e9 36 f7 ff ff       	jmp    c010272f <__alltraps>

c0102ff9 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102ff9:	6a 00                	push   $0x0
  pushl $218
c0102ffb:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103000:	e9 2a f7 ff ff       	jmp    c010272f <__alltraps>

c0103005 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103005:	6a 00                	push   $0x0
  pushl $219
c0103007:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010300c:	e9 1e f7 ff ff       	jmp    c010272f <__alltraps>

c0103011 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103011:	6a 00                	push   $0x0
  pushl $220
c0103013:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103018:	e9 12 f7 ff ff       	jmp    c010272f <__alltraps>

c010301d <vector221>:
.globl vector221
vector221:
  pushl $0
c010301d:	6a 00                	push   $0x0
  pushl $221
c010301f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103024:	e9 06 f7 ff ff       	jmp    c010272f <__alltraps>

c0103029 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103029:	6a 00                	push   $0x0
  pushl $222
c010302b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103030:	e9 fa f6 ff ff       	jmp    c010272f <__alltraps>

c0103035 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103035:	6a 00                	push   $0x0
  pushl $223
c0103037:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010303c:	e9 ee f6 ff ff       	jmp    c010272f <__alltraps>

c0103041 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103041:	6a 00                	push   $0x0
  pushl $224
c0103043:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103048:	e9 e2 f6 ff ff       	jmp    c010272f <__alltraps>

c010304d <vector225>:
.globl vector225
vector225:
  pushl $0
c010304d:	6a 00                	push   $0x0
  pushl $225
c010304f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103054:	e9 d6 f6 ff ff       	jmp    c010272f <__alltraps>

c0103059 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103059:	6a 00                	push   $0x0
  pushl $226
c010305b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103060:	e9 ca f6 ff ff       	jmp    c010272f <__alltraps>

c0103065 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103065:	6a 00                	push   $0x0
  pushl $227
c0103067:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010306c:	e9 be f6 ff ff       	jmp    c010272f <__alltraps>

c0103071 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103071:	6a 00                	push   $0x0
  pushl $228
c0103073:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103078:	e9 b2 f6 ff ff       	jmp    c010272f <__alltraps>

c010307d <vector229>:
.globl vector229
vector229:
  pushl $0
c010307d:	6a 00                	push   $0x0
  pushl $229
c010307f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103084:	e9 a6 f6 ff ff       	jmp    c010272f <__alltraps>

c0103089 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103089:	6a 00                	push   $0x0
  pushl $230
c010308b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103090:	e9 9a f6 ff ff       	jmp    c010272f <__alltraps>

c0103095 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103095:	6a 00                	push   $0x0
  pushl $231
c0103097:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010309c:	e9 8e f6 ff ff       	jmp    c010272f <__alltraps>

c01030a1 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030a1:	6a 00                	push   $0x0
  pushl $232
c01030a3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030a8:	e9 82 f6 ff ff       	jmp    c010272f <__alltraps>

c01030ad <vector233>:
.globl vector233
vector233:
  pushl $0
c01030ad:	6a 00                	push   $0x0
  pushl $233
c01030af:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030b4:	e9 76 f6 ff ff       	jmp    c010272f <__alltraps>

c01030b9 <vector234>:
.globl vector234
vector234:
  pushl $0
c01030b9:	6a 00                	push   $0x0
  pushl $234
c01030bb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030c0:	e9 6a f6 ff ff       	jmp    c010272f <__alltraps>

c01030c5 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030c5:	6a 00                	push   $0x0
  pushl $235
c01030c7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030cc:	e9 5e f6 ff ff       	jmp    c010272f <__alltraps>

c01030d1 <vector236>:
.globl vector236
vector236:
  pushl $0
c01030d1:	6a 00                	push   $0x0
  pushl $236
c01030d3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030d8:	e9 52 f6 ff ff       	jmp    c010272f <__alltraps>

c01030dd <vector237>:
.globl vector237
vector237:
  pushl $0
c01030dd:	6a 00                	push   $0x0
  pushl $237
c01030df:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01030e4:	e9 46 f6 ff ff       	jmp    c010272f <__alltraps>

c01030e9 <vector238>:
.globl vector238
vector238:
  pushl $0
c01030e9:	6a 00                	push   $0x0
  pushl $238
c01030eb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01030f0:	e9 3a f6 ff ff       	jmp    c010272f <__alltraps>

c01030f5 <vector239>:
.globl vector239
vector239:
  pushl $0
c01030f5:	6a 00                	push   $0x0
  pushl $239
c01030f7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01030fc:	e9 2e f6 ff ff       	jmp    c010272f <__alltraps>

c0103101 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103101:	6a 00                	push   $0x0
  pushl $240
c0103103:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103108:	e9 22 f6 ff ff       	jmp    c010272f <__alltraps>

c010310d <vector241>:
.globl vector241
vector241:
  pushl $0
c010310d:	6a 00                	push   $0x0
  pushl $241
c010310f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103114:	e9 16 f6 ff ff       	jmp    c010272f <__alltraps>

c0103119 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103119:	6a 00                	push   $0x0
  pushl $242
c010311b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103120:	e9 0a f6 ff ff       	jmp    c010272f <__alltraps>

c0103125 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103125:	6a 00                	push   $0x0
  pushl $243
c0103127:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010312c:	e9 fe f5 ff ff       	jmp    c010272f <__alltraps>

c0103131 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103131:	6a 00                	push   $0x0
  pushl $244
c0103133:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103138:	e9 f2 f5 ff ff       	jmp    c010272f <__alltraps>

c010313d <vector245>:
.globl vector245
vector245:
  pushl $0
c010313d:	6a 00                	push   $0x0
  pushl $245
c010313f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103144:	e9 e6 f5 ff ff       	jmp    c010272f <__alltraps>

c0103149 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103149:	6a 00                	push   $0x0
  pushl $246
c010314b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103150:	e9 da f5 ff ff       	jmp    c010272f <__alltraps>

c0103155 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103155:	6a 00                	push   $0x0
  pushl $247
c0103157:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010315c:	e9 ce f5 ff ff       	jmp    c010272f <__alltraps>

c0103161 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103161:	6a 00                	push   $0x0
  pushl $248
c0103163:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103168:	e9 c2 f5 ff ff       	jmp    c010272f <__alltraps>

c010316d <vector249>:
.globl vector249
vector249:
  pushl $0
c010316d:	6a 00                	push   $0x0
  pushl $249
c010316f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103174:	e9 b6 f5 ff ff       	jmp    c010272f <__alltraps>

c0103179 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103179:	6a 00                	push   $0x0
  pushl $250
c010317b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103180:	e9 aa f5 ff ff       	jmp    c010272f <__alltraps>

c0103185 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103185:	6a 00                	push   $0x0
  pushl $251
c0103187:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010318c:	e9 9e f5 ff ff       	jmp    c010272f <__alltraps>

c0103191 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103191:	6a 00                	push   $0x0
  pushl $252
c0103193:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103198:	e9 92 f5 ff ff       	jmp    c010272f <__alltraps>

c010319d <vector253>:
.globl vector253
vector253:
  pushl $0
c010319d:	6a 00                	push   $0x0
  pushl $253
c010319f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031a4:	e9 86 f5 ff ff       	jmp    c010272f <__alltraps>

c01031a9 <vector254>:
.globl vector254
vector254:
  pushl $0
c01031a9:	6a 00                	push   $0x0
  pushl $254
c01031ab:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031b0:	e9 7a f5 ff ff       	jmp    c010272f <__alltraps>

c01031b5 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031b5:	6a 00                	push   $0x0
  pushl $255
c01031b7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031bc:	e9 6e f5 ff ff       	jmp    c010272f <__alltraps>

c01031c1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01031c1:	55                   	push   %ebp
c01031c2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01031c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01031c7:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01031cc:	29 c2                	sub    %eax,%edx
c01031ce:	89 d0                	mov    %edx,%eax
c01031d0:	c1 f8 05             	sar    $0x5,%eax
}
c01031d3:	5d                   	pop    %ebp
c01031d4:	c3                   	ret    

c01031d5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01031d5:	55                   	push   %ebp
c01031d6:	89 e5                	mov    %esp,%ebp
c01031d8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01031db:	8b 45 08             	mov    0x8(%ebp),%eax
c01031de:	89 04 24             	mov    %eax,(%esp)
c01031e1:	e8 db ff ff ff       	call   c01031c1 <page2ppn>
c01031e6:	c1 e0 0c             	shl    $0xc,%eax
}
c01031e9:	c9                   	leave  
c01031ea:	c3                   	ret    

c01031eb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01031eb:	55                   	push   %ebp
c01031ec:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01031ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01031f1:	8b 00                	mov    (%eax),%eax
}
c01031f3:	5d                   	pop    %ebp
c01031f4:	c3                   	ret    

c01031f5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01031f5:	55                   	push   %ebp
c01031f6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01031f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01031fe:	89 10                	mov    %edx,(%eax)
}
c0103200:	5d                   	pop    %ebp
c0103201:	c3                   	ret    

c0103202 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103202:	55                   	push   %ebp
c0103203:	89 e5                	mov    %esp,%ebp
c0103205:	83 ec 10             	sub    $0x10,%esp
c0103208:	c7 45 fc c0 1a 12 c0 	movl   $0xc0121ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010320f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103212:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103215:	89 50 04             	mov    %edx,0x4(%eax)
c0103218:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321b:	8b 50 04             	mov    0x4(%eax),%edx
c010321e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103221:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103223:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c010322a:	00 00 00 
}
c010322d:	c9                   	leave  
c010322e:	c3                   	ret    

c010322f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010322f:	55                   	push   %ebp
c0103230:	89 e5                	mov    %esp,%ebp
c0103232:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103235:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103239:	75 24                	jne    c010325f <default_init_memmap+0x30>
c010323b:	c7 44 24 0c 90 93 10 	movl   $0xc0109390,0xc(%esp)
c0103242:	c0 
c0103243:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c010324a:	c0 
c010324b:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103252:	00 
c0103253:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c010325a:	e8 76 da ff ff       	call   c0100cd5 <__panic>
    struct Page *p = base;
c010325f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103262:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103265:	e9 de 00 00 00       	jmp    c0103348 <default_init_memmap+0x119>
        assert(PageReserved(p));
c010326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010326d:	83 c0 04             	add    $0x4,%eax
c0103270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103277:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010327a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010327d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103280:	0f a3 10             	bt     %edx,(%eax)
c0103283:	19 c0                	sbb    %eax,%eax
c0103285:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103288:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010328c:	0f 95 c0             	setne  %al
c010328f:	0f b6 c0             	movzbl %al,%eax
c0103292:	85 c0                	test   %eax,%eax
c0103294:	75 24                	jne    c01032ba <default_init_memmap+0x8b>
c0103296:	c7 44 24 0c c1 93 10 	movl   $0xc01093c1,0xc(%esp)
c010329d:	c0 
c010329e:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01032ad:	00 
c01032ae:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01032b5:	e8 1b da ff ff       	call   c0100cd5 <__panic>
        p->flags = p->property = 0;
c01032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c7:	8b 50 08             	mov    0x8(%eax),%edx
c01032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032cd:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
c01032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032d3:	83 c0 04             	add    $0x4,%eax
c01032d6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01032dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01032e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032e6:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c01032e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032f0:	00 
c01032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f4:	89 04 24             	mov    %eax,(%esp)
c01032f7:	e8 f9 fe ff ff       	call   c01031f5 <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
c01032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ff:	83 c0 0c             	add    $0xc,%eax
c0103302:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
c0103309:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010330c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010330f:	8b 00                	mov    (%eax),%eax
c0103311:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103314:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103317:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010331a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010331d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103320:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103323:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103326:	89 10                	mov    %edx,(%eax)
c0103328:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010332b:	8b 10                	mov    (%eax),%edx
c010332d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103330:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103333:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103336:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103339:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010333c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010333f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103342:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103344:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010334b:	c1 e0 05             	shl    $0x5,%eax
c010334e:	89 c2                	mov    %eax,%edx
c0103350:	8b 45 08             	mov    0x8(%ebp),%eax
c0103353:	01 d0                	add    %edx,%eax
c0103355:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103358:	0f 85 0c ff ff ff    	jne    c010326a <default_init_memmap+0x3b>
        p->flags = p->property = 0;
		SetPageProperty(p);
        set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c010335e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103361:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103364:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0103367:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c010336d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103370:	01 d0                	add    %edx,%eax
c0103372:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
}
c0103377:	c9                   	leave  
c0103378:	c3                   	ret    

c0103379 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103379:	55                   	push   %ebp
c010337a:	89 e5                	mov    %esp,%ebp
c010337c:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010337f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103383:	75 24                	jne    c01033a9 <default_alloc_pages+0x30>
c0103385:	c7 44 24 0c 90 93 10 	movl   $0xc0109390,0xc(%esp)
c010338c:	c0 
c010338d:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103394:	c0 
c0103395:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010339c:	00 
c010339d:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01033a4:	e8 2c d9 ff ff       	call   c0100cd5 <__panic>
    if (n > nr_free) {
c01033a9:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01033ae:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033b1:	73 0a                	jae    c01033bd <default_alloc_pages+0x44>
        return NULL;
c01033b3:	b8 00 00 00 00       	mov    $0x0,%eax
c01033b8:	e9 40 01 00 00       	jmp    c01034fd <default_alloc_pages+0x184>
    }

    //struct Page *page = NULL;
    list_entry_t *le = &free_list;
c01033bd:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033c4:	e9 13 01 00 00       	jmp    c01034dc <default_alloc_pages+0x163>
        struct Page *p = le2page(le, page_link);
c01033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033cc:	83 e8 0c             	sub    $0xc,%eax
c01033cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033d5:	8b 40 08             	mov    0x8(%eax),%eax
c01033d8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033db:	0f 82 fb 00 00 00    	jb     c01034dc <default_alloc_pages+0x163>
			int i;
           for (i=0; i<n; i++) {
c01033e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01033e8:	eb 7c                	jmp    c0103466 <default_alloc_pages+0xed>
				struct Page* t = le2page(le,page_link);
c01033ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ed:	83 e8 0c             	sub    $0xc,%eax
c01033f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				SetPageReserved(t);
c01033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f6:	83 c0 04             	add    $0x4,%eax
c01033f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103400:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103403:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103406:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103409:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(t);
c010340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010340f:	83 c0 04             	add    $0x4,%eax
c0103412:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0103419:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010341c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010341f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103422:	0f b3 10             	btr    %edx,(%eax)
c0103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103428:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010342b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010342e:	8b 40 04             	mov    0x4(%eax),%eax
				list_entry_t * next = list_next(le);
c0103431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103437:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010343a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010343d:	8b 40 04             	mov    0x4(%eax),%eax
c0103440:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103443:	8b 12                	mov    (%edx),%edx
c0103445:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103448:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010344b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010344e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103451:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103454:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103457:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010345a:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = next;
c010345c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010345f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
			int i;
           for (i=0; i<n; i++) {
c0103462:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0103466:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103469:	3b 45 08             	cmp    0x8(%ebp),%eax
c010346c:	0f 82 78 ff ff ff    	jb     c01033ea <default_alloc_pages+0x71>
				ClearPageProperty(t);
				list_entry_t * next = list_next(le);
				list_del(le);
				le = next;
		}
		if(p->property>n){
c0103472:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103475:	8b 40 08             	mov    0x8(%eax),%eax
c0103478:	3b 45 08             	cmp    0x8(%ebp),%eax
c010347b:	76 12                	jbe    c010348f <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c010347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103480:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103486:	8b 40 08             	mov    0x8(%eax),%eax
c0103489:	2b 45 08             	sub    0x8(%ebp),%eax
c010348c:	89 42 08             	mov    %eax,0x8(%edx)
        }
        nr_free -= n;
c010348f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103494:	2b 45 08             	sub    0x8(%ebp),%eax
c0103497:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
        ClearPageProperty(p);
c010349c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010349f:	83 c0 04             	add    $0x4,%eax
c01034a2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01034ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034af:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034b2:	0f b3 10             	btr    %edx,(%eax)
		p->property = n;
c01034b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01034bb:	89 50 08             	mov    %edx,0x8(%eax)
 		SetPageReserved(p);
c01034be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c1:	83 c0 04             	add    $0x4,%eax
c01034c4:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01034cb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034d1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034d4:	0f ab 10             	bts    %edx,(%eax)
		return p;
c01034d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034da:	eb 21                	jmp    c01034fd <default_alloc_pages+0x184>
c01034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034df:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034e5:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    //struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034eb:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c01034f2:	0f 85 d1 fe ff ff    	jne    c01033c9 <default_alloc_pages+0x50>
    }

    
        
    }
    return NULL;
c01034f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034fd:	c9                   	leave  
c01034fe:	c3                   	ret    

c01034ff <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01034ff:	55                   	push   %ebp
c0103500:	89 e5                	mov    %esp,%ebp
c0103502:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103509:	75 24                	jne    c010352f <default_free_pages+0x30>
c010350b:	c7 44 24 0c 90 93 10 	movl   $0xc0109390,0xc(%esp)
c0103512:	c0 
c0103513:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c010351a:	c0 
c010351b:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0103522:	00 
c0103523:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c010352a:	e8 a6 d7 ff ff       	call   c0100cd5 <__panic>
    assert(PageReserved(base));
c010352f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103532:	83 c0 04             	add    $0x4,%eax
c0103535:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010353c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010353f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103542:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103545:	0f a3 10             	bt     %edx,(%eax)
c0103548:	19 c0                	sbb    %eax,%eax
c010354a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c010354d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103551:	0f 95 c0             	setne  %al
c0103554:	0f b6 c0             	movzbl %al,%eax
c0103557:	85 c0                	test   %eax,%eax
c0103559:	75 24                	jne    c010357f <default_free_pages+0x80>
c010355b:	c7 44 24 0c d1 93 10 	movl   $0xc01093d1,0xc(%esp)
c0103562:	c0 
c0103563:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c010356a:	c0 
c010356b:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0103572:	00 
c0103573:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c010357a:	e8 56 d7 ff ff       	call   c0100cd5 <__panic>
    list_entry_t *pos = &free_list;
c010357f:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)
    struct Page * t;
    while((pos=list_next(pos)) != &free_list) {
c0103586:	eb 13                	jmp    c010359b <default_free_pages+0x9c>
      t = le2page(pos, page_link);
c0103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358b:	83 e8 0c             	sub    $0xc,%eax
c010358e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(t>base){
c0103591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103594:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103597:	76 02                	jbe    c010359b <default_free_pages+0x9c>
        break;
c0103599:	eb 18                	jmp    c01035b3 <default_free_pages+0xb4>
c010359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01035a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035a4:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    list_entry_t *pos = &free_list;
    struct Page * t;
    while((pos=list_next(pos)) != &free_list) {
c01035a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035aa:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c01035b1:	75 d5                	jne    c0103588 <default_free_pages+0x89>
      if(t>base){
        break;
      }
    }
	struct Page *pp;
	for(pp=base;pp<base+n;pp++){
c01035b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01035b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035b9:	eb 4b                	jmp    c0103606 <default_free_pages+0x107>
      list_add_before(pos, &(pp->page_link));
c01035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035be:	8d 50 0c             	lea    0xc(%eax),%edx
c01035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01035c7:	89 55 d0             	mov    %edx,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035cd:	8b 00                	mov    (%eax),%eax
c01035cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035d2:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01035d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01035de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035e4:	89 10                	mov    %edx,(%eax)
c01035e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035e9:	8b 10                	mov    (%eax),%edx
c01035eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035ee:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01035fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103600:	89 10                	mov    %edx,(%eax)
      if(t>base){
        break;
      }
    }
	struct Page *pp;
	for(pp=base;pp<base+n;pp++){
c0103602:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c0103606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103609:	c1 e0 05             	shl    $0x5,%eax
c010360c:	89 c2                	mov    %eax,%edx
c010360e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103611:	01 d0                	add    %edx,%eax
c0103613:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103616:	77 a3                	ja     c01035bb <default_free_pages+0xbc>
      list_add_before(pos, &(pp->page_link));
    }
	base->flags = 0;
c0103618:	8b 45 08             	mov    0x8(%ebp),%eax
c010361b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103622:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103629:	00 
c010362a:	8b 45 08             	mov    0x8(%ebp),%eax
c010362d:	89 04 24             	mov    %eax,(%esp)
c0103630:	e8 c0 fb ff ff       	call   c01031f5 <set_page_ref>
    ClearPageProperty(base);
c0103635:	8b 45 08             	mov    0x8(%ebp),%eax
c0103638:	83 c0 04             	add    $0x4,%eax
c010363b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103642:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103645:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103648:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010364b:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c010364e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103651:	83 c0 04             	add    $0x4,%eax
c0103654:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010365b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010365e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103661:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103664:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0103667:	8b 45 08             	mov    0x8(%ebp),%eax
c010366a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010366d:	89 50 08             	mov    %edx,0x8(%eax)
	struct Page * p = le2page(pos,page_link);
c0103670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103673:	83 e8 0c             	sub    $0xc,%eax
c0103676:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (p == base + n){
c0103679:	8b 45 0c             	mov    0xc(%ebp),%eax
c010367c:	c1 e0 05             	shl    $0x5,%eax
c010367f:	89 c2                	mov    %eax,%edx
c0103681:	8b 45 08             	mov    0x8(%ebp),%eax
c0103684:	01 d0                	add    %edx,%eax
c0103686:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103689:	75 1e                	jne    c01036a9 <default_free_pages+0x1aa>
		base->property += p->property;
c010368b:	8b 45 08             	mov    0x8(%ebp),%eax
c010368e:	8b 50 08             	mov    0x8(%eax),%edx
c0103691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103694:	8b 40 08             	mov    0x8(%eax),%eax
c0103697:	01 c2                	add    %eax,%edx
c0103699:	8b 45 08             	mov    0x8(%ebp),%eax
c010369c:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c010369f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
    pos = list_prev(&(base->page_link));
c01036a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ac:	83 c0 0c             	add    $0xc,%eax
c01036af:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01036b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036b5:	8b 00                	mov    (%eax),%eax
c01036b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(pos,page_link);
c01036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036bd:	83 e8 0c             	sub    $0xc,%eax
c01036c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (p==base-1){
c01036c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c6:	83 e8 20             	sub    $0x20,%eax
c01036c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01036cc:	75 4e                	jne    c010371c <default_free_pages+0x21d>
    while (pos != &free_list) {
c01036ce:	eb 43                	jmp    c0103713 <default_free_pages+0x214>
        if (p->property==0){
c01036d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036d3:	8b 40 08             	mov    0x8(%eax),%eax
c01036d6:	85 c0                	test   %eax,%eax
c01036d8:	75 19                	jne    c01036f3 <default_free_pages+0x1f4>
c01036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036dd:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01036e0:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01036e3:	8b 00                	mov    (%eax),%eax
			pos = list_prev(pos);
c01036e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			p = le2page(pos,page_link);
c01036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036eb:	83 e8 0c             	sub    $0xc,%eax
c01036ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01036f1:	eb 20                	jmp    c0103713 <default_free_pages+0x214>
		} else {
			p->property += base->property;
c01036f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036f6:	8b 50 08             	mov    0x8(%eax),%edx
c01036f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fc:	8b 40 08             	mov    0x8(%eax),%eax
c01036ff:	01 c2                	add    %eax,%edx
c0103701:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103704:	89 50 08             	mov    %edx,0x8(%eax)
			base->property = 0;
c0103707:	8b 45 08             	mov    0x8(%ebp),%eax
c010370a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			break;
c0103711:	eb 09                	jmp    c010371c <default_free_pages+0x21d>
		p->property = 0;
	}
    pos = list_prev(&(base->page_link));
	p = le2page(pos,page_link);
	if (p==base-1){
    while (pos != &free_list) {
c0103713:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c010371a:	75 b4                	jne    c01036d0 <default_free_pages+0x1d1>
			break;
		}
        }
    }

    nr_free += n;
c010371c:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c0103722:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103725:	01 d0                	add    %edx,%eax
c0103727:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
    return;
c010372c:	90                   	nop
}
c010372d:	c9                   	leave  
c010372e:	c3                   	ret    

c010372f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010372f:	55                   	push   %ebp
c0103730:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103732:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
}
c0103737:	5d                   	pop    %ebp
c0103738:	c3                   	ret    

c0103739 <basic_check>:

static void
basic_check(void) {
c0103739:	55                   	push   %ebp
c010373a:	89 e5                	mov    %esp,%ebp
c010373c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010373f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103746:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103749:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010374f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103752:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103759:	e8 bf 0e 00 00       	call   c010461d <alloc_pages>
c010375e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103765:	75 24                	jne    c010378b <basic_check+0x52>
c0103767:	c7 44 24 0c e4 93 10 	movl   $0xc01093e4,0xc(%esp)
c010376e:	c0 
c010376f:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103776:	c0 
c0103777:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c010377e:	00 
c010377f:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103786:	e8 4a d5 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010378b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103792:	e8 86 0e 00 00       	call   c010461d <alloc_pages>
c0103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010379a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010379e:	75 24                	jne    c01037c4 <basic_check+0x8b>
c01037a0:	c7 44 24 0c 00 94 10 	movl   $0xc0109400,0xc(%esp)
c01037a7:	c0 
c01037a8:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01037af:	c0 
c01037b0:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01037b7:	00 
c01037b8:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01037bf:	e8 11 d5 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037cb:	e8 4d 0e 00 00       	call   c010461d <alloc_pages>
c01037d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037d7:	75 24                	jne    c01037fd <basic_check+0xc4>
c01037d9:	c7 44 24 0c 1c 94 10 	movl   $0xc010941c,0xc(%esp)
c01037e0:	c0 
c01037e1:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01037f0:	00 
c01037f1:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01037f8:	e8 d8 d4 ff ff       	call   c0100cd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01037fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103800:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103803:	74 10                	je     c0103815 <basic_check+0xdc>
c0103805:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103808:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010380b:	74 08                	je     c0103815 <basic_check+0xdc>
c010380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103810:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103813:	75 24                	jne    c0103839 <basic_check+0x100>
c0103815:	c7 44 24 0c 38 94 10 	movl   $0xc0109438,0xc(%esp)
c010381c:	c0 
c010381d:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103824:	c0 
c0103825:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010382c:	00 
c010382d:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103834:	e8 9c d4 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103839:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010383c:	89 04 24             	mov    %eax,(%esp)
c010383f:	e8 a7 f9 ff ff       	call   c01031eb <page_ref>
c0103844:	85 c0                	test   %eax,%eax
c0103846:	75 1e                	jne    c0103866 <basic_check+0x12d>
c0103848:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010384b:	89 04 24             	mov    %eax,(%esp)
c010384e:	e8 98 f9 ff ff       	call   c01031eb <page_ref>
c0103853:	85 c0                	test   %eax,%eax
c0103855:	75 0f                	jne    c0103866 <basic_check+0x12d>
c0103857:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010385a:	89 04 24             	mov    %eax,(%esp)
c010385d:	e8 89 f9 ff ff       	call   c01031eb <page_ref>
c0103862:	85 c0                	test   %eax,%eax
c0103864:	74 24                	je     c010388a <basic_check+0x151>
c0103866:	c7 44 24 0c 5c 94 10 	movl   $0xc010945c,0xc(%esp)
c010386d:	c0 
c010386e:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103875:	c0 
c0103876:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010387d:	00 
c010387e:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103885:	e8 4b d4 ff ff       	call   c0100cd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010388a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010388d:	89 04 24             	mov    %eax,(%esp)
c0103890:	e8 40 f9 ff ff       	call   c01031d5 <page2pa>
c0103895:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c010389b:	c1 e2 0c             	shl    $0xc,%edx
c010389e:	39 d0                	cmp    %edx,%eax
c01038a0:	72 24                	jb     c01038c6 <basic_check+0x18d>
c01038a2:	c7 44 24 0c 98 94 10 	movl   $0xc0109498,0xc(%esp)
c01038a9:	c0 
c01038aa:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01038b1:	c0 
c01038b2:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01038b9:	00 
c01038ba:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01038c1:	e8 0f d4 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c9:	89 04 24             	mov    %eax,(%esp)
c01038cc:	e8 04 f9 ff ff       	call   c01031d5 <page2pa>
c01038d1:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c01038d7:	c1 e2 0c             	shl    $0xc,%edx
c01038da:	39 d0                	cmp    %edx,%eax
c01038dc:	72 24                	jb     c0103902 <basic_check+0x1c9>
c01038de:	c7 44 24 0c b5 94 10 	movl   $0xc01094b5,0xc(%esp)
c01038e5:	c0 
c01038e6:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01038ed:	c0 
c01038ee:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01038f5:	00 
c01038f6:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01038fd:	e8 d3 d3 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103905:	89 04 24             	mov    %eax,(%esp)
c0103908:	e8 c8 f8 ff ff       	call   c01031d5 <page2pa>
c010390d:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103913:	c1 e2 0c             	shl    $0xc,%edx
c0103916:	39 d0                	cmp    %edx,%eax
c0103918:	72 24                	jb     c010393e <basic_check+0x205>
c010391a:	c7 44 24 0c d2 94 10 	movl   $0xc01094d2,0xc(%esp)
c0103921:	c0 
c0103922:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103929:	c0 
c010392a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103931:	00 
c0103932:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103939:	e8 97 d3 ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c010393e:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103943:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103949:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010394c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010394f:	c7 45 e0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103956:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103959:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010395c:	89 50 04             	mov    %edx,0x4(%eax)
c010395f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103962:	8b 50 04             	mov    0x4(%eax),%edx
c0103965:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103968:	89 10                	mov    %edx,(%eax)
c010396a:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103971:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103974:	8b 40 04             	mov    0x4(%eax),%eax
c0103977:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010397a:	0f 94 c0             	sete   %al
c010397d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103980:	85 c0                	test   %eax,%eax
c0103982:	75 24                	jne    c01039a8 <basic_check+0x26f>
c0103984:	c7 44 24 0c ef 94 10 	movl   $0xc01094ef,0xc(%esp)
c010398b:	c0 
c010398c:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103993:	c0 
c0103994:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010399b:	00 
c010399c:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01039a3:	e8 2d d3 ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c01039a8:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01039ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01039b0:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01039b7:	00 00 00 

    assert(alloc_page() == NULL);
c01039ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039c1:	e8 57 0c 00 00       	call   c010461d <alloc_pages>
c01039c6:	85 c0                	test   %eax,%eax
c01039c8:	74 24                	je     c01039ee <basic_check+0x2b5>
c01039ca:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c01039d1:	c0 
c01039d2:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01039d9:	c0 
c01039da:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01039e1:	00 
c01039e2:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01039e9:	e8 e7 d2 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c01039ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039f5:	00 
c01039f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f9:	89 04 24             	mov    %eax,(%esp)
c01039fc:	e8 87 0c 00 00       	call   c0104688 <free_pages>
    free_page(p1);
c0103a01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a08:	00 
c0103a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a0c:	89 04 24             	mov    %eax,(%esp)
c0103a0f:	e8 74 0c 00 00       	call   c0104688 <free_pages>
    free_page(p2);
c0103a14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a1b:	00 
c0103a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a1f:	89 04 24             	mov    %eax,(%esp)
c0103a22:	e8 61 0c 00 00       	call   c0104688 <free_pages>
    assert(nr_free == 3);
c0103a27:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103a2c:	83 f8 03             	cmp    $0x3,%eax
c0103a2f:	74 24                	je     c0103a55 <basic_check+0x31c>
c0103a31:	c7 44 24 0c 1b 95 10 	movl   $0xc010951b,0xc(%esp)
c0103a38:	c0 
c0103a39:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103a40:	c0 
c0103a41:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103a48:	00 
c0103a49:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103a50:	e8 80 d2 ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a5c:	e8 bc 0b 00 00       	call   c010461d <alloc_pages>
c0103a61:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a68:	75 24                	jne    c0103a8e <basic_check+0x355>
c0103a6a:	c7 44 24 0c e4 93 10 	movl   $0xc01093e4,0xc(%esp)
c0103a71:	c0 
c0103a72:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103a79:	c0 
c0103a7a:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103a81:	00 
c0103a82:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103a89:	e8 47 d2 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a95:	e8 83 0b 00 00       	call   c010461d <alloc_pages>
c0103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aa1:	75 24                	jne    c0103ac7 <basic_check+0x38e>
c0103aa3:	c7 44 24 0c 00 94 10 	movl   $0xc0109400,0xc(%esp)
c0103aaa:	c0 
c0103aab:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103ab2:	c0 
c0103ab3:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103aba:	00 
c0103abb:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103ac2:	e8 0e d2 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103ac7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ace:	e8 4a 0b 00 00       	call   c010461d <alloc_pages>
c0103ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ada:	75 24                	jne    c0103b00 <basic_check+0x3c7>
c0103adc:	c7 44 24 0c 1c 94 10 	movl   $0xc010941c,0xc(%esp)
c0103ae3:	c0 
c0103ae4:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103aeb:	c0 
c0103aec:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103af3:	00 
c0103af4:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103afb:	e8 d5 d1 ff ff       	call   c0100cd5 <__panic>

    assert(alloc_page() == NULL);
c0103b00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b07:	e8 11 0b 00 00       	call   c010461d <alloc_pages>
c0103b0c:	85 c0                	test   %eax,%eax
c0103b0e:	74 24                	je     c0103b34 <basic_check+0x3fb>
c0103b10:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103b17:	c0 
c0103b18:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103b1f:	c0 
c0103b20:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103b27:	00 
c0103b28:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103b2f:	e8 a1 d1 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c0103b34:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b3b:	00 
c0103b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3f:	89 04 24             	mov    %eax,(%esp)
c0103b42:	e8 41 0b 00 00       	call   c0104688 <free_pages>
c0103b47:	c7 45 d8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x28(%ebp)
c0103b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b51:	8b 40 04             	mov    0x4(%eax),%eax
c0103b54:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b57:	0f 94 c0             	sete   %al
c0103b5a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b5d:	85 c0                	test   %eax,%eax
c0103b5f:	74 24                	je     c0103b85 <basic_check+0x44c>
c0103b61:	c7 44 24 0c 28 95 10 	movl   $0xc0109528,0xc(%esp)
c0103b68:	c0 
c0103b69:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103b70:	c0 
c0103b71:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103b78:	00 
c0103b79:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103b80:	e8 50 d1 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103b85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b8c:	e8 8c 0a 00 00       	call   c010461d <alloc_pages>
c0103b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b9a:	74 24                	je     c0103bc0 <basic_check+0x487>
c0103b9c:	c7 44 24 0c 40 95 10 	movl   $0xc0109540,0xc(%esp)
c0103ba3:	c0 
c0103ba4:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103bab:	c0 
c0103bac:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103bb3:	00 
c0103bb4:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103bbb:	e8 15 d1 ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103bc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bc7:	e8 51 0a 00 00       	call   c010461d <alloc_pages>
c0103bcc:	85 c0                	test   %eax,%eax
c0103bce:	74 24                	je     c0103bf4 <basic_check+0x4bb>
c0103bd0:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103bd7:	c0 
c0103bd8:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103be7:	00 
c0103be8:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103bef:	e8 e1 d0 ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c0103bf4:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103bf9:	85 c0                	test   %eax,%eax
c0103bfb:	74 24                	je     c0103c21 <basic_check+0x4e8>
c0103bfd:	c7 44 24 0c 59 95 10 	movl   $0xc0109559,0xc(%esp)
c0103c04:	c0 
c0103c05:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103c0c:	c0 
c0103c0d:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103c14:	00 
c0103c15:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103c1c:	e8 b4 d0 ff ff       	call   c0100cd5 <__panic>
    free_list = free_list_store;
c0103c21:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c27:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0103c2c:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    nr_free = nr_free_store;
c0103c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c35:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_page(p);
c0103c3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c41:	00 
c0103c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c45:	89 04 24             	mov    %eax,(%esp)
c0103c48:	e8 3b 0a 00 00       	call   c0104688 <free_pages>
    free_page(p1);
c0103c4d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c54:	00 
c0103c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c58:	89 04 24             	mov    %eax,(%esp)
c0103c5b:	e8 28 0a 00 00       	call   c0104688 <free_pages>
    free_page(p2);
c0103c60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c67:	00 
c0103c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c6b:	89 04 24             	mov    %eax,(%esp)
c0103c6e:	e8 15 0a 00 00       	call   c0104688 <free_pages>
}
c0103c73:	c9                   	leave  
c0103c74:	c3                   	ret    

c0103c75 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103c75:	55                   	push   %ebp
c0103c76:	89 e5                	mov    %esp,%ebp
c0103c78:	53                   	push   %ebx
c0103c79:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103c7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103c8d:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103c94:	eb 6b                	jmp    c0103d01 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c99:	83 e8 0c             	sub    $0xc,%eax
c0103c9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ca2:	83 c0 04             	add    $0x4,%eax
c0103ca5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103caf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103cb2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103cb5:	0f a3 10             	bt     %edx,(%eax)
c0103cb8:	19 c0                	sbb    %eax,%eax
c0103cba:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103cbd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103cc1:	0f 95 c0             	setne  %al
c0103cc4:	0f b6 c0             	movzbl %al,%eax
c0103cc7:	85 c0                	test   %eax,%eax
c0103cc9:	75 24                	jne    c0103cef <default_check+0x7a>
c0103ccb:	c7 44 24 0c 66 95 10 	movl   $0xc0109566,0xc(%esp)
c0103cd2:	c0 
c0103cd3:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103cda:	c0 
c0103cdb:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103ce2:	00 
c0103ce3:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103cea:	e8 e6 cf ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c0103cef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cf6:	8b 50 08             	mov    0x8(%eax),%edx
c0103cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cfc:	01 d0                	add    %edx,%eax
c0103cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d04:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d0a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d10:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c0103d17:	0f 85 79 ff ff ff    	jne    c0103c96 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d1d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d20:	e8 95 09 00 00       	call   c01046ba <nr_free_pages>
c0103d25:	39 c3                	cmp    %eax,%ebx
c0103d27:	74 24                	je     c0103d4d <default_check+0xd8>
c0103d29:	c7 44 24 0c 76 95 10 	movl   $0xc0109576,0xc(%esp)
c0103d30:	c0 
c0103d31:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103d38:	c0 
c0103d39:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103d40:	00 
c0103d41:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103d48:	e8 88 cf ff ff       	call   c0100cd5 <__panic>

    basic_check();
c0103d4d:	e8 e7 f9 ff ff       	call   c0103739 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d52:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d59:	e8 bf 08 00 00       	call   c010461d <alloc_pages>
c0103d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d65:	75 24                	jne    c0103d8b <default_check+0x116>
c0103d67:	c7 44 24 0c 8f 95 10 	movl   $0xc010958f,0xc(%esp)
c0103d6e:	c0 
c0103d6f:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103d76:	c0 
c0103d77:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103d7e:	00 
c0103d7f:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103d86:	e8 4a cf ff ff       	call   c0100cd5 <__panic>
    assert(!PageProperty(p0));
c0103d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d8e:	83 c0 04             	add    $0x4,%eax
c0103d91:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103d98:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103d9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103da1:	0f a3 10             	bt     %edx,(%eax)
c0103da4:	19 c0                	sbb    %eax,%eax
c0103da6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103da9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103dad:	0f 95 c0             	setne  %al
c0103db0:	0f b6 c0             	movzbl %al,%eax
c0103db3:	85 c0                	test   %eax,%eax
c0103db5:	74 24                	je     c0103ddb <default_check+0x166>
c0103db7:	c7 44 24 0c 9a 95 10 	movl   $0xc010959a,0xc(%esp)
c0103dbe:	c0 
c0103dbf:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103dc6:	c0 
c0103dc7:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103dce:	00 
c0103dcf:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103dd6:	e8 fa ce ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103ddb:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103de0:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103de6:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103de9:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103dec:	c7 45 b4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103df3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103df6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df9:	89 50 04             	mov    %edx,0x4(%eax)
c0103dfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103dff:	8b 50 04             	mov    0x4(%eax),%edx
c0103e02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e05:	89 10                	mov    %edx,(%eax)
c0103e07:	c7 45 b0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e0e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e11:	8b 40 04             	mov    0x4(%eax),%eax
c0103e14:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e17:	0f 94 c0             	sete   %al
c0103e1a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e1d:	85 c0                	test   %eax,%eax
c0103e1f:	75 24                	jne    c0103e45 <default_check+0x1d0>
c0103e21:	c7 44 24 0c ef 94 10 	movl   $0xc01094ef,0xc(%esp)
c0103e28:	c0 
c0103e29:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103e30:	c0 
c0103e31:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103e38:	00 
c0103e39:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103e40:	e8 90 ce ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103e45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e4c:	e8 cc 07 00 00       	call   c010461d <alloc_pages>
c0103e51:	85 c0                	test   %eax,%eax
c0103e53:	74 24                	je     c0103e79 <default_check+0x204>
c0103e55:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103e5c:	c0 
c0103e5d:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103e64:	c0 
c0103e65:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103e6c:	00 
c0103e6d:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103e74:	e8 5c ce ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103e79:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103e81:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103e88:	00 00 00 

    free_pages(p0 + 2, 3);
c0103e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e8e:	83 c0 40             	add    $0x40,%eax
c0103e91:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103e98:	00 
c0103e99:	89 04 24             	mov    %eax,(%esp)
c0103e9c:	e8 e7 07 00 00       	call   c0104688 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103ea1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103ea8:	e8 70 07 00 00       	call   c010461d <alloc_pages>
c0103ead:	85 c0                	test   %eax,%eax
c0103eaf:	74 24                	je     c0103ed5 <default_check+0x260>
c0103eb1:	c7 44 24 0c ac 95 10 	movl   $0xc01095ac,0xc(%esp)
c0103eb8:	c0 
c0103eb9:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103ec0:	c0 
c0103ec1:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103ec8:	00 
c0103ec9:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103ed0:	e8 00 ce ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103ed5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ed8:	83 c0 40             	add    $0x40,%eax
c0103edb:	83 c0 04             	add    $0x4,%eax
c0103ede:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103ee5:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103eeb:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103eee:	0f a3 10             	bt     %edx,(%eax)
c0103ef1:	19 c0                	sbb    %eax,%eax
c0103ef3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103ef6:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103efa:	0f 95 c0             	setne  %al
c0103efd:	0f b6 c0             	movzbl %al,%eax
c0103f00:	85 c0                	test   %eax,%eax
c0103f02:	74 0e                	je     c0103f12 <default_check+0x29d>
c0103f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f07:	83 c0 40             	add    $0x40,%eax
c0103f0a:	8b 40 08             	mov    0x8(%eax),%eax
c0103f0d:	83 f8 03             	cmp    $0x3,%eax
c0103f10:	74 24                	je     c0103f36 <default_check+0x2c1>
c0103f12:	c7 44 24 0c c4 95 10 	movl   $0xc01095c4,0xc(%esp)
c0103f19:	c0 
c0103f1a:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103f21:	c0 
c0103f22:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103f29:	00 
c0103f2a:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103f31:	e8 9f cd ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f36:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f3d:	e8 db 06 00 00       	call   c010461d <alloc_pages>
c0103f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f49:	75 24                	jne    c0103f6f <default_check+0x2fa>
c0103f4b:	c7 44 24 0c f0 95 10 	movl   $0xc01095f0,0xc(%esp)
c0103f52:	c0 
c0103f53:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103f5a:	c0 
c0103f5b:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f62:	00 
c0103f63:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103f6a:	e8 66 cd ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f76:	e8 a2 06 00 00       	call   c010461d <alloc_pages>
c0103f7b:	85 c0                	test   %eax,%eax
c0103f7d:	74 24                	je     c0103fa3 <default_check+0x32e>
c0103f7f:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103f86:	c0 
c0103f87:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103f8e:	c0 
c0103f8f:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103f96:	00 
c0103f97:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103f9e:	e8 32 cd ff ff       	call   c0100cd5 <__panic>
    assert(p0 + 2 == p1);
c0103fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fa6:	83 c0 40             	add    $0x40,%eax
c0103fa9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103fac:	74 24                	je     c0103fd2 <default_check+0x35d>
c0103fae:	c7 44 24 0c 0e 96 10 	movl   $0xc010960e,0xc(%esp)
c0103fb5:	c0 
c0103fb6:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0103fbd:	c0 
c0103fbe:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103fc5:	00 
c0103fc6:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0103fcd:	e8 03 cd ff ff       	call   c0100cd5 <__panic>

    p2 = p0 + 1;
c0103fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd5:	83 c0 20             	add    $0x20,%eax
c0103fd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103fdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fe2:	00 
c0103fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe6:	89 04 24             	mov    %eax,(%esp)
c0103fe9:	e8 9a 06 00 00       	call   c0104688 <free_pages>
    free_pages(p1, 3);
c0103fee:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103ff5:	00 
c0103ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ff9:	89 04 24             	mov    %eax,(%esp)
c0103ffc:	e8 87 06 00 00       	call   c0104688 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104004:	83 c0 04             	add    $0x4,%eax
c0104007:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010400e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104011:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104014:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104017:	0f a3 10             	bt     %edx,(%eax)
c010401a:	19 c0                	sbb    %eax,%eax
c010401c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010401f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104023:	0f 95 c0             	setne  %al
c0104026:	0f b6 c0             	movzbl %al,%eax
c0104029:	85 c0                	test   %eax,%eax
c010402b:	74 0b                	je     c0104038 <default_check+0x3c3>
c010402d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104030:	8b 40 08             	mov    0x8(%eax),%eax
c0104033:	83 f8 01             	cmp    $0x1,%eax
c0104036:	74 24                	je     c010405c <default_check+0x3e7>
c0104038:	c7 44 24 0c 1c 96 10 	movl   $0xc010961c,0xc(%esp)
c010403f:	c0 
c0104040:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0104047:	c0 
c0104048:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010404f:	00 
c0104050:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0104057:	e8 79 cc ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010405c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010405f:	83 c0 04             	add    $0x4,%eax
c0104062:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104069:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010406c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010406f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104072:	0f a3 10             	bt     %edx,(%eax)
c0104075:	19 c0                	sbb    %eax,%eax
c0104077:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010407a:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010407e:	0f 95 c0             	setne  %al
c0104081:	0f b6 c0             	movzbl %al,%eax
c0104084:	85 c0                	test   %eax,%eax
c0104086:	74 0b                	je     c0104093 <default_check+0x41e>
c0104088:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010408b:	8b 40 08             	mov    0x8(%eax),%eax
c010408e:	83 f8 03             	cmp    $0x3,%eax
c0104091:	74 24                	je     c01040b7 <default_check+0x442>
c0104093:	c7 44 24 0c 44 96 10 	movl   $0xc0109644,0xc(%esp)
c010409a:	c0 
c010409b:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01040a2:	c0 
c01040a3:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01040aa:	00 
c01040ab:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01040b2:	e8 1e cc ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01040b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040be:	e8 5a 05 00 00       	call   c010461d <alloc_pages>
c01040c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040c9:	83 e8 20             	sub    $0x20,%eax
c01040cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040cf:	74 24                	je     c01040f5 <default_check+0x480>
c01040d1:	c7 44 24 0c 6a 96 10 	movl   $0xc010966a,0xc(%esp)
c01040d8:	c0 
c01040d9:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01040e0:	c0 
c01040e1:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01040e8:	00 
c01040e9:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01040f0:	e8 e0 cb ff ff       	call   c0100cd5 <__panic>
    free_page(p0);
c01040f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040fc:	00 
c01040fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104100:	89 04 24             	mov    %eax,(%esp)
c0104103:	e8 80 05 00 00       	call   c0104688 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104108:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010410f:	e8 09 05 00 00       	call   c010461d <alloc_pages>
c0104114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104117:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010411a:	83 c0 20             	add    $0x20,%eax
c010411d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104120:	74 24                	je     c0104146 <default_check+0x4d1>
c0104122:	c7 44 24 0c 88 96 10 	movl   $0xc0109688,0xc(%esp)
c0104129:	c0 
c010412a:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0104131:	c0 
c0104132:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104139:	00 
c010413a:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0104141:	e8 8f cb ff ff       	call   c0100cd5 <__panic>

    free_pages(p0, 2);
c0104146:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010414d:	00 
c010414e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104151:	89 04 24             	mov    %eax,(%esp)
c0104154:	e8 2f 05 00 00       	call   c0104688 <free_pages>
    free_page(p2);
c0104159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104160:	00 
c0104161:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104164:	89 04 24             	mov    %eax,(%esp)
c0104167:	e8 1c 05 00 00       	call   c0104688 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010416c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104173:	e8 a5 04 00 00       	call   c010461d <alloc_pages>
c0104178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010417b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010417f:	75 24                	jne    c01041a5 <default_check+0x530>
c0104181:	c7 44 24 0c a8 96 10 	movl   $0xc01096a8,0xc(%esp)
c0104188:	c0 
c0104189:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0104190:	c0 
c0104191:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104198:	00 
c0104199:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01041a0:	e8 30 cb ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c01041a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ac:	e8 6c 04 00 00       	call   c010461d <alloc_pages>
c01041b1:	85 c0                	test   %eax,%eax
c01041b3:	74 24                	je     c01041d9 <default_check+0x564>
c01041b5:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c01041bc:	c0 
c01041bd:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01041c4:	c0 
c01041c5:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01041cc:	00 
c01041cd:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01041d4:	e8 fc ca ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c01041d9:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01041de:	85 c0                	test   %eax,%eax
c01041e0:	74 24                	je     c0104206 <default_check+0x591>
c01041e2:	c7 44 24 0c 59 95 10 	movl   $0xc0109559,0xc(%esp)
c01041e9:	c0 
c01041ea:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01041f1:	c0 
c01041f2:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01041f9:	00 
c01041fa:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0104201:	e8 cf ca ff ff       	call   c0100cd5 <__panic>
    nr_free = nr_free_store;
c0104206:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104209:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_list = free_list_store;
c010420e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104211:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104214:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0104219:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    free_pages(p0, 5);
c010421f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104226:	00 
c0104227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010422a:	89 04 24             	mov    %eax,(%esp)
c010422d:	e8 56 04 00 00       	call   c0104688 <free_pages>

    le = &free_list;
c0104232:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104239:	eb 1d                	jmp    c0104258 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010423b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010423e:	83 e8 0c             	sub    $0xc,%eax
c0104241:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104244:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104248:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010424b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010424e:	8b 40 08             	mov    0x8(%eax),%eax
c0104251:	29 c2                	sub    %eax,%edx
c0104253:	89 d0                	mov    %edx,%eax
c0104255:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104258:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010425b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010425e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104261:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104264:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104267:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c010426e:	75 cb                	jne    c010423b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104274:	74 24                	je     c010429a <default_check+0x625>
c0104276:	c7 44 24 0c c6 96 10 	movl   $0xc01096c6,0xc(%esp)
c010427d:	c0 
c010427e:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c0104285:	c0 
c0104286:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010428d:	00 
c010428e:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c0104295:	e8 3b ca ff ff       	call   c0100cd5 <__panic>
    assert(total == 0);
c010429a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010429e:	74 24                	je     c01042c4 <default_check+0x64f>
c01042a0:	c7 44 24 0c d1 96 10 	movl   $0xc01096d1,0xc(%esp)
c01042a7:	c0 
c01042a8:	c7 44 24 08 96 93 10 	movl   $0xc0109396,0x8(%esp)
c01042af:	c0 
c01042b0:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01042b7:	00 
c01042b8:	c7 04 24 ab 93 10 c0 	movl   $0xc01093ab,(%esp)
c01042bf:	e8 11 ca ff ff       	call   c0100cd5 <__panic>
}
c01042c4:	81 c4 94 00 00 00    	add    $0x94,%esp
c01042ca:	5b                   	pop    %ebx
c01042cb:	5d                   	pop    %ebp
c01042cc:	c3                   	ret    

c01042cd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01042cd:	55                   	push   %ebp
c01042ce:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01042d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01042d3:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01042d8:	29 c2                	sub    %eax,%edx
c01042da:	89 d0                	mov    %edx,%eax
c01042dc:	c1 f8 05             	sar    $0x5,%eax
}
c01042df:	5d                   	pop    %ebp
c01042e0:	c3                   	ret    

c01042e1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01042e1:	55                   	push   %ebp
c01042e2:	89 e5                	mov    %esp,%ebp
c01042e4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01042e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ea:	89 04 24             	mov    %eax,(%esp)
c01042ed:	e8 db ff ff ff       	call   c01042cd <page2ppn>
c01042f2:	c1 e0 0c             	shl    $0xc,%eax
}
c01042f5:	c9                   	leave  
c01042f6:	c3                   	ret    

c01042f7 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01042f7:	55                   	push   %ebp
c01042f8:	89 e5                	mov    %esp,%ebp
c01042fa:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01042fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104300:	c1 e8 0c             	shr    $0xc,%eax
c0104303:	89 c2                	mov    %eax,%edx
c0104305:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010430a:	39 c2                	cmp    %eax,%edx
c010430c:	72 1c                	jb     c010432a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010430e:	c7 44 24 08 0c 97 10 	movl   $0xc010970c,0x8(%esp)
c0104315:	c0 
c0104316:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010431d:	00 
c010431e:	c7 04 24 2b 97 10 c0 	movl   $0xc010972b,(%esp)
c0104325:	e8 ab c9 ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c010432a:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010432f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104332:	c1 ea 0c             	shr    $0xc,%edx
c0104335:	c1 e2 05             	shl    $0x5,%edx
c0104338:	01 d0                	add    %edx,%eax
}
c010433a:	c9                   	leave  
c010433b:	c3                   	ret    

c010433c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010433c:	55                   	push   %ebp
c010433d:	89 e5                	mov    %esp,%ebp
c010433f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104342:	8b 45 08             	mov    0x8(%ebp),%eax
c0104345:	89 04 24             	mov    %eax,(%esp)
c0104348:	e8 94 ff ff ff       	call   c01042e1 <page2pa>
c010434d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104353:	c1 e8 0c             	shr    $0xc,%eax
c0104356:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104359:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010435e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104361:	72 23                	jb     c0104386 <page2kva+0x4a>
c0104363:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104366:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010436a:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c0104371:	c0 
c0104372:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104379:	00 
c010437a:	c7 04 24 2b 97 10 c0 	movl   $0xc010972b,(%esp)
c0104381:	e8 4f c9 ff ff       	call   c0100cd5 <__panic>
c0104386:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104389:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010438e:	c9                   	leave  
c010438f:	c3                   	ret    

c0104390 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104390:	55                   	push   %ebp
c0104391:	89 e5                	mov    %esp,%ebp
c0104393:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104396:	8b 45 08             	mov    0x8(%ebp),%eax
c0104399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010439c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043a3:	77 23                	ja     c01043c8 <kva2page+0x38>
c01043a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043ac:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c01043b3:	c0 
c01043b4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01043bb:	00 
c01043bc:	c7 04 24 2b 97 10 c0 	movl   $0xc010972b,(%esp)
c01043c3:	e8 0d c9 ff ff       	call   c0100cd5 <__panic>
c01043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043cb:	05 00 00 00 40       	add    $0x40000000,%eax
c01043d0:	89 04 24             	mov    %eax,(%esp)
c01043d3:	e8 1f ff ff ff       	call   c01042f7 <pa2page>
}
c01043d8:	c9                   	leave  
c01043d9:	c3                   	ret    

c01043da <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01043da:	55                   	push   %ebp
c01043db:	89 e5                	mov    %esp,%ebp
c01043dd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01043e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e3:	83 e0 01             	and    $0x1,%eax
c01043e6:	85 c0                	test   %eax,%eax
c01043e8:	75 1c                	jne    c0104406 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01043ea:	c7 44 24 08 84 97 10 	movl   $0xc0109784,0x8(%esp)
c01043f1:	c0 
c01043f2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01043f9:	00 
c01043fa:	c7 04 24 2b 97 10 c0 	movl   $0xc010972b,(%esp)
c0104401:	e8 cf c8 ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104406:	8b 45 08             	mov    0x8(%ebp),%eax
c0104409:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010440e:	89 04 24             	mov    %eax,(%esp)
c0104411:	e8 e1 fe ff ff       	call   c01042f7 <pa2page>
}
c0104416:	c9                   	leave  
c0104417:	c3                   	ret    

c0104418 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104418:	55                   	push   %ebp
c0104419:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010441b:	8b 45 08             	mov    0x8(%ebp),%eax
c010441e:	8b 00                	mov    (%eax),%eax
}
c0104420:	5d                   	pop    %ebp
c0104421:	c3                   	ret    

c0104422 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104422:	55                   	push   %ebp
c0104423:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104425:	8b 45 08             	mov    0x8(%ebp),%eax
c0104428:	8b 55 0c             	mov    0xc(%ebp),%edx
c010442b:	89 10                	mov    %edx,(%eax)
}
c010442d:	5d                   	pop    %ebp
c010442e:	c3                   	ret    

c010442f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010442f:	55                   	push   %ebp
c0104430:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104432:	8b 45 08             	mov    0x8(%ebp),%eax
c0104435:	8b 00                	mov    (%eax),%eax
c0104437:	8d 50 01             	lea    0x1(%eax),%edx
c010443a:	8b 45 08             	mov    0x8(%ebp),%eax
c010443d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010443f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104442:	8b 00                	mov    (%eax),%eax
}
c0104444:	5d                   	pop    %ebp
c0104445:	c3                   	ret    

c0104446 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104446:	55                   	push   %ebp
c0104447:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104449:	8b 45 08             	mov    0x8(%ebp),%eax
c010444c:	8b 00                	mov    (%eax),%eax
c010444e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104451:	8b 45 08             	mov    0x8(%ebp),%eax
c0104454:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104456:	8b 45 08             	mov    0x8(%ebp),%eax
c0104459:	8b 00                	mov    (%eax),%eax
}
c010445b:	5d                   	pop    %ebp
c010445c:	c3                   	ret    

c010445d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010445d:	55                   	push   %ebp
c010445e:	89 e5                	mov    %esp,%ebp
c0104460:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104463:	9c                   	pushf  
c0104464:	58                   	pop    %eax
c0104465:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104468:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010446b:	25 00 02 00 00       	and    $0x200,%eax
c0104470:	85 c0                	test   %eax,%eax
c0104472:	74 0c                	je     c0104480 <__intr_save+0x23>
        intr_disable();
c0104474:	e8 b4 da ff ff       	call   c0101f2d <intr_disable>
        return 1;
c0104479:	b8 01 00 00 00       	mov    $0x1,%eax
c010447e:	eb 05                	jmp    c0104485 <__intr_save+0x28>
    }
    return 0;
c0104480:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104485:	c9                   	leave  
c0104486:	c3                   	ret    

c0104487 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104487:	55                   	push   %ebp
c0104488:	89 e5                	mov    %esp,%ebp
c010448a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010448d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104491:	74 05                	je     c0104498 <__intr_restore+0x11>
        intr_enable();
c0104493:	e8 8f da ff ff       	call   c0101f27 <intr_enable>
    }
}
c0104498:	c9                   	leave  
c0104499:	c3                   	ret    

c010449a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010449a:	55                   	push   %ebp
c010449b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c010449d:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01044a3:	b8 23 00 00 00       	mov    $0x23,%eax
c01044a8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01044aa:	b8 23 00 00 00       	mov    $0x23,%eax
c01044af:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01044b1:	b8 10 00 00 00       	mov    $0x10,%eax
c01044b6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01044b8:	b8 10 00 00 00       	mov    $0x10,%eax
c01044bd:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01044bf:	b8 10 00 00 00       	mov    $0x10,%eax
c01044c4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01044c6:	ea cd 44 10 c0 08 00 	ljmp   $0x8,$0xc01044cd
}
c01044cd:	5d                   	pop    %ebp
c01044ce:	c3                   	ret    

c01044cf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01044cf:	55                   	push   %ebp
c01044d0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01044d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d5:	a3 44 1a 12 c0       	mov    %eax,0xc0121a44
}
c01044da:	5d                   	pop    %ebp
c01044db:	c3                   	ret    

c01044dc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01044dc:	55                   	push   %ebp
c01044dd:	89 e5                	mov    %esp,%ebp
c01044df:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01044e2:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c01044e7:	89 04 24             	mov    %eax,(%esp)
c01044ea:	e8 e0 ff ff ff       	call   c01044cf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01044ef:	66 c7 05 48 1a 12 c0 	movw   $0x10,0xc0121a48
c01044f6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01044f8:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c01044ff:	68 00 
c0104501:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104506:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c010450c:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104511:	c1 e8 10             	shr    $0x10,%eax
c0104514:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0104519:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104520:	83 e0 f0             	and    $0xfffffff0,%eax
c0104523:	83 c8 09             	or     $0x9,%eax
c0104526:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010452b:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104532:	83 e0 ef             	and    $0xffffffef,%eax
c0104535:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010453a:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104541:	83 e0 9f             	and    $0xffffff9f,%eax
c0104544:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104549:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104550:	83 c8 80             	or     $0xffffff80,%eax
c0104553:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104558:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010455f:	83 e0 f0             	and    $0xfffffff0,%eax
c0104562:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104567:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010456e:	83 e0 ef             	and    $0xffffffef,%eax
c0104571:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104576:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010457d:	83 e0 df             	and    $0xffffffdf,%eax
c0104580:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104585:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010458c:	83 c8 40             	or     $0x40,%eax
c010458f:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104594:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010459b:	83 e0 7f             	and    $0x7f,%eax
c010459e:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01045a3:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c01045a8:	c1 e8 18             	shr    $0x18,%eax
c01045ab:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01045b0:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c01045b7:	e8 de fe ff ff       	call   c010449a <lgdt>
c01045bc:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01045c2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01045c6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01045c9:	c9                   	leave  
c01045ca:	c3                   	ret    

c01045cb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01045cb:	55                   	push   %ebp
c01045cc:	89 e5                	mov    %esp,%ebp
c01045ce:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01045d1:	c7 05 cc 1a 12 c0 f0 	movl   $0xc01096f0,0xc0121acc
c01045d8:	96 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01045db:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01045e0:	8b 00                	mov    (%eax),%eax
c01045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e6:	c7 04 24 b0 97 10 c0 	movl   $0xc01097b0,(%esp)
c01045ed:	e8 59 bd ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c01045f2:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01045f7:	8b 40 04             	mov    0x4(%eax),%eax
c01045fa:	ff d0                	call   *%eax
}
c01045fc:	c9                   	leave  
c01045fd:	c3                   	ret    

c01045fe <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01045fe:	55                   	push   %ebp
c01045ff:	89 e5                	mov    %esp,%ebp
c0104601:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104604:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104609:	8b 40 08             	mov    0x8(%eax),%eax
c010460c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010460f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104613:	8b 55 08             	mov    0x8(%ebp),%edx
c0104616:	89 14 24             	mov    %edx,(%esp)
c0104619:	ff d0                	call   *%eax
}
c010461b:	c9                   	leave  
c010461c:	c3                   	ret    

c010461d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010461d:	55                   	push   %ebp
c010461e:	89 e5                	mov    %esp,%ebp
c0104620:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010462a:	e8 2e fe ff ff       	call   c010445d <__intr_save>
c010462f:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104632:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104637:	8b 40 0c             	mov    0xc(%eax),%eax
c010463a:	8b 55 08             	mov    0x8(%ebp),%edx
c010463d:	89 14 24             	mov    %edx,(%esp)
c0104640:	ff d0                	call   *%eax
c0104642:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104645:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104648:	89 04 24             	mov    %eax,(%esp)
c010464b:	e8 37 fe ff ff       	call   c0104487 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104654:	75 2d                	jne    c0104683 <alloc_pages+0x66>
c0104656:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010465a:	77 27                	ja     c0104683 <alloc_pages+0x66>
c010465c:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0104661:	85 c0                	test   %eax,%eax
c0104663:	74 1e                	je     c0104683 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104665:	8b 55 08             	mov    0x8(%ebp),%edx
c0104668:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010466d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104674:	00 
c0104675:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104679:	89 04 24             	mov    %eax,(%esp)
c010467c:	e8 ac 1a 00 00       	call   c010612d <swap_out>
    }
c0104681:	eb a7                	jmp    c010462a <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104683:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104686:	c9                   	leave  
c0104687:	c3                   	ret    

c0104688 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104688:	55                   	push   %ebp
c0104689:	89 e5                	mov    %esp,%ebp
c010468b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010468e:	e8 ca fd ff ff       	call   c010445d <__intr_save>
c0104693:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104696:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c010469b:	8b 40 10             	mov    0x10(%eax),%eax
c010469e:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01046a8:	89 14 24             	mov    %edx,(%esp)
c01046ab:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b0:	89 04 24             	mov    %eax,(%esp)
c01046b3:	e8 cf fd ff ff       	call   c0104487 <__intr_restore>
}
c01046b8:	c9                   	leave  
c01046b9:	c3                   	ret    

c01046ba <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01046ba:	55                   	push   %ebp
c01046bb:	89 e5                	mov    %esp,%ebp
c01046bd:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01046c0:	e8 98 fd ff ff       	call   c010445d <__intr_save>
c01046c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01046c8:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01046cd:	8b 40 14             	mov    0x14(%eax),%eax
c01046d0:	ff d0                	call   *%eax
c01046d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d8:	89 04 24             	mov    %eax,(%esp)
c01046db:	e8 a7 fd ff ff       	call   c0104487 <__intr_restore>
    return ret;
c01046e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01046e3:	c9                   	leave  
c01046e4:	c3                   	ret    

c01046e5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01046e5:	55                   	push   %ebp
c01046e6:	89 e5                	mov    %esp,%ebp
c01046e8:	57                   	push   %edi
c01046e9:	56                   	push   %esi
c01046ea:	53                   	push   %ebx
c01046eb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01046f1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01046f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01046ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104706:	c7 04 24 c7 97 10 c0 	movl   $0xc01097c7,(%esp)
c010470d:	e8 39 bc ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104712:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104719:	e9 15 01 00 00       	jmp    c0104833 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010471e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104721:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104724:	89 d0                	mov    %edx,%eax
c0104726:	c1 e0 02             	shl    $0x2,%eax
c0104729:	01 d0                	add    %edx,%eax
c010472b:	c1 e0 02             	shl    $0x2,%eax
c010472e:	01 c8                	add    %ecx,%eax
c0104730:	8b 50 08             	mov    0x8(%eax),%edx
c0104733:	8b 40 04             	mov    0x4(%eax),%eax
c0104736:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104739:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010473c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010473f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104742:	89 d0                	mov    %edx,%eax
c0104744:	c1 e0 02             	shl    $0x2,%eax
c0104747:	01 d0                	add    %edx,%eax
c0104749:	c1 e0 02             	shl    $0x2,%eax
c010474c:	01 c8                	add    %ecx,%eax
c010474e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104751:	8b 58 10             	mov    0x10(%eax),%ebx
c0104754:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104757:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010475a:	01 c8                	add    %ecx,%eax
c010475c:	11 da                	adc    %ebx,%edx
c010475e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104761:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104764:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104767:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010476a:	89 d0                	mov    %edx,%eax
c010476c:	c1 e0 02             	shl    $0x2,%eax
c010476f:	01 d0                	add    %edx,%eax
c0104771:	c1 e0 02             	shl    $0x2,%eax
c0104774:	01 c8                	add    %ecx,%eax
c0104776:	83 c0 14             	add    $0x14,%eax
c0104779:	8b 00                	mov    (%eax),%eax
c010477b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104781:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104784:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104787:	83 c0 ff             	add    $0xffffffff,%eax
c010478a:	83 d2 ff             	adc    $0xffffffff,%edx
c010478d:	89 c6                	mov    %eax,%esi
c010478f:	89 d7                	mov    %edx,%edi
c0104791:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104794:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104797:	89 d0                	mov    %edx,%eax
c0104799:	c1 e0 02             	shl    $0x2,%eax
c010479c:	01 d0                	add    %edx,%eax
c010479e:	c1 e0 02             	shl    $0x2,%eax
c01047a1:	01 c8                	add    %ecx,%eax
c01047a3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01047a6:	8b 58 10             	mov    0x10(%eax),%ebx
c01047a9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01047af:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01047b3:	89 74 24 14          	mov    %esi,0x14(%esp)
c01047b7:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01047bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047be:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047c5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01047c9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01047cd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01047d1:	c7 04 24 d4 97 10 c0 	movl   $0xc01097d4,(%esp)
c01047d8:	e8 6e bb ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01047dd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047e3:	89 d0                	mov    %edx,%eax
c01047e5:	c1 e0 02             	shl    $0x2,%eax
c01047e8:	01 d0                	add    %edx,%eax
c01047ea:	c1 e0 02             	shl    $0x2,%eax
c01047ed:	01 c8                	add    %ecx,%eax
c01047ef:	83 c0 14             	add    $0x14,%eax
c01047f2:	8b 00                	mov    (%eax),%eax
c01047f4:	83 f8 01             	cmp    $0x1,%eax
c01047f7:	75 36                	jne    c010482f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01047f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047ff:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104802:	77 2b                	ja     c010482f <page_init+0x14a>
c0104804:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104807:	72 05                	jb     c010480e <page_init+0x129>
c0104809:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010480c:	73 21                	jae    c010482f <page_init+0x14a>
c010480e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104812:	77 1b                	ja     c010482f <page_init+0x14a>
c0104814:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104818:	72 09                	jb     c0104823 <page_init+0x13e>
c010481a:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104821:	77 0c                	ja     c010482f <page_init+0x14a>
                maxpa = end;
c0104823:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104826:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104829:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010482c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010482f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104833:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104836:	8b 00                	mov    (%eax),%eax
c0104838:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010483b:	0f 8f dd fe ff ff    	jg     c010471e <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104845:	72 1d                	jb     c0104864 <page_init+0x17f>
c0104847:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010484b:	77 09                	ja     c0104856 <page_init+0x171>
c010484d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104854:	76 0e                	jbe    c0104864 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104856:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010485d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104864:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104867:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010486a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010486e:	c1 ea 0c             	shr    $0xc,%edx
c0104871:	a3 20 1a 12 c0       	mov    %eax,0xc0121a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104876:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010487d:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c0104882:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104885:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104888:	01 d0                	add    %edx,%eax
c010488a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010488d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104890:	ba 00 00 00 00       	mov    $0x0,%edx
c0104895:	f7 75 ac             	divl   -0x54(%ebp)
c0104898:	89 d0                	mov    %edx,%eax
c010489a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010489d:	29 c2                	sub    %eax,%edx
c010489f:	89 d0                	mov    %edx,%eax
c01048a1:	a3 d4 1a 12 c0       	mov    %eax,0xc0121ad4

    for (i = 0; i < npage; i ++) {
c01048a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01048ad:	eb 27                	jmp    c01048d6 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01048af:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01048b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048b7:	c1 e2 05             	shl    $0x5,%edx
c01048ba:	01 d0                	add    %edx,%eax
c01048bc:	83 c0 04             	add    $0x4,%eax
c01048bf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01048c6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048c9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01048cc:	8b 55 90             	mov    -0x70(%ebp),%edx
c01048cf:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01048d2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01048d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048d9:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01048de:	39 c2                	cmp    %eax,%edx
c01048e0:	72 cd                	jb     c01048af <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01048e2:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01048e7:	c1 e0 05             	shl    $0x5,%eax
c01048ea:	89 c2                	mov    %eax,%edx
c01048ec:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01048f1:	01 d0                	add    %edx,%eax
c01048f3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01048f6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01048fd:	77 23                	ja     c0104922 <page_init+0x23d>
c01048ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104902:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104906:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c010490d:	c0 
c010490e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104915:	00 
c0104916:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010491d:	e8 b3 c3 ff ff       	call   c0100cd5 <__panic>
c0104922:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104925:	05 00 00 00 40       	add    $0x40000000,%eax
c010492a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010492d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104934:	e9 74 01 00 00       	jmp    c0104aad <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104939:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010493c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010493f:	89 d0                	mov    %edx,%eax
c0104941:	c1 e0 02             	shl    $0x2,%eax
c0104944:	01 d0                	add    %edx,%eax
c0104946:	c1 e0 02             	shl    $0x2,%eax
c0104949:	01 c8                	add    %ecx,%eax
c010494b:	8b 50 08             	mov    0x8(%eax),%edx
c010494e:	8b 40 04             	mov    0x4(%eax),%eax
c0104951:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104954:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104957:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010495a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010495d:	89 d0                	mov    %edx,%eax
c010495f:	c1 e0 02             	shl    $0x2,%eax
c0104962:	01 d0                	add    %edx,%eax
c0104964:	c1 e0 02             	shl    $0x2,%eax
c0104967:	01 c8                	add    %ecx,%eax
c0104969:	8b 48 0c             	mov    0xc(%eax),%ecx
c010496c:	8b 58 10             	mov    0x10(%eax),%ebx
c010496f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104972:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104975:	01 c8                	add    %ecx,%eax
c0104977:	11 da                	adc    %ebx,%edx
c0104979:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010497c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010497f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104982:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104985:	89 d0                	mov    %edx,%eax
c0104987:	c1 e0 02             	shl    $0x2,%eax
c010498a:	01 d0                	add    %edx,%eax
c010498c:	c1 e0 02             	shl    $0x2,%eax
c010498f:	01 c8                	add    %ecx,%eax
c0104991:	83 c0 14             	add    $0x14,%eax
c0104994:	8b 00                	mov    (%eax),%eax
c0104996:	83 f8 01             	cmp    $0x1,%eax
c0104999:	0f 85 0a 01 00 00    	jne    c0104aa9 <page_init+0x3c4>
            if (begin < freemem) {
c010499f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01049a2:	ba 00 00 00 00       	mov    $0x0,%edx
c01049a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01049aa:	72 17                	jb     c01049c3 <page_init+0x2de>
c01049ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01049af:	77 05                	ja     c01049b6 <page_init+0x2d1>
c01049b1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01049b4:	76 0d                	jbe    c01049c3 <page_init+0x2de>
                begin = freemem;
c01049b6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01049b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01049c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01049c7:	72 1d                	jb     c01049e6 <page_init+0x301>
c01049c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01049cd:	77 09                	ja     c01049d8 <page_init+0x2f3>
c01049cf:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01049d6:	76 0e                	jbe    c01049e6 <page_init+0x301>
                end = KMEMSIZE;
c01049d8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01049df:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01049e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049ec:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01049ef:	0f 87 b4 00 00 00    	ja     c0104aa9 <page_init+0x3c4>
c01049f5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01049f8:	72 09                	jb     c0104a03 <page_init+0x31e>
c01049fa:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01049fd:	0f 83 a6 00 00 00    	jae    c0104aa9 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104a03:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104a0a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a0d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a10:	01 d0                	add    %edx,%eax
c0104a12:	83 e8 01             	sub    $0x1,%eax
c0104a15:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a18:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a1b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a20:	f7 75 9c             	divl   -0x64(%ebp)
c0104a23:	89 d0                	mov    %edx,%eax
c0104a25:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104a28:	29 c2                	sub    %eax,%edx
c0104a2a:	89 d0                	mov    %edx,%eax
c0104a2c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a31:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104a37:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a3a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104a3d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a40:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a45:	89 c7                	mov    %eax,%edi
c0104a47:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104a4d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104a50:	89 d0                	mov    %edx,%eax
c0104a52:	83 e0 00             	and    $0x0,%eax
c0104a55:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104a58:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104a5b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a61:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104a64:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a6a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a6d:	77 3a                	ja     c0104aa9 <page_init+0x3c4>
c0104a6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a72:	72 05                	jb     c0104a79 <page_init+0x394>
c0104a74:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104a77:	73 30                	jae    c0104aa9 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104a79:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104a7c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104a7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a82:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a85:	29 c8                	sub    %ecx,%eax
c0104a87:	19 da                	sbb    %ebx,%edx
c0104a89:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104a8d:	c1 ea 0c             	shr    $0xc,%edx
c0104a90:	89 c3                	mov    %eax,%ebx
c0104a92:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a95:	89 04 24             	mov    %eax,(%esp)
c0104a98:	e8 5a f8 ff ff       	call   c01042f7 <pa2page>
c0104a9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104aa1:	89 04 24             	mov    %eax,(%esp)
c0104aa4:	e8 55 fb ff ff       	call   c01045fe <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104aa9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104aad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ab0:	8b 00                	mov    (%eax),%eax
c0104ab2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104ab5:	0f 8f 7e fe ff ff    	jg     c0104939 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104abb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104ac1:	5b                   	pop    %ebx
c0104ac2:	5e                   	pop    %esi
c0104ac3:	5f                   	pop    %edi
c0104ac4:	5d                   	pop    %ebp
c0104ac5:	c3                   	ret    

c0104ac6 <enable_paging>:

static void
enable_paging(void) {
c0104ac6:	55                   	push   %ebp
c0104ac7:	89 e5                	mov    %esp,%ebp
c0104ac9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104acc:	a1 d0 1a 12 c0       	mov    0xc0121ad0,%eax
c0104ad1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104ad4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104ad7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104ada:	0f 20 c0             	mov    %cr0,%eax
c0104add:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104ae6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104aed:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104afa:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104afd:	c9                   	leave  
c0104afe:	c3                   	ret    

c0104aff <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104aff:	55                   	push   %ebp
c0104b00:	89 e5                	mov    %esp,%ebp
c0104b02:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104b05:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b0b:	31 d0                	xor    %edx,%eax
c0104b0d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b12:	85 c0                	test   %eax,%eax
c0104b14:	74 24                	je     c0104b3a <boot_map_segment+0x3b>
c0104b16:	c7 44 24 0c 12 98 10 	movl   $0xc0109812,0xc(%esp)
c0104b1d:	c0 
c0104b1e:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0104b25:	c0 
c0104b26:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104b2d:	00 
c0104b2e:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104b35:	e8 9b c1 ff ff       	call   c0100cd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104b3a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104b41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b44:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b49:	89 c2                	mov    %eax,%edx
c0104b4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104b4e:	01 c2                	add    %eax,%edx
c0104b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b53:	01 d0                	add    %edx,%eax
c0104b55:	83 e8 01             	sub    $0x1,%eax
c0104b58:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b5e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b63:	f7 75 f0             	divl   -0x10(%ebp)
c0104b66:	89 d0                	mov    %edx,%eax
c0104b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b6b:	29 c2                	sub    %eax,%edx
c0104b6d:	89 d0                	mov    %edx,%eax
c0104b6f:	c1 e8 0c             	shr    $0xc,%eax
c0104b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104b75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b78:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b83:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104b86:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b94:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104b97:	eb 6b                	jmp    c0104c04 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104b99:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104ba0:	00 
c0104ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bab:	89 04 24             	mov    %eax,(%esp)
c0104bae:	e8 cc 01 00 00       	call   c0104d7f <get_pte>
c0104bb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104bb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104bba:	75 24                	jne    c0104be0 <boot_map_segment+0xe1>
c0104bbc:	c7 44 24 0c 3e 98 10 	movl   $0xc010983e,0xc(%esp)
c0104bc3:	c0 
c0104bc4:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0104bcb:	c0 
c0104bcc:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104bd3:	00 
c0104bd4:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104bdb:	e8 f5 c0 ff ff       	call   c0100cd5 <__panic>
        *ptep = pa | PTE_P | perm;
c0104be0:	8b 45 18             	mov    0x18(%ebp),%eax
c0104be3:	8b 55 14             	mov    0x14(%ebp),%edx
c0104be6:	09 d0                	or     %edx,%eax
c0104be8:	83 c8 01             	or     $0x1,%eax
c0104beb:	89 c2                	mov    %eax,%edx
c0104bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bf0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104bf2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104bf6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104bfd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c08:	75 8f                	jne    c0104b99 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104c0a:	c9                   	leave  
c0104c0b:	c3                   	ret    

c0104c0c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104c0c:	55                   	push   %ebp
c0104c0d:	89 e5                	mov    %esp,%ebp
c0104c0f:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104c12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c19:	e8 ff f9 ff ff       	call   c010461d <alloc_pages>
c0104c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c25:	75 1c                	jne    c0104c43 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104c27:	c7 44 24 08 4b 98 10 	movl   $0xc010984b,0x8(%esp)
c0104c2e:	c0 
c0104c2f:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104c36:	00 
c0104c37:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104c3e:	e8 92 c0 ff ff       	call   c0100cd5 <__panic>
    }
    return page2kva(p);
c0104c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c46:	89 04 24             	mov    %eax,(%esp)
c0104c49:	e8 ee f6 ff ff       	call   c010433c <page2kva>
}
c0104c4e:	c9                   	leave  
c0104c4f:	c3                   	ret    

c0104c50 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104c50:	55                   	push   %ebp
c0104c51:	89 e5                	mov    %esp,%ebp
c0104c53:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104c56:	e8 70 f9 ff ff       	call   c01045cb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104c5b:	e8 85 fa ff ff       	call   c01046e5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104c60:	e8 46 05 00 00       	call   c01051ab <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104c65:	e8 a2 ff ff ff       	call   c0104c0c <boot_alloc_page>
c0104c6a:	a3 24 1a 12 c0       	mov    %eax,0xc0121a24
    memset(boot_pgdir, 0, PGSIZE);
c0104c6f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104c74:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c7b:	00 
c0104c7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c83:	00 
c0104c84:	89 04 24             	mov    %eax,(%esp)
c0104c87:	e8 0a 3d 00 00       	call   c0108996 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104c8c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c94:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104c9b:	77 23                	ja     c0104cc0 <pmm_init+0x70>
c0104c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ca4:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c0104cab:	c0 
c0104cac:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104cb3:	00 
c0104cb4:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104cbb:	e8 15 c0 ff ff       	call   c0100cd5 <__panic>
c0104cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc3:	05 00 00 00 40       	add    $0x40000000,%eax
c0104cc8:	a3 d0 1a 12 c0       	mov    %eax,0xc0121ad0

    check_pgdir();
c0104ccd:	e8 f7 04 00 00       	call   c01051c9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104cd2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104cd7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104cdd:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ce5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104cec:	77 23                	ja     c0104d11 <pmm_init+0xc1>
c0104cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104cf5:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c0104cfc:	c0 
c0104cfd:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104d04:	00 
c0104d05:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104d0c:	e8 c4 bf ff ff       	call   c0100cd5 <__panic>
c0104d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d14:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d19:	83 c8 03             	or     $0x3,%eax
c0104d1c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104d1e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104d23:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104d2a:	00 
c0104d2b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d32:	00 
c0104d33:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104d3a:	38 
c0104d3b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104d42:	c0 
c0104d43:	89 04 24             	mov    %eax,(%esp)
c0104d46:	e8 b4 fd ff ff       	call   c0104aff <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104d4b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104d50:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0104d56:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104d5c:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104d5e:	e8 63 fd ff ff       	call   c0104ac6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104d63:	e8 74 f7 ff ff       	call   c01044dc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104d68:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104d73:	e8 ec 0a 00 00       	call   c0105864 <check_boot_pgdir>

    print_pgdir();
c0104d78:	e8 79 0f 00 00       	call   c0105cf6 <print_pgdir>

}
c0104d7d:	c9                   	leave  
c0104d7e:	c3                   	ret    

c0104d7f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104d7f:	55                   	push   %ebp
c0104d80:	89 e5                	mov    %esp,%ebp
c0104d82:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
c0104d85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d88:	c1 e8 16             	shr    $0x16,%eax
c0104d8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d95:	01 d0                	add    %edx,%eax
c0104d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P)){
c0104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9d:	8b 00                	mov    (%eax),%eax
c0104d9f:	83 e0 01             	and    $0x1,%eax
c0104da2:	85 c0                	test   %eax,%eax
c0104da4:	0f 85 b9 00 00 00    	jne    c0104e63 <get_pte+0xe4>
		if (!create){
c0104daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104dae:	75 0a                	jne    c0104dba <get_pte+0x3b>
			return NULL;
c0104db0:	b8 00 00 00 00       	mov    $0x0,%eax
c0104db5:	e9 0b 01 00 00       	jmp    c0104ec5 <get_pte+0x146>
		}
		struct Page* p = alloc_page();
c0104dba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dc1:	e8 57 f8 ff ff       	call   c010461d <alloc_pages>
c0104dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (p==NULL){
c0104dc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dcd:	75 0a                	jne    c0104dd9 <get_pte+0x5a>
			return NULL;
c0104dcf:	b8 00 00 00 00       	mov    $0x0,%eax
c0104dd4:	e9 ec 00 00 00       	jmp    c0104ec5 <get_pte+0x146>
		}
		set_page_ref(p,1);
c0104dd9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104de0:	00 
c0104de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de4:	89 04 24             	mov    %eax,(%esp)
c0104de7:	e8 36 f6 ff ff       	call   c0104422 <set_page_ref>
		uintptr_t ad = page2pa(p);
c0104dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104def:	89 04 24             	mov    %eax,(%esp)
c0104df2:	e8 ea f4 ff ff       	call   c01042e1 <page2pa>
c0104df7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(ad),0,PGSIZE);
c0104dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e03:	c1 e8 0c             	shr    $0xc,%eax
c0104e06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e09:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104e0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e11:	72 23                	jb     c0104e36 <get_pte+0xb7>
c0104e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e16:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e1a:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c0104e21:	c0 
c0104e22:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0104e29:	00 
c0104e2a:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104e31:	e8 9f be ff ff       	call   c0100cd5 <__panic>
c0104e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e39:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e45:	00 
c0104e46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e4d:	00 
c0104e4e:	89 04 24             	mov    %eax,(%esp)
c0104e51:	e8 40 3b 00 00       	call   c0108996 <memset>
		*pdep = ad|PTE_U|PTE_W|PTE_P;//have problem
c0104e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e59:	83 c8 07             	or     $0x7,%eax
c0104e5c:	89 c2                	mov    %eax,%edx
c0104e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e61:	89 10                	mov    %edx,(%eax)
	}
	uintptr_t d = PDE_ADDR(*pdep);
c0104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e66:	8b 00                	mov    (%eax),%eax
c0104e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	return &((pte_t*)KADDR(d))[PTX(la)];
c0104e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e73:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e79:	c1 e8 0c             	shr    $0xc,%eax
c0104e7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104e7f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104e84:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104e87:	72 23                	jb     c0104eac <get_pte+0x12d>
c0104e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e90:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c0104e97:	c0 
c0104e98:	c7 44 24 04 9b 01 00 	movl   $0x19b,0x4(%esp)
c0104e9f:	00 
c0104ea0:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104ea7:	e8 29 be ff ff       	call   c0100cd5 <__panic>
c0104eac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104eaf:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104eb7:	c1 ea 0c             	shr    $0xc,%edx
c0104eba:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104ec0:	c1 e2 02             	shl    $0x2,%edx
c0104ec3:	01 d0                	add    %edx,%eax
}
c0104ec5:	c9                   	leave  
c0104ec6:	c3                   	ret    

c0104ec7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104ec7:	55                   	push   %ebp
c0104ec8:	89 e5                	mov    %esp,%ebp
c0104eca:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104ecd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ed4:	00 
c0104ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104edc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104edf:	89 04 24             	mov    %eax,(%esp)
c0104ee2:	e8 98 fe ff ff       	call   c0104d7f <get_pte>
c0104ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104eee:	74 08                	je     c0104ef8 <get_page+0x31>
        *ptep_store = ptep;
c0104ef0:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ef6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104ef8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104efc:	74 1b                	je     c0104f19 <get_page+0x52>
c0104efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f01:	8b 00                	mov    (%eax),%eax
c0104f03:	83 e0 01             	and    $0x1,%eax
c0104f06:	85 c0                	test   %eax,%eax
c0104f08:	74 0f                	je     c0104f19 <get_page+0x52>
        return pa2page(*ptep);
c0104f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f0d:	8b 00                	mov    (%eax),%eax
c0104f0f:	89 04 24             	mov    %eax,(%esp)
c0104f12:	e8 e0 f3 ff ff       	call   c01042f7 <pa2page>
c0104f17:	eb 05                	jmp    c0104f1e <get_page+0x57>
    }
    return NULL;
c0104f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f1e:	c9                   	leave  
c0104f1f:	c3                   	ret    

c0104f20 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f20:	55                   	push   %ebp
c0104f21:	89 e5                	mov    %esp,%ebp
c0104f23:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if (*ptep & PTE_P) {
c0104f26:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f29:	8b 00                	mov    (%eax),%eax
c0104f2b:	83 e0 01             	and    $0x1,%eax
c0104f2e:	85 c0                	test   %eax,%eax
c0104f30:	74 52                	je     c0104f84 <page_remove_pte+0x64>
		struct Page* p = pte2page(*ptep);
c0104f32:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f35:	8b 00                	mov    (%eax),%eax
c0104f37:	89 04 24             	mov    %eax,(%esp)
c0104f3a:	e8 9b f4 ff ff       	call   c01043da <pte2page>
c0104f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		page_ref_dec(p);
c0104f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f45:	89 04 24             	mov    %eax,(%esp)
c0104f48:	e8 f9 f4 ff ff       	call   c0104446 <page_ref_dec>
		if (p->ref==0){
c0104f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f50:	8b 00                	mov    (%eax),%eax
c0104f52:	85 c0                	test   %eax,%eax
c0104f54:	75 13                	jne    c0104f69 <page_remove_pte+0x49>
			free_page(p);
c0104f56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f5d:	00 
c0104f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f61:	89 04 24             	mov    %eax,(%esp)
c0104f64:	e8 1f f7 ff ff       	call   c0104688 <free_pages>
		}
		*ptep = 0;
c0104f69:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c0104f72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f79:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f7c:	89 04 24             	mov    %eax,(%esp)
c0104f7f:	e8 ff 00 00 00       	call   c0105083 <tlb_invalidate>
	}
}
c0104f84:	c9                   	leave  
c0104f85:	c3                   	ret    

c0104f86 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104f86:	55                   	push   %ebp
c0104f87:	89 e5                	mov    %esp,%ebp
c0104f89:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f93:	00 
c0104f94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f9e:	89 04 24             	mov    %eax,(%esp)
c0104fa1:	e8 d9 fd ff ff       	call   c0104d7f <get_pte>
c0104fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fad:	74 19                	je     c0104fc8 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fb2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc0:	89 04 24             	mov    %eax,(%esp)
c0104fc3:	e8 58 ff ff ff       	call   c0104f20 <page_remove_pte>
    }
}
c0104fc8:	c9                   	leave  
c0104fc9:	c3                   	ret    

c0104fca <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104fca:	55                   	push   %ebp
c0104fcb:	89 e5                	mov    %esp,%ebp
c0104fcd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104fd0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104fd7:	00 
c0104fd8:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe2:	89 04 24             	mov    %eax,(%esp)
c0104fe5:	e8 95 fd ff ff       	call   c0104d7f <get_pte>
c0104fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ff1:	75 0a                	jne    c0104ffd <page_insert+0x33>
        return -E_NO_MEM;
c0104ff3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104ff8:	e9 84 00 00 00       	jmp    c0105081 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105000:	89 04 24             	mov    %eax,(%esp)
c0105003:	e8 27 f4 ff ff       	call   c010442f <page_ref_inc>
    if (*ptep & PTE_P) {
c0105008:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010500b:	8b 00                	mov    (%eax),%eax
c010500d:	83 e0 01             	and    $0x1,%eax
c0105010:	85 c0                	test   %eax,%eax
c0105012:	74 3e                	je     c0105052 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105014:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105017:	8b 00                	mov    (%eax),%eax
c0105019:	89 04 24             	mov    %eax,(%esp)
c010501c:	e8 b9 f3 ff ff       	call   c01043da <pte2page>
c0105021:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105024:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105027:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010502a:	75 0d                	jne    c0105039 <page_insert+0x6f>
            page_ref_dec(page);
c010502c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010502f:	89 04 24             	mov    %eax,(%esp)
c0105032:	e8 0f f4 ff ff       	call   c0104446 <page_ref_dec>
c0105037:	eb 19                	jmp    c0105052 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105039:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010503c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105040:	8b 45 10             	mov    0x10(%ebp),%eax
c0105043:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105047:	8b 45 08             	mov    0x8(%ebp),%eax
c010504a:	89 04 24             	mov    %eax,(%esp)
c010504d:	e8 ce fe ff ff       	call   c0104f20 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105052:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105055:	89 04 24             	mov    %eax,(%esp)
c0105058:	e8 84 f2 ff ff       	call   c01042e1 <page2pa>
c010505d:	0b 45 14             	or     0x14(%ebp),%eax
c0105060:	83 c8 01             	or     $0x1,%eax
c0105063:	89 c2                	mov    %eax,%edx
c0105065:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105068:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010506a:	8b 45 10             	mov    0x10(%ebp),%eax
c010506d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105071:	8b 45 08             	mov    0x8(%ebp),%eax
c0105074:	89 04 24             	mov    %eax,(%esp)
c0105077:	e8 07 00 00 00       	call   c0105083 <tlb_invalidate>
    return 0;
c010507c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105081:	c9                   	leave  
c0105082:	c3                   	ret    

c0105083 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105083:	55                   	push   %ebp
c0105084:	89 e5                	mov    %esp,%ebp
c0105086:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105089:	0f 20 d8             	mov    %cr3,%eax
c010508c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010508f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105092:	89 c2                	mov    %eax,%edx
c0105094:	8b 45 08             	mov    0x8(%ebp),%eax
c0105097:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010509a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01050a1:	77 23                	ja     c01050c6 <tlb_invalidate+0x43>
c01050a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050aa:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c01050b1:	c0 
c01050b2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01050b9:	00 
c01050ba:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01050c1:	e8 0f bc ff ff       	call   c0100cd5 <__panic>
c01050c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c9:	05 00 00 00 40       	add    $0x40000000,%eax
c01050ce:	39 c2                	cmp    %eax,%edx
c01050d0:	75 0c                	jne    c01050de <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01050d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01050d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050db:	0f 01 38             	invlpg (%eax)
    }
}
c01050de:	c9                   	leave  
c01050df:	c3                   	ret    

c01050e0 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01050e0:	55                   	push   %ebp
c01050e1:	89 e5                	mov    %esp,%ebp
c01050e3:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01050e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050ed:	e8 2b f5 ff ff       	call   c010461d <alloc_pages>
c01050f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01050f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050f9:	0f 84 a7 00 00 00    	je     c01051a6 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01050ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0105102:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105106:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105109:	89 44 24 08          	mov    %eax,0x8(%esp)
c010510d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105110:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105114:	8b 45 08             	mov    0x8(%ebp),%eax
c0105117:	89 04 24             	mov    %eax,(%esp)
c010511a:	e8 ab fe ff ff       	call   c0104fca <page_insert>
c010511f:	85 c0                	test   %eax,%eax
c0105121:	74 1a                	je     c010513d <pgdir_alloc_page+0x5d>
            free_page(page);
c0105123:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010512a:	00 
c010512b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010512e:	89 04 24             	mov    %eax,(%esp)
c0105131:	e8 52 f5 ff ff       	call   c0104688 <free_pages>
            return NULL;
c0105136:	b8 00 00 00 00       	mov    $0x0,%eax
c010513b:	eb 6c                	jmp    c01051a9 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c010513d:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0105142:	85 c0                	test   %eax,%eax
c0105144:	74 60                	je     c01051a6 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105146:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010514b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105152:	00 
c0105153:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105156:	89 54 24 08          	mov    %edx,0x8(%esp)
c010515a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010515d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105161:	89 04 24             	mov    %eax,(%esp)
c0105164:	e8 78 0f 00 00       	call   c01060e1 <swap_map_swappable>
            page->pra_vaddr=la;
c0105169:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010516c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010516f:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105172:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105175:	89 04 24             	mov    %eax,(%esp)
c0105178:	e8 9b f2 ff ff       	call   c0104418 <page_ref>
c010517d:	83 f8 01             	cmp    $0x1,%eax
c0105180:	74 24                	je     c01051a6 <pgdir_alloc_page+0xc6>
c0105182:	c7 44 24 0c 64 98 10 	movl   $0xc0109864,0xc(%esp)
c0105189:	c0 
c010518a:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105191:	c0 
c0105192:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105199:	00 
c010519a:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01051a1:	e8 2f bb ff ff       	call   c0100cd5 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01051a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01051a9:	c9                   	leave  
c01051aa:	c3                   	ret    

c01051ab <check_alloc_page>:

static void
check_alloc_page(void) {
c01051ab:	55                   	push   %ebp
c01051ac:	89 e5                	mov    %esp,%ebp
c01051ae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01051b1:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01051b6:	8b 40 18             	mov    0x18(%eax),%eax
c01051b9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01051bb:	c7 04 24 78 98 10 c0 	movl   $0xc0109878,(%esp)
c01051c2:	e8 84 b1 ff ff       	call   c010034b <cprintf>
}
c01051c7:	c9                   	leave  
c01051c8:	c3                   	ret    

c01051c9 <check_pgdir>:

static void
check_pgdir(void) {
c01051c9:	55                   	push   %ebp
c01051ca:	89 e5                	mov    %esp,%ebp
c01051cc:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01051cf:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01051d4:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01051d9:	76 24                	jbe    c01051ff <check_pgdir+0x36>
c01051db:	c7 44 24 0c 97 98 10 	movl   $0xc0109897,0xc(%esp)
c01051e2:	c0 
c01051e3:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01051ea:	c0 
c01051eb:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01051f2:	00 
c01051f3:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01051fa:	e8 d6 ba ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01051ff:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105204:	85 c0                	test   %eax,%eax
c0105206:	74 0e                	je     c0105216 <check_pgdir+0x4d>
c0105208:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010520d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105212:	85 c0                	test   %eax,%eax
c0105214:	74 24                	je     c010523a <check_pgdir+0x71>
c0105216:	c7 44 24 0c b4 98 10 	movl   $0xc01098b4,0xc(%esp)
c010521d:	c0 
c010521e:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105225:	c0 
c0105226:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010522d:	00 
c010522e:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105235:	e8 9b ba ff ff       	call   c0100cd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010523a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010523f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105246:	00 
c0105247:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010524e:	00 
c010524f:	89 04 24             	mov    %eax,(%esp)
c0105252:	e8 70 fc ff ff       	call   c0104ec7 <get_page>
c0105257:	85 c0                	test   %eax,%eax
c0105259:	74 24                	je     c010527f <check_pgdir+0xb6>
c010525b:	c7 44 24 0c ec 98 10 	movl   $0xc01098ec,0xc(%esp)
c0105262:	c0 
c0105263:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010526a:	c0 
c010526b:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105272:	00 
c0105273:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010527a:	e8 56 ba ff ff       	call   c0100cd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010527f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105286:	e8 92 f3 ff ff       	call   c010461d <alloc_pages>
c010528b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010528e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105293:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010529a:	00 
c010529b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052a2:	00 
c01052a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052aa:	89 04 24             	mov    %eax,(%esp)
c01052ad:	e8 18 fd ff ff       	call   c0104fca <page_insert>
c01052b2:	85 c0                	test   %eax,%eax
c01052b4:	74 24                	je     c01052da <check_pgdir+0x111>
c01052b6:	c7 44 24 0c 14 99 10 	movl   $0xc0109914,0xc(%esp)
c01052bd:	c0 
c01052be:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01052c5:	c0 
c01052c6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01052cd:	00 
c01052ce:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01052d5:	e8 fb b9 ff ff       	call   c0100cd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01052da:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01052df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052e6:	00 
c01052e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052ee:	00 
c01052ef:	89 04 24             	mov    %eax,(%esp)
c01052f2:	e8 88 fa ff ff       	call   c0104d7f <get_pte>
c01052f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052fe:	75 24                	jne    c0105324 <check_pgdir+0x15b>
c0105300:	c7 44 24 0c 40 99 10 	movl   $0xc0109940,0xc(%esp)
c0105307:	c0 
c0105308:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010530f:	c0 
c0105310:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105317:	00 
c0105318:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010531f:	e8 b1 b9 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c0105324:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105327:	8b 00                	mov    (%eax),%eax
c0105329:	89 04 24             	mov    %eax,(%esp)
c010532c:	e8 c6 ef ff ff       	call   c01042f7 <pa2page>
c0105331:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105334:	74 24                	je     c010535a <check_pgdir+0x191>
c0105336:	c7 44 24 0c 6d 99 10 	movl   $0xc010996d,0xc(%esp)
c010533d:	c0 
c010533e:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105345:	c0 
c0105346:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010534d:	00 
c010534e:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105355:	e8 7b b9 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 1);
c010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010535d:	89 04 24             	mov    %eax,(%esp)
c0105360:	e8 b3 f0 ff ff       	call   c0104418 <page_ref>
c0105365:	83 f8 01             	cmp    $0x1,%eax
c0105368:	74 24                	je     c010538e <check_pgdir+0x1c5>
c010536a:	c7 44 24 0c 82 99 10 	movl   $0xc0109982,0xc(%esp)
c0105371:	c0 
c0105372:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105379:	c0 
c010537a:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105381:	00 
c0105382:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105389:	e8 47 b9 ff ff       	call   c0100cd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010538e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105393:	8b 00                	mov    (%eax),%eax
c0105395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010539a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010539d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053a0:	c1 e8 0c             	shr    $0xc,%eax
c01053a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053a6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01053ab:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01053ae:	72 23                	jb     c01053d3 <check_pgdir+0x20a>
c01053b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053b7:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c01053be:	c0 
c01053bf:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01053c6:	00 
c01053c7:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01053ce:	e8 02 b9 ff ff       	call   c0100cd5 <__panic>
c01053d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053d6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01053db:	83 c0 04             	add    $0x4,%eax
c01053de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01053e1:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01053e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053ed:	00 
c01053ee:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01053f5:	00 
c01053f6:	89 04 24             	mov    %eax,(%esp)
c01053f9:	e8 81 f9 ff ff       	call   c0104d7f <get_pte>
c01053fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105401:	74 24                	je     c0105427 <check_pgdir+0x25e>
c0105403:	c7 44 24 0c 94 99 10 	movl   $0xc0109994,0xc(%esp)
c010540a:	c0 
c010540b:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105412:	c0 
c0105413:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010541a:	00 
c010541b:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105422:	e8 ae b8 ff ff       	call   c0100cd5 <__panic>

    p2 = alloc_page();
c0105427:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010542e:	e8 ea f1 ff ff       	call   c010461d <alloc_pages>
c0105433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105436:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010543b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105442:	00 
c0105443:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010544a:	00 
c010544b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010544e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105452:	89 04 24             	mov    %eax,(%esp)
c0105455:	e8 70 fb ff ff       	call   c0104fca <page_insert>
c010545a:	85 c0                	test   %eax,%eax
c010545c:	74 24                	je     c0105482 <check_pgdir+0x2b9>
c010545e:	c7 44 24 0c bc 99 10 	movl   $0xc01099bc,0xc(%esp)
c0105465:	c0 
c0105466:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010546d:	c0 
c010546e:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105475:	00 
c0105476:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010547d:	e8 53 b8 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105482:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010548e:	00 
c010548f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105496:	00 
c0105497:	89 04 24             	mov    %eax,(%esp)
c010549a:	e8 e0 f8 ff ff       	call   c0104d7f <get_pte>
c010549f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054a6:	75 24                	jne    c01054cc <check_pgdir+0x303>
c01054a8:	c7 44 24 0c f4 99 10 	movl   $0xc01099f4,0xc(%esp)
c01054af:	c0 
c01054b0:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01054b7:	c0 
c01054b8:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01054bf:	00 
c01054c0:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01054c7:	e8 09 b8 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_U);
c01054cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054cf:	8b 00                	mov    (%eax),%eax
c01054d1:	83 e0 04             	and    $0x4,%eax
c01054d4:	85 c0                	test   %eax,%eax
c01054d6:	75 24                	jne    c01054fc <check_pgdir+0x333>
c01054d8:	c7 44 24 0c 24 9a 10 	movl   $0xc0109a24,0xc(%esp)
c01054df:	c0 
c01054e0:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01054e7:	c0 
c01054e8:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01054ef:	00 
c01054f0:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01054f7:	e8 d9 b7 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_W);
c01054fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ff:	8b 00                	mov    (%eax),%eax
c0105501:	83 e0 02             	and    $0x2,%eax
c0105504:	85 c0                	test   %eax,%eax
c0105506:	75 24                	jne    c010552c <check_pgdir+0x363>
c0105508:	c7 44 24 0c 32 9a 10 	movl   $0xc0109a32,0xc(%esp)
c010550f:	c0 
c0105510:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105517:	c0 
c0105518:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c010551f:	00 
c0105520:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105527:	e8 a9 b7 ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010552c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105531:	8b 00                	mov    (%eax),%eax
c0105533:	83 e0 04             	and    $0x4,%eax
c0105536:	85 c0                	test   %eax,%eax
c0105538:	75 24                	jne    c010555e <check_pgdir+0x395>
c010553a:	c7 44 24 0c 40 9a 10 	movl   $0xc0109a40,0xc(%esp)
c0105541:	c0 
c0105542:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105549:	c0 
c010554a:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105551:	00 
c0105552:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105559:	e8 77 b7 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 1);
c010555e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105561:	89 04 24             	mov    %eax,(%esp)
c0105564:	e8 af ee ff ff       	call   c0104418 <page_ref>
c0105569:	83 f8 01             	cmp    $0x1,%eax
c010556c:	74 24                	je     c0105592 <check_pgdir+0x3c9>
c010556e:	c7 44 24 0c 56 9a 10 	movl   $0xc0109a56,0xc(%esp)
c0105575:	c0 
c0105576:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010557d:	c0 
c010557e:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105585:	00 
c0105586:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010558d:	e8 43 b7 ff ff       	call   c0100cd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105592:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010559e:	00 
c010559f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055a6:	00 
c01055a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055ae:	89 04 24             	mov    %eax,(%esp)
c01055b1:	e8 14 fa ff ff       	call   c0104fca <page_insert>
c01055b6:	85 c0                	test   %eax,%eax
c01055b8:	74 24                	je     c01055de <check_pgdir+0x415>
c01055ba:	c7 44 24 0c 68 9a 10 	movl   $0xc0109a68,0xc(%esp)
c01055c1:	c0 
c01055c2:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01055c9:	c0 
c01055ca:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01055d1:	00 
c01055d2:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01055d9:	e8 f7 b6 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 2);
c01055de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055e1:	89 04 24             	mov    %eax,(%esp)
c01055e4:	e8 2f ee ff ff       	call   c0104418 <page_ref>
c01055e9:	83 f8 02             	cmp    $0x2,%eax
c01055ec:	74 24                	je     c0105612 <check_pgdir+0x449>
c01055ee:	c7 44 24 0c 94 9a 10 	movl   $0xc0109a94,0xc(%esp)
c01055f5:	c0 
c01055f6:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01055fd:	c0 
c01055fe:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105605:	00 
c0105606:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010560d:	e8 c3 b6 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c0105612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105615:	89 04 24             	mov    %eax,(%esp)
c0105618:	e8 fb ed ff ff       	call   c0104418 <page_ref>
c010561d:	85 c0                	test   %eax,%eax
c010561f:	74 24                	je     c0105645 <check_pgdir+0x47c>
c0105621:	c7 44 24 0c a6 9a 10 	movl   $0xc0109aa6,0xc(%esp)
c0105628:	c0 
c0105629:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105630:	c0 
c0105631:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105638:	00 
c0105639:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105640:	e8 90 b6 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105645:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010564a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105651:	00 
c0105652:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105659:	00 
c010565a:	89 04 24             	mov    %eax,(%esp)
c010565d:	e8 1d f7 ff ff       	call   c0104d7f <get_pte>
c0105662:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105665:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105669:	75 24                	jne    c010568f <check_pgdir+0x4c6>
c010566b:	c7 44 24 0c f4 99 10 	movl   $0xc01099f4,0xc(%esp)
c0105672:	c0 
c0105673:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010567a:	c0 
c010567b:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105682:	00 
c0105683:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010568a:	e8 46 b6 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c010568f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105692:	8b 00                	mov    (%eax),%eax
c0105694:	89 04 24             	mov    %eax,(%esp)
c0105697:	e8 5b ec ff ff       	call   c01042f7 <pa2page>
c010569c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010569f:	74 24                	je     c01056c5 <check_pgdir+0x4fc>
c01056a1:	c7 44 24 0c 6d 99 10 	movl   $0xc010996d,0xc(%esp)
c01056a8:	c0 
c01056a9:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01056b0:	c0 
c01056b1:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01056b8:	00 
c01056b9:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01056c0:	e8 10 b6 ff ff       	call   c0100cd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c01056c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c8:	8b 00                	mov    (%eax),%eax
c01056ca:	83 e0 04             	and    $0x4,%eax
c01056cd:	85 c0                	test   %eax,%eax
c01056cf:	74 24                	je     c01056f5 <check_pgdir+0x52c>
c01056d1:	c7 44 24 0c b8 9a 10 	movl   $0xc0109ab8,0xc(%esp)
c01056d8:	c0 
c01056d9:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01056e0:	c0 
c01056e1:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01056e8:	00 
c01056e9:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01056f0:	e8 e0 b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c01056f5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01056fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105701:	00 
c0105702:	89 04 24             	mov    %eax,(%esp)
c0105705:	e8 7c f8 ff ff       	call   c0104f86 <page_remove>
    assert(page_ref(p1) == 1);
c010570a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010570d:	89 04 24             	mov    %eax,(%esp)
c0105710:	e8 03 ed ff ff       	call   c0104418 <page_ref>
c0105715:	83 f8 01             	cmp    $0x1,%eax
c0105718:	74 24                	je     c010573e <check_pgdir+0x575>
c010571a:	c7 44 24 0c 82 99 10 	movl   $0xc0109982,0xc(%esp)
c0105721:	c0 
c0105722:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105729:	c0 
c010572a:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105731:	00 
c0105732:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105739:	e8 97 b5 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c010573e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105741:	89 04 24             	mov    %eax,(%esp)
c0105744:	e8 cf ec ff ff       	call   c0104418 <page_ref>
c0105749:	85 c0                	test   %eax,%eax
c010574b:	74 24                	je     c0105771 <check_pgdir+0x5a8>
c010574d:	c7 44 24 0c a6 9a 10 	movl   $0xc0109aa6,0xc(%esp)
c0105754:	c0 
c0105755:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c010575c:	c0 
c010575d:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105764:	00 
c0105765:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c010576c:	e8 64 b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105771:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105776:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010577d:	00 
c010577e:	89 04 24             	mov    %eax,(%esp)
c0105781:	e8 00 f8 ff ff       	call   c0104f86 <page_remove>
    assert(page_ref(p1) == 0);
c0105786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105789:	89 04 24             	mov    %eax,(%esp)
c010578c:	e8 87 ec ff ff       	call   c0104418 <page_ref>
c0105791:	85 c0                	test   %eax,%eax
c0105793:	74 24                	je     c01057b9 <check_pgdir+0x5f0>
c0105795:	c7 44 24 0c cd 9a 10 	movl   $0xc0109acd,0xc(%esp)
c010579c:	c0 
c010579d:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01057a4:	c0 
c01057a5:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01057ac:	00 
c01057ad:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01057b4:	e8 1c b5 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c01057b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057bc:	89 04 24             	mov    %eax,(%esp)
c01057bf:	e8 54 ec ff ff       	call   c0104418 <page_ref>
c01057c4:	85 c0                	test   %eax,%eax
c01057c6:	74 24                	je     c01057ec <check_pgdir+0x623>
c01057c8:	c7 44 24 0c a6 9a 10 	movl   $0xc0109aa6,0xc(%esp)
c01057cf:	c0 
c01057d0:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01057d7:	c0 
c01057d8:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c01057df:	00 
c01057e0:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01057e7:	e8 e9 b4 ff ff       	call   c0100cd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01057ec:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01057f1:	8b 00                	mov    (%eax),%eax
c01057f3:	89 04 24             	mov    %eax,(%esp)
c01057f6:	e8 fc ea ff ff       	call   c01042f7 <pa2page>
c01057fb:	89 04 24             	mov    %eax,(%esp)
c01057fe:	e8 15 ec ff ff       	call   c0104418 <page_ref>
c0105803:	83 f8 01             	cmp    $0x1,%eax
c0105806:	74 24                	je     c010582c <check_pgdir+0x663>
c0105808:	c7 44 24 0c e0 9a 10 	movl   $0xc0109ae0,0xc(%esp)
c010580f:	c0 
c0105810:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105817:	c0 
c0105818:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c010581f:	00 
c0105820:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105827:	e8 a9 b4 ff ff       	call   c0100cd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c010582c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105831:	8b 00                	mov    (%eax),%eax
c0105833:	89 04 24             	mov    %eax,(%esp)
c0105836:	e8 bc ea ff ff       	call   c01042f7 <pa2page>
c010583b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105842:	00 
c0105843:	89 04 24             	mov    %eax,(%esp)
c0105846:	e8 3d ee ff ff       	call   c0104688 <free_pages>
    boot_pgdir[0] = 0;
c010584b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105856:	c7 04 24 06 9b 10 c0 	movl   $0xc0109b06,(%esp)
c010585d:	e8 e9 aa ff ff       	call   c010034b <cprintf>
}
c0105862:	c9                   	leave  
c0105863:	c3                   	ret    

c0105864 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105864:	55                   	push   %ebp
c0105865:	89 e5                	mov    %esp,%ebp
c0105867:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010586a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105871:	e9 ca 00 00 00       	jmp    c0105940 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105876:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105879:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010587c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010587f:	c1 e8 0c             	shr    $0xc,%eax
c0105882:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105885:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010588a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010588d:	72 23                	jb     c01058b2 <check_boot_pgdir+0x4e>
c010588f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105892:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105896:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c010589d:	c0 
c010589e:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c01058a5:	00 
c01058a6:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01058ad:	e8 23 b4 ff ff       	call   c0100cd5 <__panic>
c01058b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058ba:	89 c2                	mov    %eax,%edx
c01058bc:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01058c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01058c8:	00 
c01058c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058cd:	89 04 24             	mov    %eax,(%esp)
c01058d0:	e8 aa f4 ff ff       	call   c0104d7f <get_pte>
c01058d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058dc:	75 24                	jne    c0105902 <check_boot_pgdir+0x9e>
c01058de:	c7 44 24 0c 20 9b 10 	movl   $0xc0109b20,0xc(%esp)
c01058e5:	c0 
c01058e6:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01058ed:	c0 
c01058ee:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c01058f5:	00 
c01058f6:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01058fd:	e8 d3 b3 ff ff       	call   c0100cd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105902:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105905:	8b 00                	mov    (%eax),%eax
c0105907:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010590c:	89 c2                	mov    %eax,%edx
c010590e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105911:	39 c2                	cmp    %eax,%edx
c0105913:	74 24                	je     c0105939 <check_boot_pgdir+0xd5>
c0105915:	c7 44 24 0c 5d 9b 10 	movl   $0xc0109b5d,0xc(%esp)
c010591c:	c0 
c010591d:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105924:	c0 
c0105925:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c010592c:	00 
c010592d:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105934:	e8 9c b3 ff ff       	call   c0100cd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105939:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105940:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105943:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105948:	39 c2                	cmp    %eax,%edx
c010594a:	0f 82 26 ff ff ff    	jb     c0105876 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105950:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105955:	05 ac 0f 00 00       	add    $0xfac,%eax
c010595a:	8b 00                	mov    (%eax),%eax
c010595c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105961:	89 c2                	mov    %eax,%edx
c0105963:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010596b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105972:	77 23                	ja     c0105997 <check_boot_pgdir+0x133>
c0105974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105977:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010597b:	c7 44 24 08 60 97 10 	movl   $0xc0109760,0x8(%esp)
c0105982:	c0 
c0105983:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c010598a:	00 
c010598b:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105992:	e8 3e b3 ff ff       	call   c0100cd5 <__panic>
c0105997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010599a:	05 00 00 00 40       	add    $0x40000000,%eax
c010599f:	39 c2                	cmp    %eax,%edx
c01059a1:	74 24                	je     c01059c7 <check_boot_pgdir+0x163>
c01059a3:	c7 44 24 0c 74 9b 10 	movl   $0xc0109b74,0xc(%esp)
c01059aa:	c0 
c01059ab:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01059b2:	c0 
c01059b3:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c01059ba:	00 
c01059bb:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01059c2:	e8 0e b3 ff ff       	call   c0100cd5 <__panic>

    assert(boot_pgdir[0] == 0);
c01059c7:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059cc:	8b 00                	mov    (%eax),%eax
c01059ce:	85 c0                	test   %eax,%eax
c01059d0:	74 24                	je     c01059f6 <check_boot_pgdir+0x192>
c01059d2:	c7 44 24 0c a8 9b 10 	movl   $0xc0109ba8,0xc(%esp)
c01059d9:	c0 
c01059da:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c01059e1:	c0 
c01059e2:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c01059e9:	00 
c01059ea:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c01059f1:	e8 df b2 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    p = alloc_page();
c01059f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059fd:	e8 1b ec ff ff       	call   c010461d <alloc_pages>
c0105a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105a05:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a0a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a11:	00 
c0105a12:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a19:	00 
c0105a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a1d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a21:	89 04 24             	mov    %eax,(%esp)
c0105a24:	e8 a1 f5 ff ff       	call   c0104fca <page_insert>
c0105a29:	85 c0                	test   %eax,%eax
c0105a2b:	74 24                	je     c0105a51 <check_boot_pgdir+0x1ed>
c0105a2d:	c7 44 24 0c bc 9b 10 	movl   $0xc0109bbc,0xc(%esp)
c0105a34:	c0 
c0105a35:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105a3c:	c0 
c0105a3d:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c0105a44:	00 
c0105a45:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105a4c:	e8 84 b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 1);
c0105a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a54:	89 04 24             	mov    %eax,(%esp)
c0105a57:	e8 bc e9 ff ff       	call   c0104418 <page_ref>
c0105a5c:	83 f8 01             	cmp    $0x1,%eax
c0105a5f:	74 24                	je     c0105a85 <check_boot_pgdir+0x221>
c0105a61:	c7 44 24 0c ea 9b 10 	movl   $0xc0109bea,0xc(%esp)
c0105a68:	c0 
c0105a69:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105a70:	c0 
c0105a71:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c0105a78:	00 
c0105a79:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105a80:	e8 50 b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105a85:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a8a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a91:	00 
c0105a92:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105a99:	00 
c0105a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a9d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105aa1:	89 04 24             	mov    %eax,(%esp)
c0105aa4:	e8 21 f5 ff ff       	call   c0104fca <page_insert>
c0105aa9:	85 c0                	test   %eax,%eax
c0105aab:	74 24                	je     c0105ad1 <check_boot_pgdir+0x26d>
c0105aad:	c7 44 24 0c fc 9b 10 	movl   $0xc0109bfc,0xc(%esp)
c0105ab4:	c0 
c0105ab5:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105abc:	c0 
c0105abd:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105ac4:	00 
c0105ac5:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105acc:	e8 04 b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 2);
c0105ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ad4:	89 04 24             	mov    %eax,(%esp)
c0105ad7:	e8 3c e9 ff ff       	call   c0104418 <page_ref>
c0105adc:	83 f8 02             	cmp    $0x2,%eax
c0105adf:	74 24                	je     c0105b05 <check_boot_pgdir+0x2a1>
c0105ae1:	c7 44 24 0c 33 9c 10 	movl   $0xc0109c33,0xc(%esp)
c0105ae8:	c0 
c0105ae9:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105af0:	c0 
c0105af1:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c0105af8:	00 
c0105af9:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105b00:	e8 d0 b1 ff ff       	call   c0100cd5 <__panic>

    const char *str = "ucore: Hello world!!";
c0105b05:	c7 45 dc 44 9c 10 c0 	movl   $0xc0109c44,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105b0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b13:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b1a:	e8 a0 2b 00 00       	call   c01086bf <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b1f:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b26:	00 
c0105b27:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b2e:	e8 05 2c 00 00       	call   c0108738 <strcmp>
c0105b33:	85 c0                	test   %eax,%eax
c0105b35:	74 24                	je     c0105b5b <check_boot_pgdir+0x2f7>
c0105b37:	c7 44 24 0c 5c 9c 10 	movl   $0xc0109c5c,0xc(%esp)
c0105b3e:	c0 
c0105b3f:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105b46:	c0 
c0105b47:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0105b4e:	00 
c0105b4f:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105b56:	e8 7a b1 ff ff       	call   c0100cd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b5e:	89 04 24             	mov    %eax,(%esp)
c0105b61:	e8 d6 e7 ff ff       	call   c010433c <page2kva>
c0105b66:	05 00 01 00 00       	add    $0x100,%eax
c0105b6b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105b6e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b75:	e8 ed 2a 00 00       	call   c0108667 <strlen>
c0105b7a:	85 c0                	test   %eax,%eax
c0105b7c:	74 24                	je     c0105ba2 <check_boot_pgdir+0x33e>
c0105b7e:	c7 44 24 0c 94 9c 10 	movl   $0xc0109c94,0xc(%esp)
c0105b85:	c0 
c0105b86:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105b8d:	c0 
c0105b8e:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c0105b95:	00 
c0105b96:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105b9d:	e8 33 b1 ff ff       	call   c0100cd5 <__panic>

    free_page(p);
c0105ba2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105ba9:	00 
c0105baa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bad:	89 04 24             	mov    %eax,(%esp)
c0105bb0:	e8 d3 ea ff ff       	call   c0104688 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105bb5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105bba:	8b 00                	mov    (%eax),%eax
c0105bbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105bc1:	89 04 24             	mov    %eax,(%esp)
c0105bc4:	e8 2e e7 ff ff       	call   c01042f7 <pa2page>
c0105bc9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105bd0:	00 
c0105bd1:	89 04 24             	mov    %eax,(%esp)
c0105bd4:	e8 af ea ff ff       	call   c0104688 <free_pages>
    boot_pgdir[0] = 0;
c0105bd9:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105be4:	c7 04 24 b8 9c 10 c0 	movl   $0xc0109cb8,(%esp)
c0105beb:	e8 5b a7 ff ff       	call   c010034b <cprintf>
}
c0105bf0:	c9                   	leave  
c0105bf1:	c3                   	ret    

c0105bf2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105bf2:	55                   	push   %ebp
c0105bf3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	83 e0 04             	and    $0x4,%eax
c0105bfb:	85 c0                	test   %eax,%eax
c0105bfd:	74 07                	je     c0105c06 <perm2str+0x14>
c0105bff:	b8 75 00 00 00       	mov    $0x75,%eax
c0105c04:	eb 05                	jmp    c0105c0b <perm2str+0x19>
c0105c06:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c0b:	a2 a8 1a 12 c0       	mov    %al,0xc0121aa8
    str[1] = 'r';
c0105c10:	c6 05 a9 1a 12 c0 72 	movb   $0x72,0xc0121aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1a:	83 e0 02             	and    $0x2,%eax
c0105c1d:	85 c0                	test   %eax,%eax
c0105c1f:	74 07                	je     c0105c28 <perm2str+0x36>
c0105c21:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c26:	eb 05                	jmp    c0105c2d <perm2str+0x3b>
c0105c28:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c2d:	a2 aa 1a 12 c0       	mov    %al,0xc0121aaa
    str[3] = '\0';
c0105c32:	c6 05 ab 1a 12 c0 00 	movb   $0x0,0xc0121aab
    return str;
c0105c39:	b8 a8 1a 12 c0       	mov    $0xc0121aa8,%eax
}
c0105c3e:	5d                   	pop    %ebp
c0105c3f:	c3                   	ret    

c0105c40 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105c40:	55                   	push   %ebp
c0105c41:	89 e5                	mov    %esp,%ebp
c0105c43:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105c46:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c49:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c4c:	72 0a                	jb     c0105c58 <get_pgtable_items+0x18>
        return 0;
c0105c4e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105c53:	e9 9c 00 00 00       	jmp    c0105cf4 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105c58:	eb 04                	jmp    c0105c5e <get_pgtable_items+0x1e>
        start ++;
c0105c5a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105c5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c61:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c64:	73 18                	jae    c0105c7e <get_pgtable_items+0x3e>
c0105c66:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c70:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c73:	01 d0                	add    %edx,%eax
c0105c75:	8b 00                	mov    (%eax),%eax
c0105c77:	83 e0 01             	and    $0x1,%eax
c0105c7a:	85 c0                	test   %eax,%eax
c0105c7c:	74 dc                	je     c0105c5a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105c7e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c81:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c84:	73 69                	jae    c0105cef <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105c86:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105c8a:	74 08                	je     c0105c94 <get_pgtable_items+0x54>
            *left_store = start;
c0105c8c:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c8f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105c92:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105c94:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c97:	8d 50 01             	lea    0x1(%eax),%edx
c0105c9a:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105ca4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ca7:	01 d0                	add    %edx,%eax
c0105ca9:	8b 00                	mov    (%eax),%eax
c0105cab:	83 e0 07             	and    $0x7,%eax
c0105cae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105cb1:	eb 04                	jmp    c0105cb7 <get_pgtable_items+0x77>
            start ++;
c0105cb3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105cb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cba:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cbd:	73 1d                	jae    c0105cdc <get_pgtable_items+0x9c>
c0105cbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cc9:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ccc:	01 d0                	add    %edx,%eax
c0105cce:	8b 00                	mov    (%eax),%eax
c0105cd0:	83 e0 07             	and    $0x7,%eax
c0105cd3:	89 c2                	mov    %eax,%edx
c0105cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cd8:	39 c2                	cmp    %eax,%edx
c0105cda:	74 d7                	je     c0105cb3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105cdc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105ce0:	74 08                	je     c0105cea <get_pgtable_items+0xaa>
            *right_store = start;
c0105ce2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105ce5:	8b 55 10             	mov    0x10(%ebp),%edx
c0105ce8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ced:	eb 05                	jmp    c0105cf4 <get_pgtable_items+0xb4>
    }
    return 0;
c0105cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cf4:	c9                   	leave  
c0105cf5:	c3                   	ret    

c0105cf6 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105cf6:	55                   	push   %ebp
c0105cf7:	89 e5                	mov    %esp,%ebp
c0105cf9:	57                   	push   %edi
c0105cfa:	56                   	push   %esi
c0105cfb:	53                   	push   %ebx
c0105cfc:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105cff:	c7 04 24 d8 9c 10 c0 	movl   $0xc0109cd8,(%esp)
c0105d06:	e8 40 a6 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105d0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105d12:	e9 fa 00 00 00       	jmp    c0105e11 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d1a:	89 04 24             	mov    %eax,(%esp)
c0105d1d:	e8 d0 fe ff ff       	call   c0105bf2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d22:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d25:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d28:	29 d1                	sub    %edx,%ecx
c0105d2a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d2c:	89 d6                	mov    %edx,%esi
c0105d2e:	c1 e6 16             	shl    $0x16,%esi
c0105d31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d34:	89 d3                	mov    %edx,%ebx
c0105d36:	c1 e3 16             	shl    $0x16,%ebx
c0105d39:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d3c:	89 d1                	mov    %edx,%ecx
c0105d3e:	c1 e1 16             	shl    $0x16,%ecx
c0105d41:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d47:	29 d7                	sub    %edx,%edi
c0105d49:	89 fa                	mov    %edi,%edx
c0105d4b:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105d4f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105d53:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105d5b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d5f:	c7 04 24 09 9d 10 c0 	movl   $0xc0109d09,(%esp)
c0105d66:	e8 e0 a5 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d6e:	c1 e0 0a             	shl    $0xa,%eax
c0105d71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105d74:	eb 54                	jmp    c0105dca <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d79:	89 04 24             	mov    %eax,(%esp)
c0105d7c:	e8 71 fe ff ff       	call   c0105bf2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105d81:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105d84:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d87:	29 d1                	sub    %edx,%ecx
c0105d89:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d8b:	89 d6                	mov    %edx,%esi
c0105d8d:	c1 e6 0c             	shl    $0xc,%esi
c0105d90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d93:	89 d3                	mov    %edx,%ebx
c0105d95:	c1 e3 0c             	shl    $0xc,%ebx
c0105d98:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d9b:	c1 e2 0c             	shl    $0xc,%edx
c0105d9e:	89 d1                	mov    %edx,%ecx
c0105da0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105da3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105da6:	29 d7                	sub    %edx,%edi
c0105da8:	89 fa                	mov    %edi,%edx
c0105daa:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105dae:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105db2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105db6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105dba:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dbe:	c7 04 24 28 9d 10 c0 	movl   $0xc0109d28,(%esp)
c0105dc5:	e8 81 a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105dca:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105dd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105dd5:	89 ce                	mov    %ecx,%esi
c0105dd7:	c1 e6 0a             	shl    $0xa,%esi
c0105dda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105ddd:	89 cb                	mov    %ecx,%ebx
c0105ddf:	c1 e3 0a             	shl    $0xa,%ebx
c0105de2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105de5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105de9:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105dec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105df0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105df4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105df8:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105dfc:	89 1c 24             	mov    %ebx,(%esp)
c0105dff:	e8 3c fe ff ff       	call   c0105c40 <get_pgtable_items>
c0105e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e0b:	0f 85 65 ff ff ff    	jne    c0105d76 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e11:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e19:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e1c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e20:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e23:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e27:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e2b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e2f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e36:	00 
c0105e37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105e3e:	e8 fd fd ff ff       	call   c0105c40 <get_pgtable_items>
c0105e43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e4a:	0f 85 c7 fe ff ff    	jne    c0105d17 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105e50:	c7 04 24 4c 9d 10 c0 	movl   $0xc0109d4c,(%esp)
c0105e57:	e8 ef a4 ff ff       	call   c010034b <cprintf>
}
c0105e5c:	83 c4 4c             	add    $0x4c,%esp
c0105e5f:	5b                   	pop    %ebx
c0105e60:	5e                   	pop    %esi
c0105e61:	5f                   	pop    %edi
c0105e62:	5d                   	pop    %ebp
c0105e63:	c3                   	ret    

c0105e64 <kmalloc>:

void *
kmalloc(size_t n) {
c0105e64:	55                   	push   %ebp
c0105e65:	89 e5                	mov    %esp,%ebp
c0105e67:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105e6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105e71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105e78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105e7c:	74 09                	je     c0105e87 <kmalloc+0x23>
c0105e7e:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105e85:	76 24                	jbe    c0105eab <kmalloc+0x47>
c0105e87:	c7 44 24 0c 7d 9d 10 	movl   $0xc0109d7d,0xc(%esp)
c0105e8e:	c0 
c0105e8f:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105e96:	c0 
c0105e97:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c0105e9e:	00 
c0105e9f:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105ea6:	e8 2a ae ff ff       	call   c0100cd5 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eae:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105eb3:	c1 e8 0c             	shr    $0xc,%eax
c0105eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ebc:	89 04 24             	mov    %eax,(%esp)
c0105ebf:	e8 59 e7 ff ff       	call   c010461d <alloc_pages>
c0105ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105ec7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ecb:	75 24                	jne    c0105ef1 <kmalloc+0x8d>
c0105ecd:	c7 44 24 0c 94 9d 10 	movl   $0xc0109d94,0xc(%esp)
c0105ed4:	c0 
c0105ed5:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105edc:	c0 
c0105edd:	c7 44 24 04 b8 02 00 	movl   $0x2b8,0x4(%esp)
c0105ee4:	00 
c0105ee5:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105eec:	e8 e4 ad ff ff       	call   c0100cd5 <__panic>
    ptr=page2kva(base);
c0105ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ef4:	89 04 24             	mov    %eax,(%esp)
c0105ef7:	e8 40 e4 ff ff       	call   c010433c <page2kva>
c0105efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f02:	c9                   	leave  
c0105f03:	c3                   	ret    

c0105f04 <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105f04:	55                   	push   %ebp
c0105f05:	89 e5                	mov    %esp,%ebp
c0105f07:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105f0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f0e:	74 09                	je     c0105f19 <kfree+0x15>
c0105f10:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105f17:	76 24                	jbe    c0105f3d <kfree+0x39>
c0105f19:	c7 44 24 0c 7d 9d 10 	movl   $0xc0109d7d,0xc(%esp)
c0105f20:	c0 
c0105f21:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105f28:	c0 
c0105f29:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c0105f30:	00 
c0105f31:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105f38:	e8 98 ad ff ff       	call   c0100cd5 <__panic>
    assert(ptr != NULL);
c0105f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f41:	75 24                	jne    c0105f67 <kfree+0x63>
c0105f43:	c7 44 24 0c a1 9d 10 	movl   $0xc0109da1,0xc(%esp)
c0105f4a:	c0 
c0105f4b:	c7 44 24 08 29 98 10 	movl   $0xc0109829,0x8(%esp)
c0105f52:	c0 
c0105f53:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c0105f5a:	00 
c0105f5b:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0105f62:	e8 6e ad ff ff       	call   c0100cd5 <__panic>
    struct Page *base=NULL;
c0105f67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f71:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f76:	c1 e8 0c             	shr    $0xc,%eax
c0105f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105f7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f7f:	89 04 24             	mov    %eax,(%esp)
c0105f82:	e8 09 e4 ff ff       	call   c0104390 <kva2page>
c0105f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f94:	89 04 24             	mov    %eax,(%esp)
c0105f97:	e8 ec e6 ff ff       	call   c0104688 <free_pages>
}
c0105f9c:	c9                   	leave  
c0105f9d:	c3                   	ret    

c0105f9e <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105f9e:	55                   	push   %ebp
c0105f9f:	89 e5                	mov    %esp,%ebp
c0105fa1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa7:	c1 e8 0c             	shr    $0xc,%eax
c0105faa:	89 c2                	mov    %eax,%edx
c0105fac:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105fb1:	39 c2                	cmp    %eax,%edx
c0105fb3:	72 1c                	jb     c0105fd1 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0105fb5:	c7 44 24 08 b0 9d 10 	movl   $0xc0109db0,0x8(%esp)
c0105fbc:	c0 
c0105fbd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0105fc4:	00 
c0105fc5:	c7 04 24 cf 9d 10 c0 	movl   $0xc0109dcf,(%esp)
c0105fcc:	e8 04 ad ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0105fd1:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0105fd6:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fd9:	c1 ea 0c             	shr    $0xc,%edx
c0105fdc:	c1 e2 05             	shl    $0x5,%edx
c0105fdf:	01 d0                	add    %edx,%eax
}
c0105fe1:	c9                   	leave  
c0105fe2:	c3                   	ret    

c0105fe3 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105fe3:	55                   	push   %ebp
c0105fe4:	89 e5                	mov    %esp,%ebp
c0105fe6:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0105fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fec:	83 e0 01             	and    $0x1,%eax
c0105fef:	85 c0                	test   %eax,%eax
c0105ff1:	75 1c                	jne    c010600f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0105ff3:	c7 44 24 08 e0 9d 10 	movl   $0xc0109de0,0x8(%esp)
c0105ffa:	c0 
c0105ffb:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106002:	00 
c0106003:	c7 04 24 cf 9d 10 c0 	movl   $0xc0109dcf,(%esp)
c010600a:	e8 c6 ac ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010600f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106012:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106017:	89 04 24             	mov    %eax,(%esp)
c010601a:	e8 7f ff ff ff       	call   c0105f9e <pa2page>
}
c010601f:	c9                   	leave  
c0106020:	c3                   	ret    

c0106021 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106021:	55                   	push   %ebp
c0106022:	89 e5                	mov    %esp,%ebp
c0106024:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106027:	e8 b6 1d 00 00       	call   c0107de2 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010602c:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106031:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106036:	76 0c                	jbe    c0106044 <swap_init+0x23>
c0106038:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c010603d:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106042:	76 25                	jbe    c0106069 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106044:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106049:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010604d:	c7 44 24 08 01 9e 10 	movl   $0xc0109e01,0x8(%esp)
c0106054:	c0 
c0106055:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010605c:	00 
c010605d:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106064:	e8 6c ac ff ff       	call   c0100cd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106069:	c7 05 b4 1a 12 c0 40 	movl   $0xc0120a40,0xc0121ab4
c0106070:	0a 12 c0 
     int r = sm->init();
c0106073:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106078:	8b 40 04             	mov    0x4(%eax),%eax
c010607b:	ff d0                	call   *%eax
c010607d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106084:	75 26                	jne    c01060ac <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106086:	c7 05 ac 1a 12 c0 01 	movl   $0x1,0xc0121aac
c010608d:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106090:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106095:	8b 00                	mov    (%eax),%eax
c0106097:	89 44 24 04          	mov    %eax,0x4(%esp)
c010609b:	c7 04 24 2b 9e 10 c0 	movl   $0xc0109e2b,(%esp)
c01060a2:	e8 a4 a2 ff ff       	call   c010034b <cprintf>
          check_swap();
c01060a7:	e8 a4 04 00 00       	call   c0106550 <check_swap>
     }

     return r;
c01060ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060af:	c9                   	leave  
c01060b0:	c3                   	ret    

c01060b1 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01060b1:	55                   	push   %ebp
c01060b2:	89 e5                	mov    %esp,%ebp
c01060b4:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01060b7:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01060bc:	8b 40 08             	mov    0x8(%eax),%eax
c01060bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01060c2:	89 14 24             	mov    %edx,(%esp)
c01060c5:	ff d0                	call   *%eax
}
c01060c7:	c9                   	leave  
c01060c8:	c3                   	ret    

c01060c9 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01060c9:	55                   	push   %ebp
c01060ca:	89 e5                	mov    %esp,%ebp
c01060cc:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01060cf:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01060d4:	8b 40 0c             	mov    0xc(%eax),%eax
c01060d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01060da:	89 14 24             	mov    %edx,(%esp)
c01060dd:	ff d0                	call   *%eax
}
c01060df:	c9                   	leave  
c01060e0:	c3                   	ret    

c01060e1 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01060e1:	55                   	push   %ebp
c01060e2:	89 e5                	mov    %esp,%ebp
c01060e4:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01060e7:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01060ec:	8b 40 10             	mov    0x10(%eax),%eax
c01060ef:	8b 55 14             	mov    0x14(%ebp),%edx
c01060f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01060f6:	8b 55 10             	mov    0x10(%ebp),%edx
c01060f9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01060fd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106100:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106104:	8b 55 08             	mov    0x8(%ebp),%edx
c0106107:	89 14 24             	mov    %edx,(%esp)
c010610a:	ff d0                	call   *%eax
}
c010610c:	c9                   	leave  
c010610d:	c3                   	ret    

c010610e <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010610e:	55                   	push   %ebp
c010610f:	89 e5                	mov    %esp,%ebp
c0106111:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106114:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106119:	8b 40 14             	mov    0x14(%eax),%eax
c010611c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010611f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106123:	8b 55 08             	mov    0x8(%ebp),%edx
c0106126:	89 14 24             	mov    %edx,(%esp)
c0106129:	ff d0                	call   *%eax
}
c010612b:	c9                   	leave  
c010612c:	c3                   	ret    

c010612d <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010612d:	55                   	push   %ebp
c010612e:	89 e5                	mov    %esp,%ebp
c0106130:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010613a:	e9 5a 01 00 00       	jmp    c0106299 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010613f:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106144:	8b 40 18             	mov    0x18(%eax),%eax
c0106147:	8b 55 10             	mov    0x10(%ebp),%edx
c010614a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010614e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106151:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106155:	8b 55 08             	mov    0x8(%ebp),%edx
c0106158:	89 14 24             	mov    %edx,(%esp)
c010615b:	ff d0                	call   *%eax
c010615d:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106164:	74 18                	je     c010617e <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106166:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106169:	89 44 24 04          	mov    %eax,0x4(%esp)
c010616d:	c7 04 24 40 9e 10 c0 	movl   $0xc0109e40,(%esp)
c0106174:	e8 d2 a1 ff ff       	call   c010034b <cprintf>
c0106179:	e9 27 01 00 00       	jmp    c01062a5 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c010617e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106181:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106184:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106187:	8b 45 08             	mov    0x8(%ebp),%eax
c010618a:	8b 40 0c             	mov    0xc(%eax),%eax
c010618d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106194:	00 
c0106195:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106198:	89 54 24 04          	mov    %edx,0x4(%esp)
c010619c:	89 04 24             	mov    %eax,(%esp)
c010619f:	e8 db eb ff ff       	call   c0104d7f <get_pte>
c01061a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01061a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061aa:	8b 00                	mov    (%eax),%eax
c01061ac:	83 e0 01             	and    $0x1,%eax
c01061af:	85 c0                	test   %eax,%eax
c01061b1:	75 24                	jne    c01061d7 <swap_out+0xaa>
c01061b3:	c7 44 24 0c 6d 9e 10 	movl   $0xc0109e6d,0xc(%esp)
c01061ba:	c0 
c01061bb:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01061c2:	c0 
c01061c3:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01061ca:	00 
c01061cb:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01061d2:	e8 fe aa ff ff       	call   c0100cd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01061d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061dd:	8b 52 1c             	mov    0x1c(%edx),%edx
c01061e0:	c1 ea 0c             	shr    $0xc,%edx
c01061e3:	83 c2 01             	add    $0x1,%edx
c01061e6:	c1 e2 08             	shl    $0x8,%edx
c01061e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061ed:	89 14 24             	mov    %edx,(%esp)
c01061f0:	e8 a7 1c 00 00       	call   c0107e9c <swapfs_write>
c01061f5:	85 c0                	test   %eax,%eax
c01061f7:	74 34                	je     c010622d <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01061f9:	c7 04 24 97 9e 10 c0 	movl   $0xc0109e97,(%esp)
c0106200:	e8 46 a1 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106205:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010620a:	8b 40 10             	mov    0x10(%eax),%eax
c010620d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106210:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106217:	00 
c0106218:	89 54 24 08          	mov    %edx,0x8(%esp)
c010621c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010621f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106223:	8b 55 08             	mov    0x8(%ebp),%edx
c0106226:	89 14 24             	mov    %edx,(%esp)
c0106229:	ff d0                	call   *%eax
c010622b:	eb 68                	jmp    c0106295 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c010622d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106230:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106233:	c1 e8 0c             	shr    $0xc,%eax
c0106236:	83 c0 01             	add    $0x1,%eax
c0106239:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010623d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106240:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106244:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106247:	89 44 24 04          	mov    %eax,0x4(%esp)
c010624b:	c7 04 24 b0 9e 10 c0 	movl   $0xc0109eb0,(%esp)
c0106252:	e8 f4 a0 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010625a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010625d:	c1 e8 0c             	shr    $0xc,%eax
c0106260:	83 c0 01             	add    $0x1,%eax
c0106263:	c1 e0 08             	shl    $0x8,%eax
c0106266:	89 c2                	mov    %eax,%edx
c0106268:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010626b:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c010626d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106270:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106277:	00 
c0106278:	89 04 24             	mov    %eax,(%esp)
c010627b:	e8 08 e4 ff ff       	call   c0104688 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106280:	8b 45 08             	mov    0x8(%ebp),%eax
c0106283:	8b 40 0c             	mov    0xc(%eax),%eax
c0106286:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106289:	89 54 24 04          	mov    %edx,0x4(%esp)
c010628d:	89 04 24             	mov    %eax,(%esp)
c0106290:	e8 ee ed ff ff       	call   c0105083 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106295:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106299:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010629c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010629f:	0f 85 9a fe ff ff    	jne    c010613f <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01062a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062a8:	c9                   	leave  
c01062a9:	c3                   	ret    

c01062aa <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01062aa:	55                   	push   %ebp
c01062ab:	89 e5                	mov    %esp,%ebp
c01062ad:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01062b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062b7:	e8 61 e3 ff ff       	call   c010461d <alloc_pages>
c01062bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01062bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01062c3:	75 24                	jne    c01062e9 <swap_in+0x3f>
c01062c5:	c7 44 24 0c f0 9e 10 	movl   $0xc0109ef0,0xc(%esp)
c01062cc:	c0 
c01062cd:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01062d4:	c0 
c01062d5:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01062dc:	00 
c01062dd:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01062e4:	e8 ec a9 ff ff       	call   c0100cd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01062e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01062ec:	8b 40 0c             	mov    0xc(%eax),%eax
c01062ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062f6:	00 
c01062f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01062fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062fe:	89 04 24             	mov    %eax,(%esp)
c0106301:	e8 79 ea ff ff       	call   c0104d7f <get_pte>
c0106306:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106309:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010630c:	8b 00                	mov    (%eax),%eax
c010630e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106311:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106315:	89 04 24             	mov    %eax,(%esp)
c0106318:	e8 0d 1b 00 00       	call   c0107e2a <swapfs_read>
c010631d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106320:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106324:	74 2a                	je     c0106350 <swap_in+0xa6>
     {
        assert(r!=0);
c0106326:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010632a:	75 24                	jne    c0106350 <swap_in+0xa6>
c010632c:	c7 44 24 0c fd 9e 10 	movl   $0xc0109efd,0xc(%esp)
c0106333:	c0 
c0106334:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c010633b:	c0 
c010633c:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106343:	00 
c0106344:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c010634b:	e8 85 a9 ff ff       	call   c0100cd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106350:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106353:	8b 00                	mov    (%eax),%eax
c0106355:	c1 e8 08             	shr    $0x8,%eax
c0106358:	89 c2                	mov    %eax,%edx
c010635a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010635d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106361:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106365:	c7 04 24 04 9f 10 c0 	movl   $0xc0109f04,(%esp)
c010636c:	e8 da 9f ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c0106371:	8b 45 10             	mov    0x10(%ebp),%eax
c0106374:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106377:	89 10                	mov    %edx,(%eax)
     return 0;
c0106379:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010637e:	c9                   	leave  
c010637f:	c3                   	ret    

c0106380 <check_content_set>:



static inline void
check_content_set(void)
{
c0106380:	55                   	push   %ebp
c0106381:	89 e5                	mov    %esp,%ebp
c0106383:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106386:	b8 00 10 00 00       	mov    $0x1000,%eax
c010638b:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010638e:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106393:	83 f8 01             	cmp    $0x1,%eax
c0106396:	74 24                	je     c01063bc <check_content_set+0x3c>
c0106398:	c7 44 24 0c 42 9f 10 	movl   $0xc0109f42,0xc(%esp)
c010639f:	c0 
c01063a0:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01063a7:	c0 
c01063a8:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01063af:	00 
c01063b0:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01063b7:	e8 19 a9 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01063bc:	b8 10 10 00 00       	mov    $0x1010,%eax
c01063c1:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063c4:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01063c9:	83 f8 01             	cmp    $0x1,%eax
c01063cc:	74 24                	je     c01063f2 <check_content_set+0x72>
c01063ce:	c7 44 24 0c 42 9f 10 	movl   $0xc0109f42,0xc(%esp)
c01063d5:	c0 
c01063d6:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01063dd:	c0 
c01063de:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01063e5:	00 
c01063e6:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01063ed:	e8 e3 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01063f2:	b8 00 20 00 00       	mov    $0x2000,%eax
c01063f7:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01063fa:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01063ff:	83 f8 02             	cmp    $0x2,%eax
c0106402:	74 24                	je     c0106428 <check_content_set+0xa8>
c0106404:	c7 44 24 0c 51 9f 10 	movl   $0xc0109f51,0xc(%esp)
c010640b:	c0 
c010640c:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106413:	c0 
c0106414:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010641b:	00 
c010641c:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106423:	e8 ad a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106428:	b8 10 20 00 00       	mov    $0x2010,%eax
c010642d:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106430:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106435:	83 f8 02             	cmp    $0x2,%eax
c0106438:	74 24                	je     c010645e <check_content_set+0xde>
c010643a:	c7 44 24 0c 51 9f 10 	movl   $0xc0109f51,0xc(%esp)
c0106441:	c0 
c0106442:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106449:	c0 
c010644a:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106451:	00 
c0106452:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106459:	e8 77 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c010645e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106463:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106466:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010646b:	83 f8 03             	cmp    $0x3,%eax
c010646e:	74 24                	je     c0106494 <check_content_set+0x114>
c0106470:	c7 44 24 0c 60 9f 10 	movl   $0xc0109f60,0xc(%esp)
c0106477:	c0 
c0106478:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c010647f:	c0 
c0106480:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106487:	00 
c0106488:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c010648f:	e8 41 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106494:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106499:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010649c:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064a1:	83 f8 03             	cmp    $0x3,%eax
c01064a4:	74 24                	je     c01064ca <check_content_set+0x14a>
c01064a6:	c7 44 24 0c 60 9f 10 	movl   $0xc0109f60,0xc(%esp)
c01064ad:	c0 
c01064ae:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01064b5:	c0 
c01064b6:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01064bd:	00 
c01064be:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01064c5:	e8 0b a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01064ca:	b8 00 40 00 00       	mov    $0x4000,%eax
c01064cf:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01064d2:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064d7:	83 f8 04             	cmp    $0x4,%eax
c01064da:	74 24                	je     c0106500 <check_content_set+0x180>
c01064dc:	c7 44 24 0c 6f 9f 10 	movl   $0xc0109f6f,0xc(%esp)
c01064e3:	c0 
c01064e4:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01064eb:	c0 
c01064ec:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01064f3:	00 
c01064f4:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01064fb:	e8 d5 a7 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106500:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106505:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106508:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010650d:	83 f8 04             	cmp    $0x4,%eax
c0106510:	74 24                	je     c0106536 <check_content_set+0x1b6>
c0106512:	c7 44 24 0c 6f 9f 10 	movl   $0xc0109f6f,0xc(%esp)
c0106519:	c0 
c010651a:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106521:	c0 
c0106522:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106529:	00 
c010652a:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106531:	e8 9f a7 ff ff       	call   c0100cd5 <__panic>
}
c0106536:	c9                   	leave  
c0106537:	c3                   	ret    

c0106538 <check_content_access>:

static inline int
check_content_access(void)
{
c0106538:	55                   	push   %ebp
c0106539:	89 e5                	mov    %esp,%ebp
c010653b:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010653e:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106543:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106546:	ff d0                	call   *%eax
c0106548:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010654b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010654e:	c9                   	leave  
c010654f:	c3                   	ret    

c0106550 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106550:	55                   	push   %ebp
c0106551:	89 e5                	mov    %esp,%ebp
c0106553:	53                   	push   %ebx
c0106554:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010655e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106565:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010656c:	eb 6b                	jmp    c01065d9 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c010656e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106571:	83 e8 0c             	sub    $0xc,%eax
c0106574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010657a:	83 c0 04             	add    $0x4,%eax
c010657d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106584:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106587:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010658a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010658d:	0f a3 10             	bt     %edx,(%eax)
c0106590:	19 c0                	sbb    %eax,%eax
c0106592:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106595:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106599:	0f 95 c0             	setne  %al
c010659c:	0f b6 c0             	movzbl %al,%eax
c010659f:	85 c0                	test   %eax,%eax
c01065a1:	75 24                	jne    c01065c7 <check_swap+0x77>
c01065a3:	c7 44 24 0c 7e 9f 10 	movl   $0xc0109f7e,0xc(%esp)
c01065aa:	c0 
c01065ab:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01065b2:	c0 
c01065b3:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01065ba:	00 
c01065bb:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01065c2:	e8 0e a7 ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c01065c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01065cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065ce:	8b 50 08             	mov    0x8(%eax),%edx
c01065d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065d4:	01 d0                	add    %edx,%eax
c01065d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065dc:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01065df:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01065e2:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01065e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01065e8:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c01065ef:	0f 85 79 ff ff ff    	jne    c010656e <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01065f5:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01065f8:	e8 bd e0 ff ff       	call   c01046ba <nr_free_pages>
c01065fd:	39 c3                	cmp    %eax,%ebx
c01065ff:	74 24                	je     c0106625 <check_swap+0xd5>
c0106601:	c7 44 24 0c 8e 9f 10 	movl   $0xc0109f8e,0xc(%esp)
c0106608:	c0 
c0106609:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106610:	c0 
c0106611:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106618:	00 
c0106619:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106620:	e8 b0 a6 ff ff       	call   c0100cd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106625:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106628:	89 44 24 08          	mov    %eax,0x8(%esp)
c010662c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010662f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106633:	c7 04 24 a8 9f 10 c0 	movl   $0xc0109fa8,(%esp)
c010663a:	e8 0c 9d ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010663f:	e8 f1 09 00 00       	call   c0107035 <mm_create>
c0106644:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106647:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010664b:	75 24                	jne    c0106671 <check_swap+0x121>
c010664d:	c7 44 24 0c ce 9f 10 	movl   $0xc0109fce,0xc(%esp)
c0106654:	c0 
c0106655:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c010665c:	c0 
c010665d:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106664:	00 
c0106665:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c010666c:	e8 64 a6 ff ff       	call   c0100cd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106671:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0106676:	85 c0                	test   %eax,%eax
c0106678:	74 24                	je     c010669e <check_swap+0x14e>
c010667a:	c7 44 24 0c d9 9f 10 	movl   $0xc0109fd9,0xc(%esp)
c0106681:	c0 
c0106682:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106689:	c0 
c010668a:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106691:	00 
c0106692:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106699:	e8 37 a6 ff ff       	call   c0100cd5 <__panic>

     check_mm_struct = mm;
c010669e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066a1:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01066a6:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c01066ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066af:	89 50 0c             	mov    %edx,0xc(%eax)
c01066b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066b5:	8b 40 0c             	mov    0xc(%eax),%eax
c01066b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01066bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066be:	8b 00                	mov    (%eax),%eax
c01066c0:	85 c0                	test   %eax,%eax
c01066c2:	74 24                	je     c01066e8 <check_swap+0x198>
c01066c4:	c7 44 24 0c f1 9f 10 	movl   $0xc0109ff1,0xc(%esp)
c01066cb:	c0 
c01066cc:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01066d3:	c0 
c01066d4:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01066db:	00 
c01066dc:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01066e3:	e8 ed a5 ff ff       	call   c0100cd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01066e8:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01066ef:	00 
c01066f0:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01066f7:	00 
c01066f8:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01066ff:	e8 a9 09 00 00       	call   c01070ad <vma_create>
c0106704:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106707:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010670b:	75 24                	jne    c0106731 <check_swap+0x1e1>
c010670d:	c7 44 24 0c ff 9f 10 	movl   $0xc0109fff,0xc(%esp)
c0106714:	c0 
c0106715:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c010671c:	c0 
c010671d:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106724:	00 
c0106725:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c010672c:	e8 a4 a5 ff ff       	call   c0100cd5 <__panic>

     insert_vma_struct(mm, vma);
c0106731:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106734:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106738:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010673b:	89 04 24             	mov    %eax,(%esp)
c010673e:	e8 fa 0a 00 00       	call   c010723d <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106743:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c010674a:	e8 fc 9b ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c010674f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106756:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106759:	8b 40 0c             	mov    0xc(%eax),%eax
c010675c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106763:	00 
c0106764:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010676b:	00 
c010676c:	89 04 24             	mov    %eax,(%esp)
c010676f:	e8 0b e6 ff ff       	call   c0104d7f <get_pte>
c0106774:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106777:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010677b:	75 24                	jne    c01067a1 <check_swap+0x251>
c010677d:	c7 44 24 0c 40 a0 10 	movl   $0xc010a040,0xc(%esp)
c0106784:	c0 
c0106785:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c010678c:	c0 
c010678d:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106794:	00 
c0106795:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c010679c:	e8 34 a5 ff ff       	call   c0100cd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01067a1:	c7 04 24 54 a0 10 c0 	movl   $0xc010a054,(%esp)
c01067a8:	e8 9e 9b ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01067ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01067b4:	e9 a3 00 00 00       	jmp    c010685c <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01067b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01067c0:	e8 58 de ff ff       	call   c010461d <alloc_pages>
c01067c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01067c8:	89 04 95 e0 1a 12 c0 	mov    %eax,-0x3fede520(,%edx,4)
          assert(check_rp[i] != NULL );
c01067cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067d2:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c01067d9:	85 c0                	test   %eax,%eax
c01067db:	75 24                	jne    c0106801 <check_swap+0x2b1>
c01067dd:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c01067e4:	c0 
c01067e5:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01067ec:	c0 
c01067ed:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01067f4:	00 
c01067f5:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01067fc:	e8 d4 a4 ff ff       	call   c0100cd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106801:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106804:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c010680b:	83 c0 04             	add    $0x4,%eax
c010680e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106815:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106818:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010681b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010681e:	0f a3 10             	bt     %edx,(%eax)
c0106821:	19 c0                	sbb    %eax,%eax
c0106823:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106826:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010682a:	0f 95 c0             	setne  %al
c010682d:	0f b6 c0             	movzbl %al,%eax
c0106830:	85 c0                	test   %eax,%eax
c0106832:	74 24                	je     c0106858 <check_swap+0x308>
c0106834:	c7 44 24 0c 8c a0 10 	movl   $0xc010a08c,0xc(%esp)
c010683b:	c0 
c010683c:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106843:	c0 
c0106844:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010684b:	00 
c010684c:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106853:	e8 7d a4 ff ff       	call   c0100cd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106858:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010685c:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106860:	0f 8e 53 ff ff ff    	jle    c01067b9 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106866:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c010686b:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0106871:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106874:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106877:	c7 45 a8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010687e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106881:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106884:	89 50 04             	mov    %edx,0x4(%eax)
c0106887:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010688a:	8b 50 04             	mov    0x4(%eax),%edx
c010688d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106890:	89 10                	mov    %edx,(%eax)
c0106892:	c7 45 a4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106899:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010689c:	8b 40 04             	mov    0x4(%eax),%eax
c010689f:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01068a2:	0f 94 c0             	sete   %al
c01068a5:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01068a8:	85 c0                	test   %eax,%eax
c01068aa:	75 24                	jne    c01068d0 <check_swap+0x380>
c01068ac:	c7 44 24 0c a7 a0 10 	movl   $0xc010a0a7,0xc(%esp)
c01068b3:	c0 
c01068b4:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c01068bb:	c0 
c01068bc:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01068c3:	00 
c01068c4:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c01068cb:	e8 05 a4 ff ff       	call   c0100cd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01068d0:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01068d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01068d8:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01068df:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01068e9:	eb 1e                	jmp    c0106909 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01068eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068ee:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c01068f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01068fc:	00 
c01068fd:	89 04 24             	mov    %eax,(%esp)
c0106900:	e8 83 dd ff ff       	call   c0104688 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106905:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106909:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010690d:	7e dc                	jle    c01068eb <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c010690f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106914:	83 f8 04             	cmp    $0x4,%eax
c0106917:	74 24                	je     c010693d <check_swap+0x3ed>
c0106919:	c7 44 24 0c c0 a0 10 	movl   $0xc010a0c0,0xc(%esp)
c0106920:	c0 
c0106921:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106928:	c0 
c0106929:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106930:	00 
c0106931:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106938:	e8 98 a3 ff ff       	call   c0100cd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010693d:	c7 04 24 e4 a0 10 c0 	movl   $0xc010a0e4,(%esp)
c0106944:	e8 02 9a ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106949:	c7 05 b8 1a 12 c0 00 	movl   $0x0,0xc0121ab8
c0106950:	00 00 00 
     
     check_content_set();
c0106953:	e8 28 fa ff ff       	call   c0106380 <check_content_set>
     assert( nr_free == 0);         
c0106958:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010695d:	85 c0                	test   %eax,%eax
c010695f:	74 24                	je     c0106985 <check_swap+0x435>
c0106961:	c7 44 24 0c 0b a1 10 	movl   $0xc010a10b,0xc(%esp)
c0106968:	c0 
c0106969:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106970:	c0 
c0106971:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106978:	00 
c0106979:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106980:	e8 50 a3 ff ff       	call   c0100cd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106985:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010698c:	eb 26                	jmp    c01069b4 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c010698e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106991:	c7 04 85 00 1b 12 c0 	movl   $0xffffffff,-0x3fede500(,%eax,4)
c0106998:	ff ff ff ff 
c010699c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010699f:	8b 14 85 00 1b 12 c0 	mov    -0x3fede500(,%eax,4),%edx
c01069a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069a9:	89 14 85 40 1b 12 c0 	mov    %edx,-0x3fede4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069b0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01069b4:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01069b8:	7e d4                	jle    c010698e <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069c1:	e9 eb 00 00 00       	jmp    c0106ab1 <check_swap+0x561>
         check_ptep[i]=0;
c01069c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069c9:	c7 04 85 94 1b 12 c0 	movl   $0x0,-0x3fede46c(,%eax,4)
c01069d0:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01069d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069d7:	83 c0 01             	add    $0x1,%eax
c01069da:	c1 e0 0c             	shl    $0xc,%eax
c01069dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01069e4:	00 
c01069e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069ec:	89 04 24             	mov    %eax,(%esp)
c01069ef:	e8 8b e3 ff ff       	call   c0104d7f <get_pte>
c01069f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01069f7:	89 04 95 94 1b 12 c0 	mov    %eax,-0x3fede46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01069fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a01:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106a08:	85 c0                	test   %eax,%eax
c0106a0a:	75 24                	jne    c0106a30 <check_swap+0x4e0>
c0106a0c:	c7 44 24 0c 18 a1 10 	movl   $0xc010a118,0xc(%esp)
c0106a13:	c0 
c0106a14:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106a1b:	c0 
c0106a1c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106a23:	00 
c0106a24:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106a2b:	e8 a5 a2 ff ff       	call   c0100cd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a33:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106a3a:	8b 00                	mov    (%eax),%eax
c0106a3c:	89 04 24             	mov    %eax,(%esp)
c0106a3f:	e8 9f f5 ff ff       	call   c0105fe3 <pte2page>
c0106a44:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a47:	8b 14 95 e0 1a 12 c0 	mov    -0x3fede520(,%edx,4),%edx
c0106a4e:	39 d0                	cmp    %edx,%eax
c0106a50:	74 24                	je     c0106a76 <check_swap+0x526>
c0106a52:	c7 44 24 0c 30 a1 10 	movl   $0xc010a130,0xc(%esp)
c0106a59:	c0 
c0106a5a:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106a61:	c0 
c0106a62:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106a69:	00 
c0106a6a:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106a71:	e8 5f a2 ff ff       	call   c0100cd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a79:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106a80:	8b 00                	mov    (%eax),%eax
c0106a82:	83 e0 01             	and    $0x1,%eax
c0106a85:	85 c0                	test   %eax,%eax
c0106a87:	75 24                	jne    c0106aad <check_swap+0x55d>
c0106a89:	c7 44 24 0c 58 a1 10 	movl   $0xc010a158,0xc(%esp)
c0106a90:	c0 
c0106a91:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106a98:	c0 
c0106a99:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106aa0:	00 
c0106aa1:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106aa8:	e8 28 a2 ff ff       	call   c0100cd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106aad:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ab1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106ab5:	0f 8e 0b ff ff ff    	jle    c01069c6 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106abb:	c7 04 24 74 a1 10 c0 	movl   $0xc010a174,(%esp)
c0106ac2:	e8 84 98 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106ac7:	e8 6c fa ff ff       	call   c0106538 <check_content_access>
c0106acc:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106acf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106ad3:	74 24                	je     c0106af9 <check_swap+0x5a9>
c0106ad5:	c7 44 24 0c 9a a1 10 	movl   $0xc010a19a,0xc(%esp)
c0106adc:	c0 
c0106add:	c7 44 24 08 82 9e 10 	movl   $0xc0109e82,0x8(%esp)
c0106ae4:	c0 
c0106ae5:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106aec:	00 
c0106aed:	c7 04 24 1c 9e 10 c0 	movl   $0xc0109e1c,(%esp)
c0106af4:	e8 dc a1 ff ff       	call   c0100cd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106af9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b00:	eb 1e                	jmp    c0106b20 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b05:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106b0c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b13:	00 
c0106b14:	89 04 24             	mov    %eax,(%esp)
c0106b17:	e8 6c db ff ff       	call   c0104688 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b1c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b20:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b24:	7e dc                	jle    c0106b02 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b29:	89 04 24             	mov    %eax,(%esp)
c0106b2c:	e8 3c 08 00 00       	call   c010736d <mm_destroy>
         
     nr_free = nr_free_store;
c0106b31:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b34:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
     free_list = free_list_store;
c0106b39:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106b3c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106b3f:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0106b44:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4

     
     le = &free_list;
c0106b4a:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b51:	eb 1d                	jmp    c0106b70 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b56:	83 e8 0c             	sub    $0xc,%eax
c0106b59:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106b5c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106b60:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106b63:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106b66:	8b 40 08             	mov    0x8(%eax),%eax
c0106b69:	29 c2                	sub    %eax,%edx
c0106b6b:	89 d0                	mov    %edx,%eax
c0106b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b73:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106b76:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106b79:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106b7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b7f:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106b86:	75 cb                	jne    c0106b53 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b96:	c7 04 24 a1 a1 10 c0 	movl   $0xc010a1a1,(%esp)
c0106b9d:	e8 a9 97 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106ba2:	c7 04 24 bb a1 10 c0 	movl   $0xc010a1bb,(%esp)
c0106ba9:	e8 9d 97 ff ff       	call   c010034b <cprintf>
}
c0106bae:	83 c4 74             	add    $0x74,%esp
c0106bb1:	5b                   	pop    %ebx
c0106bb2:	5d                   	pop    %ebp
c0106bb3:	c3                   	ret    

c0106bb4 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106bb4:	55                   	push   %ebp
c0106bb5:	89 e5                	mov    %esp,%ebp
c0106bb7:	83 ec 10             	sub    $0x10,%esp
c0106bba:	c7 45 fc a4 1b 12 c0 	movl   $0xc0121ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106bc7:	89 50 04             	mov    %edx,0x4(%eax)
c0106bca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bcd:	8b 50 04             	mov    0x4(%eax),%edx
c0106bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bd3:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd8:	c7 40 14 a4 1b 12 c0 	movl   $0xc0121ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106be4:	c9                   	leave  
c0106be5:	c3                   	ret    

c0106be6 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106be6:	55                   	push   %ebp
c0106be7:	89 e5                	mov    %esp,%ebp
c0106be9:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bef:	8b 40 14             	mov    0x14(%eax),%eax
c0106bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106bf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bf8:	83 c0 14             	add    $0x14,%eax
c0106bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c02:	74 06                	je     c0106c0a <_fifo_map_swappable+0x24>
c0106c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c08:	75 24                	jne    c0106c2e <_fifo_map_swappable+0x48>
c0106c0a:	c7 44 24 0c d4 a1 10 	movl   $0xc010a1d4,0xc(%esp)
c0106c11:	c0 
c0106c12:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106c19:	c0 
c0106c1a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106c21:	00 
c0106c22:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106c29:	e8 a7 a0 ff ff       	call   c0100cd5 <__panic>
c0106c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c31:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c49:	8b 40 04             	mov    0x4(%eax),%eax
c0106c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c55:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106c58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106c5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c61:	89 10                	mov    %edx,(%eax)
c0106c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c66:	8b 10                	mov    (%eax),%edx
c0106c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106c6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106c6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c74:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c7d:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
	list_add(head, entry);
    return 0;
c0106c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c84:	c9                   	leave  
c0106c85:	c3                   	ret    

c0106c86 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106c86:	55                   	push   %ebp
c0106c87:	89 e5                	mov    %esp,%ebp
c0106c89:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c8f:	8b 40 14             	mov    0x14(%eax),%eax
c0106c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106c95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c99:	75 24                	jne    c0106cbf <_fifo_swap_out_victim+0x39>
c0106c9b:	c7 44 24 0c 1b a2 10 	movl   $0xc010a21b,0xc(%esp)
c0106ca2:	c0 
c0106ca3:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106caa:	c0 
c0106cab:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106cb2:	00 
c0106cb3:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106cba:	e8 16 a0 ff ff       	call   c0100cd5 <__panic>
     assert(in_tick==0);
c0106cbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106cc3:	74 24                	je     c0106ce9 <_fifo_swap_out_victim+0x63>
c0106cc5:	c7 44 24 0c 28 a2 10 	movl   $0xc010a228,0xc(%esp)
c0106ccc:	c0 
c0106ccd:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106cd4:	c0 
c0106cd5:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106cdc:	00 
c0106cdd:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106ce4:	e8 ec 9f ff ff       	call   c0100cd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
	 list_entry_t *e = head->prev;
c0106ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cec:	8b 00                	mov    (%eax),%eax
c0106cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	 struct Page *p = le2page(e, pra_page_link);
c0106cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cf4:	83 e8 14             	sub    $0x14,%eax
c0106cf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d03:	8b 40 04             	mov    0x4(%eax),%eax
c0106d06:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d09:	8b 12                	mov    (%edx),%edx
c0106d0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106d0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d14:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d17:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d20:	89 10                	mov    %edx,(%eax)
	 list_del(e);
	 *ptr_page = p;
c0106d22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d25:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d28:	89 10                	mov    %edx,(%eax)
     return 0;
c0106d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d2f:	c9                   	leave  
c0106d30:	c3                   	ret    

c0106d31 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106d31:	55                   	push   %ebp
c0106d32:	89 e5                	mov    %esp,%ebp
c0106d34:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106d37:	c7 04 24 34 a2 10 c0 	movl   $0xc010a234,(%esp)
c0106d3e:	e8 08 96 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106d43:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106d48:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106d4b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106d50:	83 f8 04             	cmp    $0x4,%eax
c0106d53:	74 24                	je     c0106d79 <_fifo_check_swap+0x48>
c0106d55:	c7 44 24 0c 5a a2 10 	movl   $0xc010a25a,0xc(%esp)
c0106d5c:	c0 
c0106d5d:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106d64:	c0 
c0106d65:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c0106d6c:	00 
c0106d6d:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106d74:	e8 5c 9f ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106d79:	c7 04 24 6c a2 10 c0 	movl   $0xc010a26c,(%esp)
c0106d80:	e8 c6 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106d85:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106d8a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106d8d:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106d92:	83 f8 04             	cmp    $0x4,%eax
c0106d95:	74 24                	je     c0106dbb <_fifo_check_swap+0x8a>
c0106d97:	c7 44 24 0c 5a a2 10 	movl   $0xc010a25a,0xc(%esp)
c0106d9e:	c0 
c0106d9f:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106da6:	c0 
c0106da7:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0106dae:	00 
c0106daf:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106db6:	e8 1a 9f ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106dbb:	c7 04 24 94 a2 10 c0 	movl   $0xc010a294,(%esp)
c0106dc2:	e8 84 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106dc7:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106dcc:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106dcf:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106dd4:	83 f8 04             	cmp    $0x4,%eax
c0106dd7:	74 24                	je     c0106dfd <_fifo_check_swap+0xcc>
c0106dd9:	c7 44 24 0c 5a a2 10 	movl   $0xc010a25a,0xc(%esp)
c0106de0:	c0 
c0106de1:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106de8:	c0 
c0106de9:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0106df0:	00 
c0106df1:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106df8:	e8 d8 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106dfd:	c7 04 24 bc a2 10 c0 	movl   $0xc010a2bc,(%esp)
c0106e04:	e8 42 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e09:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e0e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106e11:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106e16:	83 f8 04             	cmp    $0x4,%eax
c0106e19:	74 24                	je     c0106e3f <_fifo_check_swap+0x10e>
c0106e1b:	c7 44 24 0c 5a a2 10 	movl   $0xc010a25a,0xc(%esp)
c0106e22:	c0 
c0106e23:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106e2a:	c0 
c0106e2b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106e32:	00 
c0106e33:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106e3a:	e8 96 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106e3f:	c7 04 24 e4 a2 10 c0 	movl   $0xc010a2e4,(%esp)
c0106e46:	e8 00 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106e4b:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106e50:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106e53:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106e58:	83 f8 05             	cmp    $0x5,%eax
c0106e5b:	74 24                	je     c0106e81 <_fifo_check_swap+0x150>
c0106e5d:	c7 44 24 0c 0a a3 10 	movl   $0xc010a30a,0xc(%esp)
c0106e64:	c0 
c0106e65:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106e6c:	c0 
c0106e6d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106e74:	00 
c0106e75:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106e7c:	e8 54 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106e81:	c7 04 24 bc a2 10 c0 	movl   $0xc010a2bc,(%esp)
c0106e88:	e8 be 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e8d:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e92:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106e95:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106e9a:	83 f8 05             	cmp    $0x5,%eax
c0106e9d:	74 24                	je     c0106ec3 <_fifo_check_swap+0x192>
c0106e9f:	c7 44 24 0c 0a a3 10 	movl   $0xc010a30a,0xc(%esp)
c0106ea6:	c0 
c0106ea7:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106eae:	c0 
c0106eaf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0106eb6:	00 
c0106eb7:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106ebe:	e8 12 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106ec3:	c7 04 24 6c a2 10 c0 	movl   $0xc010a26c,(%esp)
c0106eca:	e8 7c 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106ecf:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106ed4:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106ed7:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106edc:	83 f8 06             	cmp    $0x6,%eax
c0106edf:	74 24                	je     c0106f05 <_fifo_check_swap+0x1d4>
c0106ee1:	c7 44 24 0c 19 a3 10 	movl   $0xc010a319,0xc(%esp)
c0106ee8:	c0 
c0106ee9:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106ef0:	c0 
c0106ef1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0106ef8:	00 
c0106ef9:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106f00:	e8 d0 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f05:	c7 04 24 bc a2 10 c0 	movl   $0xc010a2bc,(%esp)
c0106f0c:	e8 3a 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f11:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f16:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106f19:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f1e:	83 f8 07             	cmp    $0x7,%eax
c0106f21:	74 24                	je     c0106f47 <_fifo_check_swap+0x216>
c0106f23:	c7 44 24 0c 28 a3 10 	movl   $0xc010a328,0xc(%esp)
c0106f2a:	c0 
c0106f2b:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106f32:	c0 
c0106f33:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106f3a:	00 
c0106f3b:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106f42:	e8 8e 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106f47:	c7 04 24 34 a2 10 c0 	movl   $0xc010a234,(%esp)
c0106f4e:	e8 f8 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106f53:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106f58:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106f5b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f60:	83 f8 08             	cmp    $0x8,%eax
c0106f63:	74 24                	je     c0106f89 <_fifo_check_swap+0x258>
c0106f65:	c7 44 24 0c 37 a3 10 	movl   $0xc010a337,0xc(%esp)
c0106f6c:	c0 
c0106f6d:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106f74:	c0 
c0106f75:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0106f7c:	00 
c0106f7d:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106f84:	e8 4c 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106f89:	c7 04 24 94 a2 10 c0 	movl   $0xc010a294,(%esp)
c0106f90:	e8 b6 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f95:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106f9a:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106f9d:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fa2:	83 f8 09             	cmp    $0x9,%eax
c0106fa5:	74 24                	je     c0106fcb <_fifo_check_swap+0x29a>
c0106fa7:	c7 44 24 0c 46 a3 10 	movl   $0xc010a346,0xc(%esp)
c0106fae:	c0 
c0106faf:	c7 44 24 08 f2 a1 10 	movl   $0xc010a1f2,0x8(%esp)
c0106fb6:	c0 
c0106fb7:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106fbe:	00 
c0106fbf:	c7 04 24 07 a2 10 c0 	movl   $0xc010a207,(%esp)
c0106fc6:	e8 0a 9d ff ff       	call   c0100cd5 <__panic>
    return 0;
c0106fcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fd0:	c9                   	leave  
c0106fd1:	c3                   	ret    

c0106fd2 <_fifo_init>:


static int
_fifo_init(void)
{
c0106fd2:	55                   	push   %ebp
c0106fd3:	89 e5                	mov    %esp,%ebp
    return 0;
c0106fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fda:	5d                   	pop    %ebp
c0106fdb:	c3                   	ret    

c0106fdc <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106fdc:	55                   	push   %ebp
c0106fdd:	89 e5                	mov    %esp,%ebp
    return 0;
c0106fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fe4:	5d                   	pop    %ebp
c0106fe5:	c3                   	ret    

c0106fe6 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0106fe6:	55                   	push   %ebp
c0106fe7:	89 e5                	mov    %esp,%ebp
c0106fe9:	b8 00 00 00 00       	mov    $0x0,%eax
c0106fee:	5d                   	pop    %ebp
c0106fef:	c3                   	ret    

c0106ff0 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106ff0:	55                   	push   %ebp
c0106ff1:	89 e5                	mov    %esp,%ebp
c0106ff3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ff9:	c1 e8 0c             	shr    $0xc,%eax
c0106ffc:	89 c2                	mov    %eax,%edx
c0106ffe:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107003:	39 c2                	cmp    %eax,%edx
c0107005:	72 1c                	jb     c0107023 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107007:	c7 44 24 08 68 a3 10 	movl   $0xc010a368,0x8(%esp)
c010700e:	c0 
c010700f:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107016:	00 
c0107017:	c7 04 24 87 a3 10 c0 	movl   $0xc010a387,(%esp)
c010701e:	e8 b2 9c ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0107023:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0107028:	8b 55 08             	mov    0x8(%ebp),%edx
c010702b:	c1 ea 0c             	shr    $0xc,%edx
c010702e:	c1 e2 05             	shl    $0x5,%edx
c0107031:	01 d0                	add    %edx,%eax
}
c0107033:	c9                   	leave  
c0107034:	c3                   	ret    

c0107035 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107035:	55                   	push   %ebp
c0107036:	89 e5                	mov    %esp,%ebp
c0107038:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010703b:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107042:	e8 1d ee ff ff       	call   c0105e64 <kmalloc>
c0107047:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010704a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010704e:	74 58                	je     c01070a8 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0107050:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107053:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107056:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107059:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010705c:	89 50 04             	mov    %edx,0x4(%eax)
c010705f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107062:	8b 50 04             	mov    0x4(%eax),%edx
c0107065:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107068:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010706a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010706d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107074:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107077:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010707e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107081:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107088:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c010708d:	85 c0                	test   %eax,%eax
c010708f:	74 0d                	je     c010709e <mm_create+0x69>
c0107091:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107094:	89 04 24             	mov    %eax,(%esp)
c0107097:	e8 15 f0 ff ff       	call   c01060b1 <swap_init_mm>
c010709c:	eb 0a                	jmp    c01070a8 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010709e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070a1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01070a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01070ab:	c9                   	leave  
c01070ac:	c3                   	ret    

c01070ad <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01070ad:	55                   	push   %ebp
c01070ae:	89 e5                	mov    %esp,%ebp
c01070b0:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01070b3:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01070ba:	e8 a5 ed ff ff       	call   c0105e64 <kmalloc>
c01070bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01070c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070c6:	74 1b                	je     c01070e3 <vma_create+0x36>
        vma->vm_start = vm_start;
c01070c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01070ce:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01070d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01070d7:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01070da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01070e0:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01070e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01070e6:	c9                   	leave  
c01070e7:	c3                   	ret    

c01070e8 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01070e8:	55                   	push   %ebp
c01070e9:	89 e5                	mov    %esp,%ebp
c01070eb:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01070ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01070f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01070f9:	0f 84 95 00 00 00    	je     c0107194 <find_vma+0xac>
        vma = mm->mmap_cache;
c01070ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0107102:	8b 40 08             	mov    0x8(%eax),%eax
c0107105:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107108:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010710c:	74 16                	je     c0107124 <find_vma+0x3c>
c010710e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107111:	8b 40 04             	mov    0x4(%eax),%eax
c0107114:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107117:	77 0b                	ja     c0107124 <find_vma+0x3c>
c0107119:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010711c:	8b 40 08             	mov    0x8(%eax),%eax
c010711f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107122:	77 61                	ja     c0107185 <find_vma+0x9d>
                bool found = 0;
c0107124:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010712b:	8b 45 08             	mov    0x8(%ebp),%eax
c010712e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107134:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107137:	eb 28                	jmp    c0107161 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107139:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010713c:	83 e8 10             	sub    $0x10,%eax
c010713f:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107142:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107145:	8b 40 04             	mov    0x4(%eax),%eax
c0107148:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010714b:	77 14                	ja     c0107161 <find_vma+0x79>
c010714d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107150:	8b 40 08             	mov    0x8(%eax),%eax
c0107153:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107156:	76 09                	jbe    c0107161 <find_vma+0x79>
                        found = 1;
c0107158:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010715f:	eb 17                	jmp    c0107178 <find_vma+0x90>
c0107161:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107164:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107167:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010716a:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010716d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107170:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107176:	75 c1                	jne    c0107139 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107178:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010717c:	75 07                	jne    c0107185 <find_vma+0x9d>
                    vma = NULL;
c010717e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107185:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107189:	74 09                	je     c0107194 <find_vma+0xac>
            mm->mmap_cache = vma;
c010718b:	8b 45 08             	mov    0x8(%ebp),%eax
c010718e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107191:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107194:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107197:	c9                   	leave  
c0107198:	c3                   	ret    

c0107199 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107199:	55                   	push   %ebp
c010719a:	89 e5                	mov    %esp,%ebp
c010719c:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010719f:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a2:	8b 50 04             	mov    0x4(%eax),%edx
c01071a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a8:	8b 40 08             	mov    0x8(%eax),%eax
c01071ab:	39 c2                	cmp    %eax,%edx
c01071ad:	72 24                	jb     c01071d3 <check_vma_overlap+0x3a>
c01071af:	c7 44 24 0c 95 a3 10 	movl   $0xc010a395,0xc(%esp)
c01071b6:	c0 
c01071b7:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01071be:	c0 
c01071bf:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01071c6:	00 
c01071c7:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01071ce:	e8 02 9b ff ff       	call   c0100cd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01071d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01071d6:	8b 50 08             	mov    0x8(%eax),%edx
c01071d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071dc:	8b 40 04             	mov    0x4(%eax),%eax
c01071df:	39 c2                	cmp    %eax,%edx
c01071e1:	76 24                	jbe    c0107207 <check_vma_overlap+0x6e>
c01071e3:	c7 44 24 0c d8 a3 10 	movl   $0xc010a3d8,0xc(%esp)
c01071ea:	c0 
c01071eb:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01071f2:	c0 
c01071f3:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01071fa:	00 
c01071fb:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107202:	e8 ce 9a ff ff       	call   c0100cd5 <__panic>
    assert(next->vm_start < next->vm_end);
c0107207:	8b 45 0c             	mov    0xc(%ebp),%eax
c010720a:	8b 50 04             	mov    0x4(%eax),%edx
c010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107210:	8b 40 08             	mov    0x8(%eax),%eax
c0107213:	39 c2                	cmp    %eax,%edx
c0107215:	72 24                	jb     c010723b <check_vma_overlap+0xa2>
c0107217:	c7 44 24 0c f7 a3 10 	movl   $0xc010a3f7,0xc(%esp)
c010721e:	c0 
c010721f:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107226:	c0 
c0107227:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c010722e:	00 
c010722f:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107236:	e8 9a 9a ff ff       	call   c0100cd5 <__panic>
}
c010723b:	c9                   	leave  
c010723c:	c3                   	ret    

c010723d <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010723d:	55                   	push   %ebp
c010723e:	89 e5                	mov    %esp,%ebp
c0107240:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107243:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107246:	8b 50 04             	mov    0x4(%eax),%edx
c0107249:	8b 45 0c             	mov    0xc(%ebp),%eax
c010724c:	8b 40 08             	mov    0x8(%eax),%eax
c010724f:	39 c2                	cmp    %eax,%edx
c0107251:	72 24                	jb     c0107277 <insert_vma_struct+0x3a>
c0107253:	c7 44 24 0c 15 a4 10 	movl   $0xc010a415,0xc(%esp)
c010725a:	c0 
c010725b:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107262:	c0 
c0107263:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010726a:	00 
c010726b:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107272:	e8 5e 9a ff ff       	call   c0100cd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107277:	8b 45 08             	mov    0x8(%ebp),%eax
c010727a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010727d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107280:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107283:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107286:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107289:	eb 21                	jmp    c01072ac <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010728b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010728e:	83 e8 10             	sub    $0x10,%eax
c0107291:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107294:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107297:	8b 50 04             	mov    0x4(%eax),%edx
c010729a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010729d:	8b 40 04             	mov    0x4(%eax),%eax
c01072a0:	39 c2                	cmp    %eax,%edx
c01072a2:	76 02                	jbe    c01072a6 <insert_vma_struct+0x69>
                break;
c01072a4:	eb 1d                	jmp    c01072c3 <insert_vma_struct+0x86>
            }
            le_prev = le;
c01072a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072af:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01072b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072b5:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01072b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072c1:	75 c8                	jne    c010728b <insert_vma_struct+0x4e>
c01072c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01072c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072cc:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01072cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01072d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072d8:	74 15                	je     c01072ef <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01072da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072dd:	8d 50 f0             	lea    -0x10(%eax),%edx
c01072e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072e7:	89 14 24             	mov    %edx,(%esp)
c01072ea:	e8 aa fe ff ff       	call   c0107199 <check_vma_overlap>
    }
    if (le_next != list) {
c01072ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072f5:	74 15                	je     c010730c <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01072f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072fa:	83 e8 10             	sub    $0x10,%eax
c01072fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107301:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107304:	89 04 24             	mov    %eax,(%esp)
c0107307:	e8 8d fe ff ff       	call   c0107199 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010730c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010730f:	8b 55 08             	mov    0x8(%ebp),%edx
c0107312:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107314:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107317:	8d 50 10             	lea    0x10(%eax),%edx
c010731a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010731d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107320:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107323:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107326:	8b 40 04             	mov    0x4(%eax),%eax
c0107329:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010732c:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010732f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107332:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107335:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107338:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010733b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010733e:	89 10                	mov    %edx,(%eax)
c0107340:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107343:	8b 10                	mov    (%eax),%edx
c0107345:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107348:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010734b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010734e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107351:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107354:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107357:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010735a:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010735c:	8b 45 08             	mov    0x8(%ebp),%eax
c010735f:	8b 40 10             	mov    0x10(%eax),%eax
c0107362:	8d 50 01             	lea    0x1(%eax),%edx
c0107365:	8b 45 08             	mov    0x8(%ebp),%eax
c0107368:	89 50 10             	mov    %edx,0x10(%eax)
}
c010736b:	c9                   	leave  
c010736c:	c3                   	ret    

c010736d <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010736d:	55                   	push   %ebp
c010736e:	89 e5                	mov    %esp,%ebp
c0107370:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107373:	8b 45 08             	mov    0x8(%ebp),%eax
c0107376:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107379:	eb 3e                	jmp    c01073b9 <mm_destroy+0x4c>
c010737b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010737e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107381:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107384:	8b 40 04             	mov    0x4(%eax),%eax
c0107387:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010738a:	8b 12                	mov    (%edx),%edx
c010738c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010738f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107392:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107395:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107398:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010739b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010739e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01073a1:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c01073a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a6:	83 e8 10             	sub    $0x10,%eax
c01073a9:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01073b0:	00 
c01073b1:	89 04 24             	mov    %eax,(%esp)
c01073b4:	e8 4b eb ff ff       	call   c0105f04 <kfree>
c01073b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01073bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073c2:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01073c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01073ce:	75 ab                	jne    c010737b <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01073d0:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01073d7:	00 
c01073d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01073db:	89 04 24             	mov    %eax,(%esp)
c01073de:	e8 21 eb ff ff       	call   c0105f04 <kfree>
    mm=NULL;
c01073e3:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01073ea:	c9                   	leave  
c01073eb:	c3                   	ret    

c01073ec <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01073ec:	55                   	push   %ebp
c01073ed:	89 e5                	mov    %esp,%ebp
c01073ef:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01073f2:	e8 02 00 00 00       	call   c01073f9 <check_vmm>
}
c01073f7:	c9                   	leave  
c01073f8:	c3                   	ret    

c01073f9 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01073f9:	55                   	push   %ebp
c01073fa:	89 e5                	mov    %esp,%ebp
c01073fc:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01073ff:	e8 b6 d2 ff ff       	call   c01046ba <nr_free_pages>
c0107404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107407:	e8 41 00 00 00       	call   c010744d <check_vma_struct>
    check_pgfault();
c010740c:	e8 03 05 00 00       	call   c0107914 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0107411:	e8 a4 d2 ff ff       	call   c01046ba <nr_free_pages>
c0107416:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107419:	74 24                	je     c010743f <check_vmm+0x46>
c010741b:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c0107422:	c0 
c0107423:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c010742a:	c0 
c010742b:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0107432:	00 
c0107433:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c010743a:	e8 96 98 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vmm() succeeded.\n");
c010743f:	c7 04 24 5b a4 10 c0 	movl   $0xc010a45b,(%esp)
c0107446:	e8 00 8f ff ff       	call   c010034b <cprintf>
}
c010744b:	c9                   	leave  
c010744c:	c3                   	ret    

c010744d <check_vma_struct>:

static void
check_vma_struct(void) {
c010744d:	55                   	push   %ebp
c010744e:	89 e5                	mov    %esp,%ebp
c0107450:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107453:	e8 62 d2 ff ff       	call   c01046ba <nr_free_pages>
c0107458:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010745b:	e8 d5 fb ff ff       	call   c0107035 <mm_create>
c0107460:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107463:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107467:	75 24                	jne    c010748d <check_vma_struct+0x40>
c0107469:	c7 44 24 0c 73 a4 10 	movl   $0xc010a473,0xc(%esp)
c0107470:	c0 
c0107471:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107478:	c0 
c0107479:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107480:	00 
c0107481:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107488:	e8 48 98 ff ff       	call   c0100cd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c010748d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107494:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107497:	89 d0                	mov    %edx,%eax
c0107499:	c1 e0 02             	shl    $0x2,%eax
c010749c:	01 d0                	add    %edx,%eax
c010749e:	01 c0                	add    %eax,%eax
c01074a0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01074a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01074a9:	eb 70                	jmp    c010751b <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01074ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074ae:	89 d0                	mov    %edx,%eax
c01074b0:	c1 e0 02             	shl    $0x2,%eax
c01074b3:	01 d0                	add    %edx,%eax
c01074b5:	83 c0 02             	add    $0x2,%eax
c01074b8:	89 c1                	mov    %eax,%ecx
c01074ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074bd:	89 d0                	mov    %edx,%eax
c01074bf:	c1 e0 02             	shl    $0x2,%eax
c01074c2:	01 d0                	add    %edx,%eax
c01074c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074cb:	00 
c01074cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01074d0:	89 04 24             	mov    %eax,(%esp)
c01074d3:	e8 d5 fb ff ff       	call   c01070ad <vma_create>
c01074d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01074db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01074df:	75 24                	jne    c0107505 <check_vma_struct+0xb8>
c01074e1:	c7 44 24 0c 7e a4 10 	movl   $0xc010a47e,0xc(%esp)
c01074e8:	c0 
c01074e9:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01074f0:	c0 
c01074f1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01074f8:	00 
c01074f9:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107500:	e8 d0 97 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c0107505:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107508:	89 44 24 04          	mov    %eax,0x4(%esp)
c010750c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010750f:	89 04 24             	mov    %eax,(%esp)
c0107512:	e8 26 fd ff ff       	call   c010723d <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107517:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010751b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010751f:	7f 8a                	jg     c01074ab <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107524:	83 c0 01             	add    $0x1,%eax
c0107527:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010752a:	eb 70                	jmp    c010759c <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010752c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010752f:	89 d0                	mov    %edx,%eax
c0107531:	c1 e0 02             	shl    $0x2,%eax
c0107534:	01 d0                	add    %edx,%eax
c0107536:	83 c0 02             	add    $0x2,%eax
c0107539:	89 c1                	mov    %eax,%ecx
c010753b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010753e:	89 d0                	mov    %edx,%eax
c0107540:	c1 e0 02             	shl    $0x2,%eax
c0107543:	01 d0                	add    %edx,%eax
c0107545:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010754c:	00 
c010754d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107551:	89 04 24             	mov    %eax,(%esp)
c0107554:	e8 54 fb ff ff       	call   c01070ad <vma_create>
c0107559:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c010755c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107560:	75 24                	jne    c0107586 <check_vma_struct+0x139>
c0107562:	c7 44 24 0c 7e a4 10 	movl   $0xc010a47e,0xc(%esp)
c0107569:	c0 
c010756a:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107571:	c0 
c0107572:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107579:	00 
c010757a:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107581:	e8 4f 97 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c0107586:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107589:	89 44 24 04          	mov    %eax,0x4(%esp)
c010758d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107590:	89 04 24             	mov    %eax,(%esp)
c0107593:	e8 a5 fc ff ff       	call   c010723d <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107598:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010759c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010759f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01075a2:	7e 88                	jle    c010752c <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01075a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075a7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01075aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01075ad:	8b 40 04             	mov    0x4(%eax),%eax
c01075b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01075b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01075ba:	e9 97 00 00 00       	jmp    c0107656 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c01075bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01075c5:	75 24                	jne    c01075eb <check_vma_struct+0x19e>
c01075c7:	c7 44 24 0c 8a a4 10 	movl   $0xc010a48a,0xc(%esp)
c01075ce:	c0 
c01075cf:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01075d6:	c0 
c01075d7:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01075de:	00 
c01075df:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01075e6:	e8 ea 96 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01075eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075ee:	83 e8 10             	sub    $0x10,%eax
c01075f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c01075f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01075f7:	8b 48 04             	mov    0x4(%eax),%ecx
c01075fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075fd:	89 d0                	mov    %edx,%eax
c01075ff:	c1 e0 02             	shl    $0x2,%eax
c0107602:	01 d0                	add    %edx,%eax
c0107604:	39 c1                	cmp    %eax,%ecx
c0107606:	75 17                	jne    c010761f <check_vma_struct+0x1d2>
c0107608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010760b:	8b 48 08             	mov    0x8(%eax),%ecx
c010760e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107611:	89 d0                	mov    %edx,%eax
c0107613:	c1 e0 02             	shl    $0x2,%eax
c0107616:	01 d0                	add    %edx,%eax
c0107618:	83 c0 02             	add    $0x2,%eax
c010761b:	39 c1                	cmp    %eax,%ecx
c010761d:	74 24                	je     c0107643 <check_vma_struct+0x1f6>
c010761f:	c7 44 24 0c a4 a4 10 	movl   $0xc010a4a4,0xc(%esp)
c0107626:	c0 
c0107627:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c010762e:	c0 
c010762f:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107636:	00 
c0107637:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c010763e:	e8 92 96 ff ff       	call   c0100cd5 <__panic>
c0107643:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107646:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107649:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010764c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010764f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107652:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107656:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107659:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010765c:	0f 8e 5d ff ff ff    	jle    c01075bf <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107662:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107669:	e9 cd 01 00 00       	jmp    c010783b <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107671:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107675:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107678:	89 04 24             	mov    %eax,(%esp)
c010767b:	e8 68 fa ff ff       	call   c01070e8 <find_vma>
c0107680:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107683:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107687:	75 24                	jne    c01076ad <check_vma_struct+0x260>
c0107689:	c7 44 24 0c d9 a4 10 	movl   $0xc010a4d9,0xc(%esp)
c0107690:	c0 
c0107691:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107698:	c0 
c0107699:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01076a0:	00 
c01076a1:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01076a8:	e8 28 96 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01076ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b0:	83 c0 01             	add    $0x1,%eax
c01076b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076ba:	89 04 24             	mov    %eax,(%esp)
c01076bd:	e8 26 fa ff ff       	call   c01070e8 <find_vma>
c01076c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01076c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01076c9:	75 24                	jne    c01076ef <check_vma_struct+0x2a2>
c01076cb:	c7 44 24 0c e6 a4 10 	movl   $0xc010a4e6,0xc(%esp)
c01076d2:	c0 
c01076d3:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01076da:	c0 
c01076db:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01076e2:	00 
c01076e3:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01076ea:	e8 e6 95 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01076ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076f2:	83 c0 02             	add    $0x2,%eax
c01076f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076fc:	89 04 24             	mov    %eax,(%esp)
c01076ff:	e8 e4 f9 ff ff       	call   c01070e8 <find_vma>
c0107704:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107707:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010770b:	74 24                	je     c0107731 <check_vma_struct+0x2e4>
c010770d:	c7 44 24 0c f3 a4 10 	movl   $0xc010a4f3,0xc(%esp)
c0107714:	c0 
c0107715:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c010771c:	c0 
c010771d:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107724:	00 
c0107725:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c010772c:	e8 a4 95 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107734:	83 c0 03             	add    $0x3,%eax
c0107737:	89 44 24 04          	mov    %eax,0x4(%esp)
c010773b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010773e:	89 04 24             	mov    %eax,(%esp)
c0107741:	e8 a2 f9 ff ff       	call   c01070e8 <find_vma>
c0107746:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107749:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010774d:	74 24                	je     c0107773 <check_vma_struct+0x326>
c010774f:	c7 44 24 0c 00 a5 10 	movl   $0xc010a500,0xc(%esp)
c0107756:	c0 
c0107757:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c010775e:	c0 
c010775f:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107766:	00 
c0107767:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c010776e:	e8 62 95 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107776:	83 c0 04             	add    $0x4,%eax
c0107779:	89 44 24 04          	mov    %eax,0x4(%esp)
c010777d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107780:	89 04 24             	mov    %eax,(%esp)
c0107783:	e8 60 f9 ff ff       	call   c01070e8 <find_vma>
c0107788:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010778b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010778f:	74 24                	je     c01077b5 <check_vma_struct+0x368>
c0107791:	c7 44 24 0c 0d a5 10 	movl   $0xc010a50d,0xc(%esp)
c0107798:	c0 
c0107799:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01077a0:	c0 
c01077a1:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01077a8:	00 
c01077a9:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01077b0:	e8 20 95 ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01077b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01077b8:	8b 50 04             	mov    0x4(%eax),%edx
c01077bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077be:	39 c2                	cmp    %eax,%edx
c01077c0:	75 10                	jne    c01077d2 <check_vma_struct+0x385>
c01077c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01077c5:	8b 50 08             	mov    0x8(%eax),%edx
c01077c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077cb:	83 c0 02             	add    $0x2,%eax
c01077ce:	39 c2                	cmp    %eax,%edx
c01077d0:	74 24                	je     c01077f6 <check_vma_struct+0x3a9>
c01077d2:	c7 44 24 0c 1c a5 10 	movl   $0xc010a51c,0xc(%esp)
c01077d9:	c0 
c01077da:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01077e1:	c0 
c01077e2:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01077e9:	00 
c01077ea:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01077f1:	e8 df 94 ff ff       	call   c0100cd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01077f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01077f9:	8b 50 04             	mov    0x4(%eax),%edx
c01077fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077ff:	39 c2                	cmp    %eax,%edx
c0107801:	75 10                	jne    c0107813 <check_vma_struct+0x3c6>
c0107803:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107806:	8b 50 08             	mov    0x8(%eax),%edx
c0107809:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010780c:	83 c0 02             	add    $0x2,%eax
c010780f:	39 c2                	cmp    %eax,%edx
c0107811:	74 24                	je     c0107837 <check_vma_struct+0x3ea>
c0107813:	c7 44 24 0c 4c a5 10 	movl   $0xc010a54c,0xc(%esp)
c010781a:	c0 
c010781b:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107822:	c0 
c0107823:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010782a:	00 
c010782b:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107832:	e8 9e 94 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107837:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010783b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010783e:	89 d0                	mov    %edx,%eax
c0107840:	c1 e0 02             	shl    $0x2,%eax
c0107843:	01 d0                	add    %edx,%eax
c0107845:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107848:	0f 8d 20 fe ff ff    	jge    c010766e <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010784e:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107855:	eb 70                	jmp    c01078c7 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107857:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010785a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010785e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107861:	89 04 24             	mov    %eax,(%esp)
c0107864:	e8 7f f8 ff ff       	call   c01070e8 <find_vma>
c0107869:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c010786c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107870:	74 27                	je     c0107899 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107872:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107875:	8b 50 08             	mov    0x8(%eax),%edx
c0107878:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010787b:	8b 40 04             	mov    0x4(%eax),%eax
c010787e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107882:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107886:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107889:	89 44 24 04          	mov    %eax,0x4(%esp)
c010788d:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107894:	e8 b2 8a ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107899:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010789d:	74 24                	je     c01078c3 <check_vma_struct+0x476>
c010789f:	c7 44 24 0c a1 a5 10 	movl   $0xc010a5a1,0xc(%esp)
c01078a6:	c0 
c01078a7:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01078ae:	c0 
c01078af:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01078b6:	00 
c01078b7:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01078be:	e8 12 94 ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01078c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01078c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01078cb:	79 8a                	jns    c0107857 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01078cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078d0:	89 04 24             	mov    %eax,(%esp)
c01078d3:	e8 95 fa ff ff       	call   c010736d <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01078d8:	e8 dd cd ff ff       	call   c01046ba <nr_free_pages>
c01078dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078e0:	74 24                	je     c0107906 <check_vma_struct+0x4b9>
c01078e2:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c01078e9:	c0 
c01078ea:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01078f1:	c0 
c01078f2:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01078f9:	00 
c01078fa:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107901:	e8 cf 93 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107906:	c7 04 24 b8 a5 10 c0 	movl   $0xc010a5b8,(%esp)
c010790d:	e8 39 8a ff ff       	call   c010034b <cprintf>
}
c0107912:	c9                   	leave  
c0107913:	c3                   	ret    

c0107914 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107914:	55                   	push   %ebp
c0107915:	89 e5                	mov    %esp,%ebp
c0107917:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010791a:	e8 9b cd ff ff       	call   c01046ba <nr_free_pages>
c010791f:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107922:	e8 0e f7 ff ff       	call   c0107035 <mm_create>
c0107927:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac
    assert(check_mm_struct != NULL);
c010792c:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107931:	85 c0                	test   %eax,%eax
c0107933:	75 24                	jne    c0107959 <check_pgfault+0x45>
c0107935:	c7 44 24 0c d7 a5 10 	movl   $0xc010a5d7,0xc(%esp)
c010793c:	c0 
c010793d:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107944:	c0 
c0107945:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010794c:	00 
c010794d:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107954:	e8 7c 93 ff ff       	call   c0100cd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107959:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010795e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107961:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0107967:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010796a:	89 50 0c             	mov    %edx,0xc(%eax)
c010796d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107970:	8b 40 0c             	mov    0xc(%eax),%eax
c0107973:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107979:	8b 00                	mov    (%eax),%eax
c010797b:	85 c0                	test   %eax,%eax
c010797d:	74 24                	je     c01079a3 <check_pgfault+0x8f>
c010797f:	c7 44 24 0c ef a5 10 	movl   $0xc010a5ef,0xc(%esp)
c0107986:	c0 
c0107987:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c010798e:	c0 
c010798f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107996:	00 
c0107997:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c010799e:	e8 32 93 ff ff       	call   c0100cd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01079a3:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01079aa:	00 
c01079ab:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01079b2:	00 
c01079b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01079ba:	e8 ee f6 ff ff       	call   c01070ad <vma_create>
c01079bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01079c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01079c6:	75 24                	jne    c01079ec <check_pgfault+0xd8>
c01079c8:	c7 44 24 0c 7e a4 10 	movl   $0xc010a47e,0xc(%esp)
c01079cf:	c0 
c01079d0:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c01079d7:	c0 
c01079d8:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01079df:	00 
c01079e0:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c01079e7:	e8 e9 92 ff ff       	call   c0100cd5 <__panic>

    insert_vma_struct(mm, vma);
c01079ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01079ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079f6:	89 04 24             	mov    %eax,(%esp)
c01079f9:	e8 3f f8 ff ff       	call   c010723d <insert_vma_struct>

    uintptr_t addr = 0x100;
c01079fe:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a0f:	89 04 24             	mov    %eax,(%esp)
c0107a12:	e8 d1 f6 ff ff       	call   c01070e8 <find_vma>
c0107a17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107a1a:	74 24                	je     c0107a40 <check_pgfault+0x12c>
c0107a1c:	c7 44 24 0c fd a5 10 	movl   $0xc010a5fd,0xc(%esp)
c0107a23:	c0 
c0107a24:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107a2b:	c0 
c0107a2c:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107a33:	00 
c0107a34:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107a3b:	e8 95 92 ff ff       	call   c0100cd5 <__panic>

    int i, sum = 0;
c0107a40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a4e:	eb 17                	jmp    c0107a67 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a53:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a56:	01 d0                	add    %edx,%eax
c0107a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a5b:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a60:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107a63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a67:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a6b:	7e e3                	jle    c0107a50 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a74:	eb 15                	jmp    c0107a8b <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a79:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a7c:	01 d0                	add    %edx,%eax
c0107a7e:	0f b6 00             	movzbl (%eax),%eax
c0107a81:	0f be c0             	movsbl %al,%eax
c0107a84:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a8b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a8f:	7e e5                	jle    c0107a76 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a95:	74 24                	je     c0107abb <check_pgfault+0x1a7>
c0107a97:	c7 44 24 0c 17 a6 10 	movl   $0xc010a617,0xc(%esp)
c0107a9e:	c0 
c0107a9f:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107aa6:	c0 
c0107aa7:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107aae:	00 
c0107aaf:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107ab6:	e8 1a 92 ff ff       	call   c0100cd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107abe:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107ac1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ac4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ad0:	89 04 24             	mov    %eax,(%esp)
c0107ad3:	e8 ae d4 ff ff       	call   c0104f86 <page_remove>
    free_page(pa2page(pgdir[0]));
c0107ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107adb:	8b 00                	mov    (%eax),%eax
c0107add:	89 04 24             	mov    %eax,(%esp)
c0107ae0:	e8 0b f5 ff ff       	call   c0106ff0 <pa2page>
c0107ae5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107aec:	00 
c0107aed:	89 04 24             	mov    %eax,(%esp)
c0107af0:	e8 93 cb ff ff       	call   c0104688 <free_pages>
    pgdir[0] = 0;
c0107af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b0b:	89 04 24             	mov    %eax,(%esp)
c0107b0e:	e8 5a f8 ff ff       	call   c010736d <mm_destroy>
    check_mm_struct = NULL;
c0107b13:	c7 05 ac 1b 12 c0 00 	movl   $0x0,0xc0121bac
c0107b1a:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107b1d:	e8 98 cb ff ff       	call   c01046ba <nr_free_pages>
c0107b22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b25:	74 24                	je     c0107b4b <check_pgfault+0x237>
c0107b27:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c0107b2e:	c0 
c0107b2f:	c7 44 24 08 b3 a3 10 	movl   $0xc010a3b3,0x8(%esp)
c0107b36:	c0 
c0107b37:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107b3e:	00 
c0107b3f:	c7 04 24 c8 a3 10 c0 	movl   $0xc010a3c8,(%esp)
c0107b46:	e8 8a 91 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107b4b:	c7 04 24 20 a6 10 c0 	movl   $0xc010a620,(%esp)
c0107b52:	e8 f4 87 ff ff       	call   c010034b <cprintf>
}
c0107b57:	c9                   	leave  
c0107b58:	c3                   	ret    

c0107b59 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107b59:	55                   	push   %ebp
c0107b5a:	89 e5                	mov    %esp,%ebp
c0107b5c:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107b5f:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107b66:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b70:	89 04 24             	mov    %eax,(%esp)
c0107b73:	e8 70 f5 ff ff       	call   c01070e8 <find_vma>
c0107b78:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107b7b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107b80:	83 c0 01             	add    $0x1,%eax
c0107b83:	a3 b8 1a 12 c0       	mov    %eax,0xc0121ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107b88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107b8c:	74 0b                	je     c0107b99 <do_pgfault+0x40>
c0107b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b91:	8b 40 04             	mov    0x4(%eax),%eax
c0107b94:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107b97:	76 18                	jbe    c0107bb1 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107b99:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ba0:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c0107ba7:	e8 9f 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107bac:	e9 ae 01 00 00       	jmp    c0107d5f <do_pgfault+0x206>
    }
    //check the error_code
    switch (error_code & 3) {
c0107bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bb4:	83 e0 03             	and    $0x3,%eax
c0107bb7:	85 c0                	test   %eax,%eax
c0107bb9:	74 36                	je     c0107bf1 <do_pgfault+0x98>
c0107bbb:	83 f8 01             	cmp    $0x1,%eax
c0107bbe:	74 20                	je     c0107be0 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bc3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bc6:	83 e0 02             	and    $0x2,%eax
c0107bc9:	85 c0                	test   %eax,%eax
c0107bcb:	75 11                	jne    c0107bde <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107bcd:	c7 04 24 6c a6 10 c0 	movl   $0xc010a66c,(%esp)
c0107bd4:	e8 72 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107bd9:	e9 81 01 00 00       	jmp    c0107d5f <do_pgfault+0x206>
        }
        break;
c0107bde:	eb 2f                	jmp    c0107c0f <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107be0:	c7 04 24 cc a6 10 c0 	movl   $0xc010a6cc,(%esp)
c0107be7:	e8 5f 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107bec:	e9 6e 01 00 00       	jmp    c0107d5f <do_pgfault+0x206>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bf4:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bf7:	83 e0 05             	and    $0x5,%eax
c0107bfa:	85 c0                	test   %eax,%eax
c0107bfc:	75 11                	jne    c0107c0f <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107bfe:	c7 04 24 04 a7 10 c0 	movl   $0xc010a704,(%esp)
c0107c05:	e8 41 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107c0a:	e9 50 01 00 00       	jmp    c0107d5f <do_pgfault+0x206>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107c0f:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c19:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c1c:	83 e0 02             	and    $0x2,%eax
c0107c1f:	85 c0                	test   %eax,%eax
c0107c21:	74 04                	je     c0107c27 <do_pgfault+0xce>
        perm |= PTE_W;
c0107c23:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107c27:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c35:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107c38:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107c3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
	ptep=get_pte(mm->pgdir, addr, 1);
c0107c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c49:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c4c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107c53:	00 
c0107c54:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c57:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c5b:	89 04 24             	mov    %eax,(%esp)
c0107c5e:	e8 1c d1 ff ff       	call   c0104d7f <get_pte>
c0107c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (ptep==NULL) {
c0107c66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107c6a:	75 11                	jne    c0107c7d <do_pgfault+0x124>
		 cprintf("getpte in do_pgfault failed\n");
c0107c6c:	c7 04 24 67 a7 10 c0 	movl   $0xc010a767,(%esp)
c0107c73:	e8 d3 86 ff ff       	call   c010034b <cprintf>
         goto failed;
c0107c78:	e9 e2 00 00 00       	jmp    c0107d5f <do_pgfault+0x206>
	}
	if (*ptep==0) {
c0107c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c80:	8b 00                	mov    (%eax),%eax
c0107c82:	85 c0                	test   %eax,%eax
c0107c84:	75 35                	jne    c0107cbb <do_pgfault+0x162>
		if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0107c86:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c89:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107c8f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107c93:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c9a:	89 04 24             	mov    %eax,(%esp)
c0107c9d:	e8 3e d4 ff ff       	call   c01050e0 <pgdir_alloc_page>
c0107ca2:	85 c0                	test   %eax,%eax
c0107ca4:	0f 85 ae 00 00 00    	jne    c0107d58 <do_pgfault+0x1ff>
            cprintf("pgdirallocpage in do_pgfault failed\n");
c0107caa:	c7 04 24 84 a7 10 c0 	movl   $0xc010a784,(%esp)
c0107cb1:	e8 95 86 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107cb6:	e9 a4 00 00 00       	jmp    c0107d5f <do_pgfault+0x206>
        }
	} else {
		if(swap_init_ok) {
c0107cbb:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107cc0:	85 c0                	test   %eax,%eax
c0107cc2:	74 7d                	je     c0107d41 <do_pgfault+0x1e8>
            struct Page *page=NULL;
c0107cc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			ret = swap_in(mm,addr,&page);
c0107ccb:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107cce:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107cd2:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cdc:	89 04 24             	mov    %eax,(%esp)
c0107cdf:	e8 c6 e5 ff ff       	call   c01062aa <swap_in>
c0107ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if (ret!=0){
c0107ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ceb:	74 0e                	je     c0107cfb <do_pgfault+0x1a2>
				cprintf("swapin in do_pgfault failed\n");
c0107ced:	c7 04 24 a9 a7 10 c0 	movl   $0xc010a7a9,(%esp)
c0107cf4:	e8 52 86 ff ff       	call   c010034b <cprintf>
c0107cf9:	eb 64                	jmp    c0107d5f <do_pgfault+0x206>
                goto failed;
			}
			page_insert(mm->pgdir, page, addr, perm);
c0107cfb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d01:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107d0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107d0e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107d12:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d16:	89 04 24             	mov    %eax,(%esp)
c0107d19:	e8 ac d2 ff ff       	call   c0104fca <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0107d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d21:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107d28:	00 
c0107d29:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107d2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d37:	89 04 24             	mov    %eax,(%esp)
c0107d3a:	e8 a2 e3 ff ff       	call   c01060e1 <swap_map_swappable>
c0107d3f:	eb 17                	jmp    c0107d58 <do_pgfault+0x1ff>
	} else {
		cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d44:	8b 00                	mov    (%eax),%eax
c0107d46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d4a:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107d51:	e8 f5 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107d56:	eb 07                	jmp    c0107d5f <do_pgfault+0x206>
	}
}
   ret = 0;
c0107d58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107d62:	c9                   	leave  
c0107d63:	c3                   	ret    

c0107d64 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107d64:	55                   	push   %ebp
c0107d65:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107d67:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d6a:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0107d6f:	29 c2                	sub    %eax,%edx
c0107d71:	89 d0                	mov    %edx,%eax
c0107d73:	c1 f8 05             	sar    $0x5,%eax
}
c0107d76:	5d                   	pop    %ebp
c0107d77:	c3                   	ret    

c0107d78 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107d78:	55                   	push   %ebp
c0107d79:	89 e5                	mov    %esp,%ebp
c0107d7b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d81:	89 04 24             	mov    %eax,(%esp)
c0107d84:	e8 db ff ff ff       	call   c0107d64 <page2ppn>
c0107d89:	c1 e0 0c             	shl    $0xc,%eax
}
c0107d8c:	c9                   	leave  
c0107d8d:	c3                   	ret    

c0107d8e <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107d8e:	55                   	push   %ebp
c0107d8f:	89 e5                	mov    %esp,%ebp
c0107d91:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d97:	89 04 24             	mov    %eax,(%esp)
c0107d9a:	e8 d9 ff ff ff       	call   c0107d78 <page2pa>
c0107d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107da5:	c1 e8 0c             	shr    $0xc,%eax
c0107da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107dab:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107db0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107db3:	72 23                	jb     c0107dd8 <page2kva+0x4a>
c0107db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107db8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107dbc:	c7 44 24 08 f0 a7 10 	movl   $0xc010a7f0,0x8(%esp)
c0107dc3:	c0 
c0107dc4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107dcb:	00 
c0107dcc:	c7 04 24 13 a8 10 c0 	movl   $0xc010a813,(%esp)
c0107dd3:	e8 fd 8e ff ff       	call   c0100cd5 <__panic>
c0107dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ddb:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107de0:	c9                   	leave  
c0107de1:	c3                   	ret    

c0107de2 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107de2:	55                   	push   %ebp
c0107de3:	89 e5                	mov    %esp,%ebp
c0107de5:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107de8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107def:	e8 31 9c ff ff       	call   c0101a25 <ide_device_valid>
c0107df4:	85 c0                	test   %eax,%eax
c0107df6:	75 1c                	jne    c0107e14 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107df8:	c7 44 24 08 21 a8 10 	movl   $0xc010a821,0x8(%esp)
c0107dff:	c0 
c0107e00:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107e07:	00 
c0107e08:	c7 04 24 3b a8 10 c0 	movl   $0xc010a83b,(%esp)
c0107e0f:	e8 c1 8e ff ff       	call   c0100cd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107e14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e1b:	e8 44 9c ff ff       	call   c0101a64 <ide_device_size>
c0107e20:	c1 e8 03             	shr    $0x3,%eax
c0107e23:	a3 7c 1b 12 c0       	mov    %eax,0xc0121b7c
}
c0107e28:	c9                   	leave  
c0107e29:	c3                   	ret    

c0107e2a <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107e2a:	55                   	push   %ebp
c0107e2b:	89 e5                	mov    %esp,%ebp
c0107e2d:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107e30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e33:	89 04 24             	mov    %eax,(%esp)
c0107e36:	e8 53 ff ff ff       	call   c0107d8e <page2kva>
c0107e3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e3e:	c1 ea 08             	shr    $0x8,%edx
c0107e41:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e48:	74 0b                	je     c0107e55 <swapfs_read+0x2b>
c0107e4a:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0107e50:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107e53:	72 23                	jb     c0107e78 <swapfs_read+0x4e>
c0107e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e58:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e5c:	c7 44 24 08 4c a8 10 	movl   $0xc010a84c,0x8(%esp)
c0107e63:	c0 
c0107e64:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107e6b:	00 
c0107e6c:	c7 04 24 3b a8 10 c0 	movl   $0xc010a83b,(%esp)
c0107e73:	e8 5d 8e ff ff       	call   c0100cd5 <__panic>
c0107e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e7b:	c1 e2 03             	shl    $0x3,%edx
c0107e7e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107e85:	00 
c0107e86:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e95:	e8 09 9c ff ff       	call   c0101aa3 <ide_read_secs>
}
c0107e9a:	c9                   	leave  
c0107e9b:	c3                   	ret    

c0107e9c <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107e9c:	55                   	push   %ebp
c0107e9d:	89 e5                	mov    %esp,%ebp
c0107e9f:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ea5:	89 04 24             	mov    %eax,(%esp)
c0107ea8:	e8 e1 fe ff ff       	call   c0107d8e <page2kva>
c0107ead:	8b 55 08             	mov    0x8(%ebp),%edx
c0107eb0:	c1 ea 08             	shr    $0x8,%edx
c0107eb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107eba:	74 0b                	je     c0107ec7 <swapfs_write+0x2b>
c0107ebc:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0107ec2:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107ec5:	72 23                	jb     c0107eea <swapfs_write+0x4e>
c0107ec7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ece:	c7 44 24 08 4c a8 10 	movl   $0xc010a84c,0x8(%esp)
c0107ed5:	c0 
c0107ed6:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107edd:	00 
c0107ede:	c7 04 24 3b a8 10 c0 	movl   $0xc010a83b,(%esp)
c0107ee5:	e8 eb 8d ff ff       	call   c0100cd5 <__panic>
c0107eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107eed:	c1 e2 03             	shl    $0x3,%edx
c0107ef0:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107ef7:	00 
c0107ef8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107efc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f07:	e8 d9 9d ff ff       	call   c0101ce5 <ide_write_secs>
}
c0107f0c:	c9                   	leave  
c0107f0d:	c3                   	ret    

c0107f0e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107f0e:	55                   	push   %ebp
c0107f0f:	89 e5                	mov    %esp,%ebp
c0107f11:	83 ec 58             	sub    $0x58,%esp
c0107f14:	8b 45 10             	mov    0x10(%ebp),%eax
c0107f17:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107f1a:	8b 45 14             	mov    0x14(%ebp),%eax
c0107f1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107f20:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107f23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107f26:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f29:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107f2c:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f35:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f38:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f3b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107f48:	74 1c                	je     c0107f66 <printnum+0x58>
c0107f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f4d:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f52:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f55:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f5b:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f60:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f6c:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f72:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f78:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f7e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f84:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107f87:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f8a:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f8f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f92:	77 56                	ja     c0107fea <printnum+0xdc>
c0107f94:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f97:	72 05                	jb     c0107f9e <printnum+0x90>
c0107f99:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107f9c:	77 4c                	ja     c0107fea <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107f9e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107fa1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107fa4:	8b 45 20             	mov    0x20(%ebp),%eax
c0107fa7:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107fab:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107faf:	8b 45 18             	mov    0x18(%ebp),%eax
c0107fb2:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fc0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fce:	89 04 24             	mov    %eax,(%esp)
c0107fd1:	e8 38 ff ff ff       	call   c0107f0e <printnum>
c0107fd6:	eb 1c                	jmp    c0107ff4 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fdf:	8b 45 20             	mov    0x20(%ebp),%eax
c0107fe2:	89 04 24             	mov    %eax,(%esp)
c0107fe5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe8:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0107fea:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0107fee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107ff2:	7f e4                	jg     c0107fd8 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107ff4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ff7:	05 ec a8 10 c0       	add    $0xc010a8ec,%eax
c0107ffc:	0f b6 00             	movzbl (%eax),%eax
c0107fff:	0f be c0             	movsbl %al,%eax
c0108002:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108005:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108009:	89 04 24             	mov    %eax,(%esp)
c010800c:	8b 45 08             	mov    0x8(%ebp),%eax
c010800f:	ff d0                	call   *%eax
}
c0108011:	c9                   	leave  
c0108012:	c3                   	ret    

c0108013 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108013:	55                   	push   %ebp
c0108014:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108016:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010801a:	7e 14                	jle    c0108030 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010801c:	8b 45 08             	mov    0x8(%ebp),%eax
c010801f:	8b 00                	mov    (%eax),%eax
c0108021:	8d 48 08             	lea    0x8(%eax),%ecx
c0108024:	8b 55 08             	mov    0x8(%ebp),%edx
c0108027:	89 0a                	mov    %ecx,(%edx)
c0108029:	8b 50 04             	mov    0x4(%eax),%edx
c010802c:	8b 00                	mov    (%eax),%eax
c010802e:	eb 30                	jmp    c0108060 <getuint+0x4d>
    }
    else if (lflag) {
c0108030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108034:	74 16                	je     c010804c <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108036:	8b 45 08             	mov    0x8(%ebp),%eax
c0108039:	8b 00                	mov    (%eax),%eax
c010803b:	8d 48 04             	lea    0x4(%eax),%ecx
c010803e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108041:	89 0a                	mov    %ecx,(%edx)
c0108043:	8b 00                	mov    (%eax),%eax
c0108045:	ba 00 00 00 00       	mov    $0x0,%edx
c010804a:	eb 14                	jmp    c0108060 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010804c:	8b 45 08             	mov    0x8(%ebp),%eax
c010804f:	8b 00                	mov    (%eax),%eax
c0108051:	8d 48 04             	lea    0x4(%eax),%ecx
c0108054:	8b 55 08             	mov    0x8(%ebp),%edx
c0108057:	89 0a                	mov    %ecx,(%edx)
c0108059:	8b 00                	mov    (%eax),%eax
c010805b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108060:	5d                   	pop    %ebp
c0108061:	c3                   	ret    

c0108062 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108062:	55                   	push   %ebp
c0108063:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108065:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108069:	7e 14                	jle    c010807f <getint+0x1d>
        return va_arg(*ap, long long);
c010806b:	8b 45 08             	mov    0x8(%ebp),%eax
c010806e:	8b 00                	mov    (%eax),%eax
c0108070:	8d 48 08             	lea    0x8(%eax),%ecx
c0108073:	8b 55 08             	mov    0x8(%ebp),%edx
c0108076:	89 0a                	mov    %ecx,(%edx)
c0108078:	8b 50 04             	mov    0x4(%eax),%edx
c010807b:	8b 00                	mov    (%eax),%eax
c010807d:	eb 28                	jmp    c01080a7 <getint+0x45>
    }
    else if (lflag) {
c010807f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108083:	74 12                	je     c0108097 <getint+0x35>
        return va_arg(*ap, long);
c0108085:	8b 45 08             	mov    0x8(%ebp),%eax
c0108088:	8b 00                	mov    (%eax),%eax
c010808a:	8d 48 04             	lea    0x4(%eax),%ecx
c010808d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108090:	89 0a                	mov    %ecx,(%edx)
c0108092:	8b 00                	mov    (%eax),%eax
c0108094:	99                   	cltd   
c0108095:	eb 10                	jmp    c01080a7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108097:	8b 45 08             	mov    0x8(%ebp),%eax
c010809a:	8b 00                	mov    (%eax),%eax
c010809c:	8d 48 04             	lea    0x4(%eax),%ecx
c010809f:	8b 55 08             	mov    0x8(%ebp),%edx
c01080a2:	89 0a                	mov    %ecx,(%edx)
c01080a4:	8b 00                	mov    (%eax),%eax
c01080a6:	99                   	cltd   
    }
}
c01080a7:	5d                   	pop    %ebp
c01080a8:	c3                   	ret    

c01080a9 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01080a9:	55                   	push   %ebp
c01080aa:	89 e5                	mov    %esp,%ebp
c01080ac:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01080af:	8d 45 14             	lea    0x14(%ebp),%eax
c01080b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01080b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01080bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01080bf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01080cd:	89 04 24             	mov    %eax,(%esp)
c01080d0:	e8 02 00 00 00       	call   c01080d7 <vprintfmt>
    va_end(ap);
}
c01080d5:	c9                   	leave  
c01080d6:	c3                   	ret    

c01080d7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01080d7:	55                   	push   %ebp
c01080d8:	89 e5                	mov    %esp,%ebp
c01080da:	56                   	push   %esi
c01080db:	53                   	push   %ebx
c01080dc:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01080df:	eb 18                	jmp    c01080f9 <vprintfmt+0x22>
            if (ch == '\0') {
c01080e1:	85 db                	test   %ebx,%ebx
c01080e3:	75 05                	jne    c01080ea <vprintfmt+0x13>
                return;
c01080e5:	e9 d1 03 00 00       	jmp    c01084bb <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01080ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080f1:	89 1c 24             	mov    %ebx,(%esp)
c01080f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f7:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01080f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01080fc:	8d 50 01             	lea    0x1(%eax),%edx
c01080ff:	89 55 10             	mov    %edx,0x10(%ebp)
c0108102:	0f b6 00             	movzbl (%eax),%eax
c0108105:	0f b6 d8             	movzbl %al,%ebx
c0108108:	83 fb 25             	cmp    $0x25,%ebx
c010810b:	75 d4                	jne    c01080e1 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010810d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108111:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010811b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010811e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108125:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108128:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010812b:	8b 45 10             	mov    0x10(%ebp),%eax
c010812e:	8d 50 01             	lea    0x1(%eax),%edx
c0108131:	89 55 10             	mov    %edx,0x10(%ebp)
c0108134:	0f b6 00             	movzbl (%eax),%eax
c0108137:	0f b6 d8             	movzbl %al,%ebx
c010813a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010813d:	83 f8 55             	cmp    $0x55,%eax
c0108140:	0f 87 44 03 00 00    	ja     c010848a <vprintfmt+0x3b3>
c0108146:	8b 04 85 10 a9 10 c0 	mov    -0x3fef56f0(,%eax,4),%eax
c010814d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010814f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108153:	eb d6                	jmp    c010812b <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108155:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108159:	eb d0                	jmp    c010812b <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010815b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108165:	89 d0                	mov    %edx,%eax
c0108167:	c1 e0 02             	shl    $0x2,%eax
c010816a:	01 d0                	add    %edx,%eax
c010816c:	01 c0                	add    %eax,%eax
c010816e:	01 d8                	add    %ebx,%eax
c0108170:	83 e8 30             	sub    $0x30,%eax
c0108173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108176:	8b 45 10             	mov    0x10(%ebp),%eax
c0108179:	0f b6 00             	movzbl (%eax),%eax
c010817c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010817f:	83 fb 2f             	cmp    $0x2f,%ebx
c0108182:	7e 0b                	jle    c010818f <vprintfmt+0xb8>
c0108184:	83 fb 39             	cmp    $0x39,%ebx
c0108187:	7f 06                	jg     c010818f <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108189:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010818d:	eb d3                	jmp    c0108162 <vprintfmt+0x8b>
            goto process_precision;
c010818f:	eb 33                	jmp    c01081c4 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108191:	8b 45 14             	mov    0x14(%ebp),%eax
c0108194:	8d 50 04             	lea    0x4(%eax),%edx
c0108197:	89 55 14             	mov    %edx,0x14(%ebp)
c010819a:	8b 00                	mov    (%eax),%eax
c010819c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010819f:	eb 23                	jmp    c01081c4 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01081a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01081a5:	79 0c                	jns    c01081b3 <vprintfmt+0xdc>
                width = 0;
c01081a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01081ae:	e9 78 ff ff ff       	jmp    c010812b <vprintfmt+0x54>
c01081b3:	e9 73 ff ff ff       	jmp    c010812b <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01081b8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01081bf:	e9 67 ff ff ff       	jmp    c010812b <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01081c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01081c8:	79 12                	jns    c01081dc <vprintfmt+0x105>
                width = precision, precision = -1;
c01081ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01081d7:	e9 4f ff ff ff       	jmp    c010812b <vprintfmt+0x54>
c01081dc:	e9 4a ff ff ff       	jmp    c010812b <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01081e1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01081e5:	e9 41 ff ff ff       	jmp    c010812b <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01081ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01081ed:	8d 50 04             	lea    0x4(%eax),%edx
c01081f0:	89 55 14             	mov    %edx,0x14(%ebp)
c01081f3:	8b 00                	mov    (%eax),%eax
c01081f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081fc:	89 04 24             	mov    %eax,(%esp)
c01081ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108202:	ff d0                	call   *%eax
            break;
c0108204:	e9 ac 02 00 00       	jmp    c01084b5 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108209:	8b 45 14             	mov    0x14(%ebp),%eax
c010820c:	8d 50 04             	lea    0x4(%eax),%edx
c010820f:	89 55 14             	mov    %edx,0x14(%ebp)
c0108212:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108214:	85 db                	test   %ebx,%ebx
c0108216:	79 02                	jns    c010821a <vprintfmt+0x143>
                err = -err;
c0108218:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010821a:	83 fb 06             	cmp    $0x6,%ebx
c010821d:	7f 0b                	jg     c010822a <vprintfmt+0x153>
c010821f:	8b 34 9d d0 a8 10 c0 	mov    -0x3fef5730(,%ebx,4),%esi
c0108226:	85 f6                	test   %esi,%esi
c0108228:	75 23                	jne    c010824d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010822a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010822e:	c7 44 24 08 fd a8 10 	movl   $0xc010a8fd,0x8(%esp)
c0108235:	c0 
c0108236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108239:	89 44 24 04          	mov    %eax,0x4(%esp)
c010823d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108240:	89 04 24             	mov    %eax,(%esp)
c0108243:	e8 61 fe ff ff       	call   c01080a9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108248:	e9 68 02 00 00       	jmp    c01084b5 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010824d:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108251:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0108258:	c0 
c0108259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010825c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108260:	8b 45 08             	mov    0x8(%ebp),%eax
c0108263:	89 04 24             	mov    %eax,(%esp)
c0108266:	e8 3e fe ff ff       	call   c01080a9 <printfmt>
            }
            break;
c010826b:	e9 45 02 00 00       	jmp    c01084b5 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108270:	8b 45 14             	mov    0x14(%ebp),%eax
c0108273:	8d 50 04             	lea    0x4(%eax),%edx
c0108276:	89 55 14             	mov    %edx,0x14(%ebp)
c0108279:	8b 30                	mov    (%eax),%esi
c010827b:	85 f6                	test   %esi,%esi
c010827d:	75 05                	jne    c0108284 <vprintfmt+0x1ad>
                p = "(null)";
c010827f:	be 09 a9 10 c0       	mov    $0xc010a909,%esi
            }
            if (width > 0 && padc != '-') {
c0108284:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108288:	7e 3e                	jle    c01082c8 <vprintfmt+0x1f1>
c010828a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010828e:	74 38                	je     c01082c8 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108290:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108296:	89 44 24 04          	mov    %eax,0x4(%esp)
c010829a:	89 34 24             	mov    %esi,(%esp)
c010829d:	e8 ed 03 00 00       	call   c010868f <strnlen>
c01082a2:	29 c3                	sub    %eax,%ebx
c01082a4:	89 d8                	mov    %ebx,%eax
c01082a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01082a9:	eb 17                	jmp    c01082c2 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01082ab:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01082af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01082b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082b6:	89 04 24             	mov    %eax,(%esp)
c01082b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082bc:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01082be:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01082c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082c6:	7f e3                	jg     c01082ab <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01082c8:	eb 38                	jmp    c0108302 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01082ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01082ce:	74 1f                	je     c01082ef <vprintfmt+0x218>
c01082d0:	83 fb 1f             	cmp    $0x1f,%ebx
c01082d3:	7e 05                	jle    c01082da <vprintfmt+0x203>
c01082d5:	83 fb 7e             	cmp    $0x7e,%ebx
c01082d8:	7e 15                	jle    c01082ef <vprintfmt+0x218>
                    putch('?', putdat);
c01082da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01082e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01082eb:	ff d0                	call   *%eax
c01082ed:	eb 0f                	jmp    c01082fe <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01082ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082f6:	89 1c 24             	mov    %ebx,(%esp)
c01082f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082fc:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01082fe:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108302:	89 f0                	mov    %esi,%eax
c0108304:	8d 70 01             	lea    0x1(%eax),%esi
c0108307:	0f b6 00             	movzbl (%eax),%eax
c010830a:	0f be d8             	movsbl %al,%ebx
c010830d:	85 db                	test   %ebx,%ebx
c010830f:	74 10                	je     c0108321 <vprintfmt+0x24a>
c0108311:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108315:	78 b3                	js     c01082ca <vprintfmt+0x1f3>
c0108317:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010831b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010831f:	79 a9                	jns    c01082ca <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108321:	eb 17                	jmp    c010833a <vprintfmt+0x263>
                putch(' ', putdat);
c0108323:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108326:	89 44 24 04          	mov    %eax,0x4(%esp)
c010832a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108331:	8b 45 08             	mov    0x8(%ebp),%eax
c0108334:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108336:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010833a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010833e:	7f e3                	jg     c0108323 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0108340:	e9 70 01 00 00       	jmp    c01084b5 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108345:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108348:	89 44 24 04          	mov    %eax,0x4(%esp)
c010834c:	8d 45 14             	lea    0x14(%ebp),%eax
c010834f:	89 04 24             	mov    %eax,(%esp)
c0108352:	e8 0b fd ff ff       	call   c0108062 <getint>
c0108357:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010835a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010835d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108360:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108363:	85 d2                	test   %edx,%edx
c0108365:	79 26                	jns    c010838d <vprintfmt+0x2b6>
                putch('-', putdat);
c0108367:	8b 45 0c             	mov    0xc(%ebp),%eax
c010836a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010836e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0108375:	8b 45 08             	mov    0x8(%ebp),%eax
c0108378:	ff d0                	call   *%eax
                num = -(long long)num;
c010837a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010837d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108380:	f7 d8                	neg    %eax
c0108382:	83 d2 00             	adc    $0x0,%edx
c0108385:	f7 da                	neg    %edx
c0108387:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010838a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010838d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108394:	e9 a8 00 00 00       	jmp    c0108441 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108399:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010839c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083a0:	8d 45 14             	lea    0x14(%ebp),%eax
c01083a3:	89 04 24             	mov    %eax,(%esp)
c01083a6:	e8 68 fc ff ff       	call   c0108013 <getuint>
c01083ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01083b1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01083b8:	e9 84 00 00 00       	jmp    c0108441 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01083bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c4:	8d 45 14             	lea    0x14(%ebp),%eax
c01083c7:	89 04 24             	mov    %eax,(%esp)
c01083ca:	e8 44 fc ff ff       	call   c0108013 <getuint>
c01083cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01083d5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01083dc:	eb 63                	jmp    c0108441 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01083de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083e5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01083ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ef:	ff d0                	call   *%eax
            putch('x', putdat);
c01083f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083f8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01083ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108402:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108404:	8b 45 14             	mov    0x14(%ebp),%eax
c0108407:	8d 50 04             	lea    0x4(%eax),%edx
c010840a:	89 55 14             	mov    %edx,0x14(%ebp)
c010840d:	8b 00                	mov    (%eax),%eax
c010840f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108419:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108420:	eb 1f                	jmp    c0108441 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108422:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108425:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108429:	8d 45 14             	lea    0x14(%ebp),%eax
c010842c:	89 04 24             	mov    %eax,(%esp)
c010842f:	e8 df fb ff ff       	call   c0108013 <getuint>
c0108434:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108437:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010843a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108441:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108445:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108448:	89 54 24 18          	mov    %edx,0x18(%esp)
c010844c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010844f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108453:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108457:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010845a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010845d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108461:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108465:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108468:	89 44 24 04          	mov    %eax,0x4(%esp)
c010846c:	8b 45 08             	mov    0x8(%ebp),%eax
c010846f:	89 04 24             	mov    %eax,(%esp)
c0108472:	e8 97 fa ff ff       	call   c0107f0e <printnum>
            break;
c0108477:	eb 3c                	jmp    c01084b5 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108479:	8b 45 0c             	mov    0xc(%ebp),%eax
c010847c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108480:	89 1c 24             	mov    %ebx,(%esp)
c0108483:	8b 45 08             	mov    0x8(%ebp),%eax
c0108486:	ff d0                	call   *%eax
            break;
c0108488:	eb 2b                	jmp    c01084b5 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010848a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010848d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108491:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108498:	8b 45 08             	mov    0x8(%ebp),%eax
c010849b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010849d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01084a1:	eb 04                	jmp    c01084a7 <vprintfmt+0x3d0>
c01084a3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01084a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01084aa:	83 e8 01             	sub    $0x1,%eax
c01084ad:	0f b6 00             	movzbl (%eax),%eax
c01084b0:	3c 25                	cmp    $0x25,%al
c01084b2:	75 ef                	jne    c01084a3 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01084b4:	90                   	nop
        }
    }
c01084b5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01084b6:	e9 3e fc ff ff       	jmp    c01080f9 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01084bb:	83 c4 40             	add    $0x40,%esp
c01084be:	5b                   	pop    %ebx
c01084bf:	5e                   	pop    %esi
c01084c0:	5d                   	pop    %ebp
c01084c1:	c3                   	ret    

c01084c2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01084c2:	55                   	push   %ebp
c01084c3:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01084c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084c8:	8b 40 08             	mov    0x8(%eax),%eax
c01084cb:	8d 50 01             	lea    0x1(%eax),%edx
c01084ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084d1:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01084d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084d7:	8b 10                	mov    (%eax),%edx
c01084d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084dc:	8b 40 04             	mov    0x4(%eax),%eax
c01084df:	39 c2                	cmp    %eax,%edx
c01084e1:	73 12                	jae    c01084f5 <sprintputch+0x33>
        *b->buf ++ = ch;
c01084e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084e6:	8b 00                	mov    (%eax),%eax
c01084e8:	8d 48 01             	lea    0x1(%eax),%ecx
c01084eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01084ee:	89 0a                	mov    %ecx,(%edx)
c01084f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01084f3:	88 10                	mov    %dl,(%eax)
    }
}
c01084f5:	5d                   	pop    %ebp
c01084f6:	c3                   	ret    

c01084f7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01084f7:	55                   	push   %ebp
c01084f8:	89 e5                	mov    %esp,%ebp
c01084fa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01084fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0108500:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108503:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108506:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010850a:	8b 45 10             	mov    0x10(%ebp),%eax
c010850d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108511:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108514:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108518:	8b 45 08             	mov    0x8(%ebp),%eax
c010851b:	89 04 24             	mov    %eax,(%esp)
c010851e:	e8 08 00 00 00       	call   c010852b <vsnprintf>
c0108523:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108526:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108529:	c9                   	leave  
c010852a:	c3                   	ret    

c010852b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010852b:	55                   	push   %ebp
c010852c:	89 e5                	mov    %esp,%ebp
c010852e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108531:	8b 45 08             	mov    0x8(%ebp),%eax
c0108534:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108537:	8b 45 0c             	mov    0xc(%ebp),%eax
c010853a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010853d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108540:	01 d0                	add    %edx,%eax
c0108542:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108545:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010854c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108550:	74 0a                	je     c010855c <vsnprintf+0x31>
c0108552:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108555:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108558:	39 c2                	cmp    %eax,%edx
c010855a:	76 07                	jbe    c0108563 <vsnprintf+0x38>
        return -E_INVAL;
c010855c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108561:	eb 2a                	jmp    c010858d <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108563:	8b 45 14             	mov    0x14(%ebp),%eax
c0108566:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010856a:	8b 45 10             	mov    0x10(%ebp),%eax
c010856d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108571:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108574:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108578:	c7 04 24 c2 84 10 c0 	movl   $0xc01084c2,(%esp)
c010857f:	e8 53 fb ff ff       	call   c01080d7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0108584:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108587:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010858a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010858d:	c9                   	leave  
c010858e:	c3                   	ret    

c010858f <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010858f:	55                   	push   %ebp
c0108590:	89 e5                	mov    %esp,%ebp
c0108592:	57                   	push   %edi
c0108593:	56                   	push   %esi
c0108594:	53                   	push   %ebx
c0108595:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108598:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c010859d:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01085a3:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01085a9:	6b f0 05             	imul   $0x5,%eax,%esi
c01085ac:	01 f7                	add    %esi,%edi
c01085ae:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c01085b3:	f7 e6                	mul    %esi
c01085b5:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01085b8:	89 f2                	mov    %esi,%edx
c01085ba:	83 c0 0b             	add    $0xb,%eax
c01085bd:	83 d2 00             	adc    $0x0,%edx
c01085c0:	89 c7                	mov    %eax,%edi
c01085c2:	83 e7 ff             	and    $0xffffffff,%edi
c01085c5:	89 f9                	mov    %edi,%ecx
c01085c7:	0f b7 da             	movzwl %dx,%ebx
c01085ca:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c01085d0:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c01085d6:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01085db:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01085e1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01085e5:	c1 ea 0c             	shr    $0xc,%edx
c01085e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01085ee:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01085f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01085fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01085fe:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108601:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108604:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108607:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010860b:	74 1c                	je     c0108629 <rand+0x9a>
c010860d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108610:	ba 00 00 00 00       	mov    $0x0,%edx
c0108615:	f7 75 dc             	divl   -0x24(%ebp)
c0108618:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010861b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010861e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108623:	f7 75 dc             	divl   -0x24(%ebp)
c0108626:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108629:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010862c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010862f:	f7 75 dc             	divl   -0x24(%ebp)
c0108632:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108635:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108638:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010863b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010863e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108641:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108647:	83 c4 24             	add    $0x24,%esp
c010864a:	5b                   	pop    %ebx
c010864b:	5e                   	pop    %esi
c010864c:	5f                   	pop    %edi
c010864d:	5d                   	pop    %ebp
c010864e:	c3                   	ret    

c010864f <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010864f:	55                   	push   %ebp
c0108650:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108652:	8b 45 08             	mov    0x8(%ebp),%eax
c0108655:	ba 00 00 00 00       	mov    $0x0,%edx
c010865a:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c010865f:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c0108665:	5d                   	pop    %ebp
c0108666:	c3                   	ret    

c0108667 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108667:	55                   	push   %ebp
c0108668:	89 e5                	mov    %esp,%ebp
c010866a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010866d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108674:	eb 04                	jmp    c010867a <strlen+0x13>
        cnt ++;
c0108676:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010867a:	8b 45 08             	mov    0x8(%ebp),%eax
c010867d:	8d 50 01             	lea    0x1(%eax),%edx
c0108680:	89 55 08             	mov    %edx,0x8(%ebp)
c0108683:	0f b6 00             	movzbl (%eax),%eax
c0108686:	84 c0                	test   %al,%al
c0108688:	75 ec                	jne    c0108676 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010868a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010868d:	c9                   	leave  
c010868e:	c3                   	ret    

c010868f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010868f:	55                   	push   %ebp
c0108690:	89 e5                	mov    %esp,%ebp
c0108692:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108695:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010869c:	eb 04                	jmp    c01086a2 <strnlen+0x13>
        cnt ++;
c010869e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01086a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01086a8:	73 10                	jae    c01086ba <strnlen+0x2b>
c01086aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ad:	8d 50 01             	lea    0x1(%eax),%edx
c01086b0:	89 55 08             	mov    %edx,0x8(%ebp)
c01086b3:	0f b6 00             	movzbl (%eax),%eax
c01086b6:	84 c0                	test   %al,%al
c01086b8:	75 e4                	jne    c010869e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01086ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01086bd:	c9                   	leave  
c01086be:	c3                   	ret    

c01086bf <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01086bf:	55                   	push   %ebp
c01086c0:	89 e5                	mov    %esp,%ebp
c01086c2:	57                   	push   %edi
c01086c3:	56                   	push   %esi
c01086c4:	83 ec 20             	sub    $0x20,%esp
c01086c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01086d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01086d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086d9:	89 d1                	mov    %edx,%ecx
c01086db:	89 c2                	mov    %eax,%edx
c01086dd:	89 ce                	mov    %ecx,%esi
c01086df:	89 d7                	mov    %edx,%edi
c01086e1:	ac                   	lods   %ds:(%esi),%al
c01086e2:	aa                   	stos   %al,%es:(%edi)
c01086e3:	84 c0                	test   %al,%al
c01086e5:	75 fa                	jne    c01086e1 <strcpy+0x22>
c01086e7:	89 fa                	mov    %edi,%edx
c01086e9:	89 f1                	mov    %esi,%ecx
c01086eb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01086ee:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01086f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01086f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01086f7:	83 c4 20             	add    $0x20,%esp
c01086fa:	5e                   	pop    %esi
c01086fb:	5f                   	pop    %edi
c01086fc:	5d                   	pop    %ebp
c01086fd:	c3                   	ret    

c01086fe <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01086fe:	55                   	push   %ebp
c01086ff:	89 e5                	mov    %esp,%ebp
c0108701:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108704:	8b 45 08             	mov    0x8(%ebp),%eax
c0108707:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010870a:	eb 21                	jmp    c010872d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010870c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010870f:	0f b6 10             	movzbl (%eax),%edx
c0108712:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108715:	88 10                	mov    %dl,(%eax)
c0108717:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010871a:	0f b6 00             	movzbl (%eax),%eax
c010871d:	84 c0                	test   %al,%al
c010871f:	74 04                	je     c0108725 <strncpy+0x27>
            src ++;
c0108721:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108725:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108729:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010872d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108731:	75 d9                	jne    c010870c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108733:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108736:	c9                   	leave  
c0108737:	c3                   	ret    

c0108738 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108738:	55                   	push   %ebp
c0108739:	89 e5                	mov    %esp,%ebp
c010873b:	57                   	push   %edi
c010873c:	56                   	push   %esi
c010873d:	83 ec 20             	sub    $0x20,%esp
c0108740:	8b 45 08             	mov    0x8(%ebp),%eax
c0108743:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108746:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108749:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010874c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010874f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108752:	89 d1                	mov    %edx,%ecx
c0108754:	89 c2                	mov    %eax,%edx
c0108756:	89 ce                	mov    %ecx,%esi
c0108758:	89 d7                	mov    %edx,%edi
c010875a:	ac                   	lods   %ds:(%esi),%al
c010875b:	ae                   	scas   %es:(%edi),%al
c010875c:	75 08                	jne    c0108766 <strcmp+0x2e>
c010875e:	84 c0                	test   %al,%al
c0108760:	75 f8                	jne    c010875a <strcmp+0x22>
c0108762:	31 c0                	xor    %eax,%eax
c0108764:	eb 04                	jmp    c010876a <strcmp+0x32>
c0108766:	19 c0                	sbb    %eax,%eax
c0108768:	0c 01                	or     $0x1,%al
c010876a:	89 fa                	mov    %edi,%edx
c010876c:	89 f1                	mov    %esi,%ecx
c010876e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108771:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108774:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108777:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010877a:	83 c4 20             	add    $0x20,%esp
c010877d:	5e                   	pop    %esi
c010877e:	5f                   	pop    %edi
c010877f:	5d                   	pop    %ebp
c0108780:	c3                   	ret    

c0108781 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108781:	55                   	push   %ebp
c0108782:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108784:	eb 0c                	jmp    c0108792 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108786:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010878a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010878e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108792:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108796:	74 1a                	je     c01087b2 <strncmp+0x31>
c0108798:	8b 45 08             	mov    0x8(%ebp),%eax
c010879b:	0f b6 00             	movzbl (%eax),%eax
c010879e:	84 c0                	test   %al,%al
c01087a0:	74 10                	je     c01087b2 <strncmp+0x31>
c01087a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01087a5:	0f b6 10             	movzbl (%eax),%edx
c01087a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ab:	0f b6 00             	movzbl (%eax),%eax
c01087ae:	38 c2                	cmp    %al,%dl
c01087b0:	74 d4                	je     c0108786 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01087b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01087b6:	74 18                	je     c01087d0 <strncmp+0x4f>
c01087b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01087bb:	0f b6 00             	movzbl (%eax),%eax
c01087be:	0f b6 d0             	movzbl %al,%edx
c01087c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087c4:	0f b6 00             	movzbl (%eax),%eax
c01087c7:	0f b6 c0             	movzbl %al,%eax
c01087ca:	29 c2                	sub    %eax,%edx
c01087cc:	89 d0                	mov    %edx,%eax
c01087ce:	eb 05                	jmp    c01087d5 <strncmp+0x54>
c01087d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01087d5:	5d                   	pop    %ebp
c01087d6:	c3                   	ret    

c01087d7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01087d7:	55                   	push   %ebp
c01087d8:	89 e5                	mov    %esp,%ebp
c01087da:	83 ec 04             	sub    $0x4,%esp
c01087dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087e0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01087e3:	eb 14                	jmp    c01087f9 <strchr+0x22>
        if (*s == c) {
c01087e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e8:	0f b6 00             	movzbl (%eax),%eax
c01087eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01087ee:	75 05                	jne    c01087f5 <strchr+0x1e>
            return (char *)s;
c01087f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f3:	eb 13                	jmp    c0108808 <strchr+0x31>
        }
        s ++;
c01087f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01087f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fc:	0f b6 00             	movzbl (%eax),%eax
c01087ff:	84 c0                	test   %al,%al
c0108801:	75 e2                	jne    c01087e5 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108803:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108808:	c9                   	leave  
c0108809:	c3                   	ret    

c010880a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010880a:	55                   	push   %ebp
c010880b:	89 e5                	mov    %esp,%ebp
c010880d:	83 ec 04             	sub    $0x4,%esp
c0108810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108813:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108816:	eb 11                	jmp    c0108829 <strfind+0x1f>
        if (*s == c) {
c0108818:	8b 45 08             	mov    0x8(%ebp),%eax
c010881b:	0f b6 00             	movzbl (%eax),%eax
c010881e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108821:	75 02                	jne    c0108825 <strfind+0x1b>
            break;
c0108823:	eb 0e                	jmp    c0108833 <strfind+0x29>
        }
        s ++;
c0108825:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108829:	8b 45 08             	mov    0x8(%ebp),%eax
c010882c:	0f b6 00             	movzbl (%eax),%eax
c010882f:	84 c0                	test   %al,%al
c0108831:	75 e5                	jne    c0108818 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0108833:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108836:	c9                   	leave  
c0108837:	c3                   	ret    

c0108838 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108838:	55                   	push   %ebp
c0108839:	89 e5                	mov    %esp,%ebp
c010883b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010883e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010884c:	eb 04                	jmp    c0108852 <strtol+0x1a>
        s ++;
c010884e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108852:	8b 45 08             	mov    0x8(%ebp),%eax
c0108855:	0f b6 00             	movzbl (%eax),%eax
c0108858:	3c 20                	cmp    $0x20,%al
c010885a:	74 f2                	je     c010884e <strtol+0x16>
c010885c:	8b 45 08             	mov    0x8(%ebp),%eax
c010885f:	0f b6 00             	movzbl (%eax),%eax
c0108862:	3c 09                	cmp    $0x9,%al
c0108864:	74 e8                	je     c010884e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0108866:	8b 45 08             	mov    0x8(%ebp),%eax
c0108869:	0f b6 00             	movzbl (%eax),%eax
c010886c:	3c 2b                	cmp    $0x2b,%al
c010886e:	75 06                	jne    c0108876 <strtol+0x3e>
        s ++;
c0108870:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108874:	eb 15                	jmp    c010888b <strtol+0x53>
    }
    else if (*s == '-') {
c0108876:	8b 45 08             	mov    0x8(%ebp),%eax
c0108879:	0f b6 00             	movzbl (%eax),%eax
c010887c:	3c 2d                	cmp    $0x2d,%al
c010887e:	75 0b                	jne    c010888b <strtol+0x53>
        s ++, neg = 1;
c0108880:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108884:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010888b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010888f:	74 06                	je     c0108897 <strtol+0x5f>
c0108891:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108895:	75 24                	jne    c01088bb <strtol+0x83>
c0108897:	8b 45 08             	mov    0x8(%ebp),%eax
c010889a:	0f b6 00             	movzbl (%eax),%eax
c010889d:	3c 30                	cmp    $0x30,%al
c010889f:	75 1a                	jne    c01088bb <strtol+0x83>
c01088a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a4:	83 c0 01             	add    $0x1,%eax
c01088a7:	0f b6 00             	movzbl (%eax),%eax
c01088aa:	3c 78                	cmp    $0x78,%al
c01088ac:	75 0d                	jne    c01088bb <strtol+0x83>
        s += 2, base = 16;
c01088ae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01088b2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01088b9:	eb 2a                	jmp    c01088e5 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01088bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088bf:	75 17                	jne    c01088d8 <strtol+0xa0>
c01088c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088c4:	0f b6 00             	movzbl (%eax),%eax
c01088c7:	3c 30                	cmp    $0x30,%al
c01088c9:	75 0d                	jne    c01088d8 <strtol+0xa0>
        s ++, base = 8;
c01088cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01088d6:	eb 0d                	jmp    c01088e5 <strtol+0xad>
    }
    else if (base == 0) {
c01088d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088dc:	75 07                	jne    c01088e5 <strtol+0xad>
        base = 10;
c01088de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01088e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e8:	0f b6 00             	movzbl (%eax),%eax
c01088eb:	3c 2f                	cmp    $0x2f,%al
c01088ed:	7e 1b                	jle    c010890a <strtol+0xd2>
c01088ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f2:	0f b6 00             	movzbl (%eax),%eax
c01088f5:	3c 39                	cmp    $0x39,%al
c01088f7:	7f 11                	jg     c010890a <strtol+0xd2>
            dig = *s - '0';
c01088f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01088fc:	0f b6 00             	movzbl (%eax),%eax
c01088ff:	0f be c0             	movsbl %al,%eax
c0108902:	83 e8 30             	sub    $0x30,%eax
c0108905:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108908:	eb 48                	jmp    c0108952 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010890a:	8b 45 08             	mov    0x8(%ebp),%eax
c010890d:	0f b6 00             	movzbl (%eax),%eax
c0108910:	3c 60                	cmp    $0x60,%al
c0108912:	7e 1b                	jle    c010892f <strtol+0xf7>
c0108914:	8b 45 08             	mov    0x8(%ebp),%eax
c0108917:	0f b6 00             	movzbl (%eax),%eax
c010891a:	3c 7a                	cmp    $0x7a,%al
c010891c:	7f 11                	jg     c010892f <strtol+0xf7>
            dig = *s - 'a' + 10;
c010891e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108921:	0f b6 00             	movzbl (%eax),%eax
c0108924:	0f be c0             	movsbl %al,%eax
c0108927:	83 e8 57             	sub    $0x57,%eax
c010892a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010892d:	eb 23                	jmp    c0108952 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010892f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108932:	0f b6 00             	movzbl (%eax),%eax
c0108935:	3c 40                	cmp    $0x40,%al
c0108937:	7e 3d                	jle    c0108976 <strtol+0x13e>
c0108939:	8b 45 08             	mov    0x8(%ebp),%eax
c010893c:	0f b6 00             	movzbl (%eax),%eax
c010893f:	3c 5a                	cmp    $0x5a,%al
c0108941:	7f 33                	jg     c0108976 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108943:	8b 45 08             	mov    0x8(%ebp),%eax
c0108946:	0f b6 00             	movzbl (%eax),%eax
c0108949:	0f be c0             	movsbl %al,%eax
c010894c:	83 e8 37             	sub    $0x37,%eax
c010894f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108955:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108958:	7c 02                	jl     c010895c <strtol+0x124>
            break;
c010895a:	eb 1a                	jmp    c0108976 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010895c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108960:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108963:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108967:	89 c2                	mov    %eax,%edx
c0108969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010896c:	01 d0                	add    %edx,%eax
c010896e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108971:	e9 6f ff ff ff       	jmp    c01088e5 <strtol+0xad>

    if (endptr) {
c0108976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010897a:	74 08                	je     c0108984 <strtol+0x14c>
        *endptr = (char *) s;
c010897c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010897f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108982:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108984:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108988:	74 07                	je     c0108991 <strtol+0x159>
c010898a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010898d:	f7 d8                	neg    %eax
c010898f:	eb 03                	jmp    c0108994 <strtol+0x15c>
c0108991:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108994:	c9                   	leave  
c0108995:	c3                   	ret    

c0108996 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108996:	55                   	push   %ebp
c0108997:	89 e5                	mov    %esp,%ebp
c0108999:	57                   	push   %edi
c010899a:	83 ec 24             	sub    $0x24,%esp
c010899d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089a0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01089a3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01089a7:	8b 55 08             	mov    0x8(%ebp),%edx
c01089aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01089ad:	88 45 f7             	mov    %al,-0x9(%ebp)
c01089b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01089b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01089b6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01089b9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01089bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01089c0:	89 d7                	mov    %edx,%edi
c01089c2:	f3 aa                	rep stos %al,%es:(%edi)
c01089c4:	89 fa                	mov    %edi,%edx
c01089c6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01089c9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01089cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01089cf:	83 c4 24             	add    $0x24,%esp
c01089d2:	5f                   	pop    %edi
c01089d3:	5d                   	pop    %ebp
c01089d4:	c3                   	ret    

c01089d5 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01089d5:	55                   	push   %ebp
c01089d6:	89 e5                	mov    %esp,%ebp
c01089d8:	57                   	push   %edi
c01089d9:	56                   	push   %esi
c01089da:	53                   	push   %ebx
c01089db:	83 ec 30             	sub    $0x30,%esp
c01089de:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01089ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01089ed:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01089f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01089f6:	73 42                	jae    c0108a3a <memmove+0x65>
c01089f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01089fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a07:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a0d:	c1 e8 02             	shr    $0x2,%eax
c0108a10:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108a12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108a18:	89 d7                	mov    %edx,%edi
c0108a1a:	89 c6                	mov    %eax,%esi
c0108a1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108a1e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108a21:	83 e1 03             	and    $0x3,%ecx
c0108a24:	74 02                	je     c0108a28 <memmove+0x53>
c0108a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a28:	89 f0                	mov    %esi,%eax
c0108a2a:	89 fa                	mov    %edi,%edx
c0108a2c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108a2f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108a32:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a38:	eb 36                	jmp    c0108a70 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a3d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a43:	01 c2                	add    %eax,%edx
c0108a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a48:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a4e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a54:	89 c1                	mov    %eax,%ecx
c0108a56:	89 d8                	mov    %ebx,%eax
c0108a58:	89 d6                	mov    %edx,%esi
c0108a5a:	89 c7                	mov    %eax,%edi
c0108a5c:	fd                   	std    
c0108a5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a5f:	fc                   	cld    
c0108a60:	89 f8                	mov    %edi,%eax
c0108a62:	89 f2                	mov    %esi,%edx
c0108a64:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108a67:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108a6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108a70:	83 c4 30             	add    $0x30,%esp
c0108a73:	5b                   	pop    %ebx
c0108a74:	5e                   	pop    %esi
c0108a75:	5f                   	pop    %edi
c0108a76:	5d                   	pop    %ebp
c0108a77:	c3                   	ret    

c0108a78 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108a78:	55                   	push   %ebp
c0108a79:	89 e5                	mov    %esp,%ebp
c0108a7b:	57                   	push   %edi
c0108a7c:	56                   	push   %esi
c0108a7d:	83 ec 20             	sub    $0x20,%esp
c0108a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a8c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a95:	c1 e8 02             	shr    $0x2,%eax
c0108a98:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aa0:	89 d7                	mov    %edx,%edi
c0108aa2:	89 c6                	mov    %eax,%esi
c0108aa4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108aa6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108aa9:	83 e1 03             	and    $0x3,%ecx
c0108aac:	74 02                	je     c0108ab0 <memcpy+0x38>
c0108aae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108ab0:	89 f0                	mov    %esi,%eax
c0108ab2:	89 fa                	mov    %edi,%edx
c0108ab4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108ab7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108ac0:	83 c4 20             	add    $0x20,%esp
c0108ac3:	5e                   	pop    %esi
c0108ac4:	5f                   	pop    %edi
c0108ac5:	5d                   	pop    %ebp
c0108ac6:	c3                   	ret    

c0108ac7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108ac7:	55                   	push   %ebp
c0108ac8:	89 e5                	mov    %esp,%ebp
c0108aca:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ad6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108ad9:	eb 30                	jmp    c0108b0b <memcmp+0x44>
        if (*s1 != *s2) {
c0108adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108ade:	0f b6 10             	movzbl (%eax),%edx
c0108ae1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108ae4:	0f b6 00             	movzbl (%eax),%eax
c0108ae7:	38 c2                	cmp    %al,%dl
c0108ae9:	74 18                	je     c0108b03 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108aee:	0f b6 00             	movzbl (%eax),%eax
c0108af1:	0f b6 d0             	movzbl %al,%edx
c0108af4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108af7:	0f b6 00             	movzbl (%eax),%eax
c0108afa:	0f b6 c0             	movzbl %al,%eax
c0108afd:	29 c2                	sub    %eax,%edx
c0108aff:	89 d0                	mov    %edx,%eax
c0108b01:	eb 1a                	jmp    c0108b1d <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108b03:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108b07:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108b0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b0e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b11:	89 55 10             	mov    %edx,0x10(%ebp)
c0108b14:	85 c0                	test   %eax,%eax
c0108b16:	75 c3                	jne    c0108adb <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b1d:	c9                   	leave  
c0108b1e:	c3                   	ret    
