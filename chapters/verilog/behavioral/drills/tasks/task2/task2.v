module task2 #(
    parameter p_width = 1
) (
    output wire [(2*p_width):0] o_w_out,
    input wire [p_width:0] i_w_a,
    input wire [p_width:0] i_w_b,
    input wire i_w_sel
);

    wire [(p_width+1):0] l_w_s;
    wire [(2*p_width):0] l_w_p;

    task21 #( .p_width(p_width) ) l_m_task21 (
        .o_w_s(l_w_s),
        .i_w_a(i_w_a),
        .i_w_b(i_w_b)
    );

    task0 #(.p_width(p_width)) l_m_task0(
        .o_w_p(l_w_p),
        .i_w_a(i_w_a),
        .i_w_b(i_w_b)
    );

    assign o_w_out = (i_w_sel == 1'b0) ? l_w_s : l_w_p;

endmodule