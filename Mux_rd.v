module Mux_rd(
	select,
	choice1,
	choice2,
	choice3,
	choice4,
	choice5,
	out
);

parameter bit_size=32;

input [3:0] select;
input [bit_size-1:0] choice1;
input [bit_size-1:0] choice2;
input [bit_size-1:0] choice3;
input [bit_size-1:0] choice4;
input [bit_size-1:0] choice5;
output reg [bit_size-1:0] out;

always @ (*) begin
  case(select)
    4'b0101: out<=choice1;
    4'b0100: out<=choice2;
    4'b0010: out<=choice4;
    4'b1000: out<=choice5;
    default: out<=choice3;
  endcase
end

endmodule