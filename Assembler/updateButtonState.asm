funcUpdateButtonState:
    %saveRegs

    // Loop through and update state
    MOVI 0 R0 // i = 0
    MOVI 1 R1 // input mask
    MOVI 0 R3 // pressed this frame
    MOVI 0 R4 // released this frame

    funcUpdateButtonStateLoop:
        READ R2 | &varPreviousFrameButtonState | LOAD R2 R2 // R2 = previous button state
        AND R1 R2 // R2 is 1 in input position if button previously down
        CMP R1 R2 | GOIF NE &funcUpdateButtonStateLoopPreviouslyUp

        MOV R15 R2 // R2 = current button state
        NOT R2 R2 // R2 = inverted current button state
        AND R1 R2 // R2 is 1 in the input position if button was released this frame
        OR R2 R4 // save to R3

        GOIF UC &funcUpdateButtonStateLoopContinue
        funcUpdateButtonStateLoopPreviouslyUp:

        MOV R15 R2 // R2 = current button state
        AND R1 R2 // R2 is 1 in the input position if button was pressed this frame
        OR R2 R3 // save to R3

        funcUpdateButtonStateLoopContinue:
        LSHI 1 R1 // move mask
        ADDI 1 R0 | CMPI 16 R0 | GOIF NE &funcUpdateButtonStateLoop

    READ R0 | &varPreviousFrameButtonState | STOR R15 R0 // Updated previous button state to be current state
    READ R0 | &varCurrentFrameButtonsPressed | STOR R3 R0 // Updated previous button state to be current state
    READ R0 | &varCurrentFrameButtonsReleased | STOR R4 R0 // Updated previous button state to be current state
    %restoreRegs
    %return


funcUpdateButtonStateOther:
    %saveRegs

    // Loop through and update state
    MOVI 0 R0 // i = 0
    MOVI 1 R1 // input mask
    MOVI 0 R3 // pressed this frame
    MOVI 0 R4 // released this frame

    funcUpdateButtonStateLoopOther:
        READ R2 | &varPreviousFrameButtonStateOther | LOAD R2 R2 // R2 = previous button state
        AND R1 R2 // R2 is 1 in input position if button previously down
        CMP R1 R2 | GOIF NE &funcUpdateButtonStateLoopPreviouslyUpOther

        MOV R11 R2 // R2 = current button state
        NOT R2 R2 // R2 = inverted current button state
        AND R1 R2 // R2 is 1 in the input position if button was released this frame
        OR R2 R4 // save to R3

        GOIF UC &funcUpdateButtonStateLoopContinueOther
        funcUpdateButtonStateLoopPreviouslyUpOther:

        MOV R11 R2 // R2 = current button state
        AND R1 R2 // R2 is 1 in the input position if button was pressed this frame
        OR R2 R3 // save to R3

        funcUpdateButtonStateLoopContinueOther:
        LSHI 1 R1 // move mask
        ADDI 1 R0 | CMPI 16 R0 | GOIF NE &funcUpdateButtonStateLoopOther

    READ R0 | &varPreviousFrameButtonStateOther | STOR R11 R0 // Updated previous button state to be current state
    READ R0 | &varCurrentFrameButtonsPressedOther | STOR R3 R0 // Updated previous button state to be current state
    READ R0 | &varCurrentFrameButtonsReleasedOther | STOR R4 R0 // Updated previous button state to be current state

    %restoreRegs
    %return