## Clock signal
set_property -dict { PACKAGE_PIN AD12    IOSTANDARD LVDS } [get_ports { diff_clk_p }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
set_property -dict { PACKAGE_PIN AD11    IOSTANDARD LVDS } [get_ports { diff_clk_n }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz

create_clock -add -name sys_clk_pin -period 5.00 -waveform {0 2.5} [get_ports {diff_clk_p}];

set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { rstn }]; #IO_0_14 Sch=cpu_resetn

set_property -dict { PACKAGE_PIN Y20    IOSTANDARD LVCMOS33 } [get_ports { rx }]; #IO_L7P_T1_AD6P_35 Sch=uart_txd_in
set_property -dict { PACKAGE_PIN Y23    IOSTANDARD LVCMOS33 } [get_ports { tx }]; #IO_L11N_T1_SRCC_35 Sch=uart_rxd_out

## PMOD Header JC
set_property -dict { PACKAGE_PIN AC26  IOSTANDARD LVCMOS33 } [get_ports { ss[0] }]; #IO_L19P_T3_13 Sch=jc[1]
set_property -dict { PACKAGE_PIN AJ27  IOSTANDARD LVCMOS33 } [get_ports { mosi }]; #IO_L20P_T3_13 Sch=jc[2]
set_property -dict { PACKAGE_PIN AH30  IOSTANDARD LVCMOS33 } [get_ports { miso }]; #IO_L18N_T2_13 Sch=jc[3]
set_property -dict { PACKAGE_PIN AK29  IOSTANDARD LVCMOS33 } [get_ports { sclk }]; #IO_L15P_T2_DQS_13 Sch=jc[4]
##set_property -dict { PACKAGE_PIN AD26  IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L19N_T3_VREF_13 Sch=jc[7]
##set_property -dict { PACKAGE_PIN AG30  IOSTANDARD LVCMOS33 } [get_ports { jc[5] }]; #IO_L18P_T2_13 Sch=jc[8]
##set_property -dict { PACKAGE_PIN AK30  IOSTANDARD LVCMOS33 } [get_ports { jc[6] }]; #IO_L15N_T2_DQS_13 Sch=jc[9]
##set_property -dict { PACKAGE_PIN AK28  IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L20N_T3_13 Sch=jc[10]
set_property -dict { PACKAGE_PIN T28   IOSTANDARD LVCMOS33 } [get_ports { complete }]; #IO_L11N_T1_SRCC_14 Sch=led[0]
set_property -dict { PACKAGE_PIN V26   IOSTANDARD LVCMOS33 } [get_ports { ss[3] }]; #IO_L16P_T2_CSI_B_14 Sch=led[5]
set_property -dict { PACKAGE_PIN W24   IOSTANDARD LVCMOS33 } [get_ports { ss[2] }]; #IO_L20N_T3_A07_D23_14 Sch=led[6]
set_property -dict { PACKAGE_PIN W23   IOSTANDARD LVCMOS33 } [get_ports { ss[1] }]; #IO_L20P_T3_A08_D24_14 Sch=led[7]
