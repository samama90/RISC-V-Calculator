.data  
# -------------------- MENU STRINGS ----------------------- 
line_top:    .asciz "+==================================+\n" 
title1:      .asciz "|    ** RISC-V  CALCULATOR **      |\n" 
title2:      .asciz "|        COAL   |   RARS           |\n" 
line_mid:    .asciz "+==================================+\n" 
      
     
line1: .asciz "|  [1]  Addition                   |\n"              
line2: .asciz "|  [2]  Subtraction                |\n"         
line3: .asciz "|  [3]  Multiplication             |\n"        
line4: .asciz "|  [4]  Division                   |\n"         
line5: .asciz "|  [5]  Modulus                    |\n"         
line6: .asciz "|  [6]  Power                      |\n"        
line7: .asciz "|  [7]  Square Root                |\n"   
line8: .asciz "|  [8]  Show History               |\n"
line9: .asciz "|  [9]  Exit                       |\n"      

line_bottom: .asciz "+==================================+\n" 


exitMsg: .asciz "Program terminated successfully.\n" 
Neg_error: .asciz "Negative exponent is not allowed in this calculator!\n" 
Div_error: .asciz "Division by zero is not allowed!\n" 
sqrt_error: .asciz "Square root of negative number is not allowed!\n"
reuseInvalidMsg: .asciz "Invalid input! Enter 1 or 0.\n"
overflowMsg: .asciz "Error: Integer overflow occurred!\n"
history: .word 0, 0, 0, 0, 0   # last 5 results
h_index: .word 0              # insertion index
history_count: .word 0
has_previous: .word 0

# -------------------- INPUT PROMPTS -------------------- 
Choice: .asciz "Enter your choice: " 
prompt1: .asciz "Enter first number: " 
prompt2: .asciz "Enter second number: " 
prompt_sqrt: .asciz "Enter number: "

# -------------------- OUTPUT MESSAGES -------------------- 
resultMsg: .asciz "Result = " 
historyMsg: .asciz "Last 5 Results: \n"
noHistoryMsg: .asciz "No history available.\n"
prevMsg: .asciz "Previous Result = "
invalidMsg: .asciz "Invalid choice! Try again.\n" 
reuseMsg: .asciz "Use previous result? (1 = Yes, 0 = No): "
newline:    .string "\n" 


.text 
.globl main   
main: 
li s3, 0   # Initialize previous result register

li t0, 0   # Start history insertion from index 0
la t1, h_index
sw t0, 0(t1)

LOOP_MAIN: 
 
# -------- PRINT CALCULATOR MENU --------  

# -------- PRINT TOP BORDER --------  
la a0, line_top 
li a7, 4 
ecall 
# -------- TITLE --------  
la a0, title1 
li a7, 4 
ecall 
la a0, title2 
li a7, 4 
ecall 
# -------- SEPARATOR --------  
la a0,  line_mid 
li a7, 4 
ecall 
# -------- OPTIONS -------- 
la a0, line1 
li a7, 4 
ecall 

la a0, line2 
li a7, 4 
ecall 

la a0, line3 
li a7, 4 
ecall 

la a0, line4 
li a7, 4 
ecall 

la a0, line5 
li a7, 4 
ecall 

la a0, line6 
li a7, 4 
ecall 

la a0, line7 
li a7, 4 
ecall 

la a0, line8
li a7, 4
ecall

la a0, line9
li a7, 4
ecall
# -------- lINE BOTTOM --------  
la a0, line_bottom 
li a7, 4 
ecall 
# -------- GET USER CHOICE -------- 
la a0,Choice 
li a7, 4 
ecall 
li a7,5 
ecall 
mv t0,a0 
# -------- CHECK EXIT CONDITION -------- 
li t1,9
beq t0,t1,EXIT 

# -------- VALID RANGE CHECK (1 to 8) --------
li t1,1 
blt t0,t1,Invalid  # if choice < 1 THEN invalid 

li t1,9
bgt t0,t1,Invalid # if choice > 9 THEN invalid 

# -------- FUNCTION CALL SELECTION -------- 
li t4,1 
beq t0,t4,ADDITION 

li t4,2 
beq t0,t4,SUBTRACTION 

li t4,3 
beq t0,t4,MULTIPLICATION 

li t4,4 
beq t0,t4,DIVISION 

li t4,5 
beq t0,t4,MODULUS 

li t4,6 
beq t0,t4,POWER 

li t4,7
beq t0,t4,SQRT

li t4,8
beq t0,t4,HISTORY

