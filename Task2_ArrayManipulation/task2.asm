section .data
    array db 10, 20, 30, 40, 50  ; Example array
    size dq 5                    ; Number of elements in the array
    msg db "Reversed Array: ", 0 ; Output message
    msg_len equ $ - msg          ; Length of the message
    space db ' '                 ; Space character for formatting

section .bss
    buffer resb 5                ; Buffer for converting numbers (max 4 digits + null terminator)

section .text
    global _start

_start:
    ; Reversing the array
    mov rsi, array               ; rsi points to the start of the array
    mov rcx, [size]              ; rcx = size of the array (number of elements)

    xor rdi, rdi                 ; rdi = 0, index for the first element
    dec rcx                      ; rcx = index of the last element

reverse_loop:
    cmp rdi, rcx                 ; Check if indices have crossed
    jge print_result             ; If rdi >= rcx, jump to print the array

    mov al, [rsi + rdi]          ; Load element at rdi into al
    mov bl, [rsi + rcx]          ; Load element at rcx into bl

    mov [rsi + rdi], bl          ; Swap values
    mov [rsi + rcx], al

    inc rdi                      ; Move to the next element
    dec rcx                      ; Move to the previous element
    jmp reverse_loop             ; Repeat

print_result:
    ; Print the message "Reversed Array: "
    mov rax, 1                   ; syscall: write
    mov rdi, 1                   ; file descriptor: stdout
    mov rsi, msg                 ; Address of the message
    mov rdx, msg_len             ; Length of the message
    syscall

    ; Print each element of the reversed array
    mov rbx, array               ; Base address of the array
    mov rcx, [size]              ; Size of the array
    xor rdi, rdi                 ; Index counter

print_loop:
    cmp rdi, rcx                 ; Check if we've printed all elements
    jge exit_program             ; If all elements are printed, exit

    movzx rax, byte [rbx + rdi]  ; Load the value into rax (zero-extended)

    ; Convert number in rax to ASCII string
    mov rsi, buffer              ; Buffer to store ASCII string
    call int_to_ascii

    ; Print the number
    mov rax, 1                   ; syscall: write
    mov rdi, 1                   ; file descriptor: stdout
    mov rsi, buffer              ; Address of the buffer
    mov rdx, rbx                 ; Length of the ASCII string
    syscall

    ; Add a space after the number
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    ; Move to the next element
    inc rdi
    jmp print_loop

exit_program:
    ; Exit program
    mov rax, 60                  ; syscall: exit
    xor rdi, rdi                 ; status: 0
    syscall

; Subroutine: Convert integer in rax to ASCII string in rsi
; Result: Null-terminated string in buffer at rsi
; rbx = length of resulting ASCII string
int_to_ascii:
    xor rbx, rbx                 ; Reset length counter
    xor rcx, rcx                 ; Reset remainder
int_to_ascii_loop:
    xor rdx, rdx                 ; Clear rdx for division
    mov r8, 10                   ; Divisor
    div r8                       ; Divide rax by 10, quotient in rax, remainder in rdx
    add dl, '0'                  ; Convert remainder to ASCII
    mov [rsi + rbx], dl          ; Store ASCII character in buffer
    inc rbx                      ; Increment length
    test rax, rax                ; Check if quotient is 0
    jnz int_to_ascii_loop        ; Repeat until all digits are processed

    ; Reverse the string in-place
    mov rcx, rbx                 ; rcx = length of string
    dec rcx                      ; Index of last character
    xor rdi, rdi                 ; Index of first character
reverse_ascii:
    cmp rdi, rcx                 
    jge int_to_ascii_done        
    mov al, [rsi + rdi]          
    mov bl, [rsi + rcx]
    mov [rsi + rdi], bl
    mov [rsi + rcx], al
    inc rdi
    dec rcx
    jmp reverse_ascii
int_to_ascii_done:
    mov byte [rsi + rbx], 0      
    ret
