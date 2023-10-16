// 4:1 Multiplexer module
module mux4 #(
    parameter N = 64
) (
    input logic [N-1 : 0] d0,
    d1,
    d2,
    d3,
    input logic [1:0] s,
    output logic [N-1 : 0] y
);

  logic [N-1 : 0] aux_y1, aux_y2;

  mux2 #(N) mux2_1 (
      .d0(d0),
      .d1(d1),
      .s (s[0]),
      .y (aux_y1)
  );

  mux2 #(N) mux2_2 (
      .d0(d2),
      .d1(d3),
      .s (s[0]),
      .y (aux_y2)
  );

  mux2 #(N) mux2_3 (
      .d0(aux_y1),
      .d1(aux_y2),
      .s (s[1]),
      .y (y)
  );

endmodule
