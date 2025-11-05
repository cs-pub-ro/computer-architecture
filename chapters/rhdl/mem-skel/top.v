module top(input wire [1:0] clock_reset, output wire [15:0] o);
   wire [158:0] od;
   wire [142:0] d;
   wire [116:0] q;
   assign o = od[15:0];
   top_Cu c0(.clock_reset(clock_reset), .i(d[76:75]), .o(q[82:64]));
   top_MA c1(.clock_reset(clock_reset), .i(d[74:57]), .o(q[63:48]));
   top_RAM c2(.clock_reset(clock_reset), .i(d[104:77]), .o(q[98:83]));
   top_T1 c3(.clock_reset(clock_reset), .i(d[38:21]), .o(q[31:16]));
   top_T2 c4(.clock_reset(clock_reset), .i(d[56:39]), .o(q[47:32]));
   top_alu c5(.clock_reset(clock_reset), .i(d[142:105]), .o(q[116:99]));
   top_regs c6(.clock_reset(clock_reset), .i(d[20:0]), .o(q[15:0]));
   assign d = od[158:16];
   assign od = kernel_top_kernel(clock_reset, q);
   function [158:0] kernel_top_kernel(input reg [1:0] arg_0, input reg [116:0] arg_2);
         reg [15:0] or0;
         reg [116:0] or1;
         reg [15:0] or2;
         reg [15:0] or3;
         reg [17:0] or4;
         reg [15:0] or5;
         reg [15:0] or6;
         reg [18:0] or7;
         reg [0:0] or8;
         reg [0:0] or9;
         reg [0:0] or10;
         reg [0:0] or11;
         reg [0:0] or12;
         reg [0:0] or13;
         reg [0:0] or14;
         reg [0:0] or15;
         reg [0:0] or16;
         reg [3:0] or17;
         reg [0:0] or18;
         reg [2:0] or19;
         reg [0:0] or20;
         reg [0:0] or21;
         reg [17:0] or22;
         reg [17:0] or23;
         reg [17:0] or24;
         // _d
         reg [142:0] or25;
         reg [17:0] or26;
         reg [17:0] or27;
         reg [17:0] or28;
         // _d
         reg [142:0] or29;
         reg [17:0] or30;
         reg [17:0] or31;
         reg [17:0] or32;
         // _d
         reg [142:0] or33;
         reg [15:0] or34;
         reg [9:0] or35;
         reg [27:0] or36;
         reg [27:0] or37;
         reg [27:0] or38;
         reg [27:0] or39;
         // _d
         reg [142:0] or40;
         reg [15:0] or41;
         reg [15:0] or42;
         reg [37:0] or43;
         reg [37:0] or44;
         reg [37:0] or45;
         reg [37:0] or46;
         reg [37:0] or47;
         // _d
         reg [142:0] or48;
         reg [17:0] or49;
         reg [0:0] or50;
         reg [17:0] or51;
         reg [0:0] or52;
         reg [1:0] or53;
         reg [1:0] or54;
         // _d
         reg [142:0] or55;
         reg [20:0] or56;
         reg [20:0] or57;
         reg [20:0] or58;
         reg [20:0] or59;
         // _d
         reg [142:0] or60;
         reg [158:0] or61;
         reg [1:0] or62;
         localparam ol0 = 18'b000000000000000000;
         localparam ol1 = 143'bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
         localparam ol2 = 18'b000000000000000000;
         localparam ol3 = 18'b000000000000000000;
         localparam ol4 = 28'b0000000000000000000000000000;
         localparam ol5 = 38'b00000000000000000000000000000000000000;
         localparam ol6 = 2'b00;
         localparam ol7 = 21'b000000000000000000000;
         begin
            or62 = arg_0;
            or1 = arg_2;
            or0 = or1[15:0];
            or2 = or1[98:83];
            or3 = or0 | or2;
            or4 = or1[116:99];
            or5 = or4[15:0];
            or6 = or3 | or5;
            or7 = or1[82:64];
            or8 = or7[5:5];
            or9 = or7[6:6];
            or10 = or7[7:7];
            or11 = or7[8:8];
            or12 = or7[9:9];
            or13 = or7[10:10];
            or14 = or7[12:12];
            or15 = or7[11:11];
            or16 = or7[13:13];
            or17 = or7[18:15];
            or18 = or7[14:14];
            or19 = or7[2:0];
            or20 = or7[3:3];
            or21 = or7[4:4];
            or22 = ol0;
            or22[0:0] = or8;
            or23 = or22;
            or23[1:1] = or9;
            or24 = or23;
            or24[17:2] = or6;
            or25 = ol1;
            or25[38:21] = or24;
            or26 = ol2;
            or26[0:0] = or10;
            or27 = or26;
            or27[1:1] = or11;
            or28 = or27;
            or28[17:2] = or6;
            or29 = or25;
            or29[56:39] = or28;
            or30 = ol3;
            or30[0:0] = or12;
            or31 = or30;
            or31[1:1] = or13;
            or32 = or31;
            or32[17:2] = or6;
            or33 = or29;
            or33[74:57] = or32;
            or34 = or1[63:48];
            or35 = or34[9:0];
            or36 = ol4;
            or36[0:0] = or15;
            or37 = or36;
            or37[1:1] = or14;
            or38 = or37;
            or38[17:2] = or6;
            or39 = or38;
            or39[27:18] = or35;
            or40 = or33;
            or40[104:77] = or39;
            or41 = or1[31:16];
            or42 = or1[47:32];
            or43 = ol5;
            or43[36:36] = or16;
            or44 = or43;
            or44[35:32] = or17;
            or45 = or44;
            or45[37:37] = or18;
            or46 = or45;
            or46[15:0] = or41;
            or47 = or46;
            or47[31:16] = or42;
            or48 = or40;
            or48[142:105] = or47;
            or49 = or1[116:99];
            or50 = or49[17:17];
            or51 = or1[116:99];
            or52 = or51[16:16];
            or53 = ol6;
            or53[0:0] = or50;
            or54 = or53;
            or54[1:1] = or52;
            or55 = or48;
            or55[76:75] = or54;
            or56 = ol7;
            or56[0:0] = or20;
            or57 = or56;
            or57[1:1] = or21;
            or58 = or57;
            or58[17:2] = or6;
            or59 = or58;
            or59[20:18] = or19;
            or60 = or55;
            or60[20:0] = or59;
            or61 = {or60, or6};
            kernel_top_kernel = or61;
         end
   endfunction
