`include "constants.v"
module ALU(IN1,IN2,AluOp,Output);

	// ----------------- SIGNALS & INPUTS -----------------

    // select control for ALU operation
	input wire [1:0] AluOp;
	
	// operands
	input wire [31:0] IN1, IN2;

	// ----------------- OUTPUTS -----------------

	output reg	[31:0]	Output;


	// ----------------- LOGIC -----------------   
	always@*
		case (AluOp)  
			ALU_Add:  assign Output = IN1 + IN2;
			ALU_Sub:  assign Output = IN1 - IN2;
			ALU_And:  assign Output = IN1 & IN2;
			default:  assign Output = 0; 
		endcase

endmodule