# ==============================================================
# File generated on Fri Jul 24 17:56:20 EDT 2020
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# ==============================================================
add_files -tb ../../tb_test_hls_server.cpp -cflags { -Wno-unknown-pragmas}
add_files test_hls_server.cpp
set_part xczu19eg-ffvc1760-2-i
create_clock -name default -period 10
