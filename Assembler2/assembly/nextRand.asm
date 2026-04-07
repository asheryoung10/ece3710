//uses r1, r0, and r2
// Returns random in r0
nextRand:
    SUBI 1 R14
    STOR R13 R14

    // Load state
    READ R1
    1026
    LOAD R0 R1        // R0 = x

    // x ^= x << 7
    MOV R0 R2
    LSHI 7 R2
    XOR R2 R0

    // x ^= x >> 9
    MOV R0 R2
    LSHI -9 R2
    XOR R2 R0

    // x ^= x << 8
    MOV R0 R2
    LSHI 8 R2
    XOR R2 R0

    // Store new state
    READ R1
    1026
    STOR R0 R1

    LOAD R13 R14
    ADDI 1 R14
    JCOND UC R13