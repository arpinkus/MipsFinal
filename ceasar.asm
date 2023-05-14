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

# Macro to print string labels
.macro printString(%stringLabel)
li $v0, 4
la $a0, %stringLabel
syscall
.end_macro

# Check to see if the number in the parameter is within the range of a number or letter in the ascii table
.macro isValidLetter(%int)
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
	
	
# Exits macro
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

	# Check if int is a letter or number within ascii table range#
	isValidLetter(%int)
	beq $t6, 0, shift_end #If isValidLetter macro assigns $t6 0, then it is not a number or letter so it does not become shifted and exits shiftAscii

	# Add by Shift Amount #
	add $t2, %int, %shift

	# Check if Lowercase or Uppercase or Number #
	beq $t6, 1, Uppercase
	beq $t6, 2, Lowercase
	beq $t6, 3, Number
	

# Loop for Uppercase #
Uppercase:
	# Exit if Number is in Range #
	blt $t2, 65, negativeShiftUpper #if lower than 65, out of range of uppercase letters, go to negativeShiftUpper
	ble $t2, 91, shift_end #if lower than or equal to 91 but equal to 65 or above, then in range and no need to correct, exit macro
	

	# Bring Character Back to 'A' #
	subi $t2, $t2, 26
	j Uppercase #check to see if number is range
negativeShiftUpper:
	#when decrypting or negative shift, brings character back to 'A'
	addi $t2, $t2, 26
	# Loop #
	j Uppercase #check again to see if number is in range

# Loop for Lowercase #
Lowercase:
	blt $t2, 97, negativeShiftLower #if lower than 97, out of range of lowercase letters, go to negativeShiftLower
	ble $t2, 122, shift_end #if lower than or equal to 122 but equal to 97 or above, then in range and no need to correct, exit macro

	# Bring Character Back to 'a' #
	subi $t2, $t2, 26
	j Lowercase #check to see if number is in range
negativeShiftLower:
	#when decrypting or negative shift, brings character back to 'a'
	addi $t2, $t2, 26

	# Loop #
	j Lowercase #check again to see if number is in range
	
# Loop for Number #
Number:
	#exit if number is in range
	blt $t2, 48, negativeShiftNumber #If lower than 48, out of range of numbers, go to negativeShiftNumber
	ble $t2, 57, shift_end
	
	# Bring number back to '0' #
	subi $t2, $t2, 10
	j Number #check again to see if number is in range
negativeShiftNumber:
	#when decrypting or negative shift, brings number back to '0'
	addi $t2, $t2, 10
	j Number #check again to see if number is in range
	
#exits macro
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
	decryptPrompt: .asciiz "\n(1) Know Shift Amount\n(2) Do Not Know Shift Amount\nEnter '1' or '2' for your selection: "
	shiftAgain: .asciiz "\n(1) Yes\n(2) No\nShift Again?: "
	
	shiftedString: .asciiz "\nShifted string: "
	increment: .asciiz "\nIncrement by '1' or '-1'\nEnter '1' or '-1': "	
	
	menuPrompt: .asciiz "\n--------------------MAIN MENU--------------------\n(1) Encrypt string\n(2) Decrypt string\n\nEnter '1' or '2' for your selection: "
	lineBreak: .asciiz "\n-------------------------------------------------\n"
	invalidInput: .asciiz "\nPlease provide a valid input!\n"

.text
main:
#start of program
menu:
	# Print menu
	printString(menuPrompt)
	
	# Get user input
	li $v0, 5
	syscall
	move $s1, $v0 #save user input into $s1
	
	# Print line break
	printString(lineBreak)
	
	beq $s1, 1, encrypt # If input is 1, encrypt string
	beq $s1, 2, decrypt # If input is 2, decrypt string

	# Invalid input
	printString(invalidInput)
	
	#jump back to menu to reprompt user for option
	j menu
	
#user chose to encrypt string
encrypt:
	# Prompt User for String #
	printString(getString)
	
	# Get User String #
	li $v0, 8
	la $a0, buffer #buffer
	li $a1, 100  #max characters to read
	syscall
	move $s0, $v0  #save user string in $s0
	
	# Prompt User for Shift Amount #
	printString(getShiftAmount)
	
	# Get User Int #
	li $v0, 5
	syscall
	move $s7, $v0  #save shift in $s7
	
	# Loop through string character by character
	
	# Get address of user string and load into $t7 and load address of empty buffer into $t8
	la $t7, buffer
	la $t8, outputBuffer
	
