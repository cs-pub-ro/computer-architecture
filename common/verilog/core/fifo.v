module fifo #(
    parameter BUFFER_SIZE = 8
    parameter DATA_WIDTH  = 8
)(
    input  clk, rst_n,
    input  [DATA_WITDH - 1 : 0] write,
    output [DATA_WITDH - 1 : 0] read,
    input  push,
    input  pop,
    output reg empty,
    output reg full
);
reg [DATA_WIDTH - 1 : 0] buffer [0 : BUFFER_SIZE - 1];
reg [$clog2(BUFFER_SIZE) - 1 : 0] read_position, next_read_position;
reg [$clog2(BUFFER_SIZE) - 1 : 0] write_position, next_write_position;
reg next_empty;
reg next_full;

assign read = (pop && (!empty)) ? buffer[read_position] : 0;


always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        read_position <= 0;
        write_position <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        read_position <= next_read_position;
        write_position <= next_write_position;
        empty <= next_empty;
        full <= next_full;
        if(pop && (!full)) buffer[write_position] <= write;
    end
end

always @(*) begin
    next_read_position = read_position;
    next_write_position = write_position;
    next_empty = empty;
    next_full = full;
    if(push && (!full)) begin
        next_write_position = (write_position == BUFFER_SIZE - 1) ? 0 : write_position + 1;
    end
    if(pop && (!empty)) begin
        next_read_position = (read_position == BUFFER_SIZE - 1) ? 0 : read_position + 1;
    end
    if(push && empty) next_empty = 0;
    if(pop  && full ) next_full  = 0;
    if(push && (!full) && (!pop) && (next_write_position == read_position)) next_full = 1;
    if(pop && (!empty) && (!push) && (next_read_position == write_position)) next_full = 1;

end

endmodule
