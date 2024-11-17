module clock_divider #(
  parameter p_divisor = 2 // Clock division factor
) (
    output reg o_w_clok      // Output divided clock
    input wire i_w_clk,      // Input clock
    input wire i_w_reset,       // Reset signal
);

    // Compute the size of the counter for the division
    localparam l_p_counter_width = $clog2(p_divisor);
    reg [l_p_counter_width-1:0] counter;

    always @(posedge i_w_clk or posedge i_w_reset) begin
        if (!i_w_reset) begin
            counter <= 0;
            o_w_clk <= 0;
        end else begin
            if (counter == (p_divisor - 1)) begin
                counter <= 0;
                o_w_clk <= ~o_w_clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule