`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:30:52 10/31/2020 
// Design Name: 
// Module Name:    register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module register(
        clk,
        rst_n,
        oe,
        we,
        in,
        out,
        disp_out
    );

parameter width = 16;

input               clk;
input               rst_n;
input               oe;
input               we;
input [width-1 : 0] in;
output[width-1 : 0] out;
output[width-1 : 0] disp_out;

reg [width-1 : 0]   data;

always @(posedge clk) begin
    if(!rst_n)
        data <= 0;
    else if(we)
        data <= in;
end

assign out = oe ? data : 0;
assign disp_out = data;

endmodule
