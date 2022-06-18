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

VIDEO_INTRO			EQU 0
SOM_MUSICA			EQU 1
VIDEO_FUNDO			EQU 2
SOM_EXPLOSAO		EQU 3
SOM_COLISAO			EQU 4
SOM_GAME_OVER		EQU 5
SOM_MISSIL			EQU 6

FUNDO_PERDEU_ENERGIA	EQU 0
FUNDO_PERDEU_COLISAO	EQU 1
FUNDO_PERDEU_DESISTIU	EQU 2
FUNDO_PAUSA				EQU 3

; endereços das teclas
TECLA_0				EQU 11H
TECLA_1				EQU 12H
TECLA_2				EQU	14H
TECLA_3				EQU	18H
TECLA_4				EQU 21H
TECLA_5				EQU 22H
TECLA_6				EQU	24H
TECLA_7				EQU	28H
TECLA_8				EQU 41H
TECLA_9				EQU 42H
TECLA_A				EQU	44H
TECLA_B				EQU	48H
TECLA_C				EQU 81H
TECLA_D				EQU 82H
TECLA_E				EQU	84H
TECLA_F				EQU	88H

DEFINE_LINHA    		EQU 600AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H		; endereço do comando para escrever um pixel
TOCA_SOM                EQU 605AH		; endereço do comando para tocar um som
TERMINA_MEDIA           EQU 6066H		; endereço do comando para parar a reprodução de um som ou vídeo
PAUSA_MEDIA				EQU 605EH		; endereço do comando para pausar a reprodução de um som ou vídeo
RETOMA_MEDIA			EQU 6060H		; endereço do comando para retomar a reprodução de um som ou vídeo

APAGA_AVISO     		EQU 6040H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU 6002H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_ECRÃ			EQU 6004H		; endereço do comando que seleciona o ecrã especificado
SELECIONA_CENARIO_FUNDO	EQU 6042H		; endereço do comando para selecionar uma imagem de fundo
REPRODUZ_MEDIA	EQU 605CH		; endereço do comando para selecionar um video de fundo

ATRASO			EQU	4000H		; atraso para limitar a velocidade de movimento do boneco

; *********************
; * POSIÇÕES INICIAIS
; *********************

Y_NAVE        	EQU 28			; linha inicial da nave 
X_NAVE			EQU 30			; coluna inicial da nave 

Y_TIPO_1		EQU 3			; linha máxima para o tipo 1 dos meteoros
Y_TIPO_2		EQU 6			; linha máxima para o tipo 2 dos meteoros
Y_TIPO_3		EQU 9			; linha máxima para o tipo 3 dos meteoros
Y_TIPO_4		EQU 12			; linha máxima para o tipo 4 dos meteoros

; *************
; * DIMENSÕES
; *************

L_NAVE	    	EQU	5			; largura da nave
H_NAVE			EQU 4           ; altura da nave

L_TIPO_1		EQU 1			; largura do meteoro de tipo 1
H_TIPO_1		EQU 1			; altura do meteoro de tipo 1
L_TIPO_2		EQU 2			; largura do meteoro de tipo 2
H_TIPO_2		EQU 2			; altura do meteoro de tipo 2
L_TIPO_3		EQU 3			; largura do meteoro de tipo 3
H_TIPO_3		EQU 3			; altura do meteoro de tipo 3
L_TIPO_4		EQU 4			; largura do meteoro de tipo 4
H_TIPO_4		EQU 4			; altura do meteoro de tipo 4
L_TIPO_5		EQU 5			; largura do meteoro de tipo 5
H_TIPO_5		EQU 5			; altura do meteoro de tipo 5

; distância em words entre cada um dos tipos e a tabela de tamanho 5
OFFSET_TIPO_1	EQU 76
OFFSET_TIPO_2	EQU 70
OFFSET_TIPO_3	EQU 58
OFFSET_TIPO_4	EQU 36

TIPO_MAU		EQU 0
TIPO_BOM		EQU 1

L_EXPLOSAO		EQU 5			; altura e largura da explosão
H_EXPLOSAO		EQU 5			; altura e largura da explosão

L_PEW_PEW		EQU 1			; altura e largura do míssil
H_PEW_PEW		EQU 1			; altura e largura do míssil

MIN_COLUNA		EQU 0			; número da coluna mais à esquerda do MediaCenter
MAX_COLUNA		EQU 63			; número da coluna mais à direita do MediaCenter
MIN_LINHA		EQU 0			; número da linha mais acima do MediaCenter
MAX_LINHA		EQU 32			; número da linha mais abaixo do MediaCenter

ALCANCE_MISSIL	EQU 16		; número máximo da linha a que o míssil pode chegar


ENERGIA_INICIAL	EQU 100		; energia no início do jogo
ENERGIA_MATAR	EQU 5		; energia ganha por matar uma nave má
ENERGIA_RELOGIO	EQU -5		; energia perdida ao longo do tempo
ENERGIA_DISPARA	EQU -5		; energia perdida por disparar um míssil
ENERGIA_METEORO	EQU 10		; energia ganha por colidir com um meteoro bom

