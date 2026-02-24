from enum import IntEnum, Enum, auto

class Operands(Enum):
    Rsrc = auto()
    Rdest = auto()
    Imm = auto()
    Disp = auto()
    Rtarget = auto()
    Rlink = auto()
    Roffset = auto()
    Rproc = auto()
    Ramount = auto()
    Raddr = auto()
    Vector = auto()

class Instructions(Enum):
    ADD = auto()
    ADDI = auto()
    ADDU = auto()
    ADDUI = auto()
    ADDC = auto()
    ADDCI = auto()
    MUL = auto()
    MULI = auto()
    SUB = auto()
    SUBI = auto()
    SUBC = auto()
    SUBCI = auto()
    CMP = auto()
    CMPI = auto()
    AND = auto()
    ANDI = auto()
    OR = auto()
    ORI = auto()
    XOR = auto()
    XORI = auto()
    MOV = auto()
    MOVI = auto()
    LSH = auto()
    LSHI = auto()
    ASHU = auto()
    ASHUI = auto()
    LUI = auto()
    LOAD = auto()
    STOR = auto()
    SNXB = auto()
    ZRXB = auto()
    SCOND = auto()
    BCOND = auto()
    JCOND = auto()
    JAL = auto()
    TBIT = auto()
    TBITI = auto()
    LPR = auto()
    SPR = auto()
    DI = auto()
    EI = auto()
    EXCP = auto()
    RETX = auto()
    WAIT = auto()

class Fields(Enum):
    Rsrc = auto()
    Rdest = auto()
    ImmLo = auto()
    ImmHi = auto()
    OPCode = auto()
    OPCodeExt = auto()
    OPCodeExtSmall = auto()
    ShiftSign = auto()
    Ramount = auto()
    Raddr = auto()
    Cond = auto()
    DispHi = auto()
    DispLo = auto()
    Rlink = auto()
    Roffset = auto()
    Offset = auto()
    Rproc = auto()
    Vector = auto()
    Rtarget = auto()
    Zeros = auto()

FIELD_WIDTH = {
    Fields.OPCode: 4,
    Fields.OPCodeExt: 4,
    Fields.OPCodeExtSmall: 3,
    Fields.Rsrc: 4,
    Fields.Rdest: 4,
    Fields.Ramount: 4,
    Fields.Raddr: 4,
    Fields.Rlink: 4,
    Fields.Roffset: 4,
    Fields.Rproc: 4,
    Fields.ImmHi: 4,
    Fields.ImmLo: 4,
    Fields.DispHi: 4,
    Fields.DispLo: 4,
    Fields.Offset: 4,
    Fields.Cond: 4,
    Fields.ShiftSign: 1,
    Fields.Vector: 4,
    Fields.Rtarget: 4,
    Fields.Zeros:4 
}

