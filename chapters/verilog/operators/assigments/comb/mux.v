module mux (
    output wire o_w_out,
    input wire [7:0] i_w_in,
    input wire [2:0] i_w_sel
);
    assign o_w_out = i_w_in[i_w_sel];
endmodule