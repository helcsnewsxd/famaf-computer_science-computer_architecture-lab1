// Execute module
module execute #(
    parameter N = 64
) (
    input logic AluSrc,
    regWrite_EX_MEM,  // FORWARDING
    regWrite_MEM_WB,  // FORWARDING
    input logic [3 : 0] AluControl,
    input logic [N-1 : 0] PC_E,
    signImm_E,
    readData1_E,
    readData2_E,
    input logic [4 : 0] ra1_ID_EX, // FORWARDING
    ra2_ID_EX, // FORWARDING
    rd_EX_MEM,  // FORWARDING
    rd_MEM_WB,  // FORWARDING
    output logic [N-1 : 0] PCBranch_E,
    aluResult_E,
    writeData_E,
    output logic zero_E
);

  logic [N-1 : 0] y0_internal, y1_internal, y2_internal;

  // FORWARDING UNIT

  logic [2 : 0] forwardingA, forwardingB;

  // EX hazard
  
  if(regWrite_EX_MEM && rd_EX_MEM !== 31 && rd_EX_MEM === ra2_ID_EX)
    forwardingA = 2'b10;
  
  if(regWrite_EX_MEM && rd_EX_MEM !== 31 && rd_EX_MEM === ra1_ID_EX)
    forwardingB = 2'b10;

  // MEM hazard
  if((regWrite_MEM_WB && rd_MEM_WB !== 31 && !(regWrite_EX_MEM && (rd_EX_MEM !== 31)) && rd_EX_MEM !== ra2_ID_EX) && rd_MEM_WB === ra2_ID_EX)
    forwardingA = 2'b01;

  IF((regWrite_MEM_WB && rd_MEM_WB !== 31 && !(regWrite_EX_MEM && (rd_EX_MEM !== 31)) && rd_EX_MEM !== ra1_ID_EX) AND rd_MEM_WB === ra1_ID_EX)
    forwardingB = 2'b01;

  // ---------------

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
