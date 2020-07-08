`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/12 15:24:16
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
		input [5:0] funct,
		input [1:0] ALUop,
		output reg [3:0] ALUctrl);
		
		parameter lw_sw   = 2'b00;
		parameter beq     = 2'b01;
		parameter R_type  = 2'b10;
		parameter andi    = 2'b11;
		
		parameter ADD = 6'b100000;
		parameter SUB = 6'b100010;
		parameter AND = 6'b100100;
		parameter OR  = 6'b100101;
		parameter SLT = 6'b101010;

		always @(*) begin
			case (ALUop)
				lw_sw:  ALUctrl = 4'b0010;
				beq:    ALUctrl = 4'b0110;
				R_type: begin case (funct)
							ADD: ALUctrl = 4'b0010;
							SUB: ALUctrl = 4'b0110;
							AND: ALUctrl = 4'b0000;
							OR:  ALUctrl = 4'b0001;
							SLT: ALUctrl = 4'b0111;
						endcase end
				andi:   ALUctrl = 4'b0000;
			endcase
		end
		
endmodule