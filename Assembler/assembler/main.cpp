#include "tokenizer.h"
#include <iostream>
#include <string>
#include <fstream>
#include <unordered_map>


void printInstructions(const std::vector<Instruction>& instructions) {
    for (const auto& instruction : instructions) {
        // Print labels associated with this instruction
        if (!instruction.labels.empty()) {
            std::cout << "Labels: ";
            for (const auto& lbl : instruction.labels) {
                std::cout << lbl << " ";
            }
            std::cout << "\n";
        }

        // Print instruction tokens
        std::cout << "Instruction tokens: ";
        for (const auto& t : instruction.tokens) {
            std::cout << "[" << t.text 
                    << " (file: " << t.filename 
                    << ", line " << t.lineNum 
                    << ", offset " << t.offset << ")] ";
        }
        std::cout << "\n\n";
    }
}


void writeHexToFile(const std::vector<std::string>& hexForm, const std::string& filename) {
    std::ofstream outFile(filename);
    if (!outFile) {
        std::cerr << "ERROR: Could not open file " << filename << " for writing.\n";
        return;
    }

    for (const auto& line : hexForm) {
        outFile << line << "\n";
    }

    outFile.close();
    std::cout << "Wrote " << hexForm.size() << " instructions to " << filename << std::endl;
}

int main(int argc, char* argv[]) {
    std::unordered_map<std::string, Macro> macros;
    std::vector<std::vector<Token>> lines = tokenizeFile(argv[1], macros);
    expandMacros(lines, macros);
    seperateLinesContainingMultipleInstructions(lines);
    std::vector<Instruction> instructions = preprocessLabels(lines);
    validateInstructions(instructions);
    resolveLabelsAndExpandGoif(instructions);
    resolveImmediateValues(instructions);
    std::vector<std::string> hexForm = instructionsToHex(instructions);
    writeHexToFile(hexForm, "instructions.bin");
}

