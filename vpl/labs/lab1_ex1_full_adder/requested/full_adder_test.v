// VPL: '!=' was changed to '!==' so that undriven outputs (x/z) are reported as errors
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:06:18 10/09/2021
// Design Name:   full_adder
// Module Name:   C:/projects/full_adder/full_adder_test.v
// Project Name:  full_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_test;

	// Inputs
	reg a;
	reg b;
	reg c_in;

	// Outputs
	wire sum;
	wire c_out;
	
	//
	reg [1:0] err_cnt = 0;

	// Instantiate the Unit Under Test (UUT)
	full_adder uut (
		.sum(sum), 
		.c_out(c_out), 
		.a(a), 
		.b(b), 
		.c_in(c_in)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		c_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        a = 1;
        b = 0;
        c_in = 1;
		
		#5;
		if(sum !== 0 || c_out !== 1) begin
			$display ("Sum error for a = %d b = %d c_in = %d",a,b,c_in);
			err_cnt = err_cnt + 1;
		end
		
		#10;
		a = 1;
		b = 1;
		c_in = 0;
		
		#5;
		if(sum !== 0 || c_out !== 1) begin
			$display ("Sum error for a = %d b = %d c_in = %d",a,b,c_in);
			err_cnt = err_cnt + 1;
		end
			
		
		#10;
		a = 1;
		b = 0;
		c_in = 0;
		
		#5;
		if(sum !== 1 || c_out !== 0)  begin
			$display ("Sum error for a = %d b = %d c_in = %d",a,b,c_in);
			err_cnt = err_cnt + 1;
			
		end
		
		#10;
		
		if (!err_cnt)
			$display ("Adder1 test completed succesfully");
	end 
      
endmodule