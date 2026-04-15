#include <unordered_set>
#include <fstream>
#include <iostream>
#include <vector>
#include <unordered_map>
#include <iomanip>
#include <sstream>
#include <stdint.h>

#include "tokenizer.h"

std::vector<Token> tokenizeLine(const std::string& line, const std::string& filename, size_t lineNum) {
    std::vector<Token> tokens;
    size_t i = 0;
    size_t len = line.size();

    while (i < len) {
        // Skip whitespace
        while (i < len && (line[i] == ' ' || line[i] == '\t')) i++;
        if (i >= len) break;

        size_t start = i;

        // Token ends at next whitespace
        while (i < len && line[i] != ' ' && line[i] != '\t') i++;
        size_t end = i;

        if (start != end) {  // only push non-empty tokens
            std::string tokenStr = line.substr(start, end - start);
            tokens.push_back({tokenStr, filename, lineNum, start});
        }
    }

    return tokens;
}

std::vector<std::vector<Token>> tokenizeFileInternal(
    const std::string& filename,
    std::unordered_set<std::string>& includedFiles,
    std::unordered_map<std::string, Macro>& macros) {

    std::vector<std::vector<Token>> tokens;

    // If we have already scanned this file, then don't rescan it.
    if(includedFiles.find(filename) != includedFiles.end()) return tokens;
    includedFiles.insert(filename);

    // Attempt to open the file
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Error opening file: " << filename << std::endl;
        return tokens;
    }

    std::string line;
    size_t lineNum = 1;

    while(std::getline(file, line)) {
        if (!line.empty() && line.back() == '\r')
            line.pop_back();
        // Ignore anything in the line after a comment
        size_t commentPos = line.find("//");
        if(commentPos != std::string::npos) line = line.substr(0,commentPos);

        // Detect if the modified line is just whitespace
        bool onlyWhiteSpace = true;
        for(char c : line) {
            if(!(c == ' ' || c == '\t')) {
                onlyWhiteSpace = false;
                break;
            }
        }

        // Ignore the line if its just whitespace
        if(onlyWhiteSpace) {
            lineNum++;
            continue;
        }

        std::string trimmed = line;
        trimmed.erase(0, trimmed.find_first_not_of(" \t")); // left-trim
        if (trimmed.rfind("#include", 0) == 0) {
            size_t quote1 = trimmed.find('"');
            size_t quote2 = trimmed.find('"', quote1 + 1);
            if (quote1 != std::string::npos && quote2 != std::string::npos) {
                std::string includeFile = trimmed.substr(quote1 + 1, quote2 - quote1 - 1);
                auto includeLines = tokenizeFileInternal(includeFile, includedFiles, macros);
                tokens.insert(tokens.end(), includeLines.begin(), includeLines.end());
            }else {
                std::cerr << "ERROR: Missing qoutations marks around include filepath." << std::endl;
                std::cerr << "\t Looks like: \"" << line << "\"" << std::endl; 
                std::cerr << "\t In file: " << filename << std::endl;
                std::cerr << "\t On line: " << lineNum << std::endl;
                exit(0);
            }
            lineNum++;
            continue;
        }
        if (trimmed.rfind("#define", 0) == 0) {

            size_t nameStart = trimmed.find(' ') + 1;

            size_t parenOpen = trimmed.find('(', nameStart);

            std::string macroName;
            std::vector<std::string> params;
            std::string bodyStr;

            // -----------------------------
            // CASE 1: function-like macro
            // -----------------------------
            if (parenOpen != std::string::npos) {

                size_t parenClose = trimmed.find(')', parenOpen);
                if (parenClose == std::string::npos) {
                    std::cerr << "ERROR: Missing ')' in macro definition\n";
                    exit(1);
                }

                macroName = trimmed.substr(nameStart, parenOpen - nameStart);

                // Parse parameters
                std::string paramStr =
                    trimmed.substr(parenOpen + 1, parenClose - parenOpen - 1);

                std::stringstream ss(paramStr);
                std::string param;

                while (std::getline(ss, param, ',')) {
                    param.erase(0, param.find_first_not_of(" \t"));
                    param.erase(param.find_last_not_of(" \t") + 1);
                    if (!param.empty())
                        params.push_back(param);
                }

                // Body after ')'
                bodyStr = trimmed.substr(parenClose + 1);
            }

            // -----------------------------
            // CASE 2: simple macro (no params)
            // -----------------------------
            else {

                size_t nameEnd = trimmed.find(' ', nameStart);
                if (nameEnd == std::string::npos) {
                    std::cerr << "ERROR: Missing macro body\n";
                    exit(1);
                }

                macroName = trimmed.substr(nameStart, nameEnd - nameStart);
                bodyStr = trimmed.substr(nameEnd + 1);
            }

            // -----------------------------
            // Tokenize body
            // -----------------------------
            auto bodyTokens = tokenizeLine(bodyStr, filename, lineNum);

            Macro m;
            m.params = params;
            m.body.push_back(bodyTokens);

            macros[macroName] = m;


            lineNum++;
            continue;
        }
        auto lineTokens = tokenizeLine(line, filename, lineNum);
        if (!lineTokens.empty()) {
            tokens.push_back(lineTokens);
        }

        lineNum++;
    }

    return tokens;
}

