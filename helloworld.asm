; helloworld.asm

    section .data
message: db 'Hello, World!', 0
message_length equ $-message

    section .text
    global main
    extern  GetStdHandle
    extern  WriteFile
    extern  ExitProcess

main:
    sub  rsp, 28h  

    ; hStdOut = GetstdHandle(STD_OUTPUT_HANDLE)
    mov     rcx, -11
    call    GetStdHandle

    ; WriteFile(hstdOut, message, length(message), &bytes, 0);
    mov     rcx, rax
    mov     rdx, message
    mov     r8, message_length
    mov     r9, 0
    push    0
    call    WriteFile

    ; ExitProcess(0)
    mov     rcx, rax
    call    ExitProcess
