module sol(
    output wire o_w_ca,
    output wire o_w_cb,
    output wire o_w_cc,
    output wire o_w_cd,
    output wire o_w_ce,
    output wire o_w_cf,
    output wire o_w_cg,
    input wire [1:0] i_w_in
);

    reg [3:0] l_r_digit1;
    reg [3:0] l_r_digit2;
    reg [3:0] l_r_digit3;
    reg [3:0] l_r_digit4;

    wire [6:0] l_w_digi1_out;
    wire [6:0] l_w_digi2_out;
    wire [6:0] l_w_digi3_out;
    wire [6:0] l_w_digi4_out;

    initial begin
        l_r_digit1 = 4'd`DIGIT1;
        l_r_digit2 = 4'd`DIGIT2;
        l_r_digit3 = 4'd`DIGIT3;
        l_r_digit4 = 4'd`DIGIT4;
    end

    led7conv l_m_digit1(
        .o_w_out(l_w_digi1_out),
        .i_w_value(l_r_digit1)
    );

    led7conv l_m_digit2(
        .o_w_out(l_w_digi2_out),
        .i_w_value(l_r_digit2)
    );

    led7conv l_m_digit3(
        .o_w_out(l_w_digi3_out),
        .i_w_value(l_r_digit3)
    );

    led7conv l_m_digit4(
        .o_w_out(l_w_digi4_out),
        .i_w_value(l_r_digit4)
    );

    assign {o_w_cg, o_w_cf, o_w_ce, o_w_cd, o_w_cc, o_w_cb, o_w_ca} = (i_w_in == 2'b00) ? l_w_digi1_out :
        (i_w_in == 2'b01) ? l_w_digi2_out :
        (i_w_in == 2'b10) ? l_w_digi3_out :
        l_w_digi4_out;

endmodule