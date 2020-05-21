# PGM #1: Introduction to SPIM 
# 
# FILE: Pgm1d.s 
# 
# DESCRIPTION: This program prompts the user to enter 
# an integer, reads in the integer and the prints the 
# integer back out to the console 
 
	 .data 
 
prompt1: .asciiz  "Enter in an integer: " 
prompt2: .asciiz  "The answer is: " 
newLine: .asciiz  "\n" 
bye:     .asciiz  "Goodbye!\n" 
 
 	.text 
 
 	# Print the string in prompt1  
	li $v0, 4  
	la $a0, prompt1  
	syscall 
 
 	# Read an integer from Console and store into $s0  
	li $v0, 5  
	syscall  
	move  $s0, $v0 
 
 	# Print the string in prompt2  
	li $v0, 4  
	la $a0, prompt2  
	syscall 
 
      	# Print the value contained in $s0  
	li $v0, 1  
	move $a0, $s0  
	syscall 
 
 	# Print a new line character to the console  
	li $v0, 4  
	la $a0, newLine  
	syscall 
 
 	# Print another new line character to the console  
	li $v0, 4  
	la $a0, newLine  
	syscall 
 
 	# Print a goodbye message to the console  
	li $v0, 4 
  	la $a0, bye  
	syscall 
 
 	# Execute this code to terminate program  
	li $v0, 10  
	syscall 