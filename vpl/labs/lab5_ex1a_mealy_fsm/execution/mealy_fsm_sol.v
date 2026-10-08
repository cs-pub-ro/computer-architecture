`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:43:02 09/22/2020 
// Design Name: 
// Module Name:    mealy_fsm 
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
module mealy_fsm (
    output reg y,
    input [1:0] x,
    input rst_n,
    input clk);

    parameter S0=0;
    parameter S1=1;
    parameter S2=2;
    parameter S3=3;

    reg [2:0] state, next_state;

    always @(posedge clk)
        if(!rst_n) begin
            state<=S0;
        end
        else begin
            state<=next_state;
        end
            
    always @(*) begin
        next_state = S0;
        y = 1'b0;
        case(state)
            S0: begin
                next_state= (x==2'b11)?S0:
                            (x==2'b10)?S2:
                            (x==2'b01)?S1:S0;
                y=1'b0;
            end
            S1: begin
                next_state= (x==2'b11)?S1:
                            (x==2'b10)?S3:
                            (x==2'b01)?S0:S2;
                y=1'b0;
            end
            S2: begin
                next_state= (x==2'b11)?S2:
                            (x==2'b10)?S1:
                            (x==2'b01)?S0:S3;
                y=(x==2'b00)?1'b1:1'b0;
            end
            S3: begin
                next_state= (x==2'b11)?S0:
                            (x==2'b10)?S3:
                            (x==2'b01)?S0:S1;
                y=(x==2'b00||x==2'b10)?1'b1:1'b0;
            end
            default: begin
                next_state=S0;
                y='b0;
            end
        endcase
    end
endmodule