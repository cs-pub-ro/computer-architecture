`timescale 1ns / 1ps
module test_task1;
    //Inputs
    reg [3:0] l_r_in;

    //Outputs
    wire [6:0] l_w_7seg;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    task1 l_m_task1(
        .o_w_7seg(l_w_7seg),
        .i_w_in(l_r_in)
        );
    
    //Simulation tests
    initial begin
        //wave files
        $dumpfile("test.vcd");
        // dumpp all variables
        $dumpvars;
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_7seg=%0d, ", l_w_7seg,
            "l_r_in=%0d, ", l_r_in
            );

        l_r_in = 0;
        #10;
        for(i=0;i<10;i=i+1)
        begin
            l_r_in = i;
            #10;
        end
        //finish the simulation
        $finish;
    end
endmodule
