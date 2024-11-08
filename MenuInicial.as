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
CURSOR		EQU     FFFCh
CURSOR_INIT	EQU	FFFFh
ROW_POSITION	EQU	0d
COL_POSITION	EQU	0d
ROW_SHIFT	EQU	8d
COLUMN_SHIFT	EQU	8d

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

RowLimit		WORD	24d
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
; Função para escrever o mapa
;------------------------------------------------------------------------------
WriteMap:	PUSH	R1
		PUSH	R2
		PUSH	R3
		PUSH	R4

		MOV	R4, M[TextIndex]

WriteCol:	MOV	R2, 0d

WriteChar:	MOV	R3, M[ R4 ]
		MOV	R1, M[ RowIndex ]
		SHL	R1, ROW_SHIFT
		OR	R1, R2
		MOV	M[ CURSOR ], R1
		MOV     M[ IO_WRITE ], R3
		INC	R2
		INC	R4
		CMP	R3, FIM_TEXTO
		JMP.NZ	WriteChar

		INC	M[ RowIndex ]
		MOV	R1, M[ RowIndex ]
		CMP	R1, M[ RowLimit ]
		JMP.NZ	WriteCol

EndWrite:	POP	R4
		POP	R3
		POP	R2
		POP	R1
		RET

;------------------------------------------------------------------------------
; Função para escrever o Menu
;------------------------------------------------------------------------------
WriteMenu:     	PUSH    R1
                PUSH    R2
				
		MOV     R1, L0
		MOV	M[ TextIndex ], R1
		CALL 	WriteMap

                POP     R2
                POP     R1
                RET

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:	ENI

	MOV	R1, INITIAL_SP
	MOV	SP, R1		 	; We need to initialize the stack
	MOV	R1, CURSOR_INIT		; We need to initialize the cursor 
	MOV	M[ CURSOR ], R1		; with value CURSOR_INIT
				
	CALL	WriteMenu

Cycle: 	BR		Cycle	
Halt:  	BR		Halt
