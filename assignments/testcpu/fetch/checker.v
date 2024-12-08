module checker;
reg rst;

reg checker_is_override;
reg [15:0] checker_pc_override;
wire sol_checker_pc_reset;
reg sol_clk;
wire sol_pc_we_real;
reg sol_stop_clk;
wire sol_regs_oe;
wire sol_regs_we;
wire [2:0] sol_regs_addr;
wire sol_ram_we;
wire sol_ram_oe;
wire sol_ma_oe;
wire sol_ma_we;
wire sol_pc_oe;
wire sol_pc_we;
wire sol_ir_oe;
wire sol_ir_we;
wire sol_d;
wire [6:0] sol_opc;
wire [1:0] sol_mod;
wire [2:0] sol_rg;
wire [2:0] sol_rm;
wire [15:0] sol_biu_bus_out;
wire [15:0] sol_ma_out;
wire [15:0] sol_pc_out;
wire [15:0] sol_ir_out;
wire [15:0] sol_ram_o_w_out;

assign sol_pc_we_real = checker_is_override ? 1 : sol_pc_we;

reg uut_clk;
wire uut_pc_we_real;
wire uut_checker_pc_reset;
reg uut_stop_clk;
wire uut_regs_oe;
wire uut_regs_we;
wire [2:0] uut_regs_addr;
wire uut_ram_we;
wire uut_ram_oe;
wire uut_ma_oe;
wire uut_ma_we;
wire uut_pc_oe;
wire uut_pc_we;
wire uut_ir_oe;
wire uut_ir_we;
wire uut_d;
wire [6:0] uut_opc;
wire [1:0] uut_mod;
wire [2:0] uut_rg;
wire [2:0] uut_rm;
wire [15:0] uut_biu_bus_out;
wire [15:0] uut_ma_out;
wire [15:0] uut_pc_out;
wire [15:0] uut_ir_out;
wire [15:0] uut_ram_o_w_out;

assign uut_pc_we_real = checker_is_override ? 1 : uut_pc_we;

control_unit_sol sol_cu(
    .clk(sol_clk),
    .rst(rst),
    .ir(sol_ir_out),
    .regs_oe(sol_regs_oe),
    .regs_we(sol_regs_we),
    .regs_addr(sol_regs_addr),
    .ram_we(sol_ram_we), 
    .ram_oe(sol_ram_oe),
    .ma_oe(sol_ma_oe), 
    .ma_we(sol_ma_we),
    .pc_oe(sol_pc_oe), 
    .pc_we(sol_pc_we),
    .ir_oe(sol_ir_oe),
    .ir_we(sol_ir_we),
    .opc(sol_opc),
    .d(sol_d),
    .mod(sol_mod),
    .rg(sol_rg),
    .rm(sol_rm)
);

register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) sol_ma (
    .o_w_out(sol_ma_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_ma_we),
    .i_w_oe(sol_ma_oe)
);

register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) sol_pc (
    .o_w_out(sol_pc_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_pc_we_real),
    .i_w_oe(sol_pc_oe)
);

register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) sol_ir (
    .o_w_out(sol_ir_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_ir_we),
    .i_w_oe(sol_ir_oe)
);

cram #(
    .p_data_width(16),
    .p_address_width(3)
) sol_cram (
    .o_w_out(sol_ram_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_address(sol_ma_out[2:0]),
    .i_w_we(sol_ram_we),
    .i_w_oe(sol_ram_oe),
    .i_w_clk(sol_clk)
);

bus_interface_unit sol_biu(
    .bus_out(sol_biu_bus_out),
    .ir_in(sol_ir_out),
    .pc_in(sol_pc_out),
    .ram_in(sol_ram_o_w_out),
    .override(checker_pc_override),
    .is_override(checker_is_override)
);

control_unit uut_cu(
    .clk(uut_clk),
    .rst(rst),
    .ir(uut_ir_out),
    .regs_oe(uut_regs_oe),
    .regs_we(uut_regs_we),
    .regs_addr(uut_regs_addr),
    .ram_we(uut_ram_we), 
    .ram_oe(uut_ram_oe),
    .ma_oe(uut_ma_oe), 
    .ma_we(uut_ma_we),
    .pc_oe(uut_pc_oe), 
    .pc_we(uut_pc_we),
    .ir_oe(uut_ir_oe),
    .ir_we(uut_ir_we),
    .opc(uut_opc),
    .d(uut_d),
    .mod(uut_mod),
    .rg(uut_rg),
    .rm(uut_rm)
);



register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) uut_ma (
    .o_w_out(uut_ma_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_ma_we),
    .i_w_oe(uut_ma_oe)
);


register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) uut_pc (
    .o_w_out(uut_pc_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_pc_we_real),
    .i_w_oe(uut_pc_oe)
);


register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) uut_ir (
    .o_w_out(uut_ir_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_ir_we),
    .i_w_oe(uut_ir_oe)
);

cram #(
    .p_data_width(16),
    .p_address_width(3)
) uut_cram (
    .o_w_out(uut_ram_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_address(uut_ma_out[2:0]),
    .i_w_we(uut_ram_we),
    .i_w_oe(uut_ram_oe),
    .i_w_clk(uut_clk)
);

bus_interface_unit uut_biu(
    .bus_out(uut_biu_bus_out),
    .ir_in(uut_ir_out),
    .pc_in(uut_pc_out),
    .ram_in(uut_ram_o_w_out),
    .override(checker_pc_override),
    .is_override(checker_is_override)
);

always #5 sol_clk = sol_stop_clk ? sol_clk : ~sol_clk;
always #5 uut_clk = uut_stop_clk ? uut_clk : ~uut_clk;

reg [2:0] i = 0;
initial begin
    rst = 0;
    sol_clk = 0;
    uut_clk = 0;
    uut_stop_clk = 0;
    sol_stop_clk = 0;    
    checker_is_override = 1;
    checker_pc_override = 0;

    #10 rst = 1;
    checker_is_override = 0;
    #20;
    while(1) begin
        if($time > 1000) begin
            $display("TIMEOUT");
            $finish;
        end
        if(uut_ir_oe && sol_ir_oe) begin
            if (uut_ma.l_r_data !== sol_ma.l_r_data) begin
                $display("(ERR) MISMATCH: Got %h != Wanted %h", uut_ma.l_r_data, sol_ma.l_r_data);
            end else $display("OK-FETCH");

            if(uut_opc !== sol_opc) begin
                $display("(ERR) OPCODE MISMATCH: Got %h != Wanted %h", uut_opc, sol_opc);
            end else $display("OK");
            if(uut_mod !== sol_mod) begin
                $display("(ERR) MOD MISMATCH: Got %h != Wanted %h", uut_mod, sol_mod);
            end else $display("OK");
            if(uut_rg !== sol_rg) begin
                $display("(ERR) REG MISMATCH: Got %h != Wanted %h", uut_rg, sol_rg);
            end else $display("OK");
            if(uut_rm !== sol_rm) begin
                $display("(ERR) RM MISMATCH: Got %h != Wanted %h", uut_rm, sol_rm);
            end else $display("OK");
            if(uut_d !== sol_d) begin
                $display("(ERR) D MISMATCH: Got %h != Wanted %h", uut_d, sol_d);
            end else $display("OK");

            rst = 0;
            i = i + 1;
            checker_is_override = 1;
            checker_pc_override = i;
            if(i == 5) $finish;
            #10 rst = 1;
            checker_is_override = 0;
        end
        # 10;
    end

    #100 
    
    #20 rst = 1;
    checker_is_override = 0;
    #400 $finish;


end

endmodule