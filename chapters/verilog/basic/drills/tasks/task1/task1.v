module task1(
    output wire [3:0] o_w_s,
    output wire o_w_cout,
    input wire [3:0] i_w_a,
    input wire [3:0] i_w_b,
    input wire i_w_cin
);

    //TODO 1.1: Implement with 4 full-adders
    wire [3:0] l_w_carry;
    task0 l_m_task0_0 ( .o_w_s(o_w_s[0]), .o_w_cout(l_w_carry[0]), .i_w_a(i_w_a[0]), .i_w_b(i_w_b[0]), .i_w_cin(i_w_cin) );
    task0 l_m_task0_1 ( .o_w_s(o_w_s[1]), .o_w_cout(l_w_carry[1]), .i_w_a(i_w_a[1]), .i_w_b(i_w_b[1]), .i_w_cin(l_w_carry[0]) );
    task0 l_m_task0_2 ( .o_w_s(o_w_s[2]), .o_w_cout(l_w_carry[2]), .i_w_a(i_w_a[2]), .i_w_b(i_w_b[2]), .i_w_cin(l_w_carry[1]) );
    task0 l_m_task0_3 ( .o_w_s(o_w_s[3]), .o_w_cout(o_w_cout), .i_w_a(i_w_a[3]), .i_w_b(i_w_b[3]), .i_w_cin(l_w_carry[2]) );
    
endmodule