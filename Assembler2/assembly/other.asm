MOVI 15 R5
MOV R5 R4
MOVI 0x01 R4
LSHI 15 R4        // R4 = rectangle base

MOVI 0 R5         // i = 0

rect_init_loop:
    // -----------------
    // xpos: spread evenly
    // -----------------
    MOV R5 R1
    LSHI 6 R1        // x = i * 16
    STOR R1 R4

    // -----------------
    // ypos: ground
    // -----------------
    ADDI 1 R4
    MOVI 27 R1       // ground level (max 8-bit)
    LSHI 3 R1
    MOV R5 R2
    LSHI 2 R2
    ADD R2 R1
    STOR R1 R4

    // -----------------
    // size: 8x8
    // -----------------
    ADDI 1 R4
    MOVI 0x20 R1
    MOVI 0x60 R2
    LSHI 8 R2
    OR R2 R1
    STOR R1 R4

    // -----------------
    // color: just use i for variety
    // -----------------
    ADDI 1 R4
    MOV R5, R1
    ADDI 13 R1
    LSHI 3 R1
    ADDI 13 R1
    LSHI 2 R1
    ADDI 13 R1
    STOR R1 R4

    // -----------------
    // next rectangle
    // -----------------
    ADDI 1 R4         // next rect pointer
    ADDI 1 R5         // i++
    CMPI 16 R5
    #include "toomany.asm" 
    GOIF NE &rect_init_loop
