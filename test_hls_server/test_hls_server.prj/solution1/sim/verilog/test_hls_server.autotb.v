// ==============================================================
// File generated on Mon Jul 27 11:39:43 EDT 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
 `timescale 1ns/1ps


`define AUTOTB_DUT      test_hls_server
`define AUTOTB_DUT_INST AESL_inst_test_hls_server
`define AUTOTB_TOP      apatb_test_hls_server_top
`define AUTOTB_LAT_RESULT_FILE "test_hls_server.result.lat.rb"
`define AUTOTB_PER_RESULT_TRANS_FILE "test_hls_server.performance.result.transaction.xml"
`define AUTOTB_TOP_INST AESL_inst_apatb_test_hls_server_top
`define AUTOTB_MAX_ALLOW_LATENCY  15000000
`define AUTOTB_CLOCK_PERIOD_DIV2 5.00
`define AUTOTB_II 1
`define AUTOTB_LATENCY 0

`define AESL_FIFO_input_V AESL_autofifo_input_V
`define AESL_FIFO_INST_input_V AESL_autofifo_inst_input_V
`define AESL_FIFO_output_V AESL_autofifo_output_V
`define AESL_FIFO_INST_output_V AESL_autofifo_inst_output_V
`define AUTOTB_TVIN_input_V  "../tv/cdatafile/c.test_hls_server.autotvin_input_V.dat"
`define AUTOTB_TVIN_output_V  "../tv/cdatafile/c.test_hls_server.autotvin_output_V.dat"
`define AUTOTB_TVIN_input_V_out_wrapc  "../tv/rtldatafile/rtl.test_hls_server.autotvin_input_V.dat"
`define AUTOTB_TVIN_output_V_out_wrapc  "../tv/rtldatafile/rtl.test_hls_server.autotvin_output_V.dat"
`define AUTOTB_TVOUT_output_V  "../tv/cdatafile/c.test_hls_server.autotvout_output_V.dat"
`define AUTOTB_TVOUT_output_V_out_wrapc  "../tv/rtldatafile/rtl.test_hls_server.autotvout_output_V.dat"
module `AUTOTB_TOP;

parameter AUTOTB_TRANSACTION_NUM = 1;
parameter PROGRESS_TIMEOUT = 10000000;
parameter LATENCY_ESTIMATION = 0;
parameter LENGTH_input_V = 1;
parameter LENGTH_output_V = 1;

