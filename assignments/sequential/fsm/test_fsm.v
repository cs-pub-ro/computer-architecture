`timescale 1ns / 1ps
module test_fsm;

    //Inputs
    reg l_r_clk;
    reg l_r_reset;
    reg [1:0] l_r_in;

    //Outputs
    wire l_w_out;


    //Module initialization
    fsm uut(
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset)
    );

    always #5 l_r_clk <= ~l_r_clk;
    
    // Simulation test
    initial begin
        $monitor(
            "Time = %0t, ", $time,
            "l_w_out = %0h, ", l_w_out,
            "l_r_clk = %0h, ", l_r_clk,
            "l_r_reset = %0h, ", l_r_reset,
            "l_r_in = %0h, ", l_r_in);

        l_r_reset = 1'b0;
        l_r_clk = 1'b0;
        l_r_in = 2'b00;
        #10;
        l_r_reset = 1'b1;
        #10;
        l_r_in = 2'b01;
        #10;
        l_r_in = 2'b10;
        #10;
        l_r_in = 2'b00;
        #10;

        $finish;
    end    

endmodule