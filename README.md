# ICS3203-CAT2-Assembly--Kitonga-Sammy-Musangi-148224-.

## Tasks
### Task 1- Control Flow and Conditional Logic (6 Marks)
- The program classifies user input as either POSITIVE or NEGATIVE or ZERO
 
```
cd Task1_controFlow
nasm -f elf32 task1.asm -o task1.o -g
ld -m elf_i386 task1.o -o task1
./task1

```
- After running the above commands above, you are prompted to enter a number.
- If you enter a negative number, the program returns "NEGATIVE" as output in the terminal.
- If you enter a positive number i.e number greater than zero, the program returns "POSITIVE" as the output in the terminal.
- If you enter zero, the program returns "ZERO" as the output in the terminal

#### Jump Instructions Explanation
##### 1) jne parse_digits

- This instruction is used to jump to parse_digits if the first character is not a -. It checks whether the number is negative, and if it isn't, the program continues by parsing the digits directly.
##### 2) je finalize_conversion
- If the end of the string (null terminator) is reached, this jump is used to move to the final conversion step where we finalize the number stored in eax.
##### 3) jmp parse_loop 
- This jump ensures that the program continues parsing the digits until the entire string is processed.

##### 4) je zero_case
- If the final number in eax is zero (after comparison with 0), this jump leads the program to display the "ZERO" message.
##### 5) jl negative_case
- If the value in eax is less than 0 (negative), the program jumps to display the "NEGATIVE" message.
##### 6) jmp positive_case
- If the number is positive (greater than 0), this jump directs the program to display the "POSITIVE" message.

### Task 2- Array Manipulation with Looping and Reversal (6 Marks)

```
cd Task2_ArrayManipulation
nasm -f elf64 task2.asm -o task2.o -g
ld -m task2.o -o task2
./task2

```
- After running the above commands, the output will be a the array 10 20 30 40 50 reversed to 50 40 30 20 10

#### Documentation Requirement
##### 1) Reversing the Array:

- mov rsi, array: Points rsi to the start of the array.
- mov rcx, [size]: Loads the size of the array into rcx.
- xor rdi, rdi: Initializes rdi (used as an index for the beginning of the array) to 0.
- dec rcx: Decrements rcx to point to the last element of the array.
- reverse_loop: A loop where elements at rdi (starting) and rcx (ending) are swapped.
- cmp rdi, rcx: Compares the indices, exiting the loop if rdi >= rcx.
- mov al, [rsi + rdi] and mov bl, [rsi + rcx]: Loads elements at rdi and rcx into al and bl, respectively.
- mov [rsi + rdi], bl and mov [rsi + rcx], al: Swaps the elements.
- inc rdi and dec rcx: Increments and decrements indices to move towards the center.
- Challenges: Direct memory manipulation using indices requires careful handling of the array bounds, ensuring that no out-of-bounds access occurs.
##### 2) Printing the Reversed Array:

- mov rbx, array: Points rbx to the start of the reversed array.
- mov rcx, [size]: Loads the size again to iterate through the array.
- movzx rax, byte [rbx + rdi]: Loads each array element into rax.
- call int_to_ascii: Converts the integer in rax to an ASCII string.
- mov rax, 1 and syscall: Prints the string to stdout.
- Challenges: Handling ASCII conversion and managing the buffer size for each element ensures proper printing.
##### 3) Subroutine (int_to_ascii):

- div r8: Divides the number by 10, storing the remainder (digit) in dl.
- add dl, '0': Converts the digit into its ASCII representation.
- mov [rsi + rbx], dl: Stores the digit in the buffer.
- reverse_ascii: Reverses the string after conversion  to ensure correct digit order.


### Task 3- Modular Program with Subroutines for Factorial Calculation (4 Marks)
For this task, the program calculates the factorial of the user input using a recursive subroutine.

```
cd Task3_Factorial
nasm -f elf32 task3.asm -o task3.o -g
ld -m elf_i386 task3.o -o task3
./task3

```
- When you run the commands above, you are prompted to enter a number and the program returns the factorial of that input number.
#### Challenge
- I struggled with handling stack properly using subroutines. For this i had to save and restore register values.
#### Documentation Requirement
##### 1) Register Management:

- eax: Holds the result of operations like the user input (converted to integer), factorial calculation, and during number printing.
- ebx: Used to hold the file descriptor (1 for stdout in system calls).
- ecx: Used for loop counters, string addresses, and system call parameters.
- edx: Used for division (in div instruction) and for printing numbers.
- esi: Used to point to the input string (sensor_value) and manage the current position during conversion.
- ebp: Used to manage the stack frame in function calls (e.g., in factorial_calc and print_number subroutines).
##### 2) Preserving and Restoring Values on Stack:

- factorial_calc: The value of eax (input number) is pushed onto the stack before calling factorial_calc. The stack pointer is adjusted by push eax and restored after the calculation by add esp, 4.
- print_number: The stack frame is set up by pushing ebp. Values of eax and other registers used within the function are preserved, and ebp is restored before returning from the function.
##### 3) Subroutines:

- factorial_calc: Computes the factorial of the input number. The value in eax is updated with the factorial result.
- print_number: Converts the factorial result back to a string and prints it.
### Task 4- Data Monitoring and Control Using Port-Based Simulation (4 Marks)
- For this task, i simulated monitoring a sensor value and controlling motor and alarm states based on thresholds.
- If the input is 50 or below, the output is "Motor is Off".
- If the input is between 50 and 100, the output is "Motor is ON".
- If the input is greater than or equals to 100, the output is "Alarm is triggered" 
- The commands below can be used to run this task: 

```
cd Task4_DataMonitoring
nasm -f elf32 task4.asm -o task4.o -g
ld -m elf_i386 task4.o -o task4
./task4

```

#### Challenge
- It was a bit difficult ensuring the right actions are triggered based on sensor values hence needing precise control of memory locations.
#### Documentation Requirement
- This program reads a sensor value, processes it, and performs actions based on the value:

##### 1) Prompt & Input: 
- The program prompts the user to enter a sensor value. The value is entered as a string and converted to an integer.

##### 2) Conversion:
- The ASCII string input is converted into an integer using a loop, where each digit is processed and added to the result.

##### 3) Decision Making:
- The integer value is compared to thresholds:

- If greater than 100, the alarm is triggered ("Alarm is triggered!").
- If between 51 and 100, the motor is turned on ("Motor is ON").
- If 50 or less, the motor is turned off ("Motor is OFF").
##### 4) Memory:

- sensor_value stores the input.
- motor_on_msg, motor_off_msg, alarm_msg store the messages displayed based on the value.
##### 5) Registers:

- eax holds the converted sensor value and results of comparisons.
- ecx, ebx, edx are used for system calls (printing messages).