# Mai Nguyen Hoang - ITITIU21208

.data
Array: .float 43.01, 34.06, 21208.09, 78.9, 64.98, 2126.1, 643.2, 451.4, 423.4, 45.5, 566.0, 0.0
lineBreak: .asciiz "\n"
space: .asciiz " "
answer: .asciiz "\nThe second largest element is: "

.text
.globl main

main:
    # Set up the stack frame
    addi $sp, $sp, -4      # Adjust stack pointer
    sw $ra, 0($sp)         # Save return address

    # Call arrayLength
    la $a0, Array     # Load the address of the array into $a0
    jal arrayLength     # Call the arrayLength subroutine

    # Call arraySort
    la $a0, Array     # Load the address of the array into $a0
    move $a1, $v0          # Move the length to $a1
    jal arraySort               # Call the arraySort subroutine

    # Print sorted array
    la $a0, Array     # Load the address of the array into $a0
    move $a1, $v0          # Move the length to $a1
    jal printSortedArray         # Call the printSortedArray subroutine

    # Print the second largest element
    la $a0, answer      # Load the message into $a0
    li $v0, 4              # Syscall code for print string
    syscall

    la $t0, Array     # Load the address of the array into $t0
    lwc1 $f12, 4($t0)      # Load the second element of the array into $f12
    li $v0, 2              # Syscall code for print float
    syscall                # Print the second element

    # Clean up the stack
    lw $ra, 0($sp)         # Restore return address
    addi $sp, $sp, 4       # Restore stack pointer

    # Exit program
    li $v0, 10             # Exit syscall code
    syscall

arrayLength:
    li $v0, 0              # Initialize length counter to 0
    li $t0, 0              # Initialize index to 0
lengthLoop:
    mul $t1, $t0, 4        # Calculate array index
    add $t1, $t1, $a0      # Get array address
    lwc1 $f1, 0($t1)       # Load array value (float)
    c.eq.s $f1, $f0        # Compare with 0.0
    bc1t lengthExit              # Exit lengthLoop if value is 0.0
    addi $t0, $t0, 1       # Increment index
    addi $v0, $v0, 1       # Increment length counter
    j lengthLoop                 # Repeat lengthLoop
lengthExit:
    jr $ra                 # Return from function

arraySort:
    add $t0, $zero, $zero  # Initialize counter1 (i) to 0
outerLoop:
    addi $t0, $t0, 1       # Increment i
    bgt $t0, $a1, endOuterLoop # Break if i >= size
    add $t1, $a1, $zero    # Initialize counter2 (size)
innerLoop:
    bge $t0, $t1, outerLoop    # Break if j <= i
    addi $t1, $t1, -1      # Decrement j
    mul $t4, $t1, 4        # Calculate array[j] index
    addi $t3, $t4, -4      # Calculate array[j-1] index
    add $t7, $t4, $a0      # Get address of array[j]
    add $t8, $t3, $a0      # Get address of array[j-1]
    lwc1 $f5, 0($t7)       # Load array[j]
    lwc1 $f6, 0($t8)       # Load array[j-1]
    c.le.s $f5, $f6        # Compare array[j] <= array[j-1]
    bc1t innerLoop             # Continue if array[j] <= array[j-1]
    swc1 $f5, 0($t8)       # Swap array[j] and array[j-1]
    swc1 $f6, 0($t7)
j innerLoop                # Repeat innerLoop
endOuterLoop:
    jr $ra                 # Return from function

printSortedArray:
    li $t1, 0              # Initialize index
    la $t0, Array
printLoop:
    lwc1 $f12, 0($t0)      # Load array element (float)
    li $v0, 2              # Syscall code for print float
    syscall                # Print element
    li $v0, 4
    la $a0, lineBreak      # Load line break string
    syscall                # Print line break
    addi $t0, $t0, 4       # Move to next element
    addi $t1, $t1, 1       # Increment index
    blt $t1, $a1, printLoop# Repeat until all elements printed
    jr $ra                 # Return from function