#define HI(a,b) READ a | b
%HI(r15,0xFFFF)
READ R14
1023    // Stack starts at 1023
READ R12
&main    // Load address of main into R0    
JAL R13 R12 // Jump to main
WAIT

#include "initRects.asm"
// Store player velocityx and velocity at addresses 1024 and 1025
#include "applyInputGravityVelocity.asm"
#include "clampPlayerInBounds.asm"
#include "colorCollision.asm"
#include "lowerPlatforms.asm"

main:
    SUBI 1 R14   // Make room for one on the stack
    STOR R13 R14 // Store return address on stack

    READ R0
    12345
    READ R1
    1026
    STOR R0 R1 // seed rng

    READ R0
    0xC006 // player one background index
    MOVI 0 R1
    STOR R1 R0 // Store 0 into background index

    mainInit:
    READ R12
    &initRects
    JAL R13 R12

    READ R12
    &movePlayerToCenter
    JAL R13 R12
    

    mainGameLoop:

        READ R12
        &applyInputGravityVelocity
        JAL R13 R12

        READ R12
        &clampPlayerInBounds
        JAL R13 R12

        READ R12 
        &colorCollision
        JAL R13 R12
        
        READ R12 
        &lowerPlatforms
        JAL R13 R12
	
        READ R12
        &waitVsync
        JAL R13 R12

        READ R0
        0xC002 //y address
        LOAD R0 R0 //R0 has y pos
        READ R1
        400
        CMP R1 R0 // if player fell 
        GOIF LT &mainInit

        GOIF UC &mainGameLoop
 
    LOAD R13 R14 // Restore return address
    ADDI 1 R14  // Restore stack
    JCOND UC R13 // return

// Waits for VGA vertical refresh
// to transition from high to low.
// Modifies: R0
waitVsync:
    MOVI 1 R0
    AND R15 R0
    CMPI 0 R0
    GOIF EQ &waitVsync
    waitVsyncWaitLow:
        MOVI 1 R0
        AND R15 R0
        CMPI 1 R0
        GOIF EQ &waitVsyncWaitLow
    ADDI 1 R10
    JCOND UC R13


movePlayerToCenter:
    READ R0
    0xC000
    READ R1
    288
    STOR R1 R0
    ADDI 2 R0
    READ R1
    208
    STOR R1 R0
    JCOND UC R13


