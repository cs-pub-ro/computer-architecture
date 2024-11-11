module bigalu(
    output wire [3:0] o_w_out,
    input wire [3:0] i_w_op1,
    input wire [3:0] i_w_op2,
    input wire [3:0 ] i_w_sel 
);

    reg [3:0] l_r_out;

    always @(*) begin
        case(i_w_sel)
            4'b0000: l_r_out = i_w_op1 + i_w_op2; // add
            4'b0001: l_r_out = i_w_op1 - i_w_op2; // sub
            4'b0010: l_r_out = i_w_op1 & i_w_op2; // and
            4'b0011: l_r_out = i_w_op1 | i_w_op2; // or
            4'b0100: l_r_out = i_w_op1 ^ i_w_op2; // xor
            4'b0101: l_r_out = i_w_op1 << i_w_op2; // shift left
            4'b0110: l_r_out = i_w_op1 >> i_w_op2; // shift right
            4'b0111: l_r_out = i_w_op1 >>> i_w_op2; // shift right arithmetic
            4'b1000: l_r_out = i_w_op1 * i_w_op2; // multiply
            4'b1001: l_r_out = i_w_op1 / i_w_op2; // divide
            4'b1010: l_r_out = i_w_op1 % i_w_op2; // modulo
            4'b1011: l_r_out = i_w_op1 == i_w_op2; // equal
            4'b1100: l_r_out = i_w_op1 < i_w_op2; // less than
            4'b1101: l_r_out = i_w_op1 > i_w_op2; // greater than
            4'b1110: l_r_out = ~(i_w_op1 & i_w_op2); // NAND
            4'b1111: l_r_out = ~(i_w_op1 | i_w_op2); // NOR
        endcase
    end

    assign o_w_out = l_r_out;

endmodule