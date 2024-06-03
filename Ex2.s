.data
Array: .float 43.01, 34.06, 21208.09, 78.9, 64.98, 2126.1, 643.2, 451.4, 423.4, 45.5, 566.0, 0.0
newLine: .asciiz "\n"

.text
.globl main

# Main function
main:
    la $a0, Array       # Load the address of Array into $a0
    jal len             # Jump to the len procedure
    move $t0, $v0       # Save the length in $t0
    la $a0, Array       # Load the address of Array into $a0 again
    jal sort            # Jump to the sort procedure
    la $a0, Array       # Load the address of Array for printing
    move $a1, $t0       # Move the length into $a1
    jal printArray      # Jump to the printArray procedure
    li $v0, 10          # Load the syscall number for exit
    syscall             # Exit the program

# Function to calculate the length of the array
len:
    addi $sp, $sp, -12  # Allocate space on the stack for 3 words
    sw $ra, 8($sp)      # Save the return address on the stack
    sw $s0, 4($sp)      # Save $s0 on the stack
    sw $s1, 0($sp)      # Save $s1 on the stack
    move $s0, $a0       # Move the address of Array into $s0
    li $s1, 0           # Initialize the length counter to 0

loop:
    lwc1 $f0, 0($s0)    # Load the current element into $f0
    li.s $f1, 0.0       # Load 0.0 into $f1 for comparison
    c.eq.s $f0, $f1     # Compare the current element with 0.0
    bc1t end            # If the current element is 0.0, jump to end
    addi $s1, $s1, 1    # Increment the length counter
    addi $s0, $s0, 4    # Move to the next element in the array
    j loop              # Jump back to the loop

end:
    move $v0, $s1       # Move the length into $v0 for return
    lw $s1, 0($sp)      # Restore $s1 from the stack
    lw $s0, 4($sp)      # Restore $s0 from the stack
    lw $ra, 8($sp)      # Restore the return address from the stack
    addi $sp, $sp, 12   # Deallocate the space on the stack
    jr $ra              # Return to the caller

# Dummy Sort procedure (Placeholder for actual Bucket Sort implementation)
sort:
  # Save the return address and other necessary registers
  addi $sp, $sp, -8
  sw $ra, 4($sp)
  sw $s0, 0($sp)

  move $s0, $a0       # Move the address of Array into $s0
  move $s1, $a1       # Move the length into $s1

sort_outer:
  addi $s1, $s1, -1   # Decrement the length
  blez $s1, sort_done # If length <= 0, done sorting
  move $s2, $s0       # Initialize the inner loop pointer

sort_inner:
  addi $t0, $s2, 4    # Calculate the address of the next element
  beq $t0, $s1, sort_outer # If $s2 is pointing to the last element, skip to the next iteration of the outer loop
  lwc1 $f0, 0($s2)    # Load the current element
  lwc1 $f1, 4($s2)    # Load the next element
  c.lt.s $f1, $f0     # Compare the two elements
  bc1f sort_next      # If the current element <= next element, continue to the next pair
  swc1 $f0, 4($s2)    # Swap the two elements
  swc1 $f1, 0($s2)

sort_next:
  addi $s2, $s2, 4    # Move to the next pair
  bne $s2, $s1, sort_inner # If not at the end of the array, continue the inner loop

  j sort_outer        # Continue the outer loop

sort_done:
  # Restore registers and return
  lw $s0, 0($sp)
  lw $ra, 4($sp)
  addi $sp, $sp, 8
  jr $ra
# Procedure to print the array
printArray:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $t0, 0($sp)      # Save $t0 on the stack

    move $t1, $a1       # Get the length of the array
    li $t2, 0           # Initialize index

printLoop:
    bge $t2, $t1, printDone # If index >= length, done printing
    lwc1 $f12, 0($a0)  # Load array element
    li $v0, 2          # Syscall for print float
    syscall

    # Print newline for better readability
    la $a0, newLine
    li $v0, 4
    syscall

    addiu $a0, $a0, 4   # Move to the next array element (each float is 4 bytes)
    addiu $t2, $t2, 1   # Increment index
    j printLoop

printDone:
    lw $t0, 0($sp)      # Restore $t0 from the stack
    lw $ra, 4($sp)      # Restore $ra from the stack
    addi $sp, $sp, 8
    jr $ra
