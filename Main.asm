# Program FIles: Main.asm
# Author: M4zek
# The program reads in 5 numbers and checks if they are prime numbers.

.data
array: .space 1024
message: .asciiz "The program reads in 5 numbers and checks if they are prime numbers. \n\nPlease feed the numbers into the array: \n"
repeatMSG: .asciiz "\nRepeat the program?\nY-Yes, N-No."
info: .asciiz "-----------------------------------\nYes! - is a prime number\nNo! - Is not a prime number \n-----------------------------------\n"
fileName: .asciiz "results.txt"

.text
main:
	la $a0, fileName	# Loading a file name
	jal openFile		# opening a file for writing

	la $a0, message		# Load address into message
	jal printMessage	# Jump to subroutines 
	
	la $a2, array		# Loading the array address
	li $a1, 0		# Declare index to loop
	jal loadData		# Jump to a subroutine that loads data into an array

	la $a0, info		# Loading the address into the string from under the info label
	jal printMessage	# Write out the string from under the info

	la $a0, array		# Loading the array address
	li $a1, 0		# Declare index to loop
	jal checkTheNumbers	# Jump to number check
	
	jal closeFile		# Jump to close file
	
	la $a0, repeatMSG	# Loading the address from under repeatMSG to $a0
	jal printMessage	# Write string from under repeatMSG
	
	jal orRepeat		# Jump to a subroutine asking whether to repeat the program
	
	j Exit			# Jump to program exit
	
.data
.include "utils.asm"
