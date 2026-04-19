// R7 average X or 0, R8 average Y or 0
funcGetAveragePlayerPosition:
    %saveRegs

    READ R0 | &varActivePlayersAddress
    MOVI 0 R1 // i = 0
    funcGetAveragePlayerPositionFindActivePlayerLoop:
        MOV R0 R2 // R2 has active player address
        ADD R1 R2 // R2 has current player active state address
        LOAD R2 R2 // R2 has current player active state
        CMPI 0 R2 | GOIF NE &funcGetAveragePlayerPositionFoundActivePlayer
        ADDI 1 R1
        CMPI 4 R1 | GOIF NE &funcGetAveragePlayerPositionFindActivePlayerLoop

    READ R0 | &varCameraPositionAddress
    MOVI 0 R1 | STOR R1 R0 | ADDI 1 R0 | STOR R1 R0 // Default camera position is 0,0. 

    MOVI 0 R7
    MOVI 0 R8
    %restoreRegs
    %return // Did not find an active player.

    // Found an active player, calculate camera position based on all active players and store it.
    funcGetAveragePlayerPositionFoundActivePlayer:

    READ R0 | &varCameraPositionAddress
    READ R1 | &varActivePlayersAddress
    READ R2 | &varLocalPlayerDataAddress
    MOVI 0 R3 // i = 0
    MOVI 0 R4 // sum count 
    MOVI 0 R5 // cameraX
    MOVI 0 R6 // cameraY
    funcGetAveragePlayerPositionLoop:
        MOV R3 R7 | ADD R1 R7 | LOAD R7 R7 // R7 has current player active state
        CMPI 0 R7 | GOIF EQ &funcGetAveragePlayerPositionLoopContinue
        // Player is active, add their position to the camera position.
        MOV R3 R9 | LSHI 2 R9
        MOV R2 R7 | ADD R9 R7 | LOAD R8 R7 // R8 has current player x pos
        ADDI 1 R7 | LOAD R7 R7 // R7 has current player y pos
        ADD R8 R5
        ADD R7 R6
        ADDI 1 R4 // Increment count of players added to camera position average.

        funcGetAveragePlayerPositionLoopContinue:
        // Make i wrap 0 - 3 so we can loop through players multiple times if needed. 
        ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcGetAveragePlayerPositionLoopSkipResetIndex
        MOVI 0 R3
        funcGetAveragePlayerPositionLoopSkipResetIndex:
        // Only stop when we have added 4 players worth of positions.
        CMPI 4 R4 | GOIF NE &funcGetAveragePlayerPositionLoop


    ARSHI -2 R5 // Average out the position
    ARSHI -2 R6 // Average out the position
    MOV R5 R7
    MOV R6 R8
    %restoreRegs
    %return