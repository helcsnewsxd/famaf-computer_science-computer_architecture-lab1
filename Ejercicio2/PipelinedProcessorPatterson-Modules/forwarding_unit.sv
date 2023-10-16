// FORWARDING UNIT

module FORWARDING_UNIT (
    input logic EX_MEM_regWrite,
    MEM_WB_regWrite,
    input logic [4:0] ID_EX_rn1,
    ID_EX_rm2,
    EX_MEM_rd,
    MEM_WB_rd,
    output logic [1:0] forwardA,
    forwardB
);

  always_comb begin
    forwardA = 2'b00;
    forwardB = 2'b00;

    // EX Hazard
    if (EX_MEM_regWrite && (EX_MEM_rd !== 31) && (EX_MEM_rd === ID_EX_rn1)) forwardA = 2'b10;

    if (EX_MEM_regWrite && (EX_MEM_rd !== 31) && (EX_MEM_rd === ID_EX_rm2)) forwardB = 2'b10;

    // MEM Hazard
    if (MEM_WB_regWrite && (MEM_WB_rd !== 31) && ~(EX_MEM_regWrite && (EX_MEM_rd !== 31) && EX_MEM_rd !== ID_EX_rn1) && (MEM_WB_rd === ID_EX_rn1))
      forwardA = 2'b01;

    if (MEM_WB_regWrite && (MEM_WB_rd !== 31) && ~(EX_MEM_regWrite && (EX_MEM_rd !== 31) && EX_MEM_rd !== ID_EX_rm2) && (MEM_WB_rd === ID_EX_rm2))
      forwardB = 2'b01;
  end

endmodule
