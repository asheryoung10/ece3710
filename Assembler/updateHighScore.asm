funcUpdateHighScore:
    %saveRegs
    READ R0 | %playerScoresAddress | LOAD R0 R0
    READ R1 | &varHighScore | LOAD R2 R1

    CMP R0 R2 | GOIF LT &funcUpdateHighScoreDone

    MOV R0 R2

    funcUpdateHighScoreDone: 
    READ R0 | %playerScoresAddress | STOR R2 R0
    READ R0 | &varHighScore | STOR R2 R0
    %restoreRegs
    %return