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
    output logic [1 : 0] ALUOp
);

  always_comb
    casez (Op)
      11'b111_1100_0010:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b011110000; // LDUR
      11'b111_1100_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b110001000; // STUR
      11'b101_1010_0???:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b100000101; // CBZ
      11'b100_0101_1000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b000100010; // ADD
      11'b110_0101_1000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b000100010; // SUB
      11'b100_0101_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b000100010; // AND
      11'b101_0101_0000:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b000100010; // ORR
      default:
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0; // Important: it never executes !!!
    endcase

endmodule
