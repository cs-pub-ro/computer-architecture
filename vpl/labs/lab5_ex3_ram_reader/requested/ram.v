// Simulation model standing in for the Xilinx Block RAM IP core ("ram", 1024 x 16, dual port)
// used in the ISE project. Port A and port B have synchronous read with 1 cycle latency.
// The initial contents are the ones of ram.mif / ram.coe. Not synthesizable; do not modify.
module ram(
    input         clka,
    input         rsta,
    input  [0:0]  wea,
    input  [9:0]  addra,
    input  [15:0] dina,
    output reg [15:0] douta,
    input         clkb,
    input  [0:0]  web,
    input  [9:0]  addrb,
    input  [15:0] dinb,
    output reg [15:0] doutb
);
    reg [15:0] mem [0:1023];
    integer k;
    initial begin
        for (k = 0; k < 1024; k = k + 1) mem[k] = 16'h0000;
        mem[0] = 16'h0304;
        mem[1] = 16'h000a;
        mem[2] = 16'h4304;
        mem[4] = 16'he304;
        mem[6] = 16'hc304;
        mem[8] = 16'he110;
        mem[9] = 16'h0016;
        mem[10] = 16'he150;
        mem[11] = 16'h000a;
        mem[22] = 16'h0326;
        mem[23] = 16'h0001;
        mem[24] = 16'h2039;
        mem[25] = 16'h4304;
        mem[26] = 16'h0001;
        mem[27] = 16'h0011;
        mem[28] = 16'h0320;
        mem[29] = 16'h032e;
        mem[30] = 16'h0001;
        mem[31] = 16'he110;
        mem[32] = 16'h0016;
        mem[33] = 16'h0360;
        mem[34] = 16'h430a;
        mem[35] = 16'h0011;
        douta = 16'h0000;
        doutb = 16'h0000;
    end
    always @(posedge clka) begin
        if (wea) mem[addra] <= dina;
        douta <= mem[addra];
    end
    always @(posedge clkb) begin
        if (web) mem[addrb] <= dinb;
        doutb <= mem[addrb];
    end
endmodule
