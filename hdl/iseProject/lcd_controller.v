`timescale 1ns / 1ps

module lcd_controller(
    input rst,
    input clk,
    input [7:0] data_in,
    input strobe_in,
    input [7:0] period_clk_ns,
    output lcd_e,
    output [3:0] lcd_nibble,
    output lcd_rs,
    output lcd_rw,
    output disable_flash,
    output done
    );

	// States for FSM that initialize the LCD
	localparam lcd_init_rst = 1;
	localparam lcd_init_wait = 2;	
	localparam lcd_init_write_03_01 = 3;
	localparam lcd_init_wait_4ms = 4;
	localparam lcd_init_write_03_02 = 5;
	localparam lcd_init_wait_100us = 6;
	localparam lcd_init_write_03_03 = 7;
	localparam lcd_init_wait_40us = 8;
	localparam lcd_init_write_02 = 9;
	localparam lcd_init_wait_50us = 10;
	localparam lcd_init_strobe = 11;
	reg [3:0] lcd_init_states, lcd_init_state_next; // Declare two variables of 4 bits to hold the FSM states
	reg [19:0] counter_wait_lcd_init;
	reg [7:0] counter_wait_strobe_lcd_init;
	reg [19:0] time_wait_lcd_init;
	reg [3:0] lcd_init_data_out;  // FSM output LCD_DATA
	reg lcd_init_e_out;           // FSM output LCD_E
	reg lcd_init_done;
	
	// States for FSM that send data to LCD
	localparam lcd_data_rst = 1;
	localparam lcd_data_wait = 2;
	localparam lcd_data_wr_nibble_high = 3;
	localparam lcd_data_wr_nibble_low = 4;	
	localparam lcd_data_strobe = 5;
	reg [3:0] lcd_data_states, lcd_data_state_next;	// Declare two variables of 4 bits to hold the FSM states
	reg [3:0] lcd_data_data_out;	// FSM output LCD_DATA
	reg lcd_data_e_out;				// FSM output LCD_E
	
	
	/*
		Initialize LCD...
	*/
	always @ (posedge clk)
	begin
		if (rst)	// Reset synchronous
			begin
				lcd_init_states <= lcd_init_rst;
				counter_wait_lcd_init <= 0;
				counter_wait_strobe_lcd_init <= 0;
				lcd_init_e_out <= 0;
				lcd_init_done <= 0;
			end
		else
			begin
				case (lcd_init_states)
					lcd_init_rst:
						begin
							// Wait for 15ms to power-up LCD
							time_wait_lcd_init <= 15000000;
							lcd_init_states <= lcd_init_wait;
							lcd_init_state_next <= lcd_init_write_03_01;
						end
					
					// Wait for a configured time in (ns) and go to other state in (lcd_init_state_next)
					lcd_init_wait:
						begin
							counter_wait_lcd_init <= counter_wait_lcd_init + period_clk_ns;
							if (counter_wait_lcd_init > time_wait_lcd_init)
								lcd_init_states <= lcd_init_state_next;
						end
					
					// Strobe the LCD for at least 240 ns
					lcd_init_strobe:
						begin
							lcd_init_e_out = 1;
							counter_wait_strobe_lcd_init <= counter_wait_strobe_lcd_init + period_clk_ns;
							if (counter_wait_strobe_lcd_init > 240)
								begin
									lcd_init_states <= lcd_init_state_next;
									lcd_init_e_out <= 0;
								end
						end
					
					lcd_init_write_03_01:
						// Send 0x3 and pulse LCD_E for 240ns 
						begin
							lcd_init_data_out <= 4'h3;
							lcd_init_states <= lcd_init_strobe;	// Strobe for at least 230 ns						
							lcd_init_state_next <= lcd_init_wait_4ms;							
						end
					
					lcd_init_wait_4ms:
						begin
							time_wait_lcd_init <= 4100000;	// Wait for 4.1ms
							lcd_init_states <= lcd_init_wait;
							lcd_init_state_next <= lcd_init_write_03_02;
						end
					
					lcd_init_write_03_02:
						// Send 0x3 and pulse LCD_E for 240ns 
						begin
							lcd_init_data_out <= 4'h3;
							lcd_init_states <= lcd_init_strobe;	// Strobe for at least 230 ns						
							lcd_init_state_next <= lcd_init_wait_100us;							
						end
					
					lcd_init_wait_100us:
						begin
							time_wait_lcd_init <= 100000;	// Wait for 100us
							lcd_init_states <= lcd_init_wait;
							lcd_init_state_next <= lcd_init_write_03_03;
						end
					
					lcd_init_write_03_03:
						// Send 0x3 and pulse LCD_E for 240ns 
						begin
							lcd_init_data_out <= 4'h3;
							lcd_init_states <= lcd_init_strobe;	// Strobe for at least 230 ns						
							lcd_init_state_next <= lcd_init_wait_40us;							
						end
					
					lcd_init_wait_40us:
						begin
							time_wait_lcd_init <= 100000;	// Wait for 100us
							lcd_init_states <= lcd_init_wait;
							lcd_init_state_next <= lcd_init_write_02;
						end
					
					lcd_init_write_02:
						// Send 0x3 and pulse LCD_E for 240ns 
						begin
							lcd_init_data_out <= 4'h2;
							lcd_init_states <= lcd_init_strobe;	// Strobe for at least 230 ns						
							lcd_init_state_next <= lcd_init_wait_50us;							
						end
					
					lcd_init_wait_50us:
						begin
							time_wait_lcd_init <= 100000;	// Wait for 100us
							lcd_init_states <= lcd_init_wait;
							lcd_init_state_next <= lcd_init_wait_50us;
							lcd_init_done <= 1;
						end
				endcase;
			end;
	end;
	
	assign lcd_e = lcd_init_e_out;
	assign lcd_nibble = lcd_init_data_out;
	
	/*
		FSM that deals to send data to the LCD (nibble High + nibble Low)
	*/
	always @ (posedge clk)
	begin
		if (~lcd_init_done)
			begin
			
			end
	end;

endmodule
