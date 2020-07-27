############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project test_hls_server.prj
set_top test_hls_server
add_files test_hls_server.cpp
add_files -tb tb_test_hls_server.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1"
set_part {xczu19eg-ffvc1760-2-i} -tool vivado
create_clock -period 10 -name default
#source "./test_hls_server.prj/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -rtl verilog -format ip_catalog
