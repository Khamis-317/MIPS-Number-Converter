.data
	
currentSystem: .word    
number:        .asciiz
newSystem:     .word  
newNumber:     .asciiz
digit_arr:	.word
 
introductionMessage: .asciiz "Hello, This is Numbering System Converter. Please enter the current system, number and new system: \n"
currentSystemMsg: .asciiz "Enter The Current System: "
currentNumberMsg: .asciiz "Enter The Number: "
newSystemMsg: .asciiz "Enter The New System: "
outputMsg: .asciiz "\nThe Output Number: "

.text

main:
	la $a0, introductionMessage
	jal printMessage

	la $a0, currentSystemMsg
	jal printMessage
    
	# read current system
	li $v0, 5       
	syscall
	sw $v0, currentSystem

	la $a0, currentNumberMsg
	jal printMessage
    
	# read input number
	li $v0, 8       		 
	la $a0, number 	         # load address of (number)
	li $a1, 32      		 # max length
	syscall
    
	la $a0, newSystemMsg
	jal printMessage
    
	# read new system
	li $v0, 5           	
	syscall
	sw $v0, newSystem
    
	lw $t0, currentSystem
    	
	jal otherToDecimal
    
	# exit
	li $v0, 10
	syscall

# print function  
printMessage:
	li $v0, 4
	syscall
	jr $ra

otherToDecimal:
	la $t2, number	# number base address
	la $t5, digit_arr
	
	# get each digit's decimal value and saving it to an array
	digit_loop:
		lb $t3, 0($t2)	# load a char into register
		beqz $t3, digit_loop_end	# exit the loop when char is '\0'

		
		bgt $t3, '9', convert_alpha
		
		sub $t4, $t3, '0'	# converting a digit char to integer
		
		append_arr:
			sw $t4, ($t5)	# storing the digit into digit_arr
			sll $t5, $t5, 2	# move to the next word address
		
		addi $t2, $t2, 1	# increment the address by 1 byte
		j digit_loop
		
	digit_loop_end:	
		la $t6, digit_arr
		reverse_loop:
			subi $t2, $t2, 1  # decrement the counter (initially equal to array size)
			bltz $t2, end
			sll $t7, $t2, 2		# offset from base address
			add $t8, $t6, $t7 	# current index address
			# print the value
			lw $a0, ($t8)
			li $v0, 1 # Syscall code for print integer
			syscall
			# print a newline
			lw $a0, '\n'
			li $v0, 11
			syscall
			
			j reverse_loop
		end:
			jr $ra

# utility	
convert_alpha:
	sub $t4, $t3, 'A'	# converting an alpha digit char to integer
	addi $t4, $t4, 10
	j append_arr




