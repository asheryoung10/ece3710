funcSecondGameDetectAndResolveCollisions:
    %saveRegs

    MOVI 0 R1 // Player index
    READ R3 | &varPlayerVelocityDataAddress
    ADDI 1 R3 // y velocity

    funcSecondGameDetectAndResolveCollisionsPlayerLoop:
        MOVI 0 R2 // Rect index
        READ R6 | &varRectType
        funcSecondGameDetectAndResolveCollisionsRectLoop:

            %saveReg(R1)
            MOV R1 R0 | MOV R2 R1
            %call(&detectCollision)
            %restoreReg(R1)
            CMPI 0 R0 | GOIF EQ &funcSecondGameDetectAndResolveCollisionsRectLoopContinue


            LOAD R4 R3 // R4 has velocity
            CMPI 0 R4 | GOIF GT &funcSecondGameDetectAndResolveCollisionsRectLoopContinue

            LOAD R12 R6
            CMPI 3 R12 | GOIF NE &funcSecondGameDetectAndResolveCollisionsRectLoopRegular

            MOVI 0 R4
            SUBI %playerJumpHigh R4
            STOR R4 R3

            GOIF UC &funcSecondGameDetectAndResolveCollisionsRectLoopAudio
            // Collision detected, jump player 
            funcSecondGameDetectAndResolveCollisionsRectLoopRegular:
            MOVI 0 R4
            SUBI %playerJumpIncrement R4
            STOR R4 R3


            funcSecondGameDetectAndResolveCollisionsRectLoopAudio:
            // Increment audio
            MOVI 10 R4
            READ R5 | &varAudioValue | STOR R4 R5


            funcSecondGameDetectAndResolveCollisionsRectLoopContinue:
            ADDI 1 R6
            ADDI 1 R2 | CMPI 64 R2 | GOIF NE &funcSecondGameDetectAndResolveCollisionsRectLoop
        
        ADDI 2 R3 // Step y velocity
        ADDI 1 R1 | CMPI 4 R1 | GOIF NE &funcSecondGameDetectAndResolveCollisionsPlayerLoop

    
    %restoreRegs
    %return