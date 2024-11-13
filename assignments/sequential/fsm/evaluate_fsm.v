`timescale 1ns / 1ps
module evaluate_fsm;
    //Inputs
    reg [1:0] l_r_in;
    reg [2:0] l_r_aux;
    reg l_r_clk;
    reg l_r_reset;

    //Outputs
    wire l_w_out_student;

    //expected result
    reg l_r_solution;

    //Module initialization
    fsm uut(
        .o_w_out(l_w_out_student),
        .i_w_in(l_r_in),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset)
    );

    //local variables for loop
    integer i, j, k;
    integer file_descriptor;
    integer scan_result;
    reg[127:0] input_file;
    reg[1:0] l_r_input_line_aux [30:0];
    reg[15:0] l_r_input_line_size;

    always #5 l_r_clk <= ~l_r_clk;
    
    // Simulation test
    initial begin

        //get from the command line the input file
        if (!$value$plusargs("INPUT_FILE=%s", input_file)) begin
            $display("Error: You must specify the input file");
            $finish;
        end

        file_descriptor = $fopen(input_file, "r");
        if (file_descriptor == 0) begin
            $display("Error opening file");
            $finish;
        end
        
        l_r_reset = 1'b0;
        l_r_clk = 1'b0;
        l_r_in = 2'b00;
        l_r_input_line_size = 0;
        #10;
        l_r_reset = 1'b1;

        while (!$feof(file_descriptor)) begin
            scan_result = $fscanf(file_descriptor, "%h ", l_r_aux);
            if (l_r_aux == 3'h4) begin
                scan_result = $fscanf(file_descriptor, "%h\n", l_r_solution);
                if (l_r_solution == l_w_out_student) begin
                    $display("OK");
                end else begin
                    $write("Error: (hex_values) o_w_out = %0h correct %0h, input:", l_w_out_student, l_r_solution);
                    for (i = 0; i < l_r_input_line_size; i = i + 1) begin
                        $write("%0h", l_r_input_line_aux[i]);
                    end
                    $write("\n");
                end
                l_r_input_line_size = 0;
                l_r_reset = 1'b0;
                #10;
                l_r_reset = 1'b1;
            end else begin
                l_r_input_line_aux[l_r_input_line_size] = l_r_aux;
                l_r_input_line_size = l_r_input_line_size + 1;
                l_r_in = l_r_aux;
                #10;
            end
        end

        // Close the files
        $fclose(file_descriptor);
        #5;
        
        // Finish the simulation
        $finish;
    end
endmodule
