module Add(
	a,
	b,
	out
);

parameter size=32;

input [size-1:0] a;
input [size-1:0] b;
output reg [size-1:0] out;

assign out=a+b;

endmodule