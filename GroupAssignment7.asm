	.data 		
array:  .space  40		# initialized with space for 10 elements max (40 bytes total, 4 bytes per integer)
msg1:	.asciiz	"Initializing 'hardcoded' array to be binary searched...\n"
msg2:	.asciiz	"ArraySize = 10\nArray = {0, 4, 8, 12, 16, 20, 24, 28, 32, 36}\n"
msg3:	.asciiz "Enter an integer to binary search within the array: "
msg4:	.asciiz	"Binary Search successful! Element found at position: "
msg5:	.asciiz	"Binary Search unsuccessful... Element not found >_< \n"
msg6:	.asciiz	"Try again? (1 = YES, any other integer = NO) "
nl:     .asciiz	"\n"

	.text	
main:
	# Print "Initializing 'hardcoded' array to be binary searched...\n"
        li 	$v0, 4             	# syscall 4 prints a string
	la 	$a0, msg1
	syscall	
        
        li	$s0, 40			# initialize hardcoded arraySize
        jal	InitializeArray		# initialize hardcoded array

doSearch:

	# Print "ArraySize = 10\nArray = {0, 4, 8, 12, 16, 20, 24, 28, 32, 36}\n"
        li 	$v0, 4
	la 	$a0, msg2
	syscall	
	
	# Print "Enter an integer to binary search within the array: "
        li 	$v0, 4
	la 	$a0, msg3
	syscall	

	# Read integer for search
        li 	$v0, 5	               	# syscall 5 reads an integer
	syscall
	
	# move value into $s0
	move 	$s0, $v0		# initialize 'key'
	li	$s1, 0			# initialize lowerBound
	li	$s2, 9			# initialize upperBound
	li	$s3, 0			# initialize middle

	jal	BinarySearch
	
	# Determine result of binary search (result stored in $v0)
	beq	$v0, -1, fail
	
	# Print "Binary Search successful! Element found at position: "
        li 	$v0, 4
	la 	$a0, msg4
	syscall	
	
	# Print middle index
	li	$v0, 1
	move	$a0, $s3
	syscall
	
	# Print "\n"
        li 	$v0, 4
	la 	$a0, nl
	syscall	
	
	j	searchDone
	
									
fail:
	# Print "Binary Search unsuccessful... Element not found >_< \n"
        li 	$v0, 4             	# syscall 4 prints a string
	la 	$a0, msg5
	syscall	


searchDone:
	# Print "Try again? (1 = YES, any other integer = NO) "
        li 	$v0, 4
	la 	$a0, msg6
	syscall	
	
	# Read integer for retry
        li 	$v0, 5	               	# syscall 5 reads an integer
	syscall
	
	# jump to beginning of search if user input == "1"
	beq	$v0, 1, doSearch


# Exit the program 
exit:
	li	$v0, 10			# syscall code 10 exits the program
	syscall

#-------------------------------------------------------

	# Function: InitializeArray
	# Fills the hardcoded 40-byte array 
	# with the sorted set of integers:
	# {0, 4, 8, 12, 16, 20, 24, 28, 32, 36}
	
InitializeArray:
	li	$t0, 0			# loop counter
	
initLoop:
	bge	$t0, $s0, endInit	# while(loopCounter < arraySize)
	sw	$t0, array($t0)		# array[loopCounter] = loopCounter
	addi	$t0, $t0, 4		# loopCounter + 4
	j	initLoop
	
endInit:
	jr 	$ra			# Jump to addr stored in $ra
	
	
#-------------------------------------------------------

	# Function: BinarySearch
	# Searches for a particular integer (key) 
	# within the sorted 40-byte array of integers:
	# {0, 4, 8, 12, 16, 20, 24, 28, 32, 36}
	
BinarySearch:
	# calculate middle = lowerBound + (upperBound - lowerBound) / 2
    	sub 	$t0, $s2, $s1		# 1) (upperBound - lowerBound)
    	div	$t0, $t0, 2		# 2) (upperBound - lowerBound) / 2
    	add	$t0, $t0, $s1		# 3) lowerBound + (upperBound - lowerBound) / 2
    	# update middle
    	move	$s3, $t0
    	
    	# 'address-friendly' middle (multiple of 4)
    	mul	$t0, $t0, 4
	
	# set up stack pointer, and save current address in $ra to it
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	
	# base case - if (upperBound < lowerBound), notFound
	blt	$s2, $s1, notFound
	
	lw	$t1, array($t0)		# $t1 = array[middle]
	
	beq	$t1, $s0, Found		# if (key == arr[middle])
	blt	$s0, $t1, searchLower	# if (key < arr[middle])
	bgt	$s0, $t1, searchUpper	# else (key > arr[middle])
	
notFound:
	li	$v0, -1			# return -1
	j	endSearch
	
Found:
	move	$v0, $s3		# return middle
	j	endSearch
	
searchLower:
	move	$t3, $s3		# temp = middle     
	subi	$t3, $t3, 1		# temp --
	move	$s2, $t3		# end = temp
	jal	BinarySearch
	j	endSearch
	
searchUpper:
	move	$t3, $s3		# temp = middle
	addi	$t3, $t3, 1		# temp++
	move	$s1, $t3		# start = temp
	jal	BinarySearch
	j	endSearch
	
endSearch:
	# Load Address from $sp, move back up the stack, and 'unravel' recursion
    	lw 	$ra, ($sp)
    	addi 	$sp, $sp, 4
	jr	$ra