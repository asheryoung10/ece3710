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

    CMPI 3 R3 | GOIF EQ &funcHandleBouncy

    READ R12 | 0x30
    CMP R12 R3 | GOIF EQ &funcHandleBroken

    READ R12 | 0x80
    CMP R12 R3 | GOIF EQ &funcHandleMoving
    READ R12 | 0x81
    CMP R12 R3 | GOIF EQ &funcHandleMoving

    GOIF UC &funcUpdateRectColorsContinue


funcHandleBouncy:
    %call(&funcUpdateRectColorsBouncy)
    GOIF UC &funcUpdateRectColorsContinue

funcHandleBroken:
    %call(&funcUpdateRectColorsBroken)
    GOIF UC &funcUpdateRectColorsContinue

funcHandleMoving:
    %call(&funcUpdateRectColorsMoving)
    GOIF UC &funcUpdateRectColorsContinue


funcUpdateRectColorsContinue:
    ADDI 1 R1
    ADDI 4 R0
    ADDI 1 R5
    ADDI 1 R6

    ADDI 1 R2
    CMPI 64 R2
    GOIF NE &funcUpdateRectColorsLoop

    %restoreRegs
    %return


funcUpdateRectColorsBroken:
    %saveRegs

    LOAD R12 R5
    CMPI 0 R12 | GOIF EQ &funcBrokenMint
    CMPI 1 R12 | GOIF EQ &funcBrokenDamaged

// destroy
    MOVI 0 R12
    STOR R12 R0
    GOIF UC &funcBrokenDone

funcBrokenMint:
    READ R12 | 0xF800
    READ R10 | 0x0800
    LOAD R4 R0
    ADD R10 R4
    AND R12 R4
    STOR R4 R0
    GOIF UC &funcBrokenDone

funcBrokenDamaged:
    READ R12 | 0xF800
    READ R10 | 0x0800
    LOAD R4 R0
    ADD R10 R4
    AND R12 R4
    READ R10 | 0x3800
    OR R10 R4
    STOR R4 R0

funcBrokenDone:
    %restoreRegs
    %return


funcUpdateRectColorsMoving:
    %saveRegs
    MOV R1 R9 // R8 has address of type
    ADDI -3 R0 | LOAD R4 R0 | ADDI 3 R0

    LOAD R2 R5
    LOAD R3 R6

    CMP R2 R3 | GOIF LT &funcMoveLeftIsA

// ---- Left is B ----
funcMoveLeftIsB:
    CMP R3 R4 | GOIF GE &funcSetMoveRight
    CMP R2 R4 | GOIF LT &funcSetMoveLeft
    GOIF UC &funcChooseMove

// ---- Left is A ----
funcMoveLeftIsA:
    CMP R2 R4 | GOIF GE &funcSetMoveRight
    CMP R3 R4 | GOIF LT &funcSetMoveLeft
    GOIF UC &funcChooseMove


funcSetMoveLeft:
    READ R12 | 0x81
    STOR R12 R9
    GOIF UC &funcChooseMove

funcSetMoveRight:
    READ R12 | 0x80
    STOR R12 R9
    GOIF UC &funcChooseMove


funcChooseMove:
    LOAD R8 R9
    READ R12 | 0x81
    CMP R12 R8 | GOIF EQ &funcMoveLeft
    GOIF UC &funcMoveRight


funcMoveLeft:
    ADDI -3 R0 | LOAD R12 R0
    ADDI -2 R12
    STOR R12 R0
    ADDI 3 R0
    GOIF UC &funcMoveDone

funcMoveRight:
    ADDI -3 R0 | LOAD R12 R0
    ADDI 2 R12
    STOR R12 R0
    ADDI 3 R0

funcMoveDone:
    %restoreRegs
    %return

funcUpdateRectColorsBouncy:
    %saveRegs

    LOAD R12 R0
    ADDI 113 R12
    STOR R12 R0

    %restoreRegs
    %return

