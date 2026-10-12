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
    
    half_adder H1 (s1, c1, a, b);
    half_adder H2 (sum, c2, c_in, s1);
    or (c_out,c1,c2);

endmodule
