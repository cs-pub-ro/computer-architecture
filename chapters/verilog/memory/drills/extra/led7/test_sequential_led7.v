`timescale 1ns / 1ps
module test_sequential_led7;
    reg [15:0] i_w_in;
    reg i_w_clk;
    wire [6:0] o_w_7seg;
    wire [7:0] o_w_an;
    integer digit_index;
    reg [7:0] expected_anodes;
    reg [6:0] expected_segments;

    sequential_led7 dut(
        .o_w_7seg(o_w_7seg),
        .o_w_an(o_w_an),
        .i_w_in(i_w_in),
        .i_w_clk(i_w_clk)
    );

    always #5 i_w_clk = ~i_w_clk;

    task check_digit;
        input integer selected_digit;
        begin
            expected_anodes = ~(8'b00000001 << selected_digit);
            case (selected_digit)
                0: expected_segments = 7'b1000000;
                1: expected_segments = 7'b1111001;
                2: expected_segments = 7'b0100100;
                3: expected_segments = 7'b0110000;
                default: $fatal(1, "Unexpected digit index %0d", selected_digit);
            endcase
            if (o_w_an !== expected_anodes || o_w_7seg !== expected_segments)
                $fatal(1, "Digit %0d: anodes=%b segments=%b", selected_digit, o_w_an, o_w_7seg);
        end
    endtask

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, i_w_in, o_w_an, o_w_7seg);
        i_w_in = 16'h3210;
        i_w_clk = 1'b0;
        #1;
        check_digit(0);

        for (digit_index = 1; digit_index <= 4; digit_index = digit_index + 1) begin
            repeat (416668) @(posedge i_w_clk);
            #1;
            check_digit(digit_index % 4);
        end

        $display("Sequential LED scan passed");
        $finish;
    end

    initial begin
        #18000000;
        $fatal(1, "Sequential LED scan timed out");
    end
endmodule