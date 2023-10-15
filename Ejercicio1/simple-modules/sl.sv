// Shift Left module
module sl #(
    parameter N = 64,
    parameter SHIFT = 2
) (
    input  logic [N-1 : 0] a,
    output logic [N-1 : 0] y
);

  assign y[SHIFT-1 : 0] = {{(SHIFT) {1'b0}}};

  assign y[N-1 : SHIFT] = a[N-SHIFT-1 : 0];

endmodule
