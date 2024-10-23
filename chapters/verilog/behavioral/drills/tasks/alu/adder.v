module adder #(
    parameter p_width = 1
) (
    output wire [(p_width+1):0] o_w_s,
    input wire [p_width:0] i_w_a,
    input wire [p_width:0] i_w_b
);
    //TODO 1: Implement half-adder
    assign o_w_s = i_w_a + i_w_b;

endmodule