#loops through each character of user inputted string and shifts by user given amount
loop:
	#load a character of given user string into $t2
	lb $t2, 0($t7)
	
	# for testing #
	#li $v0, 4
	#la $a0, newLine
	#syscall
	
	# Shift charactere $t2 by the given user shift amount stored in $s7 #
	shiftAscii($t2, $s7)
	sb $t2, 0($t8) #store shifted character, $t2, into outputBuffer $t8
	
	#increment address of user string and outputBuffer by 1
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	
	# Branch if "\n" is read
	beq $t2, 0x0a, encrypt_end
	
	# Branch at end of string
	beq $t2, 0x00, encrypt_end
	
	j loop

#finished shifting all characters of string, output resulting ciphertext
encrypt_end:
	# Print Out New String #
	printString(shiftedString)
	la $a0, outputBuffer
	syscall
	
	j Exit

#user chose to decrypt a string
decrypt:
	# Print decrypt menu
	printString(decryptPrompt)
	
	# Get user input
	li $v0, 5
	syscall
	move $s1, $v0 #save user input in $s1
	
	# Print line break
	printString(lineBreak)
	
	beq $s1, 1, decryptByShift # If input is 1, decrypt string with known shift amount
	move $t5, $zero #initialize shift amount
	addi $t5, $t5, 1 #start shift at one
	beq $s1, 2, Increment # If input is 2, decrypt string by shifting 1 at a time

	# Invalid input
	printString(invalidInput)
	
	j menu

#user knows the key, the shift amount
decryptByShift:
	# Prompt User for String #
	printString(getString)
	
	# Get User String #
	li $v0, 8
	la $a0, buffer #buffer
	li $a1, 100  #max characters to read
	syscall
	move $s0, $v0  #save user string in $s0
	
	# Prompt User for Shift Amount #
	printString(getShiftAmount)
	
	# Get User Int #
	li $v0, 5
	syscall
	move $s7, $v0  #save shift in $s7
	mul $s7, $s7, -1 #multiply user shift by negative 1
	
	# Get address of user string and load into $t7 and load address of empty buffer into $t8
	la $t7, buffer
	la $t8, outputBuffer

# Loop through string character by character
deloop:
	#load a character of given user string into $t2
	lb $t2, 0($t7)
	
	# Shift charactere $t2 by $t7 which is the negative of the given user shift amount #
	shiftAscii($t2, $s7)
	sb $t2, 0($t8) #store shifted character, $t2, into outputBuffer $t8
	
	#increment address of user string and outputBuffer by 1
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	
	# Branch if "\n" is read
	beq $t2, 0x0a, decrypt_end
	
	# Branch at end of string
	beq $t2, 0x00, decrypt_end
	
	j deloop
	
#finished shifting all characters of string, output resulting plaintext
decrypt_end:
	# Print Out New String #
	printString(shiftedString)
	la $a0, outputBuffer
	syscall
	
	j Exit

# ask user if they want to increment shift by 1 or -1
Increment:
	#prompt user for positive or negative 1
	printString(increment)
	
	# Get user input
	li $v0, 5
	syscall
	move $s2, $v0 #save user input in $s1
	
	bne $s2, 1, decryptBy1
	bne $s2, -1, decryptBy1
	
	printString(invalidInput)
	j Increment
	
#user does not know shift amount, continuously increment shift by 1	
decryptBy1:
	# Prompt User for String #
	printString(getString)
	
	# Get User String #
	li $v0, 8
	la $a0, buffer #buffer
	li $a1, 100  #max characters to read
	syscall
	move $s0, $v0  #save user string in $s0
	
	# Get address of user string and load into $t7 and load address of empty buffer into $t8
	la $t7, buffer
	la $t8, outputBuffer

shift1:
	#load a character of given user string into $t2
	lb $t2, 0($t7)
	
	# Shift #
	shiftAscii($t2, $t5)
	sb $t2, 0($t8)
	
	#increment address of user string and outputBuffer by 1
	addi $t7, $t7, 1
	addi $t8, $t8, 1
	
	# Branch if "\n" is read
	beq $t2, 0x0a, again
	
	# Branch at end of string
	beq $t2, 0x00, again
	
	j shift1
	
again:
	# Print Out New String #
	printString(shiftedString)
	la $a0, outputBuffer
	syscall
	
	
	# Ask user if they want to shift again
	printString(shiftAgain)
	
	# Get user input
	li $v0, 5
	syscall
	move $s1, $v0 #store user input into $s1
	
	# Reload base address of user string into $t7 and reload base address of outputBuffer into $t8
	la $t7, buffer
	la $t8, outputBuffer
	# Add user increment to shift amount
	add $t5, $t5, $s2
	#shift by new amount if 1, exit program if 2
	beq $s1, 1, shift1
	beq $s1, 2, Exit
	
	# Invalid input
	printString(invalidInput)
	
	j again
	
#Exit program
Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program
