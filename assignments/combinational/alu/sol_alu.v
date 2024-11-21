module sol_alu(
    output wire [3:0] o_w_out,
    input wire [3:0] i_w_op1,
    input wire [3:0] i_w_op2,
    input wire [1:0] i_w_opsel
);

    reg [3:0] l_r_sop0;
    reg [3:0] l_r_sop1;
    reg [3:0] l_r_sop2;
    reg [3:0] l_r_sop3;

    wire [3:0] l_w_res0_out;
    wire [3:0] l_w_res1_out;
    wire [3:0] l_w_res2_out;
    wire [3:0] l_w_res3_out;

    initial begin
        l_r_sop0 <= 4'd`OP0;
        l_r_sop1 <= 4'd`OP1;
        l_r_sop2 <= 4'd`OP2;
        l_r_sop3 <= 4'd`OP3;
    end

    full_alu l_m_res0(
        .o_w_out(l_w_res0_out),
        .i_w_op1(i_w_op1),
        .i_w_op2(i_w_op2),
        .i_w_opsel(l_r_sop0)
    );

    full_alu l_m_res1(
        .o_w_out(l_w_res1_out),
        .i_w_op1(i_w_op1),
        .i_w_op2(i_w_op2),
        .i_w_opsel(l_r_sop1)
    );

    full_alu l_m_res2(
        .o_w_out(l_w_res2_out),
        .i_w_op1(i_w_op1),
        .i_w_op2(i_w_op2),
        .i_w_opsel(l_r_sop2)
    );

    full_alu l_m_res3(
        .o_w_out(l_w_res3_out),
        .i_w_op1(i_w_op1),
        .i_w_op2(i_w_op2),
        .i_w_opsel(l_r_sop3)
    );
    
    assign o_w_out = (i_w_opsel == 2'b00) ? l_w_res0_out :
        (i_w_opsel == 2'b01) ? l_w_res1_out :
        (i_w_opsel == 2'b10) ? l_w_res2_out :
        l_w_res3_out;

endmodule