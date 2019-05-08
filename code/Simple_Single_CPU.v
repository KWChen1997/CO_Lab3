//Subject:	 CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:	 1
//--------------------------------------------------------------------------------
//Writer:	
//----------------------------------------------
//Date:		
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
		clk_i,
		rst_i
		);
		
//I/O port
input		 clk_i;
input		 rst_i;

//Internal Signles

wire [31:0]pc_out;
wire [31:0]next_pc;
wire [31:0]adder1_o;
wire [31:0]adder2_o;
wire [31:0]instr_o;
wire [4:0]M1_o;
wire [31:0]alu_result;
wire decoder_RW;
wire decoder_RD;
wire [31:0]RF_RD1;
wire [31:0]RF_RD2;
wire [31:0]M2_o;
wire [2:0]decoder_alu_op;
wire decoder_src_o;
wire [31:0]SE_o;
wire [31:0]shifter_o;
wire [3:0]alu_ctrl;
wire decoder_b;
wire alu_zero;
wire [27:0]jump_addr;
wire [31:0]M3_o;
wire decoder_MemR;
wire decoder_MemW;
wire [31:0]Data_Memory_o;

//Greate componentes
ProgramCounter PC(
		.clk_i(clk_i),	
		.rst_i (rst_i),	
		.pc_in_i(next_pc) ,
		.pc_out_o(pc_out)
		);
	
Adder Adder1(
		.src1_i(pc_out),	
		.src2_i(32'd4),	
		.sum_o(adder1_o)
		);
	
Instr_Memory IM(
		.addr_i(pc_out),
		.instr_o(instr_o)	
		);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
		.data0_i(instr_o[15-:5]),
		.data1_i(instr_o[20-:5]),
		.select_i(decoder_RD),
		.data_o(M1_o)
		);	
		
Reg_File RF(
		.clk_i(clk_i),	
		.rst_i(rst_i) ,	
		.RSaddr_i(instr_o[25-:5]) ,
		.RTaddr_i(instr_o[20-:5]) ,
		.RDaddr_i(M1_o) ,
		.RDdata_i(Data_Memory_o)  ,
		.RegWrite_i(decoder_RW),
		.RSdata_o(RF_RD1) ,
		.RTdata_o(RF_RD2)
		);
	
Decoder Decoder(
		.instr_op_i(instr_o[31-:6]),
		.RegWrite_o(decoder_RW),
		.ALU_op_o(decoder_alu_op),
		.ALUSrc_o(decoder_src_o),
		.RegDst_o(decoder_RD),
		.Branch_o(decoder_b),
		.Jump_o(Jump),
		.MemRead_o(decoder_MemR),
		.MemWrite_o(decoder_MemW)
		);

ALU_Ctrl AC(
		.funct_i(instr_o[5-:6]),
		.ALUOp_i(decoder_alu_op),
		.ALUCtrl_o(alu_ctrl)
		);
	
Sign_Extend SE(
		.data_i(instr_o[15:0]),
		.data_o(SE_o)
		);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
		.data0_i(RF_RD2),
		.data1_i(SE_o),
		.select_i(decoder_src_o),
		.data_o(M2_o)
		);	
		
ALU ALU(
		.src1_i(RF_RD1),
		.src2_i(M2_o),
		.ctrl_i(alu_ctrl),
		.shamt_i (instr_o[10-:5]),
		.result_o(alu_result),
		.zero_o(alu_zero)
		);
		
Adder Adder2(
		.src1_i(adder1_o),	
		.src2_i(shifter_o),	
		.sum_o(adder2_o)	
		);
		
Shift_Left_Two_32 Shifter(
		.data_i(SE_o),
		.data_o(shifter_o)
		); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
		.data0_i(adder1_o),
		.data1_i(adder2_o),
		.select_i(decoder_b&(alu_zero)),
		.data_o(M3_o)
		);	

// lab 3

Shift_Left_Two_32 Shifter_jump(
	.data_i(instr_o[25:0]),
	.data_o(jump_addr)
);

MUX_2to1 #(.size(32)) Mux_jump(
		.data0_i({adder1_o[31:28],jump_addr}),
		.data1_i(M3_o),
		.select_i(Jump),
		.data_o(next_pc)
);

Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(alu_result),
	.data_i(RF_RD2),
	.MemRead_i(decoder_MemR),
	.MemWrite_i(decoder_MemW),
	.data_o(Data_Memory_o)
);

endmodule
		