OPERAND_FORMAT = {
    Instructions.ADD:    (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDI:   (Operands.Imm, Operands.Rdest),
    Instructions.ADDU:   (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDUI:  (Operands.Imm, Operands.Rdest),
    Instructions.ADDC:   (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDCI:  (Operands.Imm, Operands.Rdest),
    Instructions.MUL:    (Operands.Rsrc, Operands.Rdest),
    Instructions.MULI:   (Operands.Imm, Operands.Rdest),
    Instructions.SUB:    (Operands.Rsrc, Operands.Rdest),
    Instructions.SUBI:   (Operands.Imm, Operands.Rdest),
    Instructions.SUBC:   (Operands.Rsrc, Operands.Rdest),
    Instructions.SUBCI:  (Operands.Imm, Operands.Rdest),
    Instructions.CMP:    (Operands.Rsrc, Operands.Rdest),
    Instructions.CMPI:   (Operands.Imm, Operands.Rdest),
    Instructions.AND:    (Operands.Rsrc, Operands.Rdest),
    Instructions.ANDI:   (Operands.Imm, Operands.Rdest),
    Instructions.OR:     (Operands.Rsrc, Operands.Rdest),
    Instructions.ORI:    (Operands.Imm, Operands.Rdest),
    Instructions.XOR:    (Operands.Rsrc, Operands.Rdest),
    Instructions.XORI:   (Operands.Imm, Operands.Rdest),
    Instructions.MOV:    (Operands.Rsrc, Operands.Rdest),
    Instructions.MOVI:   (Operands.Imm, Operands.Rdest),
    Instructions.LSH:    (Operands.Ramount, Operands.Rdest),
    Instructions.LSHI:   (Operands.Imm, Operands.Rdest),
    Instructions.ASHU:   (Operands.Ramount, Operands.Rdest),
    Instructions.ASHUI:  (Operands.Imm, Operands.Rdest),
    Instructions.LUI:    (Operands.Imm, Operands.Rdest),
    Instructions.LOAD:   (Operands.Rdest, Operands.Raddr),
    Instructions.STOR:   (Operands.Rsrc, Operands.Raddr),
    Instructions.SNXB:   (Operands.Rsrc, Operands.Rdest),
    Instructions.ZRXB:   (Operands.Rsrc, Operands.Rdest),
    Instructions.SCOND:  (Operands.Rdest,),
    Instructions.BCOND:  (Operands.Disp,),
    Instructions.JCOND:  (Operands.Rtarget,),
    Instructions.JAL:    (Operands.Rlink, Operands.Rtarget),
    Instructions.TBIT:   (Operands.Roffset, Operands.Rsrc),
    Instructions.TBITI:  (Operands.Imm, Operands.Rsrc),
    Instructions.LPR:    (Operands.Rsrc, Operands.Rproc),
    Instructions.SPR:    (Operands.Rproc, Operands.Rdest),
    Instructions.DI:     (),
    Instructions.EI:     (),
    Instructions.EXCP:   (Operands.Vector,),
    Instructions.RETX:   (),
    Instructions.WAIT:   (),
}

INSTRUCTION_FORMAT = {
    Instructions.ADD:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDU:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDC:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.MUL:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SUB:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SUBC:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.CMP:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.AND:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.OR:    (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.XOR:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.MOV:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ADDUI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ADDCI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.MULI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.SUBI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.SUBCI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.CMPI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ANDI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ORI:   (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.XORI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.MOVI:  (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.LUI:   (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.LSH:   (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Ramount),
    Instructions.LSHI:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExtSmall, Fields.ShiftSign, Fields.ImmLo),
    Instructions.ASHU:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Ramount),
    Instructions.ASHUI: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExtSmall, Fields.ShiftSign, Fields.ImmLo),
    Instructions.LOAD:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Raddr),
    Instructions.STOR:  (Fields.OPCode, Fields.Rsrc,  Fields.OPCodeExt, Fields.Raddr),
    Instructions.SNXB:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ZRXB:  (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SCOND: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Cond),
    Instructions.BCOND: (Fields.OPCode, Fields.Cond,  Fields.DispHi,  Fields.DispLo),
    Instructions.JCOND: (Fields.OPCode, Fields.Cond,  Fields.OPCodeExt, Fields.Rtarget),
    Instructions.JAL:   (Fields.OPCode, Fields.Rlink, Fields.OPCodeExt, Fields.Rtarget),
    Instructions.TBIT:  (Fields.OPCode, Fields.Rsrc,  Fields.OPCodeExt, Fields.Roffset),
    Instructions.TBITI: (Fields.OPCode, Fields.Rsrc,  Fields.OPCodeExt, Fields.Offset),
    Instructions.LPR:   (Fields.OPCode, Fields.Rsrc,  Fields.OPCodeExt, Fields.Rproc),
    Instructions.SPR:   (Fields.OPCode, Fields.Rproc, Fields.OPCodeExt, Fields.Rdest),
    Instructions.DI:    (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.EI:    (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.EXCP:  (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Vector),
    Instructions.RETX:  (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.WAIT:  (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
}

OPCODE_MAP = {
    Instructions.ADD: 0x0, Instructions.ADDU: 0x0, Instructions.ADDC: 0x0,
    Instructions.MUL: 0x0, Instructions.SUB: 0x0, Instructions.SUBC: 0x0,
    Instructions.CMP: 0x0, Instructions.AND: 0x0, Instructions.OR: 0x0,
    Instructions.XOR: 0x0, Instructions.MOV: 0x0, Instructions.WAIT: 0x0,
    Instructions.ANDI: 0x1,
    Instructions.ORI: 0x2,
    Instructions.XORI: 0x3,
    Instructions.LOAD: 0x4, Instructions.STOR: 0x4, Instructions.SNXB: 0x4,
    Instructions.ZRXB: 0x4, Instructions.SCOND: 0x4, Instructions.JCOND: 0x4,
    Instructions.JAL: 0x4, Instructions.TBIT: 0x4, Instructions.TBITI: 0x4,
    Instructions.LPR: 0x4, Instructions.SPR: 0x4, Instructions.DI: 0x4,
    Instructions.EI: 0x4, Instructions.EXCP: 0x4, Instructions.RETX: 0x4,
    Instructions.ADDI: 0x5,
    Instructions.ADDUI: 0x6,
    Instructions.ADDCI: 0x7,
    Instructions.LSH: 0x8, Instructions.LSHI: 0x8, Instructions.ASHU: 0x8, Instructions.ASHUI: 0x8,
    Instructions.SUBI: 0x9,
    Instructions.SUBCI: 0xA,
    Instructions.CMPI: 0xB,
    Instructions.BCOND: 0xC,
    Instructions.MOVI: 0xD,
    Instructions.MULI: 0xE,
    Instructions.LUI: 0xF,
}

OPCODE_EXT_MAP = {
    Instructions.AND: 0x1,
    Instructions.OR: 0x2,
    Instructions.XOR: 0x3,
    Instructions.LSH: 0x4,
    Instructions.ADD: 0x5,
    Instructions.ADDU: 0x6,
    Instructions.ADDC: 0x7,
    Instructions.SUB: 0x9,
    Instructions.SUBC: 0xA,
    Instructions.CMP: 0xB,
    Instructions.MUL: 0xE,
    Instructions.MOV: 0xD,
    Instructions.WAIT: 0x0,
    Instructions.LOAD: 0x0,
    Instructions.LPR: 0x1,
    Instructions.SNXB: 0x2,
    Instructions.DI: 0x3,
    Instructions.STOR: 0x4,
    Instructions.SPR: 0x5,
    Instructions.ZRXB: 0x6,
    Instructions.EI: 0x7,
    Instructions.JAL: 0x8,
    Instructions.RETX: 0x9,
    Instructions.TBIT: 0xA,
    Instructions.EXCP: 0xB,
    Instructions.JCOND: 0xC,
    Instructions.SCOND: 0xD,
    Instructions.TBITI: 0xE,
    Instructions.ASHU: 0x6,
}

OPCODE_EXT_SMALL_MAP = {
    Instructions.LSHI: 0x0,
    Instructions.ASHUI: 0x1,
}

class Condition(IntEnum):
    EQ = 0x0  # Equal
    NE = 0x1  # Not Equal
    CS = 0x2  # Carry Set
    CC = 0x3  # Carry Clear
    HI = 0x4  # Higher
    LS = 0x5  # Lower or Same
    GT = 0x6  # Greater Than
    LE = 0x7  # Less or Equal
    FS = 0x8  # Flag Set
    FC = 0x9  # Flag Clear
    LO = 0xA  # Lower
    HS = 0xB  # Higher or Same
    LT = 0xC  # Less Than
    GE = 0xD  # Greater or Equal
    UC = 0xE  # Unconditional

def assembleInstruction(instruction_str):
    parts = instruction_str.replace(',', ' ').split()
    if not parts:
        return None
    
    inst_name = parts[0].upper()
    args = parts[1:]
    condition_enum = None
    # 2. Verify instruction name is valid
    try:
        inst_enum = Instructions[inst_name]
    except KeyError:
        # Check if it's a shorthand like BEQ, JNE, etc.
        import re
        match = re.match(r'^([BJ])([A-Z]{2})$', inst_name)
        if match:
            prefix, cond_str = match.groups()
            try:
                # Validate the condition (e.g., 'EQ', 'NE')
                condition_enum = Condition[cond_str]
                # Redirect to base instruction enum
                target_base = "BCOND" if prefix == "B" else "JCOND"
                inst_enum = Instructions[target_base]
            except KeyError:
                raise ValueError(f"Invalid condition code: {cond_str}")
        else:
            raise ValueError(f"Unknown instruction: {inst_name}")

    # 3. Verify operand count matches OPERAND_FORMAT
    expected_operands = OPERAND_FORMAT[inst_enum]
    if len(args) != len(expected_operands):
        raise ValueError(f"{inst_name} expects {len(expected_operands)} operands, got {len(args)}")

    # 4. Map Operands to values
    # Simple parser: 'R1' -> 1, '#10' or '10' -> 10
    val_map = {}
    for op_type, arg in zip(expected_operands, args):
        clean_arg = arg.strip().upper()
        if clean_arg.startswith('R'):
            val = int(clean_arg[1:])
        else:
            # Handle hex (0x) or decimal
            val = int(clean_arg, 0)
        val_map[op_type] = val

    # 5. Build the 16-bit instruction
    instruction_word = 0
    current_bit = 16
    
    # Get the fields required for this instruction
    fields = INSTRUCTION_FORMAT[inst_enum]

    for field in fields:
        width = FIELD_WIDTH[field]
        current_bit -= width
        field_val = 0

        # Assign value based on field type
        if field == Fields.OPCode:
            field_val = OPCODE_MAP[inst_enum]
        elif field == Fields.OPCodeExt:
            field_val = OPCODE_EXT_MAP.get(inst_enum, 0)
        elif field == Fields.OPCodeExtSmall:
            field_val = OPCODE_EXT_SMALL_MAP.get(inst_enum, 0)
        elif field == Fields.Zeros:
            field_val = 0
        
        # Mapping Operands to Fields
        elif field == Fields.Roffset:
            field_val = val_map[Operands.Roffset]
        elif field == Fields.Offset:
            field_val = val_map[Operands.Imm] & 0xF
        elif field == Fields.Rdest:
            field_val = val_map[Operands.Rdest]
        elif field == Fields.Rsrc:
            field_val = val_map[Operands.Rsrc]
        elif field == Fields.Raddr:
            field_val = val_map[Operands.Raddr]
        elif field == Fields.Rproc:
            field_val = val_map[Operands.Rproc]
        elif field == Fields.Rlink:
            field_val = val_map[Operands.Rlink]
        elif field == Fields.Rtarget:
            field_val = val_map[Operands.Rtarget]
        elif field == Fields.Ramount:
            # Handle 4-bit 2s complement (-8 to 7 or -15 to 15 based on docs)
            field_val = val_map[Operands.Ramount] & 0xF
        elif field == Fields.ShiftSign:
            # 's' bit is 1 if negative, 0 if positive
            field_val = 1 if val_map[Operands.Imm] < 0 else 0
        elif field == Fields.ImmHi:
            # Top 4 bits of 8-bit immediate
            field_val = (val_map[Operands.Imm] >> 4) & 0xF
        elif field == Fields.ImmLo:
            # Bottom 4 bits of 8-bit immediate
            field_val = val_map[Operands.Imm] & 0xF
        elif field == Fields.DispHi:
            field_val = (val_map[Operands.Disp] >> 4) & 0xF
        elif field == Fields.DispLo:
            field_val = val_map[Operands.Disp] & 0xF
        elif field == Fields.Cond:
           if condition_enum is not None:
            field_val = int(condition_enum) & 0xF
           else:
            raise ValueError(instruction_str + " failed.")
        else:
            raise ValueError("No field value for instruction \"" + instruction_str + "\" for " + str(field))

        # Mask to ensure no overflow and shift into place
        instruction_word |= (field_val & ((1 << width) - 1)) << current_bit

    return f"{instruction_word:04X}"

def testInstruction(instruction, expected):
    result = assembleInstruction(instruction)
    if(result != expected.upper()):
        print("Failed, instruction \"" + instruction + "\" resulted in \"" + result + "\" when \"" + expected + "\" was expected.")
    else:
        print("Passed: " + instruction)

if __name__ == "__main__":
    testInstruction("ADD R0, R1", "0150")      # OP=0, Rdest=1, Ext=5, Rsrc=0
    testInstruction("ADDI 0x2A, R5", "552A")   # OP=5, Rdest=5, Imm=2A
    testInstruction("SUB R2, R3", "0392")      # OP=0, Rdest=3, Ext=9, Rsrc=2
    testInstruction("SUBI 0x05, R10", "9A05")  # OP=9, Rdest=A, Imm=05
    testInstruction("MUL R4, R5", "05E4")      # OP=0, Rdest=5, Ext=E, Rsrc=4
    testInstruction("MULI 0x12, R8", "E812")   # OP=E, Rdest=8, Imm=12

    testInstruction("AND R6, R7", "0716")      # OP=0, Rdest=7, Ext=1, Rsrc=6
    testInstruction("ANDI 0xFF, R1", "11FF")   # OP=1, Rdest=1, Imm=FF
    testInstruction("OR R8, R9", "0928")       # OP=0, Rdest=9, Ext=2, Rsrc=8
    testInstruction("XOR R11, R12", "0C3B")    # OP=0, Rdest=C, Ext=3, Rsrc=B
    testInstruction("MOV R1, R2", "02D1")      # OP=0, Rdest=2, Ext=D, Rsrc=1
    testInstruction("MOVI 0x7F, R4", "D47F")   # OP=D, Rdest=4, Imm=7F

    testInstruction("LSH R2, R3", "8342")      # OP=8, Rdest=3, Ext=4, Ramount=2
    testInstruction("LUI 0xAB, R10", "FAAB")   # OP=F, Rdest=A, Imm=AB

    testInstruction("LOAD R1, R2", "4102")     # OP=4, Rdest=1, Ext=0, Raddr=2
    testInstruction("STOR R3, R4", "4344")     # OP=4, Rsrc=3, Ext=4, Raddr=4
    testInstruction("BEQ 0x10", "C010")        # Assuming cond 0 is 'equal' 
    testInstruction("JAL R1, R2", "4182")      # OP=4, Rlink=1, Ext=8, Rtarget=2

    testInstruction("TBIT 5, R1", "41A5")      # OP=4, Rsrc=1, Ext=A, Offset=5
    testInstruction("DI", "4030")              # OP=4, 0, Ext=3, 0
    testInstruction("EI", "4070")              # OP=4, 0, Ext=7, 0
    testInstruction("RETX", "4090")            # OP=4, 0, Ext=9, 0
    testInstruction("WAIT", "0000")            # OP=0, 0, Ext=0, 0

    testInstruction("ADD R1, R2", "0251")     # OP=0, Rdest=2, Ext=5, Rsrc=1
    testInstruction("ADDU R15, R0", "006F")   # OP=0, Rdest=0, Ext=6, Rsrc=F
    testInstruction("SUB R5, R6", "0695")     # OP=0, Rdest=6, Ext=9, Rsrc=5
    testInstruction("CMP R3, R4", "04B3")     # OP=0, Rdest=4, Ext=B, Rsrc=3
    testInstruction("AND R10, R11", "0B1A")   # OP=0, Rdest=B, Ext=1, Rsrc=A
    testInstruction("XOR R7, R8", "0837")     # OP=0, Rdest=8, Ext=3, Rsrc=7

    # --- Immediate Arithmetic ---
    testInstruction("ADDI 0x12, R1", "5112")  # OP=5, Rdest=1, Imm=12
    testInstruction("SUBI 0x7F, R2", "927F")  # OP=9, Rdest=2, Imm=7F
    testInstruction("CMPI 0x01, R9", "B901")  # OP=B, Rdest=9, Imm=01
    testInstruction("ANDI 0x55, R4", "1455")  # OP=1, Rdest=4, Imm=55
    testInstruction("MOVI 0xAA, R13", "DDAA") # OP=D, Rdest=D, Imm=AA
    # --- Branch Shorthand (OP=C, bits 11-8 = Cond) ---
    testInstruction("BEQ 0x20", "C020")       # Cond=0 (EQ)
    testInstruction("BNE 0x15", "C115")       # Cond=1 (NE)
    testInstruction("BCS 0x04", "C204")       # Cond=2 (CS)
    testInstruction("BGT 0xFE", "C6FE")       # Cond=6 (GT)
    testInstruction("BLE 0x00", "C700")       # Cond=7 (LE)
    testInstruction("BLT 0x10", "CC10")       # Cond=C (LT)
    testInstruction("BGE 0x10", "CD10")       # Cond=D (GE)
    testInstruction("BUC 0x77", "CE77")       # Cond=E (UC)

    # --- Jump Shorthand (OP=4, bits 11-8 = Cond, bits 3-0 = Rtarget) ---
    testInstruction("JEQ R5", "40C5")         # Cond=0, Ext=C (Jcond), Rtarget=5
    testInstruction("JNE R1", "41C1")         # Cond=1, Ext=C (Jcond), Rtarget=1
    testInstruction("JUC R15", "4ECF")        # Cond=E, Ext=C (Jcond), Rtarget=F
    
    # --- Memory & Linking ---
    testInstruction("LOAD R1, R2", "4102")    # OP=4, Rdest=1, Ext=0, Raddr=2
    testInstruction("STOR R10, R11", "4A4B")  # OP=4, Rsrc=A, Ext=4, Raddr=B
    testInstruction("JAL R14, R15", "4E8F")   # OP=4, Rlink=E, Ext=8, Rtarget=F
    # --- Shifts & Bit Ops ---
    testInstruction("LUI 0xAB, R4", "F4AB")   # OP=F, Rdest=4, Imm=AB
    testInstruction("LSH 5, R1", "8145")      # OP=8, Rdest=1, Ext=4, Ramount=5
    testInstruction("TBIT 12, R6", "46AC")    # OP=4, Rsrc=6, Ext=A, Offset=C (12)
    testInstruction("TBITI 0x03, R0", "40E3") # OP=4, Rsrc=0, Ext=E, Offset=3

    # --- System Control ---
    testInstruction("DI", "4030")             # OP=4, Fixed Ext=3
    testInstruction("EI", "4070")             # OP=4, Fixed Ext=7
    testInstruction("RETX", "4090")           # OP=4, Fixed Ext=9
    testInstruction("WAIT", "0000")           # OP=0, Fixed all zeros

    # --- Standard Arithmetic & Logic (Baseline) ---
    testInstruction("ADD R0, R1", "0150")    # Rsrc=0, Rdest=1
    testInstruction("SUB R5, R2", "0295")    # Rsrc=5, Rdest=2
    testInstruction("AND R4, R6", "0614")    # Rsrc=4, Rdest=6
    testInstruction("OR R8, R15", "0F28")    # Rsrc=8, Rdest=F
    testInstruction("XOR R1, R0", "0031")    # Rsrc=1, Rdest=0
    testInstruction("MOV R3, R7", "07D3")    # Rsrc=3, Rdest=7
    
    # --- Immediate Operations ---
    testInstruction("ADDI 0xA5, R1", "51A5")  # Rdest=1, Imm=A5
    testInstruction("SUBI 0x0F, R2", "920F")  # Rdest=2, Imm=0F
    testInstruction("ANDI 0x33, R4", "1433")  # Rdest=4, Imm=33
    testInstruction("MOVI 0xAA, R5", "D5AA")  # Rdest=5, Imm=AA
    
    # --- Memory & System ---
    testInstruction("LOAD R1, R2", "4102")    # Rdest=1, Raddr=2
    testInstruction("STOR R3, R4", "4344")    # Rsrc=3, Raddr=4
    testInstruction("DI", "4030")            # Disable Interrupts
    testInstruction("EI", "4070")            # Enable Interrupts
    testInstruction("RETX", "4090")          # Return from Exception
    testInstruction("WAIT", "0000")          # Wait
    
    # --- Conditional Branches (New Logic) ---
    # These use BCOND/JCOND logic parsed from Bxx/Jxx names
    testInstruction("BEQ 0x1F", "C01F")      # Bcond, EQ(0), disp=1F
    testInstruction("BNE 0x2A", "C12A")      # Bcond, NE(1), disp=2A
    testInstruction("BLT 0x05", "CC05")      # Bcond, LT(C), disp=05
    testInstruction("BGE 0x08", "CD08")      # Bcond, GE(D), disp=08
    testInstruction("BUC 0x30", "CE30")      # Bcond, UC(E), disp=30
    
    # --- Conditional Jumps ---
    testInstruction("JGT R5", "46C5")        # Jcond, Rtarget=5, GT(6)
    testInstruction("JHI R2", "44C2")        # Jcond, Rtarget=2, HI(4)
    testInstruction("JHS R9", "4BC9")        # Jcond, Rtarget=9, HS(B)