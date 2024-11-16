`timescale 1ns / 1ps
module bus #(
    parameter p_data_width = 16
) (
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ram,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_io,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_regs,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_cp,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ind,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_am,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_aie,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_t1,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_t2,
    output wire [(p_data_width - 1) : 0] o_w_bus_to_ri,
    output wire [(p_data_width - 1) : 0] o_w_disp_out,
    input wire [(p_data_width - 1) : 0] i_w_alu_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_ram_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_io_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_regs_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_cp_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_ind_to_bus,
    input wire [(p_data_width - 1) : 0] i_w_offset_to_bus
);

wire [(p_data_width - 1) : 0]  l_w_bus;

assign l_w_bus = i_w_alu_to_bus | 
                 i_w_ram_to_bus |
                 i_w_io_to_bus |
                 i_w_regs_to_bus |
                 i_w_cp_to_bus |
                 i_w_ind_to_bus |
                 i_w_offset_to_bus;

assign o_w_bus_to_ram = l_w_bus;
assign o_w_bus_to_io = l_w_bus;
assign o_w_bus_to_regs = l_w_bus;
assign o_w_bus_to_cp = l_w_bus;
assign o_w_bus_to_ind = l_w_bus;
assign o_w_bus_to_am = l_w_bus;
assign o_w_bus_to_aie = l_w_bus;
assign o_w_bus_to_t1 = l_w_bus;
assign o_w_bus_to_t2 = l_w_bus;
assign o_w_bus_to_ri = l_w_bus;

assign o_w_disp_out = l_w_bus;

endmodule
