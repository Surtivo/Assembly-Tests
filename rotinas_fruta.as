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

				MOV		R1, 1d
				MOV		M[ SnakeFruit ], R1
				INC     M[ SnakeTam ]
				CALL    VetShift

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

FruitGenC:		CMP     R1, M[ SnakeTam ]		;Checa se a posição da fruta gerada não é uma posição da cobra
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
