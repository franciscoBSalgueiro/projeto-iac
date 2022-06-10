; *********************************************************************************
; * Projeto IAC - Chuva de Meteoros
; * IST-UL
; * Grupo 32 - 103345 - Francisco Salgueiro
;			   102904 – Mariana Miranda
;			   102835 – Sofia Paiva
;
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)

TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; endereços das teclas
TECLA_0				EQU 0011H
TECLA_1				EQU 0012H
TECLA_2				EQU	0014H
TECLA_3				EQU	0018H
TECLA_4				EQU 0021H
TECLA_5				EQU 0022H
TECLA_6				EQU	0024H
TECLA_7				EQU	0028H
TECLA_8				EQU 0041H
TECLA_9				EQU 0042H
TECLA_A				EQU	0044H
TECLA_B				EQU	0048H
TECLA_C				EQU 0081H
TECLA_D				EQU 0082H
TECLA_E				EQU	0084H
TECLA_F				EQU	0088H

DEFINE_LINHA    		EQU 600AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H		; endereço do comando para escrever um pixel
TOCA_SOM                EQU 605AH		; endereço do comando para tocar um som
TERMINA_SOM             EQU 6066H		; endereço do comando para tocar um som


APAGA_AVISO     		EQU 6040H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU 6002H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_ECRÃ			EQU 6004H		; endereço do comando que seleciona o ecrã especificado
SELECIONA_CENARIO_FUNDO	EQU 6042H		; endereço do comando para selecionar uma imagem de fundo
SELECIONA_VIDEO_FUNDO	EQU 605CH		; endereço do comando para selecionar um video de fundo

ATRASO			EQU	4000H		; atraso para limitar a velocidade de movimento do boneco

; *********************
; * POSIÇÕES INICIAIS
; *********************

Y_NAVE        			EQU 28			; linha da nave 
X_NAVE					EQU 30			; coluna da nave 

Y_METEORO_GRANDE        EQU 10			; linha meteoro
X_METEORO_GRANDE        EQU 20			; coluna meteoro

Y_METEORO_MEDIO			EQU 16			; linha meteoro 2
X_METEORO_MEDIO			EQU 20			; coluna meteoro 2

Y_METEORO_MINI			EQU 21			; linha meteoro 3
X_METEORO_MINI			EQU 20			; coluna meteoro 3

Y_NAVE_MA_GRANDE		EQU 17			; linha nave má grande
X_NAVE_MA_GRANDE		EQU 50			; coluna nave má grande

Y_NAVE_MA_MEDIA			EQU 12			; linha nave má média
X_NAVE_MA_MEDIA			EQU 50			; coluna nave má média

Y_NAVE_MA_MINI          EQU 5			; linha nave má pequena
X_NAVE_MA_MINI          EQU 50			; coluna nave má pequena

Y_PEW_PEW			    EQU 10			; linha míssil
X_PEW_PEW			    EQU 30			; coluna míssil

Y_EXPLOSAO				EQU 23			; linha explosão
X_EXPLOSAO				EQU 50			; coluna explosão

; *************
; * DIMENSÕES
; *************

L_NAVE	    			EQU	5			; largura da nave
H_NAVE		    		EQU 4           ; altura da nave

L_METEORO_GRANDE		EQU 5           ; largura do meteoro
H_METEORO_GRANDE		EQU 5           ; altura do meteoro

L_METEORO_MEDIO			EQU 4			; largura do meteoro 2
H_METEORO_MEDIO			EQU 4			; altura do meteoro 2

L_METEORO_MINI			EQU 3			; largura do meteoro 3
H_METEORO_MINI			EQU 3			; altura do meteoro 3

L_NAVE_MA_GRANDE 		EQU 5           ; largura da nave má grande
H_NAVE_MA_GRANDE  		EQU 5           ; altura da nave má grande

