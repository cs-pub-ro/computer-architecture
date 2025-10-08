module control_unit_sol(
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
localparam DECODE = 5;


reg [7:0] state, next_state;

always @(posedge clk) begin
    if (!rst) state <= INIT;
    else state <= next_state;
end


always @(*) begin
    next_state = state+1;
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
    FETCH: begin
        pc_oe = 1;
        ma_we = 1;
    end
    FETCH + 1: begin
        ma_oe = 1;
    end
    FETCH + 2: begin
        ram_oe = 1;
        ir_we = 1;
        next_state = DECODE;
    end
    DECODE: begin
        ir_oe = 1;
        opc = {ir[`IR6], ir[`IR5], ir[`IR4], ir[`IR3], ir[`IR2], ir[`IR1], ir[`IR0]};
        d = ir[`IR7];
        mod = {ir[`IR9], ir[`IR8]};
        rg = {ir[`IR12], ir[`IR11], ir[`IR10]};
        rm = {ir[`IR15], ir[`IR14], ir[`IR13]};
        next_state = DECODE;
    end

    default: next_state = INIT;
    endcase
end

endmodule