module state_display #(
    parameter p_data_width = 16,
    parameter p_address_width = 10,
    parameter p_regs_address_width = 3
) (
    output wire [7:0] o_w_7_led_seg,
    output wire [7:0] o_w_an,
    input wire [p_regs_address_width:0] i_w_regs_addr,
    input wire [(p_data_width-1):0] i_w_regs,
    input wire [(p_data_width-1):0] i_w_ram,
    input wire [(p_data_width-1):0] i_w_state,
    input wire [(p_data_width-1):0] i_w_bus,
    input wire i_w_next,
    input wire i_w_prev,
    input wire i_w_clk,
    input wire i_w_reset
);

    localparam reset            = 16'h00;
    localparam fetch            = 16'h10;
    localparam decode           = 16'h20; 
    localparam addr_sum         = 16'h30;
    localparam addr_reg         = 16'h34;
    localparam addr_io          = 16'h3c;
    localparam load_src_reg     = 16'h40;
    localparam load_src_mem     = 16'h44;
    localparam load_src_io      = 16'h4c;
    localparam load_dst_reg     = 16'h50;
    localparam load_dst_mem     = 16'h54;
    localparam noload_dst_reg   = 16'h60;
    localparam noload_dst_io    = 16'h6c;
    localparam exec_1op         = 16'h70;
    localparam exec_2op         = 16'h74;
    localparam exec_transf      = 16'h78;
    localparam store_reg        = 16'h80; 
    localparam store_mem        = 16'h84;            
    localparam store_io         = 16'h8c;
    localparam inc_cp           = 16'h90;



    localparam l_p_RA_address = 4'h0;
    localparam l_p_RB_address = 4'h1;
    localparam l_p_RC_address = 4'h2;
    localparam l_p_SP_address = 4'h3;
    localparam l_p_XA_address = 4'h4;
    localparam l_p_XB_address = 4'h5;
    localparam l_p_BA_address = 4'h6;
    localparam l_p_BB_address = 4'h7;
    localparam l_p_PC_address = 4'h8;
    localparam l_p_FR_address = 4'h9;
    localparam l_p_MA_address = 4'ha;
    localparam l_p_IOA_address = 4'hb;
    localparam l_p_T1_address = 4'hc;
    localparam l_p_T2_address = 4'hd;
    localparam l_p_IR_address = 4'he;



    // Registers state
    localparam l_p_state_REGS = 2'd0;
    // RAM state
    localparam l_p_state_RAM = 2'd1;
    // BUS state
    localparam l_p_state_BUS = 2'd2;
    // Control Unit FSM state
    localparam l_p_state_FSM = 2'd3;

    reg [1:0] l_r_state; // current state
    reg [1:0] l_r_next_state; // next state
    reg [2:0] l_r_digit; // current digit to display

    // FSM - sequential logic
    always @(posedge i_w_clk or negedge i_w_reset) begin
        if (!i_w_reset) begin
            l_r_state <= l_p_state_REGS;
            l_r_digit <= 0;
        end else begin
            l_r_digit <= l_r_digit + 1;
            l_r_state <= l_r_next_state;
        end
    end

    // FSM - combinational logic compute next state
    always @(*) begin
        if (i_w_next) begin
            l_r_next_state = l_r_state + 1;
        end else if (i_w_prev) begin
            l_r_next_state = l_r_state - 1;
        end else begin
            l_r_next_state = l_r_state;
        end
    end

    reg [7:0] l_r_digit_7seg [7:0];
    reg [3:0] l_r_in [3:0];
    reg [3:0] index;
    // FSM - output logic

    // first compute only the most significant digits from the state
    always @(*) begin
        l_r_digit_7seg[4] = 8'b1111_1111;
        l_r_digit_7seg[5] = 8'b1111_1111;
        l_r_digit_7seg[6] = 8'b1111_1111;
        l_r_digit_7seg[7] = 8'b1111_1111;
        l_r_in[0] = 4'b0000;
        l_r_in[1] = 4'b0000;
        l_r_in[2] = 4'b0000;
        l_r_in[3] = 4'b0000;
        
        case(l_r_state)
            l_p_state_REGS: begin
                l_r_in[0] = i_w_regs[3:0];
                l_r_in[1] = i_w_regs[7:4];
                l_r_in[2] = i_w_regs[11:8];
                l_r_in[3] = i_w_regs[15:12];     

                l_r_digit_7seg[7] = 8'b1010_1111;    // r

                // which register to display
                case (i_w_regs_addr)
                    l_p_RA_address: begin
                        l_r_digit_7seg[5] = 8'b1000_1000;    // A
                        l_r_digit_7seg[6] = 8'b1010_1111;    // r
                    end

                    l_p_RB_address: begin
                        l_r_digit_7seg[5] = 8'b1000_0011;    // b
                        l_r_digit_7seg[6] = 8'b1010_1111;    // r
                    end

                    l_p_RC_address: begin
                        l_r_digit_7seg[5] = 8'b1100_0110;    // C
                        l_r_digit_7seg[6] = 8'b1010_1111;    // r
                    end

                    l_p_SP_address: begin
                        l_r_digit_7seg[5] = 8'b1000_1100;    // P
                        l_r_digit_7seg[6] = 8'b1001_0010;    // S
                    end

                    l_p_XA_address: begin
                        l_r_digit_7seg[4] = 8'b1000_1000;    // A
                        l_r_digit_7seg[5] = 8'b1100_0110;    // right half X
                        l_r_digit_7seg[6] = 8'b1111_0000;    // left half X
                    end

                    l_p_XB_address: begin
                        l_r_digit_7seg[4] = 8'b1000_0011;    // b
                        l_r_digit_7seg[5] = 8'b1100_0110;    // right half X
                        l_r_digit_7seg[6] = 8'b1111_0000;    // left half X
                    end

                    l_p_BA_address: begin
                        l_r_digit_7seg[5] = 8'b1000_1000;    // A
                        l_r_digit_7seg[6] = 8'b1000_0011;    // b
                    end

                    l_p_BB_address: begin
                        l_r_digit_7seg[5] = 8'b1000_0011;    // b
                        l_r_digit_7seg[6] = 8'b1000_0011;    // b
                    end

                    l_p_PC_address: begin
                        l_r_digit_7seg[5] = 8'b1000_1100;    // P
                        l_r_digit_7seg[6] = 8'b1100_0110;    // C
                    end

                    l_p_FR_address: begin
                        l_r_digit_7seg[5] = 8'b1010_1111;    // r
                        l_r_digit_7seg[6] = 8'b1000_1110;    // F
                    end

                    l_p_MA_address: begin
                        l_r_digit_7seg[4] = 8'b1000_1000;    // A
                        l_r_digit_7seg[5] = 8'b1101_1000;    // right half M
                        l_r_digit_7seg[6] = 8'b1100_1100;    // left half M
                    end

                    l_p_IOA_address: begin
                        l_r_digit_7seg[5] =  8'b1100_0000;   // O
                        l_r_digit_7seg[6] = 8'b1111_1001;    // I
                    end

                    l_p_T1_address: begin
                        l_r_digit_7seg[4] = 8'b1111_1001;    // 1
                        l_r_digit_7seg[5] = 8'b1100_1110;    // right half T
                        l_r_digit_7seg[6] = 8'b1111_1000;    // left half T
                    end

                    l_p_T2_address: begin
                        l_r_digit_7seg[4] = 8'b1010_0100;    // 2
                        l_r_digit_7seg[5] = 8'b1100_1110;    // right half T
                        l_r_digit_7seg[6] = 8'b1111_1000;    // left half T
                    end

                    l_p_IR_address: begin
                        l_r_digit_7seg[5] = 8'b1010_1111;    // r
                        l_r_digit_7seg[6] = 8'b1111_1001;    // I
                    end
                endcase
            end

            l_p_state_RAM: begin
                l_r_in[0] = i_w_ram[3:0];
                l_r_in[1] = i_w_ram[7:4];
                l_r_in[2] = i_w_ram[11:8];
                l_r_in[3] = i_w_ram[15:12];

                l_r_digit_7seg[4] = 8'b1101_1000;    // right half M
                l_r_digit_7seg[5] = 8'b1100_1100;    // left half M
                l_r_digit_7seg[6] = 8'b1000_1000;    // A
                l_r_digit_7seg[7] = 8'b1010_1111;    // r
            end

            l_p_state_BUS: begin
                l_r_in[0] = i_w_bus[3:0];
                l_r_in[1] = i_w_bus[7:4];
                l_r_in[2] = i_w_bus[11:8];
                l_r_in[3] = i_w_bus[15:12];

                l_r_digit_7seg[5] = 8'b1001_0010;    // S
                l_r_digit_7seg[6] = 8'b1100_0001;    // U
                l_r_digit_7seg[7] = 8'b1000_0011;    // b
            end

            l_p_state_FSM: begin
                l_r_digit_7seg[4] = 8'b1101_1000;    // right half M
                l_r_digit_7seg[5] = 8'b1100_1100;    // left half M
                l_r_digit_7seg[6] = 8'b1001_0010;    // S
                l_r_digit_7seg[7] = 8'b1000_1110;    // F
            end

        endcase
    end

    wire [7:0] l_w_7_led_seg_0;
    wire [7:0] l_w_7_led_seg_1;
    wire [7:0] l_w_7_led_seg_2;
    wire [7:0] l_w_7_led_seg_3;

    // instantiate 4 led7hex modules
    led7hex led7hex_inst_0 (
        .l_r_led7(l_w_7_led_seg_0),
        .i_w_value(l_r_in[0])
    );

    led7hex led7hex_inst_1 (
        .l_r_led7(l_w_7_led_seg_1),
        .i_w_value(l_r_in[1])
    );

    led7hex led7hex_inst_2 (
        .l_r_led7(l_w_7_led_seg_2),
        .i_w_value(l_r_in[2])
    );

    led7hex led7hex_inst_3 (
        .l_r_led7(l_w_7_led_seg_3),
        .i_w_value(l_r_in[3])
    );
    

    // FSM - output logic compute the least significant digits from the state
    always @(*) begin
        l_r_digit_7seg[0] = 8'b1111_1111;
        l_r_digit_7seg[1] = 8'b1111_1111;
        l_r_digit_7seg[2] = 8'b1111_1111;
        l_r_digit_7seg[3] = 8'b1111_1111;

        if (l_r_state == l_p_state_FSM) begin   
            case(i_w_state)
                reset: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1000_0111;    // t
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1010_1111;    // r
                end

                fetch: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1000_0111;    // t
                    l_r_digit_7seg[2] = 8'b1000_0110;    // E
                    l_r_digit_7seg[3] = 8'b1000_1110;    // F
                end

                fetch + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1000_0111;    // t
                    l_r_digit_7seg[2] = 8'b1000_0110;    // E
                    l_r_digit_7seg[3] = 8'b1000_1110;    // F
                end

                fetch + 'd2: begin
                    l_r_digit_7seg[0] = 8'b1010_0100;    // 2
                    l_r_digit_7seg[1] = 8'b1000_0111;    // t
                    l_r_digit_7seg[2] = 8'b1000_0110;    // E
                    l_r_digit_7seg[3] = 8'b1000_1110;    // F
                end

                decode: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_0001;    // d
                    l_r_digit_7seg[2] = 8'b1100_0110;    // C
                    l_r_digit_7seg[3] = 8'b1010_0001;    // d
                end

                addr_sum: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1001_0010;    // S
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1000_1000;    // A
                end

                addr_sum + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1001_0010;    // S
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1000_1000;    // A
                end

                addr_sum + 'd2: begin
                    l_r_digit_7seg[0] = 8'b1010_0100;    // 2
                    l_r_digit_7seg[1] = 8'b1001_0010;    // S
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1000_1000;    // A
                end

                addr_reg: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_1111;    // r
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1000_1000;    // A
                end

                addr_io: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1111_1001;    // I
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1000_1000;    // A
                end

                load_src_reg: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_1111;    // r
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_src_mem: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_src_mem + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_src_mem + 'd2: begin
                    l_r_digit_7seg[0] = 8'b1010_0100;    // 2
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_src_io: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1111_1001;    // I
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_src_io + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1111_1001;    // I
                    l_r_digit_7seg[2] = 8'b1001_0010;    // S
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_dst_reg: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_1111;    // r
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_dst_mem: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_dst_mem +'d1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                load_dst_mem + 'd2: begin
                    l_r_digit_7seg[0] = 8'b1010_0100;    // 2
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1100_0111;    // L
                end

                noload_dst_reg: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_1111;    // r
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1010_1011;    // n
                end

                noload_dst_io: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1111_1001;    // i
                    l_r_digit_7seg[2] = 8'b1010_0001;    // d
                    l_r_digit_7seg[3] = 8'b1010_1011;    // n
                end

                exec_1op: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1100_0000;    // O
                    l_r_digit_7seg[2] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[3] = 8'b1000_0110;    // E
                end

                exec_2op: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1100_0000;    // O
                    l_r_digit_7seg[2] = 8'b1010_0100;    // 2
                    l_r_digit_7seg[3] = 8'b1000_0110;    // E
                end

                exec_transf: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1100_1110;    // right half T
                    l_r_digit_7seg[2] = 8'b1111_1000;    // left half T
                    l_r_digit_7seg[3] = 8'b1000_0110;    // E
                end

                store_reg: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1010_1111;    // r
                    l_r_digit_7seg[2] = 8'b1000_0111;    // t
                    l_r_digit_7seg[3] = 8'b1001_0010;    // S
                end

                store_mem: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1000_0111;    // t
                    l_r_digit_7seg[3] = 8'b1001_0010;    // S
                end

                store_mem + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1101_0100;    // m
                    l_r_digit_7seg[2] = 8'b1000_0111;    // t
                    l_r_digit_7seg[3] = 8'b1001_0010;    // S
                end

                store_io: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1111_1001;    // I
                    l_r_digit_7seg[2] = 8'b1000_0111;    // t
                    l_r_digit_7seg[3] = 8'b1001_0010;    // S
                end

                inc_cp: begin
                    l_r_digit_7seg[0] = 8'b1111_1111;
                    l_r_digit_7seg[1] = 8'b1000_1100;    // P
                    l_r_digit_7seg[2] = 8'b1100_0110;    // C
                    l_r_digit_7seg[3] = 8'b1111_1001;    // I
                end

                inc_cp + 'd1: begin
                    l_r_digit_7seg[0] = 8'b1111_1001;    // 1
                    l_r_digit_7seg[1] = 8'b1000_1100;    // P
                    l_r_digit_7seg[2] = 8'b1100_0110;    // C
                    l_r_digit_7seg[3] = 8'b1111_1001;    // I
                end

            endcase
        end else begin
            l_r_digit_7seg[0] = l_w_7_led_seg_0;
            l_r_digit_7seg[1] = l_w_7_led_seg_1;
            l_r_digit_7seg[2] = l_w_7_led_seg_2;
            l_r_digit_7seg[3] = l_w_7_led_seg_3;
        end

    end

    // turn off the other 7 led digits
    assign o_w_an = ~(1 << l_r_digit);

    assign o_w_7_led_seg = l_r_digit_7seg[l_r_digit];

endmodule