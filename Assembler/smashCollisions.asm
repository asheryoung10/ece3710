#include "macros.asm"

smashDetectAndResolveCollisions:
    %saveRegs

    MOVI 0 R1 // Player index
    READ R3 | &varPlayerVelocityDataAddress
    ADDI 1 R3 // y velocity

    smashDetectAndResolveCollisionsPlayerLoop:
        MOVI 0 R2 // Rect index
        smashDetectAndResolveCollisionsRectLoop:
            %saveReg(R1)
            MOV R1 R0 | MOV R2 R1
            %call(&detectCollision)
            %restoreReg(R1)
            CMPI 0 R0 | GOIF EQ &smashDetectAndResolveCollisionsRectLoopContinue

            LOAD R4 R3 // R4 has velocity
            CMPI 0 R4 | GOIF GT &smashDetectAndResolveCollisionsRectLoopContinue

            // Collision detected, make player stop
            MOVI -1 R4
            STOR R4 R3


            GOIF UC &smashDetectAndResolveCollisionsRectLoopContinue

            smashDetectAndResolveCollisionsRectLoopContinue:
            ADDI 1 R2 | CMPI 64 R2 | GOIF NE &smashDetectAndResolveCollisionsRectLoop

        CMPI 1 R6 | GOIF EQ &smashDetectAndResolveCollisionsPlayerLoopContinue


        smashDetectAndResolveCollisionsPlayerLoopContinue:
        ADDI 2 R3 // Step y velocity
        ADDI 1 R1 | CMPI 4 R1 | GOIF NE &smashDetectAndResolveCollisionsPlayerLoop

    
    %restoreRegs
    %return

funcFirstGameCheckBlastZones:
    %saveRegs

    READ R0 | &varLocalPlayerDataAddress
    READ R1 | &varActivePlayersAddress
    MOVI 0 R3 // player index
    MOVI 1 R7 // remains 1 only if all players are inactive

    funcFirstGameCheckBlastZonesLoop:
        LOAD R6 R1
        CMPI 0 R6 | GOIF EQ &funcFirstGameCheckBlastZonesLoopContinue // skip inactive

        MOVI 0 R7 // found an active player

        LOAD R4 R0 // x
        ADDI 1 R0
        LOAD R5 R0 // y
        SUBI 1 R0

        // Left blast zone: x + width <= 0
        MOV R4 R6
        ADDI %playerWidth R6
        READ R12 | 0
        CMP R6 R12
        GOIF LE &funcFirstGameCheckBlastZonesKillPlayer

        // Right blast zone: x >= 640
        READ R12 | 640
        CMP R4 R12
        GOIF GE &funcFirstGameCheckBlastZonesKillPlayer

        // Top blast zone: y + height <= 0
        MOV R5 R6
        ADDI %playerHeight R6
        READ R12 | 0
        CMP R6 R12
        GOIF LE &funcFirstGameCheckBlastZonesKillPlayer

        // Bottom blast zone: same as fall
        READ R12 | %fallCutoff
        CMP R12 R5
        GOIF GT &funcFirstGameCheckBlastZonesLoopContinue

        funcFirstGameCheckBlastZonesKillPlayer:
        MOVI 0 R12
        STOR R12 R1

        funcFirstGameCheckBlastZonesLoopContinue:
        ADDI 4 R0
        ADDI 1 R1
        ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcFirstGameCheckBlastZonesLoop

    %restoreRegs
    %return

