`timescale 1ns / 1ps
module evaluate_fpu();
    //Inputs
    reg[31:0] l_r_op1;
    reg[31:0] l_r_op2;
    reg[2:0] l_r_sel;
    reg[2:0] l_r_aux_sel;

    //Outputs
    wire[31:0] l_w_out;

    //Expected outputs
    reg[31:0] l_r_out;
    
    //local variables for loop
    integer i, j, k;
    integer file_descriptor;
    integer scan_result;
    reg[127:0] input_file;
    
    //Module initialization
    fpu uut (
        .o_w_out(l_w_out),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_opsel(l_r_sel)
    );

    //Simulation tests
    initial begin

        //get from the command line the input file
        if (!$value$plusargs("INPUT_FILE=%s", input_file)) begin
            $display("Error: You must specify the input file");
            $finish;
        end

        for (i=0; i<8; i=i+1) begin
            l_r_sel = i;
            file_descriptor = $fopen(input_file, "r");
            if (file_descriptor == 0) begin
                $display("Error opening file");
                $finish;
            end
            #5;

            while (!$feof(file_descriptor)) begin
                scan_result = $fscanf(file_descriptor, "%h ", l_r_op1);
                scan_result = $fscanf(file_descriptor, "%h ", l_r_op2);
                scan_result = $fscanf(file_descriptor, "%h ", l_r_aux_sel);
                scan_result = $fscanf(file_descriptor, "%h\n", l_r_out);

                if (l_r_aux_sel == l_r_sel) begin
                    #5;
                    if (l_r_out !== l_w_out) begin
                        $display("Error: (hex_values) l_w_out = %0h correct %0h, op1 = %0h, op2 = %0h, sel = %0h", l_w_out, l_r_out, l_r_op1, l_r_op2, l_r_sel);
                    end else begin
                        $display("OK");
                    end
                    #5;
                end
            end
            $fclose(file_descriptor);
            #5;
        end
        //finish the simulation
        $finish;
    end
endmodule
