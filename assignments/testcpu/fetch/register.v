// `define DEBUG 1
module register #(
    parameter p_data_width = 8,
    parameter p_initial_value = 16'hxxxx
) (
    output wire [(p_data_width - 1):0] o_w_out,
    input wire [(p_data_width - 1):0] i_w_in,
    input wire i_w_clk,
    input wire i_w_we,
    input wire i_w_oe
);

    reg [(p_data_width - 1):0] l_r_data;
    initial begin
        l_r_data = p_initial_value;
    end

    always @(posedge i_w_clk) begin
        if(i_w_we) begin
            l_r_data <= i_w_in;
        end
    end

    assign o_w_out = i_w_oe ? l_r_data : {p_data_width{1'b0}};


endmodule