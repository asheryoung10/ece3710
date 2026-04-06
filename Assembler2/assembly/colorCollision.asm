#include "checkOverlap.asm"

// Loops through all rectangles and colors them based on collision
// Input: none
// Modifies: R0-R6, R12-R14, R15
colorCollision:
    SUBI 1 R14 // Make room on stack
    STOR R13 R14 // Save return address on stack

    MOVI 0 R1 // R1 holds our index
    READ R2
    0x8003 // R2 holds address of color

    colorCollisionLoop:
    SUBI 1 R14
    STOR R1 R14 // save R1 on stack
    SUBI 1 R14
    STOR R2 R14 // save R2 on stack

    MOV R1 R0 // put index into r0 (first parameter)
    READ R3
    &checkOverlapLower
    JAL R13 R3 // check overlap

    // Restore from stack
    LOAD R2 R14
    ADDI 1 R14
    LOAD R1 R14
    ADDI 1 R14

    CMPI 1 R0
    GOIF EQ &colorCollisionYes
    // no collision color dark
    READ R3 // R3 holds color
    0x1111 // white for collision
    GOIF UC &colorCollisionApplied
    colorCollisionYes:
    READ R3 // R3 holds color
    0xcccc // white for collision
    colorCollisionApplied:
    STOR R3 R2 // write color to rect
    ADDI 1 R1 // increment i
    ADDI 4 R2 // skip to next color address
    CMPI 16 R1
    GOIF NE &colorCollisionLoop

    LOAD R13 R14 // restore return address from stack
    ADDI 1 R14 // restore stack value
    JCOND UC R13