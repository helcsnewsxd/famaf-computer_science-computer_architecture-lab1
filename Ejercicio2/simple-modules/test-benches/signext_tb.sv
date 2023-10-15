// Immediate signed extension test bench module
module signext_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests
  parameter N = 64;

  // Test bench variables
  logic clk, reset_tb;
  logic [N-1 : 0] y_expected;

  int fd, error_code, cnt_tests, test_number, cnt_errors;
  string input_file_path, line;

  logic [ 31 : 0] a_in[0 : CNT_MAX_TESTS];
  logic [N-1 : 0] y_in[0 : CNT_MAX_TESTS];

  // Module connections
  logic [ 31 : 0] a;
  logic [N-1 : 0] y;

  signext #(N) dut (
      .a(a),
      .y(y)
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
    fd = $fopen({input_file_path, "input-files/signext_tb_in"}, "r");
    if (fd === 0) begin
      $display("ERROR when open the input file: %0d", fd);
      $stop;
    end

    while (!$feof(
        fd
    ) !== 0) begin
      error_code = $fgets(line, fd);
      if (line === "" || line.substr(0, 1) === "//") continue;
      error_code = $sscanf(line, "%d %d", a_in[cnt_tests], y_in[cnt_tests]);
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
      if (y !== y_expected) begin
        $display("Error in test number %d with \
			input = { a = %b } and \
			output = { y = %b } --> \
			The expected output was { y_expected = %b }\
			", test_number, a, y, y_expected);
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
    a = a_in[test_number];
    y_expected = y_in[test_number];
    #2ns;
  end

endmodule