funcDetectPlayerHitCollisions:
    %saveRegs

    MOVI 0 R0 // player A index

    funcDetectPlayerHitCollisionsOuterLoop:
        READ R1 | &varActivePlayersAddress
        ADD R0 R1
        LOAD R1 R1
        CMPI 0 R1 | GOIF EQ &funcDetectPlayerHitCollisionsOuterLoopContinue // skip inactive player

        MOVI 0 R2

        funcDetectPlayerHitCollisionsInnerLoop:
            CMP R0 R2 | GOIF EQ &funcDetectPlayerHitCollisionsOuterLoopContinue
            CMPI 4 R2 | GOIF EQ &funcDetectPlayerHitCollisionsOuterLoopContinue

            READ R1 | &varActivePlayersAddress
            ADD R2 R1
            LOAD R1 R1
            CMPI 0 R1 | GOIF EQ &funcDetectPlayerHitCollisionsInnerLoopContinue

            // Load player A local x/y into R4/R5
            MOV R0 R12
            LSHI 2 R12
            READ R1 | &varLocalPlayerDataAddress
            ADD R12 R1
            LOAD R4 R1
            ADDI 1 R1
            LOAD R5 R1

            // Load player B local x/y into R6/R7
            MOV R2 R12
            LSHI 2 R12
            READ R1 | &varLocalPlayerDataAddress
            ADD R12 R1
            LOAD R6 R1
            ADDI 1 R1
            LOAD R7 R1

            // Player-vs-player hitbox size: width 45, height 41.
            MOVI 1 R8
            LSHI 5 R8
            ADDI 13 R8
            MOVI 1 R9
            LSHI 5 R9
            ADDI 9 R9

            // Require vertical overlap.
            MOV R7 R12
            ADD R9 R12
            CMP R5 R12
            GOIF GE &funcDetectPlayerHitCollisionsInnerLoopContinue

            MOV R5 R12
            ADD R9 R12
            CMP R12 R7
            GOIF LE &funcDetectPlayerHitCollisionsInnerLoopContinue

            // Load player A vx into R10
            MOV R0 R12
            LSHI 1 R12
            READ R1 | &varPlayerVelocityDataAddress
            ADD R12 R1
            LOAD R10 R1

            // Load player B vx into R11
            MOV R2 R12
            LSHI 1 R12
            READ R1 | &varPlayerVelocityDataAddress
            ADD R12 R1
            LOAD R11 R1

            // Decide who is left/right.
            CMP R4 R6
            GOIF LT &funcDetectPlayerHitCollisionsAIsLeft
            GOIF GT &funcDetectPlayerHitCollisionsBIsLeft

            // Same x position: use velocity sign.
            CMPI 0 R10 | GOIF GT &funcDetectPlayerHitCollisionsLaunchBFromA
            CMPI 0 R10 | GOIF LT &funcDetectPlayerHitCollisionsLaunchBFromA
            CMPI 0 R11 | GOIF EQ &funcDetectPlayerHitCollisionsInnerLoopContinue
            GOIF UC &funcDetectPlayerHitCollisionsLaunchAFromB

            funcDetectPlayerHitCollisionsAIsLeft:
            // If A.right < B.left, they are not touching.
            MOV R4 R12
            ADD R8 R12
            CMP R12 R6
            GOIF LT &funcDetectPlayerHitCollisionsInnerLoopContinue

            // A moving right hits B.
            CMPI 0 R10 | GOIF GT &funcDetectPlayerHitCollisionsLaunchBFromA

            // B moving left hits A.
            CMPI 0 R11 | GOIF LT &funcDetectPlayerHitCollisionsLaunchAFromB
            GOIF UC &funcDetectPlayerHitCollisionsInnerLoopContinue

            funcDetectPlayerHitCollisionsBIsLeft:
            // If B.right < A.left, they are not touching.
            MOV R6 R12
            ADD R8 R12
            CMP R12 R4
            GOIF LT &funcDetectPlayerHitCollisionsInnerLoopContinue

            // B moving right hits A.
            CMPI 0 R11 | GOIF GT &funcDetectPlayerHitCollisionsLaunchAFromB

            // A moving left hits B.
            CMPI 0 R10 | GOIF LT &funcDetectPlayerHitCollisionsLaunchBFromA
            GOIF UC &funcDetectPlayerHitCollisionsInnerLoopContinue

            funcDetectPlayerHitCollisionsLaunchAFromB:
            %saveReg(R2)
            %saveReg(R0)
            MOV R0 R12
            MOV R2 R0
            MOV R12 R2
            %call(&funcLaunchPlayerBFromA)
            %restoreReg(R0)
            %restoreReg(R2)
            GOIF UC &funcDetectPlayerHitCollisionsInnerLoopContinue

            funcDetectPlayerHitCollisionsLaunchBFromA:
            %saveReg(R0)
            %saveReg(R2)
            %call(&funcLaunchPlayerBFromA)
            %restoreReg(R2)
            %restoreReg(R0)

            funcDetectPlayerHitCollisionsInnerLoopContinue:
            ADDI 1 R2
            GOIF UC &funcDetectPlayerHitCollisionsInnerLoop

        funcDetectPlayerHitCollisionsOuterLoopContinue:
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcDetectPlayerHitCollisionsOuterLoop

    %restoreRegs
    %return


