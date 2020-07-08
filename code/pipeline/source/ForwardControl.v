`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/03 14:38:56
// Design Name: 
// Module Name: ForwardControl
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


module ForwardControl(
    input MEM_WB_RegWrite, EX_MEM_RegWrite,
    input [4:0] MEM_WB_Rd, EX_MEM_Rd,ID_EX_Rs, ID_EX_Rt,
    output reg [1:0] ForwardA, ForwardB
    );
    
    initial begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
    end
    
    always @(*) begin
	ForwardA = 2'b00;
	ForwardB = 2'b00;
        if (MEM_WB_RegWrite & (MEM_WB_Rd != 0) & (MEM_WB_Rd == ID_EX_Rs)
             & ~(EX_MEM_RegWrite & (EX_MEM_Rd != 0) & (EX_MEM_Rd == ID_EX_Rs)))
            ForwardA = 2'b01;
		else if (EX_MEM_RegWrite & (EX_MEM_Rd != 0) & (EX_MEM_Rd == ID_EX_Rs))
			ForwardA = 2'b10;
			
		if (MEM_WB_RegWrite & (MEM_WB_Rd != 0) & (MEM_WB_Rd == ID_EX_Rt)
			  & ~(EX_MEM_RegWrite & (EX_MEM_Rd != 0) & (EX_MEM_Rd == ID_EX_Rt)))
            ForwardB = 2'b01;
		else if (EX_MEM_RegWrite & (EX_MEM_Rd != 0)	
			  & (EX_MEM_Rd == ID_EX_Rt))
            ForwardB = 2'b10;
        end
    
endmodule