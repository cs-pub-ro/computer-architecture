module full_opregister(
    output wire [3:0] o_w_out,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire [3:0] i_w_data,
    input wire i_w_we,
    input wire i_w_oe,
    input wire [3:0] i_w_opsel
);

    reg signed [3:0] l_r_data;

    always @(posedge i_w_clk) begin
        if (!i_w_reset) begin
            l_r_data <= 4'd0;
        end else if (i_w_we) begin
            l_r_data <= i_w_data;
        end else if (i_w_oe == 1'b0) begin
            case (i_w_opsel)
                4'd0: l_r_data <= l_r_data >> 1;
                4'd1: l_r_data <= l_r_data << 1;
                4'd2: l_r_data <= l_r_data >>> 1;
                4'd3: l_r_data <= {l_r_data[0], l_r_data[3:1]};
                4'd4: l_r_data <= {l_r_data[2:0], l_r_data[3]};
                4'd5: l_r_data <= {3'b000, |l_r_data};
                4'd6: l_r_data <= {3'b000, ^l_r_data};
                4'd7: l_r_data <= {3'b000, &l_r_data};
                4'd8: l_r_data <= ~l_r_data + 1;
                4'd9: l_r_data <= ~l_r_data;
                4'd10: l_r_data <= l_r_data + 1;
                4'd11: l_r_data <= l_r_data - 1;
                default: l_r_data <= l_r_data;
            endcase
        end
    end

    assign o_w_out =  (i_w_oe && (i_w_we == 1'b0)) ? l_r_data : 4'd0;

endmodule