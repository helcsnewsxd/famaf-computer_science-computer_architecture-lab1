// Async Flip-Flop D with Enable
module flopr #(
    parameter N = 64
) (
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [N-1 : 0] d,
    output logic [N-1 : 0] q
);

  always_ff @(posedge clk or posedge reset)
    if (reset) begin
      q <= '0;
    end else if (enable) begin
      q <= d;
    end

endmodule
