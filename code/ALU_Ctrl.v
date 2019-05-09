//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
     
//Internal Signals
wire       [4-1:0] ALUCtrl_o;

//Parameter
       
//Select exact operation
assign ALUCtrl_o =  (ALUOp_i == 3'b010)?{|funct_i[5:4],funct_i[2:0]}:  //R_format
                    (ALUOp_i == 3'b000)?4'b1001:                    //lw,sw,addi +
                    (ALUOp_i == 3'b001)?4'b1011:                    //branch -
                    (ALUOp_i == 3'b101)?4'b1111:                    //lui
                    (ALUOp_i == 3'b100)?4'b0110:                    //ori
                    (ALUOp_i == 3'b011)?4'b0101:                    //sltiu
                    4'b0000;                                        //ALU do nothing
                    


endmodule     
