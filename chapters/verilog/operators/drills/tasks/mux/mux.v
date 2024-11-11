module mux(
    output wire o_w_out,	// Output of 4:1 mux
    input wire [3:0] i_w_in,	// 4-bit input data
    input wire [1:0] i_w_sel	// 2-bit select signal
);

    // 4:1 mux implementation using logic expressions
    assign o_w_out = (i_w_in[0] & ~i_w_sel[0] & ~i_w_sel[1]) |
                     (i_w_in[1] & i_w_sel[0] & ~i_w_sel[1]) |
                     (i_w_in[2] & ~i_w_sel[0] & i_w_sel[1]) |
                     (i_w_in[3] & i_w_sel[0] & i_w_sel[1]);

    // 4:1 mux implementation using conditional operator
    assign o_w_out = (i_w_sel[0] == 1'b0) ?
                        ( (i_w_sel[1] == 1'b0) ? i_w_in[0] : i_w_in[2] ) :
                        ( (i_w_sel[1] == 1'b0) ? i_w_in[1] : i_w_in[3] );

    // Note: Comment out one of the implementations above to avoid double assignment to o_w_out
endmodule
