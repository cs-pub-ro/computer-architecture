module solution_mux (
    output wire o_w_out,
    input wire [((2**`SEL_WIDTH)-1):0] i_w_in,
    input wire [`SEL_WIDTH-1:0] i_w_sel
);
    assign o_w_out = i_w_in[i_w_sel];
endmodule