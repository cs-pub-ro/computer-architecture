module lut(
    input a,
    input b,
    output reg o1,
    output reg o2
);
    always @(*) begin
        case ({a, b})
            2'b00: begin o1 = `LUT_O1_0; o2 = `LUT_O2_0; end
            2'b01: begin o1 = `LUT_O1_1; o2 = `LUT_O2_1; end
            2'b10: begin o1 = `LUT_O1_2; o2 = `LUT_O2_2; end
            2'b11: begin o1 = `LUT_O1_3; o2 = `LUT_O2_3; end
            default: begin o1 = 1'b0; o2 = 1'b0; end
        endcase
    end
endmodule