L_NAVE_MA_MEDIA 		EQU 4           ; largura da nave má média
H_NAVE_MA_MEDIA 		EQU 4           ; altura da nave má média

L_NAVE_MA_MINI 			EQU 3           ; largura da nave má pequena
H_NAVE_MA_MINI  		EQU 3           ; altura da nave má pequena

L_PEW_PEW				EQU 1			; largura do míssil
H_PEW_PEW				EQU 1			; altura do míssil

L_EXPLOSAO				EQU 5			; largura da explosão
H_EXPLOSAO				EQU 5			; altura da explosão

MIN_COLUNA				EQU 0			; número da coluna mais à esquerda do MediaCenter
MAX_COLUNA				EQU 63			; número da coluna mais à direita do MediaCenter
MIN_LINHA				EQU 0			; número da coluna mais à esquerda do MediaCenter
MAX_LINHA				EQU 32			; número da coluna mais à direita do MediaCenter

; ***********
; * CORES
; ***********

; cores da nave
AZUL	    	EQU	0F08CH		
AMARELO			EQU 0FFB0H		
AZUL_ESCURO		EQU	0F0BEH	

; cores do meteoro
CINZA_ESCURO EQU 0F777H	
CINZA_CLARO	EQU 0FBBBH	

; cores da nave má
VERMELHO     	EQU 0FF00H

; cores do míssil
LARANJA			EQU 0FF80H

; ***********************************************************************
; * VARIÁVEIS E TABELAS
; ***********************************************************************

PLACE		1000H
pilha:
	STACK 100H			; espaço reservado para a pilha (200 bytes)
					
SP_inicial:				; inicialização do SP no endereço 1200H
						

ENERGIA:	; energia inicial a ser mostrada nos displays
	WORD 100

CARREGOU_BOTAO:		; variável que guarda se alguma tecla está a ser pressionada
	WORD	0

DEF_NAVE:			; tabela que define a nave (posição, dimensões e cores)
	WORD		X_NAVE, Y_NAVE					; posição inicial da nave
	WORD		L_NAVE, H_NAVE					; largura e altura da nave
    WORD        0, 0, AZUL_ESCURO, 0, 0
	WORD		AZUL, 0, AZUL, 0, AZUL			
	WORD		AZUL, AZUL, AZUL, AZUL, AZUL    
    WORD        0, AMARELO, 0, AMARELO, 0

DEF_METEORO_GRANDE :		; tabela que define o meteoro
	WORD		X_METEORO_GRANDE, Y_METEORO_GRANDE 			; posição inicial do meteoro
    WORD        L_METEORO_GRANDE, H_METEORO_GRANDE 			; largura e altura do meteoro
    WORD        0, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO
    WORD        CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        0, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, 0

DEF_METEORO_MEDIO :		; tabela que define o meteoro
	WORD		X_METEORO_MEDIO, Y_METEORO_MEDIO 			; posição inicial do meteoro
    WORD        L_METEORO_MEDIO, H_METEORO_MEDIO			; largura e altura do meteoro
    WORD        0, CINZA_ESCURO, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD        0, CINZA_ESCURO, CINZA_ESCURO, 0

DEF_METEORO_MINI :		; tabela que define o meteoro
	WORD		X_METEORO_MINI, Y_METEORO_MINI 			; posição inicial do meteoro
    WORD        L_METEORO_MINI, H_METEORO_MINI			; largura e altura do meteoro
    WORD        0, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO 
    WORD        0, CINZA_ESCURO, 0

DEF_NAVE_MA_GRANDE:		; tabela que define a nave má grande
	WORD		X_NAVE_MA_GRANDE, Y_NAVE_MA_GRANDE 			; posição inicial da nave má grande
	WORD		L_NAVE_MA_GRANDE, H_NAVE_MA_GRANDE			; largura e altura da nave má grande
	WORD		VERMELHO, 0, 0, 0, VERMELHO
	WORD		VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD		VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		VERMELHO, 0, 0, 0, VERMELHO

