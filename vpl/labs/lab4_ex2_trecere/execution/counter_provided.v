module counter(
    output done,        // signals when counting is done
    input [7:0] T,      // initial count
    input clk);         // clock input

reg [7:0] count = 255;

assign done = ~|count;

always @(posedge clk) begin
    if(count == 255)
        count <= T - 1;
    else
        count <= count - 1;
end

endmodule
