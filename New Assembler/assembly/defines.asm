#define player1XAddress 0xC000
#define player1YAddress 0xC001
#define player1AnimationIndexAddress 0xC002
#define player1HighlightColorAddress 0xC003

#define player2XAddress 0xC004
#define player2YAddress 0xC005
#define player2AnimationIndexAddress 0xC006
#define player2HighlightColorAddress 0xC007

#define player3XAddress 0xC008
#define player3YAddress 0xC009
#define player3AnimationIndexAddress 0xC00A
#define player3HighlightColorAddress 0xC00B

#define player4XAddress 0xC00C
#define player4YAddress 0xC00D
#define player4AnimationIndexAddress 0xC00E
#define player4HighlightColorAddress 0xC00F

#define playerWidth 45
#define playerHeight 45

#define player1LeftMask 0x0001
#define player1RightMask 0x0002
#define player1UpMask 0x0004
#define player1DownMask 0x0008
#define player1Mask 0x000F

#define player2LeftMask 0x0010
#define player2RightMask 0x0020
#define player2UpMask 0x0040
#define player2DownMask 0x0080
#define player2Mask 0x00F0

#define player3LeftMask 0x0100
#define player3RightMask 0x0200
#define player3UpMask 0x0400
#define player3DownMask 0x0800
#define player3Mask 0x0F00

#define player4LeftMask 0x1000
#define player4RightMask 0x2000
#define player4UpMask 0x4000
#define player4DownMask 0x8000
#define player4Mask 0xF000

#define greatestCPUAddress 0x8095

#define call(functionName) READ R12 | functionName | JAL R13 R12
#define return() JCOND UC R13

#define save(registerName) SUBI 1 R14 | STOR registerName R14
#define restore(registerName) ADDI 1 R14 | LOAD registerName R14

#define setRectXPos(index, value) MOVI index R12 | LSHI 4 R12 | READ R10 | 0x8000 | ADD R10 R12 | READ R10 | value | STOR R10 R12
#define setRectYPos(index, value) MOVI index R12 | LSHI 4 R12 | ADDI 1 R12 | READ R10 | 0x8000 | ADD R10 R12 | READ R10 | value | STOR R10 R12
#define setRectWidth(index, value) MOVI index R12 | LSHI 4 R12 | ADDI 2 R12 | READ R10 | 0x8000 | ADD R10 R12 | SUBI 1 R14 | STOR R12 R14 | LOAD R10 R12 | LSHI 8 R10 | LSHI -8 R10 | READ R12 | value | LSHI 8 R12 | ADD R12 R10 | LOAD R12 R14 | ADDI 1 R14 | STOR R10 R12
#define setRectHeight(index, value) MOVI index R12 | LSHI 4 R12 | ADDI 2 R12 | READ R10 | 0x8000 | ADD R10 R12 | SUBI 1 R14 | STOR R12 R14 | LOAD R10 R12 | LSHI -8 R10 | LSHI 8 R10 | READ R12 | value | ADD R12 R10 | LOAD R12 R14 | ADDI 1 R14 | STOR R10 R12
#define setRectColor(index, value) MOVI index R12 | LSHI 4 R12 | ADDI 3 R12 | READ R10 | 0x8000 | ADD R10 R12 | READ R10 | value | STOR R10 R12