std::vector<std::vector<Token>> tokenizeFile(const std::string& filename, std::unordered_map<std::string, Macro>& macros) {
    std::unordered_set<std::string> includedFiles;
    return tokenizeFileInternal(filename, includedFiles, macros);
}

void expandMacros(std::vector<std::vector<Token>>& lines,
                  const std::unordered_map<std::string, Macro>& macros) {

    std::vector<std::vector<Token>> expanded;

    for (auto& line : lines) {
        if (line.empty()) continue;

        std::vector<Token> newLine;

        for (size_t t = 0; t < line.size(); ++t) {
            const Token& tok = line[t];

            // Check if token is macro
            if (tok.text.size() > 1 && tok.text[0] == '%') {

                std::string call = tok.text.substr(1);

                size_t parenOpen = call.find('(');
                size_t parenClose = call.find(')');

                std::string name = call.substr(0, parenOpen);

                if (!macros.count(name)) {
                    std::cerr << "ERROR: Undefined macro: " << name << "\n";
                    exit(1);
                }

                const Macro& m = macros.at(name);

                // ----------------------------
                // Parse arguments
                // ----------------------------
                std::vector<std::string> args;

                if (parenOpen != std::string::npos && parenClose != std::string::npos) {
                    std::string argStr = call.substr(parenOpen + 1, parenClose - parenOpen - 1);
                    std::stringstream ss(argStr);
                    std::string arg;

                    while (std::getline(ss, arg, ',')) {
                        arg.erase(0, arg.find_first_not_of(" \t"));
                        arg.erase(arg.find_last_not_of(" \t") + 1);
                        args.push_back(arg);
                    }
                }

                if (args.size() != m.params.size()) {
                    std::cerr << "ERROR: Macro argument count mismatch\n";
                    exit(1);
                }

                // ----------------------------
                // INLINE EXPANSION
                // ----------------------------
                if (m.body.size() != 1) {
                    std::cerr << "ERROR: Multi-line macro used inline: " << name << "\n";
                    exit(1);
                }

                const auto& bodyLine = m.body[0];

                for (auto bodyTok : bodyLine) {
                    std::string text = bodyTok.text;

                    // Substitute params
                    for (size_t i = 0; i < m.params.size(); i++) {
                        if (text == m.params[i]) {
                            text = args[i];
                        }
                    }

                    bodyTok.text = text;
                    bodyTok.filename = tok.filename;
                    bodyTok.lineNum = tok.lineNum;
                    bodyTok.offset = tok.offset;

                    newLine.push_back(bodyTok);
                }

            } else {
                // Normal token
                newLine.push_back(tok);
            }
        }

        expanded.push_back(newLine);
    }

    lines = std::move(expanded);
}
void seperateLinesContainingMultipleInstructions(std::vector<std::vector<Token>>& lines) {
    std::vector<std::vector<Token>> expanded;

    for (const auto& line : lines) {
        std::vector<Token> currentLine;
        bool hasTokens = false;

        for (size_t idx = 0; idx < line.size(); ++idx) {
            const auto& token = line[idx];

            if (token.text == "|") {
                // If there are no tokens before the '|', it's an error
                if (currentLine.empty()) {
                    std::cerr << "ERROR: Split character '|' with no preceding tokens.\n";
                    std::cerr << "\t Looks like: \"";
                    for (const auto& t : line) std::cerr << t.text << " ";
                    std::cerr << "\"\n";
                    std::cerr << "\t In file: " << token.filename << "\n";
                    std::cerr << "\t On line: " << token.lineNum << std::endl;
                    exit(0);
                }

                // Push the current line to expanded
                expanded.push_back(currentLine);
                currentLine.clear();
            } else {
                currentLine.push_back(token);
            }
        }

        // After processing the line, if currentLine is empty but the original line ended with '|', that's an error
        if (!line.empty() && line.back().text == "|" && currentLine.empty()) {
            std::cerr << "ERROR: Split character '|' with no following tokens.\n";
            std::cerr << "\t Looks like: \"";
            for (const auto& t : line) std::cerr << t.text << " ";
            std::cerr << "\"\n";
            std::cerr << "\t In file: " << line.back().filename << "\n";
            std::cerr << "\t On line: " << line.back().lineNum << std::endl;
            exit(0);
        }

        // Add remaining tokens if any
        if (!currentLine.empty()) {
            expanded.push_back(currentLine);
        }
    }

    lines = std::move(expanded);
}

