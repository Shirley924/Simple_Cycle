module Jump_type(
	Branch,
	Zero,
	Jump,
	Jump_addr,
	JumpOp
);

input Branch, Zero, Jump, Jump_addr;
output reg [1:0] JumpOp;

always @ (*) begin
  if(Zero && Branch)  //bne,beq
    JumpOp<=1;
  else if(Jump_addr)  //jr
    JumpOp<=2;
  else if(Jump)       //jump
    JumpOp<=3;
  else
    JumpOp<=0;
end

endmodule