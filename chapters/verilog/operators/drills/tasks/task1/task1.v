module task1(
    output wire o_w_out,
    input wire [3:0] i_w_in,
    input wire [1:0] i_w_sel
);

    //TODO 1: Implement mux 4:1 using logic
    assign o_w_out = (i_w_in[0] & ~i_w_sel[0] & ~i_w_sel[1]) |
                     (i_w_in[1] & i_w_sel[0] & ~i_w_sel[1]) |
                     (i_w_in[2] & ~i_w_sel[0] & i_w_sel[1]) |
                     (i_w_in[3] & i_w_sel[0] & i_w_sel[1]);
    //TODO 2: implement mux 4:1 using ?
    assign o_w_out = (i_w_sel[0] == 1'b0) ?
                        ( (i_w_sel[1] == 1'b0) ? i_w_in[0] : i_w_in[2] ) :
                        ( (i_w_sel[1] == 1'b0) ? i_w_in[1] : i_w_in[3] );
endmodule