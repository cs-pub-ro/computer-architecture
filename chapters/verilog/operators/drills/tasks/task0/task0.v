module task0 #(
    parameter p_width = 1
) (
    output wire o_w_gt,
    output wire o_w_lt,
    output wire o_w_eq,
    input wire [p_width:0] i_w_a,
    input wire [p_width:0] i_w_b
);

    //TODO 1: Implement adder
    assign o_w_gt = i_w_a > i_w_b;
    assign o_w_lt = i_w_a < i_w_b;
    assign o_w_eq = i_w_a == i_w_b;
endmodule