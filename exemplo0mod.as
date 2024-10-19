;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_WRITE        EQU     FFFEh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_SHIFT		EQU		8d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;------------------------------------------------------------------------------
                ORIG    8000h
Text			STR     'Eu odeio o ChatGPT', FIM_TEXTO
RowIndex		WORD	11d
ColumnIndex		WORD	29d
TextIndex		WORD	0d

;------------------------------------------------------------------------------
; ZONA IV: codigo
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Função WriteCharacter (sem interrupção)
;------------------------------------------------------------------------------
WriteCharacter: MOV		R1, M[ TextIndex ]
				MOV		R1, M[ R1 ]         ; Carrega o próximo caractere
				CMP 	R1, FIM_TEXTO        ; Verifica se é o fim do texto
				BR.Z	EndWrite           ; Se sim, vai para o fim

				MOV     M[ IO_WRITE ], R1    ; Escreve o caractere na saída
				INC		M[ ColumnIndex ]    ; Incrementa a coluna

				MOV		R1, M[ RowIndex ]    ; Carrega o índice da linha
				MOV		R2, M[ ColumnIndex ] ; Carrega o índice da coluna
				SHL		R1, ROW_SHIFT       ; Ajusta a posição da linha
				OR		R1, R2              ; Combina linha e coluna
				MOV		M[ CURSOR ], R1     ; Atualiza o cursor

				INC		M[ TextIndex ]      ; Avança para o próximo caractere
				BR		WriteCharacter      ; Continua escrevendo

EndWrite:		RET                     ; Fim da função de escrita

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			MOV		R1, INITIAL_SP
				MOV		SP, R1		        ; Inicializa a pilha

				MOV		R1, CURSOR_INIT		; Inicializa o cursor
				MOV		M[ CURSOR ], R1

				MOV     R1, Text
				MOV		M[ TextIndex ], R1  ; Inicializa o ponteiro do texto

				MOV		R1, M[ RowIndex ]    ; Carrega o índice da linha
				MOV		R2, M[ ColumnIndex ] ; Carrega o índice da coluna
				SHL		R1, ROW_SHIFT       ; Ajusta a posição da linha
				OR		R1, R2              ; Combina linha e coluna
				MOV		M[ CURSOR ], R1     ; Atualiza o cursor

				CALL	WriteCharacter      ; Chama a função para escrever o texto

Halt:           BR		Halt                ; Entra em um loop infinito
