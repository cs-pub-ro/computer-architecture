module adder_4bits(
    output wire [4:0] o_w_s,	// Sum output, 5 bits to include carry
    input wire [3:0] i_w_a,	// 4-bit first operand
    input wire [3:0] i_w_b	// 4-bit second operand
);

    // Adder implementation
    assign o_w_s = i_w_a + i_w_b;	// Output includes carry in 5th bit
endmodule
