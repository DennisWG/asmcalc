bits 64
default rel

segment .data
    msg db "Hello world!", 0xd, 0xa, 0
    fmt db "Factorial is: %d", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess

extern printf
extern factorial

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 0+32

    lea     rcx, [msg]
    call    printf

    ; int result = factorial(5);
    mov     rcx, 5
    call    factorial

    ; printf("factorial is %d\n", result);
    lea     rcx, [fmt]
    mov     rdx, rax
    call    printf

    xor     rax, rax
    call    ExitProcess
