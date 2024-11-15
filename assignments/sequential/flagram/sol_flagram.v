module sol_flagram (
    output wire [3:0] o_w_out,
    input wire i_w_clk,
    input wire [3:0] i_w_address,
    input wire [3:0] i_w_data,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_flags_out
);

    wire [15:0] l_w_full_out;

    full_flagram full_flagram_inst (
        .o_w_out(l_w_full_out),
        .i_w_clk(i_w_clk),
        .i_w_address(i_w_address),
        .i_w_data(i_w_data),
        .i_w_we(i_w_we),
        .i_w_oe(i_w_oe),
        .i_w_flags_out(i_w_flags_out)
    );

    assign o_w_out = (i_w_we || i_w_oe) ? l_w_full_out[3:0] : (
        i_w_flags_out ? {l_w_full_out[4'd`OP3], l_w_full_out[4'd`OP2], l_w_full_out[4'd`OP1], l_w_full_out[4'd`OP0]} : 4'd0
    );
endmodule
