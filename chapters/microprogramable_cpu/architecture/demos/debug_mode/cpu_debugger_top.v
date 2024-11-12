module cpu_debugger_top(
    output wire [6:0] o_w_7seg,
    output wire [7:0] o_w_an,
    output wire o_w_sim_clk,
    input  wire [15:0] i_w_in,
    input wire i_w_next,
    input wire i_w_prev,
    input wire i_w_sim_clk,
    input wire i_w_clk,
    input wire i_w_reset
);
    // active low reset (board has buttons active high)
    wire l_w_reset_n;
    assign l_w_reset_n = ~i_w_reset;

    // clock for 7 seg display
    reg l_r_480HZ_clk = 0;
    // counter for clock devider
    reg [16:0] counter = 0;

    // debounce sim_clk variables
    reg l_r_last_sim_clk;
    reg l_r_debounced_sim_clk = 0;

    assign o_w_sim_clk = l_r_debounced_sim_clk;

    always @(posedge i_w_clk, negedge l_w_reset_n) begin

        if (!l_w_reset_n)
            counter <= 0;
        else begin
            if (counter == 104167) begin  // Divide by 104167 for 480 Hz ( 60Hz * 8 digits), 50% duty cycle
                // reset counter
                counter <= 0;
                // generate clk
                l_r_480HZ_clk <= ~l_r_480HZ_clk;

                // debounce sim_clk
                l_r_last_sim_clk <= i_w_sim_clk;
                if(i_w_sim_clk != l_r_last_sim_clk)
                    l_r_debounced_sim_clk <= i_w_sim_clk;
            end
            else begin
                counter <= counter + 1;
            end
        end

    end

    state_display l_m_state_display(
        .o_w_7seg(o_w_7seg),
        .o_w_an(o_w_an),
        .i_w_in(i_w_in),
        .i_w_next(i_w_next),
        .i_w_prev(i_w_prev),
        .i_w_clk(l_r_480HZ_clk),
        .i_w_reset_n(l_w_reset_n)
    );

endmodule