task read_token;
    input integer fp;
    output reg [1175 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end
endtask

reg AESL_clock;
reg rst;
reg start;
reg ce;
reg tb_continue;
wire AESL_start;
wire AESL_reset;
wire AESL_ce;
wire AESL_ready;
wire AESL_idle;
wire AESL_continue;
reg AESL_done = 0;
reg AESL_done_delay = 0;
reg AESL_done_delay2 = 0;
reg AESL_ready_delay = 0;
wire ready;
wire ready_wire;
wire [576 : 0] input_V_dout;
wire  input_V_empty_n;
wire  input_V_read;
wire [576 : 0] output_V_din;
wire  output_V_full_n;
wire  output_V_write;
reg [31:0] ap_c_n_tvin_trans_num_input_V;
reg [31:0] ap_c_n_tvin_trans_num_output_V;
reg [31:0] ap_c_n_tvout_trans_num_output_V;
integer done_cnt = 0;
integer AESL_ready_cnt = 0;
integer ready_cnt = 0;
reg ready_initial;
reg ready_initial_n;
reg ready_last_n;
reg ready_delay_last_n;
reg done_delay_last_n;
reg interface_done = 0;

wire ap_clk;
wire ap_rst;
wire ap_rst_n;

`AUTOTB_DUT `AUTOTB_DUT_INST(
    .input_V_dout(input_V_dout),
    .input_V_empty_n(input_V_empty_n),
    .input_V_read(input_V_read),
    .output_V_din(output_V_din),
    .output_V_full_n(output_V_full_n),
    .output_V_write(output_V_write),
    .ap_clk(ap_clk),
    .ap_rst(ap_rst));

// Assignment for control signal
assign ap_clk = AESL_clock;
assign ap_rst = AESL_reset;
assign ap_rst_n = ~AESL_reset;
assign AESL_reset = rst;
assign AESL_start = start;
assign AESL_ce = ce;
assign AESL_continue = tb_continue;
assign AESL_ready = ready;
// Fifo Instantiation input_V

wire fifoinput_V_rd;
wire [576 : 0] fifoinput_V_dout;
wire fifoinput_V_empty_n;
wire fifoinput_V_ready;
wire fifoinput_V_done;

`AESL_FIFO_input_V `AESL_FIFO_INST_input_V (
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (),
    .if_din       (),
    .if_full_n    (),
    .if_read      (fifoinput_V_rd),
    .if_dout      (fifoinput_V_dout),
    .if_empty_n   (fifoinput_V_empty_n),
    .ready        (fifoinput_V_ready),
    .done         (fifoinput_V_done)
);

// Assignment between dut and fifoinput_V

// Assign input of fifoinput_V
assign      fifoinput_V_rd        =   input_V_read & input_V_empty_n;
assign    fifoinput_V_ready   =   ready;
assign    fifoinput_V_done    =   0;
// Assign input of dut
assign      input_V_dout       =   fifoinput_V_dout;
reg   reg_fifoinput_V_empty_n;
initial begin : gen_reg_fifoinput_V_empty_n_process
    integer proc_rand;
    reg_fifoinput_V_empty_n = fifoinput_V_empty_n;
    while (1) begin
        @ (fifoinput_V_empty_n);
        reg_fifoinput_V_empty_n = fifoinput_V_empty_n;
    end
end

assign      input_V_empty_n    =   reg_fifoinput_V_empty_n;


//------------------------Fifooutput_V Instantiation--------------

// The input and output of fifooutput_V
wire  fifooutput_V_wr;
wire  [576 : 0] fifooutput_V_din;
wire  fifooutput_V_full_n;
wire  fifooutput_V_ready;
wire  fifooutput_V_done;

`AESL_FIFO_output_V `AESL_FIFO_INST_output_V(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifooutput_V_wr),
    .if_din       (fifooutput_V_din),
    .if_full_n    (fifooutput_V_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifooutput_V_ready),
    .done         (fifooutput_V_done)
);

// Assignment between dut and fifooutput_V

// Assign input of fifooutput_V
assign      fifooutput_V_wr        =   output_V_write & output_V_full_n;
assign      fifooutput_V_din        =   output_V_din;
assign    fifooutput_V_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifooutput_V_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifooutput_V_full_n;
initial begin : gen_reg_fifooutput_V_full_n_process
    integer proc_rand;
    reg_fifooutput_V_full_n = fifooutput_V_full_n;
    while (1) begin
        @ (fifooutput_V_full_n);
        reg_fifooutput_V_full_n = fifooutput_V_full_n;
    end
end

assign      output_V_full_n    =   reg_fifooutput_V_full_n;


initial begin : generate_AESL_ready_cnt_proc
    AESL_ready_cnt = 0;
    wait(AESL_reset === 0);
    while(AESL_ready_cnt != AUTOTB_TRANSACTION_NUM) begin
        while(AESL_ready !== 1) begin
            @(posedge AESL_clock);
            # 0.4;
        end
        @(negedge AESL_clock);
        AESL_ready_cnt = AESL_ready_cnt + 1;
        @(posedge AESL_clock);
        # 0.4;
    end
end

    event next_trigger_ready_cnt;
    
    initial begin : gen_ready_cnt
        ready_cnt = 0;
        wait (AESL_reset === 0);
        forever begin
            @ (posedge AESL_clock);
            if (ready == 1) begin
                if (ready_cnt < AUTOTB_TRANSACTION_NUM) begin
                    ready_cnt = ready_cnt + 1;
                end
            end
            -> next_trigger_ready_cnt;
        end
    end
    
    wire all_finish = (done_cnt == AUTOTB_TRANSACTION_NUM);
    
    // done_cnt
    always @ (posedge AESL_clock) begin
        if (AESL_reset) begin
            done_cnt <= 0;
        end else begin
            if (AESL_done == 1) begin
                if (done_cnt < AUTOTB_TRANSACTION_NUM) begin
                    done_cnt <= done_cnt + 1;
                end
            end
        end
    end
    
    initial begin : finish_simulation
        wait (all_finish == 1);
        // last transaction is saved at negedge right after last done
        @ (posedge AESL_clock);
        @ (posedge AESL_clock);
        @ (posedge AESL_clock);
        @ (posedge AESL_clock);
        $finish;
    end
    
