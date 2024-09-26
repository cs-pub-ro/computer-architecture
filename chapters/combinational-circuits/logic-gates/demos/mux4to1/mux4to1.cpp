#include <iostream>
#include "mux4to1.hpp"

int main() {
    // Test the 4-to-1 multiplexer
    int s0 = 1;
    int s1 = 0;
    int i0 = 10;
    int i1 = 20;
    int i2 = 30;
    int i3 = 40;

    int output = mux4to1(s0, s1, i0, i1, i2, i3);
    std::cout << "Output: " << output << std::endl;

    return 0;
}