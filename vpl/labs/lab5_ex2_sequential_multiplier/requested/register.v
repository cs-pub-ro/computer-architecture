`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:36 11/01/2020 
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

	input clk;
	input rst_n;
	input oe;
	input we;
	input [7:0] in;
	output[7:0] out;
	output[7:0] disp_out;

	// TODO: a. Implementa?i logica modulului 
	// TODO: b. Parametriza?i modulul

endmodule
