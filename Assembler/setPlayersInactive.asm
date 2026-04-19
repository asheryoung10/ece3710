
funcSetPlayersInactive:
    %saveRegs


    READ R0 | &varActivePlayersAddress
    MOVI 0 R1
    MOVI 0 R2
    funcSetPlayersInactiveLoop:
        STOR R2 R0
        ADDI 1 R1 | ADDI 1 R0
        CMPI 4 R1 | GOIF NE &funcSetPlayersInactiveLoop


    %restoreRegs
    %return