DEF_NAVE_MA_MEDIO:		; tabela que define a nave má
	WORD		X_NAVE_MA_MEDIA, Y_NAVE_MA_MEDIA 			; posição inicial da nave má 
	WORD		L_NAVE_MA_MEDIA, H_NAVE_MA_MEDIA			; largura e altura da nave má 
	WORD		VERMELHO, 0, 0, VERMELHO
	WORD		VERMELHO, 0, 0, VERMELHO
	WORD		0, VERMELHO, VERMELHO, 0
	WORD		VERMELHO, 0, 0, VERMELHO

DEF_NAVE_MA_MINI:		; tabela que define a nave má pequena
	WORD		X_NAVE_MA_MINI, Y_NAVE_MA_MINI 			; posição inicial da nave má pequena
	WORD		L_NAVE_MA_MINI, H_NAVE_MA_MINI			; largura e altura da nave má pequena
	WORD		VERMELHO, 0, 0, 0, VERMELHO
	WORD		0, VERMELHO, 0
	WORD		VERMELHO, 0, VERMELHO

DEF_PEW_PEW:
	WORD		X_PEW_PEW, Y_PEW_PEW			; posição inicial do míssil
	WORD		L_PEW_PEW, H_PEW_PEW			; largura e altura do míssil
	WORD		LARANJA

