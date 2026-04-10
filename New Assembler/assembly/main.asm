// Player 1
READ R0 | 0xC000 | READ R1 | 0x064 | STOR R1 R0
READ R0 | 0xC001 | READ R1 | 0x064 | STOR R1 R0
READ R0 | 0xC002 | READ R1 | 0x001 | STOR R1 R0
READ R0 | 0xC003 | READ R1 | 0xF800 | STOR R1 R0
// Player 2
READ R0 | 0xC004 | READ R1 | 0x190 | STOR R1 R0
READ R0 | 0xC005 | READ R1 | 0x064 | STOR R1 R0
READ R0 | 0xC006 | READ R1 | 0x002 | STOR R1 R0
READ R0 | 0xC007 | READ R1 | 0x07E0 | STOR R1 R0
// Player 3
READ R0 | 0xC008 | READ R1 | 0x064 | STOR R1 R0
READ R0 | 0xC009 | READ R1 | 0x12C | STOR R1 R0
READ R0 | 0xC00A | READ R1 | 0x003 | STOR R1 R0
READ R0 | 0xC00B | READ R1 | 0x001F | STOR R1 R0
// Player 4
READ R0 | 0xC00C | READ R1 | 0x190 | STOR R1 R0
READ R0 | 0xC00D | READ R1 | 0x12C | STOR R1 R0
READ R0 | 0xC00E | READ R1 | 0x004 | STOR R1 R0
READ R0 | 0xC00F | READ R1 | 0xFFFF | STOR R1 R0

// i = 0
MOVI 0 R0

// x = 0
MOVI 0 R2

// y = 0
MOVI 0 R3

// col = 0
MOVI 0 R5


loopStart:

// if i == 64 exit
MOVI 64 R1
CMPI 64 R0
GOIF EQ &done

// -------------------------
// addr = 0x8000 + (i * 4)
// -------------------------
MOV R0 R1
LSHI 2 R1

READ R4
0x8000
ADD R4 R1              // R1 = base address for rect i

// -------------------------
// STOR X
// -------------------------
STOR R2 R1
ADDI 1 R1

// -------------------------
// STOR Y
// -------------------------
STOR R3 R1
ADDI 1 R1

// -------------------------
// width/height = 16x16 => 0x1010
// -------------------------
MOVI 16 R4
LSHI 8 R4
MOVI 16 R6
OR R4 R6

STOR R6 R1
ADDI 1 R1

// -------------------------
// color = (i<<5) | (i<<10)
// -------------------------
MOV R0 R4
LSHI 5 R4

MOV R0 R6
LSHI 10 R6

OR R4 R6

STOR R6 R1

// -------------------------
// X += 16
// -------------------------
ADDI 16 R2

// col++
ADDI 1 R5

// if col == 16 -> new row
MOVI 16 R6
CMPI 16 R5
GOIF NE &skipRowReset

// reset column + x, increment y
MOVI 0 R5
MOVI 0 R2
ADDI 16 R3

skipRowReset:

// i++
ADDI 1 R0

GOIF UC &loopStart


done:
// Stop
0000