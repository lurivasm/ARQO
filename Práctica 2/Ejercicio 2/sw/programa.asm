# Prog de prueba para practica 2 ejercicio 2

.data 0
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 4 # posic 8 
num3: .word 8 # posic 12 
num4: .word 16 # posic 16 
num5: .word 32 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28
num8: .word 0 # posic 32
num9: .word 0 # posic 36
num10: .word 0 # posic 40
num11: .word 0 # posic 44
.text 0
main:
  # carga num0 a num5 en los registros 9 a 14
  lw $t1, 0($zero) # $r9 = 1
  lw $t2, 4($zero) # $r10 = 2
  lw $t3, 8($zero) # $r11 = 4
  lw $t4, 12($zero) # $r12 = 8
  lw $t5, 16($zero) # $r13 = 16
  lw $t6, 20($zero) # $r14 = 32
  nop
  nop
  nop
  nop
  # INSTRUCCION TIPO R + SALTO EFECTIVO
  add $t4, $t2, $t2 # r12 = 4 = 2 + 2
  beq $t3, $t4, salto1
  add $t4, $t4, $t2 # r12 = 6 = 4 + 2 
  nop
  nop
  nop
  # INSTRUCCION TIPO R + SALTO NO EFECTIVO
  salto1:
  add $t3, $t1, $t2 # r11 = 3 = 1 + 2
  beq $t3, $t4, salto2
  add $t4, $t4, $t2 # r12 = 6 = 4 + 2 
  nop
  nop
  nop
  # INSTRUCCION LW + SALTO EFECTIVO
  salto2:
  lw $t5, 0($zero) # $r13 = 1
  beq $t5, $t1, salto3
  add $t4, $t4, $t2 # r12 = 8 = 6 + 2 
  nop
  nop
  nop
  # INSTRUCCION LW + SALTO NO EFECTIVO
  salto3:
  lw $t5, 16($zero) # $r13 = 16
  beq $t5, $t1, fin
  add $t4, $t4, $t2 # r12 = 8 = 6 + 2 
  nop
  nop
  nop
  fin:
  beq $zero, $zero, fin
  

  