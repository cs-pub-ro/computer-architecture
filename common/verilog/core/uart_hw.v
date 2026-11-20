//////////////////////////////////////////////
// uart_hw.v                                //
//////////////////////////////////////////////
// Contains the main component of the uart  //
// engine that converts stream to parallel  //
// and viceversa. Runtime configurable.     //
//////////////////////////////////////////////
module uart_tx #(
    parameter BUFFER_SIZE   = 8,
    parameter CLK_FREQUENCY = 100_000_000
)(
    input clk,
    input rst_n,
    // Not the raw cts, but the write signal to write
    input cts,
    input tick,
    input [8:0] transmit,
    input [2:0] bits_to_send,
    input [1:0] parity,
    input stop,
    output reg tx,
    output reg en
);

localparam IDLE         = 3'h0
localparam SEND_START   = 3'h1;
localparam SEND_DATA    = 3'h2;
localparam SEND_PARITY  = 3'h3;
localparam SEND_STOP2   = 3'h4;
localparam SEND_STOP    = 3'h5;

localparam PARITY_ODD   = 1'h0;
localparam PARITY_EVEN  = 1'h1;
reg [2:0] state, next_state;
reg [8:0] tx_buffer, next_buffer;
reg [4:0] bits_remaining, next_bits_remaining;
reg p, next_p;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
        tx_buffer <= 9'h0;
        bits_remaining <= 3'h0;
        p <= 1'h0;
    end
    else begin
        state <= next_state;
        tx_buffer <= next_buffer;
        bits_remaining <= next_bits_remaining;
        p <= next_p;
    end
end

always @(*) begin
    next_state = state;
    next_buffer = tx_buffer;
    next_bits_remaining = bits_remaining;
    next_p = p;
    en = 1;

    case(state)
        IDLE: begin
            en = 0;
            tx = 1'b1;            
            if(cts) begin
                next_state = SEND_START;
                next_buffer = transmit;
                next_bits_remaining = 5 + bits_to_send;
                next_p = parity[0] ^ (^(transmit && ((1 << next_bits_remaining) - 1));
            end
        end
        SEND_START: begin
            tx = 1'b0;
            if(tick) next_state = SEND_DATA;
        end
        SEND_DATA: begin
            tx = tx_buffer[0];
            if(tick) begin
                next_buffer = tx_buffer >> 1;
                next_bits_remaining = bits_remaining - 1;
                if(!next_bits_remaining) begin
                    next_state = parity[1] ? SEND_PARITY : (stop ? SEND_STOP2 : SEND_STOP);
                end
                
            end
        end
        SEND_PARITY: begin
            tx = p;
            if(tick) next_state = (stop ? SEND_STOP2 : SEND_STOP);
        end
        SEND_STOP2: begin
            tx = 1'b1;
            if(tick) next_state = SEND_STOP;
        end
        SEND_STOP: begin
            tx = 1'b1;
            if(tick) next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule

uart_rx #(
    parameter BUFFER_SIZE   = 8,
    parameter CLK_FREQUENCY = 100_000_000
)(
    input clk,
    input rst_n,
    input rx,
    
);

endmodule

module uart_hw(
    // External
    input       rx,
    output      tx,
    input       cts,
    output      rts,
    // Internal
    input       clk,
    input       ext_rst_n,
    // data to be written is placed in write_data
    // Next frame from write_done the writing will start
    // If write buffer is filled then signal the parent
    // module. Any start_write's will be ignored until
    // buffer is no longer full
    input  [8:0]write_data,
    input       start_write,
    output      buffer_full,

    // data that was read. If data_ready is not set, read_next
    // is ignored. If however read_next is set, for that cycle
    // you will read the data at the current cursor buffer
    output [8:0]read_data,
    input       read_next,
    output      data_ready,

    input [8:0]configuration,
    output framing_error,
    output parity_error,
    output overrun_error
);

parameter WRITE_BUFFER_SIZE = 8;
parameter READ_BUFFER_SIZE  = 8;
parameter CLK_FREQUENCY     = 100_000_000;

wire [2:0] data_length;
wire [1:0] parity;
wire       stop;
wire [1:0] baudrate;
wire       hw_control_flow;

