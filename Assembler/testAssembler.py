from assembler import assembleInstruction

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