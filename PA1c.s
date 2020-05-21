# PGM #1: Introduction to SPIM 
# 
# FILE: Pgm1c.s 
# 
# DESCRIPTION: This program declares two different strings. 
#              The strings are stored with a NULL termination  
#              and without a NULL termination 
 
 	.data 
 
test1: .ascii "0123" 
test2: .asciiz "0123" 
test3: .ascii "9876" 
test4: .asciiz "9876" 