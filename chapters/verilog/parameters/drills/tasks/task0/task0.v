module task0 #(
    parameter p_widith = 1
) (
    output wire [(p_widith+1):0] o_w_s,
    input wire [p_widith:0] i_w_a,
    input wire [p_widith:0] i_w_b
);

    //TODO 1: Implement adder
    assign o_w_s = i_w_a + i_w_b;
endmodule