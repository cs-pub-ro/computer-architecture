`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:18 10/11/2021 
// Design Name: 
// Module Name:    generic_adder 
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
module generic_adder #(
        parameter op_width = 1
    )(
		output [op_width : 0]     sum, //suma va avea cu un bit mai mult decât operatorii, pentru a putea acomoda carry
		input  [op_width - 1 : 0] a,
		input  [op_width - 1 : 0] b
    );

	assign sum = a + b;

endmodule
