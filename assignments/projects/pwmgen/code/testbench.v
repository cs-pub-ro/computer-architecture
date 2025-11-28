`default_nettype none
`timescale 1ns/1ns

module tb_top_system;

    reg  clk;        
    reg  rst_n;

    reg  tb_mosi;   
    wire tb_miso;    
    reg  sclk;      
    reg  cs_n;       

    wire pwm_out;

    reg[7:0] counter_lsb;

    top dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .sclk   (sclk),
        .cs_n   (cs_n),
        .miso   (tb_mosi),
        .mosi   (tb_miso),
        .pwm_out(pwm_out)
    );

    localparam CLK_HALF   = 50;  
    localparam SCLK_HALF  = 50;   

    localparam [5:0] REG_PERIOD        = 6'h00;
    localparam [5:0] REG_COUNTER_EN    = 6'h02;
    localparam [5:0] REG_COMPARE1      = 6'h03;
    localparam [5:0] REG_COMPARE2      = 6'h05;
    localparam [5:0] REG_COUNTER_RESET = 6'h07;
    localparam [5:0] REG_COUNTER_VAL   = 6'h08;
    localparam [5:0] REG_PRESCALE      = 6'h0A;
    localparam [5:0] REG_UPNOTDOWN     = 6'h0B;
    localparam [5:0] REG_PWM_EN        = 6'h0C;
    localparam [5:0] REG_FUNCTIONS     = 6'h0D;

    localparam [1:0] FUNCTION_ALIGN_LEFT             = 2'b00;
    localparam [1:0] FUNCTION_ALIGN_RIGHT            = 2'b01;
    localparam [1:0] FUNCTION_RANGE_BETWEEN_COMPARES = 2'b10;

    initial begin
        clk = 1'b0;
        forever #(CLK_HALF) clk = ~clk;
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top_system);
    end

    task apply_reset;
        begin
            rst_n  = 1'b0;
            cs_n   = 1'b1;
            sclk   = 1'b0;
            tb_mosi = 1'b0;
            #(10*CLK_HALF); 
            rst_n  = 1'b1;
            #(5*CLK_HALF);
            $display("Time %0t: Reset deasserted.", $time);
        end
    endtask

    task spi_transfer_byte;
        input  [7:0] tx;
        output [7:0] rx;
        integer i;
        begin
            rx = 8'h00;
            for (i = 7; i >= 0; i = i - 1) begin
                tb_mosi = tx[i];
                #(SCLK_HALF);
                sclk = 1'b1;           
                #(SCLK_HALF/2);
                rx[i] = tb_miso;      
                #(SCLK_HALF/2);
                sclk = 1'b0;
            end
        end
    endtask

    task spi_write_reg;
        input  [5:0] addr;
        input  [7:0] data;
        reg    [7:0] cmd;
        reg    [7:0] dummy;
        begin
            cmd = {1'b1, 1'b1, addr};   
            #(SCLK_HALF);
            cs_n = 1'b0;

            spi_transfer_byte(cmd, dummy);
            spi_transfer_byte(data, dummy);

            #(SCLK_HALF);
            cs_n = 1'b1;

            $display("Time %0t: SPI WRITE  addr=0x%02h  data=0x%02h", $time, addr, data);
            #(4*CLK_HALF); 
        end
    endtask

    task spi_read_reg;
        input  [5:0] addr;
        output [7:0] data;
        reg    [7:0] cmd;
        reg    [7:0] rx;
        begin
            cmd = {1'b0, 1'b1, addr};   
            #(SCLK_HALF);
            cs_n = 1'b0;

            spi_transfer_byte(cmd, rx);           
            spi_transfer_byte(8'h00, data);     

            #(SCLK_HALF);
            cs_n = 1'b1;

            $display("Time %0t: SPI READ   addr=0x%02h  data=0x%02h", $time, addr, data);
            #(4*CLK_HALF);
        end
    endtask

    task check_pwm_duty;
        input integer period_val;
        input integer high_per_period;
        input integer num_periods;
        integer total_ticks;
        integer high_count;
        integer i;
        integer exp;
        begin
            total_ticks = (period_val + 1) * num_periods;
            exp         = high_per_period * num_periods;
            high_count  = 0;

            #(5*CLK_HALF);

            for (i = 0; i < total_ticks; i = i + 1) begin
                @(posedge clk);
                if (pwm_out)
                    high_count = high_count + 1;
            end

            if ((high_count >= exp-1) && (high_count <= exp+1)) begin
                $display("[PASS] PWM duty aprox. corect: high=%0d, expected ~%0d", 
                         high_count, exp);
            end else begin
                $display("[FAIL] PWM duty incorect: high=%0d, expected %0d", 
                         high_count, exp);
            end
        end
    endtask

    initial begin
        $display("--- Starting Testbench ---");

        rst_n   = 1'b0;
        cs_n    = 1'b1;
        sclk    = 1'b0;
        tb_mosi = 1'b0;

        apply_reset();

        spi_write_reg(REG_PERIOD,       8'd7);
        spi_write_reg(REG_PRESCALE,     8'd0);
        spi_write_reg(REG_COMPARE1,     8'd3);
        spi_write_reg(REG_COUNTER_EN,   8'd1);
        spi_write_reg(REG_PWM_EN,       8'd1);
        spi_write_reg(REG_FUNCTIONS,    {6'b0, FUNCTION_ALIGN_LEFT});

        spi_write_reg(REG_COUNTER_RESET, 8'd1);
        spi_write_reg(REG_COUNTER_RESET, 8'd0);

        $display("\n--- Test 1: PWM ALIGN_LEFT, compare1=3, period=7 ---");
        check_pwm_duty(7, 4, 5); 


        spi_read_reg(REG_COUNTER_VAL, counter_lsb);

        $display("\n--- Test 2: PWM RANGE_BETWEEN_COMPARES, c1=2, c2=6 ---");
        spi_write_reg(REG_COMPARE1, 8'd2);
        spi_write_reg(REG_COMPARE2, 8'd6);
        spi_write_reg(REG_FUNCTIONS, {6'b0, FUNCTION_RANGE_BETWEEN_COMPARES});

        check_pwm_duty(7, 4, 5); 

        $display("\n--- Test 3: PWM ALIGN_RIGHT, compare1=5 ---");
        spi_write_reg(REG_COMPARE1, 8'd5);
        spi_write_reg(REG_FUNCTIONS, {6'b0, FUNCTION_ALIGN_RIGHT});

        check_pwm_duty(7, 3, 5); 

        $display("\n--- Test 4: PWM UNALIGNED EDGE CASE EQUAL COMPARES ---");
        spi_write_reg(REG_COUNTER_EN, 8'h00);
        spi_write_reg(REG_COMPARE1, 8'h05);
        spi_write_reg(REG_COMPARE2, 8'h05);
        spi_write_reg(REG_COUNTER_EN, 8'h01);
        check_pwm_duty(7, 0, 2);
        
        $display("\n--- Test 5: PWM NOT TRIGGER AT START, compare1=0 ---");
        spi_write_reg(REG_COUNTER_EN, 8'h00);
        spi_write_reg(REG_COMPARE1, 8'h00);
        spi_write_reg(REG_FUNCTIONS, 8'h00);
        spi_write_reg(REG_COUNTER_EN, 8'h01);
        check_pwm_duty(7, 0, 3);

        $display("\n--- Finished Testbench ---");
        $finish;
    end

endmodule

`default_nettype wire