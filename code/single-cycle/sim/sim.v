`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/30 22:25:41
// Design Name: 
// Module Name: sim
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


module sim;
    reg clk;
    wire [31:0] pc_out;
    wire [31:0] alu_result;
  
top uut (
    .clk(clk),  
    .pc_display(pc_out),   
    .ALU_result(alu_result)
	);  
 
initial begin 
/*
    $dumpfile("test.vcd");
    $dumpvars(0, sim);
    $display("%g\t %b", $time, clk);
    */
    clk = 0;
end

//integer i = 0;
always begin
    #20 clk = ~clk; //i=i+1;
    //if (i == 100) $finish;
end

always@(posedge clk) begin
  /////////////////////////////////////////////
  /*
	$display($time,,"PC=",uut.PC);
	$display($time,,"IM= %b",uut.instr);
	$display($time,,"ALUContrl= %b",uut.ALU_opcode);
	$display($time,,"ALUIResult= %b",uut.ALU_result);
	$display($time,,"ALUIOp= %b",uut.ALUOp);
	$display($time,,"PC+4=",uut.PC_add_4);
	$display($time,,"ALUIn1=",uut.ALU_IN1);
	$display($time,,"AluIn2=",uut.ALU_IN2);
	$display($time,,"WB=",uut.Reg_write_data);
	$display($time,,"RDMem=",uut.Data_read_data);
	$display($time,,"MemWrite=",uut.Reg_read_register_2);
	*/
	////////////////////////////////////////////////
	$display($time,,"PC = %b",uut.PC);
	$display($time,,"IM = %b",uut.instr);
	$display($time,,"ALU Result = %b",uut.ALU_result);
	$display($time,,"R0(r0) = %b, R8 (t0) = %b, R16(s0) = %b, R24(t8) = %b", uut.RegFile.register[0], uut.RegFile.register[8] , uut.RegFile.register[16], uut.RegFile.register[24]);
	$display($time,,"R1(at) = %b, R9 (t1) = %b, R17(s1) = %b, R25(t9) = %b", uut.RegFile.register[1], uut.RegFile.register[9] , uut.RegFile.register[17], uut.RegFile.register[25]);
	$display($time,,"R2(v0) = %b, R10(t2) = %b, R18(s2) = %b, R26(k0) = %b", uut.RegFile.register[2], uut.RegFile.register[10], uut.RegFile.register[18], uut.RegFile.register[26]);
	$display($time,,"R3(v1) = %b, R11(t3) = %b, R19(s3) = %b, R27(k1) = %b", uut.RegFile.register[3], uut.RegFile.register[11], uut.RegFile.register[19], uut.RegFile.register[27]);
	$display($time,,"R4(a0) = %b, R12(t4) = %b, R20(s4) = %b, R28(gp) = %b", uut.RegFile.register[4], uut.RegFile.register[12], uut.RegFile.register[20], uut.RegFile.register[28]);
	$display($time,,"R5(a1) = %b, R13(t5) = %b, R21(s5) = %b, R29(sp) = %b", uut.RegFile.register[5], uut.RegFile.register[13], uut.RegFile.register[21], uut.RegFile.register[29]);
	$display($time,,"R6(a2) = %b, R14(t6) = %b, R22(s6) = %b, R30(s8) = %b", uut.RegFile.register[6], uut.RegFile.register[14], uut.RegFile.register[22], uut.RegFile.register[30]);
	$display($time,,"R7(a3) = %b, R15(t7) = %b, R23(s7) = %b, R31(ra) = %b", uut.RegFile.register[7], uut.RegFile.register[15], uut.RegFile.register[23], uut.RegFile.register[31]);

    // print Data Memory
    $display($time,,"Data mem.: 0x00 =%x", {uut.DM.mem[3] , uut.DM.mem[2] , uut.DM.mem[1] , uut.DM.mem[0] });
    $display($time,,"Data mem.: 0x04 =%x", {uut.DM.mem[7] , uut.DM.mem[6] , uut.DM.mem[5] , uut.DM.mem[4] });
    $display($time,,"Data mem.: 0x08 =%x", {uut.DM.mem[11], uut.DM.mem[10], uut.DM.mem[9] , uut.DM.mem[8] });
    $display($time,,"Data mem.: 0x0c =%x", {uut.DM.mem[15], uut.DM.mem[14], uut.DM.mem[13], uut.DM.mem[12]});
    $display($time,,"Data mem.: 0x10 =%x", {uut.DM.mem[19], uut.DM.mem[18], uut.DM.mem[17], uut.DM.mem[16]});
    $display($time,,"Data mem.: 0x14 =%x", {uut.DM.mem[23], uut.DM.mem[22], uut.DM.mem[21], uut.DM.mem[20]});
    $display($time,,"Data mem.: 0x18 =%x", {uut.DM.mem[27], uut.DM.mem[26], uut.DM.mem[25], uut.DM.mem[24]});
    $display($time,,"Data mem.: 0x1c =%x", {uut.DM.mem[31], uut.DM.mem[30], uut.DM.mem[29], uut.DM.mem[28]});
	
	$display("\t================================================================================================================================================================================");

end

endmodule  

