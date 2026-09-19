// tb.v
// Starter testbench template -- YOU complete this file.

// tb.v
// Testbench for lut.v with parameter override (WIDTH=8, DEPTH=8)

module tb;

  // Declare inputs as reg and outputs as wire
  // t_sel is 3 bits wide to support DEPTH=8 ($clog2(8) = 3)
  reg  [2:0] t_sel;
  wire [7:0] t_dout;

  // Instantiate DUT with parameter override
  lut #(
      .WIDTH(8),
      .DEPTH(8)
  ) DUT (
      .sel (t_sel),
      .dout(t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply input stimulus: loop through all addresses from 0 to DEPTH-1
  integer k;
  initial begin
    t_sel = 0;
    #5;
    for (k = 0; k < 8; k = k + 1) begin
      t_sel = k;
      #5;
    end
    $finish;
  end

  // Monitor output
  initial
    $monitor($time, " sel=%0d | dout=%0d (expected=%0d)", t_sel, t_dout,
             t_sel * t_sel);

endmodule