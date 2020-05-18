module sign_extend(
	offset,
	turn_out
);

parameter bit_size=32;
parameter imm_size=12;

input [imm_size-1:0] offset;
output reg [bit_size-1:0] turn_out;

always @ (offset) begin
  turn_out[imm_size-1:0]=offset[imm_size-1:0];
  turn_out[bit_size-1:imm_size]={(bit_size-imm_size){offset[imm_size-1]}};  //repeat the first digit of offset
end

endmodule