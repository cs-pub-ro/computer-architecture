module test_lut;
    //Inputs
    reg l_r_a;
    reg l_r_b;

    //Outputs
    wire l_w_o1;
    wire l_w_o2;

    //local variables for loop
    integer i;

    //Module initialization
    lut l_m_lut (
        .a(l_r_a),
        .b(l_r_b),
        .o1(l_w_o1),
        .o2(l_w_o2)
    );

    //Simulation tests
    initial begin
        // monitor variables changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_o1=%0d, ", l_w_o1,
            "l_w_o2=%0d, ", l_w_o2,
            "l_r_a=%0d, ", l_r_a,
            "l_r_b=%0d", l_r_b
            );

        // go through every input combination: ab = 00, 01, 10, 11
        for (i = 0; i < 4; i = i + 1) begin
            l_r_a = i[1];
            l_r_b = i[0];
            #10;
        end

        //finish the simulation
        $finish;
    end
endmodule