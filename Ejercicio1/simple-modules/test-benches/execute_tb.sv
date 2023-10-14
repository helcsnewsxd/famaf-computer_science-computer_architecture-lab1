// Execute test bench module
module execute_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests
  parameter N = 64;

  // Test bench variables
  logic clk, reset_tb;
  logic [N-1 : 0] PCBranch_E_expected, aluResult_E_expected, writeData_E_expected;
  logic zero_E_expected;

  int fd, error_code, cnt_tests, test_number, cnt_errors;
  string input_file_path, line;

  logic AluSrc_in[0:CNT_MAX_TESTS], zero_E_in[0:CNT_MAX_TESTS];
  logic [3 : 0] AluControl_in[0:CNT_MAX_TESTS];
  logic [N-1 : 0]
      PC_E_in[0:CNT_MAX_TESTS],
      signImm_E_in[0:CNT_MAX_TESTS],
      readData1_E_in[0:CNT_MAX_TESTS],
      readData2_E_in[0:CNT_MAX_TESTS],
      PCBranch_E_in[0:CNT_MAX_TESTS],
      aluResult_E_in[0:CNT_MAX_TESTS],
      writeData_E_in[0:CNT_MAX_TESTS];

  // Module connections
  logic AluSrc, zero_E;
  logic [3 : 0] AluControl;
  logic [N-1 : 0] PC_E, signImm_E, readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E;

  execute #(N) dut (
      .AluSrc(AluSrc),
      .AluControl(AluControl),
      .PC_E(PC_E),
      .signImm_E(signImm_E),
      .readData1_E(readData1_E),
      .readData2_E(readData2_E),
      .PCBranch_E(PCBranch_E),
      .aluResult_E(aluResult_E),
      .writeData_E(writeData_E),
      .zero_E(zero_E)
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
    fd = $fopen({input_file_path, "input-files/execute_tb_in"}, "r");
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
          "%b %d %d %d %d %d %d %d %d %b",
          AluSrc_in[cnt_tests],
          AluControl_in[cnt_tests],
          PC_E_in[cnt_tests],
          signImm_E_in[cnt_tests],
          readData1_E_in[cnt_tests],
          readData2_E_in[cnt_tests],
          PCBranch_E_in[cnt_tests],
          aluResult_E_in[cnt_tests],
          writeData_E_in[cnt_tests],
          zero_E_in[cnt_tests]
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
      if({PCBranch_E, aluResult_E, writeData_E, zero_E} !== {PCBranch_E_expected, aluResult_E_expected, writeData_E_expected, zero_E_expected}) begin
        $display("Error in test number %d with \
            input = { AluSrc = %d, AluControl = %b, PC_E = %d, signImm_E = %d, readData1_E = %d, readData2_E = %d } and \
            output = { PCBranch_E = %d, aluResult_E = %d, writeData_E = %d, zero_E = %d } --> \
            The expected output was { PCBranch_E_expected = %d, aluResult_E_expected = %d, writeData_E_expected = %d, zero_E_expected = %d }\
            ", test_number, AluSrc, AluControl, PC_E, signImm_E,
                 readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E, zero_E,
                 PCBranch_E_expected, aluResult_E_expected, writeData_E_expected, zero_E_expected);
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
    AluSrc = AluSrc_in[test_number];
    AluControl = AluControl_in[test_number];
    PC_E = PC_E_in[test_number];
    signImm_E = signImm_E_in[test_number];
    readData1_E = readData1_E_in[test_number];
    readData2_E = readData2_E_in[test_number];
    PCBranch_E_expected = PCBranch_E_in[test_number];
    aluResult_E_expected = aluResult_E_in[test_number];
    writeData_E_expected = writeData_E_in[test_number];
    zero_E_expected = zero_E_in[test_number];
    #2ns;
  end

endmodule
