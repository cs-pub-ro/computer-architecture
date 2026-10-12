`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:06 11/01/2020
// Design Name:   mealy_fsm
// Module Name:   D:/Facultate/Laborator_AC/2020/lab_4/lab4_sol/ex1a_sol/mealy_fsm_test.v
// Project Name:  ex1_sol
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mealy_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mealy_fsm_test;

	// Inputs
	reg [1:0] x;
	reg rst_n;
	reg clk;

	// Outputs
	wire y;
	
	reg [4:0] i;

	// Instantiate the Unit Under Test (UUT)
	mealy_fsm uut (
		.y(y), 
		.x(x), 
		.rst_n(rst_n), 
		.clk(clk)
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, x=%0d, rst_n=%0d, y=%0d", $time, x, rst_n, y);
		// Initialize Inputs
		x = 0;
		rst_n = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst_n = 1;
		for (i=0; i<16; i= i+3) begin
			x = i[1:0];
			#20;
		end
		for (i=0; i<16; i= i+1) begin
			x = i[1:0];
			#20;
		end
	end
	always #10 clk = ~clk;
      
endmodule

