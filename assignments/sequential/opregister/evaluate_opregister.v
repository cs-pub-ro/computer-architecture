module evaluate_opregister;
    //Inputs
    reg l_r_clk;
    reg l_r_reset;
    reg[3:0] l_r_data;
    reg l_r_we;
    reg l_r_oe;
    reg[1:0] l_r_opsel;    

    //Outputs
    wire[3:0] l_w_out_student;
    wire[3:0] l_w_out_solution;
    
    //local variables for loop
    integer i, j;
    
    //Module initialization
    opregister l_m_test (
        .o_w_out(l_w_out_student),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_opsel(l_r_opsel)
    );

    // Solution module initialization
    sol_opregister l_m_sol (
        .o_w_out(l_w_out_solution),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_opsel(l_r_opsel)
    );

    always #5 l_r_clk = ~l_r_clk;

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        
        l_r_clk = 1'b0;
        l_r_reset = 1'b0;
        l_r_data = 4'b0000;
        l_r_we = 1'b0;
        l_r_oe = 1'b0;
        l_r_opsel = 2'b00;
        #10;
        l_r_reset = 1'b1;

        for (i = 0; i < 16; i = i + 1) begin
            l_r_data = i;
            l_r_we = 1'b1;
            #10;
            l_r_we = 1'b0;
            l_r_oe = 1'b1;
            #10;
            if (l_w_out_student !== l_w_out_solution) begin
                $display(
                    "Error: (hex_values) o_w_out = %0h correct %0h, i_w_data = %0h, i_w_opsel = %0h, i_w_we = %0h, i_w_oe = %0h",
                    l_w_out_student, l_w_out_solution, l_r_data, l_r_opsel, l_r_we, l_r_oe);
            end else begin
                $display("OK");
            end
            #10;
            for (j = 0; j < 4; j = j + 1) begin
                l_r_oe = 1'b0;
                l_r_opsel = j;
                #10;
                l_r_oe = 1'b1;
                #10;
                if (l_w_out_student !== l_w_out_solution) begin
                    $display(
                        "Error: (hex_values) o_w_out = %0h correct %0h, i_w_data = %0h, i_w_opsel = %0h, i_w_we = %0h, i_w_oe = %0h",
                        l_w_out_student, l_w_out_solution, l_r_data, l_r_opsel, l_r_we, l_r_oe);
                end else begin
                    $display("OK");
                end
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule