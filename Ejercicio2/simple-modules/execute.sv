// Execute module
module execute #(
    parameter N = 64
) (
    input logic AluSrc,
    input logic [3 : 0] AluControl,
    input logic [N-1 : 0] PC_E,
    signImm_E,
    readData1_E,
    readData2_E,
    output logic [N-1 : 0] PCBranch_E,
    aluResult_E,
    writeData_E,
    output logic zero_E,

    // FORWARDING
    input logic [4:0] IF_ID_rn,
    IF_ID_rm,
    ID_EX_rn,
    ID_EX_rm,
    EX_MEM_rd,
    MEM_WB_rd,
    input logic EX_MEM_regWrite,
    MEM_WB_regWrite,
    input logic [N-1 : 0] EX_MEM_aluResult,
    MEM_WB_aluResult
);

  logic [N-1 : 0] y0_internal, y1_internal, y2_internal;
  logic [2:0] forwardA, forwardB;
  logic [N-1 : 0] ALU_a, ALU_b;

  sl #(N) Shif_left_2 (
      .a(signImm_E),
      .y(y0_internal)
  );

  adder #(N) Add (
      .a(PC_E),
      .b(y0_internal),
      .y(PCBranch_E)
  );

  mux2 #(N) MUX (
      .d0(readData2_E),
      .d1(signImm_E),
      .s (AluSrc),
      .y (y1_internal)
  );

  // ------------------ FORWARDING ------------------

  FORWARDING_UNIT forwarding_unit (
      .EX_MEM_regWrite(EX_MEM_regWrite),
      .MEM_WB_regWrite(MEM_WB_regWrite),
      .ID_EX_rn1(ID_EX_rn),
      .ID_EX_rm2(ID_EX_rm),
      .EX_MEM_rd(EX_MEM_rd),
      .MEM_WB_rd(MEM_WB_rd),
      .forwardA(forwardA),
      .forwardB(forwardB)
  );

  mux4 #(N) MUX_forwardA (
      .d0(readData1_E),
      .d1(MEM_WB_aluResult),
      .d2(EX_MEM_aluResult),
      .d3(0),
      .s (forwardA),
      .y (ALU_a)
  );

  mux4 #(N) MUX_forwardB (
      .d0(y1_internal),
      .d1(MEM_WB_aluResult),
      .d2(EX_MEM_aluResult),
      .d3(0),
      .s (forwardB),
      .y (ALU_b)
  );

  // ------------------------------------------------

  alu #(N) ALU (
      .a(ALU_a),
      .b(ALU_b),
      .ALUControl(AluControl),
      .result(aluResult_E),
      .zero(zero_E)
  );

  assign writeData_E = readData2_E;

endmodule
