// Registers file
module regfile #(
    parameter p_data_width = 5,
    parameter p_address_width = 3
) (
    `ifdef DEBUG
    output wire [(p_data_width-1) : 0] o_w_disp_out,
    input wire [(p_address_width-1) : 0] i_w_disp_reg,
    `endif
    output wire [(p_data_width-1) : 0] o_w_out,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_reg,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_reset,
    input wire i_w_clk
);

    // define the depth of the RAM
    localparam l_p_depth = 2**p_address_width;
    // set the ram_style attribute to "block" to infer block RAM
    reg [(p_data_width-1) : 0] l_r_data [(l_p_depth-1):0];
    genvar i;

    always @(posedge i_w_clk) begin
        if (!i_w_reset) begin
            generate
                for (i = 0; i < l_p_depth; i = i + 1) begin
                    l_r_data[i] <= 0;
                end
            endgenerate
        end else begin
            if (i_w_we) begin
                l_r_data[i_w_reg] <= i_w_in;
            end
        end
    end

    assign o_w_out = i_w_oe ? l_r_data[i_w_reg] : {p_data_width{1'b0}};

    `ifdef DEBUG
    assign o_w_disp_out = l_r_data[i_w_disp_reg];
    `endif


endmodule