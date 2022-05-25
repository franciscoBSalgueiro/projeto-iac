; *********************************************************************************
; * IST-UL
; * Modulo:    lab5-boneco.asm
; * Descrição: Este programa ilustra o desenho de um boneco do ecrã, usando rotinas.
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


LINHA_NAVE        		EQU  26        ; linha do boneco (a meio do ecrã))
COLUNA_NAVE				EQU  30        ; coluna do boneco (a meio do ecrã)

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
; * TABELAS DE DESENHOS 
; #######################################################################

PLACE		1000H				

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
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; à última da pilha
                            
	MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
	MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 1			; cenário de fundo número 0
	MOV  [SELECIONA_VIDEO_FUNDO], R1	; seleciona o cenário de fundo
     
     MOV  R1, LINHA_NAVE			; linha do boneco
	MOV  R2, COLUNA_NAVE		; coluna do boneco
	MOV	R4, DEF_NAVE		; endereço da tabela que define o boneco
	CALL	desenha_boneco		; desenha o boneco

fim:
	JMP  fim                 ; termina programa


; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD R4, 2				
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:
	desenha_coluna:       		; desenha os pixels do boneco a partir da tabela
		MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
		CALL escreve_pixel
		ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1               ; próxima coluna
		SUB  R5, 1			; menos uma coluna para tratar
		JNZ  desenha_coluna      ; continua até percorrer toda a largura da primeira linha
	ADD R1, 1					; próxima linha
	MOV R5, LARGURA_NAVE				; repor a largura
	MOV R2, COLUNA_NAVE				; alterar a coluna para a inicial
	SUB R6, 1					; menos uma coluna para tratar
	JNZ desenha_pixels 			; continua até percorrer toda a largura da segunda linha
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
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
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET

