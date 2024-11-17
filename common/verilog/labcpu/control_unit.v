module control_unit #(
    parameter p_data_width = 16,
    parameter p_opcode_width = 4,
    parameter p_opcode_ADC = 4'd0,
    parameter p_opcode_SBB1 = 4'd1,
    parameter p_opcode_SBB2 = 4'd2,
    parameter p_opcode_NOT = 4'd3,
    parameter p_opcode_AND = 4'd4,
    parameter p_opcode_OR = 4'd5,
    parameter p_opcode_XOR = 4'd6,
    parameter p_opcode_SHL = 4'd7,
    parameter p_opcode_SHR = 4'd8,
    parameter p_opcode_SAR = 4'd9,
    parameter p_regs_address_width = 3,
    parameter p_RA_address = 3'd0,
    parameter p_RB_address = 3'd1,
    parameter p_RC_address = 3'd2,
    parameter p_SP_address = 3'd3,
    parameter p_XA_address = 3'd4,
    parameter p_XB_address = 3'd5,
    parameter p_BA_address = 3'd6,
    parameter p_BB_address = 3'd7
) (
    `ifdef DEBUG
    output wire [(p_data_width - 1) : 0]       o_w_state_disp_out,
    `endif
    output reg                                 o_r_alu_oe,
    output reg                                 o_r_alu_carry,
    output reg [(p_opcode_width-1) : 0]        o_r_alu_opcode,
    output reg                                 o_r_ram_oe,
    output reg                                 o_r_ram_we,
    output reg                                 o_r_io_oe,
    output reg                                 o_r_io_we,
    output reg [(p_regs_address_width-1) : 0]  o_r_regs_addr,
    output reg                                 o_r_regs_oe,
    output reg                                 o_r_regs_we,
    output reg                                 o_r_pc_oe,
    output reg                                 o_r_pc_we,
    output reg                                 o_r_flags_sel,        // controls FR register input (0 = bus, 1 = alu flags)
    output reg                                 o_r_flags_oe,
    output reg                                 o_r_flags_we,
    output reg                                 o_r_ma_oe,
    output reg                                 o_r_ma_we,
    output reg                                 o_r_ioa_oe,
    output reg                                 o_r_ioa_we,
    output reg                                 o_r_t1_oe,
    output reg                                 o_r_t1_we,
    output reg                                 o_r_t2_oe,
    output reg                                 o_r_t2_we,
    output reg                                 o_r_ir_oe,          // controls IR register output which generates the offset for Jcond instructions
    output reg                                 o_r_ir_we,
    input wire                                 i_w_clk,
    input wire                                 i_w_reset,
    input wire [(p_data_width - 1) : 0]        i_w_ir,
    input wire [(p_data_width - 1) : 0]        i_w_flags
);

localparam l_p_state_width = 16;


wire [0:6]                      l_w_cop;
wire                            l_w_d;
wire [0:1]                      l_w_mod;
wire [0:2]                      l_w_rg;
wire [0:2]                      l_w_rm;

// l_p_state_DECODE instruction
// oeration code
assign l_w_cop  = {i_w_ir[0], i_w_ir[1], i_w_ir[2], i_w_ir[3], i_w_ir[4], i_w_ir[5], i_w_ir[6]};
// direction bit
assign l_w_d    = {i_w_ir[7]};
// addressing mode
assign l_w_mod  = {i_w_ir[8], i_w_ir[9]};
// register
assign l_w_rg   = {i_w_ir[10], i_w_ir[11], i_w_ir[12]};
// register/memory
assign l_w_rm   = {i_w_ir[13], i_w_ir[14], i_w_ir[15]};

