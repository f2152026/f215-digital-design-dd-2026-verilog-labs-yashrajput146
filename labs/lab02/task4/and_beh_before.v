// and_beh_before.v
// Delay placed BEFORE statement execution

module and_beh_before (
    input      a,
    input      b,
    output reg y
);

  always @(*) begin
    // Waits delay units FIRST, then evaluates (a & b) at the LATER time
    #5 y = a & b;
  end

endmodule