// Fetch test bench module
module fetch_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests
  parameter N = 64;

  // Test bench variables
  logic clk, reset_tb;
  logic [N-1 : 0] PCBranch_F_auxiliar, PCCounter_auxiliar, imem_addr_F_expected;

  int fd, error_code, cnt_tests, test_number, cnt_errors;
  string input_file_path, line;

  logic PCSrc_F_in[0:CNT_MAX_TESTS], reset_in[0:CNT_MAX_TESTS];
  logic [N-1 : 0] PCBranch_F_in[0:CNT_MAX_TESTS], imem_addr_F_in[0:CNT_MAX_TESTS];

  // Module connections
  logic PCSrc_F, reset;
  logic [N-1 : 0] PCBranch_F, imem_addr_F;

  fetch #(N) dut (
      .PCSrc_F(PCSrc_F),
      .clk(clk),
      .reset(reset),
      .PCBranch_F(PCBranch_F),
      .imem_addr_F(imem_addr_F)
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
    fd = $fopen({input_file_path, "input-files/fetch_tb_in"}, "r");
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
          "%b %b %d %d",
          PCSrc_F_in[cnt_tests],
          reset_in[cnt_tests],
          PCBranch_F_in[cnt_tests],
          imem_addr_F_in[cnt_tests]
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
      if (imem_addr_F !== imem_addr_F_expected) begin
        $display("Error in test number %d with \
            input = { PCSrc_F = %b, clk = %b, reset = %b, PCBranch_F = %d } and \
            output = { imem_addr_F = %d } --> \
            The expected output was { imem_addr_F_expected = %d }\
            ", test_number, PCSrc_F, clk, reset, PCBranch_F,
                 imem_addr_F, imem_addr_F_expected);
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
    PCSrc_F = PCSrc_F_in[test_number];
    reset = reset_in[test_number];
    PCBranch_F = PCBranch_F_in[test_number];
    imem_addr_F_expected = imem_addr_F_in[test_number];
    #2ns;
  end

endmodule
