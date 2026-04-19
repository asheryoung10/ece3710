funcSecondGameCheckFall:
    %saveRegs

    READ R0 | &varLocalPlayerDataAddress
    ADDI 1 R0 // ypos
    READ R1 | &varActivePlayersAddress
    MOVI 0 R3 // player index
    MOVI 1 R7 // R7 is 1 if all players are inactive
    funcSecondGameCheckFallLoop:
        LOAD R6 R1 | CMPI 0 R6 | GOIF EQ &funcSecondGameCheckFallLoopContinue // skip inactive
        MOVI 0 R7 // a player is active
        LOAD R5 R0 // R5 has y pos

        READ R12 | %fallCutoff
        CMP R12 R5 | GOIF GT &funcSecondGameCheckFallLoopContinue
        MOVI 0 R12 | STOR R12 R1 // set player as inactive



        funcSecondGameCheckFallLoopContinue:
        ADDI 4 R0 | ADDI 1 R1
        ADDI 1 R3 | CMPI 4 R3 | GOIF NE &funcSecondGameCheckFallLoop

    %restoreRegs
    %return