`timescale 1ns / 1ps
module test_fpu;
    //Inputs
    reg[31:0] l_r_op1;
    reg[31:0] l_r_op2;
    reg[2:0] l_r_sel;

    //Outputs
    wire[31:0] l_w_out;
    
    //local variables for loop
    integer i, j, k;
    
    //Module initialization
    fpu uut (
        .o_w_out(l_w_out),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_opsel(l_r_sel)
    );

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_out = %0h, ", l_w_out,
            "l_r_op1 = %0h, ", l_r_op1,
            "l_r_op2 = %0h, ", l_r_op2,
            "l_r_sel = %0h, ", l_r_sel
            );
        
        l_r_op1 = 32'b0010;
        l_r_op2 = 32'b0100;
        l_r_sel = 3'b000;
        #10;
        l_r_sel = 3'b01;
        #10;
        l_r_sel = 3'b10;
        #10;
        l_r_sel = 3'b11;
        #10;
        //finish the simulation
        $finish;
    end
endmodule
