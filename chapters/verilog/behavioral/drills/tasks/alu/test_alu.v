`timescale 1ns / 1ps
module test_alu;
    localparam l_p_width = 6;
    //Inputs
    reg [l_p_width:0] l_r_a;
    reg [l_p_width:0] l_r_b;
    reg l_r_sel;

    //Outputs
    wire [(l_p_width*2):0] l_w_out;
    
    //local variables for loop
    integer i,j,k;

    //Module initialization
    alu #(.p_width(l_p_width)) l_m_alu(
        .o_w_out(l_w_out),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
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
            "l_w_out=%0d, ", l_w_out,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d, ", l_r_b,
            "l_r_sel=%0d, ", l_r_sel
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
                for(k=0;k<2;k=k+1)
                begin
                    l_r_sel = k;
                    #10;
                end
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
