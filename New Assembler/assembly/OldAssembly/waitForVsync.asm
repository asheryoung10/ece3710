funcWaitForVsync:
    MOVI 1 R0
    AND R11 R0
    CMPI 0 R0
    GOIF EQ &funcWaitForVsync
        funcWaitForVsyncLow:
            MOVI 1 R0
            AND R11 R0
            CMPI 1 R0
            GOIF EQ &funcWaitForVsyncLow
    %return()
