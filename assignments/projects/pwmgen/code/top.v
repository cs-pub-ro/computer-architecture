/*
    DO NOT, UNDER ANY CIRCUMSTANCES, MODIFY THIS FILE! THIS HAS TO REMAIN AS SUCH IN ORDER 
    FOR THE TESTBENCH PROVIDED TO WORK PROPERLY.
*/
module top(
    // peripheral clock signals
    input clk,
    input rst_n,
    // SPI master facing signals
    input sclk,
    input cs_n,
    input miso,
    output mosi,
    // peripheral signals
    output pwm_out
);

wire clk;
wire rst_n;

wire sclk;
wire cs_n;
wire miso;
wire mosi;

wire byte_sync;
wire[7:0] data_in;
wire[7:0] data_out;
wire read;
wire write;
wire[5:0] addr;
wire[7:0] data_read;
wire[7:0] data_write;

wire[15:0] counter_val;
wire[15:0] period;
wire en;
wire count_reset;
wire upnotdown;
wire[7:0] prescale;

wire pwm_en;
wire[7:0] functions;
wire[15:0] compare1;
wire[15:0] compare2;

spi_bridge i_spi_bridge (
    .clk(clk),
    .rst_n(rst_n),
    .sclk(sclk),
    .cs_n(cs_n),
    .miso(miso),
    .mosi(mosi)
);

instr_dcd i_instr_dcd (
    .clk(clk),
    .rst_n(rst_n),
    .byte_sync(),
    .data_in(data_in),
    .data_out(data_out),
    .read(read),
    .write(write),
    .addr(addr),
    .data_read(data_read),
    .data_write(data_write)
);

regs i_regs (
    .clk(clk),
    .rst_n(rst_n),
    .read(read),
    .write(write),
    .addr(addr),
    .data_read(data_read),
    .data_write(data_write),
    .counter_val(counter_val),
    .period(period),
    .en(en),
    .count_reset(count_reset),
    .upnotdown(upnotdown),
    .prescale(prescale),
    .pwm_en(pwm_en),
    .functions(functions),
    .compare1(compare1),
    .compare2(compare2)
);

counter i_counter (
    .clk(clk),
    .rst_n(rst_n),
    .count_val(counter_val),
    .period(period),
    .en(en),
    .count_reset(count_reset),
    .upnotdown(upnotdown),
    .prescale(prescale)
);

pwm_gen i_pwm_gen (
    .clk(clk),
    .rst_n(rst_n),
    .pwm_en(pwm_en),
    .period(period),
    .functions(functions),
    .compare1(compare1),
    .compare2(compare2),
    .count_val(counter_val),
    .pwm_out(pwm_out)
);

endmodule