.data
	
currentSystem: .word
number:        .space 32
newSystem:     .word
newNumber:     .asciiz
digit_arr: .word

 
introductionMessage: .asciiz "Hello, This is Numbering System Converter. Please enter the current system, number and new system: \n"
currentSystemMsg: .asciiz "Enter The Current System: "
currentNumberMsg: .asciiz "Enter The Number: "
newSystemMsg: .asciiz "Enter The New System: "
outputMsg: .asciiz "\nThe Output Number: "

.text

main:
	la $a0, currentNumberMsg
	jal printMessage
    
	# read input number
	li $v0, 8       		 
	la $a0, number 	         # load address of (number)
	li $a1, 32      		 # max length
	syscall
    	
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
	la $t1, number	# number string base address
	li $t2, 0	# number offset (counter)
	la $t3, digit_arr # array's base address
	li $t4, 0	# array offset
	
	# get each digit's decimal value and saving it to an array
	digit_loop:
		add $t5, $t1, $t2	# adding offset to the base address
		lb $t6, 0($t5)		# loading the char base+offset
		
		beq $t6, '\n', digit_loop_end	# string end condition
		
		bgt $t6, '9', convert_alpha
		
		subi $t7, $t6, '0' 	
		
		append_arr:
			add $t8, $t3, $t4
			sw $t7, 0($t8)
			
			# printing each integer
			lw $a0, 0($t8)
			li $v0, 1
			syscall
		
			li $a0, '\n'
			li $v0, 11
			syscall
			
			addi $t4, $t4, 4	# add a word size to the offset
		
		
		addi $t2, $t2, 1		# move to the next byte address
		j digit_loop
		
	digit_loop_end:
		jr $ra	
		
# utility	
convert_alpha:
	# converting an alpha digit char to decimal
	subi $t7, $t6, 'A'
	addi $t7, $t7, 10 
	
	j append_arr





