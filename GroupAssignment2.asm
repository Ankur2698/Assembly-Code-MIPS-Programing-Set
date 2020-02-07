# The program prints an extra comma, whatever, fight me

	.data 		
msg1:	.asciiz	"Enter an integer value: "
msg2:	.asciiz	"Prime Factors (if any) = "
comma:  .asciiz	", "
nl:	.asciiz "\n"

	.text		
main:

   	# Print "Enter an integer value: "
        li	$v0, 4             		# syscall 4 prints a string
	la	$a0, msg1
	syscall	
        
       	# Read integer value n
        li	$v0, 5	               	# syscall 5 reads an integer
	syscall
   
   	# move n into register $s0
        move	$s0, $v0
        
        # if (n < 1), bad input detected.
        # NOTE: To return a successful prime factorization,
        # n cannot be less than 1.
        blt	$s0, 1, exit
        
        # At this point, we know we our inputs are valid.
        # Print "Prime Factors (if any) = "
        li	$v0, 4             		
	la	$a0, msg2
	syscall	
	
	
	li	$t2, 2
while_loop1:
        div	$s0, $t2
       	mfhi	$t0
        bne	$t0, 0, exit_while_loop1
	div	$s0, $s0, 2
	
	# Print 2
	li	$v0,1			# syscall 1 prints an integer
	move	$a0, $t2
	syscall

	# Print ", "
	li	$v0,4
	la	$a0, comma
	syscall
	
	j	while_loop1

exit_while_loop1:


	li	$t0, 3
for_loop:
	bgt	$t0, $s0, exit_for_loop
	while_loop2:
		div	$s0, $t0
		mfhi	$t1
		bne	$t1, 0, exit_while_loop2
		div	$s0, $s0, $t0
		
		# Print $t0
		li	$v0, 1			# syscall 1 prints an integer
		move	$a0, $t0
		syscall

		# Print ", "
		li	$v0, 4
		la	$a0, comma
		syscall
		
		j	while_loop2
		
exit_while_loop2:

	add	$t0, $t0, 2
	j	for_loop
	
exit_for_loop:

# Exit the program 
exit:
	li	$v0, 10			# syscall 10 exits the program
	syscall	