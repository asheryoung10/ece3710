funcWaitForVsync:
    %saveRegs
    
    funcWaitForVsyncHigh:
        MOVI 1 R0
        AND R11 R0
        CMPI 0 R0
        GOIF EQ &funcWaitForVsyncHigh
    funcWaitForVsyncLow:
        MOVI 1 R0
        AND R11 R0
        MOVI 1 R2
        AND R2 R0
        CMPI 1 R0
        GOIF EQ &funcWaitForVsyncLow

    // Increment frame counter
    READ R0 | &varFrameCount | LOAD R1 R0
    ADDI 1 R1 | STOR R1 R0

    %restoreRegs
    %return