// Input: R0 = player A index, R2 = player B index
// Output: R0 = 1 if either player is contacting the other from their movement direction.
funcPlayersCanHit:
    %saveRegs

    MOV R0 R6 // save A index
    MOV R2 R5 // save B index

    // Load player A position into R0/R1
    LSHI 2 R0
    READ R3 | &varLocalPlayerDataAddress
    ADD R0 R3
    LOAD R0 R3
    ADDI 1 R3
    LOAD R1 R3

    // Load player B position into R2/R3
    LSHI 2 R2
    READ R4 | &varLocalPlayerDataAddress
    ADD R2 R4
    LOAD R2 R4
    ADDI 1 R4
    LOAD R3 R4

    // Player-vs-player hitbox size: width 45, height 41.
    MOVI 1 R8
    LSHI 5 R8
    ADDI 13 R8
    MOVI 1 R9
    LSHI 5 R9
    ADDI 9 R9

    // First require vertical overlap.
    MOV R3 R4
    ADD R9 R4
    CMP R1 R4
    GOIF GE &funcPlayersCanHitNo

    MOV R1 R4
    ADD R9 R4
    CMP R4 R3
    GOIF LE &funcPlayersCanHitNo

    // Load A vx into R4
    MOV R6 R4
    LSHI 1 R4
    READ R7 | &varPlayerVelocityDataAddress
    ADD R4 R7
    LOAD R4 R7

    // A moving right into B: A.x < B.x and A.right >= B.left
    CMPI 0 R4 | GOIF LE &funcPlayersCanHitCheckALeft
    CMP R0 R2
    GOIF GE &funcPlayersCanHitCheckALeft
    MOV R0 R7
    ADD R8 R7
    CMP R7 R2
    GOIF LT &funcPlayersCanHitCheckALeft
    MOVI 1 R0
    GOIF UC &funcPlayersCanHitEnd

    funcPlayersCanHitCheckALeft:
    // A moving left into B: A.x > B.x and B.right >= A.left
    CMPI 0 R4 | GOIF GE &funcPlayersCanHitCheckBRight
    CMP R0 R2
    GOIF LE &funcPlayersCanHitCheckBRight
    MOV R2 R7
    ADD R8 R7
    CMP R7 R0
    GOIF LT &funcPlayersCanHitCheckBRight
    MOVI 1 R0
    GOIF UC &funcPlayersCanHitEnd

    funcPlayersCanHitCheckBRight:
    // Load B vx into R4
    MOV R5 R4
    LSHI 1 R4
    READ R7 | &varPlayerVelocityDataAddress
    ADD R4 R7
    LOAD R4 R7

    // B moving right into A: B.x < A.x and B.right >= A.left
    CMPI 0 R4 | GOIF LE &funcPlayersCanHitCheckBLeft
    CMP R2 R0
    GOIF GE &funcPlayersCanHitCheckBLeft
    MOV R2 R7
    ADD R8 R7
    CMP R7 R0
    GOIF LT &funcPlayersCanHitCheckBLeft
    MOVI 1 R0
    GOIF UC &funcPlayersCanHitEnd

    funcPlayersCanHitCheckBLeft:
    // B moving left into A: B.x > A.x and A.right >= B.left
    CMPI 0 R4 | GOIF GE &funcPlayersCanHitNo
    CMP R2 R0
    GOIF LE &funcPlayersCanHitNo
    MOV R0 R7
    ADD R8 R7
    CMP R7 R2
    GOIF LT &funcPlayersCanHitNo
    MOVI 1 R0
    GOIF UC &funcPlayersCanHitEnd

    funcPlayersCanHitNo:
    MOVI 0 R0

    funcPlayersCanHitEnd:
    MOV R0 R7
    %restoreRegs
    MOV R7 R0
    %return


// Input: R0 = player A index, R2 = player B index
// Output: R0 = 1 if overlapping, 0 otherwise
funcPlayersOverlap:
    %saveRegs

    // Load player A position into R0/R1
    LSHI 2 R0
    READ R3 | &varLocalPlayerDataAddress
    ADD R0 R3
    LOAD R0 R3
    ADDI 1 R3
    LOAD R1 R3

    // Load player B position into R2/R3
    LSHI 2 R2
    READ R4 | &varLocalPlayerDataAddress
    ADD R2 R4
    LOAD R2 R4
    ADDI 1 R4
    LOAD R3 R4

    // Player-vs-player hitbox size: width 45, height 41.
    MOVI 1 R8
    LSHI 5 R8
    ADDI 13 R8
    MOVI 1 R9
    LSHI 5 R9
    ADDI 9 R9

    // Check A.x < B.x + width
    MOV R2 R4
    ADD R8 R4
    CMP R0 R4
    GOIF GE &funcPlayersOverlapNo

    // Check A.x + width > B.x
    MOV R0 R4
    ADD R8 R4
    CMP R4 R2
    GOIF LE &funcPlayersOverlapNo

    // Check A.y < B.y + height
    MOV R3 R4
    ADD R9 R4
    CMP R1 R4
    GOIF GE &funcPlayersOverlapNo

    // Check A.y + height > B.y
    MOV R1 R4
    ADD R9 R4
    CMP R4 R3
    GOIF LE &funcPlayersOverlapNo

    MOVI 1 R0
    GOIF UC &funcPlayersOverlapEnd

    funcPlayersOverlapNo:
    MOVI 0 R0

    funcPlayersOverlapEnd:
    MOV R0 R7
    %restoreRegs
    MOV R7 R0
    %return


