module mcu_soc_tb #(
  parameter string INIT_FILE="",
  parameter int    INIT_FILE_BIN=0,
  parameter int    MEM_SIZE_WORDS=4096,
  parameter int    TIMEOUT=100000,
  parameter int    GPIO_NUM_IN=4,
  parameter int    GPIO_NUM_OUT=4
) ();

  logic clk, rstn, tx, rx;
  logic [GPIO_NUM_OUT-1:0] gpio_out;
  always #5 clk = ~clk;

  mcu_soc #(
    .INIT_FILE      (INIT_FILE),
    .INIT_FILE_BIN  (INIT_FILE_BIN),
    .MEM_SIZE_WORDS (MEM_SIZE_WORDS),
    .GPIO_NUM_IN    (GPIO_NUM_IN),
    .GPIO_NUM_OUT   (GPIO_NUM_OUT)
  ) mcux (
    .clk (clk),
    .rstn(rstn),
    .tx  (tx),
    .rx  (rx),
    .gpio_in_i (4'b0000),
    .gpio_out_o(gpio_out)
  );

  assign rx = 1'b0;

  initial begin
  $display("Starting simulation of MCU.");
  $display("Initialiting memory with: %s", INIT_FILE);
  $dumpfile("dump.fst");
  $dumpvars();
  clk = 1'b0;
  rstn = 1'b0;
  repeat (3) @ (posedge clk);
  rstn = 1'b1;
  repeat (TIMEOUT) @ (posedge clk);
  $finish;
  end

endmodule
