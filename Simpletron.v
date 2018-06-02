`timescale 1ns / 1ps
// Simpletron 2.0 8-bit microprocessor
// 8 instructions: HALT, BRANCH, BRIFACC, BRIFOVF, ADD, SUBTRACT, LOAD, STORE encoded in 3-bit respectively
// 5-bit program memory adressing: requires 32-word memory
// 5 1-bit state registers, 1-bit overflow register, 8-bit accumulator, 5-bit ADDress buffer, 5-bit program counter (24 bit total)
// Muhammed Husrev Cilasun @ Istanbul Technical University, 2014
module Simpletron( 
	input clk, 
	input reset, 
	input [7:0] data_in, 
	output [13:0] data_out
);

reg haltstate, overflow, af, sf, ldf, stf; // State Registers
reg [4:0] pc; // Program Counter
reg [4:0] adbuff; // Data_Out Address Buffer
reg [7:0] acc; // Accumulator

//-------------INSTRUCTION SET-------------//
localparam [2:0] HALT = 3'b000, 
					  BRANCH = 3'b001,	
					  BRIFACC = 3'b010,
					  BRIFOVF = 3'b011,
					  ADD = 3'b100,
					  SUBTRACT = 3'b101, 
					  LOAD = 3'b110,
					  STORE = 3'b111;
//-----------------------------------------//				  
always @(posedge clk,posedge reset)
if(reset) 
begin // This determines the reset conditions.
	haltstate = 1'b0; 
	overflow = 1'b0; 
	af = 1'b0; 
	sf = 1'b0; 
	ldf = 1'b0; 
	stf = 1'b0; 
	pc = 5'b00000; 
	acc = 8'b00000000; 
	adbuff = 5'b00000; 
end
else
	if(~haltstate) // Once haltstate flag is activated, execution stops.
		if(af) // Check if the add flag is active
			begin 
				{overflow,acc} = acc+data_in; // Add data_in with the accumulator
				af = 1'b0; // Deactivate the add flag
				adbuff = pc; 
			end
		else if(sf) // Check if the subtract flag is active
			begin 
				overflow = acc < data_in; // Set overflow flag active if necessary
				acc = acc-data_in; sf = 1'b0; // Subtract data_in from the accumulator
				sf = 1'b0; // Deactivate the subtract flag
				adbuff = pc; 
			end 
		else if(ldf) // Check if the load flag is active
			begin 
				acc = data_in; // Forward received data to the accumulator
				ldf = 1'b0; // Deactivate the load flag
				adbuff = pc; 
			end
		else if(stf) // Check if the store flag is active
			begin   
				stf = 1'b0; // Deactivate the store flag
				adbuff = pc; 
			end
		else  // If no flag is activated, then the instruction decoder decodes data_in[7:5]
			case(data_in[7:5])    
			HALT: 
				begin 
					haltstate = 1; // Activate haltstate flag
					adbuff = 5'b00000; 
					pc = 5'b00000; 
				end
			BRANCH: 
				begin 
					adbuff = data_in[4:0]; // set address buffer to the incoming address
					pc = data_in[4:0]; // set program counter to the incoming address
				end
			BRIFACC: 
				if(acc==8'h00) // check if accumulator is empty
					begin  
						adbuff = data_in[4:0]; // set address buffer to the incoming address
						pc = data_in[4:0]; // set program counter to the incoming address
					end 
				else 
					begin 
						pc = pc+1;
						adbuff = pc; 
					end 
			BRIFOVF: 
				if(overflow) // check if there is overflow
					begin 
						adbuff = data_in[4:0]; // set address buffer to the incoming address
						pc = data_in[4:0]; // set program counter to the incoming address
					end
				else 
					begin 
						pc = pc+1; 
						adbuff = pc; 
					end 
			ADD: 
				begin 
					af = 1'b1; // Activate the add flag
					adbuff = data_in[4:0]; 
					pc = pc+1;
				end
			SUBTRACT: 
				begin 
					sf = 1'b1; // Activate the subtract flag
					adbuff = data_in[4:0]; 
					pc = pc+1;
				end
			LOAD: 
				begin 
					ldf = 1'b1; // Activate the load flag
					adbuff = data_in[4:0]; 
					pc = pc+1;
				end 
			STORE: 
				begin 
					stf = 1'b1; // Activate the store flag
					adbuff = data_in[4:0]; 
					pc = pc+1;
				end
			endcase 
			
assign data_out = {stf,adbuff,acc}; // 14-bit output: 1-write bit, 5 address bits, 8 data bits
endmodule
