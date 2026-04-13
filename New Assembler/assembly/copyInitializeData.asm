// Assumes R0 has addres of data to copy, and that data is 16 words
copyPlayerInitializeData:
    %saveRegs 

    MOV R0 R1 // R1 has address of data to copy
    MOVI 0 R0 // i
    READ R2 | &varLocalPlayerDataAddress
    funcCopyPlayerInitializeData:
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMPI 16 R0 | GOIF NE &funcCopyPlayerInitializeData

    %restoreRegs 
    %return


// Assumes R0 has addres of data to copy, and that data is 16 words
copyRectInitializeData:
    %saveRegs 

    MOV R0 R1 // R1 has address of data to copy
    MOVI 0 R0 // i
    READ R2 | &varLocalRectDataAddress
    READ R4 | 256
    funcCopyRectInitializeData:
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMP R4 R0 | GOIF NE &funcCopyRectInitializeData

    %restoreRegs 
    %return