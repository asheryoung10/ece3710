#include <vector>
#include <string>

struct Token {
    std::string text;
    std::string filename;
    size_t lineNum;
    size_t offset;
};

struct Instruction {
    std::vector<Token> tokens;       // The actual instruction tokens
    std::vector<std::string> labels; // All labels associated with this instruction
    size_t lineNum;                  // Line number of first token
};

std::vector<std::vector<Token>> tokenizeFile(const std::string& filename);
void seperateLinesContainingMultipleInstructions(std::vector<std::vector<Token>>& lines);

std::vector<Instruction> preprocessLabels(const std::vector<std::vector<Token>>& lines);
void validateInstructions(const std::vector<Instruction>& instructions);

void resolveLabelsAndExpandGoif(std::vector<Instruction>& instructions);

void resolveImmediateValues(std::vector<Instruction>& instructions);

std::vector<std::string> instructionsToHex(const std::vector<Instruction>& instructions);