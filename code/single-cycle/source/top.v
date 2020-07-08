`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/30 22:22:03
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    output [31:0] pc_display, ALU_result
    );
    
    reg [31:0] PC;
	wire [31:0] PC_curr, PC_add_4, PC_next;

	wire [31:0] branch_addr, jump_addr;
	wire [25:0] instr_jump;
	wire [27:0] instr_jump_shifted;
	wire branch;
	
	wire [31:0] instr;

    wire [5:0] opcode;
	wire RegDst, Jump, BranchBeq;
	wire BranchBne, MemRead, MemtoReg;
	wire ALUSrc, MemWrite, RegWrite;
	wire [1:0] ALUOp;
	
	wire [31:0] Reg_read_data_1, Reg_read_data_2, Reg_write_data;
	wire [4:0] Reg_read_register_1, Reg_read_register_2, Reg_write_register;
	
	wire [5:0] funct; 
	wire [15:0] immediate;
	wire [31:0] extended, shifted;
	
	wire [31:0] ALU_IN1, ALU_IN2, ALU_OUT;
    wire [3:0] ALU_opcode;
	wire ALU_zero;
	
	wire [31:0] Data_read_data;

	initial
	   PC <= 32'b0;

	always @(posedge clk) begin
		PC <= PC_next;
		if (instr == 32'hFFFFFFFF) begin
            PC = 32'b0;
            $finish;
        end
    end
    
	assign PC_add_4 = PC + 4;
	assign PC_curr = PC;
	InstructionMemory IM(.addr(PC_curr),.instr(instr));
	
	assign opcode = instr[31:26];
	
	Control control(.opcode(opcode), .ALUOp(ALUOp), .jump(Jump), .branchBeq(BranchBeq),
	    .branchBne(BranchBne), .memRd(MemRead), .memWr(MemWrite), .mem2Reg(MemtoReg), 
	    .regDst(RegDst), .regWr(RegWrite), .ALUSrc(ALUSrc));
	
	assign Reg_read_register_1 = instr[25:21];
	assign Reg_read_register_2 = instr[20:16];
	assign Reg_write_register = RegDst ? instr[15:11] : instr[20:16];
	Registers RegFile(.clk(clk),.rdReg1(Reg_read_register_1), 
	   .rdReg2(Reg_read_register_2), .wrReg(Reg_write_register),
	   .wrData(Reg_write_data),.write(RegWrite),.rdData1(Reg_read_data_1), 
	   .rdData2(Reg_read_data_2));
	
	assign immediate = instr[15:0];
	SignExtend sign_Ext(.IN(immediate), .OUT(extended));
	ShiftLeft2_immediate shiftL2_branch(.in(extended), .out(shifted));
	
	assign funct = instr[5:0];
	ALUControl ALU_control(.funct(funct), .ALUop(ALUOp), .ALUctrl(ALU_opcode));
	
	assign ALU_IN1 = Reg_read_data_1;
	assign ALU_IN2 = ALUSrc ? extended : Reg_read_data_2;
	ALU A_L_U(.a(ALU_IN1), .b(ALU_IN2), .op(ALU_opcode), 
	   .result(ALU_OUT), .zero(ALU_zero));
	
	DataMemory DM(.clk(clk), .addr(ALU_OUT), .memRd(MemRead), .memWr(MemWrite), 
	   .wrData(Reg_read_data_2), .rdData(Data_read_data));
	assign Reg_write_data = MemtoReg ? Data_read_data : ALU_OUT;
	
	assign branch = (BranchBeq & ALU_zero) | (BranchBne & ~ALU_zero);
	assign branch_addr = shifted + PC_add_4;
	
	assign instr_jump = instr[25:0];
	ShiftLeft2_jump shiftL2_jump(.in(instr_jump), .out(instr_jump_shifted));
	assign jump_addr = {PC_add_4[31:28], instr_jump_shifted};
	
	assign PC_next = Jump ? jump_addr : (branch ? branch_addr : PC_add_4);
	
	assign pc_display = PC;
	assign ALU_result = ALU_OUT;
		
endmodule
