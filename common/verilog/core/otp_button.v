module otp_button (
    output wire o_w_button_press,
    input wire i_w_clk,
    input wire i_w_button
);

    localparam l_p_state_ButtonReleased = 2'd0;
    localparam l_p_state_ButtonFirstPressed = 2'd1;
    localparam l_p_state_ButtonPressed = 2'd2;

    reg [1:0] l_r_state;
    reg [1:0] l_r_next_state;

    always @(posedge i_w_clk) begin
        l_r_state <= l_r_next_state;
    end

    always @(*) begin
        l_r_next_state = l_p_state_ButtonReleased;
        case(l_r_state)
        l_p_state_ButtonReleased: begin
            if (i_w_button)
                l_r_next_state = l_p_state_ButtonFirstPressed;
            else
                l_r_next_state = l_p_state_ButtonReleased;
        end
        l_p_state_ButtonFirstPressed: begin
            l_r_next_state = l_p_state_ButtonPressed;
        end
        l_p_state_ButtonPressed: begin
            if (i_w_button)
                l_r_next_state = l_p_state_ButtonPressed;
            else
                l_r_next_state = l_p_state_ButtonReleased;
        end
        default: l_r_next_state = l_p_state_ButtonReleased;
        endcase
    end
    
    assign o_w_button_press = (l_r_state == l_p_state_ButtonFirstPressed);

endmodule