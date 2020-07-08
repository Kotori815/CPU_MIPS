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


module Registers(
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
