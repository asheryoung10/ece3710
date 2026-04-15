#define playerVelocityXIncrement 1
#define playerJumpIncrement 50
#define playerGravityIncrement 1

#define playerFractionalShiftDown -3
#define playerFractionalShiftUp 3

#define playerWidth 16
#define playerHeight 16

#define maxVelocityX 25
#define minVelocityX -25
#define maxVelocityY 20
#define minVelocityY -50

#define initialStackAddress 4095
#define call(functionName) READ R12 | functionName | JAL R13 R12
#define return JCOND UC R13

#define sharedPlayerDataAddress 0xC000
#define sharedPlayerScaleDataAddress 0xC013
#define sharedRectDataAddress 0x8000

#define saveReg(registerName) SUBI 1 R14 | STOR registerName R14
#define restoreReg(registerName) LOAD registerName R14 | ADDI 1 R14

// Save and restore R0-R6 and R13
#define saveRegs SUBI 1 R14 | STOR R0 R14 | SUBI 1 R14 | STOR R1 R14 | SUBI 1 R14 | STOR R2 R14 | SUBI 1 R14 | STOR R3 R14 | SUBI 1 R14 | STOR R4 R14 | SUBI 1 R14 | STOR R5 R14 | SUBI 1 R14 | STOR R6 R14 | SUBI 1 R14 | STOR R13 R14
#define restoreRegs LOAD R13 R14 | ADDI 1 R14 | LOAD R6 R14 | ADDI 1 R14 | LOAD R5 R14 | ADDI 1 R14 | LOAD R4 R14 | ADDI 1 R14 | LOAD R3 R14 | ADDI 1 R14 | LOAD R2 R14 | ADDI 1 R14 | LOAD R1 R14 | ADDI 1 R14 | LOAD R0 R14 | ADDI 1 R14
