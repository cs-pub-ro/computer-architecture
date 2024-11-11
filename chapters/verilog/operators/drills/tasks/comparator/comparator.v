module comparator #(
    parameter p_width = 4	// Bit-width of input operands
) (
    output wire o_w_gt,		// Output: high if i_w_a > i_w_b
    output wire o_w_lt,		// Output: high if i_w_a < i_w_b
    output wire o_w_eq,		// Output: high if i_w_a == i_w_b
    input wire [(p_width-1):0] i_w_a,	// First operand
    input wire [(p_width-1):0] i_w_b	// Second operand
);

    // Perform comparison and set outputs
    assign o_w_gt = i_w_a > i_w_b;	// High if i_w_a is greater
    assign o_w_lt = i_w_a < i_w_b;	// High if i_w_a is lower
    assign o_w_eq = i_w_a == i_w_b;	// High if equal
endmodule
