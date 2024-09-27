module task1(
    output wire o_w_red,
    output wire o_w_yellow,
    output wire o_w_green,
    input wire i_w_clk,
    input wire i_w_reset
);

    localparam STATE_INITIAL  = 3'd0;
    localparam STATE_RED      = 3'd1;
    localparam STATE_RED_WAIT = 3'd2;
    localparam STATE_GREEN    = 3'd3;
    localparam STATE_GREEN_WAIT = 3'd4;
    localparam STATE_YELLOW    = 3'd5;
    localparam STATE_YELLOW_WAIT    = 3'd6;


    reg [2:0] l_r_state;      //  current state;
    reg [2:0] l_r_next_state; // used to compute next state
    reg [7:0] l_r_value;
    wire l_w_ready;
    wire l_w_done;

    task11 l_m_task11(
        .o_w_done(l_w_done),
        .i_w_clk(i_w_clk),
        .i_w_ready(l_w_ready),
        .i_w_reset(i_w_reset),
        .i_w_value(l_r_value)
    );

    // sequential part
    always @(posedge i_w_clk) begin
        if(i_w_reset) begin
            l_r_state <= STATE_INITIAL;
        end else begin
            l_r_state <= l_r_next_state;
        end
    end

    // combinational part
    always @(*) begin
        case(l_r_state)
            STATE_INITIAL: begin
                l_r_next_state = STATE_RED;
            end
            
            STATE_RED: begin
                l_r_value = 8'd60;
                l_r_next_state = STATE_RED_WAIT;
            end
            
            STATE_RED_WAIT: begin
                if(l_w_done == 1'b1) begin
                    l_r_next_state = STATE_GREEN;
                end else begin
                    l_r_next_state = STATE_RED_WAIT;
                end
            end
            
            STATE_GREEN: begin
                l_r_value = 8'd30;
                l_r_next_state = STATE_GREEN_WAIT;
            end
            
            STATE_GREEN_WAIT: begin
                if(l_w_done == 1'b1) begin
                    l_r_next_state = STATE_YELLOW;
                end else begin
                    l_r_next_state = STATE_GREEN_WAIT;
                end
            end
            
            STATE_YELLOW: begin
                l_r_value = 8'd30;
                l_r_next_state = STATE_YELLOW_WAIT;
            end
            
            STATE_YELLOW_WAIT: begin
                if(l_w_done == 1'b1) begin
                    l_r_next_state = STATE_RED;
                end else begin
                    l_r_next_state = STATE_YELLOW_WAIT;
                end
            end
            
            default: begin
                l_r_next_state = STATE_INITIAL;
            end
        endcase
    end

    //output part
    assign l_w_ready = (l_r_state == STATE_RED) ||
                       (l_r_state == STATE_GREEN) ||
                       (l_r_state == STATE_YELLOW);
    assign o_w_green = (l_r_state == STATE_GREEN_WAIT);
    assign o_w_red = (l_r_state == STATE_RED_WAIT);
    assign o_w_yellow = (l_r_state == STATE_YELLOW_WAIT);

endmodule