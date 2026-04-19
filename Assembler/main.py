from enum import Enum

class FieldType(Enum):
    OPCODE       = (4,  "Primary opcode")
    REGISTER     = (4,  "Register index (0-15)")
    EXTENSION    = (4,  "Extended opcode")
    CONDITION    = (4,  "Condition code")
    IMM8         = (8,  "8-bit immediate")
    DISP8        = (8,  "8-bit displacement (signed)")
    FIXED4       = (4,  "Fixed 4-bit value")
    FIXED8       = (8,  "Fixed 8-bit value")

    def __init__(self, width: int, description: str):
        self.width = width
        self.description = description
        
class Instruction:
    def __init__(self, mnemonic: str, fields: list[FieldType]):
        self.mnemonic = mnemonic
        self.fields = fields

        total = sum(field.width for field in fields)
        if total != 16:
            raise ValueError(
                f"Instruction {mnemonic} has {total} bits (must be 16)"
            )

    def __repr__(self):
        field_names = [f.name for f in self.fields]
        return f"{self.mnemonic}: {field_names}"
    
ADD = Instruction(
    "ADD",
    [
        FieldType.OPCODE,
        FieldType.REGISTER,
        FieldType.EXTENSION,
        FieldType.REGISTER,
    ]
)