initial begin
    AESL_clock = 0;
    forever #`AUTOTB_CLOCK_PERIOD_DIV2 AESL_clock = ~AESL_clock;
end


reg end_input_V;
reg [31:0] size_input_V;
reg [31:0] size_input_V_backup;
reg end_output_V;
reg [31:0] size_output_V;
reg [31:0] size_output_V_backup;

initial begin : initial_process
    integer proc_rand;
    rst = 1;
    # 100;
    repeat(3) @ (posedge AESL_clock);
    rst = 0;
end
    // input_V : fifo
    reg ready_input_V;
    
    always @ (*) begin
        if (end_input_V) begin
            ready_input_V <= 1;
        end else if (ap_c_n_tvin_trans_num_input_V > ready_cnt) begin
            ready_input_V <= 1;
        end else begin
            ready_input_V <= 0;
        end
    end
    
    // output_V : fifo
    reg ready_output_V;
    
    always @ (*) begin
        if (end_output_V) begin
            ready_output_V <= 1;
        end else if (ap_c_n_tvin_trans_num_output_V > ready_cnt) begin
            ready_output_V <= 1;
        end else begin
            ready_output_V <= 0;
        end
    end
    
    // start
    always @ (*) begin
        if (AESL_reset) begin
            start <= 0;
        end else begin
            start <= ready_input_V && ready_output_V;
        end
    end

always @(AESL_done)
begin
    tb_continue = AESL_done;
end

initial begin : ready_initial_process
    ready_initial = 0;
    wait(AESL_reset === 0);
    ready_initial = 1;
    @(posedge AESL_clock);
    ready_initial = 0;
end

initial begin : ready_last_n_process
  ready_last_n = 1;
  wait(ready_cnt == AUTOTB_TRANSACTION_NUM)
  @(posedge AESL_clock);
  ready_last_n <= 0;
end

assign ready = AESL_start;
assign ready_wire = ready;
initial begin : done_delay_last_n_process
  done_delay_last_n = 1;
  while(done_cnt < AUTOTB_TRANSACTION_NUM)
      @(posedge AESL_clock);
  # 0.1;
  done_delay_last_n = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset)
  begin
      AESL_done_delay <= 0;
      AESL_done_delay2 <= 0;
  end
  else begin
      AESL_done_delay <= AESL_done & done_delay_last_n;
      AESL_done_delay2 <= AESL_done_delay;
  end
