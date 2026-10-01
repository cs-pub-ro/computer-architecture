module lut(
    input a,
    input b,
    output reg o1,
    output reg o2
);
    always @(*) begin
        case ({a, b})
            2'b00: begin o1 = 1'b0; o2 = 1'b0; end
            2'b01: begin o1 = 1'b0; o2 = 1'b0; end
            2'b10: begin o1 = 1'b0; o2 = 1'b0; end
            2'b11: begin o1 = 1'b0; o2 = 1'b0; end
            default: begin o1 = 1'b0; o2 = 1'b0; end
        endcase
    end
endmodule
