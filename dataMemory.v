`include "constants.v"	
module dataMemory( clk,memRead, memWrite,address,Data_in,Data_out,opcode); 
    input wire clk;
    input wire memRead;
    input wire memWrite;
    input wire [31:0] address;
	input wire [31:0] opcode;
    input wire [31:0] Data_in;
    output reg [31:0] Data_out ;
    reg [31:0] memory [0:255]; // 256 words of 32-bit memory 
	reg [31:0] sp ;

   always @(posedge clk ) begin 
	  if (opcode == PUSH) begin	  
		      memory[sp] <= Data_in;
              sp <= sp + 1;
         end else  if (opcode == POP) begin
              sp <= sp - 1;
              Data_out <= memory[sp];
          end	 
	
	end
	
	always @(posedge clk) begin
        if (memWrite) begin
            memory[address[31:2]] <= Data_in; // Word-aligned write
        end
    end

    always @(posedge clk) begin
        if (memRead) begin
            Data_out <= memory[address[31:2]]; // Word-aligned read
        end
    end
endmodule