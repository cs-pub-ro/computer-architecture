`timescale 1ns / 1ps
module registers#(
    parameter p_data_width = 16,
    parameter p_address_width = 3
)(
    output wire [(p_data_width-1) : 0] o_w_out,
    output wire [(p_data_width-1) : 0] o_w_disp_out,
    input wire [(p_data_width-1) : 0] i_w_in,
    input wire [(p_address_width-1) : 0] i_w_address,
    input wire [(p_address_width-1) : 0] i_w_disp_address,
    input wire i_w_we,
    input wire i_w_oe,
    input wire i_w_clk
);

    reg [(p_data_width-1) : 0] l_r_data [2**p_address_width-1:0];

    always @(posedge i_w_clk) begin
        if( (i_w_we == 1'b1) && (i_w_oe == 1'b0) ) begin
            l_r_data[i_w_address] <= i_w_in;
        end
    end

    assign o_w_out = ( (i_w_oe == 1'b1) && (i_w_we == 1'b0) ) ? l_r_data[i_w_address] : {p_data_width{1'b0}};

    assign o_w_disp_out = l_r_data[i_w_disp_address];

endmodule
