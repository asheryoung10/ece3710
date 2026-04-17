#include "model.h"
#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>
#include <QElapsedTimer>


Model::Model(const std::string& filepath) {
    memory = new uint16_t[1 << 16];
    initialize();
    initMemory(filepath);
}

Model::Model() {
    memory = new uint16_t[1 << 16];
    initialize();
}

void Model::setP1Left(bool pressed)  { p1Left  = pressed; }
void Model::setP1Right(bool pressed) { p1Right = pressed; }
void Model::setP1Up(bool pressed)    { p1Up    = pressed; }
void Model::setP1Down(bool pressed)  { p1Down  = pressed; }

void Model::setP2Left(bool pressed)  { p2Left  = pressed; }
void Model::setP2Right(bool pressed) { p2Right = pressed; }
void Model::setP2Up(bool pressed)    { p2Up    = pressed; }
void Model::setP2Down(bool pressed)  { p2Down  = pressed; }

void Model::setP3Left(bool pressed)  { p3Left  = pressed; }
void Model::setP3Right(bool pressed) { p3Right = pressed; }
void Model::setP3Up(bool pressed)    { p3Up    = pressed; }
void Model::setP3Down(bool pressed)  { p3Down  = pressed; }

void Model::setP4Left(bool pressed)  { p4Left  = pressed; }
void Model::setP4Right(bool pressed) { p4Right = pressed; }
void Model::setP4Up(bool pressed)    { p4Up    = pressed; }
void Model::setP4Down(bool pressed)  { p4Down  = pressed; }
void Model::setStartDown(bool pressed)  { start  = pressed; }
void Model::setSelectDown(bool pressed)  { select  = pressed; }

void Model::setResetButton(bool reset) {
    resetButton = reset;
    tick();
}

void Model::setVSync(bool vsyncVal) {
        if (vsync && !vsyncVal) {
            // Falling edge = one frame occurred

            qint64 now = vsyncTimer.elapsed();
            qint64 delta = now - lastFrameMs;
            lastFrameMs = now;

            if (delta > 0) {
                fps = 1000 / delta;  // ms → FPS
            }
        }
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
uint16_t Model::getPlayerX(int playerIndex) {
    uint16_t base = 0xC000 + playerIndex * 4;
    return memory[base + 0];
}

uint16_t Model::getPlayerY(int playerIndex) {
    uint16_t base = 0xC000 + playerIndex * 4;
    return memory[base + 1];
}

uint16_t Model::getPlayerAnimationIndex(int playerIndex) {
    uint16_t base = 0xC000 + playerIndex * 4;
    return memory[base + 2];
}

uint16_t Model::getPlayerHighlightColor(int playerIndex) {
    uint16_t base = 0xC000 + playerIndex * 4;
    return memory[base + 3];
}

uint16_t Model::getBackgroundOffsetX() {
    return memory[0xC010];
}
uint16_t Model::getBackgroundOffsetY() {
    return memory[0xC011];
}
uint16_t Model::getAudioPitchIndex() {
    return memory[0xC012];
}

uint16_t Model::getPlayerScale(int playerIndex) {
return memory[0xC013 + playerIndex];
}
void Model::initialize() {
    vsyncTimer.start();
    lastFrameMs = vsyncTimer.elapsed();
    for(int i = 0; i < 16; i++ ) registers[i] = 0;
    programCounter = 0;
    cFlag = false;
    lFlag = false;
    fFlag = false;
    nFlag = false;
    zFlag = false;
    p1Left  = false;
    p1Right = false;
    p1Up    = false;
    p1Down  = false;

    p2Left  = false;
    p2Right = false;
    p2Up    = false;
    p2Down  = false;

    p3Left  = false;
    p3Right = false;
    p3Up    = false;
    p3Down  = false;

    p4Left  = false;
    p4Right = false;
    p4Up    = false;
    p4Down  = false;
    start = false;
    select = false;
    readReg = 0;
    readNextCycle = false;
    vsync = false;
    resetButton = false;
}

Model::~Model() {
    delete[] memory;
}
bool Model::tick() {
    if(resetButton) initialize();
    
    int32_t fullMul;
    // LSB is vsync, then right, left, jump buttons
    registers[15] =
        (p4Down << 15) |
        (p4Up   << 14) |
        (p4Right << 13) |
        (p4Left<< 12) |

        (p3Down << 11) |
        (p3Up   << 10) |
        (p3Right << 9) |
        (p3Left<<  8) |

        (p2Down <<  7) |
        (p2Up   <<  6) |
        (p2Right <<  5) |
        (p2Left<<  4) |

        (p1Down <<  3) |
        (p1Up   <<  2) |
        (p1Right <<  1) |
        (p1Left<<  0);
    registers[11] = vsync;
    registers[11] |= (start << 2) | (select << 1);

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

    case MUL: {
        fullMul = static_cast<int32_t>(sB) * static_cast<int32_t>(sA);
        registers[rd] = static_cast<uint16_t>(fullMul);

        zFlag = (registers[rd] == 0);
        nFlag = (static_cast<int16_t>(registers[rd]) < 0);

        // overflow = upper half not equal sign extension of result
        int16_t upper = static_cast<int16_t>(fullMul >> 16);
        int16_t lower = static_cast<int16_t>(registers[rd]);

        fFlag = (upper != (lower < 0 ? -1 : 0));
        cFlag = fFlag;   // or false if you don't want carry defined
        lFlag = false;

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
        case IMUL_UPPER: {
            int16_t imm = static_cast<int16_t>(static_cast<int8_t>(immediate));

            int32_t fullMul = static_cast<int32_t>(sB) * static_cast<int32_t>(imm);
            registers[rd] = static_cast<uint16_t>(fullMul);

            zFlag = (registers[rd] == 0);
            nFlag = (static_cast<int16_t>(registers[rd]) < 0);

            int16_t upper = static_cast<int16_t>(fullMul >> 16);
            int16_t lower = static_cast<int16_t>(registers[rd]);

            fFlag = (upper != (lower < 0 ? -1 : 0));
            cFlag = fFlag;
            lFlag = false;

            programCounter++;
            break;
        }
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
            case 0b0010: {
                uint16_t bits5 = A & 0x1F;

                // sign-extend 5-bit to 32-bit signed integer
                int32_t shiftAmount = (bits5 << 27) >> 27;

                int32_t value = static_cast<int16_t>(registers[rd]);

                if (shiftAmount >= 0) {
                    registers[rd] = static_cast<uint16_t>(value << shiftAmount);
                } else {
                    registers[rd] = static_cast<uint16_t>(value >> (-shiftAmount)); // arithmetic right shift
                }

                break;
            }
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
