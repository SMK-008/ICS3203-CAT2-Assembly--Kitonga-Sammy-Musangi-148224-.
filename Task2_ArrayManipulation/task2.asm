section .data
    array db 10, 20, 30, 40, 50  
    size dq 5                    
    msg db "Reversed Array: ", 0 
    msg_len equ $ - msg          
    space db ' '                 

section .bss
    buffer resb 5                

section .text
    global _start

_start:
    ; Reversing the array
    mov rsi, array               
    mov rcx, [size]              

    xor rdi, rdi                 
    dec rcx                      

reverse_loop:
    cmp rdi, rcx                 
    jge print_result             

    mov al, [rsi + rdi]          
    mov bl, [rsi + rcx]          

    mov [rsi + rdi], bl          
    mov [rsi + rcx], al

    inc rdi                      
    dec rcx                      
    jmp reverse_loop             

print_result:
    ; Print the message "Reversed Array: "
    mov rax, 1                   
    mov rdi, 1                   
    mov rsi, msg                 
    mov rdx, msg_len             
    syscall

    ; Print each element of the reversed array
    mov rbx, array               
    mov rcx, [size]              
    xor rdi, rdi                 

print_loop:
    cmp rdi, rcx                 
    jge exit_program             

    movzx rax, byte [rbx + rdi]  

    ; Convert number in rax to ASCII string
    mov rsi, buffer              
    call int_to_ascii

    ; Print the number
    mov rax, 1                   
    mov rdi, 1                   
    mov rsi, buffer              
    mov rdx, rbx                 
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
    mov rax, 60                  
    xor rdi, rdi                 
    syscall

; Subroutine: Convert integer in rax to ASCII string in rsi
; Result: Null-terminated string in buffer at rsi
; rbx = length of resulting ASCII string
int_to_ascii:
    xor rbx, rbx                 
    xor rcx, rcx                 
int_to_ascii_loop:
    xor rdx, rdx                 
    mov r8, 10                   
    div r8                       
    add dl, '0'                  
    mov [rsi + rbx], dl          
    inc rbx                      
    test rax, rax                
    jnz int_to_ascii_loop        

    ; Reverse the string in-place
    mov rcx, rbx                 
    dec rcx                      
    xor rdi, rdi                 
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
