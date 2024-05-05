//-----------------------------------------------------------------------------
//
// Title       : RegFile
// Design      : arch_project
// Author      : sondos
// Company     : Birziet University
//

`timescale 1 ns / 1 ps

//Register File   array of 16 32-bit register
module RegFile (clk, Rd, Rs1, Rs2, regWR, Rbus1, Rbus2, Wbus1, Wbus2);	
		// clock
	input wire clk;

    // enable write signal
	input wire regWR;

    // register selection buses
	input wire [3:0] Rd, Rs1, Rs2;	  //?
    
    // data read buses
	output reg [31:0] Rbus1, Rbus2;

    // data write buses
	input wire [31:0] Wbus1, Wbus2;	
	
	//-------register file initialization----------	
	
	reg [31:0] registers_array [0:15]; 	  
	
	initial begin
		registers_array[0] <= 32'h00000000;
		registers_array[1] <= 32'h00000000;
		registers_array[2] <= 32'h00000000;
		registers_array[3] <= 32'h00000000;
		registers_array[4] <= 32'h00000000;
		registers_array[5] <= 32'h00000000;
		registers_array[6] <= 32'h00000000;		
		registers_array[7] <= 32'h00000000;		
		registers_array[8] <= 32'h00000000;
		registers_array[9] <= 32'h00000000;
		registers_array[10] <= 32'h00000000;
		registers_array[11] <= 32'h00000000;
		registers_array[12] <= 32'h00000000;
		registers_array[13] <= 32'h00000000;
		registers_array[14] <= 32'h00000000;
		registers_array[15] <= 32'h00000000;
	end
	
	
	// read registers always
	always @(posedge clk) begin
		
		Rbus1 = registers_array[Rs1];
		Rbus2 = registers_array[Rs2];
		
	end

	always @(posedge clk) begin
		
		if ( Rd != 5'b0 ) begin // write register is not R0
			registers_array[Rd] = Wbus1;
		end	
		    registers_array[Rs1] = Wbus2;
		
	end

endmodule  
