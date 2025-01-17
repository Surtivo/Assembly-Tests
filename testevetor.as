;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              	EQU     	0Ah
FIM_TEXTO       	EQU     	'@'
IO_READ         	EQU     	FFFFh
IO_WRITE        	EQU     	FFFEh
IO_STATUS       	EQU     	FFFDh
INITIAL_SP      	EQU     	FDFFh
CURSOR		    	EQU     	FFFCh
CURSOR_INIT			EQU			FFFFh
TIMER_COUNT     	EQU     	FFF6h
TIMER_CONTROL   	EQU     	FFF7h			;O MENU TÁ MAL FEITO
INTERRUPTION_MASK   EQU     	FFFAh			;O TIMER NÃO PARA MESMO QUANDO ENCERRA O JOGO (REOSLVIDO)
ROW_SHIFT			EQU			8d				;COBRA DE TAMANHO 1 NÃO LIMPA DIREITO O CAMINHO PERCORRIDO (agora limpa, na força bruta, mas limpa)
ROW_LIMIT			EQU			24d				;COBRA MAIOR QUE 1 NÃO FUNCIONA
COL_LIMIT_RIGHT		EQU			79d				;RAMDOM GERA VALORES ALEATORIO ENTRE 0 E 24
COL_LIMIT_LEFT		EQU			0d
ROW_LIMIT_DOWN		EQU			23d
ROW_LIMIT_UP		EQU			2d
U_KEY				EQU			1d 
L_KEY				EQU			2d
D_KEY				EQU			3d
R_KEY				EQU			4d


; padrao de bits para geracao de numero aleatorio
RND_MASK		EQU	8016h	; 1000 0000 0001 0110b
							; 1010 0101 1010 0101
							; 0010 0101 1011 0011 -> 0100 1011 0110 0110 (depois do ROR)
LSB_MASK		EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	EQU 11d
PRIME_NUMBER_2	EQU 13d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
L0              STR     '################################################################################', FIM_TEXTO
L1              STR     '#      Jogo da Cobrinha                                        Score: 0000     #', FIM_TEXTO
L2              STR     '################################################################################', FIM_TEXTO
L3              STR     '#                                                                              #', FIM_TEXTO
L4              STR     '#                                                                              #', FIM_TEXTO
L5              STR     '#                                                                              #', FIM_TEXTO
L6              STR     '#                                                                              #', FIM_TEXTO
L7              STR     '#                                                                              #', FIM_TEXTO
L8              STR     '#                                                                              #', FIM_TEXTO
L9              STR     '#                                                                              #', FIM_TEXTO
L10             STR     '#                                                                              #', FIM_TEXTO
L11             STR     '#                                                                              #', FIM_TEXTO
L12             STR     '#                                                                              #', FIM_TEXTO
L13             STR     '#                                                                              #', FIM_TEXTO
L14             STR     '#                                                                              #', FIM_TEXTO
L15             STR     '#                                                                              #', FIM_TEXTO
L16             STR     '#                                                                              #', FIM_TEXTO
L17             STR     '#                                                                              #', FIM_TEXTO
L18             STR     '#                                                                              #', FIM_TEXTO
L19             STR     '#                                                                              #', FIM_TEXTO
L20             STR     '#                                                                              #', FIM_TEXTO
L21             STR     '#                                                                              #', FIM_TEXTO
L22             STR     '#                                                                              #', FIM_TEXTO
L23             STR     '################################################################################', FIM_TEXTO

LFim_Jogo		STR		'#                              *****GAMEOVER*****                              #', FIM_TEXTO
L10_Menu        STR     '#                                *Iniciar Jogo*                                #', FIM_TEXTO
L12_Menu        STR     '#                                    *Sair*                                    #', FIM_TEXTO

Char            WORD    'o'
CharFruit		WORD	'*'
RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d
HeadRowPosition	WORD	12d
HeadColPosition	WORD	40d
TailRowPosition	WORD	12d
TailColPosition	WORD	40d
LastKeyPressed	WORD	L_KEY
SnakeHead		TAB		20d

FruitRowPos		WORD	12d
FruitColPos		WORD	29d
ScoreValue		WORD	0d
ScoreUnit		WORD	'0'
ScoreDez		WORD	'0'
ScoreCem		WORD	'0'
ScoreMil		WORD	'0'

Random_Var	WORD	A5A5h  ; 1010 0101 1010 0101
RandomState WORD	1d

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;******************************************************************************
;******************************************************************************
;******************************************************************************


;------------------------------------------------------------------------------
; Main
;------------------------------------------------------------------------------
Main:	ENI
		
		MOV		R1, INITIAL_SP
		MOV		SP, R1		 		; We need to initialize the stack
		MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
		MOV		M[ CURSOR ], R1		; with value CURSOR_INIT
		
		MOV		R1, 12d
		MOV		R2, 24d
		SHL		R1, ROW_SHIFT
		OR		R1, R2
        
        MOV     R3, 0d
        MOV     M[ R3 + SnakeHead ], R1
        MOV     R5, M[ R3 + SnakeHead ]
		MOV     M[ CURSOR ], R5
        MOV     R4, '0'
        MOV     M[ IO_WRITE ], R4

        INC     R3
        ADD     R1, 2d
        MOV     M[ R3 + SnakeHead ], R1
        MOV     R5, M[ R3 + SnakeHead ]
		MOV     M[ CURSOR ], R5
        MOV     R4, '0'
        MOV     M[ IO_WRITE ], R4


Cycle: 			BR		Cycle	
Halt:           BR		Halt
