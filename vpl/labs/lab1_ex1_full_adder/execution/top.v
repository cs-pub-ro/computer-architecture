module top;
    reg  [0:0] m0_a;
    reg  [0:0] m0_b;
    wire [0:0] m0_sum;
    wire [0:0] m0_c_out;
    half_adder dut0(.sum(m0_sum), .c_out(m0_c_out), .a(m0_a), .b(m0_b));
    reg  [0:0] m1_a;
    reg  [0:0] m1_b;
    reg  [0:0] m1_c_in;
    wire [0:0] m1_sum;
    wire [0:0] m1_c_out;
    full_adder dut1(.sum(m1_sum), .c_out(m1_c_out), .a(m1_a), .b(m1_b), .c_in(m1_c_in));
    initial begin
        m0_a = 1'b0; m0_b = 1'b0; #1; $display("\n[CHECKER]half_adder|a=%b b=%b|sum=%b c_out=%b", m0_a, m0_b, m0_sum, m0_c_out);
        m0_a = 1'b0; m0_b = 1'b1; #1; $display("\n[CHECKER]half_adder|a=%b b=%b|sum=%b c_out=%b", m0_a, m0_b, m0_sum, m0_c_out);
        m0_a = 1'b1; m0_b = 1'b0; #1; $display("\n[CHECKER]half_adder|a=%b b=%b|sum=%b c_out=%b", m0_a, m0_b, m0_sum, m0_c_out);
        m0_a = 1'b1; m0_b = 1'b1; #1; $display("\n[CHECKER]half_adder|a=%b b=%b|sum=%b c_out=%b", m0_a, m0_b, m0_sum, m0_c_out);
        m1_a = 1'b0; m1_b = 1'b0; m1_c_in = 1'b0; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b0; m1_b = 1'b0; m1_c_in = 1'b1; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b0; m1_b = 1'b1; m1_c_in = 1'b0; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b0; m1_b = 1'b1; m1_c_in = 1'b1; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b1; m1_b = 1'b0; m1_c_in = 1'b0; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b1; m1_b = 1'b0; m1_c_in = 1'b1; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b1; m1_b = 1'b1; m1_c_in = 1'b0; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        m1_a = 1'b1; m1_b = 1'b1; m1_c_in = 1'b1; #1; $display("\n[CHECKER]full_adder|a=%b b=%b c_in=%b|sum=%b c_out=%b", m1_a, m1_b, m1_c_in, m1_sum, m1_c_out);
        $finish;
    end
endmodule
