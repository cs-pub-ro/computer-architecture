module fsm_top(
    input clk,
    input [3:0] read_frequency, // More is slower
    input i_w_reset,
    input wire [2:0] i_w_sel,        // input wire
    input wire [3:0] i_w_dig,        // input wire
    input wire we,
    output wire [7:0] o_w_out,   // found output: 0 - not found, 1 - found
    output wire [7:0] o_w_sel,    // char input: 0 - 'a', 1 - 'b'
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
    wire [2:0] l_w_sel;
    assign o_w_out[7] = &o_w_out[6:0] ? 0 : 1;

    assign o_w_sel = ~(1 << l_w_sel);

    seqssg ssg(
        .o_w_out(o_w_out[6:0]),   // found output: 0 - not found, 1 - found
        .o_w_sel(l_w_sel),    // char input: 0 - 'a', 1 - 'b'
        .i_w_sel(i_w_sel),        // input wire
        .i_w_dig(i_w_dig),        // input wire
        .we(we),
        .i_w_clk(l_r_sim_clk),   // clock input
        .i_w_reset(i_w_reset)
    );

    
    always@(posedge clk) begin
        // If 0, stop clock
        if (read_frequency >= 1) begin
            counter <= counter + 1;
            if (counter >= CLOCK_FREQUENCY >> (read_frequency - 1)) begin
                l_r_sim_clk <= ~l_r_sim_clk; // Simulate posedge/negedge
                counter <= 0;
            end
        end else begin 
            counter <= 0;
        end
    end
    
    
endmodule
