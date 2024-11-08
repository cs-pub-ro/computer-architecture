module alu #(
    parameter p_data_width = 5, // 5 for FPGA testing, 16 for Simulation and inside the CPU
    parameter p_flags_width = 5
)(
    output wire [(p_data_width-1):0] o_w_out,
    output wire [(p_flags_width-1):0] o_w_flags,
    input wire [(p_data_width-1):0] i_w_op1,
    input wire [(p_data_width-1):0] i_w_op2,
    input wire [3:0] i_w_opcode,
    input wire i_w_carry,
    input wire i_w_oe
);

localparam ADC  = 4'd0;
localparam SBB1 = 4'd1;
localparam SBB2 = 4'd2;
localparam NOT  = 4'd3;
localparam AND  = 4'd4;
localparam OR   = 4'd5;
localparam XOR  = 4'd6;
localparam SHL  = 4'd7;
localparam SHR  = 4'd8;
localparam SAR  = 4'd9;

reg [(p_data_width-1) : 0]  l_r_result;
reg l_r_parity;
reg l_r_sign;
reg l_r_zero;
reg l_r_overflow;
reg l_r_carry;

always @(*) begin
    case(i_w_opcode)
        ADC: begin
            {l_r_carry, l_r_result} = i_w_op1 + i_w_op2 + i_w_carry;
            l_r_overflow = (i_w_op1[p_data_width-1] == i_w_op2[p_data_width-1]) &&
                           (i_w_op1[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        SBB1: begin
            {l_r_carry, l_r_result} = i_w_op1 - i_w_op2 - i_w_carry;
            l_r_overflow = (i_w_op1[p_data_width-1] != i_w_op2[p_data_width-1]) &&
                           (i_w_op1[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        SBB2: begin
            {l_r_carry, l_r_result} = i_w_op2 - i_w_op1 - i_w_carry;
            l_r_overflow = (i_w_op2[p_data_width-1] != i_w_op1[p_data_width-1]) &&
                           (i_w_op2[p_data_width-1] != l_r_result[p_data_width-1]);
        end

        AND: begin
            l_r_result = i_w_op1 & i_w_op2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        OR: begin
            l_r_result = i_w_op1 | i_w_op2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        XOR: begin
            l_r_result = i_w_op1 ^ i_w_op2;
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        NOT: begin
            l_r_result = ~(i_w_op1 | i_w_op2);
            l_r_carry = 0;
            l_r_overflow = 0;
        end

        SHL: begin
            l_r_result = (i_w_op1 << 1) | (i_w_op2 << 1);
            l_r_carry = i_w_op1[p_data_width-1] | i_w_op2[p_data_width - 1];
            l_r_overflow = l_r_result[p_data_width-1] != l_r_carry;
        end

        SHR: begin
            l_r_result = (i_w_op1 >> 1) | (i_w_op2 >> 1);
            l_r_carry = i_w_op1[0] | i_w_op2[0];
            l_r_overflow = i_w_op1[p_data_width-1] | i_w_op2[p_data_width-1];
        end

        SAR: begin
            l_r_result = {i_w_op1[p_data_width-1], i_w_op1[p_data_width-1:1]} |
                         {i_w_op2[p_data_width-1], i_w_op2[p_data_width-1:1]};
            l_r_carry = i_w_op1[0] | i_w_op2[0];
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
