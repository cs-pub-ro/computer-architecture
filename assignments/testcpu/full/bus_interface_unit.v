module bus_interface_unit (
    output wire [15:0] bus_out,
    input wire [15:0] regs_in,
    input wire [15:0] alu_in,
    input wire [15:0] pc_in,
    input wire [15:0] ram_in
);
    assign bus_out = regs_in | alu_in | pc_in | ram_in;
endmodule