from assembler import assembleInstruction


print(assembleInstruction("MOVI 0x01, R0"));
print(assembleInstruction("LSHI 15, R0"));
print(assembleInstruction("MOVI 100, R1"));
print(assembleInstruction("STOR R1, R0"));

print(assembleInstruction("MOVI 0x01, R0"));
print(assembleInstruction("LSHI 14, R0"));
print(assembleInstruction("MOVI 100, R1"));
print(assembleInstruction("STOR R1, R0"));

print(assembleInstruction("MOVI 0x01, R0"));
print(assembleInstruction("MOVI 0x01, R2"));
print(assembleInstruction("LSHI 14, R0"));
print(assembleInstruction("OR R2, R0"));
print(assembleInstruction("MOVI 100, R1"));
print(assembleInstruction("STOR R1, R0"));

