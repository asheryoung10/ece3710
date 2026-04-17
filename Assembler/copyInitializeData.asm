// Assumes R0 has addres of data to copy, and that data is 16 words
copyPlayerInitializeData:
    %saveRegs 

    READ R2 | &varPlayerVelocityDataAddress
    MOVI 0 R1
    MOVI 0 R3

    copyPlayerInitializeDataResetLoop:
        STOR R3 R2 
        ADDI 1 R2
        ADDI 1 R1 | CMPI 8 R1 | GOIF NE &copyPlayerInitializeDataResetLoop

    MOV R0 R1 // R1 has address of data to copy
    MOVI 0 R0 // i
    READ R2 | &varLocalPlayerDataAddress
    READ R4 | &varPlayerFixedPointPositions

    funcCopyPlayerInitializeData:
    
        LOAD R3 R1 | LSHI %playerFractionalShiftUp R3 | STOR R3 R4 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 | ADDI 1 R4 // Increment data pointers.

        LOAD R3 R1 | LSHI %playerFractionalShiftUp R3 | STOR R3 R4 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 | ADDI 1 R4 // Increment data pointers.

        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.

        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.

        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcCopyPlayerInitializeData

    %restoreRegs 
    %return


// Assumes R0 has addres of data to copy, and that data is 16 words
copyRectInitializeData:
    %saveRegs 

    MOV R0 R1 // R1 has address of data to copy
    MOVI 0 R0 // i
    READ R2 | &varLocalRectDataAddress
    READ R4 | 64
    funcCopyRectInitializeData:
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMP R4 R0 | GOIF NE &funcCopyRectInitializeData

    %restoreRegs 
    %return