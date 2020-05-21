# PGM #4: 
# 
# FILE: PA4.s 
# 
# DESCRIPTION:
#
#
# 
 
	 .data 
 
Name: 	.asciiz  "Cordero Woods\n\n" 
Course:	.asciiz "EENG 460: Computer Architecture\n"
PA: 	.asciiz  "Programming Assignment: 4\n" 
CR: 	.asciiz  "\n" 
Date:   .asciiz  "10/DD/2019\n\n" 
NT:		.asciiz "Normal Termination\n"
PromptN: .asciiz "Enter the value of N: "
PromptN2: .asciiz "You entered the value of: "
PromptX: .asciiz "Enter the value of X: "
PromptX2: .asciiz "You entered the value of: "
ResultMsg: .asciiz "The Binomial Coefficient is: "
PromptPlay: .asciiz "Would you like to play again (Yes=1, No=0)? "
 
 	.text 
	
	.globl main

################################################################
#
# Main: This main routine. Execution starts here.
#
# N is stored in $s0
# X is stored in $s1
# N-x is stored in $s2
# Binary Coeff is stored in $s3
#
# N! is stored in $s4
# X! is stored in $s5
# (N-x)! is stored in $s6
# (N-x)!*x! is stored in $s7
#

main:

		jal	HwkHeader

L1_Main:
		jal	PromptForN
		move	$s0, $v0		# $s0 = N
		
		li	$v0, 4
		la	$a0, CR
		syscall
		
		li	$v0, 4
		la	$a0, CR
		syscall
		
		jal	PromptForX
		move	$s1, $v0		# $s1 = x

		li	$v0, 4
		la	$a0, CR
		syscall
		
		li	$v0, 4
		la	$a0, CR
		syscall

		sub	$s2, $s0, $s1		# $s2 = N-x

		move	$a0, $s0
		jal	fact
		move	$s4, $v0		# $s4 = N!

		move	$a0, $s1
		jal	fact
		move	$s5, $v0		# $s5 = x!

		move	$a0, $s2
		jal	fact
		move	$s6, $v0		# $s6 = (N-x)!

		mul	$s7, $s5, $s6		# $s7 = x!*(N-x)!
		div	$s3, $s4, $s7		# $s3 = N!/(x!*(N-x)!)

		li	$v0, 4
		la	$a0, ResultMsg
		syscall

		li	$v0, 1
		move	$a0, $s3		# Print out the Binomial Coefficient
		syscall

		li	$v0, 4
		la	$a0, CR
		syscall

		li	$v0, 4
		la	$a0, CR
		syscall

		jal	PlayAgain
		move	$t0, $v0
		
		li	$v0, 4
		la	$a0, CR
		syscall

		bne 	$t0, $zero, L1_Main


		jal	HwkTrailer
         

		li	$v0, 10
		syscall




#####################################################################################################################################################
HwkHeader:
	
	#Store registers onto the stack
	addi $sp,$sp,-48
	
	sw	 $a0,44($sp)
	sw	 $a1,40($sp)
	sw	 $a2,36($sp)
	sw	 $a3,32($sp)
	sw	 $s0,28($sp)
	sw	 $s1,24($sp)
	sw	 $s2,20($sp)
	sw	 $s3,16($sp)
	sw	 $s4,12($sp)
	sw	 $s5,8($sp)
	sw	 $s6,4($sp)
	sw	 $s7,0($sp)
	
	#Body of subroutine: Printing name,course,assignment#, and date
	li $v0, 4  
	la $a0, Name  
	syscall 
	
	li $v0, 4  
	la $a0, Course 
	syscall 
	
	li $v0, 4  
	la $a0, PA 
	syscall 
	
	li $v0, 4  
	la $a0, Date  
	syscall 
	
	#Pop registers off the stack
	lw	 $s7,0($sp)
	lw	 $s6,4($sp)
	lw	 $s5,8($sp)
	lw	 $s4,12($sp)
	lw	 $s3,16($sp)
	lw	 $s2,20($sp)
	lw	 $s1,24($sp)
	lw	 $s0,28($sp)
	lw	 $a3,32($sp)
	lw	 $a2,36($sp)
	lw	 $a1,40($sp)
	lw	 $a0,44($sp)
	
	addi $sp,$sp,48
	
	#Return to the calling program
	jr $ra

#####################################################################################################################################################
HwkTrailer:
	
	#Store registers onto the stack
	addi $sp,$sp,-48
	
	sw	 $a0,44($sp)
	sw	 $a1,40($sp)
	sw	 $a2,36($sp)
	sw	 $a3,32($sp)
	sw	 $s0,28($sp)
	sw	 $s1,24($sp)
	sw	 $s2,20($sp)
	sw	 $s3,16($sp)
	sw	 $s4,12($sp)
	sw	 $s5,8($sp)
	sw	 $s6,4($sp)
	sw	 $s7,0($sp)
	
	#Print Carriage Return
	li $v0,4
	la $a0,CR
	syscall
	
	#Print Normal Termination
	li $v0,4
	la $a0,NT
	syscall

#Pop registers off the stack
	lw	 $s7,0($sp)
	lw	 $s6,4($sp)
	lw	 $s5,8($sp)
	lw	 $s4,12($sp)
	lw	 $s3,16($sp)
	lw	 $s2,20($sp)
	lw	 $s1,24($sp)
	lw	 $s0,28($sp)
	lw	 $a3,32($sp)
	lw	 $a2,36($sp)
	lw	 $a1,40($sp)
	lw	 $a0,44($sp)
	
	addi $sp,$sp,48
	
	#Return to the calling program
	jr $ra

