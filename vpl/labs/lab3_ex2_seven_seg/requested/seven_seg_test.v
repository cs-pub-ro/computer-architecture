`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:55:24 10/18/2021
// Design Name:   seven_seg
// Module Name:   C:/Users/IonutP/Dropbox/AC/2021-2022/Lab/Lab3/lab3_skel/ex2_skel/seven_seg_test.v
// Project Name:  seven_seg
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: seven_seg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module seven_seg_test;

	// Inputs
	reg [3:0] number;

	// Outputs
	wire [6:0] seven_seq;
	
	// Local TB variables
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	seven_seg uut (
		.seven_seq(seven_seq), 
		.number(number)
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, number=%0d, seven_seq=%0b", $time, number, seven_seq);
		// Initialize Inputs
		number = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for ( i = 0 ; i < 11; i = i + 1 ) begin
			#10; number = i;
		end
	end
      
endmodule

