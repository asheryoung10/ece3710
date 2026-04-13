funcClampPlayersInBounds:
    %saveRegs

    MOVI 0 R0
    READ R1 | &varLocalPlayerDataAddress
    READ R2 | &varPlayerVelocityDataAddress

    funcClampPlayersInBoundsLoop:
        // Clamp X to the visible screen range for a 45px-wide sprite.
        LOAD R3 R1
        CMPI 0 R3 | GOIF GT &funcClampPlayersInBoundsSetXMin
        READ R4 | 595
        CMP R4 R3 | GOIF LT &funcClampPlayersInBoundsSetXMax
        GOIF UC &funcClampPlayersInBoundsCheckY

        funcClampPlayersInBoundsSetXMin:
        MOVI 0 R3
        MOVI 0 R5
        STOR R5 R2
        GOIF UC &funcClampPlayersInBoundsStoreX

        funcClampPlayersInBoundsSetXMax:
        READ R4 | 595
        MOV R4 R3
        MOVI 0 R5
        STOR R5 R2

        funcClampPlayersInBoundsStoreX:
        STOR R3 R1

        funcClampPlayersInBoundsCheckY:
        ADDI 1 R1
        ADDI 1 R2
        LOAD R3 R1
        READ R4 | 439
        CMP R4 R3 | GOIF LT &funcClampPlayersInBoundsSetYMax
        GOIF UC &funcClampPlayersInBoundsNextPlayer

        funcClampPlayersInBoundsSetYMax:
        READ R4 | 439
        MOV R4 R3
        MOVI 0 R5
        STOR R5 R2

        funcClampPlayersInBoundsStoreY:
        STOR R3 R1

        funcClampPlayersInBoundsNextPlayer:
        ADDI 3 R1
        ADDI 1 R2
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcClampPlayersInBoundsLoop

    %restoreRegs
    %return
