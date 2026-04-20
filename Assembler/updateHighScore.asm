funcUpdateHighScore:
    %saveRegs
    READ R0 | &varCurrentScore | LOAD R0 R0
    READ R1 | &varHighScore | LOAD R2 R1

    CMP R0 R2 | GOIF LT &funcUpdateHighScoreDone

    MOV R0 R2

    funcUpdateHighScoreDone: 
    READ R0 | &varCurrentScore | STOR R2 R0
    READ R0 | &varHighScore | STOR R2 R0
    %restoreRegs
    %return

funcUpdateSharedScore:
    %saveRegs
    READ R12 | &varCurrentScore | LOAD R12 R12
    LSHI -5 R12
    READ R10 | %playerScoresAddress
    STOR R12 R10
    %restoreRegs
    %return

funcUpdateSharedScoreHigh:
    %saveRegs
    READ R12 | &varHighScore | LOAD R12 R12
    LSHI -5 R12
    READ R10 | %playerScoresAddress
    STOR R12 R10
    %restoreRegs
    %return

