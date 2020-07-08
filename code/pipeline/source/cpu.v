`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/05 17:12:50
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


module cpu(
    input clk, rst
    );
    
    // flush 
    wire Jump;
    reg IF_Flush, pcsrc;
    always @(*) begin
        IF_Flush <= 1'b0;
		if (~pcsrc | Jump) begin
			IF_Flush <= 1'b1;
		end
	end
	
	// harzard
	wire stall_IF_ID;
    wire [1:0] ForwardA, ForwardB;
	
	//////////////////////////////////
	// IF stage
	reg  [31:0] PC;
	initial PC <= 32'b0;
	wire [31:0] PC_add_4_IF;
	assign PC_add_4_IF = PC + 4;
	wire [31:0] branch_addr, jump_addr;
	//integer i;
	always @(*) if (PC == 32'h000000FC) $finish;
    always @(posedge clk) begin
		if (rst) begin
			PC <= 32'b0;
			/*
			for (i=0;i<32;i=i+1)begin
			     RegFile.register[i] <= 32'b0;
			end
			*/
		end
		else if (stall_IF_ID) 
			PC <= PC;
		else if (~pcsrc)
			PC <= branch_addr;
		else if (Jump)
			PC <= jump_addr;
		else
			PC <= PC_add_4_IF;
	end	
    
    wire [31:0] instr_IF;	
	InstructionMemory IM(.addr(PC),.instr(instr_IF));
	
    //////////////////////////////////
    // IF/ID regs
	wire [31:0] PC_add_4_ID;
	RegisterN #(.N(32)) IF_ID_reg_pc_add_4(.clk(clk), .hold(stall_IF_ID),
	   .clear(IF_Flush),.wrData(PC_add_4_IF), .rdData(PC_add_4_ID));
	
	wire[31:0] instr_ID;
    RegisterN #(.N(32)) IF_ID_reg_instr(.clk(clk), .hold(stall_IF_ID),
        .clear(IF_Flush), .wrData(instr_IF), .rdData(instr_ID));
    
    //////////////////////////////////			
	// ID stage
	wire [5:0] opcode;
	wire [4:0] rs_ID, rt_ID, rd_ID, Reg_write_register_WB;
	wire [5:0] funct; 
	wire [15:0] immediate, jump;
	wire [31:0] extended_ID, shifted;
	wire [31:0] Reg_rd_1_ID, Reg_rd_2_ID, Reg_write_data_WB;	
	
	assign immediate = instr_ID[15:0];
    SignExtend sign_Ext(.IN(immediate), .OUT(extended_ID));
	ShiftLeft2_immediate shiftL2_branch(.in(extended_ID), .out(shifted));
	
	assign branch_addr = PC_add_4_ID + shifted;
	wire [25:0] instr_jump;
	wire [27:0] instr_jump_shifted;
	assign instr_jump = instr_ID[25:0];
	ShiftLeft2_jump shiftL2_jump(.in(instr_jump), .out(instr_jump_shifted));
	assign jump_addr = {PC_add_4_ID[31:28], instr_jump_shifted};
	
	wire [1:0] ALUOp;
	wire RegDst, BranchBeq;
	wire BranchBne, MemRead, MemtoReg;
	wire ALUSrc, MemWrite, RegWrite;
    Control control(.opcode(opcode), .ALUOp(ALUOp), .jump(Jump), .branchBeq(BranchBeq),
	    .branchBne(BranchBne), .memRd(MemRead), .memWr(MemWrite), .mem2Reg(MemtoReg), 
	    .regDst(RegDst), .regWr(RegWrite), .ALUSrc(ALUSrc));
	    
    wire RegWrite_WB;
	assign opcode = instr_ID[31:26];
	assign rs_ID = instr_ID[25:21];
	assign rt_ID = instr_ID[20:16];
	assign rd_ID = instr_ID[15:11];
	RegisterFile RegFile(.clk(clk),.rdReg1(rs_ID), .rdReg2(rt_ID), 
	   .wrReg(Reg_write_register_WB), .wrData(Reg_write_data_WB),
	   .write(RegWrite_WB), .rdData1(Reg_rd_1_ID), .rdData2(Reg_rd_2_ID));
	    
    wire [7:0] control_all_ID;
    assign control_all_ID = stall_IF_ID ? 8'b0
        : {ALUOp, ALUSrc,RegDst, MemRead, MemWrite, MemtoReg, RegWrite};
        
    always @(*) begin
        pcsrc <= 1'b1;
        if (((BranchBeq==1) & (Reg_rd_1_ID == Reg_rd_2_ID)) | ((BranchBne==1) & (Reg_rd_1_ID != Reg_rd_2_ID))) pcsrc <= 1'b0;
    end    
	
    //////////////////////////////////
    // ID/EX regs
	wire [7:0] control_all_EX;
	wire [31:0] Reg_rd_1_EX, Reg_rd_2_EX, extended_EX; 
	wire [14:0] regs_EX;
	RegisterN #(.N(8)) control_all_ID_EX(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(control_all_ID), .rdData(control_all_EX));
	RegisterN #(32) read1_ID_EX(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(Reg_rd_1_ID), .rdData(Reg_rd_1_EX));
	RegisterN #(32) read2_ID_EX(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(Reg_rd_2_ID), .rdData(Reg_rd_2_EX));
	RegisterN #(32) extended_ID_EX(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(extended_ID), .rdData(extended_EX));
    RegisterN #(.N(15)) regs_ID_EX(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData({rs_ID,rt_ID,rd_ID}), .rdData(regs_EX));
	
	//////////////////////////////////
    // EX stage
    wire [4:0] Reg_write_register_EX;
    assign Reg_write_register_EX = control_all_EX[4] ? regs_EX[4:0] : regs_EX[9:5];
    
    wire [3:0] ALU_opcode;
    ALUControl ALUctrl(.funct(extended_EX[5:0]), .ALUop(control_all_EX[7:6]), .ALUctrl(ALU_opcode));
    
    wire [31:0] ALU_IN1, ALU_IN2, ALU_result_EX;
    wire [31:0] Data_writeData_EX;
    wire [31:0] ALU_result_MEM;
    assign ALU_IN1 = ForwardA[1] ? ALU_result_MEM 
        : (ForwardA[0] ? Reg_write_data_WB : Reg_rd_1_EX);
    assign Data_writeData_EX = ForwardB[1] ? ALU_result_MEM 
        : (ForwardB[0] ? Reg_write_data_WB :Reg_rd_2_EX);
    assign ALU_IN2 = control_all_EX[5] ? extended_EX : Data_writeData_EX;
    ALU_noZero A_L_U(.a(ALU_IN1), .b(ALU_IN2), .op(ALU_opcode), .result(ALU_result_EX));

	//////////////////////////////////
    // EX/MEM regs
    wire [3:0] control_all_MEM;
    wire [31:0] Data_writeData_MEM;
    wire [4:0] Reg_write_register_MEM;
    RegisterN #(.N(4)) control_all_EX_MEM(.clk(clk), .hold(1'b0),
       .clear(1'b0),.wrData(control_all_EX[3:0]), .rdData(control_all_MEM));
    RegisterN #(.N(32)) ALU_result_EX_MEM(.clk(clk), .hold(1'b0),
       .clear(1'b0),.wrData(ALU_result_EX), .rdData(ALU_result_MEM));
    RegisterN #(.N(32)) Data_writeData_EX_MEM(.clk(clk), .hold(1'b0),
       .clear(1'b0),.wrData(Data_writeData_EX), .rdData(Data_writeData_MEM));
    RegisterN #(.N(5)) Reg_write_register_EX_MEM(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(Reg_write_register_EX), .rdData( Reg_write_register_MEM));

    //////////////////////////////////
    // MEM stage
    wire [31:0] Data_read_data_MEM;
    DataMemory DM(.clk(clk), .addr(ALU_result_MEM), .memRd(control_all_MEM[3]), .memWr(control_all_MEM[2]), 
       .wrData(Data_writeData_MEM), .rdData(Data_read_data_MEM));
    
    //////////////////////////////////
    // MEM/WB regs
    wire [1:0] control_all_WB;
    wire [31:0] Data_read_data_WB, ALU_result_WB;
    RegisterN #(.N(2)) control_all_MEM_WB(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(control_all_MEM[1:0]), .rdData(control_all_WB));
    RegisterN #(.N(32)) Data_read_data_MEM_WB(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(Data_read_data_MEM), .rdData(Data_read_data_WB));
    RegisterN #(.N(32)) ALU_result_MEM_WB(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(ALU_result_MEM), .rdData(ALU_result_WB));
    RegisterN #(.N(5)) Reg_write_register_MEM_WB(.clk(clk), .hold(1'b0),
	   .clear(1'b0),.wrData(Reg_write_register_MEM), .rdData(Reg_write_register_WB));
    
    //////////////////////////////////
    // WB stage
    assign Reg_write_data_WB = control_all_WB[1] ? ALU_result_WB : Data_read_data_WB;
    assign RegWrite_WB = control_all_WB[0];

    // forward control
    ForwardControl FC(.MEM_WB_RegWrite(RegWrite_WB), .EX_MEM_RegWrite(control_all_MEM[0]), 
        .MEM_WB_Rd(Reg_write_register_WB), .EX_MEM_Rd(Reg_write_register_MEM),
        .ID_EX_Rs(regs_EX[14:10]), .ID_EX_Rt(regs_EX[9:5]), .ForwardA(ForwardA), .ForwardB(ForwardB));
        
    // harzard control
    HarzardControl HC(.ID_EX_MemRead(control_all_EX[3]), .IF_ID_rs(rs_ID), 
        .IF_ID_rt(rt_ID), .ID_EX_rt(regs_EX[9:5]), .IF_ID_stall(stall_IF_ID));

endmodule