std::vector<Instruction> preprocessLabels(const std::vector<std::vector<Token>>& lines) {
    std::vector<Instruction> instructions;
    std::vector<std::string> pendingLabels; // Labels collected but not yet assigned
    size_t pendingLineNum = 0;              // Line number of the first pending label

    for (const auto& line : lines) {
        if (line.empty()) continue;

        bool lineHasLabelsOnly = true;
        bool lineHasAtLeastOneLabel = false;
        std::vector<std::string> lineLabels;

        for (const auto& token : line) {
            if (!token.text.empty() && token.text.back() == ':') {
                // Collect labels
                std::string labelName = token.text.substr(0, token.text.size() - 1);
                lineLabels.push_back(labelName);
                lineHasAtLeastOneLabel = true;

                // Remember the line number of the first label
                if (pendingLabels.empty()) pendingLineNum = token.lineNum;
            } else {
                lineHasLabelsOnly = false;
                break; // stop at first non-label token
            }
        }

        // Error: a line contains labels and instructions on the same line
        if (lineHasAtLeastOneLabel && !lineHasLabelsOnly) {
            std::cerr << "ERROR: A line cannot contain both labels and instructions.\n";
            std::cerr << "\tFile: " << line[0].filename << "\n";
            std::cerr << "\tLine: " << line[0].lineNum << "\n";
            std::cerr << "\tContent: ";
            for (const auto& token : line) {
                std::cerr << token.text << " ";
            }
            std::cerr << std::endl;
            exit(1);
        }

        if (lineHasLabelsOnly) {
            // Add line labels to pending buffer
            pendingLabels.insert(pendingLabels.end(), lineLabels.begin(), lineLabels.end());
        } else {
            // This line has an instruction; assign all pending labels to it
            Instruction inst;
            inst.labels = pendingLabels; // attach all labels seen so far
            inst.lineNum = pendingLineNum;

            // Copy all tokens on this line as the instruction
            inst.tokens = line;

            instructions.push_back(inst);


            // Clear pending labels
            pendingLabels.clear();
            pendingLineNum = 0;
        }
    }

    // Optional: warn if there are labels left without an instruction
    if (!pendingLabels.empty()) {
        std::cerr << "WARNING: Label(s) with no following instruction:\n";
        for (auto& lbl : pendingLabels) std::cerr << "  " << lbl << "\n";
        exit(1);
    }

    return instructions;
}

// ---------------- Utility Functions ----------------
bool isRegister(const std::string& token) {
    if (token.empty()) return false;
    if (token[0] != 'R' && token[0] != 'r') return false;
    try {
        int num = std::stoi(token.substr(1));
        return num >= 0 && num <= 15;
    } catch(...) { return false; }
}

