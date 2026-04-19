funcResetAllRects:
    %saveRegs

    READ R0 | &varLocalRectDataAddress
    MOVI 0 R1
    MOVI 0 R2
    READ R6 | 256
    funcResetAllRectsLoops:
        STOR R2 R0
        ADDI 1 R0
        ADDI 1 R1 | CMP R6 R1 | GOIF NE &funcResetAllRectsLoops

    
    %restoreRegs
    %return