.data
mensaje: .asciiz "Ingresar cantidad de numeros por ver en la secuencia: "
mensaje_fib: .asciiz "Serie Fibonacci: "
espacio: .asciiz ", "
mensaje_suma: .asciiz "\nSuma total: "
newline: .asciiz "\n"

.text
.globl main
main:
    	# 1. Pedir cantidad
    	li $v0, 4
    	la $a0, mensaje
    	syscall
    
    	li $v0, 5
    	syscall
    	move $t0, $v0
    
   	# 2. Inicializar variables de Fibonacci
    	li $t1, 0        # primer número (0) - anterior
    	li $t2, 1        # segundo número (1) - actual
    	li $t3, 0        # suma total
    	li $t4, 0        # contador
    
    	# 3. Casos especiales
    	beq $t0, 0, fin          # si pide 0 números, terminar
    
    	# Mostrar mensaje inicial
    	li $v0, 4
    	la $a0, mensaje_fib
    	syscall
    
    	# Si pide 1 número, mostrar solo el 0
    	beq $t0, 1, mostrar_solo_cero
    
    	# 4. Ciclo principal para 2 o más números
    	j ciclo_fibonacci

	mostrar_solo_cero:
    	li $v0, 1
    	move $a0, $t1        # mostrar 0
    	syscall
    	add $t3, $t3, $t1    # sumar 0 a la suma total
    	j mostrar_suma

	ciclo_fibonacci:
    	# mientras contador < cantidad_deseada:
    	bge $t4, $t0, mostrar_suma
    
    	# Casos especiales para los primeros dos números
    	beq $t4, 0, mostrar_primer_numero
    	beq $t4, 1, mostrar_segundo_numero
    
    	# Para números >= 2: calcular siguiente = actual + anterior
    	add $t5, $t1, $t2    # $t5 = siguiente número
    
    	# Mostrar el número actual
    	li $v0, 4
    	la $a0, espacio
    	syscall
    
    	li $v0, 1
    	move $a0, $t5
    	syscall
    
    	# Sumar a la suma total
    	add $t3, $t3, $t5
    
    	# Actualizar: anterior = actual, actual = siguiente
    	move $t1, $t2        # anterior = actual
    	move $t2, $t5        # actual = siguiente
    
    	# Incrementar contador
    	addi $t4, $t4, 1
    	j ciclo_fibonacci

	mostrar_primer_numero:
    	# Mostrar 0 (primer número)
    	li $v0, 1
    	move $a0, $t1
    	syscall
    	add $t3, $t3, $t1    # sumar a la suma total
    	addi $t4, $t4, 1
    	j ciclo_fibonacci

	mostrar_segundo_numero:
    	# Mostrar coma y 1 (segundo número)
    	li $v0, 4
    	la $a0, espacio
    	syscall
    
    	li $v0, 1
    	move $a0, $t2
    	syscall
    	add $t3, $t3, $t2    # sumar a la suma total
    	addi $t4, $t4, 1
    	j ciclo_fibonacci

	mostrar_suma:
    	# Mostrar la suma total
    	li $v0, 4
    	la $a0, mensaje_suma
    	syscall
    
    	li $v0, 1
    	move $a0, $t3
    	syscall
    
    	li $v0, 4
    	la $a0, newline
    	syscall

	fin:
    	# Terminar programa
    	li $v0, 10
    	syscall