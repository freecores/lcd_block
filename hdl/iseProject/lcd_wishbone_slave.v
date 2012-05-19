`timescale 1ns / 1ps
/*
	Wishbone slave 
	(Verilog 2001)
*/
module lcd_wishbone_slave(
    input RST_I,
    input CLK_I,
    input [1:0] ADR_I0,
    input DAT_I0,
    output [7:0] DAT_O0,
    input WE_I,
    input SEL_I0,
    input STB_I,
    output ACK_O,
    input CYC_I
    );


endmodule
