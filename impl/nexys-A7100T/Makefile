.PHONY: all pnr bitgen clean

SHELL=bash

OUT_DIR := output
TOOLS_DIR := /foss/tools

FPGA_DB=$(TOOLS_DIR)/nextpnr-xilinx/xilinx/xc7a100t.bin

SYNTHESIS ?= 0

YOSYS_OUTPUTS = $(OUT_DIR)/impl_netlist.edif $(OUT_DIR)/impl_netlist.v $(OUT_DIR)/impl_netlist.blif $(OUT_DIR)/impl_netlist.json

all: $(OUT_DIR) $(OUT_DIR)/impl_netlist.edif pnr bitgen
pnr: $(OUT_DIR)/mcu_soc.fasm
bitgen: $(OUT_DIR)/mcu_soc.bit

mcu_soc.flist:
	bender script verilator -t xilinx -t rtl -t bscane -t fpga &> mcu_soc.flist

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(YOSYS_OUTPUTS): mcu_soc.flist
	yosys -c synth.tcl -l $(OUT_DIR)/yosys.log

$(OUT_DIR)/mcu_soc.fasm: $(OUT_DIR)/impl_netlist.json
	nextpnr-xilinx --freq 50 --json $(OUT_DIR)/impl_netlist.json --chipdb $(FPGA_DB) --xdc constr_nexys.xdc --fasm $(OUT_DIR)/mcu_soc.fasm --log $(OUT_DIR)/nextpnr-xilinx.log --force

# fpga-assembler generates bitstream from fasm
$(OUT_DIR)/mcu_soc.bit: $(OUT_DIR)/mcu_soc.fasm
	fpga-as --prjxray_db_path=$(TOOLS_DIR)/prjxray-db/artix7 \
		--part=xc7a100tcsg324-1 \
		< $(OUT_DIR)/mcu_soc.fasm > $(OUT_DIR)/mcu_soc.bit

#$(OUT_DIR)/mcu_soc.frames: $(OUT_DIR)/mcu_soc.fasm
#	fasm2frames --part xc7a100tcsg324-1 \
#		    --db-root $(TOOLS_DIR)/prjxray-db/artix7/ \
#		    ./$(OUT_DIR)/mcu_soc.fasm > $(OUT_DIR)/mcu_soc.frames

#$(OUT_DIR)/mcu_soc.bit: $(OUT_DIR)/mcu_soc.frames
#	xc7frames2bit --part_file $(TOOLS_DIR)/prjxray-db/artix7/xc7a100tcsg324-1/part.yaml \
#		      --part_name xc7a100tcsg324-1  \
#		      --frm_file ./$(OUT_DIR)/mcu_soc.frames \
#		      --$(OUT_DIR)_file ./$(OUT_DIR)/mcu_soc.bit

clean:
	rm -rf $(OUT_DIR) mcu_soc.flist
