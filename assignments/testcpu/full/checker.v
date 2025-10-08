module checker;
reg rst = 0;


reg sol_clk = 0;

reg [15:0] ir;
wire [4:0] sol_flags;
wire [4:0] sol_alu_flags;
wire sol_t1_oe;
wire sol_t1_we;
wire sol_t2_oe;
wire sol_t2_we;
wire sol_regs_oe;
wire sol_regs_we;
wire [2:0] sol_regs_addr;
wire sol_alu_carry;
wire [3:0] sol_alu_opcode;
wire sol_alu_oe;
wire sol_ram_we;
wire sol_ram_oe;
wire sol_ma_oe;
wire sol_ma_we;
wire sol_pc_oe;
wire sol_pc_we;
wire sol_load_done;
wire sol_exec_done;
wire sol_store_done;
wire sol_flags_we;


wire [15:0] sol_biu_bus_out;
wire [15:0] sol_t1_o_w_out;
wire [15:0] sol_t2_o_w_out;
wire [15:0] sol_alu_o_w_out;
wire [15:0] sol_ram_o_w_out;
control_unit_sol cu(
    .clk(sol_clk),
    .rst(rst),
    .ir(ir),
    .flags(sol_flags),
    .t1_oe(sol_t1_oe), 
    .t1_we(sol_t1_we),
    .t2_oe(sol_t2_oe), 
    .t2_we(sol_t2_we),
    .regs_oe(sol_regs_oe),
    .regs_we(sol_regs_we),
    .regs_addr(sol_regs_addr),
    .alu_carry(sol_alu_carry),
    .alu_opcode(sol_alu_opcode),
    .alu_oe(sol_alu_oe),
    .ram_we(sol_ram_we), 
    .ram_oe(sol_ram_oe),
    .ma_oe(sol_ma_oe), 
    .ma_we(sol_ma_we),
    .pc_oe(sol_pc_oe), 
    .pc_we(sol_pc_we),
    .load_done(sol_load_done), 
    .exec_done(sol_exec_done),
    .store_done(sol_store_done),
    .flags_we(sol_flags_we)
);

wire [15:0] sol_rg_o_w_out;



regfile #(
    .p_data_width(16),
    .p_address_width(3)
) sol_regs (
    .o_w_out(sol_rg_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_reg(sol_regs_addr),
    .i_w_we(sol_regs_we),
    .i_w_oe(sol_regs_oe),
    .i_w_clk(sol_clk)
);

register #(
    .p_data_width(16)
) sol_t1 (
    .o_w_out(sol_t1_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_t1_we),
    .i_w_oe(sol_t1_oe)
);

register #(
    .p_data_width(16)
) sol_t2 (
    .o_w_out(sol_t2_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_t2_we),
    .i_w_oe(sol_t2_oe)
);

