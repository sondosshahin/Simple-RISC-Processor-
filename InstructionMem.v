module instruction_memory(
    input wire [31:0] address, // Address input
    output reg [31:0] data_out // Instruction output
);
	
	// Parameter for memory depth
	parameter MEM_DEPTH = 1024;
	
	// Memory array
	reg [31:0] mem [0:MEM_DEPTH-1];
	
	// Asynchronous read from memory
	always @ (address) begin
	    data_out = mem[address[31:2]]; // Word-aligned access
	end
	
	
	initial begin
	    // Fill the memory with no-operation (NOP) instructions initially
	    integer i;
	    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
	        mem[i] = 32'h00000000; // NOP instruction code
	    end
	   
	end

endmodule
