module fulladder(
    output wire o_w_s,
    output wire o_w_cout,
    input wire i_w_a,
    input wire i_w_b,
    input wire i_w_cin
);

    //TODO 0.2: Implement full-adder using 2 half-adders
    wire l_w_c0, l_w_c1; 
    wire l_w_s0;
    halfadder l_m_halfadder_0( .o_w_s(l_w_s0), .o_w_cout(l_w_c0), .i_w_a(i_w_a), .i_w_b(i_w_b) );
    halfadder l_m_halfadder_1( .o_w_s(o_w_s), .o_w_cout(l_w_c1), .i_w_a(i_w_cin), .i_w_b(l_w_s0) );
    or(o_w_cout, l_w_c0, l_w_c1);
endmodule