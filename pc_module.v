// PC register and its logic

// PC src can be one of the following:
// 1- PC + 1
// 2- Branch target address BTA (if function is branch)
// 3- Jump target address (if instruction is J-Type: JMP, CALL)
// 4- top of stack address (if function is RET)

	
`include "constants.v"


module pc_module(clock, PC, I_TypeImmediate, J_TypeImmediate, topstack, sig_pc_src);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;
    
    // PC source signal
    input wire [1:0] sig_pc_src;

    // stack poped return address bus
    input wire [31:0] topstack;

    // extended I-Type immediate bus
    input wire [31:0] I_TypeImmediate;

    // extended J-Type immediate bus
    input wire signed [31:0] J_TypeImmediate;

    // ----------------- OUTPUTS -----------------

    // PC
    output reg [31:0] PC;

    // ----------------- INTERNALS -----------------

    // PC + 1
    wire [31:0] pc_plus_1;

    // JA
    wire [25:0] jump_address;

    // BTA
    wire [31:0] brach_target_address;
    
    assign pc_plus_1 = PC + 32'd1;
    assign jump_target_address = {PC[31:26], J_TypeImmediate};
    assign brach_target_address = PC + I_TypeImmediate;

    initial begin
		PC = 32'd0;
	end


    always @(posedge clock) begin
        case (sig_pc_src)
            pc_next: begin
                // default      : PC = PC + 1
                PC = pc_plus_1;      
            end  
            pc_topofstack:  begin
                // 		       : PC = top of stack
                PC = topstack;  
            end  
            pc_BTA: begin
                // Taken Branch : PC = PC + I_TypeImmediate
                PC = brach_target_address;
            end  
            pc_JA: begin
                // Jump         : PC = PC + J_TypeImmediate
                PC = jump_address;
            end  
        endcase
	end

    

endmodule			



module testPC();
	
	 wire clock; 
	 reg [31:0] pc;
	 
	 reg [1:0] pc_control; 
	 reg [31:0] I_TypeImmediate, J_TypeImmediate, topstack ;
	 pcModule pcmod (clock, pc, I_TypeImmediate, J_TypeImmediate, topstack, pc_control);
	
	ClockGenerator clock_generator(clock);
	initial begin
	   assign pc = 32'd0;   
	   assign pc_control = 2'b00;
	end
endmodule