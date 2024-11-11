`timescale 1ns / 1ps
module evaluate_led7;
    //Inputs
    reg [1:0] l_r_in;

    //Outputs
    wire l_w_ca;
    wire l_w_cb;
    wire l_w_cc;
    wire l_w_cd;
    wire l_w_ce;
    wire l_w_cf;
    wire l_w_cg;

    //Expected outputs
    wire l_w_sca;
    wire l_w_scb;
    wire l_w_scc;
    wire l_w_scd;
    wire l_w_sce;
    wire l_w_scf;
    wire l_w_scg;
    
    //local variables for loop
    integer i;
    
    //Module initialization
    led7 uut (
        .o_w_ca(l_w_ca),
        .o_w_cb(l_w_cb),
        .o_w_cc(l_w_cc),
        .o_w_cd(l_w_cd),
        .o_w_ce(l_w_ce),
        .o_w_cf(l_w_cf),
        .o_w_cg(l_w_cg),
        .i_w_in(l_r_in)
    );

    //Expected module initialization
    sol l_m_sol (
        .o_w_ca(l_w_sca),
        .o_w_cb(l_w_scb),
        .o_w_cc(l_w_scc),
        .o_w_cd(l_w_scd),
        .o_w_ce(l_w_sce),
        .o_w_cf(l_w_scf),
        .o_w_cg(l_w_scg),
        .i_w_in(l_r_in)
    );

    //Simulation tests
    initial begin
        for(i=0;i<4;i=i+1) begin
            l_r_in = i;
            #10;
            if (l_w_ca !== l_w_sca) begin
                $display("Error: l_w_ca = %b correct %b, l_r_in = %0h", l_w_ca, l_w_sca, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_cb !== l_w_scb) begin
                $display("Error: l_w_cb = %b correct %b, l_r_in = %0h", l_w_cb, l_w_scb, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_cc !== l_w_scc) begin
                $display("Error: l_w_cc = %b correct %b, l_r_in = %0h", l_w_cc, l_w_scc, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_cd !== l_w_scd) begin
                $display("Error: l_w_cd = %b correct %b, l_r_in = %0h", l_w_cd, l_w_scd, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_ce !== l_w_sce) begin
                $display("Error: l_w_ce = %b correct %b, l_r_in = %0h", l_w_ce, l_w_sce, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_cf !== l_w_scf) begin
                $display("Error: l_w_cf = %b correct %b, l_r_in = %0h", l_w_cf, l_w_scf, l_r_in);
            end else begin
                $display("OK");
            end
            if (l_w_cg !== l_w_scg) begin
                $display("Error: l_w_cg = %b correct %b, l_r_in = %0h", l_w_cg, l_w_scg, l_r_in);
            end else begin
                $display("OK");
            end
            #10;
        end
        //finish the simulation
        $finish;
    end
endmodule
