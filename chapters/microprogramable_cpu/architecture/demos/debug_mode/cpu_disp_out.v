module cpu_disp_out #(
    parameter p_data_width = 16,
)(
    output [(p_data_width - 1):0] o_w_out;
    input [(p_data_width - 1):0] i_w_state_display;
    input [(p_data_width - 1):0] i_w_cram_addr_disp_out;
);


endmodule