// Input: R0 = player A index, R2 = player B index
funcResolvePlayerHitCollision:
    %saveRegs

    // Load x velocities
    LSHI 1 R0
    READ R1 | &varPlayerVelocityDataAddress
    ADD R0 R1
    LOAD R3 R1 // A vx

    LSHI 1 R2
    READ R4 | &varPlayerVelocityDataAddress
    ADD R2 R4
    LOAD R5 R4 // B vx

    // If A is moving right and B is not moving faster right, A launches B to the right.
    CMPI 0 R3 | GOIF LE &funcResolvePlayerHitCollisionCheckBLeft
    CMP R5 R3
    GOIF GT &funcResolvePlayerHitCollisionCheckBLeft

    %saveReg(R0)
    %saveReg(R2)
    %call(&funcLaunchPlayerBFromA)
    %restoreReg(R2)
    %restoreReg(R0)
    GOIF UC &funcResolvePlayerHitCollisionEnd

    funcResolvePlayerHitCollisionCheckBLeft:
    // If B is moving right and A is not moving faster right, B launches A to the right. Doesn't work
    CMPI 0 R5 | GOIF LE &funcResolvePlayerHitCollisionCheckALeft
    CMP R3 R5
    GOIF GT &funcResolvePlayerHitCollisionCheckALeft

    %saveReg(R2)
    %saveReg(R0)
    %call(&funcLaunchPlayerBFromA)
    %restoreReg(R0)
    %restoreReg(R2)
    GOIF UC &funcResolvePlayerHitCollisionEnd

    funcResolvePlayerHitCollisionCheckALeft:
    // If A is moving left and B is not moving faster left, A launches B to the left.
    CMPI 0 R3 | GOIF GE &funcResolvePlayerHitCollisionCheckBLeft2
    CMP R5 R3
    GOIF LT &funcResolvePlayerHitCollisionCheckBLeft2

    %saveReg(R0)
    %saveReg(R2)
    %call(&funcLaunchPlayerBFromA)
    %restoreReg(R2)
    %restoreReg(R0)
    GOIF UC &funcResolvePlayerHitCollisionEnd

    funcResolvePlayerHitCollisionCheckBLeft2:
    // If B is moving left and A is not moving faster left, B launches A to the left.
    CMPI 0 R5 | GOIF GE &funcResolvePlayerHitCollisionEnd
    CMP R3 R5
    GOIF LT &funcResolvePlayerHitCollisionEnd

    %saveReg(R2)
    %saveReg(R0)
    %call(&funcLaunchPlayerBFromA)
    %restoreReg(R0)
    %restoreReg(R2)

    funcResolvePlayerHitCollisionEnd:
    %restoreRegs
    %return


// Input: R0 = attacker index, R2 = target index
// Uses attacker's x velocity to launch target and pushes target out of overlap.
// Input: R0 = attacker index, R2 = target index
funcLaunchPlayerBFromA:
    %saveRegs

    // Get attacker x velocity in R3.
    LSHI 1 R0
    READ R1 | &varPlayerVelocityDataAddress
    ADD R0 R1
    LOAD R3 R1

    // Apply a fixed launch speed to the target in the direction of the hit.
    LSHI 1 R2
    READ R4 | &varPlayerVelocityDataAddress
    ADD R2 R4

    MOVI 48 R1
    CMPI 0 R3 | GOIF LT &funcLaunchPlayerBFromALeft

    MOVI 0 R1
    SUBI 48 R1
    STOR R1 R4 
    GOIF UC &funcLaunchPlayerBFromASetY

    funcLaunchPlayerBFromALeft:
    MOVI 48 R1
    STOR R1 R4

    funcLaunchPlayerBFromASetY:
    // Small upward pop so the launch is visible and not glued to the floor.
    ADDI 1 R4
    MOVI -50 R1
    STOR R1 R4

    %restoreRegs
    %return