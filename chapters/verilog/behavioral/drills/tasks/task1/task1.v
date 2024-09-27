module task1(
    output wire [6:0] o_w_7seg,    
    input  wire [3:0] i_w_in    
);

    reg [6:0] l_r_7seg;

    always@(*) begin
        case(i_w_in)
            'd0: l_r_7seg = 7'b011_1111;
            'd1: l_r_7seg = 7'b000_0110;
            'd2: l_r_7seg = 7'b101_1011;
            'd3: l_r_7seg = 7'b100_1111;
            'd4: l_r_7seg = 7'b110_0110;
            'd5: l_r_7seg = 7'b110_1101;
            'd6: l_r_7seg = 7'b111_1101;
            'd7: l_r_7seg = 7'b000_0111;
            'd8: l_r_7seg = 7'b111_1111;
            'd9: l_r_7seg = 7'b110_0111;
            default: l_r_7seg = 7'b100_0000; //default case -> place "-"
        endcase
    end

    assign o_w_7seg = l_r_7seg;
    
endmodule