
/home/justin/jhai/Xilinx/Vivado/2018.3/bin/xelab xil_defaultlib.apatb_test_hls_server_top glbl -prj test_hls_server.prj -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_12 -L axi_protocol_checker_v1_1_13 -L axis_protocol_checker_v1_1_11 -L axis_protocol_checker_v1_1_12 -L xil_defaultlib -L unisims_ver -L xpm --initfile "/home/justin/jhai/Xilinx/Vivado/2018.3/data/xsim/ip/xsim_ip.ini" --lib "ieee_proposed=./ieee_proposed" -s test_hls_server 
/home/justin/jhai/Xilinx/Vivado/2018.3/bin/xsim --noieeewarnings test_hls_server -tclbatch test_hls_server.tcl

