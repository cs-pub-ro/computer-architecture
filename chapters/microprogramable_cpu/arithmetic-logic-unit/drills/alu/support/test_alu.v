`timescale 1ns / 1ps
module test_alu;
    localparam l_p_data_width = 16;
    localparam l_p_flags_width = 5;

    // Inputs
    reg [l_p_data_width-1:0] l_r_op1;
    reg [l_p_data_width-1:0] l_r_op2;
    reg [3:0] l_r_opcode;
    reg l_r_carry;
    reg l_r_oe;

    // Outputs
    wire [l_p_data_width-1:0] l_w_out;
    wire [l_p_flags_width-1:0] l_w_flags;
    
    // Local variables for loop
    integer i, j, k;

    // Module initialization
    alu #(
        .p_data_width(l_p_data_width),
        .p_flags_width(l_p_flags_width)
    ) l_m_alu (
        .o_w_out(l_w_out),
        .o_w_flags(l_w_flags),
        .i_w_op1(l_r_op1),
        .i_w_op2(l_r_op2),
        .i_w_opcode(l_r_opcode),
        .i_w_carry(l_r_carry),
        .i_w_oe(l_r_oe)
    );

    // Simulation tests
    initial begin
        // Wave files
        $dumpfile("test.vcd");
        // Dump all variables
        $dumpvars;
        // Monitor variable changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_r_op1=%0d, ", l_r_op1,
            "l_r_op2=%0d, ", l_r_op2,
            "l_r_opcode=%0d, ", l_r_opcode,
            "l_r_carry=%0d, ", l_r_carry,
            "l_r_oe=%0d, ", l_r_oe,
            "l_w_out=%0d, ", l_w_out,
            "l_w_flags=%0d", l_w_flags
        );

        // Test 1: ADC
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0000;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0003 || l_w_flags !== 5'b10000) $display("Test 1 Failed: Expected out=3, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 2: SBB1
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0001;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'hFFFF || l_w_flags !== 5'b11001) $display("Test 2 Failed: Expected out=-1, flags=00001, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 3: SBB2
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0010;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'hFFFF || l_w_flags !== 5'b11001) $display("Test 3 Failed: Expected out=-1, flags=00001, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;
        
        // Test 4: NOT
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0011;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'hFFFE || l_w_flags !== 5'b01000) $display("Test 4 Failed: Expected out=-2, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 5: AND
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0100;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0001 || l_w_flags !== 5'b00000) $display("Test 5 Failed: Expected out=1, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 6: OR
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0101;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0001 || l_w_flags !== 5'b00000) $display("Test 6 Failed: Expected out=1, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 7: XOR
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0001;
        l_r_opcode = 4'b0110;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0000 || l_w_flags !== 5'b10100) $display("Test 7 Failed: Expected out=0, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;


        // Test 8: SHL
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0000;
        l_r_opcode = 4'b0111;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0002 || l_w_flags !== 5'b00000) $display("Test 8 Failed: Expected out=2, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 9: SHR
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0000;
        l_r_opcode = 4'b1000;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0000 || l_w_flags !== 5'b10101) $display("Test 9 Failed: Expected out=0, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Test 10: SAR
        l_r_op1 = 16'h0001;
        l_r_op2 = 16'h0000;
        l_r_opcode = 4'b1001;
        l_r_carry = 1;
        l_r_oe = 1;
        #10;
        if (l_w_out !== 16'h0000 || l_w_flags !== 5'b10101) $display("Test 10 Failed: Expected out=0, flags=00000, Got out=%0d, flags=%0b", l_w_out, l_w_flags);
        #10;
        l_r_oe = 0;
        #10;

        // Finish the simulation
        $finish;
    end
endmodule