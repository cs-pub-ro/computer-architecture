`timescale 1ns / 1ps
module test_task0;
    //Inputs
    reg l_r_in;
    reg l_r_clk;
    reg l_r_reset;

    //Outputs
    wire l_w_out;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    task01 l_m_task01(
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
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
            "l_w_out=%0d, ", l_w_out,
            "l_r_in=%0d, ", l_r_in,
            "l_r_clk=%0d, ", l_r_clk,
            "l_r_reset=%0d, ", l_r_reset
            );

        l_r_in = 0;
        l_r_clk = 0;
        l_r_reset = 1;
        #10;
        for(i=0;i<2;i=i+1)
        begin
            for(j=0;j<2;j=j+1)
            begin
                l_r_reset = 1;
                #10;
                l_r_reset = 0;
                l_r_in = i;
                #10;
                l_r_in = j;
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
