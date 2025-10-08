module led7hex (
    output reg [7:0] l_r_led7,
    input wire [3:0] i_w_value
);
    always @(*) begin
        case (i_w_value)
            4'h0: l_r_led7 = 8'b1100_0000;
            4'h1: l_r_led7 = 8'b1111_1001;
            4'h2: l_r_led7 = 8'b1010_0100;
            4'h3: l_r_led7 = 8'b1011_0000;
            4'h4: l_r_led7 = 8'b1001_1001;
            4'h5: l_r_led7 = 8'b1001_0010;
            4'h6: l_r_led7 = 8'b1000_0010;
            4'h7: l_r_led7 = 8'b1111_1000;
            4'h8: l_r_led7 = 8'b1000_0000;
            4'h9: l_r_led7 = 8'b1001_1000;
            4'hA: l_r_led7 = 8'b1000_1000;
            4'hB: l_r_led7 = 8'b1000_0011;
            4'hC: l_r_led7 = 8'b1100_0110;
            4'hD: l_r_led7 = 8'b1010_0001;
            4'hE: l_r_led7 = 8'b1000_0110;
            4'hF: l_r_led7 = 8'b1000_1110;
            default: l_r_led7 = 8'b1111_1111;
        endcase
    end
endmodule