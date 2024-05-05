`timescale 1ns / 1ps
`include "constants.v"

module controlunit_tb();

    reg clock; 
    reg [5:0] opcode;
	
    // Control signals as wires since they are outputs from the module
    wire Wresult, DMadd, DMdata, SP, AluSrc, Bw2;
    wire [1:0] pc_control;
    wire MemRd, MemWr, Ext, regWr;
    wire [1:0] AluOp;

    // Instantiate the Control Unit
    control_unit cu (
        .clock(clock), 
        .regWr(regWr), 
        .AluOp(AluOp), 
        .AluSrc(AluSrc), 
        .Ext(Ext), 
        .Wresult(Wresult), 
        .Bw2(Bw2),
        .MemRd(MemRd), 
        .MemWr(MemWr), 
        .pc_control(pc_control), 
        .DMadd(DMadd), 
        .DMdata(DMdata), 
        .SP(SP), 
        .opcode(opcode)
    );

    // Clock generation
    always begin
        clock = 0;
        #5; // Half period of 10ns clock
        clock = 1;
        #5;
    end

    // Test sequence
    initial begin
        // Initialize opcode
        opcode = 6'b000000; // NOP - No operation or undefined opcode
        #10; // Wait for the next clock edge

        // Test various opcodes
        opcode = AND; // Assuming AND is defined in "constants.v"
        #20;
        opcode = ADD;
        #20;
        opcode = SUB;
        #20;
        opcode = LW;
        #20;
        opcode = SW;
        #20;
        // Continue for other opcodes as required

        // Finish test
        #10;
        $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time: %t, Opcode: %b, AluOp: %b, AluSrc: %b, Ext: %b, MemRd: %b, MemWr: %b, regWr: %b, Wresult: %b, Bw2: %b, SP: %b, DMadd: %b, DMdata: %b, pc_control: %b",
                 $time, opcode, AluOp, AluSrc, Ext, MemRd, MemWr, regWr, Wresult, Bw2, SP, DMadd, DMdata, pc_control);
    end

endmodule