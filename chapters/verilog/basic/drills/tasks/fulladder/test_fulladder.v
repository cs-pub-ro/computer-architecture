`timescale 1ns / 1ps
module test_fulladder;
    //Inputs
    reg l_r_a;
    reg l_r_b;
    reg l_r_cin;

    //Outputs
    wire l_w_s;
    wire l_w_cout;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization 
    fulladder l_m_fulladder(
        .o_w_s(l_w_s),
        .o_w_cout(l_w_cout),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_cin(l_r_cin)
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
            "l_w_s=%0d, ", l_w_s,
            "l_w_cout=%0d, ", l_w_cout,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b,
            "l_r_cin=%0d, ", l_r_cin
            );

        l_r_a = 0;
        l_r_b = 0;
        l_r_cin = 0;
        #10;
        for(i=0;i<2;i=i+1)
        begin
            l_r_a = i;
            for(j=0;j<2;j=j+1)
            begin
                l_r_b = j;
                for(k=0;k<2;k=k+1)
                begin
                    l_r_cin = k;
                    #10;
                end
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
