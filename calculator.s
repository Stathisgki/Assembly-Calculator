.data
prompt_num1:    .asciiz "\nDwse ton proto arithmo: "
prompt_num2:    .asciiz "Dwse ton deutero arithmo: "
prompt_op:      .asciiz "Dwse ton telesth (+, -, *, /, %): "
prompt_repeat:  .asciiz "Theleis na kaneis allon ypologismo? (y/n): "
error_op:       .asciiz "Lathos telesths!\n"
error_zero:     .asciiz "Den ginetai diairesh me 0!\n"
result_msg:     .asciiz "Apotelesma: "
newline:        .asciiz "\n"

.text
.globl main

main:
repeat:
    # Prompt for first number
    li $v0, 4
    la $a0, prompt_num1
    syscall

    li $v0, 5
    syscall
    move $t0, $v0      # First number

    # Prompt for operator
    li $v0, 4
    la $a0, prompt_op
    syscall

    li $v0, 12         # read character
    syscall
    move $t2, $v0      # Operator

    # Prompt for second number
    li $v0, 4
    la $a0, prompt_num2
    syscall

    li $v0, 5
    syscall
    move $t1, $v0      # Second number

    # Handle operators
    li $t3, '+'         
    beq $t2, $t3, add_op
    li $t3, '-'
    beq $t2, $t3, sub_op
    li $t3, '*'
    beq $t2, $t3, mul_op
    li $t3, '/'
    beq $t2, $t3, div_op
    li $t3, '%'
    beq $t2, $t3, mod_op

    # Unknown operator
    li $v0, 4
    la $a0, error_op
    syscall
    j ask_repeat

add_op:
    add $t4, $t0, $t1
    j print_result

sub_op:
    sub $t4, $t0, $t1
    j print_result

mul_op:
    mul $t4, $t0, $t1
    j print_result

div_op:
    beq $t1, $zero, div_by_zero
    div $t0, $t1
    mflo $t4
    j print_result

mod_op:
    beq $t1, $zero, div_by_zero
    div $t0, $t1
    mfhi $t4
    j print_result

div_by_zero:
    li $v0, 4
    la $a0, error_zero
    syscall
    j ask_repeat

print_result:
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, newline
    syscall

ask_repeat:
    li $v0, 4
    la $a0, prompt_repeat
    syscall

    li $v0, 12         # read character
    syscall
    li $t5, 'y'
    beq $v0, $t5, repeat

    # exit
    li $v0, 10
    syscall
