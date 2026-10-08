`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:47:30 10/18/2021 
// Design Name: 
// Module Name:    seven_seg 
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
module seven_seg(
        output [6:0] seven_seq,    
        input  [3:0] number    
    );

    reg [6:0] seven_seg_reg;

    always@(*) begin
        case(number)
            'd0: seven_seg_reg = 7'b011_1111;
            'd1: seven_seg_reg = 7'b000_0110;
            'd2: seven_seg_reg = 7'b101_1011;
            'd3: seven_seg_reg = 7'b100_1111;
            'd4: seven_seg_reg = 7'b110_0110;
            'd5: seven_seg_reg = 7'b110_1101;
            'd6: seven_seg_reg = 7'b111_1101;
            'd7: seven_seg_reg = 7'b000_0111;
            'd8: seven_seg_reg = 7'b111_1111;
            'd9: seven_seg_reg = 7'b110_0111;
            default: seven_seg_reg = 7'b100_0000; //default case -> place "-"
        endcase
    end

    assign seven_seq = seven_seg_reg;
    
endmodule
