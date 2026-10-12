`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:45:03 10/16/2021
// Design Name:   adder4
// Module Name:   C:/Users/IonutP/Dropbox/AC/2021-2022/Lab/Lab2/lab2_sol_test/ex1_sol/adder4_test.v
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
    wire [4:0] sum;

    // Instantiate the Unit Under Test (UUT)
    adder4 uut (
        .sum(sum), 
        .a(a), 
        .b(b)
    );

    initial begin
		// added for VPL: show the values in the console
		$timeformat(-9, 0, " ns", 0);
		$monitor("Time = %t, a=%0d, b=%0d, sum=%0d", $time, a, b, sum);
        // Initialize Inputs
        a = 0;
        b = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #10; a =   3; b =   5;
        #10; a =   8; b =   6;
        #10; a =  14; b =  15;    //este important sa avem cel putin o adunare ce are un rezultat exprimat pe 5 biti
        #10; a = 'ha; b = 'hb;  //numerele se pot exprima si in baza hexa, si in binar. rezultatul este acelasi
        #10;
    end
      
endmodule

