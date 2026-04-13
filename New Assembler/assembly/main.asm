MOV R0 R0 | MOV R0 R0 | MOV R0 R0 | MOV R0 R0   // Dummy instructions so FPGA can settle after flashing
READ R14 | %initialStackAddress
%call(&funcMain)
WAIT

#include "macros.asm"
#include "variables.asm"
#include "pushLocalDataToShared.asm"
#include "copyInitializeData.asm"
#include "updateButtonState.asm"
#include "pollAndTogglePlayerActiveState.asm"
#include "applyUserInput.asm"
#include "applyVelocity.asm"
#include "waitForVsync.asm"
#include "detectCollision.asm"


funcMain:
    %saveRegs

    READ R0 | &varSelectionRoomPlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varSelectionRoomRectInitializationDataAddress | %call(&copyRectInitializeData)

    funcMainLoop:
        %call(&funcUpdateButtonState)

        %call(&funcPollAndTogglePlayerActiveState)
        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&detectAndResolveCollisions)

        %call(&funcPushLocalDataToShared)
        %call(&funcWaitForVsync)
        GOIF UC &funcMainLoop
    
    %restoreRegs
    %return
