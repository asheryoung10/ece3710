#include "secondGameHideInactivePlayers.asm"
#include "secondGameDetectCollision.asm"
#include "secondGameGenerate.asm"
#include "secondGameKeepPlayersInBounds.asm"
#include "secondGameCheckFall.asm"
#include "updateRectColors.asm"
#include "secondGameApplyUserInput.asm"

funcSecondGame:
    %saveRegs

    READ R0 | &varSecondGamePlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varSecondGameRectInitializationDataAddress | %call(&copyRectInitializeData)
    READ R0 | &varCurrentScore | MOVI 0 R1 | STOR R1 R0 // reset score

    %call(&funcSecondGameGenerate)
    funcSecondGameLoopContinue:

        %call(&funcSecondGameHideInactivePlayers)
        %call(&funcUpdateButtonState)
        %call(&funcUpdateButtonStateOther)
        
        %call(&funcToggleWorldSize)
        %call(&funcUpdateAudio)

        %call(&funcSecondGameApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&funcPushFixedPositionToAbsolute)
        
        %call(&funcSecondGameDetectAndResolveCollisions)
        %call(&funcUpdatePlayerAnimations)

        READ R0 | &varCurrentFrameButtonsPressedOther | LOAD R0 R0
        MOVI 4 R1 | AND R1 R0
        CMPI 4 R0 | GOIF EQ &funcSecondGameReturn

        %call(&funcUpdateRectColors)
        %call(&funcSecondGameKeepPlayersInBounds)
        %call(&funcSecondGameRespawnRects)

        %call(&funcSecondGameCheckFall)
        CMPI 1 R7 | GOIF EQ &funcSecondGameReturn


        %call(&funcUpdateCameraPosition)
        %call(&funcUpdateSharedScore)
        %call(&funcPushLocalDataToShared)

        %call(&funcWaitForVsync)
        GOIF UC &funcSecondGameLoopContinue

    funcSecondGameReturn:
    %restoreRegs
    %return