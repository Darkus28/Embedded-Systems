# PGM #7: 
# 
# FILE: PA7.s 
# 
# DESCRIPTION:
#
#
# 
 
	 .data 
 
Name: 	.asciiz  "Cordero Woods\n\n" 
Course:	.asciiz "EENG 460: Computer Architecture\n"
PA: 	.asciiz  "Lab #7: Floating Point\n" 
CR: 	.asciiz  "\n" 
Date:   .asciiz  "11/dd/2019\n\n" 
NT:		.asciiz "Normal Termination\n"

PromptF: .asciiz "Enter a temperature in Fahrenheit: "
PromptF2: .asciiz "You entered a temperature of: "
PromptC: .asciiz "The Centigrade temperature is: "
PromptNew: .asciiz "Do you want to covert another Fahrenheit temperature(No(0) or Yes(1)): "

const5: .float 5.0
const9: .float 9.0
const32: .float 32.0

 
 	.text 
	
	.globl main


################################################################
#
# Main: This main routine. Execution starts here.
#


main:	############ Beginning of Main ###
		
	jal	PgmHeader

L1_Main:
	
	jal StoreConstants

	jal PromptForFahr
	move $t0, $v0
	
	li	$v0, 4
	la	$a0, CR
	syscall
		
	li	$v0, 4
	la	$a0, CR
	syscall

	move $a0, $t0
	jal F2C
	move $t0, $v0

	move $a0, $t0
	jal PrintTempC
	
	li	$v0, 4
	la	$a0, CR
	syscall
	
	li	$v0, 4
	la	$a0, CR
	syscall

	jal	ConvAgain
	move	$t0, $v0
		
	li	$v0, 4
	la	$a0, CR
	syscall

	bne $t0, $zero, L1_Main
	
	li	$v0, 4
	la	$a0, CR
	syscall
	
	jal	PgmTrailer

	li $v0, 10		# Exit Program
	syscall


############################################################################################################################################################
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

############################################################################################################################################################
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
############################################################################################################################################################
PromptForFahr:
	
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
	
	#Print PromptF
	li $v0,4
	la $a0,PromptF ##remeber to add new line in prompts
	syscall
	
	# Read a float, value read is stored in $f0
	li $v0,6 
	syscall

	li	$v0, 4
	la	$a0, CR
	syscall
	
	#Print PromptF2
	li $v0,4
	la $a0,PromptF2
	syscall
	
	# Print the value contained in $s0  
	li $v0, 2  
	mov.s $f12, $f0  
	syscall
	

	mfc1 $v0, $f0

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
############################################################################################################################################################
StoreConstants:

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
	l.s $f0,const5
	mfc1 $t0,$f0
	sw $t0,0($gp)
	
	l.s $f0,const9
	mfc1 $t0,$f0
	sw $t0,4($gp)
	
	l.s $f0,const32
	mfc1 $t0,$f0
	sw $t0,8($gp)
	
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
############################################################################################################################################################
F2C:
##a0 holds temp fah
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
	
	mtc1 $a0,$f0 ##move fah from int to float reg
	l.s $f1,const5
	l.s $f2,const9
	l.s $f3,const32
	
	sub.s $f0,$f0,$f3 #fah-32 store in $f0
	div.s $f2,$f2,$f1 #9/5
	div.s $f0,$f0,$f2 #(fah-32)/(9/5), temp in cent/celc
	
	mfc1 $v0,$f0
	
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
############################################################################################################################################################
PrintTempC:
#$a0 holds temp cent	
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
		
	#Main Body
	
	mtc1 $a0,$f0
	
	li $v0,4
	la $a0,PromptC
	syscall
	
	li $v0,2
	mov.s $f12,$f0
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
############################################################################################################################################################
ConvAgain:
	
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
	
	#Print PromptNew
	li $v0,4
	la $a0,PromptNew ##remeber to add new line in prompts
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
	