localparam DATA_LENGTH_5BIT = 3'h0;
localparam DATA_LENGTH_6BIT = 3'h1;
localparam DATA_LENGTH_7BIT = 3'h2;
localparam DATA_LENGTH_8BIT = 3'h3;
localparam DATA_LENGTH_9BIT = 3'h4;
// Start from 1 such that all 0 in configuration is invalid
// and reset is triggered
localparam PARITY_NONE      = 2'h1;
localparam PARITY_ODD       = 2'h2;
localparam PARITY_EVEN      = 2'h3;
localparam STOP_1BIT        = 1'h0;
localparam STOP_2BIT        = 1'h1;
localparam BAUD_9600        = 2'h0;
localparam BAUD_19200       = 2'h1;
localparam BAUD_38400       = 2'h2;
localparam BAUD_115200      = 2'h3;
localparam NO_HW_CONTROL    = 1'h0;
localparam WITH_HW_CONTROL  = 1'h1;

wire rst_n;

reg [8:0] current_configuration = 9'h0;
// Reset on configuration change
assign rst_n = ext_rst_n && (current_configuration == configuration);
assign {hw_control_flow, baudrate, stop, parity, data_length} = current_configuration;

reg [$clog2(CLK_FREQUENCY / 9600 + 1) - 1 : 0] baud_counts;
always @(*) begin
    case(baudrate)
        BAUD_9600: baud_counts = CLK_FREQUENCY / 9600 + 1;
        BAUD_19200: baud_counts = CLK_FREQUENCY / 19200 + 1;
        BAUD_38400: baud_counts = CLK_FREQUENCY / 38400 + 1;
        BAUD_115200: baud_counts = CLK_FREQUENCY / 115200 + 1;
        default: baud_counts = CLK_FREQUENCY / 115200 + 1;
    endcase
end

// TX

wire tx_ctr_en, tx_tick, uart_tx_write_enable, uart_tx_full, uart_tx_empty;
wire [8:0] transmit;
assign uart_tx_write_enable = (hw_control_flow ? (!cts) : 1'b1) && (!uart_tx_empty);
assign buffer_full = uart_tx_full;

counter #(
    .p_width($clog2(CLK_FREQUENCY / 9600 + 1))
) tx_tick_counter(
    .clk(clk),
    .rst_n(rst_n),
    .en(tx_ctr_en),
    .threshold(baud_counts),
    .tick(tx_tick),
    .count()
);

uart_tx #(
    .BUFFER_SIZE(WRITE_BUFFER_SIZE),
    .CLK_FREQUENCY(CLK_FREQUENCY)
) uart_tx_controller(
    .clk(clk),
    .rst_n(rst_n),
    .cts(uart_tx_write_enable),
    .tick(tx_tick),
    .transmit(transmit),
    .bits_to_send(data_length),
    .parity(parity),
    .stop(stop),
    .tx(tx),
    .en(tx_ctr_en)
);

fifo #(
    .DATA_WIDTH(9),
    .BUFFER_SIZE(WRITE_BUFFER_SIZE)
) tx_fifo (
    .clk(clk),
    .rst_n(rst_n),
    .read(transmit),
    .write(write_data),
    .push(start_write),
    .pop(uart_tx_write_enable),
    .empty(uart_tx_empty),
    .full(uart_tx_full)
);

// RX
wire rx_start_tick, rx_tick;
counter #(
    .p_width($clog2(CLK_FREQUENCY / 9600 + 1))
) rx_tick_counter(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .threshold(baud_counts),
    .tick(),
    .count()
);

counter #(
    .p_width($clog2(CLK_FREQUENCY / 9600 + 1))
) rx_start_counter(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .threshold(baud_counts >> 1),
    .tick(),
    .count()
);

fifo #(
    // 8:0 is potential data, 11:9 is frame_error, parity_error and
    // overrun_error respectively
    .DATA_WIDTH(12),
    .BUFFER_SIZE(READ_BUFFER_SIZE)
) rx_fifo (
    .clk(clk),
    .rst_n(rst_n),
    .read(),
    .write(),
    .push(),
    .pop(),
    .empty(),
    .full()
);

endmodule
