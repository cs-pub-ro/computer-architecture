`timescale 1ns / 1ps
module test_mux;
    //Inputs
    reg [3:0] l_r_in;
    reg [1:0] l_r_sel;

    //Outputs
    wire l_w_out;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    mux l_m_mux(
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
        .i_w_sel(l_r_sel)
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
            "l_w_out=%0d, ", l_w_out,
            "l_r_in=%0d, ", l_r_in,
            "l_r_sel=%0d, ", l_r_sel
            );

        l_r_in = 0;
        l_r_sel = 0;
        #10;
        for(i=0;i<16;i=i+1)
        begin
            l_r_in = i;
            for(j=0;j<4;j=j+1)
            begin
                l_r_sel = j;
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
