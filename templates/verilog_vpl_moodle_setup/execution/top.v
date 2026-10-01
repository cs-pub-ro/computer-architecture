module top;
    reg a;
    reg b;
    wire o1;
    wire o2;
    integer i;

    lut dut(
        .a(a),
        .b(b),
        .o1(o1),
        .o2(o2)
    );

    task run_row;
        input ia;
        input ib;
        begin
            a = ia;
            b = ib;
            #1;
            // Separate lines such that checker is always on the first part of
            // a line
            $display("\n[CHECKER]%b%b", o1, o2);
        end
    endtask

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            run_row(i[1], i[0]);
        end
    end
endmodule
