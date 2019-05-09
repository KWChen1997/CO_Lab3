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
    //input
    instr_op_i,
    funct_i,

    //Register
    RegWrite_o,
    RegDst_o,
    RegWriteSrc_o,

    //ALU
    ALUSrc_o,

    //ALU Control
    ALU_op_o,

    //Data Memory
    MemRead_o,
    MemWrite_o,

    //Branch
    // Branch_o,
    Branch_type_o,

    //Jump
    // Jump_o,

    //PC source
    PC_src_o


    );
//I/O
    input   [6-1:0] instr_op_i;
    input   [6-1:0] funct_i;

    output  [2-1:0] RegDst_o;
    output          RegWrite_o;
    output  [2-1:0] RegWriteSrc_o;
    output          ALUSrc_o;
    output  [3-1:0] ALU_op_o;
    output          MemRead_o;
    output          MemWrite_o;
    // output          Branch_o;
    output  [2-1:0] Branch_type_o;
    // output          Jump_o;
    output  [2-1:0] PC_src_o;
//Parameter


//Main function
    wire  [2-1:0] RegDst_o;
    wire          RegWrite_o;
    wire  [2-1:0] RegWriteSrc_o;
    wire          ALUSrc_o;
    wire  [3-1:0] ALU_op_o;
    wire          MemRead_o;
    wire          MemWrite_o;
    wire          Branch_o;
    wire  [2-1:0] Branch_type_o;
    wire          Jump_o;
    wire  [2-1:0] PC_src_o;

//Register
    assign RegDst_o =   (instr_op_i == 6'b000011)? 2'b10:   //jal
                        (instr_op_i == 6'b000000 | Branch_o)? 2'b01:   //R-fromat
                        2'b00;                              //I-format
    assign RegWrite_o = ~(  Branch_o                                            //not Branch
                        |   (instr_op_i == 6'b000010)                           //not j
                        |   (instr_op_i == 6'b000000 && funct_i == 6'b001000)   //not jr
                        |   (instr_op_i == 6'b000000 && funct_i == 6'b000000)   //not nop
                        |   MemWrite_o
                        );
    assign RegWriteSrc_o =  (instr_op_i == 6'b000011)?2'b11:                    //jal
                            (instr_op_i == 6'b100011)?2'b01:                    //lw
                            (instr_op_i == 6'b001111)?2'b10:                    //li
                            2'b00;                                              //R-foramt
    assign ALUSrc_o = ~(instr_op_i == 6'b000000 | Branch_o);           //I-format
    assign ALU_op_o =   (instr_op_i == 6'b000000)?3'b010:   //R-format
                        (instr_op_i == 6'b100011            //lw
                        |instr_op_i == 6'b101011            //sw
                        |instr_op_i == 6'b001000)?3'b000:   //addi
                        (instr_op_i == 6'b000100            //beq
                        |instr_op_i == 6'b000011            //bne
                        |instr_op_i == 6'b000110            //ble
                        |instr_op_i == 6'b000001)?3'b001:   //bltz
                        (instr_op_i == 6'b001111)?3'b101:   //lui
                        (instr_op_i == 6'b001101)?3'b100:   //ori
                        (instr_op_i == 6'b001011)?3'b011:   //sltiu
                        3'b111;                             //don't care ex:j,jal,li
    assign MemRead_o = (instr_op_i == 6'b100011);
    assign MemWrite_o = (instr_op_i == 6'b101011);
    assign Branch_o = (instr_op_i == 6'b000100              //beq
                      |instr_op_i == 6'b000101              //bne
                      |instr_op_i == 6'b000110              //ble
                      |instr_op_i == 6'b000001);            //bltz
    assign Branch_type_o =  (instr_op_i == 6'b000100)?2'b10:    //beq
                            (instr_op_i == 6'b000011)?2'b11:    //bne
                            (instr_op_i == 6'b000110)?2'b00:    //ble
                            2'b01;                              //bltz
    assign Jump_o = (instr_op_i == 6'b000010                    //j
                    |instr_op_i == 6'b000011                    //jal
                    |(instr_op_i == 6'd0 && funct_i == 6'd8));  //jr
    assign PC_src_o =   (instr_op_i == 6'b000000 && funct_i == 6'b001000)?2'b10:    //jr
                        (Branch_o)?2'b01:                                           //branch
                        (instr_op_i == 6'b000010 | instr_op_i == 6'b000011)?2'b11:   //j,jal
                        2'b00;                                                      //normal


endmodule





                    
                    