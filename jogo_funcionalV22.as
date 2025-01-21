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
INTERRUPTION_MASK   EQU     	FFFAh			;FALTA FAZER COLISÃO DA COBRA COM ELA MESMA (feito)
ROW_SHIFT			EQU			8d				;FALTA GARANTIR QUE A FRUTA NÃO VAI SPAWNAR NA COBRA (feito, mas não sei se funciona)
ROW_LIMIT			EQU			24d				;CORRIGIR COLISÃO COM AS PAREDES PARA NÃO DESMANCHAR UMA PAREDE
COL_LIMIT_RIGHT		EQU			79d				;CORRIGIR BUG DA POSIÇÃO (0,0) VIRAR UM ESPAÇO VAZIO (Muito complexo)
COL_LIMIT_LEFT		EQU			0d
ROW_LIMIT_DOWN		EQU			23d
ROW_LIMIT_UP		EQU			2d
U_KEY				EQU			1d 
L_KEY				EQU			2d
D_KEY				EQU			3d
R_KEY				EQU			4d
SNAKE_MAX_TAM       EQU         20d


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
HeadColPosition	WORD	50d
TailRowPosition	WORD	12d
TailColPosition	WORD	40d
LastKeyPressed	WORD	U_KEY
SnakeHead		TAB		20d
SnakeTam        WORD    2d
SnakeColsion	WORD	0d

FruitRowPos		WORD	12d
FruitColPos		WORD	29d
ScoreValue		WORD	2d
ScoreUnit		WORD	'1'
ScoreDez		WORD	'0'
ScoreCem		WORD	'0'
ScoreMil		WORD	'0'

Random_Var	WORD	A5A5h  ; 1010 0101 1010 0101
RandomState WORD	1d

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
			CALL	FruitCheck

			CMP R1, R_KEY
         	CALL.Z 	MovRight
			MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_RIGHT
            JMP.Z 	EndTimer
			MOV		R1, M[ LastKeyPressed ]

			CMP R1, U_KEY
         	CALL.Z 	MovUp
			MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_UP
            JMP.Z 	EndTimer
			MOV		R1, M[ LastKeyPressed ]

			CMP R1, D_KEY
         	CALL.Z 	MovDown
			MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_DOWN
			JMP.Z 	EndTimer
			MOV		R1, M[ LastKeyPressed ]

			CMP R1, L_KEY
         	CALL.Z 	MovLeft
			MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_LEFT
            JMP.Z 	EndTimer
			MOV		R1, M[ LastKeyPressed ]

			CALL	ColisionCheck
			MOV		R1, 1d
			CMP		M[ SnakeColsion ], R1
			JMP.Z	EndTimer
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

					MOV     R1, 3d
					MOV     M[ TIMER_COUNT ], R1
					MOV     R1, 1d
					MOV     M[ TIMER_CONTROL ], R1

EndRoutine:			POP		R2
					POP 	R1
					RET

;------------------------------------------------------------------------------
; Função: RandomV2 (versão 2)
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: M[Random_Var]
; Saidas:   M[Random_Var]
;------------------------------------------------------------------------------

RandomV2:	PUSH	R1
			PUSH 	R2
			PUSH 	R3
			PUSH 	R4

			MOV 	R1, M[ RandomState ]
			MOV 	R2, PRIME_NUMBER_1
			MOV		R3, PRIME_NUMBER_2
			MOV 	R4, 10d

			MUL 	R1, R2 ; Atenção: O resultado da operacao fica em R1 e R2!!!
			ADD 	R2, R3 ; Vamos usar os 16 bits menos significativos da MUL
			MOV 	M[ RandomState ], R2

			DIV 	R2, R4
			;ADD		R4, 3d
			MOV 	M[ Random_Var ], R4
			
			POP R4
			POP R3
			POP	R2
			POP R1
			RET

;------------------------------------------------------------------------------
; Printar vetor
;------------------------------------------------------------------------------
PrintVet:   PUSH    R1
            PUSH    R2
            PUSH    R3

            MOV     R3, 0d

PrintVLoop: CMP     R3, M[ SnakeTam ]
            JMP.Z   EndPrintV
            MOV     R1, M[ R3 + SnakeHead ]
            MOV     M[ CURSOR ], R1
            MOV     R1, M[ Char ]
            MOV     M[ IO_WRITE ], R1
            INC     R3
            JMP     PrintVLoop

