#include "smashCollisions.asm"
funcFirstGame:
    %saveRegs

    READ R0 | &varFirstGamePlayerInitializationDataAddress | %call(&copyPlayerInitializeData)
    READ R0 | &varFirstGameRectInitializationDataAddress | %call(&copyRectInitializeDataBig)
    %call(&funcSecondGameHideInactivePlayers)

    funcFirstGameLoopContinue:
        %call(&funcUpdateButtonState)
        %call(&funcUpdateButtonStateOther)

        %call(&funcApplyUserInput)
        %call(&funcApplyVelocity)
        %call(&funcPushFixedPositionToAbsolute) // needed for colision code, sets local

        %call(&smashDetectAndResolveCollisions)
        %call(&funcDetectPlayerHitCollisions)

        %call(&funcFirstGameCheckBlastZones)
        CMPI 1 R7 | GOIF EQ &funcFirstGameReturn

        %call(&funcUpdatePlayerAnimations)
        %call(&funcUpdateCameraPosition)
        %call(&funcPushLocalDataToShared)

        %call(&funcWaitForVsync)
        GOIF UC &funcFirstGameLoopContinue

    funcFirstGameReturn:

    %restoreRegs
    %return


varFirstGamePlayerInitializationDataAddress:
    0x00FA // p1 x = 0
    0x00DC // p1 y = 0
    0x0000 // p1 animation index
    0xF800 // p1
    0x010E // p2 x = 270
    0x00DC // p2 y = 220
    0x0000 // p2 animation index
    0x001F // p2
    0x0145 // p3 x = 325
    0x00DC // p3 y = 220
    0x0000 // p3 animation index
    0x07E0 // p3
    0x017C // p4 x = 380
    0x00DC // p4 y = 220
    0x0000 // p4 animation index
    0xFBE0 // p4

varFirstGameRectInitializationDataAddress:

0    // rect 1 left half x
448  // y
0x5020 // wh (split width)
0xF800 // col (red)

80   // rect 1 right half x
448  // y
0x5020 // wh
0xF800 // col (red)

160  // rect 2 left half x
448  // y
0x5020 // wh
0x001F // col (blue)

240  // rect 2 right half x
448  // y
0x5020 // wh
0x001F // col (blue)

320  // rect 3 left half x
448  // y
0x5020 // wh
0x07E0 // col (green)

400  // rect 3 right half x
448  // y
0x5020 // wh
0x07E0 // col (green)

480  // rect 4 left half x
448  // y
0x5020 // wh
0xFBE0 // col (yellow)

560  // rect 4 right half x
448  // y
0x5020 // wh
0xFBE0 // col (yellow)

100  // rect 4 right half x
320  // y
0x5010 // wh
0xFFFF // col (white)

200  // rect 4 right half x
200  // y
0x5010 // wh
0xFFFF // col (white)


460  // rect 4 right half x
320  // y
0x5010 // wh
0xFFFF // col (white)

360  // rect 4 right half x
200  // y
0x5010 // wh
0xFFFF // col (white)

// NEW RECTS
-10  // rect 4 right half x
0  // y
0x0aFF // wh
0x01 // col (white)

640  // rect 4 right half x
0  // y
0x0aFF // wh
0x01 // col (white)


// NEW RECTS
-10  // rect 4 right half x
255  // y
0x0aDF // wh
0x01 // col (white)

640  // rect 4 right half x
255 // y
0x0aDF // wh
0x01 // col (white)

// NEW RECTS
0  // rect 4 right half x
-10  // y
0xFF0a // wh
0x01 // col (white)

// NEW RECTS
385  // rect 4 right half x
-10  // y
0xFF0a // wh
0x01 // col (white)