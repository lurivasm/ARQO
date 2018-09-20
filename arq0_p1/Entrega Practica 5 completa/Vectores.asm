######################################################################
## Fichero: Vectores.asm
## Descripción: Programa que...
## Fecha última modificación: 

## Autores: 
## Asignatura: E.C. 1º grado
## Grupo de Prácticas:
## Grupo de Teoría:
## Práctica: 4
## Ejercicio: 1
######################################################################

.text

main:
	addi $s0, $0, 0
	lw $s1, N 
	add $s1, $s1, $s1
	add $s1, $s1, $s1
	
 
 loop : slt $t1, $s0, $s1	
 	beq $t1, $0, done
 	lw $t2, B($s0)
 	add $t2, $t2, $t2
 	add $t2, $t2, $t2 		
 	lw $t3, A($s0)
 	add $t4, $t3, $t2
 	sw $t4, C($s0)
 	addi $s0, $s0, 4
 	j loop

 done : j done


.data 0x2000
N: 6
A: 2,4,6,8,10,12
B: -1,-5,4,10,1,-5
C: .space 24