DEF_EXPLOSAO:
	WORD		X_EXPLOSAO, Y_EXPLOSAO			;posição inicial da explosão
	WORD		L_EXPLOSAO, H_EXPLOSAO			;largura e altura da explosão

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0				
inicio:
	MOV  SP, SP_inicial		; inicializa SP
                            
	MOV  [APAGA_AVISO], R1		; apaga o aviso de nenhum cenário selecionado
	MOV  [APAGA_ECRÃ], R1		; apaga todos os pixels já desenhados
	MOV	R1, 1					; cenário de fundo número 1
	MOV  [SELECIONA_VIDEO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	R1, 2							; cenário de fundo número 2
	MOV  [SELECIONA_VIDEO_FUNDO], R1
	MOV R1, 100H
	MOV R7, DISPLAYS
	MOV [R7], R1

mostra_boneco:		; desenha os bonecos
	; seleciona o ecrã 0
	MOV R0, 0 
	MOV R1, SELECIONA_ECRÃ
	MOV [R1], R0

	; desenha a nave
	MOV R4, DEF_NAVE
	CALL	desenha_boneco

	; seleciona o ecrã 1
	MOV R0, 1
	MOV R1, SELECIONA_ECRÃ
	MOV [R1], R0

	; verifica limites do meteoro
	MOV R4, [DEF_METEORO_GRANDE + 2]
	MOV R2, MAX_LINHA
	CMP R4, R2 			; verifica se chegou à última linha
	JGE espera_tecla
	MOV R4, DEF_METEORO_GRANDE		; se não chegou ao limite, desenha meteoro
	CALL	desenha_boneco

	; desenha o meteoro de tamanho 2
	MOV R4, [DEF_METEORO_MEDIO + 2]
	MOV R2, MAX_LINHA
	CMP R4, R2 			; verifica se chegou à última linha
	JGE espera_tecla
	MOV R4, DEF_METEORO_MEDIO		; se não chegou ao limite, desenha meteoro
	CALL	desenha_boneco

	; desenha o meteoro de tamanho 3
	MOV R4, [DEF_METEORO_MINI + 2]
	MOV R2, MAX_LINHA
	CMP R4, R2 			; verifica se chegou à última linha
	JGE espera_tecla
	MOV R4, DEF_METEORO_MINI		; se não chegou ao limite, desenha meteoro
	CALL	desenha_boneco

espera_tecla:					; neste ciclo espera-se até uma tecla ser premida
	MOV  R6, 1					; testa a primeira linha
	testa_linha:
		CALL	teclado			; leitura às teclas
		CMP	R9, 0
		JNZ	encontrou_tecla		; espera, enquanto não houver tecla

		CALL liberta_teclas

		SHL R6, 1		; avança para a próxima linha
		MOV R0, 16
		CMP R6, R0
		JZ espera_tecla ; se chegar à quinta linha volta ao início
		JMP testa_linha

encontrou_tecla:
	SHL  R6, 4         ; coloca linha no nibble high
    OR   R6, R9        ; junta coluna (nibble low)

	; verifica se a tecla pressionada é o 0
	MOV R7, TECLA_0
	CMP	R6, R7
	JZ	pressionou_0

	; verifica se a tecla pressionada é o 2
	MOV R7, TECLA_2
	CMP	R6, R7
	JZ	pressionou_2

	; verifica se a tecla pressionada é o 4
	MOV R7, TECLA_4
	CMP R6, R7
	JZ pressionou_4

	; verifica se a tecla pressionada é o 5
	MOV R7, TECLA_5
	CMP R6, R7
	JZ pressionou_5

	; verifica se a tecla pressionada é o 6
	MOV R7, TECLA_6
	CMP R6, R7
	JZ pressionou_6

	JMP espera_tecla ; outras teclas são ignoradas

pressionou_0:
	MOV R7, -1	; recua a nave uma coluna
	JMP ve_limites

pressionou_2:
	MOV R7, +1	; avança a nave uma coluna
	JMP ve_limites

pressionou_4:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	; decrementa o valor nos displays
	MOV	R7, [ENERGIA]
	SUB R7, 1
	JMP mostra_displays

pressionou_5:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	; aumenta o valor nos displays
	MOV	R7, [ENERGIA]
	ADD R7, 1
	JMP mostra_displays

pressionou_6:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	; reproduz o som quando a tecla 6 é pressionada
	MOV R6, TOCA_SOM
	MOV R1, 0
	MOV [R6], R1

	; pára o som de tocar
	MOV R6, TERMINA_SOM
	MOV R1, 0
	MOV [R6], R1

	JMP move_meteoro

ve_limites:
	MOV	R6, [DEF_NAVE + 4]		; obtém a largura do boneco
	MOV R2, [DEF_NAVE]
	CALL	testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0
	JZ	espera_tecla			; se não é para movimentar o objeto, vai ler o teclado de novo

move_boneco:
	MOV R11, ATRASO
	CALL atraso
    CALL apaga_pixeis

coluna_seguinte:
	MOV R4, DEF_NAVE
	MOV R0, [R4]
	ADD	R0, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)
	MOV [R4], R0
	JMP	mostra_boneco	; vai desenhar o boneco de novo

move_meteoro:
	CALL apaga_pixeis

linha_seguinte:
	MOV R4, DEF_METEORO_GRANDE
	ADD R4, 2
	MOV R0, [R4]			; obtém posição y do meteoro
	ADD R0, 1				; move para a linha seguinte
	MOV [R4], R0
	JMP	mostra_boneco		; vai desenhar o boneco de novo

mostra_displays:
	MOV R0, ENERGIA
	MOV [R0], R7			; altera o valor da energia

	MOV R0, DISPLAYS
	CALL converte_hex		; converte valor de energia para ser legível nos displays
	MOV [R0], R9
	JMP espera_tecla

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
    PUSH    R8
	MOV R2, [R4]			; obtém a posição x do boneco
	ADD R4, 2
	MOV R1, [R4]			; obtém a posição y do boneco
	ADD R4, 2
	MOV	R5, [R4]			; obtém a largura do boneco
    MOV R8, [R4]
	ADD R4, 2				
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2				; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:
	desenha_coluna:       	; desenha os pixels do boneco a partir da tabela
		MOV	R3, [R4]		; obtém a cor do próximo pixel do boneco
		CALL escreve_pixel
		ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1          ; próxima coluna
		SUB  R5, 1			; menos uma coluna para tratar
		JNZ  desenha_coluna ; continua até percorrer toda a largura da primeira linha
	ADD R1, 1				; próxima linha
	MOV R5, R8				; repor a largura
	SUB R2, R8				; alterar a coluna para a inicial
	SUB R6, 1				; menos uma coluna para tratar
	JNZ desenha_pixels 		; continua até percorrer toda a largura da segunda linha
    POP R8
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET

