#include "random.asm"

funcSecondGameGenerate:
    %saveRegs
    %call(&funcResetAllRects)

    READ R0 | &varLocalRectDataAddress
    MOVI 1 R1 // Index
    READ R2 | 280  // x
    READ R3  | -1  // y
    READ R4 | %defaultRectDimensions
    READ R5 | 0xFFFF
    READ R6 | &varRectType
    %setRect(R0,R2,R3,R4,R5)


    funcSecondGameGenerateLoop:
        %saveRegs()
        MOV R1 R0
        %call(&funcRespawnRect)
        %restoreRegs()
        GOIF UC &funcSecondGameGenerateLoopContinue

        MOVI 1 R12
        OR R12 R5 // Make sure color not black
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
        // Go if generated bouncy
        CMPI 3 R12 | GOIF EQ &funcSecondGameGenerateLoopContinue

        READ R12 | 0x30
        AND R7 R12
        STOR R12 R6
        CMPI 0 R12 | GOIF NE &funcSecondGameGenerateLoopContinue

        funcSecondGameGenerateLoopContinue:
        ADDI 1 R6
        ADDI 4 R0 // Next rectangle
        ADDI 1 R1 | CMPI 64 R1 | GOIF NE &funcSecondGameGenerateLoop

    %restoreRegs
    %return

// R0 is rect index
funcRespawnRect:
   %saveRegs

    READ R2 | &varRectType | ADD R0 R2 // R1 is address of rect
    READ R3 | &varRectAttribA | ADD R0 R3 // R1 is address of rect
    READ R4 | &varRectAttribB  | ADD R0 R4 // R0 R1 // R1 is address of rect

    LSHI 2 R0 //  index * 4
    READ R1 | &varLocalRectDataAddress | ADD R0 R1 // R1 is address of rect

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
    READ R10 | 0x6200
    %setRect(R1,R5,R8,R12,R10)

    MOVI 0 R12
    STOR R12 R3
    STOR R12 R4 // clear attributes

    READ R12 | 3
    AND R7 R12
    STOR R12 R2
    CMPI 3 R12 | GOIF EQ &funcRespawnRectReturn // if generateed return

    READ R12 | 0x30
    AND R7 R12
    STOR R12 R2
    CMPI 0 R12 | GOIF NE &funcRespawnRectReturn // if genetaed return

    READ R12 | 0x80
    AND R7 R12
    STOR R12 R2
    CMPI 0 R12 | GOIF EQ &funcRespawnRectReturn // if did not generate return

    // Generateing movable one
    READ R12 | %defaultRectDimensions
    READ R10 | 0x0FF0
    %setRect(R1,R5,R8,R12,R10)
    STOR R5 R3 // attrib a is x start
    %call(&funcNextRand)
    ARSHI -6 R7
    ADD R7 R5
    READ R12 | 0x1
    OR R12 R5 // ensure its at least one
    STOR R5 R4 // attrib b is x + 500

    funcRespawnRectReturn:
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
        
        %call(&funcRespawnRect)

        funcSecondGameRespawnRectsLoopContinue:
        ADDI 4 R1 // next rect
        ADDI 1 R0 | CMPI 64 R0 | GOIF NE &funcSecondGameRespawnRectsLoop

    %restoreRegs
    %return

// r7 is highest x, r8 is highest y
funcGetHighestRectPos:
    %saveRegs
    MOVI 0 R7 | READ R8 | 480 // 0 by default
    READ R0 | &varLocalRectDataAddress
    MOVI 0 R1 // rect index
    READ R5 | &varRectAttribB
    READ R6 | &varRectType

    funcGetHighestRectPosLoop:
    LOAD R2 R0 | ADDI 1 R0 // x
    LOAD R3 R0 | SUBI 1 R0 // y

    READ R12 | 0x80
    LOAD R10 R6 | CMP R12 R10 | GOIF EQ &funcGetHighestRectPosLoopMoving
    READ R12 | 0x81
    LOAD R10 R6 | CMP R12 R10 | GOIF EQ &funcGetHighestRectPosLoopMoving
    GOIF UC &funcGetHighestRectPosLoopMovingSkip

    funcGetHighestRectPosLoopMoving:
    LOAD R2 R5 // x pos right most of movew


    funcGetHighestRectPosLoopMovingSkip:
    CMP R8 R3 | GOIF LT &funcGetHighestRectPosLoopContinue

    // this rect is biggest yet 
    MOV R2 R7
    MOV R3 R8

    funcGetHighestRectPosLoopContinue:
    ADDI 1 R5 | ADDI 1 R6
    ADDI 4 R0 // next rect 
    ADDI 1 R1 | CMPI 64 R1 | GOIF NE &funcGetHighestRectPosLoop


    %restoreRegs
    %return
