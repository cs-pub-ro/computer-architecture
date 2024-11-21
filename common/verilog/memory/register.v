module register #(
    parameter p_data_width = 8
) (
    output wire [(p_data_width - 1):0] o_w_out,
`ifdef DEBUG
    output wire [(p_data_width - 1):0] o_w_disp_out,
`endif
    input wire [(p_data_width - 1):0] i_w_in,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire i_w_we,
    input wire i_w_oe
);

    reg [(p_data_width - 1):0] l_r_data;

    always @(posedge i_w_clk) begin
        if(!i_w_reset) begin
            l_r_data <= 0;
        end else begin
            if(i_w_we) begin
                l_r_data <= i_w_in;
            end
        end
    end

    assign o_w_out = i_w_oe  ? l_r_data : {p_data_width{1'bz}};

`ifdef DEBUG
    assign o_w_disp_out = l_r_data;
`endif
endmodule