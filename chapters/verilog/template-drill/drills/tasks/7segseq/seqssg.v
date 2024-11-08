module seqssg(
    output wire [6:0] o_w_out, // digit output only 7-segment display
    output wire [2:0] o_w_sel, // anode selection for display
    input wire [2:0] i_w_sel, // inner memory address selection
    input wire [3:0] i_w_dig, // digit value to store
    input wire we, // 0 - nothing, 1 - write digit to mem[sel]
    input wire i_w_clk,   // clock input
    input wire i_w_reset  // reset input
);

reg [2:0] counter;
reg [3:0] mem[0:7];
reg [6:0] l_r_7seg;
//
assign o_w_out = l_r_7seg; // default value
assign o_w_sel = counter;

integer i;
// sequential part
always @(posedge i_w_clk) begin
    if(i_w_reset) begin
        counter <= 0;
        for (i = 0; i < 8; i = i + 1) begin
            mem[i] <= 4'b0000;
        end
    end else begin
        counter <= counter >= 7 ? 0 : counter + 1;
        if(we) begin
            mem[i_w_sel] <= i_w_dig;
        end
    end
end

// combinational part
always @(*) begin
    case(mem[counter])
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
        default: l_r_7seg = 7'b111_1111;
    endcase
end

endmodule
