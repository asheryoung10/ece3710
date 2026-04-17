funcFirstGame:
    %saveRegs

    funcFirstGameLoopContinue:
        MOVI 0 R0
        //GOIF UC &funcFirstGameLoopContinue

    %restoreRegs
    %return