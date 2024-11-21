module led7conv (
    output wire o_w_ca,
    output wire o_w_cb,
    output wire o_w_cc,
    output wire o_w_cd,
    output wire o_w_ce,
    output wire o_w_cf,
    output wire o_w_cg,
    output wire o_w_dp,
    input wire [3:0] i_w_value
);
    reg [7:0] l_r_led7;

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

    assign {o_w_dp, o_w_cg, o_w_cf, o_w_ce, o_w_cd, o_w_cc, o_w_cb, o_w_ca} = l_r_led7;

endmodule