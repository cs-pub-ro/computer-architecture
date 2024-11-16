// Dual-Port Block RAM Read-First Mode single Clock (recommended template)
module block_dpram #(
    parameter p_data_width = 8,
    parameter p_address_width = 20
) (
    output reg [(p_data_width-1) : 0] o_r_out_a,
    output reg [(p_data_width-1) : 0] o_r_out_b,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_address_a,
    input wire [(p_address_width-1) : 0] i_w_address_b,
    input wire i_w_we,
    input wire i_w_cs_a,
    input wire i_w_cs_b,
    input wire i_w_clk
);
    // define the depth of the RAM
    localparam l_p_depth = 2**p_address_width;
    // set the ram_style attribute to "block" to infer block RAM
    (* ram_style = "block" *) reg [(p_data_width-1) : 0] l_r_data [(l_p_depth-1):0];

    always @(posedge i_w_clk) begin
        if (i_w_cs_a) begin
            if( i_w_we ) begin
                l_r_data[i_w_address_a] <= i_w_in;
            end
            o_r_out_a <= l_r_data[i_w_address_a];
        end
        if (i_w_cs_b) begin
            o_r_out_b <= l_r_data[i_w_address_b];
        end
    end

endmodule