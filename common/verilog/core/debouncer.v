module debouncer #(
    parameter p_no_cycles = 1000000  // Clock cycles for debouncing
) (
    output reg o_w_out, // Debounced output
    input wire i_w_in, // Input signal
    input wire i_w_clk, // Clock signal
    input wire i_w_reset // Reset signal
);

    // Compute the size of the counter for the debouncing
    localparam l_p_counter_width = $clog2(p_no_cycles);
    reg[(p_counter_width - 1):0] l_r_counter;
    
    always @(posedge i_w_clk) begin
        if(!i_w_reset) begin
            l_r_counter <= 0;
            o_w_out <= 0;
        end else begin
            if(i_w_in == o_w_out) begin
                l_r_counter <= 0;
            end else begin
                if(l_r_counter == (p_no_cycles - 1)) begin
                    o_w_out <= i_w_in;
                    l_r_counter <= 0;
                end else begin
                    l_r_counter <= l_r_counter + 1;
                end
            end
        end
    end
endmodule
