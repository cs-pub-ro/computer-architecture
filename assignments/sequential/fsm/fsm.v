module fsm(
    output wire o_w_out,   // 1 - match SECVENTA, 0 - otherwise
    input wire [1:0] i_w_in,    // char input: 0 - 'a', 1 - 'b', 2 - 'c', 3 - 'd'
    input wire i_w_clk,   // clock input
    input wire i_w_reset  // reset input (active low)
);
    
    
endmodule

