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
TIMER_CONTROL   	EQU     	FFF7h
INTERRUPTION_MASK   EQU     	FFFAh
ROW_SHIFT			EQU			8d
ROW_LIMIT			EQU			24d
COL_LIMIT			EQU			80d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
L0              STR     '################################################################################', FIM_TEXTO
L1              STR     '#                                   Jogo da Cobrinha                           #', FIM_TEXTO
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

LFim_Jogo		STR		'*****GAME OVER*****                            #', FIM_TEXTO

Char            WORD    'o'
RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d
HeadRowPosition	WORD	12d
HeadColPosition	WORD	40d
TailRowPosition	WORD	12d
TailColPosition	WORD	39d

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h

                ORIG    FE0Fh
INT15   WORD    Timer

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
; Rotina para executar o timer
;------------------------------------------------------------------------------
Timer:  PUSH    R1
        PUSH    R2

        MOV     R1, M[ HeadRowPosition ]
        MOV     R2, M[ HeadColPosition ]
        SHL     R1, ROW_SHIFT
        OR      R1, R2
        MOV     M[ CURSOR ], R1
        MOV     R1, M[ Char ]
        MOV     M [IO_WRITE ], R1

        MOV     R1, M[ TailRowPosition ]
        MOV     R2, M[ TailColPosition ]
        SHL     R1, ROW_SHIFT
        OR      R1, R2
        MOV     M[ CURSOR ], R1
        MOV     R1, M[ Char ]
        MOV     M [IO_WRITE ], R1

        CALL	ClearPath
		INC     M[ HeadColPosition ]
		INC		M[ TailColPosition ]

		MOV		R1, M[ HeadColPosition ]
		CMP		R1, COL_LIMIT
		CALL.NZ	InitializeTimer

        CALL	PrintEnd	;;NÃO SEI PQ ESSA PORRA FICA PRINTANDO TODA FUCKING HORA NESSE CARALHO!

    	POP     R2
		POP     R1
	    RTI

;------------------------------------------------------------------------------
; Rotina para inicializar o timer
;------------------------------------------------------------------------------
InitializeTimer:	PUSH 	R1
					PUSH	R2

					MOV     R1, 5d
					MOV     M[ TIMER_COUNT ], R1
					MOV     R1, 1d
					MOV     M[ TIMER_CONTROL ], R1

EndRoutine:			POP		R2
					POP 	R1
					RET

;------------------------------------------------------------------------------
; Rotina para limpar o espaço anterior
;------------------------------------------------------------------------------
ClearPath:	PUSH 	R1
			PUSH	R2

			MOV     R1, M[ TailRowPosition ]
        	MOV     R2, M[ TailColPosition ]
			DEC 	R2
        	SHL     R1, ROW_SHIFT
        	OR      R1, R2
        	MOV     M[ CURSOR ], R1
        	MOV     R1, ' '
        	MOV     M [IO_WRITE ], R1
			
			POP		R2
			POP 	R1
			RET					

;------------------------------------------------------------------------------
; Rotina para escrever o mapa
;------------------------------------------------------------------------------
WriteMap: 	PUSH	R1
			PUSH	R2
			PUSH	R3
			PUSH	R4

			MOV     R1, L0
			MOV		M[ TextIndex ], R1
			MOV		R4, M[ TextIndex ]

WriteCol:	MOV		R2, 0d

WriteChar:	MOV		R3, M[ R4 ]
			MOV		R1, M[ RowIndex ]
			SHL		R1, ROW_SHIFT
			OR		R1, R2
			MOV		M[ CURSOR ], R1
			MOV     M[ IO_WRITE ], R3
			INC		R2
			INC		R4
			CMP		R3, FIM_TEXTO
			JMP.NZ	WriteChar

			INC		M[ RowIndex ]
			MOV		R1, M[ RowIndex ]
			CMP		R1, ROW_LIMIT
			JMP.NZ	WriteCol

EndWrite:	POP		R4
			POP		R3
			POP		R2
			POP		R1
			RET

;------------------------------------------------------------------------------
; Rotina para encerrar o jogo
;------------------------------------------------------------------------------
PrintEnd: 	PUSH	R1
			PUSH	R2
			PUSH	R3
			PUSH	R4

			MOV     R1, LFim_Jogo
			MOV		M[ TextIndex ], R1
			MOV		R4, M[ TextIndex ]
			MOV		R2, 32d

WriteEndC:	MOV		R3, M[ R4 ]
			MOV		R1, 12d
			SHL		R1, ROW_SHIFT
			OR		R1, R2
			MOV		M[ CURSOR ], R1
			MOV     M[ IO_WRITE ], R3
			INC		R2
			INC		R4
			CMP		R3, FIM_TEXTO
			JMP.NZ	WriteEndC

EndGame:	POP		R4
			POP		R3
			POP		R2
			POP		R1
			RET

;------------------------------------------------------------------------------
; Main
;------------------------------------------------------------------------------
Main:	ENI
		
		MOV		R1, INITIAL_SP
		MOV		SP, R1		 		; We need to initialize the stack
		MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
		MOV		M[ CURSOR ], R1		; with value CURSOR_INIT
		
		CALL 	WriteMap
		CALL	InitializeTimer

Cycle: 			BR		Cycle	
Halt:           BR		Halt
