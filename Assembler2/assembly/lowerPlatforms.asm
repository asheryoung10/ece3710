

lowerPlatforms:
	SUBI 1 R14 //make room on stack
	STOR R13 R14 // store return address
	READ R0 //  Put address of player y into r0
	0xC002
	LOAD R0 R0 // load player y into r0

	MOVI 120 R1

	CMP R1 R0 // R1 ? R0
	GOIF GT &lowerPlatformsYes
	GOIF UC &lowerPlatformsNo


	lowerPlatformsYes:
	MOVI 1 R9
	MOV R0 R2
	SUB R2 R1 // r2 = 60 - playerPos
	// MOve player back where they go
	ADD R1 R2 //player pos back to 60
	READ R3 //r3 has player address
	0xC002
	STOR R2 R3 //update player postion
	MOV R1 R0 //r0 is how much to move the platforms by

	READ R12
	&offsetAllPlatforms //Lower platforms by R0
	JAL R13 R12

	GOIF UC &lowerPlatformSkip


	lowerPlatformsNo:
	MOVI 2 R9
	lowerPlatformSkip:
	LOAD R13 R14
	ADDI 1 R14
	JCOND UC R13


#include "nextRand.asm"
// R0 is the offset
offsetAllPlatforms:
    SUBI 1 R14 //make room on stack
    STOR R13 R14 //store return aaddress
    READ R1
    0xC006
    LOAD R1 R1
    ADD R0 R1 //add offset to background
    READ R2
    0xc006
    STOR R1 R2 // store new background

    MOVI 0 R1 // R1 holds our index
    READ R2
    0x8001 // R2 holds address of ypos

    offsetAllPlatformsLoop:

	LOAD R4 R2 //r4 holds position of platform
	ADD R0 R4 //add offset
	READ R5
	480
	CMP R5 R4
	GOIF GT &offsetAllPlatformsSkipMoveUp

	SUBI 1 R14
	STOR R0 R14
	SUBI 1 R14
	STOR R1 R14
	SUBI 1 R14
	STOR R2 R14

	READ R12
	&nextRand //generate random in r0
	JAL R13 R12
	LSHI -8 R0
	MOV R0 R4

	LOAD R2 R14
	ADDI 1 R14
	LOAD R1 R14
	ADDI 1 R14
	LOAD R0 R14
	ADDI 1 R14

	offsetAllPlatformsSkipMoveUp:
	STOR R4 R2

    ADDI 1 R1 // increment i
    ADDI 4 R2 // skip to next color address
    CMPI 16 R1
    GOIF NE &offsetAllPlatformsLoop

    LOAD R13 R14 // restore return address from stack
    ADDI 1 R14 // restore stack value

    JCOND UC R13

	