# INVALID INPUT HANDLING 
Invalid: 
la a0,invalidMsg 
li a7,4 
ecall 
j LOOP_MAIN 


# FUNCTION: GET USER INPUT (2 numbers) 
get_user_input: 

# -------- CHECK IF PREVIOUS RESULT EXISTS --------

la t0, has_previous
lw t1, 0(t0)

beq t1, x0, NORMAL_INPUT
# -------- SHOW PREVIOUS RESULT --------

la a0, prevMsg
li a7, 4
ecall

li a7, 1
mv a0, s3
ecall

la a0, newline
li a7, 4
ecall

REUSE_INPUT:

la a0, reuseMsg
li a7, 4
ecall

li a7, 5
ecall

# check if input == 1
li t0, 1
beq a0, t0, USE_PREVIOUS

# check if input == 0
li t0, 0
beq a0, t0, NORMAL_INPUT   # Skip reuse option if no previous result exists

# otherwise invalid
la a0, reuseInvalidMsg
li a7, 4
ecall

j REUSE_INPUT

# -------- NORMAL INPUT --------
NORMAL_INPUT:
# first number
la a0, prompt1
li a7, 4
ecall

li a7, 5
ecall
mv s0, a0

j SECOND_INPUT

# -------- USE PREVIOUS RESULT --------
USE_PREVIOUS:
mv s0, s3     # Use previous calculation result as first operand

# -------- SECOND INPUT --------
SECOND_INPUT:
la a0, prompt2
li a7, 4
ecall

li a7, 5
ecall
mv s1, a0
ret

get_single_input:

la a0, prompt_sqrt
li a7, 4
ecall

li a7, 5
ecall
mv s0, a0
ret

#----------ADDITION FUNCTION---------------- 
ADDITION:
# Overflow occurs when:
# 1. Both operands have same sign
# 2. Result has different sign

jal ra, get_user_input
add t0, s0, s1

# overflow if same sign inputs but different sign result
xor t1, s0, s1
blt t1, x0, ADD_OK

xor t2, s0, t0
blt t2, x0, OVERFLOW_ERROR

ADD_OK:
mv a0, t0

jal store_history
jal update_previous
jal fun_print
j LOOP_MAIN

#-------------SUBTRACTION FUNCTION---------------- 
SUBTRACTION: 

jal ra, get_user_input 
sub t0, s0, s1            # Store in t0 for overflow check

# Overflow occurs when operands have opposite signs
# and result sign differs from first operand

xor t1, s0, s1
bge t1, x0, SUB_OK

xor t2, s0, t0            # Now checking correct register
blt t2, x0, OVERFLOW_ERROR

SUB_OK:
mv a0, t0                 # Move to a0 for storage

jal store_history
jal update_previous
jal fun_print 
j LOOP_MAIN

#-------------MULTIPLICATION FUNCTION----------------- 
MULTIPLICATION:
jal ra, get_user_input

beq s0, x0, MULT_ZERO      # If s0=0, jump to special handler

# Verify multiplication:
# (result / operand1) must equal operand2
# Otherwise integer overflow occurred

mul t0, s0, s1
div t1, t0, s0
bne t1, s1, OVERFLOW_ERROR

mv a0, t0                  # Move result to a0
jal store_history
jal update_previous
jal fun_print
j LOOP_MAIN

MULT_ZERO:                 # Only reached when s0=0
li a0, 0                   # Result is 0
jal store_history
jal update_previous
jal fun_print
j LOOP_MAIN
#-------------DIVISION FUNCTION------------------ 
DIVISION: 
jal ra,get_user_input 
beq s1,x0,DIV_ERROR # check divide by zero 
div a0,s0,s1 
jal store_history
jal update_previous
jal fun_print 
j LOOP_MAIN 

#--------------MODULUS FUNCTION------------------ 
MODULUS: 
jal ra, get_user_input      
beq s1, x0, DIV_ERROR     
rem a0, s0, s1  
jal store_history
jal update_previous            
jal fun_print           
j LOOP_MAIN 

#---------------POWER FUNCTION------------------- 
POWER: 
jal ra ,get_user_input 
li t0,1   # result = 1 
li t1,0   # counter = 0     
blt s1, x0, NEG_POWER_ERROR 
beq s1,x0,POWER_ZERO 

POWER_LOOP:

beq t1, s1, POWER_DONE

# ---------- OVERFLOW CHECK ----------
beq s0, x0, SAFE_MULTIPLY

# Check overflow after each multiplication step
# by reversing the multiplication using division

mul t4, t0, s0
div t5, t4, s0

