`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/04 16:42:00
// Design Name: 
// Module Name: Ringcounter
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


module Ringcounter(A,clk_500,reset);
output [3:0] A;
input clk_500,reset;
reg [3:0] A;
initial A=4'b1111;
always @(posedge clk_500)
if (reset==1) A=4'b1111;
else 
    begin
        case (A)
            4'b1111: A = 4'b1110;
            4'b1110: A = 4'b1101;
            4'b1101: A = 4'b1011;
            4'b1011: A = 4'b0111;
            4'b0111: A = 4'b1110;
            default A=1111;
         endcase

    end
endmodule
