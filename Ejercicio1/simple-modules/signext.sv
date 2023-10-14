// Immediate signed extension module
module signext #(
    parameter N = 64
) (
    input  logic [ 31 : 0] a,
    output logic [N-1 : 0] y
);

  always_comb
    casez (a[31 : 21])
      11'b111_1100_0010: y = {{(N - 9) {a[20]}}, a[20 : 12]};  // LDUR
      11'b111_1100_0000: y = {{(N - 9) {a[20]}}, a[20 : 12]};  // STUR
      11'b101_1010_0???: y = {{(N - 19) {a[23]}}, a[23 : 5]};  // CBZ
      default: y = 0;
    endcase

endmodule
