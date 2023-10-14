// Registers module
module regfile_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests
  parameter N = 64;

  // Test bench variables
  logic clk, reset_tb;
  logic [N-1 : 0] rd1_expected, rd2_expected, wd3_auxiliar;

  int fd, error_code, cnt_tests, test_number, test_type, cnt_errors;
  string input_file_path, line;

  logic we3_in[0 : CNT_MAX_TESTS];
  logic [4 : 0] ra1_in[0 : CNT_MAX_TESTS], ra2_in[0 : CNT_MAX_TESTS], wa3_in[0 : CNT_MAX_TESTS];
  logic [N-1 : 0] wd3_in[0 : CNT_MAX_TESTS], rd1_in[0 : CNT_MAX_TESTS], rd2_in[0 : CNT_MAX_TESTS];

  // Module connections
  logic we3;
  logic [4 : 0] ra1, ra2, wa3;
  logic [N-1 : 0] wd3, rd1, rd2;

  regfile #(N) dut (
      .clk(clk),
      .we3(we3),
      .ra1(ra1),
      .ra2(ra2),
      .wa3(wa3),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
  );

  // Clock generation with 10ns period
  always begin
    clk = 1;
    #5ns;
    clk = 0;
    #5ns;
  end

  initial begin
    // Init tests
    cnt_tests = 0;
    test_number = 0;
    cnt_errors = 0;

    // Get input file path
    input_file_path = `__FILE__;
    for (int i = input_file_path.len(); i >= 0; i--)
      if (input_file_path[i] == "/") begin
        input_file_path = input_file_path.substr(0, i);
        break;
      end

    // Open and read input file
    fd = $fopen({input_file_path, "input-files/regfile_tb_in"}, "r");
    if (fd === 0) begin
      $display("ERROR when open the input file: %0d", fd);
      $stop;
    end

    while (!$feof(
        fd
    ) !== 0) begin
      error_code = $fgets(line, fd);
      if (line === "" || line === "\n" || line.substr(0, 1) === "//") continue;
      error_code = $sscanf(
          line,
          "%d %d %d %d %d %d %d",
          we3_in[cnt_tests],
          ra1_in[cnt_tests],
          ra2_in[cnt_tests],
          wa3_in[cnt_tests],
          wd3_in[cnt_tests],
          rd1_in[cnt_tests],
          rd2_in[cnt_tests]
      );
      cnt_tests++;
    end

    $fclose(fd);

    // First reset test bench creation
    reset_tb = 1;
    #27ns;
    reset_tb = 0;
  end

  always @(negedge clk) begin
    // Check test executed on positive edge of clk
    if (~reset_tb) begin
      test_type = 0;
      // Test writing (reading the written register)
      if (we3 === 1'b1) begin
        test_type = 1;
        we3 = 1'b0;
      end

      if ({rd1, rd2} !== {rd1_expected, rd2_expected}) begin
        if (test_type === 0)
          $display(
              "Error in %s test number %d with \
			        input = { we3 = %b, ra1 = %d, ra2 = %d, wa3 = %d, wd3 = %d } and \
			        output = { rd1 = %d, rd2 = %d } --> \
			        The expected output was { rd1_expected = %d, rd2_expected = %d }\
			        ",
              (test_type ? "writing" : "initialization"),
              test_number,
              (test_type ? 1'b1 : 1'b0),
              ra1,
              ra2,
              wa3,
              wd3,
              rd1,
              rd2,
              rd1_expected,
              rd2_expected
          );
        cnt_errors++;
      end
      test_number++;

      if (test_number === cnt_tests) begin
        $display("%d tests completed with %d errors", cnt_tests, cnt_errors);
        #5ns;
        $stop;
      end
    end

    // Prepare next test to positive edge of clk
    #2ns;
    we3 = we3_in[test_number];
    ra1 = ra1_in[test_number];
    ra2 = ra2_in[test_number];
    wa3 = wa3_in[test_number];
    wd3 = wd3_in[test_number];
    rd1_expected = rd1_in[test_number];
    rd2_expected = rd2_in[test_number];
    #2ns;
  end

endmodule
