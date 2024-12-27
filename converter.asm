.data

error_message_1: .asciiz " doesn’t belong to the "
error_message_2: .asciiz " System."	
currentSystem: .word 16
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
	#la $a0, introductionMessage
	#jal printMessage
	
	# read current system base
	#la $a0, currentSystemMsg
	#jal printMessage
	#li $v0, 5       
	#syscall
	#sw $v0, currentSystem
	
	la $a0, currentNumberMsg
	jal printMessage
	# read input number
	li $v0, 8       		 
	la $a0, number 	         # load address of (number)
	li $a1, 32      		 # max length
	syscall
    	

    	
  # read new system base
  #la $a0, newSystemMsg
	#jal printMessage
	#li $v0, 5           	
	#syscall
	#sw $v0, newSystem
	
  
  
	# To decimal conversion
	lw $a0, number	# argument 1
  lw $a1, currentSystem	# argument 2
	jal otherToDecimal	# take result from $v0
	
  #Decimal To Other
  lw $a0, $v0 
  jal decimalToOther
	
  #move $a0, $v0
	#li $v0, 1
	#syscall

	exit:
		li $v0, 10
		syscall


# print function  
printMessage:
	li $v0, 4
	syscall
	jr $ra
checking:
	comparing:
		la $t1, number	# number string base address
		li $t2, 0	# number offset (counter)
		la $t3, digit_arr # array's base address
		la $t4, currentSystem #load current system
		add $t5, $t1, $t2	# adding offset to the base address
		lb $t6, 0($t5)		# loading the char base+offset
		beq $t6, '\n', loop_end	# string end condition
		bgt $t6, '9', convert_alpha_for_checking
		bgt $t6,'F',exit_if_not_belong
		subi $t7, $t6, '0' 	# converting a char to integer
		ble $t4,$t7,exit_if_not_belong #if the system is less than or equal to the digit exit
		j comparing
		
	
	exit_if_not_belong:
		li $v0, 4
		la $a0, number
      		syscall
		li $v0, 4
		la $a0, error_message_1
      		syscall
      		
      		li $v0, 1
      		la $a0, currentSystem
      		syscall
      		
		li $v0, 4
		la $a0, error_message_2
      		syscall
		# exit
	        li $v0, 10
	        syscall
	loop_end:
		jr $ra
	   
	convert_alpha_for_checking:
	subi $t7, $t6, 'A'
	addi $t7, $t7, 10 
	jr $ra

otherToDecimal:
	la $a0, number	# number string base address
	li $t2, 0	# number offset (counter)
	la $t3, digit_arr # array's base address
	li $t4, 0	# array offset
	
	# get each digit's decimal value and saving it to an array
	digit_loop:
		add $t5, $a0, $t2	# adding offset to the base address
		lb $t6, 0($t5)		# loading the char base+offset
		
		beq $t6, '\n', digit_loop_end	# string end condition
		
		bgt $t6, '9', convert_alpha
		
		subi $t7, $t6, '0' 	# converting a char to integer
		
		append_arr:
			add $t8, $t3, $t4
			sw $t7, 0($t8)
			addi $t4, $t4, 4	# add a word size to the offset
		
		addi $t2, $t2, 1		# move to the next byte address
		j digit_loop
		
	digit_loop_end:
		li $t1, 0	# reusing register t1 for the sum	#############
		li $t4, 0	# reset the array offset
		subi $t2, $t2, 1	# to make the counter start at the value of the last index of digit_arr (digit_arr size-1)
		sum_loop:
			bltz $t2, end_sum	# end the loop when counter is < 0
			
			add $t8, $t3, $t4	# update base+offset
			lw $t9 ,0($t8)		# loading the value from address
			
			move $t5, $t2	# power loop counter initialized with digit_arr size-1
			li $t6, 1	# power result initialize with 1
			power_loop:
				beqz $t5, end_power
				mul $t6, $t6, $a1	# multiplying result by the current system base
				subi $t5, $t5, 1
				j power_loop
			
			end_power:
			mul $t7, $t9 ,$t6	# multiplying each digit with current system power the digit index
			add $t1, $t1, $t7	# add the above result to the sum
			
			addi $t4, $t4, 4	# increment the offset by word size
			subi $t2, $t2, 1	# decrement counter (initially = array_size - 1)
			j sum_loop
		end_sum:
		move $v0, $t1 
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
		
		
		
		
		
	
	
	