EndPrintV:  POP    R3
            POP    R2
            POP    R1
            RET

;------------------------------------------------------------------------------
; Rotina para ajeitar o vetor
;------------------------------------------------------------------------------
VetShift:   PUSH    R1
            PUSH    R2

            MOV     R2, M[ SnakeTam ]
            DEC     R2
            DEC     R2

ShiftLoop:  CMP     R2, 0d
            JMP.Z   EndShift
            MOV     R1, M[ R2 + SnakeHead ]
            INC     R2
            MOV     M[ R2 + SnakeHead ], R1
            DEC     R2
            DEC     R2
            JMP     ShiftLoop

EndShift:   MOV     R1, M[ R2 + SnakeHead ]
            INC     R2
            MOV     M[ R2 + SnakeHead ], R1
            POP     R2
			POP     R1
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
; Rotina limpar no movimento para esquerda
;------------------------------------------------------------------------------
ClearPathLeft:  PUSH    R1
                PUSH    R2

                MOV     R1, M[ SnakeTam ]
                DEC     R1

                MOV     R2, M[ R1 + SnakeHead ]
                MOV     M[ CURSOR ], R2
                MOV     R1, ' '
                MOV     M[ IO_WRITE ], R1

                POP     R2
                POP     R1
                RET

;------------------------------------------------------------------------------
; Rotina para mover para cima
;------------------------------------------------------------------------------
MovUp:      PUSH    R1
            PUSH    R2

            CALL	ClearPathLeft
            CALL    VetShift

            DEC     M[ HeadRowPosition ]
            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     R2, 0d
            MOV     M[ R2 + SnakeHead ], R1

            CALL    PrintVet

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_UP
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para esquerda
;------------------------------------------------------------------------------
MovLeft:    PUSH    R1
            PUSH    R2

            CALL	ClearPathLeft
            CALL    VetShift

            DEC     M[ HeadColPosition ]
            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     R2, 0d
            MOV     M[ R2 + SnakeHead ], R1

            CALL    PrintVet

            MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_LEFT
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para direita
;------------------------------------------------------------------------------
MovRight:	PUSH    R1
            PUSH    R2

            CALL	ClearPathLeft
            CALL    VetShift

            INC     M[ HeadColPosition ]
            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     R2, 0d
            MOV     M[ R2 + SnakeHead ], R1

            CALL    PrintVet

            MOV		R1, M[ HeadColPosition ]
            CMP		R1, COL_LIMIT_RIGHT
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
	    	RET

;------------------------------------------------------------------------------
; Rotina para mover para baixo
;------------------------------------------------------------------------------
MovDown:    PUSH    R1
            PUSH    R2

            CALL	ClearPathLeft
            CALL    VetShift

            INC     M[ HeadRowPosition ]
            MOV     R1, M[ HeadRowPosition ]
            MOV     R2, M[ HeadColPosition ]
            SHL     R1, ROW_SHIFT
            OR      R1, R2
            MOV     R2, 0d
            MOV     M[ R2 + SnakeHead ], R1

            CALL    PrintVet

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_DOWN
            CALL.Z	PrintEnd

            POP     R2
			POP     R1
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
; Rotina Printar as frutas no mapa
;------------------------------------------------------------------------------
PrintFruit:		PUSH	R1
				PUSH	R2
				PUSH	R3

				MOV		R1, M[ FruitRowPos ]
				MOV		R2, M[ FruitColPos ]
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ CharFruit ]
				MOV     M[ IO_WRITE ], R3

				CALL	UpdtadeScore

				POP		R3
				POP		R2
				POP		R1
				RET

;------------------------------------------------------------------------------
; Rotina para checar se a fruta foi comida
;------------------------------------------------------------------------------
FruitCheck:		PUSH	R1
				PUSH	R2

				MOV		R1, M[ HeadRowPosition ]
				MOV		R2, M[ HeadColPosition ]
				CMP		R1, M[ FruitRowPos ]
				JMP.NZ	EndFruitCheck
				CMP		R2, M[ FruitColPos ]
				CALL.Z  GenerateFruit

EndFruitCheck:	POP		R2
				POP		R1
				RET

;------------------------------------------------------------------------------
; Rotina gerar uma nova fruta
;------------------------------------------------------------------------------
GenerateFruit:	PUSH	R1
				PUSH	R2

				INC     M[ SnakeTam ]

FruitGen:		CALL 	RandomV2
				MOV R1, M[ Random_Var]
				MOV R2, 20d 
				DIV R1, R2
				ADD R2, 3
				MOV M[ FruitRowPos ], R2

				CALL RandomV2
				MOV R1, M[ Random_Var]
				MOV R2, 78d
				DIV R1, R2
				ADD R2, 1
				MOV M[ FruitColPos ], R2

				MOV		R2, M[ FruitRowPos ]
				MOV		R1, M[ FruitColPos ]
				SHL		R2, ROW_SHIFT
				OR		R2, R1
				MOV		R1, 0d

FruitGenC:		CMP     R1, M[ SnakeTam ]		;Checa se a posição da fruta gerado não é uma posição da cobra
				JMP.Z   EndFruitGen
				MOV     R3, M[ R1 + SnakeHead ]
				CMP		R2, R3
				JMP.Z	FruitGen
				INC     R1
				JMP     FruitGenC

EndFruitGen:	CALL	PrintFruit
				POP		R2
				POP		R1
				RET

;------------------------------------------------------------------------------
; Rotina atualizar o score
;------------------------------------------------------------------------------
UpdtadeScore:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4

				INC		M[ ScoreValue ]				
				MOV		R3, ':'
				MOV		R4, '0'

				INC		M[ ScoreUnit ]
				CMP		M[ ScoreUnit ], R3
				JMP.NZ	EndScoreUnit
				MOV		M[ ScoreUnit ], R4

				INC		M[ ScoreDez ]
				CMP		M[ ScoreDez ], R3
				JMP.NZ	EndScoreDez
				MOV		M[ ScoreDez ], R4

				INC		M[ ScoreCem	]
				CMP		M[ ScoreCem ], R3
				JMP.NZ	EndScoreCem
				MOV		M[ ScoreCem ], R4

				INC		M[ ScoreMil	]
				CMP		M[ ScoreMil ], R3
				JMP.NZ	EndScoreMil
				MOV		M[ ScoreMil ], R4

EndScoreMil: 	MOV		R1, 1d
				MOV		R2, 71d
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M [ ScoreMil ]
				MOV     M[ IO_WRITE ], R3

EndScoreCem: 	MOV		R1, 1d
				MOV		R2, 72d
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M [ ScoreCem ]
				MOV     M[ IO_WRITE ], R3

EndScoreDez:	MOV		R1, 1d
				MOV		R2, 73d
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M [ ScoreDez ]
				MOV     M[ IO_WRITE ], R3

EndScoreUnit:	MOV		R1, 1d
				MOV		R2, 74d
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M [ ScoreUnit ]
				MOV     M[ IO_WRITE ], R3
		
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET

;------------------------------------------------------------------------------
; Rotina para checar se houve colisão da cobra com ela mesma
;------------------------------------------------------------------------------
ColisionCheck:	PUSH	R1
				PUSH	R2
				PUSH	R3

				MOV		R1, 0d
				MOV		R2, M[ R1 + SnakeHead ]
				INC		R1

ColisionLoop:	CMP     R1, M[ SnakeTam ]
				JMP.Z   EndCheck
				MOV     R3, M[ R1 + SnakeHead ]
				CMP		R2, R3
				JMP.Z	EndColision
				INC     R1
				JMP     ColisionLoop

EndColision:	MOV		R1, 1d
				MOV		M[ SnakeColsion], R1
				CALL.Z	PrintEnd

EndCheck:	 	POP    R3
				POP    R2
				POP    R1
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

        MOV     R1, M[ HeadRowPosition ]
        MOV     R2, M[ HeadColPosition ]
        SHL     R1, ROW_SHIFT
       	OR      R1, R2
        MOV     R2, 0d
        MOV     M[ R2 + SnakeHead ], R1

		MOV     R1, M[ HeadRowPosition ]
        MOV     R2, M[ HeadColPosition ]
		INC		R2
        SHL     R1, ROW_SHIFT
       	OR      R1, R2
        MOV     R2, 1d
        MOV     M[ R2 + SnakeHead ], R1

		CALL 	PrintFruit
		CALL	InitializeTimer

Cycle: 			BR		Cycle	
Halt:           BR		Halt
