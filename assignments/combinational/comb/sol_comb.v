module sol_comb(
    output wire o_w_out,
    input wire i_w_a,
    input wire i_w_b,
    input wire i_w_c
);

    reg [7:0] l_r_in;

    initial begin
        l_r_in = 8'd`OP0;
    end

    mux l_m_mux(
        .o_w_out(o_w_out),
        .i_w_in(l_r_in),
        .i_w_sel({i_w_a, i_w_b, i_w_c})
    );

endmodule