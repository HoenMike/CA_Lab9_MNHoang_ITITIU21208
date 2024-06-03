# Mai Nguyen Hoang - ITITIU21208

.data
Array: .float 43.01, 34.06, 21208.09, 78.9, 64.98, 2126.1, 643.2, 451.4, 423.4, 45.5, 566.0, 0.0

.text
.globl main

# Main function
main:
  la $a0, Array       # Load the address of Array into $a0
  jal len             # Jump to the len procedure
  move $a0, $v0       # Move the length into $a0 for printing
  li $v0, 1           # Load the syscall number for print_int
  syscall             # Print the length
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

  # Loop through the array
  loop:
    lwc1 $f0, 0($s0)    # Load the current element into $f0
    li.s $f1, 0.0       # Load 0.0 into $f1 for comparison
    c.eq.s $f0, $f1     # Compare the current element with 0.0
    bc1t end            # If the current element is 0.0, jump to end
    addi $s1, $s1, 1    # Increment the length counter
    addi $s0, $s0, 4    # Move to the next element in the array
    j loop              # Jump back to the loop

  # End of the loop
  end:
    move $v0, $s1       # Move the length into $v0 for return
    lw $s1, 0($sp)      # Restore $s1 from the stack
    lw $s0, 4($sp)      # Restore $s0 from the stack
    lw $ra, 8($sp)      # Restore the return address from the stack
    addi $sp, $sp, 12   # Deallocate the space on the stack
    jr $ra              # Return to the caller