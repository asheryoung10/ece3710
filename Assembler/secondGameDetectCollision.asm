funcSecondGameDetectAndResolveCollisions:
    %saveRegs

    MOVI 0 R1 // Player index
    READ R3 | &varPlayerVelocityDataAddress
    ADDI 1 R3 // y velocity

    funcSecondGameDetectAndResolveCollisionsPlayerLoop:
        MOVI 0 R2 // Rect index
        READ R6 | &varRectType
        READ R4 | &varRectAttribA
        READ R5 | &varRectAttribB

        funcSecondGameDetectAndResolveCollisionsRectLoop:

            %saveReg(R1)
            MOV R1 R0 | MOV R2 R1
            %call(&detectCollision)
            %restoreReg(R1)
            CMPI 0 R0 | GOIF EQ &funcSecondGameDetectAndResolveCollisionsRectLoopContinue


            LOAD R12 R3 // R12 has velocity
            CMPI 0 R12 | GOIF GT &funcSecondGameDetectAndResolveCollisionsRectLoopContinue

            // Collision detected, check platform type
            LOAD R12 R6
            CMPI 3 R12 | GOIF EQ &funcSecondGameDetectAndResolveCollisionsRectLoopBouncy
            CMPI 0x30 R12 | GOIF EQ &funcSecondGameDetectAndResolveCollisionsRectLoopBroken

            //Fall through to default behaviour
            MOVI 0 R12
            SUBI %playerJumpIncrement R12
            STOR R12 R3
            GOIF UC &funcSecondGameDetectAndResolveCollisionsRectLoopAudio


            funcSecondGameDetectAndResolveCollisionsRectLoopBouncy:
            MOVI 0 R12
            SUBI %playerJumpHigh R12
            STOR R12 R3
            GOIF UC &funcSecondGameDetectAndResolveCollisionsRectLoopAudio

            funcSecondGameDetectAndResolveCollisionsRectLoopBroken:
            LOAD R12 R4 | ADDI 1 R12 | STOR R12 R4
            CMPI 4 R12 | GOIF LT &funcSecondGameDetectAndResolveCollisionsRectLoopContinue
            MOVI 0 R12
            SUBI %playerJumpIncrement R12
            STOR R12 R3
            GOIF UC &funcSecondGameDetectAndResolveCollisionsRectLoopAudio


            funcSecondGameDetectAndResolveCollisionsRectLoopAudio:
            // Increment audio
            MOVI 10 R10
            READ R12 | &varAudioValue | STOR R10 R12


            funcSecondGameDetectAndResolveCollisionsRectLoopContinue:
            ADDI 1 R6 | ADDI 1 R5 | ADDI 1 R4
            ADDI 1 R2 | CMPI 64 R2 | GOIF NE &funcSecondGameDetectAndResolveCollisionsRectLoop
        
        ADDI 2 R3 // Step y velocity
        ADDI 1 R1 | CMPI 4 R1 | GOIF NE &funcSecondGameDetectAndResolveCollisionsPlayerLoop

    
    %restoreRegs
    %return