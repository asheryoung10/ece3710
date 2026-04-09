#include "model.h"
#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>


Model::Model(const std::string& filepath) {
    memory = new uint16_t[1 << 16];
    initialize();
    initMemory(filepath);
}

Model::Model() {
    memory = new uint16_t[1 << 16];
    initialize();
}

void Model::setLeftButton(bool left) {
    leftButton = left;
}

void Model::setRightButton(bool right) {
    rightButton = right;
}

void Model::setJumpButton(bool jump) {
    jumpButton = jump;
}

void Model::setResetButton(bool reset) {
    resetButton = reset;
    tick();
}

void Model::setVSync(bool vsyncVal) {
    vsync = vsyncVal;
}

void Model::initMemory(const std::string& filepath) {
    memset(memory, 0, (1 << 16) * sizeof(uint16_t));
    initialize();
    std::ifstream file(filepath);
    if (!file) {
        std::cerr << "Failed to open file: " << filepath << std::endl;
        return;
    }

    std::string line;
    size_t addr = 0; // use size_t to avoid overflow

    while (std::getline(file, line)) {
        if (addr >= (1 << 16)) break; // stop if memory full

        // Remove whitespace
        line.erase(std::remove_if(line.begin(), line.end(), ::isspace), line.end());

        if (line.empty()) continue;

        // Parse hex string into uint16_t
        uint16_t value = 0;
        std::stringstream ss(line);
        ss >> std::hex >> value;

        memory[addr++] = value;
    }

    std::cout << "Loaded " << addr << " words into memory." << std::endl;
}

Model::Model(const Model& other) {
    memory = new uint16_t[1 << 16];
    std::copy(other.memory, other.memory + (1 << 16), memory);
    std::copy(std::begin(other.registers), std::end(other.registers), std::begin(registers));
    programCounter = other.programCounter;
    cFlag = other.cFlag;
    lFlag = other.lFlag;
    fFlag = other.fFlag;
    nFlag = other.nFlag;
    zFlag = other.zFlag;
}

Model& Model::operator=(const Model& other) {
    if (this != &other) { // prevent self-assignment
        std::copy(other.memory, other.memory + (1 << 16), memory);
        std::copy(std::begin(other.registers), std::end(other.registers), std::begin(registers));
        programCounter = other.programCounter;
        cFlag = other.cFlag;
        lFlag = other.lFlag;
        fFlag = other.fFlag;
        nFlag = other.nFlag;
        zFlag = other.zFlag;
    }
    return *this;
}
Model::Rectangle Model::getRectangle(unsigned int index) {
    Rectangle rectangle = {};
    uint32_t rectangleOffset = (1<<15) + index*4;
    rectangle.x = memory[rectangleOffset + 0];
    rectangle.y = memory[rectangleOffset + 1];
    rectangle.width  = (memory[rectangleOffset + 2] >> 8) & 0xFF;
    rectangle.height = memory[rectangleOffset + 2] & 0xFF;
    rectangle.color = memory[rectangleOffset + 3];
    return rectangle;
}
uint16_t Model::getPlayerOneX() {
    return memory[0xC000];
}
uint16_t Model::getPlayerOneY(){
    return memory[0xC002];
}
uint16_t Model::getPlayerOneAnimationIndex(){
    return memory[0xC004];
}
uint16_t Model::getPlayerOneScore(){
    return memory[0xC00a];
}
uint16_t Model::getPlayerOneAudioPitch(){
    return memory[0xC008];
}
uint16_t Model::getPlayerOneBackgroundIndex(){
    return memory[0xC006];
}
uint16_t Model::getPlayerTwoX(){
    return memory[0xC001];
}
uint16_t Model::getPlayerTwoY(){
    return memory[0xC003];
}
uint16_t Model::getPlayerTwoAnimationIndex(){
    return memory[0xC005];
}
uint16_t Model::getPlayerTwoScore(){
    return memory[0xC00b];
}
uint16_t Model::getPlayerTwoAudioPitch(){
    return memory[0xC009];
}
uint16_t Model::getPlayerTwoBackgroundIndex(){
    return memory[0xC007];
}
void Model::initialize() {
    for(int i = 0; i < 16; i++ ) registers[i] = 0;
    programCounter = 0;
    cFlag = false;
    lFlag = false;
    fFlag = false;
    nFlag = false;
    zFlag = false;
    leftButton = false;
    rightButton = false;
    jumpButton = false;
    readReg = 0;
    readNextCycle = false;
    vsync = false;
    resetButton = false;
    for(int i = 0; i < 16; i++) {
        uint16_t rectOffset = (1<<15) + i*4;
        memory[rectOffset + 0] = i;
        memory[rectOffset + 1] = i*32;
        memory[rectOffset + 2] = 0x2020;
        memory[rectOffset + 3] = i * 0x1111;
    }
}

