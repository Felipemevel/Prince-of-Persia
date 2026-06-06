.data

.include "cenarios/dummy.asm"			# Fantasma
.include "cenarios/stage0.asm"			# Local onde está o arquivo do menu inicial
.include "cenarios/stage2.asm" 			# Local onde esta o arquivo do cenario 2
.include "cenarios/stage1.asm" 			# Local onde esta o arquivo do cenario 1


.text
.globl main

main:

    # =========================================
    # DESENHO DE RETÂNGULO
    # =========================================

    li $t6, 100
    add $t3, $zero, $t6
    li $t7, 125
    li $t8, 0xFFFFFF
    li $s7, 50
    add $s6, $zero $s7
    li $t4, 10
    
    jal desenhar_retangulo
    
    jal controlesCenarioEspelhado

    # =========================================
    # FIM
    # =========================================
    
fim:
   li $v0, 10
   syscall   


.include "util/controle/controlarCenarios.asm"
.include "util/controle/controlarCenariosEspelhado.asm"
.include "util/renders/renderizarCenario.asm"
.include "util/renders/renderizarCenarioEspelhado.asm"
.include "util/formas/linhasRetangulos.asm"