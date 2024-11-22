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
TIMER_CONTROL   	EQU     	FFF7h			;BUGADO PARA TROCAR AS POSIÇÕES E O MENU TÁ MAL FEITO
INTERRUPTION_MASK   EQU     	FFFAh			;O TIMER NÃO PARA MESMO QUANDO ENCERRA O JOGO (DEVIDO AO TIMER SE CHAMAR NOVAMENTE SE REATIVANDO)
ROW_SHIFT			EQU			8d				;COBRA DE TAMANHO 1 NÃO LIMPA DIREITO O CAMINHO PERCORRIDO (agora limpa, na força bruta, mas limpa)
ROW_LIMIT			EQU			24d				;COBRA MAIOR QUE 1 NÃO FUNCIONA
COL_LIMIT_RIGHT		EQU			80d				
COL_LIMIT_LEFT		EQU			1d
ROW_LIMIT_DOWN		EQU			23d
ROW_LIMIT_UP		EQU			2d
U_KEY				EQU			1d 
L_KEY				EQU			2d
D_KEY				EQU			3d
R_KEY				EQU			4d

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
HeadRowPosition	WORD	12d
HeadColPosition	WORD	40d
TailRowPosition	WORD	12d
TailColPosition	WORD	40d
LastKeyPressed	WORD	L_KEY

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    KeyboardRead1                
                ORIG    FE01h
INT1            WORD    KeyboardRead2
                ORIG    FE02h
INT2            WORD    KeyboardRead3
                ORIG    FE03h
INT3            WORD    MovUpPressed
                ORIG    FE04h
INT4            WORD    MovLeftPressed
                ORIG    FE05h
INT5            WORD    MovDownPressed
                ORIG    FE06h
INT6            WORD    MovRightPressed

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
Timer:		PUSH    R1

			MOV		R1, M[ LastKeyPressed ]

			CMP R1, R_KEY
         	CALL.Z MovRight

			CMP R1, U_KEY
         	CALL.Z MovUp

			CMP R1, D_KEY
         	CALL.Z MovDown

			CMP R1, L_KEY
         	CALL.Z 	MovLeft

			CALL	InitializeTimer

EndTimer:	POP     R1
	    	RTI

;------------------------------------------------------------------------------
; Rotina para inicializar o timer
;------------------------------------------------------------------------------
InitializeTimer:	PUSH 	R1
					PUSH	R2

					MOV		R1, M[ HeadColPosition ]
					CMP		R1, COL_LIMIT_RIGHT
					JMP.Z 	EndRoutine

					MOV		R1, M[ HeadColPosition ]
					MOV		R2, COL_LIMIT_LEFT
					DEC		R2
					CMP		R1, R2
					JMP.Z 	EndRoutine

					MOV     R1, 2d
					MOV     M[ TIMER_COUNT ], R1
					MOV     R1, 1d
					MOV     M[ TIMER_CONTROL ], R1

EndRoutine:			POP		R2
					POP 	R1
					RET

;------------------------------------------------------------------------------
; Rotina para mover para direita
;------------------------------------------------------------------------------
MovRightPressed:PUSH	R1

				MOV		R1, R_KEY
				MOV		M[ LastKeyPressed ], R1

				POP		R1
				RTI

;------------------------------------------------------------------------------
; Rotina para mover para esquerda
;------------------------------------------------------------------------------
MovLeftPressed:	PUSH	R1

				MOV		R1, L_KEY
				MOV		M[ LastKeyPressed ], R1

				POP		R1
				RTI

;------------------------------------------------------------------------------
; Rotina para mover para baixo
;------------------------------------------------------------------------------
MovDownPressed:	PUSH	R1

				MOV		R1, D_KEY
				MOV		M[ LastKeyPressed ], R1

				POP		R1
				RTI

;------------------------------------------------------------------------------
; Rotina para mover para cima
;------------------------------------------------------------------------------
MovUpPressed:	PUSH	R1

				MOV		R1, U_KEY
				MOV		M[ LastKeyPressed ], R1

				POP		R1
				RTI

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
                JMP.NZ  EndRead3

