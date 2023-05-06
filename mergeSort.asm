# Name: Abigail Pinkus, Ryan Yang, David Jin, Joshua Ho
# Date: May 12, 2023
# Program: Caesar Cipher


.macro shift(%int)
	addi $t1, $t0, %int
.end_macro

.macro printAscii(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

.macro compareAndSort(%arr, %l, %m)

.end_macro 

.data

	string: .asciiz "hello there!"
	newLine: .asciiz "\n"

# Arrays to Sort #
array: .word 4,2,5,6,1,3
space: .space 48

.text


	# Loop through string character by character
	
	# Get address of string
	la $t7, string
loop:
	lb $t2, 0($t7)
	
	printAscii($t2)
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	addi $t7, $t7, 1
	
	# Branch if "\n" is read
	#beq $t2, 0x0a, Exit
	
	# Branch at end of string
	beq $t2, 0x00, Exit
	
	j loop

Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program
