// Single-Port Block RAM Write-First Mode (recommended template)
module block_ram #(
    parameter p_data_width = 8,
    parameter p_address_width = 20,
    parameter p_file = "instructions.mem"
) (
    output reg [(p_data_width-1) : 0] o_r_out,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_address,
    input wire i_w_we,
    input wire i_w_cs,
    input wire i_w_clk
);
    // define the depth of the RAM
    localparam l_p_depth = 2**p_address_width;
    // set the ram_style attribute to "block" to infer block RAM
    (* ram_style = "block" *) reg [(p_data_width-1) : 0] l_r_data [0:(l_p_depth-1)];

    initial begin
        $readmemh(p_file, l_r_data, 0, 2**p_address_width-1);
    end

    always @(posedge i_w_clk) begin
        if (i_w_cs) begin
            if( i_w_we ) begin
                l_r_data[i_w_address] <= i_w_in;
                o_r_out <= i_w_in; // write-first mode
            end else begin
                o_r_out <= l_r_data[i_w_address];
            end
        end
    end

endmodule