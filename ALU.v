module ALU(
	ALUop,
	a,
	b,
	shamt,
	out,
	Zero
);

input [3:0] ALUop;
input [31:0] a;
input [31:0] b;
input [4:0] shamt;
output reg [31:0] out;
output reg Zero;

always @ (ALUop or a or b or shamt) begin
  case(ALUop)
    1: out=a+b;          //add
    2: out=a-b;          //subtract
    3: out=a&b;          //and
    4: out=a|b;          //or
    5: out=a^b;          //xor
    6: out=~(a|b);       //nor
    7: out=($signed(a)<$signed(b))?1:0;    //slt
    8: out=$unsigned(a)<<shamt;     //sll
    9: out=$unsigned(a)>>shamt;     //srl
    10: out=(a==b)?1:0;  //beq
    11: out=(a!=b)?1:0;  //bne
    12: out=($signed(b)<$signed(a))?1:0;   //bge
    13: out=$signed(a)>>shamt;  //sra
    14: out=($unsigned(a)<$unsigned(b))?1:0;   //sltu
    15: out=($unsigned(b)<$unsigned(a))?1:0;   //bgeu
    default: out<=0;
  endcase

  Zero=(out|0)?1:0;      //if every bit of out=0, then Zero=1

end

endmodule