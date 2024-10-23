`timescale 1ns / 1ps
module evaluate_alu;
    //Inputs
    reg[3:0] l_r_op1;
    reg[3:0] l_r_op2;
    reg[1:0] l_r_sel;

    //Outputs
    wire[3:0] l_w_out;

    //Expected outputs
    wire[3:0] l_w_sout;
    
    //local variables for loop
    integer i, j, k;
    
    //Module initialization
    alu uut (
        .o_w_out(l_w_out),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_sel(l_r_sel)
    );

    //Expected module initialization
    sol l_m_sol (
        .o_w_out(l_w_sout),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_sel(l_r_sel)
    );

    //Simulation tests
    initial begin
        for(i=0;i<4;i=i+1) begin
            l_r_sel = i;
            for(j=0;j<16;j=j+1) begin
                l_r_op1 = j;
                for(k=0;k<16;k=k+1) begin
                    l_r_op2 = k;
                    #5;
                    if (l_w_out !== l_w_sout) begin
                        $display("Error: (hex_values) l_w_out = %0h correct %0h, op1 = %0h, op2 = %0h, sel = %0h", l_w_out, l_w_sout, l_r_op1, l_r_op2, l_r_sel);
                    end else begin
                        $display("OK");
                    end
                    #5;
                end
            end
        end
        
        //finish the simulation
        $finish;
    end
endmodule
