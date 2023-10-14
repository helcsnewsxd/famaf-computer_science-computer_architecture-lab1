// Arithmetic-logic unit module
module alu_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests
  parameter N = 64;

  // Test bench variables
  logic clk, reset_tb;
  logic [N-1 : 0] result_expected;
  logic zero_expected;

  int fd, error_code, cnt_tests, test_number, cnt_errors;
  string input_file_path, line;

  logic [N-1 : 0] a_in[0 : CNT_MAX_TESTS], b_in[0 : CNT_MAX_TESTS], result_in[0 : CNT_MAX_TESTS];
  logic [3 : 0] ALUControl_in[0 : CNT_MAX_TESTS];
  logic zero_in[0 : CNT_MAX_TESTS];

  // Module connections
  logic [N-1 : 0] a, b, result;
  logic [3 : 0] ALUControl;
  logic zero;

  alu #(N) dut (
      .a(a),
      .b(b),
      .ALUControl(ALUControl),
      .result(result),
      .zero(zero)
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
    fd = $fopen({input_file_path, "input-files/alu_tb_in"}, "r");
    if (fd === 0) begin
      $display("ERROR when open the input file: %0d", fd);
      $stop;
    end

    while (!$feof(
        fd
    ) !== 0) begin
      error_code = $fgets(line, fd);
      if (line === "" || line.substr(0, 1) === "//") continue;
      error_code = $sscanf(
          line,
          "%d %d %d %d %d",
          a_in[cnt_tests],
          b_in[cnt_tests],
          ALUControl_in[cnt_tests],
          result_in[cnt_tests],
          zero_in[cnt_tests]
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
      if (result !== result_expected || zero !== zero_expected) begin
        $display("Error in test number %d with \
			input = { a = %b, b = %b, ALUControl = %b } and \
			output = { result = %b, zero = %b } --> \
			The expected output was { result_expected = %b, zero_expected = %b }\
			", test_number, a, b, ALUControl, result, zero,
                 result_expected, zero_expected);
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
    b = b_in[test_number];
    ALUControl = ALUControl_in[test_number];
    result_expected = result_in[test_number];
    zero_expected = zero_in[test_number];
    #2ns;
  end

endmodule
