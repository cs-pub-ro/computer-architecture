// VPL: '!=' was changed to '!==' so that undriven outputs (x/z) are reported as errors
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:00:36 11/01/2020
// Design Name:   ram_reader
// Module Name:   D:/Facultate/Laborator_AC/2020/ex3_skel/ram_reader_test.v
// Project Name:  ex3_skel
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_reader
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_reader_test;

	// Inputs
	reg clk;
	reg rst;
	reg read;
	reg [9:0] am_out;
	wire [15:0] ram_out;

	reg [3:0] i;
	reg [3:0] errors;
	reg [3:0] instr_counter;
	reg [15:0] reference [0:9];
	// Instantiate the Unit Under Test (UUT)
	ram_reader uut (
		.clk(clk), 
		.rst(rst),
		.read(read),
		.am_out(am_out),
		.ram_out(ram_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reference[0] = 16'h0304;
		reference[1] =16'h000a;
		reference[2] =16'h4304;
		reference[3] =16'h0000;
		reference[4] =16'he304;
		reference[5] =16'h0000;
		reference[6] =16'hc304;
		reference[7] =16'h0000;
		reference[8] =16'he110;
		reference[9] =16'h0016;
		rst = 1;
		instr_counter = 0;
		errors = 0;
		for (i=0; i<10; i=i+1) begin
			instr_counter = instr_counter + 1;
			am_out = i;
			#5;
			read = 1;
			#25;
			if (ram_out !== reference[i]) begin
				errors = errors+1;
				$display("[ERROR] Mismatch: Expected ram_out = %h. Found ram_out = %h", reference[i], ram_out);
			end
			read = 0;
			#100;
		end
		if(errors ==0)
			$display("[INFO] Success! Simulation ended without any error. Score: %d/%d",
						instr_counter-errors, instr_counter);
		else
			$display("[INFO] Failure! Simulation ended with errors. Score: %d/%d",
						instr_counter-errors, instr_counter);
		$finish;
	end
   
	
	always #10 clk = !clk;
endmodule

