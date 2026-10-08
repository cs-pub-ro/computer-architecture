module top;
    reg  [3:0] m0_number;
    wire [6:0] m0_seven_seq;
    seven_seg dut0(.seven_seq(m0_seven_seq), .number(m0_number));
    initial begin
        m0_number = 4'b0000; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0001; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0010; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0011; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0100; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0101; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0110; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b0111; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b1000; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        m0_number = 4'b1001; #1; $display("\n[CHECKER]seven_seg|number=%b|seven_seq=%b", m0_number, m0_seven_seq);
        $finish;
    end
endmodule
