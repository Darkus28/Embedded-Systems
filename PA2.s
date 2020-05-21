# PGM Assignment #2 
# 
# FILE: PA2.s 
# 
 
	 .data 
 
 
 	.text 
 
 	# Print the string in prompt1  
	
	li $t0,0x11111111
	sw $t0,268500992($zero)

	li $t0,0x22222222
	sw $t0,268500996($zero)
	
	li $t0,0x33333333
	sw $t0,268501000($zero)

	li $t0,0x44444444
	sw $t0,268501004($zero)

#reversing the order

	lw $t0,268500992($zero)
	sw $t0,268501008($zero)
	lw $t0,268501004($zero)
	sw $t0,268500992($zero)
	lw $t0,268501008($zero)
	sw $t0,268501004($zero)

	lw $t0,268500996($zero)
	sw $t0,268501008($zero)
	lw $t0,268501000($zero)
	sw $t0,268500996($zero)
	lw $t0,268501008($zero)
	sw $t0,268501000($zero)

	lw $t0,268501012($zero)
	sw $t0,268501008($zero)

	
 	# Execute this code to terminate program  
	li $v0, 10  
	syscall 
