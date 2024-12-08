`timescale 1ns / 1ps

module ALU #(
    parameter p_data_width = 16,
    parameter p_opcode_width = 4,
    parameter p_opcode_ADC = 4'd0,
    parameter p_opcode_AND = 4'd1,
    parameter p_opcode_OR  = 4'd2,
    parameter p_opcode_SHL = 4'd3,
    parameter p_opcode_SHR = 4'd4,
    parameter p_opcode_SAR = 4'd5
) (
    output wire [(p_data_width-1):0] o_w_out, 
    input wire [(p_data_width-1):0] i_w_in1,  
    input wire [(p_data_width-1):0] i_w_in2, 
    input wire [(p_opcode_width-1):0] i_w_opcode, 
    input wire i_w_carry,              
    input wire i_w_oe                 
);
    reg [(p_data_width-1):0] l_r_result;

    always @(*) begin
        case (i_w_opcode)
            p_opcode_ADC: begin
                l_r_result = i_w_in1 + i_w_in2 + i_w_carry; 
            end

            p_opcode_AND: begin
                l_r_result = i_w_in1 & i_w_in2; 
            end

            p_opcode_OR: begin
                l_r_result = i_w_in1 | i_w_in2; 
            end

            p_opcode_SHL: begin
                l_r_result = i_w_in1 << 1; 
            end

            p_opcode_SHR: begin
                l_r_result = i_w_in1 >> 1;  
            end

            p_opcode_SAR: begin
                l_r_result = {i_w_in1[p_data_width-1], i_w_in1[p_data_width-1:1]}; 
            end

            default: begin
                l_r_result = 16'd0; 
            end
        endcase
    end

    assign o_w_out = i_w_oe ? l_r_result : {p_data_width{1'b0}};

endmodule
