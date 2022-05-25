; *********************************************************************************
; * IST-UL
; * Modulo:    lab4-boneco.asm
; * Descrição: Este programa ilustra o desenho de um boneco do ecrã, em que os pixels
; *            são definidos por uma tabela.
; *			A zona de dados coloca-se tipicamente primeiro, para ser mais visível,
; *			mas o código tem de começar no endereço 0000H. As diretivas PLACE
; *			permitem esta inversão da ordem de dados e código no programa face aos endereços
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
TOCA_SOM                EQU 605AH      ; endereço do comando para tocar um som
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo

LINHA        	EQU  16        ; linha do boneco (a meio do ecrã))
COLUNA			EQU  30        ; coluna do boneco (a meio do ecrã)

LARGURA		EQU	5			; largura da nave
ALTURA		EQU 4           ; altura da nave
COR_NAVE	EQU	0FF9CH		; cor da nave: rosa em ARGB (opaco e vermelho no máximo, verde a 60 e azul a 40)

; #######################################################################
; * ZONA DE DADOS 
; #######################################################################
	PLACE		0100H				

DEF_NAVE:					; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA, ALTURA
    WORD        0, 0, COR_NAVE, 0, 0
	WORD		COR_NAVE, 0, COR_NAVE, 0, COR_NAVE		; # # #   as cores podem ser diferentes
	WORD		COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE    ; # # #   as cores podem ser diferentes
    WORD        0, COR_NAVE, 0, COR_NAVE, 0

     

; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE   0				; o código tem de começar em 0000H
inicio:
     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
     MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
     
posição_boneco:
     MOV  R1, LINHA			; linha do boneco
     MOV  R2, COLUNA		; coluna do boneco

desenha_boneco:       		; desenha o boneco a partir da tabela
	MOV	R4, DEF_NAVE		; endereço da tabela que define o boneco
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2				; endereço da cor do 1º pixel (2 porque a largura é uma word)
	MOV R6, [R4]			; obtém a altura do boneco
	ADD R4, 2				; endereço da cor do 2º pixel (2 porque a altura é uma word)
desenha_linha:
	desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
		MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
		MOV  [DEFINE_LINHA], R1	; seleciona a linha
		MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
		MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
		ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1               ; próxima coluna
		SUB  R5, 1			; menos uma coluna para tratar
		JNZ  desenha_pixels      ; continua até percorrer toda a largura da primeira linha
	ADD R1, 1					; próxima linha
	MOV R5, LARGURA				; repor a largura
	MOV R2, COLUNA				; alterar a coluna para a inicial
	SUB R6, 1					; menos uma coluna para tratar
	JNZ desenha_linha 			; continua até percorrer toda a largura da segunda linha

fim:
     JMP  fim                 ; termina programa
