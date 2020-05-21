# PGM #6: 
# 
# FILE: PA6.s 
# 
# DESCRIPTION:
#
#
# 
 
	 .data 
 
Name: 	.asciiz  "Cordero Woods\n\n" 
Course:	.asciiz "EENG 460: Computer Architecture\n"
PA: 	.asciiz  "Lab #6: Number Systems\n" 
CR: 	.asciiz  "\n" 
Date:   .asciiz  "10/06/2019\n\n" 
NT:		.asciiz "Normal Termination\n"

PromptN: .asciiz "Enter the value of N: "
PromptN2: .asciiz "You entered the value of: "
DispBase: .asciiz "Displaying Base 8 value: "
PromptStore: .asciiz "Storing Value: "

 
 	.text 
	
	.globl main


################################################################
#
# Main: This main routine. Execution starts here.
#
# Registers:	$s0 contains 8
# 		$s1 Offset in Global Memory from $gp
# 		$s2 Contains the number 'N' in base 10 (quotient)
#		$s3 is the remainder
#

main:	############ Beginning of Main ###

	jal		PgmHeader

	jal		InitRegisters
	move		$s0, $v0	# $s0 = 8
	move		$s1, $v1	# $s1 = 0 (offset from $gp)

	jal		PromptForN
	move		$s2, $v0	# $s2 = N
	
	li	$v0, 4
	la	$a0, CR
	syscall
		
	li	$v0, 4
	la	$a0, CR
	syscall

L1_Main:
	
	move		$a0, $s0	# $a0 <= 8
	move		$a1, $s2	# $a1 <= N
	jal		DivideByEight
	move		$s2, $v0	# $s2 = Quotient
	move		$s3, $v1	# $s3 = Remainder

	move		$a0, $s3	# $a0 <= Remainder
	move		$a1, $s1	# $a1 <= Offset from $gp
	jal		StoreRemainderToGlobalMemory
	jal 	DispStore

	addi	$s1, $s1, 0x04	# Increment offset from $gp
	bne		$s2, $zero, L1_Main 	#Repeat until Qoutient = 0
	
	li	$v0, 4
	la	$a0, CR
	syscall

	move		$a0, $s1		# Offset from $gp
	jal DispBase8
	jal		DisplayBaseEightNumber
	
	li	$v0, 4
	la	$a0, CR
	syscall
	
	li	$v0, 4
	la	$a0, CR
	syscall

	jal		PgmTrailer

	li		$v0, 10			# Exit Program
	syscall				############ End of Main ###



#####################################################################################################################################################
PgmHeader:
	
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
PgmTrailer:
	
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
	#li $v0,4
	#la $a0,CR
	#syscall
	
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
###########################################################################################################################################################
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
#######################################################################################################################################################
InitRegisters:

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
	
	#Body of subroutine:
	li $t0,8
	move $v0,$t0
	
	li $t0,0
	move $v1,$t0
	
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
#########################################################################################################################################################
DivideByEight:

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
	
	#Body of subroutine:
	
	divu $a1,$a0
	mfhi $v1
	mflo $v0
	
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
##############################################################################################################################################################
StoreRemainderToGlobalMemory:

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
	
	#Body of subroutine:
	#sw $a0,$a1($gp)
	sw $a0,268468224($a1)
	
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
########################################################################################################################################################
DisplayBaseEightNumber:

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
	
	#Body of subroutine:
	
	move $t0,$a0
	addi $t0,$t0,-4

PrintBaseNumber:
	#lw $s0,$t0($gp) original code
	lw $s0,268468224($t0)
	
	li $v0, 1  
	move $a0, $s0
	#move $a0,$t0($gp) test purposes
	syscall
	
	addi $t0,$t0,-4
	
	bne $t0,-4, PrintBaseNumber ##$zero
	
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
######################################################################################################################################################
DispBase8:
	
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
	la $a0,DispBase
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
##################################################################################################################################################
DispStore:
	
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
	
	move $t0,$a1
	lw $s0,268468224($t0)
	###main body
	
	
	
	#Print
	li $v0,4
	la $a0,PromptStore
	syscall
	
	li $v0, 1  
	move $a0, $s0  
	syscall
	
	li	$v0, 4
	la	$a0, CR
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