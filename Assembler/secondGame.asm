#include "secondGameHideInactivePlayers.asm"
#include "secondGameDetectCollision.asm"

funcSecondGame:
    %saveRegs

    READ R0 | &varSecondGamePlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varSecondGameRectInitializationDataAddress | %call(&copyRectInitializeData)

    funcSecondGameLoopContinue:

        %call(&funcSecondGameHideInactivePlayers)
        %call(&funcUpdateButtonState)
        %call(&funcUpdateButtonStateOther)
        
        %call(&funcToggleWorldSize)
        %call(&funcUpdateAudio)

        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&funcPushFixedPositionToAbsolute)
        
        %call(&funcSecondGameDetectAndResolveCollisions)
        %call(&funcUpdatePlayerAnimations)

        %call(&funcUpdateCameraPosition)
        %call(&funcPushLocalDataToShared)

        %call(&funcWaitForVsync)
        GOIF UC &funcSecondGameLoopContinue

    %restoreRegs
    WAIT
    %return