#####################################################################################################################################################
PromptForN:
	
	#Store registers onto the stack
	addi $sp,$sp,-48
	
	sw	 $a0,44($sp)
	sw	 $a1,40($sp)
	sw	 $a2,36($sp)
	sw	 $a3,32($sp)
	sw	 $s0,28($sp)
	sw	 $s1,24($sp)
	sw	 $s2,20($sp)
	sw	 $s3,16($sp)
	sw	 $s4,12($sp)
	sw	 $s5,8($sp)
	sw	 $s6,4($sp)
	sw	 $s7,0($sp)
	
	#Print PromptN
	li $v0,4
	la $a0,PromptN ##remeber to add new line in prompts
	syscall
	
	# Read an integer from Console store in $v0 
	li $v0, 5  
	syscall  
	move  $s0, $v0
	
	#Print PromptN2
	li $v0,4
	la $a0,PromptN2
	syscall
	
	# Print the value contained in $s0  
	li $v0, 1  
	move $a0, $s0  
	syscall
	

	move $v0, $a0

#Pop registers off the stack
	lw	 $s7,0($sp)
	lw	 $s6,4($sp)
	lw	 $s5,8($sp)
	lw	 $s4,12($sp)
	lw	 $s3,16($sp)
	lw	 $s2,20($sp)
	lw	 $s1,24($sp)
	lw	 $s0,28($sp)
	lw	 $a3,32($sp)
	lw	 $a2,36($sp)
	lw	 $a1,40($sp)
	lw	 $a0,44($sp)
	
	addi $sp,$sp,48
	
	#Return to the calling program
	jr $ra
#####################################################################################################################################################
PromptForX:
	
	#Store registers onto the stack
	addi $sp,$sp,-48
	
	sw	 $a0,44($sp)
	sw	 $a1,40($sp)
	sw	 $a2,36($sp)
	sw	 $a3,32($sp)
	sw	 $s0,28($sp)
	sw	 $s1,24($sp)
	sw	 $s2,20($sp)
	sw	 $s3,16($sp)
	sw	 $s4,12($sp)
	sw	 $s5,8($sp)
	sw	 $s6,4($sp)
	sw	 $s7,0($sp)
	
	#Print PromptX
	li $v0,4
	la $a0,PromptX ##remeber to add new line in prompts
	syscall
	
	# Read an integer from Console store in $v0 
	li $v0, 5  
	syscall  
	move  $s0, $v0 
	
	#Print PromptX2
	li $v0,4
	la $a0,PromptX2
	syscall
	
	# Print the value contained in $s0  
	li $v0, 1  
	move $a0, $s0  
	syscall

	move $v0, $a0

#Pop registers off the stack
	lw	 $s7,0($sp)
	lw	 $s6,4($sp)
	lw	 $s5,8($sp)
	lw	 $s4,12($sp)
	lw	 $s3,16($sp)
	lw	 $s2,20($sp)
	lw	 $s1,24($sp)
	lw	 $s0,28($sp)
	lw	 $a3,32($sp)
	lw	 $a2,36($sp)
	lw	 $a1,40($sp)
	lw	 $a0,44($sp)
	
	addi $sp,$sp,48
	
	#Return to the calling program
	jr $ra	
#####################################################################################################################################################
# Fact: This is a recursive procedure for computing the factorial
#       of an integer
#
#
fact: 
	nop				# Factorial Subroutine

	addi	$sp, $sp, -8		# adjust stack for 2 items
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)

	slti	$t0, $a0, 1		# t0 = 1 if a0 < 1
	beq	$t0, $zero, L1_fact	# Branch if t0 = 0 (a0 >= 1)

	addi	$v0, $zero, 1		# move 1 to v0

	addi	$sp, $sp, 8		# Reset stack pointer, no
					# need to pop as what we pushed
					# never changed.

	jr	$ra			# Return from recursive call

L1_fact:
	addi	$a0, $a0, -1

	jal	fact			# Recursive Call

	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8

	mul	$v0, $a0, $v0

	jr	$ra			# Return from recursive/main call
#####################################################################################################################################################
PlayAgain:
	
	#Store registers onto the stack
	addi $sp,$sp,-48
	
	sw	 $a0,44($sp)
	sw	 $a1,40($sp)
	sw	 $a2,36($sp)
	sw	 $a3,32($sp)
	sw	 $s0,28($sp)
	sw	 $s1,24($sp)
	sw	 $s2,20($sp)
	sw	 $s3,16($sp)
	sw	 $s4,12($sp)
	sw	 $s5,8($sp)
	sw	 $s6,4($sp)
	sw	 $s7,0($sp)
	
	#Print PromptPlay
	li $v0,4
	la $a0,PromptPlay ##remeber to add new line in prompts
	syscall
	
	# Read an integer from Console store in $v0 
	li $v0, 5  
	syscall   

#Pop registers off the stack
	lw	 $s7,0($sp)
	lw	 $s6,4($sp)
	lw	 $s5,8($sp)
	lw	 $s4,12($sp)
	lw	 $s3,16($sp)
	lw	 $s2,20($sp)
	lw	 $s1,24($sp)
	lw	 $s0,28($sp)
	lw	 $a3,32($sp)
	lw	 $a2,36($sp)
	lw	 $a1,40($sp)
	lw	 $a0,44($sp)
	
	addi $sp,$sp,48
	
	#Return to the calling program
	jr $ra	
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
	