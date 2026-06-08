# synth.tcl is a synthesis script for Vivado
# 
# run "vivado -mode batch -source synth.tcl" to get a compiled vivado design
#
# Genesys2 board
set_part xc7k325tffg900-2

set script_path [ file dirname [ file normalize [ info script ] ] ]
set project_root_dir $script_path/../../.
set source_dir $project_root_dir/rtl
set output_dir $script_path/output/.

source ${script_path}/sources_vivado.tcl
read_xdc $script_path/constr_genesys.xdc

# Run synthesis
synth_design -top mcu_soc_xilinx -generic INIT_FILE=${project_root_dir}/sw/bin/bootloader.hex
#-generic INIT_FILE=${project_root_dir}/sw/bin/spi_test.hex
report_timing_summary    -file ${output_dir}/post_synth_timing_summary.rpt
report_power             -file ${output_dir}/post_synth_power.rpt
report_clock_interaction -file ${output_dir}/post_synth_clock_interaction.rpt -delay_type min_max
report_high_fanout_nets	 -file ${output_dir}/post_synth_high_fanout_nets.rpt -fanout_greater_than 200 -max_nets 5
report_utilization       -file ${output_dir}/utilization.rpt -hierarchical
write_verilog -force ${output_dir}/impl_netlist.v
write_edif    -force ${output_dir}/impl_netlist.edif

opt_design
place_design
route_design

report_timing_summary	-file ${output_dir}/post_desing_timing_summary.rpt

write_bitstream -force ${output_dir}/impl.bit -bin_file
