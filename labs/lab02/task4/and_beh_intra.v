// and_beh_intra.v
// Delay placed INTRA-assignment

module and_beh_intra (
    input      a,
    input      b,
    output reg y
);

  always @(*) begin
    // Evaluates (a & b) IMMEDIATELY, then delays assignment to y
    y = #5 a & b;
  end

endmodule