`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:32:09 11/01/2020
// Design Name:   moore_fsm
// Module Name:   D:/Facultate/Laborator_AC/2020/lab_4/lab4_sol/ex1b_sol/moore_fsm_test.v
// Project Name:  ex1b_sol
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: moore_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module moore_fsm_test;

	// Inputs
	reg x;
	reg rst_n;
	reg clk;

	// Outputs
	wire y;

	reg [5:0] i;
	reg [31:0] test;

	// Instantiate the Unit Under Test (UUT)
	moore_fsm uut (
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
		test = 32'b1001_0110_1101_0100_1000_1110_1001_0010;
		for (i=0; i<32; i=i+1) begin
			x = test[i];
			#20;
		end
	end
	always #10 clk = ~clk;
      
endmodule

