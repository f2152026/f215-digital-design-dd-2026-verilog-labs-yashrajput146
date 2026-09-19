// tb.v
// Self-checking testbench for Task 5 ALU

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp_result;
  integer    errors = 0;
  integer    total = 0;
  integer    i, j, k;

  // Instantiate DUT
  alu DUT (
      .a(t_a),
      .b(t_b),
      .op(t_op),
      .result(t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Test stimulus and self-checking
  initial begin
    t_a  = 0;
    t_b  = 0;
    t_op = 0;

    // 1. Check all operand & operation combinations
    for (k = 0; k < 2; k = k + 1) begin
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          t_a  = i[3:0];
          t_b  = j[3:0];
          t_op = k[0];

          exp_result = (t_op == 1'b0) ? (t_a + t_b) : (t_a - t_b);

          #5;
          total = total + 1;

          if (t_result !== exp_result) begin
            $display(
                "FAIL at time %0t: op=%b a=%0d b=%0d | got=%0d | expected=%0d",
                $time, t_op, t_a, t_b, t_result, exp_result);
            errors = errors + 1;
          end
        end
      end
    end

    // 2. Specific test: fixed operands while toggling op (tests sensitivity list)
    t_a  = 4'd12;
    t_b  = 4'd5;
    t_op = 1'b0;  // Add (12 + 5 = 17 -> 4'd1)
    #5;

    t_op = 1'b1;  // Switch op to Sub (12 - 5 = 7 -> 4'd7) without changing a or b
    exp_result = t_a - t_b;
    #5;
    total = total + 1;

    if (t_result !== exp_result) begin
      $display(
          "FAIL (fixed operand test) at time %0t: op=%b a=%0d b=%0d | got=%0d | expected=%0d",
          $time, t_op, t_a, t_b, t_result, exp_result);
      errors = errors + 1;
    end

    // Summary line
    $display("\n--------------------------------------------------");
    $display("Test Summary: %0d / %0d tests passed (%0d failed).",
             (total - errors), total, errors);
    $display("--------------------------------------------------\n");

    $finish;
  end

endmodule