bool isCondition(const std::string& token) {
    static const std::unordered_set<std::string> conds = {
        "EQ","NE","GE","HI","LS","LO","HS","GT","LE","FS","FC","LT","UC"
    };
    return conds.count(token) > 0;
}

bool isImmediateValue(const std::string& token) {
    if (token.empty()) return false;

    // Hexadecimal (0x...)
    if (token.size() > 2 && token[0]=='0' && token[1]=='x') {
        for (size_t i = 2; i < token.size(); i++) 
            if (!isxdigit(token[i])) return false;
        return true;
    }

    // Binary (0b...)
    if (token.size() > 2 && token[0]=='0' && token[1]=='b') {
        for (size_t i = 2; i < token.size(); i++) 
            if (token[i] != '0' && token[i] != '1') return false;
        return true;
    }

    // Decimal (allow optional leading + or -)
    size_t start = 0;
    if (token[0] == '-' || token[0] == '+') start = 1;
    if (start == 1 && token.size() == 1) return false; // just "-" or "+" is invalid

    for (size_t i = start; i < token.size(); i++)
        if (!isdigit(token[i])) return false;

    return true;
}

bool isLabelReference(const std::string& token, const std::unordered_set<std::string>& labels) {
    if (token.empty()) return false;
    if (token[0] != '&') return false;
    std::string labelName = token.substr(1);
    return labels.count(labelName) > 0;
}

// ---------------- Validation ----------------
void validateInstructions(const std::vector<Instruction>& instructions) {
    // Build a set of all defined labels
    std::unordered_set<std::string> allLabels;
    for (const auto& inst : instructions) {
        for (const auto& lbl : inst.labels) allLabels.insert(lbl);
    }

    // Instruction specification
    struct InstSpec { int numOperands; std::vector<char> types; };
    std::unordered_map<std::string, InstSpec> instructionSet = {
        {"ADD",{2,{'R','R'}}}, {"ADDI",{2,{'I','R'}}}, {"MUL",{2,{'R','R'}}}, {"MULI",{2,{'I','R'}}}, {"SUB",{2,{'R','R'}}},
        {"SUBI",{2,{'I','R'}}}, {"CMP",{2,{'R','R'}}}, {"CMPI",{2,{'I','R'}}},
        {"AND",{2,{'R','R'}}}, {"OR",{2,{'R','R'}}}, {"XOR",{2,{'R','R'}}},
        {"NOT",{2,{'R','R'}}}, {"LSH",{2,{'R','R'}}}, {"LSHI",{2,{'I','R'}}},
        {"ASH",{2,{'R','R'}}}, {"ASHI",{2,{'I','R'}}}, {"ARSHI",{2,{'I','R'}}},{"MOV",{2,{'R','R'}}},
        {"MOVI",{2,{'I','R'}}}, {"LOAD",{2,{'R','R'}}}, {"STOR",{2,{'R','R'}}},
        {"BCOND",{2,{'C','I'}}}, {"JCOND",{2,{'C','R'}}}, {"JAL",{2,{'R','R'}}},
        {"READ",{1,{'R'}}}, {"GOIF",{2,{'C','L'}}}, {"WAIT", {}}
    };

    for (const auto& inst : instructions) {
        if (inst.tokens.empty()) continue;

        // If this line has only one token and it is an immediate value or &label,
        // treat it as a "data instruction"
        if (inst.tokens.size() == 1) {
            const std::string& tok = inst.tokens[0].text;
            if(tok == "WAIT") continue;
            if (!isImmediateValue(tok) && !isLabelReference(tok, allLabels)) {
                std::cerr << "ERROR: Invalid data instruction '" << tok << "'\n";
                std::cerr << "\tFile: " << inst.tokens[0].filename
                          << ", Line: " << inst.tokens[0].lineNum << "\n";
                exit(1);
            }
            continue; // valid data instruction
        }

        // Otherwise, normal instruction validation
        std::string name = inst.tokens[0].text;
        if (!instructionSet.count(name)) {
            std::cerr << "ERROR: Invalid/Unknown instruction '" << name << "'\n";
            std::cerr << "\tFile: " << inst.tokens[0].filename
                      << ", Line: " << inst.tokens[0].lineNum << "\n";
            exit(1);
        }

        const auto& spec = instructionSet[name];

        // Check operand count
        if (inst.tokens.size() != spec.numOperands + 1) {
            std::cerr << "ERROR: Wrong number of operands for '" << name 
                      << "'. Expected " << spec.numOperands << ", got " 
                      << (inst.tokens.size()-1) << "\n";
            std::cerr << "\tFile: " << inst.tokens[0].filename
                      << ", Line: " << inst.tokens[0].lineNum << "\n";
            exit(1);
        }

        // Validate operands
        for (int i = 0; i < spec.numOperands; ++i) {
            const std::string& tok = inst.tokens[i+1].text;
            char expected = spec.types[i];
            bool valid = false;
            switch (expected) {
                case 'R': valid = isRegister(tok); break;
                case 'C': valid = isCondition(tok); break;
                case 'I': valid = isImmediateValue(tok) || isLabelReference(tok, allLabels); break;
                case 'L': valid = isLabelReference(tok, allLabels); break;
            }
            if (!valid) {
                std::cerr << "ERROR: Operand " << (i+1) << " of '" << name 
                          << "' is invalid: '" << tok << "'\n";
                std::cerr << "\tExpected type: " << expected 
                          << " (immediate or &label for I)\n";
                std::cerr << "\tFile: " << inst.tokens[i+1].filename 
                          << ", Line: " << inst.tokens[i+1].lineNum << "\n";
                exit(1);
            }
        }
    }
}

