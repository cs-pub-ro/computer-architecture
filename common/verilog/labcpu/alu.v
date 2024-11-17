module alu #(
    parameter p_data_width = 16,
    parameter p_flags_width = 5,
    parameter p_opcode_width = 4,
    parameter p_opcode_ADC = 4'd0,
    parameter p_opcode_SBB1 = 4'd1,
    parameter p_opcode_SBB2 = 4'd2,
    parameter p_opcode_NOT = 4'd3,
    parameter p_opcode_AND = 4'd4,
    parameter p_opcode_OR = 4'd5,
    parameter p_opcode_XOR = 4'd6,
    parameter p_opcode_SHL = 4'd7,
    parameter p_opcode_SHR = 4'd8,
    parameter p_opcode_SAR = 4'd9
) (
    output wire [(p_data_width-1):0] o_w_out,
    output wire [(p_flags_width-1):0] o_w_flags,
    input wire [(p_data_width-1):0] i_w_in1,
    input wire [(p_data_width-1):0] i_w_in2,
    input wire [(p_opcode_width-1):0] i_w_opcode,
    input wire i_w_carry,
    input wire i_w_oe
);

// result
reg [(p_data_width-1) : 0]  l_r_result;
// flags
reg l_r_parity;
reg l_r_sign;
reg l_r_zero;
reg l_r_overflow;
reg l_r_carry;

always @(*) begin
    case(i_w_opcode)
        p_opcode_ADC: begin
            {l_r_carry, l_r_result} = i_w_in1 + i_w_in2 + i_w_carry;
            l_r_overflow = (i_w_in1[p_data_width-1] == i_w_in2[p_data_width-1]) &&
                           (i_w_in1[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        p_opcode_SBB1: begin
            {l_r_carry, l_r_result} = i_w_in1 - i_w_in2 - i_w_carry;
            l_r_overflow = (i_w_in1[p_data_width-1] != i_w_in2[p_data_width-1]) &&
                           (i_w_in1[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        p_opcode_SBB2: begin
            {l_r_carry, l_r_result} = i_w_in2 - i_w_in1 - i_w_carry;
            l_r_overflow = (i_w_in2[p_data_width-1] != i_w_in1[p_data_width-1]) &&
                           (i_w_in2[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        p_opcode_NOT: begin
            l_r_result = ~(i_w_in1 | i_w_in2);
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        p_opcode_AND: begin
            l_r_result = i_w_in1 & i_w_in2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        p_opcode_OR: begin
            l_r_result = i_w_in1 | i_w_in2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        p_opcode_XOR: begin
            l_r_result = i_w_in1 ^ i_w_in2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end


        p_opcode_SHL: begin
            l_r_result = (i_w_in1 << 1) | (i_w_in2 << 1);
            l_r_carry = i_w_in1[p_data_width-1] | i_w_in2[p_data_width - 1];
            l_r_overflow = l_r_result[p_data_width-1] != l_r_carry;
        end

        p_opcode_SHR: begin
            l_r_result = (i_w_in1 >> 1) | (i_w_in2 >> 1);
            l_r_carry = i_w_in1[0] | i_w_in2[0];
            l_r_overflow = i_w_in1[p_data_width-1] | i_w_in2[p_data_width-1];
        end

        p_opcode_SAR: begin
            l_r_result = {i_w_in1[p_data_width-1], i_w_in1[p_data_width-1:1]} |
                         {i_w_in2[p_data_width-1], i_w_in2[p_data_width-1:1]};
            l_r_carry = i_w_in1[0] | i_w_in2[0];
            l_r_overflow = 0;
        end

        default: begin
            l_r_result = 0;
            l_r_carry = 0;
            l_r_overflow = 0;
        end
    endcase

    l_r_zero = l_r_result == 0;
    l_r_sign = l_r_result[p_data_width-1];
    l_r_parity = ~^l_r_result;
end

assign o_w_out = i_w_oe ? l_r_result : {p_data_width{1'b0}};
assign o_w_flags = {l_r_parity, l_r_sign, l_r_zero, l_r_overflow, l_r_carry};

endmodule
