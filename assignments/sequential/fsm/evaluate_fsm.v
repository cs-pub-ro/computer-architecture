`timescale 1ns / 1ps
module evaluate_led7;
    //Inputs
    reg [1:0] l_r_in;
    reg l_r_clk;
    reg l_r_reset;

    //Outputs
    wire l_w_out;
    wire int;

    //Module initialization
    fsm uut(
        .o_w_out(l_w_out),
        .i_w_in(l_r_in),
        .i_w_clk(l_r_clk),
        .i_w_reset(l_r_reset)
    );

    integer file_input, file_expected_result, i, idx;
    reg [8*128-1:0] line_input;         // Temporary register for the full line read from file
    reg [7:0] line_expected_result;     // Expected result per line

    always #2 l_r_clk <= ~l_r_clk;
    
    // Simulation test
    initial begin
        // Open the files for reading
        file_input = $fopen("test_inputs.txt", "r");
        file_expected_result = $fopen("results.txt", "r");

        if (file_input == 0) begin
            $display("Error: Input file not found!");
            $finish;
        end
        
        if (file_expected_result == 0) begin
            $display("Error: Results file not found!");
            $finish;
        end
        
        #1;
        // Read the file line by line
        for (i = 0; i < 100; i = i + 1) begin
            // Read a line from the file into 'line_input' as a single string
            if (!$fgets(line_input, file_input)) begin
                $display("Error reading input file at line %0d", i);
                $finish;
            end
            if (!$fgets(line_expected_result, file_expected_result)) begin
                $display("Error reading expected result file at line %0d", i);
                $finish;
            end
            
            // Process each character in the 'line_input' string
            for (idx = 0; idx < 128 && line_input[8*idx +: 8] != 8'h0; idx = idx + 1) begin
                l_r_in = line_input[8*idx +: 8];  // Assign each character to l_r_in
                #4;
            end

            // Check the result
            if (line_expected_result == int) begin
                $display("OK");
            end else begin
                $display("Wrong answer for input: %s", line_input);
            end
        end

        // Close the files
        $fclose(file_input);
        $fclose(file_expected_result);
        
        // Finish the simulation
        $finish;
    end
endmodule
