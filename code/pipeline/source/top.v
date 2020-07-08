`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/06 22:07:01
// Design Name: 
// Module Name: IO
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


module top(
    input clk,swPC,ANclk,rst,
    input [4:0]sw,
    output [6:0]SSD,
    output [3:0]AN
    );
    reg [31:0]read;
    wire [3:0]x1,x2,x3,x4;
    cpu CPU(clk, rst);

    always @(*) begin
    if (swPC==1) read=CPU.PC;
    else read=CPU.RegFile.register[sw];
    end

    assign x1=read[15:12];
    assign x2=read[11:8];
    assign x3=read[7:4];
    assign x4=read[3:0];
    wire [6:0]Y1,Y2,Y3,Y4;
    display D1(x1,Y1);
    display D2(x2,Y2);
    display D3(x3,Y3);
    display D4(x4,Y4);
    Ringcounter RC(AN,ANclk,1'b0);
    catho CT(AN,Y1,Y2,Y3,Y4,SSD);
endmodule
