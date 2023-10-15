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
      // MOVZ:
      11'b110_1001_0100: y = {{(N - 16) {1'b0}}, a[20 : 5]};  // LSL 00
      11'b110_1001_0101: y = {{(N - 32) {1'b0}}, a[20 : 5], 16'b0};  // LSL 01
      11'b110_1001_0110: y = {{(N - 48) {1'b0}}, a[20 : 5], 32'b0};  // LSL 10
      11'b110_1001_0111: y = {{(N - 64) {1'b0}}, a[20 : 5], 48'b0};  // LSL 11
      default: y = 0;
    endcase

endmodule
