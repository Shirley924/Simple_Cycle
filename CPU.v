// Please include verilog file if you write module in other file
`include "PC.v"
`include "Controller.v"
`include "Reg.v"
`include "sign_extend.v"
`include "Add.v"
`include "DM.v"
`include "ALU.v"
`include "Mux.v"
`include "Mux_rd.v"
`include "Mux_extend.v"

module CPU(
    input             clk,
    input             rst,
    input      [31:0] data_out,    //the data send from DM
    input      [31:0] instr_out,   //the instruction send from IM
    output reg        instr_read,  //whether the instruction should be read in IM
    output            data_read,   //whether the instruction should be read in DM
    output reg [31:0] instr_addr,  //instruction address in IM
    output     [31:0] data_addr,   //data address in DM
    output reg [3:0]  data_write,  //the byte of the data whether should be wrote in DM
    output reg [31:0] data_in      //data which will be wrote into DM
);

/* Add your design */
parameter bit_size=32;
parameter offset_size=12;
parameter imm_size=20;

// PC
wire [bit_size-1:0] PCin;
wire [bit_size-1:0] PC_add1;
wire [bit_size-1:0] PC_add2;
wire [bit_size-1:0] PCout;
wire [bit_size-1:0] PCout2;

//Register
wire [4:0] Read_reg1;
wire [4:0] Read_reg2;
wire [4:0] Write_reg;
wire [bit_size-1:0] Write_data;
wire [bit_size-1:0] Read_data1;
wire [bit_size-1:0] Read_data2;

//ALU
wire [31:0] b;
wire [4:0] shamt;
wire [31:0] out;
wire Zero;

//Controller
wire [6:0] Opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [3:0] ALUop;
wire [3:0] type;
wire RegDst, RegWrite;
wire Branch, j, jal, extend_h, extend_b, s, p, u;

//sign_extend
wire [bit_size-1:0] turn_out1;
wire [bit_size-1:0] turn_out2;
wire [bit_size-1:0] turn_out3;

//Add
wire [bit_size-1:0] summand;
wire [bit_size-1:0] sum;    //PC/rs2+imm
wire [bit_size-1:0] sum_4;  //PC+4

//Mux
wire [bit_size-1:0] result;
wire [bit_size-1:0] e_result;

/*connect the wire*/
//ALU
assign Opcode=instr_out[6:0];
assign funct3=instr_out[14:12];
assign funct7=instr_out[31:25];
assign shamt=instr_out[24:20];
//Reg
assign Read_reg1=instr_out[19:15];
assign Read_reg2=instr_out[24:20];
assign Write_reg=instr_out[11:7];
//DM
assign data_addr=out;
assign data_in=Read_data2;

always@(posedge clk) begin
	instr_read = 1;
	if(rst)
		instr_addr <= 0;
	else
		instr_addr <= PCin;
end

PC Pc(
	.clk(clk),
	.rst(rst),
	.PCin(PCin),
	.PCout(PCout));

Add#(bit_size) PC_add_4(
	.a(PCout),
	.b(32'd4),
	.out(PC_add1));

Controller control(
	.Opcode(Opcode),
	.funct3(funct3),
	.funct7(funct7),
	.RegDst(RegDst),
	.RegWrite(RegWrite),
	.MemRead(data_read),
	.MemWrite(data_write),
	.Branch(Branch),
	.j(j),.jal(jal),
	.ALUOp(ALUop),
	.extend_h(extend_h),
	.extend_b(extend_b),
	.s(s),.p(p),.u(u),.type(type));

sign_extend extend_12_I(
	.offset(instr_out[31:20]),
	.turn_out(turn_out1));

sign_extend extend_12(
	.offset({instr_out[31:25],5'b0}|{7'b0,instr_out[11:7]}),
	.turn_out(turn_out2));

sign_extend#(.imm_size(20)) extend_20(
	.offset(instr_out[31:12]),
	.turn_out(turn_out3));

Mux_extend extend(
	.select(type),
	.choice1(turn_out1),
	.choice2(turn_out2),
	.choice3(turn_out3),
	.out(e_result));

Mux Mux_add_pc(
	.select(jal),
	.choice1(Read_data1),
	.choice2(PC_add1),
	.out(summand));

Add add_pc(
	.a(summand),
	.b(e_result),
	.out(sum));

Mux mux_PC(
	.select(jal|Zero),
	.choice1(sum),
	.choice2(sum_4),
	.out(PCin));

Mux_rd Rd(
	.select({jal,3'b0}|{1'b0,j,2'b0}|{2'b0,data_read,1'b0}|{p,3'b0}),
	.choice1(sum),
	.choice2(e_result),
	.choice3(out),
	.choice4(data_out),
	.choice5(sum_4),
	.out(Wtite_data));

Reg register(
	.clk(clk),
	.rst(rst),
	.Read_reg1(Read_reg1),
	.Read_reg2(Read_reg2),
	.Write_reg(Write_reg),
	.Write_data(Write_data),
	.RegWrite(RegWrite),
	.Read_data1(Read_data1),
	.Read_data2(Read_data2));

Mux mux_ALU_input(
	.select(RegDst^(data_write>0)|jal),
	.choice1(Read_data2),
	.choice2(e_result),
	.out(b));

ALU alu(
	.ALUop(ALUop),
	.a(Read_data1),
	.b(b),
	.shamt(shamt),
	.out(out),
	.Zero(Zero));

DM Memory(
	.clk(clk),
	.rst(rst),
	.s(s), .u(u),
	.Addr(data_addr),
	.Write_Data(data_in),
	.MemWrite(data_write),
	.MemRead(data_read),
	.Read_Data(data_out));

endmodule