; flags de estado do programa
ESTADO_PERDEU_1		EQU 0	; perdeu por energia
ESTADO_PERDEU_2		EQU 1	; perdeu por colisão com nave má
ESTADO_NORMAL		EQU 2
ESTADO_PAUSA		EQU 3

; ***********
; * CORES
; ***********

; cores da nave
AZUL	    	EQU	0F08CH		
AMARELO			EQU 0FFB0H		
AZUL_ESCURO		EQU	0F0BEH	

; cores do meteoro
CINZA_ESCURO 	EQU 0F777H	
CINZA_CLARO		EQU 0FBBBH	

; cores da nave má
VERMELHO     	EQU 0FF00H

; cores do míssil
LARANJA			EQU 0FF80H

; ***********************************************************************
; * VARIÁVEIS E TABELAS
; ***********************************************************************

PLACE		1000H

; Reserva do espaço para as pilhas dos processos
	STACK 100H			; espaço reservado para a pilha (200 bytes)
SP_inicial_prog_princ:				; inicialização do SP no endereço 1200H

	STACK 100H			; espaço reservado para a pilha do processo "avanca_missil"
SP_inicial_missil:

	STACK 100H			; espaço reservado para a pilha do processo "controla_energia"
SP_inicial_displays:

	STACK 100H			; espaço reservado para a pilha do processo "move_meteoro"
SP_inicial_meteoro:

; Tabela das rotinas de exceções
tab_exc:
	WORD rot_int_0			; rotina de atendimento da interrupcão 0
	WORD rot_int_1			; rotina de atendimento da interrupcão 1
	WORD rot_int_2			; rotina de atendimento da interrupcão 2

ENERGIA:	; energia a ser mostrada nos displays
	WORD ENERGIA_INICIAL

CARREGOU_BOTAO:		; variável que guarda se alguma tecla está a ser pressionada
	WORD 0

DEF_POS_NAVE:
	WORD X_NAVE, Y_NAVE	; posição inicial da nave

DEF_NAVE:			; tabela que define a nave (posição, dimensões e cores)
	WORD		L_NAVE, H_NAVE					; largura e altura da nave
    WORD        0, 0, AZUL_ESCURO, 0, 0
	WORD		AZUL, 0, AZUL, 0, AZUL			
	WORD		AZUL, AZUL, AZUL, AZUL, AZUL    
    WORD        0, AMARELO, 0, AMARELO, 0

DEF_METEORO_T1:	; tabela que define o meteoro de tamanho 1
	WORD		L_TIPO_1, H_TIPO_1	; largura e altura do de tamanho 1
	WORD		CINZA_CLARO

DEF_METEORO_T2:	; tabela que define o meteoro cinzento médio
	WORD		L_TIPO_2, H_TIPO_2		; largura e altura do meteoro de tamanho 2
	WORD		CINZA_CLARO, CINZA_CLARO
	WORD		CINZA_CLARO, CINZA_CLARO

DEF_METEORO_T3:		; tabela que define o meteoro de tamanho 3
    WORD        L_TIPO_3, H_TIPO_3			; largura e altura do meteoro de tamanho 3
    WORD        0, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO 
    WORD        0, CINZA_ESCURO, 0

DEF_METEORO_T4:		; tabela que define o meteoro de tamanho 4
    WORD        L_TIPO_4, H_TIPO_4			; largura e altura do meteoro de tamanho 4
    WORD        0, CINZA_ESCURO, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD        0, CINZA_ESCURO, CINZA_ESCURO, 0

DEF_METEORO_T5:		; tabela que define o meteoro de tamanho 5
    WORD        L_TIPO_5, H_TIPO_5 			; largura e altura do meteoro de tamanho 5
    WORD        0, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, 0
    WORD        CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO
    WORD        CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, CINZA_ESCURO
    WORD        0, CINZA_ESCURO, CINZA_CLARO, CINZA_ESCURO, 0

DEF_NAVE_MA_T1:	; tabela que define a nave má de tamanho 1
	WORD		L_TIPO_1, H_TIPO_1	; largura e altura da nave má cinzenta de tamanho 1
	WORD		VERMELHO

DEF_NAVE_MA_T2:	; tabela que define a nave má de tamanho 2
	WORD		L_TIPO_2, H_TIPO_2	; largura e altura da nave má cinzenta tamanho 2
	WORD		VERMELHO, VERMELHO
	WORD		VERMELHO, VERMELHO

DEF_NAVE_MA_T3:		; tabela que define a nave má de tamanho 3
	WORD		L_TIPO_3, H_TIPO_3			; largura e altura da nave má de tamanho 3
	WORD		VERMELHO, 0, VERMELHO
	WORD		0, VERMELHO, 0
	WORD		VERMELHO, 0, VERMELHO

