`timescale 1ns / 1ps
module cpu #(
  parameter p_data_width = 16,
  parameter p_address_width = 10,
  parameter p_port_width = 8
)(
  input wire i_w_clk,
  input wire i_w_reset,
  input wire [(p_data_width - 1) : 0] i_w_io_out,
  output wire o_w_io_oe,
  output wire o_w_io_we,
  output wire [(p_port_width - 1) : 0] o_w_io_port,
  output wire [(p_data_width - 1) : 0] o_w_io_in
);

  // instantiate CP register and related connections
  wire                              l_w_cp_oe;
  wire                              l_w_cp_we;
  wire[(p_data_width - 1) : 0]      l_w_cp_in;
  wire[(p_data_width - 1) : 0]      l_w_cp_out;
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_cp(
    .o_w_out(l_w_cp_out),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_cp_in),
    .i_w_we(l_w_cp_we),
    .i_w_oe(l_w_cp_oe)
  );

  // instantiate IND register and related connections
  wire                              l_w_ind_oe;
  wire                              l_w_ind_we;
  wire[(p_data_width - 1) : 0]      l_w_ind_in;
  wire[(p_data_width - 1) : 0]      l_w_ind_out;
  wire[(p_data_width - 1) : 0]      l_w_ind_disp_out;
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_ind(
    .o_w_out(l_w_ind_out),
    .o_w_disp_out(l_w_ind_disp_out),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_ind_in),
    .i_w_we(l_w_ind_we),
    .i_w_oe(l_w_ind_oe)
  );

// instantiate AM register and related connections
wire                              l_w_am_oe;
wire                              l_w_am_we;
wire[(p_data_width - 1) : 0]      l_w_am_in;
wire[(p_data_width - 1) : 0]      l_w_am_out;
register #(
  .p_data_width(p_data_width)
) l_m_register_am(
  .o_w_out(l_w_am_out),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_in(l_w_am_in),
  .i_w_we(l_w_am_we),
  .i_w_oe(l_w_am_oe)
);

// instantiate AIE register and related connections
wire                              l_w_aie_oe;
wire                              l_w_aie_we;
wire[(p_data_width - 1) : 0]      l_w_aie_in;
wire[(p_data_width - 1) : 0]      l_w_aie_out;
register #(
  .p_data_width(p_data_width)
) l_m_register_aie(
  .o_w_out(l_w_aie_out),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_in(l_w_aie_in),
  .i_w_we(l_w_aie_we),
  .i_w_oe(l_w_aie_oe)
);
// instantiate T1 register and related connections
wire                              l_w_t1_oe;
wire                              l_w_t1_we;
wire[(p_data_width - 1) : 0]      l_w_t1_in;
wire[(p_data_width - 1) : 0]      l_w_t1_out;
register #(
  .p_data_width(p_data_width)
) l_m_register_t1(
  .o_w_out(l_w_t1_out),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_in(l_w_t1_in),
  .i_w_we(l_w_t1_we),
  .i_w_oe(l_w_t1_oe)
);

// instantiate T2 register and related connections
wire                              l_w_t2_oe;
wire                              l_w_t2_we;
wire[(p_data_width - 1) : 0]      l_w_t2_in;
wire[(p_data_width - 1) : 0]      l_w_t2_out;
register #(
  .p_data_width(p_data_width)
) l_m_register_t2(
  .o_w_out(l_w_t2_out),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_in(l_w_t2_in),
  .i_w_we(l_w_t2_we),
  .i_w_oe(l_w_t2_oe)
);

// instantiate RI register and related connections
wire                              l_w_ri_oe;
wire                              l_w_ri_we;
wire[(p_data_width - 1) : 0]      l_w_ri_in;
wire[(p_data_width - 1) : 0]      l_w_ri_out;
wire[(p_data_width - 1) : 0]      l_w_ri_disp_out;
register #(
  .p_data_width(p_data_width)
) l_m_register_ri(
  .o_w_out(l_w_ri_out),
  .o_w_disp_out(l_w_ri_disp_out),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_in(l_w_ri_in),
  .i_w_we(l_w_ri_we),
  .i_w_oe(l_w_ri_oe)
);

// instantiate ALU and related connections
wire[(p_data_width - 1) : 0]      l_w_alu_out;
wire[4 : 0]                       l_w_alu_flags;
wire[3 : 0]                       l_w_alu_opcode;
wire                              l_w_alu_carry;
wire                              l_w_alu_oe;
alu #(
  .p_data_width(p_data_width),
  .p_flags_width(5)
) l_m_alu(
  .o_w_out(l_w_alu_out),
  .o_w_flags(l_w_alu_flags),
  .i_w_in1(l_w_t1_out),
  .i_w_in2(l_w_t2_out),
  .i_w_opcode(l_w_alu_opcode),
  .i_w_carry(l_w_alu_carry),
  .i_w_oe(l_w_alu_oe)
);

// instantiate RAM and related connections
//synthesis attribute box_type ram "black_box"
wire                              l_w_ram_oe;
wire                              l_w_ram_we;
wire[(p_data_width - 1) : 0]      l_w_ram_in;
wire[(p_data_width - 1) : 0]      l_w_ram_out;
cram #(
  .p_data_width(p_data_width),
  .p_address_width(p_address_width)
) l_m_ram (
  .o_w_out(l_w_ram_out),
  .i_w_in(l_w_ram_in),
  .i_w_address(l_w_am_out[(p_address_width-1) : 0]),
  .i_w_we(l_w_ram_we),
  .i_w_oe(l_w_ram_oe),
  .i_w_clk(i_w_clk)
);
// it appears ssra does not work correctly in simulation so we need to implement RAM output enable manually
//assign ram_out = ram_oe ? ram_tmp : 0;

// create the custom logic for IO port address output
assign o_w_io_port = l_w_aie_out[(p_port_width - 1) : 0];

// instantiate the register file and related connections
wire                              l_w_regs_oe;
wire                              l_w_regs_we;
wire[2 : 0]                       l_w_regs_addr;
wire[(p_data_width - 1) : 0]      l_w_regs_in;
wire[(p_data_width - 1) : 0]      l_w_regs_out;
registers #(
  .p_data_width(p_data_width),
  .p_address_width(3)
) l_m_registers (
  .o_w_out(l_w_regs_out),
  .i_w_in(l_w_regs_in),
  .i_w_address(l_w_regs_addr),
  .i_w_we(l_w_regs_we),
  .i_w_oe(l_w_regs_oe),
  .i_w_clk(i_w_clk)
);

// create the custom logic for IND register input and necessary control signal
wire                              l_w_ind_sel;
wire[(p_data_width - 1) : 0]      l_w_ind_mag;
assign l_w_ind_in = l_w_ind_sel ? l_w_alu_flags : l_w_ind_mag;

// create the custom logic for conditional jump offset (RI[8:15]) generation
wire[(p_data_width - 1) : 0]      l_w_offset_out;
assign l_w_offset_out = {
  {8{l_w_ri_out[8]}},
  l_w_ri_out[8],
  l_w_ri_out[9],
  l_w_ri_out[10],
  l_w_ri_out[11],
  l_w_ri_out[12],
  l_w_ri_out[13],
  l_w_ri_out[14],
  l_w_ri_out[15]
};

// instatiate the bus that connects everything toghether
bus #(
  .p_data_width(p_data_width)
) l_m_bus (
  .i_w_alu_to_bus(l_w_alu_out),
  .i_w_ram_to_bus(l_w_ram_out),
  .i_w_io_to_bus(i_w_io_out),
  .i_w_regs_to_bus(l_w_regs_out),
  .i_w_cp_to_bus(l_w_cp_out),
  .i_w_ind_to_bus(l_w_ind_out),
  .i_w_offset_to_bus(l_w_offset_out),
  .o_w_bus_to_ram(l_w_ram_in),
  .o_w_bus_to_io(o_w_io_in),
  .o_w_bus_to_regs(l_w_regs_in),
  .o_w_bus_to_cp(l_w_cp_in),
  .o_w_bus_to_ind(l_w_ind_in),
  .o_w_bus_to_am(l_w_am_in),
  .o_w_bus_to_aie(l_w_aie_in),
  .o_w_bus_to_t1(l_w_t1_in),
  .o_w_bus_to_t2(l_w_t2_in),
  .o_w_bus_to_ri(l_w_ri_in)
);

// instantiate command unit
uc #(
  .p_data_width(p_data_width)
) l_m_uc (
  .o_r_alu_oe(l_w_alu_oe),
  .o_r_alu_carry(l_w_alu_carry),
  .o_r_alu_opcode(l_w_alu_opcode),
  .o_r_ram_oe(l_w_ram_oe),
  .o_r_ram_we(l_w_ram_we),
  .o_r_io_oe(o_w_io_oe),
  .o_r_io_we(o_w_io_we),
  .o_r_regs_addr(l_w_regs_addr),
  .o_r_regs_oe(l_w_regs_oe),
  .o_r_regs_we(l_w_regs_we),
  .o_r_cp_oe(l_w_cp_oe),
  .o_r_cp_we(l_w_cp_we),
  .o_r_ind_sel(l_w_ind_sel),        // controls IND register input (0 = bus, 1 = alu flags)
  .o_r_ind_oe(l_w_ind_oe),
  .o_r_ind_we(l_w_ind_we),
  .o_r_am_oe(l_w_am_oe),
  .o_r_am_we(l_w_am_we),
  .o_r_aie_oe(l_w_aie_oe),
  .o_r_aie_we(l_w_aie_we),
  .o_r_t1_oe(l_w_t1_oe),
  .o_r_t1_we(l_w_t1_we),
  .o_r_t2_oe(l_w_t2_oe),
  .o_r_t2_we(l_w_t2_we),
  .o_r_ri_oe(l_w_ri_oe),          // controls RI register output which generates the offset for Jcond instructions
  .o_r_ri_we(l_w_ri_we),
  .i_w_clk(i_w_clk),
  .i_w_reset(i_w_reset),
  .i_w_ri(l_w_ri_disp_out),
  .i_w_ind(l_w_ind_disp_out)
);
endmodule
