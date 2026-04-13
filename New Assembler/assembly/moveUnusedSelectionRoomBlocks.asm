funcMoveUnusedSelectionRoomBlocks:
    %saveRegs

    MOVI 0 R0
    READ R1 | &varLocalRectDataAddress
    ADDI 17 R1 // Rect 4's Y position; rects 4-7 are the climb platforms.

    funcMoveUnusedSelectionRoomBlocksLoop:
        LOAD R2 R1
        SUBI 1 R2

        READ R3 | -32
        CMP R3 R2 | GOIF GT &funcMoveUnusedSelectionRoomBlocksReset
        GOIF UC &funcMoveUnusedSelectionRoomBlocksStore

        funcMoveUnusedSelectionRoomBlocksReset:
        READ R2 | 448

        funcMoveUnusedSelectionRoomBlocksStore:
        STOR R2 R1

        ADDI 4 R1
        ADDI 1 R0 | CMPI 4 R0 | GOIF NE &funcMoveUnusedSelectionRoomBlocksLoop

    %restoreRegs
    %return
