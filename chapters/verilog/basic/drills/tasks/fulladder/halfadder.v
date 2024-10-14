<<<<<<< HEAD
module halfadder (
    output wire o_w_s,
    output wire o_w_cout,
    input wire i_w_a,
    input wire i_w_b
);
    //TODO 0.1: Implement half-adder

    // In our codebase the variable names are composed of 3 components:
        // use_type_name where:
            // use can be i (input) o (output) or l (locals)
            // type can be w (wire) r (register) or m (module)
            // name is the variable name

    // sum   = a ^  b
    xor(o_w_s, i_w_a, i_w_b); 

    // c_out = a && b
    and(o_w_cout, i_w_a, i_w_b);

=======
module halfadder (
    output wire o_w_s,
    output wire o_w_cout,
    input wire i_w_a,
    input wire i_w_b
);
    //TODO 0.1: Implement half-adder
    xor(o_w_s, i_w_a, i_w_b); 
    and(o_w_cout, i_w_a, i_w_b);

>>>>>>> 25c1bf4da332f96c33dbd18ef8e81ed39b813770
endmodule