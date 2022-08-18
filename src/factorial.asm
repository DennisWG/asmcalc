default rel                 ; rip-relative addressing mode
bits 64                     ; enable x64 mode

segment .data               ; data starts here!

segment .text               ; Code starts here!

                            ; export main
global factorial

; factorial(int n) -> int
factorial:                  ; our entry point
    push    rbp
    mov     rbp, rsp
    sub     rsp, 0+32       ; set-up the stack. we use 0 bits for our variables and reserve 32 bits for the debugger's shadow space

    mov rax, 1              ; result (int result = 1)

    test rcx, rcx           ; if(n == 1) return 1
    jz .exit

    mov rbx, 1              ; counter i (int i = 1)
    inc rcx

.for_loop:
    cmp rbx, rcx
    je .exit

    mul rbx                 ; rax = rbx * rax

    inc rbx                 ; ++i
    jmp .for_loop

.exit:
    ; leave
    mov rsp, rbp            ; we're done here! unwind the stack
    pop rbp
    ret                     ; bye bye
