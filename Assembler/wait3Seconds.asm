funcWait3Seconds:
    %saveRegs
    MOVI 0 R0
    funcWait3SecondsLoop:
        %call(&funcWaitForVsync)
        ADDI 1 R0
        CMPI 16 R0 | GOIF NE &funcWait3SecondsLoop

    %restoreRegs
    %return