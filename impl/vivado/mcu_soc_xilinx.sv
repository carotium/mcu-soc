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
  logic clk_20M;
  logic rstn_o;

  IBUFGDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("TRUE"),
    .IOSTANDARD("DEFAULT")
    ) IBUFGDS_inst (
       .O(clk),
        .I(diff_clk_p),
        .IB(diff_clk_n)
        );

  (* blackbox *)
  mcmme2_base_clkgen #(
    //.INPUT_FREQUENCY_MHZ(200),
    //.DIVCLK_DIVIDE(4),  // set clock to 50 MHz
    //.CLKFBOUT_MULT(17)
  ) clkgen_inst (
    .sys_clk_pad_i(clk),
    .rst_pad_i    (~rstn),
    .async_rstn_o (),
    .clk_o        (clk_20M),
    .rstn_o       (rstn_o)
  );

  mcu_soc #(
    .INIT_FILE     (INIT_FILE),
    .INIT_FILE_BIN (INIT_FILE_BIN),
    .MEM_SIZE_WORDS(MEM_SIZE_WORDS)
  ) mcu1 (
    .clk  (clk_20M),
    .rstn (rstn_o),
    .tx   (tx),
    .rx   (rx),
    .ss	  (ss),
    .sclk (sclk),
    .mosi (mosi),
    .miso (miso),
    .complete (complete)
  );
endmodule
