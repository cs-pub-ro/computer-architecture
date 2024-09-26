`timescale 1ns / 1ps
module test_task1;

    localparam l_p_data_width = 8;
    //Inputs
    reg [(l_p_data_width-1):0] l_r_a;
    reg [(l_p_data_width-1):0] l_r_b;
    reg l_r_clk;
    reg l_r_reset;
    reg l_r_write;
    reg l_r_multiply;
    reg l_r_display;

    //Outputs
    wire [(2*l_p_data_width-1):0] l_w_out;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    task1 #(.p_data_width(l_p_data_width)) l_m_task1(
        .o_w_out(l_w_out),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_write(l_r_write),
        .i_w_multiply(l_r_multiply),
        .i_w_display(l_r_display)
        );
    
    
    always #2 l_r_clk = ~l_r_clk;
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
            "l_r_clk=%0d, ", l_r_clk,
            "l_r_reset=%0d, ", l_r_reset,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b,
            "l_r_write=%0d, ", l_r_write,
            "l_r_multiply=%0d, ", l_r_multiply,
            "l_r_display=%0d, ", l_r_display
            );

        l_r_clk = 0;
        l_r_reset = 0;
        l_r_a = 2;
        l_r_b = 4;
        #10;
        l_r_reset = 1;
        for(i=0;i<2;i=i+1)
        begin
            l_r_display = i;
            for(j=0;j<2;j=j+1)
            begin
                l_r_multiply = j;
                for(k=0;k<2;k=k+1)
                begin
                    l_r_write = k;
                    #10;
                end
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
