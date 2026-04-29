module mcu_soc_xilinx import mcu_soc_pkg::*; #(
  parameter  string INIT_FILE="",
  parameter  int    INIT_FILE_BIN=0,
  parameter  int    MEM_SIZE_WORDS=4096
  ) (
  input logic diff_clk_p,
  input logic diff_clk_n,
//  input  logic clk,
  input  logic rstn,

  output logic tx,
  input  logic rx,

  output logic [3:0] ss,
  output logic sclk,
  input logic miso,
  output logic mosi,
  output logic complete
);

  logic clk;

  IBUFGDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("TRUE"),
    .IOSTANDARD("DEFAULT")
    ) IBUFGDS_inst (
       .O(clk),
        .I(diff_clk_p),
        .IB(diff_clk_n)
        );

  mcu_soc #(
    .INIT_FILE     (INIT_FILE),
    .INIT_FILE_BIN (INIT_FILE_BIN),
    .MEM_SIZE_WORDS(MEM_SIZE_WORDS)
  ) mcu1 (
    .clk  (clk),
    .rstn (rstn),
    .tx   (tx),
    .rx   (rx),
    .ss	  (ss),
    .sclk (sclk),
    .mosi (mosi),
    .miso (miso),
    .complete (complete)
  );
endmodule
