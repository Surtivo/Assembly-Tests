;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
Text			STR     'Hello World!', FIM_TEXTO
RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Rotina para printar string
;------------------------------------------------------------------------------
Funcao: 	PUSH	R1
			PUSH	R2

Write:		MOV		R1, M[ TextIndex ]
			MOV		R1, M[ R1 ]
			CMP 	R1, FIM_TEXTO
			JMP.Z	EndWrite
			MOV     M[ IO_WRITE ], R1
			INC		M[ ColumnIndex ]
			INC		M[ TextIndex ]
			MOV		R1, M[ RowIndex ]
			MOV		R2, M[ ColumnIndex ]
			SHL		R1, ROW_SHIFT
			OR		R1, R2
			MOV		M[ CURSOR ], R1
			JMP 	Write

EndWrite:	POP		R2
			POP		R1
			RET
;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT
				
				MOV     R1, Text
				MOV		M[ TextIndex ], R1
				CALL 	Funcao

Cycle: 			BR		Cycle	
Halt:           BR		Halt