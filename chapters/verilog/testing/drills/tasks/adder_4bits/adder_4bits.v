module adder_4bits(
    output wire [4:0] o_w_s,
    input wire [3:0] i_w_a,
    input wire [3:0] i_w_b
);

    //TODO 1: Implement adder
    assign o_w_s = i_w_a + i_w_b;
endmodule