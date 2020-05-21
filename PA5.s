# PGM #5: 
# 
# FILE: PA5.s 
# 
# DESCRIPTION:
#
#
# 
 
	 .data 
 
Name: 	.asciiz  "Cordero Woods\n\n" 
Course:	.asciiz "EENG 460: Computer Architecture\n"
PA: 	.asciiz  "Lab #5: Sorting\n" 
CR: 	.asciiz  "\n" 
Date:   .asciiz  "10/30/2019\n\n" 
NT:		.asciiz "Normal Termination\n"

Test1: .asciiz "X["
Test2: .asciiz "] = "
BeforeMsg: .asciiz "The Array before it is sorted\n\n"
AfterMsg:  .asciiz "The Array after it is sorted\n\n"

 
 	.text 
	
	.globl main


main:

	jal	PgmHeader		# Beginning of Main

	jal	LoadData

	li	$v0, 4
	la	$a0, BeforeMsg
	syscall

	li	$a0, 10
	jal	PrintData

	move	$a0, $gp
	li	$a1, 10
	jal	Sort

	li	$v0, 4
	la	$a0, AfterMsg
	syscall

	li	$a0, 10
	jal	PrintData

	jal	PgmTrailer

	# Normal Termination
	li	$v0, 10			# End of Main
	syscall


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

#####################################################################################################################################################
LoadData:
	
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
	
	li $t0,1
	sw $t0,0($gp)
	
	li $t0,6
	sw $t0,4($gp)
	
	li $t0,33
	sw $t0,8($gp)
	
	li $t0,4
	sw $t0,12($gp)
	
	li $t0,7
	sw $t0,16($gp)
	
	li $t0,9
	sw $t0,20($gp)
	
	li $t0,-5
	sw $t0,24($gp)
	
	li $t0,8
	sw $t0,28($gp)
	
	li $t0,10
	sw $t0,32($gp)
	
	li $t0,2
	sw $t0,36($gp)

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
PrintData:
	
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
	
	add $t0,$gp,$zero
	addi $a1,$a0,0
	addi $a2,$zero,0
PTLoop:

	li $v0, 4
	la $a0,Test1
	syscall
	
	li $v0, 1
	move $a0,$a2
	syscall
	
	li $v0, 4
	la $a0,Test2
	syscall

	lw	$t1,0($t0)
	li $v0, 1
	move $a0,$t1 
	syscall
	
	li $v0, 4
	la $a0,CR
	syscall
	
	addi $a1, $a1, -1
	addi $a2, $a2, 1
	addi $t0,$t0,4
bne	$a1,$zero,PTLoop

	li $v0, 4
	la $a0,CR
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
#####################################################################################################################################################################
#
# Sort: This is a sort routine taken from the book
#
#
Sort:
	# Push stuff onto the Stack
	addi	$sp, $sp, -20		# make room on stack for 5 registers
	sw	$ra, 16($sp)		# save $ra on stack
	sw	$s3, 12($sp)		# save #s3 on the stack
	sw	$s2, 8($sp)		# save $s2 on the stack
	sw	$s1, 4($sp)		# save $s1 on the stack
	sw	$s0, 0($sp)		# save $s0 on the stack

	move	$s2, $a0		# copy parm $a0 into $s2
	move	$s3, $a1		# copy parm $a1 into $s3

	move	$s0, $zero		# i = 0

for1tst:
	slt	$t0, $s0, $s3		# reg $t0=0 if $s0 >= $s3
	beq	$t0, $zero, exit1	# goto exit1 if
	addi	$s1, $s0, -1		# j = j - 1

for2tst:
	slti	$t0, $s1, 0		# $t0 = 1 if $s0 <0 (j < 0)
	bne	$t0, $zero, exit2	# go to exit2 if 
	sll	$t1, $s1, 2		#
	add	$t2, $s2, $t1		#
	lw	$t3, 0($t2)		#
	lw	$t4, 4($t2)		#
	slt	$t0, $t4, $t3		#
	beq	$t0, $zero, exit2	#
	move	$a0, $s2		#
	move	$a1, $s1		#
	jal	Swap			#
	addi	$s1, $s1, -1		# j -= 1
	j	for2tst
exit2:
	addi	$s0, $s0, 1		# i += 1
	j	for1tst
exit1:

	# Pop stuff off the Stack
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20

	jr	$ra
##########################################################################################################################################################
#
# Swap: This procedures swap two integers in an array
#
# Input Arguments:
#
#	$a0: Contains the address of the array 'V'
#	$a1: Contains the index of the element to swap 'k'
#	$a2: Not used
#	$a3: Not used
#
# Return Values:
#
#	$v0: Not used (returns 0)
#	$v1: Not used (returns 0)
#
# Registers:
#
#	$t0: Holds v[k] initially, then v[k+1]
#	$t1: The address of the kth element of array
#	$t2: Holds v[k+1] initially, then v[k]
#

Swap:
	sll	$t1, $a1, 2		# t1 = k*4
	add	$t1, $a0, $t1		# t1 = v + (k*4)

	lw	$t0, 0($t1)		# t0 = v[k]
	lw	$t2, 4($t1)		# t2 = v[k+1]

	sw	$t2, 0($t1)		# v[k] = t2
	sw	$t0, 4($t1)		# v[k+1] = t0

	# Setup return values
	move	$v0, $zero
	move	$v1, $zero

	jr	$ra
