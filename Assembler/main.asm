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
#include "setAllRectangles.asm"
#include "updateHighScore.asm"
#include "resetAllRects.asm"
#include "setPLayersInactive.asm"
#include "wait3Seconds.asm"



funcMain:
    %saveRegs
    funcMainInit:
    %call(&funcWait3Seconds)
    %call(&funcSetPlayersInactive)
    %call(&funcResetAllRects)
    READ R0 | &varSelectionRoomPlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varSelectionRoomRectInitializationDataAddress | %call(&copyRectInitializeData)

    //%call(&funcSetAllRectangles)
    funcMainLoop:
        %call(&funcUpdateButtonState)
        %call(&funcUpdateButtonStateOther)
        
        %call(&funcToggleWorldSize)
        %call(&funcUpdateAudio)

        %call(&funcPollAndTogglePlayerActiveState)

        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&funcPushFixedPositionToAbsolute)
        
        %call(&funcUpdatePlayerAnimations)
        %call(&detectAndResolveCollisions)

        %call(&funcUpdateSelection)
        %call(&funcUpdateHighScore)
        CMPI 1 R0 | GOIF EQ &funcMainInit

        %call(&funcUpdateCameraPosition)
        %call(&funcPushLocalDataToShared)

        %call(&funcWaitForVsync)
        GOIF UC &funcMainLoop
    
    %restoreRegs
    %return
