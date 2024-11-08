`timescale 1ns / 1ps
module test_register;
    localparam l_p_data_width = 8;
    //Inputs
    reg l_r_clk;
    reg l_r_reset;
    reg [(l_p_data_width - 1):0] l_r_in;
    reg l_r_oe;
    reg l_r_we;

    //Outputs
    wire [(l_p_data_width - 1):0] l_w_out;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    register #(.p_data_width(l_p_data_width)) l_m_register(
        .o_w_out(l_w_out),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset),
        .i_w_in(l_r_in),
        .i_w_oe(l_r_oe),
        .i_w_we(l_r_we)
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
            "l_r_reset=%0d, ", l_r_reset,
            "l_r_clk=%0d, ", l_r_clk,
            "l_r_in=%0d, ", l_r_in,
            "l_r_oe=%0d, ", l_r_oe,
            "l_r_we=%0d, ", l_r_we
            );

        l_r_clk = 0;
        l_r_reset = 0;
        #10;
        l_r_reset = 1;
        for(i=0;i<2;i=i+1)
        begin
            l_r_oe = i;
            for(j=0;j<2;j=j+1)
            begin
                l_r_we = j;
                for(k=2;k<4;k=k+1)
                begin
                    l_r_in = k;
                    #10;
                end
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
