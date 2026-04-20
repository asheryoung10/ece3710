funcClearAudio:
    %saveRegs
    MOVI 0 R1
    READ R0 | %sharedAudioAddress
    STOR R1 R0
    %restoreRegs
    %return

funcUpdateAudio:
    %saveRegs
    MOVI 0 R5

    READ R0 | &varAudioValue | LOAD R0 R0
    CMPI 0 R0 | GOIF EQ &funcUpdateAudioLeave

    MOVI 1 R5
    SUBI 1 R0
    READ R1 | &varAudioValue | STOR R0 R1


    funcUpdateAudioLeave:
    READ R1 | %sharedAudioAddress
    STOR R5 R1
    %restoreRegs
    %return
