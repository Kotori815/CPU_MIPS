`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/04 17:57:35
// Design Name: 
// Module Name: catho
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


module catho(A,aa,bb,cc,dd,C);
input [3:0] A;
input [6:0] aa,bb,cc,dd;
output [6:0] C;
reg [6:0] C;
always @(A)
begin
    case (A)
	    4'b1110: C = dd;
		4'b1101: C = cc;
		4'b1011: C = bb;
		4'b0111: C = aa;
		default  C = 7'b1011111;
    endcase
end
endmodule
