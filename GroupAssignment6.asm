	.data 	
array:	.word	 7331, 13, 37, 1337, 1, 3, 3, 7, 133, 7, 1, 337
				# array of 12 elements initialized.
				# array size in bytes = 12 * 4 = 48
				
msg1:	.asciiz	"Printing array BEFORE insertion sort...\n"
msg2:   .asciiz "Printing array AFTER insertion sort...\n"
space:	.asciiz " "
nl:     .asciiz	"\n"

	.text		
main:

	li 	$t0, 0		# Initialize a variable to hold the array pointer
	li 	$t1, 48		# Initialize a variable to hold the array size

	# "Printing array BEFORE selection sort...\n"
        li	$v0, 4
	la	$a0, msg1
	syscall
	
	jal 	printArray
	
	# "\n"
        li	$v0, 4
	la	$a0, nl
	syscall
	
	
	jal	insertionSort
	
	
	# "Printing array AFTER selection sort...\n"
        li	$v0, 4
	la	$a0, msg2
	syscall
	
	jal 	printArray
	
# Exit the program 
exit:
	li	$v0, 10			# syscall 10 exits the program
	syscall	

# ------------------------------------------------------------------
	
	# The factorial function returns the factorial sum
	# of a nonnegative integer.

printArray:
	
	li 	$t0, 0		# Reset the array pointer 

	# use a while loop for calculating the factorial sum
	while_loop:
		beq	$t0, $t1, done	# condition - while(loopCounter >= inputValue)
 
		# Print number from array
		lw	$t2 , array($t0)
		li	$v0, 1
		move	$a0, $t2
		syscall
		
		# "Printing array BEFORE selection sort...\n"
        	li	$v0, 4
		la	$a0, space
		syscall
		
	       	addi	$t0, $t0, 4	# update array pointer
		j	while_loop

	done:

		# Return from function
		jr	$ra


# ------------------------------------------------------------------

	# The selectionSort function organizew the contents of
	# an array (in ascending order) via a selection sort
	# algorithm.
	
insertionSort:
	
	li 	$s0, 4			# int i
	li 	$s1, 0			# int j
	li	$t2, 0			# int key 
	
	outerLoop:
		bge	$s0, $t1, doneOuter	# for (i, i < n, i++)
	
		move	$s1, $s0		# j = i - 4
		sub	$s1, $s1, 4
	
		lw	$t2, array($s0) 	# key = array[i]
	
		whileLoop:
			lw	$t3, array($s1) 	# t3 = array[j]
			move	$t4, $s1		# t4 = j + 4
			addi 	$t4, $t4, 4 
	
			blt	$s1, 0, doneWhile	# while (j >= 0 
			ble	$t3, $t2, doneWhile	#        && array[j] > key)
	
			lw	$t5, array($s1)
			sw	$t5, array($t4)
			sub	$s1, $s1, 4
			j	whileLoop
	
	doneWhile:	
	
		sw 	$t2, array($t4)
	
		addi	$s0, $s0, 4		# i += 4
		j	outerLoop
	
doneOuter:	
	jr 	$ra