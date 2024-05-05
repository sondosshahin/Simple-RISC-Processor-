parameter


//instructions and their opcodes
// 6 bit opcode


//R-type instructions
AND = 6'b000000,
ADD = 6'b000001,
SUB = 6'b000010,  



//I-type instructions
ANDI = 6'b000011,
ADDI = 6'b000100,
LW = 6'b000101,
LW_POI = 6'b000110,
SW = 6'b000111,
BGT = 6'b001000,
BLT = 6'b001001,
BEQ = 6'b001010,
BNE = 6'b001011,   



//J-type instructions
JMP = 6'b001100,
CALL = 6'b001101,
RET = 6'b001110,



//S-type instructions
PUSH = 6'b001111,
POP = 6'b010000,



//--------------------------------------
//ALU operation control
ALU_Add = 2'b00,
ALU_Sub = 2'b01,
ALU_And = 2'b10,	 

//ALU source control	 
ALU_srcReg = 1'b0,
ALU_srcImm = 1'b1,


//PC control
pc_next = 2'b00,
pc_BTA = 2'b01,
pc_JA = 2'b10,
pc_topofstack = 2'b11,	   


//write back control
alu_res = 1'b0,	 
M_dataout = 1'b1,	  

//stack pointer control
sp = 1'b0,
sp_plusone = 1'b1,		


//data memory control
//address control	
alu_out = 1'b0,	
sp_val = 1'b1,

//data control
rd_reg = 1'b0, 
pc_plus1 = 1'b1,


//extender control
unsighned_ext = 1'b0,
sighned_ext = 1'b1,	  

//register file control
disable_wr = 1'b0,
enable_wr = 1'b1,

//write bus 2 control
rs = 1'b0,
rs_plus1 = 1'b1;
