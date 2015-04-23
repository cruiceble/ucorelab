
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 11 9b 00 00       	call   c0109b67 <memset>

    cons_init();                // init the console
c0100056:	e8 88 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 00 9d 10 c0 	movl   $0xc0109d00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 1c 9d 10 c0 	movl   $0xc0109d1c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 de 52 00 00       	call   c0105362 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 38 1f 00 00       	call   c0101fc1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 8a 20 00 00       	call   c0102118 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 67 79 00 00       	call   c01079fa <vmm_init>
    proc_init();                // init process table
c0100093:	e8 c5 8c 00 00       	call   c0108d5d <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 77 16 00 00       	call   c0101714 <ide_init>
    swap_init();                // init swap
c010009d:	e8 47 65 00 00       	call   c01065e9 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 f2 0c 00 00       	call   c0100d99 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 83 1e 00 00       	call   c0101f2f <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 6b 8e 00 00       	call   c0108f1c <cpu_idle>

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
c01000ce:	e8 f8 0b 00 00       	call   c0100ccb <mon_backtrace>
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
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 21 9d 10 c0 	movl   $0xc0109d21,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 2f 9d 10 c0 	movl   $0xc0109d2f,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 3d 9d 10 c0 	movl   $0xc0109d3d,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 4b 9d 10 c0 	movl   $0xc0109d4b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 59 9d 10 c0 	movl   $0xc0109d59,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
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
c010021c:	c7 04 24 68 9d 10 c0 	movl   $0xc0109d68,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 88 9d 10 c0 	movl   $0xc0109d88,(%esp)
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
c010025d:	c7 04 24 a7 9d 10 c0 	movl   $0xc0109da7,(%esp)
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
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
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
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
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
c010030c:	e8 fe 12 00 00       	call   c010160f <cons_putc>
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
c0100349:	e8 5a 8f 00 00       	call   c01092a8 <vprintfmt>
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
c0100385:	e8 85 12 00 00       	call   c010160f <cons_putc>
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
c01003e1:	e8 65 12 00 00       	call   c010164b <cons_getc>
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
c0100553:	c7 00 ac 9d 10 c0    	movl   $0xc0109dac,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 ac 9d 10 c0 	movl   $0xc0109dac,0x8(%eax)
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

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 3c bf 10 c0 	movl   $0xc010bf3c,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 f8 d1 11 c0 	movl   $0xc011d1f8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec f9 d1 11 c0 	movl   $0xc011d1f9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 bd 19 12 c0 	movl   $0xc01219bd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 d8 92 00 00       	call   c01099db <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 b6 9d 10 c0 	movl   $0xc0109db6,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 cf 9d 10 c0 	movl   $0xc0109dcf,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 f0 9c 10 	movl   $0xc0109cf0,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 e7 9d 10 c0 	movl   $0xc0109de7,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 ff 9d 10 c0 	movl   $0xc0109dff,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 17 9e 10 c0 	movl   $0xc0109e17,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 30 9e 10 c0 	movl   $0xc0109e30,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 5a 9e 10 c0 	movl   $0xc0109e5a,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 76 9e 10 c0 	movl   $0xc0109e76,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 88 00 00 00       	jmp    c0100a7e <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 88 9e 10 c0 	movl   $0xc0109e88,(%esp)
c0100a0b:	e8 43 f9 ff ff       	call   c0100353 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 08             	add    $0x8,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 a4 9e 10 c0 	movl   $0xc0109ea4,(%esp)
c0100a3e:	e8 10 f9 ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a4d:	c7 04 24 ac 9e 10 c0 	movl   $0xc0109eac,(%esp)
c0100a54:	e8 fa f8 ff ff       	call   c0100353 <cprintf>
        print_debuginfo(eip - 1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b6 fe ff ff       	call   c010091d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a82:	74 0a                	je     c0100a8e <print_stackframe+0xbd>
c0100a84:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a88:	0f 8e 68 ff ff ff    	jle    c01009f6 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a8e:	c9                   	leave  
c0100a8f:	c3                   	ret    

c0100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a90:	55                   	push   %ebp
c0100a91:	89 e5                	mov    %esp,%ebp
c0100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	eb 0c                	jmp    c0100aab <parse+0x1b>
            *buf ++ = '\0';
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa8:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aae:	0f b6 00             	movzbl (%eax),%eax
c0100ab1:	84 c0                	test   %al,%al
c0100ab3:	74 1d                	je     c0100ad2 <parse+0x42>
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	0f be c0             	movsbl %al,%eax
c0100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac2:	c7 04 24 30 9f 10 c0 	movl   $0xc0109f30,(%esp)
c0100ac9:	e8 da 8e 00 00       	call   c01099a8 <strchr>
c0100ace:	85 c0                	test   %eax,%eax
c0100ad0:	75 cd                	jne    c0100a9f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad5:	0f b6 00             	movzbl (%eax),%eax
c0100ad8:	84 c0                	test   %al,%al
c0100ada:	75 02                	jne    c0100ade <parse+0x4e>
            break;
c0100adc:	eb 67                	jmp    c0100b45 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 35 9f 10 c0 	movl   $0xc0109f35,(%esp)
c0100af3:	e8 5b f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	eb 04                	jmp    c0100b18 <parse+0x88>
            buf ++;
c0100b14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1b:	0f b6 00             	movzbl (%eax),%eax
c0100b1e:	84 c0                	test   %al,%al
c0100b20:	74 1d                	je     c0100b3f <parse+0xaf>
c0100b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b25:	0f b6 00             	movzbl (%eax),%eax
c0100b28:	0f be c0             	movsbl %al,%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 30 9f 10 c0 	movl   $0xc0109f30,(%esp)
c0100b36:	e8 6d 8e 00 00       	call   c01099a8 <strchr>
c0100b3b:	85 c0                	test   %eax,%eax
c0100b3d:	74 d5                	je     c0100b14 <parse+0x84>
            buf ++;
        }
    }
c0100b3f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b40:	e9 66 ff ff ff       	jmp    c0100aab <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b48:	c9                   	leave  
c0100b49:	c3                   	ret    

c0100b4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4a:	55                   	push   %ebp
c0100b4b:	89 e5                	mov    %esp,%ebp
c0100b4d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b50:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5a:	89 04 24             	mov    %eax,(%esp)
c0100b5d:	e8 2e ff ff ff       	call   c0100a90 <parse>
c0100b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b69:	75 0a                	jne    c0100b75 <runcmd+0x2b>
        return 0;
c0100b6b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b70:	e9 85 00 00 00       	jmp    c0100bfa <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7c:	eb 5c                	jmp    c0100bda <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b84:	89 d0                	mov    %edx,%eax
c0100b86:	01 c0                	add    %eax,%eax
c0100b88:	01 d0                	add    %edx,%eax
c0100b8a:	c1 e0 02             	shl    $0x2,%eax
c0100b8d:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b92:	8b 00                	mov    (%eax),%eax
c0100b94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b98:	89 04 24             	mov    %eax,(%esp)
c0100b9b:	e8 69 8d 00 00       	call   c0109909 <strcmp>
c0100ba0:	85 c0                	test   %eax,%eax
c0100ba2:	75 32                	jne    c0100bd6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba7:	89 d0                	mov    %edx,%eax
c0100ba9:	01 c0                	add    %eax,%eax
c0100bab:	01 d0                	add    %edx,%eax
c0100bad:	c1 e0 02             	shl    $0x2,%eax
c0100bb0:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bb5:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbb:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc8:	83 c2 04             	add    $0x4,%edx
c0100bcb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bcf:	89 0c 24             	mov    %ecx,(%esp)
c0100bd2:	ff d0                	call   *%eax
c0100bd4:	eb 24                	jmp    c0100bfa <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdd:	83 f8 02             	cmp    $0x2,%eax
c0100be0:	76 9c                	jbe    c0100b7e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be9:	c7 04 24 53 9f 10 c0 	movl   $0xc0109f53,(%esp)
c0100bf0:	e8 5e f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfa:	c9                   	leave  
c0100bfb:	c3                   	ret    

c0100bfc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfc:	55                   	push   %ebp
c0100bfd:	89 e5                	mov    %esp,%ebp
c0100bff:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c02:	c7 04 24 6c 9f 10 c0 	movl   $0xc0109f6c,(%esp)
c0100c09:	e8 45 f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0e:	c7 04 24 94 9f 10 c0 	movl   $0xc0109f94,(%esp)
c0100c15:	e8 39 f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1e:	74 0b                	je     c0100c2b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	89 04 24             	mov    %eax,(%esp)
c0100c26:	e8 26 16 00 00       	call   c0102251 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2b:	c7 04 24 b9 9f 10 c0 	movl   $0xc0109fb9,(%esp)
c0100c32:	e8 13 f6 ff ff       	call   c010024a <readline>
c0100c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3e:	74 18                	je     c0100c58 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 04 24             	mov    %eax,(%esp)
c0100c4d:	e8 f8 fe ff ff       	call   c0100b4a <runcmd>
c0100c52:	85 c0                	test   %eax,%eax
c0100c54:	79 02                	jns    c0100c58 <kmonitor+0x5c>
                break;
c0100c56:	eb 02                	jmp    c0100c5a <kmonitor+0x5e>
            }
        }
    }
c0100c58:	eb d1                	jmp    c0100c2b <kmonitor+0x2f>
}
c0100c5a:	c9                   	leave  
c0100c5b:	c3                   	ret    

c0100c5c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5c:	55                   	push   %ebp
c0100c5d:	89 e5                	mov    %esp,%ebp
c0100c5f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c69:	eb 3f                	jmp    c0100caa <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c7c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c82:	89 d0                	mov    %edx,%eax
c0100c84:	01 c0                	add    %eax,%eax
c0100c86:	01 d0                	add    %edx,%eax
c0100c88:	c1 e0 02             	shl    $0x2,%eax
c0100c8b:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c90:	8b 00                	mov    (%eax),%eax
c0100c92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9a:	c7 04 24 bd 9f 10 c0 	movl   $0xc0109fbd,(%esp)
c0100ca1:	e8 ad f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cad:	83 f8 02             	cmp    $0x2,%eax
c0100cb0:	76 b9                	jbe    c0100c6b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbf:	e8 c3 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd1:	e8 fb fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdb:	c9                   	leave  
c0100cdc:	c3                   	ret    

c0100cdd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce3:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce8:	85 c0                	test   %eax,%eax
c0100cea:	74 02                	je     c0100cee <__panic+0x11>
        goto panic_dead;
c0100cec:	eb 48                	jmp    c0100d36 <__panic+0x59>
    }
    is_panic = 1;
c0100cee:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cf5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d01:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0c:	c7 04 24 c6 9f 10 c0 	movl   $0xc0109fc6,(%esp)
c0100d13:	e8 3b f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d22:	89 04 24             	mov    %eax,(%esp)
c0100d25:	e8 f6 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d2a:	c7 04 24 e2 9f 10 c0 	movl   $0xc0109fe2,(%esp)
c0100d31:	e8 1d f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d36:	e8 fa 11 00 00       	call   c0101f35 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d42:	e8 b5 fe ff ff       	call   c0100bfc <kmonitor>
    }
c0100d47:	eb f2                	jmp    c0100d3b <__panic+0x5e>

c0100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d49:	55                   	push   %ebp
c0100d4a:	89 e5                	mov    %esp,%ebp
c0100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d63:	c7 04 24 e4 9f 10 c0 	movl   $0xc0109fe4,(%esp)
c0100d6a:	e8 e4 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 9f f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 e2 9f 10 c0 	movl   $0xc0109fe2,(%esp)
c0100d88:	e8 c6 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d92:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d97:	5d                   	pop    %ebp
c0100d98:	c3                   	ret    

c0100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
c0100d9c:	83 ec 28             	sub    $0x28,%esp
c0100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db1:	ee                   	out    %al,(%dx)
c0100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd8:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de2:	c7 04 24 02 a0 10 c0 	movl   $0xc010a002,(%esp)
c0100de9:	e8 65 f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df5:	e8 99 11 00 00       	call   c0101f93 <pic_enable>
}
c0100dfa:	c9                   	leave  
c0100dfb:	c3                   	ret    

c0100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfc:	55                   	push   %ebp
c0100dfd:	89 e5                	mov    %esp,%ebp
c0100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e02:	9c                   	pushf  
c0100e03:	58                   	pop    %eax
c0100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0a:	25 00 02 00 00       	and    $0x200,%eax
c0100e0f:	85 c0                	test   %eax,%eax
c0100e11:	74 0c                	je     c0100e1f <__intr_save+0x23>
        intr_disable();
c0100e13:	e8 1d 11 00 00       	call   c0101f35 <intr_disable>
        return 1;
c0100e18:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1d:	eb 05                	jmp    c0100e24 <__intr_save+0x28>
    }
    return 0;
c0100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e24:	c9                   	leave  
c0100e25:	c3                   	ret    

c0100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e26:	55                   	push   %ebp
c0100e27:	89 e5                	mov    %esp,%ebp
c0100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e30:	74 05                	je     c0100e37 <__intr_restore+0x11>
        intr_enable();
c0100e32:	e8 f8 10 00 00       	call   c0101f2f <intr_enable>
    }
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 10             	sub    $0x10,%esp
c0100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
c0100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea3:	0f b7 00             	movzwl (%eax),%eax
c0100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eaa:	74 12                	je     c0100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb3:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eba:	b4 03 
c0100ebc:	eb 13                	jmp    c0100ed1 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec8:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed1:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed8:	0f b7 c0             	movzwl %ax,%eax
c0100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eec:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef3:	83 c0 01             	add    $0x1,%eax
c0100ef6:	0f b7 c0             	movzwl %ax,%eax
c0100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f01:	89 c2                	mov    %eax,%edx
c0100f03:	ec                   	in     (%dx),%al
c0100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0b:	0f b6 c0             	movzbl %al,%eax
c0100f0e:	c1 e0 08             	shl    $0x8,%eax
c0100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f14:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f1b:	0f b7 c0             	movzwl %ax,%eax
c0100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f36:	83 c0 01             	add    $0x1,%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f44:	89 c2                	mov    %eax,%edx
c0100f46:	ec                   	in     (%dx),%al
c0100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4e:	0f b6 c0             	movzbl %al,%eax
c0100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f57:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5f:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f65:	c9                   	leave  
c0100f66:	c3                   	ret    

c0100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f67:	55                   	push   %ebp
c0100f68:	89 e5                	mov    %esp,%ebp
c0100f6a:	83 ec 48             	sub    $0x48,%esp
c0100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
c0100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffc:	89 c2                	mov    %eax,%edx
c0100ffe:	ec                   	in     (%dx),%al
c0100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101006:	3c ff                	cmp    $0xff,%al
c0101008:	0f 95 c0             	setne  %al
c010100b:	0f b6 c0             	movzbl %al,%eax
c010100e:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c0101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102d:	89 c2                	mov    %eax,%edx
c010102f:	ec                   	in     (%dx),%al
c0101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101033:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101038:	85 c0                	test   %eax,%eax
c010103a:	74 0c                	je     c0101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101043:	e8 4b 0f 00 00       	call   c0101f93 <pic_enable>
    }
}
c0101048:	c9                   	leave  
c0101049:	c3                   	ret    

c010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104a:	55                   	push   %ebp
c010104b:	89 e5                	mov    %esp,%ebp
c010104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101057:	eb 09                	jmp    c0101062 <lpt_putc_sub+0x18>
        delay();
c0101059:	e8 db fd ff ff       	call   c0100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106c:	89 c2                	mov    %eax,%edx
c010106e:	ec                   	in     (%dx),%al
c010106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101076:	84 c0                	test   %al,%al
c0101078:	78 09                	js     c0101083 <lpt_putc_sub+0x39>
c010107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101081:	7e d6                	jle    c0101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101083:	8b 45 08             	mov    0x8(%ebp),%eax
c0101086:	0f b6 c0             	movzbl %al,%eax
c0101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109a:	ee                   	out    %al,(%dx)
c010109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c1:	c9                   	leave  
c01010c2:	c3                   	ret    

c01010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cd:	74 0d                	je     c01010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d2:	89 04 24             	mov    %eax,(%esp)
c01010d5:	e8 70 ff ff ff       	call   c010104a <lpt_putc_sub>
c01010da:	eb 24                	jmp    c0101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 62 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ef:	e8 56 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fb:	e8 4a ff ff ff       	call   c010104a <lpt_putc_sub>
    }
}
c0101100:	c9                   	leave  
c0101101:	c3                   	ret    

c0101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	53                   	push   %ebx
c0101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	b0 00                	mov    $0x0,%al
c010110e:	85 c0                	test   %eax,%eax
c0101110:	75 07                	jne    c0101119 <cga_putc+0x17>
        c |= 0x0700;
c0101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	0f b6 c0             	movzbl %al,%eax
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 4c                	je     c0101170 <cga_putc+0x6e>
c0101124:	83 f8 0d             	cmp    $0xd,%eax
c0101127:	74 57                	je     c0101180 <cga_putc+0x7e>
c0101129:	83 f8 08             	cmp    $0x8,%eax
c010112c:	0f 85 88 00 00 00    	jne    c01011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101132:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101139:	66 85 c0             	test   %ax,%ax
c010113c:	74 30                	je     c010116e <cga_putc+0x6c>
            crt_pos --;
c010113e:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101145:	83 e8 01             	sub    $0x1,%eax
c0101148:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114e:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101153:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c010115a:	0f b7 d2             	movzwl %dx,%edx
c010115d:	01 d2                	add    %edx,%edx
c010115f:	01 c2                	add    %eax,%edx
c0101161:	8b 45 08             	mov    0x8(%ebp),%eax
c0101164:	b0 00                	mov    $0x0,%al
c0101166:	83 c8 20             	or     $0x20,%eax
c0101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116c:	eb 72                	jmp    c01011e0 <cga_putc+0xde>
c010116e:	eb 70                	jmp    c01011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101180:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101187:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c010118e:	0f b7 c1             	movzwl %cx,%eax
c0101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101197:	c1 e8 10             	shr    $0x10,%eax
c010119a:	89 c2                	mov    %eax,%edx
c010119c:	66 c1 ea 06          	shr    $0x6,%dx
c01011a0:	89 d0                	mov    %edx,%eax
c01011a2:	c1 e0 02             	shl    $0x2,%eax
c01011a5:	01 d0                	add    %edx,%eax
c01011a7:	c1 e0 04             	shl    $0x4,%eax
c01011aa:	29 c1                	sub    %eax,%ecx
c01011ac:	89 ca                	mov    %ecx,%edx
c01011ae:	89 d8                	mov    %ebx,%eax
c01011b0:	29 d0                	sub    %edx,%eax
c01011b2:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b8:	eb 26                	jmp    c01011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ba:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011c0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ca:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011d1:	0f b7 c0             	movzwl %ax,%eax
c01011d4:	01 c0                	add    %eax,%eax
c01011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011dc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011eb:	76 5b                	jbe    c0101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ed:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f8:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101204:	00 
c0101205:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101209:	89 04 24             	mov    %eax,(%esp)
c010120c:	e8 95 89 00 00       	call   c0109ba6 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101218:	eb 15                	jmp    c010122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121a:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101222:	01 d2                	add    %edx,%edx
c0101224:	01 d0                	add    %edx,%eax
c0101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101236:	7e e2                	jle    c010121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101238:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010123f:	83 e8 50             	sub    $0x50,%eax
c0101242:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101248:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101263:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010126a:	66 c1 e8 08          	shr    $0x8,%ax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101282:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101295:	0f b7 c0             	movzwl %ax,%eax
c0101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a9:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012b0:	0f b6 c0             	movzbl %al,%eax
c01012b3:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012ba:	83 c2 01             	add    $0x1,%edx
c01012bd:	0f b7 d2             	movzwl %dx,%edx
c01012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
}
c01012d0:	83 c4 34             	add    $0x34,%esp
c01012d3:	5b                   	pop    %ebx
c01012d4:	5d                   	pop    %ebp
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 4f fb ff ff       	call   c0100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	c9                   	leave  
c010132e:	c3                   	ret    

c010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132f:	55                   	push   %ebp
c0101330:	89 e5                	mov    %esp,%ebp
c0101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101339:	74 0d                	je     c0101348 <serial_putc+0x19>
        serial_putc_sub(c);
c010133b:	8b 45 08             	mov    0x8(%ebp),%eax
c010133e:	89 04 24             	mov    %eax,(%esp)
c0101341:	e8 90 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101346:	eb 24                	jmp    c010136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 82 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135b:	e8 76 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101367:	e8 6a ff ff ff       	call   c01012d6 <serial_putc_sub>
    }
}
c010136c:	c9                   	leave  
c010136d:	c3                   	ret    

c010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136e:	55                   	push   %ebp
c010136f:	89 e5                	mov    %esp,%ebp
c0101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101374:	eb 33                	jmp    c01013a9 <cons_intr+0x3b>
        if (c != 0) {
c0101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137a:	74 2d                	je     c01013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137c:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101381:	8d 50 01             	lea    0x1(%eax),%edx
c0101384:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c010138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138d:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101393:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101398:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139d:	75 0a                	jne    c01013a9 <cons_intr+0x3b>
                cons.wpos = 0;
c010139f:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	ff d0                	call   *%eax
c01013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b5:	75 bf                	jne    c0101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b7:	c9                   	leave  
c01013b8:	c3                   	ret    

c01013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b9:	55                   	push   %ebp
c01013ba:	89 e5                	mov    %esp,%ebp
c01013bc:	83 ec 10             	sub    $0x10,%esp
c01013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c9:	89 c2                	mov    %eax,%edx
c01013cb:	ec                   	in     (%dx),%al
c01013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d3:	0f b6 c0             	movzbl %al,%eax
c01013d6:	83 e0 01             	and    $0x1,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	75 07                	jne    c01013e4 <serial_proc_data+0x2b>
        return -1;
c01013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e2:	eb 2a                	jmp    c010140e <serial_proc_data+0x55>
c01013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	ec                   	in     (%dx),%al
c01013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f8:	0f b6 c0             	movzbl %al,%eax
c01013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x52>
        c = '\b';
c0101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101416:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	74 0c                	je     c010142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141f:	c7 04 24 b9 13 10 c0 	movl   $0xc01013b9,(%esp)
c0101426:	e8 43 ff ff ff       	call   c010136e <cons_intr>
    }
}
c010142b:	c9                   	leave  
c010142c:	c3                   	ret    

c010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142d:	55                   	push   %ebp
c010142e:	89 e5                	mov    %esp,%ebp
c0101430:	83 ec 38             	sub    $0x38,%esp
c0101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143d:	89 c2                	mov    %eax,%edx
c010143f:	ec                   	in     (%dx),%al
c0101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101447:	0f b6 c0             	movzbl %al,%eax
c010144a:	83 e0 01             	and    $0x1,%eax
c010144d:	85 c0                	test   %eax,%eax
c010144f:	75 0a                	jne    c010145b <kbd_proc_data+0x2e>
        return -1;
c0101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101456:	e9 59 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
c010145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101476:	75 17                	jne    c010148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101478:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010147d:	83 c8 40             	or     $0x40,%eax
c0101480:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c0101485:	b8 00 00 00 00       	mov    $0x0,%eax
c010148a:	e9 25 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	84 c0                	test   %al,%al
c0101495:	79 47                	jns    c01014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101497:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010149c:	83 e0 40             	and    $0x40,%eax
c010149f:	85 c0                	test   %eax,%eax
c01014a1:	75 09                	jne    c01014ac <kbd_proc_data+0x7f>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	83 e0 7f             	and    $0x7f,%eax
c01014aa:	eb 04                	jmp    c01014b0 <kbd_proc_data+0x83>
c01014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b7:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014be:	83 c8 40             	or     $0x40,%eax
c01014c1:	0f b6 c0             	movzbl %al,%eax
c01014c4:	f7 d0                	not    %eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014cd:	21 d0                	and    %edx,%eax
c01014cf:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d9:	e9 d6 00 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014de:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e3:	83 e0 40             	and    $0x40,%eax
c01014e6:	85 c0                	test   %eax,%eax
c01014e8:	74 11                	je     c01014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ee:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014f3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f6:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101506:	0f b6 d0             	movzbl %al,%edx
c0101509:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150e:	09 d0                	or     %edx,%eax
c0101510:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c0101520:	0f b6 d0             	movzbl %al,%edx
c0101523:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101528:	31 d0                	xor    %edx,%eax
c010152a:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010152f:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101534:	83 e0 03             	and    $0x3,%eax
c0101537:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c010153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101542:	01 d0                	add    %edx,%eax
c0101544:	0f b6 00             	movzbl (%eax),%eax
c0101547:	0f b6 c0             	movzbl %al,%eax
c010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154d:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101552:	83 e0 08             	and    $0x8,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 22                	je     c010157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155d:	7e 0c                	jle    c010156b <kbd_proc_data+0x13e>
c010155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101563:	7f 06                	jg     c010156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101569:	eb 10                	jmp    c010157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156f:	7e 0a                	jle    c010157b <kbd_proc_data+0x14e>
c0101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101575:	7f 04                	jg     c010157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157b:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	83 e0 06             	and    $0x6,%eax
c0101585:	85 c0                	test   %eax,%eax
c0101587:	75 28                	jne    c01015b1 <kbd_proc_data+0x184>
c0101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101590:	75 1f                	jne    c01015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101592:	c7 04 24 1d a0 10 c0 	movl   $0xc010a01d,(%esp)
c0101599:	e8 b5 ed ff ff       	call   c0100353 <cprintf>
c010159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bc:	c7 04 24 2d 14 10 c0 	movl   $0xc010142d,(%esp)
c01015c3:	e8 a6 fd ff ff       	call   c010136e <cons_intr>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_init>:

static void
kbd_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d0:	e8 e1 ff ff ff       	call   c01015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015dc:	e8 b2 09 00 00       	call   c0101f93 <pic_enable>
}
c01015e1:	c9                   	leave  
c01015e2:	c3                   	ret    

c01015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e3:	55                   	push   %ebp
c01015e4:	89 e5                	mov    %esp,%ebp
c01015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e9:	e8 93 f8 ff ff       	call   c0100e81 <cga_init>
    serial_init();
c01015ee:	e8 74 f9 ff ff       	call   c0100f67 <serial_init>
    kbd_init();
c01015f3:	e8 d2 ff ff ff       	call   c01015ca <kbd_init>
    if (!serial_exists) {
c01015f8:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 0c                	jne    c010160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101601:	c7 04 24 29 a0 10 c0 	movl   $0xc010a029,(%esp)
c0101608:	e8 46 ed ff ff       	call   c0100353 <cprintf>
    }
}
c010160d:	c9                   	leave  
c010160e:	c3                   	ret    

c010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160f:	55                   	push   %ebp
c0101610:	89 e5                	mov    %esp,%ebp
c0101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101615:	e8 e2 f7 ff ff       	call   c0100dfc <__intr_save>
c010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101620:	89 04 24             	mov    %eax,(%esp)
c0101623:	e8 9b fa ff ff       	call   c01010c3 <lpt_putc>
        cga_putc(c);
c0101628:	8b 45 08             	mov    0x8(%ebp),%eax
c010162b:	89 04 24             	mov    %eax,(%esp)
c010162e:	e8 cf fa ff ff       	call   c0101102 <cga_putc>
        serial_putc(c);
c0101633:	8b 45 08             	mov    0x8(%ebp),%eax
c0101636:	89 04 24             	mov    %eax,(%esp)
c0101639:	e8 f1 fc ff ff       	call   c010132f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 dd f7 ff ff       	call   c0100e26 <__intr_restore>
}
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 9f f7 ff ff       	call   c0100dfc <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 ab fd ff ff       	call   c0101410 <serial_intr>
        kbd_intr();
c0101665:	e8 4c ff ff ff       	call   c01015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0101670:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101687:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ad:	89 04 24             	mov    %eax,(%esp)
c01016b0:	e8 71 f7 ff ff       	call   c0100e26 <__intr_restore>
    return c;
c01016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b8:	c9                   	leave  
c01016b9:	c3                   	ret    

c01016ba <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c7:	90                   	nop
c01016c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cc:	83 c0 07             	add    $0x7,%eax
c01016cf:	0f b7 c0             	movzwl %ax,%eax
c01016d2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016da:	89 c2                	mov    %eax,%edx
c01016dc:	ec                   	in     (%dx),%al
c01016dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ed:	25 80 00 00 00       	and    $0x80,%eax
c01016f2:	85 c0                	test   %eax,%eax
c01016f4:	75 d2                	jne    c01016c8 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016fa:	74 11                	je     c010170d <ide_wait_ready+0x53>
c01016fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ff:	83 e0 21             	and    $0x21,%eax
c0101702:	85 c0                	test   %eax,%eax
c0101704:	74 07                	je     c010170d <ide_wait_ready+0x53>
        return -1;
c0101706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170b:	eb 05                	jmp    c0101712 <ide_wait_ready+0x58>
    }
    return 0;
c010170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101712:	c9                   	leave  
c0101713:	c3                   	ret    

c0101714 <ide_init>:

void
ide_init(void) {
c0101714:	55                   	push   %ebp
c0101715:	89 e5                	mov    %esp,%ebp
c0101717:	57                   	push   %edi
c0101718:	53                   	push   %ebx
c0101719:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171f:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101725:	e9 d6 02 00 00       	jmp    c0101a00 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010172a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172e:	c1 e0 03             	shl    $0x3,%eax
c0101731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101738:	29 c2                	sub    %eax,%edx
c010173a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101740:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101743:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101747:	66 d1 e8             	shr    %ax
c010174a:	0f b7 c0             	movzwl %ax,%eax
c010174d:	0f b7 04 85 48 a0 10 	movzwl -0x3fef5fb8(,%eax,4),%eax
c0101754:	c0 
c0101755:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101759:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101764:	00 
c0101765:	89 04 24             	mov    %eax,(%esp)
c0101768:	e8 4d ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101771:	83 e0 01             	and    $0x1,%eax
c0101774:	c1 e0 04             	shl    $0x4,%eax
c0101777:	83 c8 e0             	or     $0xffffffe0,%eax
c010177a:	0f b6 c0             	movzbl %al,%eax
c010177d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101781:	83 c2 06             	add    $0x6,%edx
c0101784:	0f b7 d2             	movzwl %dx,%edx
c0101787:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178b:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101792:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101797:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a2:	00 
c01017a3:	89 04 24             	mov    %eax,(%esp)
c01017a6:	e8 0f ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017ab:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017af:	83 c0 07             	add    $0x7,%eax
c01017b2:	0f b7 c0             	movzwl %ax,%eax
c01017b5:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b9:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d1:	00 
c01017d2:	89 04 24             	mov    %eax,(%esp)
c01017d5:	e8 e0 fe ff ff       	call   c01016ba <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017da:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017de:	83 c0 07             	add    $0x7,%eax
c01017e1:	0f b7 c0             	movzwl %ax,%eax
c01017e4:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e8:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017ec:	89 c2                	mov    %eax,%edx
c01017ee:	ec                   	in     (%dx),%al
c01017ef:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f6:	84 c0                	test   %al,%al
c01017f8:	0f 84 f7 01 00 00    	je     c01019f5 <ide_init+0x2e1>
c01017fe:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101809:	00 
c010180a:	89 04 24             	mov    %eax,(%esp)
c010180d:	e8 a8 fe ff ff       	call   c01016ba <ide_wait_ready>
c0101812:	85 c0                	test   %eax,%eax
c0101814:	0f 85 db 01 00 00    	jne    c01019f5 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010181a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181e:	c1 e0 03             	shl    $0x3,%eax
c0101821:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101828:	29 c2                	sub    %eax,%edx
c010182a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101830:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101833:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101837:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010183a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101840:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101843:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010184a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101850:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101853:	89 cb                	mov    %ecx,%ebx
c0101855:	89 df                	mov    %ebx,%edi
c0101857:	89 c1                	mov    %eax,%ecx
c0101859:	fc                   	cld    
c010185a:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185c:	89 c8                	mov    %ecx,%eax
c010185e:	89 fb                	mov    %edi,%ebx
c0101860:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101863:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101866:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101872:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101878:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187e:	25 00 00 00 04       	and    $0x4000000,%eax
c0101883:	85 c0                	test   %eax,%eax
c0101885:	74 0e                	je     c0101895 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188a:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101893:	eb 09                	jmp    c010189e <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101898:	8b 40 78             	mov    0x78(%eax),%eax
c010189b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a2:	c1 e0 03             	shl    $0x3,%eax
c01018a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ac:	29 c2                	sub    %eax,%edx
c01018ae:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b7:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018be:	c1 e0 03             	shl    $0x3,%eax
c01018c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c8:	29 c2                	sub    %eax,%edx
c01018ca:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d3:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d9:	83 c0 62             	add    $0x62,%eax
c01018dc:	0f b7 00             	movzwl (%eax),%eax
c01018df:	0f b7 c0             	movzwl %ax,%eax
c01018e2:	25 00 02 00 00       	and    $0x200,%eax
c01018e7:	85 c0                	test   %eax,%eax
c01018e9:	75 24                	jne    c010190f <ide_init+0x1fb>
c01018eb:	c7 44 24 0c 50 a0 10 	movl   $0xc010a050,0xc(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 08 93 a0 10 	movl   $0xc010a093,0x8(%esp)
c01018fa:	c0 
c01018fb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101902:	00 
c0101903:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c010190a:	e8 ce f3 ff ff       	call   c0100cdd <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101913:	c1 e0 03             	shl    $0x3,%eax
c0101916:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191d:	29 c2                	sub    %eax,%edx
c010191f:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101925:	83 c0 0c             	add    $0xc,%eax
c0101928:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192e:	83 c0 36             	add    $0x36,%eax
c0101931:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101934:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101942:	eb 34                	jmp    c0101978 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010194a:	01 c2                	add    %eax,%edx
c010194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194f:	8d 48 01             	lea    0x1(%eax),%ecx
c0101952:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101955:	01 c8                	add    %ecx,%eax
c0101957:	0f b6 00             	movzbl (%eax),%eax
c010195a:	88 02                	mov    %al,(%edx)
c010195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195f:	8d 50 01             	lea    0x1(%eax),%edx
c0101962:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101965:	01 c2                	add    %eax,%edx
c0101967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196d:	01 c8                	add    %ecx,%eax
c010196f:	0f b6 00             	movzbl (%eax),%eax
c0101972:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101974:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197e:	72 c4                	jb     c0101944 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101980:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101983:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101986:	01 d0                	add    %edx,%eax
c0101988:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101991:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101994:	85 c0                	test   %eax,%eax
c0101996:	74 0f                	je     c01019a7 <ide_init+0x293>
c0101998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199e:	01 d0                	add    %edx,%eax
c01019a0:	0f b6 00             	movzbl (%eax),%eax
c01019a3:	3c 20                	cmp    $0x20,%al
c01019a5:	74 d9                	je     c0101980 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019ab:	c1 e0 03             	shl    $0x3,%eax
c01019ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b5:	29 c2                	sub    %eax,%edx
c01019b7:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019bd:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019c0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c4:	c1 e0 03             	shl    $0x3,%eax
c01019c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ce:	29 c2                	sub    %eax,%edx
c01019d0:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d6:	8b 50 08             	mov    0x8(%eax),%edx
c01019d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e9:	c7 04 24 ba a0 10 c0 	movl   $0xc010a0ba,(%esp)
c01019f0:	e8 5e e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f9:	83 c0 01             	add    $0x1,%eax
c01019fc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a00:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a05:	0f 86 1f fd ff ff    	jbe    c010172a <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a12:	e8 7c 05 00 00       	call   c0101f93 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a17:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1e:	e8 70 05 00 00       	call   c0101f93 <pic_enable>
}
c0101a23:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a29:	5b                   	pop    %ebx
c0101a2a:	5f                   	pop    %edi
c0101a2b:	5d                   	pop    %ebp
c0101a2c:	c3                   	ret    

c0101a2d <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
c0101a30:	83 ec 04             	sub    $0x4,%esp
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a3a:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3f:	77 24                	ja     c0101a65 <ide_device_valid+0x38>
c0101a41:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a45:	c1 e0 03             	shl    $0x3,%eax
c0101a48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4f:	29 c2                	sub    %eax,%edx
c0101a51:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a57:	0f b6 00             	movzbl (%eax),%eax
c0101a5a:	84 c0                	test   %al,%al
c0101a5c:	74 07                	je     c0101a65 <ide_device_valid+0x38>
c0101a5e:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a63:	eb 05                	jmp    c0101a6a <ide_device_valid+0x3d>
c0101a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a6a:	c9                   	leave  
c0101a6b:	c3                   	ret    

c0101a6c <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6c:	55                   	push   %ebp
c0101a6d:	89 e5                	mov    %esp,%ebp
c0101a6f:	83 ec 08             	sub    $0x8,%esp
c0101a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a79:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 a8 ff ff ff       	call   c0101a2d <ide_device_valid>
c0101a85:	85 c0                	test   %eax,%eax
c0101a87:	74 1b                	je     c0101aa4 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8d:	c1 e0 03             	shl    $0x3,%eax
c0101a90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a97:	29 c2                	sub    %eax,%edx
c0101a99:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a9f:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa2:	eb 05                	jmp    c0101aa9 <ide_device_size+0x3d>
    }
    return 0;
c0101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa9:	c9                   	leave  
c0101aaa:	c3                   	ret    

c0101aab <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aab:	55                   	push   %ebp
c0101aac:	89 e5                	mov    %esp,%ebp
c0101aae:	57                   	push   %edi
c0101aaf:	53                   	push   %ebx
c0101ab0:	83 ec 50             	sub    $0x50,%esp
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101aba:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac1:	77 24                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101ac3:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac8:	77 1d                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101aca:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ace:	c1 e0 03             	shl    $0x3,%eax
c0101ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad8:	29 c2                	sub    %eax,%edx
c0101ada:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101ae0:	0f b6 00             	movzbl (%eax),%eax
c0101ae3:	84 c0                	test   %al,%al
c0101ae5:	75 24                	jne    c0101b0b <ide_read_secs+0x60>
c0101ae7:	c7 44 24 0c d8 a0 10 	movl   $0xc010a0d8,0xc(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 08 93 a0 10 	movl   $0xc010a093,0x8(%esp)
c0101af6:	c0 
c0101af7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afe:	00 
c0101aff:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c0101b06:	e8 d2 f1 ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0b:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b12:	77 0f                	ja     c0101b23 <ide_read_secs+0x78>
c0101b14:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b1a:	01 d0                	add    %edx,%eax
c0101b1c:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b21:	76 24                	jbe    c0101b47 <ide_read_secs+0x9c>
c0101b23:	c7 44 24 0c 00 a1 10 	movl   $0xc010a100,0xc(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 08 93 a0 10 	movl   $0xc010a093,0x8(%esp)
c0101b32:	c0 
c0101b33:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b3a:	00 
c0101b3b:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c0101b42:	e8 96 f1 ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b47:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4b:	66 d1 e8             	shr    %ax
c0101b4e:	0f b7 c0             	movzwl %ax,%eax
c0101b51:	0f b7 04 85 48 a0 10 	movzwl -0x3fef5fb8(,%eax,4),%eax
c0101b58:	c0 
c0101b59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b61:	66 d1 e8             	shr    %ax
c0101b64:	0f b7 c0             	movzwl %ax,%eax
c0101b67:	0f b7 04 85 4a a0 10 	movzwl -0x3fef5fb6(,%eax,4),%eax
c0101b6e:	c0 
c0101b6f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7e:	00 
c0101b7f:	89 04 24             	mov    %eax,(%esp)
c0101b82:	e8 33 fb ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b87:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8b:	83 c0 02             	add    $0x2,%eax
c0101b8e:	0f b7 c0             	movzwl %ax,%eax
c0101b91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b95:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba5:	0f b6 c0             	movzbl %al,%eax
c0101ba8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bac:	83 c2 02             	add    $0x2,%edx
c0101baf:	0f b7 d2             	movzwl %dx,%edx
c0101bb2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb6:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc5:	0f b6 c0             	movzbl %al,%eax
c0101bc8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcc:	83 c2 03             	add    $0x3,%edx
c0101bcf:	0f b7 d2             	movzwl %dx,%edx
c0101bd2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be5:	c1 e8 08             	shr    $0x8,%eax
c0101be8:	0f b6 c0             	movzbl %al,%eax
c0101beb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bef:	83 c2 04             	add    $0x4,%edx
c0101bf2:	0f b7 d2             	movzwl %dx,%edx
c0101bf5:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf9:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c00:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c04:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c08:	c1 e8 10             	shr    $0x10,%eax
c0101c0b:	0f b6 c0             	movzbl %al,%eax
c0101c0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c12:	83 c2 05             	add    $0x5,%edx
c0101c15:	0f b7 d2             	movzwl %dx,%edx
c0101c18:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1c:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c27:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c28:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2c:	83 e0 01             	and    $0x1,%eax
c0101c2f:	c1 e0 04             	shl    $0x4,%eax
c0101c32:	89 c2                	mov    %eax,%edx
c0101c34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c37:	c1 e8 18             	shr    $0x18,%eax
c0101c3a:	83 e0 0f             	and    $0xf,%eax
c0101c3d:	09 d0                	or     %edx,%eax
c0101c3f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c42:	0f b6 c0             	movzbl %al,%eax
c0101c45:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c49:	83 c2 06             	add    $0x6,%edx
c0101c4c:	0f b7 d2             	movzwl %dx,%edx
c0101c4f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c53:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c56:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c5a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c63:	83 c0 07             	add    $0x7,%eax
c0101c66:	0f b7 c0             	movzwl %ax,%eax
c0101c69:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c71:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c75:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c79:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c81:	eb 5a                	jmp    c0101cdd <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c83:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c87:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8e:	00 
c0101c8f:	89 04 24             	mov    %eax,(%esp)
c0101c92:	e8 23 fa ff ff       	call   c01016ba <ide_wait_ready>
c0101c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9e:	74 02                	je     c0101ca2 <ide_read_secs+0x1f7>
            goto out;
c0101ca0:	eb 41                	jmp    c0101ce3 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca9:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101caf:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbf:	89 cb                	mov    %ecx,%ebx
c0101cc1:	89 df                	mov    %ebx,%edi
c0101cc3:	89 c1                	mov    %eax,%ecx
c0101cc5:	fc                   	cld    
c0101cc6:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc8:	89 c8                	mov    %ecx,%eax
c0101cca:	89 fb                	mov    %edi,%ebx
c0101ccc:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ccf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd2:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd6:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce1:	75 a0                	jne    c0101c83 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce6:	83 c4 50             	add    $0x50,%esp
c0101ce9:	5b                   	pop    %ebx
c0101cea:	5f                   	pop    %edi
c0101ceb:	5d                   	pop    %ebp
c0101cec:	c3                   	ret    

c0101ced <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ced:	55                   	push   %ebp
c0101cee:	89 e5                	mov    %esp,%ebp
c0101cf0:	56                   	push   %esi
c0101cf1:	53                   	push   %ebx
c0101cf2:	83 ec 50             	sub    $0x50,%esp
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfc:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d03:	77 24                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d05:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d0a:	77 1d                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d0c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d10:	c1 e0 03             	shl    $0x3,%eax
c0101d13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d1a:	29 c2                	sub    %eax,%edx
c0101d1c:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d22:	0f b6 00             	movzbl (%eax),%eax
c0101d25:	84 c0                	test   %al,%al
c0101d27:	75 24                	jne    c0101d4d <ide_write_secs+0x60>
c0101d29:	c7 44 24 0c d8 a0 10 	movl   $0xc010a0d8,0xc(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 08 93 a0 10 	movl   $0xc010a093,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c0101d48:	e8 90 ef ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4d:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d54:	77 0f                	ja     c0101d65 <ide_write_secs+0x78>
c0101d56:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5c:	01 d0                	add    %edx,%eax
c0101d5e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d63:	76 24                	jbe    c0101d89 <ide_write_secs+0x9c>
c0101d65:	c7 44 24 0c 00 a1 10 	movl   $0xc010a100,0xc(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 08 93 a0 10 	movl   $0xc010a093,0x8(%esp)
c0101d74:	c0 
c0101d75:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7c:	00 
c0101d7d:	c7 04 24 a8 a0 10 c0 	movl   $0xc010a0a8,(%esp)
c0101d84:	e8 54 ef ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d89:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8d:	66 d1 e8             	shr    %ax
c0101d90:	0f b7 c0             	movzwl %ax,%eax
c0101d93:	0f b7 04 85 48 a0 10 	movzwl -0x3fef5fb8(,%eax,4),%eax
c0101d9a:	c0 
c0101d9b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da3:	66 d1 e8             	shr    %ax
c0101da6:	0f b7 c0             	movzwl %ax,%eax
c0101da9:	0f b7 04 85 4a a0 10 	movzwl -0x3fef5fb6(,%eax,4),%eax
c0101db0:	c0 
c0101db1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dc0:	00 
c0101dc1:	89 04 24             	mov    %eax,(%esp)
c0101dc4:	e8 f1 f8 ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcd:	83 c0 02             	add    $0x2,%eax
c0101dd0:	0f b7 c0             	movzwl %ax,%eax
c0101dd3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ddb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ddf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de4:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de7:	0f b6 c0             	movzbl %al,%eax
c0101dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dee:	83 c2 02             	add    $0x2,%edx
c0101df1:	0f b7 d2             	movzwl %dx,%edx
c0101df4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e07:	0f b6 c0             	movzbl %al,%eax
c0101e0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0e:	83 c2 03             	add    $0x3,%edx
c0101e11:	0f b7 d2             	movzwl %dx,%edx
c0101e14:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e18:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e23:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e27:	c1 e8 08             	shr    $0x8,%eax
c0101e2a:	0f b6 c0             	movzbl %al,%eax
c0101e2d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e31:	83 c2 04             	add    $0x4,%edx
c0101e34:	0f b7 d2             	movzwl %dx,%edx
c0101e37:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3b:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e42:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e46:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e4a:	c1 e8 10             	shr    $0x10,%eax
c0101e4d:	0f b6 c0             	movzbl %al,%eax
c0101e50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e54:	83 c2 05             	add    $0x5,%edx
c0101e57:	0f b7 d2             	movzwl %dx,%edx
c0101e5a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e61:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e65:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e69:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e6a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6e:	83 e0 01             	and    $0x1,%eax
c0101e71:	c1 e0 04             	shl    $0x4,%eax
c0101e74:	89 c2                	mov    %eax,%edx
c0101e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e79:	c1 e8 18             	shr    $0x18,%eax
c0101e7c:	83 e0 0f             	and    $0xf,%eax
c0101e7f:	09 d0                	or     %edx,%eax
c0101e81:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e84:	0f b6 c0             	movzbl %al,%eax
c0101e87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8b:	83 c2 06             	add    $0x6,%edx
c0101e8e:	0f b7 d2             	movzwl %dx,%edx
c0101e91:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e95:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e98:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ea0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea5:	83 c0 07             	add    $0x7,%eax
c0101ea8:	0f b7 c0             	movzwl %ax,%eax
c0101eab:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eaf:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb3:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb7:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ebb:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec3:	eb 5a                	jmp    c0101f1f <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ed0:	00 
c0101ed1:	89 04 24             	mov    %eax,(%esp)
c0101ed4:	e8 e1 f7 ff ff       	call   c01016ba <ide_wait_ready>
c0101ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ee0:	74 02                	je     c0101ee4 <ide_write_secs+0x1f7>
            goto out;
c0101ee2:	eb 41                	jmp    c0101f25 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eee:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f01:	89 cb                	mov    %ecx,%ebx
c0101f03:	89 de                	mov    %ebx,%esi
c0101f05:	89 c1                	mov    %eax,%ecx
c0101f07:	fc                   	cld    
c0101f08:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f0a:	89 c8                	mov    %ecx,%eax
c0101f0c:	89 f3                	mov    %esi,%ebx
c0101f0e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f14:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f18:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f23:	75 a0                	jne    c0101ec5 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f28:	83 c4 50             	add    $0x50,%esp
c0101f2b:	5b                   	pop    %ebx
c0101f2c:	5e                   	pop    %esi
c0101f2d:	5d                   	pop    %ebp
c0101f2e:	c3                   	ret    

c0101f2f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2f:	55                   	push   %ebp
c0101f30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f32:	fb                   	sti    
    sti();
}
c0101f33:	5d                   	pop    %ebp
c0101f34:	c3                   	ret    

c0101f35 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f35:	55                   	push   %ebp
c0101f36:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f38:	fa                   	cli    
    cli();
}
c0101f39:	5d                   	pop    %ebp
c0101f3a:	c3                   	ret    

c0101f3b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3b:	55                   	push   %ebp
c0101f3c:	89 e5                	mov    %esp,%ebp
c0101f3e:	83 ec 14             	sub    $0x14,%esp
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4c:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f52:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f57:	85 c0                	test   %eax,%eax
c0101f59:	74 36                	je     c0101f91 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5f:	0f b6 c0             	movzbl %al,%eax
c0101f62:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f68:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f73:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f74:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f78:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f85:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f90:	ee                   	out    %al,(%dx)
    }
}
c0101f91:	c9                   	leave  
c0101f92:	c3                   	ret    

c0101f93 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f93:	55                   	push   %ebp
c0101f94:	89 e5                	mov    %esp,%ebp
c0101f96:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa1:	89 c1                	mov    %eax,%ecx
c0101fa3:	d3 e2                	shl    %cl,%edx
c0101fa5:	89 d0                	mov    %edx,%eax
c0101fa7:	f7 d0                	not    %eax
c0101fa9:	89 c2                	mov    %eax,%edx
c0101fab:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fb2:	21 d0                	and    %edx,%eax
c0101fb4:	0f b7 c0             	movzwl %ax,%eax
c0101fb7:	89 04 24             	mov    %eax,(%esp)
c0101fba:	e8 7c ff ff ff       	call   c0101f3b <pic_setmask>
}
c0101fbf:	c9                   	leave  
c0101fc0:	c3                   	ret    

c0101fc1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc1:	55                   	push   %ebp
c0101fc2:	89 e5                	mov    %esp,%ebp
c0101fc4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc7:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fce:	00 00 00 
c0101fd1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fdb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fdf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe3:	ee                   	out    %al,(%dx)
c0101fe4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
c0101ff7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102001:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102005:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102009:	ee                   	out    %al,(%dx)
c010200a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102010:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102014:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102018:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201c:	ee                   	out    %al,(%dx)
c010201d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102023:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102027:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202f:	ee                   	out    %al,(%dx)
c0102030:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102036:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010203a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102049:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102051:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102060:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102064:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)
c0102069:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102073:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102077:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207b:	ee                   	out    %al,(%dx)
c010207c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102082:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102086:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010208a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102095:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102099:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b4:	ee                   	out    %al,(%dx)
c01020b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
c01020c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020db:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e6:	74 12                	je     c01020fa <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e8:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020ef:	0f b7 c0             	movzwl %ax,%eax
c01020f2:	89 04 24             	mov    %eax,(%esp)
c01020f5:	e8 41 fe ff ff       	call   c0101f3b <pic_setmask>
    }
}
c01020fa:	c9                   	leave  
c01020fb:	c3                   	ret    

c01020fc <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fc:	55                   	push   %ebp
c01020fd:	89 e5                	mov    %esp,%ebp
c01020ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102102:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102109:	00 
c010210a:	c7 04 24 40 a1 10 c0 	movl   $0xc010a140,(%esp)
c0102111:	e8 3d e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102116:	c9                   	leave  
c0102117:	c3                   	ret    

c0102118 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102118:	55                   	push   %ebp
c0102119:	89 e5                	mov    %esp,%ebp
c010211b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010211e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102125:	e9 c3 00 00 00       	jmp    c01021ed <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010212a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212d:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102134:	89 c2                	mov    %eax,%edx
c0102136:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102139:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102140:	c0 
c0102141:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102144:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c010214b:	c0 08 00 
c010214e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102151:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102158:	c0 
c0102159:	83 e2 e0             	and    $0xffffffe0,%edx
c010215c:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 1f             	and    $0x1f,%edx
c0102171:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 f0             	and    $0xfffffff0,%edx
c0102186:	83 ca 0e             	or     $0xe,%edx
c0102189:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010219a:	c0 
c010219b:	83 e2 ef             	and    $0xffffffef,%edx
c010219e:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 9f             	and    $0xffffff9f,%edx
c01021b3:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 ca 80             	or     $0xffffff80,%edx
c01021c8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01021d9:	c1 e8 10             	shr    $0x10,%eax
c01021dc:	89 c2                	mov    %eax,%edx
c01021de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e1:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c01021e8:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f0:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021f5:	0f 86 2f ff ff ff    	jbe    c010212a <idt_init+0x12>
c01021fb:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102202:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102205:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c0102208:	c9                   	leave  
c0102209:	c3                   	ret    

c010220a <trapname>:

static const char *
trapname(int trapno) {
c010220a:	55                   	push   %ebp
c010220b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010220d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102210:	83 f8 13             	cmp    $0x13,%eax
c0102213:	77 0c                	ja     c0102221 <trapname+0x17>
        return excnames[trapno];
c0102215:	8b 45 08             	mov    0x8(%ebp),%eax
c0102218:	8b 04 85 20 a5 10 c0 	mov    -0x3fef5ae0(,%eax,4),%eax
c010221f:	eb 18                	jmp    c0102239 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102221:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102225:	7e 0d                	jle    c0102234 <trapname+0x2a>
c0102227:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010222b:	7f 07                	jg     c0102234 <trapname+0x2a>
        return "Hardware Interrupt";
c010222d:	b8 4a a1 10 c0       	mov    $0xc010a14a,%eax
c0102232:	eb 05                	jmp    c0102239 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102234:	b8 5d a1 10 c0       	mov    $0xc010a15d,%eax
}
c0102239:	5d                   	pop    %ebp
c010223a:	c3                   	ret    

c010223b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010223b:	55                   	push   %ebp
c010223c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010223e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102241:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102245:	66 83 f8 08          	cmp    $0x8,%ax
c0102249:	0f 94 c0             	sete   %al
c010224c:	0f b6 c0             	movzbl %al,%eax
}
c010224f:	5d                   	pop    %ebp
c0102250:	c3                   	ret    

c0102251 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102251:	55                   	push   %ebp
c0102252:	89 e5                	mov    %esp,%ebp
c0102254:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102257:	8b 45 08             	mov    0x8(%ebp),%eax
c010225a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010225e:	c7 04 24 9e a1 10 c0 	movl   $0xc010a19e,(%esp)
c0102265:	e8 e9 e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c010226a:	8b 45 08             	mov    0x8(%ebp),%eax
c010226d:	89 04 24             	mov    %eax,(%esp)
c0102270:	e8 a1 01 00 00       	call   c0102416 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102275:	8b 45 08             	mov    0x8(%ebp),%eax
c0102278:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010227c:	0f b7 c0             	movzwl %ax,%eax
c010227f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102283:	c7 04 24 af a1 10 c0 	movl   $0xc010a1af,(%esp)
c010228a:	e8 c4 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010228f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102292:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102296:	0f b7 c0             	movzwl %ax,%eax
c0102299:	89 44 24 04          	mov    %eax,0x4(%esp)
c010229d:	c7 04 24 c2 a1 10 c0 	movl   $0xc010a1c2,(%esp)
c01022a4:	e8 aa e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ac:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022b0:	0f b7 c0             	movzwl %ax,%eax
c01022b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022b7:	c7 04 24 d5 a1 10 c0 	movl   $0xc010a1d5,(%esp)
c01022be:	e8 90 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c6:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022ca:	0f b7 c0             	movzwl %ax,%eax
c01022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022d1:	c7 04 24 e8 a1 10 c0 	movl   $0xc010a1e8,(%esp)
c01022d8:	e8 76 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e0:	8b 40 30             	mov    0x30(%eax),%eax
c01022e3:	89 04 24             	mov    %eax,(%esp)
c01022e6:	e8 1f ff ff ff       	call   c010220a <trapname>
c01022eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01022ee:	8b 52 30             	mov    0x30(%edx),%edx
c01022f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01022f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01022f9:	c7 04 24 fb a1 10 c0 	movl   $0xc010a1fb,(%esp)
c0102300:	e8 4e e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102305:	8b 45 08             	mov    0x8(%ebp),%eax
c0102308:	8b 40 34             	mov    0x34(%eax),%eax
c010230b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010230f:	c7 04 24 0d a2 10 c0 	movl   $0xc010a20d,(%esp)
c0102316:	e8 38 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010231b:	8b 45 08             	mov    0x8(%ebp),%eax
c010231e:	8b 40 38             	mov    0x38(%eax),%eax
c0102321:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102325:	c7 04 24 1c a2 10 c0 	movl   $0xc010a21c,(%esp)
c010232c:	e8 22 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102331:	8b 45 08             	mov    0x8(%ebp),%eax
c0102334:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102338:	0f b7 c0             	movzwl %ax,%eax
c010233b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010233f:	c7 04 24 2b a2 10 c0 	movl   $0xc010a22b,(%esp)
c0102346:	e8 08 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010234b:	8b 45 08             	mov    0x8(%ebp),%eax
c010234e:	8b 40 40             	mov    0x40(%eax),%eax
c0102351:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102355:	c7 04 24 3e a2 10 c0 	movl   $0xc010a23e,(%esp)
c010235c:	e8 f2 df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102368:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010236f:	eb 3e                	jmp    c01023af <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102371:	8b 45 08             	mov    0x8(%ebp),%eax
c0102374:	8b 50 40             	mov    0x40(%eax),%edx
c0102377:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010237a:	21 d0                	and    %edx,%eax
c010237c:	85 c0                	test   %eax,%eax
c010237e:	74 28                	je     c01023a8 <print_trapframe+0x157>
c0102380:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102383:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c010238a:	85 c0                	test   %eax,%eax
c010238c:	74 1a                	je     c01023a8 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c010238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102391:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102398:	89 44 24 04          	mov    %eax,0x4(%esp)
c010239c:	c7 04 24 4d a2 10 c0 	movl   $0xc010a24d,(%esp)
c01023a3:	e8 ab df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023ac:	d1 65 f0             	shll   -0x10(%ebp)
c01023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023b2:	83 f8 17             	cmp    $0x17,%eax
c01023b5:	76 ba                	jbe    c0102371 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ba:	8b 40 40             	mov    0x40(%eax),%eax
c01023bd:	25 00 30 00 00       	and    $0x3000,%eax
c01023c2:	c1 e8 0c             	shr    $0xc,%eax
c01023c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c9:	c7 04 24 51 a2 10 c0 	movl   $0xc010a251,(%esp)
c01023d0:	e8 7e df ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c01023d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d8:	89 04 24             	mov    %eax,(%esp)
c01023db:	e8 5b fe ff ff       	call   c010223b <trap_in_kernel>
c01023e0:	85 c0                	test   %eax,%eax
c01023e2:	75 30                	jne    c0102414 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e7:	8b 40 44             	mov    0x44(%eax),%eax
c01023ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ee:	c7 04 24 5a a2 10 c0 	movl   $0xc010a25a,(%esp)
c01023f5:	e8 59 df ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01023fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102401:	0f b7 c0             	movzwl %ax,%eax
c0102404:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102408:	c7 04 24 69 a2 10 c0 	movl   $0xc010a269,(%esp)
c010240f:	e8 3f df ff ff       	call   c0100353 <cprintf>
    }
}
c0102414:	c9                   	leave  
c0102415:	c3                   	ret    

c0102416 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102416:	55                   	push   %ebp
c0102417:	89 e5                	mov    %esp,%ebp
c0102419:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010241c:	8b 45 08             	mov    0x8(%ebp),%eax
c010241f:	8b 00                	mov    (%eax),%eax
c0102421:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102425:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010242c:	e8 22 df ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 40 04             	mov    0x4(%eax),%eax
c0102437:	89 44 24 04          	mov    %eax,0x4(%esp)
c010243b:	c7 04 24 8b a2 10 c0 	movl   $0xc010a28b,(%esp)
c0102442:	e8 0c df ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102447:	8b 45 08             	mov    0x8(%ebp),%eax
c010244a:	8b 40 08             	mov    0x8(%eax),%eax
c010244d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102451:	c7 04 24 9a a2 10 c0 	movl   $0xc010a29a,(%esp)
c0102458:	e8 f6 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010245d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102460:	8b 40 0c             	mov    0xc(%eax),%eax
c0102463:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102467:	c7 04 24 a9 a2 10 c0 	movl   $0xc010a2a9,(%esp)
c010246e:	e8 e0 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102473:	8b 45 08             	mov    0x8(%ebp),%eax
c0102476:	8b 40 10             	mov    0x10(%eax),%eax
c0102479:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247d:	c7 04 24 b8 a2 10 c0 	movl   $0xc010a2b8,(%esp)
c0102484:	e8 ca de ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102489:	8b 45 08             	mov    0x8(%ebp),%eax
c010248c:	8b 40 14             	mov    0x14(%eax),%eax
c010248f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102493:	c7 04 24 c7 a2 10 c0 	movl   $0xc010a2c7,(%esp)
c010249a:	e8 b4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010249f:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a2:	8b 40 18             	mov    0x18(%eax),%eax
c01024a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a9:	c7 04 24 d6 a2 10 c0 	movl   $0xc010a2d6,(%esp)
c01024b0:	e8 9e de ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bf:	c7 04 24 e5 a2 10 c0 	movl   $0xc010a2e5,(%esp)
c01024c6:	e8 88 de ff ff       	call   c0100353 <cprintf>
}
c01024cb:	c9                   	leave  
c01024cc:	c3                   	ret    

c01024cd <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024cd:	55                   	push   %ebp
c01024ce:	89 e5                	mov    %esp,%ebp
c01024d0:	53                   	push   %ebx
c01024d1:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d7:	8b 40 34             	mov    0x34(%eax),%eax
c01024da:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024dd:	85 c0                	test   %eax,%eax
c01024df:	74 07                	je     c01024e8 <print_pgfault+0x1b>
c01024e1:	b9 f4 a2 10 c0       	mov    $0xc010a2f4,%ecx
c01024e6:	eb 05                	jmp    c01024ed <print_pgfault+0x20>
c01024e8:	b9 05 a3 10 c0       	mov    $0xc010a305,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01024ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f0:	8b 40 34             	mov    0x34(%eax),%eax
c01024f3:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024f6:	85 c0                	test   %eax,%eax
c01024f8:	74 07                	je     c0102501 <print_pgfault+0x34>
c01024fa:	ba 57 00 00 00       	mov    $0x57,%edx
c01024ff:	eb 05                	jmp    c0102506 <print_pgfault+0x39>
c0102501:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102506:	8b 45 08             	mov    0x8(%ebp),%eax
c0102509:	8b 40 34             	mov    0x34(%eax),%eax
c010250c:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010250f:	85 c0                	test   %eax,%eax
c0102511:	74 07                	je     c010251a <print_pgfault+0x4d>
c0102513:	b8 55 00 00 00       	mov    $0x55,%eax
c0102518:	eb 05                	jmp    c010251f <print_pgfault+0x52>
c010251a:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010251f:	0f 20 d3             	mov    %cr2,%ebx
c0102522:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102525:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102528:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010252c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102530:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102534:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102538:	c7 04 24 14 a3 10 c0 	movl   $0xc010a314,(%esp)
c010253f:	e8 0f de ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102544:	83 c4 34             	add    $0x34,%esp
c0102547:	5b                   	pop    %ebx
c0102548:	5d                   	pop    %ebp
c0102549:	c3                   	ret    

c010254a <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010254a:	55                   	push   %ebp
c010254b:	89 e5                	mov    %esp,%ebp
c010254d:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102550:	8b 45 08             	mov    0x8(%ebp),%eax
c0102553:	89 04 24             	mov    %eax,(%esp)
c0102556:	e8 72 ff ff ff       	call   c01024cd <print_pgfault>
    if (check_mm_struct != NULL) {
c010255b:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0102560:	85 c0                	test   %eax,%eax
c0102562:	74 28                	je     c010258c <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102564:	0f 20 d0             	mov    %cr2,%eax
c0102567:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c010256d:	89 c1                	mov    %eax,%ecx
c010256f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102572:	8b 50 34             	mov    0x34(%eax),%edx
c0102575:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010257a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010257e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102582:	89 04 24             	mov    %eax,(%esp)
c0102585:	e8 81 5b 00 00       	call   c010810b <do_pgfault>
c010258a:	eb 1c                	jmp    c01025a8 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c010258c:	c7 44 24 08 37 a3 10 	movl   $0xc010a337,0x8(%esp)
c0102593:	c0 
c0102594:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c010259b:	00 
c010259c:	c7 04 24 4e a3 10 c0 	movl   $0xc010a34e,(%esp)
c01025a3:	e8 35 e7 ff ff       	call   c0100cdd <__panic>
}
c01025a8:	c9                   	leave  
c01025a9:	c3                   	ret    

c01025aa <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025aa:	55                   	push   %ebp
c01025ab:	89 e5                	mov    %esp,%ebp
c01025ad:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b3:	8b 40 30             	mov    0x30(%eax),%eax
c01025b6:	83 f8 24             	cmp    $0x24,%eax
c01025b9:	0f 84 c2 00 00 00    	je     c0102681 <trap_dispatch+0xd7>
c01025bf:	83 f8 24             	cmp    $0x24,%eax
c01025c2:	77 18                	ja     c01025dc <trap_dispatch+0x32>
c01025c4:	83 f8 20             	cmp    $0x20,%eax
c01025c7:	74 7d                	je     c0102646 <trap_dispatch+0x9c>
c01025c9:	83 f8 21             	cmp    $0x21,%eax
c01025cc:	0f 84 d5 00 00 00    	je     c01026a7 <trap_dispatch+0xfd>
c01025d2:	83 f8 0e             	cmp    $0xe,%eax
c01025d5:	74 28                	je     c01025ff <trap_dispatch+0x55>
c01025d7:	e9 0d 01 00 00       	jmp    c01026e9 <trap_dispatch+0x13f>
c01025dc:	83 f8 2e             	cmp    $0x2e,%eax
c01025df:	0f 82 04 01 00 00    	jb     c01026e9 <trap_dispatch+0x13f>
c01025e5:	83 f8 2f             	cmp    $0x2f,%eax
c01025e8:	0f 86 33 01 00 00    	jbe    c0102721 <trap_dispatch+0x177>
c01025ee:	83 e8 78             	sub    $0x78,%eax
c01025f1:	83 f8 01             	cmp    $0x1,%eax
c01025f4:	0f 87 ef 00 00 00    	ja     c01026e9 <trap_dispatch+0x13f>
c01025fa:	e9 ce 00 00 00       	jmp    c01026cd <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01025ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102602:	89 04 24             	mov    %eax,(%esp)
c0102605:	e8 40 ff ff ff       	call   c010254a <pgfault_handler>
c010260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102611:	74 2e                	je     c0102641 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102613:	8b 45 08             	mov    0x8(%ebp),%eax
c0102616:	89 04 24             	mov    %eax,(%esp)
c0102619:	e8 33 fc ff ff       	call   c0102251 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c010261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102621:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102625:	c7 44 24 08 5f a3 10 	movl   $0xc010a35f,0x8(%esp)
c010262c:	c0 
c010262d:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102634:	00 
c0102635:	c7 04 24 4e a3 10 c0 	movl   $0xc010a34e,(%esp)
c010263c:	e8 9c e6 ff ff       	call   c0100cdd <__panic>
        }
        break;
c0102641:	e9 dc 00 00 00       	jmp    c0102722 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0102646:	a1 14 7b 12 c0       	mov    0xc0127b14,%eax
c010264b:	83 c0 01             	add    $0x1,%eax
c010264e:	a3 14 7b 12 c0       	mov    %eax,0xc0127b14
        if (ticks % TICK_NUM == 0) {
c0102653:	8b 0d 14 7b 12 c0    	mov    0xc0127b14,%ecx
c0102659:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c010265e:	89 c8                	mov    %ecx,%eax
c0102660:	f7 e2                	mul    %edx
c0102662:	89 d0                	mov    %edx,%eax
c0102664:	c1 e8 05             	shr    $0x5,%eax
c0102667:	6b c0 64             	imul   $0x64,%eax,%eax
c010266a:	29 c1                	sub    %eax,%ecx
c010266c:	89 c8                	mov    %ecx,%eax
c010266e:	85 c0                	test   %eax,%eax
c0102670:	75 0a                	jne    c010267c <trap_dispatch+0xd2>
            print_ticks();
c0102672:	e8 85 fa ff ff       	call   c01020fc <print_ticks>
        }
        break;
c0102677:	e9 a6 00 00 00       	jmp    c0102722 <trap_dispatch+0x178>
c010267c:	e9 a1 00 00 00       	jmp    c0102722 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102681:	e8 c5 ef ff ff       	call   c010164b <cons_getc>
c0102686:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102689:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010268d:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102691:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102695:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102699:	c7 04 24 7a a3 10 c0 	movl   $0xc010a37a,(%esp)
c01026a0:	e8 ae dc ff ff       	call   c0100353 <cprintf>
        break;
c01026a5:	eb 7b                	jmp    c0102722 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026a7:	e8 9f ef ff ff       	call   c010164b <cons_getc>
c01026ac:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026af:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026b3:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026b7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026bf:	c7 04 24 8c a3 10 c0 	movl   $0xc010a38c,(%esp)
c01026c6:	e8 88 dc ff ff       	call   c0100353 <cprintf>
        break;
c01026cb:	eb 55                	jmp    c0102722 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026cd:	c7 44 24 08 9b a3 10 	movl   $0xc010a39b,0x8(%esp)
c01026d4:	c0 
c01026d5:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01026dc:	00 
c01026dd:	c7 04 24 4e a3 10 c0 	movl   $0xc010a34e,(%esp)
c01026e4:	e8 f4 e5 ff ff       	call   c0100cdd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ec:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01026f0:	0f b7 c0             	movzwl %ax,%eax
c01026f3:	83 e0 03             	and    $0x3,%eax
c01026f6:	85 c0                	test   %eax,%eax
c01026f8:	75 28                	jne    c0102722 <trap_dispatch+0x178>
            print_trapframe(tf);
c01026fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01026fd:	89 04 24             	mov    %eax,(%esp)
c0102700:	e8 4c fb ff ff       	call   c0102251 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102705:	c7 44 24 08 ab a3 10 	movl   $0xc010a3ab,0x8(%esp)
c010270c:	c0 
c010270d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0102714:	00 
c0102715:	c7 04 24 4e a3 10 c0 	movl   $0xc010a34e,(%esp)
c010271c:	e8 bc e5 ff ff       	call   c0100cdd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102721:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102722:	c9                   	leave  
c0102723:	c3                   	ret    

c0102724 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102724:	55                   	push   %ebp
c0102725:	89 e5                	mov    %esp,%ebp
c0102727:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010272a:	8b 45 08             	mov    0x8(%ebp),%eax
c010272d:	89 04 24             	mov    %eax,(%esp)
c0102730:	e8 75 fe ff ff       	call   c01025aa <trap_dispatch>
}
c0102735:	c9                   	leave  
c0102736:	c3                   	ret    

c0102737 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102737:	1e                   	push   %ds
    pushl %es
c0102738:	06                   	push   %es
    pushl %fs
c0102739:	0f a0                	push   %fs
    pushl %gs
c010273b:	0f a8                	push   %gs
    pushal
c010273d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010273e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102743:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102745:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102747:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102748:	e8 d7 ff ff ff       	call   c0102724 <trap>

    # pop the pushed stack pointer
    popl %esp
c010274d:	5c                   	pop    %esp

c010274e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010274e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010274f:	0f a9                	pop    %gs
    popl %fs
c0102751:	0f a1                	pop    %fs
    popl %es
c0102753:	07                   	pop    %es
    popl %ds
c0102754:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102755:	83 c4 08             	add    $0x8,%esp
    iret
c0102758:	cf                   	iret   

c0102759 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102759:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c010275d:	e9 ec ff ff ff       	jmp    c010274e <__trapret>

c0102762 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102762:	6a 00                	push   $0x0
  pushl $0
c0102764:	6a 00                	push   $0x0
  jmp __alltraps
c0102766:	e9 cc ff ff ff       	jmp    c0102737 <__alltraps>

c010276b <vector1>:
.globl vector1
vector1:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $1
c010276d:	6a 01                	push   $0x1
  jmp __alltraps
c010276f:	e9 c3 ff ff ff       	jmp    c0102737 <__alltraps>

c0102774 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $2
c0102776:	6a 02                	push   $0x2
  jmp __alltraps
c0102778:	e9 ba ff ff ff       	jmp    c0102737 <__alltraps>

c010277d <vector3>:
.globl vector3
vector3:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $3
c010277f:	6a 03                	push   $0x3
  jmp __alltraps
c0102781:	e9 b1 ff ff ff       	jmp    c0102737 <__alltraps>

c0102786 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102786:	6a 00                	push   $0x0
  pushl $4
c0102788:	6a 04                	push   $0x4
  jmp __alltraps
c010278a:	e9 a8 ff ff ff       	jmp    c0102737 <__alltraps>

c010278f <vector5>:
.globl vector5
vector5:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $5
c0102791:	6a 05                	push   $0x5
  jmp __alltraps
c0102793:	e9 9f ff ff ff       	jmp    c0102737 <__alltraps>

c0102798 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $6
c010279a:	6a 06                	push   $0x6
  jmp __alltraps
c010279c:	e9 96 ff ff ff       	jmp    c0102737 <__alltraps>

c01027a1 <vector7>:
.globl vector7
vector7:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $7
c01027a3:	6a 07                	push   $0x7
  jmp __alltraps
c01027a5:	e9 8d ff ff ff       	jmp    c0102737 <__alltraps>

c01027aa <vector8>:
.globl vector8
vector8:
  pushl $8
c01027aa:	6a 08                	push   $0x8
  jmp __alltraps
c01027ac:	e9 86 ff ff ff       	jmp    c0102737 <__alltraps>

c01027b1 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027b1:	6a 09                	push   $0x9
  jmp __alltraps
c01027b3:	e9 7f ff ff ff       	jmp    c0102737 <__alltraps>

c01027b8 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027b8:	6a 0a                	push   $0xa
  jmp __alltraps
c01027ba:	e9 78 ff ff ff       	jmp    c0102737 <__alltraps>

c01027bf <vector11>:
.globl vector11
vector11:
  pushl $11
c01027bf:	6a 0b                	push   $0xb
  jmp __alltraps
c01027c1:	e9 71 ff ff ff       	jmp    c0102737 <__alltraps>

c01027c6 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027c6:	6a 0c                	push   $0xc
  jmp __alltraps
c01027c8:	e9 6a ff ff ff       	jmp    c0102737 <__alltraps>

c01027cd <vector13>:
.globl vector13
vector13:
  pushl $13
c01027cd:	6a 0d                	push   $0xd
  jmp __alltraps
c01027cf:	e9 63 ff ff ff       	jmp    c0102737 <__alltraps>

c01027d4 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027d4:	6a 0e                	push   $0xe
  jmp __alltraps
c01027d6:	e9 5c ff ff ff       	jmp    c0102737 <__alltraps>

c01027db <vector15>:
.globl vector15
vector15:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $15
c01027dd:	6a 0f                	push   $0xf
  jmp __alltraps
c01027df:	e9 53 ff ff ff       	jmp    c0102737 <__alltraps>

c01027e4 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $16
c01027e6:	6a 10                	push   $0x10
  jmp __alltraps
c01027e8:	e9 4a ff ff ff       	jmp    c0102737 <__alltraps>

c01027ed <vector17>:
.globl vector17
vector17:
  pushl $17
c01027ed:	6a 11                	push   $0x11
  jmp __alltraps
c01027ef:	e9 43 ff ff ff       	jmp    c0102737 <__alltraps>

c01027f4 <vector18>:
.globl vector18
vector18:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $18
c01027f6:	6a 12                	push   $0x12
  jmp __alltraps
c01027f8:	e9 3a ff ff ff       	jmp    c0102737 <__alltraps>

c01027fd <vector19>:
.globl vector19
vector19:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $19
c01027ff:	6a 13                	push   $0x13
  jmp __alltraps
c0102801:	e9 31 ff ff ff       	jmp    c0102737 <__alltraps>

c0102806 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $20
c0102808:	6a 14                	push   $0x14
  jmp __alltraps
c010280a:	e9 28 ff ff ff       	jmp    c0102737 <__alltraps>

c010280f <vector21>:
.globl vector21
vector21:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $21
c0102811:	6a 15                	push   $0x15
  jmp __alltraps
c0102813:	e9 1f ff ff ff       	jmp    c0102737 <__alltraps>

c0102818 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $22
c010281a:	6a 16                	push   $0x16
  jmp __alltraps
c010281c:	e9 16 ff ff ff       	jmp    c0102737 <__alltraps>

c0102821 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $23
c0102823:	6a 17                	push   $0x17
  jmp __alltraps
c0102825:	e9 0d ff ff ff       	jmp    c0102737 <__alltraps>

c010282a <vector24>:
.globl vector24
vector24:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $24
c010282c:	6a 18                	push   $0x18
  jmp __alltraps
c010282e:	e9 04 ff ff ff       	jmp    c0102737 <__alltraps>

c0102833 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $25
c0102835:	6a 19                	push   $0x19
  jmp __alltraps
c0102837:	e9 fb fe ff ff       	jmp    c0102737 <__alltraps>

c010283c <vector26>:
.globl vector26
vector26:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $26
c010283e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102840:	e9 f2 fe ff ff       	jmp    c0102737 <__alltraps>

c0102845 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $27
c0102847:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102849:	e9 e9 fe ff ff       	jmp    c0102737 <__alltraps>

c010284e <vector28>:
.globl vector28
vector28:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $28
c0102850:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102852:	e9 e0 fe ff ff       	jmp    c0102737 <__alltraps>

c0102857 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $29
c0102859:	6a 1d                	push   $0x1d
  jmp __alltraps
c010285b:	e9 d7 fe ff ff       	jmp    c0102737 <__alltraps>

c0102860 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $30
c0102862:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102864:	e9 ce fe ff ff       	jmp    c0102737 <__alltraps>

c0102869 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $31
c010286b:	6a 1f                	push   $0x1f
  jmp __alltraps
c010286d:	e9 c5 fe ff ff       	jmp    c0102737 <__alltraps>

c0102872 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $32
c0102874:	6a 20                	push   $0x20
  jmp __alltraps
c0102876:	e9 bc fe ff ff       	jmp    c0102737 <__alltraps>

c010287b <vector33>:
.globl vector33
vector33:
  pushl $0
c010287b:	6a 00                	push   $0x0
  pushl $33
c010287d:	6a 21                	push   $0x21
  jmp __alltraps
c010287f:	e9 b3 fe ff ff       	jmp    c0102737 <__alltraps>

c0102884 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $34
c0102886:	6a 22                	push   $0x22
  jmp __alltraps
c0102888:	e9 aa fe ff ff       	jmp    c0102737 <__alltraps>

c010288d <vector35>:
.globl vector35
vector35:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $35
c010288f:	6a 23                	push   $0x23
  jmp __alltraps
c0102891:	e9 a1 fe ff ff       	jmp    c0102737 <__alltraps>

c0102896 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $36
c0102898:	6a 24                	push   $0x24
  jmp __alltraps
c010289a:	e9 98 fe ff ff       	jmp    c0102737 <__alltraps>

c010289f <vector37>:
.globl vector37
vector37:
  pushl $0
c010289f:	6a 00                	push   $0x0
  pushl $37
c01028a1:	6a 25                	push   $0x25
  jmp __alltraps
c01028a3:	e9 8f fe ff ff       	jmp    c0102737 <__alltraps>

c01028a8 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $38
c01028aa:	6a 26                	push   $0x26
  jmp __alltraps
c01028ac:	e9 86 fe ff ff       	jmp    c0102737 <__alltraps>

c01028b1 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $39
c01028b3:	6a 27                	push   $0x27
  jmp __alltraps
c01028b5:	e9 7d fe ff ff       	jmp    c0102737 <__alltraps>

c01028ba <vector40>:
.globl vector40
vector40:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $40
c01028bc:	6a 28                	push   $0x28
  jmp __alltraps
c01028be:	e9 74 fe ff ff       	jmp    c0102737 <__alltraps>

c01028c3 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028c3:	6a 00                	push   $0x0
  pushl $41
c01028c5:	6a 29                	push   $0x29
  jmp __alltraps
c01028c7:	e9 6b fe ff ff       	jmp    c0102737 <__alltraps>

c01028cc <vector42>:
.globl vector42
vector42:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $42
c01028ce:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028d0:	e9 62 fe ff ff       	jmp    c0102737 <__alltraps>

c01028d5 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $43
c01028d7:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028d9:	e9 59 fe ff ff       	jmp    c0102737 <__alltraps>

c01028de <vector44>:
.globl vector44
vector44:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $44
c01028e0:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028e2:	e9 50 fe ff ff       	jmp    c0102737 <__alltraps>

c01028e7 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028e7:	6a 00                	push   $0x0
  pushl $45
c01028e9:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028eb:	e9 47 fe ff ff       	jmp    c0102737 <__alltraps>

c01028f0 <vector46>:
.globl vector46
vector46:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $46
c01028f2:	6a 2e                	push   $0x2e
  jmp __alltraps
c01028f4:	e9 3e fe ff ff       	jmp    c0102737 <__alltraps>

c01028f9 <vector47>:
.globl vector47
vector47:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $47
c01028fb:	6a 2f                	push   $0x2f
  jmp __alltraps
c01028fd:	e9 35 fe ff ff       	jmp    c0102737 <__alltraps>

c0102902 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $48
c0102904:	6a 30                	push   $0x30
  jmp __alltraps
c0102906:	e9 2c fe ff ff       	jmp    c0102737 <__alltraps>

c010290b <vector49>:
.globl vector49
vector49:
  pushl $0
c010290b:	6a 00                	push   $0x0
  pushl $49
c010290d:	6a 31                	push   $0x31
  jmp __alltraps
c010290f:	e9 23 fe ff ff       	jmp    c0102737 <__alltraps>

c0102914 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102914:	6a 00                	push   $0x0
  pushl $50
c0102916:	6a 32                	push   $0x32
  jmp __alltraps
c0102918:	e9 1a fe ff ff       	jmp    c0102737 <__alltraps>

c010291d <vector51>:
.globl vector51
vector51:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $51
c010291f:	6a 33                	push   $0x33
  jmp __alltraps
c0102921:	e9 11 fe ff ff       	jmp    c0102737 <__alltraps>

c0102926 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $52
c0102928:	6a 34                	push   $0x34
  jmp __alltraps
c010292a:	e9 08 fe ff ff       	jmp    c0102737 <__alltraps>

c010292f <vector53>:
.globl vector53
vector53:
  pushl $0
c010292f:	6a 00                	push   $0x0
  pushl $53
c0102931:	6a 35                	push   $0x35
  jmp __alltraps
c0102933:	e9 ff fd ff ff       	jmp    c0102737 <__alltraps>

c0102938 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102938:	6a 00                	push   $0x0
  pushl $54
c010293a:	6a 36                	push   $0x36
  jmp __alltraps
c010293c:	e9 f6 fd ff ff       	jmp    c0102737 <__alltraps>

c0102941 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $55
c0102943:	6a 37                	push   $0x37
  jmp __alltraps
c0102945:	e9 ed fd ff ff       	jmp    c0102737 <__alltraps>

c010294a <vector56>:
.globl vector56
vector56:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $56
c010294c:	6a 38                	push   $0x38
  jmp __alltraps
c010294e:	e9 e4 fd ff ff       	jmp    c0102737 <__alltraps>

c0102953 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102953:	6a 00                	push   $0x0
  pushl $57
c0102955:	6a 39                	push   $0x39
  jmp __alltraps
c0102957:	e9 db fd ff ff       	jmp    c0102737 <__alltraps>

c010295c <vector58>:
.globl vector58
vector58:
  pushl $0
c010295c:	6a 00                	push   $0x0
  pushl $58
c010295e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102960:	e9 d2 fd ff ff       	jmp    c0102737 <__alltraps>

c0102965 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102965:	6a 00                	push   $0x0
  pushl $59
c0102967:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102969:	e9 c9 fd ff ff       	jmp    c0102737 <__alltraps>

c010296e <vector60>:
.globl vector60
vector60:
  pushl $0
c010296e:	6a 00                	push   $0x0
  pushl $60
c0102970:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102972:	e9 c0 fd ff ff       	jmp    c0102737 <__alltraps>

c0102977 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102977:	6a 00                	push   $0x0
  pushl $61
c0102979:	6a 3d                	push   $0x3d
  jmp __alltraps
c010297b:	e9 b7 fd ff ff       	jmp    c0102737 <__alltraps>

c0102980 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102980:	6a 00                	push   $0x0
  pushl $62
c0102982:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102984:	e9 ae fd ff ff       	jmp    c0102737 <__alltraps>

c0102989 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102989:	6a 00                	push   $0x0
  pushl $63
c010298b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010298d:	e9 a5 fd ff ff       	jmp    c0102737 <__alltraps>

c0102992 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $64
c0102994:	6a 40                	push   $0x40
  jmp __alltraps
c0102996:	e9 9c fd ff ff       	jmp    c0102737 <__alltraps>

c010299b <vector65>:
.globl vector65
vector65:
  pushl $0
c010299b:	6a 00                	push   $0x0
  pushl $65
c010299d:	6a 41                	push   $0x41
  jmp __alltraps
c010299f:	e9 93 fd ff ff       	jmp    c0102737 <__alltraps>

c01029a4 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029a4:	6a 00                	push   $0x0
  pushl $66
c01029a6:	6a 42                	push   $0x42
  jmp __alltraps
c01029a8:	e9 8a fd ff ff       	jmp    c0102737 <__alltraps>

c01029ad <vector67>:
.globl vector67
vector67:
  pushl $0
c01029ad:	6a 00                	push   $0x0
  pushl $67
c01029af:	6a 43                	push   $0x43
  jmp __alltraps
c01029b1:	e9 81 fd ff ff       	jmp    c0102737 <__alltraps>

c01029b6 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $68
c01029b8:	6a 44                	push   $0x44
  jmp __alltraps
c01029ba:	e9 78 fd ff ff       	jmp    c0102737 <__alltraps>

c01029bf <vector69>:
.globl vector69
vector69:
  pushl $0
c01029bf:	6a 00                	push   $0x0
  pushl $69
c01029c1:	6a 45                	push   $0x45
  jmp __alltraps
c01029c3:	e9 6f fd ff ff       	jmp    c0102737 <__alltraps>

c01029c8 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029c8:	6a 00                	push   $0x0
  pushl $70
c01029ca:	6a 46                	push   $0x46
  jmp __alltraps
c01029cc:	e9 66 fd ff ff       	jmp    c0102737 <__alltraps>

c01029d1 <vector71>:
.globl vector71
vector71:
  pushl $0
c01029d1:	6a 00                	push   $0x0
  pushl $71
c01029d3:	6a 47                	push   $0x47
  jmp __alltraps
c01029d5:	e9 5d fd ff ff       	jmp    c0102737 <__alltraps>

c01029da <vector72>:
.globl vector72
vector72:
  pushl $0
c01029da:	6a 00                	push   $0x0
  pushl $72
c01029dc:	6a 48                	push   $0x48
  jmp __alltraps
c01029de:	e9 54 fd ff ff       	jmp    c0102737 <__alltraps>

c01029e3 <vector73>:
.globl vector73
vector73:
  pushl $0
c01029e3:	6a 00                	push   $0x0
  pushl $73
c01029e5:	6a 49                	push   $0x49
  jmp __alltraps
c01029e7:	e9 4b fd ff ff       	jmp    c0102737 <__alltraps>

c01029ec <vector74>:
.globl vector74
vector74:
  pushl $0
c01029ec:	6a 00                	push   $0x0
  pushl $74
c01029ee:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029f0:	e9 42 fd ff ff       	jmp    c0102737 <__alltraps>

c01029f5 <vector75>:
.globl vector75
vector75:
  pushl $0
c01029f5:	6a 00                	push   $0x0
  pushl $75
c01029f7:	6a 4b                	push   $0x4b
  jmp __alltraps
c01029f9:	e9 39 fd ff ff       	jmp    c0102737 <__alltraps>

c01029fe <vector76>:
.globl vector76
vector76:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $76
c0102a00:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a02:	e9 30 fd ff ff       	jmp    c0102737 <__alltraps>

c0102a07 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a07:	6a 00                	push   $0x0
  pushl $77
c0102a09:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a0b:	e9 27 fd ff ff       	jmp    c0102737 <__alltraps>

c0102a10 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a10:	6a 00                	push   $0x0
  pushl $78
c0102a12:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a14:	e9 1e fd ff ff       	jmp    c0102737 <__alltraps>

c0102a19 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a19:	6a 00                	push   $0x0
  pushl $79
c0102a1b:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a1d:	e9 15 fd ff ff       	jmp    c0102737 <__alltraps>

c0102a22 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $80
c0102a24:	6a 50                	push   $0x50
  jmp __alltraps
c0102a26:	e9 0c fd ff ff       	jmp    c0102737 <__alltraps>

c0102a2b <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a2b:	6a 00                	push   $0x0
  pushl $81
c0102a2d:	6a 51                	push   $0x51
  jmp __alltraps
c0102a2f:	e9 03 fd ff ff       	jmp    c0102737 <__alltraps>

c0102a34 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a34:	6a 00                	push   $0x0
  pushl $82
c0102a36:	6a 52                	push   $0x52
  jmp __alltraps
c0102a38:	e9 fa fc ff ff       	jmp    c0102737 <__alltraps>

c0102a3d <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a3d:	6a 00                	push   $0x0
  pushl $83
c0102a3f:	6a 53                	push   $0x53
  jmp __alltraps
c0102a41:	e9 f1 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a46 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $84
c0102a48:	6a 54                	push   $0x54
  jmp __alltraps
c0102a4a:	e9 e8 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a4f <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a4f:	6a 00                	push   $0x0
  pushl $85
c0102a51:	6a 55                	push   $0x55
  jmp __alltraps
c0102a53:	e9 df fc ff ff       	jmp    c0102737 <__alltraps>

c0102a58 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a58:	6a 00                	push   $0x0
  pushl $86
c0102a5a:	6a 56                	push   $0x56
  jmp __alltraps
c0102a5c:	e9 d6 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a61 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a61:	6a 00                	push   $0x0
  pushl $87
c0102a63:	6a 57                	push   $0x57
  jmp __alltraps
c0102a65:	e9 cd fc ff ff       	jmp    c0102737 <__alltraps>

c0102a6a <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $88
c0102a6c:	6a 58                	push   $0x58
  jmp __alltraps
c0102a6e:	e9 c4 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a73 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a73:	6a 00                	push   $0x0
  pushl $89
c0102a75:	6a 59                	push   $0x59
  jmp __alltraps
c0102a77:	e9 bb fc ff ff       	jmp    c0102737 <__alltraps>

c0102a7c <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a7c:	6a 00                	push   $0x0
  pushl $90
c0102a7e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a80:	e9 b2 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a85 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a85:	6a 00                	push   $0x0
  pushl $91
c0102a87:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a89:	e9 a9 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a8e <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $92
c0102a90:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102a92:	e9 a0 fc ff ff       	jmp    c0102737 <__alltraps>

c0102a97 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a97:	6a 00                	push   $0x0
  pushl $93
c0102a99:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a9b:	e9 97 fc ff ff       	jmp    c0102737 <__alltraps>

c0102aa0 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102aa0:	6a 00                	push   $0x0
  pushl $94
c0102aa2:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102aa4:	e9 8e fc ff ff       	jmp    c0102737 <__alltraps>

c0102aa9 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102aa9:	6a 00                	push   $0x0
  pushl $95
c0102aab:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102aad:	e9 85 fc ff ff       	jmp    c0102737 <__alltraps>

c0102ab2 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ab2:	6a 00                	push   $0x0
  pushl $96
c0102ab4:	6a 60                	push   $0x60
  jmp __alltraps
c0102ab6:	e9 7c fc ff ff       	jmp    c0102737 <__alltraps>

c0102abb <vector97>:
.globl vector97
vector97:
  pushl $0
c0102abb:	6a 00                	push   $0x0
  pushl $97
c0102abd:	6a 61                	push   $0x61
  jmp __alltraps
c0102abf:	e9 73 fc ff ff       	jmp    c0102737 <__alltraps>

c0102ac4 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ac4:	6a 00                	push   $0x0
  pushl $98
c0102ac6:	6a 62                	push   $0x62
  jmp __alltraps
c0102ac8:	e9 6a fc ff ff       	jmp    c0102737 <__alltraps>

c0102acd <vector99>:
.globl vector99
vector99:
  pushl $0
c0102acd:	6a 00                	push   $0x0
  pushl $99
c0102acf:	6a 63                	push   $0x63
  jmp __alltraps
c0102ad1:	e9 61 fc ff ff       	jmp    c0102737 <__alltraps>

c0102ad6 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ad6:	6a 00                	push   $0x0
  pushl $100
c0102ad8:	6a 64                	push   $0x64
  jmp __alltraps
c0102ada:	e9 58 fc ff ff       	jmp    c0102737 <__alltraps>

c0102adf <vector101>:
.globl vector101
vector101:
  pushl $0
c0102adf:	6a 00                	push   $0x0
  pushl $101
c0102ae1:	6a 65                	push   $0x65
  jmp __alltraps
c0102ae3:	e9 4f fc ff ff       	jmp    c0102737 <__alltraps>

c0102ae8 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ae8:	6a 00                	push   $0x0
  pushl $102
c0102aea:	6a 66                	push   $0x66
  jmp __alltraps
c0102aec:	e9 46 fc ff ff       	jmp    c0102737 <__alltraps>

c0102af1 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102af1:	6a 00                	push   $0x0
  pushl $103
c0102af3:	6a 67                	push   $0x67
  jmp __alltraps
c0102af5:	e9 3d fc ff ff       	jmp    c0102737 <__alltraps>

c0102afa <vector104>:
.globl vector104
vector104:
  pushl $0
c0102afa:	6a 00                	push   $0x0
  pushl $104
c0102afc:	6a 68                	push   $0x68
  jmp __alltraps
c0102afe:	e9 34 fc ff ff       	jmp    c0102737 <__alltraps>

c0102b03 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b03:	6a 00                	push   $0x0
  pushl $105
c0102b05:	6a 69                	push   $0x69
  jmp __alltraps
c0102b07:	e9 2b fc ff ff       	jmp    c0102737 <__alltraps>

c0102b0c <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b0c:	6a 00                	push   $0x0
  pushl $106
c0102b0e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b10:	e9 22 fc ff ff       	jmp    c0102737 <__alltraps>

c0102b15 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b15:	6a 00                	push   $0x0
  pushl $107
c0102b17:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b19:	e9 19 fc ff ff       	jmp    c0102737 <__alltraps>

c0102b1e <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b1e:	6a 00                	push   $0x0
  pushl $108
c0102b20:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b22:	e9 10 fc ff ff       	jmp    c0102737 <__alltraps>

c0102b27 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b27:	6a 00                	push   $0x0
  pushl $109
c0102b29:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b2b:	e9 07 fc ff ff       	jmp    c0102737 <__alltraps>

c0102b30 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b30:	6a 00                	push   $0x0
  pushl $110
c0102b32:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b34:	e9 fe fb ff ff       	jmp    c0102737 <__alltraps>

c0102b39 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b39:	6a 00                	push   $0x0
  pushl $111
c0102b3b:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b3d:	e9 f5 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b42 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b42:	6a 00                	push   $0x0
  pushl $112
c0102b44:	6a 70                	push   $0x70
  jmp __alltraps
c0102b46:	e9 ec fb ff ff       	jmp    c0102737 <__alltraps>

c0102b4b <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b4b:	6a 00                	push   $0x0
  pushl $113
c0102b4d:	6a 71                	push   $0x71
  jmp __alltraps
c0102b4f:	e9 e3 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b54 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b54:	6a 00                	push   $0x0
  pushl $114
c0102b56:	6a 72                	push   $0x72
  jmp __alltraps
c0102b58:	e9 da fb ff ff       	jmp    c0102737 <__alltraps>

c0102b5d <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b5d:	6a 00                	push   $0x0
  pushl $115
c0102b5f:	6a 73                	push   $0x73
  jmp __alltraps
c0102b61:	e9 d1 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b66 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b66:	6a 00                	push   $0x0
  pushl $116
c0102b68:	6a 74                	push   $0x74
  jmp __alltraps
c0102b6a:	e9 c8 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b6f <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b6f:	6a 00                	push   $0x0
  pushl $117
c0102b71:	6a 75                	push   $0x75
  jmp __alltraps
c0102b73:	e9 bf fb ff ff       	jmp    c0102737 <__alltraps>

c0102b78 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b78:	6a 00                	push   $0x0
  pushl $118
c0102b7a:	6a 76                	push   $0x76
  jmp __alltraps
c0102b7c:	e9 b6 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b81 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b81:	6a 00                	push   $0x0
  pushl $119
c0102b83:	6a 77                	push   $0x77
  jmp __alltraps
c0102b85:	e9 ad fb ff ff       	jmp    c0102737 <__alltraps>

c0102b8a <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b8a:	6a 00                	push   $0x0
  pushl $120
c0102b8c:	6a 78                	push   $0x78
  jmp __alltraps
c0102b8e:	e9 a4 fb ff ff       	jmp    c0102737 <__alltraps>

c0102b93 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b93:	6a 00                	push   $0x0
  pushl $121
c0102b95:	6a 79                	push   $0x79
  jmp __alltraps
c0102b97:	e9 9b fb ff ff       	jmp    c0102737 <__alltraps>

c0102b9c <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b9c:	6a 00                	push   $0x0
  pushl $122
c0102b9e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102ba0:	e9 92 fb ff ff       	jmp    c0102737 <__alltraps>

c0102ba5 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102ba5:	6a 00                	push   $0x0
  pushl $123
c0102ba7:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102ba9:	e9 89 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bae <vector124>:
.globl vector124
vector124:
  pushl $0
c0102bae:	6a 00                	push   $0x0
  pushl $124
c0102bb0:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bb2:	e9 80 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bb7 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102bb7:	6a 00                	push   $0x0
  pushl $125
c0102bb9:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bbb:	e9 77 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bc0 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bc0:	6a 00                	push   $0x0
  pushl $126
c0102bc2:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bc4:	e9 6e fb ff ff       	jmp    c0102737 <__alltraps>

c0102bc9 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bc9:	6a 00                	push   $0x0
  pushl $127
c0102bcb:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bcd:	e9 65 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bd2 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102bd2:	6a 00                	push   $0x0
  pushl $128
c0102bd4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102bd9:	e9 59 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bde <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $129
c0102be0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102be5:	e9 4d fb ff ff       	jmp    c0102737 <__alltraps>

c0102bea <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $130
c0102bec:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102bf1:	e9 41 fb ff ff       	jmp    c0102737 <__alltraps>

c0102bf6 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102bf6:	6a 00                	push   $0x0
  pushl $131
c0102bf8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102bfd:	e9 35 fb ff ff       	jmp    c0102737 <__alltraps>

c0102c02 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $132
c0102c04:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c09:	e9 29 fb ff ff       	jmp    c0102737 <__alltraps>

c0102c0e <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $133
c0102c10:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c15:	e9 1d fb ff ff       	jmp    c0102737 <__alltraps>

c0102c1a <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c1a:	6a 00                	push   $0x0
  pushl $134
c0102c1c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c21:	e9 11 fb ff ff       	jmp    c0102737 <__alltraps>

c0102c26 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c26:	6a 00                	push   $0x0
  pushl $135
c0102c28:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c2d:	e9 05 fb ff ff       	jmp    c0102737 <__alltraps>

c0102c32 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $136
c0102c34:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c39:	e9 f9 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c3e <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c3e:	6a 00                	push   $0x0
  pushl $137
c0102c40:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c45:	e9 ed fa ff ff       	jmp    c0102737 <__alltraps>

c0102c4a <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c4a:	6a 00                	push   $0x0
  pushl $138
c0102c4c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c51:	e9 e1 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c56 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $139
c0102c58:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c5d:	e9 d5 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c62 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c62:	6a 00                	push   $0x0
  pushl $140
c0102c64:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c69:	e9 c9 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c6e <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c6e:	6a 00                	push   $0x0
  pushl $141
c0102c70:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c75:	e9 bd fa ff ff       	jmp    c0102737 <__alltraps>

c0102c7a <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $142
c0102c7c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c81:	e9 b1 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c86 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c86:	6a 00                	push   $0x0
  pushl $143
c0102c88:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c8d:	e9 a5 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c92 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102c92:	6a 00                	push   $0x0
  pushl $144
c0102c94:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c99:	e9 99 fa ff ff       	jmp    c0102737 <__alltraps>

c0102c9e <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $145
c0102ca0:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102ca5:	e9 8d fa ff ff       	jmp    c0102737 <__alltraps>

c0102caa <vector146>:
.globl vector146
vector146:
  pushl $0
c0102caa:	6a 00                	push   $0x0
  pushl $146
c0102cac:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cb1:	e9 81 fa ff ff       	jmp    c0102737 <__alltraps>

c0102cb6 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102cb6:	6a 00                	push   $0x0
  pushl $147
c0102cb8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cbd:	e9 75 fa ff ff       	jmp    c0102737 <__alltraps>

c0102cc2 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $148
c0102cc4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cc9:	e9 69 fa ff ff       	jmp    c0102737 <__alltraps>

c0102cce <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cce:	6a 00                	push   $0x0
  pushl $149
c0102cd0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102cd5:	e9 5d fa ff ff       	jmp    c0102737 <__alltraps>

c0102cda <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cda:	6a 00                	push   $0x0
  pushl $150
c0102cdc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102ce1:	e9 51 fa ff ff       	jmp    c0102737 <__alltraps>

c0102ce6 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102ce6:	6a 00                	push   $0x0
  pushl $151
c0102ce8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102ced:	e9 45 fa ff ff       	jmp    c0102737 <__alltraps>

c0102cf2 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102cf2:	6a 00                	push   $0x0
  pushl $152
c0102cf4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102cf9:	e9 39 fa ff ff       	jmp    c0102737 <__alltraps>

c0102cfe <vector153>:
.globl vector153
vector153:
  pushl $0
c0102cfe:	6a 00                	push   $0x0
  pushl $153
c0102d00:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d05:	e9 2d fa ff ff       	jmp    c0102737 <__alltraps>

c0102d0a <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d0a:	6a 00                	push   $0x0
  pushl $154
c0102d0c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d11:	e9 21 fa ff ff       	jmp    c0102737 <__alltraps>

c0102d16 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d16:	6a 00                	push   $0x0
  pushl $155
c0102d18:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d1d:	e9 15 fa ff ff       	jmp    c0102737 <__alltraps>

c0102d22 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d22:	6a 00                	push   $0x0
  pushl $156
c0102d24:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d29:	e9 09 fa ff ff       	jmp    c0102737 <__alltraps>

c0102d2e <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d2e:	6a 00                	push   $0x0
  pushl $157
c0102d30:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d35:	e9 fd f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d3a <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d3a:	6a 00                	push   $0x0
  pushl $158
c0102d3c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d41:	e9 f1 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d46 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d46:	6a 00                	push   $0x0
  pushl $159
c0102d48:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d4d:	e9 e5 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d52 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d52:	6a 00                	push   $0x0
  pushl $160
c0102d54:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d59:	e9 d9 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d5e <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d5e:	6a 00                	push   $0x0
  pushl $161
c0102d60:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d65:	e9 cd f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d6a <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d6a:	6a 00                	push   $0x0
  pushl $162
c0102d6c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d71:	e9 c1 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d76 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d76:	6a 00                	push   $0x0
  pushl $163
c0102d78:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d7d:	e9 b5 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d82 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d82:	6a 00                	push   $0x0
  pushl $164
c0102d84:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d89:	e9 a9 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d8e <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d8e:	6a 00                	push   $0x0
  pushl $165
c0102d90:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d95:	e9 9d f9 ff ff       	jmp    c0102737 <__alltraps>

c0102d9a <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d9a:	6a 00                	push   $0x0
  pushl $166
c0102d9c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102da1:	e9 91 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102da6 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102da6:	6a 00                	push   $0x0
  pushl $167
c0102da8:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102dad:	e9 85 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102db2 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102db2:	6a 00                	push   $0x0
  pushl $168
c0102db4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102db9:	e9 79 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102dbe <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dbe:	6a 00                	push   $0x0
  pushl $169
c0102dc0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102dc5:	e9 6d f9 ff ff       	jmp    c0102737 <__alltraps>

c0102dca <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dca:	6a 00                	push   $0x0
  pushl $170
c0102dcc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102dd1:	e9 61 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102dd6 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102dd6:	6a 00                	push   $0x0
  pushl $171
c0102dd8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102ddd:	e9 55 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102de2 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102de2:	6a 00                	push   $0x0
  pushl $172
c0102de4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102de9:	e9 49 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102dee <vector173>:
.globl vector173
vector173:
  pushl $0
c0102dee:	6a 00                	push   $0x0
  pushl $173
c0102df0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102df5:	e9 3d f9 ff ff       	jmp    c0102737 <__alltraps>

c0102dfa <vector174>:
.globl vector174
vector174:
  pushl $0
c0102dfa:	6a 00                	push   $0x0
  pushl $174
c0102dfc:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e01:	e9 31 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102e06 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e06:	6a 00                	push   $0x0
  pushl $175
c0102e08:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e0d:	e9 25 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102e12 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e12:	6a 00                	push   $0x0
  pushl $176
c0102e14:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e19:	e9 19 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102e1e <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e1e:	6a 00                	push   $0x0
  pushl $177
c0102e20:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e25:	e9 0d f9 ff ff       	jmp    c0102737 <__alltraps>

c0102e2a <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e2a:	6a 00                	push   $0x0
  pushl $178
c0102e2c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e31:	e9 01 f9 ff ff       	jmp    c0102737 <__alltraps>

c0102e36 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e36:	6a 00                	push   $0x0
  pushl $179
c0102e38:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e3d:	e9 f5 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e42 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e42:	6a 00                	push   $0x0
  pushl $180
c0102e44:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e49:	e9 e9 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e4e <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e4e:	6a 00                	push   $0x0
  pushl $181
c0102e50:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e55:	e9 dd f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e5a <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e5a:	6a 00                	push   $0x0
  pushl $182
c0102e5c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e61:	e9 d1 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e66 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e66:	6a 00                	push   $0x0
  pushl $183
c0102e68:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e6d:	e9 c5 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e72 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e72:	6a 00                	push   $0x0
  pushl $184
c0102e74:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e79:	e9 b9 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e7e <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e7e:	6a 00                	push   $0x0
  pushl $185
c0102e80:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e85:	e9 ad f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e8a <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e8a:	6a 00                	push   $0x0
  pushl $186
c0102e8c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e91:	e9 a1 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102e96 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e96:	6a 00                	push   $0x0
  pushl $187
c0102e98:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e9d:	e9 95 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102ea2 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102ea2:	6a 00                	push   $0x0
  pushl $188
c0102ea4:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102ea9:	e9 89 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102eae <vector189>:
.globl vector189
vector189:
  pushl $0
c0102eae:	6a 00                	push   $0x0
  pushl $189
c0102eb0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102eb5:	e9 7d f8 ff ff       	jmp    c0102737 <__alltraps>

c0102eba <vector190>:
.globl vector190
vector190:
  pushl $0
c0102eba:	6a 00                	push   $0x0
  pushl $190
c0102ebc:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ec1:	e9 71 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102ec6 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ec6:	6a 00                	push   $0x0
  pushl $191
c0102ec8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102ecd:	e9 65 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102ed2 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ed2:	6a 00                	push   $0x0
  pushl $192
c0102ed4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ed9:	e9 59 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102ede <vector193>:
.globl vector193
vector193:
  pushl $0
c0102ede:	6a 00                	push   $0x0
  pushl $193
c0102ee0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ee5:	e9 4d f8 ff ff       	jmp    c0102737 <__alltraps>

c0102eea <vector194>:
.globl vector194
vector194:
  pushl $0
c0102eea:	6a 00                	push   $0x0
  pushl $194
c0102eec:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102ef1:	e9 41 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102ef6 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102ef6:	6a 00                	push   $0x0
  pushl $195
c0102ef8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102efd:	e9 35 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102f02 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f02:	6a 00                	push   $0x0
  pushl $196
c0102f04:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f09:	e9 29 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102f0e <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f0e:	6a 00                	push   $0x0
  pushl $197
c0102f10:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f15:	e9 1d f8 ff ff       	jmp    c0102737 <__alltraps>

c0102f1a <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f1a:	6a 00                	push   $0x0
  pushl $198
c0102f1c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f21:	e9 11 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102f26 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f26:	6a 00                	push   $0x0
  pushl $199
c0102f28:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f2d:	e9 05 f8 ff ff       	jmp    c0102737 <__alltraps>

c0102f32 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f32:	6a 00                	push   $0x0
  pushl $200
c0102f34:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f39:	e9 f9 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f3e <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f3e:	6a 00                	push   $0x0
  pushl $201
c0102f40:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f45:	e9 ed f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f4a <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f4a:	6a 00                	push   $0x0
  pushl $202
c0102f4c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f51:	e9 e1 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f56 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f56:	6a 00                	push   $0x0
  pushl $203
c0102f58:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f5d:	e9 d5 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f62 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f62:	6a 00                	push   $0x0
  pushl $204
c0102f64:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f69:	e9 c9 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f6e <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f6e:	6a 00                	push   $0x0
  pushl $205
c0102f70:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f75:	e9 bd f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f7a <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f7a:	6a 00                	push   $0x0
  pushl $206
c0102f7c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f81:	e9 b1 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f86 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f86:	6a 00                	push   $0x0
  pushl $207
c0102f88:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f8d:	e9 a5 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f92 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102f92:	6a 00                	push   $0x0
  pushl $208
c0102f94:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f99:	e9 99 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102f9e <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f9e:	6a 00                	push   $0x0
  pushl $209
c0102fa0:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fa5:	e9 8d f7 ff ff       	jmp    c0102737 <__alltraps>

c0102faa <vector210>:
.globl vector210
vector210:
  pushl $0
c0102faa:	6a 00                	push   $0x0
  pushl $210
c0102fac:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fb1:	e9 81 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102fb6 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fb6:	6a 00                	push   $0x0
  pushl $211
c0102fb8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fbd:	e9 75 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102fc2 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fc2:	6a 00                	push   $0x0
  pushl $212
c0102fc4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fc9:	e9 69 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102fce <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fce:	6a 00                	push   $0x0
  pushl $213
c0102fd0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fd5:	e9 5d f7 ff ff       	jmp    c0102737 <__alltraps>

c0102fda <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fda:	6a 00                	push   $0x0
  pushl $214
c0102fdc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fe1:	e9 51 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102fe6 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102fe6:	6a 00                	push   $0x0
  pushl $215
c0102fe8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102fed:	e9 45 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102ff2 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102ff2:	6a 00                	push   $0x0
  pushl $216
c0102ff4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102ff9:	e9 39 f7 ff ff       	jmp    c0102737 <__alltraps>

c0102ffe <vector217>:
.globl vector217
vector217:
  pushl $0
c0102ffe:	6a 00                	push   $0x0
  pushl $217
c0103000:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103005:	e9 2d f7 ff ff       	jmp    c0102737 <__alltraps>

c010300a <vector218>:
.globl vector218
vector218:
  pushl $0
c010300a:	6a 00                	push   $0x0
  pushl $218
c010300c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103011:	e9 21 f7 ff ff       	jmp    c0102737 <__alltraps>

c0103016 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103016:	6a 00                	push   $0x0
  pushl $219
c0103018:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010301d:	e9 15 f7 ff ff       	jmp    c0102737 <__alltraps>

c0103022 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103022:	6a 00                	push   $0x0
  pushl $220
c0103024:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103029:	e9 09 f7 ff ff       	jmp    c0102737 <__alltraps>

c010302e <vector221>:
.globl vector221
vector221:
  pushl $0
c010302e:	6a 00                	push   $0x0
  pushl $221
c0103030:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103035:	e9 fd f6 ff ff       	jmp    c0102737 <__alltraps>

c010303a <vector222>:
.globl vector222
vector222:
  pushl $0
c010303a:	6a 00                	push   $0x0
  pushl $222
c010303c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103041:	e9 f1 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103046 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103046:	6a 00                	push   $0x0
  pushl $223
c0103048:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010304d:	e9 e5 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103052 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103052:	6a 00                	push   $0x0
  pushl $224
c0103054:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103059:	e9 d9 f6 ff ff       	jmp    c0102737 <__alltraps>

c010305e <vector225>:
.globl vector225
vector225:
  pushl $0
c010305e:	6a 00                	push   $0x0
  pushl $225
c0103060:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103065:	e9 cd f6 ff ff       	jmp    c0102737 <__alltraps>

c010306a <vector226>:
.globl vector226
vector226:
  pushl $0
c010306a:	6a 00                	push   $0x0
  pushl $226
c010306c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103071:	e9 c1 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103076 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103076:	6a 00                	push   $0x0
  pushl $227
c0103078:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010307d:	e9 b5 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103082 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103082:	6a 00                	push   $0x0
  pushl $228
c0103084:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103089:	e9 a9 f6 ff ff       	jmp    c0102737 <__alltraps>

c010308e <vector229>:
.globl vector229
vector229:
  pushl $0
c010308e:	6a 00                	push   $0x0
  pushl $229
c0103090:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103095:	e9 9d f6 ff ff       	jmp    c0102737 <__alltraps>

c010309a <vector230>:
.globl vector230
vector230:
  pushl $0
c010309a:	6a 00                	push   $0x0
  pushl $230
c010309c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030a1:	e9 91 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030a6 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030a6:	6a 00                	push   $0x0
  pushl $231
c01030a8:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030ad:	e9 85 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030b2 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030b2:	6a 00                	push   $0x0
  pushl $232
c01030b4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030b9:	e9 79 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030be <vector233>:
.globl vector233
vector233:
  pushl $0
c01030be:	6a 00                	push   $0x0
  pushl $233
c01030c0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030c5:	e9 6d f6 ff ff       	jmp    c0102737 <__alltraps>

c01030ca <vector234>:
.globl vector234
vector234:
  pushl $0
c01030ca:	6a 00                	push   $0x0
  pushl $234
c01030cc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030d1:	e9 61 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030d6 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030d6:	6a 00                	push   $0x0
  pushl $235
c01030d8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030dd:	e9 55 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030e2 <vector236>:
.globl vector236
vector236:
  pushl $0
c01030e2:	6a 00                	push   $0x0
  pushl $236
c01030e4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030e9:	e9 49 f6 ff ff       	jmp    c0102737 <__alltraps>

c01030ee <vector237>:
.globl vector237
vector237:
  pushl $0
c01030ee:	6a 00                	push   $0x0
  pushl $237
c01030f0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01030f5:	e9 3d f6 ff ff       	jmp    c0102737 <__alltraps>

c01030fa <vector238>:
.globl vector238
vector238:
  pushl $0
c01030fa:	6a 00                	push   $0x0
  pushl $238
c01030fc:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103101:	e9 31 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103106 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103106:	6a 00                	push   $0x0
  pushl $239
c0103108:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010310d:	e9 25 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103112 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103112:	6a 00                	push   $0x0
  pushl $240
c0103114:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103119:	e9 19 f6 ff ff       	jmp    c0102737 <__alltraps>

c010311e <vector241>:
.globl vector241
vector241:
  pushl $0
c010311e:	6a 00                	push   $0x0
  pushl $241
c0103120:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103125:	e9 0d f6 ff ff       	jmp    c0102737 <__alltraps>

c010312a <vector242>:
.globl vector242
vector242:
  pushl $0
c010312a:	6a 00                	push   $0x0
  pushl $242
c010312c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103131:	e9 01 f6 ff ff       	jmp    c0102737 <__alltraps>

c0103136 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103136:	6a 00                	push   $0x0
  pushl $243
c0103138:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010313d:	e9 f5 f5 ff ff       	jmp    c0102737 <__alltraps>

c0103142 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103142:	6a 00                	push   $0x0
  pushl $244
c0103144:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103149:	e9 e9 f5 ff ff       	jmp    c0102737 <__alltraps>

c010314e <vector245>:
.globl vector245
vector245:
  pushl $0
c010314e:	6a 00                	push   $0x0
  pushl $245
c0103150:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103155:	e9 dd f5 ff ff       	jmp    c0102737 <__alltraps>

c010315a <vector246>:
.globl vector246
vector246:
  pushl $0
c010315a:	6a 00                	push   $0x0
  pushl $246
c010315c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103161:	e9 d1 f5 ff ff       	jmp    c0102737 <__alltraps>

c0103166 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103166:	6a 00                	push   $0x0
  pushl $247
c0103168:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010316d:	e9 c5 f5 ff ff       	jmp    c0102737 <__alltraps>

c0103172 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103172:	6a 00                	push   $0x0
  pushl $248
c0103174:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103179:	e9 b9 f5 ff ff       	jmp    c0102737 <__alltraps>

c010317e <vector249>:
.globl vector249
vector249:
  pushl $0
c010317e:	6a 00                	push   $0x0
  pushl $249
c0103180:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103185:	e9 ad f5 ff ff       	jmp    c0102737 <__alltraps>

c010318a <vector250>:
.globl vector250
vector250:
  pushl $0
c010318a:	6a 00                	push   $0x0
  pushl $250
c010318c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103191:	e9 a1 f5 ff ff       	jmp    c0102737 <__alltraps>

c0103196 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103196:	6a 00                	push   $0x0
  pushl $251
c0103198:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010319d:	e9 95 f5 ff ff       	jmp    c0102737 <__alltraps>

c01031a2 <vector252>:
.globl vector252
vector252:
  pushl $0
c01031a2:	6a 00                	push   $0x0
  pushl $252
c01031a4:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031a9:	e9 89 f5 ff ff       	jmp    c0102737 <__alltraps>

c01031ae <vector253>:
.globl vector253
vector253:
  pushl $0
c01031ae:	6a 00                	push   $0x0
  pushl $253
c01031b0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031b5:	e9 7d f5 ff ff       	jmp    c0102737 <__alltraps>

c01031ba <vector254>:
.globl vector254
vector254:
  pushl $0
c01031ba:	6a 00                	push   $0x0
  pushl $254
c01031bc:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031c1:	e9 71 f5 ff ff       	jmp    c0102737 <__alltraps>

c01031c6 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031c6:	6a 00                	push   $0x0
  pushl $255
c01031c8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031cd:	e9 65 f5 ff ff       	jmp    c0102737 <__alltraps>

c01031d2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01031d2:	55                   	push   %ebp
c01031d3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01031d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01031d8:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01031dd:	29 c2                	sub    %eax,%edx
c01031df:	89 d0                	mov    %edx,%eax
c01031e1:	c1 f8 05             	sar    $0x5,%eax
}
c01031e4:	5d                   	pop    %ebp
c01031e5:	c3                   	ret    

c01031e6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01031e6:	55                   	push   %ebp
c01031e7:	89 e5                	mov    %esp,%ebp
c01031e9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01031ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01031ef:	89 04 24             	mov    %eax,(%esp)
c01031f2:	e8 db ff ff ff       	call   c01031d2 <page2ppn>
c01031f7:	c1 e0 0c             	shl    $0xc,%eax
}
c01031fa:	c9                   	leave  
c01031fb:	c3                   	ret    

c01031fc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01031fc:	55                   	push   %ebp
c01031fd:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01031ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103202:	8b 00                	mov    (%eax),%eax
}
c0103204:	5d                   	pop    %ebp
c0103205:	c3                   	ret    

c0103206 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103206:	55                   	push   %ebp
c0103207:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103209:	8b 45 08             	mov    0x8(%ebp),%eax
c010320c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010320f:	89 10                	mov    %edx,(%eax)
}
c0103211:	5d                   	pop    %ebp
c0103212:	c3                   	ret    

c0103213 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103213:	55                   	push   %ebp
c0103214:	89 e5                	mov    %esp,%ebp
c0103216:	83 ec 10             	sub    $0x10,%esp
c0103219:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103220:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103223:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103226:	89 50 04             	mov    %edx,0x4(%eax)
c0103229:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010322c:	8b 50 04             	mov    0x4(%eax),%edx
c010322f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103232:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103234:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c010323b:	00 00 00 
}
c010323e:	c9                   	leave  
c010323f:	c3                   	ret    

c0103240 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103240:	55                   	push   %ebp
c0103241:	89 e5                	mov    %esp,%ebp
c0103243:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103246:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010324a:	75 24                	jne    c0103270 <default_init_memmap+0x30>
c010324c:	c7 44 24 0c 70 a5 10 	movl   $0xc010a570,0xc(%esp)
c0103253:	c0 
c0103254:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c010325b:	c0 
c010325c:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103263:	00 
c0103264:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c010326b:	e8 6d da ff ff       	call   c0100cdd <__panic>
    struct Page *p = base;
c0103270:	8b 45 08             	mov    0x8(%ebp),%eax
c0103273:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103276:	e9 dc 00 00 00       	jmp    c0103357 <default_init_memmap+0x117>
        assert(PageReserved(p));
c010327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010327e:	83 c0 04             	add    $0x4,%eax
c0103281:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103288:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010328b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010328e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103291:	0f a3 10             	bt     %edx,(%eax)
c0103294:	19 c0                	sbb    %eax,%eax
c0103296:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103299:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010329d:	0f 95 c0             	setne  %al
c01032a0:	0f b6 c0             	movzbl %al,%eax
c01032a3:	85 c0                	test   %eax,%eax
c01032a5:	75 24                	jne    c01032cb <default_init_memmap+0x8b>
c01032a7:	c7 44 24 0c a1 a5 10 	movl   $0xc010a5a1,0xc(%esp)
c01032ae:	c0 
c01032af:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01032b6:	c0 
c01032b7:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01032be:	00 
c01032bf:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01032c6:	e8 12 da ff ff       	call   c0100cdd <__panic>
        p->flags = 0;
c01032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032d8:	83 c0 04             	add    $0x4,%eax
c01032db:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01032e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01032e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032eb:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01032f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032ff:	00 
c0103300:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103303:	89 04 24             	mov    %eax,(%esp)
c0103306:	e8 fb fe ff ff       	call   c0103206 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c010330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010330e:	83 c0 0c             	add    $0xc,%eax
c0103311:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103318:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010331b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010331e:	8b 00                	mov    (%eax),%eax
c0103320:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103323:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103326:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103329:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010332c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010332f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103332:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103335:	89 10                	mov    %edx,(%eax)
c0103337:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010333a:	8b 10                	mov    (%eax),%edx
c010333c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010333f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103342:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103345:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103348:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010334b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010334e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103351:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103353:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103357:	8b 45 0c             	mov    0xc(%ebp),%eax
c010335a:	c1 e0 05             	shl    $0x5,%eax
c010335d:	89 c2                	mov    %eax,%edx
c010335f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103362:	01 d0                	add    %edx,%eax
c0103364:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103367:	0f 85 0e ff ff ff    	jne    c010327b <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c010336d:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103373:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103376:	01 d0                	add    %edx,%eax
c0103378:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    //first block
    base->property = n;
c010337d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103380:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103383:	89 50 08             	mov    %edx,0x8(%eax)
}
c0103386:	c9                   	leave  
c0103387:	c3                   	ret    

c0103388 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103388:	55                   	push   %ebp
c0103389:	89 e5                	mov    %esp,%ebp
c010338b:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010338e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103392:	75 24                	jne    c01033b8 <default_alloc_pages+0x30>
c0103394:	c7 44 24 0c 70 a5 10 	movl   $0xc010a570,0xc(%esp)
c010339b:	c0 
c010339c:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01033a3:	c0 
c01033a4:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c01033ab:	00 
c01033ac:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01033b3:	e8 25 d9 ff ff       	call   c0100cdd <__panic>
    if (n > nr_free) {
c01033b8:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01033bd:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033c0:	73 0a                	jae    c01033cc <default_alloc_pages+0x44>
        return NULL;
c01033c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01033c7:	e9 37 01 00 00       	jmp    c0103503 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c01033cc:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c01033d3:	e9 0a 01 00 00       	jmp    c01034e2 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c01033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033db:	83 e8 0c             	sub    $0xc,%eax
c01033de:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c01033e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e4:	8b 40 08             	mov    0x8(%eax),%eax
c01033e7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033ea:	0f 82 f2 00 00 00    	jb     c01034e2 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c01033f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01033f7:	eb 7c                	jmp    c0103475 <default_alloc_pages+0xed>
c01033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103402:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0103405:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c0103408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340b:	83 e8 0c             	sub    $0xc,%eax
c010340e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0103411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103414:	83 c0 04             	add    $0x4,%eax
c0103417:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010341e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103421:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103424:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103427:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c010342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010342d:	83 c0 04             	add    $0x4,%eax
c0103430:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103437:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010343a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010343d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103440:	0f b3 10             	btr    %edx,(%eax)
c0103443:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103446:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103449:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010344c:	8b 40 04             	mov    0x4(%eax),%eax
c010344f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103452:	8b 12                	mov    (%edx),%edx
c0103454:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103457:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010345a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010345d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103460:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103463:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103466:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103469:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c010346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010346e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0103471:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0103475:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103478:	3b 45 08             	cmp    0x8(%ebp),%eax
c010347b:	0f 82 78 ff ff ff    	jb     c01033f9 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0103481:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103484:	8b 40 08             	mov    0x8(%eax),%eax
c0103487:	3b 45 08             	cmp    0x8(%ebp),%eax
c010348a:	76 12                	jbe    c010349e <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c010348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010348f:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103495:	8b 40 08             	mov    0x8(%eax),%eax
c0103498:	2b 45 08             	sub    0x8(%ebp),%eax
c010349b:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c010349e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034a1:	83 c0 04             	add    $0x4,%eax
c01034a4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01034ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034b1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034b4:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c01034b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ba:	83 c0 04             	add    $0x4,%eax
c01034bd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01034c4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034c7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034ca:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034cd:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c01034d0:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01034d5:	2b 45 08             	sub    0x8(%ebp),%eax
c01034d8:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
        return p;
c01034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e0:	eb 21                	jmp    c0103503 <default_alloc_pages+0x17b>
c01034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034eb:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c01034ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034f1:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c01034f8:	0f 85 da fe ff ff    	jne    c01033d8 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c01034fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103503:	c9                   	leave  
c0103504:	c3                   	ret    

c0103505 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103505:	55                   	push   %ebp
c0103506:	89 e5                	mov    %esp,%ebp
c0103508:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010350b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010350f:	75 24                	jne    c0103535 <default_free_pages+0x30>
c0103511:	c7 44 24 0c 70 a5 10 	movl   $0xc010a570,0xc(%esp)
c0103518:	c0 
c0103519:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103520:	c0 
c0103521:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0103528:	00 
c0103529:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103530:	e8 a8 d7 ff ff       	call   c0100cdd <__panic>
    assert(PageReserved(base));
c0103535:	8b 45 08             	mov    0x8(%ebp),%eax
c0103538:	83 c0 04             	add    $0x4,%eax
c010353b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103542:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103545:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103548:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010354b:	0f a3 10             	bt     %edx,(%eax)
c010354e:	19 c0                	sbb    %eax,%eax
c0103550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103553:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103557:	0f 95 c0             	setne  %al
c010355a:	0f b6 c0             	movzbl %al,%eax
c010355d:	85 c0                	test   %eax,%eax
c010355f:	75 24                	jne    c0103585 <default_free_pages+0x80>
c0103561:	c7 44 24 0c b1 a5 10 	movl   $0xc010a5b1,0xc(%esp)
c0103568:	c0 
c0103569:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103570:	c0 
c0103571:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0103578:	00 
c0103579:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103580:	e8 58 d7 ff ff       	call   c0100cdd <__panic>

    list_entry_t *le = &free_list;
c0103585:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010358c:	eb 13                	jmp    c01035a1 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c010358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103591:	83 e8 0c             	sub    $0xc,%eax
c0103594:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0103597:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010359a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010359d:	76 02                	jbe    c01035a1 <default_free_pages+0x9c>
        break;
c010359f:	eb 18                	jmp    c01035b9 <default_free_pages+0xb4>
c01035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035aa:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c01035ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035b0:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c01035b7:	75 d5                	jne    c010358e <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01035b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01035bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035bf:	eb 4b                	jmp    c010360c <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c01035c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035c4:	8d 50 0c             	lea    0xc(%eax),%edx
c01035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035cd:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01035d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035d3:	8b 00                	mov    (%eax),%eax
c01035d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01035db:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01035de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01035e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035ea:	89 10                	mov    %edx,(%eax)
c01035ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035ef:	8b 10                	mov    (%eax),%edx
c01035f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035f4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035fa:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035fd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103603:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103606:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c0103608:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c010360c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010360f:	c1 e0 05             	shl    $0x5,%eax
c0103612:	89 c2                	mov    %eax,%edx
c0103614:	8b 45 08             	mov    0x8(%ebp),%eax
c0103617:	01 d0                	add    %edx,%eax
c0103619:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010361c:	77 a3                	ja     c01035c1 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010361e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103628:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010362f:	00 
c0103630:	8b 45 08             	mov    0x8(%ebp),%eax
c0103633:	89 04 24             	mov    %eax,(%esp)
c0103636:	e8 cb fb ff ff       	call   c0103206 <set_page_ref>
    ClearPageProperty(base);
c010363b:	8b 45 08             	mov    0x8(%ebp),%eax
c010363e:	83 c0 04             	add    $0x4,%eax
c0103641:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103648:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010364b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010364e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103651:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0103654:	8b 45 08             	mov    0x8(%ebp),%eax
c0103657:	83 c0 04             	add    $0x4,%eax
c010365a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103661:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103664:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103667:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010366a:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c010366d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103670:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103673:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0103676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103679:	83 e8 0c             	sub    $0xc,%eax
c010367c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c010367f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103682:	c1 e0 05             	shl    $0x5,%eax
c0103685:	89 c2                	mov    %eax,%edx
c0103687:	8b 45 08             	mov    0x8(%ebp),%eax
c010368a:	01 d0                	add    %edx,%eax
c010368c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010368f:	75 1e                	jne    c01036af <default_free_pages+0x1aa>
      base->property += p->property;
c0103691:	8b 45 08             	mov    0x8(%ebp),%eax
c0103694:	8b 50 08             	mov    0x8(%eax),%edx
c0103697:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010369a:	8b 40 08             	mov    0x8(%eax),%eax
c010369d:	01 c2                	add    %eax,%edx
c010369f:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a2:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c01036a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c01036af:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b2:	83 c0 0c             	add    $0xc,%eax
c01036b5:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01036b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036bb:	8b 00                	mov    (%eax),%eax
c01036bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c01036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c3:	83 e8 0c             	sub    $0xc,%eax
c01036c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c01036c9:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c01036d0:	74 57                	je     c0103729 <default_free_pages+0x224>
c01036d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d5:	83 e8 20             	sub    $0x20,%eax
c01036d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036db:	75 4c                	jne    c0103729 <default_free_pages+0x224>
      while(le!=&free_list){
c01036dd:	eb 41                	jmp    c0103720 <default_free_pages+0x21b>
        if(p->property){
c01036df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e2:	8b 40 08             	mov    0x8(%eax),%eax
c01036e5:	85 c0                	test   %eax,%eax
c01036e7:	74 20                	je     c0103709 <default_free_pages+0x204>
          p->property += base->property;
c01036e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ec:	8b 50 08             	mov    0x8(%eax),%edx
c01036ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f2:	8b 40 08             	mov    0x8(%eax),%eax
c01036f5:	01 c2                	add    %eax,%edx
c01036f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036fa:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c01036fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103700:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0103707:	eb 20                	jmp    c0103729 <default_free_pages+0x224>
c0103709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010370c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010370f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103712:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103714:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103717:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010371a:	83 e8 0c             	sub    $0xc,%eax
c010371d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0103720:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103727:	75 b6                	jne    c01036df <default_free_pages+0x1da>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0103729:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c010372f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103732:	01 d0                	add    %edx,%eax
c0103734:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    return ;
c0103739:	90                   	nop
}
c010373a:	c9                   	leave  
c010373b:	c3                   	ret    

c010373c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010373c:	55                   	push   %ebp
c010373d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010373f:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103744:	5d                   	pop    %ebp
c0103745:	c3                   	ret    

c0103746 <basic_check>:

static void
basic_check(void) {
c0103746:	55                   	push   %ebp
c0103747:	89 e5                	mov    %esp,%ebp
c0103749:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010374c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103753:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103756:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103759:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010375f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103766:	e8 c4 15 00 00       	call   c0104d2f <alloc_pages>
c010376b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010376e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103772:	75 24                	jne    c0103798 <basic_check+0x52>
c0103774:	c7 44 24 0c c4 a5 10 	movl   $0xc010a5c4,0xc(%esp)
c010377b:	c0 
c010377c:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103783:	c0 
c0103784:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c010378b:	00 
c010378c:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103793:	e8 45 d5 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103798:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010379f:	e8 8b 15 00 00       	call   c0104d2f <alloc_pages>
c01037a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037ab:	75 24                	jne    c01037d1 <basic_check+0x8b>
c01037ad:	c7 44 24 0c e0 a5 10 	movl   $0xc010a5e0,0xc(%esp)
c01037b4:	c0 
c01037b5:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01037bc:	c0 
c01037bd:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01037c4:	00 
c01037c5:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01037cc:	e8 0c d5 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01037d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037d8:	e8 52 15 00 00       	call   c0104d2f <alloc_pages>
c01037dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037e4:	75 24                	jne    c010380a <basic_check+0xc4>
c01037e6:	c7 44 24 0c fc a5 10 	movl   $0xc010a5fc,0xc(%esp)
c01037ed:	c0 
c01037ee:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01037f5:	c0 
c01037f6:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01037fd:	00 
c01037fe:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103805:	e8 d3 d4 ff ff       	call   c0100cdd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010380a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010380d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103810:	74 10                	je     c0103822 <basic_check+0xdc>
c0103812:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103815:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103818:	74 08                	je     c0103822 <basic_check+0xdc>
c010381a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010381d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103820:	75 24                	jne    c0103846 <basic_check+0x100>
c0103822:	c7 44 24 0c 18 a6 10 	movl   $0xc010a618,0xc(%esp)
c0103829:	c0 
c010382a:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103831:	c0 
c0103832:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103839:	00 
c010383a:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103841:	e8 97 d4 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103846:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103849:	89 04 24             	mov    %eax,(%esp)
c010384c:	e8 ab f9 ff ff       	call   c01031fc <page_ref>
c0103851:	85 c0                	test   %eax,%eax
c0103853:	75 1e                	jne    c0103873 <basic_check+0x12d>
c0103855:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103858:	89 04 24             	mov    %eax,(%esp)
c010385b:	e8 9c f9 ff ff       	call   c01031fc <page_ref>
c0103860:	85 c0                	test   %eax,%eax
c0103862:	75 0f                	jne    c0103873 <basic_check+0x12d>
c0103864:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103867:	89 04 24             	mov    %eax,(%esp)
c010386a:	e8 8d f9 ff ff       	call   c01031fc <page_ref>
c010386f:	85 c0                	test   %eax,%eax
c0103871:	74 24                	je     c0103897 <basic_check+0x151>
c0103873:	c7 44 24 0c 3c a6 10 	movl   $0xc010a63c,0xc(%esp)
c010387a:	c0 
c010387b:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103882:	c0 
c0103883:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010388a:	00 
c010388b:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103892:	e8 46 d4 ff ff       	call   c0100cdd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103897:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010389a:	89 04 24             	mov    %eax,(%esp)
c010389d:	e8 44 f9 ff ff       	call   c01031e6 <page2pa>
c01038a2:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038a8:	c1 e2 0c             	shl    $0xc,%edx
c01038ab:	39 d0                	cmp    %edx,%eax
c01038ad:	72 24                	jb     c01038d3 <basic_check+0x18d>
c01038af:	c7 44 24 0c 78 a6 10 	movl   $0xc010a678,0xc(%esp)
c01038b6:	c0 
c01038b7:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01038be:	c0 
c01038bf:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01038c6:	00 
c01038c7:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01038ce:	e8 0a d4 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01038d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d6:	89 04 24             	mov    %eax,(%esp)
c01038d9:	e8 08 f9 ff ff       	call   c01031e6 <page2pa>
c01038de:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038e4:	c1 e2 0c             	shl    $0xc,%edx
c01038e7:	39 d0                	cmp    %edx,%eax
c01038e9:	72 24                	jb     c010390f <basic_check+0x1c9>
c01038eb:	c7 44 24 0c 95 a6 10 	movl   $0xc010a695,0xc(%esp)
c01038f2:	c0 
c01038f3:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01038fa:	c0 
c01038fb:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103902:	00 
c0103903:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c010390a:	e8 ce d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103912:	89 04 24             	mov    %eax,(%esp)
c0103915:	e8 cc f8 ff ff       	call   c01031e6 <page2pa>
c010391a:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103920:	c1 e2 0c             	shl    $0xc,%edx
c0103923:	39 d0                	cmp    %edx,%eax
c0103925:	72 24                	jb     c010394b <basic_check+0x205>
c0103927:	c7 44 24 0c b2 a6 10 	movl   $0xc010a6b2,0xc(%esp)
c010392e:	c0 
c010392f:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103936:	c0 
c0103937:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c010393e:	00 
c010393f:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103946:	e8 92 d3 ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c010394b:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103950:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103956:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103959:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010395c:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103963:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103966:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103969:	89 50 04             	mov    %edx,0x4(%eax)
c010396c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010396f:	8b 50 04             	mov    0x4(%eax),%edx
c0103972:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103975:	89 10                	mov    %edx,(%eax)
c0103977:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010397e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103981:	8b 40 04             	mov    0x4(%eax),%eax
c0103984:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103987:	0f 94 c0             	sete   %al
c010398a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010398d:	85 c0                	test   %eax,%eax
c010398f:	75 24                	jne    c01039b5 <basic_check+0x26f>
c0103991:	c7 44 24 0c cf a6 10 	movl   $0xc010a6cf,0xc(%esp)
c0103998:	c0 
c0103999:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01039a0:	c0 
c01039a1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01039a8:	00 
c01039a9:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01039b0:	e8 28 d3 ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c01039b5:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01039ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01039bd:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c01039c4:	00 00 00 

    assert(alloc_page() == NULL);
c01039c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039ce:	e8 5c 13 00 00       	call   c0104d2f <alloc_pages>
c01039d3:	85 c0                	test   %eax,%eax
c01039d5:	74 24                	je     c01039fb <basic_check+0x2b5>
c01039d7:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c01039de:	c0 
c01039df:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01039e6:	c0 
c01039e7:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01039ee:	00 
c01039ef:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01039f6:	e8 e2 d2 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c01039fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a02:	00 
c0103a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a06:	89 04 24             	mov    %eax,(%esp)
c0103a09:	e8 8c 13 00 00       	call   c0104d9a <free_pages>
    free_page(p1);
c0103a0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a15:	00 
c0103a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a19:	89 04 24             	mov    %eax,(%esp)
c0103a1c:	e8 79 13 00 00       	call   c0104d9a <free_pages>
    free_page(p2);
c0103a21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a28:	00 
c0103a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a2c:	89 04 24             	mov    %eax,(%esp)
c0103a2f:	e8 66 13 00 00       	call   c0104d9a <free_pages>
    assert(nr_free == 3);
c0103a34:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103a39:	83 f8 03             	cmp    $0x3,%eax
c0103a3c:	74 24                	je     c0103a62 <basic_check+0x31c>
c0103a3e:	c7 44 24 0c fb a6 10 	movl   $0xc010a6fb,0xc(%esp)
c0103a45:	c0 
c0103a46:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103a4d:	c0 
c0103a4e:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103a55:	00 
c0103a56:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103a5d:	e8 7b d2 ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a69:	e8 c1 12 00 00       	call   c0104d2f <alloc_pages>
c0103a6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a75:	75 24                	jne    c0103a9b <basic_check+0x355>
c0103a77:	c7 44 24 0c c4 a5 10 	movl   $0xc010a5c4,0xc(%esp)
c0103a7e:	c0 
c0103a7f:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103a86:	c0 
c0103a87:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103a8e:	00 
c0103a8f:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103a96:	e8 42 d2 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aa2:	e8 88 12 00 00       	call   c0104d2f <alloc_pages>
c0103aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103aaa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aae:	75 24                	jne    c0103ad4 <basic_check+0x38e>
c0103ab0:	c7 44 24 0c e0 a5 10 	movl   $0xc010a5e0,0xc(%esp)
c0103ab7:	c0 
c0103ab8:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103abf:	c0 
c0103ac0:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103ac7:	00 
c0103ac8:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103acf:	e8 09 d2 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103adb:	e8 4f 12 00 00       	call   c0104d2f <alloc_pages>
c0103ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ae7:	75 24                	jne    c0103b0d <basic_check+0x3c7>
c0103ae9:	c7 44 24 0c fc a5 10 	movl   $0xc010a5fc,0xc(%esp)
c0103af0:	c0 
c0103af1:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103af8:	c0 
c0103af9:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103b00:	00 
c0103b01:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103b08:	e8 d0 d1 ff ff       	call   c0100cdd <__panic>

    assert(alloc_page() == NULL);
c0103b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b14:	e8 16 12 00 00       	call   c0104d2f <alloc_pages>
c0103b19:	85 c0                	test   %eax,%eax
c0103b1b:	74 24                	je     c0103b41 <basic_check+0x3fb>
c0103b1d:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103b2c:	c0 
c0103b2d:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103b34:	00 
c0103b35:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103b3c:	e8 9c d1 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103b41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b48:	00 
c0103b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b4c:	89 04 24             	mov    %eax,(%esp)
c0103b4f:	e8 46 12 00 00       	call   c0104d9a <free_pages>
c0103b54:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b5e:	8b 40 04             	mov    0x4(%eax),%eax
c0103b61:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b64:	0f 94 c0             	sete   %al
c0103b67:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b6a:	85 c0                	test   %eax,%eax
c0103b6c:	74 24                	je     c0103b92 <basic_check+0x44c>
c0103b6e:	c7 44 24 0c 08 a7 10 	movl   $0xc010a708,0xc(%esp)
c0103b75:	c0 
c0103b76:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103b7d:	c0 
c0103b7e:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103b85:	00 
c0103b86:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103b8d:	e8 4b d1 ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103b92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b99:	e8 91 11 00 00       	call   c0104d2f <alloc_pages>
c0103b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ba4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ba7:	74 24                	je     c0103bcd <basic_check+0x487>
c0103ba9:	c7 44 24 0c 20 a7 10 	movl   $0xc010a720,0xc(%esp)
c0103bb0:	c0 
c0103bb1:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103bb8:	c0 
c0103bb9:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103bc0:	00 
c0103bc1:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103bc8:	e8 10 d1 ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103bcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bd4:	e8 56 11 00 00       	call   c0104d2f <alloc_pages>
c0103bd9:	85 c0                	test   %eax,%eax
c0103bdb:	74 24                	je     c0103c01 <basic_check+0x4bb>
c0103bdd:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c0103be4:	c0 
c0103be5:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103bec:	c0 
c0103bed:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103bf4:	00 
c0103bf5:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103bfc:	e8 dc d0 ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0103c01:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103c06:	85 c0                	test   %eax,%eax
c0103c08:	74 24                	je     c0103c2e <basic_check+0x4e8>
c0103c0a:	c7 44 24 0c 39 a7 10 	movl   $0xc010a739,0xc(%esp)
c0103c11:	c0 
c0103c12:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103c19:	c0 
c0103c1a:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103c21:	00 
c0103c22:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103c29:	e8 af d0 ff ff       	call   c0100cdd <__panic>
    free_list = free_list_store;
c0103c2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c34:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103c39:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c42:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103c47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c4e:	00 
c0103c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c52:	89 04 24             	mov    %eax,(%esp)
c0103c55:	e8 40 11 00 00       	call   c0104d9a <free_pages>
    free_page(p1);
c0103c5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c61:	00 
c0103c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c65:	89 04 24             	mov    %eax,(%esp)
c0103c68:	e8 2d 11 00 00       	call   c0104d9a <free_pages>
    free_page(p2);
c0103c6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c74:	00 
c0103c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c78:	89 04 24             	mov    %eax,(%esp)
c0103c7b:	e8 1a 11 00 00       	call   c0104d9a <free_pages>
}
c0103c80:	c9                   	leave  
c0103c81:	c3                   	ret    

c0103c82 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103c82:	55                   	push   %ebp
c0103c83:	89 e5                	mov    %esp,%ebp
c0103c85:	53                   	push   %ebx
c0103c86:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103c9a:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ca1:	eb 6b                	jmp    c0103d0e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca6:	83 e8 0c             	sub    $0xc,%eax
c0103ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103caf:	83 c0 04             	add    $0x4,%eax
c0103cb2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103cb9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103cbf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103cc2:	0f a3 10             	bt     %edx,(%eax)
c0103cc5:	19 c0                	sbb    %eax,%eax
c0103cc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103cca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103cce:	0f 95 c0             	setne  %al
c0103cd1:	0f b6 c0             	movzbl %al,%eax
c0103cd4:	85 c0                	test   %eax,%eax
c0103cd6:	75 24                	jne    c0103cfc <default_check+0x7a>
c0103cd8:	c7 44 24 0c 46 a7 10 	movl   $0xc010a746,0xc(%esp)
c0103cdf:	c0 
c0103ce0:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103ce7:	c0 
c0103ce8:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103cef:	00 
c0103cf0:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103cf7:	e8 e1 cf ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0103cfc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d03:	8b 50 08             	mov    0x8(%eax),%edx
c0103d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d09:	01 d0                	add    %edx,%eax
c0103d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d14:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d17:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d1d:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103d24:	0f 85 79 ff ff ff    	jne    c0103ca3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d2a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d2d:	e8 9a 10 00 00       	call   c0104dcc <nr_free_pages>
c0103d32:	39 c3                	cmp    %eax,%ebx
c0103d34:	74 24                	je     c0103d5a <default_check+0xd8>
c0103d36:	c7 44 24 0c 56 a7 10 	movl   $0xc010a756,0xc(%esp)
c0103d3d:	c0 
c0103d3e:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103d4d:	00 
c0103d4e:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103d55:	e8 83 cf ff ff       	call   c0100cdd <__panic>

    basic_check();
c0103d5a:	e8 e7 f9 ff ff       	call   c0103746 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d5f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d66:	e8 c4 0f 00 00       	call   c0104d2f <alloc_pages>
c0103d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103d6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d72:	75 24                	jne    c0103d98 <default_check+0x116>
c0103d74:	c7 44 24 0c 6f a7 10 	movl   $0xc010a76f,0xc(%esp)
c0103d7b:	c0 
c0103d7c:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103d83:	c0 
c0103d84:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103d8b:	00 
c0103d8c:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103d93:	e8 45 cf ff ff       	call   c0100cdd <__panic>
    assert(!PageProperty(p0));
c0103d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d9b:	83 c0 04             	add    $0x4,%eax
c0103d9e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103da5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103da8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103dab:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103dae:	0f a3 10             	bt     %edx,(%eax)
c0103db1:	19 c0                	sbb    %eax,%eax
c0103db3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103db6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103dba:	0f 95 c0             	setne  %al
c0103dbd:	0f b6 c0             	movzbl %al,%eax
c0103dc0:	85 c0                	test   %eax,%eax
c0103dc2:	74 24                	je     c0103de8 <default_check+0x166>
c0103dc4:	c7 44 24 0c 7a a7 10 	movl   $0xc010a77a,0xc(%esp)
c0103dcb:	c0 
c0103dcc:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103dd3:	c0 
c0103dd4:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103ddb:	00 
c0103ddc:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103de3:	e8 f5 ce ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c0103de8:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103ded:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103df3:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103df6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103df9:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e03:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e06:	89 50 04             	mov    %edx,0x4(%eax)
c0103e09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e0c:	8b 50 04             	mov    0x4(%eax),%edx
c0103e0f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e12:	89 10                	mov    %edx,(%eax)
c0103e14:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e1e:	8b 40 04             	mov    0x4(%eax),%eax
c0103e21:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e24:	0f 94 c0             	sete   %al
c0103e27:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e2a:	85 c0                	test   %eax,%eax
c0103e2c:	75 24                	jne    c0103e52 <default_check+0x1d0>
c0103e2e:	c7 44 24 0c cf a6 10 	movl   $0xc010a6cf,0xc(%esp)
c0103e35:	c0 
c0103e36:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103e3d:	c0 
c0103e3e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103e45:	00 
c0103e46:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103e4d:	e8 8b ce ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103e52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e59:	e8 d1 0e 00 00       	call   c0104d2f <alloc_pages>
c0103e5e:	85 c0                	test   %eax,%eax
c0103e60:	74 24                	je     c0103e86 <default_check+0x204>
c0103e62:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c0103e69:	c0 
c0103e6a:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103e71:	c0 
c0103e72:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103e79:	00 
c0103e7a:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103e81:	e8 57 ce ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c0103e86:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103e8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103e8e:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103e95:	00 00 00 

    free_pages(p0 + 2, 3);
c0103e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e9b:	83 c0 40             	add    $0x40,%eax
c0103e9e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103ea5:	00 
c0103ea6:	89 04 24             	mov    %eax,(%esp)
c0103ea9:	e8 ec 0e 00 00       	call   c0104d9a <free_pages>
    assert(alloc_pages(4) == NULL);
c0103eae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103eb5:	e8 75 0e 00 00       	call   c0104d2f <alloc_pages>
c0103eba:	85 c0                	test   %eax,%eax
c0103ebc:	74 24                	je     c0103ee2 <default_check+0x260>
c0103ebe:	c7 44 24 0c 8c a7 10 	movl   $0xc010a78c,0xc(%esp)
c0103ec5:	c0 
c0103ec6:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103ecd:	c0 
c0103ece:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103ed5:	00 
c0103ed6:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103edd:	e8 fb cd ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ee5:	83 c0 40             	add    $0x40,%eax
c0103ee8:	83 c0 04             	add    $0x4,%eax
c0103eeb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103ef2:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ef5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ef8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103efb:	0f a3 10             	bt     %edx,(%eax)
c0103efe:	19 c0                	sbb    %eax,%eax
c0103f00:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103f03:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103f07:	0f 95 c0             	setne  %al
c0103f0a:	0f b6 c0             	movzbl %al,%eax
c0103f0d:	85 c0                	test   %eax,%eax
c0103f0f:	74 0e                	je     c0103f1f <default_check+0x29d>
c0103f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f14:	83 c0 40             	add    $0x40,%eax
c0103f17:	8b 40 08             	mov    0x8(%eax),%eax
c0103f1a:	83 f8 03             	cmp    $0x3,%eax
c0103f1d:	74 24                	je     c0103f43 <default_check+0x2c1>
c0103f1f:	c7 44 24 0c a4 a7 10 	movl   $0xc010a7a4,0xc(%esp)
c0103f26:	c0 
c0103f27:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103f2e:	c0 
c0103f2f:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103f36:	00 
c0103f37:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103f3e:	e8 9a cd ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f43:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f4a:	e8 e0 0d 00 00       	call   c0104d2f <alloc_pages>
c0103f4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f52:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f56:	75 24                	jne    c0103f7c <default_check+0x2fa>
c0103f58:	c7 44 24 0c d0 a7 10 	movl   $0xc010a7d0,0xc(%esp)
c0103f5f:	c0 
c0103f60:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103f67:	c0 
c0103f68:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103f6f:	00 
c0103f70:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103f77:	e8 61 cd ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103f7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f83:	e8 a7 0d 00 00       	call   c0104d2f <alloc_pages>
c0103f88:	85 c0                	test   %eax,%eax
c0103f8a:	74 24                	je     c0103fb0 <default_check+0x32e>
c0103f8c:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c0103f93:	c0 
c0103f94:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103f9b:	c0 
c0103f9c:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103fa3:	00 
c0103fa4:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103fab:	e8 2d cd ff ff       	call   c0100cdd <__panic>
    assert(p0 + 2 == p1);
c0103fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fb3:	83 c0 40             	add    $0x40,%eax
c0103fb6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103fb9:	74 24                	je     c0103fdf <default_check+0x35d>
c0103fbb:	c7 44 24 0c ee a7 10 	movl   $0xc010a7ee,0xc(%esp)
c0103fc2:	c0 
c0103fc3:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0103fca:	c0 
c0103fcb:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103fd2:	00 
c0103fd3:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0103fda:	e8 fe cc ff ff       	call   c0100cdd <__panic>

    p2 = p0 + 1;
c0103fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe2:	83 c0 20             	add    $0x20,%eax
c0103fe5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103fe8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fef:	00 
c0103ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ff3:	89 04 24             	mov    %eax,(%esp)
c0103ff6:	e8 9f 0d 00 00       	call   c0104d9a <free_pages>
    free_pages(p1, 3);
c0103ffb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104002:	00 
c0104003:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104006:	89 04 24             	mov    %eax,(%esp)
c0104009:	e8 8c 0d 00 00       	call   c0104d9a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010400e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104011:	83 c0 04             	add    $0x4,%eax
c0104014:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010401b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010401e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104021:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104024:	0f a3 10             	bt     %edx,(%eax)
c0104027:	19 c0                	sbb    %eax,%eax
c0104029:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010402c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104030:	0f 95 c0             	setne  %al
c0104033:	0f b6 c0             	movzbl %al,%eax
c0104036:	85 c0                	test   %eax,%eax
c0104038:	74 0b                	je     c0104045 <default_check+0x3c3>
c010403a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010403d:	8b 40 08             	mov    0x8(%eax),%eax
c0104040:	83 f8 01             	cmp    $0x1,%eax
c0104043:	74 24                	je     c0104069 <default_check+0x3e7>
c0104045:	c7 44 24 0c fc a7 10 	movl   $0xc010a7fc,0xc(%esp)
c010404c:	c0 
c010404d:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0104054:	c0 
c0104055:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010405c:	00 
c010405d:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c0104064:	e8 74 cc ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104069:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010406c:	83 c0 04             	add    $0x4,%eax
c010406f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104076:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104079:	8b 45 90             	mov    -0x70(%ebp),%eax
c010407c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010407f:	0f a3 10             	bt     %edx,(%eax)
c0104082:	19 c0                	sbb    %eax,%eax
c0104084:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104087:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010408b:	0f 95 c0             	setne  %al
c010408e:	0f b6 c0             	movzbl %al,%eax
c0104091:	85 c0                	test   %eax,%eax
c0104093:	74 0b                	je     c01040a0 <default_check+0x41e>
c0104095:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104098:	8b 40 08             	mov    0x8(%eax),%eax
c010409b:	83 f8 03             	cmp    $0x3,%eax
c010409e:	74 24                	je     c01040c4 <default_check+0x442>
c01040a0:	c7 44 24 0c 24 a8 10 	movl   $0xc010a824,0xc(%esp)
c01040a7:	c0 
c01040a8:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01040af:	c0 
c01040b0:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01040b7:	00 
c01040b8:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01040bf:	e8 19 cc ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01040c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040cb:	e8 5f 0c 00 00       	call   c0104d2f <alloc_pages>
c01040d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040d6:	83 e8 20             	sub    $0x20,%eax
c01040d9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040dc:	74 24                	je     c0104102 <default_check+0x480>
c01040de:	c7 44 24 0c 4a a8 10 	movl   $0xc010a84a,0xc(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01040ed:	c0 
c01040ee:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01040f5:	00 
c01040f6:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01040fd:	e8 db cb ff ff       	call   c0100cdd <__panic>
    free_page(p0);
c0104102:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104109:	00 
c010410a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010410d:	89 04 24             	mov    %eax,(%esp)
c0104110:	e8 85 0c 00 00       	call   c0104d9a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104115:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010411c:	e8 0e 0c 00 00       	call   c0104d2f <alloc_pages>
c0104121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104124:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104127:	83 c0 20             	add    $0x20,%eax
c010412a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010412d:	74 24                	je     c0104153 <default_check+0x4d1>
c010412f:	c7 44 24 0c 68 a8 10 	movl   $0xc010a868,0xc(%esp)
c0104136:	c0 
c0104137:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c010413e:	c0 
c010413f:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104146:	00 
c0104147:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c010414e:	e8 8a cb ff ff       	call   c0100cdd <__panic>

    free_pages(p0, 2);
c0104153:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010415a:	00 
c010415b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010415e:	89 04 24             	mov    %eax,(%esp)
c0104161:	e8 34 0c 00 00       	call   c0104d9a <free_pages>
    free_page(p2);
c0104166:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010416d:	00 
c010416e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104171:	89 04 24             	mov    %eax,(%esp)
c0104174:	e8 21 0c 00 00       	call   c0104d9a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104179:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104180:	e8 aa 0b 00 00       	call   c0104d2f <alloc_pages>
c0104185:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104188:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010418c:	75 24                	jne    c01041b2 <default_check+0x530>
c010418e:	c7 44 24 0c 88 a8 10 	movl   $0xc010a888,0xc(%esp)
c0104195:	c0 
c0104196:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c010419d:	c0 
c010419e:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01041a5:	00 
c01041a6:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01041ad:	e8 2b cb ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c01041b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041b9:	e8 71 0b 00 00       	call   c0104d2f <alloc_pages>
c01041be:	85 c0                	test   %eax,%eax
c01041c0:	74 24                	je     c01041e6 <default_check+0x564>
c01041c2:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c01041c9:	c0 
c01041ca:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01041d1:	c0 
c01041d2:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01041d9:	00 
c01041da:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01041e1:	e8 f7 ca ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c01041e6:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01041eb:	85 c0                	test   %eax,%eax
c01041ed:	74 24                	je     c0104213 <default_check+0x591>
c01041ef:	c7 44 24 0c 39 a7 10 	movl   $0xc010a739,0xc(%esp)
c01041f6:	c0 
c01041f7:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01041fe:	c0 
c01041ff:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104206:	00 
c0104207:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c010420e:	e8 ca ca ff ff       	call   c0100cdd <__panic>
    nr_free = nr_free_store;
c0104213:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104216:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c010421b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010421e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104221:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0104226:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c010422c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104233:	00 
c0104234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104237:	89 04 24             	mov    %eax,(%esp)
c010423a:	e8 5b 0b 00 00       	call   c0104d9a <free_pages>

    le = &free_list;
c010423f:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104246:	eb 1d                	jmp    c0104265 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104248:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010424b:	83 e8 0c             	sub    $0xc,%eax
c010424e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104251:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104255:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010425b:	8b 40 08             	mov    0x8(%eax),%eax
c010425e:	29 c2                	sub    %eax,%edx
c0104260:	89 d0                	mov    %edx,%eax
c0104262:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104265:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104268:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010426b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010426e:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104271:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104274:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c010427b:	75 cb                	jne    c0104248 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010427d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104281:	74 24                	je     c01042a7 <default_check+0x625>
c0104283:	c7 44 24 0c a6 a8 10 	movl   $0xc010a8a6,0xc(%esp)
c010428a:	c0 
c010428b:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c0104292:	c0 
c0104293:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010429a:	00 
c010429b:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01042a2:	e8 36 ca ff ff       	call   c0100cdd <__panic>
    assert(total == 0);
c01042a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042ab:	74 24                	je     c01042d1 <default_check+0x64f>
c01042ad:	c7 44 24 0c b1 a8 10 	movl   $0xc010a8b1,0xc(%esp)
c01042b4:	c0 
c01042b5:	c7 44 24 08 76 a5 10 	movl   $0xc010a576,0x8(%esp)
c01042bc:	c0 
c01042bd:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01042c4:	00 
c01042c5:	c7 04 24 8b a5 10 c0 	movl   $0xc010a58b,(%esp)
c01042cc:	e8 0c ca ff ff       	call   c0100cdd <__panic>
}
c01042d1:	81 c4 94 00 00 00    	add    $0x94,%esp
c01042d7:	5b                   	pop    %ebx
c01042d8:	5d                   	pop    %ebp
c01042d9:	c3                   	ret    

c01042da <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01042da:	55                   	push   %ebp
c01042db:	89 e5                	mov    %esp,%ebp
c01042dd:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01042e0:	9c                   	pushf  
c01042e1:	58                   	pop    %eax
c01042e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01042e8:	25 00 02 00 00       	and    $0x200,%eax
c01042ed:	85 c0                	test   %eax,%eax
c01042ef:	74 0c                	je     c01042fd <__intr_save+0x23>
        intr_disable();
c01042f1:	e8 3f dc ff ff       	call   c0101f35 <intr_disable>
        return 1;
c01042f6:	b8 01 00 00 00       	mov    $0x1,%eax
c01042fb:	eb 05                	jmp    c0104302 <__intr_save+0x28>
    }
    return 0;
c01042fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104302:	c9                   	leave  
c0104303:	c3                   	ret    

c0104304 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104304:	55                   	push   %ebp
c0104305:	89 e5                	mov    %esp,%ebp
c0104307:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010430a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010430e:	74 05                	je     c0104315 <__intr_restore+0x11>
        intr_enable();
c0104310:	e8 1a dc ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104315:	c9                   	leave  
c0104316:	c3                   	ret    

c0104317 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104317:	55                   	push   %ebp
c0104318:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010431a:	8b 55 08             	mov    0x8(%ebp),%edx
c010431d:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104322:	29 c2                	sub    %eax,%edx
c0104324:	89 d0                	mov    %edx,%eax
c0104326:	c1 f8 05             	sar    $0x5,%eax
}
c0104329:	5d                   	pop    %ebp
c010432a:	c3                   	ret    

c010432b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010432b:	55                   	push   %ebp
c010432c:	89 e5                	mov    %esp,%ebp
c010432e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104331:	8b 45 08             	mov    0x8(%ebp),%eax
c0104334:	89 04 24             	mov    %eax,(%esp)
c0104337:	e8 db ff ff ff       	call   c0104317 <page2ppn>
c010433c:	c1 e0 0c             	shl    $0xc,%eax
}
c010433f:	c9                   	leave  
c0104340:	c3                   	ret    

c0104341 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104341:	55                   	push   %ebp
c0104342:	89 e5                	mov    %esp,%ebp
c0104344:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104347:	8b 45 08             	mov    0x8(%ebp),%eax
c010434a:	c1 e8 0c             	shr    $0xc,%eax
c010434d:	89 c2                	mov    %eax,%edx
c010434f:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104354:	39 c2                	cmp    %eax,%edx
c0104356:	72 1c                	jb     c0104374 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104358:	c7 44 24 08 ec a8 10 	movl   $0xc010a8ec,0x8(%esp)
c010435f:	c0 
c0104360:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104367:	00 
c0104368:	c7 04 24 0b a9 10 c0 	movl   $0xc010a90b,(%esp)
c010436f:	e8 69 c9 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104374:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104379:	8b 55 08             	mov    0x8(%ebp),%edx
c010437c:	c1 ea 0c             	shr    $0xc,%edx
c010437f:	c1 e2 05             	shl    $0x5,%edx
c0104382:	01 d0                	add    %edx,%eax
}
c0104384:	c9                   	leave  
c0104385:	c3                   	ret    

c0104386 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104386:	55                   	push   %ebp
c0104387:	89 e5                	mov    %esp,%ebp
c0104389:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010438c:	8b 45 08             	mov    0x8(%ebp),%eax
c010438f:	89 04 24             	mov    %eax,(%esp)
c0104392:	e8 94 ff ff ff       	call   c010432b <page2pa>
c0104397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010439a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439d:	c1 e8 0c             	shr    $0xc,%eax
c01043a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043a3:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01043a8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01043ab:	72 23                	jb     c01043d0 <page2kva+0x4a>
c01043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043b4:	c7 44 24 08 1c a9 10 	movl   $0xc010a91c,0x8(%esp)
c01043bb:	c0 
c01043bc:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01043c3:	00 
c01043c4:	c7 04 24 0b a9 10 c0 	movl   $0xc010a90b,(%esp)
c01043cb:	e8 0d c9 ff ff       	call   c0100cdd <__panic>
c01043d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043d3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01043d8:	c9                   	leave  
c01043d9:	c3                   	ret    

c01043da <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01043da:	55                   	push   %ebp
c01043db:	89 e5                	mov    %esp,%ebp
c01043dd:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01043e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043e6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043ed:	77 23                	ja     c0104412 <kva2page+0x38>
c01043ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043f6:	c7 44 24 08 40 a9 10 	movl   $0xc010a940,0x8(%esp)
c01043fd:	c0 
c01043fe:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104405:	00 
c0104406:	c7 04 24 0b a9 10 c0 	movl   $0xc010a90b,(%esp)
c010440d:	e8 cb c8 ff ff       	call   c0100cdd <__panic>
c0104412:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104415:	05 00 00 00 40       	add    $0x40000000,%eax
c010441a:	89 04 24             	mov    %eax,(%esp)
c010441d:	e8 1f ff ff ff       	call   c0104341 <pa2page>
}
c0104422:	c9                   	leave  
c0104423:	c3                   	ret    

c0104424 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104424:	55                   	push   %ebp
c0104425:	89 e5                	mov    %esp,%ebp
c0104427:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010442a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010442d:	ba 01 00 00 00       	mov    $0x1,%edx
c0104432:	89 c1                	mov    %eax,%ecx
c0104434:	d3 e2                	shl    %cl,%edx
c0104436:	89 d0                	mov    %edx,%eax
c0104438:	89 04 24             	mov    %eax,(%esp)
c010443b:	e8 ef 08 00 00       	call   c0104d2f <alloc_pages>
c0104440:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104443:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104447:	75 07                	jne    c0104450 <__slob_get_free_pages+0x2c>
    return NULL;
c0104449:	b8 00 00 00 00       	mov    $0x0,%eax
c010444e:	eb 0b                	jmp    c010445b <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104453:	89 04 24             	mov    %eax,(%esp)
c0104456:	e8 2b ff ff ff       	call   c0104386 <page2kva>
}
c010445b:	c9                   	leave  
c010445c:	c3                   	ret    

c010445d <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010445d:	55                   	push   %ebp
c010445e:	89 e5                	mov    %esp,%ebp
c0104460:	53                   	push   %ebx
c0104461:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104464:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104467:	ba 01 00 00 00       	mov    $0x1,%edx
c010446c:	89 c1                	mov    %eax,%ecx
c010446e:	d3 e2                	shl    %cl,%edx
c0104470:	89 d0                	mov    %edx,%eax
c0104472:	89 c3                	mov    %eax,%ebx
c0104474:	8b 45 08             	mov    0x8(%ebp),%eax
c0104477:	89 04 24             	mov    %eax,(%esp)
c010447a:	e8 5b ff ff ff       	call   c01043da <kva2page>
c010447f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104483:	89 04 24             	mov    %eax,(%esp)
c0104486:	e8 0f 09 00 00       	call   c0104d9a <free_pages>
}
c010448b:	83 c4 14             	add    $0x14,%esp
c010448e:	5b                   	pop    %ebx
c010448f:	5d                   	pop    %ebp
c0104490:	c3                   	ret    

c0104491 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104491:	55                   	push   %ebp
c0104492:	89 e5                	mov    %esp,%ebp
c0104494:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104497:	8b 45 08             	mov    0x8(%ebp),%eax
c010449a:	83 c0 08             	add    $0x8,%eax
c010449d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01044a2:	76 24                	jbe    c01044c8 <slob_alloc+0x37>
c01044a4:	c7 44 24 0c 64 a9 10 	movl   $0xc010a964,0xc(%esp)
c01044ab:	c0 
c01044ac:	c7 44 24 08 83 a9 10 	movl   $0xc010a983,0x8(%esp)
c01044b3:	c0 
c01044b4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01044bb:	00 
c01044bc:	c7 04 24 98 a9 10 c0 	movl   $0xc010a998,(%esp)
c01044c3:	e8 15 c8 ff ff       	call   c0100cdd <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01044c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c01044cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01044d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d9:	83 c0 07             	add    $0x7,%eax
c01044dc:	c1 e8 03             	shr    $0x3,%eax
c01044df:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01044e2:	e8 f3 fd ff ff       	call   c01042da <__intr_save>
c01044e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01044ea:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01044ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01044f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f5:	8b 40 04             	mov    0x4(%eax),%eax
c01044f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01044fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044ff:	74 25                	je     c0104526 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104501:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104504:	8b 45 10             	mov    0x10(%ebp),%eax
c0104507:	01 d0                	add    %edx,%eax
c0104509:	8d 50 ff             	lea    -0x1(%eax),%edx
c010450c:	8b 45 10             	mov    0x10(%ebp),%eax
c010450f:	f7 d8                	neg    %eax
c0104511:	21 d0                	and    %edx,%eax
c0104513:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104516:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104519:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010451c:	29 c2                	sub    %eax,%edx
c010451e:	89 d0                	mov    %edx,%eax
c0104520:	c1 f8 03             	sar    $0x3,%eax
c0104523:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104526:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104529:	8b 00                	mov    (%eax),%eax
c010452b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010452e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104531:	01 ca                	add    %ecx,%edx
c0104533:	39 d0                	cmp    %edx,%eax
c0104535:	0f 8c aa 00 00 00    	jl     c01045e5 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010453b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010453f:	74 38                	je     c0104579 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104541:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104544:	8b 00                	mov    (%eax),%eax
c0104546:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104549:	89 c2                	mov    %eax,%edx
c010454b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010454e:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104550:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104553:	8b 50 04             	mov    0x4(%eax),%edx
c0104556:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104559:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010455c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104562:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104565:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104568:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010456b:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010456d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104570:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104573:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104576:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104579:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010457c:	8b 00                	mov    (%eax),%eax
c010457e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104581:	75 0e                	jne    c0104591 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104583:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104586:	8b 50 04             	mov    0x4(%eax),%edx
c0104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458c:	89 50 04             	mov    %edx,0x4(%eax)
c010458f:	eb 3c                	jmp    c01045cd <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104591:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104594:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010459b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010459e:	01 c2                	add    %eax,%edx
c01045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a3:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a9:	8b 40 04             	mov    0x4(%eax),%eax
c01045ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045af:	8b 12                	mov    (%edx),%edx
c01045b1:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01045b4:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b9:	8b 40 04             	mov    0x4(%eax),%eax
c01045bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045bf:	8b 52 04             	mov    0x4(%edx),%edx
c01045c2:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01045c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045cb:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c01045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d0:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c01045d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045d8:	89 04 24             	mov    %eax,(%esp)
c01045db:	e8 24 fd ff ff       	call   c0104304 <__intr_restore>
			return cur;
c01045e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045e3:	eb 7f                	jmp    c0104664 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c01045e5:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01045ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01045ed:	75 61                	jne    c0104650 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c01045ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045f2:	89 04 24             	mov    %eax,(%esp)
c01045f5:	e8 0a fd ff ff       	call   c0104304 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01045fa:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104601:	75 07                	jne    c010460a <slob_alloc+0x179>
				return 0;
c0104603:	b8 00 00 00 00       	mov    $0x0,%eax
c0104608:	eb 5a                	jmp    c0104664 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010460a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104611:	00 
c0104612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104615:	89 04 24             	mov    %eax,(%esp)
c0104618:	e8 07 fe ff ff       	call   c0104424 <__slob_get_free_pages>
c010461d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104624:	75 07                	jne    c010462d <slob_alloc+0x19c>
				return 0;
c0104626:	b8 00 00 00 00       	mov    $0x0,%eax
c010462b:	eb 37                	jmp    c0104664 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c010462d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104634:	00 
c0104635:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104638:	89 04 24             	mov    %eax,(%esp)
c010463b:	e8 26 00 00 00       	call   c0104666 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104640:	e8 95 fc ff ff       	call   c01042da <__intr_save>
c0104645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104648:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010464d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104650:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104653:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104656:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104659:	8b 40 04             	mov    0x4(%eax),%eax
c010465c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c010465f:	e9 97 fe ff ff       	jmp    c01044fb <slob_alloc+0x6a>
}
c0104664:	c9                   	leave  
c0104665:	c3                   	ret    

c0104666 <slob_free>:

static void slob_free(void *block, int size)
{
c0104666:	55                   	push   %ebp
c0104667:	89 e5                	mov    %esp,%ebp
c0104669:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010466c:	8b 45 08             	mov    0x8(%ebp),%eax
c010466f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104672:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104676:	75 05                	jne    c010467d <slob_free+0x17>
		return;
c0104678:	e9 ff 00 00 00       	jmp    c010477c <slob_free+0x116>

	if (size)
c010467d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104681:	74 10                	je     c0104693 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104683:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104686:	83 c0 07             	add    $0x7,%eax
c0104689:	c1 e8 03             	shr    $0x3,%eax
c010468c:	89 c2                	mov    %eax,%edx
c010468e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104691:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104693:	e8 42 fc ff ff       	call   c01042da <__intr_save>
c0104698:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c010469b:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01046a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046a3:	eb 27                	jmp    c01046cc <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a8:	8b 40 04             	mov    0x4(%eax),%eax
c01046ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046ae:	77 13                	ja     c01046c3 <slob_free+0x5d>
c01046b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046b6:	77 27                	ja     c01046df <slob_free+0x79>
c01046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046bb:	8b 40 04             	mov    0x4(%eax),%eax
c01046be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046c1:	77 1c                	ja     c01046df <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c6:	8b 40 04             	mov    0x4(%eax),%eax
c01046c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046d2:	76 d1                	jbe    c01046a5 <slob_free+0x3f>
c01046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d7:	8b 40 04             	mov    0x4(%eax),%eax
c01046da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046dd:	76 c6                	jbe    c01046a5 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c01046df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e2:	8b 00                	mov    (%eax),%eax
c01046e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01046eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ee:	01 c2                	add    %eax,%edx
c01046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f3:	8b 40 04             	mov    0x4(%eax),%eax
c01046f6:	39 c2                	cmp    %eax,%edx
c01046f8:	75 25                	jne    c010471f <slob_free+0xb9>
		b->units += cur->next->units;
c01046fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046fd:	8b 10                	mov    (%eax),%edx
c01046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104702:	8b 40 04             	mov    0x4(%eax),%eax
c0104705:	8b 00                	mov    (%eax),%eax
c0104707:	01 c2                	add    %eax,%edx
c0104709:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010470c:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c010470e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104711:	8b 40 04             	mov    0x4(%eax),%eax
c0104714:	8b 50 04             	mov    0x4(%eax),%edx
c0104717:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471a:	89 50 04             	mov    %edx,0x4(%eax)
c010471d:	eb 0c                	jmp    c010472b <slob_free+0xc5>
	} else
		b->next = cur->next;
c010471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104722:	8b 50 04             	mov    0x4(%eax),%edx
c0104725:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104728:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c010472b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472e:	8b 00                	mov    (%eax),%eax
c0104730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104737:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473a:	01 d0                	add    %edx,%eax
c010473c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010473f:	75 1f                	jne    c0104760 <slob_free+0xfa>
		cur->units += b->units;
c0104741:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104744:	8b 10                	mov    (%eax),%edx
c0104746:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104749:	8b 00                	mov    (%eax),%eax
c010474b:	01 c2                	add    %eax,%edx
c010474d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104750:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104752:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104755:	8b 50 04             	mov    0x4(%eax),%edx
c0104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475b:	89 50 04             	mov    %edx,0x4(%eax)
c010475e:	eb 09                	jmp    c0104769 <slob_free+0x103>
	} else
		cur->next = b;
c0104760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104763:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104766:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476c:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104771:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104774:	89 04 24             	mov    %eax,(%esp)
c0104777:	e8 88 fb ff ff       	call   c0104304 <__intr_restore>
}
c010477c:	c9                   	leave  
c010477d:	c3                   	ret    

c010477e <slob_init>:



void
slob_init(void) {
c010477e:	55                   	push   %ebp
c010477f:	89 e5                	mov    %esp,%ebp
c0104781:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104784:	c7 04 24 aa a9 10 c0 	movl   $0xc010a9aa,(%esp)
c010478b:	e8 c3 bb ff ff       	call   c0100353 <cprintf>
}
c0104790:	c9                   	leave  
c0104791:	c3                   	ret    

c0104792 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104792:	55                   	push   %ebp
c0104793:	89 e5                	mov    %esp,%ebp
c0104795:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104798:	e8 e1 ff ff ff       	call   c010477e <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c010479d:	c7 04 24 be a9 10 c0 	movl   $0xc010a9be,(%esp)
c01047a4:	e8 aa bb ff ff       	call   c0100353 <cprintf>
}
c01047a9:	c9                   	leave  
c01047aa:	c3                   	ret    

c01047ab <slob_allocated>:

size_t
slob_allocated(void) {
c01047ab:	55                   	push   %ebp
c01047ac:	89 e5                	mov    %esp,%ebp
  return 0;
c01047ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047b3:	5d                   	pop    %ebp
c01047b4:	c3                   	ret    

c01047b5 <kallocated>:

size_t
kallocated(void) {
c01047b5:	55                   	push   %ebp
c01047b6:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c01047b8:	e8 ee ff ff ff       	call   c01047ab <slob_allocated>
}
c01047bd:	5d                   	pop    %ebp
c01047be:	c3                   	ret    

c01047bf <find_order>:

static int find_order(int size)
{
c01047bf:	55                   	push   %ebp
c01047c0:	89 e5                	mov    %esp,%ebp
c01047c2:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c01047c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c01047cc:	eb 07                	jmp    c01047d5 <find_order+0x16>
		order++;
c01047ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c01047d2:	d1 7d 08             	sarl   0x8(%ebp)
c01047d5:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01047dc:	7f f0                	jg     c01047ce <find_order+0xf>
		order++;
	return order;
c01047de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01047e1:	c9                   	leave  
c01047e2:	c3                   	ret    

c01047e3 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c01047e3:	55                   	push   %ebp
c01047e4:	89 e5                	mov    %esp,%ebp
c01047e6:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c01047e9:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c01047f0:	77 38                	ja     c010482a <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c01047f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f5:	8d 50 08             	lea    0x8(%eax),%edx
c01047f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ff:	00 
c0104800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104803:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104807:	89 14 24             	mov    %edx,(%esp)
c010480a:	e8 82 fc ff ff       	call   c0104491 <slob_alloc>
c010480f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104816:	74 08                	je     c0104820 <__kmalloc+0x3d>
c0104818:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010481b:	83 c0 08             	add    $0x8,%eax
c010481e:	eb 05                	jmp    c0104825 <__kmalloc+0x42>
c0104820:	b8 00 00 00 00       	mov    $0x0,%eax
c0104825:	e9 a6 00 00 00       	jmp    c01048d0 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c010482a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104831:	00 
c0104832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104835:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104839:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104840:	e8 4c fc ff ff       	call   c0104491 <slob_alloc>
c0104845:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010484c:	75 07                	jne    c0104855 <__kmalloc+0x72>
		return 0;
c010484e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104853:	eb 7b                	jmp    c01048d0 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104855:	8b 45 08             	mov    0x8(%ebp),%eax
c0104858:	89 04 24             	mov    %eax,(%esp)
c010485b:	e8 5f ff ff ff       	call   c01047bf <find_order>
c0104860:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104863:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104865:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104868:	8b 00                	mov    (%eax),%eax
c010486a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010486e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104871:	89 04 24             	mov    %eax,(%esp)
c0104874:	e8 ab fb ff ff       	call   c0104424 <__slob_get_free_pages>
c0104879:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010487c:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c010487f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104882:	8b 40 04             	mov    0x4(%eax),%eax
c0104885:	85 c0                	test   %eax,%eax
c0104887:	74 2f                	je     c01048b8 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104889:	e8 4c fa ff ff       	call   c01042da <__intr_save>
c010488e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104891:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c0104897:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010489a:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c010489d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a0:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c01048a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048a8:	89 04 24             	mov    %eax,(%esp)
c01048ab:	e8 54 fa ff ff       	call   c0104304 <__intr_restore>
		return bb->pages;
c01048b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048b3:	8b 40 04             	mov    0x4(%eax),%eax
c01048b6:	eb 18                	jmp    c01048d0 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01048b8:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01048bf:	00 
c01048c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c3:	89 04 24             	mov    %eax,(%esp)
c01048c6:	e8 9b fd ff ff       	call   c0104666 <slob_free>
	return 0;
c01048cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048d0:	c9                   	leave  
c01048d1:	c3                   	ret    

c01048d2 <kmalloc>:

void *
kmalloc(size_t size)
{
c01048d2:	55                   	push   %ebp
c01048d3:	89 e5                	mov    %esp,%ebp
c01048d5:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c01048d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048df:	00 
c01048e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e3:	89 04 24             	mov    %eax,(%esp)
c01048e6:	e8 f8 fe ff ff       	call   c01047e3 <__kmalloc>
}
c01048eb:	c9                   	leave  
c01048ec:	c3                   	ret    

c01048ed <kfree>:


void kfree(void *block)
{
c01048ed:	55                   	push   %ebp
c01048ee:	89 e5                	mov    %esp,%ebp
c01048f0:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c01048f3:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01048fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01048fe:	75 05                	jne    c0104905 <kfree+0x18>
		return;
c0104900:	e9 a2 00 00 00       	jmp    c01049a7 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104905:	8b 45 08             	mov    0x8(%ebp),%eax
c0104908:	25 ff 0f 00 00       	and    $0xfff,%eax
c010490d:	85 c0                	test   %eax,%eax
c010490f:	75 7f                	jne    c0104990 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104911:	e8 c4 f9 ff ff       	call   c01042da <__intr_save>
c0104916:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104919:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c010491e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104921:	eb 5c                	jmp    c010497f <kfree+0x92>
			if (bb->pages == block) {
c0104923:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104926:	8b 40 04             	mov    0x4(%eax),%eax
c0104929:	3b 45 08             	cmp    0x8(%ebp),%eax
c010492c:	75 3f                	jne    c010496d <kfree+0x80>
				*last = bb->next;
c010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104931:	8b 50 08             	mov    0x8(%eax),%edx
c0104934:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104937:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104939:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010493c:	89 04 24             	mov    %eax,(%esp)
c010493f:	e8 c0 f9 ff ff       	call   c0104304 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104947:	8b 10                	mov    (%eax),%edx
c0104949:	8b 45 08             	mov    0x8(%ebp),%eax
c010494c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104950:	89 04 24             	mov    %eax,(%esp)
c0104953:	e8 05 fb ff ff       	call   c010445d <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104958:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c010495f:	00 
c0104960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104963:	89 04 24             	mov    %eax,(%esp)
c0104966:	e8 fb fc ff ff       	call   c0104666 <slob_free>
				return;
c010496b:	eb 3a                	jmp    c01049a7 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010496d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104970:	83 c0 08             	add    $0x8,%eax
c0104973:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104979:	8b 40 08             	mov    0x8(%eax),%eax
c010497c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010497f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104983:	75 9e                	jne    c0104923 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104985:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104988:	89 04 24             	mov    %eax,(%esp)
c010498b:	e8 74 f9 ff ff       	call   c0104304 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104990:	8b 45 08             	mov    0x8(%ebp),%eax
c0104993:	83 e8 08             	sub    $0x8,%eax
c0104996:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010499d:	00 
c010499e:	89 04 24             	mov    %eax,(%esp)
c01049a1:	e8 c0 fc ff ff       	call   c0104666 <slob_free>
	return;
c01049a6:	90                   	nop
}
c01049a7:	c9                   	leave  
c01049a8:	c3                   	ret    

c01049a9 <ksize>:


unsigned int ksize(const void *block)
{
c01049a9:	55                   	push   %ebp
c01049aa:	89 e5                	mov    %esp,%ebp
c01049ac:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c01049af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049b3:	75 07                	jne    c01049bc <ksize+0x13>
		return 0;
c01049b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01049ba:	eb 6b                	jmp    c0104a27 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01049bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01049bf:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049c4:	85 c0                	test   %eax,%eax
c01049c6:	75 54                	jne    c0104a1c <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c01049c8:	e8 0d f9 ff ff       	call   c01042da <__intr_save>
c01049cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c01049d0:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c01049d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049d8:	eb 31                	jmp    c0104a0b <ksize+0x62>
			if (bb->pages == block) {
c01049da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049dd:	8b 40 04             	mov    0x4(%eax),%eax
c01049e0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049e3:	75 1d                	jne    c0104a02 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c01049e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e8:	89 04 24             	mov    %eax,(%esp)
c01049eb:	e8 14 f9 ff ff       	call   c0104304 <__intr_restore>
				return PAGE_SIZE << bb->order;
c01049f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f3:	8b 00                	mov    (%eax),%eax
c01049f5:	ba 00 10 00 00       	mov    $0x1000,%edx
c01049fa:	89 c1                	mov    %eax,%ecx
c01049fc:	d3 e2                	shl    %cl,%edx
c01049fe:	89 d0                	mov    %edx,%eax
c0104a00:	eb 25                	jmp    c0104a27 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a05:	8b 40 08             	mov    0x8(%eax),%eax
c0104a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a0f:	75 c9                	jne    c01049da <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a14:	89 04 24             	mov    %eax,(%esp)
c0104a17:	e8 e8 f8 ff ff       	call   c0104304 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a1f:	83 e8 08             	sub    $0x8,%eax
c0104a22:	8b 00                	mov    (%eax),%eax
c0104a24:	c1 e0 03             	shl    $0x3,%eax
}
c0104a27:	c9                   	leave  
c0104a28:	c3                   	ret    

c0104a29 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104a29:	55                   	push   %ebp
c0104a2a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104a2c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a2f:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a34:	29 c2                	sub    %eax,%edx
c0104a36:	89 d0                	mov    %edx,%eax
c0104a38:	c1 f8 05             	sar    $0x5,%eax
}
c0104a3b:	5d                   	pop    %ebp
c0104a3c:	c3                   	ret    

c0104a3d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104a3d:	55                   	push   %ebp
c0104a3e:	89 e5                	mov    %esp,%ebp
c0104a40:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a46:	89 04 24             	mov    %eax,(%esp)
c0104a49:	e8 db ff ff ff       	call   c0104a29 <page2ppn>
c0104a4e:	c1 e0 0c             	shl    $0xc,%eax
}
c0104a51:	c9                   	leave  
c0104a52:	c3                   	ret    

c0104a53 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104a53:	55                   	push   %ebp
c0104a54:	89 e5                	mov    %esp,%ebp
c0104a56:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a5c:	c1 e8 0c             	shr    $0xc,%eax
c0104a5f:	89 c2                	mov    %eax,%edx
c0104a61:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104a66:	39 c2                	cmp    %eax,%edx
c0104a68:	72 1c                	jb     c0104a86 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104a6a:	c7 44 24 08 dc a9 10 	movl   $0xc010a9dc,0x8(%esp)
c0104a71:	c0 
c0104a72:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104a79:	00 
c0104a7a:	c7 04 24 fb a9 10 c0 	movl   $0xc010a9fb,(%esp)
c0104a81:	e8 57 c2 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104a86:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a8b:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a8e:	c1 ea 0c             	shr    $0xc,%edx
c0104a91:	c1 e2 05             	shl    $0x5,%edx
c0104a94:	01 d0                	add    %edx,%eax
}
c0104a96:	c9                   	leave  
c0104a97:	c3                   	ret    

c0104a98 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104a98:	55                   	push   %ebp
c0104a99:	89 e5                	mov    %esp,%ebp
c0104a9b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aa1:	89 04 24             	mov    %eax,(%esp)
c0104aa4:	e8 94 ff ff ff       	call   c0104a3d <page2pa>
c0104aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aaf:	c1 e8 0c             	shr    $0xc,%eax
c0104ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab5:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104aba:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104abd:	72 23                	jb     c0104ae2 <page2kva+0x4a>
c0104abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ac6:	c7 44 24 08 0c aa 10 	movl   $0xc010aa0c,0x8(%esp)
c0104acd:	c0 
c0104ace:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104ad5:	00 
c0104ad6:	c7 04 24 fb a9 10 c0 	movl   $0xc010a9fb,(%esp)
c0104add:	e8 fb c1 ff ff       	call   c0100cdd <__panic>
c0104ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104aea:	c9                   	leave  
c0104aeb:	c3                   	ret    

c0104aec <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104aec:	55                   	push   %ebp
c0104aed:	89 e5                	mov    %esp,%ebp
c0104aef:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af5:	83 e0 01             	and    $0x1,%eax
c0104af8:	85 c0                	test   %eax,%eax
c0104afa:	75 1c                	jne    c0104b18 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104afc:	c7 44 24 08 30 aa 10 	movl   $0xc010aa30,0x8(%esp)
c0104b03:	c0 
c0104b04:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104b0b:	00 
c0104b0c:	c7 04 24 fb a9 10 c0 	movl   $0xc010a9fb,(%esp)
c0104b13:	e8 c5 c1 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b20:	89 04 24             	mov    %eax,(%esp)
c0104b23:	e8 2b ff ff ff       	call   c0104a53 <pa2page>
}
c0104b28:	c9                   	leave  
c0104b29:	c3                   	ret    

c0104b2a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104b2a:	55                   	push   %ebp
c0104b2b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b30:	8b 00                	mov    (%eax),%eax
}
c0104b32:	5d                   	pop    %ebp
c0104b33:	c3                   	ret    

c0104b34 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104b34:	55                   	push   %ebp
c0104b35:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b3d:	89 10                	mov    %edx,(%eax)
}
c0104b3f:	5d                   	pop    %ebp
c0104b40:	c3                   	ret    

c0104b41 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104b41:	55                   	push   %ebp
c0104b42:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b47:	8b 00                	mov    (%eax),%eax
c0104b49:	8d 50 01             	lea    0x1(%eax),%edx
c0104b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b54:	8b 00                	mov    (%eax),%eax
}
c0104b56:	5d                   	pop    %ebp
c0104b57:	c3                   	ret    

c0104b58 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104b58:	55                   	push   %ebp
c0104b59:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b5e:	8b 00                	mov    (%eax),%eax
c0104b60:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b66:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b6b:	8b 00                	mov    (%eax),%eax
}
c0104b6d:	5d                   	pop    %ebp
c0104b6e:	c3                   	ret    

c0104b6f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104b6f:	55                   	push   %ebp
c0104b70:	89 e5                	mov    %esp,%ebp
c0104b72:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104b75:	9c                   	pushf  
c0104b76:	58                   	pop    %eax
c0104b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104b7d:	25 00 02 00 00       	and    $0x200,%eax
c0104b82:	85 c0                	test   %eax,%eax
c0104b84:	74 0c                	je     c0104b92 <__intr_save+0x23>
        intr_disable();
c0104b86:	e8 aa d3 ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104b8b:	b8 01 00 00 00       	mov    $0x1,%eax
c0104b90:	eb 05                	jmp    c0104b97 <__intr_save+0x28>
    }
    return 0;
c0104b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b97:	c9                   	leave  
c0104b98:	c3                   	ret    

c0104b99 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104b99:	55                   	push   %ebp
c0104b9a:	89 e5                	mov    %esp,%ebp
c0104b9c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104b9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ba3:	74 05                	je     c0104baa <__intr_restore+0x11>
        intr_enable();
c0104ba5:	e8 85 d3 ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104baa:	c9                   	leave  
c0104bab:	c3                   	ret    

c0104bac <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104bac:	55                   	push   %ebp
c0104bad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bb2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104bb5:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bba:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104bbc:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bc1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104bc3:	b8 10 00 00 00       	mov    $0x10,%eax
c0104bc8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104bca:	b8 10 00 00 00       	mov    $0x10,%eax
c0104bcf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104bd1:	b8 10 00 00 00       	mov    $0x10,%eax
c0104bd6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104bd8:	ea df 4b 10 c0 08 00 	ljmp   $0x8,$0xc0104bdf
}
c0104bdf:	5d                   	pop    %ebp
c0104be0:	c3                   	ret    

c0104be1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104be1:	55                   	push   %ebp
c0104be2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be7:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104bec:	5d                   	pop    %ebp
c0104bed:	c3                   	ret    

c0104bee <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104bee:	55                   	push   %ebp
c0104bef:	89 e5                	mov    %esp,%ebp
c0104bf1:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104bf4:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104bf9:	89 04 24             	mov    %eax,(%esp)
c0104bfc:	e8 e0 ff ff ff       	call   c0104be1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104c01:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104c08:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104c0a:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104c11:	68 00 
c0104c13:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c18:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104c1e:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c23:	c1 e8 10             	shr    $0x10,%eax
c0104c26:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104c2b:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c32:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c35:	83 c8 09             	or     $0x9,%eax
c0104c38:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c3d:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c44:	83 e0 ef             	and    $0xffffffef,%eax
c0104c47:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c4c:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c53:	83 e0 9f             	and    $0xffffff9f,%eax
c0104c56:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c5b:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c62:	83 c8 80             	or     $0xffffff80,%eax
c0104c65:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c6a:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c71:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c74:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c79:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c80:	83 e0 ef             	and    $0xffffffef,%eax
c0104c83:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c88:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c8f:	83 e0 df             	and    $0xffffffdf,%eax
c0104c92:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c97:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c9e:	83 c8 40             	or     $0x40,%eax
c0104ca1:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104ca6:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cad:	83 e0 7f             	and    $0x7f,%eax
c0104cb0:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cb5:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104cba:	c1 e8 18             	shr    $0x18,%eax
c0104cbd:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104cc2:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104cc9:	e8 de fe ff ff       	call   c0104bac <lgdt>
c0104cce:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104cd4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104cd8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104cdb:	c9                   	leave  
c0104cdc:	c3                   	ret    

c0104cdd <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104cdd:	55                   	push   %ebp
c0104cde:	89 e5                	mov    %esp,%ebp
c0104ce0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104ce3:	c7 05 24 7b 12 c0 d0 	movl   $0xc010a8d0,0xc0127b24
c0104cea:	a8 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104ced:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104cf2:	8b 00                	mov    (%eax),%eax
c0104cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cf8:	c7 04 24 5c aa 10 c0 	movl   $0xc010aa5c,(%esp)
c0104cff:	e8 4f b6 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104d04:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d09:	8b 40 04             	mov    0x4(%eax),%eax
c0104d0c:	ff d0                	call   *%eax
}
c0104d0e:	c9                   	leave  
c0104d0f:	c3                   	ret    

c0104d10 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104d10:	55                   	push   %ebp
c0104d11:	89 e5                	mov    %esp,%ebp
c0104d13:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104d16:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d1b:	8b 40 08             	mov    0x8(%eax),%eax
c0104d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d21:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d25:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d28:	89 14 24             	mov    %edx,(%esp)
c0104d2b:	ff d0                	call   *%eax
}
c0104d2d:	c9                   	leave  
c0104d2e:	c3                   	ret    

c0104d2f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104d2f:	55                   	push   %ebp
c0104d30:	89 e5                	mov    %esp,%ebp
c0104d32:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104d35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104d3c:	e8 2e fe ff ff       	call   c0104b6f <__intr_save>
c0104d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104d44:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d49:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d4f:	89 14 24             	mov    %edx,(%esp)
c0104d52:	ff d0                	call   *%eax
c0104d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d5a:	89 04 24             	mov    %eax,(%esp)
c0104d5d:	e8 37 fe ff ff       	call   c0104b99 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d66:	75 2d                	jne    c0104d95 <alloc_pages+0x66>
c0104d68:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104d6c:	77 27                	ja     c0104d95 <alloc_pages+0x66>
c0104d6e:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104d73:	85 c0                	test   %eax,%eax
c0104d75:	74 1e                	je     c0104d95 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104d77:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d7a:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104d7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d86:	00 
c0104d87:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d8b:	89 04 24             	mov    %eax,(%esp)
c0104d8e:	e8 62 19 00 00       	call   c01066f5 <swap_out>
    }
c0104d93:	eb a7                	jmp    c0104d3c <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104d98:	c9                   	leave  
c0104d99:	c3                   	ret    

c0104d9a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104d9a:	55                   	push   %ebp
c0104d9b:	89 e5                	mov    %esp,%ebp
c0104d9d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104da0:	e8 ca fd ff ff       	call   c0104b6f <__intr_save>
c0104da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104da8:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104dad:	8b 40 10             	mov    0x10(%eax),%eax
c0104db0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104db3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104db7:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dba:	89 14 24             	mov    %edx,(%esp)
c0104dbd:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc2:	89 04 24             	mov    %eax,(%esp)
c0104dc5:	e8 cf fd ff ff       	call   c0104b99 <__intr_restore>
}
c0104dca:	c9                   	leave  
c0104dcb:	c3                   	ret    

c0104dcc <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104dcc:	55                   	push   %ebp
c0104dcd:	89 e5                	mov    %esp,%ebp
c0104dcf:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104dd2:	e8 98 fd ff ff       	call   c0104b6f <__intr_save>
c0104dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104dda:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104ddf:	8b 40 14             	mov    0x14(%eax),%eax
c0104de2:	ff d0                	call   *%eax
c0104de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dea:	89 04 24             	mov    %eax,(%esp)
c0104ded:	e8 a7 fd ff ff       	call   c0104b99 <__intr_restore>
    return ret;
c0104df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104df5:	c9                   	leave  
c0104df6:	c3                   	ret    

c0104df7 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104df7:	55                   	push   %ebp
c0104df8:	89 e5                	mov    %esp,%ebp
c0104dfa:	57                   	push   %edi
c0104dfb:	56                   	push   %esi
c0104dfc:	53                   	push   %ebx
c0104dfd:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104e03:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104e11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104e18:	c7 04 24 73 aa 10 c0 	movl   $0xc010aa73,(%esp)
c0104e1f:	e8 2f b5 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104e24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e2b:	e9 15 01 00 00       	jmp    c0104f45 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e30:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e36:	89 d0                	mov    %edx,%eax
c0104e38:	c1 e0 02             	shl    $0x2,%eax
c0104e3b:	01 d0                	add    %edx,%eax
c0104e3d:	c1 e0 02             	shl    $0x2,%eax
c0104e40:	01 c8                	add    %ecx,%eax
c0104e42:	8b 50 08             	mov    0x8(%eax),%edx
c0104e45:	8b 40 04             	mov    0x4(%eax),%eax
c0104e48:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e4b:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104e4e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e51:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e54:	89 d0                	mov    %edx,%eax
c0104e56:	c1 e0 02             	shl    $0x2,%eax
c0104e59:	01 d0                	add    %edx,%eax
c0104e5b:	c1 e0 02             	shl    $0x2,%eax
c0104e5e:	01 c8                	add    %ecx,%eax
c0104e60:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e63:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e66:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e69:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e6c:	01 c8                	add    %ecx,%eax
c0104e6e:	11 da                	adc    %ebx,%edx
c0104e70:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104e73:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104e76:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e7c:	89 d0                	mov    %edx,%eax
c0104e7e:	c1 e0 02             	shl    $0x2,%eax
c0104e81:	01 d0                	add    %edx,%eax
c0104e83:	c1 e0 02             	shl    $0x2,%eax
c0104e86:	01 c8                	add    %ecx,%eax
c0104e88:	83 c0 14             	add    $0x14,%eax
c0104e8b:	8b 00                	mov    (%eax),%eax
c0104e8d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104e93:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e96:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104e99:	83 c0 ff             	add    $0xffffffff,%eax
c0104e9c:	83 d2 ff             	adc    $0xffffffff,%edx
c0104e9f:	89 c6                	mov    %eax,%esi
c0104ea1:	89 d7                	mov    %edx,%edi
c0104ea3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ea6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ea9:	89 d0                	mov    %edx,%eax
c0104eab:	c1 e0 02             	shl    $0x2,%eax
c0104eae:	01 d0                	add    %edx,%eax
c0104eb0:	c1 e0 02             	shl    $0x2,%eax
c0104eb3:	01 c8                	add    %ecx,%eax
c0104eb5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104eb8:	8b 58 10             	mov    0x10(%eax),%ebx
c0104ebb:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104ec1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104ec5:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104ec9:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104ecd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ed0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ed7:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104edb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104edf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104ee3:	c7 04 24 80 aa 10 c0 	movl   $0xc010aa80,(%esp)
c0104eea:	e8 64 b4 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104eef:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ef2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ef5:	89 d0                	mov    %edx,%eax
c0104ef7:	c1 e0 02             	shl    $0x2,%eax
c0104efa:	01 d0                	add    %edx,%eax
c0104efc:	c1 e0 02             	shl    $0x2,%eax
c0104eff:	01 c8                	add    %ecx,%eax
c0104f01:	83 c0 14             	add    $0x14,%eax
c0104f04:	8b 00                	mov    (%eax),%eax
c0104f06:	83 f8 01             	cmp    $0x1,%eax
c0104f09:	75 36                	jne    c0104f41 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f11:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f14:	77 2b                	ja     c0104f41 <page_init+0x14a>
c0104f16:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f19:	72 05                	jb     c0104f20 <page_init+0x129>
c0104f1b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104f1e:	73 21                	jae    c0104f41 <page_init+0x14a>
c0104f20:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f24:	77 1b                	ja     c0104f41 <page_init+0x14a>
c0104f26:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f2a:	72 09                	jb     c0104f35 <page_init+0x13e>
c0104f2c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104f33:	77 0c                	ja     c0104f41 <page_init+0x14a>
                maxpa = end;
c0104f35:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f38:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f41:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104f45:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f48:	8b 00                	mov    (%eax),%eax
c0104f4a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104f4d:	0f 8f dd fe ff ff    	jg     c0104e30 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f57:	72 1d                	jb     c0104f76 <page_init+0x17f>
c0104f59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f5d:	77 09                	ja     c0104f68 <page_init+0x171>
c0104f5f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104f66:	76 0e                	jbe    c0104f76 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104f68:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f7c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104f80:	c1 ea 0c             	shr    $0xc,%edx
c0104f83:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104f88:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104f8f:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c0104f94:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104f97:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f9a:	01 d0                	add    %edx,%eax
c0104f9c:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104f9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104fa2:	ba 00 00 00 00       	mov    $0x0,%edx
c0104fa7:	f7 75 ac             	divl   -0x54(%ebp)
c0104faa:	89 d0                	mov    %edx,%eax
c0104fac:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104faf:	29 c2                	sub    %eax,%edx
c0104fb1:	89 d0                	mov    %edx,%eax
c0104fb3:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c0104fb8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104fbf:	eb 27                	jmp    c0104fe8 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104fc1:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104fc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fc9:	c1 e2 05             	shl    $0x5,%edx
c0104fcc:	01 d0                	add    %edx,%eax
c0104fce:	83 c0 04             	add    $0x4,%eax
c0104fd1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104fd8:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104fdb:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104fde:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104fe1:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104fe4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104fe8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104feb:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104ff0:	39 c2                	cmp    %eax,%edx
c0104ff2:	72 cd                	jb     c0104fc1 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104ff4:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104ff9:	c1 e0 05             	shl    $0x5,%eax
c0104ffc:	89 c2                	mov    %eax,%edx
c0104ffe:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105003:	01 d0                	add    %edx,%eax
c0105005:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105008:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010500f:	77 23                	ja     c0105034 <page_init+0x23d>
c0105011:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105014:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105018:	c7 44 24 08 b0 aa 10 	movl   $0xc010aab0,0x8(%esp)
c010501f:	c0 
c0105020:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0105027:	00 
c0105028:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010502f:	e8 a9 bc ff ff       	call   c0100cdd <__panic>
c0105034:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105037:	05 00 00 00 40       	add    $0x40000000,%eax
c010503c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010503f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105046:	e9 74 01 00 00       	jmp    c01051bf <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010504b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010504e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105051:	89 d0                	mov    %edx,%eax
c0105053:	c1 e0 02             	shl    $0x2,%eax
c0105056:	01 d0                	add    %edx,%eax
c0105058:	c1 e0 02             	shl    $0x2,%eax
c010505b:	01 c8                	add    %ecx,%eax
c010505d:	8b 50 08             	mov    0x8(%eax),%edx
c0105060:	8b 40 04             	mov    0x4(%eax),%eax
c0105063:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105066:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105069:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010506c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010506f:	89 d0                	mov    %edx,%eax
c0105071:	c1 e0 02             	shl    $0x2,%eax
c0105074:	01 d0                	add    %edx,%eax
c0105076:	c1 e0 02             	shl    $0x2,%eax
c0105079:	01 c8                	add    %ecx,%eax
c010507b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010507e:	8b 58 10             	mov    0x10(%eax),%ebx
c0105081:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105084:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105087:	01 c8                	add    %ecx,%eax
c0105089:	11 da                	adc    %ebx,%edx
c010508b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010508e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105091:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105094:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105097:	89 d0                	mov    %edx,%eax
c0105099:	c1 e0 02             	shl    $0x2,%eax
c010509c:	01 d0                	add    %edx,%eax
c010509e:	c1 e0 02             	shl    $0x2,%eax
c01050a1:	01 c8                	add    %ecx,%eax
c01050a3:	83 c0 14             	add    $0x14,%eax
c01050a6:	8b 00                	mov    (%eax),%eax
c01050a8:	83 f8 01             	cmp    $0x1,%eax
c01050ab:	0f 85 0a 01 00 00    	jne    c01051bb <page_init+0x3c4>
            if (begin < freemem) {
c01050b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01050b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050bc:	72 17                	jb     c01050d5 <page_init+0x2de>
c01050be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050c1:	77 05                	ja     c01050c8 <page_init+0x2d1>
c01050c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01050c6:	76 0d                	jbe    c01050d5 <page_init+0x2de>
                begin = freemem;
c01050c8:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01050ce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01050d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01050d9:	72 1d                	jb     c01050f8 <page_init+0x301>
c01050db:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01050df:	77 09                	ja     c01050ea <page_init+0x2f3>
c01050e1:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01050e8:	76 0e                	jbe    c01050f8 <page_init+0x301>
                end = KMEMSIZE;
c01050ea:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01050f1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01050f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01050fe:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105101:	0f 87 b4 00 00 00    	ja     c01051bb <page_init+0x3c4>
c0105107:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010510a:	72 09                	jb     c0105115 <page_init+0x31e>
c010510c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010510f:	0f 83 a6 00 00 00    	jae    c01051bb <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105115:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010511c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010511f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105122:	01 d0                	add    %edx,%eax
c0105124:	83 e8 01             	sub    $0x1,%eax
c0105127:	89 45 98             	mov    %eax,-0x68(%ebp)
c010512a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010512d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105132:	f7 75 9c             	divl   -0x64(%ebp)
c0105135:	89 d0                	mov    %edx,%eax
c0105137:	8b 55 98             	mov    -0x68(%ebp),%edx
c010513a:	29 c2                	sub    %eax,%edx
c010513c:	89 d0                	mov    %edx,%eax
c010513e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105143:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105146:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105149:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010514c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010514f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105152:	ba 00 00 00 00       	mov    $0x0,%edx
c0105157:	89 c7                	mov    %eax,%edi
c0105159:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010515f:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105162:	89 d0                	mov    %edx,%eax
c0105164:	83 e0 00             	and    $0x0,%eax
c0105167:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010516a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010516d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105170:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105173:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105176:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105179:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010517c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010517f:	77 3a                	ja     c01051bb <page_init+0x3c4>
c0105181:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105184:	72 05                	jb     c010518b <page_init+0x394>
c0105186:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105189:	73 30                	jae    c01051bb <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010518b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010518e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0105191:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105194:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105197:	29 c8                	sub    %ecx,%eax
c0105199:	19 da                	sbb    %ebx,%edx
c010519b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010519f:	c1 ea 0c             	shr    $0xc,%edx
c01051a2:	89 c3                	mov    %eax,%ebx
c01051a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051a7:	89 04 24             	mov    %eax,(%esp)
c01051aa:	e8 a4 f8 ff ff       	call   c0104a53 <pa2page>
c01051af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01051b3:	89 04 24             	mov    %eax,(%esp)
c01051b6:	e8 55 fb ff ff       	call   c0104d10 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01051bb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01051bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01051c2:	8b 00                	mov    (%eax),%eax
c01051c4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01051c7:	0f 8f 7e fe ff ff    	jg     c010504b <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01051cd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01051d3:	5b                   	pop    %ebx
c01051d4:	5e                   	pop    %esi
c01051d5:	5f                   	pop    %edi
c01051d6:	5d                   	pop    %ebp
c01051d7:	c3                   	ret    

c01051d8 <enable_paging>:

static void
enable_paging(void) {
c01051d8:	55                   	push   %ebp
c01051d9:	89 e5                	mov    %esp,%ebp
c01051db:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01051de:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c01051e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01051e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01051e9:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01051ec:	0f 20 c0             	mov    %cr0,%eax
c01051ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01051f2:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01051f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01051f8:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01051ff:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105203:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105206:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0105209:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010520c:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010520f:	c9                   	leave  
c0105210:	c3                   	ret    

c0105211 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105211:	55                   	push   %ebp
c0105212:	89 e5                	mov    %esp,%ebp
c0105214:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105217:	8b 45 14             	mov    0x14(%ebp),%eax
c010521a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010521d:	31 d0                	xor    %edx,%eax
c010521f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105224:	85 c0                	test   %eax,%eax
c0105226:	74 24                	je     c010524c <boot_map_segment+0x3b>
c0105228:	c7 44 24 0c e2 aa 10 	movl   $0xc010aae2,0xc(%esp)
c010522f:	c0 
c0105230:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105237:	c0 
c0105238:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010523f:	00 
c0105240:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105247:	e8 91 ba ff ff       	call   c0100cdd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010524c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105253:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105256:	25 ff 0f 00 00       	and    $0xfff,%eax
c010525b:	89 c2                	mov    %eax,%edx
c010525d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105260:	01 c2                	add    %eax,%edx
c0105262:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105265:	01 d0                	add    %edx,%eax
c0105267:	83 e8 01             	sub    $0x1,%eax
c010526a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010526d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105270:	ba 00 00 00 00       	mov    $0x0,%edx
c0105275:	f7 75 f0             	divl   -0x10(%ebp)
c0105278:	89 d0                	mov    %edx,%eax
c010527a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010527d:	29 c2                	sub    %eax,%edx
c010527f:	89 d0                	mov    %edx,%eax
c0105281:	c1 e8 0c             	shr    $0xc,%eax
c0105284:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105287:	8b 45 0c             	mov    0xc(%ebp),%eax
c010528a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010528d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105290:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105295:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105298:	8b 45 14             	mov    0x14(%ebp),%eax
c010529b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010529e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052a6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01052a9:	eb 6b                	jmp    c0105316 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01052ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01052b2:	00 
c01052b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01052bd:	89 04 24             	mov    %eax,(%esp)
c01052c0:	e8 d1 01 00 00       	call   c0105496 <get_pte>
c01052c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01052c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01052cc:	75 24                	jne    c01052f2 <boot_map_segment+0xe1>
c01052ce:	c7 44 24 0c 0e ab 10 	movl   $0xc010ab0e,0xc(%esp)
c01052d5:	c0 
c01052d6:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01052dd:	c0 
c01052de:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01052e5:	00 
c01052e6:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01052ed:	e8 eb b9 ff ff       	call   c0100cdd <__panic>
        *ptep = pa | PTE_P | perm;
c01052f2:	8b 45 18             	mov    0x18(%ebp),%eax
c01052f5:	8b 55 14             	mov    0x14(%ebp),%edx
c01052f8:	09 d0                	or     %edx,%eax
c01052fa:	83 c8 01             	or     $0x1,%eax
c01052fd:	89 c2                	mov    %eax,%edx
c01052ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105302:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105304:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105308:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010530f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010531a:	75 8f                	jne    c01052ab <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010531c:	c9                   	leave  
c010531d:	c3                   	ret    

c010531e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010531e:	55                   	push   %ebp
c010531f:	89 e5                	mov    %esp,%ebp
c0105321:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105324:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010532b:	e8 ff f9 ff ff       	call   c0104d2f <alloc_pages>
c0105330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105337:	75 1c                	jne    c0105355 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105339:	c7 44 24 08 1b ab 10 	movl   $0xc010ab1b,0x8(%esp)
c0105340:	c0 
c0105341:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105348:	00 
c0105349:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105350:	e8 88 b9 ff ff       	call   c0100cdd <__panic>
    }
    return page2kva(p);
c0105355:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105358:	89 04 24             	mov    %eax,(%esp)
c010535b:	e8 38 f7 ff ff       	call   c0104a98 <page2kva>
}
c0105360:	c9                   	leave  
c0105361:	c3                   	ret    

c0105362 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105362:	55                   	push   %ebp
c0105363:	89 e5                	mov    %esp,%ebp
c0105365:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105368:	e8 70 f9 ff ff       	call   c0104cdd <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010536d:	e8 85 fa ff ff       	call   c0104df7 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105372:	e8 36 05 00 00       	call   c01058ad <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105377:	e8 a2 ff ff ff       	call   c010531e <boot_alloc_page>
c010537c:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c0105381:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105386:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010538d:	00 
c010538e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105395:	00 
c0105396:	89 04 24             	mov    %eax,(%esp)
c0105399:	e8 c9 47 00 00       	call   c0109b67 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010539e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053a6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01053ad:	77 23                	ja     c01053d2 <pmm_init+0x70>
c01053af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053b6:	c7 44 24 08 b0 aa 10 	movl   $0xc010aab0,0x8(%esp)
c01053bd:	c0 
c01053be:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01053c5:	00 
c01053c6:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01053cd:	e8 0b b9 ff ff       	call   c0100cdd <__panic>
c01053d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053d5:	05 00 00 00 40       	add    $0x40000000,%eax
c01053da:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c01053df:	e8 e7 04 00 00       	call   c01058cb <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01053e4:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053e9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01053ef:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053f7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01053fe:	77 23                	ja     c0105423 <pmm_init+0xc1>
c0105400:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105403:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105407:	c7 44 24 08 b0 aa 10 	movl   $0xc010aab0,0x8(%esp)
c010540e:	c0 
c010540f:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105416:	00 
c0105417:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010541e:	e8 ba b8 ff ff       	call   c0100cdd <__panic>
c0105423:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105426:	05 00 00 00 40       	add    $0x40000000,%eax
c010542b:	83 c8 03             	or     $0x3,%eax
c010542e:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105430:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105435:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010543c:	00 
c010543d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105444:	00 
c0105445:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010544c:	38 
c010544d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105454:	c0 
c0105455:	89 04 24             	mov    %eax,(%esp)
c0105458:	e8 b4 fd ff ff       	call   c0105211 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010545d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105462:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0105468:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010546e:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105470:	e8 63 fd ff ff       	call   c01051d8 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105475:	e8 74 f7 ff ff       	call   c0104bee <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010547a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010547f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105485:	e8 dc 0a 00 00       	call   c0105f66 <check_boot_pgdir>

    print_pgdir();
c010548a:	e8 69 0f 00 00       	call   c01063f8 <print_pgdir>
    
    kmalloc_init();
c010548f:	e8 fe f2 ff ff       	call   c0104792 <kmalloc_init>

}
c0105494:	c9                   	leave  
c0105495:	c3                   	ret    

c0105496 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105496:	55                   	push   %ebp
c0105497:	89 e5                	mov    %esp,%ebp
c0105499:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c010549c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010549f:	c1 e8 16             	shr    $0x16,%eax
c01054a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ac:	01 d0                	add    %edx,%eax
c01054ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01054b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054b4:	8b 00                	mov    (%eax),%eax
c01054b6:	83 e0 01             	and    $0x1,%eax
c01054b9:	85 c0                	test   %eax,%eax
c01054bb:	0f 85 af 00 00 00    	jne    c0105570 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01054c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054c5:	74 15                	je     c01054dc <get_pte+0x46>
c01054c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054ce:	e8 5c f8 ff ff       	call   c0104d2f <alloc_pages>
c01054d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054da:	75 0a                	jne    c01054e6 <get_pte+0x50>
            return NULL;
c01054dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01054e1:	e9 e6 00 00 00       	jmp    c01055cc <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01054e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054ed:	00 
c01054ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054f1:	89 04 24             	mov    %eax,(%esp)
c01054f4:	e8 3b f6 ff ff       	call   c0104b34 <set_page_ref>
        uintptr_t pa = page2pa(page);
c01054f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054fc:	89 04 24             	mov    %eax,(%esp)
c01054ff:	e8 39 f5 ff ff       	call   c0104a3d <page2pa>
c0105504:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0105507:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010550a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010550d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105510:	c1 e8 0c             	shr    $0xc,%eax
c0105513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105516:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010551b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010551e:	72 23                	jb     c0105543 <get_pte+0xad>
c0105520:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105523:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105527:	c7 44 24 08 0c aa 10 	movl   $0xc010aa0c,0x8(%esp)
c010552e:	c0 
c010552f:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0105536:	00 
c0105537:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010553e:	e8 9a b7 ff ff       	call   c0100cdd <__panic>
c0105543:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105546:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010554b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105552:	00 
c0105553:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010555a:	00 
c010555b:	89 04 24             	mov    %eax,(%esp)
c010555e:	e8 04 46 00 00       	call   c0109b67 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0105563:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105566:	83 c8 07             	or     $0x7,%eax
c0105569:	89 c2                	mov    %eax,%edx
c010556b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010556e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0105570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105573:	8b 00                	mov    (%eax),%eax
c0105575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010557a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010557d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105580:	c1 e8 0c             	shr    $0xc,%eax
c0105583:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105586:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010558b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010558e:	72 23                	jb     c01055b3 <get_pte+0x11d>
c0105590:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105593:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105597:	c7 44 24 08 0c aa 10 	movl   $0xc010aa0c,0x8(%esp)
c010559e:	c0 
c010559f:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c01055a6:	00 
c01055a7:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01055ae:	e8 2a b7 ff ff       	call   c0100cdd <__panic>
c01055b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01055bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055be:	c1 ea 0c             	shr    $0xc,%edx
c01055c1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01055c7:	c1 e2 02             	shl    $0x2,%edx
c01055ca:	01 d0                	add    %edx,%eax
}
c01055cc:	c9                   	leave  
c01055cd:	c3                   	ret    

c01055ce <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01055ce:	55                   	push   %ebp
c01055cf:	89 e5                	mov    %esp,%ebp
c01055d1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01055d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055db:	00 
c01055dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e6:	89 04 24             	mov    %eax,(%esp)
c01055e9:	e8 a8 fe ff ff       	call   c0105496 <get_pte>
c01055ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01055f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055f5:	74 08                	je     c01055ff <get_page+0x31>
        *ptep_store = ptep;
c01055f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01055fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055fd:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01055ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105603:	74 1b                	je     c0105620 <get_page+0x52>
c0105605:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105608:	8b 00                	mov    (%eax),%eax
c010560a:	83 e0 01             	and    $0x1,%eax
c010560d:	85 c0                	test   %eax,%eax
c010560f:	74 0f                	je     c0105620 <get_page+0x52>
        return pa2page(*ptep);
c0105611:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105614:	8b 00                	mov    (%eax),%eax
c0105616:	89 04 24             	mov    %eax,(%esp)
c0105619:	e8 35 f4 ff ff       	call   c0104a53 <pa2page>
c010561e:	eb 05                	jmp    c0105625 <get_page+0x57>
    }
    return NULL;
c0105620:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105625:	c9                   	leave  
c0105626:	c3                   	ret    

c0105627 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105627:	55                   	push   %ebp
c0105628:	89 e5                	mov    %esp,%ebp
c010562a:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010562d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105630:	8b 00                	mov    (%eax),%eax
c0105632:	83 e0 01             	and    $0x1,%eax
c0105635:	85 c0                	test   %eax,%eax
c0105637:	74 4d                	je     c0105686 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0105639:	8b 45 10             	mov    0x10(%ebp),%eax
c010563c:	8b 00                	mov    (%eax),%eax
c010563e:	89 04 24             	mov    %eax,(%esp)
c0105641:	e8 a6 f4 ff ff       	call   c0104aec <pte2page>
c0105646:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0105649:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010564c:	89 04 24             	mov    %eax,(%esp)
c010564f:	e8 04 f5 ff ff       	call   c0104b58 <page_ref_dec>
c0105654:	85 c0                	test   %eax,%eax
c0105656:	75 13                	jne    c010566b <page_remove_pte+0x44>
            free_page(page);
c0105658:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010565f:	00 
c0105660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105663:	89 04 24             	mov    %eax,(%esp)
c0105666:	e8 2f f7 ff ff       	call   c0104d9a <free_pages>
        }
        *ptep = 0;
c010566b:	8b 45 10             	mov    0x10(%ebp),%eax
c010566e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105674:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105677:	89 44 24 04          	mov    %eax,0x4(%esp)
c010567b:	8b 45 08             	mov    0x8(%ebp),%eax
c010567e:	89 04 24             	mov    %eax,(%esp)
c0105681:	e8 ff 00 00 00       	call   c0105785 <tlb_invalidate>
    }
}
c0105686:	c9                   	leave  
c0105687:	c3                   	ret    

c0105688 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105688:	55                   	push   %ebp
c0105689:	89 e5                	mov    %esp,%ebp
c010568b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010568e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105695:	00 
c0105696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105699:	89 44 24 04          	mov    %eax,0x4(%esp)
c010569d:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a0:	89 04 24             	mov    %eax,(%esp)
c01056a3:	e8 ee fd ff ff       	call   c0105496 <get_pte>
c01056a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01056ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056af:	74 19                	je     c01056ca <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01056b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c2:	89 04 24             	mov    %eax,(%esp)
c01056c5:	e8 5d ff ff ff       	call   c0105627 <page_remove_pte>
    }
}
c01056ca:	c9                   	leave  
c01056cb:	c3                   	ret    

c01056cc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01056cc:	55                   	push   %ebp
c01056cd:	89 e5                	mov    %esp,%ebp
c01056cf:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01056d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01056d9:	00 
c01056da:	8b 45 10             	mov    0x10(%ebp),%eax
c01056dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e4:	89 04 24             	mov    %eax,(%esp)
c01056e7:	e8 aa fd ff ff       	call   c0105496 <get_pte>
c01056ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01056ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056f3:	75 0a                	jne    c01056ff <page_insert+0x33>
        return -E_NO_MEM;
c01056f5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01056fa:	e9 84 00 00 00       	jmp    c0105783 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01056ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105702:	89 04 24             	mov    %eax,(%esp)
c0105705:	e8 37 f4 ff ff       	call   c0104b41 <page_ref_inc>
    if (*ptep & PTE_P) {
c010570a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010570d:	8b 00                	mov    (%eax),%eax
c010570f:	83 e0 01             	and    $0x1,%eax
c0105712:	85 c0                	test   %eax,%eax
c0105714:	74 3e                	je     c0105754 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105719:	8b 00                	mov    (%eax),%eax
c010571b:	89 04 24             	mov    %eax,(%esp)
c010571e:	e8 c9 f3 ff ff       	call   c0104aec <pte2page>
c0105723:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105726:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105729:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010572c:	75 0d                	jne    c010573b <page_insert+0x6f>
            page_ref_dec(page);
c010572e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105731:	89 04 24             	mov    %eax,(%esp)
c0105734:	e8 1f f4 ff ff       	call   c0104b58 <page_ref_dec>
c0105739:	eb 19                	jmp    c0105754 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010573e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105742:	8b 45 10             	mov    0x10(%ebp),%eax
c0105745:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105749:	8b 45 08             	mov    0x8(%ebp),%eax
c010574c:	89 04 24             	mov    %eax,(%esp)
c010574f:	e8 d3 fe ff ff       	call   c0105627 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105757:	89 04 24             	mov    %eax,(%esp)
c010575a:	e8 de f2 ff ff       	call   c0104a3d <page2pa>
c010575f:	0b 45 14             	or     0x14(%ebp),%eax
c0105762:	83 c8 01             	or     $0x1,%eax
c0105765:	89 c2                	mov    %eax,%edx
c0105767:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010576a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010576c:	8b 45 10             	mov    0x10(%ebp),%eax
c010576f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105773:	8b 45 08             	mov    0x8(%ebp),%eax
c0105776:	89 04 24             	mov    %eax,(%esp)
c0105779:	e8 07 00 00 00       	call   c0105785 <tlb_invalidate>
    return 0;
c010577e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105783:	c9                   	leave  
c0105784:	c3                   	ret    

c0105785 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105785:	55                   	push   %ebp
c0105786:	89 e5                	mov    %esp,%ebp
c0105788:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010578b:	0f 20 d8             	mov    %cr3,%eax
c010578e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105791:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105794:	89 c2                	mov    %eax,%edx
c0105796:	8b 45 08             	mov    0x8(%ebp),%eax
c0105799:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010579c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01057a3:	77 23                	ja     c01057c8 <tlb_invalidate+0x43>
c01057a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057ac:	c7 44 24 08 b0 aa 10 	movl   $0xc010aab0,0x8(%esp)
c01057b3:	c0 
c01057b4:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c01057bb:	00 
c01057bc:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01057c3:	e8 15 b5 ff ff       	call   c0100cdd <__panic>
c01057c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057cb:	05 00 00 00 40       	add    $0x40000000,%eax
c01057d0:	39 c2                	cmp    %eax,%edx
c01057d2:	75 0c                	jne    c01057e0 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01057d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01057da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057dd:	0f 01 38             	invlpg (%eax)
    }
}
c01057e0:	c9                   	leave  
c01057e1:	c3                   	ret    

c01057e2 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01057e2:	55                   	push   %ebp
c01057e3:	89 e5                	mov    %esp,%ebp
c01057e5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01057e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01057ef:	e8 3b f5 ff ff       	call   c0104d2f <alloc_pages>
c01057f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01057f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057fb:	0f 84 a7 00 00 00    	je     c01058a8 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105801:	8b 45 10             	mov    0x10(%ebp),%eax
c0105804:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105808:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010580f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105812:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105816:	8b 45 08             	mov    0x8(%ebp),%eax
c0105819:	89 04 24             	mov    %eax,(%esp)
c010581c:	e8 ab fe ff ff       	call   c01056cc <page_insert>
c0105821:	85 c0                	test   %eax,%eax
c0105823:	74 1a                	je     c010583f <pgdir_alloc_page+0x5d>
            free_page(page);
c0105825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010582c:	00 
c010582d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105830:	89 04 24             	mov    %eax,(%esp)
c0105833:	e8 62 f5 ff ff       	call   c0104d9a <free_pages>
            return NULL;
c0105838:	b8 00 00 00 00       	mov    $0x0,%eax
c010583d:	eb 6c                	jmp    c01058ab <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c010583f:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0105844:	85 c0                	test   %eax,%eax
c0105846:	74 60                	je     c01058a8 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105848:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010584d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105854:	00 
c0105855:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105858:	89 54 24 08          	mov    %edx,0x8(%esp)
c010585c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010585f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105863:	89 04 24             	mov    %eax,(%esp)
c0105866:	e8 3e 0e 00 00       	call   c01066a9 <swap_map_swappable>
            page->pra_vaddr=la;
c010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010586e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105871:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105874:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105877:	89 04 24             	mov    %eax,(%esp)
c010587a:	e8 ab f2 ff ff       	call   c0104b2a <page_ref>
c010587f:	83 f8 01             	cmp    $0x1,%eax
c0105882:	74 24                	je     c01058a8 <pgdir_alloc_page+0xc6>
c0105884:	c7 44 24 0c 34 ab 10 	movl   $0xc010ab34,0xc(%esp)
c010588b:	c0 
c010588c:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105893:	c0 
c0105894:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c010589b:	00 
c010589c:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01058a3:	e8 35 b4 ff ff       	call   c0100cdd <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01058a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058ab:	c9                   	leave  
c01058ac:	c3                   	ret    

c01058ad <check_alloc_page>:

static void
check_alloc_page(void) {
c01058ad:	55                   	push   %ebp
c01058ae:	89 e5                	mov    %esp,%ebp
c01058b0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01058b3:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c01058b8:	8b 40 18             	mov    0x18(%eax),%eax
c01058bb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01058bd:	c7 04 24 48 ab 10 c0 	movl   $0xc010ab48,(%esp)
c01058c4:	e8 8a aa ff ff       	call   c0100353 <cprintf>
}
c01058c9:	c9                   	leave  
c01058ca:	c3                   	ret    

c01058cb <check_pgdir>:

static void
check_pgdir(void) {
c01058cb:	55                   	push   %ebp
c01058cc:	89 e5                	mov    %esp,%ebp
c01058ce:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01058d1:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01058d6:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01058db:	76 24                	jbe    c0105901 <check_pgdir+0x36>
c01058dd:	c7 44 24 0c 67 ab 10 	movl   $0xc010ab67,0xc(%esp)
c01058e4:	c0 
c01058e5:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01058ec:	c0 
c01058ed:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c01058f4:	00 
c01058f5:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01058fc:	e8 dc b3 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105901:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105906:	85 c0                	test   %eax,%eax
c0105908:	74 0e                	je     c0105918 <check_pgdir+0x4d>
c010590a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010590f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105914:	85 c0                	test   %eax,%eax
c0105916:	74 24                	je     c010593c <check_pgdir+0x71>
c0105918:	c7 44 24 0c 84 ab 10 	movl   $0xc010ab84,0xc(%esp)
c010591f:	c0 
c0105920:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105927:	c0 
c0105928:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c010592f:	00 
c0105930:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105937:	e8 a1 b3 ff ff       	call   c0100cdd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010593c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105941:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105948:	00 
c0105949:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105950:	00 
c0105951:	89 04 24             	mov    %eax,(%esp)
c0105954:	e8 75 fc ff ff       	call   c01055ce <get_page>
c0105959:	85 c0                	test   %eax,%eax
c010595b:	74 24                	je     c0105981 <check_pgdir+0xb6>
c010595d:	c7 44 24 0c bc ab 10 	movl   $0xc010abbc,0xc(%esp)
c0105964:	c0 
c0105965:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c010596c:	c0 
c010596d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105974:	00 
c0105975:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010597c:	e8 5c b3 ff ff       	call   c0100cdd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105981:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105988:	e8 a2 f3 ff ff       	call   c0104d2f <alloc_pages>
c010598d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105990:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105995:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010599c:	00 
c010599d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059a4:	00 
c01059a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ac:	89 04 24             	mov    %eax,(%esp)
c01059af:	e8 18 fd ff ff       	call   c01056cc <page_insert>
c01059b4:	85 c0                	test   %eax,%eax
c01059b6:	74 24                	je     c01059dc <check_pgdir+0x111>
c01059b8:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c01059bf:	c0 
c01059c0:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01059c7:	c0 
c01059c8:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01059cf:	00 
c01059d0:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01059d7:	e8 01 b3 ff ff       	call   c0100cdd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01059dc:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059e8:	00 
c01059e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01059f0:	00 
c01059f1:	89 04 24             	mov    %eax,(%esp)
c01059f4:	e8 9d fa ff ff       	call   c0105496 <get_pte>
c01059f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a00:	75 24                	jne    c0105a26 <check_pgdir+0x15b>
c0105a02:	c7 44 24 0c 10 ac 10 	movl   $0xc010ac10,0xc(%esp)
c0105a09:	c0 
c0105a0a:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105a11:	c0 
c0105a12:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105a19:	00 
c0105a1a:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105a21:	e8 b7 b2 ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a29:	8b 00                	mov    (%eax),%eax
c0105a2b:	89 04 24             	mov    %eax,(%esp)
c0105a2e:	e8 20 f0 ff ff       	call   c0104a53 <pa2page>
c0105a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a36:	74 24                	je     c0105a5c <check_pgdir+0x191>
c0105a38:	c7 44 24 0c 3d ac 10 	movl   $0xc010ac3d,0xc(%esp)
c0105a3f:	c0 
c0105a40:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105a47:	c0 
c0105a48:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105a4f:	00 
c0105a50:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105a57:	e8 81 b2 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 1);
c0105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a5f:	89 04 24             	mov    %eax,(%esp)
c0105a62:	e8 c3 f0 ff ff       	call   c0104b2a <page_ref>
c0105a67:	83 f8 01             	cmp    $0x1,%eax
c0105a6a:	74 24                	je     c0105a90 <check_pgdir+0x1c5>
c0105a6c:	c7 44 24 0c 52 ac 10 	movl   $0xc010ac52,0xc(%esp)
c0105a73:	c0 
c0105a74:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105a7b:	c0 
c0105a7c:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105a83:	00 
c0105a84:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105a8b:	e8 4d b2 ff ff       	call   c0100cdd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105a90:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a95:	8b 00                	mov    (%eax),%eax
c0105a97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aa2:	c1 e8 0c             	shr    $0xc,%eax
c0105aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105aa8:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105aad:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105ab0:	72 23                	jb     c0105ad5 <check_pgdir+0x20a>
c0105ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ab9:	c7 44 24 08 0c aa 10 	movl   $0xc010aa0c,0x8(%esp)
c0105ac0:	c0 
c0105ac1:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105ac8:	00 
c0105ac9:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105ad0:	e8 08 b2 ff ff       	call   c0100cdd <__panic>
c0105ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105add:	83 c0 04             	add    $0x4,%eax
c0105ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105ae3:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ae8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105aef:	00 
c0105af0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105af7:	00 
c0105af8:	89 04 24             	mov    %eax,(%esp)
c0105afb:	e8 96 f9 ff ff       	call   c0105496 <get_pte>
c0105b00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105b03:	74 24                	je     c0105b29 <check_pgdir+0x25e>
c0105b05:	c7 44 24 0c 64 ac 10 	movl   $0xc010ac64,0xc(%esp)
c0105b0c:	c0 
c0105b0d:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105b14:	c0 
c0105b15:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105b1c:	00 
c0105b1d:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105b24:	e8 b4 b1 ff ff       	call   c0100cdd <__panic>

    p2 = alloc_page();
c0105b29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b30:	e8 fa f1 ff ff       	call   c0104d2f <alloc_pages>
c0105b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105b38:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b3d:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105b44:	00 
c0105b45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b4c:	00 
c0105b4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b50:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b54:	89 04 24             	mov    %eax,(%esp)
c0105b57:	e8 70 fb ff ff       	call   c01056cc <page_insert>
c0105b5c:	85 c0                	test   %eax,%eax
c0105b5e:	74 24                	je     c0105b84 <check_pgdir+0x2b9>
c0105b60:	c7 44 24 0c 8c ac 10 	movl   $0xc010ac8c,0xc(%esp)
c0105b67:	c0 
c0105b68:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105b6f:	c0 
c0105b70:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105b77:	00 
c0105b78:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105b7f:	e8 59 b1 ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105b84:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b89:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b90:	00 
c0105b91:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b98:	00 
c0105b99:	89 04 24             	mov    %eax,(%esp)
c0105b9c:	e8 f5 f8 ff ff       	call   c0105496 <get_pte>
c0105ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ba4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ba8:	75 24                	jne    c0105bce <check_pgdir+0x303>
c0105baa:	c7 44 24 0c c4 ac 10 	movl   $0xc010acc4,0xc(%esp)
c0105bb1:	c0 
c0105bb2:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105bb9:	c0 
c0105bba:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105bc1:	00 
c0105bc2:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105bc9:	e8 0f b1 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_U);
c0105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd1:	8b 00                	mov    (%eax),%eax
c0105bd3:	83 e0 04             	and    $0x4,%eax
c0105bd6:	85 c0                	test   %eax,%eax
c0105bd8:	75 24                	jne    c0105bfe <check_pgdir+0x333>
c0105bda:	c7 44 24 0c f4 ac 10 	movl   $0xc010acf4,0xc(%esp)
c0105be1:	c0 
c0105be2:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105be9:	c0 
c0105bea:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105bf1:	00 
c0105bf2:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105bf9:	e8 df b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_W);
c0105bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c01:	8b 00                	mov    (%eax),%eax
c0105c03:	83 e0 02             	and    $0x2,%eax
c0105c06:	85 c0                	test   %eax,%eax
c0105c08:	75 24                	jne    c0105c2e <check_pgdir+0x363>
c0105c0a:	c7 44 24 0c 02 ad 10 	movl   $0xc010ad02,0xc(%esp)
c0105c11:	c0 
c0105c12:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105c19:	c0 
c0105c1a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105c21:	00 
c0105c22:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105c29:	e8 af b0 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105c2e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c33:	8b 00                	mov    (%eax),%eax
c0105c35:	83 e0 04             	and    $0x4,%eax
c0105c38:	85 c0                	test   %eax,%eax
c0105c3a:	75 24                	jne    c0105c60 <check_pgdir+0x395>
c0105c3c:	c7 44 24 0c 10 ad 10 	movl   $0xc010ad10,0xc(%esp)
c0105c43:	c0 
c0105c44:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105c4b:	c0 
c0105c4c:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105c53:	00 
c0105c54:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105c5b:	e8 7d b0 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 1);
c0105c60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c63:	89 04 24             	mov    %eax,(%esp)
c0105c66:	e8 bf ee ff ff       	call   c0104b2a <page_ref>
c0105c6b:	83 f8 01             	cmp    $0x1,%eax
c0105c6e:	74 24                	je     c0105c94 <check_pgdir+0x3c9>
c0105c70:	c7 44 24 0c 26 ad 10 	movl   $0xc010ad26,0xc(%esp)
c0105c77:	c0 
c0105c78:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105c7f:	c0 
c0105c80:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105c87:	00 
c0105c88:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105c8f:	e8 49 b0 ff ff       	call   c0100cdd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105c94:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c99:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105ca0:	00 
c0105ca1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105ca8:	00 
c0105ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105cb0:	89 04 24             	mov    %eax,(%esp)
c0105cb3:	e8 14 fa ff ff       	call   c01056cc <page_insert>
c0105cb8:	85 c0                	test   %eax,%eax
c0105cba:	74 24                	je     c0105ce0 <check_pgdir+0x415>
c0105cbc:	c7 44 24 0c 38 ad 10 	movl   $0xc010ad38,0xc(%esp)
c0105cc3:	c0 
c0105cc4:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105ccb:	c0 
c0105ccc:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105cd3:	00 
c0105cd4:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105cdb:	e8 fd af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 2);
c0105ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce3:	89 04 24             	mov    %eax,(%esp)
c0105ce6:	e8 3f ee ff ff       	call   c0104b2a <page_ref>
c0105ceb:	83 f8 02             	cmp    $0x2,%eax
c0105cee:	74 24                	je     c0105d14 <check_pgdir+0x449>
c0105cf0:	c7 44 24 0c 64 ad 10 	movl   $0xc010ad64,0xc(%esp)
c0105cf7:	c0 
c0105cf8:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105cff:	c0 
c0105d00:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105d07:	00 
c0105d08:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105d0f:	e8 c9 af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105d14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d17:	89 04 24             	mov    %eax,(%esp)
c0105d1a:	e8 0b ee ff ff       	call   c0104b2a <page_ref>
c0105d1f:	85 c0                	test   %eax,%eax
c0105d21:	74 24                	je     c0105d47 <check_pgdir+0x47c>
c0105d23:	c7 44 24 0c 76 ad 10 	movl   $0xc010ad76,0xc(%esp)
c0105d2a:	c0 
c0105d2b:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105d32:	c0 
c0105d33:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105d3a:	00 
c0105d3b:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105d42:	e8 96 af ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105d47:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d53:	00 
c0105d54:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d5b:	00 
c0105d5c:	89 04 24             	mov    %eax,(%esp)
c0105d5f:	e8 32 f7 ff ff       	call   c0105496 <get_pte>
c0105d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d6b:	75 24                	jne    c0105d91 <check_pgdir+0x4c6>
c0105d6d:	c7 44 24 0c c4 ac 10 	movl   $0xc010acc4,0xc(%esp)
c0105d74:	c0 
c0105d75:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105d7c:	c0 
c0105d7d:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105d84:	00 
c0105d85:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105d8c:	e8 4c af ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d94:	8b 00                	mov    (%eax),%eax
c0105d96:	89 04 24             	mov    %eax,(%esp)
c0105d99:	e8 b5 ec ff ff       	call   c0104a53 <pa2page>
c0105d9e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105da1:	74 24                	je     c0105dc7 <check_pgdir+0x4fc>
c0105da3:	c7 44 24 0c 3d ac 10 	movl   $0xc010ac3d,0xc(%esp)
c0105daa:	c0 
c0105dab:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105db2:	c0 
c0105db3:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105dba:	00 
c0105dbb:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105dc2:	e8 16 af ff ff       	call   c0100cdd <__panic>
    assert((*ptep & PTE_U) == 0);
c0105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dca:	8b 00                	mov    (%eax),%eax
c0105dcc:	83 e0 04             	and    $0x4,%eax
c0105dcf:	85 c0                	test   %eax,%eax
c0105dd1:	74 24                	je     c0105df7 <check_pgdir+0x52c>
c0105dd3:	c7 44 24 0c 88 ad 10 	movl   $0xc010ad88,0xc(%esp)
c0105dda:	c0 
c0105ddb:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105de2:	c0 
c0105de3:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105dea:	00 
c0105deb:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105df2:	e8 e6 ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, 0x0);
c0105df7:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105dfc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105e03:	00 
c0105e04:	89 04 24             	mov    %eax,(%esp)
c0105e07:	e8 7c f8 ff ff       	call   c0105688 <page_remove>
    assert(page_ref(p1) == 1);
c0105e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e0f:	89 04 24             	mov    %eax,(%esp)
c0105e12:	e8 13 ed ff ff       	call   c0104b2a <page_ref>
c0105e17:	83 f8 01             	cmp    $0x1,%eax
c0105e1a:	74 24                	je     c0105e40 <check_pgdir+0x575>
c0105e1c:	c7 44 24 0c 52 ac 10 	movl   $0xc010ac52,0xc(%esp)
c0105e23:	c0 
c0105e24:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105e2b:	c0 
c0105e2c:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105e33:	00 
c0105e34:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105e3b:	e8 9d ae ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e43:	89 04 24             	mov    %eax,(%esp)
c0105e46:	e8 df ec ff ff       	call   c0104b2a <page_ref>
c0105e4b:	85 c0                	test   %eax,%eax
c0105e4d:	74 24                	je     c0105e73 <check_pgdir+0x5a8>
c0105e4f:	c7 44 24 0c 76 ad 10 	movl   $0xc010ad76,0xc(%esp)
c0105e56:	c0 
c0105e57:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105e5e:	c0 
c0105e5f:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105e66:	00 
c0105e67:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105e6e:	e8 6a ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105e73:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e78:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e7f:	00 
c0105e80:	89 04 24             	mov    %eax,(%esp)
c0105e83:	e8 00 f8 ff ff       	call   c0105688 <page_remove>
    assert(page_ref(p1) == 0);
c0105e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e8b:	89 04 24             	mov    %eax,(%esp)
c0105e8e:	e8 97 ec ff ff       	call   c0104b2a <page_ref>
c0105e93:	85 c0                	test   %eax,%eax
c0105e95:	74 24                	je     c0105ebb <check_pgdir+0x5f0>
c0105e97:	c7 44 24 0c 9d ad 10 	movl   $0xc010ad9d,0xc(%esp)
c0105e9e:	c0 
c0105e9f:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105ea6:	c0 
c0105ea7:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105eae:	00 
c0105eaf:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105eb6:	e8 22 ae ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ebe:	89 04 24             	mov    %eax,(%esp)
c0105ec1:	e8 64 ec ff ff       	call   c0104b2a <page_ref>
c0105ec6:	85 c0                	test   %eax,%eax
c0105ec8:	74 24                	je     c0105eee <check_pgdir+0x623>
c0105eca:	c7 44 24 0c 76 ad 10 	movl   $0xc010ad76,0xc(%esp)
c0105ed1:	c0 
c0105ed2:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105ed9:	c0 
c0105eda:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105ee1:	00 
c0105ee2:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105ee9:	e8 ef ad ff ff       	call   c0100cdd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105eee:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ef3:	8b 00                	mov    (%eax),%eax
c0105ef5:	89 04 24             	mov    %eax,(%esp)
c0105ef8:	e8 56 eb ff ff       	call   c0104a53 <pa2page>
c0105efd:	89 04 24             	mov    %eax,(%esp)
c0105f00:	e8 25 ec ff ff       	call   c0104b2a <page_ref>
c0105f05:	83 f8 01             	cmp    $0x1,%eax
c0105f08:	74 24                	je     c0105f2e <check_pgdir+0x663>
c0105f0a:	c7 44 24 0c b0 ad 10 	movl   $0xc010adb0,0xc(%esp)
c0105f11:	c0 
c0105f12:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105f19:	c0 
c0105f1a:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105f21:	00 
c0105f22:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105f29:	e8 af ad ff ff       	call   c0100cdd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105f2e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f33:	8b 00                	mov    (%eax),%eax
c0105f35:	89 04 24             	mov    %eax,(%esp)
c0105f38:	e8 16 eb ff ff       	call   c0104a53 <pa2page>
c0105f3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f44:	00 
c0105f45:	89 04 24             	mov    %eax,(%esp)
c0105f48:	e8 4d ee ff ff       	call   c0104d9a <free_pages>
    boot_pgdir[0] = 0;
c0105f4d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105f58:	c7 04 24 d6 ad 10 c0 	movl   $0xc010add6,(%esp)
c0105f5f:	e8 ef a3 ff ff       	call   c0100353 <cprintf>
}
c0105f64:	c9                   	leave  
c0105f65:	c3                   	ret    

c0105f66 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105f66:	55                   	push   %ebp
c0105f67:	89 e5                	mov    %esp,%ebp
c0105f69:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105f6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105f73:	e9 ca 00 00 00       	jmp    c0106042 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f81:	c1 e8 0c             	shr    $0xc,%eax
c0105f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f87:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105f8c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105f8f:	72 23                	jb     c0105fb4 <check_boot_pgdir+0x4e>
c0105f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f94:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f98:	c7 44 24 08 0c aa 10 	movl   $0xc010aa0c,0x8(%esp)
c0105f9f:	c0 
c0105fa0:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105fa7:	00 
c0105fa8:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105faf:	e8 29 ad ff ff       	call   c0100cdd <__panic>
c0105fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105fbc:	89 c2                	mov    %eax,%edx
c0105fbe:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fc3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fca:	00 
c0105fcb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fcf:	89 04 24             	mov    %eax,(%esp)
c0105fd2:	e8 bf f4 ff ff       	call   c0105496 <get_pte>
c0105fd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105fda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105fde:	75 24                	jne    c0106004 <check_boot_pgdir+0x9e>
c0105fe0:	c7 44 24 0c f0 ad 10 	movl   $0xc010adf0,0xc(%esp)
c0105fe7:	c0 
c0105fe8:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0105fef:	c0 
c0105ff0:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105ff7:	00 
c0105ff8:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0105fff:	e8 d9 ac ff ff       	call   c0100cdd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106004:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106007:	8b 00                	mov    (%eax),%eax
c0106009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010600e:	89 c2                	mov    %eax,%edx
c0106010:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106013:	39 c2                	cmp    %eax,%edx
c0106015:	74 24                	je     c010603b <check_boot_pgdir+0xd5>
c0106017:	c7 44 24 0c 2d ae 10 	movl   $0xc010ae2d,0xc(%esp)
c010601e:	c0 
c010601f:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0106026:	c0 
c0106027:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c010602e:	00 
c010602f:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0106036:	e8 a2 ac ff ff       	call   c0100cdd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010603b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106042:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106045:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010604a:	39 c2                	cmp    %eax,%edx
c010604c:	0f 82 26 ff ff ff    	jb     c0105f78 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106052:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106057:	05 ac 0f 00 00       	add    $0xfac,%eax
c010605c:	8b 00                	mov    (%eax),%eax
c010605e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106063:	89 c2                	mov    %eax,%edx
c0106065:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010606a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010606d:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0106074:	77 23                	ja     c0106099 <check_boot_pgdir+0x133>
c0106076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106079:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010607d:	c7 44 24 08 b0 aa 10 	movl   $0xc010aab0,0x8(%esp)
c0106084:	c0 
c0106085:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c010608c:	00 
c010608d:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0106094:	e8 44 ac ff ff       	call   c0100cdd <__panic>
c0106099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010609c:	05 00 00 00 40       	add    $0x40000000,%eax
c01060a1:	39 c2                	cmp    %eax,%edx
c01060a3:	74 24                	je     c01060c9 <check_boot_pgdir+0x163>
c01060a5:	c7 44 24 0c 44 ae 10 	movl   $0xc010ae44,0xc(%esp)
c01060ac:	c0 
c01060ad:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01060b4:	c0 
c01060b5:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c01060bc:	00 
c01060bd:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01060c4:	e8 14 ac ff ff       	call   c0100cdd <__panic>

    assert(boot_pgdir[0] == 0);
c01060c9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01060ce:	8b 00                	mov    (%eax),%eax
c01060d0:	85 c0                	test   %eax,%eax
c01060d2:	74 24                	je     c01060f8 <check_boot_pgdir+0x192>
c01060d4:	c7 44 24 0c 78 ae 10 	movl   $0xc010ae78,0xc(%esp)
c01060db:	c0 
c01060dc:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01060e3:	c0 
c01060e4:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c01060eb:	00 
c01060ec:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01060f3:	e8 e5 ab ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    p = alloc_page();
c01060f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060ff:	e8 2b ec ff ff       	call   c0104d2f <alloc_pages>
c0106104:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106107:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010610c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106113:	00 
c0106114:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010611b:	00 
c010611c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010611f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106123:	89 04 24             	mov    %eax,(%esp)
c0106126:	e8 a1 f5 ff ff       	call   c01056cc <page_insert>
c010612b:	85 c0                	test   %eax,%eax
c010612d:	74 24                	je     c0106153 <check_boot_pgdir+0x1ed>
c010612f:	c7 44 24 0c 8c ae 10 	movl   $0xc010ae8c,0xc(%esp)
c0106136:	c0 
c0106137:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c010613e:	c0 
c010613f:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0106146:	00 
c0106147:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010614e:	e8 8a ab ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 1);
c0106153:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106156:	89 04 24             	mov    %eax,(%esp)
c0106159:	e8 cc e9 ff ff       	call   c0104b2a <page_ref>
c010615e:	83 f8 01             	cmp    $0x1,%eax
c0106161:	74 24                	je     c0106187 <check_boot_pgdir+0x221>
c0106163:	c7 44 24 0c ba ae 10 	movl   $0xc010aeba,0xc(%esp)
c010616a:	c0 
c010616b:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0106172:	c0 
c0106173:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c010617a:	00 
c010617b:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0106182:	e8 56 ab ff ff       	call   c0100cdd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106187:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010618c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106193:	00 
c0106194:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010619b:	00 
c010619c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010619f:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061a3:	89 04 24             	mov    %eax,(%esp)
c01061a6:	e8 21 f5 ff ff       	call   c01056cc <page_insert>
c01061ab:	85 c0                	test   %eax,%eax
c01061ad:	74 24                	je     c01061d3 <check_boot_pgdir+0x26d>
c01061af:	c7 44 24 0c cc ae 10 	movl   $0xc010aecc,0xc(%esp)
c01061b6:	c0 
c01061b7:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01061be:	c0 
c01061bf:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c01061c6:	00 
c01061c7:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c01061ce:	e8 0a ab ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 2);
c01061d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061d6:	89 04 24             	mov    %eax,(%esp)
c01061d9:	e8 4c e9 ff ff       	call   c0104b2a <page_ref>
c01061de:	83 f8 02             	cmp    $0x2,%eax
c01061e1:	74 24                	je     c0106207 <check_boot_pgdir+0x2a1>
c01061e3:	c7 44 24 0c 03 af 10 	movl   $0xc010af03,0xc(%esp)
c01061ea:	c0 
c01061eb:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c01061f2:	c0 
c01061f3:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c01061fa:	00 
c01061fb:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0106202:	e8 d6 aa ff ff       	call   c0100cdd <__panic>

    const char *str = "ucore: Hello world!!";
c0106207:	c7 45 dc 14 af 10 c0 	movl   $0xc010af14,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010620e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106211:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106215:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010621c:	e8 6f 36 00 00       	call   c0109890 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106221:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106228:	00 
c0106229:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106230:	e8 d4 36 00 00       	call   c0109909 <strcmp>
c0106235:	85 c0                	test   %eax,%eax
c0106237:	74 24                	je     c010625d <check_boot_pgdir+0x2f7>
c0106239:	c7 44 24 0c 2c af 10 	movl   $0xc010af2c,0xc(%esp)
c0106240:	c0 
c0106241:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c0106248:	c0 
c0106249:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0106250:	00 
c0106251:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c0106258:	e8 80 aa ff ff       	call   c0100cdd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010625d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106260:	89 04 24             	mov    %eax,(%esp)
c0106263:	e8 30 e8 ff ff       	call   c0104a98 <page2kva>
c0106268:	05 00 01 00 00       	add    $0x100,%eax
c010626d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106270:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106277:	e8 bc 35 00 00       	call   c0109838 <strlen>
c010627c:	85 c0                	test   %eax,%eax
c010627e:	74 24                	je     c01062a4 <check_boot_pgdir+0x33e>
c0106280:	c7 44 24 0c 64 af 10 	movl   $0xc010af64,0xc(%esp)
c0106287:	c0 
c0106288:	c7 44 24 08 f9 aa 10 	movl   $0xc010aaf9,0x8(%esp)
c010628f:	c0 
c0106290:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c0106297:	00 
c0106298:	c7 04 24 d4 aa 10 c0 	movl   $0xc010aad4,(%esp)
c010629f:	e8 39 aa ff ff       	call   c0100cdd <__panic>

    free_page(p);
c01062a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062ab:	00 
c01062ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062af:	89 04 24             	mov    %eax,(%esp)
c01062b2:	e8 e3 ea ff ff       	call   c0104d9a <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01062b7:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062bc:	8b 00                	mov    (%eax),%eax
c01062be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062c3:	89 04 24             	mov    %eax,(%esp)
c01062c6:	e8 88 e7 ff ff       	call   c0104a53 <pa2page>
c01062cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062d2:	00 
c01062d3:	89 04 24             	mov    %eax,(%esp)
c01062d6:	e8 bf ea ff ff       	call   c0104d9a <free_pages>
    boot_pgdir[0] = 0;
c01062db:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01062e6:	c7 04 24 88 af 10 c0 	movl   $0xc010af88,(%esp)
c01062ed:	e8 61 a0 ff ff       	call   c0100353 <cprintf>
}
c01062f2:	c9                   	leave  
c01062f3:	c3                   	ret    

c01062f4 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01062f4:	55                   	push   %ebp
c01062f5:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01062f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01062fa:	83 e0 04             	and    $0x4,%eax
c01062fd:	85 c0                	test   %eax,%eax
c01062ff:	74 07                	je     c0106308 <perm2str+0x14>
c0106301:	b8 75 00 00 00       	mov    $0x75,%eax
c0106306:	eb 05                	jmp    c010630d <perm2str+0x19>
c0106308:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010630d:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c0106312:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106319:	8b 45 08             	mov    0x8(%ebp),%eax
c010631c:	83 e0 02             	and    $0x2,%eax
c010631f:	85 c0                	test   %eax,%eax
c0106321:	74 07                	je     c010632a <perm2str+0x36>
c0106323:	b8 77 00 00 00       	mov    $0x77,%eax
c0106328:	eb 05                	jmp    c010632f <perm2str+0x3b>
c010632a:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010632f:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c0106334:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c010633b:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c0106340:	5d                   	pop    %ebp
c0106341:	c3                   	ret    

c0106342 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106342:	55                   	push   %ebp
c0106343:	89 e5                	mov    %esp,%ebp
c0106345:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106348:	8b 45 10             	mov    0x10(%ebp),%eax
c010634b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010634e:	72 0a                	jb     c010635a <get_pgtable_items+0x18>
        return 0;
c0106350:	b8 00 00 00 00       	mov    $0x0,%eax
c0106355:	e9 9c 00 00 00       	jmp    c01063f6 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010635a:	eb 04                	jmp    c0106360 <get_pgtable_items+0x1e>
        start ++;
c010635c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106360:	8b 45 10             	mov    0x10(%ebp),%eax
c0106363:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106366:	73 18                	jae    c0106380 <get_pgtable_items+0x3e>
c0106368:	8b 45 10             	mov    0x10(%ebp),%eax
c010636b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106372:	8b 45 14             	mov    0x14(%ebp),%eax
c0106375:	01 d0                	add    %edx,%eax
c0106377:	8b 00                	mov    (%eax),%eax
c0106379:	83 e0 01             	and    $0x1,%eax
c010637c:	85 c0                	test   %eax,%eax
c010637e:	74 dc                	je     c010635c <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106380:	8b 45 10             	mov    0x10(%ebp),%eax
c0106383:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106386:	73 69                	jae    c01063f1 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106388:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010638c:	74 08                	je     c0106396 <get_pgtable_items+0x54>
            *left_store = start;
c010638e:	8b 45 18             	mov    0x18(%ebp),%eax
c0106391:	8b 55 10             	mov    0x10(%ebp),%edx
c0106394:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106396:	8b 45 10             	mov    0x10(%ebp),%eax
c0106399:	8d 50 01             	lea    0x1(%eax),%edx
c010639c:	89 55 10             	mov    %edx,0x10(%ebp)
c010639f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063a6:	8b 45 14             	mov    0x14(%ebp),%eax
c01063a9:	01 d0                	add    %edx,%eax
c01063ab:	8b 00                	mov    (%eax),%eax
c01063ad:	83 e0 07             	and    $0x7,%eax
c01063b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063b3:	eb 04                	jmp    c01063b9 <get_pgtable_items+0x77>
            start ++;
c01063b5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01063bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063bf:	73 1d                	jae    c01063de <get_pgtable_items+0x9c>
c01063c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01063c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01063ce:	01 d0                	add    %edx,%eax
c01063d0:	8b 00                	mov    (%eax),%eax
c01063d2:	83 e0 07             	and    $0x7,%eax
c01063d5:	89 c2                	mov    %eax,%edx
c01063d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01063da:	39 c2                	cmp    %eax,%edx
c01063dc:	74 d7                	je     c01063b5 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01063de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01063e2:	74 08                	je     c01063ec <get_pgtable_items+0xaa>
            *right_store = start;
c01063e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01063e7:	8b 55 10             	mov    0x10(%ebp),%edx
c01063ea:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01063ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01063ef:	eb 05                	jmp    c01063f6 <get_pgtable_items+0xb4>
    }
    return 0;
c01063f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063f6:	c9                   	leave  
c01063f7:	c3                   	ret    

c01063f8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01063f8:	55                   	push   %ebp
c01063f9:	89 e5                	mov    %esp,%ebp
c01063fb:	57                   	push   %edi
c01063fc:	56                   	push   %esi
c01063fd:	53                   	push   %ebx
c01063fe:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106401:	c7 04 24 a8 af 10 c0 	movl   $0xc010afa8,(%esp)
c0106408:	e8 46 9f ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c010640d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106414:	e9 fa 00 00 00       	jmp    c0106513 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010641c:	89 04 24             	mov    %eax,(%esp)
c010641f:	e8 d0 fe ff ff       	call   c01062f4 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106424:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106427:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010642a:	29 d1                	sub    %edx,%ecx
c010642c:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010642e:	89 d6                	mov    %edx,%esi
c0106430:	c1 e6 16             	shl    $0x16,%esi
c0106433:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106436:	89 d3                	mov    %edx,%ebx
c0106438:	c1 e3 16             	shl    $0x16,%ebx
c010643b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010643e:	89 d1                	mov    %edx,%ecx
c0106440:	c1 e1 16             	shl    $0x16,%ecx
c0106443:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106446:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106449:	29 d7                	sub    %edx,%edi
c010644b:	89 fa                	mov    %edi,%edx
c010644d:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106451:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106455:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106459:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010645d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106461:	c7 04 24 d9 af 10 c0 	movl   $0xc010afd9,(%esp)
c0106468:	e8 e6 9e ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010646d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106470:	c1 e0 0a             	shl    $0xa,%eax
c0106473:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106476:	eb 54                	jmp    c01064cc <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010647b:	89 04 24             	mov    %eax,(%esp)
c010647e:	e8 71 fe ff ff       	call   c01062f4 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106483:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106486:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106489:	29 d1                	sub    %edx,%ecx
c010648b:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010648d:	89 d6                	mov    %edx,%esi
c010648f:	c1 e6 0c             	shl    $0xc,%esi
c0106492:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106495:	89 d3                	mov    %edx,%ebx
c0106497:	c1 e3 0c             	shl    $0xc,%ebx
c010649a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010649d:	c1 e2 0c             	shl    $0xc,%edx
c01064a0:	89 d1                	mov    %edx,%ecx
c01064a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01064a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064a8:	29 d7                	sub    %edx,%edi
c01064aa:	89 fa                	mov    %edi,%edx
c01064ac:	89 44 24 14          	mov    %eax,0x14(%esp)
c01064b0:	89 74 24 10          	mov    %esi,0x10(%esp)
c01064b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01064b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01064bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064c0:	c7 04 24 f8 af 10 c0 	movl   $0xc010aff8,(%esp)
c01064c7:	e8 87 9e ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01064cc:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01064d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01064d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01064d7:	89 ce                	mov    %ecx,%esi
c01064d9:	c1 e6 0a             	shl    $0xa,%esi
c01064dc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01064df:	89 cb                	mov    %ecx,%ebx
c01064e1:	c1 e3 0a             	shl    $0xa,%ebx
c01064e4:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01064e7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01064eb:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01064ee:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01064f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01064f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01064fa:	89 74 24 04          	mov    %esi,0x4(%esp)
c01064fe:	89 1c 24             	mov    %ebx,(%esp)
c0106501:	e8 3c fe ff ff       	call   c0106342 <get_pgtable_items>
c0106506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010650d:	0f 85 65 ff ff ff    	jne    c0106478 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106513:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106518:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010651b:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010651e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106522:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106525:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106529:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010652d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106531:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106538:	00 
c0106539:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106540:	e8 fd fd ff ff       	call   c0106342 <get_pgtable_items>
c0106545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106548:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010654c:	0f 85 c7 fe ff ff    	jne    c0106419 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106552:	c7 04 24 1c b0 10 c0 	movl   $0xc010b01c,(%esp)
c0106559:	e8 f5 9d ff ff       	call   c0100353 <cprintf>
}
c010655e:	83 c4 4c             	add    $0x4c,%esp
c0106561:	5b                   	pop    %ebx
c0106562:	5e                   	pop    %esi
c0106563:	5f                   	pop    %edi
c0106564:	5d                   	pop    %ebp
c0106565:	c3                   	ret    

c0106566 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106566:	55                   	push   %ebp
c0106567:	89 e5                	mov    %esp,%ebp
c0106569:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010656c:	8b 45 08             	mov    0x8(%ebp),%eax
c010656f:	c1 e8 0c             	shr    $0xc,%eax
c0106572:	89 c2                	mov    %eax,%edx
c0106574:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0106579:	39 c2                	cmp    %eax,%edx
c010657b:	72 1c                	jb     c0106599 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010657d:	c7 44 24 08 50 b0 10 	movl   $0xc010b050,0x8(%esp)
c0106584:	c0 
c0106585:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010658c:	00 
c010658d:	c7 04 24 6f b0 10 c0 	movl   $0xc010b06f,(%esp)
c0106594:	e8 44 a7 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0106599:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010659e:	8b 55 08             	mov    0x8(%ebp),%edx
c01065a1:	c1 ea 0c             	shr    $0xc,%edx
c01065a4:	c1 e2 05             	shl    $0x5,%edx
c01065a7:	01 d0                	add    %edx,%eax
}
c01065a9:	c9                   	leave  
c01065aa:	c3                   	ret    

c01065ab <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01065ab:	55                   	push   %ebp
c01065ac:	89 e5                	mov    %esp,%ebp
c01065ae:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01065b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01065b4:	83 e0 01             	and    $0x1,%eax
c01065b7:	85 c0                	test   %eax,%eax
c01065b9:	75 1c                	jne    c01065d7 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01065bb:	c7 44 24 08 80 b0 10 	movl   $0xc010b080,0x8(%esp)
c01065c2:	c0 
c01065c3:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01065ca:	00 
c01065cb:	c7 04 24 6f b0 10 c0 	movl   $0xc010b06f,(%esp)
c01065d2:	e8 06 a7 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01065d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01065da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01065df:	89 04 24             	mov    %eax,(%esp)
c01065e2:	e8 7f ff ff ff       	call   c0106566 <pa2page>
}
c01065e7:	c9                   	leave  
c01065e8:	c3                   	ret    

c01065e9 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01065e9:	55                   	push   %ebp
c01065ea:	89 e5                	mov    %esp,%ebp
c01065ec:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01065ef:	e8 a0 1d 00 00       	call   c0108394 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01065f4:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01065f9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01065fe:	76 0c                	jbe    c010660c <swap_init+0x23>
c0106600:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106605:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c010660a:	76 25                	jbe    c0106631 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010660c:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106611:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106615:	c7 44 24 08 a1 b0 10 	movl   $0xc010b0a1,0x8(%esp)
c010661c:	c0 
c010661d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106624:	00 
c0106625:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c010662c:	e8 ac a6 ff ff       	call   c0100cdd <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106631:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c0106638:	4a 12 c0 
     int r = sm->init();
c010663b:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106640:	8b 40 04             	mov    0x4(%eax),%eax
c0106643:	ff d0                	call   *%eax
c0106645:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010664c:	75 26                	jne    c0106674 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010664e:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c0106655:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106658:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010665d:	8b 00                	mov    (%eax),%eax
c010665f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106663:	c7 04 24 cb b0 10 c0 	movl   $0xc010b0cb,(%esp)
c010666a:	e8 e4 9c ff ff       	call   c0100353 <cprintf>
          check_swap();
c010666f:	e8 a4 04 00 00       	call   c0106b18 <check_swap>
     }

     return r;
c0106674:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106677:	c9                   	leave  
c0106678:	c3                   	ret    

c0106679 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106679:	55                   	push   %ebp
c010667a:	89 e5                	mov    %esp,%ebp
c010667c:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010667f:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106684:	8b 40 08             	mov    0x8(%eax),%eax
c0106687:	8b 55 08             	mov    0x8(%ebp),%edx
c010668a:	89 14 24             	mov    %edx,(%esp)
c010668d:	ff d0                	call   *%eax
}
c010668f:	c9                   	leave  
c0106690:	c3                   	ret    

c0106691 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106691:	55                   	push   %ebp
c0106692:	89 e5                	mov    %esp,%ebp
c0106694:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106697:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010669c:	8b 40 0c             	mov    0xc(%eax),%eax
c010669f:	8b 55 08             	mov    0x8(%ebp),%edx
c01066a2:	89 14 24             	mov    %edx,(%esp)
c01066a5:	ff d0                	call   *%eax
}
c01066a7:	c9                   	leave  
c01066a8:	c3                   	ret    

c01066a9 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01066a9:	55                   	push   %ebp
c01066aa:	89 e5                	mov    %esp,%ebp
c01066ac:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01066af:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066b4:	8b 40 10             	mov    0x10(%eax),%eax
c01066b7:	8b 55 14             	mov    0x14(%ebp),%edx
c01066ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01066be:	8b 55 10             	mov    0x10(%ebp),%edx
c01066c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01066c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01066cf:	89 14 24             	mov    %edx,(%esp)
c01066d2:	ff d0                	call   *%eax
}
c01066d4:	c9                   	leave  
c01066d5:	c3                   	ret    

c01066d6 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01066d6:	55                   	push   %ebp
c01066d7:	89 e5                	mov    %esp,%ebp
c01066d9:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01066dc:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066e1:	8b 40 14             	mov    0x14(%eax),%eax
c01066e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01066ee:	89 14 24             	mov    %edx,(%esp)
c01066f1:	ff d0                	call   *%eax
}
c01066f3:	c9                   	leave  
c01066f4:	c3                   	ret    

c01066f5 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01066f5:	55                   	push   %ebp
c01066f6:	89 e5                	mov    %esp,%ebp
c01066f8:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01066fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106702:	e9 5a 01 00 00       	jmp    c0106861 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106707:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010670c:	8b 40 18             	mov    0x18(%eax),%eax
c010670f:	8b 55 10             	mov    0x10(%ebp),%edx
c0106712:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106716:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106719:	89 54 24 04          	mov    %edx,0x4(%esp)
c010671d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106720:	89 14 24             	mov    %edx,(%esp)
c0106723:	ff d0                	call   *%eax
c0106725:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106728:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010672c:	74 18                	je     c0106746 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010672e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106731:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106735:	c7 04 24 e0 b0 10 c0 	movl   $0xc010b0e0,(%esp)
c010673c:	e8 12 9c ff ff       	call   c0100353 <cprintf>
c0106741:	e9 27 01 00 00       	jmp    c010686d <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106749:	8b 40 1c             	mov    0x1c(%eax),%eax
c010674c:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010674f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106752:	8b 40 0c             	mov    0xc(%eax),%eax
c0106755:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010675c:	00 
c010675d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106760:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106764:	89 04 24             	mov    %eax,(%esp)
c0106767:	e8 2a ed ff ff       	call   c0105496 <get_pte>
c010676c:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010676f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106772:	8b 00                	mov    (%eax),%eax
c0106774:	83 e0 01             	and    $0x1,%eax
c0106777:	85 c0                	test   %eax,%eax
c0106779:	75 24                	jne    c010679f <swap_out+0xaa>
c010677b:	c7 44 24 0c 0d b1 10 	movl   $0xc010b10d,0xc(%esp)
c0106782:	c0 
c0106783:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c010678a:	c0 
c010678b:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106792:	00 
c0106793:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c010679a:	e8 3e a5 ff ff       	call   c0100cdd <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010679f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067a5:	8b 52 1c             	mov    0x1c(%edx),%edx
c01067a8:	c1 ea 0c             	shr    $0xc,%edx
c01067ab:	83 c2 01             	add    $0x1,%edx
c01067ae:	c1 e2 08             	shl    $0x8,%edx
c01067b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067b5:	89 14 24             	mov    %edx,(%esp)
c01067b8:	e8 91 1c 00 00       	call   c010844e <swapfs_write>
c01067bd:	85 c0                	test   %eax,%eax
c01067bf:	74 34                	je     c01067f5 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01067c1:	c7 04 24 37 b1 10 c0 	movl   $0xc010b137,(%esp)
c01067c8:	e8 86 9b ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01067cd:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067d2:	8b 40 10             	mov    0x10(%eax),%eax
c01067d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01067df:	00 
c01067e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01067e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01067e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01067ee:	89 14 24             	mov    %edx,(%esp)
c01067f1:	ff d0                	call   *%eax
c01067f3:	eb 68                	jmp    c010685d <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01067f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067f8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01067fb:	c1 e8 0c             	shr    $0xc,%eax
c01067fe:	83 c0 01             	add    $0x1,%eax
c0106801:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106805:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106808:	89 44 24 08          	mov    %eax,0x8(%esp)
c010680c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010680f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106813:	c7 04 24 50 b1 10 c0 	movl   $0xc010b150,(%esp)
c010681a:	e8 34 9b ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010681f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106822:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106825:	c1 e8 0c             	shr    $0xc,%eax
c0106828:	83 c0 01             	add    $0x1,%eax
c010682b:	c1 e0 08             	shl    $0x8,%eax
c010682e:	89 c2                	mov    %eax,%edx
c0106830:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106833:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106838:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010683f:	00 
c0106840:	89 04 24             	mov    %eax,(%esp)
c0106843:	e8 52 e5 ff ff       	call   c0104d9a <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106848:	8b 45 08             	mov    0x8(%ebp),%eax
c010684b:	8b 40 0c             	mov    0xc(%eax),%eax
c010684e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106851:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106855:	89 04 24             	mov    %eax,(%esp)
c0106858:	e8 28 ef ff ff       	call   c0105785 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010685d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106864:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106867:	0f 85 9a fe ff ff    	jne    c0106707 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010686d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106870:	c9                   	leave  
c0106871:	c3                   	ret    

c0106872 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106872:	55                   	push   %ebp
c0106873:	89 e5                	mov    %esp,%ebp
c0106875:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010687f:	e8 ab e4 ff ff       	call   c0104d2f <alloc_pages>
c0106884:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010688b:	75 24                	jne    c01068b1 <swap_in+0x3f>
c010688d:	c7 44 24 0c 90 b1 10 	movl   $0xc010b190,0xc(%esp)
c0106894:	c0 
c0106895:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c010689c:	c0 
c010689d:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01068a4:	00 
c01068a5:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c01068ac:	e8 2c a4 ff ff       	call   c0100cdd <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01068b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01068b4:	8b 40 0c             	mov    0xc(%eax),%eax
c01068b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01068be:	00 
c01068bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01068c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068c6:	89 04 24             	mov    %eax,(%esp)
c01068c9:	e8 c8 eb ff ff       	call   c0105496 <get_pte>
c01068ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01068d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068d4:	8b 00                	mov    (%eax),%eax
c01068d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01068d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068dd:	89 04 24             	mov    %eax,(%esp)
c01068e0:	e8 f7 1a 00 00       	call   c01083dc <swapfs_read>
c01068e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01068ec:	74 2a                	je     c0106918 <swap_in+0xa6>
     {
        assert(r!=0);
c01068ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01068f2:	75 24                	jne    c0106918 <swap_in+0xa6>
c01068f4:	c7 44 24 0c 9d b1 10 	movl   $0xc010b19d,0xc(%esp)
c01068fb:	c0 
c01068fc:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106903:	c0 
c0106904:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010690b:	00 
c010690c:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106913:	e8 c5 a3 ff ff       	call   c0100cdd <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106918:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010691b:	8b 00                	mov    (%eax),%eax
c010691d:	c1 e8 08             	shr    $0x8,%eax
c0106920:	89 c2                	mov    %eax,%edx
c0106922:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106925:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106929:	89 54 24 04          	mov    %edx,0x4(%esp)
c010692d:	c7 04 24 a4 b1 10 c0 	movl   $0xc010b1a4,(%esp)
c0106934:	e8 1a 9a ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0106939:	8b 45 10             	mov    0x10(%ebp),%eax
c010693c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010693f:	89 10                	mov    %edx,(%eax)
     return 0;
c0106941:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106946:	c9                   	leave  
c0106947:	c3                   	ret    

c0106948 <check_content_set>:



static inline void
check_content_set(void)
{
c0106948:	55                   	push   %ebp
c0106949:	89 e5                	mov    %esp,%ebp
c010694b:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010694e:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106953:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106956:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010695b:	83 f8 01             	cmp    $0x1,%eax
c010695e:	74 24                	je     c0106984 <check_content_set+0x3c>
c0106960:	c7 44 24 0c e2 b1 10 	movl   $0xc010b1e2,0xc(%esp)
c0106967:	c0 
c0106968:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c010696f:	c0 
c0106970:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106977:	00 
c0106978:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c010697f:	e8 59 a3 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106984:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106989:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010698c:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106991:	83 f8 01             	cmp    $0x1,%eax
c0106994:	74 24                	je     c01069ba <check_content_set+0x72>
c0106996:	c7 44 24 0c e2 b1 10 	movl   $0xc010b1e2,0xc(%esp)
c010699d:	c0 
c010699e:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c01069a5:	c0 
c01069a6:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01069ad:	00 
c01069ae:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c01069b5:	e8 23 a3 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01069ba:	b8 00 20 00 00       	mov    $0x2000,%eax
c01069bf:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069c2:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069c7:	83 f8 02             	cmp    $0x2,%eax
c01069ca:	74 24                	je     c01069f0 <check_content_set+0xa8>
c01069cc:	c7 44 24 0c f1 b1 10 	movl   $0xc010b1f1,0xc(%esp)
c01069d3:	c0 
c01069d4:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c01069db:	c0 
c01069dc:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01069e3:	00 
c01069e4:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c01069eb:	e8 ed a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01069f0:	b8 10 20 00 00       	mov    $0x2010,%eax
c01069f5:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069f8:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069fd:	83 f8 02             	cmp    $0x2,%eax
c0106a00:	74 24                	je     c0106a26 <check_content_set+0xde>
c0106a02:	c7 44 24 0c f1 b1 10 	movl   $0xc010b1f1,0xc(%esp)
c0106a09:	c0 
c0106a0a:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106a11:	c0 
c0106a12:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106a19:	00 
c0106a1a:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106a21:	e8 b7 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106a26:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106a2b:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a2e:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a33:	83 f8 03             	cmp    $0x3,%eax
c0106a36:	74 24                	je     c0106a5c <check_content_set+0x114>
c0106a38:	c7 44 24 0c 00 b2 10 	movl   $0xc010b200,0xc(%esp)
c0106a3f:	c0 
c0106a40:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106a47:	c0 
c0106a48:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106a4f:	00 
c0106a50:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106a57:	e8 81 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106a5c:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106a61:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a64:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a69:	83 f8 03             	cmp    $0x3,%eax
c0106a6c:	74 24                	je     c0106a92 <check_content_set+0x14a>
c0106a6e:	c7 44 24 0c 00 b2 10 	movl   $0xc010b200,0xc(%esp)
c0106a75:	c0 
c0106a76:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106a7d:	c0 
c0106a7e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106a85:	00 
c0106a86:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106a8d:	e8 4b a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106a92:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106a97:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106a9a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a9f:	83 f8 04             	cmp    $0x4,%eax
c0106aa2:	74 24                	je     c0106ac8 <check_content_set+0x180>
c0106aa4:	c7 44 24 0c 0f b2 10 	movl   $0xc010b20f,0xc(%esp)
c0106aab:	c0 
c0106aac:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106ab3:	c0 
c0106ab4:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106abb:	00 
c0106abc:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106ac3:	e8 15 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106ac8:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106acd:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106ad0:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ad5:	83 f8 04             	cmp    $0x4,%eax
c0106ad8:	74 24                	je     c0106afe <check_content_set+0x1b6>
c0106ada:	c7 44 24 0c 0f b2 10 	movl   $0xc010b20f,0xc(%esp)
c0106ae1:	c0 
c0106ae2:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106ae9:	c0 
c0106aea:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106af1:	00 
c0106af2:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106af9:	e8 df a1 ff ff       	call   c0100cdd <__panic>
}
c0106afe:	c9                   	leave  
c0106aff:	c3                   	ret    

c0106b00 <check_content_access>:

static inline int
check_content_access(void)
{
c0106b00:	55                   	push   %ebp
c0106b01:	89 e5                	mov    %esp,%ebp
c0106b03:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106b06:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106b0b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106b0e:	ff d0                	call   *%eax
c0106b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106b16:	c9                   	leave  
c0106b17:	c3                   	ret    

c0106b18 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106b18:	55                   	push   %ebp
c0106b19:	89 e5                	mov    %esp,%ebp
c0106b1b:	53                   	push   %ebx
c0106b1c:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106b1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106b26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106b2d:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b34:	eb 6b                	jmp    c0106ba1 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b39:	83 e8 0c             	sub    $0xc,%eax
c0106b3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b42:	83 c0 04             	add    $0x4,%eax
c0106b45:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106b4c:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106b4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b52:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106b55:	0f a3 10             	bt     %edx,(%eax)
c0106b58:	19 c0                	sbb    %eax,%eax
c0106b5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106b5d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b61:	0f 95 c0             	setne  %al
c0106b64:	0f b6 c0             	movzbl %al,%eax
c0106b67:	85 c0                	test   %eax,%eax
c0106b69:	75 24                	jne    c0106b8f <check_swap+0x77>
c0106b6b:	c7 44 24 0c 1e b2 10 	movl   $0xc010b21e,0xc(%esp)
c0106b72:	c0 
c0106b73:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106b7a:	c0 
c0106b7b:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106b82:	00 
c0106b83:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106b8a:	e8 4e a1 ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0106b8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b96:	8b 50 08             	mov    0x8(%eax),%edx
c0106b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b9c:	01 d0                	add    %edx,%eax
c0106b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ba4:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106ba7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106baa:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106bad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bb0:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106bb7:	0f 85 79 ff ff ff    	jne    c0106b36 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106bbd:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106bc0:	e8 07 e2 ff ff       	call   c0104dcc <nr_free_pages>
c0106bc5:	39 c3                	cmp    %eax,%ebx
c0106bc7:	74 24                	je     c0106bed <check_swap+0xd5>
c0106bc9:	c7 44 24 0c 2e b2 10 	movl   $0xc010b22e,0xc(%esp)
c0106bd0:	c0 
c0106bd1:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106bd8:	c0 
c0106bd9:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106be0:	00 
c0106be1:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106be8:	e8 f0 a0 ff ff       	call   c0100cdd <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bfb:	c7 04 24 48 b2 10 c0 	movl   $0xc010b248,(%esp)
c0106c02:	e8 4c 97 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106c07:	e8 47 0a 00 00       	call   c0107653 <mm_create>
c0106c0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106c0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106c13:	75 24                	jne    c0106c39 <check_swap+0x121>
c0106c15:	c7 44 24 0c 6e b2 10 	movl   $0xc010b26e,0xc(%esp)
c0106c1c:	c0 
c0106c1d:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106c24:	c0 
c0106c25:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106c2c:	00 
c0106c2d:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106c34:	e8 a4 a0 ff ff       	call   c0100cdd <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106c39:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106c3e:	85 c0                	test   %eax,%eax
c0106c40:	74 24                	je     c0106c66 <check_swap+0x14e>
c0106c42:	c7 44 24 0c 79 b2 10 	movl   $0xc010b279,0xc(%esp)
c0106c49:	c0 
c0106c4a:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106c51:	c0 
c0106c52:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106c59:	00 
c0106c5a:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106c61:	e8 77 a0 ff ff       	call   c0100cdd <__panic>

     check_mm_struct = mm;
c0106c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c69:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106c6e:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c77:	89 50 0c             	mov    %edx,0xc(%eax)
c0106c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c7d:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c80:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106c83:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c86:	8b 00                	mov    (%eax),%eax
c0106c88:	85 c0                	test   %eax,%eax
c0106c8a:	74 24                	je     c0106cb0 <check_swap+0x198>
c0106c8c:	c7 44 24 0c 91 b2 10 	movl   $0xc010b291,0xc(%esp)
c0106c93:	c0 
c0106c94:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106c9b:	c0 
c0106c9c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106ca3:	00 
c0106ca4:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106cab:	e8 2d a0 ff ff       	call   c0100cdd <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106cb0:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106cb7:	00 
c0106cb8:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106cbf:	00 
c0106cc0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106cc7:	e8 ff 09 00 00       	call   c01076cb <vma_create>
c0106ccc:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106ccf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106cd3:	75 24                	jne    c0106cf9 <check_swap+0x1e1>
c0106cd5:	c7 44 24 0c 9f b2 10 	movl   $0xc010b29f,0xc(%esp)
c0106cdc:	c0 
c0106cdd:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106ce4:	c0 
c0106ce5:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106cec:	00 
c0106ced:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106cf4:	e8 e4 9f ff ff       	call   c0100cdd <__panic>

     insert_vma_struct(mm, vma);
c0106cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d03:	89 04 24             	mov    %eax,(%esp)
c0106d06:	e8 50 0b 00 00       	call   c010785b <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106d0b:	c7 04 24 ac b2 10 c0 	movl   $0xc010b2ac,(%esp)
c0106d12:	e8 3c 96 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106d17:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d21:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d24:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106d2b:	00 
c0106d2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106d33:	00 
c0106d34:	89 04 24             	mov    %eax,(%esp)
c0106d37:	e8 5a e7 ff ff       	call   c0105496 <get_pte>
c0106d3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106d3f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106d43:	75 24                	jne    c0106d69 <check_swap+0x251>
c0106d45:	c7 44 24 0c e0 b2 10 	movl   $0xc010b2e0,0xc(%esp)
c0106d4c:	c0 
c0106d4d:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106d54:	c0 
c0106d55:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106d5c:	00 
c0106d5d:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106d64:	e8 74 9f ff ff       	call   c0100cdd <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106d69:	c7 04 24 f4 b2 10 c0 	movl   $0xc010b2f4,(%esp)
c0106d70:	e8 de 95 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106d7c:	e9 a3 00 00 00       	jmp    c0106e24 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106d81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106d88:	e8 a2 df ff ff       	call   c0104d2f <alloc_pages>
c0106d8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d90:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d9a:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106da1:	85 c0                	test   %eax,%eax
c0106da3:	75 24                	jne    c0106dc9 <check_swap+0x2b1>
c0106da5:	c7 44 24 0c 18 b3 10 	movl   $0xc010b318,0xc(%esp)
c0106dac:	c0 
c0106dad:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106db4:	c0 
c0106db5:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106dbc:	00 
c0106dbd:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106dc4:	e8 14 9f ff ff       	call   c0100cdd <__panic>
          assert(!PageProperty(check_rp[i]));
c0106dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dcc:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106dd3:	83 c0 04             	add    $0x4,%eax
c0106dd6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106ddd:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106de0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106de3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106de6:	0f a3 10             	bt     %edx,(%eax)
c0106de9:	19 c0                	sbb    %eax,%eax
c0106deb:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106dee:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106df2:	0f 95 c0             	setne  %al
c0106df5:	0f b6 c0             	movzbl %al,%eax
c0106df8:	85 c0                	test   %eax,%eax
c0106dfa:	74 24                	je     c0106e20 <check_swap+0x308>
c0106dfc:	c7 44 24 0c 2c b3 10 	movl   $0xc010b32c,0xc(%esp)
c0106e03:	c0 
c0106e04:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106e0b:	c0 
c0106e0c:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106e13:	00 
c0106e14:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106e1b:	e8 bd 9e ff ff       	call   c0100cdd <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e20:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106e24:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106e28:	0f 8e 53 ff ff ff    	jle    c0106d81 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106e2e:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106e33:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106e39:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106e3c:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106e3f:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106e46:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e49:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106e4c:	89 50 04             	mov    %edx,0x4(%eax)
c0106e4f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e52:	8b 50 04             	mov    0x4(%eax),%edx
c0106e55:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e58:	89 10                	mov    %edx,(%eax)
c0106e5a:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106e61:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106e64:	8b 40 04             	mov    0x4(%eax),%eax
c0106e67:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106e6a:	0f 94 c0             	sete   %al
c0106e6d:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106e70:	85 c0                	test   %eax,%eax
c0106e72:	75 24                	jne    c0106e98 <check_swap+0x380>
c0106e74:	c7 44 24 0c 47 b3 10 	movl   $0xc010b347,0xc(%esp)
c0106e7b:	c0 
c0106e7c:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106e83:	c0 
c0106e84:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106e8b:	00 
c0106e8c:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106e93:	e8 45 9e ff ff       	call   c0100cdd <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106e98:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106e9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106ea0:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106ea7:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106eaa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106eb1:	eb 1e                	jmp    c0106ed1 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106eb6:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106ebd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106ec4:	00 
c0106ec5:	89 04 24             	mov    %eax,(%esp)
c0106ec8:	e8 cd de ff ff       	call   c0104d9a <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ecd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ed1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106ed5:	7e dc                	jle    c0106eb3 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106ed7:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106edc:	83 f8 04             	cmp    $0x4,%eax
c0106edf:	74 24                	je     c0106f05 <check_swap+0x3ed>
c0106ee1:	c7 44 24 0c 60 b3 10 	movl   $0xc010b360,0xc(%esp)
c0106ee8:	c0 
c0106ee9:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106ef0:	c0 
c0106ef1:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106ef8:	00 
c0106ef9:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106f00:	e8 d8 9d ff ff       	call   c0100cdd <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106f05:	c7 04 24 84 b3 10 c0 	movl   $0xc010b384,(%esp)
c0106f0c:	e8 42 94 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106f11:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0106f18:	00 00 00 
     
     check_content_set();
c0106f1b:	e8 28 fa ff ff       	call   c0106948 <check_content_set>
     assert( nr_free == 0);         
c0106f20:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f25:	85 c0                	test   %eax,%eax
c0106f27:	74 24                	je     c0106f4d <check_swap+0x435>
c0106f29:	c7 44 24 0c ab b3 10 	movl   $0xc010b3ab,0xc(%esp)
c0106f30:	c0 
c0106f31:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106f38:	c0 
c0106f39:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106f40:	00 
c0106f41:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106f48:	e8 90 9d ff ff       	call   c0100cdd <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f4d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f54:	eb 26                	jmp    c0106f7c <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f59:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c0106f60:	ff ff ff ff 
c0106f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f67:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c0106f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f71:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f78:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f7c:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106f80:	7e d4                	jle    c0106f56 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f82:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f89:	e9 eb 00 00 00       	jmp    c0107079 <check_swap+0x561>
         check_ptep[i]=0;
c0106f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f91:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c0106f98:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f9f:	83 c0 01             	add    $0x1,%eax
c0106fa2:	c1 e0 0c             	shl    $0xc,%eax
c0106fa5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fac:	00 
c0106fad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106fb4:	89 04 24             	mov    %eax,(%esp)
c0106fb7:	e8 da e4 ff ff       	call   c0105496 <get_pte>
c0106fbc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106fbf:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fc9:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0106fd0:	85 c0                	test   %eax,%eax
c0106fd2:	75 24                	jne    c0106ff8 <check_swap+0x4e0>
c0106fd4:	c7 44 24 0c b8 b3 10 	movl   $0xc010b3b8,0xc(%esp)
c0106fdb:	c0 
c0106fdc:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0106fe3:	c0 
c0106fe4:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106feb:	00 
c0106fec:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0106ff3:	e8 e5 9c ff ff       	call   c0100cdd <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ffb:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107002:	8b 00                	mov    (%eax),%eax
c0107004:	89 04 24             	mov    %eax,(%esp)
c0107007:	e8 9f f5 ff ff       	call   c01065ab <pte2page>
c010700c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010700f:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c0107016:	39 d0                	cmp    %edx,%eax
c0107018:	74 24                	je     c010703e <check_swap+0x526>
c010701a:	c7 44 24 0c d0 b3 10 	movl   $0xc010b3d0,0xc(%esp)
c0107021:	c0 
c0107022:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0107029:	c0 
c010702a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0107031:	00 
c0107032:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0107039:	e8 9f 9c ff ff       	call   c0100cdd <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010703e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107041:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107048:	8b 00                	mov    (%eax),%eax
c010704a:	83 e0 01             	and    $0x1,%eax
c010704d:	85 c0                	test   %eax,%eax
c010704f:	75 24                	jne    c0107075 <check_swap+0x55d>
c0107051:	c7 44 24 0c f8 b3 10 	movl   $0xc010b3f8,0xc(%esp)
c0107058:	c0 
c0107059:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c0107060:	c0 
c0107061:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107068:	00 
c0107069:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c0107070:	e8 68 9c ff ff       	call   c0100cdd <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107075:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107079:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010707d:	0f 8e 0b ff ff ff    	jle    c0106f8e <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0107083:	c7 04 24 14 b4 10 c0 	movl   $0xc010b414,(%esp)
c010708a:	e8 c4 92 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c010708f:	e8 6c fa ff ff       	call   c0106b00 <check_content_access>
c0107094:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0107097:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010709b:	74 24                	je     c01070c1 <check_swap+0x5a9>
c010709d:	c7 44 24 0c 3a b4 10 	movl   $0xc010b43a,0xc(%esp)
c01070a4:	c0 
c01070a5:	c7 44 24 08 22 b1 10 	movl   $0xc010b122,0x8(%esp)
c01070ac:	c0 
c01070ad:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01070b4:	00 
c01070b5:	c7 04 24 bc b0 10 c0 	movl   $0xc010b0bc,(%esp)
c01070bc:	e8 1c 9c ff ff       	call   c0100cdd <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01070c8:	eb 1e                	jmp    c01070e8 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01070ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070cd:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c01070d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01070db:	00 
c01070dc:	89 04 24             	mov    %eax,(%esp)
c01070df:	e8 b6 dc ff ff       	call   c0104d9a <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070e4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01070e8:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01070ec:	7e dc                	jle    c01070ca <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01070ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01070f1:	89 04 24             	mov    %eax,(%esp)
c01070f4:	e8 92 08 00 00       	call   c010798b <mm_destroy>
         
     nr_free = nr_free_store;
c01070f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070fc:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c0107101:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107104:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107107:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c010710c:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c0107112:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107119:	eb 1d                	jmp    c0107138 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c010711b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010711e:	83 e8 0c             	sub    $0xc,%eax
c0107121:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107124:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107128:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010712b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010712e:	8b 40 08             	mov    0x8(%eax),%eax
c0107131:	29 c2                	sub    %eax,%edx
c0107133:	89 d0                	mov    %edx,%eax
c0107135:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107138:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010713b:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010713e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107141:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107144:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107147:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c010714e:	75 cb                	jne    c010711b <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107150:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107153:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107157:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010715a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010715e:	c7 04 24 41 b4 10 c0 	movl   $0xc010b441,(%esp)
c0107165:	e8 e9 91 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010716a:	c7 04 24 5b b4 10 c0 	movl   $0xc010b45b,(%esp)
c0107171:	e8 dd 91 ff ff       	call   c0100353 <cprintf>
}
c0107176:	83 c4 74             	add    $0x74,%esp
c0107179:	5b                   	pop    %ebx
c010717a:	5d                   	pop    %ebp
c010717b:	c3                   	ret    

c010717c <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010717c:	55                   	push   %ebp
c010717d:	89 e5                	mov    %esp,%ebp
c010717f:	83 ec 10             	sub    $0x10,%esp
c0107182:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107189:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010718c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010718f:	89 50 04             	mov    %edx,0x4(%eax)
c0107192:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107195:	8b 50 04             	mov    0x4(%eax),%edx
c0107198:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010719b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010719d:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a0:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01071a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01071ac:	c9                   	leave  
c01071ad:	c3                   	ret    

c01071ae <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01071ae:	55                   	push   %ebp
c01071af:	89 e5                	mov    %esp,%ebp
c01071b1:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01071b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01071b7:	8b 40 14             	mov    0x14(%eax),%eax
c01071ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01071bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01071c0:	83 c0 14             	add    $0x14,%eax
c01071c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01071c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01071ca:	74 06                	je     c01071d2 <_fifo_map_swappable+0x24>
c01071cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071d0:	75 24                	jne    c01071f6 <_fifo_map_swappable+0x48>
c01071d2:	c7 44 24 0c 74 b4 10 	movl   $0xc010b474,0xc(%esp)
c01071d9:	c0 
c01071da:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c01071e1:	c0 
c01071e2:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01071e9:	00 
c01071ea:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01071f1:	e8 e7 9a ff ff       	call   c0100cdd <__panic>
c01071f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01071fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107202:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107205:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107208:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010720b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010720e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107211:	8b 40 04             	mov    0x4(%eax),%eax
c0107214:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107217:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010721a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010721d:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107220:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107223:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107226:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107229:	89 10                	mov    %edx,(%eax)
c010722b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010722e:	8b 10                	mov    (%eax),%edx
c0107230:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107233:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107236:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107239:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010723c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010723f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107242:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107245:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0107247:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010724c:	c9                   	leave  
c010724d:	c3                   	ret    

c010724e <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010724e:	55                   	push   %ebp
c010724f:	89 e5                	mov    %esp,%ebp
c0107251:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107254:	8b 45 08             	mov    0x8(%ebp),%eax
c0107257:	8b 40 14             	mov    0x14(%eax),%eax
c010725a:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c010725d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107261:	75 24                	jne    c0107287 <_fifo_swap_out_victim+0x39>
c0107263:	c7 44 24 0c bb b4 10 	movl   $0xc010b4bb,0xc(%esp)
c010726a:	c0 
c010726b:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107272:	c0 
c0107273:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c010727a:	00 
c010727b:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c0107282:	e8 56 9a ff ff       	call   c0100cdd <__panic>
     assert(in_tick==0);
c0107287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010728b:	74 24                	je     c01072b1 <_fifo_swap_out_victim+0x63>
c010728d:	c7 44 24 0c c8 b4 10 	movl   $0xc010b4c8,0xc(%esp)
c0107294:	c0 
c0107295:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c010729c:	c0 
c010729d:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01072a4:	00 
c01072a5:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01072ac:	e8 2c 9a ff ff       	call   c0100cdd <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     /* Select the tail */
     list_entry_t *le = head->prev;
c01072b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072b4:	8b 00                	mov    (%eax),%eax
c01072b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c01072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01072bf:	75 24                	jne    c01072e5 <_fifo_swap_out_victim+0x97>
c01072c1:	c7 44 24 0c d3 b4 10 	movl   $0xc010b4d3,0xc(%esp)
c01072c8:	c0 
c01072c9:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c01072d0:	c0 
c01072d1:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01072d8:	00 
c01072d9:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01072e0:	e8 f8 99 ff ff       	call   c0100cdd <__panic>
     struct Page *p = le2page(le, pra_page_link);
c01072e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072e8:	83 e8 14             	sub    $0x14,%eax
c01072eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01072f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072f7:	8b 40 04             	mov    0x4(%eax),%eax
c01072fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01072fd:	8b 12                	mov    (%edx),%edx
c01072ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107302:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107308:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010730b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010730e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107314:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c0107316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010731a:	75 24                	jne    c0107340 <_fifo_swap_out_victim+0xf2>
c010731c:	c7 44 24 0c dc b4 10 	movl   $0xc010b4dc,0xc(%esp)
c0107323:	c0 
c0107324:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c010732b:	c0 
c010732c:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
c0107333:	00 
c0107334:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c010733b:	e8 9d 99 ff ff       	call   c0100cdd <__panic>
     *ptr_page = p;
c0107340:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107343:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107346:	89 10                	mov    %edx,(%eax)
     return 0;
c0107348:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010734d:	c9                   	leave  
c010734e:	c3                   	ret    

c010734f <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c010734f:	55                   	push   %ebp
c0107350:	89 e5                	mov    %esp,%ebp
c0107352:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107355:	c7 04 24 e8 b4 10 c0 	movl   $0xc010b4e8,(%esp)
c010735c:	e8 f2 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107361:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107366:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107369:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010736e:	83 f8 04             	cmp    $0x4,%eax
c0107371:	74 24                	je     c0107397 <_fifo_check_swap+0x48>
c0107373:	c7 44 24 0c 0e b5 10 	movl   $0xc010b50e,0xc(%esp)
c010737a:	c0 
c010737b:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107382:	c0 
c0107383:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010738a:	00 
c010738b:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c0107392:	e8 46 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107397:	c7 04 24 20 b5 10 c0 	movl   $0xc010b520,(%esp)
c010739e:	e8 b0 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01073a3:	b8 00 10 00 00       	mov    $0x1000,%eax
c01073a8:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01073ab:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073b0:	83 f8 04             	cmp    $0x4,%eax
c01073b3:	74 24                	je     c01073d9 <_fifo_check_swap+0x8a>
c01073b5:	c7 44 24 0c 0e b5 10 	movl   $0xc010b50e,0xc(%esp)
c01073bc:	c0 
c01073bd:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c01073c4:	c0 
c01073c5:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c01073cc:	00 
c01073cd:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01073d4:	e8 04 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01073d9:	c7 04 24 48 b5 10 c0 	movl   $0xc010b548,(%esp)
c01073e0:	e8 6e 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01073e5:	b8 00 40 00 00       	mov    $0x4000,%eax
c01073ea:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01073ed:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073f2:	83 f8 04             	cmp    $0x4,%eax
c01073f5:	74 24                	je     c010741b <_fifo_check_swap+0xcc>
c01073f7:	c7 44 24 0c 0e b5 10 	movl   $0xc010b50e,0xc(%esp)
c01073fe:	c0 
c01073ff:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107406:	c0 
c0107407:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010740e:	00 
c010740f:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c0107416:	e8 c2 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010741b:	c7 04 24 70 b5 10 c0 	movl   $0xc010b570,(%esp)
c0107422:	e8 2c 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107427:	b8 00 20 00 00       	mov    $0x2000,%eax
c010742c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010742f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107434:	83 f8 04             	cmp    $0x4,%eax
c0107437:	74 24                	je     c010745d <_fifo_check_swap+0x10e>
c0107439:	c7 44 24 0c 0e b5 10 	movl   $0xc010b50e,0xc(%esp)
c0107440:	c0 
c0107441:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107448:	c0 
c0107449:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107450:	00 
c0107451:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c0107458:	e8 80 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010745d:	c7 04 24 98 b5 10 c0 	movl   $0xc010b598,(%esp)
c0107464:	e8 ea 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107469:	b8 00 50 00 00       	mov    $0x5000,%eax
c010746e:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107471:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107476:	83 f8 05             	cmp    $0x5,%eax
c0107479:	74 24                	je     c010749f <_fifo_check_swap+0x150>
c010747b:	c7 44 24 0c be b5 10 	movl   $0xc010b5be,0xc(%esp)
c0107482:	c0 
c0107483:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c010748a:	c0 
c010748b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107492:	00 
c0107493:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c010749a:	e8 3e 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010749f:	c7 04 24 70 b5 10 c0 	movl   $0xc010b570,(%esp)
c01074a6:	e8 a8 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01074ab:	b8 00 20 00 00       	mov    $0x2000,%eax
c01074b0:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01074b3:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074b8:	83 f8 05             	cmp    $0x5,%eax
c01074bb:	74 24                	je     c01074e1 <_fifo_check_swap+0x192>
c01074bd:	c7 44 24 0c be b5 10 	movl   $0xc010b5be,0xc(%esp)
c01074c4:	c0 
c01074c5:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c01074cc:	c0 
c01074cd:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01074d4:	00 
c01074d5:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01074dc:	e8 fc 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01074e1:	c7 04 24 20 b5 10 c0 	movl   $0xc010b520,(%esp)
c01074e8:	e8 66 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01074ed:	b8 00 10 00 00       	mov    $0x1000,%eax
c01074f2:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01074f5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074fa:	83 f8 06             	cmp    $0x6,%eax
c01074fd:	74 24                	je     c0107523 <_fifo_check_swap+0x1d4>
c01074ff:	c7 44 24 0c cd b5 10 	movl   $0xc010b5cd,0xc(%esp)
c0107506:	c0 
c0107507:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c010750e:	c0 
c010750f:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107516:	00 
c0107517:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c010751e:	e8 ba 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107523:	c7 04 24 70 b5 10 c0 	movl   $0xc010b570,(%esp)
c010752a:	e8 24 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010752f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107534:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107537:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010753c:	83 f8 07             	cmp    $0x7,%eax
c010753f:	74 24                	je     c0107565 <_fifo_check_swap+0x216>
c0107541:	c7 44 24 0c dc b5 10 	movl   $0xc010b5dc,0xc(%esp)
c0107548:	c0 
c0107549:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107550:	c0 
c0107551:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107558:	00 
c0107559:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c0107560:	e8 78 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107565:	c7 04 24 e8 b4 10 c0 	movl   $0xc010b4e8,(%esp)
c010756c:	e8 e2 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107571:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107576:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107579:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010757e:	83 f8 08             	cmp    $0x8,%eax
c0107581:	74 24                	je     c01075a7 <_fifo_check_swap+0x258>
c0107583:	c7 44 24 0c eb b5 10 	movl   $0xc010b5eb,0xc(%esp)
c010758a:	c0 
c010758b:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c0107592:	c0 
c0107593:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010759a:	00 
c010759b:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01075a2:	e8 36 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01075a7:	c7 04 24 48 b5 10 c0 	movl   $0xc010b548,(%esp)
c01075ae:	e8 a0 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01075b3:	b8 00 40 00 00       	mov    $0x4000,%eax
c01075b8:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c01075bb:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075c0:	83 f8 09             	cmp    $0x9,%eax
c01075c3:	74 24                	je     c01075e9 <_fifo_check_swap+0x29a>
c01075c5:	c7 44 24 0c fa b5 10 	movl   $0xc010b5fa,0xc(%esp)
c01075cc:	c0 
c01075cd:	c7 44 24 08 92 b4 10 	movl   $0xc010b492,0x8(%esp)
c01075d4:	c0 
c01075d5:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01075dc:	00 
c01075dd:	c7 04 24 a7 b4 10 c0 	movl   $0xc010b4a7,(%esp)
c01075e4:	e8 f4 96 ff ff       	call   c0100cdd <__panic>
    return 0;
c01075e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075ee:	c9                   	leave  
c01075ef:	c3                   	ret    

c01075f0 <_fifo_init>:


static int
_fifo_init(void)
{
c01075f0:	55                   	push   %ebp
c01075f1:	89 e5                	mov    %esp,%ebp
    return 0;
c01075f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075f8:	5d                   	pop    %ebp
c01075f9:	c3                   	ret    

c01075fa <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01075fa:	55                   	push   %ebp
c01075fb:	89 e5                	mov    %esp,%ebp
    return 0;
c01075fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107602:	5d                   	pop    %ebp
c0107603:	c3                   	ret    

c0107604 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107604:	55                   	push   %ebp
c0107605:	89 e5                	mov    %esp,%ebp
c0107607:	b8 00 00 00 00       	mov    $0x0,%eax
c010760c:	5d                   	pop    %ebp
c010760d:	c3                   	ret    

c010760e <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010760e:	55                   	push   %ebp
c010760f:	89 e5                	mov    %esp,%ebp
c0107611:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107614:	8b 45 08             	mov    0x8(%ebp),%eax
c0107617:	c1 e8 0c             	shr    $0xc,%eax
c010761a:	89 c2                	mov    %eax,%edx
c010761c:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0107621:	39 c2                	cmp    %eax,%edx
c0107623:	72 1c                	jb     c0107641 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107625:	c7 44 24 08 1c b6 10 	movl   $0xc010b61c,0x8(%esp)
c010762c:	c0 
c010762d:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107634:	00 
c0107635:	c7 04 24 3b b6 10 c0 	movl   $0xc010b63b,(%esp)
c010763c:	e8 9c 96 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0107641:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0107646:	8b 55 08             	mov    0x8(%ebp),%edx
c0107649:	c1 ea 0c             	shr    $0xc,%edx
c010764c:	c1 e2 05             	shl    $0x5,%edx
c010764f:	01 d0                	add    %edx,%eax
}
c0107651:	c9                   	leave  
c0107652:	c3                   	ret    

c0107653 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107653:	55                   	push   %ebp
c0107654:	89 e5                	mov    %esp,%ebp
c0107656:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107659:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107660:	e8 6d d2 ff ff       	call   c01048d2 <kmalloc>
c0107665:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010766c:	74 58                	je     c01076c6 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107671:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107674:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107677:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010767a:	89 50 04             	mov    %edx,0x4(%eax)
c010767d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107680:	8b 50 04             	mov    0x4(%eax),%edx
c0107683:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107686:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107692:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107695:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010769c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010769f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01076a6:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01076ab:	85 c0                	test   %eax,%eax
c01076ad:	74 0d                	je     c01076bc <mm_create+0x69>
c01076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b2:	89 04 24             	mov    %eax,(%esp)
c01076b5:	e8 bf ef ff ff       	call   c0106679 <swap_init_mm>
c01076ba:	eb 0a                	jmp    c01076c6 <mm_create+0x73>
        else mm->sm_priv = NULL;
c01076bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076bf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01076c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076c9:	c9                   	leave  
c01076ca:	c3                   	ret    

c01076cb <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01076cb:	55                   	push   %ebp
c01076cc:	89 e5                	mov    %esp,%ebp
c01076ce:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01076d1:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01076d8:	e8 f5 d1 ff ff       	call   c01048d2 <kmalloc>
c01076dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01076e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076e4:	74 1b                	je     c0107701 <vma_create+0x36>
        vma->vm_start = vm_start;
c01076e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076e9:	8b 55 08             	mov    0x8(%ebp),%edx
c01076ec:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01076ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076f5:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01076f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076fb:	8b 55 10             	mov    0x10(%ebp),%edx
c01076fe:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107701:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107704:	c9                   	leave  
c0107705:	c3                   	ret    

c0107706 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107706:	55                   	push   %ebp
c0107707:	89 e5                	mov    %esp,%ebp
c0107709:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c010770c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107713:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107717:	0f 84 95 00 00 00    	je     c01077b2 <find_vma+0xac>
        vma = mm->mmap_cache;
c010771d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107720:	8b 40 08             	mov    0x8(%eax),%eax
c0107723:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107726:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010772a:	74 16                	je     c0107742 <find_vma+0x3c>
c010772c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010772f:	8b 40 04             	mov    0x4(%eax),%eax
c0107732:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107735:	77 0b                	ja     c0107742 <find_vma+0x3c>
c0107737:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010773a:	8b 40 08             	mov    0x8(%eax),%eax
c010773d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107740:	77 61                	ja     c01077a3 <find_vma+0x9d>
                bool found = 0;
c0107742:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107749:	8b 45 08             	mov    0x8(%ebp),%eax
c010774c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010774f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107752:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107755:	eb 28                	jmp    c010777f <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010775a:	83 e8 10             	sub    $0x10,%eax
c010775d:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107760:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107763:	8b 40 04             	mov    0x4(%eax),%eax
c0107766:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107769:	77 14                	ja     c010777f <find_vma+0x79>
c010776b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010776e:	8b 40 08             	mov    0x8(%eax),%eax
c0107771:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107774:	76 09                	jbe    c010777f <find_vma+0x79>
                        found = 1;
c0107776:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010777d:	eb 17                	jmp    c0107796 <find_vma+0x90>
c010777f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107782:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107785:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107788:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010778b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010778e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107791:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107794:	75 c1                	jne    c0107757 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107796:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010779a:	75 07                	jne    c01077a3 <find_vma+0x9d>
                    vma = NULL;
c010779c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01077a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01077a7:	74 09                	je     c01077b2 <find_vma+0xac>
            mm->mmap_cache = vma;
c01077a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01077ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01077af:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01077b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01077b5:	c9                   	leave  
c01077b6:	c3                   	ret    

c01077b7 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01077b7:	55                   	push   %ebp
c01077b8:	89 e5                	mov    %esp,%ebp
c01077ba:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c01077bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c0:	8b 50 04             	mov    0x4(%eax),%edx
c01077c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c6:	8b 40 08             	mov    0x8(%eax),%eax
c01077c9:	39 c2                	cmp    %eax,%edx
c01077cb:	72 24                	jb     c01077f1 <check_vma_overlap+0x3a>
c01077cd:	c7 44 24 0c 49 b6 10 	movl   $0xc010b649,0xc(%esp)
c01077d4:	c0 
c01077d5:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c01077dc:	c0 
c01077dd:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01077e4:	00 
c01077e5:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c01077ec:	e8 ec 94 ff ff       	call   c0100cdd <__panic>
    assert(prev->vm_end <= next->vm_start);
c01077f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01077f4:	8b 50 08             	mov    0x8(%eax),%edx
c01077f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077fa:	8b 40 04             	mov    0x4(%eax),%eax
c01077fd:	39 c2                	cmp    %eax,%edx
c01077ff:	76 24                	jbe    c0107825 <check_vma_overlap+0x6e>
c0107801:	c7 44 24 0c 8c b6 10 	movl   $0xc010b68c,0xc(%esp)
c0107808:	c0 
c0107809:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107810:	c0 
c0107811:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107818:	00 
c0107819:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107820:	e8 b8 94 ff ff       	call   c0100cdd <__panic>
    assert(next->vm_start < next->vm_end);
c0107825:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107828:	8b 50 04             	mov    0x4(%eax),%edx
c010782b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010782e:	8b 40 08             	mov    0x8(%eax),%eax
c0107831:	39 c2                	cmp    %eax,%edx
c0107833:	72 24                	jb     c0107859 <check_vma_overlap+0xa2>
c0107835:	c7 44 24 0c ab b6 10 	movl   $0xc010b6ab,0xc(%esp)
c010783c:	c0 
c010783d:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107844:	c0 
c0107845:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010784c:	00 
c010784d:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107854:	e8 84 94 ff ff       	call   c0100cdd <__panic>
}
c0107859:	c9                   	leave  
c010785a:	c3                   	ret    

c010785b <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010785b:	55                   	push   %ebp
c010785c:	89 e5                	mov    %esp,%ebp
c010785e:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107861:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107864:	8b 50 04             	mov    0x4(%eax),%edx
c0107867:	8b 45 0c             	mov    0xc(%ebp),%eax
c010786a:	8b 40 08             	mov    0x8(%eax),%eax
c010786d:	39 c2                	cmp    %eax,%edx
c010786f:	72 24                	jb     c0107895 <insert_vma_struct+0x3a>
c0107871:	c7 44 24 0c c9 b6 10 	movl   $0xc010b6c9,0xc(%esp)
c0107878:	c0 
c0107879:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107880:	c0 
c0107881:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0107888:	00 
c0107889:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107890:	e8 48 94 ff ff       	call   c0100cdd <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107895:	8b 45 08             	mov    0x8(%ebp),%eax
c0107898:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010789b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010789e:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c01078a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c01078a7:	eb 21                	jmp    c01078ca <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c01078a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078ac:	83 e8 10             	sub    $0x10,%eax
c01078af:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01078b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078b5:	8b 50 04             	mov    0x4(%eax),%edx
c01078b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078bb:	8b 40 04             	mov    0x4(%eax),%eax
c01078be:	39 c2                	cmp    %eax,%edx
c01078c0:	76 02                	jbe    c01078c4 <insert_vma_struct+0x69>
                break;
c01078c2:	eb 1d                	jmp    c01078e1 <insert_vma_struct+0x86>
            }
            le_prev = le;
c01078c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01078ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01078d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078d3:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01078d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078df:	75 c8                	jne    c01078a9 <insert_vma_struct+0x4e>
c01078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01078e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01078ea:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01078ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01078f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078f6:	74 15                	je     c010790d <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01078f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078fb:	8d 50 f0             	lea    -0x10(%eax),%edx
c01078fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107901:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107905:	89 14 24             	mov    %edx,(%esp)
c0107908:	e8 aa fe ff ff       	call   c01077b7 <check_vma_overlap>
    }
    if (le_next != list) {
c010790d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107910:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107913:	74 15                	je     c010792a <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107918:	83 e8 10             	sub    $0x10,%eax
c010791b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010791f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107922:	89 04 24             	mov    %eax,(%esp)
c0107925:	e8 8d fe ff ff       	call   c01077b7 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010792a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010792d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107930:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107932:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107935:	8d 50 10             	lea    0x10(%eax),%edx
c0107938:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010793b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010793e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107941:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107944:	8b 40 04             	mov    0x4(%eax),%eax
c0107947:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010794a:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010794d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107950:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107953:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107956:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107959:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010795c:	89 10                	mov    %edx,(%eax)
c010795e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107961:	8b 10                	mov    (%eax),%edx
c0107963:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107966:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107969:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010796c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010796f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107972:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107975:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107978:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010797a:	8b 45 08             	mov    0x8(%ebp),%eax
c010797d:	8b 40 10             	mov    0x10(%eax),%eax
c0107980:	8d 50 01             	lea    0x1(%eax),%edx
c0107983:	8b 45 08             	mov    0x8(%ebp),%eax
c0107986:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107989:	c9                   	leave  
c010798a:	c3                   	ret    

c010798b <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010798b:	55                   	push   %ebp
c010798c:	89 e5                	mov    %esp,%ebp
c010798e:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107991:	8b 45 08             	mov    0x8(%ebp),%eax
c0107994:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107997:	eb 36                	jmp    c01079cf <mm_destroy+0x44>
c0107999:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010799c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010799f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01079a2:	8b 40 04             	mov    0x4(%eax),%eax
c01079a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01079a8:	8b 12                	mov    (%edx),%edx
c01079aa:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01079ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01079b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01079b6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01079b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01079bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01079bf:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c01079c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079c4:	83 e8 10             	sub    $0x10,%eax
c01079c7:	89 04 24             	mov    %eax,(%esp)
c01079ca:	e8 1e cf ff ff       	call   c01048ed <kfree>
c01079cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01079d8:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01079db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079e4:	75 b3                	jne    c0107999 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01079e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01079e9:	89 04 24             	mov    %eax,(%esp)
c01079ec:	e8 fc ce ff ff       	call   c01048ed <kfree>
    mm=NULL;
c01079f1:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01079f8:	c9                   	leave  
c01079f9:	c3                   	ret    

c01079fa <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01079fa:	55                   	push   %ebp
c01079fb:	89 e5                	mov    %esp,%ebp
c01079fd:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107a00:	e8 02 00 00 00       	call   c0107a07 <check_vmm>
}
c0107a05:	c9                   	leave  
c0107a06:	c3                   	ret    

c0107a07 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107a07:	55                   	push   %ebp
c0107a08:	89 e5                	mov    %esp,%ebp
c0107a0a:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a0d:	e8 ba d3 ff ff       	call   c0104dcc <nr_free_pages>
c0107a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107a15:	e8 13 00 00 00       	call   c0107a2d <check_vma_struct>
    check_pgfault();
c0107a1a:	e8 a7 04 00 00       	call   c0107ec6 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107a1f:	c7 04 24 e5 b6 10 c0 	movl   $0xc010b6e5,(%esp)
c0107a26:	e8 28 89 ff ff       	call   c0100353 <cprintf>
}
c0107a2b:	c9                   	leave  
c0107a2c:	c3                   	ret    

c0107a2d <check_vma_struct>:

static void
check_vma_struct(void) {
c0107a2d:	55                   	push   %ebp
c0107a2e:	89 e5                	mov    %esp,%ebp
c0107a30:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a33:	e8 94 d3 ff ff       	call   c0104dcc <nr_free_pages>
c0107a38:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107a3b:	e8 13 fc ff ff       	call   c0107653 <mm_create>
c0107a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107a43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107a47:	75 24                	jne    c0107a6d <check_vma_struct+0x40>
c0107a49:	c7 44 24 0c fd b6 10 	movl   $0xc010b6fd,0xc(%esp)
c0107a50:	c0 
c0107a51:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107a58:	c0 
c0107a59:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107a60:	00 
c0107a61:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107a68:	e8 70 92 ff ff       	call   c0100cdd <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107a6d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107a74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a77:	89 d0                	mov    %edx,%eax
c0107a79:	c1 e0 02             	shl    $0x2,%eax
c0107a7c:	01 d0                	add    %edx,%eax
c0107a7e:	01 c0                	add    %eax,%eax
c0107a80:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a89:	eb 70                	jmp    c0107afb <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a8e:	89 d0                	mov    %edx,%eax
c0107a90:	c1 e0 02             	shl    $0x2,%eax
c0107a93:	01 d0                	add    %edx,%eax
c0107a95:	83 c0 02             	add    $0x2,%eax
c0107a98:	89 c1                	mov    %eax,%ecx
c0107a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a9d:	89 d0                	mov    %edx,%eax
c0107a9f:	c1 e0 02             	shl    $0x2,%eax
c0107aa2:	01 d0                	add    %edx,%eax
c0107aa4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107aab:	00 
c0107aac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107ab0:	89 04 24             	mov    %eax,(%esp)
c0107ab3:	e8 13 fc ff ff       	call   c01076cb <vma_create>
c0107ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107abb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107abf:	75 24                	jne    c0107ae5 <check_vma_struct+0xb8>
c0107ac1:	c7 44 24 0c 08 b7 10 	movl   $0xc010b708,0xc(%esp)
c0107ac8:	c0 
c0107ac9:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107ad0:	c0 
c0107ad1:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107ad8:	00 
c0107ad9:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107ae0:	e8 f8 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107aec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107aef:	89 04 24             	mov    %eax,(%esp)
c0107af2:	e8 64 fd ff ff       	call   c010785b <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107af7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107aff:	7f 8a                	jg     c0107a8b <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b04:	83 c0 01             	add    $0x1,%eax
c0107b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107b0a:	eb 70                	jmp    c0107b7c <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b0f:	89 d0                	mov    %edx,%eax
c0107b11:	c1 e0 02             	shl    $0x2,%eax
c0107b14:	01 d0                	add    %edx,%eax
c0107b16:	83 c0 02             	add    $0x2,%eax
c0107b19:	89 c1                	mov    %eax,%ecx
c0107b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b1e:	89 d0                	mov    %edx,%eax
c0107b20:	c1 e0 02             	shl    $0x2,%eax
c0107b23:	01 d0                	add    %edx,%eax
c0107b25:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b2c:	00 
c0107b2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107b31:	89 04 24             	mov    %eax,(%esp)
c0107b34:	e8 92 fb ff ff       	call   c01076cb <vma_create>
c0107b39:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107b3c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107b40:	75 24                	jne    c0107b66 <check_vma_struct+0x139>
c0107b42:	c7 44 24 0c 08 b7 10 	movl   $0xc010b708,0xc(%esp)
c0107b49:	c0 
c0107b4a:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107b51:	c0 
c0107b52:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107b59:	00 
c0107b5a:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107b61:	e8 77 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107b66:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b70:	89 04 24             	mov    %eax,(%esp)
c0107b73:	e8 e3 fc ff ff       	call   c010785b <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b82:	7e 88                	jle    c0107b0c <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b87:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107b8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107b8d:	8b 40 04             	mov    0x4(%eax),%eax
c0107b90:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107b93:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107b9a:	e9 97 00 00 00       	jmp    c0107c36 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ba2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107ba5:	75 24                	jne    c0107bcb <check_vma_struct+0x19e>
c0107ba7:	c7 44 24 0c 14 b7 10 	movl   $0xc010b714,0xc(%esp)
c0107bae:	c0 
c0107baf:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107bb6:	c0 
c0107bb7:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107bbe:	00 
c0107bbf:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107bc6:	e8 12 91 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bce:	83 e8 10             	sub    $0x10,%eax
c0107bd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107bd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bd7:	8b 48 04             	mov    0x4(%eax),%ecx
c0107bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bdd:	89 d0                	mov    %edx,%eax
c0107bdf:	c1 e0 02             	shl    $0x2,%eax
c0107be2:	01 d0                	add    %edx,%eax
c0107be4:	39 c1                	cmp    %eax,%ecx
c0107be6:	75 17                	jne    c0107bff <check_vma_struct+0x1d2>
c0107be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107beb:	8b 48 08             	mov    0x8(%eax),%ecx
c0107bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bf1:	89 d0                	mov    %edx,%eax
c0107bf3:	c1 e0 02             	shl    $0x2,%eax
c0107bf6:	01 d0                	add    %edx,%eax
c0107bf8:	83 c0 02             	add    $0x2,%eax
c0107bfb:	39 c1                	cmp    %eax,%ecx
c0107bfd:	74 24                	je     c0107c23 <check_vma_struct+0x1f6>
c0107bff:	c7 44 24 0c 2c b7 10 	movl   $0xc010b72c,0xc(%esp)
c0107c06:	c0 
c0107c07:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107c0e:	c0 
c0107c0f:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107c16:	00 
c0107c17:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107c1e:	e8 ba 90 ff ff       	call   c0100cdd <__panic>
c0107c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107c29:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107c2c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107c32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c39:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107c3c:	0f 8e 5d ff ff ff    	jle    c0107b9f <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107c42:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107c49:	e9 cd 01 00 00       	jmp    c0107e1b <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c58:	89 04 24             	mov    %eax,(%esp)
c0107c5b:	e8 a6 fa ff ff       	call   c0107706 <find_vma>
c0107c60:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107c63:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107c67:	75 24                	jne    c0107c8d <check_vma_struct+0x260>
c0107c69:	c7 44 24 0c 61 b7 10 	movl   $0xc010b761,0xc(%esp)
c0107c70:	c0 
c0107c71:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107c78:	c0 
c0107c79:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107c80:	00 
c0107c81:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107c88:	e8 50 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c90:	83 c0 01             	add    $0x1,%eax
c0107c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c9a:	89 04 24             	mov    %eax,(%esp)
c0107c9d:	e8 64 fa ff ff       	call   c0107706 <find_vma>
c0107ca2:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107ca5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107ca9:	75 24                	jne    c0107ccf <check_vma_struct+0x2a2>
c0107cab:	c7 44 24 0c 6e b7 10 	movl   $0xc010b76e,0xc(%esp)
c0107cb2:	c0 
c0107cb3:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107cba:	c0 
c0107cbb:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107cc2:	00 
c0107cc3:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107cca:	e8 0e 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cd2:	83 c0 02             	add    $0x2,%eax
c0107cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cdc:	89 04 24             	mov    %eax,(%esp)
c0107cdf:	e8 22 fa ff ff       	call   c0107706 <find_vma>
c0107ce4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107ce7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107ceb:	74 24                	je     c0107d11 <check_vma_struct+0x2e4>
c0107ced:	c7 44 24 0c 7b b7 10 	movl   $0xc010b77b,0xc(%esp)
c0107cf4:	c0 
c0107cf5:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107cfc:	c0 
c0107cfd:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107d04:	00 
c0107d05:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107d0c:	e8 cc 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d14:	83 c0 03             	add    $0x3,%eax
c0107d17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d1e:	89 04 24             	mov    %eax,(%esp)
c0107d21:	e8 e0 f9 ff ff       	call   c0107706 <find_vma>
c0107d26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107d29:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107d2d:	74 24                	je     c0107d53 <check_vma_struct+0x326>
c0107d2f:	c7 44 24 0c 88 b7 10 	movl   $0xc010b788,0xc(%esp)
c0107d36:	c0 
c0107d37:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107d3e:	c0 
c0107d3f:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107d46:	00 
c0107d47:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107d4e:	e8 8a 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d56:	83 c0 04             	add    $0x4,%eax
c0107d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d60:	89 04 24             	mov    %eax,(%esp)
c0107d63:	e8 9e f9 ff ff       	call   c0107706 <find_vma>
c0107d68:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107d6b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107d6f:	74 24                	je     c0107d95 <check_vma_struct+0x368>
c0107d71:	c7 44 24 0c 95 b7 10 	movl   $0xc010b795,0xc(%esp)
c0107d78:	c0 
c0107d79:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107d80:	c0 
c0107d81:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107d88:	00 
c0107d89:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107d90:	e8 48 8f ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107d95:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d98:	8b 50 04             	mov    0x4(%eax),%edx
c0107d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d9e:	39 c2                	cmp    %eax,%edx
c0107da0:	75 10                	jne    c0107db2 <check_vma_struct+0x385>
c0107da2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107da5:	8b 50 08             	mov    0x8(%eax),%edx
c0107da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dab:	83 c0 02             	add    $0x2,%eax
c0107dae:	39 c2                	cmp    %eax,%edx
c0107db0:	74 24                	je     c0107dd6 <check_vma_struct+0x3a9>
c0107db2:	c7 44 24 0c a4 b7 10 	movl   $0xc010b7a4,0xc(%esp)
c0107db9:	c0 
c0107dba:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107dc1:	c0 
c0107dc2:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107dc9:	00 
c0107dca:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107dd1:	e8 07 8f ff ff       	call   c0100cdd <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107dd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107dd9:	8b 50 04             	mov    0x4(%eax),%edx
c0107ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ddf:	39 c2                	cmp    %eax,%edx
c0107de1:	75 10                	jne    c0107df3 <check_vma_struct+0x3c6>
c0107de3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107de6:	8b 50 08             	mov    0x8(%eax),%edx
c0107de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dec:	83 c0 02             	add    $0x2,%eax
c0107def:	39 c2                	cmp    %eax,%edx
c0107df1:	74 24                	je     c0107e17 <check_vma_struct+0x3ea>
c0107df3:	c7 44 24 0c d4 b7 10 	movl   $0xc010b7d4,0xc(%esp)
c0107dfa:	c0 
c0107dfb:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107e02:	c0 
c0107e03:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107e0a:	00 
c0107e0b:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107e12:	e8 c6 8e ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107e17:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e1e:	89 d0                	mov    %edx,%eax
c0107e20:	c1 e0 02             	shl    $0x2,%eax
c0107e23:	01 d0                	add    %edx,%eax
c0107e25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e28:	0f 8d 20 fe ff ff    	jge    c0107c4e <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e2e:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107e35:	eb 70                	jmp    c0107ea7 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e41:	89 04 24             	mov    %eax,(%esp)
c0107e44:	e8 bd f8 ff ff       	call   c0107706 <find_vma>
c0107e49:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107e4c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e50:	74 27                	je     c0107e79 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107e52:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e55:	8b 50 08             	mov    0x8(%eax),%edx
c0107e58:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e5b:	8b 40 04             	mov    0x4(%eax),%eax
c0107e5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107e62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e6d:	c7 04 24 04 b8 10 c0 	movl   $0xc010b804,(%esp)
c0107e74:	e8 da 84 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107e79:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e7d:	74 24                	je     c0107ea3 <check_vma_struct+0x476>
c0107e7f:	c7 44 24 0c 29 b8 10 	movl   $0xc010b829,0xc(%esp)
c0107e86:	c0 
c0107e87:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107e8e:	c0 
c0107e8f:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107e96:	00 
c0107e97:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107e9e:	e8 3a 8e ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107ea3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107eab:	79 8a                	jns    c0107e37 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eb0:	89 04 24             	mov    %eax,(%esp)
c0107eb3:	e8 d3 fa ff ff       	call   c010798b <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0107eb8:	c7 04 24 40 b8 10 c0 	movl   $0xc010b840,(%esp)
c0107ebf:	e8 8f 84 ff ff       	call   c0100353 <cprintf>
}
c0107ec4:	c9                   	leave  
c0107ec5:	c3                   	ret    

c0107ec6 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107ec6:	55                   	push   %ebp
c0107ec7:	89 e5                	mov    %esp,%ebp
c0107ec9:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107ecc:	e8 fb ce ff ff       	call   c0104dcc <nr_free_pages>
c0107ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107ed4:	e8 7a f7 ff ff       	call   c0107653 <mm_create>
c0107ed9:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0107ede:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107ee3:	85 c0                	test   %eax,%eax
c0107ee5:	75 24                	jne    c0107f0b <check_pgfault+0x45>
c0107ee7:	c7 44 24 0c 5f b8 10 	movl   $0xc010b85f,0xc(%esp)
c0107eee:	c0 
c0107eef:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107ef6:	c0 
c0107ef7:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0107efe:	00 
c0107eff:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107f06:	e8 d2 8d ff ff       	call   c0100cdd <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107f0b:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107f10:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107f13:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0107f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f1c:	89 50 0c             	mov    %edx,0xc(%eax)
c0107f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f22:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f2b:	8b 00                	mov    (%eax),%eax
c0107f2d:	85 c0                	test   %eax,%eax
c0107f2f:	74 24                	je     c0107f55 <check_pgfault+0x8f>
c0107f31:	c7 44 24 0c 77 b8 10 	movl   $0xc010b877,0xc(%esp)
c0107f38:	c0 
c0107f39:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107f40:	c0 
c0107f41:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0107f48:	00 
c0107f49:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107f50:	e8 88 8d ff ff       	call   c0100cdd <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107f55:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107f5c:	00 
c0107f5d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107f64:	00 
c0107f65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107f6c:	e8 5a f7 ff ff       	call   c01076cb <vma_create>
c0107f71:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107f74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f78:	75 24                	jne    c0107f9e <check_pgfault+0xd8>
c0107f7a:	c7 44 24 0c 08 b7 10 	movl   $0xc010b708,0xc(%esp)
c0107f81:	c0 
c0107f82:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107f89:	c0 
c0107f8a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107f91:	00 
c0107f92:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107f99:	e8 3f 8d ff ff       	call   c0100cdd <__panic>

    insert_vma_struct(mm, vma);
c0107f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fa8:	89 04 24             	mov    %eax,(%esp)
c0107fab:	e8 ab f8 ff ff       	call   c010785b <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107fb0:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107fb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fc1:	89 04 24             	mov    %eax,(%esp)
c0107fc4:	e8 3d f7 ff ff       	call   c0107706 <find_vma>
c0107fc9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107fcc:	74 24                	je     c0107ff2 <check_pgfault+0x12c>
c0107fce:	c7 44 24 0c 85 b8 10 	movl   $0xc010b885,0xc(%esp)
c0107fd5:	c0 
c0107fd6:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0107fdd:	c0 
c0107fde:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0107fe5:	00 
c0107fe6:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0107fed:	e8 eb 8c ff ff       	call   c0100cdd <__panic>

    int i, sum = 0;
c0107ff2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107ff9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108000:	eb 17                	jmp    c0108019 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108002:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108005:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108008:	01 d0                	add    %edx,%eax
c010800a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010800d:	88 10                	mov    %dl,(%eax)
        sum += i;
c010800f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108012:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108015:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108019:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010801d:	7e e3                	jle    c0108002 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010801f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108026:	eb 15                	jmp    c010803d <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108028:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010802b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010802e:	01 d0                	add    %edx,%eax
c0108030:	0f b6 00             	movzbl (%eax),%eax
c0108033:	0f be c0             	movsbl %al,%eax
c0108036:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108039:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010803d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108041:	7e e5                	jle    c0108028 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108043:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108047:	74 24                	je     c010806d <check_pgfault+0x1a7>
c0108049:	c7 44 24 0c 9f b8 10 	movl   $0xc010b89f,0xc(%esp)
c0108050:	c0 
c0108051:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c0108058:	c0 
c0108059:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0108060:	00 
c0108061:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c0108068:	e8 70 8c ff ff       	call   c0100cdd <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010806d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108070:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108073:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108076:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010807b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010807f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108082:	89 04 24             	mov    %eax,(%esp)
c0108085:	e8 fe d5 ff ff       	call   c0105688 <page_remove>
    free_page(pa2page(pgdir[0]));
c010808a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010808d:	8b 00                	mov    (%eax),%eax
c010808f:	89 04 24             	mov    %eax,(%esp)
c0108092:	e8 77 f5 ff ff       	call   c010760e <pa2page>
c0108097:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010809e:	00 
c010809f:	89 04 24             	mov    %eax,(%esp)
c01080a2:	e8 f3 cc ff ff       	call   c0104d9a <free_pages>
    pgdir[0] = 0;
c01080a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01080b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01080ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080bd:	89 04 24             	mov    %eax,(%esp)
c01080c0:	e8 c6 f8 ff ff       	call   c010798b <mm_destroy>
    check_mm_struct = NULL;
c01080c5:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c01080cc:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01080cf:	e8 f8 cc ff ff       	call   c0104dcc <nr_free_pages>
c01080d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080d7:	74 24                	je     c01080fd <check_pgfault+0x237>
c01080d9:	c7 44 24 0c a8 b8 10 	movl   $0xc010b8a8,0xc(%esp)
c01080e0:	c0 
c01080e1:	c7 44 24 08 67 b6 10 	movl   $0xc010b667,0x8(%esp)
c01080e8:	c0 
c01080e9:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01080f0:	00 
c01080f1:	c7 04 24 7c b6 10 c0 	movl   $0xc010b67c,(%esp)
c01080f8:	e8 e0 8b ff ff       	call   c0100cdd <__panic>

    cprintf("check_pgfault() succeeded!\n");
c01080fd:	c7 04 24 cf b8 10 c0 	movl   $0xc010b8cf,(%esp)
c0108104:	e8 4a 82 ff ff       	call   c0100353 <cprintf>
}
c0108109:	c9                   	leave  
c010810a:	c3                   	ret    

c010810b <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010810b:	55                   	push   %ebp
c010810c:	89 e5                	mov    %esp,%ebp
c010810e:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108111:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108118:	8b 45 10             	mov    0x10(%ebp),%eax
c010811b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010811f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108122:	89 04 24             	mov    %eax,(%esp)
c0108125:	e8 dc f5 ff ff       	call   c0107706 <find_vma>
c010812a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c010812d:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0108132:	83 c0 01             	add    $0x1,%eax
c0108135:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010813a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010813e:	74 0b                	je     c010814b <do_pgfault+0x40>
c0108140:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108143:	8b 40 04             	mov    0x4(%eax),%eax
c0108146:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108149:	76 18                	jbe    c0108163 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c010814b:	8b 45 10             	mov    0x10(%ebp),%eax
c010814e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108152:	c7 04 24 ec b8 10 c0 	movl   $0xc010b8ec,(%esp)
c0108159:	e8 f5 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010815e:	e9 ae 01 00 00       	jmp    c0108311 <do_pgfault+0x206>
    }
    //check the error_code
    switch (error_code & 3) {
c0108163:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108166:	83 e0 03             	and    $0x3,%eax
c0108169:	85 c0                	test   %eax,%eax
c010816b:	74 36                	je     c01081a3 <do_pgfault+0x98>
c010816d:	83 f8 01             	cmp    $0x1,%eax
c0108170:	74 20                	je     c0108192 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108172:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108175:	8b 40 0c             	mov    0xc(%eax),%eax
c0108178:	83 e0 02             	and    $0x2,%eax
c010817b:	85 c0                	test   %eax,%eax
c010817d:	75 11                	jne    c0108190 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c010817f:	c7 04 24 1c b9 10 c0 	movl   $0xc010b91c,(%esp)
c0108186:	e8 c8 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010818b:	e9 81 01 00 00       	jmp    c0108311 <do_pgfault+0x206>
        }
        break;
c0108190:	eb 2f                	jmp    c01081c1 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108192:	c7 04 24 7c b9 10 c0 	movl   $0xc010b97c,(%esp)
c0108199:	e8 b5 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010819e:	e9 6e 01 00 00       	jmp    c0108311 <do_pgfault+0x206>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01081a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081a6:	8b 40 0c             	mov    0xc(%eax),%eax
c01081a9:	83 e0 05             	and    $0x5,%eax
c01081ac:	85 c0                	test   %eax,%eax
c01081ae:	75 11                	jne    c01081c1 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01081b0:	c7 04 24 b4 b9 10 c0 	movl   $0xc010b9b4,(%esp)
c01081b7:	e8 97 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01081bc:	e9 50 01 00 00       	jmp    c0108311 <do_pgfault+0x206>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c01081c1:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c01081c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081cb:	8b 40 0c             	mov    0xc(%eax),%eax
c01081ce:	83 e0 02             	and    $0x2,%eax
c01081d1:	85 c0                	test   %eax,%eax
c01081d3:	74 04                	je     c01081d9 <do_pgfault+0xce>
        perm |= PTE_W;
c01081d5:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01081d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01081dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081e7:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c01081ea:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c01081f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        }
   }
#endif
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c01081f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fb:	8b 40 0c             	mov    0xc(%eax),%eax
c01081fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108205:	00 
c0108206:	8b 55 10             	mov    0x10(%ebp),%edx
c0108209:	89 54 24 04          	mov    %edx,0x4(%esp)
c010820d:	89 04 24             	mov    %eax,(%esp)
c0108210:	e8 81 d2 ff ff       	call   c0105496 <get_pte>
c0108215:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108218:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010821c:	75 11                	jne    c010822f <do_pgfault+0x124>
        cprintf("get_pte in do_pgfault failed\n");
c010821e:	c7 04 24 17 ba 10 c0 	movl   $0xc010ba17,(%esp)
c0108225:	e8 29 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010822a:	e9 e2 00 00 00       	jmp    c0108311 <do_pgfault+0x206>
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c010822f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108232:	8b 00                	mov    (%eax),%eax
c0108234:	85 c0                	test   %eax,%eax
c0108236:	75 35                	jne    c010826d <do_pgfault+0x162>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0108238:	8b 45 08             	mov    0x8(%ebp),%eax
c010823b:	8b 40 0c             	mov    0xc(%eax),%eax
c010823e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108241:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108245:	8b 55 10             	mov    0x10(%ebp),%edx
c0108248:	89 54 24 04          	mov    %edx,0x4(%esp)
c010824c:	89 04 24             	mov    %eax,(%esp)
c010824f:	e8 8e d5 ff ff       	call   c01057e2 <pgdir_alloc_page>
c0108254:	85 c0                	test   %eax,%eax
c0108256:	0f 85 ae 00 00 00    	jne    c010830a <do_pgfault+0x1ff>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c010825c:	c7 04 24 38 ba 10 c0 	movl   $0xc010ba38,(%esp)
c0108263:	e8 eb 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108268:	e9 a4 00 00 00       	jmp    c0108311 <do_pgfault+0x206>
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
c010826d:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0108272:	85 c0                	test   %eax,%eax
c0108274:	74 7d                	je     c01082f3 <do_pgfault+0x1e8>
            struct Page *page=NULL;
c0108276:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c010827d:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108280:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108284:	8b 45 10             	mov    0x10(%ebp),%eax
c0108287:	89 44 24 04          	mov    %eax,0x4(%esp)
c010828b:	8b 45 08             	mov    0x8(%ebp),%eax
c010828e:	89 04 24             	mov    %eax,(%esp)
c0108291:	e8 dc e5 ff ff       	call   c0106872 <swap_in>
c0108296:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010829d:	74 0e                	je     c01082ad <do_pgfault+0x1a2>
                cprintf("swap_in in do_pgfault failed\n");
c010829f:	c7 04 24 5f ba 10 c0 	movl   $0xc010ba5f,(%esp)
c01082a6:	e8 a8 80 ff ff       	call   c0100353 <cprintf>
c01082ab:	eb 64                	jmp    c0108311 <do_pgfault+0x206>
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
c01082ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01082b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01082b3:	8b 40 0c             	mov    0xc(%eax),%eax
c01082b6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01082b9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01082bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01082c0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01082c4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082c8:	89 04 24             	mov    %eax,(%esp)
c01082cb:	e8 fc d3 ff ff       	call   c01056cc <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c01082d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082d3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01082da:	00 
c01082db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082df:	8b 45 10             	mov    0x10(%ebp),%eax
c01082e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01082e9:	89 04 24             	mov    %eax,(%esp)
c01082ec:	e8 b8 e3 ff ff       	call   c01066a9 <swap_map_swappable>
c01082f1:	eb 17                	jmp    c010830a <do_pgfault+0x1ff>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01082f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082f6:	8b 00                	mov    (%eax),%eax
c01082f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082fc:	c7 04 24 80 ba 10 c0 	movl   $0xc010ba80,(%esp)
c0108303:	e8 4b 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108308:	eb 07                	jmp    c0108311 <do_pgfault+0x206>
        }
   }
   ret = 0;
c010830a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108311:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108314:	c9                   	leave  
c0108315:	c3                   	ret    

c0108316 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108316:	55                   	push   %ebp
c0108317:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108319:	8b 55 08             	mov    0x8(%ebp),%edx
c010831c:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108321:	29 c2                	sub    %eax,%edx
c0108323:	89 d0                	mov    %edx,%eax
c0108325:	c1 f8 05             	sar    $0x5,%eax
}
c0108328:	5d                   	pop    %ebp
c0108329:	c3                   	ret    

c010832a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010832a:	55                   	push   %ebp
c010832b:	89 e5                	mov    %esp,%ebp
c010832d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108330:	8b 45 08             	mov    0x8(%ebp),%eax
c0108333:	89 04 24             	mov    %eax,(%esp)
c0108336:	e8 db ff ff ff       	call   c0108316 <page2ppn>
c010833b:	c1 e0 0c             	shl    $0xc,%eax
}
c010833e:	c9                   	leave  
c010833f:	c3                   	ret    

c0108340 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108340:	55                   	push   %ebp
c0108341:	89 e5                	mov    %esp,%ebp
c0108343:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108346:	8b 45 08             	mov    0x8(%ebp),%eax
c0108349:	89 04 24             	mov    %eax,(%esp)
c010834c:	e8 d9 ff ff ff       	call   c010832a <page2pa>
c0108351:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108354:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108357:	c1 e8 0c             	shr    $0xc,%eax
c010835a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010835d:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108362:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108365:	72 23                	jb     c010838a <page2kva+0x4a>
c0108367:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010836a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010836e:	c7 44 24 08 a8 ba 10 	movl   $0xc010baa8,0x8(%esp)
c0108375:	c0 
c0108376:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010837d:	00 
c010837e:	c7 04 24 cb ba 10 c0 	movl   $0xc010bacb,(%esp)
c0108385:	e8 53 89 ff ff       	call   c0100cdd <__panic>
c010838a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010838d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108392:	c9                   	leave  
c0108393:	c3                   	ret    

c0108394 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108394:	55                   	push   %ebp
c0108395:	89 e5                	mov    %esp,%ebp
c0108397:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010839a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083a1:	e8 87 96 ff ff       	call   c0101a2d <ide_device_valid>
c01083a6:	85 c0                	test   %eax,%eax
c01083a8:	75 1c                	jne    c01083c6 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01083aa:	c7 44 24 08 d9 ba 10 	movl   $0xc010bad9,0x8(%esp)
c01083b1:	c0 
c01083b2:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01083b9:	00 
c01083ba:	c7 04 24 f3 ba 10 c0 	movl   $0xc010baf3,(%esp)
c01083c1:	e8 17 89 ff ff       	call   c0100cdd <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01083c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083cd:	e8 9a 96 ff ff       	call   c0101a6c <ide_device_size>
c01083d2:	c1 e8 03             	shr    $0x3,%eax
c01083d5:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c01083da:	c9                   	leave  
c01083db:	c3                   	ret    

c01083dc <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01083dc:	55                   	push   %ebp
c01083dd:	89 e5                	mov    %esp,%ebp
c01083df:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01083e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083e5:	89 04 24             	mov    %eax,(%esp)
c01083e8:	e8 53 ff ff ff       	call   c0108340 <page2kva>
c01083ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01083f0:	c1 ea 08             	shr    $0x8,%edx
c01083f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01083f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01083fa:	74 0b                	je     c0108407 <swapfs_read+0x2b>
c01083fc:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108402:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108405:	72 23                	jb     c010842a <swapfs_read+0x4e>
c0108407:	8b 45 08             	mov    0x8(%ebp),%eax
c010840a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010840e:	c7 44 24 08 04 bb 10 	movl   $0xc010bb04,0x8(%esp)
c0108415:	c0 
c0108416:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010841d:	00 
c010841e:	c7 04 24 f3 ba 10 c0 	movl   $0xc010baf3,(%esp)
c0108425:	e8 b3 88 ff ff       	call   c0100cdd <__panic>
c010842a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010842d:	c1 e2 03             	shl    $0x3,%edx
c0108430:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108437:	00 
c0108438:	89 44 24 08          	mov    %eax,0x8(%esp)
c010843c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108440:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108447:	e8 5f 96 ff ff       	call   c0101aab <ide_read_secs>
}
c010844c:	c9                   	leave  
c010844d:	c3                   	ret    

c010844e <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010844e:	55                   	push   %ebp
c010844f:	89 e5                	mov    %esp,%ebp
c0108451:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108457:	89 04 24             	mov    %eax,(%esp)
c010845a:	e8 e1 fe ff ff       	call   c0108340 <page2kva>
c010845f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108462:	c1 ea 08             	shr    $0x8,%edx
c0108465:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010846c:	74 0b                	je     c0108479 <swapfs_write+0x2b>
c010846e:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108474:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108477:	72 23                	jb     c010849c <swapfs_write+0x4e>
c0108479:	8b 45 08             	mov    0x8(%ebp),%eax
c010847c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108480:	c7 44 24 08 04 bb 10 	movl   $0xc010bb04,0x8(%esp)
c0108487:	c0 
c0108488:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010848f:	00 
c0108490:	c7 04 24 f3 ba 10 c0 	movl   $0xc010baf3,(%esp)
c0108497:	e8 41 88 ff ff       	call   c0100cdd <__panic>
c010849c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010849f:	c1 e2 03             	shl    $0x3,%edx
c01084a2:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01084a9:	00 
c01084aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084ae:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084b9:	e8 2f 98 ff ff       	call   c0101ced <ide_write_secs>
}
c01084be:	c9                   	leave  
c01084bf:	c3                   	ret    

c01084c0 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c01084c0:	52                   	push   %edx
    call *%ebx              # call fn
c01084c1:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c01084c3:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c01084c4:	e8 1c 08 00 00       	call   c0108ce5 <do_exit>

c01084c9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01084c9:	55                   	push   %ebp
c01084ca:	89 e5                	mov    %esp,%ebp
c01084cc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01084cf:	9c                   	pushf  
c01084d0:	58                   	pop    %eax
c01084d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01084d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01084d7:	25 00 02 00 00       	and    $0x200,%eax
c01084dc:	85 c0                	test   %eax,%eax
c01084de:	74 0c                	je     c01084ec <__intr_save+0x23>
        intr_disable();
c01084e0:	e8 50 9a ff ff       	call   c0101f35 <intr_disable>
        return 1;
c01084e5:	b8 01 00 00 00       	mov    $0x1,%eax
c01084ea:	eb 05                	jmp    c01084f1 <__intr_save+0x28>
    }
    return 0;
c01084ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01084f1:	c9                   	leave  
c01084f2:	c3                   	ret    

c01084f3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01084f3:	55                   	push   %ebp
c01084f4:	89 e5                	mov    %esp,%ebp
c01084f6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01084f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084fd:	74 05                	je     c0108504 <__intr_restore+0x11>
        intr_enable();
c01084ff:	e8 2b 9a ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108504:	c9                   	leave  
c0108505:	c3                   	ret    

c0108506 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108506:	55                   	push   %ebp
c0108507:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108509:	8b 55 08             	mov    0x8(%ebp),%edx
c010850c:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108511:	29 c2                	sub    %eax,%edx
c0108513:	89 d0                	mov    %edx,%eax
c0108515:	c1 f8 05             	sar    $0x5,%eax
}
c0108518:	5d                   	pop    %ebp
c0108519:	c3                   	ret    

c010851a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010851a:	55                   	push   %ebp
c010851b:	89 e5                	mov    %esp,%ebp
c010851d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108520:	8b 45 08             	mov    0x8(%ebp),%eax
c0108523:	89 04 24             	mov    %eax,(%esp)
c0108526:	e8 db ff ff ff       	call   c0108506 <page2ppn>
c010852b:	c1 e0 0c             	shl    $0xc,%eax
}
c010852e:	c9                   	leave  
c010852f:	c3                   	ret    

c0108530 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108530:	55                   	push   %ebp
c0108531:	89 e5                	mov    %esp,%ebp
c0108533:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0108536:	8b 45 08             	mov    0x8(%ebp),%eax
c0108539:	c1 e8 0c             	shr    $0xc,%eax
c010853c:	89 c2                	mov    %eax,%edx
c010853e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108543:	39 c2                	cmp    %eax,%edx
c0108545:	72 1c                	jb     c0108563 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0108547:	c7 44 24 08 24 bb 10 	movl   $0xc010bb24,0x8(%esp)
c010854e:	c0 
c010854f:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0108556:	00 
c0108557:	c7 04 24 43 bb 10 c0 	movl   $0xc010bb43,(%esp)
c010855e:	e8 7a 87 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0108563:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108568:	8b 55 08             	mov    0x8(%ebp),%edx
c010856b:	c1 ea 0c             	shr    $0xc,%edx
c010856e:	c1 e2 05             	shl    $0x5,%edx
c0108571:	01 d0                	add    %edx,%eax
}
c0108573:	c9                   	leave  
c0108574:	c3                   	ret    

c0108575 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0108575:	55                   	push   %ebp
c0108576:	89 e5                	mov    %esp,%ebp
c0108578:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010857b:	8b 45 08             	mov    0x8(%ebp),%eax
c010857e:	89 04 24             	mov    %eax,(%esp)
c0108581:	e8 94 ff ff ff       	call   c010851a <page2pa>
c0108586:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010858c:	c1 e8 0c             	shr    $0xc,%eax
c010858f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108592:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108597:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010859a:	72 23                	jb     c01085bf <page2kva+0x4a>
c010859c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010859f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085a3:	c7 44 24 08 54 bb 10 	movl   $0xc010bb54,0x8(%esp)
c01085aa:	c0 
c01085ab:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01085b2:	00 
c01085b3:	c7 04 24 43 bb 10 c0 	movl   $0xc010bb43,(%esp)
c01085ba:	e8 1e 87 ff ff       	call   c0100cdd <__panic>
c01085bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01085c7:	c9                   	leave  
c01085c8:	c3                   	ret    

c01085c9 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01085c9:	55                   	push   %ebp
c01085ca:	89 e5                	mov    %esp,%ebp
c01085cc:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01085cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01085d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085d5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01085dc:	77 23                	ja     c0108601 <kva2page+0x38>
c01085de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085e5:	c7 44 24 08 78 bb 10 	movl   $0xc010bb78,0x8(%esp)
c01085ec:	c0 
c01085ed:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01085f4:	00 
c01085f5:	c7 04 24 43 bb 10 c0 	movl   $0xc010bb43,(%esp)
c01085fc:	e8 dc 86 ff ff       	call   c0100cdd <__panic>
c0108601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108604:	05 00 00 00 40       	add    $0x40000000,%eax
c0108609:	89 04 24             	mov    %eax,(%esp)
c010860c:	e8 1f ff ff ff       	call   c0108530 <pa2page>
}
c0108611:	c9                   	leave  
c0108612:	c3                   	ret    

c0108613 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0108613:	55                   	push   %ebp
c0108614:	89 e5                	mov    %esp,%ebp
c0108616:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0108619:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c0108620:	e8 ad c2 ff ff       	call   c01048d2 <kmalloc>
c0108625:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0108628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010862c:	0f 84 a1 00 00 00    	je     c01086d3 <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
	proc->state = PROC_UNINIT;
c0108632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	proc->pid = -1;
c010863b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010863e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	proc->runs = 0;
c0108645:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108648:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	proc->kstack = 0;
c010864f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108652:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	proc->need_resched = 0;
c0108659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010865c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
	proc->parent = NULL;
c0108663:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108666:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	proc->mm = NULL;
c010866d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108670:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
	memset(&(proc->context),0,sizeof(struct context));
c0108677:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010867a:	83 c0 1c             	add    $0x1c,%eax
c010867d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108684:	00 
c0108685:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010868c:	00 
c010868d:	89 04 24             	mov    %eax,(%esp)
c0108690:	e8 d2 14 00 00       	call   c0109b67 <memset>
	proc->tf = NULL;
c0108695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108698:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
	proc->cr3 = boot_cr3;
c010869f:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c01086a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086a8:	89 50 40             	mov    %edx,0x40(%eax)
	proc->flags = 0;
c01086ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ae:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
	memset(proc->name,0,PROC_NAME_LEN+1);
c01086b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086b8:	83 c0 48             	add    $0x48,%eax
c01086bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01086c2:	00 
c01086c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086ca:	00 
c01086cb:	89 04 24             	mov    %eax,(%esp)
c01086ce:	e8 94 14 00 00       	call   c0109b67 <memset>
    }
    return proc;
c01086d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01086d6:	c9                   	leave  
c01086d7:	c3                   	ret    

c01086d8 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01086d8:	55                   	push   %ebp
c01086d9:	89 e5                	mov    %esp,%ebp
c01086db:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01086de:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e1:	83 c0 48             	add    $0x48,%eax
c01086e4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01086eb:	00 
c01086ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086f3:	00 
c01086f4:	89 04 24             	mov    %eax,(%esp)
c01086f7:	e8 6b 14 00 00       	call   c0109b67 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01086fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ff:	8d 50 48             	lea    0x48(%eax),%edx
c0108702:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108709:	00 
c010870a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010870d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108711:	89 14 24             	mov    %edx,(%esp)
c0108714:	e8 30 15 00 00       	call   c0109c49 <memcpy>
}
c0108719:	c9                   	leave  
c010871a:	c3                   	ret    

c010871b <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c010871b:	55                   	push   %ebp
c010871c:	89 e5                	mov    %esp,%ebp
c010871e:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0108721:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108728:	00 
c0108729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108730:	00 
c0108731:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108738:	e8 2a 14 00 00       	call   c0109b67 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010873d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108740:	83 c0 48             	add    $0x48,%eax
c0108743:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c010874a:	00 
c010874b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010874f:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108756:	e8 ee 14 00 00       	call   c0109c49 <memcpy>
}
c010875b:	c9                   	leave  
c010875c:	c3                   	ret    

c010875d <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c010875d:	55                   	push   %ebp
c010875e:	89 e5                	mov    %esp,%ebp
c0108760:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108763:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c010876a:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010876f:	83 c0 01             	add    $0x1,%eax
c0108772:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108777:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010877c:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108781:	7e 0c                	jle    c010878f <get_pid+0x32>
        last_pid = 1;
c0108783:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c010878a:	00 00 00 
        goto inside;
c010878d:	eb 13                	jmp    c01087a2 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010878f:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c0108795:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c010879a:	39 c2                	cmp    %eax,%edx
c010879c:	0f 8c ac 00 00 00    	jl     c010884e <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01087a2:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c01087a9:	20 00 00 
    repeat:
        le = list;
c01087ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01087af:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01087b2:	eb 7f                	jmp    c0108833 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01087b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087b7:	83 e8 58             	sub    $0x58,%eax
c01087ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01087bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087c0:	8b 50 04             	mov    0x4(%eax),%edx
c01087c3:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087c8:	39 c2                	cmp    %eax,%edx
c01087ca:	75 3e                	jne    c010880a <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c01087cc:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087d1:	83 c0 01             	add    $0x1,%eax
c01087d4:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01087d9:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01087df:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01087e4:	39 c2                	cmp    %eax,%edx
c01087e6:	7c 4b                	jl     c0108833 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c01087e8:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087ed:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01087f2:	7e 0a                	jle    c01087fe <get_pid+0xa1>
                        last_pid = 1;
c01087f4:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c01087fb:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01087fe:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108805:	20 00 00 
                    goto repeat;
c0108808:	eb a2                	jmp    c01087ac <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c010880a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010880d:	8b 50 04             	mov    0x4(%eax),%edx
c0108810:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108815:	39 c2                	cmp    %eax,%edx
c0108817:	7e 1a                	jle    c0108833 <get_pid+0xd6>
c0108819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010881c:	8b 50 04             	mov    0x4(%eax),%edx
c010881f:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108824:	39 c2                	cmp    %eax,%edx
c0108826:	7d 0b                	jge    c0108833 <get_pid+0xd6>
                next_safe = proc->pid;
c0108828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010882b:	8b 40 04             	mov    0x4(%eax),%eax
c010882e:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c0108833:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108836:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108839:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010883c:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c010883f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108842:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108845:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108848:	0f 85 66 ff ff ff    	jne    c01087b4 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c010884e:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c0108853:	c9                   	leave  
c0108854:	c3                   	ret    

c0108855 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108855:	55                   	push   %ebp
c0108856:	89 e5                	mov    %esp,%ebp
c0108858:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c010885b:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108860:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108863:	74 63                	je     c01088c8 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108865:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010886a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010886d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108870:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108873:	e8 51 fc ff ff       	call   c01084c9 <__intr_save>
c0108878:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c010887b:	8b 45 08             	mov    0x8(%ebp),%eax
c010887e:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108883:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108886:	8b 40 0c             	mov    0xc(%eax),%eax
c0108889:	05 00 20 00 00       	add    $0x2000,%eax
c010888e:	89 04 24             	mov    %eax,(%esp)
c0108891:	e8 4b c3 ff ff       	call   c0104be1 <load_esp0>
            lcr3(next->cr3);
c0108896:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108899:	8b 40 40             	mov    0x40(%eax),%eax
c010889c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010889f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088a2:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01088a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088a8:	8d 50 1c             	lea    0x1c(%eax),%edx
c01088ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ae:	83 c0 1c             	add    $0x1c,%eax
c01088b1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01088b5:	89 04 24             	mov    %eax,(%esp)
c01088b8:	e8 7a 06 00 00       	call   c0108f37 <switch_to>
        }
        local_intr_restore(intr_flag);
c01088bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088c0:	89 04 24             	mov    %eax,(%esp)
c01088c3:	e8 2b fc ff ff       	call   c01084f3 <__intr_restore>
    }
}
c01088c8:	c9                   	leave  
c01088c9:	c3                   	ret    

c01088ca <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01088ca:	55                   	push   %ebp
c01088cb:	89 e5                	mov    %esp,%ebp
c01088cd:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c01088d0:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01088d5:	8b 40 3c             	mov    0x3c(%eax),%eax
c01088d8:	89 04 24             	mov    %eax,(%esp)
c01088db:	e8 79 9e ff ff       	call   c0102759 <forkrets>
}
c01088e0:	c9                   	leave  
c01088e1:	c3                   	ret    

c01088e2 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01088e2:	55                   	push   %ebp
c01088e3:	89 e5                	mov    %esp,%ebp
c01088e5:	53                   	push   %ebx
c01088e6:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01088e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ec:	8d 58 60             	lea    0x60(%eax),%ebx
c01088ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f2:	8b 40 04             	mov    0x4(%eax),%eax
c01088f5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01088fc:	00 
c01088fd:	89 04 24             	mov    %eax,(%esp)
c0108900:	e8 b5 07 00 00       	call   c01090ba <hash32>
c0108905:	c1 e0 03             	shl    $0x3,%eax
c0108908:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010890d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108910:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108916:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108919:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010891c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010891f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108922:	8b 40 04             	mov    0x4(%eax),%eax
c0108925:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108928:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010892b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010892e:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108931:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108934:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108937:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010893a:	89 10                	mov    %edx,(%eax)
c010893c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010893f:	8b 10                	mov    (%eax),%edx
c0108941:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108944:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010894a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010894d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108953:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108956:	89 10                	mov    %edx,(%eax)
}
c0108958:	83 c4 34             	add    $0x34,%esp
c010895b:	5b                   	pop    %ebx
c010895c:	5d                   	pop    %ebp
c010895d:	c3                   	ret    

c010895e <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c010895e:	55                   	push   %ebp
c010895f:	89 e5                	mov    %esp,%ebp
c0108961:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108964:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108968:	7e 5f                	jle    c01089c9 <find_proc+0x6b>
c010896a:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108971:	7f 56                	jg     c01089c9 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108973:	8b 45 08             	mov    0x8(%ebp),%eax
c0108976:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010897d:	00 
c010897e:	89 04 24             	mov    %eax,(%esp)
c0108981:	e8 34 07 00 00       	call   c01090ba <hash32>
c0108986:	c1 e0 03             	shl    $0x3,%eax
c0108989:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010898e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108994:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108997:	eb 19                	jmp    c01089b2 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108999:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010899c:	83 e8 60             	sub    $0x60,%eax
c010899f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c01089a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089a5:	8b 40 04             	mov    0x4(%eax),%eax
c01089a8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01089ab:	75 05                	jne    c01089b2 <find_proc+0x54>
                return proc;
c01089ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089b0:	eb 1c                	jmp    c01089ce <find_proc+0x70>
c01089b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01089b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089bb:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c01089be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01089c7:	75 d0                	jne    c0108999 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c01089c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01089ce:	c9                   	leave  
c01089cf:	c3                   	ret    

c01089d0 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c01089d0:	55                   	push   %ebp
c01089d1:	89 e5                	mov    %esp,%ebp
c01089d3:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c01089d6:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c01089dd:	00 
c01089de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089e5:	00 
c01089e6:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01089e9:	89 04 24             	mov    %eax,(%esp)
c01089ec:	e8 76 11 00 00       	call   c0109b67 <memset>
    tf.tf_cs = KERNEL_CS;
c01089f1:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c01089f7:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c01089fd:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108a01:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108a05:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108a09:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a10:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a16:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108a19:	b8 c0 84 10 c0       	mov    $0xc01084c0,%eax
c0108a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108a21:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a24:	80 cc 01             	or     $0x1,%ah
c0108a27:	89 c2                	mov    %eax,%edx
c0108a29:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108a30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108a37:	00 
c0108a38:	89 14 24             	mov    %edx,(%esp)
c0108a3b:	e8 79 01 00 00       	call   c0108bb9 <do_fork>
}
c0108a40:	c9                   	leave  
c0108a41:	c3                   	ret    

c0108a42 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108a42:	55                   	push   %ebp
c0108a43:	89 e5                	mov    %esp,%ebp
c0108a45:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108a48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108a4f:	e8 db c2 ff ff       	call   c0104d2f <alloc_pages>
c0108a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a5b:	74 1a                	je     c0108a77 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a60:	89 04 24             	mov    %eax,(%esp)
c0108a63:	e8 0d fb ff ff       	call   c0108575 <page2kva>
c0108a68:	89 c2                	mov    %eax,%edx
c0108a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6d:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108a70:	b8 00 00 00 00       	mov    $0x0,%eax
c0108a75:	eb 05                	jmp    c0108a7c <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108a77:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108a7c:	c9                   	leave  
c0108a7d:	c3                   	ret    

c0108a7e <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108a7e:	55                   	push   %ebp
c0108a7f:	89 e5                	mov    %esp,%ebp
c0108a81:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a87:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a8a:	89 04 24             	mov    %eax,(%esp)
c0108a8d:	e8 37 fb ff ff       	call   c01085c9 <kva2page>
c0108a92:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108a99:	00 
c0108a9a:	89 04 24             	mov    %eax,(%esp)
c0108a9d:	e8 f8 c2 ff ff       	call   c0104d9a <free_pages>
}
c0108aa2:	c9                   	leave  
c0108aa3:	c3                   	ret    

c0108aa4 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108aa4:	55                   	push   %ebp
c0108aa5:	89 e5                	mov    %esp,%ebp
c0108aa7:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108aaa:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108aaf:	8b 40 18             	mov    0x18(%eax),%eax
c0108ab2:	85 c0                	test   %eax,%eax
c0108ab4:	74 24                	je     c0108ada <copy_mm+0x36>
c0108ab6:	c7 44 24 0c 9c bb 10 	movl   $0xc010bb9c,0xc(%esp)
c0108abd:	c0 
c0108abe:	c7 44 24 08 b0 bb 10 	movl   $0xc010bbb0,0x8(%esp)
c0108ac5:	c0 
c0108ac6:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108acd:	00 
c0108ace:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108ad5:	e8 03 82 ff ff       	call   c0100cdd <__panic>
    /* do nothing in this project */
    return 0;
c0108ada:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108adf:	c9                   	leave  
c0108ae0:	c3                   	ret    

c0108ae1 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108ae1:	55                   	push   %ebp
c0108ae2:	89 e5                	mov    %esp,%ebp
c0108ae4:	57                   	push   %edi
c0108ae5:	56                   	push   %esi
c0108ae6:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aea:	8b 40 0c             	mov    0xc(%eax),%eax
c0108aed:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108af2:	89 c2                	mov    %eax,%edx
c0108af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108af7:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afd:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b00:	8b 55 10             	mov    0x10(%ebp),%edx
c0108b03:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108b08:	89 c1                	mov    %eax,%ecx
c0108b0a:	83 e1 01             	and    $0x1,%ecx
c0108b0d:	85 c9                	test   %ecx,%ecx
c0108b0f:	74 0e                	je     c0108b1f <copy_thread+0x3e>
c0108b11:	0f b6 0a             	movzbl (%edx),%ecx
c0108b14:	88 08                	mov    %cl,(%eax)
c0108b16:	83 c0 01             	add    $0x1,%eax
c0108b19:	83 c2 01             	add    $0x1,%edx
c0108b1c:	83 eb 01             	sub    $0x1,%ebx
c0108b1f:	89 c1                	mov    %eax,%ecx
c0108b21:	83 e1 02             	and    $0x2,%ecx
c0108b24:	85 c9                	test   %ecx,%ecx
c0108b26:	74 0f                	je     c0108b37 <copy_thread+0x56>
c0108b28:	0f b7 0a             	movzwl (%edx),%ecx
c0108b2b:	66 89 08             	mov    %cx,(%eax)
c0108b2e:	83 c0 02             	add    $0x2,%eax
c0108b31:	83 c2 02             	add    $0x2,%edx
c0108b34:	83 eb 02             	sub    $0x2,%ebx
c0108b37:	89 d9                	mov    %ebx,%ecx
c0108b39:	c1 e9 02             	shr    $0x2,%ecx
c0108b3c:	89 c7                	mov    %eax,%edi
c0108b3e:	89 d6                	mov    %edx,%esi
c0108b40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b42:	89 f2                	mov    %esi,%edx
c0108b44:	89 f8                	mov    %edi,%eax
c0108b46:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108b4b:	89 de                	mov    %ebx,%esi
c0108b4d:	83 e6 02             	and    $0x2,%esi
c0108b50:	85 f6                	test   %esi,%esi
c0108b52:	74 0b                	je     c0108b5f <copy_thread+0x7e>
c0108b54:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108b58:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108b5c:	83 c1 02             	add    $0x2,%ecx
c0108b5f:	83 e3 01             	and    $0x1,%ebx
c0108b62:	85 db                	test   %ebx,%ebx
c0108b64:	74 07                	je     c0108b6d <copy_thread+0x8c>
c0108b66:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108b6a:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b70:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b73:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b7d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b80:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108b83:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b89:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b8f:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108b92:	8b 52 40             	mov    0x40(%edx),%edx
c0108b95:	80 ce 02             	or     $0x2,%dh
c0108b98:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108b9b:	ba ca 88 10 c0       	mov    $0xc01088ca,%edx
c0108ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ba3:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ba9:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bac:	89 c2                	mov    %eax,%edx
c0108bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb1:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108bb4:	5b                   	pop    %ebx
c0108bb5:	5e                   	pop    %esi
c0108bb6:	5f                   	pop    %edi
c0108bb7:	5d                   	pop    %ebp
c0108bb8:	c3                   	ret    

c0108bb9 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108bb9:	55                   	push   %ebp
c0108bba:	89 e5                	mov    %esp,%ebp
c0108bbc:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108bbf:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108bc6:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108bcb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108bd0:	7e 05                	jle    c0108bd7 <do_fork+0x1e>
        goto fork_out;
c0108bd2:	e9 fa 00 00 00       	jmp    c0108cd1 <do_fork+0x118>
    }
    ret = -E_NO_MEM;
c0108bd7:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
	proc = alloc_proc();
c0108bde:	e8 30 fa ff ff       	call   c0108613 <alloc_proc>
c0108be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (proc==NULL) {
c0108be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108bea:	75 05                	jne    c0108bf1 <do_fork+0x38>
		//printf("alllocfail");
		goto fork_out;
c0108bec:	e9 e0 00 00 00       	jmp    c0108cd1 <do_fork+0x118>
	}
	if (setup_kstack(proc)!=0) {
c0108bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bf4:	89 04 24             	mov    %eax,(%esp)
c0108bf7:	e8 46 fe ff ff       	call   c0108a42 <setup_kstack>
c0108bfc:	85 c0                	test   %eax,%eax
c0108bfe:	74 05                	je     c0108c05 <do_fork+0x4c>
		goto bad_fork_cleanup_proc;
c0108c00:	e9 d1 00 00 00       	jmp    c0108cd6 <do_fork+0x11d>
	}
	if (copy_mm(clone_flags,proc)!=0) {
c0108c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c0f:	89 04 24             	mov    %eax,(%esp)
c0108c12:	e8 8d fe ff ff       	call   c0108aa4 <copy_mm>
c0108c17:	85 c0                	test   %eax,%eax
c0108c19:	74 11                	je     c0108c2c <do_fork+0x73>
		goto bad_fork_cleanup_kstack;
c0108c1b:	90                   	nop
	
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c1f:	89 04 24             	mov    %eax,(%esp)
c0108c22:	e8 57 fe ff ff       	call   c0108a7e <put_kstack>
c0108c27:	e9 aa 00 00 00       	jmp    c0108cd6 <do_fork+0x11d>
		goto bad_fork_cleanup_proc;
	}
	if (copy_mm(clone_flags,proc)!=0) {
		goto bad_fork_cleanup_kstack;
	}
	copy_thread(proc, stack, tf);
c0108c2c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c2f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c3d:	89 04 24             	mov    %eax,(%esp)
c0108c40:	e8 9c fe ff ff       	call   c0108ae1 <copy_thread>
	proc->pid = get_pid();	
c0108c45:	e8 13 fb ff ff       	call   c010875d <get_pid>
c0108c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108c4d:	89 42 04             	mov    %eax,0x4(%edx)
	hash_proc(proc);
c0108c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c53:	89 04 24             	mov    %eax,(%esp)
c0108c56:	e8 87 fc ff ff       	call   c01088e2 <hash_proc>
	list_add(&proc_list,&(proc->list_link));
c0108c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c5e:	83 c0 58             	add    $0x58,%eax
c0108c61:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
c0108c68:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c7a:	8b 40 04             	mov    0x4(%eax),%eax
c0108c7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c80:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108c86:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108c89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108c8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c92:	89 10                	mov    %edx,(%eax)
c0108c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c97:	8b 10                	mov    (%eax),%edx
c0108c99:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c9c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ca2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108ca5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108cab:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108cae:	89 10                	mov    %edx,(%eax)
	nr_process++;
c0108cb0:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108cb5:	83 c0 01             	add    $0x1,%eax
c0108cb8:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
	wakeup_proc(proc);
c0108cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cc0:	89 04 24             	mov    %eax,(%esp)
c0108cc3:	e8 e3 02 00 00       	call   c0108fab <wakeup_proc>
	ret = proc->pid;
c0108cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ccb:	8b 40 04             	mov    0x4(%eax),%eax
c0108cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
fork_out:
    return ret;
c0108cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cd4:	eb 0d                	jmp    c0108ce3 <do_fork+0x12a>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cd9:	89 04 24             	mov    %eax,(%esp)
c0108cdc:	e8 0c bc ff ff       	call   c01048ed <kfree>
    goto fork_out;
c0108ce1:	eb ee                	jmp    c0108cd1 <do_fork+0x118>
}
c0108ce3:	c9                   	leave  
c0108ce4:	c3                   	ret    

c0108ce5 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108ce5:	55                   	push   %ebp
c0108ce6:	89 e5                	mov    %esp,%ebp
c0108ce8:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108ceb:	c7 44 24 08 d9 bb 10 	movl   $0xc010bbd9,0x8(%esp)
c0108cf2:	c0 
c0108cf3:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c0108cfa:	00 
c0108cfb:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108d02:	e8 d6 7f ff ff       	call   c0100cdd <__panic>

c0108d07 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108d07:	55                   	push   %ebp
c0108d08:	89 e5                	mov    %esp,%ebp
c0108d0a:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108d0d:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108d12:	89 04 24             	mov    %eax,(%esp)
c0108d15:	e8 01 fa ff ff       	call   c010871b <get_proc_name>
c0108d1a:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108d20:	8b 52 04             	mov    0x4(%edx),%edx
c0108d23:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d27:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d2b:	c7 04 24 ec bb 10 c0 	movl   $0xc010bbec,(%esp)
c0108d32:	e8 1c 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d3e:	c7 04 24 12 bc 10 c0 	movl   $0xc010bc12,(%esp)
c0108d45:	e8 09 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108d4a:	c7 04 24 1f bc 10 c0 	movl   $0xc010bc1f,(%esp)
c0108d51:	e8 fd 75 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108d5b:	c9                   	leave  
c0108d5c:	c3                   	ret    

c0108d5d <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108d5d:	55                   	push   %ebp
c0108d5e:	89 e5                	mov    %esp,%ebp
c0108d60:	83 ec 28             	sub    $0x28,%esp
c0108d63:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108d70:	89 50 04             	mov    %edx,0x4(%eax)
c0108d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d76:	8b 50 04             	mov    0x4(%eax),%edx
c0108d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d7c:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d85:	eb 26                	jmp    c0108dad <proc_init+0x50>
        list_init(hash_list + i);
c0108d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d8a:	c1 e0 03             	shl    $0x3,%eax
c0108d8d:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108d92:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d98:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d9b:	89 50 04             	mov    %edx,0x4(%eax)
c0108d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108da1:	8b 50 04             	mov    0x4(%eax),%edx
c0108da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108da7:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108da9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108dad:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108db4:	7e d1                	jle    c0108d87 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108db6:	e8 58 f8 ff ff       	call   c0108613 <alloc_proc>
c0108dbb:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108dc0:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dc5:	85 c0                	test   %eax,%eax
c0108dc7:	75 1c                	jne    c0108de5 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108dc9:	c7 44 24 08 3b bc 10 	movl   $0xc010bc3b,0x8(%esp)
c0108dd0:	c0 
c0108dd1:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c0108dd8:	00 
c0108dd9:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108de0:	e8 f8 7e ff ff       	call   c0100cdd <__panic>
    }

    idleproc->pid = 0;
c0108de5:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108df1:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108df6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108dfc:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e01:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108e06:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108e09:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e0e:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108e15:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e1a:	c7 44 24 04 53 bc 10 	movl   $0xc010bc53,0x4(%esp)
c0108e21:	c0 
c0108e22:	89 04 24             	mov    %eax,(%esp)
c0108e25:	e8 ae f8 ff ff       	call   c01086d8 <set_proc_name>
    nr_process ++;
c0108e2a:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108e2f:	83 c0 01             	add    $0x1,%eax
c0108e32:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108e37:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e3c:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108e41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108e48:	00 
c0108e49:	c7 44 24 04 58 bc 10 	movl   $0xc010bc58,0x4(%esp)
c0108e50:	c0 
c0108e51:	c7 04 24 07 8d 10 c0 	movl   $0xc0108d07,(%esp)
c0108e58:	e8 73 fb ff ff       	call   c01089d0 <kernel_thread>
c0108e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108e60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108e64:	7f 1c                	jg     c0108e82 <proc_init+0x125>
        panic("create init_main failed.\n");
c0108e66:	c7 44 24 08 66 bc 10 	movl   $0xc010bc66,0x8(%esp)
c0108e6d:	c0 
c0108e6e:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
c0108e75:	00 
c0108e76:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108e7d:	e8 5b 7e ff ff       	call   c0100cdd <__panic>
    }

    initproc = find_proc(pid);
c0108e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e85:	89 04 24             	mov    %eax,(%esp)
c0108e88:	e8 d1 fa ff ff       	call   c010895e <find_proc>
c0108e8d:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108e92:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e97:	c7 44 24 04 80 bc 10 	movl   $0xc010bc80,0x4(%esp)
c0108e9e:	c0 
c0108e9f:	89 04 24             	mov    %eax,(%esp)
c0108ea2:	e8 31 f8 ff ff       	call   c01086d8 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108ea7:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108eac:	85 c0                	test   %eax,%eax
c0108eae:	74 0c                	je     c0108ebc <proc_init+0x15f>
c0108eb0:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108eb5:	8b 40 04             	mov    0x4(%eax),%eax
c0108eb8:	85 c0                	test   %eax,%eax
c0108eba:	74 24                	je     c0108ee0 <proc_init+0x183>
c0108ebc:	c7 44 24 0c 88 bc 10 	movl   $0xc010bc88,0xc(%esp)
c0108ec3:	c0 
c0108ec4:	c7 44 24 08 b0 bb 10 	movl   $0xc010bbb0,0x8(%esp)
c0108ecb:	c0 
c0108ecc:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c0108ed3:	00 
c0108ed4:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108edb:	e8 fd 7d ff ff       	call   c0100cdd <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108ee0:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108ee5:	85 c0                	test   %eax,%eax
c0108ee7:	74 0d                	je     c0108ef6 <proc_init+0x199>
c0108ee9:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108eee:	8b 40 04             	mov    0x4(%eax),%eax
c0108ef1:	83 f8 01             	cmp    $0x1,%eax
c0108ef4:	74 24                	je     c0108f1a <proc_init+0x1bd>
c0108ef6:	c7 44 24 0c b0 bc 10 	movl   $0xc010bcb0,0xc(%esp)
c0108efd:	c0 
c0108efe:	c7 44 24 08 b0 bb 10 	movl   $0xc010bbb0,0x8(%esp)
c0108f05:	c0 
c0108f06:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c0108f0d:	00 
c0108f0e:	c7 04 24 c5 bb 10 c0 	movl   $0xc010bbc5,(%esp)
c0108f15:	e8 c3 7d ff ff       	call   c0100cdd <__panic>
}
c0108f1a:	c9                   	leave  
c0108f1b:	c3                   	ret    

c0108f1c <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108f1c:	55                   	push   %ebp
c0108f1d:	89 e5                	mov    %esp,%ebp
c0108f1f:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0108f22:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108f27:	8b 40 10             	mov    0x10(%eax),%eax
c0108f2a:	85 c0                	test   %eax,%eax
c0108f2c:	74 07                	je     c0108f35 <cpu_idle+0x19>
            schedule();
c0108f2e:	e8 c1 00 00 00       	call   c0108ff4 <schedule>
        }
    }
c0108f33:	eb ed                	jmp    c0108f22 <cpu_idle+0x6>
c0108f35:	eb eb                	jmp    c0108f22 <cpu_idle+0x6>

c0108f37 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108f37:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108f3b:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0108f3d:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0108f40:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0108f43:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0108f46:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0108f49:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0108f4c:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0108f4f:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108f52:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0108f56:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0108f59:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0108f5c:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0108f5f:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c0108f62:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0108f65:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0108f68:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108f6b:	ff 30                	pushl  (%eax)

    ret
c0108f6d:	c3                   	ret    

c0108f6e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108f6e:	55                   	push   %ebp
c0108f6f:	89 e5                	mov    %esp,%ebp
c0108f71:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108f74:	9c                   	pushf  
c0108f75:	58                   	pop    %eax
c0108f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108f7c:	25 00 02 00 00       	and    $0x200,%eax
c0108f81:	85 c0                	test   %eax,%eax
c0108f83:	74 0c                	je     c0108f91 <__intr_save+0x23>
        intr_disable();
c0108f85:	e8 ab 8f ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0108f8a:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f8f:	eb 05                	jmp    c0108f96 <__intr_save+0x28>
    }
    return 0;
c0108f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f96:	c9                   	leave  
c0108f97:	c3                   	ret    

c0108f98 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108f98:	55                   	push   %ebp
c0108f99:	89 e5                	mov    %esp,%ebp
c0108f9b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108f9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108fa2:	74 05                	je     c0108fa9 <__intr_restore+0x11>
        intr_enable();
c0108fa4:	e8 86 8f ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108fa9:	c9                   	leave  
c0108faa:	c3                   	ret    

c0108fab <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108fab:	55                   	push   %ebp
c0108fac:	89 e5                	mov    %esp,%ebp
c0108fae:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fb4:	8b 00                	mov    (%eax),%eax
c0108fb6:	83 f8 03             	cmp    $0x3,%eax
c0108fb9:	74 0a                	je     c0108fc5 <wakeup_proc+0x1a>
c0108fbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fbe:	8b 00                	mov    (%eax),%eax
c0108fc0:	83 f8 02             	cmp    $0x2,%eax
c0108fc3:	75 24                	jne    c0108fe9 <wakeup_proc+0x3e>
c0108fc5:	c7 44 24 0c d8 bc 10 	movl   $0xc010bcd8,0xc(%esp)
c0108fcc:	c0 
c0108fcd:	c7 44 24 08 13 bd 10 	movl   $0xc010bd13,0x8(%esp)
c0108fd4:	c0 
c0108fd5:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0108fdc:	00 
c0108fdd:	c7 04 24 28 bd 10 c0 	movl   $0xc010bd28,(%esp)
c0108fe4:	e8 f4 7c ff ff       	call   c0100cdd <__panic>
    proc->state = PROC_RUNNABLE;
c0108fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fec:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0108ff2:	c9                   	leave  
c0108ff3:	c3                   	ret    

c0108ff4 <schedule>:

void
schedule(void) {
c0108ff4:	55                   	push   %ebp
c0108ff5:	89 e5                	mov    %esp,%ebp
c0108ff7:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0108ffa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0109001:	e8 68 ff ff ff       	call   c0108f6e <__intr_save>
c0109006:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0109009:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010900e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0109015:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c010901b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109020:	39 c2                	cmp    %eax,%edx
c0109022:	74 0a                	je     c010902e <schedule+0x3a>
c0109024:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109029:	83 c0 58             	add    $0x58,%eax
c010902c:	eb 05                	jmp    c0109033 <schedule+0x3f>
c010902e:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c0109033:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0109036:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109039:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010903c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010903f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109045:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109048:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010904b:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c0109052:	74 15                	je     c0109069 <schedule+0x75>
                next = le2proc(le, list_link);
c0109054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109057:	83 e8 58             	sub    $0x58,%eax
c010905a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010905d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109060:	8b 00                	mov    (%eax),%eax
c0109062:	83 f8 02             	cmp    $0x2,%eax
c0109065:	75 02                	jne    c0109069 <schedule+0x75>
                    break;
c0109067:	eb 08                	jmp    c0109071 <schedule+0x7d>
                }
            }
        } while (le != last);
c0109069:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010906c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010906f:	75 cb                	jne    c010903c <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c0109071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109075:	74 0a                	je     c0109081 <schedule+0x8d>
c0109077:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010907a:	8b 00                	mov    (%eax),%eax
c010907c:	83 f8 02             	cmp    $0x2,%eax
c010907f:	74 08                	je     c0109089 <schedule+0x95>
            next = idleproc;
c0109081:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109086:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109089:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010908c:	8b 40 08             	mov    0x8(%eax),%eax
c010908f:	8d 50 01             	lea    0x1(%eax),%edx
c0109092:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109095:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109098:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010909d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01090a0:	74 0b                	je     c01090ad <schedule+0xb9>
            proc_run(next);
c01090a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090a5:	89 04 24             	mov    %eax,(%esp)
c01090a8:	e8 a8 f7 ff ff       	call   c0108855 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c01090ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01090b0:	89 04 24             	mov    %eax,(%esp)
c01090b3:	e8 e0 fe ff ff       	call   c0108f98 <__intr_restore>
}
c01090b8:	c9                   	leave  
c01090b9:	c3                   	ret    

c01090ba <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c01090ba:	55                   	push   %ebp
c01090bb:	89 e5                	mov    %esp,%ebp
c01090bd:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c01090c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01090c3:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c01090c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c01090cc:	b8 20 00 00 00       	mov    $0x20,%eax
c01090d1:	2b 45 0c             	sub    0xc(%ebp),%eax
c01090d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01090d7:	89 c1                	mov    %eax,%ecx
c01090d9:	d3 ea                	shr    %cl,%edx
c01090db:	89 d0                	mov    %edx,%eax
}
c01090dd:	c9                   	leave  
c01090de:	c3                   	ret    

c01090df <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01090df:	55                   	push   %ebp
c01090e0:	89 e5                	mov    %esp,%ebp
c01090e2:	83 ec 58             	sub    $0x58,%esp
c01090e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01090e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01090eb:	8b 45 14             	mov    0x14(%ebp),%eax
c01090ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01090f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01090f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01090f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01090fa:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01090fd:	8b 45 18             	mov    0x18(%ebp),%eax
c0109100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109103:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109106:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109109:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010910c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010910f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109112:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109115:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109119:	74 1c                	je     c0109137 <printnum+0x58>
c010911b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010911e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109123:	f7 75 e4             	divl   -0x1c(%ebp)
c0109126:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109129:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010912c:	ba 00 00 00 00       	mov    $0x0,%edx
c0109131:	f7 75 e4             	divl   -0x1c(%ebp)
c0109134:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109137:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010913a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010913d:	f7 75 e4             	divl   -0x1c(%ebp)
c0109140:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109143:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109146:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109149:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010914c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010914f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109152:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109155:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109158:	8b 45 18             	mov    0x18(%ebp),%eax
c010915b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109160:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109163:	77 56                	ja     c01091bb <printnum+0xdc>
c0109165:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109168:	72 05                	jb     c010916f <printnum+0x90>
c010916a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010916d:	77 4c                	ja     c01091bb <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010916f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0109172:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109175:	8b 45 20             	mov    0x20(%ebp),%eax
c0109178:	89 44 24 18          	mov    %eax,0x18(%esp)
c010917c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109180:	8b 45 18             	mov    0x18(%ebp),%eax
c0109183:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109187:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010918a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010918d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109191:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109195:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109198:	89 44 24 04          	mov    %eax,0x4(%esp)
c010919c:	8b 45 08             	mov    0x8(%ebp),%eax
c010919f:	89 04 24             	mov    %eax,(%esp)
c01091a2:	e8 38 ff ff ff       	call   c01090df <printnum>
c01091a7:	eb 1c                	jmp    c01091c5 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01091a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091b0:	8b 45 20             	mov    0x20(%ebp),%eax
c01091b3:	89 04 24             	mov    %eax,(%esp)
c01091b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01091b9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01091bb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01091bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01091c3:	7f e4                	jg     c01091a9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01091c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01091c8:	05 c0 bd 10 c0       	add    $0xc010bdc0,%eax
c01091cd:	0f b6 00             	movzbl (%eax),%eax
c01091d0:	0f be c0             	movsbl %al,%eax
c01091d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01091da:	89 04 24             	mov    %eax,(%esp)
c01091dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01091e0:	ff d0                	call   *%eax
}
c01091e2:	c9                   	leave  
c01091e3:	c3                   	ret    

c01091e4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01091e4:	55                   	push   %ebp
c01091e5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01091e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01091eb:	7e 14                	jle    c0109201 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01091ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f0:	8b 00                	mov    (%eax),%eax
c01091f2:	8d 48 08             	lea    0x8(%eax),%ecx
c01091f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01091f8:	89 0a                	mov    %ecx,(%edx)
c01091fa:	8b 50 04             	mov    0x4(%eax),%edx
c01091fd:	8b 00                	mov    (%eax),%eax
c01091ff:	eb 30                	jmp    c0109231 <getuint+0x4d>
    }
    else if (lflag) {
c0109201:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109205:	74 16                	je     c010921d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109207:	8b 45 08             	mov    0x8(%ebp),%eax
c010920a:	8b 00                	mov    (%eax),%eax
c010920c:	8d 48 04             	lea    0x4(%eax),%ecx
c010920f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109212:	89 0a                	mov    %ecx,(%edx)
c0109214:	8b 00                	mov    (%eax),%eax
c0109216:	ba 00 00 00 00       	mov    $0x0,%edx
c010921b:	eb 14                	jmp    c0109231 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010921d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109220:	8b 00                	mov    (%eax),%eax
c0109222:	8d 48 04             	lea    0x4(%eax),%ecx
c0109225:	8b 55 08             	mov    0x8(%ebp),%edx
c0109228:	89 0a                	mov    %ecx,(%edx)
c010922a:	8b 00                	mov    (%eax),%eax
c010922c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109231:	5d                   	pop    %ebp
c0109232:	c3                   	ret    

c0109233 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109233:	55                   	push   %ebp
c0109234:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109236:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010923a:	7e 14                	jle    c0109250 <getint+0x1d>
        return va_arg(*ap, long long);
c010923c:	8b 45 08             	mov    0x8(%ebp),%eax
c010923f:	8b 00                	mov    (%eax),%eax
c0109241:	8d 48 08             	lea    0x8(%eax),%ecx
c0109244:	8b 55 08             	mov    0x8(%ebp),%edx
c0109247:	89 0a                	mov    %ecx,(%edx)
c0109249:	8b 50 04             	mov    0x4(%eax),%edx
c010924c:	8b 00                	mov    (%eax),%eax
c010924e:	eb 28                	jmp    c0109278 <getint+0x45>
    }
    else if (lflag) {
c0109250:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109254:	74 12                	je     c0109268 <getint+0x35>
        return va_arg(*ap, long);
c0109256:	8b 45 08             	mov    0x8(%ebp),%eax
c0109259:	8b 00                	mov    (%eax),%eax
c010925b:	8d 48 04             	lea    0x4(%eax),%ecx
c010925e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109261:	89 0a                	mov    %ecx,(%edx)
c0109263:	8b 00                	mov    (%eax),%eax
c0109265:	99                   	cltd   
c0109266:	eb 10                	jmp    c0109278 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109268:	8b 45 08             	mov    0x8(%ebp),%eax
c010926b:	8b 00                	mov    (%eax),%eax
c010926d:	8d 48 04             	lea    0x4(%eax),%ecx
c0109270:	8b 55 08             	mov    0x8(%ebp),%edx
c0109273:	89 0a                	mov    %ecx,(%edx)
c0109275:	8b 00                	mov    (%eax),%eax
c0109277:	99                   	cltd   
    }
}
c0109278:	5d                   	pop    %ebp
c0109279:	c3                   	ret    

c010927a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010927a:	55                   	push   %ebp
c010927b:	89 e5                	mov    %esp,%ebp
c010927d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0109280:	8d 45 14             	lea    0x14(%ebp),%eax
c0109283:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109286:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109289:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010928d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109290:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109294:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109297:	89 44 24 04          	mov    %eax,0x4(%esp)
c010929b:	8b 45 08             	mov    0x8(%ebp),%eax
c010929e:	89 04 24             	mov    %eax,(%esp)
c01092a1:	e8 02 00 00 00       	call   c01092a8 <vprintfmt>
    va_end(ap);
}
c01092a6:	c9                   	leave  
c01092a7:	c3                   	ret    

c01092a8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01092a8:	55                   	push   %ebp
c01092a9:	89 e5                	mov    %esp,%ebp
c01092ab:	56                   	push   %esi
c01092ac:	53                   	push   %ebx
c01092ad:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01092b0:	eb 18                	jmp    c01092ca <vprintfmt+0x22>
            if (ch == '\0') {
c01092b2:	85 db                	test   %ebx,%ebx
c01092b4:	75 05                	jne    c01092bb <vprintfmt+0x13>
                return;
c01092b6:	e9 d1 03 00 00       	jmp    c010968c <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01092bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092c2:	89 1c 24             	mov    %ebx,(%esp)
c01092c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01092c8:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01092ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01092cd:	8d 50 01             	lea    0x1(%eax),%edx
c01092d0:	89 55 10             	mov    %edx,0x10(%ebp)
c01092d3:	0f b6 00             	movzbl (%eax),%eax
c01092d6:	0f b6 d8             	movzbl %al,%ebx
c01092d9:	83 fb 25             	cmp    $0x25,%ebx
c01092dc:	75 d4                	jne    c01092b2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01092de:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01092e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01092e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01092ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01092f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01092f9:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01092fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01092ff:	8d 50 01             	lea    0x1(%eax),%edx
c0109302:	89 55 10             	mov    %edx,0x10(%ebp)
c0109305:	0f b6 00             	movzbl (%eax),%eax
c0109308:	0f b6 d8             	movzbl %al,%ebx
c010930b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010930e:	83 f8 55             	cmp    $0x55,%eax
c0109311:	0f 87 44 03 00 00    	ja     c010965b <vprintfmt+0x3b3>
c0109317:	8b 04 85 e4 bd 10 c0 	mov    -0x3fef421c(,%eax,4),%eax
c010931e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109320:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109324:	eb d6                	jmp    c01092fc <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109326:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010932a:	eb d0                	jmp    c01092fc <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010932c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109333:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109336:	89 d0                	mov    %edx,%eax
c0109338:	c1 e0 02             	shl    $0x2,%eax
c010933b:	01 d0                	add    %edx,%eax
c010933d:	01 c0                	add    %eax,%eax
c010933f:	01 d8                	add    %ebx,%eax
c0109341:	83 e8 30             	sub    $0x30,%eax
c0109344:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109347:	8b 45 10             	mov    0x10(%ebp),%eax
c010934a:	0f b6 00             	movzbl (%eax),%eax
c010934d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109350:	83 fb 2f             	cmp    $0x2f,%ebx
c0109353:	7e 0b                	jle    c0109360 <vprintfmt+0xb8>
c0109355:	83 fb 39             	cmp    $0x39,%ebx
c0109358:	7f 06                	jg     c0109360 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010935a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010935e:	eb d3                	jmp    c0109333 <vprintfmt+0x8b>
            goto process_precision;
c0109360:	eb 33                	jmp    c0109395 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0109362:	8b 45 14             	mov    0x14(%ebp),%eax
c0109365:	8d 50 04             	lea    0x4(%eax),%edx
c0109368:	89 55 14             	mov    %edx,0x14(%ebp)
c010936b:	8b 00                	mov    (%eax),%eax
c010936d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109370:	eb 23                	jmp    c0109395 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0109372:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109376:	79 0c                	jns    c0109384 <vprintfmt+0xdc>
                width = 0;
c0109378:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010937f:	e9 78 ff ff ff       	jmp    c01092fc <vprintfmt+0x54>
c0109384:	e9 73 ff ff ff       	jmp    c01092fc <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109389:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109390:	e9 67 ff ff ff       	jmp    c01092fc <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0109395:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109399:	79 12                	jns    c01093ad <vprintfmt+0x105>
                width = precision, precision = -1;
c010939b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010939e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01093a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01093a8:	e9 4f ff ff ff       	jmp    c01092fc <vprintfmt+0x54>
c01093ad:	e9 4a ff ff ff       	jmp    c01092fc <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01093b2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01093b6:	e9 41 ff ff ff       	jmp    c01092fc <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01093bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01093be:	8d 50 04             	lea    0x4(%eax),%edx
c01093c1:	89 55 14             	mov    %edx,0x14(%ebp)
c01093c4:	8b 00                	mov    (%eax),%eax
c01093c6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01093c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01093cd:	89 04 24             	mov    %eax,(%esp)
c01093d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01093d3:	ff d0                	call   *%eax
            break;
c01093d5:	e9 ac 02 00 00       	jmp    c0109686 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01093da:	8b 45 14             	mov    0x14(%ebp),%eax
c01093dd:	8d 50 04             	lea    0x4(%eax),%edx
c01093e0:	89 55 14             	mov    %edx,0x14(%ebp)
c01093e3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01093e5:	85 db                	test   %ebx,%ebx
c01093e7:	79 02                	jns    c01093eb <vprintfmt+0x143>
                err = -err;
c01093e9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01093eb:	83 fb 06             	cmp    $0x6,%ebx
c01093ee:	7f 0b                	jg     c01093fb <vprintfmt+0x153>
c01093f0:	8b 34 9d a4 bd 10 c0 	mov    -0x3fef425c(,%ebx,4),%esi
c01093f7:	85 f6                	test   %esi,%esi
c01093f9:	75 23                	jne    c010941e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01093fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01093ff:	c7 44 24 08 d1 bd 10 	movl   $0xc010bdd1,0x8(%esp)
c0109406:	c0 
c0109407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010940a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010940e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109411:	89 04 24             	mov    %eax,(%esp)
c0109414:	e8 61 fe ff ff       	call   c010927a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109419:	e9 68 02 00 00       	jmp    c0109686 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010941e:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0109422:	c7 44 24 08 da bd 10 	movl   $0xc010bdda,0x8(%esp)
c0109429:	c0 
c010942a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010942d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109431:	8b 45 08             	mov    0x8(%ebp),%eax
c0109434:	89 04 24             	mov    %eax,(%esp)
c0109437:	e8 3e fe ff ff       	call   c010927a <printfmt>
            }
            break;
c010943c:	e9 45 02 00 00       	jmp    c0109686 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109441:	8b 45 14             	mov    0x14(%ebp),%eax
c0109444:	8d 50 04             	lea    0x4(%eax),%edx
c0109447:	89 55 14             	mov    %edx,0x14(%ebp)
c010944a:	8b 30                	mov    (%eax),%esi
c010944c:	85 f6                	test   %esi,%esi
c010944e:	75 05                	jne    c0109455 <vprintfmt+0x1ad>
                p = "(null)";
c0109450:	be dd bd 10 c0       	mov    $0xc010bddd,%esi
            }
            if (width > 0 && padc != '-') {
c0109455:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109459:	7e 3e                	jle    c0109499 <vprintfmt+0x1f1>
c010945b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010945f:	74 38                	je     c0109499 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109461:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0109464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109467:	89 44 24 04          	mov    %eax,0x4(%esp)
c010946b:	89 34 24             	mov    %esi,(%esp)
c010946e:	e8 ed 03 00 00       	call   c0109860 <strnlen>
c0109473:	29 c3                	sub    %eax,%ebx
c0109475:	89 d8                	mov    %ebx,%eax
c0109477:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010947a:	eb 17                	jmp    c0109493 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010947c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109480:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109483:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109487:	89 04 24             	mov    %eax,(%esp)
c010948a:	8b 45 08             	mov    0x8(%ebp),%eax
c010948d:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010948f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109493:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109497:	7f e3                	jg     c010947c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109499:	eb 38                	jmp    c01094d3 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010949b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010949f:	74 1f                	je     c01094c0 <vprintfmt+0x218>
c01094a1:	83 fb 1f             	cmp    $0x1f,%ebx
c01094a4:	7e 05                	jle    c01094ab <vprintfmt+0x203>
c01094a6:	83 fb 7e             	cmp    $0x7e,%ebx
c01094a9:	7e 15                	jle    c01094c0 <vprintfmt+0x218>
                    putch('?', putdat);
c01094ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094b2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01094b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01094bc:	ff d0                	call   *%eax
c01094be:	eb 0f                	jmp    c01094cf <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01094c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094c7:	89 1c 24             	mov    %ebx,(%esp)
c01094ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cd:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01094cf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01094d3:	89 f0                	mov    %esi,%eax
c01094d5:	8d 70 01             	lea    0x1(%eax),%esi
c01094d8:	0f b6 00             	movzbl (%eax),%eax
c01094db:	0f be d8             	movsbl %al,%ebx
c01094de:	85 db                	test   %ebx,%ebx
c01094e0:	74 10                	je     c01094f2 <vprintfmt+0x24a>
c01094e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01094e6:	78 b3                	js     c010949b <vprintfmt+0x1f3>
c01094e8:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01094ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01094f0:	79 a9                	jns    c010949b <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01094f2:	eb 17                	jmp    c010950b <vprintfmt+0x263>
                putch(' ', putdat);
c01094f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109502:	8b 45 08             	mov    0x8(%ebp),%eax
c0109505:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109507:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010950b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010950f:	7f e3                	jg     c01094f4 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0109511:	e9 70 01 00 00       	jmp    c0109686 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109516:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109519:	89 44 24 04          	mov    %eax,0x4(%esp)
c010951d:	8d 45 14             	lea    0x14(%ebp),%eax
c0109520:	89 04 24             	mov    %eax,(%esp)
c0109523:	e8 0b fd ff ff       	call   c0109233 <getint>
c0109528:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010952b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010952e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109531:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109534:	85 d2                	test   %edx,%edx
c0109536:	79 26                	jns    c010955e <vprintfmt+0x2b6>
                putch('-', putdat);
c0109538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010953b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010953f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109546:	8b 45 08             	mov    0x8(%ebp),%eax
c0109549:	ff d0                	call   *%eax
                num = -(long long)num;
c010954b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010954e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109551:	f7 d8                	neg    %eax
c0109553:	83 d2 00             	adc    $0x0,%edx
c0109556:	f7 da                	neg    %edx
c0109558:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010955b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010955e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109565:	e9 a8 00 00 00       	jmp    c0109612 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010956a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010956d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109571:	8d 45 14             	lea    0x14(%ebp),%eax
c0109574:	89 04 24             	mov    %eax,(%esp)
c0109577:	e8 68 fc ff ff       	call   c01091e4 <getuint>
c010957c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010957f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109582:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109589:	e9 84 00 00 00       	jmp    c0109612 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010958e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109591:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109595:	8d 45 14             	lea    0x14(%ebp),%eax
c0109598:	89 04 24             	mov    %eax,(%esp)
c010959b:	e8 44 fc ff ff       	call   c01091e4 <getuint>
c01095a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01095a6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01095ad:	eb 63                	jmp    c0109612 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01095af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01095bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c0:	ff d0                	call   *%eax
            putch('x', putdat);
c01095c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095c9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01095d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01095d3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01095d5:	8b 45 14             	mov    0x14(%ebp),%eax
c01095d8:	8d 50 04             	lea    0x4(%eax),%edx
c01095db:	89 55 14             	mov    %edx,0x14(%ebp)
c01095de:	8b 00                	mov    (%eax),%eax
c01095e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01095ea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01095f1:	eb 1f                	jmp    c0109612 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01095f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095fa:	8d 45 14             	lea    0x14(%ebp),%eax
c01095fd:	89 04 24             	mov    %eax,(%esp)
c0109600:	e8 df fb ff ff       	call   c01091e4 <getuint>
c0109605:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109608:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010960b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109612:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109616:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109619:	89 54 24 18          	mov    %edx,0x18(%esp)
c010961d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109620:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109624:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109628:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010962b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010962e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109632:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109636:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109639:	89 44 24 04          	mov    %eax,0x4(%esp)
c010963d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109640:	89 04 24             	mov    %eax,(%esp)
c0109643:	e8 97 fa ff ff       	call   c01090df <printnum>
            break;
c0109648:	eb 3c                	jmp    c0109686 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010964a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010964d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109651:	89 1c 24             	mov    %ebx,(%esp)
c0109654:	8b 45 08             	mov    0x8(%ebp),%eax
c0109657:	ff d0                	call   *%eax
            break;
c0109659:	eb 2b                	jmp    c0109686 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010965b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010965e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109662:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109669:	8b 45 08             	mov    0x8(%ebp),%eax
c010966c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010966e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109672:	eb 04                	jmp    c0109678 <vprintfmt+0x3d0>
c0109674:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109678:	8b 45 10             	mov    0x10(%ebp),%eax
c010967b:	83 e8 01             	sub    $0x1,%eax
c010967e:	0f b6 00             	movzbl (%eax),%eax
c0109681:	3c 25                	cmp    $0x25,%al
c0109683:	75 ef                	jne    c0109674 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0109685:	90                   	nop
        }
    }
c0109686:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109687:	e9 3e fc ff ff       	jmp    c01092ca <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010968c:	83 c4 40             	add    $0x40,%esp
c010968f:	5b                   	pop    %ebx
c0109690:	5e                   	pop    %esi
c0109691:	5d                   	pop    %ebp
c0109692:	c3                   	ret    

c0109693 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109693:	55                   	push   %ebp
c0109694:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109699:	8b 40 08             	mov    0x8(%eax),%eax
c010969c:	8d 50 01             	lea    0x1(%eax),%edx
c010969f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096a2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01096a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096a8:	8b 10                	mov    (%eax),%edx
c01096aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096ad:	8b 40 04             	mov    0x4(%eax),%eax
c01096b0:	39 c2                	cmp    %eax,%edx
c01096b2:	73 12                	jae    c01096c6 <sprintputch+0x33>
        *b->buf ++ = ch;
c01096b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096b7:	8b 00                	mov    (%eax),%eax
c01096b9:	8d 48 01             	lea    0x1(%eax),%ecx
c01096bc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01096bf:	89 0a                	mov    %ecx,(%edx)
c01096c1:	8b 55 08             	mov    0x8(%ebp),%edx
c01096c4:	88 10                	mov    %dl,(%eax)
    }
}
c01096c6:	5d                   	pop    %ebp
c01096c7:	c3                   	ret    

c01096c8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01096c8:	55                   	push   %ebp
c01096c9:	89 e5                	mov    %esp,%ebp
c01096cb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01096ce:	8d 45 14             	lea    0x14(%ebp),%eax
c01096d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01096d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01096db:	8b 45 10             	mov    0x10(%ebp),%eax
c01096de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ec:	89 04 24             	mov    %eax,(%esp)
c01096ef:	e8 08 00 00 00       	call   c01096fc <vsnprintf>
c01096f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01096f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096fa:	c9                   	leave  
c01096fb:	c3                   	ret    

c01096fc <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01096fc:	55                   	push   %ebp
c01096fd:	89 e5                	mov    %esp,%ebp
c01096ff:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109702:	8b 45 08             	mov    0x8(%ebp),%eax
c0109705:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010970b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010970e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109711:	01 d0                	add    %edx,%eax
c0109713:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010971d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109721:	74 0a                	je     c010972d <vsnprintf+0x31>
c0109723:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109726:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109729:	39 c2                	cmp    %eax,%edx
c010972b:	76 07                	jbe    c0109734 <vsnprintf+0x38>
        return -E_INVAL;
c010972d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109732:	eb 2a                	jmp    c010975e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109734:	8b 45 14             	mov    0x14(%ebp),%eax
c0109737:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010973b:	8b 45 10             	mov    0x10(%ebp),%eax
c010973e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109742:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109745:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109749:	c7 04 24 93 96 10 c0 	movl   $0xc0109693,(%esp)
c0109750:	e8 53 fb ff ff       	call   c01092a8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109755:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109758:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010975b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010975e:	c9                   	leave  
c010975f:	c3                   	ret    

c0109760 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109760:	55                   	push   %ebp
c0109761:	89 e5                	mov    %esp,%ebp
c0109763:	57                   	push   %edi
c0109764:	56                   	push   %esi
c0109765:	53                   	push   %ebx
c0109766:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109769:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c010976e:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c0109774:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010977a:	6b f0 05             	imul   $0x5,%eax,%esi
c010977d:	01 f7                	add    %esi,%edi
c010977f:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0109784:	f7 e6                	mul    %esi
c0109786:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109789:	89 f2                	mov    %esi,%edx
c010978b:	83 c0 0b             	add    $0xb,%eax
c010978e:	83 d2 00             	adc    $0x0,%edx
c0109791:	89 c7                	mov    %eax,%edi
c0109793:	83 e7 ff             	and    $0xffffffff,%edi
c0109796:	89 f9                	mov    %edi,%ecx
c0109798:	0f b7 da             	movzwl %dx,%ebx
c010979b:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c01097a1:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c01097a7:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01097ac:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01097b2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01097b6:	c1 ea 0c             	shr    $0xc,%edx
c01097b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01097bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01097bf:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01097c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01097c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01097cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01097cf:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01097d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01097d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01097dc:	74 1c                	je     c01097fa <rand+0x9a>
c01097de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097e1:	ba 00 00 00 00       	mov    $0x0,%edx
c01097e6:	f7 75 dc             	divl   -0x24(%ebp)
c01097e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01097ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097ef:	ba 00 00 00 00       	mov    $0x0,%edx
c01097f4:	f7 75 dc             	divl   -0x24(%ebp)
c01097f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01097fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01097fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109800:	f7 75 dc             	divl   -0x24(%ebp)
c0109803:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109806:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109809:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010980c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010980f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109812:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109818:	83 c4 24             	add    $0x24,%esp
c010981b:	5b                   	pop    %ebx
c010981c:	5e                   	pop    %esi
c010981d:	5f                   	pop    %edi
c010981e:	5d                   	pop    %ebp
c010981f:	c3                   	ret    

c0109820 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109820:	55                   	push   %ebp
c0109821:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109823:	8b 45 08             	mov    0x8(%ebp),%eax
c0109826:	ba 00 00 00 00       	mov    $0x0,%edx
c010982b:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c0109830:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c0109836:	5d                   	pop    %ebp
c0109837:	c3                   	ret    

c0109838 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109838:	55                   	push   %ebp
c0109839:	89 e5                	mov    %esp,%ebp
c010983b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010983e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109845:	eb 04                	jmp    c010984b <strlen+0x13>
        cnt ++;
c0109847:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010984b:	8b 45 08             	mov    0x8(%ebp),%eax
c010984e:	8d 50 01             	lea    0x1(%eax),%edx
c0109851:	89 55 08             	mov    %edx,0x8(%ebp)
c0109854:	0f b6 00             	movzbl (%eax),%eax
c0109857:	84 c0                	test   %al,%al
c0109859:	75 ec                	jne    c0109847 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010985b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010985e:	c9                   	leave  
c010985f:	c3                   	ret    

c0109860 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109860:	55                   	push   %ebp
c0109861:	89 e5                	mov    %esp,%ebp
c0109863:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109866:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010986d:	eb 04                	jmp    c0109873 <strnlen+0x13>
        cnt ++;
c010986f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0109873:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109876:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109879:	73 10                	jae    c010988b <strnlen+0x2b>
c010987b:	8b 45 08             	mov    0x8(%ebp),%eax
c010987e:	8d 50 01             	lea    0x1(%eax),%edx
c0109881:	89 55 08             	mov    %edx,0x8(%ebp)
c0109884:	0f b6 00             	movzbl (%eax),%eax
c0109887:	84 c0                	test   %al,%al
c0109889:	75 e4                	jne    c010986f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010988b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010988e:	c9                   	leave  
c010988f:	c3                   	ret    

c0109890 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109890:	55                   	push   %ebp
c0109891:	89 e5                	mov    %esp,%ebp
c0109893:	57                   	push   %edi
c0109894:	56                   	push   %esi
c0109895:	83 ec 20             	sub    $0x20,%esp
c0109898:	8b 45 08             	mov    0x8(%ebp),%eax
c010989b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010989e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01098a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01098a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098aa:	89 d1                	mov    %edx,%ecx
c01098ac:	89 c2                	mov    %eax,%edx
c01098ae:	89 ce                	mov    %ecx,%esi
c01098b0:	89 d7                	mov    %edx,%edi
c01098b2:	ac                   	lods   %ds:(%esi),%al
c01098b3:	aa                   	stos   %al,%es:(%edi)
c01098b4:	84 c0                	test   %al,%al
c01098b6:	75 fa                	jne    c01098b2 <strcpy+0x22>
c01098b8:	89 fa                	mov    %edi,%edx
c01098ba:	89 f1                	mov    %esi,%ecx
c01098bc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01098bf:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01098c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01098c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01098c8:	83 c4 20             	add    $0x20,%esp
c01098cb:	5e                   	pop    %esi
c01098cc:	5f                   	pop    %edi
c01098cd:	5d                   	pop    %ebp
c01098ce:	c3                   	ret    

c01098cf <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01098cf:	55                   	push   %ebp
c01098d0:	89 e5                	mov    %esp,%ebp
c01098d2:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01098d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01098d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01098db:	eb 21                	jmp    c01098fe <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01098dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098e0:	0f b6 10             	movzbl (%eax),%edx
c01098e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098e6:	88 10                	mov    %dl,(%eax)
c01098e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098eb:	0f b6 00             	movzbl (%eax),%eax
c01098ee:	84 c0                	test   %al,%al
c01098f0:	74 04                	je     c01098f6 <strncpy+0x27>
            src ++;
c01098f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01098f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01098fa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01098fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109902:	75 d9                	jne    c01098dd <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109904:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109907:	c9                   	leave  
c0109908:	c3                   	ret    

c0109909 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109909:	55                   	push   %ebp
c010990a:	89 e5                	mov    %esp,%ebp
c010990c:	57                   	push   %edi
c010990d:	56                   	push   %esi
c010990e:	83 ec 20             	sub    $0x20,%esp
c0109911:	8b 45 08             	mov    0x8(%ebp),%eax
c0109914:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109917:	8b 45 0c             	mov    0xc(%ebp),%eax
c010991a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010991d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109920:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109923:	89 d1                	mov    %edx,%ecx
c0109925:	89 c2                	mov    %eax,%edx
c0109927:	89 ce                	mov    %ecx,%esi
c0109929:	89 d7                	mov    %edx,%edi
c010992b:	ac                   	lods   %ds:(%esi),%al
c010992c:	ae                   	scas   %es:(%edi),%al
c010992d:	75 08                	jne    c0109937 <strcmp+0x2e>
c010992f:	84 c0                	test   %al,%al
c0109931:	75 f8                	jne    c010992b <strcmp+0x22>
c0109933:	31 c0                	xor    %eax,%eax
c0109935:	eb 04                	jmp    c010993b <strcmp+0x32>
c0109937:	19 c0                	sbb    %eax,%eax
c0109939:	0c 01                	or     $0x1,%al
c010993b:	89 fa                	mov    %edi,%edx
c010993d:	89 f1                	mov    %esi,%ecx
c010993f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109942:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109945:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109948:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010994b:	83 c4 20             	add    $0x20,%esp
c010994e:	5e                   	pop    %esi
c010994f:	5f                   	pop    %edi
c0109950:	5d                   	pop    %ebp
c0109951:	c3                   	ret    

c0109952 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109952:	55                   	push   %ebp
c0109953:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109955:	eb 0c                	jmp    c0109963 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109957:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010995b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010995f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109963:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109967:	74 1a                	je     c0109983 <strncmp+0x31>
c0109969:	8b 45 08             	mov    0x8(%ebp),%eax
c010996c:	0f b6 00             	movzbl (%eax),%eax
c010996f:	84 c0                	test   %al,%al
c0109971:	74 10                	je     c0109983 <strncmp+0x31>
c0109973:	8b 45 08             	mov    0x8(%ebp),%eax
c0109976:	0f b6 10             	movzbl (%eax),%edx
c0109979:	8b 45 0c             	mov    0xc(%ebp),%eax
c010997c:	0f b6 00             	movzbl (%eax),%eax
c010997f:	38 c2                	cmp    %al,%dl
c0109981:	74 d4                	je     c0109957 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109983:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109987:	74 18                	je     c01099a1 <strncmp+0x4f>
c0109989:	8b 45 08             	mov    0x8(%ebp),%eax
c010998c:	0f b6 00             	movzbl (%eax),%eax
c010998f:	0f b6 d0             	movzbl %al,%edx
c0109992:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109995:	0f b6 00             	movzbl (%eax),%eax
c0109998:	0f b6 c0             	movzbl %al,%eax
c010999b:	29 c2                	sub    %eax,%edx
c010999d:	89 d0                	mov    %edx,%eax
c010999f:	eb 05                	jmp    c01099a6 <strncmp+0x54>
c01099a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01099a6:	5d                   	pop    %ebp
c01099a7:	c3                   	ret    

c01099a8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01099a8:	55                   	push   %ebp
c01099a9:	89 e5                	mov    %esp,%ebp
c01099ab:	83 ec 04             	sub    $0x4,%esp
c01099ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099b1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01099b4:	eb 14                	jmp    c01099ca <strchr+0x22>
        if (*s == c) {
c01099b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b9:	0f b6 00             	movzbl (%eax),%eax
c01099bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01099bf:	75 05                	jne    c01099c6 <strchr+0x1e>
            return (char *)s;
c01099c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c4:	eb 13                	jmp    c01099d9 <strchr+0x31>
        }
        s ++;
c01099c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01099ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01099cd:	0f b6 00             	movzbl (%eax),%eax
c01099d0:	84 c0                	test   %al,%al
c01099d2:	75 e2                	jne    c01099b6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01099d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01099d9:	c9                   	leave  
c01099da:	c3                   	ret    

c01099db <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01099db:	55                   	push   %ebp
c01099dc:	89 e5                	mov    %esp,%ebp
c01099de:	83 ec 04             	sub    $0x4,%esp
c01099e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099e4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01099e7:	eb 11                	jmp    c01099fa <strfind+0x1f>
        if (*s == c) {
c01099e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01099ec:	0f b6 00             	movzbl (%eax),%eax
c01099ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01099f2:	75 02                	jne    c01099f6 <strfind+0x1b>
            break;
c01099f4:	eb 0e                	jmp    c0109a04 <strfind+0x29>
        }
        s ++;
c01099f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01099fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01099fd:	0f b6 00             	movzbl (%eax),%eax
c0109a00:	84 c0                	test   %al,%al
c0109a02:	75 e5                	jne    c01099e9 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0109a04:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109a07:	c9                   	leave  
c0109a08:	c3                   	ret    

c0109a09 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109a09:	55                   	push   %ebp
c0109a0a:	89 e5                	mov    %esp,%ebp
c0109a0c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109a16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109a1d:	eb 04                	jmp    c0109a23 <strtol+0x1a>
        s ++;
c0109a1f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a26:	0f b6 00             	movzbl (%eax),%eax
c0109a29:	3c 20                	cmp    $0x20,%al
c0109a2b:	74 f2                	je     c0109a1f <strtol+0x16>
c0109a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a30:	0f b6 00             	movzbl (%eax),%eax
c0109a33:	3c 09                	cmp    $0x9,%al
c0109a35:	74 e8                	je     c0109a1f <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a3a:	0f b6 00             	movzbl (%eax),%eax
c0109a3d:	3c 2b                	cmp    $0x2b,%al
c0109a3f:	75 06                	jne    c0109a47 <strtol+0x3e>
        s ++;
c0109a41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a45:	eb 15                	jmp    c0109a5c <strtol+0x53>
    }
    else if (*s == '-') {
c0109a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a4a:	0f b6 00             	movzbl (%eax),%eax
c0109a4d:	3c 2d                	cmp    $0x2d,%al
c0109a4f:	75 0b                	jne    c0109a5c <strtol+0x53>
        s ++, neg = 1;
c0109a51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a55:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109a5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a60:	74 06                	je     c0109a68 <strtol+0x5f>
c0109a62:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109a66:	75 24                	jne    c0109a8c <strtol+0x83>
c0109a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a6b:	0f b6 00             	movzbl (%eax),%eax
c0109a6e:	3c 30                	cmp    $0x30,%al
c0109a70:	75 1a                	jne    c0109a8c <strtol+0x83>
c0109a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a75:	83 c0 01             	add    $0x1,%eax
c0109a78:	0f b6 00             	movzbl (%eax),%eax
c0109a7b:	3c 78                	cmp    $0x78,%al
c0109a7d:	75 0d                	jne    c0109a8c <strtol+0x83>
        s += 2, base = 16;
c0109a7f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109a83:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109a8a:	eb 2a                	jmp    c0109ab6 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109a8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a90:	75 17                	jne    c0109aa9 <strtol+0xa0>
c0109a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a95:	0f b6 00             	movzbl (%eax),%eax
c0109a98:	3c 30                	cmp    $0x30,%al
c0109a9a:	75 0d                	jne    c0109aa9 <strtol+0xa0>
        s ++, base = 8;
c0109a9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109aa0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109aa7:	eb 0d                	jmp    c0109ab6 <strtol+0xad>
    }
    else if (base == 0) {
c0109aa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109aad:	75 07                	jne    c0109ab6 <strtol+0xad>
        base = 10;
c0109aaf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ab9:	0f b6 00             	movzbl (%eax),%eax
c0109abc:	3c 2f                	cmp    $0x2f,%al
c0109abe:	7e 1b                	jle    c0109adb <strtol+0xd2>
c0109ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ac3:	0f b6 00             	movzbl (%eax),%eax
c0109ac6:	3c 39                	cmp    $0x39,%al
c0109ac8:	7f 11                	jg     c0109adb <strtol+0xd2>
            dig = *s - '0';
c0109aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0109acd:	0f b6 00             	movzbl (%eax),%eax
c0109ad0:	0f be c0             	movsbl %al,%eax
c0109ad3:	83 e8 30             	sub    $0x30,%eax
c0109ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109ad9:	eb 48                	jmp    c0109b23 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ade:	0f b6 00             	movzbl (%eax),%eax
c0109ae1:	3c 60                	cmp    $0x60,%al
c0109ae3:	7e 1b                	jle    c0109b00 <strtol+0xf7>
c0109ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae8:	0f b6 00             	movzbl (%eax),%eax
c0109aeb:	3c 7a                	cmp    $0x7a,%al
c0109aed:	7f 11                	jg     c0109b00 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0109af2:	0f b6 00             	movzbl (%eax),%eax
c0109af5:	0f be c0             	movsbl %al,%eax
c0109af8:	83 e8 57             	sub    $0x57,%eax
c0109afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109afe:	eb 23                	jmp    c0109b23 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b03:	0f b6 00             	movzbl (%eax),%eax
c0109b06:	3c 40                	cmp    $0x40,%al
c0109b08:	7e 3d                	jle    c0109b47 <strtol+0x13e>
c0109b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b0d:	0f b6 00             	movzbl (%eax),%eax
c0109b10:	3c 5a                	cmp    $0x5a,%al
c0109b12:	7f 33                	jg     c0109b47 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b17:	0f b6 00             	movzbl (%eax),%eax
c0109b1a:	0f be c0             	movsbl %al,%eax
c0109b1d:	83 e8 37             	sub    $0x37,%eax
c0109b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b26:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109b29:	7c 02                	jl     c0109b2d <strtol+0x124>
            break;
c0109b2b:	eb 1a                	jmp    c0109b47 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109b2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109b34:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109b38:	89 c2                	mov    %eax,%edx
c0109b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b3d:	01 d0                	add    %edx,%eax
c0109b3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109b42:	e9 6f ff ff ff       	jmp    c0109ab6 <strtol+0xad>

    if (endptr) {
c0109b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109b4b:	74 08                	je     c0109b55 <strtol+0x14c>
        *endptr = (char *) s;
c0109b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b50:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b53:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109b55:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109b59:	74 07                	je     c0109b62 <strtol+0x159>
c0109b5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109b5e:	f7 d8                	neg    %eax
c0109b60:	eb 03                	jmp    c0109b65 <strtol+0x15c>
c0109b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109b65:	c9                   	leave  
c0109b66:	c3                   	ret    

c0109b67 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109b67:	55                   	push   %ebp
c0109b68:	89 e5                	mov    %esp,%ebp
c0109b6a:	57                   	push   %edi
c0109b6b:	83 ec 24             	sub    $0x24,%esp
c0109b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b71:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109b74:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109b78:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b7b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109b7e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109b81:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109b87:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109b8a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109b8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109b91:	89 d7                	mov    %edx,%edi
c0109b93:	f3 aa                	rep stos %al,%es:(%edi)
c0109b95:	89 fa                	mov    %edi,%edx
c0109b97:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109b9a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109b9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109ba0:	83 c4 24             	add    $0x24,%esp
c0109ba3:	5f                   	pop    %edi
c0109ba4:	5d                   	pop    %ebp
c0109ba5:	c3                   	ret    

c0109ba6 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109ba6:	55                   	push   %ebp
c0109ba7:	89 e5                	mov    %esp,%ebp
c0109ba9:	57                   	push   %edi
c0109baa:	56                   	push   %esi
c0109bab:	53                   	push   %ebx
c0109bac:	83 ec 30             	sub    $0x30,%esp
c0109baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109bbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bc4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109bc7:	73 42                	jae    c0109c0b <memmove+0x65>
c0109bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109bdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109bde:	c1 e8 02             	shr    $0x2,%eax
c0109be1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109be3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109be9:	89 d7                	mov    %edx,%edi
c0109beb:	89 c6                	mov    %eax,%esi
c0109bed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109bef:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109bf2:	83 e1 03             	and    $0x3,%ecx
c0109bf5:	74 02                	je     c0109bf9 <memmove+0x53>
c0109bf7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109bf9:	89 f0                	mov    %esi,%eax
c0109bfb:	89 fa                	mov    %edi,%edx
c0109bfd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109c00:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109c03:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109c09:	eb 36                	jmp    c0109c41 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c0e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c14:	01 c2                	add    %eax,%edx
c0109c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c19:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c1f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c25:	89 c1                	mov    %eax,%ecx
c0109c27:	89 d8                	mov    %ebx,%eax
c0109c29:	89 d6                	mov    %edx,%esi
c0109c2b:	89 c7                	mov    %eax,%edi
c0109c2d:	fd                   	std    
c0109c2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c30:	fc                   	cld    
c0109c31:	89 f8                	mov    %edi,%eax
c0109c33:	89 f2                	mov    %esi,%edx
c0109c35:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109c38:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109c3b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109c41:	83 c4 30             	add    $0x30,%esp
c0109c44:	5b                   	pop    %ebx
c0109c45:	5e                   	pop    %esi
c0109c46:	5f                   	pop    %edi
c0109c47:	5d                   	pop    %ebp
c0109c48:	c3                   	ret    

c0109c49 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109c49:	55                   	push   %ebp
c0109c4a:	89 e5                	mov    %esp,%ebp
c0109c4c:	57                   	push   %edi
c0109c4d:	56                   	push   %esi
c0109c4e:	83 ec 20             	sub    $0x20,%esp
c0109c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109c57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c66:	c1 e8 02             	shr    $0x2,%eax
c0109c69:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c71:	89 d7                	mov    %edx,%edi
c0109c73:	89 c6                	mov    %eax,%esi
c0109c75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c77:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109c7a:	83 e1 03             	and    $0x3,%ecx
c0109c7d:	74 02                	je     c0109c81 <memcpy+0x38>
c0109c7f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c81:	89 f0                	mov    %esi,%eax
c0109c83:	89 fa                	mov    %edi,%edx
c0109c85:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109c88:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109c8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109c91:	83 c4 20             	add    $0x20,%esp
c0109c94:	5e                   	pop    %esi
c0109c95:	5f                   	pop    %edi
c0109c96:	5d                   	pop    %ebp
c0109c97:	c3                   	ret    

c0109c98 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109c98:	55                   	push   %ebp
c0109c99:	89 e5                	mov    %esp,%ebp
c0109c9b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ca7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109caa:	eb 30                	jmp    c0109cdc <memcmp+0x44>
        if (*s1 != *s2) {
c0109cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109caf:	0f b6 10             	movzbl (%eax),%edx
c0109cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109cb5:	0f b6 00             	movzbl (%eax),%eax
c0109cb8:	38 c2                	cmp    %al,%dl
c0109cba:	74 18                	je     c0109cd4 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109cbf:	0f b6 00             	movzbl (%eax),%eax
c0109cc2:	0f b6 d0             	movzbl %al,%edx
c0109cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109cc8:	0f b6 00             	movzbl (%eax),%eax
c0109ccb:	0f b6 c0             	movzbl %al,%eax
c0109cce:	29 c2                	sub    %eax,%edx
c0109cd0:	89 d0                	mov    %edx,%eax
c0109cd2:	eb 1a                	jmp    c0109cee <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109cd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109cd8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109cdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0109cdf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109ce2:	89 55 10             	mov    %edx,0x10(%ebp)
c0109ce5:	85 c0                	test   %eax,%eax
c0109ce7:	75 c3                	jne    c0109cac <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109cee:	c9                   	leave  
c0109cef:	c3                   	ret    
