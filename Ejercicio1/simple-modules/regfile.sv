// Registers module
module regfile #(
    parameter N = 64
) (
    input logic clk,
    we3,
    input logic [4 : 0] ra1,
    ra2,
    wa3,
    input logic [N-1 : 0] wd3,
    output logic [N-1 : 0] rd1,
    rd2
);

  // registers array and init
  logic [N-1 : 0] X[0 : 31] = '{
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      0
  };

  // read (async)
  always_comb begin
    rd1 = (we3 && wa3 !== 31 && wa3 === ra1 ? wd3 : X[ra1]);
    rd2 = (we3 && wa3 !== 31 && wa3 === ra2 ? wd3 : X[ra2]);
  end

  // write (sync)
  always @(posedge clk) if (we3 && wa3 !== 31) X[wa3] <= wd3;

endmodule
