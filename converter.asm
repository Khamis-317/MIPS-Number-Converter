.data
	
currentSystem: .word    
number:        .asciiz
newSystem:     .word  
newNumber:     .asciiz
 
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

    # read input number
    la $a0, currentNumberMsg
    jal printMessage
    
    li $v0, 8       		 
    la $a0, number 	         # load address of (number)
    li $a1, 32      		 # max length
    syscall
    
    # read new system
    la $a0, newSystemMsg
    jal printMessage
    
    li $v0, 5           	
    syscall
    sw $v0, newSystem

    # Printing The Result
    la $a0, outputMsg
    jal printMessage
    la $a0, newNumber
    jal printMessage
    
    # Exit
    li $v0, 10
    syscall

# print function  
printMessage:
    li $v0, 4
    syscall
    jr $ra


