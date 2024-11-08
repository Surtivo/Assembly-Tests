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
TIMER_COUNT     EQU     FFF6h
TIMER_CONTROL   EQU     FFF7h
INTERRUPTION_MASK   EQU     FFFAh

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
Char            WORD    'A'
;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
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

;------------------------------------------------------------------------------
; Rotina para executar o timer
;------------------------------------------------------------------------------
Timer:  PUSH    R1
        PUSH    R2

        MOV     R1, 12d
        MOV     R2, 40d
        SHL     R1, 8d
        OR      R1, R2
        MOV     M[ CURSOR ], R1
        MOV     R1, M[ Char ]
        MOV     M [IO_WRITE ], R1

        INC     M[ Char ]
        
        CALL    InitializeTimer

        POP     R2
        POP     R1
        RTI

;------------------------------------------------------------------------------
; Rotina para inicializar o timer
;------------------------------------------------------------------------------
InitializeTimer:  PUSH R1

            MOV     R1, 10d
            MOV     M[ TIMER_COUNT ], R1
            MOV     R1, 1d
            MOV     M[ TIMER_CONTROL ], R1

            POP R1
            RET
;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:	ENI

        MOV		R1, INITIAL_SP
	MOV		SP, R1		 		; We need to initialize the stack
	MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
	MOV		M[ CURSOR ], R1		; with value CURSOR_INIT

        CALL    InitializeTimer

Cycle: 			BR		Cycle	
Halt:           BR		Halt
