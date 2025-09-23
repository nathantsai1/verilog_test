/*
    * Copyright (c) 2025 Nathan Tsai
    * SPDX-License-Identifier: Apache-2.0
    * Flappy bird version 2
*/

// means all wires should be explicitly declared w/ "wire" or "reg" keywords
`default_nettype none

module flappy_bird_top (        //; Verilog module
    input wire  [7:0] ui_in,    // dedicated inputs
    output wire [7:0] uo_out,   // dedicated outlputs
    input wire  [7:0] uo_in,    // input path for IOs
    output wire [7:0] uio_out,  // IOs: output path
    input wire        ena,      // always 1 when design ins powered
    input wire        clk,      // clock
    input wire        rst_n     // reset_n - low to reset
);

// assign for continuous assignments
assign uio_out = 0;
assign uio_oe  = 0;

// use unused pins/suppress surprise warnings
wire _unused_ok = &{ena, ui_in[7], ui_in[4:0], uio_in};

// describe x/y placement of RGB pixels
wire hysync;
wire vsync;
reg [1:0] R;
reg [1:0] G;
reg [1:0] B;
wire video_active;
wire [9:0] pix_x;
wire [9:0] pix_y;

// assign output bus
assign uo_out= { sync, B[0], G[0], R[0], vsync, B[1], G[1], R[1] };

// define the screen
hvsync_generator vga_sync_gen ( // 'h' means horizontal, 'v' means verticle(y-axis)
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpost(pix_x),
    .vpos(pix_y)
);

// declare gamepad
wire inp_b, inp_y, inp_select, inp_start, inp_up, inp_down, inp_left, inp_right, inp_a, inp_x, inp_l, inp_r;





START AT LEVEL 12: https://bitstream.hackclub.com/tutorials/flappy-bird