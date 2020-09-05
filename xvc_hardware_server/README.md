# Overview
This directory contains the xvc hardware server. This consists of two main parts:
1. debug_bridge_writer: Module that handles writing xvc data to the debug bridge.
2. xvc_hardware_server: Module that receives xvc data from GULF-Stream, formats it, then writes it to the debug bridge using the debug_bridge_writer.

# Project Status
- debug_bridge_writer and xvc_hardware_server have been written, but are untested.

# debug_bridge_writer
## Overview
Writes to debug bridge registers in the appropriate format.
## Parameters:
- DEBUG_BRIDGE_DATA_WIDTH: Width (in bits) of the AXI-Lite data channel connected to the debug bridge.
- DEBUG_BRIDGE_ADDRESS_WIDTH: Width (in bits) of the AXI-Lite read and write address channels connected to the debug bridge.
## Function
This module performs the following programming sequence.
1. STATE_IDLE: When *i_input_valid* is high, read length, tms and tdi vectors from the xvc hardware server. Commence writing.
2. STATE_WRITE_LENGTH: Write length to offset 0x0.
3. STATE_WRITE_TMS: Write TMS to offset 0x4.
4. STATE_WRITE_TDI: Write TDI to offset 0x8.
5. STATE_WRITE_CTRL: Write 1 to offset 0x10.
6. STATE_READ_CTRL: Read from offset 0x10 until it becomes 0.
7. STATE_READ_TDO: Read TDO from offset 0x0C.
8. STATE_SEND_TDO: Write TDO to *o_tdo_data*, then set *o_tdo_valid* to 1.

All write states use STATE_AXI_LITE_WRITE to perform the write, and all read states use STATE_AXI_LITE_READ to perform the read. AXI-Lite reads and writes are performed using an easy_axilite_master module.

# xvc_hardware_server:
## Overview
Reads xvc instructions from GULF-Stream via AXI-Stream, then separates them and writes them word-by-word to the debug bridge. Accumulates TDO returns from the debug bridge and sends them back to GULF-Stream via AXI-Stream.
## Parameters
- INPUT_AXIS_DATA_WIDTH: Width (in bits) of input AXI-Stream connection.
- OUTPUT_AXIS_DATA_WIDTH: Width (in bits) of output AXI-Stream connection.
- DEBUG_BRIDGE_DATA_WIDTH: Width (in bits) of debug bridge AXI-Lite data connection. Set to 32 bits.
- DEBUG_BRIDGE_ACCESS_WIDTH: Width (in bits) of debug bridge AXI-Lite address connections. Set to 8 bits.
## Function
1. STATE_IDLE: Core reads AXI-Stream data from an AXI-Stream FIFO. Network information (ports, ip address) are saved for output. AXI-Stream data is passed on for conversion. Data will arrive in TMS0.TDI0.TMS1.TDI1....000000 format from GULF-Stream (big endian, MSB first).
2. STATE_AXI_STREAM_DATA_CONVERSION: AXI-Stream data is masked with a keep mask to eliminate invalid bits, then reversed. This converts the data into Little Endian format and moves TMS0 from the MSB (GULF-Stream sends entry 0 starting at the MSB) to the LSB.
3. STATE_SETUP: If this is the first transfer, it contains information regarding the length of the packet to be written to the debug bridge. This is saved (converted to Big Endian before saving), then the core returns to IDLE to collect the next AXI-Stream transfer, which contains data.
4. STATE_WRITE_TO_DEBUG_BRIDGE: Once data containing TMS and TDI values is received and converted, the TMS and TDI data are written to the debug bridge 32 bits at a time. The number of bits remaining is decremented. If the number of bits left to write is less than 32, only that number of bits is written.
5. STATE_READ_TDO: After writing data, the core waits for a TDO to be returned. The TDO is then added to the output TDO vector. If the core is finished, or the TDO is full, the TDO is sent out. Otherwise, if the input AXI-Stream vector's data has been completely sent, a new vector is fetched from the FIFO. Otherwise, the core writes the next 32 bit's worth of data to the debug bridge.
6. STATE_TDO_REVERSAL/STATE_TDO_SHIFT_TO_MSB: TDO is formatted for output (converted to big endian, shifted all the way to the left so that MSB is occupied).
7. STATE_SEND_TDO: TDO is sent out. If the core is finished, the core idles. Otherwise, if the input AXI-Stream vector's data has been completely sent, a new vector is fetched from the FIFO. Otherwise, the core writes the next 32 bit's worth of data to the debug bridge.

# Editing the files.
The repository is currently disorganized. Here are the links to the Verilog files used by each of the cores:  
**debug_bridge_writer:**
- [debug_bridge_writer.v](https://github.com/JKHHai/xvc-hardware/blob/master/xvc_hardware_server/debug_bridge_writer_project/debug_bridge_writer.srcs/sources_1/new/debug_bridge_writer.v)
- [easy_axilite_master.v](https://github.com/JKHHai/xvc-hardware/blob/master/xvc_hardware_server/debug_bridge_writer_project/imports/easy_axilite_master.v)

**xvc_hardware_server:**
- [xvc_hardware_server.v](https://github.com/JKHHai/xvc-hardware/blob/master/xvc_hardware_server/xvc_hardware_server_project/xvc_hardware_server.srcs/sources_1/new/xvc_hardware_server.v)

