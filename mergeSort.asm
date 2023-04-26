# Name: Abigail Pinkus, 
# Date: May 12, 2023
# Program: Merge Sort: Final
# ~ main, Loop, Exit
# ~ Take in user input values for array size n. #
# ~ input/output #
# ~ break up array #
# ~ sort #
# ~ put together #
# ~ output #

# ~ step 1: start
# ~ step 2: declare array and left, right, mid variable
# ~ step 3: perform merge function.
    # ~ if left > right
        # ~ return
    # ~ mid= (left+right)/2
    # ~ mergesort(array, left, mid)
    # ~ mergesort(array, mid+1, right)
    # ~ merge(array, left, mid, right)
# ~ step 4: Stop

.macro userInput

.end_macro 

.macro breakArray(%arr)

.end_macro

.data
# Arrays to Sort #
array: .word 4,2,5,6,1,3
space: .space 48

.text
main:
	li $t0, 0
LoopUserInput:
	bge $t0, 6, AfterUserInput
	userInput
	# possibly write code to save int's here or in marco
	
	addi $t0, $t0, 1
AfterUserInput:
	

Exit:
	# Exit Program #
	li $v0, 10
	syscall
#end program