module cram #(
    parameter p_data_width = 16,
    parameter p_address_width = 10
)(
    // `ifdef DEBUG
    output wire [(p_data_width-1) : 0] o_w_disp_out,
    input wire [(p_address_width-1) : 0] i_w_disp_address,
    // `endif
    output wire [(p_data_width-1) : 0] o_w_out,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_address,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_clk,
    input wire i_w_ram_clk
);

    // initial begin
    //     $readmemh("cram.data", l_r_data, 0, 2**p_address_width-1);
    // end

    wire [(p_data_width-1) : 0] l_w_out;
    // `ifdef DEBUG
    block_dpram #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width)
    ) block_ram_inst (
        .o_r_out_a(l_w_out),
        .o_r_out_b(o_w_disp_out),
        .i_w_in(i_w_in),
        .i_w_address_a(i_w_address),
        .i_w_address_b(i_w_disp_address),
        .i_w_we(i_w_we),
        .i_w_cs_a(1'b1),
        .i_w_cs_b(1'b1),
        .i_w_clk_a(i_w_clk),
        .i_w_clk_b(i_w_ram_clk)
    );
    // `else
    // block_ram #(
    //     .p_data_width(p_data_width),
    //     .p_address_width(p_address_width)
    // ) block_ram_inst (
    //     .o_r_out(l_w_out),
    //     .i_w_in(i_w_in),
    //     .i_w_address(i_w_address),
    //     .i_w_we(i_w_we),
    //     .i_w_cs(1'b1),
    //     .i_w_clk(i_w_clk)
    // );
    // `endif

    assign o_w_out = ( (i_w_oe == 1'b1) && (i_w_we == 1'b0) ) ? l_w_out : {p_data_width{1'b0}};

endmodule