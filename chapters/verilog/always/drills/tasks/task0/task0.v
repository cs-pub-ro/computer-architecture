module task0 #(
    parameter p_counter_width = 2
) (
    output wire o_w_out,    // found output: 0 - not found, 1 - found
    input wire i_w_in,      // char input: 0 - 'a', 1 - 'b'
    input wire i_w_sim_clk, // simulated clk
    input wire i_w_clk,     // clock input
    input wire i_w_reset    // reset input
);

    wire l_w_debounced_in;
    wire l_w_debounced_sim_clk;
    debouncer #(
        .p_counter_width(p_counter_width)
        ) l_m_debouncer0(
            .o_w_out(l_w_debounced_in),
            .i_w_in(i_w_in),
            .i_w_clk(i_w_clk),
            .i_w_reset(i_w_reset)
        );
    debouncer #(
        .p_counter_width(p_counter_width)
        ) l_m_debouncer1(
            .o_w_out(l_w_debounced_sim_clk),
            .i_w_in(i_w_sim_clk),
            .i_w_clk(i_w_clk),
            .i_w_reset(i_w_reset)
        );

    task01 l_m_task01(
        .o_w_out(o_w_out),
        .i_w_in(l_w_debounced_in),
        .i_w_clk(l_w_debounced_sim_clk),
        .i_w_reset(i_w_reset)
    );
endmodule
