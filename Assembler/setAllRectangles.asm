funcSetAllRectangles:
    %saveRegs

    MOVI 0 R0
    READ R1 | &varLocalRectDataAddress
    READ R6 | 0x0FF0
    READ R7 | 0x5151
    MOVI 0 R2 // x
    MOVI 0 R3 // y

    funcSetAllRectanglesLoop:

        STOR R2 R1 | ADDI 1 R1 // x
        STOR R3 R1 | ADDI 1 R1 // y
        STOR R7 R1 | ADDI 1 R1 // widthHieght
        STOR R6 R1 | ADDI 1 R1 // color

        ADDI 15 R2 
        ADDI 15 R3
    
        ADDI 1 R0 | CMPI 64 R0 | GOIF NE &funcSetAllRectanglesLoop

    %restoreRegs
    %return