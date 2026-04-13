#define playerVelocityXIncrement 2
#define playerJumpIncrement 12
#define playerGravityIncrement 2

#define maxVelocityX 4
#define minVelocityX -4
#define maxVelocityY 4
#define minVelocityY -4

#define initialStackAddress 2047
#define call(functionName) READ R12 | functionName | JAL R13 R12
#define return JCOND UC R13

#define sharedPlayerDataAddress 0xC000
#define sharedRectDataAddress 0x8000

#define saveReg(registerName) SUBI 1 R14 | STOR registerName R14
#define restoreReg(registerName) LOAD registerName R14 | ADDI 1 R14

// Save and restore R0-R6 and R13
#define saveRegs SUBI 1 R14 | STOR R0 R14 | SUBI 1 R14 | STOR R1 R14 | SUBI 1 R14 | STOR R2 R14 | SUBI 1 R14 | STOR R3 R14 | SUBI 1 R14 | STOR R4 R14 | SUBI 1 R14 | STOR R5 R14 | SUBI 1 R14 | STOR R6 R14 | SUBI 1 R14 | STOR R13 R14
#define restoreRegs LOAD R13 R14 | ADDI 1 R14 | LOAD R6 R14 | ADDI 1 R14 | LOAD R5 R14 | ADDI 1 R14 | LOAD R4 R14 | ADDI 1 R14 | LOAD R3 R14 | ADDI 1 R14 | LOAD R2 R14 | ADDI 1 R14 | LOAD R1 R14 | ADDI 1 R14 | LOAD R0 R14 | ADDI 1 R14
