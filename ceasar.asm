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

.macro shiftAscii(%int, %shift)
add $t3, %int, %shift
bge $t3, 90, Lowercase
Loop:
# Exit if Number is in Range #
ble $t3, 91, After

# Bring Character Back to 'A' #
li $t4, 26 #save number 26
sub $t3, $t3, $t4

# Loop #
j Loop

Lowercase:
ble $t3, 148, After

# Bring Character Back to 'a' #
li $t4, 26 #save number 26
sub $t3, $t3, $t4

# Loop #
j Lowercase

After:
li $v0, 4
la $a0, newLine
syscall
syscall
.end_macro 

.data
getString: .asciiz "\nEnter a string: "
getShiftAmount: .asciiz "\nEnter a shift amount: "
fillerString: .asciiz  "\nThis is a fake output string"
buffer: .space 150
string: .asciiz "hello there!"
newLine: .asciiz "\n"

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
	li $v0, 1
	move $a0, $t3
	syscall
	
	addi $t7, $t7, 1
	
	# Branch if "\n" is read
	#beq $t2, 0x0a, Exit
	
	# Branch at end of string
	beq $t2, 0x00, After
	
	j loop
	
After:
	# Print Out New String #
	
Output:
	
	# filler code #
	la $s1, fillerString
	
	# Assumed Output with no Middle (for now) #
	li $v0, 4
	move $s1, $a0
	syscall
Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program
