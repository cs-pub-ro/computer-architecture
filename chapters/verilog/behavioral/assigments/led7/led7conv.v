module led7conv (
    output wire [6:0] o_w_out,
    input wire [3:0] i_w_value
);
    reg [6:0] l_r_led7;

    always @(*) begin
        case (i_w_value)
            4'd0: l_r_led7 = 7'b011_1111;
            4'd1: l_r_led7 = 7'b000_0110;
            4'd2: l_r_led7 = 7'b101_1011;
            4'd3: l_r_led7 = 7'b100_1111;
            4'd4: l_r_led7 = 7'b110_0110;
            4'd5: l_r_led7 = 7'b110_1101;
            4'd6: l_r_led7 = 7'b111_1101;
            4'd7: l_r_led7 = 7'b000_0111;
            4'd8: l_r_led7 = 7'b111_1111;
            4'd9: l_r_led7 = 7'b110_0111;
            default: l_r_led7 = 7'b111_1111;
        endcase
    end

    assign o_w_out = l_r_led7;

endmodule