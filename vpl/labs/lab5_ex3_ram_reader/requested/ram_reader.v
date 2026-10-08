`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:56:36 11/01/2020 
// Design Name: 
// Module Name:    ram_reader 
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
module ram_reader(
    clk,
    rst,
    read,
    am_out,
    ram_out);

    input clk;
    input rst;
    input read;
    input  [9:0]  am_out;
    output [15:0] ram_out;

    parameter width = 16;

    wire disp_clk;
    wire [9:0]  disp_addr;
    wire [16:0] disp_data;

    reg                ram_oe;
    reg                ram_we;
    reg  [width-1 : 0] ram_in;
    wire [width-1 : 0] ram_tmp;

	ram ram (
	  .clka(clk),               // input clka
	  .rsta(ram_oe),            // input rsta
	  .wea(ram_we),             // input [0 : 0] wea
	  .addra(am_out[9:0]),      // input [9 : 0] addra
	  .dina(ram_in),            // input [15 : 0] dina
	  .douta(ram_tmp),          // output [15 : 0] douta
	  .clkb(disp_clk),          // input clkb
	  .web(1'b0),               // input [0 : 0] web
	  .addrb(disp_addr[9:0]),   // input [9 : 0] addrb
	  .dinb(16'b0),             // input [15 : 0] dinb
	  .doutb(disp_data)         // output [15 : 0] doutb
	);

	// TODO: Implementați un automat de stări care citește valoarea aflată la adresa am_out la activarea semnalului read

endmodule

