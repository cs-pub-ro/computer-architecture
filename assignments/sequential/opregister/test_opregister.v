`timescale 1ns / 1ps
module test_opregister;
    //Inputs
    reg l_r_clk;
    reg l_r_reset;
    reg[3:0] l_r_data;
    reg l_r_we;
    reg l_r_oe;
    reg[1:0] l_r_sel;    

    //Outputs
    wire[3:0] l_w_out;
    
    //local variables for loop
    
    //Module initialization
    opregister uut (
        .o_w_out(l_w_out),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_opsel(l_r_sel)
    );

    always #5 l_r_clk = ~l_r_clk;

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_out = %0h, ", l_w_out,
            "l_r_clk = %0h, ", l_r_clk,
            "l_r_reset = %0h, ", l_r_reset,
            "l_r_data = %0h, ", l_r_data,
            "l_r_we = %0h, ", l_r_we,
            "l_r_oe = %0h, ", l_r_oe,
            "l_r_sel = %0h, ", l_r_sel
            );
        
        l_r_clk = 1'b0;
        l_r_reset = 1'b0;
        l_r_data = 4'b0000;
        l_r_we = 1'b0;
        l_r_oe = 1'b0;
        l_r_sel = 2'b00;

        #10;
        l_r_reset = 1'b1;
        l_r_data = 4'b0010;
        l_r_we = 1'b1;
        #10;
        l_r_we = 1'b0;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_sel = 2'b00;
        #10;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_sel = 2'b01;
        #10;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_sel = 2'b10;
        #10;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_sel = 2'b11;
        #10;
        l_r_oe = 1'b1;
        #10;
        //finish the simulation
        $finish;
    end
endmodule