module counter #(
    parameter WIDTH = 8,
    parameter[WIDTH-1:0] RESET_VAL = {WIDTH{1'b0}};
) (
    input clk,
    input rst_n,
    input soft_rst,
    input set,
    input[WIDTH-1:0] setcount,
    input ena,
    input upnotdown,
    output[WIDTH-1:0] count
);
    
reg[WIDTH-1:0] count_q;
always@(posedge clk or negedge rst_n) begin: COUNTER
    if(!rst_n)
        count_q <= '0;
    else begin
        if(soft_rst)
            count_q <= RESET_VAL;
        else if(set)
            count_q <= setcount;
        else if(ena)
            count_q <= (upnotdown) ? count_q + 1'b1 : count_q - 1'b1 ;
    end
end: COUNTER

assign count = count_q;

endmodule: counter