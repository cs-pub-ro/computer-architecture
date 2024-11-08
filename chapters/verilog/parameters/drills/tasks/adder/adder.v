module adder #(
    parameter p_widith = 4	// Bit-width for input operands
) (
    output wire [p_widith:0] o_w_s,	// Sum output, 1 bit wider to account for carry
    input wire [(p_widith-1):0] i_w_a,	// First operand
    input wire [(p_widith-1):0] i_w_b	// Second operand
);

    // Adder implementation
    assign o_w_s = i_w_a + i_w_b;
endmodule
