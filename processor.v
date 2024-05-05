module processor ();
    wire clock;


    // Control unit
    // Mux's control signals
    wire Wresult, DMadd, DMdata, SP, AluSrc, Bw2;
    wire [1:0] pc_control;

    // Functional units control signals
    wire MemRd, MemWr, Ext, regWr;
    wire [1:0] AluOp;

    // Instruction Memory
    // Instruction memory wires/registers
    wire [31:0] PC; // output of PC Module input to instruction memory
    wire [0:31] InstructionReg; // output of instruction memory, input to other modules	  
	wire [31:0] sp;

    // Instruction Parts
    wire [5:0] opcode; // function code

    // R-Type
    wire [3:0] Rs1, Rs2, Rd; // register selection	 
																   
    // ----------------- Assignment -----------------

    // opCode
    assign opcode = InstructionReg[0:5];

    // R-Type
    assign Rd = InstructionReg[6:9];
    assign Rs1 = InstructionReg[10:13];
    assign Rs2 = InstructionReg[14:17];

    // J-Type
    wire signed [0:25] J_TypeImmediate;
    assign J_TypeImmediate = InstructionReg[6:31];

    // I-Type
    wire signed [0:13] I_TypeImmediate;
    assign I_TypeImmediate = InstructionReg[14:29];

    // S-Type
    //?

    // ----------------- PC Modules -----------------

    // Register file wires/registers
    reg [31:0] topstack; // input to PC Module
    wire signed [31:0] Sign_Extended_I_TypeImmediate;
    wire [31:0] Unsigned_Extended_I_TypeImmediate;

    // Signed extender for I-Type instructions immediate (16 bit to 32)
    assign Sign_Extended_I_TypeImmediate = { {16{I_TypeImmediate[15]}}, I_TypeImmediate };

    // Unsigned extender for I-Type instructions immediate (16 bit to 32)
    assign Unsigned_Extended_I_TypeImmediate = { {16{1'b0}}, I_TypeImmediate };

 // ----------------- Register File -----------------
    
    reg [31:0] BusW, BusW2; 
    wire [31:0] BusA, BusB;
    wire [3:0] RA, RB, RW, RW2;

    assign RA = Rs1;
    assign RB = Rs2;
    assign RW = Rd;	
	assign RW2 = Rs1;	  
	

	 //Control Unit
	control_unit cu (clock, regWr, AluOp, AluSrc, Ext, Wresult, Bw2,
	 MemRd, MemWr, pc_control, DMadd, DMdata, SP, opcode);		
	 
// ----------------- ALU -----------------

  	reg [31:0] ALU_A, ALU_B; // operands
  	wire [31:0] ALU_Output;
  
  	assign ALU_A = BusA;

 	always_comb begin
	    case (AluSrc)
	        1'b0 : ALU_B = BusB;
	        1'b1 : ALU_B = Unsigned_Extended_I_TypeImmediate;
	        default: ALU_B = 32'h0; // Add a default case to avoid latch inference
	    endcase
	end


//Data Memory

// Data memory wires/registers/signals
	reg [31:0] DataMemoryAddressBus;
	reg [31:0] DataMemoryInputBus;
	wire [31:0] DataMemoryOutputBus;
	
	always_comb begin
	    case (DMadd)
	        1'b0 : DataMemoryAddressBus = ALU_Output; // Use non-blocking assignment
	         1'b1 : DataMemoryAddressBus = sp; // Uncomment and replace with the actual assignment
	        default: DataMemoryAddressBus = 32'h0; // Add a default case to avoid latch inference
	    endcase
	end
	
	always_comb begin
	    case (DMdata)
	        1'b0 : DataMemoryInputBus = Rd; // Use non-blocking assignment
	        1'b1 : DataMemoryInputBus = PC + 1; // Uncomment and replace with the actual assignment
	        default: DataMemoryInputBus = 32'h0; // Add a default case to avoid latch inference
	    endcase
	end	 

// CLOCK 
	ClockGenerator clock_generator(clock);		

	 
	   //Instruction Memory 
     instruction_memory inst_memory(PC, InstructionReg);		  
	 
	  //PC Module 
     pc_module pcModule(clock, PC, Sign_Extended_I_TypeImmediate, Sign_Extended_J_TypeImmediate, topstack, pc_control);	 
	 
	   //  Register File
	 RegFile register_file(clock, RW, RA, RB,  regWr, BusA, BusB, BusW, BusW2);

    // ALU 
    ALU alu(ALU_A, ALU_B, AluOp, ALU_Output);

  
    //  Data Memory
    dataMemory data_memory(clock, MemRd, MemWr, DataMemoryAddressBus, DataMemoryInputBus, DataMemoryOutputBus, opcode);
	
  
    // Write Back 
    assign BusW1 = (Wresult == 0) ? ALU_Output : DataMemoryOutputBus;
	

endmodule
