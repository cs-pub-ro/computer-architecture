#include <iostream>
#include <fstream>
#include <random>
#include <limits>
#include <bitset>
#include <sstream>
#include <iomanip>
#include <fenv.h>

/*
| Operation Code (i_w_sel) | Operation       |
|--------------------------|-----------------|
| 000                      | Addition        |
| 001                      | Subtraction     |
| 010                      | Multiplication  |
| 011                      | Division        |
| 100                      | Negation        |
| 101                      | Absolute Value  |
| 110                      | Less than       |
| 111                      | Equal           |
*/

std::string floatToBinary(float value) {
    union {
        float input;
        int output;
    } data;
    data.input = value;
    std::bitset<sizeof(float) * 8> bits(data.output);
    return bits.to_string();
}

std::string intToBinary(int value, int bits) {
    std::bitset<32> bitset(value);
    return bitset.to_string().substr(32 - bits, bits);
}

std::string floatToHex(float value) {
    union {
        float input;
        int output;
    } data;
    data.input = value;
    std::stringstream ss;
    ss << std::hex << std::setw(8) << std::setfill('0') << data.output;
    return ss.str();
}

std::string intToHex(int value, int hex_digits = 8) {
    std::stringstream ss;
    ss << std::hex << std::setw(hex_digits) << std::setfill('0') << value;
    return ss.str();
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <output_file>" << std::endl;
        return 1;
    }
    std::string output_file = argv[1];
    fesetround(FE_TONEAREST);
    std::mt19937 gen(0);
    std::normal_distribution<float> normal_dis(0.0f, 1e3);


    std::ofstream outfile(output_file);
    if (!outfile) {
        std::cerr << "Error opening file for writing" << std::endl;
        return 1;
    }
    
    for (int i = 0; i < 1000; i++) {
        float a = normal_dis(gen);
        float b = normal_dis(gen);
        float result;
        for (int i_w_sel = 0; i_w_sel < 8; i_w_sel++) {
            switch (i_w_sel) {
                case 0:
                    result = a + b;
                    break;
                case 1:
                    result = a - b;
                    break;
                case 2:
                    result = a * b;
                    break;
                case 3:
                    result = a / b;
                    break;
                case 4:
                    result = -a;
                    break;
                case 5:
                    result = std::abs(a);
                    break;
                case 6:
                    result = a < b;
                    break;
                case 7:
                    if (a < b) a = b;
                    result = a == b;
                    break;
            }
            outfile << floatToHex(a) << " " << floatToHex(b) << " " << intToHex(i_w_sel, 1) << " " << floatToHex(result) << std::endl;
        }
    }
    outfile.close();
    return 0;
}