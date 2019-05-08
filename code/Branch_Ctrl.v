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

module Branch_Ctrl(
	Branch_type_i,
	zero_i,
	sign_i,
	Branch_Ctrl_o
	);

//I/O ports
input [2-1:0] Branch_type_i;
input         zero_i;
input         sign_i;

output        Branch_Ctrl_o;

//Internal Signals
wire          Branch_type_o;

assign Branch_Ctrl_o = ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b1010)//beq
                     | ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b1100)//bne
                     | ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b1101)//bne
                     | ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b0001)//ble
                     | ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b0010)//ble
                     | ({ Branch_type_i[1:0], zero_i, sign_i } == 4'b0101)//bltz
                     ;

endmodule