DEF_NAVE_MA_T4:		; tabela que define a nave má de tamanho 4
	WORD		L_TIPO_4, H_TIPO_4			; largura e altura da nave má de tamanho 4
	WORD		VERMELHO, 0, 0, VERMELHO
	WORD		VERMELHO, 0, 0, VERMELHO
	WORD		0, VERMELHO, VERMELHO, 0
	WORD		VERMELHO, 0, 0, VERMELHO

DEF_NAVE_MA_T5:		; tabela que define a nave má de tamanho 5
	WORD		L_TIPO_5, H_TIPO_5			; largura e altura da nave má de tamanho 5
	WORD		VERMELHO, 0, 0, 0, VERMELHO
	WORD		VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD		VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		VERMELHO, 0, 0, 0, VERMELHO

DEF_TIPO_METEORO:
	WORD 0, 0, 0, 1		; (0) - nave má, (1) - meteoro

DEF_POS_METEORO:	
	WORD 4			; número de meteoros
	WORD 10, 22		; posições dos meteoros
	WORD 18, 15
	WORD 34, 8
	WORD 50, 1

DEF_POS_PEW_PEW:
	WORD -1, -1

DEF_PEW_PEW:
	WORD		L_PEW_PEW, H_PEW_PEW			; largura e altura do míssil
	WORD		LARANJA

DEF_POS_EXPLOSAO:
	WORD -1, -1

DEF_EXPLOSAO:
	WORD		L_EXPLOSAO, H_EXPLOSAO			; largura e altura da explosão
	WORD		0, AMARELO, 0, AMARELO, 0
	WORD		AMARELO, 0, LARANJA, 0, AMARELO
	WORD		0, VERMELHO, 0, VERMELHO, 0
	WORD		AMARELO, 0, LARANJA, 0, AMARELO
	WORD		0, AMARELO, 0, AMARELO, 0

EXPLOSAO_COUNTER:	; counter para a duração da explosão
	WORD 0

ESTADO_JOGO:		; flag para indicar o estado do jogo
	WORD 2			; 0 e 1 - game over, 2 - normal, 3 - pausa

evento_int_displays:
	LOCK 0

evento_int_missil:
	LOCK 0

evento_int_meteoros:
	LOCK 0

; **********************************************************************
; **********************************************************************
; 							CÓDIGO PRINCIPAL
; **********************************************************************
; **********************************************************************

PLACE   0				
inicio:
	MOV  SP, SP_inicial_prog_princ		; inicializa SP
	MOV BTE, tab_exc				; inicializa BTE
	MOV	[APAGA_ECRÃ], R1
	MOV	[APAGA_AVISO], R1		; apaga o aviso de nenhum cenário selecionado

	CALL controla_energia		; cria o processo controla_energia
	CALL move_meteoro			; cria o processo move_meteoro
	CALL avanca_missil			; cria o processo avanca_missil

start_menu:
	MOV	R1, VIDEO_INTRO			; vídeo de fundo da intro
	MOV  [REPRODUZ_MEDIA], R1	; seleciona o cenário de fundo
	MOV R6, 8
	start_loop:
		CALL teclado
		CMP R9, 1
		JNZ start_loop
		CALL pressiona_teclas

inicio_game_loop:
	MOV R1, VIDEO_INTRO
	MOV [TERMINA_MEDIA], R1				; pára de tocar música de fundo

	MOV	R1, SOM_MUSICA
	MOV  [REPRODUZ_MEDIA], R1	; toca a música de fundo em loop

	MOV R7, ENERGIA_INICIAL		; reinicia o valor da energia
	MOV [ENERGIA], R7
	MOV R0, 0
	MOV [evento_int_displays], R0

	MOV R7, DEF_POS_NAVE		; reinicia a posição da nave
	MOV R1, X_NAVE				
	MOV [R7], R1				; define a posição x da nave
	MOV R1, Y_NAVE
	MOV [R7+2], R1				; define a posição y da nave
	MOV R7, DEF_POS_PEW_PEW	
	MOV R1, -1
	MOV [R7+2], R1				; apaga os mísseis

	; cria os meteoros
	MOV R5, 12				
	define_pos_iniciais:
	CALL cria_meteoro
	SUB R5, 4
	CMP R5, 0
	JLT game_loop
	JMP define_pos_iniciais

game_loop:
	MOV	R1, 3					; vídeo de fundo da intro
	MOV  [TERMINA_MEDIA], R1	; seleciona o cenário de fundo
	EI0							; permite interrupcões 0
	EI1							; permite interrupcões 1
	EI2							; permite interrupcões 2
	EI							; permite interrupcões geral
	MOV	R1, VIDEO_FUNDO			; cenário de fundo
	MOV  [REPRODUZ_MEDIA], R1	; seleciona o cenário de fundo
	MOV R7, [ENERGIA]

