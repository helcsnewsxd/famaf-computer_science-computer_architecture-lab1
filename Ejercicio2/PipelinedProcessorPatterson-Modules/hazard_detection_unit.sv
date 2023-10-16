// HAZARD DETECTION UNIT

module HDU (
    input logic ID_EX_memRead,
    input logic [4:0] IF_ID_rn1,
    IF_ID_rm2,
    ID_EX_rd,
    output logic data_hazard
);

  always_comb begin
    if (ID_EX_memRead && (IF_ID_rn1 === ID_EX_rd || IF_ID_rm2 === ID_EX_rd)) data_hazard = 1'b1;
    else data_hazard = 1'b0;
  end

endmodule
