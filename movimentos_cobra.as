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
            INC     M[ HeadRowPosition ]
            INC		M[ TailRowPosition ]

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_DOWN
            CALL.Z	PrintEnd
            
            POP     R2
			POP     R1
	    	RET

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
            DEC     M[ HeadRowPosition ]
            DEC		M[ TailRowPosition ]

            MOV		R1, M[ HeadRowPosition ]
            CMP		R1, ROW_LIMIT_UP	
            CALL.Z	PrintEnd
            
            POP     R2
			POP     R1
	    	RET