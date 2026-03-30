from assembler import assembleProgram


program_source = """
MOVI 0x01, R0
LSHI 15, R0
MOVI 100, R1
STOR R1, R0

MOVI 0x01, R0
LSHI 14, R0
MOVI 100, R1
STOR R1, R0

MOVI 0x01, R0
MOVI 0x01, R2
LSHI 14, R0
OR R2, R0
MOVI 100, R1
STOR R1, R0
WAIT
"""


print(assembleProgram(program_source))
