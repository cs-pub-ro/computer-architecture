module control_unit(
    input clk,
    input rst,
    input [15:0] ir,
    input [4:0] flags,
    output reg t1_oe, 
    output reg t1_we,
    output reg t2_oe, 
    output reg t2_we,
    output reg regs_oe,
    output reg regs_we,
    output reg [2:0] regs_addr,
    output reg alu_carry,
    output reg [3:0] alu_opcode,
    output reg alu_oe,
    output reg ram_we, 
    output reg ram_oe,
    output reg ma_oe, 
    output reg ma_we,
    output reg pc_oe, 
    output reg pc_we,
    output wire load_done, 
    output wire exec_done,
    output wire store_done,
    output reg flags_we
);

// Define further states here (if needed)
localparam INIT = 0;
localparam LOAD_DONE = 1;
localparam EXEC_DONE = 2;
localparam STORE_DONE = 3;
localparam LOAD = 4;
localparam EXEC = 30;
localparam STORE = 50;

reg [7:0] state, next_state;

always @(posedge clk) begin
    state <= next_state;
end

assign load_done = state == LOAD_DONE;
assign exec_done = state == EXEC_DONE;
assign store_done = state == STORE_DONE;

wire d;
wire [0:1] mod;
wire [0:2] rg, rm;
wire [0:6] opc;
wire [15:0] ir_rev;

generate for (genvar i = 0; i < 16; i = i + 1)
    assign ir_rev[i] = ir[15 - i];
endgenerate

assign {opc, d, mod, rg, rm} = ir_rev;

always @(*) begin
    t1_oe = 0;
    t1_we = 0;
    t2_oe = 0;
    t2_we = 0;
    regs_oe = 0;
    regs_we = 0;
    regs_addr = 0;
    alu_carry = 0;
    alu_opcode = 0;
    ram_we = 0;
    ram_oe = 0;
    ma_oe = 0;
    ma_we = 0;
    pc_oe = 0;
    pc_we = 0;
    flags_we = 0;

    case(state)
    INIT: next_state = LOAD;
    LOAD_DONE: next_state = EXEC;
    EXEC_DONE: next_state = STORE;
    STORE_DONE: next_state = STORE_DONE;
    // TODO define LOAD, EXEC, STORE here

    default: next_state = INIT;
    endcase
end

endmodule