section .data
    prompt db "Enter a number (e.g., -5, 0, 10): ", 0
    positive_msg db "POSITIVE", 0
    negative_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    number resb 4

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4             ; syscall: write
    mov ebx, 1             ; stdout
    lea ecx, [prompt]
    mov edx, 32
    int 0x80

    ; Read user input
    mov eax, 3             ; syscall: read
    mov ebx, 0             ; stdin
    lea ecx, [number]
    mov edx, 4
    int 0x80

    ; Convert input (assumes number is entered correctly)
    mov esi, number        ; Point to the input string
    xor eax, eax           ; Clear EAX (to accumulate result)
    xor ebx, ebx           ; Clear EBX (to track negativity)

    ; Check for negative sign
    cmp byte [esi], '-'
    jne parse_digits       ; If not '-', jump to digit parsing
    inc esi                ; Move to next character
    mov bl, 1              ; Mark number as negative

parse_digits:
    xor ecx, ecx           ; Clear ECX (temporary storage)
parse_loop:
    mov cl, byte [esi]     ; Load the current character
    cmp cl, 0              ; Check for null terminator
    je finalize_conversion ; End of string
    sub cl, 48             ; Convert ASCII to integer
    imul eax, eax, 10      ; Multiply EAX by 10 (shift left)
    add eax, ecx           ; Add current digit to EAX
    inc esi                ; Move to next character
    jmp parse_loop         ; Repeat

finalize_conversion:
    cmp bl, 0              ; Check if the number was negative
    je classification
    neg eax                ; Negate EAX to make it negative

classification:
    ; Classify the number
    cmp eax, 0
    je zero_case           ; If EAX == 0, jump to zero_case
    jl negative_case       ; If EAX < 0, jump to negative_case
    jmp positive_case      ; If EAX > 0, jump to positive_case

zero_case:
    ; Display "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 4
    int 0x80
    jmp program_end

negative_case:
    ; Display "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, negative_msg
    mov edx, 8
    int 0x80
    jmp program_end

positive_case:
    ; Display "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, positive_msg
    mov edx, 8
    int 0x80

program_end:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
