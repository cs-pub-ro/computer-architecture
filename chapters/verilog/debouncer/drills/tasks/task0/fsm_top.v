module fsm_top(
    input clk,
    input [7:0] read_frequency, // More is slower
    input i_w_reset,
    input i_w_in,
    output o_w_out,
    output o_w_dbg_clk
);
    // Board has this frequency by default
    parameter CLOCK_FREQUENCY = 100_000_000;
    
    reg [31:0] counter;
    reg l_r_sim_clk; // Simulated clock to make transitions easier to see
    assign o_w_dbg_clk = l_r_sim_clk;
    initial begin
        counter = 0;
        l_r_sim_clk = 0;
    end

    task01 l_m_task01(
        .o_w_out(o_w_out),
        .i_w_in(i_w_in),
        .i_w_clk(l_r_sim_clk),
        .i_w_reset(i_w_reset)
    );

    
    always@(posedge clk) begin
        if (read_frequency >= 1) begin
            counter <= counter + 1;
            if (counter >= CLOCK_FREQUENCY/(read_frequency + 1)) begin
                l_r_sim_clk <= ~l_r_sim_clk; // Simulate posedge/negedge
                counter <= 0;
            end
        end else begin 
            counter <= 0;
        end
    end
    
    
endmodule
