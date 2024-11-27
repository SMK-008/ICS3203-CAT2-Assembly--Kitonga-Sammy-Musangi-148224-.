section .data
    array db 5, 10, 15, 20, 25    
    n equ 5                       
    newline db 0Ah, 0             

section .bss
    temp resb 1                   

section .text
    global _start

_start:
    ; Initialize pointers for the array
    lea rsi, [array]              
    lea rdi, [array + n - 1]      

reverse_loop:
    cmp rsi, rdi                  
    jge reverse_done              

    ; Swap elements at rsi and rdi
    mov al, [rsi]                 
    mov bl, [rdi]                 
    mov [rsi], bl                 
    mov [rdi], al                 

    ; Move the pointers
    inc rsi                       
    dec rdi                       
    jmp reverse_loop              

reverse_done:
    ; Print the reversed array (optional, for validation)
    lea rsi, [array]              
    mov rcx, n                    

print_loop:
    cmp rcx, 0                    
    jz exit                       

    movzx rax, byte [rsi]         
    add rax, '0'                  
    mov [temp], al                
    mov rdi, 1                    
    lea rsi, [temp]               
    mov rdx, 1                    
    mov rax, 1                    
    syscall

    ; Print a space (except after the last element)
    dec rcx                       
    cmp rcx, 0                    
    jz print_done                 

    lea rsi, [newline]            
    mov rdi, 1                    
    mov rdx, 1                    
    mov rax, 1                    
    syscall

print_done:
    inc rsi                       
    jmp print_loop                

exit:
    mov rax, 60                   
    xor rdi, rdi                  
    syscall
