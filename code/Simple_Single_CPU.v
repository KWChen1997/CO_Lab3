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

//data wire
wire [31:00]pc_out;
wire [31:00]next_pc;
wire [31:00]adder1_o;
wire [31:00]adder2_o;
wire [31:00]instr_o;
wire [04:00]WriteReg;
wire [31:00]ALU_result;
wire [31:00]Data_Memory_o;
wire [31:00]SE_o;
wire [31:00]WriteSrc;
wire [31:00]RF_RD1;
wire [31:00]RF_RD2;
wire [31:0]Mux_ALUSrc_o;
wire [31:00]shifter_o;
wire [31:00]jump_addr;

//ctrl wire
wire [01:00]RegDst;
wire [01:00]RegWriteSrc;
wire RegWrite;
wire ALU_src;
wire [02:00]ALU_op;
wire MemRead;
wire MemWrite;
wire [01:00]Branch_type;
wire [01:00]PC_src;
wire [03:00]ALU_ctrl;
wire ALU_zero;
wire BC_o;


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

MUX_4to1 #(.size(5)) Mux_Write_Reg(
		.data0_i(instr_o[20:16]),
		.data1_i(instr_o[15:11]),
		.data2_i(5'd31),
		.data3_i(5'd0),
		.select_i(RegDst),
		.data_o(WriteReg)
);

MUX_4to1 #(.size(32)) Mux_Write_Reg_Src(
		.data0_i(ALU_result),
		.data1_i(Data_Memory_o),
		.data2_i(SE_o),
		.data3_i(adder1_o),
		.select_i(RegWriteSrc),
		.data_o(WriteSrc)
);
		
Reg_File RF(
		.clk_i(clk_i),	
		.rst_i(rst_i) ,	
		.RSaddr_i(instr_o[25-:5]) ,
		.RTaddr_i(instr_o[20-:5]) ,
		.RDaddr_i(WriteReg) ,
		.RDdata_i(WriteSrc)  ,
		.RegWrite_i(RegWrite),
		.RSdata_o(RF_RD1) ,
		.RTdata_o(RF_RD2)
		);
	
Decoder Decoder(
		.instr_op_i(instr_o[31-:6]),
		.funct_i(instr_o[5:0]),
		.RegWrite_o(RegWrite),
		.RegDst_o(RegDst),
		.RegWriteSrc_o(RegWriteSrc),
		.ALUSrc_o(ALU_src),
		.ALU_op_o(ALU_op),
		.MemRead_o(MemRead),
		.MemWrite_o(MemWrite),
		.Branch_type_o(Branch_type),
		.PC_src_o(PC_src)
		);

ALU_Ctrl AC(
		.funct_i(instr_o[5:0]),
		.ALUOp_i(ALU_op),
		.ALUCtrl_o(ALU_ctrl)
		);
	
Sign_Extend SE(
		.data_i(instr_o[15:0]),
		.data_o(SE_o)
		);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
		.data0_i(RF_RD2),
		.data1_i(SE_o),
		.select_i(ALU_src),
		.data_o(Mux_ALUSrc_o)
		);	
		
ALU ALU(
		.src1_i(RF_RD1),
		.src2_i(Mux_ALUSrc_o),
		.ctrl_i(ALU_ctrl),
		.shamt_i (instr_o[10-:5]),
		.result_o(ALU_result),
		.zero_o(ALU_zero)
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
		
	

// lab 3

Shift_Left_Two_32 Shifter_jump(
	.data_i({{6{1'b0}},instr_o[25:0]}),
	.data_o(jump_addr)
);


Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALU_result),
	.data_i(RF_RD2),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(Data_Memory_o)
);

Branch_Ctrl BC(
	.Branch_type_i(Branch_type),
	.zero_i(ALU_zero),
	.sign_i(ALU_result[31]),
	.Branch_Ctrl_o(BC_o)
);

MUX_4to1 #(.size(32)) Mux_PC_Src(
	.data0_i(adder1_o),
	.data1_i(adder2_o),
	.data2_i(RF_RD1),
	.data3_i(jump_addr),
	.select_i({PC_src[1],PC_src[0]&BC_o}),
	.data_o(next_pc)
);

endmodule
		

// MUX_2to1 #(.size(5)) Mux_Write_Reg(
// 		.data0_i(instr_o[15-:5]),
// 		.data1_i(instr_o[20-:5]),
// 		.select_i(decoder_RD),
// 		.data_o(M1_o)
// 		);

// MUX_2to1 #(.size(32)) Mux_PC_Source(
// 		.data0_i(adder1_o),
// 		.data1_i(adder2_o),
// 		.select_i(decoder_b&BC_o),
// 		.data_o(M3_o)
// 		);

// MUX_2to1 #(.size(32)) MUX_jump_source(
// 		.data0_i({adder1_o[31:28],jump_addr[27:0]}),
// 		.data1_i(RF_RD1),
// 		.select_i(isJr),
// 		.data_o(M4_o)
// );

// MUX_2to1 #(.size(32)) Mux_jump(
// 		.data0_i(M4_o),
// 		.data1_i(M3_o),
// 		.select_i(Jump ^ isJr),
// 		.data_o(next_pc)
// );

// MUX_2to1 #(.size(32)) RF_Write_data_source(
// 		.data0_i(Data_Memory_o),
// 		.data1_i(adder1_o),
// 		.select_i(decoder_link_o),
// 		.data_o(M5_o)
// );

// MUX_2to1 #(.size(5)) M6(
// 		.data0_i(M1_o),
// 		.data1_i(5'd31),
// 		.select_i(decoder_link_o),
// 		.data_o(M6_o)
// );