`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/21 14:42:31
// Design Name: 
// Module Name: control
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


module Control(
    input [5:0] opcode,
    output reg [1:0] ALUOp,
    output reg jump, branchBeq, branchBne,
    output reg memRd, memWr, mem2Reg,
    output reg regDst, regWr, ALUSrc
    );
    
    
    always @(*) begin
        case (opcode)
            6'b000000: begin    // R-type 
                ALUOp       = 2'b10;
                ALUSrc      = 1'b0;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b1;
                regWr       = 1'b1;
                jump        = 1'b0;
            end
            6'b100011: begin	// lw 
                ALUOp		= 2'b00;
                ALUSrc      = 1'b1;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b1;
                mem2Reg     = 1'b1;
                memWr       = 1'b0;
                regDst      = 1'b0;
                regWr       = 1'b1;
                jump        = 1'b0;
			end
			6'b101011: begin	// sw 
				ALUOp       = 2'b00;  
				ALUSrc      = 1'b1;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b1;
                mem2Reg     = 1'b1;
				memWr       = 1'b1;
                regDst      = 1'b0;
				regWr       = 1'b0;
                jump        = 1'b0;			
			end
			6'b000100: begin	// beq 
				ALUOp       = 2'b01;
                ALUSrc      = 1'b0;
				branchBeq   = 1'b1;
                branchBne   = 1'b0;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b1;
				regWr       = 1'b0;
                jump        = 1'b0;			
			end
			6'b000101: begin	// bne 
				ALUOp       = 2'b01;
                ALUSrc      = 1'b0;
                branchBeq   = 1'b0;
				branchBne   = 1'b1;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b1;
                regWr       = 1'b0;
                jump        = 1'b0;
			end
			6'b000010: begin	// j jump 
                ALUOp       = 2'b10;
                ALUSrc      = 1'b0;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b1;
                regWr       = 1'b1;
                jump        = 1'b1;
			end
			6'b001000: begin	// addi 
                ALUOp       = 2'b00;
                ALUSrc      = 1'b1;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b0;
                regWr       = 1'b1;
                jump        = 1'b0;
			end
			6'b001100: begin	// andi 
                ALUOp       = 2'b11;
                ALUSrc      = 1'b1;
                branchBeq   = 1'b0;
                branchBne   = 1'b0;
                memRd       = 1'b0;
                mem2Reg     = 1'b0;
                memWr       = 1'b0;
                regDst      = 1'b0;
                regWr       = 1'b1;
                jump        = 1'b0;
			end
		endcase
	end
    
endmodule
