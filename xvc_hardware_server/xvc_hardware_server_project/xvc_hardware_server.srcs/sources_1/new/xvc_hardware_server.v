`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2020 07:10:06 PM
// Design Name: 
// Module Name: xvc_hardware_server
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module xvc_hardware_server
    #(
        parameter INPUT_AXIS_DATA_WIDTH = 512, // Width of input data bus in bits
        parameter OUTPUT_AXIS_DATA_WIDTH = 512, // Width of output data bus in bits
        parameter DEBUG_BRIDGE_DATA_WIDTH = 32, // Width of the debug bridge's AXI-Lite data bus in bits
        parameter DEBUG_BRIDGE_ADDRESS_WIDTH = 8 // Width of the debug bridge's AXI-Lite address bus in bits
    )
    (
        input i_clk,
        input i_aresetn,
        // Input AXI-Stream
        input i_input_TVALID,
        output o_input_TREADY,
        input [INPUT_AXIS_DATA_WIDTH-1:0] i_input_TDATA,
        input [(INPUT_AXIS_DATA_WIDTH-1)/8:0] i_input_TKEEP,
        input i_input_TLAST,
        // Input network information
        input [31:0] i_remote_ip_rx,
        input [15:0] i_remote_port_rx,
        input [15:0] i_local_port_rx,
        // Output AXI-Stream
        output o_output_TVALID,
        input i_output_TREADY,
        output [OUTPUT_AXIS_DATA_WIDTH-1:0] o_output_TDATA,
        output [(OUTPUT_AXIS_DATA_WIDTH-1)/8:0] o_output_TKEEP,
        output o_output_TLAST,
        // Output network information
        output [31:0] o_remote_ip_tx,
        output [15:0] o_remote_port_tx,
        output [15:0] o_local_port_tx,
        // Output AXI-LITE interface to Debug Bridge
        output [DEBUG_BRIDGE_ADDRESS_WIDTH-1:0] o_axi_araddr,
	    output [3:0] o_axi_arcache,
	    output [2:0] o_axi_arprot,
	    input i_axi_arready,
	    output o_axi_arvalid,
	    output [DEBUG_BRIDGE_ADDRESS_WIDTH-1:0] o_axi_awaddr,
	    output [3:0] o_axi_awcache,
	    output [2:0] o_axi_awprot,
	    input i_axi_awready,
	    output o_axi_awvalid,
	    output o_axi_bready,
	    input [1:0] i_axi_bresp,
	    input i_axi_bvalid,
	    input [DEBUG_BRIDGE_DATA_WIDTH-1:0] i_axi_rdata,
	    output o_axi_rready,
	    input [1:0] i_axi_rresp,
	    input i_axi_rvalid,
	    output [DEBUG_BRIDGE_DATA_WIDTH-1:0] o_axi_wdata,
	    input i_axi_wready,
	    output [3:0] o_axi_wstrb,
	    output o_axi_wvalid
    );

    // Declarations
    localparam STATE_IDLE = 4'd0; // Core is waiting for inputs
    localparam STATE_AXI_STREAM_DATA_CONVERSION = 4'd1; // Data has been received and is being converted (removal of invalid bits, shifting to start at LSB)
    localparam STATE_SETUP = 4'd2;
    localparam STATE_WRITE_TO_DEBUG_BRIDGE = 4'd3;
    localparam STATE_READ_TDO = 4'd4;
    localparam STATE_TDO_REVERSAL = 4'd5;
    localparam STATE_TDO_SHIFT_TO_MSB = 4'd6;
    localparam STATE_SEND_TDO = 4'd7;
    // Parameters - Input AXI-Stream
    localparam METADATA_WIDTH = INPUT_AXIS_DATA_WIDTH + 32 + 16 + 16; // Width of input data and remote IP, remote Port, and Local port, respectively
    // Parameters - Read TDO
    localparam TDO_CAPACITY = OUTPUT_AXIS_DATA_WIDTH / DEBUG_BRIDGE_DATA_WIDTH;
    localparam NEAR_TDO_CAPACITY = DEBUG_BRIDGE_DATA_WIDTH * (TDO_CAPACITY - 1); // This indicates if there is space for 1 more transfer in the TDO being sent out via AXI-Stream
    // Registers
    reg [3:0] r_core_state;
    reg [31:0] r_remaining_bits_to_send; // Represents the remaining number of TMS/TDI bits to send
    reg [31:0] r_num_bits_sent; // IMPORTANT: THIS DOES NOT REPRESENT THE TOTAL NUMBER OF BITS SENT, IT IS USED TO TRACK NUMBER OF BITS SENT OUT OF THE CURRENT AXI-STREAM TRANSFER
    // Wires
    wire w_aresetp; // Goes high when aresetn goes low
    // Registers - Input Stream
    reg [INPUT_AXIS_DATA_WIDTH-1:0] r_input_tdata;
    reg [(INPUT_AXIS_DATA_WIDTH-1)/8:0] r_input_tkeep;
    reg r_input_tlast;
    // Input Stream Network Information
    reg [31:0] r_remote_ip_rx;
    reg [15:0] r_remote_port_rx;
    reg [15:0] r_local_port_rx;
    // Wires - Input Stream
    wire [METADATA_WIDTH-1:0] w_input_metadata_tdata; // Concatenated input data in form {i_local_port_rx, i_remote_port_rx, i_remote_ip_rx, i_input_tdata}
    wire [(METADATA_WIDTH-1/8):0] w_input_metadata_tkeep; // Concatenated input keep bits in form {2{1'b1}, 2{1'b1}, 4{1'b1}, i_input_tkeep}
    wire w_fifo_tvalid;
    wire w_fifo_tready;
    wire [METADATA_WIDTH-1:0] w_fifo_metadata_tdata;
    wire [(METADATA_WIDTH-1)/8:0] w_fifo_metadata_tkeep;
    wire w_fifo_tlast;
    // Registers - Input Data Conversion
    reg [INPUT_AXIS_DATA_WIDTH-1:0] r_valid_input_tdata_reversed_little_endian;
    // Wires - Input Data Conversion
    wire [INPUT_AXIS_DATA_WIDTH-1:0] w_input_keep_mask;
    wire [INPUT_AXIS_DATA_WIDTH-1:0] w_valid_input_tdata;
    wire [INPUT_AXIS_DATA_WIDTH-1:0] w_valid_input_tdata_reversed_little_endian;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_first_input_data_word; // The least significant DEBUG_BRIDGE_DATA_WIDTH bits from r_valid_input_tdata;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_first_input_data_word_little_endian;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_second_input_data_word_little_endian;
    // Registers - Write to Debug Bridge
    reg r_dbw_input_valid;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_length;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_tms;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_tdi;
    reg [OUTPUT_AXIS_DATA_WIDTH-1:0] r_tdo;
    reg [(OUTPUT_AXIS_DATA_WIDTH-1)/8:0] r_tdo_keep;
    // Wires - Write to Debug Bridge
    wire w_dbw_input_valid;
    wire w_dbw_input_ready;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_dbw_length;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_dbw_tms;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_dbw_tdi;
    wire w_dbw_tdo_valid;
    wire w_dbw_tdo_ready;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_tdo;
    wire [OUTPUT_AXIS_DATA_WIDTH-1:0] w_tdo_shifted;
    // Registers - Output Data Conversion and Stream
    reg [OUTPUT_AXIS_DATA_WIDTH-1:0] r_output_tdata;
    reg [(OUTPUT_AXIS_DATA_WIDTH-1)/8:0] r_output_tkeep;
    reg r_output_tlast;
    // Wires - Output Data Conversion and Stream
    wire [OUTPUT_AXIS_DATA_WIDTH-1:0] w_r_tdo_reversed;
    wire [(OUTPUT_AXIS_DATA_WIDTH-1)/8:0] w_r_tdo_keep_reversed;
    // Output Stream Network Information
    reg [31:0] r_remote_ip_tx;
    reg [15:0] r_remote_port_tx;
    reg [15:0] r_local_port_tx;

    // Assignments
    assign w_aresetp = ~i_aresetn;
    // Assignments - Input Data Stream
    assign w_fifo_tready = (r_core_state == STATE_IDLE ? 1'b1 : 1'b0);
    assign w_input_metadata_tdata = {i_local_port_rx[15:0], i_remote_port_rx[15:0], i_remote_ip_rx[31:0], i_input_TDATA[INPUT_AXIS_DATA_WIDTH-1:0]};
    assign w_input_metadata_tkeep = {{6{1'b1}}, i_input_TKEEP[(INPUT_AXIS_DATA_WIDTH-1)/8:0]};
    // Assignments - AXI-Stream Data Conversion
    assign w_valid_input_tdata = r_input_tdata & w_input_keep_mask;
    assign w_first_input_data_word_little_endian = r_valid_input_tdata_reversed_little_endian[0+:DEBUG_BRIDGE_DATA_WIDTH];
    assign w_second_input_data_word_little_endian = r_valid_input_tdata_reversed_little_endian[DEBUG_BRIDGE_DATA_WIDTH+:DEBUG_BRIDGE_DATA_WIDTH];
    genvar i;
    generate
        // Generation of input keep mask
        for (i = 0; i < (INPUT_AXIS_DATA_WIDTH/8); i = i + 1)
        begin
            assign w_input_keep_mask[8*i+:8] = r_input_tkeep[i] == 1 ? 8'b11111111 : 8'b00000000;
        end
    endgenerate
    genvar j;
    generate
        // Reverse input data
        for (j = 0; j < (INPUT_AXIS_DATA_WIDTH/8); j = j + 1)
        begin
            assign w_valid_input_tdata_reversed_little_endian[8*(INPUT_AXIS_DATA_WIDTH/8-1-j)+:8] = w_valid_input_tdata[8*j+:8];
        end
    endgenerate
    // Assignments - Setup
    genvar h;
    generate
        // Reverse first input data word for Setup, to get length in big endian format
        for (h = 0; h < (DEBUG_BRIDGE_DATA_WIDTH/8); h = h + 1)
        begin
            assign w_first_input_data_word[8*(DEBUG_BRIDGE_DATA_WIDTH/8-1-h)+:8] = w_first_input_data_word_little_endian[8*h+:8];
        end
    endgenerate
    // Assignments - Write to Debug Bridge
    assign w_dbw_input_valid = r_dbw_input_valid;
    assign w_dbw_length = r_length;
    assign w_dbw_tms = r_tms;
    assign w_dbw_tdi = r_tdi;
    assign w_dbw_tdo_ready = r_core_state == STATE_READ_TDO ? 1'b1 : 1'b0;
    // Assignments - Read TDO
    assign w_tdo_shifted = w_tdo << (DEBUG_BRIDGE_DATA_WIDTH * (TDO_CAPACITY - 1)); // Shift the tdo to the most significant position
    // Assignments - Output Data Conversion
    genvar k;
    generate
        // Reversal of TDO
        for (k = 0; k < (OUTPUT_AXIS_DATA_WIDTH/8); k = k + 1)
        begin
            assign w_r_tdo_reversed[8*(OUTPUT_AXIS_DATA_WIDTH/8-1-k)+:8] = r_tdo[8*k+:8];
        end
    endgenerate
    genvar m;
    generate
        // Reversal of TDO keep
        for (m = 0; m < (OUTPUT_AXIS_DATA_WIDTH/8); m = m + 1)
        begin
            assign w_r_tdo_keep_reversed[8*(OUTPUT_AXIS_DATA_WIDTH/8-1-m)] = r_tdo_keep[8*m];
        end
    endgenerate
    // Assignments - Send TDO
    assign o_output_TVALID = r_core_state == STATE_SEND_TDO ? 1'b1 : 1'b0;
    assign o_output_TDATA = r_output_tdata;
    assign o_output_TKEEP = r_output_tkeep;
    assign o_output_TLAST = r_output_tlast;
    assign o_remote_ip_tx = r_remote_ip_tx;
    assign o_remote_port_tx = r_remote_port_tx;
    assign o_local_port_tx = r_local_port_tx;

    // Modules
    zero_latency_axis_fifo #(
        .DATA_WIDTH(METADATA_WIDTH),
	    .FIFO_DEPTH(512),
	    .HAS_DATA(1),
	    .HAS_KEEP(1),
	    .HAS_LAST(1),
	    .RAM_STYLE("auto")
    )
    input_fifo
    (
        .clk(i_clk),
	    .rst(w_aresetp),
	    .s_axis_tdata(w_input_metadata_tdata),
	    .s_axis_tkeep(w_input_metadata_tkeep),
	    .s_axis_tlast(i_input_TLAST),
	    .s_axis_tvalid(i_input_TVALID),
	    .m_axis_tready(w_fifo_tready),
	    .s_axis_tready(o_input_TREADY),
	    .m_axis_tdata(w_fifo_metadata_tdata),
	    .m_axis_tkeep(w_fifo_metadata_tkeep),
	    .m_axis_tlast(w_fifo_tlast),
	    .m_axis_tvalid(w_fifo_tvalid),
	    .data_cnt() // Shows number of entries currently in FIFO, not used in this module
    );

    debug_bridge_writer #(
        .DEBUG_BRIDGE_DATA_WIDTH(DEBUG_BRIDGE_DATA_WIDTH),
        .DEBUG_BRIDGE_ADDRESS_WIDTH(DEBUG_BRIDGE_ADDRESS_WIDTH)
    )
    dbw
    (
        .i_clk(i_clk),
        .i_aresetn(i_aresetn),
        .i_input_valid(w_dbw_input_valid),
        .o_input_ready(w_dbw_input_ready),
        .i_length(w_dbw_length),
        .i_tms(w_dbw_tms),
        .i_tdi(w_dbw_tdi),
        .o_tdo_valid(w_dbw_tdo_valid),
        .i_tdo_ready(w_dbw_tdo_ready),
        .o_tdo_data(w_tdo),
        .o_axi_araddr(o_axi_araddr),
	    .o_axi_arcache(o_axi_arcache),
	    .o_axi_arprot(o_axi_arprot),
	    .i_axi_arready(i_axi_arready),
	    .o_axi_arvalid(o_axi_arvalid),
	    .o_axi_awaddr(o_axi_awaddr),
	    .o_axi_awcache(o_axi_awcache),
	    .o_axi_awprot(o_axi_awprot),
	    .i_axi_awready(i_axi_awready),
	    .o_axi_awvalid(o_axi_awvalid),
	    .o_axi_bready(o_axi_bready),
	    .i_axi_bresp(i_axi_bresp),
	    .i_axi_bvalid(i_axi_bvalid),
	    .i_axi_rdata(i_axi_rdata),
	    .o_axi_rready(o_axi_rready),
	    .i_axi_rresp(i_axi_rresp),
	    .i_axi_rvalid(i_axi_rvalid),
	    .o_axi_wdata(o_axi_wdata),
	    .i_axi_wready(i_axi_wready),
	    .o_axi_wstrb(o_axi_wstrb),
	    .o_axi_wvalid(o_axi_wvalid)
    );

    always @(posedge i_clk)
    begin
        // Setup and Resets
        if (i_aresetn == 1'b0)
        begin
            r_core_state <= STATE_IDLE;
            r_remaining_bits_to_send <= 0;
            r_num_bits_sent <= 0;
            // Input Stream
            r_input_tdata <= 0;
            r_input_tkeep <= 0;
            r_input_tlast <= 0;
            r_remote_ip_rx <= 0;
            r_remote_port_rx <= 0;
            r_local_port_rx <= 0;
            // Input Data Conversion
            r_valid_input_tdata_reversed_little_endian <= 0;
            // Write to Debug Bridge
            r_dbw_input_valid <= 0;
            r_length <= 0;
            r_tms <= 0;
            r_tdi <= 0;
            r_tdo <= 0;
            r_tdo_keep <= 0;
            // Output Data Conversion and Stream
            r_output_tdata <= 0;
            r_output_tkeep <= 0;
            r_output_tlast <= 0;
            r_remote_ip_tx <= 0;
            r_remote_port_tx <= 0;
            r_local_port_tx <= 0;
        end
        else
        begin
            case (r_core_state)
                STATE_IDLE:
                // Read incoming packets and network information
                begin
                    if (w_fifo_tvalid == 1'b1)
                    begin
                        r_input_tdata <= w_fifo_metadata_tdata[INPUT_AXIS_DATA_WIDTH-1:0];
                        r_input_tkeep <= w_fifo_metadata_tkeep[(INPUT_AXIS_DATA_WIDTH-1)/8:0];
                        r_input_tlast <= w_fifo_tlast;
                        r_remote_ip_rx <= w_fifo_metadata_tdata[METADATA_WIDTH-33:METADATA_WIDTH-64];
                        r_remote_port_rx <= w_fifo_metadata_tdata[METADATA_WIDTH-17:METADATA_WIDTH-32];
                        r_local_port_rx <= w_fifo_metadata_tdata[METADATA_WIDTH-1:METADATA_WIDTH-16];
                        r_core_state <= STATE_AXI_STREAM_DATA_CONVERSION;
                    end
                    else
                    begin
                        r_input_tdata <= 0;
                        r_input_tkeep <= 0;
                        r_input_tlast <= 0;
                        r_remote_ip_rx <= 0;
                        r_remote_port_rx <= 0;
                        r_local_port_rx <= 0;
                        r_core_state <= STATE_IDLE;
                    end
                end
                STATE_AXI_STREAM_DATA_CONVERSION:
                // Convert the packet into a valid packet (only contains valid bits, shifted to start at entry 0)
                begin
                    r_valid_input_tdata_reversed_little_endian <= w_valid_input_tdata_reversed_little_endian;
                    if (r_remaining_bits_to_send == 0)
                    begin
                        r_core_state <= STATE_SETUP;
                    end
                    else
                    begin
                        r_core_state <= STATE_WRITE_TO_DEBUG_BRIDGE;
                    end
                end
                STATE_SETUP:
                begin
                    // In the first transfer, the total number of bits to send is sent in the least significant 32 bits
                    // Set number of bits to send, then go back to collect data
                    r_remaining_bits_to_send <= w_first_input_data_word;
                    r_num_bits_sent <= 0;
                    r_core_state <= STATE_IDLE;
                end
                STATE_WRITE_TO_DEBUG_BRIDGE:
                // Write DEBUG_BRIDGE_DATA_WIDTH worth of data to the debug bridge
                begin
                    if (r_dbw_input_valid == 1'b0)
                    begin
                        r_dbw_input_valid <= 1'b1;
                        if (r_remaining_bits_to_send < DEBUG_BRIDGE_DATA_WIDTH)
                        begin
                            r_length <= r_remaining_bits_to_send;
                            r_num_bits_sent <= r_num_bits_sent + r_remaining_bits_to_send;
                            r_remaining_bits_to_send <= 0;
                        end
                        else
                        begin
                            r_length <= DEBUG_BRIDGE_DATA_WIDTH;
                            r_num_bits_sent <= r_num_bits_sent + DEBUG_BRIDGE_DATA_WIDTH;
                            r_remaining_bits_to_send <= (r_remaining_bits_to_send - DEBUG_BRIDGE_DATA_WIDTH);
                        end
                        r_tms <= w_first_input_data_word_little_endian;
                        r_tdi <= w_second_input_data_word_little_endian;
                        r_core_state <= STATE_WRITE_TO_DEBUG_BRIDGE;
                    end
                    else
                    begin
                        if (w_dbw_input_ready == 1'b1)
                        begin
                            r_dbw_input_valid <= 1'b0;
                            r_core_state <= STATE_READ_TDO;
                        end
                        else
                        begin
                            r_dbw_input_valid <= r_dbw_input_valid;
                            r_core_state <= STATE_WRITE_TO_DEBUG_BRIDGE;
                        end
                        r_length <= r_length;
                        r_num_bits_sent <= r_num_bits_sent;
                        r_remaining_bits_to_send <= r_remaining_bits_to_send;
                        r_tms <= r_tms;
                        r_tdi <= r_tdi;
                    end
                end
                STATE_READ_TDO:
                begin
                    if (w_dbw_tdo_valid)
                    begin
                        r_tdo <= (r_tdo >> DEBUG_BRIDGE_DATA_WIDTH) | w_tdo_shifted;
                        if (r_length <= DEBUG_BRIDGE_DATA_WIDTH && r_length > 24)
                        begin
                            r_tdo_keep <= (r_tdo_keep >> (DEBUG_BRIDGE_DATA_WIDTH / 8)) | (4'b1111 << (DEBUG_BRIDGE_DATA_WIDTH / 8 * (TDO_CAPACITY - 1)));
                        end
                        else if (r_length <= 24 && r_length > 16)
                        begin
                            r_tdo_keep <= (r_tdo_keep >> (DEBUG_BRIDGE_DATA_WIDTH / 8)) | (4'b0111 << (DEBUG_BRIDGE_DATA_WIDTH / 8 * (TDO_CAPACITY - 1)));
                        end 
                        else if (r_length <= 16 && r_length > 8)
                        begin
                            r_tdo_keep <= (r_tdo_keep >> (DEBUG_BRIDGE_DATA_WIDTH / 8)) | (4'b0011 << (DEBUG_BRIDGE_DATA_WIDTH / 8 * (TDO_CAPACITY - 1)));
                        end
                        else if (r_length <= 8)
                        begin
                            r_tdo_keep <= (r_tdo_keep >> (DEBUG_BRIDGE_DATA_WIDTH / 8)) | (4'b0001 << (DEBUG_BRIDGE_DATA_WIDTH / 8 * (TDO_CAPACITY - 1)));
                        end
                        if (r_remaining_bits_to_send == 0 || r_num_bits_sent > NEAR_TDO_CAPACITY)
                        // Case 1: We've sent the last transfer or our TDO is too full to handle another transfer
                        begin
                            r_num_bits_sent <= r_num_bits_sent;
                            r_core_state <= STATE_TDO_REVERSAL;
                        end
                        else 
                        begin
                            if (r_num_bits_sent >= INPUT_AXIS_DATA_WIDTH)
                            // Case 2: We've sent our entire input vector and need another one
                            begin
                                r_num_bits_sent <= 0;
                                r_core_state <= STATE_IDLE;
                            end
                            else
                            // Case 3: Our input vector is not depleted yet, so we continue to use it to send transfers
                            begin
                                r_num_bits_sent <= r_num_bits_sent;
                                r_core_state <= STATE_WRITE_TO_DEBUG_BRIDGE;
                            end
                        end
                    end
                    else
                    begin
                        r_tdo <= r_tdo;
                        r_tdo_keep <= r_tdo_keep;
                        r_num_bits_sent <= r_num_bits_sent;
                        r_core_state <= STATE_READ_TDO;
                    end
                end
                STATE_TDO_REVERSAL:
                // Data Conversion Part 1: Reverse the TDO and TDO Keep
                begin
                    r_tdo <= w_r_tdo_reversed;
                    r_tdo_keep <= w_r_tdo_keep_reversed;
                    r_core_state <= STATE_TDO_SHIFT_TO_MSB;
                end
                STATE_TDO_SHIFT_TO_MSB:
                // Data Conversion Part 2: Convert TDO into UDP form by shifting it left until MSB is filled
                begin
                    if (r_tdo_keep[(OUTPUT_AXIS_DATA_WIDTH-1)/8] == 1)
                    begin
                        r_output_tdata <= r_tdo;
                        r_output_tkeep <= r_tdo_keep;
                        r_remote_ip_tx <= r_remote_ip_rx;
                        r_remote_port_tx <= r_remote_port_rx;
                        r_local_port_tx <= r_local_port_rx;
                        r_tdo <= 0;
                        r_tdo_keep <= 0;
                        if (r_remaining_bits_to_send == 0)
                        begin
                            r_output_tlast <= 1'b1;
                        end
                        else
                        begin
                            r_output_tlast <= 1'b0;
                        end
                        r_core_state <= STATE_SEND_TDO;
                    end
                    else
                    begin
                        r_output_tdata <= 0;
                        r_output_tkeep <= 0;
                        r_output_tlast <= 0;
                        r_remote_ip_tx <= 0;
                        r_remote_port_tx <= 0;
                        r_local_port_tx <= 0;
                        r_tdo <= (r_tdo << 8);
                        r_tdo_keep <= (r_tdo_keep << 1);
                        r_core_state <= STATE_TDO_SHIFT_TO_MSB;
                    end
                end
                STATE_SEND_TDO:
                // Transmit output data and network information
                begin
                    if (i_output_TREADY == 1'b1)
                    begin
                        r_length <= 0;
                        r_tms <= 0;
                        r_tdi <= 0;
                        r_output_tdata <= 0;
                        r_output_tkeep <= 0;
                        r_output_tlast <= 0;
                        r_remote_ip_tx <= 0;
                        r_remote_port_tx <= 0;
                        r_local_port_tx <= 0;
                        if (r_remaining_bits_to_send == 0 || r_num_bits_sent >= INPUT_AXIS_DATA_WIDTH)
                        // Case 1: Finished sending all data, Case 2: Not finished but require a new input vector
                        begin
                            r_num_bits_sent <= 0;
                            r_core_state <= STATE_IDLE;
                        end
                        else
                        // Case 3: Input vector still has relevant data
                        begin
                            r_num_bits_sent <= r_num_bits_sent;
                            r_core_state <= STATE_WRITE_TO_DEBUG_BRIDGE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
