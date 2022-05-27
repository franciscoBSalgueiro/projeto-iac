; *********************************************************************************
; * IST-UL
; * Modulo:    lab5-boneco.asm
; * Descrição: Este programa ilustra o desenho de um boneco do ecrã, usando rotinas.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO			EQU 8		; linha a testar (4ª linha, 1000b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA			EQU 1		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA			EQU 2		; tecla na segunda coluna do teclado (tecla D)

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

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO			EQU	8000H		; atraso para limitar a velocidade de movimento do boneco

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
	MOV	R1, 1			; cenário de fundo número 0
	MOV  [SELECIONA_VIDEO_FUNDO], R1	; seleciona o cenário de fundo
    
    MOV  R1, Y_NAVE			; linha da nave
	MOV  R2, X_NAVE		; coluna da nave
    MOV	R4, DEF_NAVE		; endereço da tabela que define a nave

mostra_boneco:
    ; desenhar nave
	MOV R0, 1
	MOV R1, Y_NAVE
	MOV R4, DEF_NAVE
	CALL	desenha_boneco		; desenha o boneco


espera_tecla:				; neste ciclo espera-se até uma tecla ser premida
	MOV  R6, LINHA_TECLADO	; linha a testar no teclado
	CALL	teclado			; leitura às teclas
	CMP	R9, 0
	JZ	espera_tecla		; espera, enquanto não houver tecla
	CMP	R9, TECLA_ESQUERDA
	JNZ	testa_direita
	MOV	R7, -1			; vai deslocar para a esquerda
	JMP	ve_limites
testa_direita:
	CMP	R9, TECLA_DIREITA
	JNZ	espera_tecla		; tecla que não interessa
	MOV	R7, +1			; vai deslocar para a direita

ve_limites:
	MOV	R6, [R4]			; obtém a largura do boneco
	CALL	testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0
	JZ	espera_tecla		; se não é para movimentar o objeto, vai ler o teclado de novo

move_boneco:
	MOV R11, ATRASO
	CALL atraso
    ; apagar nave
	MOV R0, 0
	MOV R1, Y_NAVE
	MOV R4, DEF_NAVE
	CALL	desenha_boneco

coluna_seguinte:
	ADD	R2, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)
	JMP	mostra_boneco		; vai desenhar o boneco de novo

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
    PUSH    R8
	MOV	R5, [R4]			; obtém a largura do boneco
    MOV R8, [R4]
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
	MOV R5, R8				; repor a largura
	SUB R2, R8				; alterar a coluna para a inicial
	SUB R6, 1					; menos uma coluna para tratar
	JNZ desenha_pixels 			; continua até percorrer toda a largura da segunda linha
    POP R8
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
	CMP	R7, 0			; passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento	; entre limites. Mantém o valor do R7
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2			; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; entre limites. Mantém o valor do R7
	CMP	R7, 0			; passa a deslocar-se para a direita
	JGT	impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0			; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5
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
