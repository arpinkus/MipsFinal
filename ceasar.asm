# Name: Abigail Pinkus, Ryan Yang, David Jin, Joshua Ho, 
# Date: May 12, 2023
# Program: Ceasar Cipher
# ~ Step 1: Identify the character within the sentence.
# ~ Step 2: Find that character’s location within the alphabet.
# ~ Step 3: Identify that characters location + the key in the alphabet.
# ~ Note* if the location + key > 26, loop back around and begin counting at one.
# ~ Step 4: Build a new sentence using the new characters in place of the original characters.
# ~ Step 5: repeat until sentence length is reached. (For loop).
# ~ Step 6: return result.

# ~ create map of letters to numbers
# ~ get characeter from sentence
# ~ Find the character's number
# ~ add character's location number + key Code what to do if 26 is reached: take the greater number and subtract 26 until it is less than 26
# ~ build a new sentence using the new characters (we could print a char array in a loop
# ~ print result

.macro shift(%int)
	addi $t1, $t0, %int
.end_macro

.macro printAscii(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

.macro isValidLetter(%int)
	blt %int, 48, Fail
	ble %int, 57, number
	blt %int, 65, Fail
	ble %int, 90, Uppercase
	blt %int, 97, Fail
	ble %int, 122, Lowercase
	bgt %int, 122, Fail
Uppercase:
	li $t6, 1 #1 = uppercase
	j Success
Lowercase:
	blt %int, 97, Fail
	li $t6, 2 #2 = lowercase
	j Success
Fail:
	li $t6, 0 #0 = not a letter
	j Success
	
number:
	li $t6, 3 #3 = a number
	
Success:
	# Testing Print #
	#li $v0, 4
	#la $a0, check
	#syscall
	#li $v0, 1
	#move $a0, $t6
	#syscall
.end_macro 

# The loop ensures that the shift is actually shifted by the user's amount. 
# If the shift amount entered is greater than 26, the shift is looped more than once. (it only needs to loop by divisions of 26)
.macro shiftAscii(%int, %shift)
	isValidLetter(%int)
	# Check if Char is a Letter #
	beq $t6, 0, shift_end

	# Add by Shift Amount #
	add $t2, %int, %shift

	# Check if Lowercase or Uppercase #
	beq $t6, 2, Lowercase
	beq $t6, 1, Uppercase #unnecessary (just for certainty)
	beq $t6, 3, Number
	
#-----------------------------------------------------we can move the li $t4, 26 before all the labels so that its just written once, unless $t4 is used for something other than storing 26------------------

# Loop for Uppercase #
Uppercase:
	# Exit if Number is in Range #
	blt $t2, 65, negativeShiftUpper
	ble $t2, 91, shift_end
	

	# Bring Character Back to 'A' #
	li $t4, 26 #save number 26
	sub $t2, $t2, $t4
	j Uppercase
negativeShiftUpper:
	#when decrypting or negative shift
	addi $t2, $t2, 26
	# Loop #
	j Uppercase

	# Loop for Lowercase #
Lowercase:
	blt $t2, 97, negativeShiftLower
	ble $t2, 122, shift_end

	# Bring Character Back to 'a' #
	li $t4, 26 #save number 26
	sub $t2, $t2, $t4
	j Lowercase
negativeShiftLower:
	#when decrypting or negative shift
	addi $t2, $t2, 26

	# Loop #
	j Lowercase
	
Number:
	#exit if number is in range
	blt $t2, 48, numberShift
	ble $t2, 57, shift_end
	
	# Bring number back to '0' #
	subi $t2, $t2, 10
	j Number
numberShift:
	addi $t2, $t2, 10
	j Number
	

shift_end:
	# Testing #
	# Print newLine #
	#li $v0, 4
	#la $a0, newLine
	#syscall

	# Print New Shifted Ascii Number #
	#li $v0, 1
	#move $a0, $t2
	#syscall
	
	# Print newLine #
	#li $v0, 4
	#la $a0, newLine
	#syscall
.end_macro 

.data
	outputBuffer: .space 100
	getString: .asciiz "\nEnter a string: "
	getShiftAmount: .asciiz "\nEnter a shift amount: "
	buffer: .space 150
	newLine: .asciiz "\n"
	#check: .asciiz "\nCheck number: "
	
	shiftedString: .asciiz "\nShifted string: "
	
	
	menuPrompt: .asciiz "\n--------------------MAIN MENU--------------------\n(1) Encrypt string\n(2) Decrypt string\n\nEnter '1' or '2' for your selection: "
	lineBreak: .asciiz "\n-------------------------------------------------\n"
	invalidInput: .asciiz "\nPlease provide a valid input!\n"
.text
main:
menu:
	# Print menu
	li $v0, 4
	la $a0, menuPrompt
	syscall
	
	# Get user input
	li $v0, 5
	syscall
	move $s1, $v0
	
	# Print line break
	li $v0, 4
	la $a0, lineBreak
	syscall
	
	beq $s1, 1, encrypt # If input is 1, encrypt string
	beq $s1, 2, decrypt # If input is 2, decrypt string

	# Invalid input
	li $v0, 4
	la $a0, invalidInput
	syscall
	
	j menu
	

encrypt:
	# Prompt User for String #
	li $v0, 4
	la $a0, getString
	syscall
	
	# Get User String #
	li $v0, 8
	la $a0, buffer #buffer
	li $a1, 100  #max characters to read
	syscall
	move $s0, $v0  #save user string in $s0
	
	# Prompt User for Shift Amount #
	li $v0, 4
	la $a0, getShiftAmount
	syscall
	
	# Get User Int #
	li $v0, 5
	syscall
	move $s7, $v0  #save shift in $s7
	
	# Loop through string character by character
	
	# Get address of string
	la $t7, buffer
	la $t8, outputBuffer
	#move $t7, $a0
loop:
	lb $t2, 0($t7)
	
	#li $v0, 4
	#la $a0, newLine
	#syscall
	
	# Shift #
	shiftAscii($t2, $s7)
	sb $t2, 0($t8)
	
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	
	# Branch if "\n" is read
	beq $t2, 0x0a, encrypt_end
	
	# Branch at end of string
	beq $t2, 0x00, encrypt_end
	
	j loop
	
encrypt_end:
	# Print Out New String #
	li $v0, 4
	la $a0, shiftedString
	syscall
	la $a0, outputBuffer
	syscall
	
	j Exit
	
decrypt:
	# Prompt User for String #
	li $v0, 4
	la $a0, getString
	syscall
	
	# Get User String #
	li $v0, 8
	la $a0, buffer #buffer
	li $a1, 100  #max characters to read
	syscall
	move $s0, $v0  #save user string in $s0
	
	# Prompt User for Shift Amount #
	li $v0, 4
	la $a0, getShiftAmount
	syscall
	
	# Get User Int #
	li $v0, 5
	syscall
	move $s7, $v0  #save shift in $s7
	mul $s7, $s7, -1
	
	# Loop through string character by character
	
	# Get address of string
	la $t7, buffer
	la $t8, outputBuffer
	#move $t7, $a0
deloop:
	lb $t2, 0($t7)
	
	#li $v0, 4
	#la $a0, newLine
	#syscall
	
	# Shift #
	shiftAscii($t2, $s7)
	sb $t2, 0($t8)
	
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	
	# Branch if "\n" is read
	beq $t2, 0x0a, decrypt_end
	
	# Branch at end of string
	beq $t2, 0x00, decrypt_end
	
	j deloop
	
decrypt_end:
	# Print Out New String #
	li $v0, 4
	la $a0, shiftedString
	syscall
	la $a0, outputBuffer
	syscall
	
	j Exit
	
Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program
