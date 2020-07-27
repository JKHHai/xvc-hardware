// ==============================================================
// File generated on Mon Jul 27 11:39:37 EDT 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================

#define AP_INT_MAX_W 32678

#include <systemc>
#include <iostream>
#include <cstdlib>
#include <cstddef>
#include <stdint.h>
#include "SysCFileHandler.h"
#include "ap_int.h"
#include "ap_fixed.h"
#include <complex>
#include <stdbool.h>
#include "autopilot_cbe.h"
#include "hls_stream.h"
#include "hls_half.h"
#include "hls_signal_handler.h"

using namespace std;
using namespace sc_core;
using namespace sc_dt;


// [dump_struct_tree [build_nameSpaceTree] dumpedStructList] ---------->
    typedef struct axistream {
        ap_uint<512> tdata;
        ap_uint<64> tkeep;
        ap_uint<1> tlast;
       } axistream;



// [dump_enumeration [get_enumeration_list]] ---------->


// wrapc file define: "input_V"
#define AUTOTB_TVIN_input_V  "../tv/cdatafile/c.test_hls_server.autotvin_input_V.dat"
#define WRAPC_STREAM_SIZE_IN_input_V  "../tv/stream_size/stream_size_in_input_V.dat"
#define WRAPC_STREAM_INGRESS_STATUS_input_V  "../tv/stream_size/stream_ingress_status_input_V.dat"
// wrapc file define: "output_V"
#define AUTOTB_TVOUT_output_V  "../tv/cdatafile/c.test_hls_server.autotvout_output_V.dat"
#define AUTOTB_TVIN_output_V  "../tv/cdatafile/c.test_hls_server.autotvin_output_V.dat"
#define WRAPC_STREAM_SIZE_OUT_output_V  "../tv/stream_size/stream_size_out_output_V.dat"
#define WRAPC_STREAM_EGRESS_STATUS_output_V  "../tv/stream_size/stream_egress_status_output_V.dat"

#define INTER_TCL  "../tv/cdatafile/ref.tcl"

// tvout file define: "output_V"
#define AUTOTB_TVOUT_PC_output_V  "../tv/rtldatafile/rtl.test_hls_server.autotvout_output_V.dat"

class INTER_TCL_FILE {
	public:
		INTER_TCL_FILE(const char* name) {
			mName = name;
			input_V_depth = 0;
			output_V_depth = 0;
			trans_num =0;
		}

		~INTER_TCL_FILE() {
			mFile.open(mName);
			if (!mFile.good()) {
				cout << "Failed to open file ref.tcl" << endl;
				exit (1);
			}
			string total_list = get_depth_list();
			mFile << "set depth_list {\n";
			mFile << total_list;
			mFile << "}\n";
			mFile << "set trans_num "<<trans_num<<endl;
			mFile.close();
		}

		string get_depth_list () {
			stringstream total_list;
			total_list << "{input_V " << input_V_depth << "}\n";
			total_list << "{output_V " << output_V_depth << "}\n";
			return total_list.str();
		}

		void set_num (int num , int* class_num) {
			(*class_num) = (*class_num) > num ? (*class_num) : num;
		}
	public:
		int input_V_depth;
		int output_V_depth;
		int trans_num;

	private:
		ofstream mFile;
		const char* mName;
};

extern void test_hls_server (
hls::stream<axistream > (&input),
hls::stream<axistream > (&output));

