	.data 	
array:	.word	 7331, 13, 37, 1337, 1, 3, 3, 7, 133, 7, 1, 337
				# array of 12 elements initialized.
				# array size in bytes = 12 * 4 = 48
				
msg1:	.asciiz	"Printing array BEFORE selection sort...\n"
msg2:   .asciiz "Printing array AFTER selection sort...\n"
space:	.asciiz " "
nl:     .asciiz	"\n"

	.text		
main:

	li 	$t0, 0		# Initialize a variable to hold the array pointer
	li 	$t1, 48		# Initialize a variable to hold the array size

	# Print "Printing array BEFORE selection sort...\n"
        li	$v0, 4		# syscall 4 prints a string
	la	$a0, msg1
	syscall
	
	jal 	printArray
	
	# Print "\n"
        li	$v0, 4
	la	$a0, nl
	syscall
		
	jal	selectionSort
		
	# Print "Printing array AFTER selection sort...\n"
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
		jr	$ra			# Jump to addr stored in $ra


# ------------------------------------------------------------------

	# The selectionSort function organizew the contents of
	# an array (in ascending order) via a selection sort
	# algorithm.
	
selectionSort:
	
	li 	$s0, 0			# int i
	li 	$s1, 0			# int j
	li	$t2, 0			# int min 
	la	$t3, ($t1)		# int n = (arraySize - 4), for 'outer' loop
	sub	$t3, $t3, 4
	
	outerLoop:
		bge	$s0, $t3, doneOuter	# for (i, i < n, i++)
	
		move 	$t2, $s0		# min = i
	
		move 	$s1, $s0		# j = i + 4
		addi	$s1, $s1, 4
	
	
		innerLoop:
			bge	$s1, $t1, doneInner	# for (j = i + 1; j < arraySize, j++)
	
			lw	$t4, array($s1)
			lw	$t5, array($t2)
			bge	$t4, $t5, skipMinAssign	# if (arr[j] < arr[min])
			move	$t2, $s1		# min = j
	
		skipMinAssign:	
			addi	$s1, $s1, 4		# j += 4
			j	innerLoop
	
	doneInner:	
	
		# perform the swap 
		lw	$t6, array($t2)
		lw	$t7, array($s0)
		sw	$t6, array($s0)
		sw	$t7, array($t2)
	
		addi	$s0, $s0, 4		# i += 4
		j	outerLoop
doneOuter:	
	jr 	$ra