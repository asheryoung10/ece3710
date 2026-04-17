
funcSecondGameHideInactivePlayers:
    %saveRegs

    READ R0 | &varActivePlayersAddress
    READ R1 | &varPlayerFixedPointPositions
    MOVI 0 R3
    READ R6 | 0x7FFF

    funcGameHideInactivePlayersLoop:
        LOAD R4 R0 
        CMPI 0 R4 | GOIF NE &funcGameHideInactivePlayersLoopContinue
        STOR R6 R1
        
        funcGameHideInactivePlayersLoopContinue:
        ADDI 1 R0 | ADDI 2 R1
        ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcGameHideInactivePlayersLoop



    %restoreRegs
    %return
