.data

.include "cenarios/stage0.asm"		# Local onde está o arquivo do menu inicial
.include "cenarios/stage1.asm" 			#local onde esta o arquivo do cenario 1
.include "cenarios/stage2.asm" 		#local onde esta o arquivo do cenario 2


.text
.globl main

main:

    li $t6, 100
    add $t3, $zero, $t6
    li $t7, 125
    li $t8, 0xFFFFFF
    li $s7, 50
    add $s6, $zero $s7
    li $t4, 10
    
    jal desenhar_retangulo

    # =========================================
    # STAGE 0
    # =========================================
    
    la $a0, menu_principal
    lw $a1, menu_principal_width
    lw $a2, menu_principal_height
    
    jal render_cenario
    li $a0, 5000
    jal espera

    # =========================================
    # STAGE 1
    # =========================================

    la $a0, cenario1
    lw $a1, cenario1_width
    lw $a2, cenario1_height

    jal render_cenario

    li $a0, 5000
    jal espera


    # =========================================
    # STAGE 2
    # =========================================

    la $a0, cenario_2
    lw $a1, cenario_2_width
    lw $a2, cenario_2_height

    jal render_cenario

    li $a0, 5000
    jal espera


    # =========================================
    # FIM
    # =========================================

    li $v0, 10
    syscall


# =========================================
# FUNÇÃO: render_cenario
# a0 = endereço do cenário
# a1 = width
# a2 = height
# =========================================

render_cenario:

    addiu $sp, $sp, -16
    sw $ra, 12($sp)
    sw $t0, 8($sp)
    sw $t1, 4($sp)
    sw $t2, 0($sp)

    li $t0, 0x10010000   # framebuffer
    mul $t3, $a1, $a2    # total pixels

loop_render:

    beqz $t3, end_render

    lw $t4, 0($a0)

    li $t5, 0xFFFFFFFF
    beq $t4, $t5, skip_draw

    sw $t4, 0($t0)

skip_draw:

    addiu $a0, $a0, 4
    addiu $t0, $t0, 4
    addiu $t3, $t3, -1

    j loop_render


end_render:

    lw $ra, 12($sp)
    lw $t0, 8($sp)
    lw $t1, 4($sp)
    lw $t2, 0($sp)
    addiu $sp, $sp, 16

    jr $ra


# =========================================
# FUNÇÃO: espera (ms)
# a0 = tempo em ms
# =========================================

espera:

    li $v0, 32
    syscall
    jr $ra
    
posicionar_pixel:

    lui $s0, 0x1001

    sll $t9, $t7, 9
    addu $t9, $t6, $t9
    sll $t9, $t9, 2
    addu $t9, $t9, $s0

    sw $t8, 0($t9)
    jr $ra

    

desenhar_linha:

    addiu $sp, $sp, -8  # Reserva 8 bytes na pilha
    sw    $ra, 4($sp)   # Guarda o endereço de retorno da main
    sw    $s7, 0($sp)   # Guarda o valor original do contador
        
for_linha:

   jal posicionar_pixel
  
   addi $s7, $s7, -1
   addi $t6, $t6, 1  

   bnez $s7, for_linha

   lw $s7, 0($sp)   # Restaura o contador
   lw $ra, 4($sp)   # Restaura o endereço de retorno da main
   addiu $sp, $sp, 8   # Libera a pilha

   jr $ra 
   
desenhar_retangulo:

    addiu $sp, $sp, -8  # Reserva 8 bytes na pilha
    sw    $ra, 4($sp)   # Guarda o endereço de retorno da main
    sw    $s7, 0($sp)   # Guarda o valor original do contador
    
for_retangulo:

   jal desenhar_linha
   add $t6, $zero, $t3
   addi $t7, $t7, 1
   addi $t4, $t4, -1
   
   bnez $t4, for_retangulo
   
   lw $s7, 0($sp)   # Restaura o contador
   lw $ra, 4($sp)   # Restaura o endereço de retorno da main
   addiu $sp, $sp, 8   # Libera a pilha

   jr $ra 
   