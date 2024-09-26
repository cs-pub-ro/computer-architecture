module task11(
    output wire o_w_done,
    input wire i_w_clk,
    input wire i_w_reset,
    input wire i_w_ready,
    input wire [7:0] i_w_value
);

    localparam STATE_INITIAL = 2'd0;
    localparam STATE_WAIT_INPUT = 2'd1;
    localparam STATE_COUNTING = 2'd2;
    localparam STATE_DONE_COUNTING = 2'd3;


    reg [1:0] l_r_state      = STATE_INITIAL;   // stores current state; starts with state 0
    reg [1:0] l_r_next_state;                   // used to compute next state
    reg [7:0] l_r_counter;
    // sequential part
    always @(posedge i_w_clk) begin
        if(i_w_reset) begin
            l_r_state <= STATE_INITIAL;
        end else begin
            l_r_state <= l_r_next_state;
            if(i_w_ready == 0) begin
                l_r_counter <= l_r_counter - 1;
            end else begin
                l_r_counter <= i_w_value;
            end
        end
    end

    // combinational part
    always @(*) begin
        case(l_r_state)
            STATE_INITIAL: begin
                l_r_next_state = STATE_WAIT_INPUT;
            end
            
            STATE_WAIT_INPUT: begin
                if(i_w_ready == 0) begin
                    l_r_next_state = STATE_WAIT_INPUT;
                end else begin
                    l_r_next_state = STATE_COUNTING;
                end
            end
            
            STATE_COUNTING: begin
                if(l_r_counter == 8'd0) begin
                    l_r_next_state = STATE_DONE_COUNTING;
                end else begin
                    l_r_next_state = STATE_COUNTING;
                end
            end

            STATE_DONE_COUNTING: begin
                l_r_next_state = STATE_WAIT_INPUT;
            end
            
            default: begin
                l_r_next_state = STATE_INITIAL;
            end
        endcase
    end

assign o_w_done = l_r_state == STATE_DONE_COUNTING;

endmodule