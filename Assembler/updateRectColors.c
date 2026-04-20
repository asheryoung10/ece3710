funcUpdateRectColors:
    %saveRegs

    READ R0 | &varLocalRectDataAddress
    ADDI 3 R0
    READ R1 | &varRectType
    MOVI 0 R2
    READ R5 | &varRectAttribA
    READ R6 | &varRectAttribB

    funcUpdateRectColorsLoop:

        LOAD R3 R1
        CMPI 3 R3 | GOIF EQ &funcUpdateRectColorsBouncy
        READ R12 | 0x30
        CMP R12 R3 | GOIF EQ &funcUpdateRectColorsBroken
        READ R12 | 0x80
        CMP R12 R3 | GOIF EQ &funcUpdateRectColorsMoving

        GOIF UC &funcUpdateRectColorsContinue

        funcUpdateRectColorsBouncy:
        LOAD R12 R0 | ADDI 113 R12 | STOR R12 R0  
        GOIF UC &funcUpdateRectColorsContinue

        funcUpdateRectColorsBroken:
            LOAD R12 R5
            CMPI 0 R12 | GOIF EQ &funcUpdateRectColorsBrokenMint
            CMPI 1 R12 | GOIF EQ &funcUpdateRectColorsBrokenDamaged
            GOIF UC &funcUpdateRectColorsBrokenDestroy
        

        funcUpdateRectColorsBrokenMint:
            READ R12 | 0xF800
            READ R10 | 0x0800
            LOAD R4 R0 | ADD R10 R4 | AND R12 R4 | STOR R4 R0  

            GOIF UC &funcUpdateRectColorsContinue

        funcUpdateRectColorsBrokenDamaged:
            READ R12 | 0xF800
            READ R10 | 0x0800
            LOAD R4 R0 | ADD R10 R4 | AND R12 R4 | READ R10 | 0x3800 | OR R10 R4 | STOR R4 R0  

            GOIF UC &funcUpdateRectColorsContinue

         funcUpdateRectColorsBrokenDestroy:
            MOVI 0 R12
            STOR R12 R0 // set color to black
            GOIF UC &funcUpdateRectColorsContinue


        funcUpdateRectColorsMoving:
             %saveRegs
             ADDI -3 R0 | LOAD R4 R0 | ADDI 3 R0 // r4 has x pos
             LOAD R2 R5 | LOAD R3 R6 // r2 has x1, r3 has x2
             CMP R2 R3 | GOIF LT &funcUpdateRectColorsMovingLeftIsA
             GOIF UC &funcUpdateRectColorsMovingLeftIsB

             funcUpdateRectColorsMovingLeftIsA:
             CMP R2 R4 | GOIF GE &funcUpdateRectColorsSetMoveRight
             CMP R3 R4 | GOIF LT &funcUpdateRectColorsSetMoveLeft
             GOIF UC &funcUpdateRectColorsMovingDone

             funcUpdateRectColorsMovingLeftIsB:
             CMP R3 R4 | GOIF LT &funcUpdateRectColorsSetMoveLeft
             CMP R2 R4 | GOIF GT &funcUpdateRectColorsSetMoveRight
             GOIF UC &funcUpdateRectColorsChooseMove

             funcUpdateRectColorsSetMoveLeft:
             ADDI -3 R0 | LOAD R4 R0 | MOVI 1 R12 | OR R12 R4 | STOR R4 R0 | ADDI 3 R0 // r4 has x pos
             GOIF UC &funcUpdateRectColorsChooseMove
            
             funcUpdateRectColorsSetMoveRight:
             ADDI -3 R0 | LOAD R4 R0 | READ R12 | 0xFFFE | AND R12 R4 | STOR R4 R0 | ADDI 3 R0 // r4 has x pos
             GOIF UC &funcUpdateRectColorsChooseMove

             funcUpdateRectColorsChooseMove:
                 ADDI -3 R0 | LOAD R4 R0 | ADDI 3 R0 // r4 has x pos
                 MOVI 1 R12 | AND R12 R4
            //     CMPI 1 R4 | GOIF EQ &funcUpdateRectColorsMoveLeft
            //     GOIF EQ &funcUpdateRectColorsMoveRight

             funcUpdateRectColorsMoveLeft:
            // ADDI -3 R0 | LOAD R12 R0 | ADDI -1 R12 | STOR R12 R0 | ADDI 3 R0 // r12 has x pos
            // GOIF UC &funcUpdateRectColorsMovingDone

             funcUpdateRectColorsMoveRight:
             ADDI -3 R0 | LOAD R12 R0 | ADDI 1 R12 | STOR R12 R0 | ADDI 3 R0 // r12 has x pos
             GOIF UC &funcUpdateRectColorsMovingDone

             funcUpdateRectColorsMovingDone:
                 %restoreRegs
                 //GOIF UC &funcUpdateRectColorsContinue
        

        funcUpdateRectColorsContinue:
        ADDI 1 R1 | ADDI 4 R0 | ADDI 1 R5 | ADDI 1 R6
        ADDI 1 R2 | CMPI 64 R2 | GOIF NE &funcUpdateRectColorsLoop


    %restoreRegs
    %return