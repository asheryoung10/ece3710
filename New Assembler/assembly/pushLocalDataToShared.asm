funcPushLocalDataToShared:
    %saveRegs

    //READ R6 | &sendPlayerPositions
    //LOAD R4 R6 | ADDI 1 R6 | LOAD R6 R6 // R5: p1x, R6 p1y

    MOVI 0 R0 // i
    READ R1 | &varLocalPlayerDataAddress
    READ R2 | %sharedPlayerDataAddress
    funcPushLocalDataToSharedPlayerLoop:
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMPI 16 R0 | GOIF NE &funcPushLocalDataToSharedPlayerLoop

    MOVI 0 R0 // i
    READ R1 | &varLocalRectDataAddress
    READ R2 | %sharedRectDataAddress
    READ R4 | 256 // Rectangle data size in words
    funcPushLocalDataToSharedRectLoop:
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMP R4 R0 | GOIF NE &funcPushLocalDataToSharedRectLoop
    
    %restoreRegs
    %return 