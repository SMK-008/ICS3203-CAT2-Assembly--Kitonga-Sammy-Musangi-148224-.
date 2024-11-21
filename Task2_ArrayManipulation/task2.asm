section .data
    array db 10, 20, 30, 40, 50  ; Original array
    array_len db 5               ; Number of elements
    newline db 10                ; Newline character

section .text
    global _start

_start:
    ; Load the array length correctly
    movzx ecx, byte [array_len]  ; Load array_len into ecx (zero-extend)
    lea esi, [array]             ; Pointer to start of the array
    lea edi, [array + ecx - 1]   ; Pointer to end of the array
    shr ecx, 1                   ; Divide length by 2 for loop count

reverse_loop:
    mov al, [esi]                ; Load the value at the start
    mov bl, [edi]                ; Load the value at the end
    mov [esi], bl                ; Swap values
    mov [edi], al                ; Swap values
    inc esi                      ; Increment start pointer
    dec edi                      ; Decrement end pointer
    loop reverse_loop            ; Repeat until midpoint reached

    ; Print the reversed array
    movzx ecx, byte [array_len]  ; Reload array length into ecx
    lea esi, [array]             ; Reset pointer to start of the array

print_loop:
    mov al, [esi]                ; Load the current array element
    add al, '0'                  ; Convert it to an ASCII character
    mov [esi], al                ; Store back in array (for display purposes)
    inc esi                      ; Move to the next array element
    loop print_loop              ; Repeat for all elements

    ; Write array to stdout
    lea ecx, [array]             ; Pointer to the start of the array
    mov edx, byte [array_len]    ; Number of bytes to write
    mov eax, 4                   ; syscall: write
    mov ebx, 1                   ; stdout
    int 0x80                     ; System call

    ; Write newline
    lea ecx, [newline]           ; Pointer to the newline character
    mov edx, 1                   ; Write 1 byte
    mov eax, 4                   ; syscall: write
    mov ebx, 1                   ; stdout
    int 0x80                     ; System call

exit_program:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
