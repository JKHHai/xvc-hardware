#include "test_hls_server.h"
#include <iostream>

int main (void)
{
        hls::stream<axistream> input_stream;
        hls::stream<axistream> output_stream;
        axistream temp_data_in; // Used to setup our variables
        axistream temp_data_out; // Used to read our variables after transmission

        temp_data_in.tdata = 0x100;
        temp_data_in.tkeep = 0xFF;
        temp_data_in.tlast = 1;

        // When the input stream is empty, insert our data packet
        while (!input_stream.empty())
        {
        	continue;
        }
		input_stream.write(temp_data_in);

        test_hls_server(input_stream, output_stream);

        // When the output stream is not empty, read the packet
        while (output_stream.empty())
        {
        	continue;
        }
        temp_data_out = output_stream.read();
        std::cout << std::hex << temp_data_out.tdata << "\n";
        return 0;
}

