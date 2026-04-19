//uses r1, r0, and r2
// Returns random in r7
funcNextRand:
    %saveRegs
    SUBI 1 R14
    STOR R13 R14

    // Load state
    READ R1
    &varRandomSeed
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
    &varRandomSeed
    STOR R0 R1

    LOAD R13 R14
    ADDI 1 R14

    MOV R0 R7 // return in r7
    %restoreRegs
    %return