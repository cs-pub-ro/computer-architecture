`timescale 1ns / 1ps
module evaluate_comb;
    //Inputs
    reg l_r_a;
    reg l_r_b;
    reg l_r_c;

    //Outputs
    wire l_w_out;
    wire l_w_sout;
    
    //local variables for loop
    integer i,j,k;
    
    //Module initialization
    comb l_m_comb (
        .o_w_out(l_w_out),
        .i_w_a(l_r_a),
        .i_w_b(l_r_b),
        .i_w_c(l_r_c)
    );

    sol l_m_solution_comb (
        .o_w_out(l_w_sout),
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
                    if (l_w_out !== l_w_sout) begin
                        $display("Error: (hex_values) l_w_out = %0h correct %0h, a = %0h, b = %0h, c = %0h", l_w_out, l_w_sout, l_r_a, l_r_b, l_r_c);
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
