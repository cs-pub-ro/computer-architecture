module bus #(
    parameter p_data_width = 16
) (
    `ifdef DEBUG
    output wire [(p_data_width - 1) : 0] o_w_disp_out,
    `endif
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ram,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_io,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_regs,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_pc,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_flags,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ma,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ioa,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_t1,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_t2,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ir,
    input wire [(p_data_width - 1) : 0] i_w_alu_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_ram_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_io_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_regs_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_pc_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_flags_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_offset_to_bus
);

wire [(p_data_width - 1) : 0]  l_w_bus;

assign l_w_bus = i_w_alu_to_bus | 
                 i_w_ram_to_bus |
                 i_w_io_to_bus |
                 i_w_regs_to_bus |
                 i_w_pc_to_bus |
                 i_w_flags_to_bus |
                 i_w_offset_to_bus;

assign o_w_bus_to_ram = l_w_bus;
assign o_w_bus_to_io = l_w_bus;
assign o_w_bus_to_regs = l_w_bus;
assign o_w_bus_to_pc = l_w_bus;
assign o_w_bus_to_flags = l_w_bus;
assign o_w_bus_to_ma = l_w_bus;
assign o_w_bus_to_ioa = l_w_bus;
assign o_w_bus_to_t1 = l_w_bus;
assign o_w_bus_to_t2 = l_w_bus;
assign o_w_bus_to_ir = l_w_bus;

assign o_w_disp_out = l_w_bus;

endmodule
