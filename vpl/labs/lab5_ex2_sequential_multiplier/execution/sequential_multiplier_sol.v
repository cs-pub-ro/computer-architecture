`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:27 10/31/2020 
// Design Name: 
// Module Name:    sequential_multiplier 
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
module sequential_multiplier(
    clk,
    rst_n,
    a,
    b,
    write,
    multiply,
	 display,
    out);
	 
	 parameter a_width = 8;
	 parameter b_width = 4;
	 parameter product_width = a_width+b_width;
	 parameter state_width = 2;
	 
	 input clk;
	 input rst_n;
	 input [a_width-1:0] a;
	 input [b_width-1:0] b;
	 input write;
	 input multiply;
	 input display;
	 output [product_width-1:0] out;
	
	 reg a_reg_oe;
	 reg a_reg_we;
	 wire[a_width-1:0] a_reg_out;
	 wire [a_width-1:0] a_reg_disp_out;

	 reg b_reg_oe;
	 reg b_reg_we;
	 wire [b_width-1:0] b_reg_out;
	 wire [b_width-1:0] b_reg_disp_out;

	 reg prod_reg_oe;
	 reg prod_reg_we;
	 wire [product_width-1:0] product;
	 wire [product_width-1:0] prod_reg_disp_out;

	 reg [state_width-1:0] state, next_state;
	
	 register #(a_width) a_reg(clk, rst_n, a_reg_oe, a_reg_we, a, a_reg_out, a_reg_disp_out);
	 register #(b_width) b_reg(clk, rst_n, b_reg_oe, b_reg_we, b, b_reg_out, b_reg_disp_out);
	 register #(product_width) prod_reg(clk, rst_n, prod_reg_oe, prod_reg_we, product, out, prod_reg_disp_out);
	 
	 assign product = a_reg_out * b_reg_out;
	 
	 always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			state <= 0;
		else
			state <= next_state;
	 end
	 
	 always @(*) begin
	 	a_reg_oe = 0;
		a_reg_we = 0;
		b_reg_oe = 0;
		b_reg_we = 0;
		prod_reg_oe = 0;
		prod_reg_we = 0;

		case(state)
			0: next_state = write? 1:(multiply? 2: (display? 3: 0));
			1: begin
				a_reg_we = 1;
				b_reg_we = 1;
				next_state = write? 1:(multiply? 2: (display? 3: 0));
			end
			2: begin
				a_reg_oe = 1;
				b_reg_oe = 1;
				prod_reg_we = 1;
				next_state = write? 1:(multiply? 2: (display? 3: 0));
			end
			3: begin
				prod_reg_oe = 1;
				next_state = write? 1:(multiply? 2: (display? 3: 0));
			end
		endcase
	 end

endmodule
