// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder: every carry is computed
// directly (two-level, no rippling), exactly like cla4.v, just scaled to
// 64 bits. Add delays throughout (same convention as cla4.v) so it can be
// fairly compared against rca64.v and cla64_blocked.v.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:1] c;   // c[1]..c[64] are the 64 carries; think of cin as c[0]

  // ---------------------------------------------------------------------
  // Step 1: generate/propagate signals
  // ---------------------------------------------------------------------
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // ---------------------------------------------------------------------
  // Step 2: The 64 direct carry equations (Flat Two-Level SOP Logic)
  //
  // c[k] = g[k-1] 
  //        | (p[k-1] & g[k-2]) 
  //        | (p[k-1] & p[k-2] & g[k-3]) 
  //        ... 
  //        | (p[k-1] & ... & p[0] & cin)
  // ---------------------------------------------------------------------
  genvar k, j;
  generate
    for (k = 1; k <= 64; k = k + 1) begin : gen_carry
      // Each c[k] needs (k + 1) product terms
      wire [k:0] terms;

      // Term 0:cin propagation -> p[k-1] & p[k-2] & ... & p[0] & cin
      assign #(2) terms[0] = &{p[k-1:0], cin};

      // Term j: generation at bit (j-1) propagated to bit (k-1)
      for (j = 1; j < k; j = j + 1) begin : gen_terms
        assign #(2) terms[j] = g[j-1] & (&p[k-1:j]);
      end

      // Topmost term: direct generate at bit (k-1)
      assign #(2) terms[k] = g[k-1];

      // OR reduction across all terms to form c[k]
      assign #(2) c[k] = |terms;
    end
  endgenerate

  assign cout = c[64];

  // ---------------------------------------------------------------------
  // Step 3: sum bits
  // ---------------------------------------------------------------------
  assign #(2) sum = p ^ {c[63:1], cin};

endmodule