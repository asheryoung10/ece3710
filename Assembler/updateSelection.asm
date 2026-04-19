#include "firstGame.asm"
#include "secondGame.asm"

funcUpdateSelection:
    %saveRegs

    READ R0 | &varPlayerGameSelection
    MOVI 0 R1 // first selection
    MOVI 0 R2 // second selection
    MOVI 0 R3 // player index
    READ R5 | 0x0001

    funcUpdateSelectionLoop:
        MOV R0 R4
        ADD R3 R4 // R4 has selection 
        LOAD R4 R4 // R4 has selection for current player

        CMPI 0 R4 | GOIF EQ &funcUpdateSelectionLoopContinue
        CMPI 9 R4 | GOIF EQ &funcUpdateSelectionLoop9
        CMPI 11 R4 | GOIF EQ &funcUpdateSelectionLoop11
        GOIF UC &funcUpdateSelectionLoopContinue

        funcUpdateSelectionLoop9:
        ADDI 1 R1
        GOIF UC &funcUpdateSelectionLoopContinue
        funcUpdateSelectionLoop11:
        ADDI 1 R2
        GOIF UC &funcUpdateSelectionLoopContinue

        funcUpdateSelectionLoopContinue:
        LSHI 4 R5 | ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcUpdateSelectionLoop


    // r7 will have player count
    %call(&funcGetActivePlayerCount)

    CMPI 0 R7 |  GOIF EQ &funcUpdateSelectionReturn // zer oplayers return
    
    CMP R7 R2 | GOIF EQ &funcUpdateSelectionChooseSecond
    CMPI 1 R7 | GOIF EQ &funcUpdateSelectionReturn
    CMP R7 R1 | GOIF EQ &funcUpdateSelectionChooseFirst
    GOIF UC &funcUpdateSelectionReturn


    funcUpdateSelectionChooseFirst:
    MOVI 1 R0
    %call(&funcFirstGame)
    GOIF UC &funcUpdateSelectionReturn
    funcUpdateSelectionChooseSecond:
    MOVI 1 R0
    %call(&funcSecondGame)
    GOIF UC &funcUpdateSelectionReturn

    funcUpdateSelectionReturn:
    MOV R0 R9
    %restoreRegs
    MOV R9 R0
    %return

// returns player count in r7
funcGetActivePlayerCount:
    %saveRegs

    MOVI 0 R0 
    READ R1 | &varActivePlayersAddress
    MOVI 0 R7 // count

    funcGetPlayerCountLoop:
        LOAD R12 R1 | CMPI 0 R12 | GOIF EQ &funcGetPlayerCountLoopContinue
        ADDI 1 R7 
        funcGetPlayerCountLoopContinue:
        ADDI 1 R1
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcGetPlayerCountLoop

    %restoreRegs
    %return