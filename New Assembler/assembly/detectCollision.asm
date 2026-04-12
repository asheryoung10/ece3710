funcDetectAndResolveCollisions:
    %save(R13)

    MOVI 0 R0 // Player index
    funcDetectAndResolveCollisionsPlayerLoop:
        MOVI 0 R1 // rect index
        funcDetectAndResolveCollisionsRectLoop:
            %callSave
            %call(&funcDetectFeetCollision)
            MOV R0 R7
            %callRestore
            CMPI 1 R7 | GOIF NE &funcDetectAndResolveCollisionsNegative

            READ R7 | &varPlayerVelocityAddress
            MOV R0 R2 // R2 has player index
            LSHI 1 R2  // * 2
            OR R2 R7
            ADDI 1 R7 // YVelocity
            READ R12 | %minVelocityY
            STOR R12 R7

            funcDetectAndResolveCollisionsNegative:
            ADDI 1 R1 
            CMPI 16 R1
            GOIF NE &funcDetectAndResolveCollisionsRectLoop

        ADDI 1 R0
        CMPI 4 R0

    GOIF NE &funcDetectAndResolveCollisionsPlayerLoop


    %restore(R13)
    %return


// Input: R0: Player index, R1 Rectangle Index
// Output: R0 = 0 (no collision), R1 = 1 (collision)
funcDetectCollision:
    %save(R6) | %save(R7) | %save(R8) | %save(R9)

    // get player x and y
    READ R2 | &varPlayerLocalData
    LSHI 2 R0
    ADD R0 R2
    LOAD R0 R2
    ADDI 1 R2 | LOAD R2 R2

    // get rectangle x, y, width, height
    READ R3 | &varRectLocalData
    LSHI 2 R1
    ADD R1 R3
    LOAD R1 R3
    ADDI 1 R3 | LOAD R4 R3
    ADDI 1 R3 | LOAD R3 R3
    READ R12 | 0x00FF | MOV R3 R5 | AND R12 R5
    LSHI -8 R3

    // constants
    MOVI 45 R6 // player width
    MOVI 41 R7 // player height

    // --- check 1: pX < rectX + rectW ---
    MOV R1 R8
    ADD R3 R8
    CMPI 0 R8 // dummy to set flags properly
    CMP R0 R8
    GOIF GE &funcDetectCollisionNo

    // --- check 2: pX + pW > rectX ---
    MOV R0 R8
    ADD R6 R8
    CMP R8 R1
    GOIF LE &funcDetectCollisionNo

    // --- check 3: pY < rectY + rectH ---
    MOV R4 R8
    ADD R5 R8
    CMP R2 R8
    GOIF GE &funcDetectCollisionNo

    // --- check 4: pY + pH > rectY ---
    MOV R2 R8
    ADD R7 R8
    CMP R8 R4
    GOIF LE &funcDetectCollisionNo

    // collision true
    MOVI 1 R1
    MOVI 1 R0
    GOIF UC &funcDetectCollisionPositive

funcDetectCollisionNo:
    MOVI 0 R1
    MOVI 0 R0

    GOIF UC &funcDetectCollisionReturn

funcDetectCollisionPositive:

funcDetectCollisionReturn:
    %restore(R9) | %restore(R8) | %restore(R7) | %restore(R6)
    %return


// Input: R0: Player index, R1 Rectangle Index
// Output: R0 = 0 (no collision), R1 = 1 (collision)
funcDetectFeetCollision:
    %save(R6) | %save(R7) | %save(R8) | %save(R9)

    // -------------------------
    // Load player x, y
    // -------------------------
    READ R2 | &varPlayerLocalData
    LSHI 2 R0
    ADD R0 R2
    LOAD R0 R2          // pX
    ADDI 1 R2 | LOAD R2 R2   // pY

    // -------------------------
    // Load rect x, y, w, h
    // -------------------------
    READ R3 | &varRectLocalData
    LSHI 2 R1
    ADD R1 R3
    LOAD R1 R3          // rX
    ADDI 1 R3 | LOAD R4 R3   // rY
    ADDI 1 R3 | LOAD R3 R3   // packed w/h
    READ R12 | 0x00FF | MOV R3 R5 | AND R12 R5 // rH
    LSHI -8 R3                               // rW

    // -------------------------
    // Player feet box (bottom 10px)
    // -------------------------
    MOVI 45 R6      // pW
    MOVI 10 R7      // pFeetH

    MOV R2 R8
    MOVI 31 R9      // 41 - 10 = 31
    ADD R9 R8       // pFeetY in R8

    // -------------------------
    // Rect head box (top 10px)
    // -------------------------
    MOVI 10 R9      // rHeadH = 10
    // rY already correct for top

    // -------------------------
    // CHECK 1: pX < rX + rW
    // -------------------------
    MOV R1 R10
    ADD R3 R10
    CMP R0 R10
    GOIF GE &funcDetectFeetCollisionNo

    // -------------------------
    // CHECK 2: pX + pW > rX
    // -------------------------
    MOV R0 R10
    ADD R6 R10
    CMP R10 R1
    GOIF LE &funcDetectFeetCollisionNo

    // -------------------------
    // CHECK 3: pFeetY < rY + 10
    // -------------------------
    MOV R4 R10
    ADD R9 R10
    CMP R8 R10
    GOIF GE &funcDetectFeetCollisionNo

    // -------------------------
    // CHECK 4: pFeetY + 10 > rY
    // -------------------------
    MOV R8 R10
    ADD R7 R10
    CMP R10 R4
    GOIF LE &funcDetectFeetCollisionNo

    // -------------------------
    // collision = true
    // -------------------------
    MOVI 1 R1
    MOVI 1 R0
    GOIF UC &funcDetectFeetCollisionPositive

funcDetectFeetCollisionNo:
    MOVI 0 R1
    MOVI 0 R0
    GOIF UC &funcDetectFeetCollisionReturn

funcDetectFeetCollisionPositive:
    MOVI 1 R1
    MOVI 1 R0

funcDetectFeetCollisionReturn:
    %restore(R9) | %restore(R8) | %restore(R7) | %restore(R6)
    %return