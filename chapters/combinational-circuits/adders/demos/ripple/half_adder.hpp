#pragma once

// Function to implement a half adder
void half_adder(const int a, const int b, int &sum, int &carry) {
    sum = a ^ b;       // Sum is the XOR of the inputs
    carry = a & b;     // Carry is the AND of the inputs
}