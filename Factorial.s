################################################################
#
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

