`timescale 1ns / 1ps
module evaluate_comb;
    //Inputs
    reg l_r_a;
    reg l_r_b;
    reg l_r_c;

    //Outputs
    wire l_w_out_student;
    wire l_w_out_solution;
    
    //local variables for loop
    integer i,j,k;
    
    //Module initialization
    comb l_m_comb (
        .o_w_out(l_w_out_student),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_c(l_r_c)
    );

    sol_comb l_m_solution_comb (
        .o_w_out(l_w_out_solution),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_c(l_r_c)
    );

    //Simulation tests
    initial begin
        for(i=0;i<2;i=i+1) begin
            l_r_a = i;
            for(j=0;j<2;j=j+1) begin
                l_r_b = j;
                for(k=0;k<2;k=k+1) begin
                    l_r_c = k;
                    #5;
                    if (l_w_out_student !== l_w_out_solution) begin
                        $display(
                            "Error: (hex_values) o_w_out = %0h ", l_w_out_student,
                            "Expected = %0h, i_w_a = %0h, i_w_b = %0h, i_w_c = %0h",
                            l_w_out_solution, l_r_a, l_r_b, l_r_c);
                    end else begin
                        $display("OK");
                    end
                    #5;
                end
            end
        end
        $finish;
    end
endmodule
