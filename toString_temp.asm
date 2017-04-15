############################################
# Data Segment
# messages
############################################  

###########################################
#Group members:
#Hilal KÖKTÜRK
#Deniz Merve GÜNDÜZ
###########################################

.data
input_msg:
.asciiz "Enter integer (from -2^31 + 1 to 2^31 - 1): "
output_msg:
.asciiz "The integer is: "
int_str: .space 48
int:    .space 4

############################################
# Text Segment
# routines
############################################  
############################################
# Main Routine  
############################################  
.text
main:
la $a0, input_msg 
jal print_str 
jal read_int # read the input
add $a0, $zero, $v0 
la $a1, int_str # load the space for the first string into register
# $a0 contains the integer  
jal toString
# print integer a string.
la $a0, int_str
jal print_str
addi $a0, $zero, '\n' # print a newline
j exit # exit
exit:
addi $v0, $zero, 10 # system code for exit
syscall # exit gracefully
############################################
# I/O Routines
############################################
print_str: # $a0 has string to be printed
addi $v0, $zero, 4 # system code for print_str
syscall # print it
jr $ra # return
print_int: # $a0 has number to be printed
addi $v0, $zero, 1 # system code for print_int
syscall
jr $ra

read_int: # $v0 contains the read int
addi $v0, $zero, 5 # system code for read_int
syscall 
jr $ra 

#########  toString routine

toString: 
# $a0 has the integer.
addi $a2,$zero,10 	 #a2 equals to 10 and it is divider
div $a0,$a2      	 #we divide a0 to a2 (a0/a2)
mflo $a3  		 #division is at a3 now
mfhi $s0  		 #remainder is at s0 and it equals to last digit
addi $s0, $s0, 48 	 #s0 equals to ascii value of s0 now
sb $s0, 0($sp)   	 #we send the value of s0 to stack
addi $sp, $sp, 1 	 #we increase the pointer value of stack
add $t2, $zero, $sp	 #t2 equals to sp now

loop: 
div $a3,$a2 		 #we divide a3 which is division to a2 (a3/a2) (a3/10)
mflo $a3   		 #a3 becomes to new division for every loop
mfhi $s0    		 #s0 becomes new remainder for every loop
addi $s0,$s0,48		 #s0 equals to ascii value of s0 now
sb $s0,0($sp)   	 #we send the value of s0 to stack
addi $sp, $sp, 1 	 #we increase the pointer value of stack
bne $a3,$zero,loop 	 #when division not equal to 0 it will return to loop

pop:
lb $t1,-1($sp)		#we pop from the stack 
sb $t1, 0($a1)		#we load from stack and we store to a1
addi $sp, $sp, -1	#we decrease sp 1
addi $a1, $a1, 1	#we increase a1 1
bne $t2,$sp, pop	#when t2 is not equal to sp it will return to pop
jr $ra