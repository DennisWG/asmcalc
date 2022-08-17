bits 64
default rel

segment .data
    msg db "Hello world!", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess

extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 0+32

    lea     rcx, [msg]
    call    printf

    xor     rax, rax
    call    ExitProcess