register #(
    .p_data_width(5)
) sol_flags_reg (
    .o_w_out(sol_flags),
    .i_w_in(sol_alu_flags),
    .i_w_clk(sol_clk),
    .i_w_we(sol_flags_we),
    .i_w_oe(1'b1)
);

wire [15:0] sol_pc_o_w_out;
register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) sol_pc (
    .o_w_out(sol_pc_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_clk(sol_clk),
    .i_w_we(sol_pc_we),
    .i_w_oe(sol_pc_oe)
);


bus_interface_unit sol_biu (
    .bus_out(sol_biu_bus_out),
    .regs_in(sol_rg_o_w_out),
    .alu_in(sol_alu_o_w_out),
    .pc_in(sol_pc_o_w_out),
    .ram_in(sol_ram_o_w_out)
);


alu sol_alu (
    .o_w_out(sol_alu_o_w_out),
    .o_w_flags(sol_alu_flags),
    .i_w_in1(sol_t1_o_w_out),
    .i_w_in2(sol_t2_o_w_out),
    .i_w_opcode(sol_alu_opcode),
    .i_w_carry(sol_alu_carry),
    .i_w_oe(sol_alu_oe)
);

wire [15:0] sol_ma_out;

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

cram sol_cram (
    .o_w_out(sol_ram_o_w_out),
    .i_w_in(sol_biu_bus_out),
    .i_w_address(sol_ma_out[9:0]),
    .i_w_we(sol_ram_we),
    .i_w_oe(sol_ram_oe),
    .i_w_clk(sol_clk)
);





reg uut_clk = 0;

wire [4:0] uut_flags;
wire [4:0] uut_alu_flags;
wire uut_t1_oe;
wire uut_t1_we;
wire uut_t2_oe;
wire uut_t2_we;
wire uut_regs_oe;
wire uut_regs_we;
wire [2:0] uut_regs_addr;
wire uut_alu_carry;
wire [3:0] uut_alu_opcode;
wire uut_alu_oe;
wire uut_ram_we;
wire uut_ram_oe;
wire uut_ma_oe;
wire uut_ma_we;
wire uut_pc_oe;
wire uut_pc_we;
wire uut_load_done;
wire uut_exec_done;
wire uut_store_done;
wire uut_flags_we;


wire [15:0] uut_biu_bus_out;
wire [15:0] uut_t1_o_w_out;
wire [15:0] uut_t2_o_w_out;
wire [15:0] uut_alu_o_w_out;
wire [15:0] uut_ram_o_w_out;
control_unit uut(
    .clk(uut_clk),
    .rst(rst),
    .ir(ir),
    .flags(uut_flags),
    .t1_oe(uut_t1_oe), 
    .t1_we(uut_t1_we),
    .t2_oe(uut_t2_oe), 
    .t2_we(uut_t2_we),
    .regs_oe(uut_regs_oe),
    .regs_we(uut_regs_we),
    .regs_addr(uut_regs_addr),
    .alu_carry(uut_alu_carry),
    .alu_opcode(uut_alu_opcode),
    .alu_oe(uut_alu_oe),
    .ram_we(uut_ram_we), 
    .ram_oe(uut_ram_oe),
    .ma_oe(uut_ma_oe), 
    .ma_we(uut_ma_we),
    .pc_oe(uut_pc_oe), 
    .pc_we(uut_pc_we),
    .load_done(uut_load_done), 
    .exec_done(uut_exec_done),
    .store_done(uut_store_done),
    .flags_we(uut_flags_we)
);

wire [15:0] uut_rg_o_w_out;



regfile #(
    .p_data_width(16),
    .p_address_width(3)
) uut_regs (
    .o_w_out(uut_rg_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_reg(uut_regs_addr),
    .i_w_we(uut_regs_we),
    .i_w_oe(uut_regs_oe),
    .i_w_clk(uut_clk)
);

register #(
    .p_data_width(16)
) uut_t1 (
    .o_w_out(uut_t1_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_t1_we),
    .i_w_oe(uut_t1_oe)
);

register #(
    .p_data_width(16)
) uut_t2 (
    .o_w_out(uut_t2_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_t2_we),
    .i_w_oe(uut_t2_oe)
);