void resolveLabelsAndExpandGoif(std::vector<Instruction>& instructions) {
    bool changed;

    do {
        changed = false;
        std::unordered_map<std::string, size_t> labelAddresses;

        // 1) Assign current addresses to labels
        size_t addr = 0;
        for (auto& inst : instructions) {
            for (auto& lbl : inst.labels) {
                labelAddresses[lbl] = addr;
            }
            addr++;
        }

        // 2) Expand GOIF
        std::vector<Instruction> newInstructions;
        addr = 0;
        for (auto& inst : instructions) {
            if (inst.tokens.empty()) continue;

            std::string name = inst.tokens[0].text;

            if (name == "GOIF") {
                if (inst.tokens.size() != 3) {
                    std::cerr << "ERROR: GOIF must have 2 operands (condition, &label)\n";
                    std::cerr << "\tFile: " << inst.tokens[0].filename
                              << ", Line: " << inst.tokens[0].lineNum << "\n";
                    exit(1);
                }

                std::string cond = inst.tokens[1].text;
                std::string labelToken = inst.tokens[2].text;
                if (labelToken[0] != '&') {
                    std::cerr << "ERROR: GOIF operand must be &label\n";
                    exit(1);
                }
                std::string targetLabel = labelToken.substr(1);
                if (!labelAddresses.count(targetLabel)) {
                    std::cerr << "ERROR: GOIF target label not defined yet: " << targetLabel << "\n";
                    exit(1);
                }

                int offset = static_cast<int>(labelAddresses[targetLabel]) - static_cast<int>(addr);

                if (offset >= -128 && offset <= 127) {
                    // Use Bcond directly
                    Instruction bcondInst;
                    bcondInst.lineNum = inst.lineNum;
                    bcondInst.labels = inst.labels;
                    bcondInst.tokens.push_back({ "BCOND", inst.tokens[0].filename, inst.tokens[0].lineNum, inst.tokens[0].offset });
                    bcondInst.tokens.push_back({ cond, inst.tokens[1].filename, inst.tokens[1].lineNum, inst.tokens[1].offset });
                    bcondInst.tokens.push_back({ std::to_string(offset), inst.tokens[2].filename, inst.tokens[2].lineNum, inst.tokens[2].offset });
                    newInstructions.push_back(bcondInst);
                    addr += 1;
                } else {
                    // Expand to 3 instructions
                    changed = true;

                    // READ R12
                    Instruction readInst;
                    readInst.lineNum = inst.lineNum;
                    readInst.labels = inst.labels;
                    readInst.tokens.push_back({ "READ", inst.tokens[0].filename, inst.tokens[0].lineNum, inst.tokens[0].offset });
                    readInst.tokens.push_back({ "R12", inst.tokens[0].filename, inst.tokens[0].lineNum, inst.tokens[0].offset });
                    newInstructions.push_back(readInst);
                    addr += 1;

                    // Data instruction: &label
                    Instruction dataInst;
                    dataInst.lineNum = inst.lineNum;
                    dataInst.tokens.push_back({ labelToken, inst.tokens[2].filename, inst.tokens[2].lineNum, inst.tokens[2].offset });
                    newInstructions.push_back(dataInst);
                    addr += 1;

                    // Jcond cond R12
                    Instruction jcondInst;
                    jcondInst.lineNum = inst.lineNum;
                    jcondInst.tokens.push_back({ "JCOND", inst.tokens[0].filename, inst.tokens[0].lineNum, inst.tokens[0].offset });
                    jcondInst.tokens.push_back({ cond, inst.tokens[1].filename, inst.tokens[1].lineNum, inst.tokens[1].offset });
                    jcondInst.tokens.push_back({ "R12", inst.tokens[0].filename, inst.tokens[0].lineNum, inst.tokens[0].offset });
                    newInstructions.push_back(jcondInst);
                    addr += 1;
                }

            } else {
                newInstructions.push_back(inst);
                addr += 1;
            }
        }

        instructions = newInstructions;

    } while (changed);

    // 3) Assign numeric values to &label and remove all label entries
    std::unordered_map<std::string, size_t> labelAddressesFinal;
    size_t addr = 0;
    for (auto& inst : instructions) {
        addr++; // only instructions count
    }

    // Build final label address mapping
    addr = 0;
    for (auto& inst : instructions) {
        for (auto& lbl : inst.labels) {
            labelAddressesFinal[lbl] = addr;
        }
        addr++;
    }

    // Replace &label with numeric addresses and clear labels
    for (auto& inst : instructions) {
        for (auto& tok : inst.tokens) {
            if (!tok.text.empty() && tok.text[0] == '&') {
                std::string lblName = tok.text.substr(1);
                if (!labelAddressesFinal.count(lblName)) {
                    std::cerr << "ERROR: label not found: " << lblName << "\n";
                    exit(1);
                }
                tok.text = std::to_string(labelAddressesFinal[lblName]);
            }
        }
        inst.labels.clear(); // remove labels
    }
}

