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
        path = Path(sys.argv[1])
        return path.read_text(), path
    return DEFAULT_PROGRAM_SOURCE, None


source, input_path = load_program_source()
output = assembleProgram(source)

if input_path is not None:
    output_path = input_path.with_suffix(".bin")
else:
    output_path = Path("output.bin")

# If assembleProgram returns bytes, use write_bytes
# If it returns a string, use write_text
if isinstance(output, bytes):
    output_path.write_bytes(output)
else:
    output_path.write_text(output)

print(f"Wrote output to {output_path}")