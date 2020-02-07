	.data 	
msg1:	.asciiz	"Enter an integer value for A: "
msg2:	.asciiz	"Enter an integer value for B: "
msg3:   .asciiz "A choose B = "
nl:     .asciiz	"\n"

	.text		
main:

   	# Print "Enter an integer value for A: "
        li 	$v0, 4             		# syscall 4 prints a string
	la 	$a0, msg1
	syscall	
        
       	# Read integer for A
        li 	$v0, 5	               		# syscall 5 reads an integer
	syscall
   
   	# move A into register $s0
        move 	$s0, $v0
        
        # Print "Enter an integer value for B: "
        li 	$v0, 4             		
	la 	$a0, msg2
	syscall	

	# Read integer for B
        li 	$v0, 5
	syscall
   
   	# move B into register $s1
        move 	$s1, $v0
        
        # if (A < 0 || B < 0), bad inputs detected.
        blt 	$s0, 0, bad_ending
        blt 	$s1, 0, bad_ending
        
        # if (A < B), special case:
       	blt 	$s0, $s1, special
        
        
        ## At this point, we know we our inputs are valid.
        ## The following calculations are the PEMDAS order of operations
        ## required to calculate A choose B, done one at a time.
        ## NOTE: (A choose B) == (A! / (B! * (A - B)!))
        
        
	li 	$s3, 0		# Initialize a variable to hold the final answer
	li 	$s4, 0		# Initialize a helper variable to help calculate the final answer
	
	# Calculate A - B
	sub	$s3, $s0, $s1

	# Calculate (A - B)!
	move 	$a0, $s3		# prepare argument ($s3)
	jal 	factorial		# Save current PC in $ra, and jump to factorial label
	move 	$s3, $v0		# factorial result stored in $v0. Move to $s3.
	
	# Calculate B!
	move 	$a0, $s1
	jal 	factorial
	move 	$s4, $v0		# move result of B! into helper register $s4
	
	# Calculate B! * (A - B)!
	mul 	$s3, $s4, $s3
	
	# Calculate A!
	move 	$a0, $s0
	jal 	factorial
	move 	$s4, $v0		# move result of A! into helper register $s4
	
	# Calculate A! / (B! * (A - B)!)
	div 	$s3, $s4, $s3
	
true_ending:	

	# Print "A choose B = "
        li	$v0, 4
	la	$a0, msg3
	syscall

	# Print A choose B
	li	$v0, 1
	move	$a0, $s3
	syscall

	# Print "\n"
	li	$v0, 4
	la	$a0, nl
	syscall


# Exit the program 
bad_ending:
	li	$v0, 10			# syscall 10 exits the program
	syscall	

# ------------------------------------------------------------------
	
	# The factorial function returns the factorial sum
	# of a nonnegative integer.

factorial:
	
        li	$t0, 1			# initialize loopCounter for factorial function
	li	$t1, 1			# initialize factorial sum for factorial function

	# use a while loop for calculating the factorial sum
	while_loop:
		blt	$a0, $t0, done	# condition - while(loopCounter >= inputValue)
 
		mul	$t1, $t1, $t0	# sum *= i
	       	addi	$t0, $t0, 1	# update counter
		
	        j 	while_loop

	done:
		move 	$v0, $t1	# Save the return value in $v0
	
		jr 	$ra		# Jump out of the function
	
special:
	li	$s3, 0
	j 	true_ending
