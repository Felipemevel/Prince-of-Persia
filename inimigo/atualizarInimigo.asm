.text
.globl atualizar_inimigos

# ============================================================
# FUNÇÃO: atualizar_inimigos
# ============================================================
# Descrição:
#   Controla a física autônoma de pulo do inimigo.
#   Faz ele subir uma certa altura e depois descer, em loop.
#
# Lógica de Eixo Y:
#   Subir = Subtrair de Y
#   Descer = Somar a Y
# ============================================================

atualizar_inimigos:

    # --------------------------------------------------------
    # 1. Salva a posição antiga para os Retângulos Sujos
    # --------------------------------------------------------
    lw $t0, inimigo_y
    sw $t0, inimigo_old_y

    # --------------------------------------------------------
    # 2. Carrega variáveis de física do Inimigo
    # --------------------------------------------------------
    lw $t1, inimigo_jump_dir     # 1 = Subindo, -1 = Descendo
    lw $t2, inimigo_jump_count   # Conta os pixels do pulo atual
    
    li $t3, 1                    # Velocidade do pulo (5 pixels por frame)
    li $t4, 100                   # Altura máxima do pulo (40 pixels)

    # --------------------------------------------------------
    # 3. Verifica se está subindo ou descendo
    # --------------------------------------------------------
    li $t5, 1
    beq $t1, $t5, inimigo_sobe

inimigo_desce:
    addu $t0, $t0, $t3           # Move para baixo (Soma Y)
    addu $t2, $t2, $t3           # Aumenta contador de distância
    
    bge $t2, $t4, inverte_para_subir
    j salvar_inimigo

inimigo_sobe:
    subu $t0, $t0, $t3           # Move para cima (Subtrai Y)
    addu $t2, $t2, $t3           # Aumenta contador de distância
    
    bge $t2, $t4, inverte_para_descer
    j salvar_inimigo

# --------------------------------------------------------
# 4. Inversão de Direção nas Bordas do Pulo
# --------------------------------------------------------
inverte_para_subir:
    li $t1, 1                    # Muda direção para 1 (sobe)
    sw $t1, inimigo_jump_dir
    li $t2, 0                    # Zera distância
    j salvar_inimigo

inverte_para_descer:
    li $t1, -1                   # Muda direção para -1 (desce)
    sw $t1, inimigo_jump_dir
    li $t2, 0                    # Zera distância

# --------------------------------------------------------
# 5. Salva os novos valores na memória
# --------------------------------------------------------
salvar_inimigo:
    sw $t0, inimigo_y
    sw $t2, inimigo_jump_count

    jr $ra