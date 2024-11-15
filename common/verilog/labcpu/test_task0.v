`timescale 1ns / 1ps
module test_task0;
    localparam l_p_data_width = 16;
    localparam l_p_address_width = 10;
    localparam l_p_port_width = 8;

    //Inputs
    reg l_r_clk;
    reg l_r_reset;

    //Outputs
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    task0 #(
        .p_data_width(l_p_data_width),
        .p_address_width(l_p_address_width),
        .p_port_width(l_p_port_width)
    ) l_m_task0(
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset)
    );
    
    always #5 l_r_clk = ~l_r_clk;

    //Simulation tests
    initial begin
        //wave files
        $dumpfile("test.vcd");
        // dumpp all variables
        $dumpvars;
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
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
