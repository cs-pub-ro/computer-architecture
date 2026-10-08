`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:16:24 10/19/2020 
// Design Name: 
// Module Name:    demux1_4 
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
module multiplier(
	output reg [7:0] prod,
	input      [3:0] a,
	input      [3:0] b);
	
	reg [2:0] i;
	
	always@(*) begin : prod_block
		prod = 0;
		
		for(i = 0; i < 4; i = i + 1) begin
			if ( b[i] )
				prod = prod + (a << i);
		end
	end
	
endmodule 
	
	