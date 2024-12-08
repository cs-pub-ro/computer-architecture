`timescale 1ns / 1ps

module Exec_Checker;

    parameter p_data_width = 16;

    reg [p_data_width-1:0] i_ir;       // RI code
    reg [p_data_width-1:0] i_t1;       // T1 value
    reg [p_data_width-1:0] i_t2;       // T2 value
    reg i_w_clk;                       // Clock
    reg i_w_reset;                     // Reset
    reg i_w_carry;                     // Carry

    wire [p_data_width-1:0] out_t1_sol; 
    wire [p_data_width-1:0] out_t1_uut; 

    Execute_Sol #(.p_data_width(p_data_width)) sol (
        .out_t1(out_t1_sol),
        .i_ir(i_ir),
        .i_t1(i_t1),
        .i_t2(i_t2),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_carry(i_w_carry)
    );

    Execute #(.p_data_width(p_data_width)) uut (
        .out_t1(out_t1_uut),
        .i_ir(i_ir),
        .i_t1(i_t1),
        .i_t2(i_t2),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_carry(i_w_carry)
    );

    initial begin
        i_w_clk = 1;
        forever #5 i_w_clk = ~i_w_clk;
    end

    initial begin
        i_w_reset = 1;
        #10;
        i_w_reset = 0;
        #10;
        i_w_reset = 1;
        #10;

        i_t1 = 16'h000A;
        i_t2 = 16'h0003;
        i_ir = 16'b0000000001001010; 
        i_w_carry = 1;
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [ADC]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [ADC]: %h", out_t1_uut);

        i_w_reset = 0;
        #5;
        i_w_reset = 1;
        #10;

        i_t1 = 16'h00FF;
        i_t2 = 16'h0F0F;
        i_ir = 16'b0000000000011010;
        i_w_carry = 0;
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [AND]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [AND]: %h", out_t1_uut);

        i_w_reset = 0;
        #5;
        i_w_reset = 1;
        #10;

        i_t1 = 16'hF0F0;
        i_t2 = 16'h0F0F;
        i_ir = 16'b0000000001011010;
        i_w_carry = 0;
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [OR]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [OR]: %h", out_t1_uut);

        i_w_reset = 0;
        #5;
        i_w_reset = 1;
        #10;

        i_t1 = 16'h0001;
        i_ir = 16'b0000000000011000; 
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [SHL]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [SHL]: %h", out_t1_uut);

        i_w_reset = 0;
        #5;
        i_w_reset = 1;
        #10;

        i_t1 = 16'h0002;
        i_ir = 16'b0000000001011000;
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [SHR]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [SHR]: %h", out_t1_uut);

        i_w_reset = 0;
        #5;
        i_w_reset = 1;
        #10;

        i_t1 = 16'h8000;
        i_ir = 16'b0000000000111000;
        #50;
        if (out_t1_sol !== out_t1_uut)
            $display("Mismatch [SAR]: Expected=%h, Got=%h", out_t1_sol, out_t1_uut);
        else
            $display("Match [SAR]: %h", out_t1_uut);

        $finish;
    end

endmodule