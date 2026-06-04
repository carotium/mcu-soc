module mcmme2_base_clkgen #(
  //parameter INPUT_FREQUENCY_MHZ = 200,
  //parameter DIVCLK_DIVIDE = 1,
  //parameter CLKFBOUT_MULT = 1
) (
  input  sys_clk_pad_i, // Main clocks in, depending on board
  input  rst_pad_i,     // Asynchronous, active high reset in
  output async_rstn_o,  // Asynchronous, active low reset out
  output clk_o,         // synthesized clock out
  output rstn_o         // synchronous reset
  );
  assign async_rstn_o = ~rst_pad_i;
  assign rstn_o = ~rst_pad_i;

  localparam RESETCNT_BITS = 8;
  localparam RESETCNT_VAL  = (2 << RESETCNT_BITS) - 1;

  // PLL stuff
  wire clk_in1_clk_gen_sys;
  assign clk_in1_clk_gen_sys = sys_clk_pad_i;

  wire clk_20_clk_gen_sys;
  wire clkfbout_clk_gen_sys;
  wire clkfbout_buf_clk_gen_sys;
  wire clkfboutb_unused;
  wire clkout0b_unused;
  wire clkout1_unused;
  wire clkout1b_unused;
  wire clkout2_unused;
  wire clkout2b_unused;
  wire clkout3_unused;
  wire clkout3b_unused;
  wire clkout4_unused;
  wire clkout5_unused;
  wire clkout6_unused;
  wire [15:0] do_unused;
  wire drdy_unused;
  wire psdone_unused;
  wire locked_int;
  wire clkinstopped_unused;
  wire clkfbstopped_unused;
  wire reset_high;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (4.250),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (42.500),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (5.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_clk_gen_sys),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clk_20_clk_gen_sys),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_clk_gen_sys),
    .CLKIN1              (clk_in1_clk_gen_sys),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (reset_high));
  
  assign reset_high = rst_pad_i;

  BUFG clkf_buf (.O (clkfbout_buf_clk_gen_sys), .I (clkfbout_clk_gen_sys));
  BUFG clkout1_buf (.O (clk_o), .I (clk_20_clk_gen_sys));

endmodule
