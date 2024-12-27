.data
	
currentSystem: .word 0
number:        .space 32
newSystem:     .word 0
newNumber:     .asciiz
digit_arr: .word 32
result: .space 32
 
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
    	
    	#output currentSystem input message
    	la $a0, currentSystemMsg
    	jal printMessage
  
    	
    	#read current system of the number
    	li $v0, 5
    	syscall
    	sw $v0, currentSystem
    	
    	#output newSystem input message
    	la $a0, newSystemMsg
    	jal printMessage
  
  	#read newSystem 
  	li $v0, 5
  	syscall
  	sw $v0, newSystem
    	
    	
	#jal otherToDecimal
	
	
 	li $a0, 61
    	jal decimalToOther
    	
    	la $a0, result
    	jal printMessage
    	
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




#Decimal to Other 
decimalToOther:
	
	move $t1, $a0 #decimal number
	la $t2, result #base address of result
	
	li $t3, 0 #offset for result
	
	lw $t4, newSystem
	
	
	loop:
		beq $t1, $zero, end_loop
	
		div $t1, $t4  #number divided by newSystem
	
		mflo $t1 #quotient
		mfhi $t5 #reminder to append in result
	
	
		#convert reminder to char
		bgt $t5, 9, convert_to_char
		addi $t5, $t5, 48
		j append_to_result
	
		convert_to_char:
		addi $t5, $t5, 55
	
		append_to_result:
		add $t6, $t2, $zero
		add $t6, $t6, $t3
		sb  $t5, 0($t6) 
	
		addi $t3, $t3, 1 #increment length
	
		j loop
	
	end_loop:
		add $t6, $t2, $zero
		add $t6, $t6, $t3
		sb $zero, 0($t6) #terminate the string
		add $a0, $t2, $zero
		move $a1, $t3
		j reverse_string
		
reverse_string:
	move $t0, $a0 #result base addresss
	move $t1, $a1 #length
	li $t2, 0 # i start iterator
	subi $t3, $t1, 1 #j end iterator
	
	reverse_loop:
	
		bge $t2, $t3, reverse_end #i>=j
		
		add $t4, $t0, $t2  #  index i  
		add $t5, $t0, $t3  # index j
		
		lb $t6, 0($t4)  #store from memory to register 
		lb $t7, 0($t5) #store from memory to register 
		 
		sb $t7, 0($t4)  #store from register to memory 
		sb $t6, 0($t5)  #store from register to memory 
		
		#move i and j
		addi $t2, $t2, 1
		addi $t3, $t3, -1
		j reverse_loop
		
	reverse_end:
	jr $ra
		
		
		
		
		
	
	
	
	