`timescale 1ns / 1ps
module evaluate_alu;
    //Inputs
    reg[3:0] l_r_op1;
    reg[3:0] l_r_op2;
    reg[1:0] l_r_opsel;

    //Outputs
    wire[3:0] l_w_out_student;

    //Expected outputs
    wire[3:0] l_w_out_solution;
    
    //local variables for loop
    integer i, j, k;
    
    //Module initialization
    alu uut (
        .o_w_out(l_w_out_student),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_opsel(l_r_opsel)
    );

    //Expected module initialization
    sol_alu l_m_sol (
        .o_w_out(l_w_out_solution),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_opsel(l_r_opsel)
    );

    //Simulation tests
    initial begin
        for(i=0;i<4;i=i+1) begin
            l_r_opsel = i;
            for(j=0;j<16;j=j+1) begin
                l_r_op1 = j;
                for(k=0;k<16;k=k+1) begin
                    l_r_op2 = k;
                    #5;
                    if (l_w_out_student !== l_w_out_solution) begin
                        $display("Error: (hex_values) o_w_out = %0h", l_w_out_student,
                        " correct %0h, i_w_op1 = %0h, i_w_op2 = %0h, i_w_opsel = %0h",
                        l_w_out_solution, l_r_op1, l_r_op2, l_r_opsel);
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
