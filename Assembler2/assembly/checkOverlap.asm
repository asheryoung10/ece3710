
// Input: R0, the index of the rectangle (note player dimensions are 64x64), rect dimensions vary
// Output R0, 1 if collision, 0 if no collision
// Modifes R0-R5
checkOverlap:
    SUBI 1 R14  // Make room on the stack
    STOR R13 R14 // Save return address to stack so we can call other functions safely

    MOVI 0 R1 //i = 0
    READ R2
    0x8000  // R2 has base address of first rectangle

    checkOverlapIncrementRectOffset:
        CMP R0 R1
        GOIF EQ &checkOverlapObtainedRectangleOffset // We have correct index
        ADDI 1 R1  // Keep going
        ADDI 4 R2 // Offset to next rect
        GOIF UC &checkOverlapIncrementRectOffset
    checkOverlapObtainedRectangleOffset:
    LOAD R0 R2 // rect xpos
    ADDI 1 R2
    LOAD R1 R2 // rect ypos
    ADDI 1 R2
    LOAD R2 R2 // rect packed width height 
    READ R3
    0xFF00
    READ R4
    0x00FF
    AND R2 R3
    AND R2 R4
    LSHI -8 R3
    MOV R3 R2
    MOV R4 R3
    // Now rect data is in R0 = xpos, R1 = ypos, r2 = width, r3 = height
    READ R4
    0xC001
    LOAD R5 R4 // R5 = playerY
    SUBI 1 R4
    LOAD R4 R4 // R4 = playerX

    //AI code here
        // -----------------------------
        // Check horizontal overlap
        // -----------------------------
        MOV R4 R6        // R6 = playerX
        ADDI 64 R6       // R6 = playerX + 64
        CMP R0 R6        // compare rectX vs playerX+64
        GOIF GE &checkOverlapnoCollision   // if rectX >= playerX+64 → no collision

        ADD R2 R0        // R0 = rectX + rectWidth
        CMP R0 R4        // compare rectX+width vs playerX
        GOIF LE &checkOverlapnoCollision   // if rectX+width <= playerX → no collision

        // -----------------------------
        // Check vertical overlap
        // -----------------------------
        MOV R5 R6        // R6 = playerY
        ADDI 64 R6       // R6 = playerY + 64
        CMP R1 R6        // rectY vs playerY+64
        GOIF GE &checkOverlapnoCollision

        ADD R3 R1        // R1 = rectY + rectHeight
        CMP R1 R5        // rectY+height vs playerY
        GOIF LE &checkOverlapnoCollision

        // -----------------------------
        // Rectangles overlap
        // -----------------------------
        MOVI 1 R0        // collision = 1
        GOIF UC &checkOverlapdoneOverlap

    checkOverlapnoCollision:
        MOVI 0 R0        // collision = 0
    checkOverlapdoneOverlap:
    //AI code done (set R0 to indicate, 1 is collide, 0 is no collide)
    LOAD R13 R14 // restore the return address
    ADDI 1 R14 // restore the stack
    JCOND UC R13 // return



// Input: R0, the index of the rectangle (note player dimensions are 64x64), rect dimensions vary
// Output R0, 1 if collision, 0 if no collision
// Modifes R0-R5
checkOverlapLower:
    SUBI 1 R14  // Make room on the stack
    STOR R13 R14 // Save return address to stack so we can call other functions safely

    MOVI 0 R1 //i = 0
    READ R2
    0x8000  // R2 has base address of first rectangle

    checkOverlapLowerIncrementRectOffset:
        CMP R0 R1
        GOIF EQ &checkOverlapLowerObtainedRectangleOffset // We have correct index
        ADDI 1 R1  // Keep going
        ADDI 4 R2 // Offset to next rect
        GOIF UC &checkOverlapLowerIncrementRectOffset
    checkOverlapLowerObtainedRectangleOffset:
    LOAD R0 R2 // rect xpos
    ADDI 1 R2
    LOAD R1 R2 // rect ypos
    ADDI 1 R2
    LOAD R2 R2 // rect packed width height 
    READ R3
    0xFF00
    READ R4
    0x00FF
    AND R2 R3
    AND R2 R4
    LSHI -8 R3
    MOV R3 R2
    MOV R4 R3
    // Now rect data is in R0 = xpos, R1 = ypos, r2 = width, r3 = height
    READ R4
    0xC001
    LOAD R5 R4 // R5 = playerY
    ADDI 60 R5
    SUBI 1 R4
    LOAD R4 R4 // R4 = playerX

    //AI code here
        // -----------------------------
        // Check horizontal overlap
        // -----------------------------
        MOV R4 R6        // R6 = playerX
        ADDI 64 R6       // R6 = playerX + 64
        CMP R0 R6        // compare rectX vs playerX+64
        GOIF GE &checkOverlapLowernoCollision   // if rectX >= playerX+64 → no collision

        ADD R2 R0        // R0 = rectX + rectWidth
        CMP R0 R4        // compare rectX+width vs playerX
        GOIF LE &checkOverlapLowernoCollision   // if rectX+width <= playerX → no collision

        // -----------------------------
        // Check vertical overlap
        // -----------------------------
        MOV R5 R6        // R6 = playerY
        ADDI 4 R6       // R6 = playerY + 64
        CMP R1 R6        // rectY vs playerY+64
        GOIF GE &checkOverlapLowernoCollision

        ADD R3 R1        // R1 = rectY + rectHeight
        CMP R1 R5        // rectY+height vs playerY
        GOIF LE &checkOverlapLowernoCollision

        // -----------------------------
        // Rectangles overlap
        // -----------------------------
        MOVI 1 R0        // collision = 1
        GOIF UC &checkOverlapLowerdoneOverlap

    checkOverlapLowernoCollision:
        MOVI 0 R0        // collision = 0
    checkOverlapLowerdoneOverlap:
    //AI code done (set R0 to indicate, 1 is collide, 0 is no collide)
    LOAD R13 R14 // restore the return address
    ADDI 1 R14 // restore the stack
    JCOND UC R13 // return
