`timescale 1ns / 1ps
module evaluate_flagram;
//Inputs
    reg l_r_clk;
    reg [3:0] l_r_address;
    reg [3:0] l_r_data;
    reg l_r_we;
    reg l_r_oe;
    reg l_r_flags_out;   

    //Outputs
    wire[3:0] l_w_out_student;
    wire[3:0] l_w_out_solution;
    
    //local variables for loop
    integer i, j;
    
    //Module initialization
    flagram uut (
        .o_w_out(l_w_out_student),
        .i_w_clk(l_r_clk),
        .i_w_address(l_r_address),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_flags_out(l_r_flags_out)
    );

    //Module initialization
    sol_flagram uut_solution (
        .o_w_out(l_w_out_solution),
        .i_w_clk(l_r_clk),
        .i_w_address(l_r_address),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_flags_out(l_r_flags_out)
    );


    always #5 l_r_clk = ~l_r_clk;

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        l_r_clk = 1'b0;
        l_r_data = 4'b0000;
        l_r_address = 4'b0000;
        l_r_we = 1'b0;
        l_r_oe = 1'b0;
        l_r_flags_out = 1'b0;
        #10;

        for (i = 0; i < 16; i = i + 1) begin
            l_r_address = i;
            #10;
            for (j = 0; j < 16; j = j + 1) begin
                l_r_data = j;
                l_r_we = 1'b1;
                #10;
                l_r_we = 1'b0;
                l_r_oe = 1'b1;
                #10;
                if (l_w_out_student !== l_w_out_solution) begin
                    $display(
                        "Error: (hex_values) o_w_out = %0h correct %0h, i_w_address = %0h, i_w_data = %0h, i_w_we = %0h, i_w_oe = %0h, i_w_flags_out = %0h",
                        l_w_out_student, l_w_out_solution, l_r_address, l_r_data, l_r_we, l_r_oe, l_r_flags_out);
                end else begin
                    $display("OK");
                end
                #10;
                l_r_oe = 1'b0;
                l_r_flags_out = 1'b1;
                #10;
                if (l_w_out_student !== l_w_out_solution) begin
                    $display(
                        "Error: (hex_values) o_w_out = %0h correct %0h, i_w_address = %0h, i_w_data = %0h, i_w_we = %0h, i_w_oe = %0h, i_w_flags_out = %0h",
                        l_w_out_student, l_w_out_solution, l_r_address, l_r_data, l_r_we, l_r_oe, l_r_flags_out);
                end else begin
                    $display("OK");
                end
                #10;
                l_r_flags_out = 1'b0;
                #10;
            end
        end
        //finish the simulation
        $finish;
    end
endmodule