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
; Rotina para limpar caracteres de posições que cobra passou
;------------------------------------------------------------------------------
ClearPath:  PUSH    R1
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

            CALL	ClearPath
			MOV		R1, M[ SnakeFruit ]
			CMP		R1, 1d 
			JMP.Z	NoShiftU
            CALL    VetShift

NoShiftU:	DEC     M[ HeadRowPosition ]
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

            CALL	ClearPath
			MOV		R1, M[ SnakeFruit ]
			CMP		R1, 1d 
			JMP.Z	NoShiftL
			CALL    VetShift

NoShiftL: 	DEC     M[ HeadColPosition ]
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

            CALL	ClearPath
			MOV		R1, M[ SnakeFruit ]
			CMP		R1, 1d 
			JMP.Z	NoShiftR
            CALL    VetShift

NoShiftR:	INC     M[ HeadColPosition ]
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

            CALL	ClearPath
			MOV		R1, M[ SnakeFruit ]
			CMP		R1, 1d 
			JMP.Z	NoShiftD
            CALL    VetShift

NoShiftD:	INC     M[ HeadRowPosition ]
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