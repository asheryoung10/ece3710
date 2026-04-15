funcPushLocalDataToShared:
    %saveRegs


    MOVI 0 R0 // i = 0;
    READ R1 | &varLocalPlayerScaleDataAddress
    READ R2 | %sharedPlayerScaleDataAddress

    funcPushLocalDataToSharedPlayerScaleLoop:
        MOV R0 R3 | ADD R1 R3 | LOAD R3 R3 // R3 has scale
        MOV R0 R4 | ADD R2 R4 // R4 has address of shared player scale
        STOR R3 R4 // store data

        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcPushLocalDataToSharedPlayerScaleLoop
   
   READ R6 | &varCameraPositionAddress
   LOAD R5 R6 | ADDI 1 R6 | LOAD R6 R6 // R5: camera1x, R6 camera1y

   READ R1 | %sharedPlayerDataAddress
   ADDI 16 R1
   MOV R5 R7 | MOV R6 R8
   ARSHI -3 R7 | ARSHI -3 R8 // Shift camera position back to original scale for storage in shared data.
   MOVI 0 R0
   SUB R7 R0
   STOR R0 R1 | ADDI 1 R1
   MOVI 0 R0
   SUB R8 R0
   STOR R0 R1



   
	
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
        ADDI 1 R0 | CMPI 65 R0 | GOIF NE &funcPushLocalDataToSharedRectLoop
    
    %restoreRegs
    %return 