end
always @(posedge AESL_clock)
begin
    if(AESL_reset)
      interface_done = 0;
  else begin
      # 0.01;
      if(ready === 1 && ready_cnt > 0 && ready_cnt < AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else if(AESL_done_delay === 1 && done_cnt == AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else
          interface_done = 0;
  end
end
    // output_V : fifo
    reg done_output_V;
    
    always @ (*) begin
        if (end_output_V) begin
            done_output_V <= 1;
        end else if (ap_c_n_tvout_trans_num_output_V > done_cnt + 1) begin
            done_output_V <= 1;
        end else if (size_output_V > 1) begin
            done_output_V <= 0;
        end else if (output_V_write == 1) begin
            done_output_V <= 1;
        end else begin
            done_output_V <= 0;
        end
    end
    
    // AESL_done
    always @ (*) begin
        if (AESL_reset) begin
            AESL_done <= 0;
        end else begin
            AESL_done <= done_output_V;
        end
    end
    
    `define STREAM_SIZE_IN_input_V "../tv/stream_size/stream_size_in_input_V.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_input_V
        integer fp_input_V;
        reg [127:0] token_input_V;
        integer ret;
        
        ap_c_n_tvin_trans_num_input_V = 0;
        end_input_V = 0;
        wait (AESL_reset === 0);
        
        fp_input_V = $fopen(`STREAM_SIZE_IN_input_V, "r");
        if(fp_input_V == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_input_V);
            $finish;
        end
        read_token(fp_input_V, token_input_V); // should be [[[runtime]]]
        if (token_input_V != "[[[runtime]]]") begin
            $display("ERROR: token_input_V != \"[[[runtime]]]\"");
            $finish;
        end
        size_input_V = 0;
        size_input_V_backup = 0;
        while (size_input_V == 0 && end_input_V == 0) begin
            ap_c_n_tvin_trans_num_input_V = ap_c_n_tvin_trans_num_input_V + 1;
            read_token(fp_input_V, token_input_V); // should be [[transaction]] or [[[/runtime]]]
            if (token_input_V == "[[transaction]]") begin
                read_token(fp_input_V, token_input_V); // should be transaction number
                read_token(fp_input_V, token_input_V); // should be size for hls::stream
                ret = $sscanf(token_input_V, "%d", size_input_V);
                if (size_input_V > 0) begin
                    size_input_V_backup = size_input_V;
                end
                read_token(fp_input_V, token_input_V); // should be [[/transaction]]
            end else if (token_input_V == "[[[/runtime]]]") begin
                $fclose(fp_input_V);
                end_input_V = 1;
            end else begin
                $display("ERROR: unknown token_input_V");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_input_V == 0) begin
                if (input_V_read == 1) begin
                    if (size_input_V > 0) begin
                        size_input_V = size_input_V - 1;
                        while (size_input_V == 0 && end_input_V == 0) begin
                            ap_c_n_tvin_trans_num_input_V = ap_c_n_tvin_trans_num_input_V + 1;
                            read_token(fp_input_V, token_input_V); // should be [[transaction]] or [[[/runtime]]]
                            if (token_input_V == "[[transaction]]") begin
                                read_token(fp_input_V, token_input_V); // should be transaction number
                                read_token(fp_input_V, token_input_V); // should be size for hls::stream
                                ret = $sscanf(token_input_V, "%d", size_input_V);
                                if (size_input_V > 0) begin
                                    size_input_V_backup = size_input_V;
                                end
                                read_token(fp_input_V, token_input_V); // should be [[/transaction]]
                            end else if (token_input_V == "[[[/runtime]]]") begin
                                size_input_V = size_input_V_backup;
                                $fclose(fp_input_V);
                                end_input_V = 1;
                            end else begin
                                $display("ERROR: unknown token_input_V");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if (input_V_read == 1) begin
                    if (size_input_V > 0) begin
                        size_input_V = size_input_V - 1;
                        if (size_input_V == 0) begin
                            ap_c_n_tvin_trans_num_input_V = ap_c_n_tvin_trans_num_input_V + 1;
                            size_input_V = size_input_V_backup;
                        end
                    end
                end
            end
        end
    end
    
    
    initial begin : proc_ap_c_n_tvin_trans_num_output_V
        ap_c_n_tvin_trans_num_output_V = AUTOTB_TRANSACTION_NUM + 1;
    end
    `define STREAM_SIZE_OUT_output_V "../tv/stream_size/stream_size_out_output_V.dat"
    
    initial begin : proc_ap_c_n_tvout_trans_num_output_V
        integer fp_output_V;
        reg [127:0] token_output_V;
        integer ret;
        
        ap_c_n_tvout_trans_num_output_V = 0;
        end_output_V = 0;
        wait (AESL_reset === 0);
        
        fp_output_V = $fopen(`STREAM_SIZE_OUT_output_V, "r");
        if (fp_output_V == 0) begin // Failed to open file
            $display("Failed to open size file for \"%s\"!", `STREAM_SIZE_OUT_output_V);
            $finish;
        end
        read_token(fp_output_V, token_output_V);
        if (token_output_V != "[[[runtime]]]") begin
            $display("ERROR: token_output_V != \"[[[runtime]]]\"");
            $finish;
        end
        
        size_output_V = 0;
        while (size_output_V == 0 && end_output_V == 0) begin
            ap_c_n_tvout_trans_num_output_V = ap_c_n_tvout_trans_num_output_V + 1;
            read_token(fp_output_V, token_output_V); // should be [[transaction]] or [[[/runtime]]]
            if (token_output_V == "[[transaction]]") begin
                read_token(fp_output_V, token_output_V); // should be transaction number
                read_token(fp_output_V, token_output_V); // should be size for hls::stream
                ret = $sscanf(token_output_V, "%d", size_output_V);
                read_token(fp_output_V, token_output_V); // should be [[/transaction]]
            end else if (token_output_V == "[[[/runtime]]]") begin
                $fclose(fp_output_V);
                end_output_V = 1;
            end else begin
                $display("ERROR: unknown token_output_V");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_output_V == 0) begin 
                if (output_V_write == 1) begin 
                    if (size_output_V > 0) begin
                        size_output_V = size_output_V - 1;
                        while (size_output_V == 0 && end_output_V == 0) begin
                            ap_c_n_tvout_trans_num_output_V = ap_c_n_tvout_trans_num_output_V + 1;
                            read_token(fp_output_V, token_output_V); // should be [[transaction]] or [[[/runtime]]]
                            if (token_output_V == "[[transaction]]") begin
                                read_token(fp_output_V, token_output_V); // should be transaction number
                                read_token(fp_output_V, token_output_V); // should be size for hls::stream
                                ret = $sscanf(token_output_V, "%d", size_output_V);
                                read_token(fp_output_V, token_output_V); // should be [[/transaction]]
                            end else if (token_output_V == "[[[/runtime]]]") begin
                                $fclose(fp_output_V);
                                end_output_V = 1;
                            end else begin
                                $display("ERROR: unknown token_output_V");
                                $finish;
                            end
                        end
                    end
                end
            end
        end
    end

reg dump_tvout_finish_output_V;

initial begin : dump_tvout_runtime_sign_output_V
    integer fp;
    dump_tvout_finish_output_V = 0;
    fp = $fopen(`AUTOTB_TVOUT_output_V_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_output_V_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    @ (posedge AESL_clock);
    @ (posedge AESL_clock);
    @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_output_V_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_output_V_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_output_V = 1;
end


////////////////////////////////////////////
// progress and performance
////////////////////////////////////////////

task wait_start();
    while (~AESL_start) begin
        @ (posedge AESL_clock);
    end
endtask

reg [31:0] clk_cnt = 0;
reg AESL_ready_p1;
reg AESL_start_p1;

always @ (posedge AESL_clock) begin
    clk_cnt <= clk_cnt + 1;
    AESL_ready_p1 <= AESL_ready;
    AESL_start_p1 <= AESL_start;
end

reg [31:0] start_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] start_cnt;
reg [31:0] ready_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] ap_ready_cnt;
reg [31:0] finish_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] finish_cnt;
event report_progress;

