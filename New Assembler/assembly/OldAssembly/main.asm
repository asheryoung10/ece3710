MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
MOV R0 R0
READ R14    // R14 is the stack pointer
%greatestCPUAddress  // Initialize stack pointer
%call(&funcMain)    // Go to main
WAIT // Execution finished

funcMain:
    %save(R13) // Save return address

    READ R0 | &varSelectionRoomPlayerCopyDataAddress | %call(&funcCopyPlayerData) 
    READ R0 | &varSelectionRoomInitRectangleCopy8DataAddress | %call(&funcCopyRectData)
    funcMainLoop:
        %call(&funcJoinLeavePlayers) 
        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)

        %call(&funcDetectAndResolveCollisions)

        %call(&funcPushLocalToShared)
        %call(&funcWaitForVsync)
        %call(&funcUpdateButtonState)
        READ R12 | &varPreviousButtonStateAddress | STOR R15 R12 // Save previous button state
        GOIF UC &funcMainLoop

    %restore(R13) // Restore return address
    %return()

#include "defines.asm"
#include "globalVariables.asm"
#include "waitForVsync.asm"
#include "sendPlayerPositions.asm"
#include "detectCollision.asm"

funcUpdateButtonState:
    READ R0 | &varPreviousButtonStateAddress
    MOVI 0 R1 // pressed
    MOVI 0 R4 // released
       MOVI 0 R2 // i = 0
    MOVI 1 R3 // mask
    funcUpdateButtonStateLoop:
        MOV R3 R6 // R6 has mask
        AND R15 R6 // if currenly down
        LOAD R7 R0
        NOT R7 R7
        AND R7 R6 // and not previsouly down
        OR R6 R1 // then set pressed
        NOT R7 R7 // R7 if previously down
        MOV R3 R6 // R6 has mask
        AND R15 R6 // 
        NOT R6 R6  // Not currenlty down
        AND R7 R6 // Previously down but not currently
        OR R6 R4
          ADDI 1 R2 | LSHI 1 R3 // increment all pointers
        CMPI 16 R2 | GOIF NE &funcUpdateButtonStateLoop // while i!=16
    READ R12 | &varButtonPressedThisFrameAddress   | STOR R1 R12
    READ R12 | &varButtonReleasedThisFrameAddress | STOR R4 R12

    %return
