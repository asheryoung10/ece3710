from dataclasses import dataclass
from enum import Enum, IntEnum, auto
import re
from typing import Optional


COMMENT_PREFIX = "//"
LABEL_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:")
BRANCH_SHORTHAND_RE = re.compile(r"^([BJ])([A-Z]{2})$")
SIGNED_DISP_MIN = -128
SIGNED_DISP_MAX = 127


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
    Fields.Zeros: 4,
}


OPERAND_FORMAT = {
    Instructions.ADD: (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDI: (Operands.Imm, Operands.Rdest),
    Instructions.ADDU: (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDUI: (Operands.Imm, Operands.Rdest),
    Instructions.ADDC: (Operands.Rsrc, Operands.Rdest),
    Instructions.ADDCI: (Operands.Imm, Operands.Rdest),
    Instructions.MUL: (Operands.Rsrc, Operands.Rdest),
    Instructions.MULI: (Operands.Imm, Operands.Rdest),
    Instructions.SUB: (Operands.Rsrc, Operands.Rdest),
    Instructions.SUBI: (Operands.Imm, Operands.Rdest),
    Instructions.SUBC: (Operands.Rsrc, Operands.Rdest),
    Instructions.SUBCI: (Operands.Imm, Operands.Rdest),
    Instructions.CMP: (Operands.Rsrc, Operands.Rdest),
    Instructions.CMPI: (Operands.Imm, Operands.Rdest),
    Instructions.AND: (Operands.Rsrc, Operands.Rdest),
    Instructions.ANDI: (Operands.Imm, Operands.Rdest),
    Instructions.OR: (Operands.Rsrc, Operands.Rdest),
    Instructions.ORI: (Operands.Imm, Operands.Rdest),
    Instructions.XOR: (Operands.Rsrc, Operands.Rdest),
    Instructions.XORI: (Operands.Imm, Operands.Rdest),
    Instructions.MOV: (Operands.Rsrc, Operands.Rdest),
    Instructions.MOVI: (Operands.Imm, Operands.Rdest),
    Instructions.LSH: (Operands.Ramount, Operands.Rdest),
    Instructions.LSHI: (Operands.Imm, Operands.Rdest),
    Instructions.ASHU: (Operands.Ramount, Operands.Rdest),
    Instructions.ASHUI: (Operands.Imm, Operands.Rdest),
    Instructions.LUI: (Operands.Imm, Operands.Rdest),
    Instructions.LOAD: (Operands.Rdest, Operands.Raddr),
    Instructions.STOR: (Operands.Rsrc, Operands.Raddr),
    Instructions.SNXB: (Operands.Rsrc, Operands.Rdest),
    Instructions.ZRXB: (Operands.Rsrc, Operands.Rdest),
    Instructions.SCOND: (Operands.Rdest,),
    Instructions.BCOND: (Operands.Disp,),
    Instructions.JCOND: (Operands.Rtarget,),
    Instructions.JAL: (Operands.Rlink, Operands.Rtarget),
    Instructions.TBIT: (Operands.Roffset, Operands.Rsrc),
    Instructions.TBITI: (Operands.Imm, Operands.Rsrc),
    Instructions.LPR: (Operands.Rsrc, Operands.Rproc),
    Instructions.SPR: (Operands.Rproc, Operands.Rdest),
    Instructions.DI: (),
    Instructions.EI: (),
    Instructions.EXCP: (Operands.Vector,),
    Instructions.RETX: (),
    Instructions.WAIT: (),
}


INSTRUCTION_FORMAT = {
    Instructions.ADD: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDU: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDC: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.MUL: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SUB: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SUBC: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.CMP: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.AND: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.OR: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.XOR: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.MOV: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ADDI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ADDUI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ADDCI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.MULI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.SUBI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.SUBCI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.CMPI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ANDI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.ORI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.XORI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.MOVI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.LUI: (Fields.OPCode, Fields.Rdest, Fields.ImmHi, Fields.ImmLo),
    Instructions.LSH: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Ramount),
    Instructions.LSHI: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExtSmall, Fields.ShiftSign, Fields.ImmLo),
    Instructions.ASHU: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Ramount),
    Instructions.ASHUI: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExtSmall, Fields.ShiftSign, Fields.ImmLo),
    Instructions.LOAD: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Raddr),
    Instructions.STOR: (Fields.OPCode, Fields.Rsrc, Fields.OPCodeExt, Fields.Raddr),
    Instructions.SNXB: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.ZRXB: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Rsrc),
    Instructions.SCOND: (Fields.OPCode, Fields.Rdest, Fields.OPCodeExt, Fields.Cond),
    Instructions.BCOND: (Fields.OPCode, Fields.Cond, Fields.DispHi, Fields.DispLo),
    Instructions.JCOND: (Fields.OPCode, Fields.Cond, Fields.OPCodeExt, Fields.Rtarget),
    Instructions.JAL: (Fields.OPCode, Fields.Rlink, Fields.OPCodeExt, Fields.Rtarget),
    Instructions.TBIT: (Fields.OPCode, Fields.Rsrc, Fields.OPCodeExt, Fields.Roffset),
    Instructions.TBITI: (Fields.OPCode, Fields.Rsrc, Fields.OPCodeExt, Fields.Offset),
    Instructions.LPR: (Fields.OPCode, Fields.Rsrc, Fields.OPCodeExt, Fields.Rproc),
    Instructions.SPR: (Fields.OPCode, Fields.Rproc, Fields.OPCodeExt, Fields.Rdest),
    Instructions.DI: (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.EI: (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.EXCP: (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Vector),
    Instructions.RETX: (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
    Instructions.WAIT: (Fields.OPCode, Fields.Zeros, Fields.OPCodeExt, Fields.Zeros),
}


OPCODE_MAP = {
    Instructions.ADD: 0x0,
    Instructions.ADDU: 0x0,
    Instructions.ADDC: 0x0,
    Instructions.MUL: 0x0,
    Instructions.SUB: 0x0,
    Instructions.SUBC: 0x0,
    Instructions.CMP: 0x0,
    Instructions.AND: 0x0,
    Instructions.OR: 0x0,
    Instructions.XOR: 0x0,
    Instructions.MOV: 0x0,
    Instructions.WAIT: 0x0,
    Instructions.ANDI: 0x1,
    Instructions.ORI: 0x2,
    Instructions.XORI: 0x3,
    Instructions.LOAD: 0x4,
    Instructions.STOR: 0x4,
    Instructions.SNXB: 0x4,
    Instructions.ZRXB: 0x4,
    Instructions.SCOND: 0x4,
    Instructions.JCOND: 0x4,
    Instructions.JAL: 0x4,
    Instructions.TBIT: 0x4,
    Instructions.TBITI: 0x4,
    Instructions.LPR: 0x4,
    Instructions.SPR: 0x4,
    Instructions.DI: 0x4,
    Instructions.EI: 0x4,
    Instructions.EXCP: 0x4,
    Instructions.RETX: 0x4,
    Instructions.ADDI: 0x5,
    Instructions.ADDUI: 0x6,
    Instructions.ADDCI: 0x7,
    Instructions.LSH: 0x8,
    Instructions.LSHI: 0x8,
    Instructions.ASHU: 0x8,
    Instructions.ASHUI: 0x8,
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
    EQ = 0x0
    NE = 0x1
    CS = 0x2
    CC = 0x3
    HI = 0x4
    LS = 0x5
    GT = 0x6
    LE = 0x7
    FS = 0x8
    FC = 0x9
    LO = 0xA
    HS = 0xB
    LT = 0xC
    GE = 0xD
    UC = 0xE


@dataclass(frozen=True)
class ParsedInstruction:
    text: str
    inst_enum: Instructions
    operand_tokens: tuple[str, ...]
    condition_enum: Optional[Condition] = None


@dataclass(frozen=True)
class ProgramInstruction:
    address: int
    line_number: int
    parsed: ParsedInstruction


def _strip_comment(line):
    return line.split(COMMENT_PREFIX, 1)[0].strip()


def _extract_labels(line):
    labels = []
    remainder = line.strip()

    while remainder:
        match = LABEL_RE.match(remainder)
        if not match:
            break

        labels.append(match.group(1))
        remainder = remainder[match.end():].strip()

    return labels, remainder


def _parse_numeric_token(token):
    clean_token = token.strip()
    if clean_token.startswith("#"):
        clean_token = clean_token[1:]
    return int(clean_token, 0)


def _parse_condition_token(token):
    try:
        return Condition[token.strip().upper()]
    except KeyError as exc:
        raise ValueError(f"Invalid condition code: {token}") from exc


def _parse_instruction(instruction_str):
    parts = instruction_str.replace(",", " ").split()
    if not parts:
        return None

    inst_name = parts[0].upper()
    args = parts[1:]
    condition_enum = None

    try:
        inst_enum = Instructions[inst_name]
        if inst_enum in (Instructions.BCOND, Instructions.JCOND):
            if not args:
                raise ValueError(f"{inst_name} expects a condition and {len(OPERAND_FORMAT[inst_enum])} operand(s)")
            condition_enum = _parse_condition_token(args[0])
            args = args[1:]
    except KeyError:
        match = BRANCH_SHORTHAND_RE.fullmatch(inst_name)
        if not match:
            raise ValueError(f"Unknown instruction: {inst_name}")

        prefix, cond_str = match.groups()
        condition_enum = _parse_condition_token(cond_str)
        inst_enum = Instructions.BCOND if prefix == "B" else Instructions.JCOND

    expected_operands = OPERAND_FORMAT[inst_enum]
    if len(args) != len(expected_operands):
        raise ValueError(f"{inst_name} expects {len(expected_operands)} operands, got {len(args)}")

    return ParsedInstruction(
        text=instruction_str,
        inst_enum=inst_enum,
        operand_tokens=tuple(args),
        condition_enum=condition_enum,
    )


def _normalize_label(label):
    return label.upper()


def _parse_operand_value(op_type, token, labels=None, current_address=None):
    clean_token = token.strip()

    if op_type == Operands.Disp:
        try:
            value = _parse_numeric_token(clean_token)
        except ValueError:
            if labels is None or current_address is None:
                raise ValueError(f"Invalid displacement: {clean_token}")

            label_key = _normalize_label(clean_token)
            if label_key not in labels:
                raise ValueError(f"Unknown label: {clean_token}")

            value = labels[label_key] - current_address

            if value < SIGNED_DISP_MIN or value > SIGNED_DISP_MAX:
                raise ValueError(
                    f"Branch displacement {value} is out of range; expected {SIGNED_DISP_MIN}..{SIGNED_DISP_MAX}"
                )
            return value

        if value < SIGNED_DISP_MIN or value > 0xFF:
            raise ValueError(f"Branch displacement {value} is out of range; expected {SIGNED_DISP_MIN}..255")
        return value

    if clean_token.upper().startswith("R"):
        return int(clean_token[1:])

    return _parse_numeric_token(clean_token)


def _build_value_map(parsed_instruction, labels=None, current_address=None):
    val_map = {}
    expected_operands = OPERAND_FORMAT[parsed_instruction.inst_enum]

    for op_type, operand_token in zip(expected_operands, parsed_instruction.operand_tokens):
        val_map[op_type] = _parse_operand_value(op_type, operand_token, labels, current_address)

    return val_map


def _encode_instruction(parsed_instruction, val_map):
    instruction_word = 0
    current_bit = 16
    fields = INSTRUCTION_FORMAT[parsed_instruction.inst_enum]

    for field in fields:
        width = FIELD_WIDTH[field]
        current_bit -= width
        field_val = 0

        if field == Fields.OPCode:
            field_val = OPCODE_MAP[parsed_instruction.inst_enum]
        elif field == Fields.OPCodeExt:
            field_val = OPCODE_EXT_MAP.get(parsed_instruction.inst_enum, 0)
        elif field == Fields.OPCodeExtSmall:
            field_val = OPCODE_EXT_SMALL_MAP.get(parsed_instruction.inst_enum, 0)
        elif field == Fields.Zeros:
            field_val = 0
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
            field_val = val_map[Operands.Ramount] & 0xF
        elif field == Fields.ShiftSign:
            field_val = 1 if val_map[Operands.Imm] < 0 else 0
        elif field == Fields.ImmHi:
            field_val = (val_map[Operands.Imm] >> 4) & 0xF
        elif field == Fields.ImmLo:
            field_val = val_map[Operands.Imm] & 0xF
        elif field == Fields.DispHi:
            field_val = (val_map[Operands.Disp] >> 4) & 0xF
        elif field == Fields.DispLo:
            field_val = val_map[Operands.Disp] & 0xF
        elif field == Fields.Cond:
            if parsed_instruction.condition_enum is None:
                raise ValueError(f"Missing condition for {parsed_instruction.text}")
            field_val = int(parsed_instruction.condition_enum) & 0xF
        else:
            raise ValueError(f'No field value for instruction "{parsed_instruction.text}" for {field}')

        instruction_word |= (field_val & ((1 << width) - 1)) << current_bit

    return f"{instruction_word:04X}"


def _assemble_parsed_instruction(parsed_instruction, labels=None, current_address=None):
    val_map = _build_value_map(parsed_instruction, labels, current_address)
    return _encode_instruction(parsed_instruction, val_map)


def _wrap_line_error(line_number, exc):
    raise ValueError(f"Line {line_number}: {exc}") from exc


def _collect_program(source):
    label_map = {}
    instructions = []
    current_address = 0

    for line_number, raw_line in enumerate(source.splitlines(), start=1):
        stripped_line = _strip_comment(raw_line)
        if not stripped_line:
            continue

        labels, instruction_text = _extract_labels(stripped_line)

        for label in labels:
            normalized_label = _normalize_label(label)
            if normalized_label in label_map:
                raise ValueError(f"Line {line_number}: Duplicate label: {label}")
            label_map[normalized_label] = current_address

        if not instruction_text:
            continue

        try:
            parsed_instruction = _parse_instruction(instruction_text)
        except ValueError as exc:
            _wrap_line_error(line_number, exc)

        instructions.append(
            ProgramInstruction(
                address=current_address,
                line_number=line_number,
                parsed=parsed_instruction,
            )
        )
        current_address += 1

    return instructions, label_map


def assembleInstruction(instruction_str):
    stripped_line = _strip_comment(instruction_str)
    if not stripped_line:
        return None

    _, instruction_text = _extract_labels(stripped_line)
    if not instruction_text:
        return None

    parsed_instruction = _parse_instruction(instruction_text)
    return _assemble_parsed_instruction(parsed_instruction)


def assembleProgram(source):
    instructions, label_map = _collect_program(source)
    assembled_lines = []

    for program_instruction in instructions:
        try:
            assembled_lines.append(
                _assemble_parsed_instruction(
                    program_instruction.parsed,
                    labels=label_map,
                    current_address=program_instruction.address,
                )
            )
        except ValueError as exc:
            _wrap_line_error(program_instruction.line_number, exc)

    return "\n".join(assembled_lines)
    
print(assembleInstruction("MOVI -10, R13"))
