`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:30:50 10/22/2013
// Design Name:   ba
// Module Name:   C:/projects/ba/ba_test.v
// Project Name:  ba
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ba
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ba_test;

	// Inputs
	wire i;
	reg clk;

	// Outputs
	wire o;

	// Instantiate the Unit Under Test (UUT)
	ba uut (
		.o(o), 
		.i(i), 
		.clk(clk)
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, i=%0d, o=%0d", $time, i, o);
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
    
    // Generate clock
    always #10 clk = !clk;
    
    reg [0:7] is = 8'b00101101;     // inputs to cycle through
    reg [2:0] count = 3'b0;         // index to cycle through inputs
    
    // Increment index at each clock
    always @(posedge clk) count <= count + 1;
    
    // Assign input based on curent index; delay 8 timeunits to simulate asynchronous input
    assign #8 i = is[count];
      
endmodule
