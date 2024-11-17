module cpu #(
  parameter p_data_width = 16,
  parameter p_address_width = 10,
  parameter p_port_width = 8,
  parameter p_regs_address_width = 3,
) (
  `ifdef DEBUG
  output wire [(p_data_width - 1) : 0] o_w_regs_disp_out,
  input wire [p_regs_address_width : 0] i_w_regs_disp_addr,
  output wire [(p_data_width - 1) : 0] o_w_ram_disp_out,
  input wire [(p_address_width - 1) : 0] i_w_ram_disp_addr,
  output wire [(p_data_width - 1) : 0] o_w_state_disp_out,
  output wire [(p_data_width - 1) : 0] o_w_bus_disp_out,
  `endif
  input wire i_w_clk,
  input wire i_w_reset,
  // IO port
  input wire [(p_data_width - 1) : 0] i_w_io_out,
  output wire o_w_io_oe,
  output wire o_w_io_we,
  output wire [(p_port_width - 1) : 0] o_w_io_port,
  output wire [(p_data_width - 1) : 0] o_w_io_in
);


  // GENERAL PURPOSE REGISTERS
  // General purpose registers
  wire                                  l_w_regs_oe;
  wire                                  l_w_regs_we;
  wire[(p_regs_address_width-1) : 0]    l_w_regs_addr;
  wire[(p_data_width - 1) : 0]          l_w_regs_in;
  wire[(p_data_width - 1) : 0]          l_w_regs_out;

  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]          l_w_regs_disp_out;
  wire[(p_regs_address_width-1) : 0]    l_w_regs_disp_addr;
  
  /*
  MSB of i_w_regs_disp_addr is used to select beetween
  general purpose registers (0) and special registers (1)
  */
  assign l_w_regs_disp_addr = i_w_regs_disp_addr[(p_regs_address_width-1) : 1];
  `endif

  regfile #(
    .p_data_width(p_data_width),
    .p_address_width(p_regs_address_width)
  ) l_m_regfile (
    `ifdef DEBUG
    .o_w_disp_out(l_w_regs_disp_out),
    .i_w_disp_reg(l_w_regs_disp_addr),
    `endif
    .o_w_out(l_w_regs_out),
    .i_w_in(l_w_regs_in),
    .i_w_reg(l_w_regs_addr),
    .i_w_we(l_w_regs_we),
    .i_w_oe(l_w_regs_oe),
    .i_w_reset(i_w_reset),
    .i_w_clk(i_w_clk)
  );

  // SPECIAL PURPOSE REGISTERS

  // instantiate PC register and related connections
  wire                              l_w_pc_oe;
  wire                              l_w_pc_we;
  wire[(p_data_width - 1) : 0]      l_w_pc_in;
  wire[(p_data_width - 1) : 0]      l_w_pc_out;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_pc_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_program_counter (
    `ifdef DEBUG
    .o_w_disp_out(l_w_pc_disp_out),
    `endif
    .o_w_out(l_w_pc_out),
    .i_w_in(l_w_pc_in),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_we(l_w_pc_we),
    .i_w_oe(l_w_pc_oe)
  );

  

  // instantiate IR register and related connections
  wire                              l_w_ir_oe;
  wire                              l_w_ir_we;
  wire[(p_data_width - 1) : 0]      l_w_ir_in;
  wire[(p_data_width - 1) : 0]      l_w_ir_out;
  wire[(p_data_width - 1) : 0]      l_w_ir_internal;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_ir_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_instruction_register (
    `ifdef DEBUG
    .o_w_disp_out(l_w_ir_disp_out),
    `endif
    .o_w_out(l_w_ir_internal),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_ir_in),
    .i_w_we(l_w_ir_we),
    .i_w_oe(1'b1)
  );
  // IR always output the internal value to the control unit
  // for mag will be a different signal
  assign l_w_ir_out = (l_w_ir_oe) ? l_w_ir_internal : {p_data_width{1'b0}};

  // instantiate FR register and related connections
  wire                              l_w_flags_oe;
  wire                              l_w_flags_we;
  wire[(p_data_width - 1) : 0]      l_w_flags_in;
  wire[(p_data_width - 1) : 0]      l_w_flags_out;
  wire[(p_data_width - 1) : 0]      l_w_flags_internal;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_flags_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_flags (
    `ifdef DEBUG
    .o_w_disp_out(l_w_flags_disp_out),
    `endif
    .o_w_out(l_w_flags_internal),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_flags_in),
    .i_w_we(l_w_flags_we),
    .i_w_oe(1'b1)
  );
  // FLAGS always output the internal value to the control unit
  // for mag will be a different signal
  assign l_w_flags_out = (l_w_flags_oe) ? l_w_flags_internal : {p_data_width{1'b0}};



  // instantiate MA register and related connections
  wire                              l_w_ma_oe;
  wire                              l_w_ma_we;
  wire[(p_data_width - 1) : 0]      l_w_ma_in;
  wire[(p_data_width - 1) : 0]      l_w_ma_out;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_ma_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_memory_address (
    `ifdef DEBUG
    .o_w_disp_out(l_w_ma_disp_out),
    `endif
    .o_w_out(l_w_ma_out),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_ma_in),
    .i_w_we(l_w_ma_we),
    .i_w_oe(l_w_ma_oe)
  );

  // instantiate IOA register and related connections
  wire                              l_w_ioa_oe;
  wire                              l_w_ioa_we;
  wire[(p_data_width - 1) : 0]      l_w_ioa_in;
  wire[(p_data_width - 1) : 0]      l_w_ioa_out;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_ioa_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_input_output_address (
    `ifdef DEBUG
    .o_w_disp_out(l_w_ioa_disp_out),
    `endif
    .o_w_out(l_w_ioa_out),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_ioa_in),
    .i_w_we(l_w_ioa_we),
    .i_w_oe(l_w_ioa_oe)
  );

  // instantiate T1 register and related connections
  wire                              l_w_t1_oe;
  wire                              l_w_t1_we;
  wire[(p_data_width - 1) : 0]      l_w_t1_in;
  wire[(p_data_width - 1) : 0]      l_w_t1_out;
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_t1_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_t1 (
    `ifdef DEBUG
    .o_w_out(l_w_t1_disp_out),
    `endif
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
  `ifdef DEBUG
  wire[(p_data_width - 1) : 0]      l_w_t2_disp_out;
  `endif
  register #(
    .p_data_width(p_data_width)
  ) l_m_register_t2 (
    `ifdef DEBUG
    .o_w_out(l_w_t2_disp_out),
    `endif
    .o_w_out(l_w_t2_out),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_in(l_w_t2_in),
    .i_w_we(l_w_t2_we),
    .i_w_oe(l_w_t2_oe)
  );

  // set the disp registers
  `ifdef DEBUG
  assign o_w_regs_disp_out = (i_w_regs_disp_addr[p_regs_address_width] == 0) ? l_w_regs_disp_out : (
    (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b000) ? l_w_pc_disp_out : (
      (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b001) ? l_w_flags_disp_out : (
        (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b010) ? l_w_ma_disp_out : (
          (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b011) ? l_w_ioa_disp_out : (
            (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b100) ? l_w_t1_disp_out : (
              (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b101) ? l_w_t2_disp_out : (
                (i_w_regs_disp_addr[(p_regs_address_width-1):0] == 3'b110) ? l_w_ir_disp_out : 0
              )
            )
          )
        )
      )
    )
  );
  `endif

  // RAM
  // instantiate RAM and related connections
  // synthesis attribute box_type ram "block RAM"
  wire                              l_w_ram_oe;
  wire                              l_w_ram_we;
  wire[(p_data_width - 1) : 0]      l_w_ram_in;
  wire[(p_data_width - 1) : 0]      l_w_ram_out;
  cram #(
    .p_data_width(p_data_width),
    .p_address_width(p_address_width)
  ) l_m_ram (
    `ifdef DEBUG
    .o_w_disp_out(o_w_ram_disp_out),
    .i_w_disp_address(i_w_ram_disp_addr),
    `endif
    .o_w_out(l_w_ram_out),
    .i_w_in(l_w_ram_in),
    .i_w_address(l_w_ma_out[(p_address_width-1) : 0]),
    .i_w_we(l_w_ram_we),
    .i_w_oe(l_w_ram_oe),
    .i_w_clk(i_w_clk)
  );


  // ALU
  // instantiate ALU and related connections
  // ALU parameters
  parameter l_p_opcode_width = 4;
  parameter l_p_opcode_ADC = 4'd0;
  parameter l_p_opcode_SBB1 = 4'd1;
  parameter l_p_opcode_SBB2 = 4'd2;
  parameter l_p_opcode_NOT = 4'd3;
  parameter l_p_opcode_AND = 4'd4;
  parameter l_p_opcode_OR = 4'd5;
  parameter l_p_opcode_XOR = 4'd6;
  parameter l_p_opcode_SHL = 4'd7;
  parameter l_p_opcode_SHR = 4'd8;
  parameter l_p_opcode_SAR = 4'd9;
  parameter l_p_flags_width = 5;
  // ALU connections
  wire[(p_data_width - 1) : 0]        l_w_alu_out;
  wire[(l_p_flags_width - 1) : 0]     l_w_alu_flags;
  wire[(l_p_opcode_width - 1) : 0]    l_w_alu_opcode;
  wire                                l_w_alu_carry;
  wire                                l_w_alu_oe;
  // ALU instantiation
  alu #(
    .p_data_width(p_data_width),
    .p_flags_width(l_p_flags_width),
    .p_opcode_width(l_p_opcode_width),
    .p_opcode_ADC(l_p_opcode_ADC),
    .p_opcode_SBB1(l_p_opcode_SBB1),
    .p_opcode_SBB2(l_p_opcode_SBB2),
    .p_opcode_NOT(l_p_opcode_NOT),
    .p_opcode_AND(l_p_opcode_AND),
    .p_opcode_OR(l_p_opcode_OR),
    .p_opcode_XOR(l_p_opcode_XOR),
    .p_opcode_SHL(l_p_opcode_SHL),
    .p_opcode_SHR(l_p_opcode_SHR),
    .p_opcode_SAR(l_p_opcode_SAR)
  ) l_m_alu (
    .o_w_out(l_w_alu_out),
    .o_w_flags(l_w_alu_flags),
    .i_w_in1(l_w_t1_out),
    .i_w_in2(l_w_t2_out),
    .i_w_opcode(l_w_alu_opcode),
    .i_w_carry(l_w_alu_carry),
    .i_w_oe(l_w_alu_oe)
  );


  // OTHER CONNECTIONS

  // create the custom logic for IO port address output
  assign o_w_io_port = l_w_ioa_out[(p_port_width - 1) : 0];


  // create the custom logic for FR register input and necessary control signal
  wire                              l_w_flags_sel;
  wire[(p_data_width - 1) : 0]      l_w_flags_bus;
  // flags register can be written from the bus or from the ALU
  assign l_w_flags_in = l_w_flags_sel ? l_w_alu_flags : l_w_flags_bus;

  // create the custom logic for conditional jump offset (RI[8:15]) generation
  wire[(p_data_width - 1) : 0]      l_w_offset_out;
  assign l_w_offset_out = {
    {8{l_w_ir_out[8]}},
    l_w_ir_out[8],
    l_w_ir_out[9],
    l_w_ir_out[10],
    l_w_ir_out[11],
    l_w_ir_out[12],
    l_w_ir_out[13],
    l_w_ir_out[14],
    l_w_ir_out[15]
  };

  // BUS CONNECTIONS
  // instatiate the bus that connects everything toghether
  bus #(
    .p_data_width(p_data_width)
  ) l_m_bus (
    `ifdef DEBUG
    .o_w_disp_out(o_w_bus_disp_out),
    `endif
    .o_w_bus_to_ram(l_w_ram_in),
    .o_w_bus_to_io(o_w_io_in),
    .o_w_bus_to_regs(l_w_regs_in),
    .o_w_bus_to_pc(l_w_pc_in),
    .o_w_bus_to_flags(l_w_flags_bus),
    .o_w_bus_to_ma(l_w_ma_in),
    .o_w_bus_to_ioa(l_w_ioa_in),
    .o_w_bus_to_t1(l_w_t1_in),
    .o_w_bus_to_t2(l_w_t2_in),
    .o_w_bus_to_ir(l_w_ir_in),
    .i_w_alu_to_bus(l_w_alu_out),
    .i_w_ram_to_bus(l_w_ram_out),
    .i_w_io_to_bus(i_w_io_out),
    .i_w_regs_to_bus(l_w_regs_out),
    .i_w_pc_to_bus(l_w_pc_out),
    .i_w_flags_to_bus(l_w_flags_out),
    .i_w_offset_to_bus(l_w_offset_out)
  );

  // CONTROL UNIT MODULE
  control_unit #(
    .p_data_width(p_data_width),
    .p_opcode_width(l_p_opcode_width),
    .p_opcode_ADC(l_p_opcode_ADC),
    .p_opcode_SBB1(l_p_opcode_SBB1),
    .p_opcode_SBB2(l_p_opcode_SBB2),
    .p_opcode_NOT(l_p_opcode_NOT),
    .p_opcode_AND(l_p_opcode_AND),
    .p_opcode_OR(l_p_opcode_OR),
    .p_opcode_XOR(l_p_opcode_XOR),
    .p_opcode_SHL(l_p_opcode_SHL),
    .p_opcode_SHR(l_p_opcode_SHR),
    .p_opcode_SAR(l_p_opcode_SAR),
    .p_regs_address_width(p_regs_address_width)
  ) l_m_cu (
    `ifdef DEBUG
    .o_w_state_disp_out(o_w_state_disp_out),
    `endif
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
    .o_r_pc_oe(l_w_pc_oe),
    .o_r_pc_we(l_w_pc_we),
    .o_r_flags_sel(l_w_flags_sel),        // controls FR register input (0 = bus, 1 = alu flags)
    .o_r_flags_oe(l_w_flags_oe),
    .o_r_flags_we(l_w_flags_we),
    .o_r_ma_oe(l_w_ma_oe),
    .o_r_ma_we(l_w_ma_we),
    .o_r_ioa_oe(l_w_ioa_oe),
    .o_r_ioa_we(l_w_ioa_we),
    .o_r_t1_oe(l_w_t1_oe),
    .o_r_t1_we(l_w_t1_we),
    .o_r_t2_oe(l_w_t2_oe),
    .o_r_t2_we(l_w_t2_we),
    .o_r_ir_oe(l_w_ir_oe),          // controls IR register output which generates the offset for Jcond instructions
    .o_r_ir_we(l_w_ir_we),
    .i_w_clk(i_w_clk),
    .i_w_reset(i_w_reset),
    .i_w_ir(l_w_ir_internal),
    .i_w_flags(l_w_flags_internal)
  );


endmodule