initial begin
    start_cnt = 0;
    finish_cnt = 0;
    ap_ready_cnt = 0;
    wait (AESL_reset == 0);
    wait_start();
    start_timestamp[start_cnt] = clk_cnt;
    start_cnt = start_cnt + 1;
    if (AESL_done) begin
        finish_timestamp[finish_cnt] = clk_cnt;
        finish_cnt = finish_cnt + 1;
    end
    -> report_progress;
    forever begin
        @ (posedge AESL_clock);
        if (start_cnt < AUTOTB_TRANSACTION_NUM) begin
            if ((AESL_start && AESL_ready_p1)||(AESL_start && ~AESL_start_p1)) begin
                start_timestamp[start_cnt] = clk_cnt;
                start_cnt = start_cnt + 1;
            end
        end
        if (ap_ready_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_start_p1 && AESL_ready_p1) begin
                ready_timestamp[ap_ready_cnt] = clk_cnt;
                ap_ready_cnt = ap_ready_cnt + 1;
            end
        end
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                finish_timestamp[finish_cnt] = clk_cnt;
                finish_cnt = finish_cnt + 1;
            end
        end
        -> report_progress;
    end
end

reg [31:0] progress_timeout;

initial begin : simulation_progress
    real intra_progress;
    wait (AESL_reset == 0);
    progress_timeout = PROGRESS_TIMEOUT;
    $display("////////////////////////////////////////////////////////////////////////////////////");
    $display("// Inter-Transaction Progress: Completed Transaction / Total Transaction");
    $display("// Intra-Transaction Progress: Measured Latency / Latency Estimation * 100%%");
    $display("//");
    $display("// RTL Simulation : \"Inter-Transaction Progress\" [\"Intra-Transaction Progress\"] @ \"Simulation Time\"");
    $display("////////////////////////////////////////////////////////////////////////////////////");
    print_progress();
    while (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
        @ (report_progress);
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                print_progress();
                progress_timeout = PROGRESS_TIMEOUT;
            end else begin
                if (progress_timeout == 0) begin
                    print_progress();
                    progress_timeout = PROGRESS_TIMEOUT;
                end else begin
                    progress_timeout = progress_timeout - 1;
                end
            end
        end
    end
    print_progress();
    $display("////////////////////////////////////////////////////////////////////////////////////");
    calculate_performance();
end

task get_intra_progress(output real intra_progress);
    begin
        if (start_cnt > finish_cnt) begin
            intra_progress = clk_cnt - start_timestamp[finish_cnt];
        end else if(finish_cnt > 0) begin
            intra_progress = LATENCY_ESTIMATION;
        end else begin
            intra_progress = 0;
        end
        intra_progress = intra_progress / LATENCY_ESTIMATION;
    end
endtask

task print_progress();
    real intra_progress;
    begin
        if (LATENCY_ESTIMATION > 0) begin
            get_intra_progress(intra_progress);
            $display("// RTL Simulation : %0d / %0d [%2.2f%%] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, intra_progress * 100, $time);
        end else begin
            $display("// RTL Simulation : %0d / %0d [n/a] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, $time);
        end
    end
endtask

task calculate_performance();
    integer i;
    integer fp;
    reg [31:0] latency [0:AUTOTB_TRANSACTION_NUM - 1];
    reg [31:0] latency_min;
    reg [31:0] latency_max;
    reg [31:0] latency_total;
    reg [31:0] latency_average;
    reg [31:0] interval [0:AUTOTB_TRANSACTION_NUM - 2];
    reg [31:0] interval_min;
    reg [31:0] interval_max;
    reg [31:0] interval_total;
    reg [31:0] interval_average;
    begin
        latency_min = -1;
        latency_max = 0;
        latency_total = 0;
        interval_min = -1;
        interval_max = 0;
        interval_total = 0;

        for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
            // calculate latency
            latency[i] = finish_timestamp[i] - start_timestamp[i];
            if (latency[i] > latency_max) latency_max = latency[i];
            if (latency[i] < latency_min) latency_min = latency[i];
            latency_total = latency_total + latency[i];
            // calculate interval
            if (AUTOTB_TRANSACTION_NUM == 1) begin
                interval[i] = 0;
                interval_max = 0;
                interval_min = 0;
                interval_total = 0;
            end else if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                interval[i] = finish_timestamp[i] - start_timestamp[i]+1;
                if (interval[i] > interval_max) interval_max = interval[i];
                if (interval[i] < interval_min) interval_min = interval[i];
                interval_total = interval_total + interval[i];
            end
        end

        latency_average = latency_total / AUTOTB_TRANSACTION_NUM;
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            interval_average = 0;
        end else begin
            interval_average = interval_total / (AUTOTB_TRANSACTION_NUM - 1);
        end

        fp = $fopen(`AUTOTB_LAT_RESULT_FILE, "w");

        $fdisplay(fp, "$MAX_LATENCY = \"%0d\"", latency_max);
        $fdisplay(fp, "$MIN_LATENCY = \"%0d\"", latency_min);
        $fdisplay(fp, "$AVER_LATENCY = \"%0d\"", latency_average);
        $fdisplay(fp, "$MAX_THROUGHPUT = \"%0d\"", interval_max);
        $fdisplay(fp, "$MIN_THROUGHPUT = \"%0d\"", interval_min);
        $fdisplay(fp, "$AVER_THROUGHPUT = \"%0d\"", interval_average);

        $fclose(fp);

        fp = $fopen(`AUTOTB_PER_RESULT_TRANS_FILE, "w");

        $fdisplay(fp, "%20s%16s%16s", "", "latency", "interval");
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            i = 0;
            $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
        end else begin
            for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
                if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                    $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
                end else begin
                    $fdisplay(fp, "transaction%8d:%16d               x", i, latency[i]);
                end
            end
        end

        $fclose(fp);
    end
endtask


////////////////////////////////////////////
// Dependence Check
////////////////////////////////////////////

`ifndef POST_SYN

`endif

endmodule
