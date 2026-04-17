funcUpdateCameraPosition:
    %saveRegs

    READ R0 | &varActivePlayersAddress
    MOVI 0 R1 // i = 0
    funcUpdateCameraPositionFindActivePlayerLoop:
        MOV R0 R2 // R2 has active player address
        ADD R1 R2 // R2 has current player active state address
        LOAD R2 R2 // R2 has current player active state
        CMPI 0 R2 | GOIF NE &funcUpdateCameraPositionFoundActivePlayer
        ADDI 1 R1
        CMPI 4 R1 | GOIF NE &funcUpdateCameraPositionFindActivePlayerLoop

    READ R0 | &varCameraPositionAddress
    MOVI 0 R1 | STOR R1 R0 | ADDI 1 R0 | STOR R1 R0 // Default camera position is 0,0. 


    %restoreRegs
    %return // Did not find an active player.

    // Found an active player, calculate camera position based on all active players and store it.
    funcUpdateCameraPositionFoundActivePlayer:

    READ R0 | &varCameraPositionAddress
    READ R1 | &varActivePlayersAddress
    READ R2 | &varLocalPlayerDataAddress
    MOVI 0 R3 // i = 0
    MOVI 0 R4 // sum count 
    MOVI 0 R5 // cameraX
    MOVI 0 R6 // cameraY
    funcUpdateCameraPositionLoop:
        MOV R3 R7 | ADD R1 R7 | LOAD R7 R7 // R7 has current player active state
        CMPI 0 R7 | GOIF EQ &funcUpdateCameraPositionLoopContinue
        // Player is active, add their position to the camera position.
        MOV R3 R9 | LSHI 2 R9
        MOV R2 R7 | ADD R9 R7 | LOAD R8 R7 // R8 has current player x pos
        ADDI 1 R7 | LOAD R7 R7 // R7 has current player y pos
        ADD R8 R5
        ADD R7 R6
        ADDI 1 R4 // Increment count of players added to camera position average.

        funcUpdateCameraPositionLoopContinue:
        // Make i wrap 0 - 3 so we can loop through players multiple times if needed. 
        ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcUpdateCameraPositionLoopSkipResetIndex
        MOVI 0 R3
        funcUpdateCameraPositionLoopSkipResetIndex:
        // Only stop when we have added 4 players worth of positions.
        CMPI 4 R4 | GOIF NE &funcUpdateCameraPositionLoop


    ARSHI -2 R5 // Average out the position
    ARSHI -2 R6 // Average out the position
    READ R8 | &varWorldScaleSize | LOAD R8 R8
    MOVI 0 R9 | SUB R8 R9 | ADDI 1 R9

    READ R7 | 298
    LSH R9 R7    
    SUB R7 R5

    READ R7 | 218
    //MUL R8 R7
    LSH R9 R7

     SUB R7 R6

    STOR R5 R0 | ADDI 1 R0 | STOR R6 R0 // Store camera position

    %restoreRegs
    %return