`timescale 1ns / 1ps
module test_led7;
    //Inputs
    reg [1:0] l_r_in;

    //Outputs
    wire l_w_ca;
    wire l_w_cb;
    wire l_w_cc;
    wire l_w_cd;
    wire l_w_ce;
    wire l_w_cf;
    wire l_w_cg;
    
    //local variables for loop
    
    //Module initialization
    led7 uut (
        .o_w_ca(l_w_ca),
        .o_w_cb(l_w_cb),
        .o_w_cc(l_w_cc),
        .o_w_cd(l_w_cd),
        .o_w_ce(l_w_ce),
        .o_w_cf(l_w_cf),
        .o_w_cg(l_w_cg),
        .i_w_digit(l_r_in)
    );

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_ca = %b, ", l_w_ca,
            "l_w_cb = %b, ", l_w_cb,
            "l_w_cc = %b, ", l_w_cc,
            "l_w_cd = %b, ", l_w_cd,
            "l_w_ce = %b, ", l_w_ce,
            "l_w_cf = %b, ", l_w_cf,
            "l_w_cg = %b, ", l_w_cg,
            "l_r_in = %0h", l_r_in
            );
        
        l_r_in = 2'b00;
        #10;
        l_r_in = 2'b01;
        #10;
        l_r_in = 2'b10;
        #10;
        l_r_in = 2'b11;
        #10;
        //finish the simulation
        $finish;
    end
endmodule
