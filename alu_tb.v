`timescale 1ns / 1ps

`include "constants.v"
module alu_tb();

    // Test inputs
    reg [31:0] IN1, IN2;
    reg [1:0] AluOp;
    
    // Test output
    wire [31:0] Output;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .IN1(IN1), 
        .IN2(IN2), 
        .AluOp(AluOp), 
        .Output(Output)
    );

    initial begin
        // Initialize Inputs
        IN1 = 0;
        IN2 = 0;
        AluOp = 0;

        // Wait for global reset
        #100;
        
        // Add stimulus here
        // Test Addition
        AluOp = ALU_Add; 
        IN1 = 32'd10; 
        IN2 = 32'd15;
        #10; // Wait for 10ns

        // Test Subtraction
        AluOp = ALU_Sub; 
        IN1 = 32'd20; 
        IN2 = 32'd10;
        #10; // Wait for 10ns

        // Test AND
        AluOp = ALU_And; 
        IN1 = 32'hA; // 1010 in binary
        IN2 = 32'h3; // 0011 in binary
        #10; // Wait for 10ns

        // Add more tests as needed

        // Finish simulation
        #10;
        $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("At time %t, IN1 = %d, IN2 = %d, AluOp = %b, Output = %d",
                 $time, IN1, IN2, AluOp, Output);
    end

endmodule