detectAndResolveCollisions:
    %saveRegs

    MOVI 0 R1 // Player index
    READ R3 | &varPlayerVelocityDataAddress
    ADDI 1 R3 // y velocity

    detectAndResolveCollisionsPlayerLoop:
        MOVI 0 R2 // Rect index
        detectAndResolveCollisionsRectLoop:

            %saveReg(R1)
            MOV R1 R0 | MOV R2 R1
            %call(&detectCollision)
            %restoreReg(R1)
            CMPI 0 R0 | GOIF EQ &detectAndResolveCollisionsRectLoopContinue


            LOAD R4 R3 // R4 has velocity
            CMPI 0 R4 | GOIF GT &detectAndResolveCollisionsRectLoopContinue

            CMPI 9 R2 | GOIF EQ &detectAndResolveCollisionsChooseLevel
            CMPI 11 R2 | GOIF EQ &detectAndResolveCollisionsChooseLevel


            // Collision detected, jump player 
            MOVI 0 R4
            SUBI %playerJumpIncrement R4
            STOR R4 R3

            // Increment audio
            MOVI 10 R4
            READ R5 | &varAudioValue | STOR R4 R5

            GOIF UC &detectAndResolveCollisionsRectLoopContinue

            detectAndResolveCollisionsChooseLevel:
            READ R6 | &varPlayerGameSelection
            ADD R1 R6 // R6 has player selection
            STOR R2 R6 // store level selection as player selection

            detectAndResolveCollisionsRectLoopContinue:
            ADDI 1 R2 | CMPI 64 R2 | GOIF NE &detectAndResolveCollisionsRectLoop

        ADDI 2 R3 // Step y velocity
        ADDI 1 R1 | CMPI 4 R1 | GOIF NE &detectAndResolveCollisionsPlayerLoop

    
    %restoreRegs
    %return


// Assumes R0 has player index, and R1 has rectangle index
detectCollision:
    %saveRegs
    MOV R1 R2 // R2 has rectangle index

    // Get player position
    LSHI 2 R0 // Get player offset
    READ R1 | &varLocalPlayerDataAddress
    ADD R0 R1 // R1 has x pos address
    LOAD R0 R1 // R0 has player x pos
    ADDI 1 R1 | LOAD R1 R1 // R1 has player y pos
    // R0: px, R1: py

    // Get rectangle position
    LSHI 2 R2 // Get rectangle offset
    READ R5 | &varLocalRectDataAddress
    ADD R2 R5 // R5 has x pos address
    LOAD R2 R5 // R2 has rect x pos
    ADDI 1 R5 | LOAD R3 R5 // R3 has rect y pos
    ADDI 1 R5 | LOAD R5 R5 // R5 has packed width height
    MOV R5 R4 | LSHI -8 R4 // R4 has rect width
    LSHI 8 R5 | LSHI -8 R5 // R5 has rect height

    // At this point, R0: px, R1: py, R2: rx, R3: ry, R4: rwidth, R5: rheight
    // Note player is 45 width 41 height

    // Get player width and height
    MOVI 16 R6   // player width
    MOVI 16 R7   // player height

    // -------------------------
    // CHECK 1: px < rx + rw
    // -------------------------
    MOV R2 R8
    ADD R4 R8
    CMP R0 R8
    GOIF GE &detectCollisionNo

    // -------------------------
    // CHECK 2: px + pw > rx
    // -------------------------
    MOV R0 R8
    ADD R6 R8
    CMP R8 R2
    GOIF LE &detectCollisionNo

    // -------------------------
    // CHECK 3: py < ry + rh
    // -------------------------
    MOV R3 R8
    ADD R5 R8
    CMP R1 R8
    GOIF GE &detectCollisionNo

    // -------------------------
    // CHECK 4: py + ph > ry
    // -------------------------
    MOV R1 R8
    ADD R7 R8
    CMP R8 R3
    GOIF LE &detectCollisionNo

    // -------------------------
    // COLLISION TRUE
    // -------------------------
    MOVI 1 R0
    GOIF UC &detectCollisionEnd

detectCollisionNo:
    MOVI 0 R0

detectCollisionEnd:
    MOV R0 R7
    %restoreRegs
    MOV R7 R0 // Prevent restore from clearing return signal
    %return