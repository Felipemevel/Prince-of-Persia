## Documentação das Funções

Abaixo estão detalhadas as rotinas desenvolvidas em linguagem Assembly (MIPS) que compõem o fluxo principal do motor de renderização.

---

### `main`
Ponto de entrada do programa. Orquestra o fluxo sequencial de execução das telas do jogo.

* **Descrição do Procedimento:**
    1. Carrega os argumentos da imagem inicial (Estágio 0 / Menu) nos registradores de argumento (`$a0`, `$a1`, `$a2`).
    2. Invoca a rotina `render_cenario` via `jal` (Jump and Link).
    3. Define o tempo de transição (5000ms) e invoca a rotina `espera`.
    4. Repete o processo sequencialmente para o Estágio 1 e Estágio 2.
    5. Encerra a execução do processo de forma limpa via `syscall 10` (Exit).

---

### `render_cenario`
Função central de renderização gráfica. Lê um vetor linear de pixels (na seção `.data`) e os projeta no Framebuffer de vídeo, implementando a lógica de transparência (Color Keying).

* **Parâmetros de Entrada:**
    * `$a0` : Endereço de memória base do array de pixels da imagem/cenário.
    * `$a1` : Largura da imagem em pixels (Width).
    * `$a2` : Altura da imagem em pixels (Height).
* **Registradores Internos Modificados:** * `$t0`, `$t1`, `$t2`, `$t3`, `$t4`, `$t5`
* **Proteção de Contexto (Stack):** * A função aloca 16 bytes na pilha (`$sp`) no início da execução para preservar o endereço de retorno (`$ra`) e os registradores temporários do chamador, desalocando-os antes da instrução de retorno (`jr $ra`).
* **Lógica de Execução:**
    * Calcula a área total da tela iterando sobre o produto da largura pela altura (`mul $t3, $a1, $a2`).
    * Itera sobre cada pixel aplicando a chave de transparência (`0xFFFFFFFF`). Pixels transparentes invocam um desvio condicional (`beq $t4, $t5, skip_draw`), preservando o pixel subjacente no Framebuffer (`0x10010000`).
    * Avança os ponteiros de leitura e escrita paralelamente a cada ciclo.

---

### `espera`
Função utilitária de delay de hardware que paralisa a execução da thread atual.

* **Parâmetros de Entrada:**
    * `$a0` : Tempo de paralisação em milissegundos (ms).
* **Registradores Internos Modificados:** * `$v0` (para código da syscall)
* **Lógica de Execução:**
    * Invoca o serviço do sistema `syscall 32` (Sleep), embutido no simulador MARS.
    * Interrompe o avanço do Program Counter (PC) pelo tempo definido em `$a0`.
    * Retorna a execução para a linha seguinte no escopo chamador (`jr $ra`).