`timescale 1ns / 1ps
module test_task1;
    //Inputs
    reg l_r_clk;
    reg l_r_reset;

    //Outputs
    wire l_w_red;
    wire l_w_yellow;
    wire l_w_green;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    task1 l_m_task1(
        .o_w_red(l_w_red),
        .o_w_yellow(l_w_yellow),
        .o_w_green(l_w_green),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset)
        );
    //Simulate clk
    always #2 l_r_clk <= ~l_r_clk;

    //Simulation tests
    initial begin
        //wave files
        $dumpfile("test.vcd");
        // dumpp all variables
        $dumpvars;
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_red=%0d, ", l_w_red,
            "l_w_yellow=%0d, ", l_w_yellow,
            "l_w_green=%0d, ", l_w_green,
            "l_r_clk=%0d, ", l_r_clk,
            "l_r_reset=%0d, ", l_r_reset
            );

        l_r_clk = 0;
        l_r_reset = 1;
        #10;
        l_r_reset = 0;
        #1000;
        //finish the simulation
        $finish;
    end
endmodule