mostra_boneco:		; desenha os bonecos
	CALL redesenha_ecra

espera_tecla:					; neste ciclo espera-se até uma tecla ser premida ou uma exceção acontecer
	YIELD
	MOV R1, [ESTADO_JOGO]
	CMP R1, ESTADO_PERDEU_2					; verifica se o jogo chegou ao fim
	JLE game_over

	MOV  R6, 1					; testa a primeira linha
	testa_linha:
		CALL	teclado			; leitura às teclas
		CMP	R9, 0				; verifica se a tecla foi pressionada
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

	MOV R4, [ESTADO_JOGO]
	CMP R4, ESTADO_PAUSA
	JZ testa_D

	; verifica se a tecla pressionada é o 0
	MOV R7, TECLA_0
	CMP	R6, R7
	JZ	pressionou_0

	; verifica se a tecla pressionada é o 1
	MOV R7, TECLA_1
	CMP	R6, R7
	JZ	pressionou_1

	; verifica se a tecla pressionada é o 2
	MOV R7, TECLA_2
	CMP	R6, R7
	JZ	pressionou_2

	; verifica se a tecla pressionada é o E
	MOV R7, TECLA_E
	CMP R6, R7
	JZ pressionou_E

testa_D:
	; verifica se a tecla pressionada é o D
	MOV R7, TECLA_D
	CMP R6, R7
	JZ pressionou_D


	JMP espera_tecla ; outras teclas são ignoradas

pressionou_0:
	MOV R7, -1	; recua a nave uma coluna
	JMP ve_limites

pressionou_1:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	MOV R0, [DEF_POS_PEW_PEW+2]
	CMP R0, -1
	JNZ pressionou_1_fim

	MOV R0, ENERGIA_DISPARA
	MOV [evento_int_displays], R0

	CALL dispara_missil
pressionou_1_fim:
	JMP mostra_boneco

pressionou_2:
	MOV R7, +1	; avança a nave uma coluna
	JMP ve_limites

pressionou_D:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	MOV R4, [ESTADO_JOGO]
	CMP R4, ESTADO_NORMAL
	JZ poe_pausa
	CMP R4, ESTADO_PAUSA
	JNZ espera_tecla
tira_pausa:
	EI
	MOV R1, SOM_MUSICA
	MOV [RETOMA_MEDIA], R1				; retoma a música
	MOV	R1, VIDEO_FUNDO			; cenário de fundo número 1
	MOV  [REPRODUZ_MEDIA], R1	; seleciona o cenário de fundo
	MOV R4, ESTADO_JOGO
	MOV R3, ESTADO_NORMAL
	MOV [R4], R3
	JMP espera_tecla
poe_pausa:
	DI
	CALL apaga_pixeis
	MOV R1, SOM_MUSICA
	MOV [PAUSA_MEDIA], R1				; pausa a música
	MOV R1, VIDEO_FUNDO
	MOV [TERMINA_MEDIA], R1				; termina o vídeo de fundo
	MOV	R1, FUNDO_PAUSA					; cenário de fundo de pausa
	MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV R4, ESTADO_JOGO
	MOV R3, ESTADO_PAUSA
	MOV [R4], R3
	JMP espera_tecla

pressionou_E:
	; verifica se a tecla já foi pressionada
	CALL pressiona_teclas
	CMP R4, 0
	JNZ espera_tecla

	CALL apaga_pixeis
	JMP game_over

ve_limites:
	MOV	R6, [DEF_NAVE]		; obtém a largura do boneco
	MOV R2, [DEF_POS_NAVE]
	CALL	testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0
	JZ	espera_tecla			; se não é para movimentar o objeto, vai ler o teclado de novo

move_boneco:
	MOV R11, ATRASO
	CALL atraso

coluna_seguinte:
	MOV R4, DEF_POS_NAVE
	MOV R0, [R4]
	ADD	R0, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)
	MOV [R4], R0
	JMP	mostra_boneco	; vai desenhar o boneco de novo

game_over:
	DI0					; desativa interrupções 0
	DI1					; desativa interrupções 1
	DI2					; desativa interrupções 2
	DI					; desativa interrupcões
	CALL apaga_pixeis	; apaga ecrã
	MOV R1, SOM_MUSICA
	MOV [TERMINA_MEDIA], R1				; pára de tocar música de fundo
	MOV R1, VIDEO_FUNDO
	MOV [TERMINA_MEDIA], R1				; pára de tocar música de fundo
	MOV R6, SOM_GAME_OVER 				; número do som de game over
	CALL efeito_sonoro
	MOV	R1, [ESTADO_JOGO]				; cenário de fundo correspondente ao tipo de perda
	MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	R1, 1							; cenário de fundo número 1
	MOV  [TERMINA_MEDIA], R1
	MOV R6, 8

	game_over_loop_1:
		CALL	teclado			; leitura às teclas
		CMP	R9, 0
		JNZ game_over_loop_1
		CALL liberta_teclas
	game_over_loop_2:
		CALL teclado
		CMP R9, 1				; verifica se a tecla pressionada é o 'C'
		JNZ game_over_loop_2
		CALL pressiona_teclas
		MOV R2, ESTADO_JOGO
		MOV R3, ESTADO_NORMAL
		MOV [R2], R3
		JMP inicio_game_loop


