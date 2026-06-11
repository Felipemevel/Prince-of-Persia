.text

# =========================================
# FUNÇÃO: renderizar_sprite
# Descrição: Renderiza o personagem por cima do cenário na tela.
# $a0 = Endereço do sprite (ex: prince_idle_right)
# $a1 = Posição X na tela
# $a2 = Posição Y na tela
# $a3 = Largura do sprite (width) essa info ta no .asm do sprite, temos que pegar manualmente eu coloquei como comentario
# $t0 = Altura do sprite (height) essa info ta no .asm do sprite, temos que pegar manualmente eu coloquei como comentario
# =========================================

.globl renderizar_sprite 

renderizar_sprite: 
    addiu $sp, $sp, -24         # --> Abre 24 bytes na pilha (stack) para salvar o contexto
    sw $ra, 20($sp)             # --> Salva o endereço de retorno ($ra)
    sw $s0, 16($sp)             # --> Salva o registrador $s0 (será o ponteiro da tela)
    sw $s1, 12($sp)             # --> Salva o registrador $s1 (será a largura da tela)
    sw $s2, 8($sp)              # --> Salva o registrador $s2 (cálculos de offset / iterador Y)
    sw $s3, 4($sp)              # --> Salva o registrador $s3 (ponteiro do sprite)
    sw $s4, 0($sp)              # --> Salva o registrador $s4 (cor transparente)

    li $s0, 0x10010000          # --> Carrega o endereço base do Framebuffer (Memória de vídeo)
    li $s1, 512                 # --> Define a largura total da tela do jogo em pixels (512)
    
    # =========================================
    # Cálculo Preciso de Coordenadas: Offset = (Y * LarguraTela + X) * 4
    # =========================================
    mul $s2, $a2, $s1           # --> Passo 1: Multiplica a coordenada Y pela largura da tela
    addu $s2, $s2, $a1          # --> Passo 2: Soma a coordenada X ao resultado
    sll $s2, $s2, 2             # --> Passo 3: Multiplica por 4 (usando Shift Left de 2 bits) pois cada pixel tem 4 bytes
    addu $s0, $s0, $s2          # --> $s0 agora aponta para o pixel exato onde o personagem começa na tela

    move $s2, $t0               # --> Inicia $s2 como o contador de linhas (Altura do Sprite)
    move $s3, $a0               # --> $s3 aponta para o endereço inicial do sprite (ex: prince_idle_right)
    li $s4, 0x00000000          # --> Fundo preto (0x00000000). Esta cor será ignorada (transparente)

loop_linha_sprite: 
    beqz $s2, fim_render_sprite # --> Se desenhou todas as linhas da altura do sprite, termina o loop
    move $t1, $a3               # --> $t1 inicia como o contador de colunas (Largura do Sprite)
    move $t2, $s0               # --> $t2 será o ponteiro que viaja pela tela desenhando a linha atual

loop_coluna_sprite: 
    beqz $t1, proxima_linha_sprite # --> Se desenhou todos os pixels da largura, pula para a linha de baixo
    
    lw $t3, 0($s3)              # --> Lê a cor do pixel atual diretamente do arquivo do sprite
    beq $t3, $s4, skip_pixel_sprite # --> Se a cor lida for igual a 0x00000000 (preto/transparente), não desenha
    
    sw $t3, 0($t2)              # --> Desenha a cor do pixel no Framebuffer (Tela)

skip_pixel_sprite: 
    addiu $s3, $s3, 4           # --> Avança o ponteiro do sprite para o próximo pixel (4 bytes)
    addiu $t2, $t2, 4           # --> Avança o ponteiro da tela para o próximo pixel à direita (4 bytes)
    addiu $t1, $t1, -1          # --> Diminui 1 do contador de colunas
    j loop_coluna_sprite        # --> Repete até terminar a largura do sprite

proxima_linha_sprite: 
    # =========================================
    # Avança para a próxima linha do display
    # =========================================
    sll $t4, $s1, 2             # --> Calcula o tamanho de uma linha inteira da tela em bytes (512 * 4)
    addu $s0, $s0, $t4          # --> Soma esse valor ao ponteiro base da tela. Isso faz ele "descer" uma linha exata
    
    addiu $s2, $s2, -1          # --> Diminui 1 do contador de linhas do sprite
    j loop_linha_sprite         # --> Repete até desenhar toda a altura do sprite

fim_render_sprite: 
    lw $ra, 20($sp)             # --> Restaura o endereço de retorno ($ra)
    lw $s0, 16($sp)             # --> Restaura o registrador $s0
    lw $s1, 12($sp)             # --> Restaura o registrador $s1
    lw $s2, 8($sp)              # --> Restaura o registrador $s2
    lw $s3, 4($sp)              # --> Restaura o registrador $s3
    lw $s4, 0($sp)              # --> Restaura o registrador $s4
    addiu $sp, $sp, 24          # --> Fecha os 24 bytes que foram abertos na pilha
    jr $ra                      # --> Retorna para a função de renderizarCenario