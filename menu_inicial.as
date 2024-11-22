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
COL_LIMIT_RIGHT		EQU			80d
COL_LIMIT_LEFT		EQU			1d
ROW_LIMIT_DOWN		EQU			23d
ROW_LIMIT_UP		EQU			2d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
L0              STR     '################################################################################', FIM_TEXTO
L1              STR     '#                               Jogo da Cobrinha                               #', FIM_TEXTO
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
RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    KeyboardRead1                
                ORIG    FE01h
INT1            WORD    KeyboardRead2
                ORIG    FE02h
INT2            WORD    KeyboardRead3

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
; Rotina para leitura do telcado
;------------------------------------------------------------------------------
KeyboardRead1:  PUSH    R1
                PUSH    R2

                MOV     R1, M [ IO_STATUS ]
                CMP     R1, 0d
                JMP.NZ  EndRead

                MOV		R1, 13d
                SHL		R1, ROW_SHIFT
                MOV     R2, 35d
                OR		R1, R2
                MOV		M[ CURSOR ], R1
                MOV     R1, ' '
                MOV     M[ IO_WRITE ], R1

                MOV		R1, 11d
                SHL		R1, ROW_SHIFT
                MOV     R2, 31d
                OR		R1, R2
                MOV		M[ CURSOR ], R1
                MOV     R1, '>'
                MOV     M[ IO_WRITE ], R1


EndRead:        POP     R2
                POP     R1
                RTI

;------------------------------------------------------------------------------
; Rotina para leitura do telcado
;------------------------------------------------------------------------------
KeyboardRead2:  PUSH    R1
                PUSH    R2

                MOV     R1, M [ IO_STATUS ]
                CMP     R1, 0d
                JMP.NZ  EndRead2

                MOV		R1, 11d
                SHL		R1, ROW_SHIFT
                MOV     R2, 31d
                OR		R1, R2
                MOV		M[ CURSOR ], R1
                MOV     R1, ' '
                MOV     M[ IO_WRITE ], R1

                MOV		R1, 13d
                SHL		R1, ROW_SHIFT
                MOV     R2, 35d
                OR		R1, R2
                MOV		M[ CURSOR ], R1
                MOV     R1, '>'
                MOV     M[ IO_WRITE ], R1


EndRead2:       POP     R2
                POP     R1
                RTI

;------------------------------------------------------------------------------
; Rotina para leitura do telcado
;------------------------------------------------------------------------------
KeyboardRead3:  PUSH    R1
                PUSH    R2
                PUSH    R3

                MOV     R1, M [ IO_STATUS ]
                CMP     R1, 0d
                JMP.NZ  EndRead3

                MOV		R1, M[ CURSOR ]
                MOV		R2, 11d
                SHL		R2, ROW_SHIFT
                MOV     R3, 31d
                OR		R2, R3
                CMP     R1, R2
                JMP.Z   Option1

Option1:        MOV     R1, 0d
                MOV     M[ RowIndex ], R1
                CALL 	WriteMap

EndRead3:       POP     R3
                POP     R2
                POP     R1
                RTI

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
; Rotina para escrever o menu
;------------------------------------------------------------------------------
WirteMenu: 	PUSH	R1
			PUSH	R2
			PUSH	R3
			PUSH	R4

            CALL 	WriteMap

            MOV     R1, 11d
            MOV     M[ RowIndex ], R1

			MOV     R1, L10_Menu
			MOV		M[ TextIndex ], R1
			MOV		R4, M[ TextIndex ]

WriteColM:	MOV		R2, 0d

WriteCharM:	MOV		R3, M[ R4 ]
			MOV		R1, M[ RowIndex ]
			SHL		R1, ROW_SHIFT
			OR		R1, R2
			MOV		M[ CURSOR ], R1
			MOV     M[ IO_WRITE ], R3
			INC		R2
			INC		R4
			CMP		R3, FIM_TEXTO
			JMP.NZ	WriteCharM

			INC		M[ RowIndex ]
            INC		M[ RowIndex ]
			MOV		R1, M[ RowIndex ]
			CMP		R1, 15d
			JMP.NZ	WriteColM

EndWriteM:	POP		R4
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
		
        CALL    WirteMenu
        ;MOV     R1, 0d
        ;MOV     M[ RowIndex ], R1
        ;CALL 	WriteMap

Cycle: 			BR		Cycle	
Halt:           BR		Halt
