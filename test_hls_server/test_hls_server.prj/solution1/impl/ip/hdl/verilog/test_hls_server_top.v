// ==============================================================
// File generated on Mon Jul 27 11:40:38 EDT 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
module test_hls_server_top (
input_V_TVALID,
input_V_TREADY,
input_V_TDATA,
input_V_TKEEP,
input_V_TLAST,
output_V_TVALID,
output_V_TREADY,
output_V_TDATA,
output_V_TKEEP,
output_V_TLAST,
aresetn,
aclk
);

parameter RESET_ACTIVE_LOW = 1;

input input_V_TVALID ;
output input_V_TREADY ;
input [512 - 1:0] input_V_TDATA ;
input [64 - 1:0] input_V_TKEEP ;
input [1 - 1:0] input_V_TLAST ;


output output_V_TVALID ;
input output_V_TREADY ;
output [512 - 1:0] output_V_TDATA ;
output [64 - 1:0] output_V_TKEEP ;
output [1 - 1:0] output_V_TLAST ;

input aresetn ;

input aclk ;


wire input_V_TVALID;
wire input_V_TREADY;
wire [512 - 1:0] input_V_TDATA;
wire [64 - 1:0] input_V_TKEEP;
wire [1 - 1:0] input_V_TLAST;


wire output_V_TVALID;
wire output_V_TREADY;
wire [512 - 1:0] output_V_TDATA;
wire [64 - 1:0] output_V_TKEEP;
wire [1 - 1:0] output_V_TLAST;

wire aresetn;


wire [577 - 1:0] sig_test_hls_server_input_V_dout;
wire sig_test_hls_server_input_V_empty_n;
wire sig_test_hls_server_input_V_read;

wire [577 - 1:0] sig_test_hls_server_output_V_din;
wire sig_test_hls_server_output_V_full_n;
wire sig_test_hls_server_output_V_write;

wire sig_test_hls_server_ap_rst;



test_hls_server test_hls_server_U(
    .input_V_dout(sig_test_hls_server_input_V_dout),
    .input_V_empty_n(sig_test_hls_server_input_V_empty_n),
    .input_V_read(sig_test_hls_server_input_V_read),
    .output_V_din(sig_test_hls_server_output_V_din),
    .output_V_full_n(sig_test_hls_server_output_V_full_n),
    .output_V_write(sig_test_hls_server_output_V_write),
    .ap_rst(sig_test_hls_server_ap_rst),
    .ap_clk(aclk)
);

test_hls_server_input_V_if test_hls_server_input_V_if_U(
    .ACLK(aclk),
    .ARESETN(aresetn),
    .input_V_dout(sig_test_hls_server_input_V_dout),
    .input_V_empty_n(sig_test_hls_server_input_V_empty_n),
    .input_V_read(sig_test_hls_server_input_V_read),
    .TVALID(input_V_TVALID),
    .TREADY(input_V_TREADY),
    .TDATA(input_V_TDATA),
    .TKEEP(input_V_TKEEP),
    .TLAST(input_V_TLAST));

test_hls_server_output_V_if test_hls_server_output_V_if_U(
    .ACLK(aclk),
    .ARESETN(aresetn),
    .output_V_din(sig_test_hls_server_output_V_din),
    .output_V_full_n(sig_test_hls_server_output_V_full_n),
    .output_V_write(sig_test_hls_server_output_V_write),
    .TVALID(output_V_TVALID),
    .TREADY(output_V_TREADY),
    .TDATA(output_V_TDATA),
    .TKEEP(output_V_TKEEP),
    .TLAST(output_V_TLAST));

test_hls_server_ap_rst_if #(
    .RESET_ACTIVE_LOW(RESET_ACTIVE_LOW))
ap_rst_if_U(
    .dout(sig_test_hls_server_ap_rst),
    .din(aresetn));

endmodule
