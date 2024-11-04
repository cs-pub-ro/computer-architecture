module sequential_multiplier #(
    parameter p_data_width = 4
)(
    output wire [(2*p_data_width-1):0] o_w_out,
    output wire [(p_data_width-1):0] o_w_disp_a,
    output wire [(p_data_width-1):0] o_w_disp_b,
    input wire [(p_data_width-1):0] i_w_a,
    input wire [(p_data_width-1):0] i_w_b,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire i_w_write,
    input wire i_w_multiply,
    input wire i_w_display 
);

    wire l_w_a_we;
    wire l_w_a_oe;
    wire [(p_data_width-1):0] l_w_a_out;
    register #(.p_data_width(p_data_width)) l_m_register_0 (
        .o_w_out(l_w_a_out),
        .o_w_disp_out(o_w_disp_a),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_in(i_w_a),
        .i_w_we(l_w_a_we),
        .i_w_oe(l_w_a_oe)
    );

    wire l_w_b_we;
    wire l_w_b_oe;
    wire [(p_data_width-1):0] l_w_b_out;
    register #(.p_data_width(p_data_width)) l_m_register_1 (
        .o_w_out(l_w_b_out),
        .o_w_disp_out(o_w_disp_b),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_in(i_w_b),
        .i_w_we(l_w_b_we),
        .i_w_oe(l_w_b_oe)
    );
    

    wire l_w_c_we;
    wire l_w_c_oe;
    wire [(2*p_data_width-1):0] l_w_c_out;
    wire [(2*p_data_width-1):0] l_w_c_in;
    assign l_w_c_in = (l_w_a_out * l_w_b_out);
    register #(.p_data_width(2*p_data_width)) l_m_register_2 (
        .o_w_out(l_w_c_out),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_in(l_w_c_in),
        .i_w_we(l_w_c_we),
        .i_w_oe(l_w_c_oe)
    );

    localparam STATE_INITIAL = 2'd0;
    localparam STATE_WRITE = 2'd1;
    localparam STATE_MULTIPLY = 2'd2;
    localparam STATE_DISPLAY = 2'd3;

    reg [1:0] l_r_state;
    reg [1:0] l_r_next_state;

    always @(posedge i_w_clk) begin
		if(i_w_reset == 1'b0) begin
            l_r_state <= STATE_INITIAL;
        end else begin
            l_r_state <= l_r_next_state;
        end
	end

    always @(*) begin 
        l_r_next_state = i_w_write ?
                            STATE_WRITE :
                            (i_w_multiply ?
                                STATE_MULTIPLY :
                                (i_w_display ?
                                    STATE_DISPLAY :
                                    STATE_INITIAL));
    end

    assign l_w_a_we = l_r_state == STATE_WRITE;
    assign l_w_a_oe = l_r_state == STATE_MULTIPLY;
    assign l_w_b_we = l_r_state == STATE_WRITE;
    assign l_w_b_oe = l_r_state == STATE_MULTIPLY;
    assign l_w_c_we = l_r_state == STATE_MULTIPLY;
    assign l_w_c_oe = l_r_state == STATE_DISPLAY;

    assign o_w_out = l_w_c_out;

endmodule