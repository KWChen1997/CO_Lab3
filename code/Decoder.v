//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Branch_type_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
output [1:0]   Branch_type_o;
output		   Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
output		   MemtoReg_o;

//Internal Signals
wire    [3-1:0] ALU_op_o;
wire            ALUSrc_o;
wire            RegWrite_o;
wire            RegDst_o;
wire            Branch_o;
wire		   Jump_o;
wire		   MemRead_o;
wire		   MemWrite_o;
wire		   MemtoReg_o;
wire    [1:0]  Branch_type_o;

wire beq_ne;

wire R_format;
//Parameter


//Main function
assign R_format 	= (instr_op_i == 6'b000000);
assign beq_ne 		= instr_op_i[5:1] == 5'b00010 ? 1 : 0;

assign Jump_o 		= ~(instr_op_i == 6'b000010);
assign MemRead_o 	= (instr_op_i == 6'b100011);
assign MemWrite_o 	= (instr_op_i == 6'b101011);
assign RegDst_o 	= ~R_format;
assign ALUSrc_o 	= instr_op_i[5] | instr_op_i[3];f
assign RegWrite_o 	= ~(Branch_o | ~Jump_o | MemWrite_o);
assign Branch_o 	= 	(instr_op_i == 6'b000100)
                    &	(instr_op_i == 6'b000101)
                    &	(instr_op_i == 6'b000110)
                    &	(instr_op_i == 6'b000001)
                    ;
assign ALU_op_o[2] = (instr_op_i[5:1]					==	5'b00001)	//a'b'c'd'e
                    |(instr_op_i[5:2]					==	4'b0011);	//a'b'cd
assign ALU_op_o[1] = ({instr_op_i[5:4],instr_op_i[2:1]}	==	4'b0001)	//a'b'd'e
                    |({instr_op_i[5:2],instr_op_i[0]}	==	5'b00001);	//a'b'c'd'f
assign ALU_op_o[0] = (instr_op_i[5:2]					==	4'b0001)	//a'b'c'd
                    |({instr_op_i[5:4],instr_op_i[1]}	==	3'b001)		//a'b'e
                    |({instr_op_i[5:3],instr_op_i[0]}	==	4'b0001);	//a'b'c'f

assign Branch_type_o = {instr_op_i[2]^instr_op_i[1],instr_op_i[0]};


endmodule





                    
                    