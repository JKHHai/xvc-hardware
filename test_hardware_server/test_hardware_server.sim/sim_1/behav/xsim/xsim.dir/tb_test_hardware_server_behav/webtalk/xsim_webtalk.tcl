webtalk_init -webtalk_dir /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/test_hardware_server.sim/sim_1/behav/xsim/xsim.dir/tb_test_hardware_server_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Tue Aug 25 21:01:44 2020" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2019.1 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2552052" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "174111048_179741397_210699440_801" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "252c6b3b-9ab6-4f5c-b33d-58b5be277c3b" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "4263e278493e4005873bd9c7775c7147" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "73" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 16.04.6 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "1514.046 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "67.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "3120 ns" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "0" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "0.11_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "125884_KB" -context "xsim\\usage"
webtalk_transmit -clientid 1683295675 -regid "174111048_179741397_210699440_801" -xml /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/test_hardware_server.sim/sim_1/behav/xsim/xsim.dir/tb_test_hardware_server_behav/webtalk/usage_statistics_ext_xsim.xml -html /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/test_hardware_server.sim/sim_1/behav/xsim/xsim.dir/tb_test_hardware_server_behav/webtalk/usage_statistics_ext_xsim.html -wdm /home/justin/paulchowresearch2020/xvc/xvc-hardware/test_hardware_server/test_hardware_server.sim/sim_1/behav/xsim/xsim.dir/tb_test_hardware_server_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
