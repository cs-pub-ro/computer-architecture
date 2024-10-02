module adder_6bits(
    output wire [6:0] o_w_s,
    input wire [5:0] i_w_a,
    input wire [5:0]  i_w_b
);

    //TODO 3.1: Implement using 
    wire [1:0] l_w_carry;
    adder_4bits l_m_adder_4bits ( .o_w_s(o_w_s[3:0]), .o_w_cout(l_w_carry[0]), .i_w_a(i_w_a[3:0]), .i_w_b(i_w_b[3:0]), .i_w_cin(1'b0) );
    fulladder l_m_fulladder_0 ( .o_w_s(o_w_s[4]), .o_w_cout(l_w_carry[1]), .i_w_a(i_w_a[4]), .i_w_b(i_w_b[4]), .i_w_cin(l_w_carry[0]) );
    fulladder l_m_fulladder_1 ( .o_w_s(o_w_s[5]), .o_w_cout(o_w_s[6]), .i_w_a(i_w_a[5]), .i_w_b(i_w_b[5]), .i_w_cin(l_w_carry[1]) );
endmodule