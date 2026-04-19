#include "averagePlayerPosition.asm"
funcSecondGameKeepPlayersInBounds:
    %saveRegs

    MOVI 0 R7
    MOVI 0 R8

    %call(&funcGetAveragePlayerPosition)
    MOV R7 R1
    READ R2 | 0
    SUB R1 R2 // R2 = R2 - R1
    MOVI 0 R0
    SUB R2 R0
    MOV R0 R7

    MOV R8 R1
    READ R2 | 0
    SUB R1 R2 // R2 = R2 - R1
    MOVI 0 R0
    SUB R2 R0
    MOV R0 R8   
    CMPI 0 R8 | GOIF GT &funcSecondGameKeepPlayersInBoundsSkipResetY
    MOVI 0 R8
    funcSecondGameKeepPlayersInBoundsSkipResetY:



    // Update score
    READ R0 | %playerScoresAddress | LOAD R1 R0
    MOV R1 R2
    SUB R8 R1
    CMP R2 R1 | GOIF GT &funcSecondGameKeepPlayersInBoundsUpdateScoreSkip
    STOR R1 R0


    funcSecondGameKeepPlayersInBoundsUpdateScoreSkip:

    MOVI 0 R0 // Player index
    READ R1 | &varActivePlayersAddress
    READ R2 | &varLocalPlayerDataAddress
    READ R4 | &varPlayerFixedPointPositions

    funcSecondGameKeepPlayersInBoundsPlayerLoop:
        LOAD R3 R1 | CMPI 0 R1 | GOIF EQ &funcSecondGameKeepPlayersInBoundsPlayerLoopContinue // Skip player if inactive

        LOAD R3 R2 | SUB R7 R3 | STOR R3 R2 // x
        ADDI 1 R2
        LOAD R3 R2 | SUB R8 R3 | STOR R3 R2 // y
        SUBI 1 R2

        MOV R7 R12 | LSHI %playerFractionalShiftUp R12
        LOAD R3 R4 | SUB R12 R3 | STOR R3 R4
        ADDI 1 R4
        MOV R8 R12 | LSHI %playerFractionalShiftUp R12
        LOAD R3 R4 | SUB R12 R3 | STOR R3 R4
        SUBI 1 R4


        funcSecondGameKeepPlayersInBoundsPlayerLoopContinue:
        ADDI 2 R4
        ADDI 1 R1 | ADDI 4 R2 // next active and local
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcSecondGameKeepPlayersInBoundsPlayerLoop


    MOVI 0 R0 // Rect index
    READ R1 | &varLocalRectDataAddress

    funcSecondGameKeepPlayersInBoundsRectLoop:
        LOAD R2 R1 | SUB R7 R2 | STOR R2 R1 // x
        ADDI 1 R1
        LOAD R2 R1 | SUB R8 R2 | STOR R2 R1 // y
        SUBI 1 R1
        ADDI 4 R1 | ADDI 1 R0 | CMPI 64 R0 | GOIF NE &funcSecondGameKeepPlayersInBoundsRectLoop

    READ R0 | &varBackgroundOffset
    LOAD R1 R0 | SUB R7 R1 | STOR R1 R0
    ADDI 1 R0
    LOAD R1 R0 | SUB R8 R1 | STOR R1 R0


    %restoreRegs
    %return