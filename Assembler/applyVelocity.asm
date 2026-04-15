funcApplyVelocity:
    %saveRegs

    MOVI 0 R0 // i = 0
    READ R1 | &varPlayerVelocityDataAddress
    READ R2 | &varPlayerFixedPointPositions
    funcApplyVelocityPlayerLoop:

        // Update x pos
        LOAD R3 R1 // R3 has player x vel
        //ARSHI -2 R3
        LOAD R4 R2 // R4 has player x pos
        ADD R3 R4 // R4 has player x pos + vel
        STOR R4 R2 // Store xpos + vel

        ADDI 1 R1 | ADDI 1 R2 // Step to y addresses

        // Update y pos
        LOAD R3 R1 // R3 has player x vel
        //ARSHI -2 R3
        LOAD R4 R2 // R4 has player x pos
        ADD R3 R4 // R4 has player x pos + vel
        STOR R4 R2 // Store xpos + vel

        ADDI 1 R2 // step to next player x
        ADDI 1 R1 // step to next player vel x


        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcApplyVelocityPlayerLoop


    %restoreRegs
    %return


funcPushFixedPositionToAbsolute:
    %saveRegs
    READ R0 | &varPlayerFixedPointPositions
    READ R1 | &varLocalPlayerDataAddress
    MOVI 0 R2 // Player index
    
    funcPushFixedPositionToAbsolutePlayerLoop:
        LOAD R4 R0 // R4 has player fixed pos
        ARSHI %playerFractionalShiftDown R4 // Shift away fractional part
        STOR R4 R1 // Write back to local
        
        ADDI 1 R0 | ADDI 1 R1

        LOAD R4 R0 // R4 has player fixed pos
        ARSHI %playerFractionalShiftDown R4 // Shift away fractional part
        STOR R4 R1 // Write back to local


        ADDI 1 R0 // Step to next fixed position
        ADDI 3 R1 // Step to next local position
        ADDI 1 R2 | CMPI 4 R2 | GOIF NE &funcPushFixedPositionToAbsolutePlayerLoop



    %restoreRegs
    %return