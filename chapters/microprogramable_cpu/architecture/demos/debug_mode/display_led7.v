module display_led7(
    output wire [6:0] o_w_7seg,
    output wire [7:0] o_w_an,    
    // input  wire [15:0] i_w_value,
    input  wire [15:0] i_w_in,
    // input  wire [15:0] i_w_mem_addr,
    input wire i_w_clk
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
    reg [4:0] l_r_in;
    reg [17:0] counter = 0;
    reg [6:0] l_r_digit_7seg[7:0];

    always @(posedge i_w_clk) begin

        if (counter == 208334) begin  // Divide by 208334 for 480 Hz ( 60Hz * 8 digits)
            counter <= 0;
            l_r_digit <= l_r_digit + 1;
        end
        else begin
            counter <= counter + 1;
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

        case(i_w_in)
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
    end

    // turn off the other 7 led digits
    assign o_w_an = ~(1 << l_r_digit);

    assign o_w_7seg = l_r_digit_7seg[l_r_digit];

endmodule