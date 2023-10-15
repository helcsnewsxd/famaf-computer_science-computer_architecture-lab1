// Main decoder test bench module
module maindec_tb ();

  // Parameters
  parameter CNT_MAX_TESTS = 10000;  // maximum cnt of tests

  // Test bench variables
  logic clk, reset_tb;
  logic [8 : 0] flags_expected;

  int fd, error_code, cnt_tests, test_number, cnt_errors;
  string input_file_path, line;

  logic [10 : 0] Op_in[0 : CNT_MAX_TESTS];
  logic [8 : 0] flags_in[0 : CNT_MAX_TESTS];

  // Module connections
  logic [10 : 0] Op;
  logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
  logic [1 : 0] ALUOp;

  maindec dut (
      .Op(Op),
      .Reg2Loc(Reg2Loc),
      .ALUSrc(ALUSrc),
      .MemtoReg(MemtoReg),
      .RegWrite(RegWrite),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
      .Branch(Branch),
      .ALUOp(ALUOp)
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
    fd = $fopen({input_file_path, "input-files/maindec_tb_in"}, "r");
    if (fd === 0) begin
      $display("ERROR when open the input file: %0d", fd);
      $stop;
    end

    while (!$feof(
        fd
    ) !== 0) begin
      error_code = $fgets(line, fd);
      if (line === "" || line === "\n" || line.substr(0, 1) === "//") continue;
      error_code = $sscanf(line, "%b %b", Op_in[cnt_tests], flags_in[cnt_tests]);
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
      if({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== flags_expected) begin
        $display("Error in test number %d with \
			  input = { Op = %b } and \
			  output = { flags = %b } --> \
			  The expected output was { flags_expected= %b }\
			  ", test_number, Op, {
                 Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp},
                 flags_expected);
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
    Op = Op_in[test_number];
    flags_expected = flags_in[test_number];
    #2ns;
  end

endmodule
