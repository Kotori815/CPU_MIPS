`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/21 16:01:51
// Design Name: 
// Module Name: shiftLeft2
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


module ShiftLeft2_immediate(
    input [31:0] in,
    output reg [31:0] out
    );
    always @(*) begin
        out = {in[29:0],2'b00};
    end
endmodule

module ShiftLeft2_jump(
    input [25:0] in,
    output reg [27:0] out
    ); 
    always @(*) begin
        out = {in[25:0],2'b00} ;
    end
endmodule
