module control_unit_sol(
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

localparam INIT = 0;
localparam LOAD_DONE = 1;
localparam EXEC_DONE = 2;
localparam STORE_DONE = 3;
localparam LOAD = 4;
localparam EXEC = 30;
localparam PUSH = 31;
localparam CALL = 33;
localparam POP = 35;
localparam STORE = 50;

// Define further states here (if wanted)

assign load_done = state == LOAD_DONE;
assign exec_done = state == EXEC_DONE;
assign store_done = state == STORE_DONE;

reg [7:0] state, next_state;

always @(posedge clk) begin
    if (!rst) state <= INIT;
    else
        state <= next_state;
end

localparam SP = 3'b011;
localparam XA = 3'b100;
localparam XB = 3'b101;
localparam BA = 3'b110;
localparam BB = 3'b111;

localparam ADC = 4'b0000;
localparam SBB1 = 4'b0001;
localparam SBB2 = 4'b0010;
localparam NOT = 4'b0011;
localparam AND = 4'b0100;
localparam OR = 4'b0101;
localparam XOR = 4'b0110;
localparam SHL = 4'b0111;
localparam SHR = 4'b1000;
localparam SAR = 4'b1001;


localparam FLAG_C = 0;



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
    next_state = state + 1;
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
    EXEC_DONE: begin
        if ((opc[0:3] == 4'b0100)||(opc[0:3] == 4'b0000 && opc[4:6])) next_state = STORE_DONE;
        else next_state = STORE;
    end
    STORE_DONE: next_state = STORE_DONE;
    // TODO define LOAD, EXEC, STORE here
    LOAD: begin
        t1_we = 1;
        regs_addr = rm[1] ? XB : XA;
        regs_oe = 1;
    end
    LOAD + 1: begin
        t2_we = 1;
        regs_addr = rm[0] ? BB : BA;
        regs_oe = 1;
    end
    LOAD + 2: begin
        alu_opcode = ADC;
        alu_oe = 1;
        t1_oe = 1;
        t2_oe = 1;
        t1_we = 1;

    end
    LOAD + 3: begin
        pc_oe = 1;
        t2_we = 1;
    end
    LOAD + 4: begin
        alu_opcode = ADC;
        alu_oe = 1;
        t2_oe = 1;
        pc_we = 1;
        alu_carry = 1;
        ma_we = 1;
    end
    LOAD + 5: begin
        ma_oe = 1;
    end
    LOAD + 6: begin
        ram_oe = 1;
        t2_we = 1;
    end
    LOAD + 7: begin
        alu_opcode = ADC;
        alu_oe = 1;
        t1_oe = 1;
        t2_oe = 1;
        ma_we = 1;
    end
    LOAD + 8: begin
        ma_oe = 1;
    end
    LOAD + 9: begin
        ram_oe = 1;
        if (d) t2_we = 1;
        else t1_we = 1;
        if (!opc[1]) next_state = LOAD_DONE;
    end
    LOAD + 10: begin
        regs_oe = 1;
        regs_addr = rg;
        if (d == 0) t2_we = 1;
        else t1_we = 1;
        next_state = LOAD_DONE;
    end
    EXEC: begin

        if (opc[1]) begin
            alu_oe = opc[3];
            casex (opc[4:6])
                3'b00x: alu_opcode = ADC;
                3'b01x: alu_opcode = SBB1;
                3'b100: alu_opcode = AND;
                3'b101: alu_opcode = OR;
                3'b110: alu_opcode = XOR;
                default: alu_opcode = 1'bx;
            endcase
            flags_we = 1;
            t1_oe = 1;
            t2_oe = 1;
            alu_carry = (opc[4:6] == 3'b001 || opc[4:6] == 3'b011) ?
                    flags[FLAG_C] : 0;
            t1_we = opc[3];
            next_state = EXEC_DONE;
        end else begin

            if(opc[3]) begin
                casex (opc[4:6])
                    3'b000: alu_opcode = ADC;
                    3'b001: alu_opcode = SBB1;
                    3'b010: alu_opcode = SBB2;
                    3'b011: alu_opcode = NOT;
                    3'b100: alu_opcode = SHL;
                    3'b101: alu_opcode = SHR;
                    3'b110: alu_opcode = SAR;
                    default: alu_opcode = 1'bx;
                endcase
                alu_carry = opc[4:6] == 3'b000 || opc[4:6] == 3'b001;
                flags_we = 1;
                alu_oe = 1;
                t1_oe = 1;
                t1_we = 1;
                next_state = EXEC_DONE;

            end else begin
                case (opc[4:6])
                    3'b000: next_state = EXEC_DONE;
                    3'b010, 3'b100: begin
                        regs_addr = SP;
                        regs_oe = 1;
                        t2_we = 1;
                        next_state = PUSH;
                    end
                    3'b101: begin
                        pc_we = 1;
                        t1_oe = 1;
                        alu_opcode = OR;
                        alu_oe = 1;
                        next_state = EXEC_DONE;
                    end
                endcase
            end
        end
        
    end
    PUSH: begin
        t2_oe = 1;
        alu_opcode = SBB2;
        alu_carry = 1;
        alu_oe = 1;
        regs_we = 1;
        regs_addr = SP;
        ma_we = 1;
    end
    PUSH + 1: begin
        if (opc[4:6] == 3'b100) begin
            pc_oe = 1;
            t2_we = 1;
            next_state = CALL;
        end
        else begin
            ram_we = 1;
            ma_oe = 1;
            t1_oe = 1;
            alu_opcode = OR;
            alu_oe = 1;
            next_state = EXEC_DONE;
        end
    end
    // MEM[SP-1] = PC + 1
    CALL: begin
        ram_we = 1;
        ma_oe = 1;
        alu_opcode = ADC;
        alu_carry = 1;
        alu_oe = 1;
        t2_oe = 1;
    end
    CALL + 1: begin
        t1_oe = 1;
        alu_opcode = OR;
        alu_oe = 1;
        pc_we = 1;
        next_state = EXEC_DONE;
    end
    // POP: begin
    //     ma_we = 1;
    //     t2_oe = 1;

    //     alu_opcode = OR;
    //     alu_oe = 1;
    // end
    // POP + 1: begin
    //     ma_oe = 1;
    //     ram_we = 1;
    //     t1_oe = 1;

    //     alu_opcode = OR;
    //     alu_oe = 1;
    // end
    // POP + 2: begin
    //     t2_oe = 1;
    //     alu_opcode = ADC;
    //     alu_carry = 1;
    //     alu_oe = 1;

    //     regs_addr = SP;
    //     regs_we = 1;
    //     next_state = EXEC_DONE;
    // end
    STORE: begin
        alu_opcode = OR;
        alu_oe = 1;
        t1_oe = 1;
        if (d) begin
            regs_addr = rg;
            regs_we = 1;
        end else begin
            ma_oe = 1;
            ram_we = 1;
        end
        next_state = STORE_DONE;
    end
    default: next_state = INIT;
    endcase
end

endmodule