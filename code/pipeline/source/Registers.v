`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/21 15:46:43
// Design Name: 
// Module Name: regFile
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


module RegisterFile(
    input clk,
    input [4:0] rdReg1, rdReg2, wrReg,
    input [31:0] wrData,
    input write,
    output [31:0] rdData1, rdData2
    );
    
    reg [31:0] register [0:31];
    
    integer i;
    initial
        for(i=0;i<32;i=i+1) register[i] = 32'b00000000000000000000000000000000;
    
	always @(posedge clk) begin
		if (write) register[wrReg] = wrData;
	end
    
    assign rdData1 = register[rdReg1];
    assign rdData2 = register[rdReg2];
    
endmodule

module RegisterN(clk, hold, clear, wrData, rdData);
    
    parameter N = 1;
    
    input clk;
    input hold, clear;    
    input [N-1:0] wrData;
    output reg [N-1:0] rdData;
    
    initial begin
        rdData = {N{1'b0}};
    end
    
    always @(posedge clk) begin
		if (clear)
		    rdData <= {N{1'b0}};
		else if (hold)
			rdData <= rdData;
		else
			rdData <= wrData;
	end
    
endmodule