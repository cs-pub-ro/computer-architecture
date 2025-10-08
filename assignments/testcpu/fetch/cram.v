module cram #(
    parameter p_data_width = 16,
    parameter p_address_width = 10,
    parameter p_file = "instructions.mem"
)(
    output wire [(p_data_width-1) : 0] o_w_out,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_address,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_clk
);

    wire [(p_data_width-1) : 0] l_w_out;

    block_ram #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width),
        .p_file(p_file)
    ) block_ram_inst (
        .o_r_out(l_w_out),
        .i_w_in(i_w_in),
        .i_w_address(i_w_address),
        .i_w_we(i_w_we),
        .i_w_cs(1'b1),
        .i_w_clk(i_w_clk)
    );

    assign o_w_out = ( (i_w_oe == 1'b1) && (i_w_we == 1'b0) ) ? l_w_out : {p_data_width{1'b0}};

endmodule