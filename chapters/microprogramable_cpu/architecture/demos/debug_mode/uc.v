`timescale 1ns / 1ps
module uc#(
    parameter p_data_width = 16  
) (
    output reg                      o_r_alu_oe,
    output reg                      o_r_alu_carry,
    output reg [3 : 0]              o_r_alu_opcode,
    output reg                      o_r_ram_oe,
    output reg                      o_r_ram_we,
    output reg                      o_r_io_oe,
    output reg                      o_r_io_we,
    output reg [2 : 0]              o_r_regs_addr,
    output reg                      o_r_regs_oe,
    output reg                      o_r_regs_we,
    output reg                      o_r_cp_oe,
    output reg                      o_r_cp_we,
    output reg                      o_r_ind_sel,        // controls IND register input (0 = bus, 1 = alu flags)
    output reg                      o_r_ind_oe,
    output reg                      o_r_ind_we,
    output reg                      o_r_am_oe,
    output reg                      o_r_am_we,
    output reg                      o_r_aie_oe,
    output reg                      o_r_aie_we,
    output reg                      o_r_t1_oe,
    output reg                      o_r_t1_we,
    output reg                      o_r_t2_oe,
    output reg                      o_r_t2_we,
    output reg                      o_r_ri_oe,          // controls RI register output which generates the offset for Jcond instructions
    output reg                      o_r_ri_we,
    output wire [(p_data_width - 1) : 0]       o_w_state_disp_out,
    input wire                                 i_w_clk,
    input wire                                 i_w_reset,
    input wire [(p_data_width - 1) : 0]        i_w_ri,
    input wire [(p_data_width - 1) : 0]        i_w_ind
);

localparam l_p_state_width = 16;

localparam ADC  = 4'd0;
localparam SBB1 = 4'd1;
localparam SBB2 = 4'd2;
localparam NOT  = 4'd3;
localparam AND  = 4'd4;
localparam OR   = 4'd5;
localparam XOR  = 4'd6;
localparam SHL  = 4'd7;
localparam SHR  = 4'd8;
localparam SAR  = 4'd9;

localparam RA = 3'd0;
localparam RB = 3'd1;
localparam RC = 3'd2;
localparam IS = 3'd3;
localparam XA = 3'd4;
localparam XB = 3'd5;
localparam BA = 3'd6;
localparam BB = 3'd7;


wire [0:6]                      l_w_cop;
wire                            l_w_d;
wire [0:1]                      l_w_mod;
wire [0:2]                      l_w_rg;
wire [0:2]                      l_w_rm;

assign l_w_cop  = {i_w_ri[0], i_w_ri[1], i_w_ri[2], i_w_ri[3], i_w_ri[4], i_w_ri[5], i_w_ri[6]};
assign l_w_d    = {i_w_ri[7]};
assign l_w_mod  = {i_w_ri[8], i_w_ri[9]};
assign l_w_rg   = {i_w_ri[10], i_w_ri[11], i_w_ri[12]};
assign l_w_rm   = {i_w_ri[13], i_w_ri[14], i_w_ri[15]};

localparam reset            = 16'h00;            // reset state
localparam fetch            = 16'h10;            // load instruction to instruction register
localparam decode           = 16'h20;            // analyze loaded instruction
localparam addr_sum         = 16'h30;            // computes address of the form [By+Xz] with y,z in {A, B}
localparam addr_reg         = 16'h34;            // computes address of the form [yz] with y in {X, B} and z in {A, B}
localparam addr_io          = 16'h3c;            // computes address of IO port
localparam load_src_reg     = 16'h40;            // load source operand from register
localparam load_src_mem     = 16'h44;            // load source operand from memory
localparam load_src_io      = 16'h4c;            // load source operand from IO port
localparam load_dst_reg     = 16'h50;            // load destination operand from register
localparam load_dst_mem     = 16'h54;            // load destination operand from memory
localparam noload_dst_reg   = 16'h60;            // like load_dst_reg but without the loading; equals a nop
localparam noload_dst_io    = 16'h6c;            // like load_dst_io but without the loading; equals loading of aie
localparam exec_1op         = 16'h70;            // execute 1 operand instructions
localparam exec_2op         = 16'h74;            // execute 2 operand instructions
localparam exec_transf      = 16'h78;            // execute transfer instructions
localparam store_reg        = 16'h80;            // store result to register
localparam store_mem        = 16'h84;            // store result to memory
localparam store_io         = 16'h8c;            // store result to IO port
localparam inc_cp           = 16'h90;            // increment program counter

reg [(l_p_state_width - 1) : 0] l_r_state = reset, l_r_state_next;
reg [(l_p_state_width - 1) : 0] l_r_decoded_src, l_r_decoded_src_next;      // stores decoded source operand load state
reg [(l_p_state_width - 1) : 0] l_r_decoded_dst, l_r_decoded_dst_next;      // stores decoded destination operand load state
reg [(l_p_state_width - 1) : 0] l_r_decoded_exec, l_r_decoded_exec_next;    // stores decoded execute state
reg [(l_p_state_width - 1) : 0] l_r_decoded_store, l_r_decoded_store_next;  // stores decoded store state
reg l_r_decoded_d, l_r_decoded_d_next;                              // stores decoded direction bit
reg [0:2] l_r_decoded_rg, l_r_decoded_rg_next;                      // stores decoded REG operand

// FSM - sequential part
always @(posedge i_w_clk) begin
    l_r_state <= reset;

    if(!i_w_reset) begin
        l_r_state <= l_r_state_next;

        if(l_r_state == decode) begin
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
    l_r_state_next = reset;
    l_r_decoded_src_next = reset;
    l_r_decoded_dst_next = reset;
    l_r_decoded_exec_next = reset;
    l_r_decoded_store_next = reset;
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
    o_r_cp_oe = 0;
    o_r_cp_we = 0;
    o_r_ind_sel = 0;
    o_r_ind_oe = 0;
    o_r_ind_we = 0;
    o_r_am_oe = 0;
    o_r_am_we = 0;
    o_r_aie_oe = 0;
    o_r_aie_we = 0;
    o_r_t1_oe = 0;
    o_r_t1_we = 0;
    o_r_t2_oe = 0;
    o_r_t2_we = 0;
    o_r_ri_oe = 0;
    o_r_ri_we = 0;

    case(l_r_state)
        reset: begin
            l_r_state_next = fetch;
        end

        fetch: begin
            o_r_cp_oe = 1;
            o_r_am_we = 1;

            l_r_state_next = fetch + 1;
        end

        fetch + 'd1: begin
            o_r_am_oe = 1;

            l_r_state_next = fetch + 2;
        end

        fetch + 'd2: begin
            o_r_ram_oe = 1;
            o_r_ri_we = 1;

            l_r_state_next = decode;
        end

        decode: begin
            // decode location of operands and operation
            if(l_w_cop[0:3] == 4'b0001) begin           // one operand instructions
                l_r_decoded_d_next      = 0;
                l_r_decoded_rg_next     = l_w_rg;
                l_r_decoded_dst_next    = l_w_mod == 2'b11 ? load_dst_reg : load_dst_mem;
                l_r_decoded_src_next    = l_r_decoded_dst_next;
                l_r_decoded_exec_next   = exec_1op;
                l_r_decoded_store_next  = l_w_mod == 2'b11 ? store_reg : store_mem;
            end
            else if(l_w_cop[0:2] == 3'b010) begin       // two operand instructions
                l_r_decoded_d_next      = l_w_d;
                l_r_decoded_rg_next     = l_w_rg;
                l_r_decoded_dst_next    = (l_w_mod == 2'b11) || (l_w_d == 1) ? load_dst_reg : load_dst_mem;
                l_r_decoded_src_next    = (l_w_mod == 2'b11) || (l_w_d == 0) ? load_src_reg : load_src_mem;
                l_r_decoded_exec_next   = exec_2op;
                l_r_decoded_store_next  = !l_w_cop[3] ? inc_cp : ((l_w_mod == 2'b11) || (l_w_d == 1) ? store_reg : store_mem);
            end
            else if(l_w_cop[0:5] == 6'b100000) begin    // IO instructions
                l_r_decoded_d_next      = !l_w_cop[6] ? 1 : 0;
                l_r_decoded_rg_next     = RA;
                l_r_decoded_dst_next    = !l_w_cop[6] ? noload_dst_reg : noload_dst_io;
                l_r_decoded_src_next    = !l_w_cop[6] ? load_src_io : load_src_reg;
                l_r_decoded_exec_next   = exec_transf;
                l_r_decoded_store_next  = !l_w_cop[6] ? store_reg : store_io;
            end
            
            // decode address calculation mode
            if(l_w_cop[0] == 0) begin
                case(l_w_mod)
                    2'b00: begin
                        l_r_state_next = l_w_rm[0] ? addr_reg : addr_sum;
                    end
                    
                    2'b11: begin
                        l_r_state_next = l_r_decoded_src_next;
                    end
                endcase
            end
            else begin
                if(l_w_cop[0:5] == 6'b100000) begin     // IO instructions
                    l_r_state_next = addr_io;
                end
            end
        end
        
        addr_sum: begin
            o_r_regs_addr = l_w_rm[1] ? BB : BA;
            o_r_regs_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = addr_sum + 1;
        end

        addr_sum + 'd1: begin
            o_r_regs_addr = l_w_rm[2] ? XB : XA;
            o_r_regs_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = addr_sum + 2;
        end

        addr_sum + 'd2: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 1;
            o_r_alu_carry = 0;
            o_r_alu_opcode = ADC;
            o_r_alu_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        addr_reg: begin
            o_r_regs_addr = l_w_rm;
            o_r_regs_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        addr_io: begin
            o_r_ri_oe = 1;
            if(l_r_decoded_d)
                o_r_t2_we = 1;
            else
                o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_src;
        end
        
        load_src_reg: begin
            o_r_regs_addr = l_r_decoded_d ? l_w_rm : l_r_decoded_rg;
            o_r_regs_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end
        
        load_src_mem: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_am_we = 1;

            l_r_state_next = load_src_mem + 1;
        end

        load_src_mem + 'd1: begin
            o_r_am_oe = 1;

            l_r_state_next = load_src_mem + 2;
        end

        load_src_mem + 'd2: begin
            o_r_ram_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end

        load_src_io: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_aie_we = 1;

            l_r_state_next = load_src_io + 1;
        end

        load_src_io + 'd1: begin
            o_r_aie_oe = 1;
            o_r_io_oe = 1;
            o_r_t2_we = 1;

            l_r_state_next = l_r_decoded_dst;
        end
        
        load_dst_reg: begin
            o_r_regs_addr = l_r_decoded_d ? l_r_decoded_rg : l_w_rm;
            o_r_regs_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end
        
        load_dst_mem: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_am_we = 1;

            l_r_state_next = load_dst_mem + 1;
        end

        load_dst_mem + 'd1: begin
            o_r_am_oe = 1;

            l_r_state_next = load_dst_mem + 2;
        end

        load_dst_mem + 'd2: begin
            o_r_ram_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end

        noload_dst_reg: begin
            l_r_state_next = l_r_decoded_exec;
        end

        noload_dst_io: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_aie_we = 1;

            l_r_state_next = l_r_decoded_exec;
        end

        exec_1op: begin
            o_r_t1_oe = 1;
            case(l_w_cop[4:6])
                3'b000: begin                               // INC
                    o_r_alu_carry = 1;
                    o_r_alu_opcode = ADC;
                end
                3'b001: begin                               // DEC
                    o_r_alu_carry = 1;
                    o_r_alu_opcode = SBB1;
                end
                3'b010: begin                               // NEG
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = SBB2;
                end
                3'b011: begin                               // NOT
                    o_r_alu_opcode = NOT;
                end
                3'b100: o_r_alu_opcode = SHL;                  // SHL/SAL
                3'b101: o_r_alu_opcode = SHR;                  // SHR
                3'b110: o_r_alu_opcode = SAR;                  // SAR
            endcase
            o_r_alu_oe = 1;
            o_r_t1_we = 1;
            o_r_ind_sel = 1;
            o_r_ind_we = 1;

            l_r_state_next = l_r_decoded_store;
        end
        
        exec_2op: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 1;
            case(l_w_cop[4:6])
                3'b000: begin                               // ADD
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = ADC;
                end
                3'b001: begin                               // ADC
                    o_r_alu_carry = i_w_ind[0];
                    o_r_alu_opcode = ADC;
                end
                3'b010: begin                               // SUB/CMP
                    o_r_alu_carry = 0;
                    o_r_alu_opcode = SBB1;
                end
                3'b011: begin                               // SBB
                    o_r_alu_carry = i_w_ind[0];
                    o_r_alu_opcode = SBB1;
                end
                3'b100: o_r_alu_opcode = AND;                  // AND/TEST
                3'b101: o_r_alu_opcode = OR;                   // OR
                3'b110: o_r_alu_opcode = XOR;                  // XOR
            endcase
            o_r_alu_oe = 1;
            o_r_t1_we = 1;
            o_r_ind_sel = 1;
            o_r_ind_we = 1;

            l_r_state_next = l_r_decoded_store;
        end

        exec_transf: begin
            o_r_t1_oe = 0;
            o_r_t2_oe = 1;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = l_r_decoded_store;
        end
        
        store_reg: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_regs_addr = l_r_decoded_d ? l_r_decoded_rg : l_w_rm;
            o_r_regs_we = 1;

            l_r_state_next = inc_cp;
        end
        
        store_mem: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_am_oe = 1;
            o_r_ram_we = 1;

            l_r_state_next = store_mem + 1;
        end

        store_mem + 'd1: begin
            l_r_state_next = inc_cp;
        end

        store_io: begin
            o_r_t1_oe = 1;
            o_r_t2_oe = 0;
            o_r_alu_opcode = OR;
            o_r_alu_oe = 1;
            o_r_aie_oe = 1;
            o_r_io_we = 1;

            l_r_state_next = inc_cp;
        end

        inc_cp: begin
            o_r_cp_oe = 1;
            o_r_t1_we = 1;

            l_r_state_next = inc_cp + 1;
        end

        inc_cp + 'd1: begin
            o_r_t1_oe = 1;
            o_r_cp_we = 1;
            o_r_alu_oe = 1;
            o_r_alu_carry = 1;
            o_r_alu_opcode = ADC;

            l_r_state_next = fetch;
        end

        default: l_r_state_next = reset;
    endcase
end

assign o_w_state_disp_out = l_r_state;

endmodule
