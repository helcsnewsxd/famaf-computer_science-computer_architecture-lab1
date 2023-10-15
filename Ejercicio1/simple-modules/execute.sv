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
    output logic zero_E
);

  logic [N-1 : 0] y0_internal, y1_internal, y2_internal;

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

  alu #(N) ALU (
      .a(readData1_E),
      .b(y1_internal),
      .ALUControl(AluControl),
      .result(aluResult_E),
      .zero(zero_E)
  );

  assign writeData_E = readData2_E;

endmodule
