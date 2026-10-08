`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:53:01 10/16/2021
// Design Name:   generic_adder
// Module Name:   C:/Users/IonutP/Dropbox/AC/2021-2022/Lab/Lab2/lab2_sol_test/ex2_sol/generic_adder_test.v
// Project Name:  generic_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: generic_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module generic_adder_test;
	
	parameter op_width_test = 6;	//se declara parametrul cu care se testeaza
	
	// Inputs
	reg [op_width_test -1 :0] a_test;	//variabilele se actualizeaza manual; generatorul de test ia in seama doar valoarea default
	reg [op_width_test -1 :0] b_test;

	// Outputs
	wire[op_width_test : 0]   sum_test;

	// Instantiate the Unit Under Test (UUT)
	generic_adder #(
		.op_width(op_width_test)			//se instantiaza folosind parametrul din fisierul de test
		) uut (
		.sum(sum_test), 
		.a(a_test), 
		.b(b_test)
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, a_test=%0d, b_test=%0d, sum_test=%0d", $time, a_test, b_test, sum_test);
		// Initialize Inputs
		a_test = 0;
		b_test = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10; a_test =   3; b_test =   5;
		#10; a_test =   8; b_test =   6;
		#10; a_test =  35; b_test =  48;	
		#10; a_test = 'ha; b_test = 'hb;  
		#10;
	end
      
endmodule

