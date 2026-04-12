funcJoinLeavePlayers:
    %save(R6)
    %save(R7)
    %save(R8)
    %save(R9)

    MOVI 0 R0 // Player index
    MOVI 8 R1 // Current player 1 down mask
    READ R4 | &varActivePlayersAddress
    READ R5 | %playerSharedDataAddress
    READ R6 | 215  // Start x pos
    READ R7 | 220 // y pos
    READ R8 | &varPlayerDefaultColors
    READ R9 | %playerSharedDataAddress
    ADDI 3 R9 // Color
    
    funcJoinLeavePlayersPlayerLoop:
        
        MOV R1 R3 // R3 = player down mask
        READ R12  | &varButtonPressedThisFrameAddress | LOAD R12 R12
        AND R12 R3
        CMPI 0 R3 | GOIF EQ &funcJoinLeavePlayersPlayerLoopNext //if not pressed this frame do nothing

        LOAD R12 R4
        NOT R12 R12
        STOR R12 R4
        
        STOR R6 R5
        ADDI 1 R5
        STOR R7 R5
        SUBI 1 R5

        READ R10 | 0x0000 // black color if inactive

        CMPI 0 R12 | GOIF EQ &funcJoinLeavePlayersPlayerLoopSetColorInactiveSkip
        LOAD R12 R8


        funcJoinLeavePlayersPlayerLoopSetColorInactiveSkip:
        STOR R12 R9

        funcJoinLeavePlayersPlayerLoopNext:
        ADDI 1 R8
        ADDI 4 R5
        ADDI 4 R9
        ADDI 1 R0
        ADDI 55 R6 // Space players out
        ADDI 1 R4
        LSHI 4 R1
        CMPI 4 R0
        GOIF NE &funcJoinLeavePlayersPlayerLoop

    %restore(R9)
    %restore(R8)
    %restore(R7)
    %restore(R6)
    %return

// Takes in R0 the address of player data to copy
funcCopyPlayerData:
    MOVI 0 R1 // i = 0
    READ R2 | %playerSharedDataAddress

    funcCopyPlayerDataLoop:

        LOAD R3 R0
        STOR R3 R2

        ADDI 1 R2
        ADDI 1 R0
        ADDI 1 R1 // i++
        CMPI 16 R1
        GOIF NE &funcCopyPlayerDataLoop
    %return

funcApplyUserInput:

    MOVI 0 R0 // i = 0
    MOVI 1 R1 // player input mask
    READ R2 | &varPlayerVelocityAddress
    READ R3 | &varActivePlayersAddress
    READ R4 | %playerSharedDataAddress

    funcApplyUserInputPlayerLoop:
        LOAD R5 R3 | CMPI 0 R5 | GOIF EQ &funcApplyUserInputPlayerLoopContinue // Skip player if inactive

        MOVI 0 R8 // Detects if a horizontal input
        MOVI 0 R6
        MOV R1 R5 | AND R15 R5 | CMPI 0 R5 | GOIF EQ &funcApplyUserInputSkipLeft
        ADDI -2 R6 // Amount to add
        MOVI 1 R8
        funcApplyUserInputSkipLeft:
        LOAD R7 R2 | ADD R6 R7
        CMPI %minVelocityX R7 | GOIF LE &funcApplyUserInputSkipClampLeft
        MOVI %minVelocityX R7
        funcApplyUserInputSkipClampLeft:
        STOR R7 R2

        LSHI 1 R1

        MOVI 0 R6
        MOV R1 R5 | AND R15 R5 | CMPI 0 R5 | GOIF EQ &funcApplyUserInputSkipRight
        ADDI 2 R6 // Amount to add
        MOVI 1 R8
        funcApplyUserInputSkipRight:
        LOAD R7 R2 | ADD R6 R7
        CMPI %maxVelocityX R7 | GOIF GE &funcApplyUserInputSkipClampRight
        MOVI %maxVelocityX R7
        funcApplyUserInputSkipClampRight:
        STOR R7 R2

        CMPI 1 R8 | GOIF EQ &funcApplyUserInputSkipHorizontalFriction

        LOAD R7 R2 // R7 = velocityx
        CMPI 0 R7 | GOIF EQ &funcApplyUserInputSkipHorizontalFriction
        MOVI 1 R8
        CMPI 0 R7 | GOIF GE &funcApplyUserInputHoritonalFrictionInternalSkip
        MOVI -1 R8
        funcApplyUserInputHoritonalFrictionInternalSkip:
        ADD R8 R7
        STOR R7 R2
        funcApplyUserInputSkipHorizontalFriction:
        LSHI -1 R1

        funcApplyUserInputPlayerLoopContinue:
        ADDI 2 R2 // step player velocity
        ADDI 1 R3 // step active player
        ADDI 4 R4 // Step shared player
        LSHI 4 R1 // Step input mask
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcApplyUserInputPlayerLoop

    %return

funcApplyVelocity:

    MOVI 0 R0 // i = 0
    READ R2 | &varPlayerVelocityAddress
    READ R3 | &varActivePlayersAddress
    READ R4 | %playerSharedDataAddress

    funcApplyVelocityPlayerLoop:
        LOAD R5 R3 | CMPI 0 R5 | GOIF EQ &funcApplyVelocityPlayerLoopContinue // Skip player if inactive

        LOAD R1 R4 // R1 = positionx
        LOAD R5 R2 // R5 = velocityx
        ARSHI -2 R5 // Remove lower bits of velocity

        ADD R5 R1  // Apply velocity
        STOR R1 R4 // Store new position

        ADDI 1 R4
        ADDI 1 R2

        LOAD R1 R4 // R1 = positiony
        LOAD R5 R2 // R5 = velocityy
        ARSHI -2 R5 // Remove lower bits of velocity

        ADD R5 R1  // Apply velocity
        STOR R1 R4 // Store new position

        SUBI 1 R2
        SUBI 1 R4

        funcApplyVelocityPlayerLoopContinue:
        ADDI 2 R2 // step player velocity
        ADDI 1 R3 // step active player
        ADDI 4 R4 // Step shared player
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcApplyVelocityPlayerLoop

    %return

