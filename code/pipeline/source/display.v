`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/24 11:20:02
// Design Name: 
// Module Name: display
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


module display(B,seven);

output [6:0] seven;
input [3:0] B;
reg [6:0] seven;
always @B begin
case (B)
4'b0000:seven=7'b0000001;
4'b0001:seven=7'b1001111;
4'b0010:seven=7'b0010010;
4'b0011:seven=7'b0000110;
4'b0100:seven=7'b1001100;
4'b0101:seven=7'b0100100;
4'b0110:seven=7'b0100000;
4'b0111:seven=7'b0001111;
4'b1000:seven=7'b0000000;
4'b1001:seven=7'b0000100;
4'b1010:seven=7'b0001000;
4'b1011:seven=7'b1100000;
4'b1100:seven=7'b0110001;
4'b1101:seven=7'b1000010;
4'b1110:seven=7'b0110000;
4'b1111:seven=7'b0111000;
default:seven=7'b1111110;
endcase
end
endmodule
