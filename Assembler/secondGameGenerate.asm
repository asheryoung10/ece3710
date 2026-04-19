#include "random.asm"

funcSecondGameGenerate:
    %saveRegs
    READ R0 | &varLocalRectDataAddress
    MOVI 0 R1 // Index
    READ R2 | 200  // x
    READ R3  | 400  // y
    READ R4 | %defaultRectDimensions
    READ R5 | 0xFFFF
    READ R6 | &varRectType


    funcSecondGameGenerateLoop:

        %setRect(R0,R2,R3,R4,R5)

        SUBI 100 R3
        %call(&funcNextRand) 
        ARSHI -7 R7
        ADD R7 R2
        %call(&funcNextRand) 
        ARSHI -9 R7
        ADD R7 R3
        ADD R7 R5

        READ R12 | 3
        AND R7 R12
        STOR R12 R6

        ADDI 1 R6
        ADDI 4 R0 // Next rectangle
        ADDI 1 R1 | CMPI 64 R1 | GOIF NE &funcSecondGameGenerateLoop

    %restoreRegs
    %return

funcSecondGameRespawnRects:
    %saveRegs

    MOVI 0 R0 // rect index 
    READ R1 | &varLocalRectDataAddress

    funcSecondGameRespawnRectsLoop:
        LOAD R2 R1 | ADDI 1 R1 // r2 = xpos
        LOAD R3 R1 | SUBI 1 R1 // r3 = ypos

        READ R12 | %fallCutoff
        CMP R3 R12 | GOIF LT &funcSecondGameRespawnRectsLoopContinue
        // rect needs to be reset
        %call(&funcGetHighestRectPos)
        SUBI 100 R8 // make higher up
        
        MOV R7 R5
        %call(&funcNextRand)
        ARSHI -7 R7
        ADD R7 R5

        %call(&funcNextRand)
        ARSHI -9 R7
        ADD R7 R8
        %call(&funcNextRand)

        READ R12 | %defaultRectDimensions
        %setRect(R1,R5,R8,R12,R7)


        funcSecondGameRespawnRectsLoopContinue:
        ADDI 4 R1 // next rect
        ADDI 1 R0 | CMPI 64 R0 | GOIF NE &funcSecondGameRespawnRectsLoop

    %restoreRegs
    %return

// r7 is highest x, r8 is highest y
funcGetHighestRectPos:
    %saveRegs
    MOVI 0 R7 | MOVI 0 R8 // 0 by default
    READ R0 | &varLocalRectDataAddress
    MOVI 0 R1 // rect index

    funcGetHighestRectPosLoop:
    LOAD R2 R0 | ADDI 1 R0 // x
    LOAD R3 R0 | SUBI 1 R0 // y

    CMP R8 R3 | GOIF LT &funcGetHighestRectPosLoopContinue

    // this rect is biggest yet 
    MOV R2 R7
    MOV R3 R8

    funcGetHighestRectPosLoopContinue:
    ADDI 4 R0 // next rect 
    ADDI 1 R1 | CMPI 64 R1 | GOIF NE &funcGetHighestRectPosLoop


    %restoreRegs
    %return
