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

    // when we call a module we have to give it a specific name especially if we want to use it multiple times
    // we also should tell the module what each variable is used for when we call it for example:

    halfadder l_m_halfadder_0( .o_w_s(l_w_s0), .o_w_cout(l_w_c0), .i_w_a(i_w_a), .i_w_b(i_w_b) );
    
    // module halfadder, 
    // name l_m_halfadder_0, 
    // for output sum we have l_w_s0,
    // for output carry out we have l_w_c0.
    // for input a we have i_w_a,
    // for input b we have i_w_b .

    halfadder l_m_halfadder_1( .o_w_s(o_w_s), .o_w_cout(l_w_c1), .i_w_a(i_w_cin), .i_w_b(l_w_s0) );
    or(o_w_cout, l_w_c0, l_w_c1);
endmodule