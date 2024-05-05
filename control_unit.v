`include "constants.v"

module control_unit (clock, regWr, AluOp, AluSrc, Ext, Wresult, Bw2,
	MemRd, MemWr, pc_control, DMadd, DMdata, SP, opcode);
	
	input wire clock;
	input wire [5:0] opcode;
	
	//mux's control signals
	output reg Wresult, DMadd, DMdata, SP, AluSrc, Bw2;
	output reg [1:0] pc_control;
	
	
	//functional units control signals
	output reg MemRd, MemWr, Ext, regWr;
	output reg [1:0]AluOp;	   
	
	
	//pc source control
	always@(posedge clock) begin 
		if (opcode == RET) begin	
			pc_control = pc_topofstack;
		end	else if (opcode == JMP || opcode == CALL) begin
			pc_control = pc_JA;
		end else if (opcode == BEQ || opcode == BNE || opcode == BGT || opcode == BLT) begin 	//comparision result??
			pc_control = pc_BTA;
		end else begin
			pc_control = pc_next; 
		end
	end	 
	
	
	// alu source control
	always@(posedge clock) begin  
		if (opcode == AND || opcode == ADD || opcode == SUB ) begin
			AluSrc = ALU_srcReg;
		end else if (opcode == ANDI || opcode == ADDI || opcode == LW || opcode == LW_POI || opcode == SW || opcode == BGT
				|| opcode == BLT || opcode == BEQ || opcode == BNE) begin
			AluSrc = ALU_srcImm;
		end
	end
	
	
	// alu operation control
	always@(posedge clock) begin   
		if (opcode == AND || opcode == ANDI)begin
			AluOp = ALU_And;
		end else if (opcode == SUB)begin 
			AluOp = ALU_Sub;
		end else begin 
			AluOp = ALU_Add;
		end
	end	
	
	//extender control
	always@(posedge clock) begin 
		if (opcode == ADDI || opcode == ANDI) begin
			Ext = unsighned_ext;
		end else begin
			Ext = sighned_ext;
		end
	end	
	
	
	//write on register file control
	always@(posedge clock) begin 
		if (opcode == AND || opcode == ADD || opcode == SUB || opcode == ANDI || opcode == ADDI || opcode == LW || opcode == LW_POI) begin
			regWr = 1'b1;
		end	 else begin	
			regWr = 1'b0;
		end
	end
	
	
	//write bus2 control
	always@(posedge clock) begin   
		if (opcode == LW_POI) begin
			Bw2 = rs_plus1;
		end else begin	
			Bw2 = rs;
		end
	end
	
	
	
	// data memory read and write control
	always@(posedge clock) begin  
		if (opcode == LW || opcode == LW_POI || opcode == RET || opcode == POP) begin	
			MemRd = 1'b1;
			MemWr = 1'b0;
		end else if (opcode == SW || opcode == CALL || opcode == PUSH) begin
			MemRd = 1'b0;
			MemWr = 1'b1;
		end
	end	
	
	
	//data memory address and data inputs
	always@(posedge clock) begin   		 
		if (opcode == LW || opcode == LW_POI || opcode == SW) begin
			DMadd = 1'b0;
		end else if ( opcode == CALL ||  opcode == RET || opcode == POP || opcode == PUSH) begin
			DMadd = 1'b1;
		end
	end
	
	  //stack pointer control
	always@(posedge clock) begin 
		if (opcode == PUSH) begin 
			SP = 1'b0;
		end else if (opcode == POP) begin 
			SP = 1'b1;
		end		
	end
	
endmodule  




module test ();	
	
	wire clock; 
	

	
	 reg [5:0] opcode;
	
	//mux's control signals
	 reg Wresult, DMadd, DMdata, SP, AluSrc, Bw2;
	 reg [1:0] pc_control;
	
	
	//functional units control signals
	 reg MemRd, MemWr, Ext, regWr;
	 reg [1:0]AluOp;
	 
	 control_unit cu (clock, regWr, AluOp, AluSrc, Ext, Wresult, Bw2,
	MemRd, MemWr, pc_control, DMadd, DMdata, SP, opcode);
	
	ClockGenerator clock_generator(clock);
	initial begin
		#5
		opcode [5:0] <= 6'b000000;	 
		
		#10	
		opcode [5:0] <= 6'b000001;	 
		
	end
endmodule	