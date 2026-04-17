#include "firstGame.asm"
#include "secondGame.asm"

funcUpdateSelection:
    %saveRegs

    READ R0 | &varPlayerGameSelection
    MOVI 0 R1 // first selection
    MOVI 0 R2 // second selection
    MOVI 0 R3 // player index
    READ R5 | 0x000F

    funcUpdateSelectionLoop:
        MOV R0 R4
        ADD R3 R4 // R4 has selection 
        LOAD R4 R4 // R4 has selection for current player

        CMPI 0 R4 | GOIF EQ &funcUpdateSelectionLoopContinue
        CMPI 9 R4 | GOIF EQ &funcUpdateSelectionLoop9
        CMPI 11 R4 | GOIF EQ &funcUpdateSelectionLoop11
        GOIF UC &funcUpdateSelectionLoopContinue

        funcUpdateSelectionLoop9:
        ADD R5 R1
        GOIF UC &funcUpdateSelectionLoopContinue
        funcUpdateSelectionLoop11:
        ADD R5 R2
        GOIF UC &funcUpdateSelectionLoopContinue

        funcUpdateSelectionLoopContinue:
        LSHI 4 R5 | ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcUpdateSelectionLoop


    READ R0 | &varLocalRectDataAddress
    MOVI 9 R9 | LSHI 2 R9 | ADDI 3 R9 | ADD R0 R9 | STOR R1 R9

    READ R0 | &varLocalRectDataAddress
    MOVI 11 R9 | LSHI 2 R9 | ADDI 3 R9 | ADD R0 R9 | STOR R2 R9

    MOVI 0 R0
    READ R9 | &varCurrentFrameButtonsPressedOther | LOAD R9 R9
    MOVI 4 R10 | AND R10 R9 | CMPI 0 R9 | GOIF EQ &funcUpdateSelectionReturn
    MOVI 1 R0

    CMP R1 R2 | GOIF HI &funcUpdateSelectionChooseFirst
    GOIF UC &funcUpdateSelectionChooseSecond

    funcUpdateSelectionChooseFirst:
    %call(&funcFirstGame)
    GOIF UC &funcUpdateSelectionReturn
    funcUpdateSelectionChooseSecond:
    %call(&funcSecondGame)
    GOIF UC &funcUpdateSelectionReturn

    funcUpdateSelectionReturn:
    MOV R0 R9
    %restoreRegs
    MOV R9 R0
    %return