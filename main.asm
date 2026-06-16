# ============================================================
# ARQUIVO PRINCIPAL DO JOGO (main.asm)
# ============================================================
# Responsável por:
# - Carregar cenários e sprites
# - Inicializar variáveis dinâmicas (Príncipe e Inimigos)
# - Manter o Game Loop contínuo
# - Encerrar a execução do programa
# ============================================================

.data

# ============================================================
# 1. INCLUSÃO DE ARQUIVOS DE IMAGEM E MAPAS
# ============================================================

# ------------------------------------------------------------
# Cenários
# ------------------------------------------------------------
.include "cenarios/dummy.asm"             # Cenário fantasma/utilizado como apoio
.include "cenarios/stage0.asm"            # Tela/Menu inicial
.include "cenarios/stage1.asm"            # Cenário 1
.include "cenarios/stage2.asm"            # Cenário 2

# ------------------------------------------------------------
# Sprites (Personagens)
# ------------------------------------------------------------
.include "sprites/prince_idle_right.asm"  # Sprite do príncipe
.include "sprites/inimigo1-frame1.asm"    # Sprite do inimigo (Frame 1)
.include "sprites/bola.asm"               # NOVO: Sprite da bola (NPC Orbital 50x50)


# ============================================================
# 2. VARIÁVEIS DINÂMICAS DO JOGO
# ============================================================

# ------------------------------------------------------------
# Posições e Estados do Príncipe (Herói)
# ------------------------------------------------------------
prince_x:            .word 45      # Coordenada X atual
prince_y:            .word 75      # Coordenada Y atual
prince_old_x:        .word 45      # Coordenada X anterior (Borracha)
prince_old_y:        .word 75      # Coordenada Y anterior (Borracha)

# ------------------------------------------------------------
# Posições e Estados do Inimigo (Cenário 2)
# ------------------------------------------------------------
inimigo_x:           .word 400     # Lado direito da tela
inimigo_y:           .word 142     # Chão exato (256 - 64 - 50)
inimigo_old_x:       .word 400     # Posição X antiga (Borracha)
inimigo_old_y:       .word 142     # Posição Y antiga (Borracha)

# Física do Inimigo
inimigo_jump_dir:    .word 1       # 1 = subindo, -1 = descendo
inimigo_jump_count:  .word 0       # Conta quantos pixels já subiu/desceu

# ------------------------------------------------------------
# Posições e Estados do NPC Orbital (Bola) - NOVO
# ------------------------------------------------------------
bola_x:              .word 300     # Posição inicial X
bola_y:              .word 100     # Posição inicial Y
bola_old_x:          .word 300     # Posição antiga X (para a borracha)
bola_old_y:          .word 100     # Posição antiga Y (para a borracha)

# Tabela de Look-Up (LUT) para a órbita circular
# Centro da órbita: (220, 100) | Raio: 80 pixels | 32 frames de animação
bola_indice:         .word 0       # Qual ponto da órbita estamos (0 a 31)

orbita_lut_x: .word 300, 298, 294, 286, 276, 264, 250, 235, 220, 204, 189, 175, 163, 153, 145, 141, 140, 141, 145, 153, 163, 175, 189, 204, 220, 235, 250, 264, 276, 286, 294, 298
orbita_lut_y: .word 100, 115, 130, 144, 156, 166, 174, 178, 180, 178, 174, 166, 156, 144, 130, 115, 100, 84, 69, 55, 43, 33, 25, 21, 20, 21, 25, 33, 43, 55, 69, 84

# ------------------------------------------------------------
# Controle de Sistema (Cenários e Renderização)
# ------------------------------------------------------------
cenario_atual:       .word 1       # Cenário carregado ao iniciar o jogo
atualizar_fundo:     .word 1       # 1 = Redesenha tudo | 0 = Usa Dirty Rectangles


# ============================================================
# 3. INÍCIO DA ÁREA DE CÓDIGO PRINCIPAL
# ============================================================

.text
.globl main

main:

# ------------------------------------------------------------
# GAME LOOP PRINCIPAL
# ------------------------------------------------------------
# Mantém o jogo rodando infinitamente para ler o teclado e
# processar a física dos inimigos autônomos.
# ------------------------------------------------------------
game_loop:

    jal controlesCenario           # Executa lógica de controles e renderização

    j game_loop                    # Repete o ciclo infinitamente


# ============================================================
# ENCERRAMENTO DO PROGRAMA (Chamado ao apertar 'X')
# ============================================================
fim:
    li $v0, 10
    syscall


# ============================================================
# 4. INCLUSÃO DOS MÓDULOS LÓGICOS DO PROJETO (.text)
# ============================================================

# Controle principal (Movimento e troca de cenário)
.include "util/controle/controlarCenarios.asm"

# Motor de renderização de cenários
.include "util/renders/renderizarCenario.asm"

# Motor de renderização de sprites (Príncipe e Inimigos)
.include "personagem/renderizarPersonagem.asm"

# Lógica autônoma do Inimigo
.include "inimigo/atualizarInimigo.asm"

# Lógica autônoma do NPC Orbital (Bola) - NOVO
.include "inimigo/atualizarOrbita.asm"