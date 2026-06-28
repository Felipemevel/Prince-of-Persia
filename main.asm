.data
.include "cenarios/dummy.asm"
.include "cenarios/stage0.asm"
.include "cenarios/stage1.asm"
.include "cenarios/stage2.asm"
.include "tiles/stage1.asm"
.include "tiles/stage2.asm"
.include "sprites/prince_idle_right.asm"
.include "sprites/prince_idle_left.asm"
.include "sprites/prince_jump_right.asm"
.include "sprites/prince_jump_left.asm"
.include "sprites/prince_attack_sword_right.asm"
.include "sprites/prince_attack_sword_left.asm"
.include "sprites/inimigo1-frame1.asm"
prince_x:            .word 45
prince_y:            .word 54
prince_old_x:        .word 45
prince_old_y:        .word 54
inimigo_x:           .word 400
inimigo_y:           .word 142
inimigo_old_x:       .word 400
inimigo_old_y:       .word 142
inimigo_jump_dir:    .word 1
inimigo_jump_count:  .word 0
cenario_atual:       .word 1
atualizar_fundo:     .word 1
velocidade_y:        .word 0
velocidade_x:        .word 0
no_chao:             .word 1
direcao:             .word 1
inimigo_vida:        .word 3
inimigo_vivo:        .word 1
atacando:            .word 0
ataque_cooldown:     .word 0
.text
.globl main
main:
game_loop:
    jal controlesCenario
    j game_loop
fim:
    li $v0, 10
    syscall
.include "util/controle/controlarCenarios.asm"
.include "util/controle/colisoes.asm"
.include "util/renders/renderizarCenario.asm"
.include "personagem/renderizarPersonagem.asm"
.include "inimigo/atualizarInimigo.asm"
.include "util/som/sons.asm"