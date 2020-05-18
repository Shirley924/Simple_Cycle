module Controller(
	Opcode,
	funct3,
	funct7,
	RegDst,          //RegDst==1, use rt; else, use imm
	RegWrite,        //RegWrite==1,write rd
	MemRead,         //read data from memory
	MemWrite,
	Branch,          //beg,bne
	j,jal,
	ALUOp,
	extend_h,         //1h,sh
	extend_b,
	s,
	u,
	p,
	type
);

input [6:0] Opcode;
input [2:0] funct3;
input [6:0] funct7;

output reg [3:0] ALUOp;
output reg [3:0] type;   // 0:R ; 1:I ; 2:S ; 3:B ; 4:U ;5:J
output reg [3:0] MemWrite;
output reg RegDst, RegWrite, MemRead, Branch, j, jal, extend_h, extend_b, s, p, u;

always @ (*) begin
  RegDst <= 1;
  extend_h <= 0;
  extend_b <= 0;
  s<=0;
  u<=0;
  p<=0;
  type<=0;
  Branch <= 0; 
  MemWrite <= 0;
  MemRead <= 0;
  RegWrite <= 1;
  j <= 0;
  jal <= 0;

  case(Opcode)
    //R-type
    7'b0110011: begin
      RegDst<=1;
      type<=0;
      case(funct3)
	  3'b000: begin
	    case(funct7)
	      7'b0000000:  //add
		ALUOp<=1;
	      7'b0100000:  //sub
		ALUOp<=2;
	    endcase
	  end
	  3'b001: begin    //sll
	    ALUOp<=8;
	    u<=1;
	  end
	  3'b010: begin     //slt
	    ALUOp<=7;
	    s<=1;
	  end
	  3'b011: begin     //sltu
	    ALUOp<=14;
	    u<=1;
	  end
	  3'b100:           //xor
	    ALUOp<=5;
	  3'b101: begin
	    case(funct7)
	      7'b0000000: begin  //srl
		ALUOp<=9;
		u<=1;
	      end
	      7'b0100000: begin  //sra
		ALUOp<=13;
		s<=1;
	      end
	    endcase
	  end
	  3'b110:           //or
	    ALUOp<=4;
	  3'b111:          //and
	    ALUOp<=3;
      endcase
    end

    //I-type
    7'b0000011: begin 
      type<=1;
      case(funct3)
          3'b010: begin //lw
            RegDst<=0;
            MemRead<=1;
            ALUOp<=1;
          end
	  3'b000: begin //lb
            ALUOp<=1;
            RegDst<=0;
            MemRead<=1;
            extend_b<=1;
            s<=1;
	  end
	  3'b001: begin //lh
	    ALUOp<=1;
            RegDst<=0;
            MemRead<=1;
            extend_h<=1;
            s<=1;
	  end
	  3'b100: begin //lbu
            ALUOp<=1;
            RegDst<=0;
            MemRead<=1;
            extend_b<=1;
	    u<=1;
	  end
	  3'b101: begin //lhu
	    ALUOp<=1;
            RegDst<=0;
            MemRead<=1;
            extend_h<=1;
	    u<=1;
	  end
      endcase
    end
    7'b0010011: begin
      type<=1;
      case(funct3)
	3'b000: begin //addi
          ALUOp<=1;
          RegDst<=0;
	end
        3'b010: begin //slti
	  ALUOp<=7;
	  RegDst<=0;
	  s<=1;
	end
        3'b011: begin //sltu
	  ALUOp<=14;
	  RegDst<=0;
	  u<=1;
	end
        3'b100: begin //xori
	  ALUOp<=5;
	  RegDst<=0;
	end
        3'b110: begin //ori
	  ALUOp<=4;
	  RegDst<=0;
	end
        3'b111: begin //andi
	  ALUOp<=3;
	  RegDst<=0;
	end
        3'b001: begin //slli
	  ALUOp<=8;
	  RegDst<=0;
	  u<=1;
	end
        3'b101: begin //srli
	  ALUOp<=9;
	  RegDst<=0;
	  u<=1;
	end
        3'b101: begin //srai
	  ALUOp<=13;
	  RegDst<=0;
	  s<=1;
	end
      endcase
    end
    7'b1100111: begin //jalr
      type<=1;
      ALUOp<=1;
      RegDst<=0;
      jal<=1;
    end

    //S-type
    7'b0100011: begin
      type<=2;
      case(funct3)
	3'b010: begin //sw
	  ALUOp<=1;
	  RegWrite<=4'b1111;
	  MemWrite<=1;
	end
	3'b000: begin //sb
	  ALUOp<=1;
	  RegWrite<=0;
	  MemWrite<=4'b0001;
	  extend_b<=1;
	end
	3'b001: begin //sh
	  ALUOp<=1;
	  RegWrite<=0;
	  MemWrite<=4'b0011;
	  extend_h<=1;
	end
      endcase
    end

    //B-type
    7'b1100011: begin
      type<=3;
      case(funct3)
	3'b000: begin //beq
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=10;
	end
	3'b001: begin //bne
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=11;
	end
	3'b100: begin //blt
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=7;
	end
	3'b101: begin //bge
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=12;
	end
	3'b110: begin //bltu
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=14;
	end
	3'b111: begin //bgeu
	  RegWrite<=0;
	  Branch<=1;
	  ALUOp<=15;
	end
      endcase
    end

    //U-type
    7'b0010111: begin //auipc
      type<=4;
      RegDst<=0;
      ALUOp<=1;
      p<=1;
      j<=1;
    end
    7'b0110111: begin //lui
      type<=4;
      RegDst<=0;
      ALUOp<=1;
      j<=1;
    end

    //J-type
    7'b1101111: begin //jal
      type<=5;
      jal<=1;
      RegDst<=0;
    end

  endcase
end

endmodule