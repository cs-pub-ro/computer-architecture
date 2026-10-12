module trecere(
    output p_rosu,          // red for pedestrians
    output p_verde,         // green for pedestrians
    output m_rosu,          // red for cars
    output m_galben,        // yellow for cars
    output m_verde,         // green for cars
    input clk);             // clock input

// counter used for light timings
wire [7:0] T;
counter c(done, T, clk);

fsm_trecere fsm(p_rosu, p_verde, m_rosu, m_galben, m_verde, T, done, clk);

endmodule
