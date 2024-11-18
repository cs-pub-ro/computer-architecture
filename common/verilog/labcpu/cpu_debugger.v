`define DEBUG 1
module cpu_debugger #(
    parameter p_data_width = 16,    
    parameter p_address_width = 10,
    parameter p_regs_address_width = 3,
    parameter p_no_cycles = 1000000, // number of cycles for debouncing
    parameter p_divisor = 104167 // 104167 for 480 Hz ( 60Hz * 8 digits), 50% duty cycle
) (
    output wire [7:0] o_w_7_led_seg,
    output wire [7:0] o_w_an,
    output wire o_w_sim_clk,
    input wire [(p_address_width-1):0] i_w_in,
    input wire i_w_next,
    input wire i_w_prev,
    input wire i_w_clk, // the main clock
    input wire i_w_debug_clk, // the debug clock on a switch (for debugging)
    input wire i_w_reset
);

    // CPU
    wire [(p_data_width - 1) : 0]           l_w_cpu_regs_out;
    wire [(p_data_width - 1) : 0]           l_w_cpu_ram;
    wire [(p_data_width - 1) : 0]           l_w_cpu_state;
    wire [(p_data_width - 1) : 0]           l_w_cpu_bus;
    wire [p_regs_address_width : 0]   l_w_cpu_regs_addr;
    assign l_w_cpu_regs_addr = i_w_in[p_regs_address_width : 0];
    wire [(p_address_width - 1) : 0]        l_w_cpu_ram_addr;
    assign l_w_cpu_ram_addr = i_w_in[(p_address_width - 1) : 0];

    cpu #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width),
        .p_regs_address_width(p_regs_address_width)
    ) l_m_cpu (
        .o_w_regs_disp_out(l_w_cpu_regs_out),
        .o_w_ram_disp_out(l_w_cpu_ram),
        .o_w_state_disp_out(l_w_cpu_state),
        .o_w_bus_disp_out(l_w_cpu_bus),
        .i_w_regs_disp_addr(l_w_cpu_regs_addr),
        .i_w_ram_disp_addr(l_w_cpu_ram_addr),
        .i_w_clk(i_w_debug_clk),
        .i_w_ram_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_io_out(16'h0)
    );

    // 7 seg display for state

    // The clock divider
    wire l_w_480HZ_clk;
    assign o_w_sim_clk = l_w_480HZ_clk;

    clock_divider #(
        .p_divisor(p_divisor)
    ) l_m_clk_divider (
        .o_w_clk(l_w_480HZ_clk),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset)
    );
    // Debounce the next and prev buttons
    wire l_w_next_debounced;
    wire l_w_prev_debounced;

    debouncer #(
        .p_no_cycles(p_no_cycles)
    ) l_m_debouncer_next (
        .o_w_out(l_w_next_debounced),
        .i_w_in(i_w_next),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset)
    );

    debouncer #(
        .p_no_cycles(p_no_cycles)
    ) l_m_debouncer_prev (
        .o_w_out(l_w_prev_debounced),
        .i_w_in(i_w_prev),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset)
    );

    // 7 seg display for state
    state_display #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width),
        .p_regs_address_width(p_regs_address_width)
    ) l_m_state_display (
        .o_w_7_led_seg(o_w_7_led_seg),
        .o_w_an(o_w_an),
        .i_w_regs_addr(l_w_cpu_regs_addr),
        .i_w_regs(l_w_cpu_regs_out),
        .i_w_ram(l_w_cpu_ram),
        .i_w_state(l_w_cpu_state),
        .i_w_bus(l_w_cpu_bus),
        .i_w_next(l_w_next_debounced),
        .i_w_prev(l_w_prev_debounced),
        .i_w_clk(l_w_480HZ_clk),
        .i_w_reset(i_w_reset)
    );

endmodule