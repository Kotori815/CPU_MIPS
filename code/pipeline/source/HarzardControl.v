`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/05 22:35:33
// Design Name: 
// Module Name: HarzardControl
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


module HarzardControl(
    input ID_EX_MemRead,
    input [4:0] IF_ID_rs, IF_ID_rt, ID_EX_rt,
    output IF_ID_stall
    );
    
    assign IF_ID_stall = ID_EX_MemRead & ((ID_EX_rt == IF_ID_rs) | (ID_EX_rt == IF_ID_rt));
    
endmodule
