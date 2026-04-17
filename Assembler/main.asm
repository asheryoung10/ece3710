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
#include "updateCameraPosition.asm"
#include "updatePlayerAnimations.asm"
#include "audio.asm"
#include "updateSelection.asm"


funcMain:
    %saveRegs
    funcMainInit:
    READ R0 | &varSelectionRoomPlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varSelectionRoomRectInitializationDataAddress | %call(&copyRectInitializeData)

    funcMainLoop:
        %call(&funcUpdateButtonState)
        %call(&funcUpdateButtonStateOther)
        
        //%call(&funcToggleWorldSize)
        //%call(&funcUpdateAudio)

        %call(&funcPollAndTogglePlayerActiveState)

        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&funcPushFixedPositionToAbsolute)
        
        %call(&detectAndResolveCollisions)
        %call(&funcUpdatePlayerAnimations)

        //%call(&funcUpdateSelection)
        //CMPI 1 R0 | GOIF EQ &funcMainInit

        %call(&funcUpdateCameraPosition)
        %call(&funcPushLocalDataToShared)

        %call(&funcWaitForVsync)
        GOIF UC &funcMainLoop
    
    %restoreRegs
    %return