bne t5, t0, OVERFLOW_ERROR

mv t0, t4
addi t1, t1, 1

j POWER_LOOP

SAFE_MULTIPLY:
mul t0, t0, s0
addi t1, t1, 1

j POWER_LOOP


OVERFLOW_ERROR:
la a0, overflowMsg
li a7, 4
ecall

j LOOP_MAIN

POWER_DONE: 
mv a0,t0 
jal store_history
jal update_previous
jal fun_print           
j LOOP_MAIN 

NEG_POWER_ERROR: 
la a0, Neg_error 
li a7, 4 
ecall 
j LOOP_MAIN 

POWER_ZERO: 
li a0,1 
jal store_history
jal update_previous
jal fun_print           
j LOOP_MAIN 

#--------- SQUARE ROOT FUNCTION ------------
SQRT:
jal ra, get_single_input

blt s0, x0, SQRT_NEG_ERROR
beq s0, x0, SQRT_ZERO
li t0, 0

# Find integer square root using linear search
# Increase candidate until candidate² exceeds input

SQRT_LOOP:

addi t1, t0, 1
mul t2, t1, t1

bgt t2, s0, SQRT_DONE
addi t0, t0, 1
j SQRT_LOOP

SQRT_DONE:
mv a0, t0
jal store_history
jal update_previous
jal fun_print
j LOOP_MAIN

SQRT_ZERO:
li a0, 0
jal store_history
jal update_previous
jal fun_print
j LOOP_MAIN

SQRT_NEG_ERROR:
la a0, sqrt_error
li a7, 4
ecall
j LOOP_MAIN


HISTORY:
# check if history is empty
la t3, history_count
lw t2, 0(t3)

beq t2, x0, EMPTY_HISTORY

# print top border
la a0, line_top
li a7, 4
ecall

# print title
la a0, historyMsg
li a7, 4
ecall

# if less than 5 results, start from history[0]
li t4, 5
blt t2, t4, HISTORY_START_ZERO

# history full -> start from h_index
la t5, h_index
lw t6, 0(t5)

la t0, history
slli t6, t6, 2
add t0, t0, t6

j HISTORY_PRINT

HISTORY_START_ZERO:
la t0, history

HISTORY_PRINT:
li t1, 0
j loop_history

EMPTY_HISTORY:
la a0, noHistoryMsg
li a7, 4
ecall
j LOOP_MAIN
#--------------------------------
loop_history:

beq t1, t2, end_history

lw a0, 0(t0)
li a7, 1
ecall

la a0, newline
li a7, 4
ecall

addi t1, t1, 1

# move to next history slot
addi t0, t0, 4

# wrap around if end reached
la t4, history
addi t5, t4, 20      # 5 words × 4 bytes

blt t0, t5, continue_history

mv t0, t4

continue_history:
j loop_history

end_history:
la a0, line_bottom
li a7, 4
ecall

j LOOP_MAIN

# -------- DIVISION ERROR HANDLING -------- 
DIV_ERROR: 
li a7, 4 
la a0, Div_error 
ecall 
j LOOP_MAIN 

#------------PRINT RESULT-------------- 
fun_print: 
mv s2,a0 

la a0, resultMsg
li a7,4 
ecall 

li a7,1 
mv a0,s2
ecall 

la a0,newline 
li a7,4 
ecall 
ret 


# -------- STORE RESULT IN HISTORY --------

# History uses a circular buffer of size 5.
# When buffer becomes full, new results overwrite
# the oldest stored results.

store_history:

# Input:
#   a0 = calculation result

# Action:
#   Store result in circular history buffer
#   Update insertion index and history count

la t0, h_index
lw t1, 0(t0)

la t2, history

slli t3, t1, 2
add t2, t2, t3

sw a0, 0(t2)

# ---------------- UPDATE INDEX ----------------

addi t1, t1, 1

li t3, 5
blt t1, t3, skip_reset

li t1, 0

skip_reset:
sw t1, 0(t0)

# ---------------- UPDATE HISTORY COUNT ----------------

la t4, history_count
lw t5, 0(t4)

li t6, 5
bge t5, t6, done_count

addi t5, t5, 1
sw t5, 0(t4)

done_count:
ret


# -------- UPDATE PREVIOUS RESULT --------

update_previous:

mv s3, a0

# set flag = 1
la t0, has_previous
li t1, 1
sw t1, 0(t0)

ret
#-----------EXIT PROGRAM--------------- 
EXIT: 
la a0, exitMsg 
li a7, 4 
ecall 
li a7,10 
ecall
