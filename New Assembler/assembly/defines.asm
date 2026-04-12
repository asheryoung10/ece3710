#define playerWidth 45
#define playerHeight 45

#define greatestCPUAddress 4000

#define playerSharedDataAddress 0xC000
#define rectSharedDataAddress 0x8000

#define call(functionName) READ R12 | functionName | JAL R13 R12
#define return() JCOND UC R13

#define save(registerName) SUBI 1 R14 | STOR registerName R14
#define restore(registerName) LOAD registerName R14 | ADDI 1 R14

#define setRectXPos(index, value) MOVI index R12 | LSHI 2 R12 | READ R10 | &varRectLocalData | ADD R10 R12 | READ R10 | value | STOR R10 R12
#define setRectYPos(index, value) MOVI index R12 | LSHI 2 R12 | ADDI 1 R12 | READ R10 | &varRectLocalData | ADD R10 R12 | READ R10 | value | STOR R10 R12
#define setRectWidth(index, value) MOVI index R12 | LSHI 2 R12 | ADDI 2 R12 | READ R10 | &varRectLocalData | ADD R10 R12 | SUBI 1 R14 | STOR R12 R14 | LOAD R10 R12 | LSHI 8 R10 | LSHI -8 R10 | READ R12 | value | LSHI 8 R12 | ADD R12 R10 | LOAD R12 R14 | ADDI 1 R14 | STOR R10 R12
#define setRectHeight(index, value) MOVI index R12 | LSHI 2 R12 | ADDI 2 R12 | READ R10 | &varRectLocalData | ADD R10 R12 | SUBI 1 R14 | STOR R12 R14 | LOAD R10 R12 | LSHI -8 R10 | LSHI 8 R10 | READ R12 | value | ADD R12 R10 | LOAD R12 R14 | ADDI 1 R14 | STOR R10 R12
#define setRectColor(index, value) MOVI index R12 | LSHI 2 R12 | ADDI 3 R12 | READ R10 | &varRectLocalData | ADD R10 R12 | READ R10 | value | STOR R10 R12
#define backgroundY 0xC011
#define backgroundX 0xC010

#define callSave   SUBI 1 R14 | STOR R0 R14 | SUBI 1 R14 | STOR R1 R14 | SUBI 1 R14 | STOR R2 R14 | SUBI 1 R14 | STOR R3 R14 | SUBI 1 R14 | STOR R4 R14 | SUBI 1 R14 | STOR R5 R14 | SUBI 1 R14 | STOR R6 R14
#define callRestore LOAD R6 R14 | ADDI 1 R14 | LOAD R5 R14 | ADDI 1 R14 | LOAD R4 R14 | ADDI 1 R14 | LOAD R3 R14 | ADDI 1 R14 | LOAD R2 R14 | ADDI 1 R14 | LOAD R1 R14 | ADDI 1 R14 | LOAD R0 R14 | ADDI 1 R14

#define maxVelocityX 30
#define minVelocityX -30
#define maxVelocityY 30
#define minVelocityY -30
#define playerHorizontalIncrement 1
#define playerGravityIncrement 1
