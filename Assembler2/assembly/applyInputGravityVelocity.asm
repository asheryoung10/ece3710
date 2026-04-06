// applyInputGravityVelocity.asm
// Fully independent input handling
// Left/right cancel if both pressed, jump always applies

applyInputGravityVelocity:

    // -----------------------------
    // Load velocityY (addr 1025)
    // -----------------------------
    READ R0
    1025
    LOAD R1 R0        // R1 = velocityY

    // -----------------------------
    // Apply gravity (cap at 3)
    // -----------------------------
    CMPI 3 R1
    GOIF GT &applyGravity
    GOIF UC &skipGravity

applyGravity:
    ADDI 1 R1

skipGravity:
    READ R0
    1025
    STOR R1 R0        // store velocityY

    // -----------------------------
    // Load velocityX (addr 1024)
    // -----------------------------
    READ R0
    1024
    LOAD R2 R0        // R2 = velocityX

    // -----------------------------
    // Poll horizontal input independently
    // -----------------------------
    MOVI 0x02 R3       // right mask
    AND R15 R3
    MOVI 0x04 R4       // left mask
    AND R15 R4

    // Default: keep previous horizontal velocity
    // If both pressed → cancel
    CMPI 0 R3
    GOIF EQ &checkLeftOnly
    CMPI 0 R4
    GOIF EQ &rightOnly
    MOVI 0 R2          // both pressed → cancel
    GOIF UC &afterHorz

rightOnly:
    MOVI 1 R2
    GOIF UC &afterHorz

checkLeftOnly:
    CMPI 0 R4
    GOIF EQ &afterHorz
    MOVI -1 R2

afterHorz:
    // -----------------------------
    // Poll jump independently (spacebar)
    // -----------------------------
    MOVI 0x08 R5       // jump mask
    AND R15 R5
    CMPI 0 R5
    GOIF NE &doJump
    GOIF UC &afterJump

doJump:
    MOVI 0 R6
    SUBI 10 R6          // velocityY = -10
    READ R0
    1025
    STOR R6 R0

afterJump:
    // -----------------------------
    // Clamp X velocity
    // -----------------------------
clampXVel:
    CMPI 3 R2
    GOIF LT &maxRight
    GOIF UC &checkLeftClamp

maxRight:
    MOVI 3 R2
    GOIF UC &storeX

checkLeftClamp:
    CMPI -3 R2
    GOIF GT &maxLeft
    GOIF UC &storeX

maxLeft:
    MOVI -3 R2

storeX:
    // -----------------------------
    // Store velocityX
    // -----------------------------
    READ R0
    1024
    STOR R2 R0

    // -----------------------------
    // Update player X (addr 0xC000)
    // -----------------------------
    READ R0
    0xC000
    LOAD R3 R0
    ADD R2 R3
    READ R0
    0xC000
    STOR R3 R0

    // -----------------------------
    // Update player Y (addr 0xC001)
    // -----------------------------
    READ R0
    0xC001
    LOAD R3 R0        // playerY

    READ R0
    1025
    LOAD R5 R0        // velocityY

    ADD R5 R3         // playerY += velocityY

    READ R0
    0xC001
    STOR R3 R0        // store updated playerY

    JCOND UC R13      // return