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
SELECIONA_VIDEO_FUNDO	EQU 605CH	; endereço do comando para selecionar um video de fundo

LINHA_NAVE        	EQU  16        ; linha da nave (a meio do ecrã))
COLUNA_NAVE			EQU  30        ; coluna da nave (a meio do ecrã)

LINHA_METEORO_BOM   EQU  5         ; linha do meteoro bom
COLUNA_METEORO_BOM  EQU  30        ; coluna do meteoro bom

LARGURA_NAVE	    EQU	5			; largura da nave
ALTURA_NAVE		    EQU 4           ; altura da nave
COR_NAVE	        EQU	0FF9CH		; cor da nave: rosa em ARGB (opaco e vermelho no máximo, verde a 60 e azul a 40)

LARGURA_METEORO_BOM EQU 5           ; largura do meteoro bom
ALTURA_METEORO_BOM  EQU 5           ; altura do meteoro bom
COR_METEORO_BOM     EQU 0F8F8H

LARGURA_METEORO_MAU EQU 5           ; largura do meteoro bom
ALTURA_METEORO_MAU  EQU 5           ; altura do meteoro bom
COR_METEORO_MAU     EQU 0FF00H		; cor do meteoro mau: vermelho em ARGB ( opaco e vermelho ao máximo, verde e azul a 0)

; #######################################################################
; * ZONA DE DADOS 
; #######################################################################
	PLACE		0100H				

DEF_NAVE:					; tabela que define a nave (cor, largura, altura)
	WORD		LARGURA_NAVE, ALTURA_NAVE               ; largura e altura da nave
    WORD        0, 0, COR_NAVE, 0, 0
	WORD		COR_NAVE, 0, COR_NAVE, 0, COR_NAVE		
	WORD		COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE    
    WORD        0, COR_NAVE, 0, COR_NAVE, 0

DEF_METEORO_BOM :           ; tabela que define o meteoro bom
    WORD        LARGURA_METEORO_BOM, ALTURA_METEORO_BOM ; largura e altura do meteoro bom
    WORD        0, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, 0
    WORD        COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM
    WORD        COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM
    WORD        COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM
    WORD        0, COR_METEORO_BOM, COR_METEORO_BOM, COR_METEORO_BOM, 0

DEF_METEORO_MAU:						; tabela que define o boneco do meteoro mau
	WORD		LARGURA_METEORO_MAU, ALTURA_METEORO_MAU
	WORD		COR_METEORO_MAU, 0, 0, 0, COR_METEORO_MAU
	WORD		COR_METEORO_MAU, 0, COR_METEORO_MAU, 0, COR_METEORO_MAU
	WORD		0, COR_METEORO_MAU, COR_METEORO_MAU, COR_METEORO_MAU, 0
	WORD		COR_METEORO_MAU, 0, COR_METEORO_MAU, 0, COR_METEORO_MAU
	WORD		COR_METEORO_MAU, 0, 0, 0, COR_METEORO_MAU


; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE   0				; o código tem de começar em 0000H
inicio:
     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 1			; cenário de fundo número 0
     MOV  [SELECIONA_VIDEO_FUNDO], R1	; seleciona o cenário de fundo
     
posição_nave:
     MOV  R1, LINHA_NAVE		; linha da nave
     MOV  R2, COLUNA_NAVE		; coluna da nave

desenha_nave:       		; desenha o boneco a partir da tabela
	MOV	R4, DEF_NAVE		; endereço da tabela que define o boneco
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD	R4, 2				; endereço da cor do 1º pixel (2 porque a largura é uma word)
	MOV R6, [R4]			; obtém a altura do boneco
	ADD R4, 2				; endereço da cor do 2º pixel (2 porque a altura é uma word)

posição_meteoro_bom:
    MOV
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
	MOV R5, LARGURA_NAVE				; repor a largura
	MOV R2, COLUNA_NAVE				; alterar a coluna para a inicial
	SUB R6, 1					; menos uma coluna para tratar
	JNZ desenha_linha 			; continua até percorrer toda a largura da segunda linha

fim:
     JMP  fim                 ; termina programa
