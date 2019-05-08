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
reg        [4-1:0] ALUCtrl_o;
wire       [3:0]   funct_op;
wire    [3:0]Rformat_o;
wire    [3:0]Branch_o;
wire    [3:0]Ori_o;
wire    [3:0]Jump_o;

//Parameter
       
//Select exact operation

// assign funct_op = {|funct_i[5:4], funct_i[2:0]};
assign Rformat_o = {|funct_i[5:4], funct_i[2:0]};

always@(*)begin
    case(ALUOp_i)
        3'b010:
            ALUCtrl_o <= Rformat_o;
        3'b000:
            ALUCtrl_o <= 4'b1001;
        3'b001:
            ALUCtrl_o <= 4'b1011;
        3'b101:
            ALUCtrl_o <= 4'b1111;
        3'b100:
            ALUCtrl_o <= 4'b0110;
        3'b011:
            ALUCtrl_o <= 4'b0101;
        default:
            ALUCtrl_o <= 4'd1;
    endcase
end

endmodule     
