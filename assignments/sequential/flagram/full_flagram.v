module full_flagram (
    output wire [15:0] o_w_out,
    input wire i_w_clk,
    input wire [3:0] i_w_address,
    input wire [3:0] i_w_data,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_flags_out
);

    // RAM memory
    reg [3:0] l_r_data [((2 ** 4) - 1):0];

    // FLAGS
    wire [15:0] l_w_flags;

    // Output
    reg [15:0] l_r_data_out;

    // Flags
    reg Z_flag;
    reg S_flag;
    reg E_flag;
    reg O_flag;
    reg C2_flag;
    reg S2_flag;
    reg G4_flag;
    reg L4_flag;
    reg POW_flag;
    reg SMAX_flag;
    reg SMIN_flag;
    reg MAX_flag;
    reg PAL_flag;
    reg SB2_flag;

    always @(posedge i_w_clk) begin
        if (i_w_we) begin
            l_r_data[i_w_address] <= i_w_data;
            l_r_data_out <= 15'd0;
        end else if (i_w_oe) begin
            l_r_data_out <= {12'd0, l_r_data[i_w_address]};
            Z_flag <= ~(|l_r_data[i_w_address]);
            S_flag <= l_r_data[i_w_address][3];
            E_flag <= ~(^l_r_data[i_w_address]);
            O_flag <= ^l_r_data[i_w_address];
            C2_flag <= !l_r_data[i_w_address][2];
            S2_flag <= l_r_data[i_w_address][2];
            G4_flag <= l_r_data[i_w_address] > 4'd4;
            L4_flag <= l_r_data[i_w_address] < 4'd4;
            POW_flag <= (l_r_data[i_w_address] == 4'd0) || (l_r_data[i_w_address] == 4'd1) || (l_r_data[i_w_address] == 4'd2) || (l_r_data[i_w_address] == 4'd4) || (l_r_data[i_w_address] == 4'd8);
            SMAX_flag <= l_r_data[i_w_address] == 4'd7;
            SMIN_flag <= l_r_data[i_w_address] == 4'd8;
            MAX_flag <= l_r_data[i_w_address] == 4'd15;
            PAL_flag <= (l_r_data[i_w_address][0] == l_r_data[i_w_address][3]) && (l_r_data[i_w_address][1] == l_r_data[i_w_address][2]);
            SB2_flag <= (l_r_data[i_w_address][3] == l_r_data[i_w_address][2]) || (l_r_data[i_w_address][2] == l_r_data[i_w_address][1]) || (l_r_data[i_w_address][1] == l_r_data[i_w_address][0]);
        end else if (i_w_flags_out) begin
            l_r_data_out <= l_w_flags;
        end
    end

    assign l_w_flags = {2'd0, SB2_flag, PAL_flag, MAX_flag, SMIN_flag, SMAX_flag, POW_flag, L4_flag, G4_flag, S2_flag, C2_flag, O_flag, E_flag, S_flag, Z_flag};
    assign o_w_out = l_r_data_out;

endmodule