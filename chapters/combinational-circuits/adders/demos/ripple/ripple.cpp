#include <iostream>
#include "ripple_adder.hpp"

int main() {
    // Example for 4-bit ripple adder
    const int N = 4;
    int a[N] = {1, 0, 1, 1}; // Example binary number
    int b[N] = {1, 1, 0, 1}; // Example binary number
    int sum[N];
    int carry;

    ripple_adder<N>(a, b, sum, 0, carry);

    std::cout << "4-bit Ripple Adder:" << std::endl;
    std::cout << "Sum: ";
    for (int i = N - 1; i >= 0; --i) {
        std::cout << sum[i];
    }
    std::cout << ", Carry: " << carry << std::endl;

    // Example for 16-bit ripple adder using four 4-bit ripple adders
    const int M = 16;
    int a16[M] = {1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0}; // Example 16-bit binary number
    int b16[M] = {1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1}; // Example 16-bit binary number
    int sum16[M];
    int carry16[5] = {0}; // Carry array for each 4-bit adder

    for (int i = 0; i < M; i += 4) {
        ripple_adder<4>(*(int(*)[4])(a16 + i), *(int(*)[4])(b16 + i), *(int(*)[4])(sum16 + i), carry16[i / 4], carry16[i / 4 + 1]);
    }

    std::cout << "16-bit Ripple Adder from 4-bit Ripple Adder:" << std::endl;
    std::cout << "Sum: ";
    for (int i = M - 1; i >= 0; --i) {
        std::cout << sum16[i];
    }
    std::cout << ", Carry: " << carry16[4] << std::endl;

    ripple_adder<16>(a16, b16, sum16, 0, carry);

    std::cout << "16-bit Ripple Adder:" << std::endl;
    std::cout << "Sum: ";
    for (int i = M - 1; i >= 0; --i) {
        std::cout << sum16[i];
    }
    std::cout << ", Carry: " << carry << std::endl;

    return 0;
}