# Mai Nguyen Hoang - ITITIU21208

.data
Array: .float 43.01, 34.06, 21208.09, 78.9, 64.98, 2126.1, 643.2, 451.4, 423.4, 45.5, 566.0, 0.0
lineBreak: .asciiz "\n"

.text
.globl main

main:
  # Setup stack frame
  addi $sp, $sp, -4      # Adjust $sp
  sw $ra, 0($sp)         # Save $ra

  # Call arrayLength
  la $a0, Array     # Load array address
  jal arrayLength     # Call subroutine

  # Call arraySort
  la $a0, Array     # Load array address
  move $a1, $v0          # Move length to $a1
  jal arraySort               # Call subroutine

  # Print sorted array
  la $a0, Array     # Load array address
  move $a1, $v0          # Move length to $a1
  jal printSortedArray         # Call subroutine

  # Cleanup stack
  lw $ra, 0($sp)         # Restore $ra
  addi $sp, $sp, 4       # Restore $sp

  # Terminate program
  li $v0, 10             # Exit syscall
  syscall

arrayLength:
  li $v0, 0              # Initialize length
  li $t0, 0              # Initialize index

loop:
  mul $t1, $t0, 4        # Calculate index
  add $t1, $t1, $a0      # Get array address
  lwc1 $f1, 0($t1)       # Load array value
  c.eq.s $f1, $f0        # Compare with 0.0
  bc1t exit              # Exit if value is 0.0
  addi $t0, $t0, 1       # Increase index
  addi $v0, $v0, 1       # Increase length
  j loop                 # Repeat loop

exit:
  jr $ra                 # Return

arraySort:
  add $t0, $zero, $zero  # Initialize counter1

outerLoop:
  addi $t0, $t0, 1       # Increase i
  bgt $t0, $a1, endloop1 # Break if i >= size
  add $t1, $a1, $zero    # Initialize counter2

innerLoop:
  bge $t0, $t1, outerLoop    # Break if j <= i
  addi $t1, $t1, -1      # Decrease j
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
endloop1:
  jr $ra                 # Return

printSortedArray:
  li $t1, 0              # Initialize index
  la $t0, Array

printLoop:
  lwc1 $f12, 0($t0)      # Load array element
  li $v0, 2              # Syscall for print float
  syscall                # Print element

  li $v0, 4
  la $a0, lineBreak
  syscall                # Print space
  
  addi $t0, $t0, 4       # Move to next element
  addi $t1, $t1, 1       # Increase index
  blt $t1, $a1, printLoop# Repeat until all elements printed
  jr $ra                 # Return