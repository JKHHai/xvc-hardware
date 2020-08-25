`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2020 06:11:36 PM
// Design Name: 
// Module Name: test_hardware_server
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


module test_hardware_server
    #(
        parameter INPUT_DATA_WIDTH = 512, // Width of input data bus in bits
        parameter OUTPUT_DATA_WIDTH = 512 // Width of output data bus in bits
    )
    (
        input i_clk,
        input i_aresetn,
        // Input Stream
        input i_input_TVALID,
        output o_input_TREADY,
        input [INPUT_DATA_WIDTH-1:0] i_input_TDATA,
        input [(INPUT_DATA_WIDTH-1)/8:0] i_input_TKEEP,
        input i_input_TLAST,
        // Input network information
        input [31:0] i_remote_ip_rx,
        input [15:0] i_remote_port_rx,
        input [15:0] i_local_port_rx,
        // Output Stream
        output o_output_TVALID,
        input i_output_TREADY,
        output [OUTPUT_DATA_WIDTH-1:0] o_output_TDATA,
        output [(OUTPUT_DATA_WIDTH-1)/8:0] o_output_TKEEP,
        output o_output_TLAST,
        // Output network information
        output [31:0] o_remote_ip_tx,
        output [15:0] o_remote_port_tx,
        output [15:0] o_local_port_tx
    );

    // Declarations
    localparam STATE_IDLE = 3'd0; // Core is waiting for inputs
    localparam STATE_INPUT_DATA_CONVERSION = 3'd1; // Data has been received and is being converted (removal of invalid bits, shifting to start at LSB)    
    localparam STATE_COMPUTATION = 3'd2; // Output data is being computed
    localparam STATE_OUTPUT_DATA_CONVERSION = 3'd3; // Output data is being converted for transmission
    localparam STATE_OUTPUT_DATA_TRANSMISSION = 3'd4; // Output data is being transmitted
    reg [2:0] r_core_state;
    // Registers - Input Stream
    reg r_input_tready;
    reg [INPUT_DATA_WIDTH-1:0] r_input_tdata;
    reg [(INPUT_DATA_WIDTH-1)/8:0] r_input_tkeep;
    reg r_input_tlast;
    // Input Stream Network Information
    reg [31:0] r_remote_ip_rx;
    reg [15:0] r_remote_port_rx;
    reg [15:0] r_local_port_rx;
    // Registers - Input Data Conversion
    reg [INPUT_DATA_WIDTH-1:0] r_valid_input_tdata;
    reg [(INPUT_DATA_WIDTH-1)/8:0] r_valid_input_tkeep;
    // Registers - Data Computation
    reg [INPUT_DATA_WIDTH-1:0] r_computed_tdata;
    reg [(INPUT_DATA_WIDTH-1)/8:0] r_computed_tkeep;
    // Registers - Output Data Conversion and Stream
    reg r_output_tvalid;
    reg [OUTPUT_DATA_WIDTH-1:0] r_output_tdata;
    reg [(OUTPUT_DATA_WIDTH-1)/8:0] r_output_tkeep;
    reg r_output_tlast;
    // Output Stream Network Information
    reg [31:0] r_remote_ip_tx;
    reg [15:0] r_remote_port_tx;
    reg [15:0] r_local_port_tx;
    // Wires - Output Data Conversion and Stream
    wire [OUTPUT_DATA_WIDTH-1:0] w_computed_tdata_byte_shifted;
    wire [(OUTPUT_DATA_WIDTH-1)/8:0] w_computed_tkeep_bit_shifted;

    // Assignments
    assign w_computed_tdata_byte_shifted = r_computed_tdata[7:0] << (OUTPUT_DATA_WIDTH - 8);
    assign w_computed_tkeep_bit_shifted = 1'b1 << ((OUTPUT_DATA_WIDTH - 1) / 8);
    assign o_input_TREADY = r_input_tready;
    assign o_output_TVALID = r_output_tvalid;
    assign o_output_TDATA = r_output_tdata;
    assign o_output_TKEEP = r_output_tkeep;
    assign o_output_TLAST = r_output_tlast;
    assign o_remote_ip_tx = r_remote_ip_tx;
    assign o_remote_port_tx = r_remote_port_tx;
    assign o_local_port_tx = r_local_port_tx;

    always @(posedge i_clk)
    begin
        // Setup and Resets
        if (i_aresetn == 1'b0)
        begin
            r_core_state <= STATE_IDLE;
            // Input Stream
            r_input_tready <= 1'b0;
            r_input_tdata <= 0;
            r_input_tkeep <= 0;
            r_input_tlast <= 0;
            r_remote_ip_rx <= 0;
            r_remote_port_rx <= 0;
            r_local_port_rx <= 0;
            // Input Data Conversion
            r_valid_input_tdata <= 0;
            r_valid_input_tkeep <= 0;
            // Data Computation
            r_computed_tdata <= 0;
            r_computed_tkeep <= 0;
            // Output Data Conversion and Stream
            r_output_tvalid <= 1'b0;
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
                    if (i_input_TVALID == 1'b1)
                    begin
                        if (r_input_tready == 1'b1)
                        begin
                            r_input_tready <= 1'b0;
                            r_input_tdata <= i_input_TDATA;
                            r_input_tkeep <= i_input_TKEEP;
                            r_input_tlast <= i_input_TLAST;
                            r_remote_ip_rx <= i_remote_ip_rx;
                            r_remote_port_rx <= i_remote_port_rx;
                            r_local_port_rx <= i_local_port_rx;
                            r_core_state <= STATE_INPUT_DATA_CONVERSION;
                        end
                        else
                        begin
                            r_input_tready <= 1'b1;
                        end
                    end
                end
                STATE_INPUT_DATA_CONVERSION:
                // Convert the packet into a valid packet (only contains valid bits, shifted to start at entry 0)
                begin
                    // Conversion will be finished once there are no valid keep bits left
                    if (r_input_tkeep == 0)
                    begin
                        r_core_state <= STATE_COMPUTATION;
                    end
                    else
                    begin
                        if (r_input_tkeep[(INPUT_DATA_WIDTH-1)/8] == 1)
                        begin
                            r_valid_input_tdata <= (r_valid_input_tdata << 8) | r_input_tdata[INPUT_DATA_WIDTH-1:INPUT_DATA_WIDTH-8];
                            r_valid_input_tkeep <= (r_valid_input_tkeep << 1) | 1;
                        end
                        r_input_tdata <= (r_input_tdata << 8); 
                        r_input_tkeep <= (r_input_tkeep << 1);
                    end
                end
                STATE_COMPUTATION:
                // Compute the output data and clear the previous data
                begin
                    r_computed_tdata <= (r_valid_input_tdata << 1);
                    r_computed_tkeep <= (r_valid_input_tkeep << 1) + 1;
                    r_output_tlast <= r_input_tlast;
                    r_valid_input_tdata <= 0;
                    r_valid_input_tkeep <= 0;
                    r_core_state <= STATE_OUTPUT_DATA_CONVERSION;
                end
                STATE_OUTPUT_DATA_CONVERSION:
                // Convert output data back into UDP form
                begin
                    if (r_computed_tkeep == 0)
                    begin
                        r_computed_tdata <= 0;
                        r_core_state <= STATE_OUTPUT_DATA_TRANSMISSION;
                    end
                    else
                    begin
                        if (r_computed_tkeep[0] == 1'b1)
                        begin
                            r_output_tdata <= (r_output_tdata >> 8) | w_computed_tdata_byte_shifted;
                            r_output_tkeep <= (r_output_tkeep >> 1) | w_computed_tkeep_bit_shifted;
                        end
                        r_computed_tdata <= (r_computed_tdata >> 8);
                        r_computed_tkeep <= (r_computed_tkeep >> 1);
                    end
                end
                STATE_OUTPUT_DATA_TRANSMISSION:
                // Transmit output data and network information
                begin
                    if (r_output_tvalid == 1'b0)
                    begin
                        r_remote_ip_tx <= r_remote_ip_rx;
                        r_remote_port_tx <= r_remote_port_rx;
                        r_local_port_tx <= r_local_port_rx;
                        r_output_tvalid <= 1'b1;
                    end
                    else if (r_output_tvalid == 1'b1 && i_output_TREADY == 1'b1)
                    begin
                        r_output_tvalid <= 1'b0;
                        r_output_tdata <= 0;
                        r_output_tkeep <= 0;
                        r_output_tlast <= 0;
                        r_core_state <= STATE_IDLE;
                    end
                end
            endcase
        end
    end
endmodule
