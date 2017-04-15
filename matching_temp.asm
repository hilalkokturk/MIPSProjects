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
input_msg1:
    .asciiz    "Enter the string: "
input_str1:
    .space 48
newline:
    .asciiz "\n"
msg1: "\n 1 \n"
msg2: "\n -1 "
        
############################################
# Text Segment
# routines
############################################  
############################################
# Main Routine                
############################################  
    .text
main:
    la    $a0, input_msg1        # load the first input message
    jal    print_str        # print the input prompt
    
    la    $a0, input_str1        # load the space for the first string into register    
    addi    $a1, $zero, 48      # the length of the string is 48
    jal    read_str        # read the input
    add    $s0, $a0, $zero        
    
    # TODO                                
    add    $a0, $s0, $zero        # save second string address for compare
    jal    match    
    
    add    $a0, $v0, $zero        # prepare the cmp result for printing
    jal    print_int        # print it
    
    addi    $a0, $zero, '\n'    # print a newline
    j    exit            # exit
    
exit:
    addi    $v0, $zero, 10        # system code for exit
    syscall                # exit gracefully

############################################
# I/O Routines
############################################
print_str:                # $a0 has string to be printed
    addi    $v0, $zero, 4        # system code for print_str
    syscall                # print it
    jr     $ra            # return
    
    
print_int:                # $a0 has number to be printed
    addi    $v0, $zero, 1        # system code for print_int
    syscall
    jr     $ra
    

read_str:                # address of str in $a0,     
                    # length is in $a1.
    addi    $v0, $zero, 8        # system code for read_str
    syscall
    jr     $ra    
##############################################
# match Routine       
# $a0: memory address of the str1. 
# $v0:-1 if the str1 contains unknown characters and if it is unbalanced, 
#     1  if it is balanced  
##############################################      
match:
                            
    addi $t0, $zero, 0 #left bracket count
    addi $t1, $zero, 0 #right bracket count
    
    checkconditions:
    lb $t2,0($a0) #load from a0 to t2
    addi $a0,$a0,1 #increase the value which shows from a0 
    beq $t2, '(', LeftBracket #if t2=='(' go to LeftBracket Method
    beq $t2, ')', RightBracket #if t2==')' goto RightBracket Method
    beq $t0,$t1,EqualCount #if t0(Left bracket count) == t1 (Right bracket count) go to EqualCount Method
    bne $t0,$t1,NotEqualCount #if t0(Left bracket count) != t1 (Right bracket count) go to NotEqualCount Method
    
    LeftBracket: addi $t0,$t0,1 #increase t0(Left bracket count)
    j checkconditions #jump checkconditions
    RightBracket: addi $t1,$t1,1 #increase t1(Right bracket count)
    j checkconditions #jump checkconditions
    NotEqualCount: addi $v0,$zero,-1 #set v0=-1
    jr $ra
    EqualCount: addi $v0,$zero,1 #set v0=1
    jr $ra
 