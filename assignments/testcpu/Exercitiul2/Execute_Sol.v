`timescale 1ns / 1ps

module Execute_Sol #(
    parameter p_data_width = 16
)(
    output [p_data_width-1:0] out_t1, // ALU output
    input [p_data_width-1:0] i_ir,    // RI code
    input [p_data_width-1:0] i_t1,    // T1 value
    input [p_data_width-1:0] i_t2,    // T2 value
    input i_w_clk,                    // Clock
    input i_w_reset,                  // Reset
    input i_w_carry                   // Carry
);

    localparam ADC  = 4'd0;
    localparam AND  = 4'd1;
    localparam OR   = 4'd2;
    localparam SHL  = 4'd3;
    localparam SHR  = 4'd4;
    localparam SAR  = 4'd5;

    wire l_w_t1_we, l_w_t1_oe;
    wire [p_data_width-1:0] l_w_t1_out;

    register #(.p_data_width(p_data_width)) instanta_t1 (
        .o_w_out(l_w_t1_out),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_in(i_t1),
        .i_w_we(l_w_t1_we),
        .i_w_oe(l_w_t1_oe)
    );

    wire l_w_t2_we, l_w_t2_oe;
    wire [p_data_width-1:0] l_w_t2_out;

    register #(.p_data_width(p_data_width)) instanta_t2 (
        .o_w_out(l_w_t2_out),
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_in(i_t2),
        .i_w_we(l_w_t2_we),
        .i_w_oe(l_w_t2_oe)
    );

    wire [3:0] l_w_opcode;
    wire l_w_alu_oe;

    ALU #(.p_data_width(p_data_width),
          .p_opcode_width(4),    
          .p_opcode_ADC(4'd0),   
          .p_opcode_AND(4'd1),   
          .p_opcode_OR(4'd2),    
          .p_opcode_SHL(4'd3),   
          .p_opcode_SHR(4'd4),   
          .p_opcode_SAR(4'd5)) alu (
                .o_w_out(out_t1),
                .i_w_in1(l_w_t1_out),
                .i_w_in2(l_w_t2_out),
                .i_w_opcode(l_w_opcode),
                .i_w_carry(i_w_carry),
                .i_w_oe(l_w_alu_oe)
    );

    localparam STATE_INITIAL = 3'd0;
    localparam STATE_T1_WRITE = 3'd1;
    localparam STATE_T2_WRITE = 3'd2;
    localparam STATE_T_STORE = 3'd3;
    localparam STATE_ALU_EXEC = 3'd4;

    reg [2:0] l_r_state, l_r_next_state;

    always @(posedge i_w_clk or negedge i_w_reset) begin
        if (!i_w_reset) begin
            l_r_state <= STATE_INITIAL;
        end else begin
            l_r_state <= l_r_next_state;
        end
    end

    reg l_r_t1_we, l_r_t1_oe;
    reg l_r_t2_we, l_r_t2_oe;
    reg [3:0] l_r_opcode;
    reg l_r_alu_oe;

    always @(*) begin
        
        l_r_t1_we = 0;
        l_r_t1_oe = 0;
        l_r_t2_we = 0;
        l_r_t2_oe = 0;
        l_r_opcode = 4'd0;
        l_r_alu_oe = 0; 
        
        case (l_r_state)
            
            STATE_INITIAL: begin
                l_r_t1_oe = 0;
                l_r_t2_oe = 0;
                l_r_next_state = STATE_T1_WRITE;
            end
            
            STATE_T1_WRITE: begin
                l_r_t1_we = 1; 
                if (i_ir[1]) begin 
                        l_r_next_state = STATE_T2_WRITE;
                    end
                else begin
                    l_r_next_state = STATE_T_STORE;
                end
            end 
           
            STATE_T2_WRITE: begin
                l_r_t2_we = 1;
                l_r_next_state = STATE_T_STORE;
            end
            
            STATE_T_STORE: begin
                l_r_t1_we = 0;
                l_r_t2_we = 0;
                l_r_next_state = STATE_ALU_EXEC;
            end

            STATE_ALU_EXEC: begin
                l_r_t1_oe = 1;
                l_r_t2_oe = i_ir[1]; 
                case (i_ir[6:4])
                    3'b100: l_r_opcode = ADC;
                    3'b001: l_r_opcode = (i_ir[1]) ? AND : SHL;
                    3'b101: l_r_opcode = (i_ir[1]) ? OR : SHR;
                    3'b011: l_r_opcode = SAR;
                    default: l_r_opcode = 4'd0;
                endcase
                l_r_alu_oe = 1; 
                l_r_next_state = STATE_ALU_EXEC;
            end
            
            default: l_r_next_state = STATE_INITIAL;
        endcase
    end

    assign l_w_t1_we = l_r_t1_we;
    assign l_w_t1_oe = l_r_t1_oe;
    assign l_w_t2_we = l_r_t2_we;
    assign l_w_t2_oe = l_r_t2_oe;
    assign l_w_opcode = l_r_opcode;
    assign l_w_alu_oe = l_r_alu_oe;

endmodule
