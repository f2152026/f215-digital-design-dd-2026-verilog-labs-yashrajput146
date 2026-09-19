// and_df.v
// Dataflow implementation with delay (Inertial delay model)

module and_df (
    input  a,
    input  b,
    output y
);

  // Default delay set to 5 (update value to #1, #2, or #3 for parts a-c)
  assign #5 y = a & b;

endmodule