; **********************************************************************
; **********************************************************************
; 							ROTINAS AUXILIARES
; **********************************************************************
; **********************************************************************


; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - posição x do boneco
;				R2 - posição y do boneco
;				R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
    PUSH    R8
	PUSH	R9
	CMP R2, 0
	JLT sai_desenha_pixels

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
		ADD  R1, 1          ; próxima coluna
		SUB  R5, 1			; menos uma coluna para tratar
		JNZ  desenha_coluna ; continua até percorrer toda a largura da primeira linha
	proxima_linha:
	ADD R2, 1				; próxima linha
	MOV R9, MAX_LINHA
	CMP R9, R2
	JZ sai_desenha_pixels	; não desenha pixel se estiver for dos limites
	MOV R5, R8				; repor a largura
	SUB R1, R8				; alterar a coluna para a inicial
	SUB R6, 1				; menos uma coluna para tratar
	JNZ desenha_pixels 		; continua até percorrer toda a largura da segunda linha
sai_desenha_pixels:
	POP R9
    POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET


; **********************************************************************
; REDEFINE_BONECO
;
; Argumentos:   R2 - posição y do boneco
;				R4 - tabela que define o boneco
; **********************************************************************

redefine_boneco:
	PUSH R5

	MOV R5, Y_TIPO_1
	CMP R2, R5				; verifica se o boneco do tipo 1 atingiu o Y máximo
	JLE boneco_tipo_1		; altera o tipo de boneco se o Y atual for maior que o Y máximo

	MOV R5, Y_TIPO_2
	CMP R2, R5				; verifica se o boneco do tipo 2 atingiu o Y máximo
	JLE boneco_tipo_2		; altera o tipo de boneco se o Y atual for maior que o Y máximo

	MOV R5, Y_TIPO_3
	CMP R2, R5				; verifica se o boneco do tipo 3 atingiu o Y máximo
	JLE boneco_tipo_3		; altera o tipo de boneco se o Y atual for maior que o Y máximo

	MOV R5, Y_TIPO_4
	CMP R2, R5				; verifica se o boneco do tipo 4 atingiu o Y máximo
	JLE boneco_tipo_4		;  altera o tipo de boneco se o Y atual for maior que o Y máximo

	JMP redefine_boneco_fim

	boneco_tipo_1:
		MOV R5, OFFSET_TIPO_1
		SUB R4, R5					; muda o desenho do boneco para o tipo 1
		JMP redefine_boneco_fim

	boneco_tipo_2:
		MOV R5, OFFSET_TIPO_2
		SUB R4, R5					; muda o desenho do boneco para o tipo 2
		JMP redefine_boneco_fim

	boneco_tipo_3:
		MOV R5, OFFSET_TIPO_3
		SUB R4, R5					; muda o desenho do boneco para o tipo 3
		JMP redefine_boneco_fim

	boneco_tipo_4:
		MOV R5, OFFSET_TIPO_4
		SUB R4, R5					; muda o desenho do boneco para o tipo 4

	redefine_boneco_fim:
	POP R5
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - coluna
;               R2 - linha
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_COLUNA], R1	; seleciona a coluna
	MOV  [DEFINE_LINHA], R2		; seleciona a linha
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
	MOV [R0], R4	; apaga todos os pixéis desenhados
	POP R0
	POP R4
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites laterais do ecrã e nesse caso
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
	JGT	testa_limite_direito ; se não chegou ao limite esquerdo testa o direito
	CMP	R7, 0				 ; caso contrário passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento	; entre limites. Mantém o valor do R7
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2				; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; se não chegou ao limite direito mantém o valor do R7
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
;
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
; **********************************************************************

liberta_teclas:
	PUSH R1
	PUSH R2
	PUSH R7
	MOV R2, 8
	CMP	R6, R2 		; verifica se a linha sem teclas premidas é a quarta
	JNZ liberta_teclas_fim
	MOV R7, CARREGOU_BOTAO
	MOV R1, 0
	MOV [R7], R1 	; liberta tecla
	liberta_teclas_fim:
	POP R7
	POP R2
	POP R1
	RET


; **********************************************************************
; PRESSIONA_TECLAS - guarda que a tecla que foi pressionada
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

; **********************************************************************
; REDESENHA_ECRA - volta a desenhar todos os bonecos nas suas 
; posições atuais e em ecrãs diferentes de forma a não se intercetarem.
;
; **********************************************************************

