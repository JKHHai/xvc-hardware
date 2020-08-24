`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2020 08:50:30 PM
// Design Name: 
// Module Name: tb_test_hardware_server
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


module tb_test_hardware_server();
    // Declarations
    parameter input_data_width = 512;
    parameter output_data_width = 512;
    reg r_clock, r_reset;
    wire w_clock, w_reset;
    // Declarations - Input Stream
    reg r_input_tvalid;
    reg [input_data_width-1:0] r_input_tdata;
    reg [(input_data_width-1)/8:0] r_input_tkeep;
    reg r_input_tlast;
    wire w_input_tvalid;
    wire w_input_tready;
    wire [input_data_width-1:0] w_input_tdata;
    wire [(input_data_width-1)/8:0] w_input_tkeep;
    wire w_input_tlast;
    // Declarations - Output Stream
    reg r_output_tready;
    reg [output_data_width-1:0] r_output_tdata;
    reg [(output_data_width-1)/8:0] r_output_tkeep;
    reg r_output_tlast;
    wire w_output_tvalid;
    wire w_output_tready;
    wire [output_data_width-1:0] w_output_tdata;
    wire [(output_data_width-1)/8:0] w_output_tkeep;
    wire w_output_tlast;

    // Assignments
    assign w_clock = r_clock;
    assign w_reset = r_reset;
    assign w_input_tvalid = r_input_tvalid;
    assign w_input_tdata = r_input_tdata;
    assign w_input_tkeep = r_input_tkeep;
    assign w_input_tlast = r_input_tlast;
    assign w_output_tready = r_output_tready;

    test_hardware_server #(
        .INPUT_DATA_WIDTH(input_data_width),
        .OUTPUT_DATA_WIDTH(output_data_width)
    )
    DUT
    (
        .i_clk(w_clock),
        .i_aresetn(w_reset),
        .i_input_TVALID(w_input_tvalid),
        .o_input_TREADY(w_input_tready),
        .i_input_TDATA(w_input_tdata),
        .i_input_TKEEP(w_input_tkeep),
        .i_input_TLAST(w_input_tlast),
        .o_output_TVALID(w_output_tvalid),
        .i_output_TREADY(w_output_tready),
        .o_output_TDATA(w_output_tdata),
        .o_output_TKEEP(w_output_tkeep),
        .o_output_TLAST(w_output_tlast)
    );

    // Reset Signal
    initial begin
        r_reset = 0;
        #40 r_reset = 1;
    end

    // Clock Signal
    initial r_clock = 0;
    always begin
        #2 r_clock = ~r_clock;
    end

    // Testbench
    initial begin
        r_input_tvalid = 0;
        r_input_tdata = 0;
        r_input_tkeep = 0;
        r_input_tlast = 0;
        r_output_tready = 0;
        r_output_tdata = 0;
        r_output_tkeep = 0;
        r_output_tlast = 0;

        #60 r_input_tdata = 'h020000000000000000000000000000000000863787d9000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        r_input_tkeep = 'h8000000000000000;
        r_input_tlast = 1;
        r_input_tvalid = 1; 
        
        #60 r_input_tdata = 'h040000000000000000000000000000000000863787d9000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        r_input_tkeep = 'h8000000000000000;
        r_input_tlast = 1;
        r_input_tvalid = 1;   
        
        #3000 $finish;      
    end

    // Lower input valid signal when ready signal is detected
    always @(posedge r_clock)
    begin
        if (r_input_tvalid == 1'b1 && w_input_tready == 1'b1)
        begin
            r_input_tvalid <= 1'b0;
        end
    end

    // Read the output when it flashes a valid signal
    always @(posedge r_clock)
    begin
        if (w_output_tvalid == 1'b1)
        begin
            r_output_tready <= 1'b1;
        end
    end

    always @(posedge r_clock)
    begin
        if (w_output_tvalid == 1'b1 && r_output_tready == 1'b1)
        begin
            r_output_tready <= 1'b0;
            r_output_tdata <= w_output_tdata;
            r_output_tkeep <= w_output_tkeep;
            r_output_tlast <= w_output_tlast;
            $display("output TDATA: 0x%h", w_output_tdata);
            $display("output TKEEP: 0x%h", w_output_tkeep);
            $display("output TLAST: 0x%h", w_output_tlast);
            if (w_output_tdata == 2 * r_input_tdata)
            begin
                $display("TEST PASSED");
            end   
            else
            begin
                $display("TEST FAILED");
            end
        end
    end
endmodule
