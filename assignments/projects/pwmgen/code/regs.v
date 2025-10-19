module regs (
    // peripheral clock signals
    input clk,
    input rst_n,
    // decoder facing signals
    input read,
    input write,
    input[5:0] addr,
    output[7:0] data_read,
    input[7:0] data_write,
    // counter programming signals
    input[15:0] counter_val,
    output[15:0] period,
    output en,
    output count_reset,
    output upnotdown,
    output[7:0] prescale,
    // PWM signal programming values
    output pwm_en,
    output[7:0] functions,
    output[15:0] compare1,
    output[15:0] compare2
);

/*
    All registers that appear in this block should be similar to this. Please try to abide
    to sizes as specified in the architecture documentation.
*/
reg[15:0] period;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        period <= 16'h0000;
    else begin
        // Here should be the rest of the implementation
    end
end



endmodule