endmodule
module top_Cu(input wire [1:0] clock_reset, input wire [1:0] i, output wire [18:0] o);
   wire [20:0] od;
   wire [1:0] d;
   wire [1:0] q;
   assign o = od[18:0];
   top_Cu_state c0(.clock_reset(clock_reset), .i(d[1:0]), .o(q[1:0]));
   assign d = od[20:19];
   assign od = kernel_cu_kernel(clock_reset, i, q);
   function [20:0] kernel_cu_kernel(input reg [1:0] arg_0, input reg [1:0] arg_1, input reg [1:0] arg_2);
         reg [1:0] or0;
         // cs
         reg [18:0] or1;
         reg [1:0] or2;
         reg [1:0] or3;
         reg [20:0] or4;
         reg [1:0] or5;
         reg [1:0] or6;
         localparam ol0 = 2'b00;
         localparam ol1 = 19'b0000000000100110000;
         localparam ol2 = 2'b01;
         localparam ol3 = 19'b0000000001001010000;
         localparam ol4 = 2'b10;
         localparam ol5 = 19'b0000000000011010000;
         localparam ol6 = 2'b11;
         localparam ol7 = 19'b0000000001100010000;
         localparam ol8 = 19'b0000000000000010000;
         localparam ol9 = 2'b01;
         localparam ol10 = 2'b00;
         begin
            or5 = arg_0;
            or6 = arg_1;
            or0 = arg_2;
            case (or0)
               2'b00 : or1 = ol1;
               2'b01 : or1 = ol3;
               2'b10 : or1 = ol5;
               2'b11 : or1 = ol7;
               default : or1 = ol8;
            endcase
            or2 = or0 + ol9;
            or3 = ol10;
            or3[1:0] = or2;
            or4 = {or3, or1};
            kernel_cu_kernel = or4;
         end
   endfunction
