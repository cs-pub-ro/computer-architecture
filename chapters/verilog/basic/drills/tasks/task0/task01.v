module task01 (
    output wire o_w_s,
    output wire o_w_cout,
    input wire i_w_a,
    input wire i_w_b
);
    //TODO 0.1: Implement half-adder
    xor(o_w_s, i_w_a, i_w_b);
    and(o_w_cout, i_w_a, i_w_b);

endmodule