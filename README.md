# ICS3203-CAT2-Assembly--Kitonga-Sammy-Musangi-148224-.

## Tasks
### Task 1- Control Flow and Conditional Logic (6 Marks)
- The program classifies user input as either POSITIVE or NEGATIVE
 
```
cd Task1_controFlow
nasm -f elf32 task1.asm -o task1.o -g
ld -m elf_i386 task1.o -o task1
./task1

```
- After running the above commands above, you are prompted to enter a number.
- If you enter a negative number, the program returns "NEGATIVE" as output in the terminal.
- If you enter a positive number i.e number greater than zero, the program returns "POSITIVE" as the output in the terminal.

#### Challenge
- The main difficulty here was properly using jumps and conditional statements  to handle different cases i.e (Positive or Negative).

### Task 2- Array Manipulation with Looping and Reversal (6 Marks)
```
cd Task2_ArrayManipulation
nasm -f elf64 task2.asm -o task2.o -g
ld -m task2.o -o task2
./task2

```
#### Challenge
- I kept having issues with getting segmentation faults as output in the terminal which was a bit frustrating


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