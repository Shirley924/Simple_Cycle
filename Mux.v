module Mux(
	select,
	choice1,
	choice2,
	out
);

parameter bit_size=32;

input select;
input [bit_size-1:0] choice1;
input [bit_size-1:0] choice2;
output [bit_size-1:0] out;

assign out=select?choice1:choice2;

endmodule