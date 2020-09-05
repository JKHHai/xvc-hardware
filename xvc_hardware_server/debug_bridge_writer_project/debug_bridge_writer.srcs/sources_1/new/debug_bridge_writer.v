`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2020 06:01:21 PM
// Design Name: 
// Module Name: debug_bridge_writer
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

module debug_bridge_writer
    #(
        parameter DEBUG_BRIDGE_DATA_WIDTH = 32, // Width of the debug bridge's AXI-Lite data bus in bits
        parameter DEBUG_BRIDGE_ADDRESS_WIDTH = 8 // Width of the debug bridge's AXI-Lite address bus in bits
    )
    (
        input i_clk,
        input i_aresetn,
        // Input data and address
        input i_input_valid,
        output o_input_ready,
        input [DEBUG_BRIDGE_DATA_WIDTH-1:0] i_length,
        input [DEBUG_BRIDGE_DATA_WIDTH-1:0] i_tms,
        input [DEBUG_BRIDGE_DATA_WIDTH-1:0] i_tdi,
        // Output TDO
        output o_tdo_valid,
        input i_tdo_ready,
        output [DEBUG_BRIDGE_DATA_WIDTH-1:0] o_tdo_data,
        // AXI-Lite interface
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
    localparam STATE_IDLE = 4'd0;
    localparam STATE_AXI_LITE_WRITE = 4'd1;
    localparam STATE_AXI_LITE_READ = 4'd2;
    localparam STATE_WRITE_LENGTH = 4'd3;
    localparam STATE_WRITE_TMS = 4'd4;
    localparam STATE_WRITE_TDI = 4'd5;
    localparam STATE_WRITE_CTRL = 4'd6;
    localparam STATE_READ_CTRL = 4'd7;
    localparam STATE_READ_TDO = 4'd8;
    localparam STATE_SEND_TDO = 4'd9;
    // Parameters - AXI-Lite
    localparam AXI_LITE_OPCODE_DO_NOTHING = 2'd0;
    localparam AXI_LITE_OPCODE_WRITE = 2'd1;
    localparam AXI_LITE_OPCODE_READ = 2'd2;
    localparam AXI_LITE_ADDR_OFFSET_LENGTH = 8'h00;
    localparam AXI_LITE_ADDR_OFFSET_TMS = 8'h04;
    localparam AXI_LITE_ADDR_OFFSET_TDI = 8'h08;
    localparam AXI_LITE_ADDR_OFFSET_TDO = 8'h0C;
    localparam AXI_LITE_ADDR_OFFSET_CTRL = 8'h10;
    reg [3:0] r_core_state;
    wire w_aresetp;
    // Registers - Input
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_length;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_tms;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_tdi;
    // Registers - AXI-Lite Write
    reg [DEBUG_BRIDGE_ADDRESS_WIDTH-1:0] r_axi_lite_addr;
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_axi_lite_wdata;
    reg [1:0] r_axi_lite_opcode; // Tells the interface what to do
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_axi_lite_rdata;
    reg r_axi_lite_read_complete; // High if the read was successful
    // Wires - AXI-Lite Write
    wire [DEBUG_BRIDGE_ADDRESS_WIDTH-1:0] w_axi_lite_addr;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_axi_lite_wdata;
    wire [1:0] w_axi_lite_opcode;
    wire [DEBUG_BRIDGE_DATA_WIDTH-1:0] w_axi_lite_rdata;
    wire w_axi_lite_rvalid;
    wire w_axi_lite_wdone;
    wire w_axi_lite_rd_err;
    wire w_axi_lite_wr_err;
    wire w_axi_lite_busy;
    // Registers - Output
    reg [DEBUG_BRIDGE_DATA_WIDTH-1:0] r_tdo_data;

    // Assignments
    assign w_aresetp = ~i_aresetn;
    assign o_input_ready = r_core_state == STATE_IDLE ? 1'b1 : 1'b0;
    assign o_tdo_valid = r_core_state == STATE_SEND_TDO ? 1'b1 : 1'b0;
    assign o_tdo_data = r_tdo_data;
    // AXI-Lite Write
    assign w_axi_lite_addr = r_axi_lite_addr;
    assign w_axi_lite_wdata = r_axi_lite_wdata;
    assign w_axi_lite_opcode = r_axi_lite_opcode;
    assign w_axi_lite_rdata = r_axi_lite_rdata;

    // Modules
    easy_axilite_master #(
        .ADDR_LEN(DEBUG_BRIDGE_ADDRESS_WIDTH),
        .DATA_LEN(DEBUG_BRIDGE_DATA_WIDTH)
    )
    debug_bridge_interface
    (
        .clk(i_clk),
        .rst(w_aresetp),
    	.addr(w_axi_lite_addr),
    	.wdata(w_axi_lite_wdata),
    	.opcode(w_axi_lite_opcode),
    	.rdata(w_axi_lite_rdata),
    	.rvalid(w_axi_lite_rvalid),
    	.wdone(w_axi_lite_wdone),
    	.rd_err(w_axi_lite_rd_err),
    	.wr_err(w_axi_lite_wr_err),
    	.busy(w_axi_lite_busy),
    	.m_axi_araddr(o_axi_araddr),
    	.m_axi_arcache(o_axi_arcache),
    	.m_axi_arprot(o_axi_arprot),
    	.m_axi_arready(i_axi_arready),
    	.m_axi_arvalid(o_axi_arvalid),
    	.m_axi_awaddr(o_axi_awaddr),
    	.m_axi_awcache(o_axi_awcache),
    	.m_axi_awprot(o_axi_awprot),
    	.m_axi_awready(i_axi_awready),
    	.m_axi_awvalid(o_axi_awvalid),
    	.m_axi_bready(o_axi_bready),
    	.m_axi_bresp(i_axi_bresp),
    	.m_axi_bvalid(i_axi_bvalid),
    	.m_axi_rdata(i_axi_rdata),
    	.m_axi_rready(o_axi_rready),
    	.m_axi_rresp(i_axi_rresp),
    	.m_axi_rvalid(i_axi_rvalid),
    	.m_axi_wdata(o_axi_wdata),
    	.m_axi_wready(i_axi_wready),
    	.m_axi_wstrb(o_axi_wstrb),
    	.m_axi_wvalid(o_axi_wvalid)
    );

    always @(posedge i_clk)
    begin
        // Resets and Initial Setup
        if (i_aresetn == 1'b0)
        begin
            r_core_state <= STATE_IDLE;
            // Input
            r_length <= 0;
            r_tms <= 0;
            r_tdi <= 0;
            // AXI-Lite
            r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_LENGTH;
            r_axi_lite_wdata <= 0;
            r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
            r_axi_lite_rdata <= 0;
            r_axi_lite_read_complete <= 1'b0;
            // Output
            r_tdo_data <= 0;
        end
        else
        begin
            case (r_core_state)
            STATE_IDLE:
            begin
                if (i_input_valid == 1'b1)
                begin
                    r_length <= i_length;
                    r_tms <= i_tms;
                    r_tdi <= i_tdi;
                    r_core_state <= STATE_WRITE_LENGTH;
                end
                else
                begin
                    r_length <= 0;
                    r_tms <= 0;
                    r_tdi <= 0;
                    r_core_state <= STATE_IDLE;
                end
            end
            STATE_AXI_LITE_WRITE:
            begin
                if (w_axi_lite_wdone == 1'b1)
                begin
                    r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
                    r_axi_lite_wdata <= 0;
                    case (r_axi_lite_addr)
                        // Pick next state based on where data was last written to
                        AXI_LITE_ADDR_OFFSET_LENGTH: r_core_state <= STATE_WRITE_TMS;
                        AXI_LITE_ADDR_OFFSET_TMS: r_core_state <= STATE_WRITE_TDI;
                        AXI_LITE_ADDR_OFFSET_TDI: r_core_state <= STATE_WRITE_CTRL;
                        AXI_LITE_ADDR_OFFSET_CTRL: r_core_state <= STATE_READ_CTRL;
                    endcase
                end
                else
                begin
                    if (w_axi_lite_busy == 1'b1)
                    begin
                        r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
                    end
                    else
                    begin
                        r_axi_lite_opcode <= AXI_LITE_OPCODE_WRITE;
                    end
                    r_axi_lite_wdata <= r_axi_lite_wdata;
                    r_core_state <= STATE_AXI_LITE_WRITE;
                end
            end
            STATE_AXI_LITE_READ:
            begin
                if (w_axi_lite_rvalid == 1'b1)
                begin
                    r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
                    r_axi_lite_rdata <= w_axi_lite_rdata;
                    r_axi_lite_read_complete <= 1'b1;
                    case (r_axi_lite_addr)
                        // Pick next state based on where data was last written to
                        AXI_LITE_ADDR_OFFSET_CTRL: r_core_state <= STATE_READ_CTRL;
                        AXI_LITE_ADDR_OFFSET_TDO: r_core_state <= STATE_READ_TDO;
                    endcase
                end
                else
                begin
                    if (w_axi_lite_busy == 1'b1)
                    begin
                        r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
                    end
                    else
                    begin
                        r_axi_lite_opcode <= AXI_LITE_OPCODE_READ;
                    end
                    r_axi_lite_rdata <= 0;
                    r_axi_lite_read_complete <= 1'b0;
                    r_core_state <= STATE_AXI_LITE_READ;
                end
            end
            STATE_WRITE_LENGTH:
            begin
                r_axi_lite_opcode <= AXI_LITE_OPCODE_WRITE;
                r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_LENGTH;
                r_axi_lite_wdata <= r_length;
                r_core_state <= STATE_AXI_LITE_WRITE;
            end
            STATE_WRITE_TMS:
            begin
                r_axi_lite_opcode <= AXI_LITE_OPCODE_WRITE;
                r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_TMS;
                r_axi_lite_wdata <= r_tms;
                r_core_state <= STATE_AXI_LITE_WRITE;
            end
            STATE_WRITE_TDI:
            begin
                r_axi_lite_opcode <= AXI_LITE_OPCODE_WRITE;
                r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_TDI;
                r_axi_lite_wdata <= r_tdi;
                r_core_state <= STATE_AXI_LITE_WRITE;
            end
            STATE_WRITE_CTRL:
            begin
                r_axi_lite_opcode <= AXI_LITE_OPCODE_WRITE;
                r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_CTRL;
                r_axi_lite_wdata <= 1;
                r_core_state <= STATE_AXI_LITE_WRITE;
            end
            STATE_READ_CTRL:
            begin
                if (r_axi_lite_read_complete == 1'b1 && r_axi_lite_rdata == 0)
                begin
                    r_axi_lite_opcode <= r_axi_lite_opcode;
                    r_axi_lite_addr <= 0;
                    r_axi_lite_rdata <= 0;
                    r_core_state <= STATE_READ_TDO;
                end
                else
                begin
                    r_axi_lite_opcode <= AXI_LITE_OPCODE_READ;
                    r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_CTRL;
                    r_axi_lite_rdata <= 0;
                    r_core_state <= STATE_AXI_LITE_READ; 
                end
                r_axi_lite_read_complete <= 1'b0;                 
            end
            STATE_READ_TDO:
            begin
                if (r_axi_lite_read_complete == 1'b1)
                begin
                    r_axi_lite_opcode <= AXI_LITE_OPCODE_DO_NOTHING;
                    r_axi_lite_addr <= 0;
                    r_tdo_data <= r_axi_lite_rdata;
                    r_core_state <= STATE_SEND_TDO;
                end
                else
                begin
                    r_axi_lite_opcode <= AXI_LITE_OPCODE_READ;
                    r_axi_lite_addr <= AXI_LITE_ADDR_OFFSET_TDO;
                    r_tdo_data <= 0;
                    r_core_state <= STATE_AXI_LITE_READ;    
                end
                r_axi_lite_rdata <= 0;
                r_axi_lite_read_complete <= 1'b0;                 
            end
            STATE_SEND_TDO:
            begin
                if (i_tdo_ready == 1'b1)
                begin
                    r_tdo_data <= 0;
                    r_core_state <= STATE_IDLE;
                end
                else
                begin
                    r_tdo_data <= r_tdo_data;
                    r_core_state <= STATE_SEND_TDO;
                end
            end
            endcase
        end
    end
endmodule
