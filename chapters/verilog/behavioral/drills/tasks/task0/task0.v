module task0 #(
    parameter p_width = 1
) (
    output wire [(p_width*2):0] o_w_p,
    input wire [p_width:0] i_w_a,
    input wire [p_width:0] i_w_b
);

    //TODO 1: implement multiplier
    integer i;
    reg [(p_width*2):0] l_r_prod;

    always @(*) begin
        l_r_prod = 0;
        for(i = 0; i < p_width; i=i+1) begin
            if(i_w_b[i])
                l_r_prod = l_r_prod + (i_w_a << i);
        end
    end

    assign o_w_p = l_r_prod;
endmodule