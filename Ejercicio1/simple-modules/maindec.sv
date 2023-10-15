// Main decoder module
module maindec (
    input logic [10 : 0] Op,
    output logic Reg2Loc,
    ALUSrc,
    MemtoReg,
    RegWrite,
    MemRead,
    MemWrite,
    Branch,
    MOVZ,
    output logic [1 : 0] ALUOp
);

  always_comb
    casez (Op)
      11'b111_1100_0010:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0111100000; // LDUR
      11'b111_1100_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b1100010000; // STUR
      11'b101_1010_0???:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b1000001010; // CBZ
      11'b100_0101_1000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0001000100; // ADD
      11'b110_0101_1000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0001000100; // SUB
      11'b100_0101_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0001000100; // AND
      11'b101_0101_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0001000100; // ORR
      11'b110_1001_01??:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b1101000011; // MOVZ
      default:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, MOVZ} = 10'b0; // Important: it never executes !!!
    endcase

endmodule
