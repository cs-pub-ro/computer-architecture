module state_display(
    output wire [6:0] o_w_7seg,
    output wire [7:0] o_w_an,
    input  wire [15:0] i_w_in,
    input wire i_w_next,
    input wire i_w_prev,
    input wire i_w_clk,
    input wire i_w_reset_n
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


localparam BUS              = 16'h00;
localparam RA               = 16'h01;
localparam RB               = 16'h02;
localparam RC               = 16'h03;
localparam IS               = 16'h04;
localparam XA               = 16'h05;
localparam XB               = 16'h06;
localparam BA               = 16'h07;
localparam BB               = 16'h08;
localparam RI               = 16'h09;
localparam IND              = 16'h0a;
localparam CP               = 16'h0b;
localparam AM               = 16'h0c;
localparam M                = 16'h0d;
localparam T1               = 16'h0e;
localparam T2               = 16'h0f;
localparam FSM              = 16'h10;

    reg [6:0] l_r_7seg;
    reg [2:0] l_r_digit = 0;
    reg [4:0] l_r_in, l_r_offset;
    reg [6:0] l_r_digit_7seg[7:0];

    reg [15:0] l_r_state = 0;
    reg l_r_next_last_val;
    reg l_r_prev_last_val;

    always @(posedge i_w_clk, negedge i_w_reset_n) begin

        if (!i_w_reset_n)
            l_r_state <= 0;
        else begin
            l_r_digit <= l_r_digit + 1; 

            // for debounce
            l_r_next_last_val <= i_w_next;
            l_r_prev_last_val <= i_w_prev;

            if (i_w_next && !l_r_next_last_val) 
                l_r_state <= (l_r_state != 16) ? (l_r_state + 1) : 0;
            
            if (i_w_prev && !l_r_prev_last_val) 
                l_r_state <= (l_r_state != 0) ? (l_r_state - 1) : 16;  
        end

    end


    always@(*) begin

        l_r_digit_7seg[0] = 7'b111_1111;
        l_r_digit_7seg[1] = 7'b111_1111;
        l_r_digit_7seg[2] = 7'b111_1111;
        l_r_digit_7seg[3] = 7'b111_1111;
        l_r_digit_7seg[4] = 7'b111_1111;
        l_r_digit_7seg[5] = 7'b111_1111;
        l_r_digit_7seg[6] = 7'b111_1111;
        l_r_digit_7seg[7] = 7'b111_1111;

        case(l_r_state)
            BUS: begin
                l_r_digit_7seg[4] = 7'b001_0010;    // S
                l_r_digit_7seg[5] = 7'b100_0001;    // U
                l_r_digit_7seg[6] = 7'b000_0011;    // b
            end

            RA: begin
                l_r_digit_7seg[4] = 7'b000_1000;    // A
                l_r_digit_7seg[5] = 7'b010_1111;    // r
            end

            RB: begin
                l_r_digit_7seg[4] = 7'b000_0011;    // b
                l_r_digit_7seg[5] = 7'b010_1111;    // r
            end

            RC: begin
                l_r_digit_7seg[4] = 7'b100_0110;    // C
                l_r_digit_7seg[5] = 7'b010_1111;    // r
            end

            IS: begin
                l_r_digit_7seg[4] = 7'b001_0010;    // S
                l_r_digit_7seg[5] = 7'b111_1001;    // I
            end

            XA: begin
                l_r_digit_7seg[4] = 7'b000_1000;    // A
                l_r_digit_7seg[5] = 7'b100_0110;    // right half X
                l_r_digit_7seg[6] = 7'b111_0000;    // left half X
            end

            XB: begin
                l_r_digit_7seg[4] = 7'b000_0011;    // b
                l_r_digit_7seg[5] = 7'b100_0110;    // right half X
                l_r_digit_7seg[6] = 7'b111_0000;    // left half X
            end

            BA: begin
                l_r_digit_7seg[4] = 7'b000_1000;    // A
                l_r_digit_7seg[5] = 7'b000_0011;    // b
            end

            BB: begin
                l_r_digit_7seg[4] = 7'b000_0011;    // b
                l_r_digit_7seg[5] = 7'b000_0011;    // b
            end

            RI: begin
                l_r_digit_7seg[4] = 7'b111_1001;    // I
                l_r_digit_7seg[5] = 7'b010_1111;    // r
            end

            IND: begin
                l_r_digit_7seg[4] = 7'b010_0001;    // d
                l_r_digit_7seg[5] = 7'b010_1011;    // n
                l_r_digit_7seg[6] = 7'b111_1011;    // i
            end

            CP: begin
                l_r_digit_7seg[4] = 7'b000_1100;    // P
                l_r_digit_7seg[5] = 7'b100_0110;    // C
            end

            AM: begin
                l_r_digit_7seg[4] = 7'b101_1000;    // right half M
                l_r_digit_7seg[5] = 7'b100_1100;    // left half M
                l_r_digit_7seg[6] = 7'b000_1000;    // A
            end

            M: begin
                l_r_digit_7seg[4] = 7'b101_1000;    // right half M
                l_r_digit_7seg[5] = 7'b100_1100;    // left half M
            end

            T1: begin
                l_r_digit_7seg[4] = 7'b111_1001;    // 1
                l_r_digit_7seg[5] = 7'b100_1110;    // right half T
                l_r_digit_7seg[6] = 7'b111_1000;    // left half T
            end

            T2: begin
                l_r_digit_7seg[4] = 7'b010_0100;    // 2
                l_r_digit_7seg[5] = 7'b100_1110;    // right half T
                l_r_digit_7seg[6] = 7'b111_1000;    // left half T
            end

            FSM: begin
                l_r_digit_7seg[4] = 7'b101_1000;    // right half M
                l_r_digit_7seg[5] = 7'b100_1100;    // left half M
                l_r_digit_7seg[6] = 7'b001_0010;    // S
                l_r_digit_7seg[7] = 7'b000_1110;    // F
            end
            
        endcase

        if(l_r_state == FSM) begin

            case(i_w_in)
                reset: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b000_0111;    // t
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b010_1111;    // r
                end

                fetch: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b000_0111;    // t
                    l_r_digit_7seg[2] = 7'b000_0110;    // E
                    l_r_digit_7seg[3] = 7'b000_1110;    // F
                end

                fetch + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b000_0111;    // t
                    l_r_digit_7seg[2] = 7'b000_0110;    // E
                    l_r_digit_7seg[3] = 7'b000_1110;    // F
                end

                fetch + 'd2: begin
                    l_r_digit_7seg[0] = 7'b010_0100;    // 2
                    l_r_digit_7seg[1] = 7'b000_0111;    // t
                    l_r_digit_7seg[2] = 7'b000_0110;    // E
                    l_r_digit_7seg[3] = 7'b000_1110;    // F
                end

                decode: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_0001;    // d
                    l_r_digit_7seg[2] = 7'b100_0110;    // C
                    l_r_digit_7seg[3] = 7'b010_0001;    // d
                end

                addr_sum: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b001_0010;    // S
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b000_1000;    // A
                end

                addr_sum + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b001_0010;    // S
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b000_1000;    // A
                end

                addr_sum + 'd2: begin
                    l_r_digit_7seg[0] = 7'b010_0100;    // 2
                    l_r_digit_7seg[1] = 7'b001_0010;    // S
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b000_1000;    // A
                end

                addr_reg: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_1111;    // r
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b000_1000;    // A
                end

                addr_io: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b111_1001;    // I
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b000_1000;    // A
                end

                load_src_reg: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_1111;    // r
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_src_mem: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_src_mem + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_src_mem + 'd2: begin
                    l_r_digit_7seg[0] = 7'b010_0100;    // 2
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_src_io: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b111_1001;    // I
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_src_io + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b111_1001;    // I
                    l_r_digit_7seg[2] = 7'b001_0010;    // S
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_dst_reg: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_1111;    // r
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_dst_mem: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_dst_mem +'d1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                load_dst_mem + 'd2: begin
                    l_r_digit_7seg[0] = 7'b010_0100;    // 2
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b100_0111;    // L
                end

                noload_dst_reg: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_1111;    // r
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b010_1011;    // n
                end

                noload_dst_io: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b111_1001;    // i
                    l_r_digit_7seg[2] = 7'b010_0001;    // d
                    l_r_digit_7seg[3] = 7'b010_1011;    // n
                end

                exec_1op: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b100_0000;    // O
                    l_r_digit_7seg[2] = 7'b111_1001;    // 1
                    l_r_digit_7seg[3] = 7'b000_0110;    // E
                end

                exec_2op: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b100_0000;    // O
                    l_r_digit_7seg[2] = 7'b010_0100;    // 2
                    l_r_digit_7seg[3] = 7'b000_0110;    // E
                end

                exec_transf: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b100_1110;    // right half T
                    l_r_digit_7seg[2] = 7'b111_1000;    // left half T
                    l_r_digit_7seg[3] = 7'b000_0110;    // E
                end

                store_reg: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b010_1111;    // r
                    l_r_digit_7seg[2] = 7'b000_0111;    // t
                    l_r_digit_7seg[3] = 7'b001_0010;    // S
                end

                store_mem: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b000_0111;    // t
                    l_r_digit_7seg[3] = 7'b001_0010;    // S
                end

                store_mem + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b101_0100;    // m
                    l_r_digit_7seg[2] = 7'b000_0111;    // t
                    l_r_digit_7seg[3] = 7'b001_0010;    // S
                end

                store_io: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b111_1001;    // I
                    l_r_digit_7seg[2] = 7'b000_0111;    // t
                    l_r_digit_7seg[3] = 7'b001_0010;    // S
                end

                inc_cp: begin
                    l_r_digit_7seg[0] = 7'b111_1111;
                    l_r_digit_7seg[1] = 7'b000_1100;    // P
                    l_r_digit_7seg[2] = 7'b100_0110;    // C
                    l_r_digit_7seg[3] = 7'b111_1001;    // I
                end

                inc_cp + 'd1: begin
                    l_r_digit_7seg[0] = 7'b111_1001;    // 1
                    l_r_digit_7seg[1] = 7'b000_1100;    // P
                    l_r_digit_7seg[2] = 7'b100_0110;    // C
                    l_r_digit_7seg[3] = 7'b111_1001;    // I
                end

            endcase

        end else begin

            case(l_r_digit)
                2'd0: l_r_in = i_w_in[3:0];
                2'd1: l_r_in = i_w_in[7:4];
                2'd2: l_r_in = i_w_in[11:8];
                2'd3: l_r_in = i_w_in[15:12];            
            endcase

            // 7 seg output
            case(l_r_in)
                4'd0: l_r_7seg = 7'b100_0000;
                4'd1: l_r_7seg = 7'b111_1001;
                4'd2: l_r_7seg = 7'b010_0100;
                4'd3: l_r_7seg = 7'b011_0000;
                4'd4: l_r_7seg = 7'b001_1001;
                4'd5: l_r_7seg = 7'b001_0010;
                4'd6: l_r_7seg = 7'b000_0010;
                4'd7: l_r_7seg = 7'b111_1000;
                4'd8: l_r_7seg = 7'b000_0000;
                4'd9: l_r_7seg = 7'b001_1000;
                4'd10: l_r_7seg = 7'b000_1000;  // A
                4'd11: l_r_7seg = 7'b000_0011;  // b
                4'd12: l_r_7seg = 7'b100_0110;  // C
                4'd13: l_r_7seg = 7'b010_0001;  // d
                4'd14: l_r_7seg = 7'b000_0110;  // E
                4'd15: l_r_7seg = 7'b000_1110;  // F
                default: l_r_7seg = 7'b011_1111; //default case -> place "-"
            endcase

            if (l_r_digit < 4)
                l_r_digit_7seg[l_r_digit] = l_r_7seg;

        end
    end

    // turn off the other 7 led digits
    assign o_w_an = ~(1 << l_r_digit);

    assign o_w_7seg = l_r_digit_7seg[l_r_digit];

endmodule