redesenha_ecra:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5

	CALL apaga_pixeis

	; seleciona o ecrã 0
	MOV R0, 0 
	CALL muda_ecra

	; desenha a nave
	MOV R4, DEF_NAVE
	MOV R1, [DEF_POS_NAVE]			; coloca a posição x da nave em R1
	MOV R2, [DEF_POS_NAVE+2]		; coloca a posiçõa y da nave em R2
	CALL	desenha_boneco

	; desenha o míssil
	MOV R4, DEF_PEW_PEW
	MOV R1, [DEF_POS_PEW_PEW]		; coloca a posição x do míssil em R1
	MOV R2, [DEF_POS_PEW_PEW+2]		; coloca a posiçõa y do míssil em R2
	CALL	desenha_boneco

	MOV R5, DEF_POS_METEORO
	CALL	desenha_varios

	MOV R5, [EXPLOSAO_COUNTER]
	CMP R5, 0
	JZ redesenha_ecra_fim
	; decrementa contador da explosão
	SUB R5, 1
	MOV R4, EXPLOSAO_COUNTER
	MOV [R4], R5

	; seleciona o ecrã 1
	MOV R0, 1
	CALL muda_ecra

	MOV R4, DEF_EXPLOSAO
	MOV R0, DEF_POS_EXPLOSAO
	MOV R1, [R0]				; coloca a posição x da explosão em R1
	MOV R2, [R0+2]				; coloca a posição y da explosão em R2
	CALL desenha_boneco

	redesenha_ecra_fim:
	POP R5
	POP R4
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; DESENHA_VARIOS 
;
; Argumento - R5 tabela das posições dos bonecos a desenhar
; **********************************************************************

desenha_varios:
	PUSH R0
	PUSH R1
	PUSH R4
	PUSH R5
	PUSH R8
	PUSH R9
	PUSH R10
	MOV R10, DEF_TIPO_METEORO
	MOV R8, [R5] ; número de objetos
	ADD R5, 2
	SHL R8, 2	 ; número de bytes a avançar
	MOV R0, 2	 ; ecrã inicial

desenha_ciclo:
	CALL muda_ecra
	MOV R9, [R10]
	CMP R9, TIPO_MAU	; verifica se é do tipo bom ou mau
	JZ tipo_mau			; salta se for do tipo mau
	tipo_bom:
		MOV R4, DEF_METEORO_T5
		JMP desenha_um
	tipo_mau:
		MOV R4, DEF_NAVE_MA_T5

desenha_um:
	SUB R8, 4	
	CMP R8, 0				; verifica se ainda há mais objetos
	JLT sai_desenha_ciclo
	MOV R1, [R5]
	MOV R2, [R5+2]
	CALL redefine_boneco	; altera tipo do boneco
	CALL desenha_boneco		; desenha o novo boneco
	ADD R5, 4
	ADD R10, 2
	ADD R0, 1
	JMP desenha_ciclo

sai_desenha_ciclo:
	POP R10
	POP R9
	POP R8
	POP R5
	POP R4
	POP R1
	POP R0
	RET


; **********************************************************************
; DISPARA_MISSIL - dispara o míssil da nave
; **********************************************************************

dispara_missil:
	PUSH R1
	PUSH R2
	PUSH R3

	MOV R6, SOM_MISSIL
	CALL efeito_sonoro

	MOV R1, DEF_POS_PEW_PEW
	MOV R2, DEF_POS_NAVE
	MOV R3, [R2]
	ADD R3, 2				; Disparar centrado
	MOV [R1], R3			; Escreve a posição x do míssil
	MOV R3, [R2+2]			; Lê a posição x da nave para R3
	SUB R3, 1				; Dispara à frente da nave
	MOV [R1+2], R3			; Define a posição y do míssil

	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; ALEATORIO - Retorna um valor aleatório entre 0 e 7 através da 
; leitura do periférico de entrada PIN
;
; Retorna: R3 - número aleatório entre 0 e 7
; **********************************************************************

aleatorio:
    PUSH R2
    MOV R2, TEC_COL		; obtem  o endereço do periférico de entrada
    MOVB R3, [R2]		; lê o valor no periférico de entrada
    SHR R3, 5			; Coloca os bits 7 a 5 nos bits de 2 a 0
    POP R2
    RET


; **********************************************************************
; CRIA_METEORO - escolhe aleatóriamente o tipo de meteoro a ser criado,
;				e cria o mesmo em posições aleatórias
; Argumento - R5 número do meteoro
; **********************************************************************

