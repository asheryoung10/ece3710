from assembler import assembleInstruction


print(assembleInstruction("MOVI 0x01, R0"));
print(assembleInstruction("LSH 15, R0"));
print(assembleInstruction("MOVI 0, R1"));
print(assembleInstruction("STOR R1, R0"));
