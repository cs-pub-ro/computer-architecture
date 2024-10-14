`timescale 1ns / 1ps
module test_mux #(
    parameter p_sel_width = 2
);
    //Inputs
    reg [(p_sel_width-1):0] l_r_sel;
    reg [(2**p_sel_width)-1:0] l_r_in;

    //Outputs
    wire l_w_out;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    mux #(
        .sel_width(p_sel_width)
    ) uut (
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
        .i_w_sel(l_r_sel)
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
            "l_w_out = %0h, ", l_w_out,
            "l_r_sel = %0h, ", l_r_sel,
            "l_r_in = %0h", l_r_in
        );

        for (i = 0; i < (2**p_sel_width); i = i + 1) begin
            l_r_in = 1 << i;
            for (j = 0; j < (2**p_sel_width); j = j + 1) begin
                l_r_sel = j;
                #5;
                if (l_w_out !== l_r_in[j]) begin
                    $display("Error: l_w_out = %0h, l_r_in[%0d] = %0h", l_w_out, j, l_r_in[j]);
                end
                #5;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
