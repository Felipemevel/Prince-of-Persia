.text

# =========================================
# FUNÇÃO: render_cenario_espelhado
# a0 = endereço do cenário
# a1 = width
# a2 = height
# =========================================

render_cenario_espelhado:

    addiu $sp, $sp, -24
    sw $ra, 20($sp)
    sw $t0, 16($sp)
    sw $t1, 12($sp) # Contador de altura Y
    sw $t2, 8($sp)  # Contador de largura X
    sw $t3, 4($sp)  # Ponteiro de leitura da linha atual
    sw $s0, 0($sp)

    li $t0, 0x10010000     # Início do framebuffer

    li $t1, 0               # y = 0
loop_altura_esp:
    beq $t1, $a2, end_render_esp # Se y == height, termina

    # Cálculo: endereço do início desta linha no cenário
    # Posição = base + (y * width * 4)
    mul $t3, $t1, $a1
    sll $t3, $t3, 2
    addu $t3, $a0, $t3

    # Cálculo: endereço do ÚLTIMO pixel desta linha
    # End_Final = (Inicio_Linha) + (width * 4) - 4
    sll $t4, $a1, 2
    addu $t3, $t3, $t4
    addiu $t3, $t3, -4      # $t3 agora aponta para o último pixel da linha atual

    li $t2, 0               # x = 0
loop_largura_esp:
    beq $t2, $a1, proxima_linha_esp 

    lw $s0, 0($t3)  

    li $t4, 0xFFFFFFFF
    beq $s0, $t4, skip_draw_esp

    sw $s0, 0($t0)          # Escreve no framebuffer

skip_draw_esp:
    addiu $t0, $t0, 4       # Avança FB
    addiu $t3, $t3, -4      # Retrocede no cenário (dentro da linha)
    addiu $t2, $t2, 1       # x++
    j loop_largura_esp

proxima_linha_esp:
    addiu $t1, $t1, 1       # y++
    j loop_altura_esp

end_render_esp:
    lw $ra, 20($sp)
    lw $t0, 16($sp)
    lw $t1, 12($sp)
    lw $t2, 8($sp)
    lw $t3, 4($sp)
    lw $s0, 0($sp)
    addiu $sp, $sp, 24

    jr $ra
    
    # =========================================
    # RENDERIZAÇÃO POR CONTROLE
    # =========================================

renderizarCenarioUmEspelhado:

    la $a0, cenario1
    lw $a1, cenario1_width
    lw $a2, cenario1_height

    jal render_cenario_espelhado

    j controlesCenarioEspelhado
    
renderizarCenarioDoisEspelhado:

    la $a0, cenario_2
    lw $a1, cenario_2_width
    lw $a2, cenario_2_height

    jal render_cenario_espelhado
    
    j controlesCenarioEspelhado
    
renderizarCenarioZeroEspelhado:

    la $a0, menu_principal
    lw $a1, menu_principal_width
    lw $a2, menu_principal_height
    
    jal render_cenario_espelhado
    
    j controlesCenarioEspelhado