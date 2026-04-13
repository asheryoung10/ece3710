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
        CMPI 1 R0
        GOIF EQ &funcWaitForVsyncLow

    %restoreRegs
    %return
