#include "defines.asm"
READ R14                    //
%constGreatestCPUAddress()  // Initialize stack pointer
READ R12      //
&mainFunction //
JAL R13 R12   // Call main function
WAIT // Execution finished


mainFunction:

    mainFunctionLoop:


        GOIF UC &mainFunctionLoop 
    JCOND UC R13
