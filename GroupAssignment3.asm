	.data 	
array:	.word	13, 37, 1337, 7331, 1, 3, 3, 7, 133, 7, 1, 337
				# array of 12 elements initialized.
				# array size in bytes = 12 * 4 = 48
				
msg1:	.asciiz	"Printing array...\n"
msg2:   .asciiz "Maximum = "
msg3:	.asciiz "Minimum = "
msg4:	.asciiz	"Mean = "
space:  .asciiz	" "
nl:     .asciiz	"\n"

	.text		
main:

	li 	$t0, 0		# Initialize a variable to hold the array pointer
	li 	$t1, 48		# Initialize a variable to hold the array size

	# Printing "Printing array...\n"
        li	$v0, 4
	la	$a0, msg1
	syscall
	
	jal 	printArray
	
	# Printing "\n"
        li	$v0, 4
	la	$a0, nl
	syscall
	
	li 	$t0, 0	
	
	lw	$s0, array($t0)		# Initialize 'maximum' variable, set equal to first element in array (13)
	lw	$s1, array($t0)		# Initialize 'minimum' variable, set equal to first element in array (13)
	li	$s2, 0			# Initialize 'mean' variable, set equal to 0
	
# Calculate the max, min, and mean in a single loop through the array
while1:
	bge	$t0, $t1, donzo		# condition - while(loopCounter >= inputValue)
 
	lw	$t2 , array($t0)	# load number from array
	ble	$t2, $s0, skipSetMax	# if (t2 > max), update max
	move	$s0, $t2
skipSetMax:
	bge	$t2, $s1, skipSetMin	# if (t2 < min), update min
	move	$s1, $t2
skipSetMin:
	add	$s2, $s2, $t2		# update sum, which will be divided after the while loop
		
	addi	$t0, $t0, 4		# update array pointer
	j 	while1

donzo:
	div	$s2, $s2, 12		# (sum of elements) / (# of elements)
	
	# Printing "Maximum = "
        li	$v0, 4
	la	$a0, msg2
	syscall
	
	# Print maximum
	li	$v0, 1
	move	$a0, $s0
	syscall
	
	# Printing "\n"
        li	$v0, 4
	la	$a0, nl
	syscall
	
	# Printing "Minimum = "
        li	$v0, 4
	la	$a0, msg3
	syscall
	
	# Print minimum
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	# Printing "\n"
        li	$v0, 4
	la	$a0, nl
	syscall
	
	# Printing "Mean = "
        li	$v0, 4
	la	$a0, msg4
	syscall
	
	# Print mean
	li	$v0, 1
	move	$a0, $s2
	syscall
	
	# Printing "\n"
        li	$v0, 4
	la	$a0, nl
	syscall

# Exit the program 
exit:
	li	$v0, 10			# syscall 10 exits the program
	syscall	

# ------------------------------------------------------------------
	
	# The printArray function prints the array
	# initialized at the beginning of the .asm file.

printArray:
	
	        li 	$t0, 0		# Reset the array pointer 

	# use a while loop for calculating the factorial sum
	while2:
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
		j 	while2

	done:

		# Return from function
		jr $ra			# Jump to addr stored in $ra