void resolveImmediateValues(std::vector<Instruction>& instructions) {
    auto checkRange = [](int value, int bits) -> bool {
        int minVal = -(1 << (bits - 1));
        int maxVal = (1 << (bits - 1)) - 1;
        return value >= minVal && value <= maxVal;
    };

    // Instruction specification for immediate positions
    struct InstSpec { int numOperands; std::vector<char> types; };
    std::unordered_map<std::string, InstSpec> instructionSet = {
        {"ADD",{2,{'R','R'}}}, {"ADDI",{2,{'I','R'}}}, {"MUL",{2,{'R','R'}}}, {"MULI",{2,{'I','R'}}}, {"SUB",{2,{'R','R'}}},
        {"SUBI",{2,{'I','R'}}}, {"CMP",{2,{'R','R'}}}, {"CMPI",{2,{'I','R'}}},
        {"AND",{2,{'R','R'}}}, {"OR",{2,{'R','R'}}}, {"XOR",{2,{'R','R'}}},
        {"NOT",{2,{'R','R'}}}, {"LSH",{2,{'R','R'}}}, {"LSHI",{2,{'I','R'}}},
        {"ASH",{2,{'R','R'}}}, {"ASHI",{2,{'I','R'}}}, {"ARSHI",{2,{'I','R'}}},{"MOV",{2,{'R','R'}}},
        {"MOVI",{2,{'I','R'}}}, {"LOAD",{2,{'R','R'}}}, {"STOR",{2,{'R','R'}}},
        {"BCOND",{2,{'C','I'}}}, {"JCOND",{2,{'C','R'}}}, {"JAL",{2,{'R','R'}}},
        {"READ",{1,{'R'}}}, {"I",{1,{'I'}}}
    };

    for (auto& inst : instructions) {
        if (inst.tokens.empty()) continue;
        std::string name = inst.tokens[0].text;

        int bits = 8;
        // Skip data-only instructions
        if (inst.tokens.size() == 1) {
            bits = 16;
            // Example: if WAIT or other single-token instructions
            if (name == "WAIT") continue;

            // If you expect a single immediate value encoded in the name itself
            // (e.g., "I 0xC000" might sometimes appear as a single token like "0xC000")
            std::string& tok = inst.tokens[0].text;  // Only token

            int value = 0;
            try {
                if (tok.size() > 2 && tok[0] == '0' && tok[1] == 'x') {
                    value = std::stoi(tok, nullptr, 16);
                } else if (tok.size() > 2 && tok[0] == '0' && tok[1] == 'b') {
                    value = std::stoi(tok.substr(2), nullptr, 2);
                } else {
                    value = std::stoi(tok);
                }
            } catch (...) {
                std::cerr << "ERROR: Invalid single-token value '" << tok << "'\n";
                exit(1);
            }

            tok = std::to_string(value); // normalize to decimal
            continue; // done processing this single-token instruction
        }
        if (!instructionSet.count(name)) continue; // safety

        const auto& spec = instructionSet[name];

        // Determine bit width for immediates
        if (name == "LSHI" || name == "ASHI") bits = 5;
        if (name == "BCOND") bits = 8;

        // Process only operands that are expected to be 'I'
        for (size_t i = 0; i < spec.types.size(); ++i) {
            if (spec.types[i] != 'I') continue;

            std::string& tok = inst.tokens[i+1].text; // +1 because token 0 is instruction name
            int value = 0;

            try {
                if (tok.size() > 2 && tok[0]=='0' && tok[1]=='x') {
                    value = std::stoi(tok, nullptr, 16);
                } else if (tok.size() > 2 && tok[0]=='0' && tok[1]=='b') {
                    value = std::stoi(tok.substr(2), nullptr, 2);
                } else {
                    value = std::stoi(tok);
                }
            } catch (...) {
                std::cerr << "ERROR: Invalid immediate value '" << tok 
                          << "' in instruction '" << name << "'\n";
                std::cerr << "\tFile: " << inst.tokens[i+1].filename
                          << ", Line: " << inst.tokens[i+1].lineNum << "\n";
                exit(1);
            }

            if (!checkRange(value, bits)) {
                std::cerr << "ERROR: Immediate value '" << tok 
                          << "' out of range for instruction '" << name << "'\n";
                std::cerr << "\tFile: " << inst.tokens[i+1].filename
                          << ", Line: " << inst.tokens[i+1].lineNum << "\n";
                exit(1);
            }
            tok = std::to_string(value); // normalize to decimal
        }
    }
}

