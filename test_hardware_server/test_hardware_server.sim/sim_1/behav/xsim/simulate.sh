#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Fri Aug 21 19:07:10 UTC 2020
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_test_hardware_server_behav -key {Behavioral:sim_1:Functional:tb_test_hardware_server} -tclbatch tb_test_hardware_server.tcl -view /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/tb_test_hardware_server_behav.wcfg -log simulate.log"
xsim tb_test_hardware_server_behav -key {Behavioral:sim_1:Functional:tb_test_hardware_server} -tclbatch tb_test_hardware_server.tcl -view /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/tb_test_hardware_server_behav.wcfg -log simulate.log
