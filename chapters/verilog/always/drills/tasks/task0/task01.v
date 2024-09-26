module task01(
    output wire o_w_out,   // found output: 0 - not found, 1 - found
    input wire i_w_in,    // char input: 0 - 'a', 1 - 'b'
    input wire i_w_clk,   // clock input
    input wire i_w_reset  // reset input
);

//STATES definition
localparam STATE_INITIAL = 2'b00;   //INITIAL state
localparam STATE_B       = 2'b01;   //State with 'b'
localparam STATE_BA      = 2'b10;   //State with 'ba'

reg [1:0] l_r_state      = STATE_INITIAL;   // stores current state; starts with state 0
reg [1:0] l_r_next_state;                   // used to compute next state

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
            if(i_w_in == 0)
                l_r_next_state = STATE_INITIAL;
            else
                l_r_next_state = STATE_B;
        end
        
        STATE_B: begin
            if(i_w_in == 0)
                l_r_next_state = STATE_BA;
            else
                l_r_next_state = STATE_B;
        end
        
        STATE_BA: begin
            l_r_next_state = STATE_BA;
        end
        
        default: begin
            l_r_next_state = STATE_INITIAL;
        end
    endcase
end

assign o_w_out = l_r_state == STATE_BA;

endmodule
