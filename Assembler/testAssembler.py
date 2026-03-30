import unittest

from assembler import assembleInstruction, assembleProgram


SINGLE_INSTRUCTION_CASES = [
    ("ADD R0, R1", "0150"),
    ("ADDI 0x2A, R5", "552A"),
    ("SUB R2, R3", "0392"),
    ("SUBI 0x05, R10", "9A05"),
    ("MUL R4, R5", "05E4"),
    ("MULI 0x12, R8", "E812"),
    ("AND R6, R7", "0716"),
    ("ANDI 0xFF, R1", "11FF"),
    ("OR R8, R9", "0928"),
    ("XOR R11, R12", "0C3B"),
    ("MOV R1, R2", "02D1"),
    ("MOVI 0x7F, R4", "D47F"),
    ("LSH R2, R3", "8342"),
    ("LUI 0xAB, R10", "FAAB"),
    ("LOAD R1, R2", "4102"),
    ("STOR R3, R4", "4344"),
    ("BEQ 0x10", "C010"),
    ("JAL R1, R2", "4182"),
    ("TBIT 5, R1", "41A5"),
    ("DI", "4030"),
    ("EI", "4070"),
    ("RETX", "4090"),
    ("WAIT", "0000"),
    ("ADD R1, R2", "0251"),
    ("ADDU R15, R0", "006F"),
    ("SUB R5, R6", "0695"),
    ("CMP R3, R4", "04B3"),
    ("AND R10, R11", "0B1A"),
    ("XOR R7, R8", "0837"),
    ("ADDI 0x12, R1", "5112"),
    ("SUBI 0x7F, R2", "927F"),
    ("CMPI 0x01, R9", "B901"),
    ("ANDI 0x55, R4", "1455"),
    ("MOVI 0xAA, R13", "DDAA"),
    ("BEQ 0x20", "C020"),
    ("BNE 0x15", "C115"),
    ("BCS 0x04", "C204"),
    ("BGT 0xFE", "C6FE"),
    ("BLE 0x00", "C700"),
    ("BLT 0x10", "CC10"),
    ("BGE 0x10", "CD10"),
    ("BUC 0x77", "CE77"),
    ("JEQ R5", "40C5"),
    ("JNE R1", "41C1"),
    ("JUC R15", "4ECF"),
    ("LOAD R1, R2", "4102"),
    ("STOR R10, R11", "4A4B"),
    ("JAL R14, R15", "4E8F"),
    ("LUI 0xAB, R4", "F4AB"),
    ("LSH 5, R1", "8145"),
    ("TBIT 12, R6", "46AC"),
    ("TBITI 0x03, R0", "40E3"),
    ("SUB R5, R2", "0295"),
    ("AND R4, R6", "0614"),
    ("OR R8, R15", "0F28"),
    ("XOR R1, R0", "0031"),
    ("MOV R3, R7", "07D3"),
    ("ADDI 0xA5, R1", "51A5"),
    ("SUBI 0x0F, R2", "920F"),
    ("ANDI 0x33, R4", "1433"),
    ("MOVI 0xAA, R5", "D5AA"),
    ("BEQ 0x1F", "C01F"),
    ("BNE 0x2A", "C12A"),
    ("BLT 0x05", "CC05"),
    ("BGE 0x08", "CD08"),
    ("BUC 0x30", "CE30"),
    ("JGT R5", "46C5"),
    ("JHI R2", "44C2"),
    ("JHS R9", "4BC9"),
]


class TestAssembler(unittest.TestCase):
    def test_single_instruction_regressions(self):
        for instruction, expected in SINGLE_INSTRUCTION_CASES:
            with self.subTest(instruction=instruction):
                self.assertEqual(assembleInstruction(instruction), expected)

    def test_raw_branch_forms(self):
        self.assertEqual(assembleInstruction("BCOND EQ, 0x10"), "C010")
        self.assertEqual(assembleInstruction("BCOND NE, -1"), "C1FF")
        self.assertEqual(assembleInstruction("JCOND EQ, R5"), "40C5")
        self.assertEqual(assembleInstruction("JCOND UC, R15"), "4ECF")

    def test_hash_prefixed_immediates(self):
        self.assertEqual(assembleInstruction("ADDI #10, R1"), "510A")

    def test_assemble_program_matches_current_init_mem_sample(self):
        program = """
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

        expected = "\n".join(
            [
                "D001",
                "800F",
                "D164",
                "4140",
                "D001",
                "800E",
                "D164",
                "4140",
                "D001",
                "D201",
                "800E",
                "0022",
                "D164",
                "4140",
                "0000",
            ]
        )

        self.assertEqual(assembleProgram(program), expected)

    def test_assemble_program_supports_comments_and_forward_labels(self):
        program = """
            // initialize and branch forward
            start: MOVI 0x01, R0
            BEQ done // done is two instructions ahead
            ADD R0, R1
            done: WAIT
        """

        expected = "\n".join(
            [
                "D001",
                "C002",
                "0150",
                "0000",
            ]
        )

        self.assertEqual(assembleProgram(program), expected)

    def test_assemble_program_supports_backward_labels(self):
        program = """
            loop: ADD R0, R1
            BUC loop
        """

        self.assertEqual(assembleProgram(program), "0150\nCEFF")

    def test_assemble_program_supports_raw_bcond_with_label(self):
        program = """
            start: MOVI 0x01, R0
            BCOND EQ, done
            ADD R0, R1
            done: WAIT
        """

        self.assertEqual(assembleProgram(program), "D001\nC002\n0150\n0000")

    def test_undefined_label_raises(self):
        with self.assertRaisesRegex(ValueError, r"Line 1: Unknown label: missing"):
            assembleProgram("BEQ missing")

    def test_duplicate_label_raises(self):
        program = """
            loop: WAIT
            loop: WAIT
        """

        with self.assertRaisesRegex(ValueError, r"Line 3: Duplicate label: loop"):
            assembleProgram(program)

    def test_out_of_range_branch_raises(self):
        filler = "\n".join("WAIT" for _ in range(128))
        program = f"BEQ far\n{filler}\nfar: WAIT"

        with self.assertRaisesRegex(ValueError, r"Line 1: Branch displacement 129 is out of range"):
            assembleProgram(program)

    def test_raw_branch_without_condition_raises(self):
        with self.assertRaisesRegex(ValueError, r"Invalid condition code: 5"):
            assembleInstruction("BCOND 5")


if __name__ == "__main__":
    unittest.main()
