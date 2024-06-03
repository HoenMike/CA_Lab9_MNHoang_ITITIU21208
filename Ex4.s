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

    # Call secondMax
    la $a0, Array     # Load the address of the array into $a0
    move $a1, $v0          # Move the length to $a1
    jal secondMax               # Call the secondMax subroutine

    # Print the second largest element
    la $a0, answer      # Load the message into $a0
    li $v0, 4              # Syscall code for print string
    syscall

    mov.s $f12, $f0      # Move the second largest element to $f12
    li $v0, 2              # Syscall code for print float
    syscall                # Print the second largest element

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

secondMax:
    li $t0, 0              # Initialize index to 0
    lwc1 $f1, 0($a0)       # Load first element as max
    lwc1 $f2, 0($a0)       # Load first element as second max

    addi $t0, $t0, 1       # Increment index to start from second element
secondMaxLoop:
    bge $t0, $a1, secondMaxExit   # Exit if index >= length

    mul $t1, $t0, 4        # Calculate array index
    add $t1, $t1, $a0      # Get array address
    lwc1 $f3, 0($t1)       # Load current element

    c.le.s $f3, $f1        # Compare current element with max
    bc1t updateSecondMax   # If current element <= max, update second max

    mov.s $f2, $f1         # Update second max to previous max
    mov.s $f1, $f3         # Update max to current element
    j continueSecondMax    # Continue loop

updateSecondMax:
    c.le.s $f3, $f2        # Compare current element with second max
    bc1t continueSecondMax # If current element <= second max, continue loop
    mov.s $f2, $f3         # Update second max to current element

continueSecondMax:
    addi $t0, $t0, 1       # Increment index
    j secondMaxLoop        # Repeat loop

secondMaxExit:
    mov.s $f0, $f2         # Move second max to $f0 for return
    jr $ra                 # Return from function