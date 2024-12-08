module control_unit(
    input clk,
    input rst,
    input [15:0] ir,
    output reg regs_oe,
    output reg regs_we,
    output reg [2:0] regs_addr,
    output reg ram_we, 
    output reg ram_oe,
    output reg ma_oe, 
    output reg ma_we,
    output reg pc_oe, 
    output reg pc_we,
    output reg ir_we,
    output reg ir_oe,
    output reg [6:0] opc,
    output reg d,
    output reg [1:0] mod,
    output reg [2:0] rg,
    output reg [2:0] rm
);

// Define further states here (if needed)
localparam INIT = 0;
localparam FETCH = 1;


reg [7:0] state, next_state;

always @(posedge clk) begin
    if (!rst) state <= INIT;
    else state <= next_state;
end


always @(*) begin
    regs_oe = 0;
    regs_we = 0;
    regs_addr = 0;
    ram_we = 0;
    ram_oe = 0;
    ma_oe = 0;
    ma_we = 0;
    pc_oe = 0;
    pc_we = 0;
    ir_oe = 0;
    ir_we = 0;

    case(state)
    INIT: next_state = FETCH;
    // TODO define FETCH here

    default: next_state = INIT;
    endcase
end

endmodule