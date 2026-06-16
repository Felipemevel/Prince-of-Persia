.text
.globl atualizar_orbita

# ============================================================
# FUNÇÃO: atualizar_orbita
# ============================================================
# Descrição:
#   Atualiza as coordenadas da bola lendo as posições de
#   uma tabela pré-calculada (Look-Up Table - LUT).
# ============================================================

atualizar_orbita:

    # 1. Salva a posição antiga para os Retângulos Sujos (Borracha)
    lw $t0, bola_x
    sw $t0, bola_old_x

    lw $t1, bola_y
    sw $t1, bola_old_y

    # 2. Carrega o índice atual e os endereços da LUT
    lw $t2, bola_indice
    la $t3, orbita_lut_x
    la $t4, orbita_lut_y

    # 3. Calcula o offset na memória (índice * 4 bytes)
    sll $t5, $t2, 2

    # 4. Atualiza bola_x com o valor da tabela
    addu $t6, $t3, $t5      # Endereço base de X + offset
    lw $t7, 0($t6)          # Lê o novo valor de X
    sw $t7, bola_x

    # 5. Atualiza bola_y com o valor da tabela
    addu $t8, $t4, $t5      # Endereço base de Y + offset
    lw $t9, 0($t8)          # Lê o novo valor de Y
    sw $t9, bola_y

    # 6. Avança o índice para o próximo frame
    addiu $t2, $t2, 1

    # 7. Verifica se a volta terminou (32 pontos)
    li $t0, 32
    bne $t2, $t0, salva_indice
    
    # Se completou 32 passos, reseta para o ponto 0
    li $t2, 0               

salva_indice:
    sw $t2, bola_indice

    jr $ra