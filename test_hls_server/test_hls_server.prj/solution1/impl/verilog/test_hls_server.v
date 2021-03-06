// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.3
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="test_hls_server,hls_ip_2018_3,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu19eg-ffvc1760-2-i,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=0.000000,HLS_SYN_LAT=0,HLS_SYN_TPT=1,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=2,HLS_SYN_LUT=95,HLS_VERSION=2018_3}" *)

module test_hls_server (
        input_V_dout,
        input_V_empty_n,
        input_V_read,
        output_V_din,
        output_V_full_n,
        output_V_write,
        ap_clk,
        ap_rst
);


input  [576:0] input_V_dout;
input   input_V_empty_n;
output   input_V_read;
output  [576:0] output_V_din;
input   output_V_full_n;
output   output_V_write;
input   ap_clk;
input   ap_rst;

wire    Block_proc24_U0_ap_start;
wire    Block_proc24_U0_ap_done;
wire    Block_proc24_U0_ap_continue;
wire    Block_proc24_U0_ap_idle;
wire    Block_proc24_U0_ap_ready;
wire    Block_proc24_U0_input_V_read;
wire   [576:0] Block_proc24_U0_output_V_din;
wire    Block_proc24_U0_output_V_write;
wire    ap_sync_continue;
wire    Block_proc24_U0_start_full_n;
wire    Block_proc24_U0_start_write;

Block_proc24 Block_proc24_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(Block_proc24_U0_ap_start),
    .ap_done(Block_proc24_U0_ap_done),
    .ap_continue(Block_proc24_U0_ap_continue),
    .ap_idle(Block_proc24_U0_ap_idle),
    .ap_ready(Block_proc24_U0_ap_ready),
    .input_V_dout(input_V_dout),
    .input_V_empty_n(input_V_empty_n),
    .input_V_read(Block_proc24_U0_input_V_read),
    .output_V_din(Block_proc24_U0_output_V_din),
    .output_V_full_n(output_V_full_n),
    .output_V_write(Block_proc24_U0_output_V_write)
);

assign Block_proc24_U0_ap_continue = 1'b1;

assign Block_proc24_U0_ap_start = 1'b1;

assign Block_proc24_U0_start_full_n = 1'b1;

assign Block_proc24_U0_start_write = 1'b0;

assign ap_sync_continue = 1'b0;

assign input_V_read = Block_proc24_U0_input_V_read;

assign output_V_din = Block_proc24_U0_output_V_din;

assign output_V_write = Block_proc24_U0_output_V_write;

endmodule //test_hls_server
