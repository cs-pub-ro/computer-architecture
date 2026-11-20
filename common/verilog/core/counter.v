module counter #(
    parameter p_width = 10
)(
    input clk,
    input rst_n,
    input en,
    input [p_width - 1 : 0] threshold,
    output tick,
    output reg [p_width - 1 : 0] count;
);

wire [p_width - 1 : 0] next_count;

assign next_count = en ? ((count == threshold) ? 0 : (count + 1)) : count;
assign tick = en ? (count == threshold) : 0;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) count <= 0;
    else if(en) count <= next_count;
end

endmodule
