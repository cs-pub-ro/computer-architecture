#pragma once

#include "full_adder.hpp"

// Template function to implement a ripple carry adder
template <int N>
void ripple_adder(const int (&a)[N], const int (&b)[N], int (&sum)[N], const int carry_in, int &carry_out) {
    // Initialize carry to 0
    int carry_tmp[N+1];
    carry_tmp[0] = carry_in;

    // Iterate over each bit
    for (int i = 0; i < N; ++i) {
        // Calculate the sum and carry for the current bit
        full_adder(a[i], b[i], carry_tmp[i], sum[i], carry_tmp[i+1]);
    }

    // Set the final carry
    carry_out = carry_tmp[N];
}