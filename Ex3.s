# Mai Nguyen Hoang - ITITIU21208

.data
Array: .float 43.01, 34.06, 21208.09, 78.9, 64.98, 2126.1, 643.2, 451.4, 423.4, 45.5, 566.0, 0.0
lineBreak: .asciiz "\n"
answer: .asciiz "\nThe second largest element is: "

.text
.globl main

main:
    # Stack frame setup
    addi $sp, $sp, -4      # Decrease stack pointer for new frame
    sw $ra, 0($sp)         # Store return address on stack

    # Call subroutine to get array length
    la $a0, Array     # Set array address as argument
    jal arrayLength     # Jump to arrayLength subroutine

    # Call subroutine to sort the array
    la $a0, Array     # Set array address as argument
    move $a1, $v0     # Set array length as argument
    jal arraySort     # Jump to arraySort subroutine

    # Call subroutine to print sorted array
    la $a0, Array     # Set array address as argument
    move $a1, $v0     # Set array length as argument
    jal printSortedArray     # Jump to printSortedArray subroutine

    # Print the second largest element
    la $a0, answer    # Set message as argument
    li $v0, 4         # Set syscall code for print string
    syscall           # Execute syscall

    la $t0, Array     # Set array address as argument
    lwc1 $f12, 4($t0) # Load second element of array into $f12
    li $v0, 2         # Set syscall code for print float
    syscall           # Execute syscall

    # Stack frame cleanup
    lw $ra, 0($sp)    # Restore return address from stack
    addi $sp, $sp, 4  # Increase stack pointer to previous frame

    # Exit program
    li $v0, 10        # Set syscall code for exit
    syscall           # Execute syscall

arrayLength:
    # Initialize length counter and index
    li $v0, 0
    li $t0, 0
lengthLoop:
    # Calculate array index and get array address
    mul $t1, $t0, 4
    add $t1, $t1, $a0
    lwc1 $f1, 0($t1)  # Load array value
    c.eq.s $f1, $f0   # Compare array value with 0.0
    bc1t lengthExit   # If array value is 0.0, exit loop
    addi $t0, $t0, 1  # Increment index
    addi $v0, $v0, 1  # Increment length counter
    j lengthLoop      # Repeat loop
lengthExit:
    jr $ra            # Return from subroutine

arraySort:
    # Initialize counters
    add $t0, $zero, $zero
outerLoop:
    # Increment counter and check if it's greater than or equal to size
    addi $t0, $t0, 1
    bgt $t0, $a1, endOuterLoop
    add $t1, $a1, $zero
innerLoop:
    # Check if counter is less than or equal to size
    bge $t0, $t1, outerLoop
    addi $t1, $t1, -1  # Decrement counter
    # Calculate array indices and get array addresses
    mul $t4, $t1, 4
    addi $t3, $t4, -4
    add $t7, $t4, $a0
    add $t8, $t3, $a0
    # Load array values and compare them
    lwc1 $f5, 0($t7)
    lwc1 $f6, 0($t8)
    c.le.s $f5, $f6
    bc1t innerLoop     # If array[j] <= array[j-1], continue loop
    # Swap array values
    swc1 $f5, 0($t8)
    swc1 $f6, 0($t7)
    j innerLoop        # Repeat loop
endOuterLoop:
    jr $ra             # Return from subroutine

printSortedArray:
    # Initialize index
    li $t1, 0
    la $t0, Array
printLoop:
    # Load array element and print it
    lwc1 $f12, 0($t0)
    li $v0, 2
    syscall
    # Print line break
    li $v0, 4
    la $a0, lineBreak
    syscall
    # Move to next element and increment index
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    blt $t1, $a1, printLoop  # Repeat until all elements are printed
    jr $ra                   # Return from subroutine