void AESL_WRAP_test_hls_server (
hls::stream<axistream > (&input),
hls::stream<axistream > (&output))
{
	refine_signal_handler();
	fstream wrapc_switch_file_token;
	wrapc_switch_file_token.open(".hls_cosim_wrapc_switch.log");
	int AESL_i;
	if (wrapc_switch_file_token.good())
	{
		CodeState = ENTER_WRAPC_PC;
		static unsigned AESL_transaction_pc = 0;
		string AESL_token;
		string AESL_num;
		static AESL_FILE_HANDLER aesl_fh;

		// pop stream input: "input"
		aesl_fh.read(WRAPC_STREAM_SIZE_IN_input_V, AESL_token); // [[transaction]]
		aesl_fh.read(WRAPC_STREAM_SIZE_IN_input_V, AESL_num); // transaction number

		if (atoi(AESL_num.c_str()) == AESL_transaction_pc)
		{
			aesl_fh.read(WRAPC_STREAM_SIZE_IN_input_V, AESL_token); // pop_size
			int aesl_tmp_1 = atoi(AESL_token.c_str());
			for (int i = 0; i < aesl_tmp_1; i++)
			{
				input.read();
			}
			aesl_fh.read(WRAPC_STREAM_SIZE_IN_input_V, AESL_token); // [[/transaction]]
		}

		// define output stream variables: "output"
		std::vector<axistream > aesl_tmp_3;
		int aesl_tmp_4;
		int aesl_tmp_5 = 0;

		// read output stream size: "output"
		aesl_fh.read(WRAPC_STREAM_SIZE_OUT_output_V, AESL_token); // [[transaction]]
		aesl_fh.read(WRAPC_STREAM_SIZE_OUT_output_V, AESL_num); // transaction number

		if (atoi(AESL_num.c_str()) == AESL_transaction_pc)
		{
			aesl_fh.read(WRAPC_STREAM_SIZE_OUT_output_V, AESL_token); // pop_size
			aesl_tmp_4 = atoi(AESL_token.c_str());
			aesl_fh.read(WRAPC_STREAM_SIZE_OUT_output_V, AESL_token); // [[/transaction]]
		}

		// output port post check: "output_V"
		aesl_fh.read(AUTOTB_TVOUT_PC_output_V, AESL_token); // [[transaction]]
		if (AESL_token != "[[transaction]]")
		{
			exit(1);
		}
		aesl_fh.read(AUTOTB_TVOUT_PC_output_V, AESL_num); // transaction number

		if (atoi(AESL_num.c_str()) == AESL_transaction_pc)
		{
			aesl_fh.read(AUTOTB_TVOUT_PC_output_V, AESL_token); // data

			std::vector<sc_bv<577> > output_V_pc_buffer;
			int i = 0;

			while (AESL_token != "[[/transaction]]")
			{
				bool no_x = false;
				bool err = false;

				// search and replace 'X' with "0" from the 1st char of token
				while (!no_x)
				{
					size_t x_found = AESL_token.find('X');
					if (x_found != string::npos)
					{
						if (!err)
						{
							cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'X' on port 'output_V', possible cause: There are uninitialized variables in the C design." << endl;
							err = true;
						}
						AESL_token.replace(x_found, 1, "0");
					}
					else
					{
						no_x = true;
					}
				}

				no_x = false;

				// search and replace 'x' with "0" from the 3rd char of token
				while (!no_x)
				{
					size_t x_found = AESL_token.find('x', 2);

					if (x_found != string::npos)
					{
						if (!err)
						{
							cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'X' on port 'output_V', possible cause: There are uninitialized variables in the C design." << endl;
							err = true;
						}
						AESL_token.replace(x_found, 1, "0");
					}
					else
					{
						no_x = true;
					}
				}

				// push token into output port buffer
				if (AESL_token != "")
				{
					output_V_pc_buffer.push_back(AESL_token.c_str());
					i++;
				}

				aesl_fh.read(AUTOTB_TVOUT_PC_output_V, AESL_token); // data or [[/transaction]]

				if (AESL_token == "[[[/runtime]]]" || aesl_fh.eof(AUTOTB_TVOUT_PC_output_V))
				{
					exit(1);
				}
			}

			// correct the buffer size the current transaction
			if (i != aesl_tmp_4)
			{
				aesl_tmp_4 = i;
			}

			if (aesl_tmp_4 > 0 && aesl_tmp_3.size() < aesl_tmp_4)
			{
				int aesl_tmp_3_size = aesl_tmp_3.size();

				for (int tmp_aesl_tmp_3 = 0; tmp_aesl_tmp_3 < aesl_tmp_4 - aesl_tmp_3_size; tmp_aesl_tmp_3++)
				{
					axistream tmp;
					aesl_tmp_3.push_back(tmp);
				}
			}

			// ***********************************
			if (i > 0)
			{
				// RTL Name: output_V
				{
					// bitslice(511, 0)
					// {
						// celement: output.V.tdata.V(511, 0)
						// {
							sc_lv<512>* output_V_tdata_V_lv0_0_0_1_lv1_0_0_1 = new sc_lv<512>[aesl_tmp_4 - aesl_tmp_5];
						// }
					// }
					// bitslice(575, 512)
					// {
						// celement: output.V.tkeep.V(63, 0)
						// {
							sc_lv<64>* output_V_tkeep_V_lv0_0_0_1_lv1_0_0_1 = new sc_lv<64>[aesl_tmp_4 - aesl_tmp_5];
						// }
					// }
					// bitslice(576, 576)
					// {
						// celement: output.V.tlast.V(0, 0)
						// {
							sc_lv<1>* output_V_tlast_V_lv0_0_0_1_lv1_0_0_1 = new sc_lv<1>[aesl_tmp_4 - aesl_tmp_5];
						// }
					// }

					// bitslice(511, 0)
					{
						int hls_map_index = 0;
						// celement: output.V.tdata.V(511, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									if (&(aesl_tmp_3[0].tdata) != NULL) // check the null address if the c port is array or others
									{
										output_V_tdata_V_lv0_0_0_1_lv1_0_0_1[hls_map_index].range(511, 0) = sc_bv<512>(output_V_pc_buffer[hls_map_index].range(511, 0));
										hls_map_index++;
									}
								}
							}
						}
					}
					// bitslice(575, 512)
					{
						int hls_map_index = 0;
						// celement: output.V.tkeep.V(63, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									if (&(aesl_tmp_3[0].tkeep) != NULL) // check the null address if the c port is array or others
									{
										output_V_tkeep_V_lv0_0_0_1_lv1_0_0_1[hls_map_index].range(63, 0) = sc_bv<64>(output_V_pc_buffer[hls_map_index].range(575, 512));
										hls_map_index++;
									}
								}
							}
						}
					}
					// bitslice(576, 576)
					{
						int hls_map_index = 0;
						// celement: output.V.tlast.V(0, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									if (&(aesl_tmp_3[0].tlast) != NULL) // check the null address if the c port is array or others
									{
										output_V_tlast_V_lv0_0_0_1_lv1_0_0_1[hls_map_index].range(0, 0) = sc_bv<1>(output_V_pc_buffer[hls_map_index].range(576, 576));
										hls_map_index++;
									}
								}
							}
						}
					}

					// bitslice(511, 0)
					{
						int hls_map_index = 0;
						// celement: output.V.tdata.V(511, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									// sub                    : i_0 i_1
									// ori_name               : aesl_tmp_3[i_0].tdata
									// sub_1st_elem           : 0 0
									// ori_name_1st_elem      : aesl_tmp_3[0].tdata
									// output_left_conversion : aesl_tmp_3[i_0].tdata
									// output_type_conversion : (output_V_tdata_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str()
									if (&(aesl_tmp_3[0].tdata) != NULL) // check the null address if the c port is array or others
									{
										aesl_tmp_3[i_0].tdata = (output_V_tdata_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str();
										hls_map_index++;
									}
								}
							}
						}
					}
					// bitslice(575, 512)
					{
						int hls_map_index = 0;
						// celement: output.V.tkeep.V(63, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									// sub                    : i_0 i_1
									// ori_name               : aesl_tmp_3[i_0].tkeep
									// sub_1st_elem           : 0 0
									// ori_name_1st_elem      : aesl_tmp_3[0].tkeep
									// output_left_conversion : aesl_tmp_3[i_0].tkeep
									// output_type_conversion : (output_V_tkeep_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str()
									if (&(aesl_tmp_3[0].tkeep) != NULL) // check the null address if the c port is array or others
									{
										aesl_tmp_3[i_0].tkeep = (output_V_tkeep_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str();
										hls_map_index++;
									}
								}
							}
						}
					}
					// bitslice(576, 576)
					{
						int hls_map_index = 0;
						// celement: output.V.tlast.V(0, 0)
						{
							// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
							for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
							{
								// carray: (0) => (0) @ (1)
								for (int i_1 = 0; i_1 <= 0; i_1 += 1)
								{
									// sub                    : i_0 i_1
									// ori_name               : aesl_tmp_3[i_0].tlast
									// sub_1st_elem           : 0 0
									// ori_name_1st_elem      : aesl_tmp_3[0].tlast
									// output_left_conversion : aesl_tmp_3[i_0].tlast
									// output_type_conversion : (output_V_tlast_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str()
									if (&(aesl_tmp_3[0].tlast) != NULL) // check the null address if the c port is array or others
									{
										aesl_tmp_3[i_0].tlast = (output_V_tlast_V_lv0_0_0_1_lv1_0_0_1[hls_map_index]).to_string(SC_BIN).c_str();
										hls_map_index++;
									}
								}
							}
						}
					}
				}
			}
		}

		// push back output stream: "output"
		for (int i = 0; i < aesl_tmp_4; i++)
		{
			output.write(aesl_tmp_3[i]);
		}

		AESL_transaction_pc++;
	}
	else
	{
		CodeState = ENTER_WRAPC;
		static unsigned AESL_transaction;

		static AESL_FILE_HANDLER aesl_fh;

		// "input_V"
		char* tvin_input_V = new char[149];
		aesl_fh.touch(AUTOTB_TVIN_input_V);
		char* wrapc_stream_size_in_input_V = new char[50];
		aesl_fh.touch(WRAPC_STREAM_SIZE_IN_input_V);
		char* wrapc_stream_ingress_status_input_V = new char[149];
		aesl_fh.touch(WRAPC_STREAM_INGRESS_STATUS_input_V);

		// "output_V"
		char* tvin_output_V = new char[149];
		aesl_fh.touch(AUTOTB_TVIN_output_V);
		char* tvout_output_V = new char[149];
		aesl_fh.touch(AUTOTB_TVOUT_output_V);
		char* wrapc_stream_size_out_output_V = new char[50];
		aesl_fh.touch(WRAPC_STREAM_SIZE_OUT_output_V);
		char* wrapc_stream_egress_status_output_V = new char[149];
		aesl_fh.touch(WRAPC_STREAM_EGRESS_STATUS_output_V);

		CodeState = DUMP_INPUTS;
		static INTER_TCL_FILE tcl_file(INTER_TCL);
		int leading_zero;

		// dump stream tvin: "input"
		std::vector<axistream > aesl_tmp_0;
		int aesl_tmp_1 = 0;
		while (!input.empty())
		{
			aesl_tmp_0.push_back(input.read());
			aesl_tmp_1++;
		}

		// dump stream tvin: "output"
		std::vector<axistream > aesl_tmp_3;
		int aesl_tmp_4 = 0;
		while (!output.empty())
		{
			aesl_tmp_3.push_back(output.read());
			aesl_tmp_4++;
		}

		// push back input stream: "input"
		for (int i = 0; i < aesl_tmp_1; i++)
		{
			input.write(aesl_tmp_0[i]);
		}

		// push back input stream: "output"
		for (int i = 0; i < aesl_tmp_4; i++)
		{
			output.write(aesl_tmp_3[i]);
		}

// [call_c_dut] ---------->

		CodeState = CALL_C_DUT;
		test_hls_server(input, output);

		CodeState = DUMP_OUTPUTS;
		// record input size to tv3: "input"
		int aesl_tmp_2 = input.size();

		// pop output stream: "output"
		int aesl_tmp_5 = aesl_tmp_4;
		aesl_tmp_4 = 0;
     aesl_tmp_3.clear();
		while (!output.empty())
		{
			aesl_tmp_3.push_back(output.read());
			aesl_tmp_4++;
		}

		// [[transaction]]
		sprintf(tvin_input_V, "[[transaction]] %d\n", AESL_transaction);
		aesl_fh.write(AUTOTB_TVIN_input_V, tvin_input_V);
		aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, tvin_input_V);

		sc_bv<577>* input_V_tvin_wrapc_buffer = new sc_bv<577>[aesl_tmp_1 - aesl_tmp_2];

		// RTL Name: input_V
		{
			// bitslice(511, 0)
			{
				int hls_map_index = 0;
				// celement: input.V.tdata.V(511, 0)
				{
					// carray: (0) => (aesl_tmp_1 - aesl_tmp_2 - 1) @ (1)
					for (int i_0 = 0; i_0 <= aesl_tmp_1 - aesl_tmp_2 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_0[i_0].tdata
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_0[0].tdata
							// regulate_c_name       : input_V_tdata_V
							// input_type_conversion : (aesl_tmp_0[i_0].tdata).to_string(2).c_str()
							if (&(aesl_tmp_0[0].tdata) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<512> input_V_tdata_V_tmp_mem;
								input_V_tdata_V_tmp_mem = (aesl_tmp_0[i_0].tdata).to_string(2).c_str();
								input_V_tvin_wrapc_buffer[hls_map_index].range(511, 0) = input_V_tdata_V_tmp_mem.range(511, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
			// bitslice(575, 512)
			{
				int hls_map_index = 0;
				// celement: input.V.tkeep.V(63, 0)
				{
					// carray: (0) => (aesl_tmp_1 - aesl_tmp_2 - 1) @ (1)
					for (int i_0 = 0; i_0 <= aesl_tmp_1 - aesl_tmp_2 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_0[i_0].tkeep
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_0[0].tkeep
							// regulate_c_name       : input_V_tkeep_V
							// input_type_conversion : (aesl_tmp_0[i_0].tkeep).to_string(2).c_str()
							if (&(aesl_tmp_0[0].tkeep) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<64> input_V_tkeep_V_tmp_mem;
								input_V_tkeep_V_tmp_mem = (aesl_tmp_0[i_0].tkeep).to_string(2).c_str();
								input_V_tvin_wrapc_buffer[hls_map_index].range(575, 512) = input_V_tkeep_V_tmp_mem.range(63, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
			// bitslice(576, 576)
			{
				int hls_map_index = 0;
				// celement: input.V.tlast.V(0, 0)
				{
					// carray: (0) => (aesl_tmp_1 - aesl_tmp_2 - 1) @ (1)
					for (int i_0 = 0; i_0 <= aesl_tmp_1 - aesl_tmp_2 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_0[i_0].tlast
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_0[0].tlast
							// regulate_c_name       : input_V_tlast_V
							// input_type_conversion : (aesl_tmp_0[i_0].tlast).to_string(2).c_str()
							if (&(aesl_tmp_0[0].tlast) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<1> input_V_tlast_V_tmp_mem;
								input_V_tlast_V_tmp_mem = (aesl_tmp_0[i_0].tlast).to_string(2).c_str();
								input_V_tvin_wrapc_buffer[hls_map_index].range(576, 576) = input_V_tlast_V_tmp_mem.range(0, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
		}

		// dump tv to file
		for (int i = 0; i < aesl_tmp_1 - aesl_tmp_2; i++)
		{
			sprintf(tvin_input_V, "%s\n", (input_V_tvin_wrapc_buffer[i]).to_string(SC_HEX).c_str());
			aesl_fh.write(AUTOTB_TVIN_input_V, tvin_input_V);
		}

		// dump stream ingress status to file
     if (aesl_tmp_1 > aesl_tmp_2)
     {
		sc_int<32> stream_ingress_size_input_V = aesl_tmp_1;
		aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, stream_ingress_size_input_V.to_string().c_str());
		aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, "\n");

		for (int i = 0; i < aesl_tmp_1 - aesl_tmp_2; i++)
		{
			stream_ingress_size_input_V--;
			aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, stream_ingress_size_input_V.to_string().c_str());
			aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, "\n");
		}
     }
     else {
		    sc_int<32> stream_ingress_size_input_V = 0;
		    aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, stream_ingress_size_input_V.to_string().c_str());
		    aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, "\n");
     }

		tcl_file.set_num(aesl_tmp_1 - aesl_tmp_2, &tcl_file.input_V_depth);
		sprintf(tvin_input_V, "[[/transaction]] \n");
		aesl_fh.write(AUTOTB_TVIN_input_V, tvin_input_V);
		aesl_fh.write(WRAPC_STREAM_INGRESS_STATUS_input_V, tvin_input_V);

		// release memory allocation
		delete [] input_V_tvin_wrapc_buffer;

		// dump stream size
		sprintf(wrapc_stream_size_in_input_V, "[[transaction]] %d\n", AESL_transaction);
		aesl_fh.write(WRAPC_STREAM_SIZE_IN_input_V, wrapc_stream_size_in_input_V);
		sprintf(wrapc_stream_size_in_input_V, "%d\n", aesl_tmp_1 - aesl_tmp_2);
		aesl_fh.write(WRAPC_STREAM_SIZE_IN_input_V, wrapc_stream_size_in_input_V);
		sprintf(wrapc_stream_size_in_input_V, "[[/transaction]] \n");
		aesl_fh.write(WRAPC_STREAM_SIZE_IN_input_V, wrapc_stream_size_in_input_V);

		// [[transaction]]
		sprintf(tvout_output_V, "[[transaction]] %d\n", AESL_transaction);
		aesl_fh.write(AUTOTB_TVOUT_output_V, tvout_output_V);

		sc_bv<577>* output_V_tvout_wrapc_buffer = new sc_bv<577>[aesl_tmp_4 - aesl_tmp_5];

		// RTL Name: output_V
		{
			// bitslice(511, 0)
			{
				int hls_map_index = 0;
				// celement: output.V.tdata.V(511, 0)
				{
					// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
					for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_3[i_0].tdata
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_3[0].tdata
							// regulate_c_name       : output_V_tdata_V
							// input_type_conversion : (aesl_tmp_3[i_0].tdata).to_string(2).c_str()
							if (&(aesl_tmp_3[0].tdata) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<512> output_V_tdata_V_tmp_mem;
								output_V_tdata_V_tmp_mem = (aesl_tmp_3[i_0].tdata).to_string(2).c_str();
								output_V_tvout_wrapc_buffer[hls_map_index].range(511, 0) = output_V_tdata_V_tmp_mem.range(511, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
			// bitslice(575, 512)
			{
				int hls_map_index = 0;
				// celement: output.V.tkeep.V(63, 0)
				{
					// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
					for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_3[i_0].tkeep
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_3[0].tkeep
							// regulate_c_name       : output_V_tkeep_V
							// input_type_conversion : (aesl_tmp_3[i_0].tkeep).to_string(2).c_str()
							if (&(aesl_tmp_3[0].tkeep) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<64> output_V_tkeep_V_tmp_mem;
								output_V_tkeep_V_tmp_mem = (aesl_tmp_3[i_0].tkeep).to_string(2).c_str();
								output_V_tvout_wrapc_buffer[hls_map_index].range(575, 512) = output_V_tkeep_V_tmp_mem.range(63, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
			// bitslice(576, 576)
			{
				int hls_map_index = 0;
				// celement: output.V.tlast.V(0, 0)
				{
					// carray: (aesl_tmp_5) => (aesl_tmp_4 - 1) @ (1)
					for (int i_0 = aesl_tmp_5; i_0 <= aesl_tmp_4 - 1; i_0 += 1)
					{
						// carray: (0) => (0) @ (1)
						for (int i_1 = 0; i_1 <= 0; i_1 += 1)
						{
							// sub                   : i_0 i_1
							// ori_name              : aesl_tmp_3[i_0].tlast
							// sub_1st_elem          : 0 0
							// ori_name_1st_elem     : aesl_tmp_3[0].tlast
							// regulate_c_name       : output_V_tlast_V
							// input_type_conversion : (aesl_tmp_3[i_0].tlast).to_string(2).c_str()
							if (&(aesl_tmp_3[0].tlast) != NULL) // check the null address if the c port is array or others
							{
								sc_lv<1> output_V_tlast_V_tmp_mem;
								output_V_tlast_V_tmp_mem = (aesl_tmp_3[i_0].tlast).to_string(2).c_str();
								output_V_tvout_wrapc_buffer[hls_map_index].range(576, 576) = output_V_tlast_V_tmp_mem.range(0, 0);
                                 		       hls_map_index++;
							}
						}
					}
				}
			}
		}

		// dump tv to file
		for (int i = 0; i < aesl_tmp_4 - aesl_tmp_5; i++)
		{
			sprintf(tvout_output_V, "%s\n", (output_V_tvout_wrapc_buffer[i]).to_string(SC_HEX).c_str());
			aesl_fh.write(AUTOTB_TVOUT_output_V, tvout_output_V);
		}

		tcl_file.set_num(aesl_tmp_4 - aesl_tmp_5, &tcl_file.output_V_depth);
		sprintf(tvout_output_V, "[[/transaction]] \n");
		aesl_fh.write(AUTOTB_TVOUT_output_V, tvout_output_V);

		// release memory allocation
		delete [] output_V_tvout_wrapc_buffer;

		// dump stream size
		sprintf(wrapc_stream_size_out_output_V, "[[transaction]] %d\n", AESL_transaction);
		aesl_fh.write(WRAPC_STREAM_SIZE_OUT_output_V, wrapc_stream_size_out_output_V);
		sprintf(wrapc_stream_size_out_output_V, "%d\n", aesl_tmp_4 - aesl_tmp_5);
		aesl_fh.write(WRAPC_STREAM_SIZE_OUT_output_V, wrapc_stream_size_out_output_V);
		sprintf(wrapc_stream_size_out_output_V, "[[/transaction]] \n");
		aesl_fh.write(WRAPC_STREAM_SIZE_OUT_output_V, wrapc_stream_size_out_output_V);

		// push back output stream: "output"
		for (int i = 0; i < aesl_tmp_4; i++)
		{
			output.write(aesl_tmp_3[i]);
		}

		CodeState = DELETE_CHAR_BUFFERS;
		// release memory allocation: "input_V"
		delete [] tvin_input_V;
		delete [] wrapc_stream_size_in_input_V;
		// release memory allocation: "output_V"
		delete [] tvout_output_V;
		delete [] tvin_output_V;
		delete [] wrapc_stream_size_out_output_V;

		AESL_transaction++;

		tcl_file.set_num(AESL_transaction , &tcl_file.trans_num);
	}
}

