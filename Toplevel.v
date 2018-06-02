`timescale 1ns / 1ps

module Toplevel(
    input clk,
	 input reset
    );
wire [7:0] m_to_s;
wire [13:0] s_to_m;
Memory MyMemory(.clk(clk), .reset(reset), .write(s_to_m[13]), .address(s_to_m[12:8]), .data_in(s_to_m[7:0]), .data_out(m_to_s));
Simpletron MyCPU(.clk(clk), .reset(reset), .data_in(m_to_s), .data_out(s_to_m));
endmodule
