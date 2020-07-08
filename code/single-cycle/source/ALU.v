`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/12 14:24:56
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a, b,
    input [3:0] op,
    output reg [31:0] result,
    output zero
    );
    
    parameter Add = 4'b0010;
    parameter Sub = 4'b0110;
    parameter And = 4'b0000;
    parameter Or  = 4'b0001;
    parameter Slt = 4'b0111;
    
    reg temp;
    
    always @(a or b or op) begin
        case (op)
            Add: result = a + b;
            Sub: result = a - b;
            And: result = a & b;
            Or:  result = a | b;
            Slt:begin
               result = a - b;
               temp = result[31];
               result = {31'b0,temp}; 
            end
            default: result = a + b;
        endcase
    end

    assign zero = (result=={32{1'b0}});

endmodule