; **********************************************************************
; ATRASO - Executa um ciclo para implementar um atraso.
; Argumentos:   R11 - valor que define o atraso
;
; **********************************************************************
atraso:
	PUSH	R11
ciclo_atraso:
	SUB	R11, 1
	JNZ	ciclo_atraso
	POP	R11
	RET

; **********************************************************************
; APAGA_PIXEIS - Apaga todos os pixéis no ecrã
;
; **********************************************************************
apaga_pixeis:
	PUSH R0
	PUSH R4
	MOV R0, APAGA_ECRÃ
	MOV R4, 1
	MOV [R0], R4
	POP R0
	POP R4
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;			R6 - largura do boneco
;			R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH	R5
	PUSH	R6
testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	CMP	R2, R5
	JGT	testa_limite_direito
	CMP	R7, 0				; passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento	; entre limites. Mantém o valor do R7
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2				; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; entre limites. Mantém o valor do R7
	CMP	R7, 0				; passa a deslocar-se para a direita
	JGT	impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0				; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5
	RET

; **********************************************************************
; CONVERTE_HEX - Converte o valor para falso hexadecimal para o display
; Argumentos:	R7 - valor real
;
; Retorna: 	R9 - valor formatado em hexadecimal para o decimal
;
; a = (R7 // 100) * 256
; c = R7 % 100
; b = (c // 10) * 16
; c = c % 10
; R9 = a + b + c
; **********************************************************************
converte_hex:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7

	MOV R0, 10
	MOV R1, 100

	MOV R2, R7
	DIV R7, R1
	SHL R7, 4
	SHL R7, 4	; R7 é o dígito mais à esquerda no hexadecimal

	MOD R2, R1
	MOV R9, R2
	DIV R9, R0
	SHL R9, 4	; R9 é o dígito do meio no hexadecimal

	MOD R2, R0	; R2 é o dígito da direita no hexadecimal

	ADD R9, R2
	ADD R9, R7

	POP R7
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R9 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R6      ; escrever no periférico de saída (linhas)
	MOVB R9, [R3]      ; ler do periférico de entrada (colunas)
	AND  R9, R5        ; elimina bits para além dos bits 0-3
	POP	R5
	POP	R3
	POP	R2
	RET


; **********************************************************************
; LIBERTA_TECLAS - liberta teclas que não estão a ser pressionadas
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
; **********************************************************************

liberta_teclas:
	PUSH R1
	PUSH R7
	CMP	R6, 2 		; verifica se a linha sem teclas premidas é a segunda
	JNZ liberta_teclas_fim
	MOV R7, CARREGOU_BOTAO
	MOV R1, 0
	MOV [R7], R1 	; liberta tecla
	liberta_teclas_fim:
	POP R7
	POP R1
	RET


; **********************************************************************
; PRESSIONA_TECLAS - guarda a tecla que foi pressionada
;
; Retorna: R4 - (0) não carregou tecla / (1) carregou tecla
; **********************************************************************
pressiona_teclas:
	PUSH R7
	PUSH R9

	; vê se botão está pressionado
	MOV R9, CARREGOU_BOTAO
	MOV R7, [R9]
	MOV R4, 1
	CMP R7, 0
	JNZ pressiona_teclas_fim

	; guarda que botão está a ser pressionado
	MOV R4, 0
	MOV R7, 1
	MOV [R9], R7
	pressiona_teclas_fim:

	POP R9
	POP R7
	RET
