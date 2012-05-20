`timescale 1ns / 1ps

module testLcd_controller;

	// Inputs
	reg rst;
	reg clk;
	reg [7:0] data_in;
	reg strobe_in;
	reg [7:0] period_clk_ns;

	// Outputs
	wire lcd_e;
	wire [3:0] lcd_nibble;
	wire lcd_rs;
	wire lcd_rw;
	wire disable_flash;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	lcd_controller uut (
		.rst(rst), 
		.clk(clk), 
		.data_in(data_in), 
		.strobe_in(strobe_in), 
		.period_clk_ns(period_clk_ns), 
		.lcd_e(lcd_e), 
		.lcd_nibble(lcd_nibble), 
		.lcd_rs(lcd_rs), 
		.lcd_rw(lcd_rw), 
		.disable_flash(disable_flash), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		data_in = 0;
		strobe_in = 0;
		period_clk_ns = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

