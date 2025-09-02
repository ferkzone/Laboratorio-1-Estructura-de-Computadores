.data
mensaje: .asciiz "Ingrese la cantidad de numeros (3-5): "
mensaje2: .asciiz "Ingrese un numero: "
mensaje3: .asciiz "El numero menor es: "
mensaje_error: .asciiz "Error: el valor debe estar entre 3 y 5 numeros.\n"
newline: .asciiz "\n"
.align 2                    # Asegurar alineación correcta
array: .space 20           # espacio para numeros enteros a ingresar 5*4=20

.text
.globl main
main: 
#-------------------------------
# 1.Pedir cantidad de numeros 3-5
preguntar_input:
	li $v0, 4
	la $a0, mensaje
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	blt $t0, 3, error
	bgt $t0, 5, error
	j continuar
	
error:
	li $v0, 4
	la $a0, mensaje_error
	syscall
	j preguntar_input
	
#-------------------------------
# 2. Leer los numeros ingresados y guardarlos en un arreglo
continuar:
	li $t1, 0              # contador = 0
	la $t2, array          # dirección base del array
	
leer_ciclo:
	bge $t1, $t0, encontrar_minimo
	
	li $v0, 4 
	la $a0, mensaje2 
	syscall
	
	li $v0, 5 
	syscall
	
	# Calcular dirección correcta: base + (índice * 4)
	la $t3, array          # cargar dirección base
	sll $t4, $t1, 2        # $t4 = $t1 * 4 (desplazamiento)
	add $t3, $t3, $t4      # $t3 = dirección base + desplazamiento
	sw $v0, 0($t3)         # guardar en la dirección calculada
	
	addi $t1, $t1, 1       # incrementar contador
	j leer_ciclo
		
#-------------------------------
# 3. Encontrar numero menor	
encontrar_minimo:
	la $t2, array          # reinicializar dirección base
	lw $t3, 0($t2)         # cargar primer elemento como minimo inicial
	li $t1, 1              # empezar desde el segundo elemento
	
ciclo_min:
	bge $t1, $t0, mostrar_resultado
	
	# Calcular dirección correcta para el elemento actual
	la $t5, array          # cargar dirección base
	sll $t6, $t1, 2        # $t6 = $t1 * 4
	add $t5, $t5, $t6      # $t5 = dirección base + desplazamiento
	lw $t4, 0($t5)         # cargar elemento actual
	
	bge $t4, $t3, skip     # si actual >= minimo, saltar
	move $t3, $t4          # actualizar máximo
	
skip: 
	addi $t1, $t1, 1       # incrementar contador
	j ciclo_min

#-------------------------------
# 4. Resultado
mostrar_resultado:
	li $v0, 4 
	la $a0, mensaje3 
	syscall 
	
	move $a0, $t3 
	li $v0, 1  
	syscall 
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 10 
	syscall