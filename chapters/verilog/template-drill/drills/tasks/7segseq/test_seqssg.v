`timescale 1ns / 1ps
module test_task0;
    //Inputs
    reg [2:0]i_w_sel;
    reg [3:0]i_w_dig;
    reg we;
    reg l_r_clk = 0;
    reg l_r_reset;

    //Out
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    seqssg ssg(
        .o_w_out(),   // found output: 0 - not found, 1 - found
        .o_w_sel(),    // char input: 0 - 'a', 1 - 'b'
        .i_w_sel(i_w_sel),        // input wire
        .i_w_dig(i_w_dig),        // input wire
        .we(we),
        .i_w_clk(l_r_clk),   // clock input
        .i_w_reset(l_r_reset)  // reset input
    );
    //Simulate clk
    always #2 l_r_clk <= ~l_r_clk;

    //Simulation tests
    initial begin
        l_r_reset = 1;
        i_w_sel = 0;
        i_w_dig = 2;
        we = 1;
        #10 l_r_reset = 0;
        #10 i_w_sel = 1;
        i_w_dig = 3;
        #10 we = 0;
        i_w_dig = 4;
        #10 we = 1;
        
        //finish the simulation
        $finish;
    end
endmodule
