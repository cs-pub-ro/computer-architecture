module full_flagram (
    output wire [15:0] o_w_out,
    input wire i_w_clk,
    input wire [3:0] i_w_address,
    input wire [3:0] i_w_data,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_flags_out
);
    // FLAGS
    wire [15:0] l_w_flags;

    // RAM read data
    wire [3:0] l_w_ram_data;

    // RAM
    sol_ram #(
        .p_data_width(4),
        .p_address_width(4)
    ) ram_inst (
        .o_w_out(l_w_ram_data),
        .i_w_in(i_w_data),
        .i_w_address(i_w_address),
        .i_w_we(i_w_we),
        .i_w_oe(i_w_oe),
        .i_w_clk(i_w_clk)
    );

    // Flags
    wire Z_flag;
    wire S_flag;
    wire E_flag;
    wire O_flag;
    wire C2_flag;
    wire S2_flag;
    wire G4_flag;
    wire L4_flag;
    wire POW_flag;
    wire SMAX_flag;
    wire SMIN_flag;
    wire MAX_flag;
    wire PAL_flag;
    wire SB2_flag;

    assign Z_flag = (|l_w_ram_data);
    assign S_flag = l_w_ram_data[3];
    assign E_flag = (~(^l_w_ram_data));
    assign O_flag = (^l_w_ram_data);
    assign C2_flag = !l_w_ram_data[2];
    assign S2_flag = l_w_ram_data[2];
    assign G4_flag = l_w_ram_data > 4'd4;
    assign L4_flag = l_w_ram_data < 4'd4;
    assign POW_flag = (l_w_ram_data == 4'd1) || (l_w_ram_data == 4'd2) || (l_w_ram_data == 4'd4) || (l_w_ram_data == 4'd8);
    assign SMAX_flag = l_w_ram_data == 4'd7;
    assign SMIN_flag = l_w_ram_data == 4'd8;
    assign MAX_flag = l_w_ram_data == 4'd15;
    assign PAL_flag = (l_w_ram_data[0] == l_w_ram_data[3]) && (l_w_ram_data[1] == l_w_ram_data[2]);
    assign SB2_flag = (l_w_ram_data[3] == l_w_ram_data[2]) || (l_w_ram_data[2] == l_w_ram_data[1]) || (l_w_ram_data[1] == l_w_ram_data[0]);

    wire [15:0] l_w_flags_in;
    wire [15:0] l_w_flags_out;
    assign l_w_flags_in = {2'd0, SB2_flag, PAL_flag, MAX_flag, SMIN_flag, SMAX_flag, POW_flag, L4_flag, G4_flag, S2_flag, C2_flag, O_flag, E_flag, S_flag, Z_flag};

    // register for FLGAS
    sol_register #(
        .p_data_width(16)
    ) register_inst (
        .o_w_out(l_w_flags_out),
        .i_w_in(l_w_flags_in),
        .i_w_we(i_w_oe),
        .i_w_oe(i_w_flags_out),
        .i_w_clk(i_w_clk),
        .i_w_reset(1'b1)
    );

    assign o_w_out = i_w_we ? 16'd0 : (i_w_oe ? {12'd0, l_w_ram_data} : (i_w_flags_out ? l_w_flags_out : 16'd0));

endmodule