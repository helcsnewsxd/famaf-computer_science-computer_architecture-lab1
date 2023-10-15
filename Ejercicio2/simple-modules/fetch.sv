// Fetch module
module fetch #(
    parameter N = 64
) (
    input logic PCSrc_F,
    clk,
    reset,
    enable,
    input logic [N-1 : 0] PCBranch_F,
    output logic [N-1 : 0] imem_addr_F
);

  logic [N-1 : 0] d_internal, next_instruction_internal, b_internal = 4;

  mux2 #(N) MUX (
      .d0(next_instruction_internal),
      .d1(PCBranch_F),
      .s (PCSrc_F),
      .y (d_internal)
  );

  flopr #(N) PC (
      .clk(clk),
      .reset(reset),
      .enable(enable),
      .d(d_internal),
      .q(imem_addr_F)
  );

  adder #(N) Add (
      .a(imem_addr_F),
      .b(b_internal),
      .y(next_instruction_internal)
  );

endmodule
