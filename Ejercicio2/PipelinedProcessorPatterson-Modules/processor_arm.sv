// PIPELINED PROCESSOR

module processor_arm #(
    parameter N = 64
) (
    input logic CLOCK_50,
    reset,
    output logic [N-1:0] DM_writeData,
    DM_addr,
    output logic DM_writeEnable,
    input logic dump
);

  logic [31:0] q;
  logic [ 3:0] AluControl;
  logic reg2loc, regWrite, AluSrc, Branch, memtoReg, memRead, memWrite, data_hazard;
  logic [N-1:0] DM_readData, IM_address;  //DM_addr, DM_writeData
  logic DM_readEnable;  //DM_writeEnable
  logic [10:0] instr;

  controller c (
      .instr(instr),
      .AluControl(AluControl),
      .reg2loc(reg2loc),
      .regWrite(regWrite),
      .AluSrc(AluSrc),
      .Branch(Branch),
      .memtoReg(memtoReg),
      .memRead(memRead),
      .memWrite(memWrite)
  );


  datapath #(64) dp (
      .reset(reset),
      .clk(CLOCK_50),
      .reg2loc(reg2loc),
      .AluSrc(AluSrc),
      .AluControl(AluControl),
      .Branch(Branch),
      .memRead(memRead),
      .memWrite(memWrite),
      .regWrite(regWrite),
      .memtoReg(memtoReg),
      .data_hazard(data_hazard),
      .IM_readData(q),
      .DM_readData(DM_readData),
      .IM_addr(IM_address),
      .DM_addr(DM_addr),
      .DM_writeData(DM_writeData),
      .DM_writeEnable(DM_writeEnable),
      .DM_readEnable(DM_readEnable)
  );


  imem instrMem (
      .addr(IM_address[9:2]),
      .q(q)
  );


  dmem dataMem (
      .clk(CLOCK_50),
      .memWrite(DM_writeEnable),
      .memRead(DM_readEnable),
      .address(DM_addr[8:3]),
      .writeData(DM_writeData),
      .readData(DM_readData),
      .dump(dump)
  );


  flopr #(11) IF_ID_TOP (
      .clk(CLOCK_50),
      .reset(reset),
      .enable(data_hazard),
      .d(q[31:21]),
      .q(instr)
  );

endmodule