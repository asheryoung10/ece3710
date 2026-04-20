funcSecondGameApplyUserInput:
    %saveRegs

    MOVI 0 R0 // i
    READ R1 | &varPlayerVelocityDataAddress
    READ R2 | &varActivePlayersAddress
    MOVI 1 R3 // Input mask
    secondGameFuncApplyUserInputPlayerLoop:
        LOAD R6 R2 // R6 is zero if player is inactive
        CMPI 0 R6 | GOIF EQ &secondGameFuncApplyUserInputPlayerLoopContinue

        MOVI 0 R9 // stay 0 if no horizontal input

        // Left button
        MOV R3 R4 // R4 has input mask
        AND R15 R4 // R4 is nonzero is left is pressed
        CMPI 0 R4 | GOIF EQ &secondGameFuncApplyUserInputPlayerLoopSkipLeftPressed
        // Left is pressed
        MOVI 1 R9 // Indicate horizontal input
        LOAD R4 R1 // R4 is player velocity
        SUBI %playerVelocityXIncrement R4 
        STOR R4 R1 // Update velocity
        secondGameFuncApplyUserInputPlayerLoopSkipLeftPressed:

        LSHI 1 R3 // Increment button mask

        // Right button
        MOV R3 R4 // R4 has input mask
        AND R15 R4 // R4 is nonzero is left is pressed
        CMPI 0 R4 | GOIF EQ &secondGameFuncApplyUserInputPlayerLoopSkipRightPressed
        // Right is pressed
        MOVI 1 R9 // Indicate horizontal input
        LOAD R4 R1 // R4 is player velocity
        ADDI %playerVelocityXIncrement R4 
        STOR R4 R1 // Update velocity
        secondGameFuncApplyUserInputPlayerLoopSkipRightPressed:
        
        // Horizontal clamp
        LOAD R4 R1 // R4 has x velocity
        CMPI %maxVelocityX R4 | GOIF LT &secondGameFuncApplyUserInputHorizontalClampPositive
        CMPI %minVelocityX R4 | GOIF GT &secondGameFuncApplyUserInputHorizontalClampNegative

        GOIF UC &secondGameFuncApplyUserInputHorizontalClampSkip
        secondGameFuncApplyUserInputHorizontalClampPositive:

        // slow down right motion
        MOVI %maxVelocityX R4 | STOR R4 R1

        GOIF UC &secondGameFuncApplyUserInputHorizontalClampSkip
        secondGameFuncApplyUserInputHorizontalClampNegative:

        // slow down left motion
        MOVI %minVelocityX R4 | STOR R4 R1

        secondGameFuncApplyUserInputHorizontalClampSkip:

        // Horizontal friction
        LOAD R4 R1 // R4 has x velocity
        CMPI 0 R9 | GOIF NE &secondGameFuncApplyUserInputHorizontalFrictionSkip
        CMPI 0 R4 | GOIF EQ &secondGameFuncApplyUserInputHorizontalFrictionSkip
        ADDI 1 R4
        CMPI 0 R4 | GOIF GE &secondGameFuncApplyUserInputHorizontalFrictionSkip
        SUBI 2 R4
        secondGameFuncApplyUserInputHorizontalFrictionSkip:
        STOR R4 R1

        // Gravity
        ADDI 1 R1
        LOAD R4 R1
        CMPI %maxVelocityY R4 | GOIF EQ &secondGameFuncApplyUserInputSkipGravity
        CMPI %maxVelocityY R4 | GOIF LT &secondGameFuncApplyUserInputClampGravity
        ADDI %playerGravityIncrement R4 | STOR R4 R1


        GOIF UC &secondGameFuncApplyUserInputSkipGravity
        secondGameFuncApplyUserInputClampGravity:
        MOVI %maxVelocityY R4 | STOR R4 R1 
        secondGameFuncApplyUserInputSkipGravity:

        // Jump
        LSHI 2 R3
        MOV R3 R4 // R4 has input mask for jump
        READ R6 | &varCurrentFrameButtonsPressed | LOAD R6 R6
        AND R6 R4 | CMPI 0 R4 | GOIF EQ &secondGameFuncApplyUserInputSkipJump

        // Jump Player
        MOVI 0 R4
        ADDI %playerJumpIncrement R4
        STOR R4 R1


        secondGameFuncApplyUserInputSkipJump:

        SUBI 1 R1
        //LSHI 1 R3
        LSHI -3 R3
        secondGameFuncApplyUserInputPlayerLoopContinue:
        ADDI 2 R1 // step player velocity
        LSHI 4 R3 // Step player input mask
        ADDI 1 R2 // next active player address
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &secondGameFuncApplyUserInputPlayerLoop


    %restoreRegs
    %return

funcChangeWorldsSize:
    %saveRegs

    // Obtain world size and increment it, set it back to zero if its 5
    READ R0 | &varWorldScaleSize | LOAD R0 R0
    ADDI 1 R0
    CMPI 3 R0 | GOIF NE &secondGameFuncChangeWorldsSizeSkipReset
    MOVI 1 R0
    secondGameFuncChangeWorldsSizeSkipReset:
    READ R1 | &varWorldScaleSize
    STOR R0 R1


    %restoreRegs
    %return

funcToggleWorldSize:
    %saveRegs
        READ R1 | &varCurrentFrameButtonsPressedOther | LOAD R1 R1
        MOVI 2 R2 | AND R2 R1 | CMPI 2 R1 | GOIF NE &secondGameFuncTWSSkipToggle
        %call(&funcChangeWorldsSize) 
        secondGameFuncTWSSkipToggle:
    %restoreRegs
    %return