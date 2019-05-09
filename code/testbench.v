`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:58 02/25/2016
// Design Name: 
// Module Name:    testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define CYCLE_TIME 50			

module TestBench;
  reg Clk, Start;
 // reg [31:0] i;

  Simple_Single_CPU CPU(Clk,Start);
  
  initial
  begin
	$dumpfile("tb_wave.vcd");
	$dumpvars(0, CPU);

    Clk = 0;
    Start = 0;
    
    #(`CYCLE_TIME)
    
    Start = 1;
    #(`CYCLE_TIME*560)	
    
  $finish;
  end
  
  always@(posedge Clk) begin
  	$display("PC = %d", CPU.PC.pc_out_o);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[0], CPU.Data_Memory.memory[1], CPU.Data_Memory.memory[2], CPU.Data_Memory.memory[3], CPU.Data_Memory.memory[4], CPU.Data_Memory.memory[5], CPU.Data_Memory.memory[6], CPU.Data_Memory.memory[7]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[8], CPU.Data_Memory.memory[9], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[12], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[15]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[16], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[20], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[23]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[24], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[28], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[31]);
    $display("Registers");
    $display("R0 = %d, at = %d, v0 = %d, v1 = %d, a0 = %d, a1 = %d, a2 = %d, a3 = %d", CPU.RF.Reg_File[ 0], CPU.RF.Reg_File[ 1], CPU.RF.Reg_File[ 2], CPU.RF.Reg_File[ 3], CPU.RF.Reg_File[ 4], CPU.RF.Reg_File[ 5], CPU.RF.Reg_File[ 6], CPU.RF.Reg_File[ 7]);
    $display("t0 = %d, t1 = %d, t2 = %d, t3 = %d, t4 = %d, t5 = %d, t6 = %d, t7 = %d", CPU.RF.Reg_File[ 8], CPU.RF.Reg_File[ 9], CPU.RF.Reg_File[10], CPU.RF.Reg_File[11], CPU.RF.Reg_File[12], CPU.RF.Reg_File[13], CPU.RF.Reg_File[14], CPU.RF.Reg_File[15]);
    $display("t8 = %d, t9 = %d, s0 = %d, s1 = %d, s2 = %d, s3 = %d, s4 = %d, s5 = %d", CPU.RF.Reg_File[16], CPU.RF.Reg_File[17], CPU.RF.Reg_File[18], CPU.RF.Reg_File[19], CPU.RF.Reg_File[20], CPU.RF.Reg_File[21], CPU.RF.Reg_File[22], CPU.RF.Reg_File[23]);
    $display("s6 = %d, s7 = %d, k0 = %d, k1 = %d, gp = %d, sp = %d, fp = %d, ra = %d\n", CPU.RF.Reg_File[24], CPU.RF.Reg_File[25], CPU.RF.Reg_File[26], CPU.RF.Reg_File[27], CPU.RF.Reg_File[28], CPU.RF.Reg_File[29], CPU.RF.Reg_File[30], CPU.RF.Reg_File[31]);
  end

  always #(`CYCLE_TIME/2) Clk = ~Clk;	
  
endmodule

