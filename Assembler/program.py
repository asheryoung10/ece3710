from pathlib import Path
import sys

from assembler import assembleProgram


DEFAULT_PROGRAM_SOURCE = """
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


def load_program_source():
    if len(sys.argv) > 1:
        return Path(sys.argv[1]).read_text()

    return DEFAULT_PROGRAM_SOURCE


print(assembleProgram(load_program_source()))
