`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:36:02 10/22/2013
// Design Name:   trecere
// Module Name:   C:/projects/trecere/trecere_test.v
// Project Name:  trecere
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: trecere
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module trecere_test;

	// Inputs
	reg clk;

	// Outputs
	wire p_rosu;
	wire p_verde;
	wire m_rosu;
	wire m_galben;
	wire m_verde;

	// Instantiate the Unit Under Test (UUT)
	trecere uut (
		.p_rosu(p_rosu), 
		.p_verde(p_verde), 
		.m_rosu(m_rosu), 
		.m_galben(m_galben), 
		.m_verde(m_verde), 
		.clk(clk)
	);

	initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, p_rosu=%0d, p_verde=%0d, m_rosu=%0d, m_galben=%0d, m_verde=%0d", $time, p_rosu, p_verde, m_rosu, m_galben, m_verde);
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
    
    always #10 clk = !clk;
      
endmodule
