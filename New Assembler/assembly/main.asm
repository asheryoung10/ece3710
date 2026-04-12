
READ R14    // R14 is the stack pointer
%greatestCPUAddress  // Initialize stack pointer
%call(&funcMain)    // Go to main
WAIT // Execution finished

funcMain:
    %save(R1l) // Save return address
    
    funcMainLoop:
        %call(&funcJoinLeavePlayers) 
        %call(&funcSendPlayerPositions)
        READ R12 | &varPreviousButtonStateAddress | STOR R15 R12 // Save previous button state
        %call(&funcWaitForVsync)
        GOIF UC &funcMainLoop

    %restore(R11) // Restore return address
    %return()

#include "defines.asm"
#include "globalVariables.asm"
#include "waitForVsync.asm"
#include "sendPlayerPositions.asm"