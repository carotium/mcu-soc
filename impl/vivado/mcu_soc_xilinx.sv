module mcu_soc_xilinx import mcu_soc_pkg::*; #(
  parameter  string INIT_FILE="",
  parameter  int    INIT_FILE_BIN=0,
  parameter  int    MEM_SIZE_WORDS=4096,
  parameter  int    GPIO_NUM_IN=4,
  parameter  int    GPIO_NUM_OUT=4
  ) (
  input  logic clk,
  input  logic rst,

  output logic tx,

  input  logic [GPIO_NUM_IN-1:0]  gpio_in_i,
  output logic [GPIO_NUM_OUT-1:0] gpio_out_o
);
  mcu_soc #(
    .INIT_FILE     (INIT_FILE),
    .INIT_FILE_BIN (INIT_FILE_BIN),
    .MEM_SIZE_WORDS(MEM_SIZE_WORDS),
    .GPIO_NUM_IN   (GPIO_NUM_IN),
    .GPIO_NUM_OUT  (GPIO_NUM_OUT)
  ) mcu1 (
    .clk         (clk),
    .rstn        (~rst),
    .jtag_tck_i  (),
    .jtag_tdi_i  (),
    .jtag_tdo_o  (),
    .jtag_tms_i  (1'b0),
    .jtag_trstn_i(1'b1),
    .tx          (tx),
    .gpio_in_i   (gpio_in_i),
    .gpio_out_o  (gpio_out_o)
  );
endmodule
