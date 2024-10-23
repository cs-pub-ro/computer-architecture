`timescale 1ns / 1ps
module test_comb;
    //Inputs
    reg l_r_a;
    reg l_r_b;
    reg l_r_c;

    //Outputs
    wire l_w_out;
    
    //local variables for loop
    integer i,j, k;
    
    //Module initialization
    comb l_m_comb (
        .o_w_out(l_w_out),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_c(l_r_c)
    );

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_out=%0d, ", l_w_out,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b,
            "l_r_c=%0d, ", l_r_c
            );
        
        l_r_a = 0;
        l_r_b = 0;
        l_r_c = 0;

        #10;
        for(i=0;i<2;i=i+1)
        begin
            l_r_a = i;
            for(j=0;j<2;j=j+1)
            begin
                l_r_b = j;
                for(k=0;k<2;k=k+1)
                begin
                    l_r_c = k;
                    #10;
                end
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
