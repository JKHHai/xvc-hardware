#ifndef TEST_HLS_SERVER_H
#define TEST_HLS_SERVER_H
#include "hls_stream.h"
#include "ap_int.h"
#include "ap_utils.h"

#define TDATA_WIDTH 512

struct axistream
{
	ap_uint <TDATA_WIDTH> tdata;
	ap_uint <TDATA_WIDTH/8> tkeep;
	ap_uint <1> tlast;
};

void test_hls_server
        (
                hls::stream<axistream> &input,
                hls::stream<axistream> &output
        );

#endif //TEST_HLS_SERVER_H
