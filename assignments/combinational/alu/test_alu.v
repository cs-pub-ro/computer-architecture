`timescale 1ns / 1ps
module test_alu;
    //Inputs
    reg[3:0] l_r_op1;
    reg[3:0] l_r_op2;
    reg[1:0] l_r_sel;

    //Outputs
    wire[3:0] l_w_out;
    
    //local variables for loop
    
    //Module initialization
    alu uut (
        .o_w_out(l_w_out),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_sel(l_r_sel)
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
        
        l_r_op1 = 4'b0010;
        l_r_op2 = 4'b0100;
        l_r_sel = 2'b00;
        #10;
        l_r_sel = 2'b01;
        #10;
        l_r_sel = 2'b10;
        #10;
        l_r_sel = 2'b11;
        #10;
        //finish the simulation
        $finish;
    end
endmodule
