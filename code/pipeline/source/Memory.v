`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/31 00:31:56
// Design Name: 
// Module Name: Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
	input [31:0] addr,
	output [31:0] instr
	);
   	
	reg [31:0] memory [0:63];
	//wire [5:0] index = addr[7:2];
	
	integer i = 0;
	initial
	   for(i = 0; i < 64; i= i+1)
	       memory[i] = 32'b11111111111111111111111111111111;

	initial begin
        memory[0]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[1]	= 32'b00100000000010010000000000110111;	//addi $t1, $zero, 0x37
        memory[2]	= 32'b00000001000010011000000000100100;	//and $s0, $t0, $t1
        memory[3]	= 32'b00000001000010011000000000100101;	//or $s0, $t0, $t1
        memory[4]	= 32'b10101100000100000000000000000100;	//sw $s0, 4($zero)
        memory[5]	= 32'b10101100000010000000000000001000;	//sw $t0, 8($zero)
        memory[6]	= 32'b00000001000010011000100000100000;	//add $s1, $t0, $t1
        memory[7]	= 32'b00000001000010011001000000100010;	//sub $s2, $t0, $t1
        memory[8]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[9]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[10]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[11]	= 32'b00010010001100100000000000010010;	//beq $s1, $s2, error0
        memory[12]	= 32'b10001100000100010000000000000100;	//lw $s1, 4($zero)
        memory[13]	= 32'b00110010001100100000000001001000;	//andi $s2, $s1, 0x48
        memory[14]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[15]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[16]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[17]	= 32'b00010010001100100000000000001111;	//beq $s1, $s2, error1
        memory[18]	= 32'b10001100000100110000000000001000;	//lw $s3, 8($zero)
        memory[19]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[20]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[21]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[22]	= 32'b00010010000100110000000000001101;	//beq $s0, $s3, error2
        memory[23]	= 32'b00000010010100011010000000101010;	//slt $s4, $s2, $s1 (Last)
        memory[24]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[25]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[26]	= 32'b00100000000010000000000000100000;	//addi $t0, $zero, 0x20
        memory[27]	= 32'b00010010100000000000000000001111;	//beq $s4, $0, EXIT
        memory[28]	= 32'b00000010001000001001000000100000;	//add $s2, $s1, $0
        memory[29]	= 32'b00001000000000000000000000010111;	//j Last
        memory[30]	= 32'b00100000000010000000000000000000;	//addi $t0, $0, 0(error0)
        memory[31]	= 32'b00100000000010010000000000000000;	//addi $t1, $0, 0
        memory[32]	= 32'b00001000000000000000000000111111;	//j EXIT
        memory[33]	= 32'b00100000000010000000000000000001;	//addi $t0, $0, 1(error1)
        memory[34]	= 32'b00100000000010010000000000000001;	//addi $t1, $0, 1
        memory[35]	= 32'b00001000000000000000000000111111;	//j EXIT
        memory[36]	= 32'b00100000000010000000000000000010;	//addi $t0, $0, 2(error2)
        memory[37]	= 32'b00100000000010010000000000000010;	//addi $t1, $0, 2
        memory[38]	= 32'b00001000000000000000000000111111;	//j EXIT
        memory[39]	= 32'b00100000000010000000000000000011;	//addi $t0, $0, 3(error3)
        memory[40]	= 32'b00100000000010010000000000000011;	//addi $t1, $0, 3
        memory[41]	= 32'b00001000000000000000000000111111;	//j EXIT
	end
	
	assign instr = memory[addr/4];
	
endmodule


module DataMemory(
    input clk,
    input [31:0] addr,
    input memRd, memWr,
    input [31:0] wrData,
    output [31:0] rdData);

	reg [31:0] mem [0:63];
	reg [5:0] i;
	
	initial
	   for (i=0; i<32;i=i+1) mem[i] = 32'b0;
	
	always @(posedge clk)
        if (memWr) mem[addr] = wrData;
    
    assign rdData = memRd ? mem[addr] : 32'b0;
    
endmodule