endmodule
module top_Cu_state(input wire [1:0] clock_reset, input wire [1:0] i, output reg [1:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 2'b00;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 2'b00;
      end else begin
         o <= i;
      end
   end
endmodule
module top_MA(input wire [1:0] clock_reset, input wire [17:0] i, output wire [15:0] o);
   wire [31:0] od;
   wire [15:0] d;
   wire [15:0] q;
   assign o = od[15:0];
   top_MA_memory c0(.clock_reset(clock_reset), .i(d[15:0]), .o(q[15:0]));
   assign d = od[31:16];
   assign od = kernel_register_kernel(clock_reset, i, q);
   function [31:0] kernel_register_kernel(input reg [1:0] arg_0, input reg [17:0] arg_1, input reg [15:0] arg_2);
         reg [0:0] or0;
         reg [17:0] or1;
         reg [0:0] or2;
         reg [0:0] or3;
         reg [0:0] or4;
         reg [0:0] or5;
         reg [15:0] or6;
         reg [15:0] or7;
         reg [0:0] or8;
         reg [0:0] or9;
         reg [15:0] or10;
         reg [15:0] or11;
         reg [15:0] or12;
         reg [31:0] or13;
         reg [1:0] or14;
         localparam ol0 = 1'b1;
         localparam ol1 = 1'b0;
         localparam ol2 = 16'b0000000000000000;
         localparam ol3 = 1'b1;
         localparam ol4 = 16'b0000000000000000;
         begin
            or14 = arg_0;
            or1 = arg_1;
            or6 = arg_2;
            or0 = or1[0:0];
            or2 = or0 == ol0;
            or3 = or1[1:1];
            or4 = or3 == ol1;
            or5 = or2 & or4;
            or7 = or5 ? or6 : ol2;
            or8 = or1[1:1];
            or9 = or8 == ol3;
            or10 = or1[17:2];
            or11 = or9 ? or10 : or6;
            or12 = ol4;
            or12[15:0] = or11;
            or13 = {or12, or7};
            kernel_register_kernel = or13;
         end
   endfunction
endmodule
module top_MA_memory(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_RAM(input wire [1:0] clock_reset, input wire [27:0] i, output wire [15:0] o);
   wire [52:0] od;
   wire [36:0] d;
   wire [15:0] q;
   assign o = od[15:0];
   top_RAM_memory c0(.clock_reset(clock_reset), .i(d[36:0]), .o(q[15:0]));
   assign d = od[52:16];
   assign od = kernel_ram_kernel(clock_reset, i, q);
   function [52:0] kernel_ram_kernel(input reg [1:0] arg_0, input reg [27:0] arg_1, input reg [15:0] arg_2);
         reg [9:0] or0;
         reg [27:0] or1;
         // d
         reg [36:0] or2;
         reg [9:0] or3;
         reg [15:0] or4;
         reg [0:0] or5;
         reg [0:0] or6;
         reg [26:0] or7;
         reg [26:0] or8;
         reg [26:0] or9;
         // d
         reg [36:0] or10;
         reg [0:0] or11;
         reg [0:0] or12;
         reg [15:0] or13;
         reg [15:0] or14;
         reg [52:0] or15;
         reg [1:0] or16;
         localparam ol0 = 37'bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
         localparam ol1 = 1'b1;
         localparam ol2 = 27'b000000000000000000000000000;
         localparam ol3 = 1'b1;
         localparam ol4 = 16'b0000000000000000;
         begin
            or16 = arg_0;
            or1 = arg_1;
            or13 = arg_2;
            or0 = or1[27:18];
            or2 = ol0;
            or2[9:0] = or0;
            or3 = or1[27:18];
            or4 = or1[17:2];
            or5 = or1[1:1];
            or6 = or5 == ol1;
            or7 = ol2;
            or7[9:0] = or3;
            or8 = or7;
            or8[25:10] = or4;
            or9 = or8;
            or9[26:26] = or6;
            or10 = or2;
            or10[36:10] = or9;
            or11 = or1[0:0];
            or12 = or11 == ol3;
            or14 = or12 ? or13 : ol4;
            or15 = {or10, or14};
            kernel_ram_kernel = or15;
         end
   endfunction
endmodule
module top_RAM_memory(input wire [1:0] clock_reset, input wire [36:0] i, output reg [15:0] o);
   wire [9:0] read_addr;
   wire [9:0] write_addr;
   wire [15:0] write_value;
   wire [0:0] write_enable;
   wire [0:0] clock;
   reg [15:0] mem[1023:0];
   initial begin
   end
   assign read_addr = i[9:0];
   assign write_addr = i[19:10];
   assign write_value = i[35:20];
   assign write_enable = i[36:36];
   assign clock = clock_reset[0:0];
   always @(posedge clock) begin
      o <= mem[read_addr];
   end
   always @(posedge clock) begin
      if (write_enable) begin
         mem[write_addr] <= write_value;
      end
   end
endmodule
module top_T1(input wire [1:0] clock_reset, input wire [17:0] i, output wire [15:0] o);
   wire [31:0] od;
   wire [15:0] d;
   wire [15:0] q;
   assign o = od[15:0];
   top_T1_memory c0(.clock_reset(clock_reset), .i(d[15:0]), .o(q[15:0]));
   assign d = od[31:16];
   assign od = kernel_register_kernel(clock_reset, i, q);
   function [31:0] kernel_register_kernel(input reg [1:0] arg_0, input reg [17:0] arg_1, input reg [15:0] arg_2);
         reg [0:0] or0;
         reg [17:0] or1;
         reg [0:0] or2;
         reg [0:0] or3;
         reg [0:0] or4;
         reg [0:0] or5;
         reg [15:0] or6;
         reg [15:0] or7;
         reg [0:0] or8;
         reg [0:0] or9;
         reg [15:0] or10;
         reg [15:0] or11;
         reg [15:0] or12;
         reg [31:0] or13;
         reg [1:0] or14;
         localparam ol0 = 1'b1;
         localparam ol1 = 1'b0;
         localparam ol2 = 16'b0000000000000000;
         localparam ol3 = 1'b1;
         localparam ol4 = 16'b0000000000000000;
         begin
            or14 = arg_0;
            or1 = arg_1;
            or6 = arg_2;
            or0 = or1[0:0];
            or2 = or0 == ol0;
            or3 = or1[1:1];
            or4 = or3 == ol1;
            or5 = or2 & or4;
            or7 = or5 ? or6 : ol2;
            or8 = or1[1:1];
            or9 = or8 == ol3;
            or10 = or1[17:2];
            or11 = or9 ? or10 : or6;
            or12 = ol4;
            or12[15:0] = or11;
            or13 = {or12, or7};
            kernel_register_kernel = or13;
         end
   endfunction
endmodule
module top_T1_memory(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000101;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000101;
      end else begin
         o <= i;
      end
   end
endmodule
module top_T2(input wire [1:0] clock_reset, input wire [17:0] i, output wire [15:0] o);
   wire [31:0] od;
   wire [15:0] d;
   wire [15:0] q;
   assign o = od[15:0];
   top_T2_memory c0(.clock_reset(clock_reset), .i(d[15:0]), .o(q[15:0]));
   assign d = od[31:16];
   assign od = kernel_register_kernel(clock_reset, i, q);
   function [31:0] kernel_register_kernel(input reg [1:0] arg_0, input reg [17:0] arg_1, input reg [15:0] arg_2);
         reg [0:0] or0;
         reg [17:0] or1;
         reg [0:0] or2;
         reg [0:0] or3;
         reg [0:0] or4;
         reg [0:0] or5;
         reg [15:0] or6;
         reg [15:0] or7;
         reg [0:0] or8;
         reg [0:0] or9;
         reg [15:0] or10;
         reg [15:0] or11;
         reg [15:0] or12;
         reg [31:0] or13;
         reg [1:0] or14;
         localparam ol0 = 1'b1;
         localparam ol1 = 1'b0;
         localparam ol2 = 16'b0000000000000000;
         localparam ol3 = 1'b1;
         localparam ol4 = 16'b0000000000000000;
         begin
            or14 = arg_0;
            or1 = arg_1;
            or6 = arg_2;
            or0 = or1[0:0];
            or2 = or0 == ol0;
            or3 = or1[1:1];
            or4 = or3 == ol1;
            or5 = or2 & or4;
            or7 = or5 ? or6 : ol2;
            or8 = or1[1:1];
            or9 = or8 == ol3;
            or10 = or1[17:2];
            or11 = or9 ? or10 : or6;
            or12 = ol4;
            or12[15:0] = or11;
            or13 = {or12, or7};
            kernel_register_kernel = or13;
         end
   endfunction
endmodule
module top_T2_memory(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_alu(input wire [1:0] clock_reset, input wire [37:0] i, output wire [17:0] o);
   wire [17:0] od;
   ;
   ;
   assign o = od[17:0];
   assign od = kernel_alu(clock_reset, i);
   function [17:0] kernel_alu(input reg [1:0] arg_0, input reg [37:0] arg_1);
         reg [0:0] or0;
         reg [37:0] or1;
         reg [0:0] or2;
         reg [15:0] or3;
         reg [15:0] or4;
         reg [15:0] or5;
         reg [15:0] or6;
         reg [17:0] or7;
         reg [17:0] or8;
         reg [17:0] or9;
         reg [1:0] or10;
         localparam ol0 = 1'b1;
         localparam ol1 = 16'b0000000000000000;
         localparam ol2 = 18'b000000000000000000;
         localparam ol3 = 1'b0;
         localparam ol4 = 1'b0;
         begin
            or10 = arg_0;
            or1 = arg_1;
            or0 = or1[37:37];
            or2 = or0 == ol0;
            or3 = or1[15:0];
            or4 = or1[31:16];
            or5 = or3 + or4;
            or6 = or2 ? or5 : ol1;
            or7 = ol2;
            or7[15:0] = or6;
            or8 = or7;
            or8[17:17] = ol3;
            or9 = or8;
            or9[16:16] = ol4;
            kernel_alu = or9;
         end
   endfunction
endmodule
module top_regs(input wire [1:0] clock_reset, input wire [20:0] i, output wire [15:0] o);
   wire [143:0] od;
   wire [127:0] d;
   wire [127:0] q;
   assign o = od[15:0];
   top_regs_registers c0(.clock_reset(clock_reset), .i(d[127:0]), .o(q[127:0]));
   assign d = od[143:16];
   assign od = kernel_register_file_kernel(clock_reset, i, q);
   function [143:0] kernel_register_file_kernel(input reg [1:0] arg_0, input reg [20:0] arg_1, input reg [127:0] arg_2);
         reg [127:0] or0;
         reg [2:0] or1;
         reg [20:0] or2;
         reg [0:0] or3;
         reg [0:0] or4;
         reg [15:0] or5;
         // d
         reg [127:0] or6;
         reg [0:0] or7;
         reg [0:0] or8;
         reg [15:0] or9;
         reg [15:0] or10;
         // d
         reg [127:0] or11;
         reg [15:0] or12;
         // d
         reg [127:0] or13;
         reg [15:0] or14;
         reg [127:0] or15;
         reg [143:0] or16;
         reg [1:0] or17;
         localparam ol0 = 1'b1;
         localparam ol1 = 1'b1;
         localparam ol2 = 16'b0000000000000000;
         localparam ol3 = 16'b0000000000000000;
         localparam ol4 = 3'b000;
         localparam ol5 = 16'b0000000000000000;
         localparam ol6 = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
         begin
            or17 = arg_0;
            or2 = arg_1;
            or0 = arg_2;
            or1 = or2[20:18];
            or3 = or2[1:1];
            or4 = or3 == ol0;
            or5 = or2[17:2];
            or6 = or0;
            or6[15:0] = or5;
            or7 = or2[0:0];
            or8 = or7 == ol1;
            or9 = or0[15:0];
            or10 = or8 ? or9 : ol2;
            or11 = or4 ? or6 : or0;
            or12 = or4 ? ol3 : or10;
            case (or1)
               3'b000 : or13 = or11;
               default : or13 = or0;
            endcase
            case (or1)
               3'b000 : or14 = or12;
               default : or14 = ol5;
            endcase
            or15 = ol6;
            or15[127:0] = or13;
            or16 = {or15, or14};
            kernel_register_file_kernel = or16;
         end
   endfunction
endmodule
module top_regs_registers(input wire [1:0] clock_reset, input wire [127:0] i, output wire [127:0] o);
   top_regs_registers_0 c0(.clock_reset(clock_reset), .i(i[15:0]), .o(o[15:0]));
   top_regs_registers_1 c1(.clock_reset(clock_reset), .i(i[31:16]), .o(o[31:16]));
   top_regs_registers_2 c2(.clock_reset(clock_reset), .i(i[47:32]), .o(o[47:32]));
   top_regs_registers_3 c3(.clock_reset(clock_reset), .i(i[63:48]), .o(o[63:48]));
   top_regs_registers_4 c4(.clock_reset(clock_reset), .i(i[79:64]), .o(o[79:64]));
   top_regs_registers_5 c5(.clock_reset(clock_reset), .i(i[95:80]), .o(o[95:80]));
   top_regs_registers_6 c6(.clock_reset(clock_reset), .i(i[111:96]), .o(o[111:96]));
   top_regs_registers_7 c7(.clock_reset(clock_reset), .i(i[127:112]), .o(o[127:112]));
endmodule
module top_regs_registers_0(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_1(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_2(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_3(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_4(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_5(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_6(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
module top_regs_registers_7(input wire [1:0] clock_reset, input wire [15:0] i, output reg [15:0] o);
   wire  clock;
   wire  reset;
   assign clock = clock_reset[0];
   assign reset = clock_reset[1];
   initial begin
      o = 16'b0000000000000000;
   end
   always @(posedge clock) begin
      if (reset) begin
         o <= 16'b0000000000000000;
      end else begin
         o <= i;
      end
   end
endmodule
