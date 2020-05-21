# PGM #3: Subroutines
# 
# FILE: PA3.s 
# 
# DESCRIPTION: This program prompts the user to enter 
# an integer, reads in the integer and the prints the 
# integer back out to the console 
 
	 .data 
 
Name: 	.asciiz  "Cordero Woods\n\n" 
Course:	.asciiz "EENG 460: Computer Architecture\n"
PA: 	.asciiz  "Programming Assignment: 3\n" 
Cr: 	.asciiz  "\n" 
Date:   .asciiz  "10/DD/2019\n\n" 
NT:		.asciiz "Normal Termination\n"
 
 	.text 
	
	.globl main
	
#Main program entry point	
main:	
 
 	#Jump to Subroutine
	jal Proc1
	
	#Jump to Subroutine
	jal Proc2
	
	#Jump to Subroutine
	jal Proc3
	
	#Jump to Subroutine
	jal Proc4
	
	#Print another Carriage Return
	li $v0,4
	la $a0,Cr
	syscall
	
	#Normal Termination
	li $v0,10
	syscall
	
	
##################################################################################################################	
Proc1:
	
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
############################################################################################
Proc2:
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
	li $s0,0xFFFFFFFF
	
	li $v0, 1  
	move $a0, $s0  
	syscall

PrintInt:
	li $v0,4
	la $a0,Cr
	syscall
	
	sll $s0,$s0,1
	li $v0, 1  
	move $a0, $s0  
	syscall 
	bne $s0, $zero, PrintInt
	
	li $v0,4
	la $a0,Cr
	syscall
	
	li $v0,4
	la $a0,Cr
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
############################################################################################	
Proc3:
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
	li $s0,0x7FFFFFFF
	
	li $v0, 1  
	move $a0, $s0  
	syscall

PrintInt2:
	li $v0,4
	la $a0,Cr
	syscall
	
	srl $s0,$s0,1
	li $v0, 1  
	move $a0, $s0  
	syscall 
	bne $s0, $zero, PrintInt2
	
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
############################################################################################	
Proc4:
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
	
	#Print Carriage Return
	li $v0,4
	la $a0,Cr
	syscall
	
	li $v0,4
	la $a0,Cr
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
############################################################################################	





	