cria_meteoro:
	PUSH R0
	PUSH R1
	PUSH R3
	PUSH R5
	PUSH R6
	MOV R0, 0
	MOV R6, DEF_POS_METEORO
	ADD R6, 2
	ADD R6, R5
	CALL aleatorio		; valor aleatório para a coluna
	MOV [R6+2], R0		; posição x do meteoro
	SHL R3, 3
	ADD R3, 2 			; mínima posição à esquerda
	MOV [R6], R3

	; define tipo do meteoro
	MOV R6, DEF_TIPO_METEORO
	SHR R5, 1
	ADD R6, R5
	CALL aleatorio
	SHR R3, 1			; obtém um numero aleatório
	CMP R3, 0			; verifica o tipo de meteoro
	JNZ cria_tipo_mau	; foi escolhido aleatóriamente o tipo mau
	cria_tipo_bom:		; caso contrário é criado o tipo bom
		MOV R0, TIPO_BOM
		MOV [R6], R0		; coloca um (1) no tipo de meteoro
		JMP cria_meteoro_fim
	cria_tipo_mau:
		MOV R0, TIPO_MAU	
		MOV [R6], R0		; coloca um (0) no tipo de meteoro
cria_meteoro_fim:
	POP R6
	POP R5
	POP R3
	POP R1
	POP R0
	RET


; **********************************************************************
; DETETA_COLISÕES - deteta colisões e cria a respetiva colisão
;
; Argumentos: ;		R0 - tabela da posição do colidor
;					R5 - nº do meteoro a testar
; **********************************************************************

deteta_colisoes:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6	
	PUSH R7 
	PUSH R9
	PUSH R10

	MOV R2, [R0]				; posição x do objeto a colidir
	MOV R3, [R0+2]				; posição y do objeto a colidir

	MOV R10, DEF_POS_METEORO
	ADD R10, 2
	ADD R10, R5
	MOV R6, [R10]				; posição x do meteoro
	ADD R6, 2					; centro x do meteoro
	MOV R7, [R10+2]				; posição y do meteoro
	ADD R7, 2					; centro y do meteoro

	MOV R1, DEF_POS_PEW_PEW
	CMP R0, R1
	JZ tipo_missil
	MOV R1, DEF_POS_NAVE
	CMP R0, R1
	JZ tipo_nave 

tipo_missil:
	MOV R4, 3					; distância máxima do meteoro
	JMP compara_posicoes
tipo_nave:
	MOV R4, 5					; distância máxima do meteoro
	ADD R2, 2					; centro x da nave
	ADD R3, 2					; centro y da nave

compara_posicoes:
	MUL R4, R4
	SUB R6, R2					; distância horizontal
	MUL R6, R6
	CMP R6, R4
	JGE deteta_colisoes_fim
	SUB R7, R3					; distância	vertical
	MUL R7, R7
	CMP R7, R4
	JGE deteta_colisoes_fim

encontrou_colisao:
	MOV R1, DEF_POS_PEW_PEW		
	CMP R0, R1					; há colisão com um missíl se as posições forem iguais
	JZ encontrou_colisao_missil

encontrou_colisao_nave:
	MOV R0, DEF_TIPO_METEORO
	SHR R5, 1					; número do meteoro a testar
	ADD R0, R5			
	MOV R9, [R0]				
	CMP R9, TIPO_MAU			; verifica se a colisão foi com o tipo mau
	JZ encontrou_colisao_nave_mau

encontrou_colisao_nave_bom:
	; reproduz som quando há uma colisão com meteoro
	MOV R6, SOM_COLISAO 					; número do som da colisão
	CALL efeito_sonoro

	SHL R5, 1						; número do meteoro
	CALL cria_meteoro
	MOV R0, ENERGIA_METEORO			; atualiza a energia respetiva
	MOV [evento_int_displays], R0 	; desbloqueia processo controla_energia
	JMP deteta_colisoes_fim

encontrou_colisao_nave_mau:
	MOV R2, ESTADO_JOGO				
	MOV R3, ESTADO_PERDEU_2
	MOV [R2], R3					; atualiza estado para o fim do jogo
	JMP deteta_colisoes_fim

encontrou_colisao_missil:
	MOV R1, DEF_TIPO_METEORO		
	MOV R9, R5
	SHR R9, 1
	ADD R1, R9
	MOV R9, [R1]
	CMP R9, TIPO_BOM
	JZ cria_explosao				; míssil colide com o tipo bom
	MOV R2, ENERGIA_MATAR			; atualiza a energia respetiva
	MOV	[evento_int_displays], R2	; desbloqueia processo controla_energia
	JMP cria_explosao


cria_explosao:
	; cria explosão
	MOV R2, DEF_POS_EXPLOSAO
	MOV R1, [R10]				; posição x da esquerda do meteoro
	MOV [R2], R1				; coloca na posição x da explosão
	MOV R1, [R10+2]				; posição y de cima do meteoro
	ADD R2, 2
	MOV [R2], R1				; coloca na posição y da explosão

	; reproduz som quando há uma colisão
	MOV R6, SOM_EXPLOSAO		; número do som da explosão
	CALL efeito_sonoro

	; põe contador da explosão a 3
	MOV R2, EXPLOSAO_COUNTER
	MOV R1, 3
	MOV [R2], R1

	CALL cria_meteoro
	MOV R1, -1
	MOV [R0+2], R1

