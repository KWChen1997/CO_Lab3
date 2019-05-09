//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	shamt_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   shamt_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);

always@(*)begin
	case(ctrl_i)
		//R type
		4'b1100/*12*/: result_o <= src1_i & src2_i;
		4'b1101/*13*/: result_o <= src1_i | src2_i;
		4'b1001/* 9*/: result_o <= src1_i + src2_i;
		4'b1011/*11*/: result_o <= src1_i - src2_i;
		4'b1010/*10*/: result_o <= src1_i < src2_i;
		4'b0011/* 3*/: result_o <= $signed(src2_i) >>> shamt_i; //sra
		4'b0111/* 7*/: result_o <= $signed(src2_i) >>> src1_i; //srav
		//I type
		4'b0101/* 5*/: result_o <= src1_i < (src2_i & 32'h0000FFFF); //sltiu
		4'b1111/*15*/: result_o <= src2_i << 16; //lui
		4'b0110/* 6*/: result_o <= src1_i | (src2_i & 32'h0000FFFF); //ori
		4'b1000/* 8*/: result_o <= src1_i * src2_i;
		4'b0000/* 0*/: result_o <= 32'd0;


		default: result_o <= 0;
	endcase
end

endmodule





                    
                    