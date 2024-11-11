module sequential_led7(
    output wire [6:0] o_w_7seg,
    output wire [7:0] o_w_an,    
    input  wire [15:0] i_w_in,
    input wire i_w_clk
);

    reg [6:0] l_r_7seg;
    reg [1:0] l_r_digit = 0;
    reg [4:0] l_r_in;
    reg [18:0] counter = 0;

    always @(posedge i_w_clk) begin
     
        if (counter == 416667) begin  // Divide by 416667 for 240 Hz ( 60Hz * 4 digits)
            counter <= 0;
            l_r_digit <= l_r_digit + 1;
        end
        else begin
            counter <= counter + 1;
        end
    end

    always@(*) begin
         // which digit of input to display
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
            4'd10: l_r_7seg = 7'b000_1000;
            4'd11: l_r_7seg = 7'b000_0011;
            4'd12: l_r_7seg = 7'b100_0110;
            4'd13: l_r_7seg = 7'b010_0001;
            4'd14: l_r_7seg = 7'b000_0110;
            4'd15: l_r_7seg = 7'b000_1110;
            default: l_r_7seg = 7'b011_1111; //default case -> place "-"
        endcase
    end
    
    // turn off the other 7 led digits
    assign o_w_an = ~(1 << l_r_digit);
    
    assign o_w_7seg = l_r_7seg;
    
endmodule