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
blt %int, 65, Fail
ble %int, 90, Uppercase
ble %int, 122, Lowercase
Uppercase:
li $t6, 1 #1 = uppercase
j After
Lowercase:
blt %int, 97, Fail
li $t6, 2 #2 = lowercase
j After
Fail:
li $t6, 0 #0 = not a letter

After:
# Testing Print #
li $v0, 4
la $a0, check
syscall
li $v0, 1
move $a0, $t6
syscall
.end_macro 

# The loop ensures that the shift is actually shifted by the user's amount. 
# If the shift amount entered is greater than 26, the shift is looped more than once. (it only needs to loop by divisions of 26)
.macro shiftAscii(%int, %shift)
isValidLetter(%int)
# Check if Char is a Letter #
beq $t6, 0, After

# Add by Shift Amount #
add $t2, %int, %shift

# Check if Lowercase or Uppercase #
beq $t6, 2, Lowercase
beq $t6, 1, Uppercase #unnecessary (just for certainty)

# Loop for Uppercase #
Uppercase:
# Exit if Number is in Range #
ble $t2, 91, After

# Bring Character Back to 'A' #
li $t4, 26 #save number 26
sub $t2, $t2, $t4

# Loop #
j Uppercase

# Loop for Lowercase #
Lowercase:
ble $t2, 122, After

# Bring Character Back to 'a' #
li $t4, 26 #save number 26
sub $t2, $t2, $t4

# Loop #
j Lowercase

After:
# Testing #
# Print newLine #
li $v0, 4
la $a0, newLine
syscall
syscall
# Print New Shifted Ascii Number #
li $v0, 1
move $a0, $t2
syscall
# Print newLine #
li $v0, 4
la $a0, newLine
syscall
.end_macro 

.data
getString: .asciiz "\nEnter a string: "
getShiftAmount: .asciiz "\nEnter a shift amount: "
buffer: .space 150
string: .asciiz "hello there!"
newLine: .asciiz "\n"
check: .asciiz "\nCheck number: "

.text
main:
Input:
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
	#la $t7, string
	move $t7, $a0
loop:
	lb $t2, 0($t7)
	
	printAscii($t2)
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	# Shift #
	shiftAscii($t2, $s7)
	
	addi $t7, $t7, 1
	
	# Branch if "\n" is read
	#beq $t2, 0x0a, Exit
	
	# Branch at end of string
	beq $t2, 0x00, After
	
	j loop
	
After:
	# Print Out New String #
	
Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program
