module SRAM(
    clk,
    rst,
    addr,
    read,
    write,
    DI,
    DO
);

parameter BYTES_SIZE     = 8;
module Mux_extend(
	select,
	choice1,
	choice2,
	choice3,
	out
);

parameter bit_size=32;

input [3:0] select;
input [bit_size-1:0] choice1;
input [bit_size-1:0] choice2;
input [bit_size-1:0] choice3;
output reg [bit_size-1:0] out;

always @ (*) begin
  case(select)
    2: out<=choice2;
    3: out<=choice2;
    4: out<=choice3;
    5: out<=choice3;
    default: out<=choice1;
  endcase
end

endmodule