Model::~Model() {
    delete[] memory;
}
bool Model::tick() {
    if(resetButton) initialize();
    

    // LSB is vsync, then right, left, jump buttons
    registers[15] = (jumpButton << 3) | (leftButton << 2) | (rightButton << 1) | vsync;

    uint16_t instruction = memory[programCounter];
    uint8_t opcodeUpper = (instruction >> 12);
    uint8_t opcodeCombined = ((instruction >> 12) << 4) | ((instruction >> 4) & 0x0F);
    uint8_t immediate = ((instruction << 8) >> 8);

    if(readNextCycle) {
        registers[readReg] = instruction;        
        readNextCycle = false;
        programCounter++;
        return true;
    }
    uint8_t rd = (instruction >> 8) & 0x0F;
    uint8_t rs = (instruction) & 0x0F;
    uint16_t A = registers[rs];
    uint16_t B = registers[rd];

    int16_t sA = static_cast<int16_t>(A);
    int16_t sB = static_cast<int16_t>(B);
    int shift_amt;

    switch(opcodeCombined) {
    case JAL:
        registers[rd] = programCounter+1;
        programCounter = A;
        break;
    case NOP:
        return false;

    case AND:
        registers[rd] = B & A;
        programCounter++;
        break;
    case OR:
        registers[rd] = B | A;
        programCounter++;
        break;
    case XOR:
        registers[rd] = B ^ A;
        programCounter++;
        break;
    case NOT:
        registers[rd] = ~A;
        programCounter++;
        break;

    case ADD: {
        int16_t res = sB + sA;
        registers[rd] = uint16_t(res);
        zFlag = (res == 0);
        fFlag = ((sB >= 0 && sA >= 0 && res < 0) || (sB < 0 && sA < 0 && res >= 0));
        nFlag = sB < sA;
        cFlag = false;
        programCounter++;
        break;
    }

    case ADDU: {
        uint32_t res = uint32_t(B) + uint32_t(A);
        registers[rd] = uint16_t(res);
        cFlag = res > 0xFFFF;
        lFlag = B < A;
        fFlag = false;
        zFlag = (registers[rd] == 0);
        nFlag = false;
        programCounter++;
        break;
    }

    case ADDC: {
        uint32_t res = (cFlag ? 1 : 0) + sB + sA;
        registers[rd] = uint16_t(res);
        fFlag = ((sB >= 0 && sA >= 0 && registers[rd] < 0) || (sB < 0 && sA < 0 && registers[rd] >= 0));
        programCounter++;
        break;
    }

    case SUB: {
        int16_t res = sB - sA;
        registers[rd] = uint16_t(res);
        zFlag = (res == 0);
        fFlag = ((sB >= 0 && sA < 0 && res < 0) || (sB < 0 && sA >= 0 && res >= 0));
        nFlag = sB < sA;
        cFlag = false;
        programCounter++;
        break;
    }

    case CMP: {
        zFlag = (sB == sA);
        lFlag = B < A;
        nFlag = sB < sA;
        programCounter++;
        break;
    }

    case LSH: {
        shift_amt = sA;
        registers[rd] = (shift_amt >= 0) ? (B << shift_amt) : (B >> -shift_amt);
        programCounter++;
        break;
    }

    case ARSH: {
        shift_amt = sA;
        registers[rd] = (shift_amt >= 0) ? (uint16_t(sB) >> shift_amt) : (uint16_t(sB) << -shift_amt);
        programCounter++;
        break;
    }

    case LOAD:
        registers[rd] = memory[A];
        programCounter++;
        break;
    case STOR:
        memory[A] = registers[rd];
        programCounter++;
        break;
    case MOV:
        registers[rd] = A;
        programCounter++;
        break;
    case JCOND: {
        // Lower 4 bits of instruction = condition
        bool takeBranch = false;

switch (rd) {
    case 0b0000: takeBranch = zFlag; break;            // EQ (Zero flag)
    case 0b0001: takeBranch = !zFlag; break;           // NE (Not Zero)
    case 0b0010: takeBranch = cFlag; break;            // CS (Carry Set)
    case 0b0011: takeBranch = !cFlag; break;           // CC (Carry Clear)
    case 0b0100: takeBranch = lFlag; break;  // HI (Higher - no lower and no zero)
    case 0b0101: takeBranch = !lFlag; break;   // LS (Lower or zero)
    case 0b0110: takeBranch = nFlag ; break;  // GT (Greater than - signed)
    case 0b0111: takeBranch = !nFlag; break;   // LE (Less than or equal - signed)
    case 0b1000: takeBranch = fFlag; break;            // FS (Flag Set)
    case 0b1001: takeBranch = !fFlag; break;           // FC (Flag Clear)
    case 0b1010: takeBranch = !lFlag && !zFlag; break;            // LO (Lower - signed)
    case 0b1011: takeBranch = lFlag || zFlag; break;   // HS (Higher or same - signed)
    case 0b1100: takeBranch = !nFlag && !zFlag; break;  // LT (Less Than - signed, both N and Z must be 0)
    case 0b1101: takeBranch = nFlag || zFlag; break;   // GE (Greater or equal - signed, either N or Z must be 1)
    case 0b1110: takeBranch = true; break;             // UC (Unconditional)
    default: takeBranch = false; break;                // Default (no branch)
}
        if(takeBranch)
            programCounter = A;
        else
            programCounter++;

        break;
    }

    case READ: {
        readReg = rd;
        readNextCycle = true;
        programCounter++;
        break;
    }
    default: {
        A = immediate;
        int16_t sA = static_cast<int16_t>(static_cast<int8_t>(immediate));
        switch(opcodeUpper) {
        case ADDI_UPPER: {
            int16_t res = sB + sA;
            registers[rd] = uint16_t(res);
            zFlag = (res == 0);
            fFlag = ((sB >= 0 && sA >= 0 && res < 0) || (sB < 0 && sA < 0 && res >= 0));
            nFlag = sB < sA;
            cFlag = false;
            programCounter++;
            break;
        }
        case ADDUI_UPPER: {
            uint32_t res = uint32_t(B) + uint32_t(A);
            registers[rd] = uint16_t(res);
            cFlag = res > 0xFFFF;
            lFlag = B < A;
            fFlag = false;
            zFlag = (registers[rd] == 0);
            nFlag = false;
            programCounter++;
            break;
        }
        case ADDCI_UPPER: {
            uint32_t res = (cFlag ? 1 : 0) + sB + sA;
            registers[rd] = uint16_t(res);
            fFlag = ((sB >= 0 && sA >= 0 && registers[rd] < 0) || (sB < 0 && sA < 0 && registers[rd] >= 0));
            programCounter++;
            break;
        }
        case SUBI_UPPER: {
            int16_t res = sB - sA;
            registers[rd] = uint16_t(res);
            zFlag = (res == 0);
            fFlag = ((sB >= 0 && sA < 0 && res < 0) || (sB < 0 && sA >= 0 && res >= 0));
            nFlag = sB < sA;
            cFlag = false;
            programCounter++;
            break;
        }
        case CMPI_UPPER: {
            zFlag = (sB == sA);
            lFlag = B < A;
            nFlag = sB < sA;
            programCounter++;
            break;
        }
        case MOVI_UPPER:
            registers[rd] = sA;
            programCounter++;
            break;
        case BCOND_UPPER: {
            // Lower 4 bits of instruction = condition
            bool takeBranch = false;

switch (rd) {
    case 0b0000: takeBranch = zFlag; break;            // EQ (Zero flag)
    case 0b0001: takeBranch = !zFlag; break;           // NE (Not Zero)
    case 0b0010: takeBranch = cFlag; break;            // CS (Carry Set)
    case 0b0011: takeBranch = !cFlag; break;           // CC (Carry Clear)
    case 0b0100: takeBranch = lFlag; break;  // HI (Higher - no lower and no zero)
    case 0b0101: takeBranch = !lFlag; break;   // LS (Lower or zero)
    case 0b0110: takeBranch = nFlag ; break;  // GT (Greater than - signed)
    case 0b0111: takeBranch = !nFlag; break;   // LE (Less than or equal - signed)
    case 0b1000: takeBranch = fFlag; break;            // FS (Flag Set)
    case 0b1001: takeBranch = !fFlag; break;           // FC (Flag Clear)
    case 0b1010: takeBranch = !lFlag && !zFlag; break;            // LO (Lower - signed)
    case 0b1011: takeBranch = lFlag || zFlag; break;   // HS (Higher or same - signed)
    case 0b1100: takeBranch = !nFlag && !zFlag; break;  // LT (Less Than - signed, both N and Z must be 0)
    case 0b1101: takeBranch = nFlag || zFlag; break;   // GE (Greater or equal - signed, either N or Z must be 1)
    case 0b1110: takeBranch = true; break;             // UC (Unconditional)
    default: takeBranch = false; break;                // Default (no branch)
}
            if(takeBranch) {
                int16_t branchOffset = static_cast<int8_t>(immediate); // cast preserves sign
                programCounter = programCounter + branchOffset;
            }else
                programCounter++;

            break;
        }

        case LSH_RSH_ARSH_UPPER: {
            switch(opcodeCombined & 0b1110) {
            case 0b0000: {
                // Step 1: get lower 5 bits
                uint16_t bits5 = A & 0x1F;  // mask lower 5 bits

                // Step 2: interpret as signed 5-bit 2's complement
                int8_t shiftAmount = bits5;       // copy to signed 8-bit
                if (shiftAmount & 0x10) {         // if highest bit (bit 4) is 1
                    shiftAmount |= 0xE0;          // sign extend to 8 bits (fill upper 3 bits with 1)
                }

                // Step 3: shift B
                if (shiftAmount >= 0) {
                    registers[rd] = B << shiftAmount;
                } else {
                    registers[rd] = B >> (-shiftAmount);
                }
                break;
            }
            case 0b1000:
                registers[rd] = B >> (A & 0xF);
                break;
            case 0b1010:
                registers[rd] = B >> (A & 0xF);
                break;
            case 0b0010:
                registers[rd] = uint16_t(int16_t(B) >> (A & 0xF));
                break;
            default:
                std::cout << "Unknown shift opcode" << std::endl;
                return false;
            }
            programCounter++;
            break;
        }

        default:
            std::cout << "Unknown opcode: 0x"
                      << std::hex << static_cast<int>(opcodeCombined) << std::endl;
            std::cout << "Instruction: 0x"
                      << std::hex << static_cast<int>(instruction) << std::endl;
            std::cout << "Program Counter: 0x"
                      << programCounter << std::endl;
            return false;
        }
        break;
    }
    }
    return true;
}
