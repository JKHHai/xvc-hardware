#include "test_hls_server.h"

void test_hls_server
        (
                hls::stream<axistream> &input,
                hls::stream<axistream> &output
        )
{
#pragma HLS DATAFLOW
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS resource core=AXI4Stream variable=input
#pragma HLS DATA_PACK variable=input
#pragma HLS resource core=AXI4Stream variable=output
#pragma HLS DATA_PACK variable=output

        axistream temp_data_in;
        axistream temp_data_out;
        if (!input.empty() && !output.full())
        {
        	temp_data_in = input.read();
        	temp_data_out.tdata = 2 * temp_data_in.tdata;
        	temp_data_out.tkeep = (temp_data_in.tkeep << 1) + 1; // Keep 1 more byte in case multiplying by 2 results in overflow into a null byte
        	temp_data_out.tlast = temp_data_in.tlast;
        	output.write(temp_data_out);
        }

}

