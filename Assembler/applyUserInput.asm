funcApplyUserInput:
    %saveRegs

    MOVI 0 R0 // i
    READ R1 | &varPlayerVelocityDataAddress
    READ R2 | &varActivePlayersAddress
    MOVI 1 R3 // Input mask
    funcApplyUserInputPlayerLoop:
        LOAD R6 R2 // R6 is zero if player is inactive
        CMPI 0 R6 | GOIF EQ &funcApplyUserInputPlayerLoopContinue

        MOVI 0 R9 // stay 0 if no horizontal input

        // Left button
        MOV R3 R4 // R4 has input mask
        AND R15 R4 // R4 is nonzero is left is pressed
        CMPI 0 R4 | GOIF EQ &funcApplyUserInputPlayerLoopSkipLeftPressed
        // Left is pressed
        MOVI 1 R9 // Indicate horizontal input
        LOAD R4 R1 // R4 is player velocity
        SUBI %playerVelocityXIncrement R4 
        STOR R4 R1 // Update velocity
        funcApplyUserInputPlayerLoopSkipLeftPressed:

        LSHI 1 R3 // Increment button mask

        // Right button
        MOV R3 R4 // R4 has input mask
        AND R15 R4 // R4 is nonzero is left is pressed
        CMPI 0 R4 | GOIF EQ &funcApplyUserInputPlayerLoopSkipRightPressed
        // Right is pressed
        MOVI 1 R9 // Indicate horizontal input
        LOAD R4 R1 // R4 is player velocity
        ADDI %playerVelocityXIncrement R4 
        STOR R4 R1 // Update velocity
        funcApplyUserInputPlayerLoopSkipRightPressed:
        
        // Horizontal clamp
        LOAD R4 R1 // R4 has x velocity
        CMPI %maxVelocityX R4 | GOIF LT &funcApplyUserInputHorizontalClampPositive
        CMPI %minVelocityX R4 | GOIF GT &funcApplyUserInputHorizontalClampNegative

        GOIF UC &funcApplyUserInputHorizontalClampSkip
        funcApplyUserInputHorizontalClampPositive:

        // slow down right motion
        MOVI %maxVelocityX R4 | STOR R4 R1

        GOIF UC &funcApplyUserInputHorizontalClampSkip
        funcApplyUserInputHorizontalClampNegative:

        // slow down left motion
        MOVI %minVelocityX R4 | STOR R4 R1

        funcApplyUserInputHorizontalClampSkip:

        // Horizontal friction
        LOAD R4 R1 // R4 has x velocity
        CMPI 0 R9 | GOIF NE &funcApplyUserInputHorizontalFrictionSkip
        CMPI 0 R4 | GOIF EQ &funcApplyUserInputHorizontalFrictionSkip
        ADDI 1 R4
        CMPI 0 R4 | GOIF GE &funcApplyUserInputHorizontalFrictionSkip
        SUBI 2 R4
        funcApplyUserInputHorizontalFrictionSkip:
        STOR R4 R1

        // Gravity
        ADDI 1 R1
        LOAD R4 R1
        CMPI %maxVelocityY R4 | GOIF EQ &funcApplyUserInputSkipGravity
        CMPI %maxVelocityY R4 | GOIF LT &funcApplyUserInputClampGravity
        ADDI %playerGravityIncrement R4 | STOR R4 R1


        GOIF UC &funcApplyUserInputSkipGravity
        funcApplyUserInputClampGravity:
        MOVI %maxVelocityY R4 | STOR R4 R1 
        funcApplyUserInputSkipGravity:

        // Jump
        LSHI 1 R3
        MOV R3 R4 // R4 has input mask for jump
        READ R6 | &varCurrentFrameButtonsPressed | LOAD R6 R6
        AND R6 R4 | CMPI 0 R4 | GOIF EQ &funcApplyUserInputSkipJump

        // Jump Player
        MOVI 0 R4
        SUBI %playerJumpIncrement R4
        STOR R4 R1


        funcApplyUserInputSkipJump:

        SUBI 1 R1
        LSHI 1 R3
        LSHI -3 R3
        funcApplyUserInputPlayerLoopContinue:
        ADDI 2 R1 // step player velocity
        LSHI 4 R3 // Step player input mask
        ADDI 1 R2 // next active player address
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcApplyUserInputPlayerLoop


    %restoreRegs
    %return

funcChangeWorldsSize:
    %saveRegs

    // Obtain world size and increment it, set it back to zero if its 5
    READ R0 | &varWorldScaleSize | LOAD R0 R0
    ADDI 1 R0
    CMPI 3 R0 | GOIF NE &funcChangeWorldsSizeSkipReset
    MOVI 1 R0
    funcChangeWorldsSizeSkipReset:
    READ R1 | &varWorldScaleSize
    STOR R0 R1


    %restoreRegs
    %return

funcToggleWorldSize:
    %saveRegs
        READ R1 | &varCurrentFrameButtonsPressedOther | LOAD R1 R1
        MOVI 2 R2 | AND R2 R1 | CMPI 2 R1 | GOIF NE &funcTWSSkipToggle
        %call(&funcChangeWorldsSize) 
        funcTWSSkipToggle:
    %restoreRegs
    %return