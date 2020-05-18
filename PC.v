module PC ( 
	clk, 
	rst,
	PCin, 
	PCout
);
	
parameter bit_size = 32;
	
input  clk, rst;
input  [bit_size-1:0] PCin;
output reg [bit_size-1:0] PCout;

always @(posedge clk or posedge rst) begin
  if(rst)
    PCout<=0;
  else
    PCout<=PCin;
end
		   
endmodule