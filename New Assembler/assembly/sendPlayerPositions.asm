funcSendPlayerPositions:

    MOVI 0 R0                            // player index
    READ R12 | &varActivePlayersAddress  // active player list
    READ R2  | &varPlayerPhysicsDataAddress     // player physics list
    READ R3  | %playerSharedDataAddress  // player draw list

    funcSendPlayerPositionsPlayerLoop:

        LOAD R4 R2              // R4 = player X pos
        ADDI 1 R2 | LOAD R5 R2  // R5 = player Y pos

        LOAD R10 R12 
        CMPI 0 R10 | GOIF NE &funcSendPlayerPositionsPlayerLoopDrawOffscreen    // 
        MOVI -64 R4 | MOVI -64 R5                                               // Put data to send in undrawable region.
        funcSendPlayerPositionsPlayerLoopDrawOffscreen:                         //

        STOR R4 R3 // Store x
        ADDI 1 R3 | STOR R5 R3 // Store y

        ADDI 3 R2 // next player in physics list
        ADDI 3 R3 // next player in draw list
        ADDI 1 R0 // i++
        ADDI 1 R12 // next active player
        CMPI 4 R0
        GOIF NE &funcSendPlayerPositionsPlayerLoop 

    %return


funcJoinLeavePlayers:
    %save(R6)
    %save(R7)
    %save(R8)
    %save(R9)

    MOVI 0 R0 // Player index
    MOVI 8 R1 // Current player 1 down mask
    READ R2 | &varPreviousButtonStateAddress | LOAD R2 R2
    READ R4 | &varActivePlayersAddress
    READ R5 | &varPlayerPhysicsDataAddress
    READ R6 | 215  // Start x pos
    READ R7 | 220 // y pos
    
    funcJoinLeavePlayersPlayerLoop:
        
        MOV R1 R3 // R3 = player down mask
        AND R2 R3 // R3 = 1 if down was pressed last frame
        CMPI 0 R3 | GOIF NE &funcJoinLeavePlayersPlayerLoopNext // if pressed last frame then we dont want to do anything

        MOV R1 R3 // R3 = player down mask
        AND R15 R3 // R3 = 1 if down was pressed this frame
        CMPI 0 R3 | GOIF EQ &funcJoinLeavePlayersPlayerLoopNext // if they didn't press the button dont do anything

        LOAD R12 R4
        NOT R12 R12
        STOR R12 R4
        
        STOR R6 R5
        ADDI 1 R5
        STOR R7 R5
        SUBI 1 R5


        funcJoinLeavePlayersPlayerLoopNext:
        ADDI 4 R5
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