module DM(
	clk,
	rst,
	s, u,
	Addr,     //memory address
	Write_Data,         //memory adress contents
	MemWrite,   // 0100: half_word ; 0010: byte ; 0001: normal
	MemRead,    //signal to read data
	Read_Data          //output
);

parameter offset_size=12;
parameter bit_size=32;

input clk, rst, MemRead;
input s, u;
input [3:0] MemWrite;
input [bit_size-1:0] Addr;       //attention here
input [bit_size-1:0] Write_Data;
output reg [bit_size-1:0] Read_Data;

reg [bit_size-1:0] Memory [0:2**offset_size-1];  //create 2^offset_size memory to store the value

integer i;

/*initial begin
  Read_Data<=0;
  for(i=0;i<2**offset_size;i=i+1)
    Memory[i]<=0;
end
*/

always @ (posedge clk or posedge rst) begin
  if(rst)
    for(i=0;i<2**offset_size;i=i+1)
      Memory[i]<=0;
  else if(MemWrite===4'b0011)   //store half word
    Memory[Addr]<={16'b0,Write_Data[15:0]};
  else if(MemWrite===4'b0001)   //store byte
    Memory[Addr]<={24'b0,Write_Data[7:0]};
  else if(MemWrite===4'b1111)  //store
    Memory[Addr]<=Write_Data;
  
  else if(s && MemWrite===4'b0001)
    Read_Data=$signed({24'b0,Memory[Addr][7:0]});
  else if(s && MemWrite===4'b0011)
    Read_Data=$signed({16'b0,Memory[Addr][15:0]});
  else if(u && MemWrite===4'b0001)
    Read_Data=$unsigned({24'b0,Memory[Addr][7:0]});
  else if(u && MemWrite===4'b0011)
    Read_Data=$unsigned({16'b0,Memory[Addr][15:0]});
  else
    Read_Data<=Memory[Addr];
end

endmodule