// Condition binary map
std::unordered_map<std::string,uint8_t> condMap = {
    {"EQ",0b0000}, {"NE",0b0001}, {"GE",0b1101}, {"HI",0b0100},
    {"LS",0b0101}, {"LO",0b1010}, {"HS",0b1011}, {"GT",0b0110},
    {"LE",0b0111}, {"FS",0b1000}, {"FC",0b1001}, {"LT",0b1100},
    {"UC",0b1110}
};

// Upper/lower opcode map
std::unordered_map<std::string,std::pair<uint8_t,uint8_t>> opcodeMap = {
    {"ADD",{0x00,0x05}}, {"ADDI",{0x05,0x00}}, {"MUL",{0x00,0x0E}}, {"MULI",{0x0E,0x00}}, {"SUB",{0x00,0x09}}, {"SUBI",{0x09,0x00}},
    {"CMP",{0x00,0x0B}}, {"CMPI",{0x0B,0x00}}, {"AND",{0x00,0x01}}, {"OR",{0x00,0x02}},
    {"XOR",{0x00,0x03}}, {"NOT",{0x00,0x04}}, {"LSH",{0x08,0x04}}, {"LSHI",{0x08,0x00}},
    {"RSH",{0x84,0x00}}, {"RSHI",{0x85,0x00}}, {"ARSH",{0x08,0x06}}, {"ARSHI",{0x08,0x02}},
    {"NOP",{0x00,0x00}}, {"LOAD",{0x04,0x00}}, {"STOR",{0x04,0x04}}, {"MOV",{0x00,0x0D}},
    {"MOVI",{0x0D,0x00}}, {"SCOND",{0x04,0x0D}}, {"BCOND",{0x0C,0x00}}, {"JCOND",{0x04,0x0C}},
    {"JAL",{0x04,0x08}}, {"READ",{0x00,0x0F}}
};