register #(
    .p_data_width(5)
) uut_flags_reg (
    .o_w_out(uut_flags),
    .i_w_in(uut_alu_flags),
    .i_w_clk(uut_clk),
    .i_w_we(uut_flags_we),
    .i_w_oe(1'b1)
);

wire [15:0] uut_pc_o_w_out;
register #(
    .p_data_width(16),
    .p_initial_value(16'h0000)
) uut_pc (
    .o_w_out(uut_pc_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_clk(uut_clk),
    .i_w_we(uut_pc_we),
    .i_w_oe(uut_pc_oe)
);


bus_interface_unit uut_biu (
    .bus_out(uut_biu_bus_out),
    .regs_in(uut_rg_o_w_out),
    .alu_in(uut_alu_o_w_out),
    .pc_in(uut_pc_o_w_out),
    .ram_in(uut_ram_o_w_out)
);


alu uut_alu (
    .o_w_out(uut_alu_o_w_out),
    .o_w_flags(uut_alu_flags),
    .i_w_in1(uut_t1_o_w_out),
    .i_w_in2(uut_t2_o_w_out),
    .i_w_opcode(uut_alu_opcode),
    .i_w_carry(uut_alu_carry),
    .i_w_oe(uut_alu_oe)
);

wire [15:0] uut_ma_out;

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

cram uut_cram (
    .o_w_out(uut_ram_o_w_out),
    .i_w_in(uut_biu_bus_out),
    .i_w_address(uut_ma_out[9:0]),
    .i_w_we(uut_ram_we),
    .i_w_oe(uut_ram_oe),
    .i_w_clk(uut_clk)
);



reg [1:0] checker_state;
initial begin
    checker_state = 0;
    ir = sol_cram.block_ram_inst.l_r_data[0];
    #10 rst = 1;
    // $monitor(
    //         "Time = %0t, ", $time,
    //         "ref t1=%h, ", sol_t1.l_r_data,
    //         "ref t2=%h, ", sol_t2.l_r_data,
    //         "t2=%h, ", sol_t2.l_r_data,
    //         "rg=%b, ", cu.rm,
    //         "pc=%h, ", sol_pc.l_r_data,
    //     );
    while (1) begin
        if ($time > 1000) begin
            $display("Timeout");
            $finish;
        end
        if (checker_state == 0) begin
            if (sol_load_done && uut_load_done) begin
                if (sol_t1.l_r_data == uut_t1.l_r_data) begin
                    $display("(LOAD) T1 OK");
                end else begin
                    $display("(LOAD) T1 ERR: ref=%h, you=%h", sol_t1.l_r_data, uut_t1.l_r_data);
                end
                if (sol_t2.l_r_data == uut_t2.l_r_data) begin
                    $display("(LOAD) T2 OK");
                end else begin
                    $display("(LOAD) T2 ERR: ref=%h, you=%h", sol_t2.l_r_data, uut_t2.l_r_data);
                end
                if (sol_pc.l_r_data == uut_pc.l_r_data) begin
                    $display("(LOAD) PC OK");
                end else begin
                    $display("(LOAD) PC ERR: ref=%h, you=%h", sol_pc.l_r_data, uut_pc.l_r_data);
                end
                checker_state = 1;
            end

            if (sol_load_done && !uut_load_done) begin
                uut_clk = ~uut_clk;
            end else if (!sol_load_done && uut_load_done) begin
                sol_clk = ~sol_clk;
            end else begin
                uut_clk = ~uut_clk;
                sol_clk = ~sol_clk;
            end
        end
        if (checker_state == 1) begin
            if (sol_exec_done && uut_exec_done) begin
                if (sol_t1.l_r_data == uut_t1.l_r_data) begin
                    $display("(EXEC) T1 OK");
                end else begin
                    $display("(EXEC) T1 ERR: ref=%h, you=%h", sol_t1.l_r_data, uut_t1.l_r_data);
                end
                if (sol_t2.l_r_data == uut_t2.l_r_data) begin
                    $display("(EXEC) T2 OK");
                end else begin
                    $display("(EXEC) T2 ERR: ref=%h, you=%h", sol_t2.l_r_data, uut_t2.l_r_data);
                end
                if (sol_pc.l_r_data == uut_pc.l_r_data) begin
                    $display("(EXEC) PC OK");
                end else begin
                    $display("(EXEC) PC ERR: ref=%h, you=%h", sol_pc.l_r_data, uut_pc.l_r_data);
                end
                checker_state = 2;
            end

            if (sol_exec_done && !uut_exec_done) begin
                uut_clk = ~uut_clk;
            end else if (!sol_exec_done && uut_exec_done) begin
                sol_clk = ~sol_clk;
            end else begin
                uut_clk = ~uut_clk;
                sol_clk = ~sol_clk;
            end
        end
        if (checker_state == 2) begin
            if (sol_store_done && uut_store_done) begin
                if (sol_t1.l_r_data == uut_t1.l_r_data) begin
                    $display("(STORE) T1 OK");
                end else begin
                    $display("(STORE) T1 ERR: ref=%h, you=%h", sol_t1.l_r_data, uut_t1.l_r_data);
                end
                if (sol_t2.l_r_data == uut_t2.l_r_data) begin
                    $display("(STORE) T2 OK");
                end else begin
                    $display("(STORE) T2 ERR: ref=%h, you=%h", sol_t2.l_r_data, uut_t2.l_r_data);
                end
                if (sol_pc.l_r_data == uut_pc.l_r_data) begin
                    $display("(STORE) PC OK");
                end else begin
                    $display("(STORE) PC ERR: ref=%h, you=%h", sol_pc.l_r_data, uut_pc.l_r_data);
                end
                $writememh("sol.hex", sol_cram.block_ram_inst.l_r_data);
                $writememh("uut.hex", uut_cram.block_ram_inst.l_r_data);
                $writememh("sol_regs.hex", sol_regs.l_r_data);
                $writememh("uut_regs.hex", uut_regs.l_r_data);

                $finish;
            end

            if (sol_store_done && !uut_store_done) begin
                uut_clk = ~uut_clk;
            end else if (!sol_store_done && uut_store_done) begin
                sol_clk = ~sol_clk;
            end else begin
                uut_clk = ~uut_clk;
                sol_clk = ~sol_clk;
            end
        end
        # 5;
    end
    
end

// control_unit cu(
//     .clk(clk),
//     .ir(ir),
//     .flags(uut_flags),
//     .t1_oe(uut_t1_oe), 
//     .t1_we(uut_t1_we),
//     .t2_oe(uut_t2_oe), 
//     .t2_we(uut_t2_we),
//     .regs_oe(uut_regs_oe),
//     .regs_we(uut_regs_we),
//     .regs_addr(uut_regs_addr),
//     .alu_carry(uut_alu_carry),
//     .alu_opcode(uut_alu_opcode),
//     .ram_we(uut_ram_oe), 
//     .ram_oe(uut_ram_we),
//     .ma_oe(uut_ma_oe), 
//     .ma_we(uut_ma_we),
//     .pc_oe(uut_pc_oe), 
//     .pc_we(uut_pc_we),
//     .load_done(uut_load_done), 
//     .exec_done(uut_exec_done),
//     .store_done(uut_store_done),
//     .flags_we(uut_flags_we)
// );


endmodule