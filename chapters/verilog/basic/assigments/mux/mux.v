module mux #(
    parameter sel_width = 2
) (
    output wire o_w_out,
    input wire [((2**sel_width)-1):0] i_w_in,
    input wire [sel_width-1:0] i_w_sel
);
    assign o_w_out = i_w_in[i_w_sel];
endmodule