funcPushLocalDataToShared:
    %saveRegs
   
   MOVI 0 R5 | MOVI 0 R6
   READ R7 | &varActivePlayersAddress | LOAD R7 R7
   CMPI 0 R7 | GOIF EQ &funcPushLocalDataToSharedSkipFollowP1

   READ R6 | &varLocalPlayerDataAddress
   LOAD R5 R6 | ADDI 1 R6 | LOAD R6 R6 // R5: p1x, R6 p1y
   READ R7 | 298 | SUB R7 R5
   READ R7 | 218 | SUB R7 R6
   
   funcPushLocalDataToSharedSkipFollowP1:
	
    MOVI 0 R0 // i
    READ R1 | &varLocalPlayerDataAddress
    READ R2 | %sharedPlayerDataAddress
    funcPushLocalDataToSharedPlayerLoop:
        LOAD R3 R1 | SUB R5 R3 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 |  SUB R6 R3 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcPushLocalDataToSharedPlayerLoop

    MOVI 0 R0 // i
    READ R1 | &varLocalRectDataAddress
    READ R2 | %sharedRectDataAddress
    funcPushLocalDataToSharedRectLoop:
        LOAD R3 R1 | SUB R5 R3 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 | SUB R6 R3 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        LOAD R3 R1 | STOR R3 R2 // Retrieve and push data.
        ADDI 1 R1 | ADDI 1 R2 // Increment data pointers.
        ADDI 1 R0 | CMPI 64 R0 | GOIF NE &funcPushLocalDataToSharedRectLoop
    
    %restoreRegs
    %return 
