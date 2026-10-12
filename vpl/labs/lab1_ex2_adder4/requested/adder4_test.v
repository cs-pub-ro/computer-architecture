`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:21:07 10/09/2013
// Design Name:   adder4
// Module Name:   C:/projects/adder4/adder4_test.v
// Project Name:  adder4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder4_test;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire [3:0] sum;
	wire 	   c_out;

	// Instantiate the Unit Under Test (UUT)
	adder4 uut (
		.sum(sum),
		.c_out(c_out),
		.a(a), 
		.b(b) 
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, a=%0d, b=%0d, sum=%0d, c_out=%0d", $time, a, b, sum, c_out);
		// Initialize Inputs
		a = 0;
		b = 0;


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        a = 3;
        b = 5;

        #10;
        a = 10;
        b = 7;

        #10;
        b = 3;
        a = 8;

	end
      
endmodule