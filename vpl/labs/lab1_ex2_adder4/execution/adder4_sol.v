/** Full adder can be also copied here, instead of importing it inside the project*/
module half_adder(
    output sum,
    output c_out,   // carry out
    input  a,
    input  b);

	xor X1 (sum,a,b);
	and A1 (c_out,a,b);

endmodule

module full_adder(
    output sum,
    output c_out,   // carry out
    input  a,
    input  b,
    input  c_in);    // carry in
    

	half_adder h1 (s1, c1, a, b);
	half_adder h2 (sum, c2, c_in, s1);
	or (c_out,c1,c2);
endmodule


module adder4(
	output [3:0] sum,
    output c_out,	     
    input  [3:0] a, b);       //operands

	full_adder ADD1 (sum[0], c_in1,a[0],b[0],'b0);
	full_adder ADD2 (sum[1], c_in2,a[1],b[1],c_in1);
	full_adder ADD3 (sum[2], c_in3,a[2],b[2],c_in2);
	full_adder ADD4 (sum[3], c_out,a[3],b[3],c_in3);

endmodule
