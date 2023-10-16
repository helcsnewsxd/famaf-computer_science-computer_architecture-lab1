// Etapa: DECODE

module decode #(
    parameter N = 64
) (
    input logic regWrite_D,
    reg2loc_D,
    clk,
    input logic [N-1:0] writeData3_D,
    input logic [31:0] instr_D,
    input logic [4:0] wa3_D,
    output logic [N-1:0] signImm_D,
    readData1_D,
    readData2_D,

    // DATA HAZARDS
    input logic [4:0] ID_EX_rd,
    input logic ID_EX_memRead,
    output logic data_hazard,

    // FORWARDING
    output logic [4:0] IF_ID_rn,
    IF_ID_rm

);  // Eliminar para single cycle processor

  assign IF_ID_rn = instr_D[9:5];

  // ------------------ HDU ------------------
  HDU hdu (
      .ID_EX_memRead(ID_EX_memRead),
      .IF_ID_rn1(IF_ID_rn),
      .IF_ID_rm2(IF_ID_rm),
      .ID_EX_rd(ID_EX_rd),
      .data_hazard(data_hazard)
  );
  // -----------------------------------------

  mux2 #(5) ra2mux (
      .d0(instr_D[20:16]),
      .d1(instr_D[4:0]),
      .s (reg2loc_D),
      .y (IF_ID_rm)
  );

  regfile registers (
      .clk(clk),
      .we3(regWrite_D),
      .ra1(IF_ID_rn),
      .ra2(IF_ID_rm),
      .wa3(wa3_D),
      .wd3(writeData3_D),
      .rd1(readData1_D),
      .rd2(readData2_D)
  );

  // En single cycle processor:						
  //regfile registers (.clk(clk), .we3(regWrite_D), .ra1(instr_D[9:5]), .ra2(ra2), .wa3(instr_D[4:0]), 
  //							 .wd3(writeData3_D), .rd1(readData1_D), .rd2(readData2_D));


  signext ext (
      .a(instr_D),
      .y(signImm_D)
  );

endmodule
