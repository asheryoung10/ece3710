
READ R14    // R14 is the stack pointer
%greatestCPUAddress  // Initialize stack pointer
%call(&funcMain)    // Go to main
WAIT // Execution finished

funcMain:
    %save(R1l) // Save return address
    
    %call(&funcInitMainMenu)
    
    funcMainLoop:
        %call(&funcWaitForVsync)
        GOIF UC &funcMainLoop

    %restore(R11) // Restore return address
    %return()

#include "defines.asm"
#include "waitForVsync.asm"
#include "initMainMenu.asm"