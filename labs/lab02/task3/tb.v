// tb.v
// Self-checking testbench for 2-bit magnitude comparator (comp2)

module tb;

  // DUT Inputs & Outputs
  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  // Expected values and tracking counters
  reg        exp_gt, exp_lt, exp_eq;
  integer    errors = 0;
  integer    total = 0;
  integer    i, j;

  // Instantiate DUT
  comp2 DUT (
      .A (t_a),
      .B (t_b),
      .GT(t_gt),
      .LT(t_lt),
      .EQ(t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Test stimulus & self-checking loop
  initial begin
    t_a = 0;
    t_b = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];

        // Compute expected outputs independently in the testbench
        exp_gt = (i > j);
        exp_lt = (i < j);
        exp_eq = (i == j);

        #5;  // Wait for outputs to settle
        total = total + 1;

        // Compare actual outputs against expected outputs
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display(
              "FAIL at time %0t: A=%0d B=%0d | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
              $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    // Summary line
    $display("\n--------------------------------------------------");
    $display("Test Summary: %0d / %0d combinations passed (%0d failed).",
             (total - errors), total, errors);
    $display("--------------------------------------------------\n");

    $finish;
  end

endmodule