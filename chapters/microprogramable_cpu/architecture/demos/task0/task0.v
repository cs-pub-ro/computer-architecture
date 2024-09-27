module task0#(
  parameter p_data_width = 16,
  parameter p_address_width = 10,
  parameter p_port_width = 8
)(
  input wire i_w_clk,
  input wire i_w_reset
);
    cpu #(
        .p_data_width(p_data_width),
        .p_address_width(p_address_width),
        .p_port_width(p_port_width)
    ) l_m_cpu (
        .i_w_clk(i_w_clk),
        .i_w_reset(i_w_reset),
        .i_w_io_out({p_data_width{1'b0}})
    );
endmodule