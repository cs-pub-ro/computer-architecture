module bus_interface_unit (
    output wire [15:0] bus_out,
    input wire [15:0] ir_in,
    input wire [15:0] pc_in,
    input wire [15:0] ram_in,
    input wire [15:0] override,
    input wire is_override
);
    assign bus_out = is_override ? override : (ir_in | pc_in | ram_in);
endmodule