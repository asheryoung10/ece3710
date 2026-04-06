

lowerPlatforms:
	READ R0 //  Put address of player y into r0
	0xC002
	LOAD R0 R0 // load player y into r0

	MOVI 60 R1

	CMP R1 R0 // R1 ? R0
	GOIF GT &lowerPlatformsYes
	GOIF UC &lowerPlatformsNo


	lowerPlatformsYes:
	MOVI 1 R9
	MOV R0 R2
	SUB R1 R2 // r2 = 60 - playerPos
	// MOve player back where they go
	ADD R0 R2 //player pos back to 60
	READ R3 //r3 has player address
	0xC002
	STOR R2 R3 //update player postion
	GOIF UC &lowerPlatformSkip


	lowerPlatformsNo:
	MOVI 2 R9
	lowerPlatformSkip:
	JCOND UC R13


// R0 is the offset
offsetAllPlatforms:
	

