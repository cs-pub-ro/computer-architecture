module test_cpu_debugger;

    // Parameters
    parameter p_data_width = 16;
    parameter p_address_width = 10;
    parameter p_regs_address_width = 3;

    // Inputs
    reg [(p_address_width-1):0] i_w_in;
    reg i_w_next;
    reg i_w_prev;
    reg i_w_clk;
    reg i_w_debug_clk;
    reg i_w_reset;

    // Outputs
    wire [7:0] o_w_7_led_seg;
    wire [7:0] o_w_an;
    wire o_w_sim_clk;

    // Instantiate the Unit Under Test (UUT)
    `define SIMULATION 1
    cpu_debugger #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width),
        .p_regs_address_width(p_regs_address_width),
        .p_divisor(4),
        .p_no_cycles(1)
    ) uut (
        .o_w_7_led_seg(o_w_7_led_seg),
        .o_w_an(o_w_an),
        .o_w_sim_clk(o_w_sim_clk),
        .i_w_in(i_w_in),
        .i_w_next(i_w_next),
        .i_w_prev(i_w_prev),
        .i_w_clk(i_w_clk),
        .i_w_debug_clk(i_w_debug_clk),
        .i_w_reset(i_w_reset)
    );

    // Clock generation
    always #2 i_w_clk = ~i_w_clk; // 100 MHz clock

    always #20 i_w_debug_clk = ~i_w_debug_clk; // 50 MHz clock
    // Test sequence
    initial begin

        `ifdef SIMULATION
        $display("Running in test mode");
        `endif
        // monitor the outputs
        $monitor(
            "Time = %0t, ", $time,
            "o_w_7_led_seg=%h, ", o_w_7_led_seg,
            "o_w_an=%h, ", o_w_an,
            "o_w_sim_clk=%h ", o_w_sim_clk,
            "state_display_state=%h ", uut.l_m_state_display.l_r_state,
            "l_w_cpu_state=%h", uut.l_w_cpu_state
            );

        // Initialize Inputs
        i_w_clk = 0;
        i_w_debug_clk = 0;

        i_w_in = 0;
        i_w_next = 0;
        i_w_prev = 0;
        i_w_reset = 0;

        // Wait for global reset to finish
        #100;
        i_w_reset = 1;
        i_w_next = 1;
        #16;
        #16;
        #16;
        #16;
        #16;
        i_w_next = 0;
        #16;
        #16;
        #16;
        #16;
        #16;
        i_w_next = 1;
        #16;
        #16;
        #16;
        #16;
        #16;
        i_w_next = 0;
        #16;
        #16;
        #16;
        #16;
        #16;
        i_w_next = 1;
        #16;
        #16;
        #16;
        #16;
        #16;
        i_w_next = 0;
        #16;
        #16;
        #16;
        #16;
        #16;



        // Add more test cases as needed
        #1000;
        #1000;
        $finish;
    end

endmodule