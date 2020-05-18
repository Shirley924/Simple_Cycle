module Reg(
	clk,
	rst,
	Read_reg1,  //rs
	Read_reg2,  //rt
	Write_reg,  //rd
	Write_data,
	RegWrite,   //enable
	Read_data1,
	Read_data2
);

parameter bit_size=32;

input clk, rst, RegWrite;
input [4:0] Read_reg1;
input [4:0] Read_reg2;
input [4:0] Write_reg;

input [bit_size-1:0] Write_data;

output [bit_size-1:0] Read_data1;
output [bit_size-1:0] Read_data2;

reg [bit_size-1:0] Register[0:31];

integer i;
/*initial begin
  for(i=0;i<32;i=i+1)
    Register[i]<=0;
end
*/

assign Read_data1=Register[Read_reg1];
assign Read_data2=Register[Read_reg2];

always @ (posedge clk or posedge rst) begin
  if(rst)
    for(i=0;i<32;i=i+1)
      Register[i]<=0;
  else if(RegWrite)
    Register[Write_reg]<=Write_data;
end

endmodule