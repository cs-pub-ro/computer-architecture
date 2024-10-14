module adder_4bits(
    output wire [3:0] o_w_s,
    output wire o_w_cout,
    input wire [3:0] i_w_a,
    input wire [3:0] i_w_b,
    input wire i_w_cin
);

    //TODO 1.1: Implement with 4 full-adders 
    wire [3:0] l_w_carry;

    // Since we have to call the full adder 4 times for each bit of a[3:0], b[3:0] the module has different names for each call
    // for every iteration (each bit from a and b) the full adders give a bit of the sum and the carry out of each full adder (except the last one) is the carry in for the next one
    // the carry out for the last one is the carry out of the 4 adder,
    // while the carry in for the first full adder is the carry in for the 4 adder
    
    fulladder l_m_fulladder_0 ( .o_w_s(o_w_s[0]), .o_w_cout(l_w_carry[0]), .i_w_a(i_w_a[0]), .i_w_b(i_w_b[0]), .i_w_cin(i_w_cin) );
    fulladder l_m_fulladder_1 ( .o_w_s(o_w_s[1]), .o_w_cout(l_w_carry[1]), .i_w_a(i_w_a[1]), .i_w_b(i_w_b[1]), .i_w_cin(l_w_carry[0]) );
    fulladder l_m_fulladder_2 ( .o_w_s(o_w_s[2]), .o_w_cout(l_w_carry[2]), .i_w_a(i_w_a[2]), .i_w_b(i_w_b[2]), .i_w_cin(l_w_carry[1]) );
    fulladder l_m_fulladder_3 ( .o_w_s(o_w_s[3]), .o_w_cout(o_w_cout), .i_w_a(i_w_a[3]), .i_w_b(i_w_b[3]), .i_w_cin(l_w_carry[2]) );
    
endmodule