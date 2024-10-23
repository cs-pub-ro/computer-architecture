module alu #(
    parameter p_width = 4
) (
    output wire [((2*p_width)-1):0] o_w_out,
    input wire [(p_width-1):0] i_w_a,
    input wire [(p_width-1):0] i_w_b,
    input wire i_w_sel
);

    wire [p_width:0] l_w_s;
    wire [(2*p_width-1):0] l_w_p;

    adder #( .p_width(p_width) ) l_m_adder (
        .o_w_s(l_w_s),
        .i_w_a(i_w_a),
        .i_w_b(i_w_b)
    );

    multiplier #(.p_width(p_width)) l_m_multiplier(
        .o_w_p(l_w_p),
        .i_w_a(i_w_a),
        .i_w_b(i_w_b)
    );

    assign o_w_out = (i_w_sel == 1'b0) ? l_w_s : l_w_p;

endmodule