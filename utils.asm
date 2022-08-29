# Subroutine that loads data from the user into an array
.text
loadData:
	move $s7, $ra		# Move the return address to $s7
while:
	beq $a1, 5 , done	# If $t1 == 5 then jump to next
	
	la $a0, giveTheNumberMSG	# Loading the address from under the string giveTheNumberMSG
	jal printMessage		# Jump to printMessage subroutine
	
	# Loading a number from the user into the array
	li $v0,5		# Loading code 5 for syscall
	syscall	
	move $s0, $v0		# Transfer the loaded number from the user to $s0

	sw $s0, 0($a2)		# Write the number to the array at the given address
	addi $a2, $a2, 4	# Increase address by 4
	
	addi $a1, $a1 1		# Increasing the index in the loop by 1
	j while			# Jump to the while label
done:
	move $ra, $s7		# Move the return address to $ra from $s7
	jr $ra			# Jump back

#-----------------------------------------------------------------------

# Subroutine extracts data from the array and passes it to the isPrimeNumber function
.text
checkTheNumbers:
	move $t1, $a1		# Move iterator to $t1
	move $t0, $a0		# Move the address of the array to $t0
	move $s7, $ra		# Move the return address to $s7

while2:	
	beq $t1, 5 ,done2	# Jump to done if $t1 == 10
	lw $a1, 0($t0)		# Read a number from the array
		
	li $a0, 2		# Charging the divider															
	jal isPrimeNumber	# Jump to check if a number is prime
																																															
	addi $t0, $t0, 4	# Adding 4 to an array address
	addi $t1, $t1 1		# Increasing the index in the loop by 1
	j while2		# Jump back to the while2 loop
			
done2:
	move $ra, $s7		# Move the return address to $ra from $s7
	jr $ra			# Jump back
#-------------------------------------------------------------------------


# A subroutine to check if a number is prime
.text
isPrimeNumber:
	move $s6, $ra		# Moving the return address to $s6
	
	beq $a1, 1, no		# If the number in the array = 1 then jump under 'no' 
	beq $a1, $a0, yes	# Does $s0 == $s1 if yes then jump under 'yes'
	div $a1, $a0		# dividing a number by n
	mfhi $t7		# shift to $t7 the remainder of the division
	beq $zero, $t7, no	# If 0 == $t7(remainder of division) then jump to "no"
	addi $a0, $a0, 1	# $s1 = $s1 + 1
	j isPrimeNumber		# Jump under "isPrimeNumber"
	
	# Write out the string from under the false label and save it to a file
	no:			
	move $a0, $a1		# Move the number from $a1 to $a0
	li $v0, 1		# Syscall 1 write integer
	syscall			# Write out integer

	jal converter		# Jump to the subroutine that converts a number (string) to a digit			
	la $a0, ($v0)		# Load address from under $v0
	jal saveToFile		# Jump to subroutine that writes to file
	
	
	li $v0, 4		# Syscal 4 write out string
	la $a0, false		# Loading address into string false
	syscall			# Calling syscall
	jal saveToFile		# Jump to subroutine that writes to file with argument $a0 = false
		
	move $ra, $s6		# Move the return address to the $ra register
	jr $ra			# Jump back
	
	# Write out the string from under the true label and save it to a file
	yes:
	move $a0, $a1		# Move the number from $a1 to $a0
	li  $v0, 1		# Syscall 1 write out integer
	syscall			# Write out integer
	
	jal converter		# Jump to the subroutine that converts a number (string) to a digit	
	la $a0, ($v0)		# Load address from under $v0
	jal saveToFile		# Jump to subroutine that writes to file
	
	li $v0, 4		# Syscal 4 write out string
	la $a0, true		# Loading address into string true
	syscall			# Calling syscall
	jal saveToFile		# Jump to subroutine that writes to file with argument $a0 = false
	
	move $ra, $s6		# Move the return address to the $ra register
	jr $ra			# Jump back
# ---------------------------------------------------------------


.text
# ---------- ELABORATIONS ON THE FILE ----------
# Subroutine that opens a file
openFile:			# Open file
	li $v0, 13		# Loading 13 for syscall
	li $a1, 9		# File opening argument ( write with file creation or overwrite )
	syscall			# Calling syscall
	move $s4, $v0		# Move descriptor to $s4
	jr $ra			# Jump to the call site
	
saveToFile:			# Save to file

	move $t9, $a0
	move $a0, $s4		# Move descriptor to $a0
	li $v0, 15		# Load argument for syscal 15 write to file
	la $a1, ($t9)		# Loading the value to be saved
	li $a2, 6		# Setting the length of characters to be written
	syscall			# Calling the syscall service
	jr $ra			# Jump back to the call site

closeFile:			# Close file
	li $v0, 16		# Syscall service #16 closing file
	move $a0, $s4		# Transfer of descriptor to $a0
	syscall			# Calling syscall
	jr $ra			# Jump to the call site
# --------------------------

# Subroutine that prints out a string
.text
printMessage:
	li $v0, 4		# Loading 4 as an argemtn for string printing
	syscall			# Calling the syscall service
	jr $ra			# Jump to where the printMessage subroutine was called
#------------------------------

# The subroutine checks whether the user wants to repeat the program's action.
.text
orRepeat:
	li $v0,12		# Loading parameter 12 for syscall
	syscall			# Calling syscall
	move $a0, $v0		# Transferring the read character to $a0
	beq $a0, 89, main	# Check if $a0 == 89 or 121 if yes jump to main
	beq $a0, 121, main
	jr $ra			# Jump back to where the subroutine was called
# --------------------------------------------------------------------

.text
# Subroutine to close the program
.text
Exit: 
	li $v0,10		# Adopting command 10 for syscall corresponding to program termination
	syscall			# Calling syscall
#------------------------------

.text
converter:

	la $v0, buffer		# Load str address into $v0
	addiu $v0, $v0, 7	# v0 = end of str indicator
	li $a3, 10		# Initialization $a1 = 10

# The subroutine that converts our integer to a string
int2str:		
	divu $a0, $a3		# dividing $a0 by 10
	mflo $a0		# $a0 = product
	mfhi $t3		# $t0 = rest (0 to 9) 
	addiu $t3, $t3, 48	# digit to character conversion
	addiu $v0, $v0, -1	# indicate previous sign
	sb $t3, ($v0)		# storte byte: memory($v0) = $t3
	bnez $a0, int2str	# Returns to petrol ifiloraz no is zero

	jr $ra			# jump to call

# ---------------------------------------------------

.data
buffer: .word 50
endBuffer: .space 100
true: .asciiz " Yes!\n"
false: .asciiz " No!\n"
giveTheNumberMSG: .asciiz "Give the number: "
