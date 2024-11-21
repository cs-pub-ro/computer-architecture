module test_flagram;
//Inputs
    reg l_r_clk;
    reg [3:0] l_r_address;
    reg [3:0] l_r_data;
    reg l_r_we;
    reg l_r_oe;
    reg l_r_flags_out;   

    //Outputs
    wire[3:0] l_w_out;
    
    //local variables for loop
    
    //Module initialization
    flagram uut (
        .o_w_out(l_w_out),
        .i_w_clk(l_r_clk),
        .i_w_address(l_r_address),
        .i_w_data(l_r_data),
        .i_w_we(l_r_we),
        .i_w_oe(l_r_oe),
        .i_w_flags_out(l_r_flags_out)
    );


    always #5 l_r_clk = ~l_r_clk;

    //Simulation tests
    initial begin
        // monitor varibles changes in values
        $monitor(
            "Time = %0t, ", $time,
            "l_w_out = %0h, ", l_w_out,
            "l_r_clk = %0h, ", l_r_clk,
            "l_r_address = %0h, ", l_r_address,
            "l_r_data = %0h, ", l_r_data,
            "l_r_we = %0h, ", l_r_we,
            "l_r_oe = %0h, ", l_r_oe,
            "l_r_flags_out = %0h, ", l_r_flags_out
            );
        
        l_r_clk = 1'b0;
        l_r_data = 4'b0000;
        l_r_address = 4'b0000;
        l_r_we = 1'b0;
        l_r_oe = 1'b0;
        l_r_flags_out = 1'b0;

        #10;
        l_r_data = 4'b0010;
        l_r_we = 1'b1;
        #10;
        l_r_we = 1'b0;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_flags_out = 1'b1;
        #10;
        l_r_oe = 1'b1;
        #10;
        l_r_oe = 1'b0;
        l_r_flags_out = 1'b0;
        #10;
        l_r_flags_out = 1'b1;
        #10;
        l_r_flags_out = 1'b0;
        #10;
        //finish the simulation
        $finish;
    end
endmodule