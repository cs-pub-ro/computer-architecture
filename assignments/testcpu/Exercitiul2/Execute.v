`timescale 1ns / 1ps

module Execute #(
    parameter p_data_width = 16
)(
    output [p_data_width-1:0] out_t1, // ALU output
    input [p_data_width-1:0] i_ir,    // RI code
    input [p_data_width-1:0] i_t1,    // T1 value
    input [p_data_width-1:0] i_t2,    // T2 value
    input i_w_clk,                    // Clock
    input i_w_reset,                  // Reset
    input i_w_carry                   // Carry
);

endmodule