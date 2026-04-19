funcUpdateRectColors:
    %saveRegs

    READ R0 | &varLocalRectDataAddress
    ADDI 3 R0
    READ R1 | &varRectType
    MOVI 0 R2

    funcUpdateRectColorsLoop:

        LOAD R3 R1
        CMPI 3 R3 | GOIF NE &funcUpdateRectColorsContinue

        LOAD R4 R0 | ADDI 113 R4 | STOR R4 R0  

        funcUpdateRectColorsContinue:
        ADDI 1 R1 | ADDI 4 R0
        ADDI 1 R2 | CMPI 64 R2 | GOIF NE &funcUpdateRectColorsLoop


    %restoreRegs
    %return