Option1:        MOV     R1, 0d
                MOV     M[ RowIndex ], R1
                CALL 	WriteMap
				CALL	InitializeTimer

EndRead3:       POP     R3
                POP     R2
                POP     R1
                RTI
;------------------------------------------------------------------------------
; Rotina para mover para cima
;------------------------------------------------------------------------------
MovUp:      PUSH    R1
            PUSH    R2

            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [ IO_WRITE ], R1

            MOV     R1, M[ TailRowPosition ]
            MOV     R2, M[ TailColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [IO_WRITE ], R1

            CALL	ClearPathUp
			CALL	ClearPathLeft
			CALL	ClearPathRight
            DEC     M[ HeadRowPosition ]
            DEC		M[ TailRowPosition ]

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_UP	
            CALL.Z	PrintEnd
            
            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para direita
;------------------------------------------------------------------------------
MovRight:   PUSH    R1
            PUSH    R2

            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [ IO_WRITE ], R1

            MOV     R1, M[ TailRowPosition ]
            MOV     R2, M[ TailColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [ IO_WRITE ], R1

            CALL	ClearPathRight
			;CALL	ClearPathUp
			;CALL	ClearPathDown
            INC     M[ HeadColPosition ]
            INC		M[ TailColPosition ]

            MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_RIGHT
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para esquerda
;------------------------------------------------------------------------------
MovLeft:    PUSH    R1
            PUSH    R2

            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [ IO_WRITE ], R1

            MOV     R1, M[ TailRowPosition ]
            MOV     R2, M[ TailColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [IO_WRITE ], R1

            CALL	ClearPathLeft
			CALL	ClearPathUp
			CALL	ClearPathDown
            DEC     M[ HeadColPosition ]
            DEC		M[ TailColPosition ]

            MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_LEFT
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para baixo
;------------------------------------------------------------------------------
MovDown:    PUSH    R1
            PUSH    R2

            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [ IO_WRITE ], R1

            MOV     R1, M[ TailRowPosition ]
            MOV     R2, M[ TailColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M [IO_WRITE ], R1

            CALL	ClearPathDown
			CALL	ClearPathLeft
			CALL	ClearPathRight
            INC     M[ HeadRowPosition ]
            INC		M[ TailRowPosition ]

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_DOWN
            CALL.Z	PrintEnd
            
            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para limpar o espaço anterior
;------------------------------------------------------------------------------
ClearPathRight:	PUSH 	R1
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
; Rotina para limpar o espaço anterior
;------------------------------------------------------------------------------
ClearPathLeft:	PUSH 	R1
				PUSH	R2

				MOV     R1, M[ TailRowPosition ]
				MOV     R2, M[ TailColPosition ]
				INC 	R2
				SHL     R1, ROW_SHIFT
				OR      R1, R2
				MOV     M[ CURSOR ], R1
				MOV     R1, ' '
				MOV     M [IO_WRITE ], R1
				
				POP		R2
				POP 	R1
				RET	

;------------------------------------------------------------------------------
; Rotina para limpar o espaço anterior
;------------------------------------------------------------------------------
ClearPathDown:	PUSH 	R1
				PUSH	R2

				MOV     R1, M[ TailRowPosition ]
				MOV     R2, M[ TailColPosition ]
				DEC 	R1
				SHL     R1, ROW_SHIFT
				OR      R1, R2
				MOV     M[ CURSOR ], R1
				MOV     R1, ' '
				MOV     M [IO_WRITE ], R1
				
				POP		R2
				POP 	R1
				RET					

;------------------------------------------------------------------------------
; Rotina para limpar o espaço anterior
;------------------------------------------------------------------------------
ClearPathUp:	PUSH 	R1
				PUSH	R2

				MOV     R1, M[ TailRowPosition ]
				MOV     R2, M[ TailColPosition ]
				INC 	R1
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
			MOV		R2, 0d

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

EndGame:	MOV     R1, 0d
			MOV     M[ TIMER_CONTROL ], R1

			POP		R4
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
		
		;CALL	WirteMenu
		CALL 	WriteMap
		CALL	InitializeTimer

Cycle: 			BR		Cycle	
Halt:           BR		Halt
