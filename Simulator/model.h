#ifndef MODEL_H
#define MODEL_H
#include <stdint.h>
#include <string>

class Model
{
public:
    Model(const std::string& filepath);
    Model();
    ~Model();
    Model(const Model& other);
    Model& operator=(const Model& other);
    void initMemory(const std::string& filepath);

    typedef struct {
        uint16_t x, y;
        uint8_t width, height;
        uint16_t color;
    } Rectangle;

    bool tick();
    void setLeftButtonPlayerOne(bool leftButton);
    void setRightButtonPlayerOne(bool rightButton);
    void setJumpButtonPlayerOne(bool jumpButton);
    void setLeftButtonPlayerTwo(bool leftButton);
    void setRightButtonPlayerTwo(bool rightButton);
    void setJumpButtonPlayerTwo(bool jumpButton);

    void setResetButton(bool resetButton);
    void setVSync(bool vsync);
    Rectangle getRectangle(unsigned int index);
    uint16_t getPlayerOneX();
    uint16_t getPlayerOneY();
    uint16_t getPlayerOneAnimationIndex();
    uint16_t getPlayerOneScore();
    uint16_t getPlayerOneAudioPitch();
    uint16_t getPlayerOneBackgroundIndex();
    uint16_t getPlayerTwoX();
    uint16_t getPlayerTwoY();
    uint16_t getPlayerTwoAnimationIndex();
    uint16_t getPlayerTwoScore();
    uint16_t getPlayerTwoAudioPitch();
    uint16_t getPlayerTwoBackgroundIndex();
    uint16_t* memory; // 65536 spots.
    uint16_t registers[16];
    uint16_t programCounter;
    bool cFlag, lFlag, fFlag, zFlag, nFlag;
    bool readNextCycle;
    uint8_t readReg;

private:
    bool leftButtonPlayerOne;
    bool rightButtonPlayerOne;
    bool jumpButtonPlayerOne;
    bool leftButtonPlayerTwo;
    bool rightButtonPlayerTwo;
    bool jumpButtonPlayerTwo;

    bool resetButton;
    bool vsync;
    void initialize();
    static constexpr uint8_t NOP   = 0b00000000;
    static constexpr uint8_t AND   = 0b00000001;
    static constexpr uint8_t OR    = 0b00000010;
    static constexpr uint8_t XOR   = 0b00000011;
    static constexpr uint8_t NOT   = 0b00000100;
    static constexpr uint8_t ADD   = 0b00000101;
    static constexpr uint8_t ADDU  = 0b00000110;
    static constexpr uint8_t ADDC  = 0b00000111;
    static constexpr uint8_t SUB   = 0b00001001;
    static constexpr uint8_t CMP   = 0b00001011;
    static constexpr uint8_t LSH   = 0b10000100;
    static constexpr uint8_t ARSH  = 0b10000110;
    static constexpr uint8_t LOAD  = 0b01000000;
    static constexpr uint8_t STOR  = 0b01000100;
    static constexpr uint8_t MOV   = 0b00001101;
    static constexpr uint8_t JCOND = 0b01001100;
    static constexpr uint8_t JAL   = 0b01001000;
    static constexpr uint8_t READ  = 0b00001111;

    static constexpr uint8_t ADDI_UPPER  = 0b0101;
    static constexpr uint8_t ADDUI_UPPER = 0b0110;
    static constexpr uint8_t ADDCI_UPPER = 0b0111;
    static constexpr uint8_t SUBI_UPPER  = 0b1001;
    static constexpr uint8_t CMPI_UPPER  = 0b1011;
    static constexpr uint8_t MOVI_UPPER  = 0b1101;
    static constexpr uint8_t BCOND_UPPER = 0b1100;
    static constexpr uint8_t LSH_RSH_ARSH_UPPER = 0b1000;
};

#endif // MODEL_H
