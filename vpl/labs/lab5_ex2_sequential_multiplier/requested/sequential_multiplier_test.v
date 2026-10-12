// VPL: '!=' was changed to '!==' so that undriven outputs (x/z) are reported as errors
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:01:39 10/31/2020
// Design Name:   sequential_multiplier
// Module Name:   D:/Facultate/Laborator_AC/2020/ex_2/sequential_multiplier_test.v
// Project Name:  ex_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sequential_multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sequential_multiplier_test;

	// Inputs
	reg clk;
	reg rst_n;
	reg [7:0] a;
	reg [3:0] b;
	reg write;
	reg multiply;
	reg display;

	// Outputs
	wire [11:0] out;

	integer i;
	integer j;
	reg [11:0] reference;
	reg [10:0] errors;
	reg [10:0] instr_counter;

	// Instantiate the Unit Under Test (UUT)
	sequential_multiplier uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.a(a), 
		.b(b), 
		.write(write), 
		.multiply(multiply), 
		.display(display), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		a = 0;
		b = 0;
		write = 0;
		multiply = 0;
		display = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst_n = 1;
		errors = 0;
		instr_counter = 1;
		for (i=0; i<256; i=i+2) begin
			for (j=0; j<16; j=j+3) begin
				instr_counter = instr_counter + 1;
				a = i;
				b = j;
				#20;
				write = 1;
				#25;
				write = 0;
				multiply = 1;
				#20;
				multiply = 0;
				display = 1;
				#30;
				reference = a*b;
				if(out !== reference) begin
					$display("[ERROR] Mismatch: For a=%d and b=%d found out=%d. Expected: %d", a, b, out, reference);
					errors = errors + 1;
				end
				display = 0;
			end
		end
		if (errors == 0)
			$display("[INFO] Success! The simulation ended without any error. Score: %d/%d",
						instr_counter-errors, instr_counter);
		else
			$display("[INFO] Failure! The simulation ended with errors. Score: %d/%d",
						instr_counter-errors, instr_counter);
		$finish;
	end
      always #10 clk = ~clk;
endmodule

