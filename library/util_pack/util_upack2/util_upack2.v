// ***************************************************************************
// ***************************************************************************
// Copyright 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_upack2 #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLES_PER_CHANNEL = 1,
  parameter SAMPLE_DATA_WIDTH = 16
) (
  input clk,
  input reset,

  input enable_0,
  input enable_1,
  input enable_2,
  input enable_3,
  input enable_4,
  input enable_5,
  input enable_6,
  input enable_7,
  input enable_8,
  input enable_9,
  input enable_10,
  input enable_11,
  input enable_12,
  input enable_13,
  input enable_14,
  input enable_15,

  input fifo_rd_en,
  output fifo_rd_valid,
  output fifo_rd_underflow,

  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_0,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_1,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_2,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_3,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_4,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_5,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_6,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_7,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_8,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_9,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_10,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_11,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_12,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_13,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_14,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_15,

  input s_axis_valid,
  output s_axis_ready,
  input [2**$clog2(NUM_OF_CHANNELS)*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] s_axis_data
);

localparam CHANNEL_DATA_WIDTH = SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL;
/*
 * Round up to the next power of two and zero out the additional channels
 * internally.
 */
localparam REAL_NUM_OF_CHANNELS = NUM_OF_CHANNELS > 8 ? 16 :
   NUM_OF_CHANNELS > 4 ? 8 :
   NUM_OF_CHANNELS > 2 ? 4 :
   NUM_OF_CHANNELS > 1 ? 2 : 1;

/* FIXME: Find out how to do this in the IP-XACT */

wire [15:0] enable_s;
wire [CHANNEL_DATA_WIDTH*REAL_NUM_OF_CHANNELS-1:0] fifo_rd_data;
wire [CHANNEL_DATA_WIDTH*16-1:0] fifo_rd_data_s;

util_upack2_impl #(
  .NUM_OF_CHANNELS(REAL_NUM_OF_CHANNELS),
  .SAMPLE_DATA_WIDTH(SAMPLE_DATA_WIDTH),
  .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL)
) i_upack (
  .clk (clk),
  .reset (reset),

  .enable (enable_s[REAL_NUM_OF_CHANNELS-1:0]),

  .fifo_rd_en ({REAL_NUM_OF_CHANNELS{fifo_rd_en}}),
  .fifo_rd_valid (fifo_rd_valid),
  .fifo_rd_underflow (fifo_rd_underflow),
  .fifo_rd_data (fifo_rd_data),

  .s_axis_valid (s_axis_valid),
  .s_axis_ready (s_axis_ready),
  .s_axis_data (s_axis_data)
);

assign enable_s = {
  enable_15,enable_14,enable_13,enable_12,enable_11,enable_10,enable_9,enable_8,
  enable_7,enable_6,enable_5,enable_4,enable_3,enable_2,enable_1,enable_0
};

assign fifo_rd_data_s = {{(16-NUM_OF_CHANNELS)*CHANNEL_DATA_WIDTH{1'b0}},fifo_rd_data};

assign fifo_rd_data_0 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*0+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_1 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*1+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_2 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*2+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_3 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*3+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_4 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*4+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_5 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*5+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_6 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*6+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_7 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*7+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_8 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*8+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_9 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*9+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_10 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*10+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_11 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*11+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_12 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*12+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_13 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*13+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_14 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*14+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_15 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*15+:CHANNEL_DATA_WIDTH];

endmodule