deteta_colisoes_fim:
	POP R10
	POP R9
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; MUDA_ECRÃ
;
; Argumentos - R0 número do ecrã para que mudar
; **********************************************************************

muda_ecra:
	PUSH R1
	MOV R1, SELECIONA_ECRÃ
	MOV [R1], R0
	POP R1
	RET

; **********************************************************************
; MUDA_ECRÃ
;
; Argumentos - R6 número do efeito sonoro a reproduzir
; **********************************************************************
efeito_sonoro:
	PUSH R7
	MOV R7, TERMINA_MEDIA
	MOV [R7], R6				; termina o som anterior de tocar
	MOV R7, TOCA_SOM
	MOV [R7], R6				; reproduz o som
	POP R7
	RET


; **********************************************************************
; **********************************************************************
; 							PROCESSOS
; **********************************************************************
; **********************************************************************


; **********************************************************************
; Processo
; MOVE_METEORO - processo que move o meteoro até chegar ao fim do ecrã,
;				criando um novo nesse caso
;
; **********************************************************************

PROCESS SP_inicial_meteoro

move_meteoro:
	MOV R0, 0
	MOV R4, DEF_POS_METEORO
	MOV R9, [R4]	; número de meteoros
	SHL R9, 1
	ADD R4, 4

move_meteoro_ciclo:
	CALL redesenha_ecra
	MOV R1, [evento_int_meteoros]
	MOV R8, R9	 			; cópia temporária de nº de meteoros
	MOV R3, R4	 			; cópia temporária de tabela de posições
	MOV R5, 0

	move_meteoro_ciclo_2:
		SUB R8, 2
		CMP R8, 0
		JLT move_meteoro_ciclo
		MOV R10, [R3]				; valor da posição y do meteoro
		ADD R10, 1			
		MOV [R3], R10				; atualiza posição y do meteoro
		MOV R0, DEF_POS_PEW_PEW
		CALL deteta_colisoes		; verifica se houve colisão com o míssil
		MOV R0, DEF_POS_NAVE	
		CALL deteta_colisoes		; verifica se houve colisão com a nave
		MOV R2, MAX_LINHA
		CMP R10, R2								; verifica se chegou à linha máxima
		JNZ move_meteoro_ciclo_2_continua		; continua ciclo enquanto não chegar à linha máxima
		CALL cria_meteoro						; caso contrário cria um novo meteoro
		move_meteoro_ciclo_2_continua:
		ADD R3, 4
		ADD R5, 4
		JMP move_meteoro_ciclo_2


; **********************************************************************
; Processo
; AVANCA_MISSIL - processo que avança a posição do míssil
;
; **********************************************************************

PROCESS SP_inicial_missil	

avanca_missil:
	MOV R0, DEF_POS_PEW_PEW
	MOV R1, ALCANCE_MISSIL

atualiza_missil:
	CALL redesenha_ecra
	MOV R10, [evento_int_missil]

	MOV R5, [R0+2]		; posição y do míssil
	SUB R5, 1			; avança o míssil
	CMP R5, R1			; verifica se a o míssil chega à linha 16
	JGT atualiza_missil_fim
	MOV R5, -1

atualiza_missil_fim:
	MOV [R0+2], R5
	JMP atualiza_missil

; **********************************************************************
; Processo
; CONTROLA_ENERGIA - Processo que atualiza o valor mostrado nos displays
;
; **********************************************************************
PROCESS SP_inicial_displays	

controla_energia:
	MOV R0, ENERGIA
	MOV R1, DISPLAYS
	MOV R7, ENERGIA_INICIAL

atualiza_display:
	CALL converte_hex		; converte valor de energia para ser legível nos displays
	MOV [R1], R9			; atualiza valor no display

	MOV R2, [evento_int_displays]

	MOV R7, [R0]			; valor da energia em decimal
	ADD R7, R2
	MOV [R0], R7			; atualiza valor da energia

	; caso em que a energia chega a 0
	CMP R7, 0
	JNZ atualiza_display

	MOV R2, ESTADO_JOGO
	MOV R3, ESTADO_PERDEU_1
	MOV [R2], R3
	JMP atualiza_display


; **********************************************************************
; **********************************************************************
; 						ROTINAS DE INTERRUPÇÃO
; **********************************************************************
; **********************************************************************

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupcão 0
;			Assinala o evento da variável evento_int_meteoros
; **********************************************************************
rot_int_0:
	MOV	[evento_int_meteoros], R0	; desbloqueia processo meteoros
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupcão 1
;			Assinala o evento da variável evento_int_missil
; **********************************************************************
rot_int_1:
	MOV	[evento_int_missil], R0	; desbloqueia processo avanca_missil
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupcão 2
;			Assinala o evento da variável evento_int_displays
; **********************************************************************
rot_int_2:
	PUSH R0
	MOV R0, ENERGIA_RELOGIO
	MOV	[evento_int_displays], R0	; desbloqueia processo controla_energia
	POP R0
	RFE