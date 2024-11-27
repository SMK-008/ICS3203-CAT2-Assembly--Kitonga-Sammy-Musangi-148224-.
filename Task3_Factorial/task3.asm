section .data
    prompt db "Enter a number to calculate its factorial: ", 0
    prompt_len equ $ - prompt   ; Calculates length of prompt string dynamically
    result db "The factorial is: ", 0
    result_len equ $ - result   ; Calculates length of result string dynamically
    newline db 10, 0            


section .bss
    number resb 4     
    factorial resb 4 

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4                 
    mov ebx, 1                 
    mov ecx, prompt            
    mov edx, prompt_len        
    int 0x80                   

    ; Read user input
    mov eax, 3             
    mov ebx, 0             
    mov ecx, number        
    mov edx, 4             
    int 0x80               

    ; Convert input (ASCII to integer)
    mov eax, 0             
    mov esi, number        
convert_input:
    movzx ecx, byte [esi]  
    cmp ecx, 10            
    je input_done          
    sub ecx, '0'           
    imul eax, eax, 10      
    add eax, ecx           
    inc esi                
    jmp convert_input
input_done:

    ; Call factorial subroutine
    push eax               
    call factorial_calc    
    add esp, 4             

    ; Store result in `factorial`
    mov [factorial], eax

    ; Output result message
    mov eax, 4             
    mov ebx, 1             
    mov ecx, result        
    mov edx, 20            
    int 0x80               

    ; Print the factorial result (integer to string conversion)
    mov eax, [factorial]   
    call print_number

    ; Print newline
    mov eax, 4             
    mov ebx, 1             
    mov ecx, newline       
    mov edx, 1             
    int 0x80

    ; Exit program
    mov eax, 1             
    xor ebx, ebx           
    int 0x80

; Subroutine: Factorial Calculation
factorial_calc:
    push ebp               
    mov ebp, esp           
    mov ecx, [ebp+8]       
    mov eax, 1             

factorial_loop:
    cmp ecx, 1             
    jle factorial_done
    imul eax, ecx          
    dec ecx                
    jmp factorial_loop

factorial_done:
    pop ebp                
    ret


print_number:
    push ebp               
    mov ebp, esp           

    mov ecx, 10            
    mov esi, esp           
print_loop:
    xor edx, edx           
    div ecx                
    add dl, '0'          
    dec esi                
    mov [esi], dl          
    test eax, eax         
    jnz print_loop         

print_done:
    mov edx, esp         
    sub edx, esi          
    mov ecx, esi          
    mov ebx, 1            
    mov eax, 4           
    int 0x80             
    mov esp, ebp           
    pop ebp                
    ret
