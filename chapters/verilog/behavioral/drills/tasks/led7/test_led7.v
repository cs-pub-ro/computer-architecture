`timescale 1ns / 1ps
module test_led7;
    //Inputs
    reg [3:0] l_r_in;
    reg [7:0] l_r_an;

    //Outputs
    wire [6:0] l_w_7seg;
    wire [7:0] l_w_an;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    led7 l_m_led7(
        .o_w_7seg(l_w_7seg),
        .o_w_an(l_w_an),
        .i_w_in(l_r_in),
        .i_w_an(l_r_an)
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
