funcUpdatePlayerAnimations:
    %saveRegs
    %call(&funcUpdatePlayerAnimationsSubIndices)

    READ R0 | &varActivePlayersAddress
    READ R1 | &varLocalPlayerDataAddress
    ADDI 2 R1 // step to animation index
    READ R2 | &varPlayerAnimationSubIndices
    READ R3 | &varPlayerVelocityDataAddress
    MOVI 0 R4 // player index

    funcUpdatePlayerAnimationsPlayerLoop:
        LOAD R6 R0 | CMPI 0 R6 | GOIF EQ &funcUpdatePlayerAnimationsPlayerLoopContinue // skip inactive players

        LOAD R6 R2 // R6 = player animation sub index
        STOR R6 R1 // Store that into player animation index
        LOAD R7 R3 | ADDI 1 R3 | LOAD R8 R3 | SUBI 1 R3 // R7 = playerVelocityX, R8 = playerVelocityY
        CMPI 0 R7 | GOIF EQ &FUPAAPcheckXZero

        // X != 0
        CMPI 0 R8 | GOIF EQ &FUPAAPxOnly

        // diagonal cases
        CMPI 0 R7 | GOIF LT &FUPAAPxPos
        GOIF UC &FUPAAPxNeg


// =============================
// Y only cases (X == 0)
// =============================
FUPAAPcheckXZero:
        CMPI 0 R8 | GOIF LT &FUPAAPdown
        GOIF UC &FUPAAPup


// =============================
// X only cases (Y == 0)
// =============================
FUPAAPxOnly:
        CMPI 0 R7 | GOIF LT &FUPAAPright
        GOIF UC &FUPAAPleft


// =============================
// Diagonal cases (X != 0, Y != 0)
// =============================
FUPAAPxNeg:
        CMPI 0 R8 | GOIF LT &FUPAAPdownleft
        GOIF UC &FUPAAPupleft

FUPAAPxPos:
        CMPI 0 R8 | GOIF LT &FUPAAPdownright
        GOIF UC &FUPAAPupright



        // =============================
        // Animation write-back
        // =============================
        FUPAAPdown:
            MOVI 0 R7 // down anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPdownleft:
            MOVI 4 R7 // down-left anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPleft:
            MOVI 8 R7 // left anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPupleft:
            MOVI 12 R7 // up-left anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPup:
            MOVI 16 R7 // up anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPupright:
            MOVI 20 R7 // up-right anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPright:
            MOVI 24 R7 // right anim index
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        FUPAAPdownright:
            MOVI 28 R7 // down-right anim index (default fallback)
            ADD R6 R7
            STOR R7 R1
            GOIF UC &funcUpdatePlayerAnimationsPlayerLoopContinue

        funcUpdatePlayerAnimationsPlayerLoopContinue:
        ADDI 1 R0 // Step active players list
        ADDI 4 R1 // Step to next player local animation index feild
        ADDI 1 R2 // Step sub animation index
        ADDI 2 R3 // Step velocity
        ADDI 1 R4 | CMPI 4 R4 | GOIF NE &funcUpdatePlayerAnimationsPlayerLoop


    %restoreRegs
    %return


funcUpdatePlayerAnimationsSubIndices:
    %saveRegs

    READ R0 | &varPlayerAnimationSubIndices
    READ R3 | &varPlayerVelocityDataAddress
    MOVI 0 R1
    funcUpdatePlayerAnimationsSubIndicesPlayerLoop:
        LOAD R2 R0 // R2 has the current player animation sub index 


        LOAD R4 R3 | ADDI 1 R3 | LOAD R5 R3 // R4 = velX, R5 = velY

        %saveReg(R0)
        MOV R4 R0
        %call(&funcAbsoluteValue)
        MOV R0 R4
        MOV R5 R0 
        %call(&funcAbsoluteValue)
        MOV R0 R5
        %restoreReg(R0)

        ADD R5 R4 // R4 has absolute manhatten velocity

        READ R5 | &varFrameCount | LOAD R5 R5
        READ R6 | 0x00FF
        CMPI 40 R4 | GOIF GT &funcUpdatePlayerAnimationsSubIndicesPlayerLoopSlowAnimation
        LSHI -7 R6 
        funcUpdatePlayerAnimationsSubIndicesPlayerLoopSlowAnimation:
        AND R6 R5
        CMPI 0 R5 | GOIF NE &funcUpdatePlayerAnimationsSubIndicesPlayerLoopContinue

        ADDI 1 R2

        funcUpdatePlayerAnimationsSubIndicesPlayerLoopContinue:
        CMPI 4 R2 | GOIF NE &funcUpdatePlayerAnimationsSubIndicesPlayerLoopSkipResetIndex
        MOVI 0 R2
        funcUpdatePlayerAnimationsSubIndicesPlayerLoopSkipResetIndex:
        STOR R2 R0 // Increment or clear the sub index
        ADDI 1 R3 // increment velocity pointer
        ADDI 1 R0 | ADDI 1 R1 | CMPI 4 R1 | GOIF NE &funcUpdatePlayerAnimationsSubIndicesPlayerLoop

    %restoreRegs
    %return


// modifies r0 such that its aboslute value
funcAbsoluteValue:
    CMPI 0 R0 | GOIF LE &FAVdone
    MOVI 0 R12
    SUB R0 R12
    MOV R12 R0
    FAVdone:
    %return