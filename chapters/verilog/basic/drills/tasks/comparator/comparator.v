<<<<<<< HEAD
module comparator(
    output wire o_w_lt,
    output wire o_w_gt,
    output wire o_w_eq,
    input wire i_w_a,
    input wire i_w_b
);

    //TODO 4.1: Implement 

    // lt = less than
    // gt = greater than
    // eq =  equals

    wire l_w_nota, l_w_notb;
    not (l_w_nota, i_w_a);
	not (l_w_notb, i_w_b);
	and (o_w_lt, l_w_nota, i_w_b);
	and (o_w_gt, i_w_a, l_w_notb);
	xnor (o_w_eq, i_w_a, i_w_b);

=======
module comparator(
    output wire o_w_lt,
    output wire o_w_gt,
    output wire o_w_eq,
    input wire i_w_a,
    input wire i_w_b
);

    //TODO 4.1: Implement 
    wire l_w_nota, l_w_notb;
    not (l_w_nota, i_w_a);
	not (l_w_notb, i_w_b);
	and (o_w_lt, l_w_nota, i_w_b);
	and (o_w_gt, i_w_a, l_w_notb);
	xnor (o_w_eq, i_w_a, i_w_b);

>>>>>>> 25c1bf4da332f96c33dbd18ef8e81ed39b813770
endmodule