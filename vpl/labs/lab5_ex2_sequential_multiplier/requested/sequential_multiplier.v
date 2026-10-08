`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:07 11/01/2020 
// Design Name: 
// Module Name:    sequential_multiplier 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sequential_multiplier(
     clk,
     rst_n,
     a,
     b,
     write,
     multiply,
     display,
     out);
     
     parameter a_width = 8;
     parameter b_width = 4;
     // TODO: Declara?i parametrul product_width astfel �nc�t logica modulului sa fie corecta
	  // Nota: Valorile 8 ?i 4 pot fi reconfigurate, prin urmare product_width se va adapta odata cu ele
     
     input clk;
     input rst_n;
     input write;
     input multiply;
     input display;
     input [a_width-1:0] a;
     input [b_width-1:0] b;
     output [product_width-1:0] out;
    
    // TODO: Implementa?i logica automatului de stari, conform cerin?ei

endmodule
