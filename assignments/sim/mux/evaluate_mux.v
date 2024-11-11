`timescale 1ns / 1ps
module evaluate_mux;
    localparam l_p_sel_width = `SEL_WIDTH;
    //Inputs
    reg [(l_p_sel_width-1):0] l_r_sel;
    reg [(2**l_p_sel_width)-1:0] l_r_in;

    //Outputs
    wire l_w_out;
    wire l_w_sout;
    
    //local variables for loop
    integer i,j;

    //Module initialization
    mux uut (
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
        .i_w_sel(l_r_sel)
    );
    
    solution_mux suut (
        .o_w_out(l_w_sout),
        .i_w_in(l_r_in),
        .i_w_sel(l_r_sel)
    );
    
    //Simulation tests
    initial begin
        for (i = 0; i < (2**l_p_sel_width); i = i + 1) begin
            l_r_in = 1 << i;
            for (j = 0; j < (2**l_p_sel_width); j = j + 1) begin
                l_r_sel = j;
                #5;
                if (l_w_out !== l_w_sout) begin
                    $display("Error: (hex_values) l_w_out = %0h correct %0h, sel: %0h in = %0h", l_w_out, l_w_sout, j, l_r_in);
                end else begin
                    $display("OK");
                end
                #5;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule
