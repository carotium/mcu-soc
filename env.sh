#!/bin/bash
# Copyright (c) 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>
# - Thomas Benz     <tbenz@iis.ee.ethz.ch>
#
# Environment setup for Croc SoC ASIC flow
# This file is sourced by all scripts to set up tool paths and PDK location

# Determine repository root

#export PDK_ROOT="$(PDK_ROOT)"

if [[ -n "${BASH_SOURCE[0]}" ]]; then
    export MCU_ROOT=$(realpath $(dirname "${BASH_SOURCE[0]}"))
else
    export MCU_ROOT=$(pwd)
fi
echo "[INFO][ENV] MCU root: $MCU_ROOT"


######################
# Project Settings
######################
export PROJ_NAME="${PROJ_NAME:-mcu-soc}"
export TOP_DESIGN="${TOP_DESIGN:-mcu_soc}"
export DUT_DESIGN="${DUT_DESIGN:-mcu_soc}"

echo "[INFO][ENV] PDK root: $PDK_ROOT"
echo "[INFO][ENV] PDK files: $PDKPATH"
