`timescale 1ns / 1ps
module test_task0;
    localparam l_p_width = 6;
    //Inputs
    reg [l_p_width:0] l_r_a;
    reg [l_p_width:0] l_r_b;

    //Outputs
    wire l_w_gt;
    wire l_w_lt;
    wire l_w_eq;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    task0 #( .p_width(l_p_width) ) l_m_task0 (
        .o_w_gt(l_w_gt),
        .o_w_lt(l_w_lt),
        .o_w_eq(l_w_eq),
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
            "l_w_gt=%0d, ", l_w_gt,
            "l_w_lt=%0d, ", l_w_lt,
            "l_w_eq=%0d, ", l_w_eq,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b
            );

        l_r_a = 0;
        l_r_b = 0;
        #10;
        for(i=0;i<5;i=i+1)
        begin
            l_r_a = i;
            for(j=0;j<5;j=j+1)
            begin
                l_r_b = j;
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