localparam l_p_state_RESET            = 16'h00;            // l_p_state_RESET state
localparam l_p_state_FETCH            = 16'h10;            // load instruction to instruction register
localparam l_p_state_DECODE           = 16'h20;            // analyze loaded instruction
localparam l_p_state_ADDR_SUM         = 16'h30;            // computes address of the form [By+Xz] with y,z in {A, B}
localparam l_p_state_ADDR_REG         = 16'h34;            // computes address of the form [yz] with y in {X, B} and z in {A, B}
localparam l_p_state_ADDR_IO          = 16'h3c;            // computes address of IO port
localparam l_p_state_LOAD_SRC_REG     = 16'h40;            // load source operand from register
localparam l_p_state_LOAD_SRC_MEM     = 16'h44;            // load source operand from memory
localparam l_p_state_LOAD_SRC_IO      = 16'h4c;            // load source operand from IO port
localparam l_p_state_LOAD_DST_REG     = 16'h50;            // load destination operand from register
localparam l_p_state_LOAD_DST_MEM     = 16'h54;            // load destination operand from memory
localparam l_p_state_NO_LOAD_DST_REG   = 16'h60;            // like l_p_state_LOAD_DST_REG but without the loading; equals a nop
localparam l_p_state_NO_LOAD_DST_IO    = 16'h6c;            // like load_dst_io but without the loading; equals loading of aie
localparam l_p_state_EXEC_ONE_OP         = 16'h70;            // execute 1 operand instructions
localparam l_p_state_EXEC_TWO_OP         = 16'h74;            // execute 2 operand instructions
localparam l_p_state_EXEC_TRANSFER      = 16'h78;            // execute transfer instructions
localparam l_p_state_STORE_REG        = 16'h80;            // store result to register
localparam l_p_state_STORE_MEM        = 16'h84;            // store result to memory
localparam l_p_state_STORE_IO         = 16'h8c;            // store result to IO port
localparam l_p_state_INC_PC           = 16'h90;            // increment program counter

reg [(l_p_state_width - 1) : 0] l_r_state = l_p_state_RESET, l_r_state_next;
reg [(l_p_state_width - 1) : 0] l_r_decoded_src, l_r_decoded_src_next;      // stores decoded source operand load state
reg [(l_p_state_width - 1) : 0] l_r_decoded_dst, l_r_decoded_dst_next;      // stores decoded destination operand load state
reg [(l_p_state_width - 1) : 0] l_r_decoded_exec, l_r_decoded_exec_next;    // stores decoded execute state
reg [(l_p_state_width - 1) : 0] l_r_decoded_store, l_r_decoded_store_next;  // stores decoded store state
reg l_r_decoded_d, l_r_decoded_d_next;                              // stores decoded direction bit
reg [0:2] l_r_decoded_rg, l_r_decoded_rg_next;                      // stores decoded REG operand

// FSM - sequential part 
always @(posedge i_w_clk or negedge i_w_reset) begin
    if (!i_w_reset) begin
        l_r_state <= l_p_state_RESET;
    end else begin
        l_r_state <= l_r_state_next;
        if(l_r_state == l_p_state_DECODE) begin
            l_r_decoded_src <= l_r_decoded_src_next;
            l_r_decoded_dst <= l_r_decoded_dst_next;
            l_r_decoded_exec <= l_r_decoded_exec_next;
            l_r_decoded_store <= l_r_decoded_store_next;
            l_r_decoded_d <= l_r_decoded_d_next;
            l_r_decoded_rg <= l_r_decoded_rg_next;
        end
    end
end

