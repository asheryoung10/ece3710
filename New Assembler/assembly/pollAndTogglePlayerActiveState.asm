funcPollAndTogglePlayerActiveState:
    %saveRegs

    MOVI 0 R0 // i
    READ R1 | &varActivePlayersAddress
    READ R2 | &varLocalPlayerDataAddress
    READ R3 | &varPlayerDefaultColors
    READ R4 | &varCurrentFrameButtonsPressed
    MOVI 8 R5 // Down input mask
    READ R7 | &varSelectionRoomPlayerInitializationDataAddress 
    READ R8 | &varPlayerVelocityDataAddress

    funcPollAndTogglePlayerActiveStateLoop: 

        LOAD R6 R4 // R6 has current frame buttons pressed
        AND R5 R6 // R6 is none-zero if player pressed toggle button
        CMPI 0 R6 | GOIF EQ &funcPollAndTogglePlayerActiveStateLoopContinue

        LOAD R6 R1 // R6 has zero if player is currently inactive
        CMPI 0 R6 | GOIF EQ &funcPollAndTogglePlayerActiveStateLoopSetActive

        // Set inactive
        MOVI 0 R6 | STOR R6 R1
        // Color default
        LOAD R6 R7 | STOR R6 R2 | ADDI 1 R7 | ADDI 1 R2
        LOAD R6 R7 | STOR R6 R2 | ADDI 1 R7 | ADDI 1 R2
        LOAD R6 R7 | STOR R6 R2 | ADDI 1 R7 | ADDI 1 R2
        LOAD R6 R7 | STOR R6 R2 | SUBI 3 R7 | SUBI 3 R2
        MOVI 0 R6 | STOR R6 R8 | ADDI 1 R8 | STOR R6 r8 | SUBI 1 R8 // Clear velocity

        GOIF UC &funcPollAndTogglePlayerActiveStateLoopContinue
        funcPollAndTogglePlayerActiveStateLoopSetActive: 

        // Set active
        MOVI 1 R6 | STOR R6 R1
        ADDI 3 R2 // Step to color
        LOAD R6 R3 | STOR R6 R2
        SUBI 3 R2 // Undo step
       

        funcPollAndTogglePlayerActiveStateLoopContinue:
        LSHI 4 R5 // Step input mask to next player down button
        ADDI 1 R3 // Step player default color
        ADDI 4 R2 // Step local player data
        ADDI 1 R1 // Step active player address
        ADDI 4 R7 // Step selection room data
        ADDI 2 R8 // Step velocity
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcPollAndTogglePlayerActiveStateLoop


    %restoreRegs
    %return