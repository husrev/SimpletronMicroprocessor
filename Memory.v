`timescale 1ns / 1ps
module Memory(
    input clk,
	 input reset,
    input write,
    input [4:0] address,
    input [7:0] data_in,
    output [7:0] data_out 
    );
	reg [7:0] r[0:31];
	always @(posedge clk, posedge reset)
	if(reset)
	begin
			r[0] = 8'b11011101; // load c
			r[1] = 8'b01001001; // branchifacc @9
			r[2] = 8'b11011100; // load d
			r[3] = 8'b10011110; // add a
			r[4] = 8'b11111100; // store d
			r[5] = 8'b11011111; // load b
			r[6] = 8'b10111101; // subtract c
			r[7] = 8'b11111111; // store b
			r[8] = 8'b00100001; // branch @1
			r[9] = 8'b00000000; // halt
			r[10] = 8'b00000000;
			r[11] = 8'b00000000;
			r[12] = 8'b00000000;
			r[13] = 8'b00000000;
			r[14] = 8'b00000000;
			r[15] = 8'b00000000;	
			r[16] = 8'b00000000;
			r[17] = 8'b00000000; 
			r[18] = 8'b00000000;
			r[19] = 8'b00000000;
			r[20] = 8'b00000000;
			r[21] = 8'b00000000;
			r[22] = 8'b00000000;
			r[23] = 8'b00000000;
			r[24] = 8'b00000000;
			r[25] = 8'b00000000;
			r[26] = 8'b00000000;
			r[27] = 8'b00000000;
			r[28] = 8'b00000000; // d=0
			r[29] = 8'b00000001; // c=1
			r[30] = 8'b00001010; // a=10
			r[31] = 8'b00001111; // b=15
	end
	else
		if(write)
			r[address] = data_in;

assign data_out = r[address];
		

endmodule
