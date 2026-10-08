module ba(
    output reg o,   // found output: 0 - not found, 1 - found
    input i,        // char input: 0 - 'a', 1 - 'b'
    input clk);     // clock input

reg [1:0] state = 2'b0; // stores current state; starts with state 0
reg [1:0] next_state;   // used to compute next state

// sequential part
always @(posedge clk) begin
    state <= next_state;
end

// combinational part
always @(*) begin
    case(state)
        0: begin
            o = 0;
            if(i == 0)
                next_state = 1;
            else
                next_state = 2;
        end
        
        1: begin
            o = 0;
            if(i == 0)
                next_state = 1;
            else
                next_state = 2;
        end
        
        2: begin
            o = 0;
            if(i == 0)
                next_state = 3;
            else
                next_state = 2;
        end
        
        3: begin
            o = 1;
            if(i == 0)
                next_state = 1;
            else
                next_state = 2;
        end
    endcase
end

endmodule
