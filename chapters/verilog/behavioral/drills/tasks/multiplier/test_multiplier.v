`timescale 1ns / 1ps
module test_multiplier;
    localparam l_p_width = 6;
    //Inputs
    reg [(l_p_width-1):0] l_r_a;
    reg [(l_p_width-1):0] l_r_b;

    //Outputs
    wire [((l_p_width*2)-1):0] l_w_p;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    multiplier #(.p_width(l_p_width)) l_m_multiplier(
        .o_w_p(l_w_p),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b)
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
            "l_w_p=%0d, ", l_w_p,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b
            );

        l_r_a = 0;
        l_r_b = 0;
        #10;
        for(i=0;i<16;i=i+1)
        begin
            l_r_a = i;
            for(j=0;j<16;j=j+1)
            begin
                l_r_b = j;
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
