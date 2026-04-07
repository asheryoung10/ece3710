// clampPlayerInBounds.asm
// Ensures the player stays fully on-screen (640x480), player is 64x64
// Resets velocity if player hits bounds

clampPlayerInBounds:

    // -----------------------------
    // Clamp X position
    // -----------------------------
    READ R0
    0xC000
    LOAD R1 R0            // R1 = playerX

    CMPI 0 R1
    GOIF GT &clampPlayerInBounds_setXMin

    // compare to max X = 576
    READ R0
    576
    CMP R0 R1
    GOIF LT &clampPlayerInBounds_setXMax
    GOIF UC &clampPlayerInBounds_checkY

clampPlayerInBounds_setXMin:
    MOVI 0 R1
    // reset X velocity
    READ R0
    1024
    MOVI 0 R2
    STOR R2 R0
    GOIF UC &clampPlayerInBounds_storeX

clampPlayerInBounds_setXMax:
    READ R0
    576
    MOV R0 R1             // clamp X to maxX
    // reset X velocity
    READ R0
    1024
    MOVI 0 R2
    STOR R2 R0

clampPlayerInBounds_storeX:
    READ R0
    0xC000
    STOR R1 R0            // store clamped X

    // -----------------------------
    // Clamp Y position
    // -----------------------------
clampPlayerInBounds_checkY:
    READ R0
    0xC002
    LOAD R2 R0            // R2 = playerY

    CMPI 0 R2
    GOIF GT &clampPlayerInBounds_setYMin

    // compare to max Y = 416
    READ R0
    416
    CMP R0 R2
    GOIF LT &clampPlayerInBounds_setYMax
    GOIF UC &clampPlayerInBounds_done

clampPlayerInBounds_setYMin:
    MOVI 0 R2
    // reset Y velocity
    READ R0
    1025
    MOVI 0 R3
    STOR R3 R0
    GOIF UC &clampPlayerInBounds_storeY

clampPlayerInBounds_setYMax:
    READ R0
    416
    MOV R0 R2             // clamp Y to maxY
    // reset Y velocity
    READ R0
    1025
    MOVI 0 R3
    STOR R3 R0

clampPlayerInBounds_storeY:
    READ R0
    0xC002
    STOR R2 R0            // store clamped Y

clampPlayerInBounds_done:
    JCOND UC R13          // return
