`timescale 1ns / 1ps

module register#(
    parameter p_data_width = 16
)(
    output wire [(p_data_width - 1):0] o_w_out,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire [(p_data_width - 1):0] i_w_in,
    input wire i_w_we,
    input wire i_w_oe
);

    reg [(p_data_width - 1):0] l_r_data;

    always @(posedge i_w_clk) begin
        if(i_w_reset == 1'b0) begin
            l_r_data <= 0;
        end else begin
            if( (i_w_we == 1'b1) && (i_w_oe == 1'b0) ) begin
                l_r_data <= i_w_in;
            end
        end
    end

    assign o_w_out = ( (i_w_oe == 1'b1) && (i_w_we == 1'b0) ) ? l_r_data : {p_data_width{1'b0}};
endmodule