// FSM - combinational part
always @(*) begin
    l_r_state_next = l_p_state_RESET;
    l_r_decoded_src_next = l_p_state_RESET;
    l_r_decoded_dst_next = l_p_state_RESET;
    l_r_decoded_exec_next = l_p_state_RESET;
    l_r_decoded_store_next = l_p_state_RESET;
    l_r_decoded_d_next = 0;
    l_r_decoded_rg_next = 0;
    o_r_alu_oe = 0;
    o_r_alu_carry = 0;
    o_r_alu_opcode = 0;
    o_r_ram_oe = 0;
    o_r_ram_we = 0;
    o_r_io_oe = 0;
    o_r_io_we = 0;
    o_r_regs_addr = 0;
    o_r_regs_oe = 0;
    o_r_regs_we = 0;
    o_r_pc_oe = 0;
    o_r_pc_we = 0;
    o_r_flags_sel = 0;
    o_r_flags_oe = 0;
    o_r_flags_we = 0;
    o_r_ma_oe = 0;
    o_r_ma_we = 0;
    o_r_ioa_oe = 0;
    o_r_ioa_we = 0;
    o_r_t1_oe = 0;
    o_r_t1_we = 0;
    o_r_t2_oe = 0;
    o_r_t2_we = 0;
    o_r_ir_oe = 0;
    o_r_ir_we = 0;

    case(l_r_state)
        l_p_state_RESET: begin
            l_r_state_next = l_p_state_FETCH;
        end

        l_p_state_FETCH: begin
            o_r_pc_oe = 1;
            o_r_ma_we = 1;

            l_r_state_next = l_p_state_FETCH + 1;
        end

        l_p_state_FETCH + 'd1: begin
            o_r_ma_oe = 1;

            l_r_state_next = l_p_state_FETCH + 2;
        end

        // TODO: Test if this is correct
        // different cycles the memory address is l_p_state_RESET to 0
        l_p_state_FETCH + 'd2: begin
            o_r_ram_oe = 1;
            o_r_ir_we = 1;

            l_r_state_next = l_p_state_DECODE;
        end

        l_p_state_DECODE: begin
            // l_p_state_DECODE location of operands and operation
            if(l_w_cop[0:3] == 4'b0001) begin           // one operand instructions
                l_r_decoded_d_next      = 0;
                l_r_decoded_rg_next     = l_w_rg;
                l_r_decoded_dst_next    = l_w_mod == 2'b11 ? l_p_state_LOAD_DST_REG : l_p_state_LOAD_DST_MEM;
                l_r_decoded_src_next    = l_r_decoded_dst_next;
                l_r_decoded_exec_next   = l_p_state_EXEC_ONE_OP;
                l_r_decoded_store_next  = l_w_mod == 2'b11 ? l_p_state_STORE_REG : l_p_state_STORE_MEM;
            end
            else if(l_w_cop[0:2] == 3'b010) begin       // two operand instructions
                l_r_decoded_d_next      = l_w_d;
                l_r_decoded_rg_next     = l_w_rg;
                l_r_decoded_dst_next    = (l_w_mod == 2'b11) || (l_w_d == 1) ? l_p_state_LOAD_DST_REG : l_p_state_LOAD_DST_MEM;
                l_r_decoded_src_next    = (l_w_mod == 2'b11) || (l_w_d == 0) ? l_p_state_LOAD_SRC_REG : l_p_state_LOAD_SRC_MEM;
                l_r_decoded_exec_next   = l_p_state_EXEC_TWO_OP;
                l_r_decoded_store_next  = !l_w_cop[3] ? l_p_state_INC_PC : ((l_w_mod == 2'b11) || (l_w_d == 1) ? l_p_state_STORE_REG : l_p_state_STORE_MEM);
            end
            else if(l_w_cop[0:5] == 6'b100000) begin    // IO instructions
                l_r_decoded_d_next      = !l_w_cop[6] ? 1 : 0;
                l_r_decoded_rg_next     = p_RA_address;
                l_r_decoded_dst_next    = !l_w_cop[6] ? l_p_state_NO_LOAD_DST_REG : l_p_state_NO_LOAD_DST_IO;
                l_r_decoded_src_next    = !l_w_cop[6] ? l_p_state_LOAD_SRC_IO : l_p_state_LOAD_SRC_REG;
                l_r_decoded_exec_next   = l_p_state_EXEC_TRANSFER;
                l_r_decoded_store_next  = !l_w_cop[6] ? l_p_state_STORE_REG : l_p_state_STORE_IO;
            end
            
            // l_p_state_DECODE address calculation mode
            if(l_w_cop[0] == 0) begin
                case(l_w_mod)
                    2'b00: begin
                        l_r_state_next = l_w_rm[0] ? l_p_state_ADDR_REG : l_p_state_ADDR_SUM;
                    end
                    
                    2'b11: begin
                        l_r_state_next = l_r_decoded_src_next;
                    end
                endcase
            end
            else begin
                if(l_w_cop[0:5] == 6'b100000) begin     // IO instructions
                    l_r_state_next = l_p_state_ADDR_IO;
                end
            end
        end
        
        l_p_state_ADDR_SUM: begin
            o_r_regs_addr = l_w_rm[1] ? p_BB_address : p_BA_address;
            o_r_regs_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_p_state_ADDR_SUM + 1;
        end

        l_p_state_ADDR_SUM + 'd1: begin
            o_r_regs_addr = l_w_rm[2] ? p_XB_address : p_XA_address;
            o_r_regs_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_p_state_ADDR_SUM + 2;
        end

        l_p_state_ADDR_SUM + 'd2: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 1;
            o_r_alu_carry = 0;
            o_r_alu_opcode = p_opcode_ADC;
            o_r_alu_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        l_p_state_ADDR_REG: begin
            o_r_regs_addr = l_w_rm;
            o_r_regs_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        l_p_state_ADDR_IO: begin
            o_r_ir_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        l_p_state_LOAD_SRC_REG: begin
            o_r_regs_addr = l_r_decoded_d ? l_w_rm : l_r_decoded_rg;
            o_r_regs_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end
        
        l_p_state_LOAD_SRC_MEM: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ma_we = 1;

            l_r_state_next = l_p_state_LOAD_SRC_MEM + 1;
        end

        l_p_state_LOAD_SRC_MEM + 'd1: begin
            o_r_ma_oe = 1;

            l_r_state_next = l_p_state_LOAD_SRC_MEM + 2;
        end

        l_p_state_LOAD_SRC_MEM + 'd2: begin
            o_r_ram_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end

        l_p_state_LOAD_SRC_IO: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ioa_we = 1;

            l_r_state_next = l_p_state_LOAD_SRC_IO + 1;
        end

        l_p_state_LOAD_SRC_IO + 'd1: begin
            o_r_ioa_oe = 1;
            o_r_io_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end
        
        l_p_state_LOAD_DST_REG: begin
            o_r_regs_addr = l_r_decoded_d ? l_r_decoded_rg : l_w_rm;
            o_r_regs_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end
        
        l_p_state_LOAD_DST_MEM: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ma_we = 1;

            l_r_state_next = l_p_state_LOAD_DST_MEM + 1;
        end

        l_p_state_LOAD_DST_MEM + 'd1: begin
            o_r_ma_oe = 1;

            l_r_state_next = l_p_state_LOAD_DST_MEM + 2;
        end

        l_p_state_LOAD_DST_MEM + 'd2: begin
            o_r_ram_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end

        l_p_state_NO_LOAD_DST_REG: begin
            l_r_state_next = l_r_decoded_exec;
        end

        l_p_state_NO_LOAD_DST_IO: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ioa_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end

        l_p_state_EXEC_ONE_OP: begin
            o_r_t1_oe = 1;
            case(l_w_cop[4:6])
                3'b000: begin                               // INC
                    o_r_alu_carry = 1;
                    o_r_alu_opcode = p_opcode_ADC;
                end
                3'b001: begin                               // DEC
                    o_r_alu_carry = 1;
                    o_r_alu_opcode = p_opcode_SBB1;
                end
                3'b010: begin                               // NEG
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = p_opcode_SBB2;
                end
                3'b011: begin                               // NOT
                    o_r_alu_opcode = p_opcode_NOT;
                end
                3'b100: o_r_alu_opcode = p_opcode_SHL;                  // SHL/SAL
                3'b101: o_r_alu_opcode = p_opcode_SHR;                  // SHR
                3'b110: o_r_alu_opcode = p_opcode_SAR;                  // SAR
            endcase
            o_r_alu_oe = 1;
            o_r_t1_we = 1;
            o_r_flags_sel = 1;
            o_r_flags_we = 1;

            l_r_state_next = l_r_decoded_store;
        end
        
        l_p_state_EXEC_TWO_OP: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 1;
            case(l_w_cop[4:6])
                3'b000: begin                               // ADD
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = p_opcode_ADC;
                end
                3'b001: begin                               // ADC
                    o_r_alu_carry = i_w_flags[0];
                    o_r_alu_opcode = p_opcode_ADC;
                end
                3'b010: begin                               // SUB/CMP
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = p_opcode_SBB1;
                end
                3'b011: begin                               // SBB
                    o_r_alu_carry = i_w_flags[0];
                    o_r_alu_opcode = p_opcode_SBB1;
                end
                3'b100: o_r_alu_opcode = p_opcode_AND;         // AND/TEST
                3'b101: o_r_alu_opcode = p_opcode_OR;          // OR
                3'b110: o_r_alu_opcode = p_opcode_XOR;         // XOR
            endcase
            o_r_alu_oe = 1;
            o_r_t1_we = 1;
            o_r_flags_sel = 1;
            o_r_flags_we = 1;

            l_r_state_next = l_r_decoded_store;
        end

        l_p_state_EXEC_TRANSFER: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_store;
        end
        
        l_p_state_STORE_REG: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_regs_addr = l_r_decoded_d ? l_r_decoded_rg : l_w_rm;
            o_r_regs_we = 1;

            l_r_state_next = l_p_state_INC_PC;
        end
        
        l_p_state_STORE_MEM: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ma_oe = 1;
            o_r_ram_we = 1;

            l_r_state_next = l_p_state_STORE_MEM + 1;
        end

        l_p_state_STORE_MEM + 'd1: begin
            l_r_state_next = l_p_state_INC_PC;
        end

        l_p_state_STORE_IO: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = p_opcode_OR;
            o_r_alu_oe = 1;
            o_r_ioa_oe = 1;
            o_r_io_we = 1;

            l_r_state_next = l_p_state_INC_PC;
        end

        l_p_state_INC_PC: begin
            o_r_pc_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_p_state_INC_PC + 1;
        end

        l_p_state_INC_PC + 'd1: begin
            o_r_t1_oe = 1;
            o_r_pc_we = 1;
            o_r_alu_oe = 1;
            o_r_alu_carry = 1;
            o_r_alu_opcode = p_opcode_ADC;

            l_r_state_next = l_p_state_FETCH;
        end

        default: l_r_state_next = l_p_state_RESET;
    endcase
end

assign o_w_state_disp_out = l_r_state;

endmodule
