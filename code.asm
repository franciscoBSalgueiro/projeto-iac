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


Y_NAVE        		EQU  26        ; linha da nave 
X_NAVE				EQU  30        ; coluna da nave 

Y_METEORO           EQU 10         ; linha meteoro
X_METEORO           EQU 20         ; coluna meteoro

Y_NAVE_MÁ           EQU 10         ; linha nave má
X_NAVE_MÁ           EQU 50         ; coluna nave má


L_NAVE	    	EQU	5			; largura da nave
H_NAVE		    EQU 4           ; altura da nave
COR_NAVE	    EQU	0FF9CH		; cor da nave: rosa em ARGB (opaco e vermelho no máximo, verde a 60 e azul a 40)

L_METEORO 		EQU 5           ; largura do meteoro
H_METEORO  		EQU 5           ; altura do meteoro
COR_METEORO     EQU 0F8F8H

L_NAVE_MÁ 		EQU 5           ; largura da nave má
H_NAVE_MÁ  		EQU 5           ; altura da nave má
COR_NAVE_MÁ     EQU 0FF00H		; cor da nave má: vermelho em ARGB (opaco e vermelho ao máximo, verde e azul a 0)

; #######################################################################
; * TABELAS DE DESENHOS 
; #######################################################################

PLACE		1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)				

DEF_NAVE:					; tabela que define a nave (cor, largura, altura)
	WORD		L_NAVE, H_NAVE               ; largura e altura da nave
    WORD        0, 0, COR_NAVE, 0, 0
	WORD		COR_NAVE, 0, COR_NAVE, 0, COR_NAVE		
	WORD		COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE    
    WORD        0, COR_NAVE, 0, COR_NAVE, 0

DEF_METEORO :           ; tabela que define o meteoro
    WORD        L_METEORO, H_METEORO ; largura e altura do meteoro
    WORD        0, COR_METEORO, COR_METEORO, COR_METEORO, 0
    WORD        COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO
    WORD        COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO
    WORD        COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO, COR_METEORO
    WORD        0, COR_METEORO, COR_METEORO, COR_METEORO, 0

DEF_NAVE_MÁ:						; tabela que define a nave má
	WORD		L_NAVE_MÁ, H_NAVE_MÁ
	WORD		COR_NAVE_MÁ, 0, 0, 0, COR_NAVE_MÁ
	WORD		COR_NAVE_MÁ, 0, COR_NAVE_MÁ, 0, COR_NAVE_MÁ
	WORD		0, COR_NAVE_MÁ, COR_NAVE_MÁ, COR_NAVE_MÁ, 0
	WORD		COR_NAVE_MÁ, 0, COR_NAVE_MÁ, 0, COR_NAVE_MÁ
	WORD		COR_NAVE_MÁ, 0, 0, 0, COR_NAVE_MÁ


; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0				; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; à última da pilha
                            
	MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
	MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
	MOV  [SELECIONA_VIDEO_FUNDO], R1	; seleciona o cenário de fundo
    
    ; desenhar meteoro
    MOV R1, Y_METEORO
    MOV R2, X_METEORO
    MOV R0, 1
    MOV R4, DEF_METEORO
    CALL  desenha_boneco

    ; desenhar nave má
    MOV R1, Y_NAVE_MÁ
    MOV R2, X_NAVE_MÁ
    MOV R0, 1
    MOV R4, DEF_NAVE_MÁ
    CALL  desenha_boneco

    ; desenhar nave
    MOV  R1, Y_NAVE			; linha da nave
	MOV  R2, X_NAVE		; coluna da nave
	MOV R0, 1
    MOV	R4, DEF_NAVE		; endereço da tabela que define a nave
	CALL	desenha_boneco		; desenha o boneco

fim:
	JMP  fim                 ; termina programa


; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R0 - apaga (0) / desenha (1)
;               R1 - linha 
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
    PUSH    R7
	MOV	R5, [R4]			; obtém a largura do boneco
    MOV R7, [R4]
	ADD R4, 2				
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:
	desenha_coluna:       		; desenha os pixels do boneco a partir da tabela
        CMP R0, 0
        JZ else
		MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
        JMP both
        else:
            MOV R3, 0
        both:
		CALL escreve_pixel
		ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1               ; próxima coluna
		SUB  R5, 1			; menos uma coluna para tratar
		JNZ  desenha_coluna      ; continua até percorrer toda a largura da primeira linha
	ADD R1, 1					; próxima linha
	MOV R5, R7				; repor a largura
	SUB R2, R7				; alterar a coluna para a inicial
	SUB R6, 1					; menos uma coluna para tratar
	JNZ desenha_pixels 			; continua até percorrer toda a largura da segunda linha
    POP R7
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

