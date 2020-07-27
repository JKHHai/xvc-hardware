#include "hls_design_meta.h"
const Port_Property HLS_Design_Meta::port_props[]={
	Port_Property("input_V_dout", 577, hls_in, 0, "ap_fifo", "fifo_data", 1),
	Port_Property("input_V_empty_n", 1, hls_in, 0, "ap_fifo", "fifo_status", 1),
	Port_Property("input_V_read", 1, hls_out, 0, "ap_fifo", "fifo_update", 1),
	Port_Property("output_V_din", 577, hls_out, 1, "ap_fifo", "fifo_data", 1),
	Port_Property("output_V_full_n", 1, hls_in, 1, "ap_fifo", "fifo_status", 1),
	Port_Property("output_V_write", 1, hls_out, 1, "ap_fifo", "fifo_update", 1),
	Port_Property("ap_clk", 1, hls_in, -1, "", "", 1),
	Port_Property("ap_rst", 1, hls_in, -1, "", "", 1),
};
const char* HLS_Design_Meta::dut_name = "test_hls_server";