// Convert register token to 4-bit value
uint8_t regToVal(const std::string& reg) {
    if(reg.empty()) return 0;
    std::string r = reg;
    if(r[0]=='R' || r[0]=='r') r = r.substr(1);
    return static_cast<uint8_t>(std::stoi(r) & 0xF);
}

// Convert signed integer to N-bit two's complement
uint8_t twosComplement(int value, int bits) {
    int mask = (1 << bits) - 1;
    return static_cast<uint8_t>(value & mask);
}

std::vector<std::string> instructionsToHex(const std::vector<Instruction>& instructions) {
    std::vector<std::string> output;

    for(const auto& inst : instructions) {
        if(inst.tokens.empty()) continue;

        std::string name = inst.tokens[0].text;

        uint16_t word = 0;

        auto opIt = opcodeMap.find(name);
        uint8_t upper = 0;
        uint8_t lower = 0;

        if(opIt == opcodeMap.end()) {
            if(isImmediateValue(name)) {
            word = std::stoi(name);
            }else if(name == "WAIT") {
                word = 0;
            }else{
            std::cerr << "ERROR: Unknown instruction " << name << std::endl;
            continue;
            }
        }else{
        upper = opIt->second.first;
        lower = opIt->second.second;

        }



        if(name=="MUL" || name=="ADD" || name=="SUB" || name=="CMP" || name=="AND" || name=="OR" ||
           name=="XOR" || name=="NOT" || name=="MOV" || name=="LSH" ) {
            uint8_t r1 = regToVal(inst.tokens[1].text); // first operand
            uint8_t r2 = regToVal(inst.tokens[2].text); // second operand
            word = (upper << 12) | (r2 << 8) | (lower << 4) | r1;  // <-- FIXED lower opcode placement
   
           }
        if(
           name == "JAL" || name=="LOAD" || name=="STOR") {
            uint8_t r1 = regToVal(inst.tokens[1].text); // first operand
            uint8_t r2 = regToVal(inst.tokens[2].text); // second operand
            word = (upper << 12) | (r1 << 8) | (lower << 4) | r2;  // <-- FIXED lower opcode placement
   
           }
        else if(name=="MULI" || name=="MOVI" || name=="ADDI" || name=="SUBI" || name=="CMPI") {
            int imm = std::stoi(inst.tokens[1].text);
            uint8_t r = regToVal(inst.tokens[2].text);
            word = (upper << 12) | (r << 8) | (twosComplement(imm, 8) & 0xFF); // MOVI 4-bit
        }
        else if(name=="LSHI" || name=="RSHI" || name=="ARSHI") {
            int imm = std::stoi(inst.tokens[1].text);
            uint8_t r = regToVal(inst.tokens[2].text);
            word = (upper << 12) | (r << 8) | (lower<<4) | (twosComplement(imm,5) & 0x1F); // <-- FIXED shift
        }else if (name=="BCOND"){
            int imm = std::stoi(inst.tokens[2].text);
            word = (upper << 12) | (condMap[inst.tokens[1].text] << 8) | (twosComplement(imm,8) & 0xFF);
        }else if (name=="READ") {
            uint8_t r2 = regToVal(inst.tokens[1].text);
            word = (upper << 12) | (r2 << 8) | (lower << 4);
        }else if (name=="JCOND") {
            word = (upper << 12) | (condMap[inst.tokens[1].text] << 8) | (lower << 4) | regToVal(inst.tokens[2].text );
        }

        std::stringstream ss;
        ss << std::uppercase << std::hex << std::setw(4) << std::setfill('0') << word;
        ss << std::dec << " // " << inst.tokens[0].filename << " " << inst.tokens[0].lineNum; 
        output.push_back(ss.str());
    }

    return output;
}