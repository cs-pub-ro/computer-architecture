#pragma once

#include "half_adder.hpp"

// Function to implement a full adder
void full_adder(const int a, const int b, const int cin, int &sum, int &carry) {
    int sum1, carry1, carry2;

    // First half adder
    half_adder(a, b, sum1, carry1);

    // Second half adder
    half_adder(sum1, cin, sum, carry2);

    // Final carry
    carry = carry1 | carry2;
}