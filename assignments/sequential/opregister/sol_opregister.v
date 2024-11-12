module sol_opregister(
    output wire [3:0] o_w_out,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire [3:0] i_w_data,
    input wire i_w_we,
    input wire i_w_oe,
    input wire [1:0] i_w_opsel
);

    wire [3:0] l_w_opsel;

    assign l_w_opsel = (i_w_opsel == 2'b00) ? 4'd`OP0 :
        (i_w_opsel == 2'b01) ? 4'd`OP1 :
        (i_w_opsel == 2'b10) ? 4'd`OP2 :
        4'd`OP3;

    full_opregister l_m_f_opr(
        .o_w_out(o_w_out),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_data(i_w_data),
        .i_w_we(i_w_we),
        .i_w_oe(i_w_oe),
        .i_w_opsel(l_w_opsel)
    );

endmodule