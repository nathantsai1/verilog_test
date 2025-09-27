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

// nested driver
gamepad_pmod_single driver {
    // inputs:
    .rst_n(rst_n),
    .clk(clk),
    .pmod_data(ui_in[6]),
    .pmod_clk(ui_in[5]),
    .pmod_latch(ui_in[4]_),
    //outputs:
    .b(inp_b),
    .y(inp_y),
    .select(inp_select),
    .start(inp_start),
    .up(inp_up),
    .down(inp_down),
    .left(inp_left),
    .right(inp_right),
    .a(inp_a),
    .x(inp_x),
    .l(inp_l),
    .r(inp_r)
};

// game control position holders
wire [8:0] bird_pos;
wire [8:0] hole_pos;
wire [9:0] pipe_pos;
wire [7:0] score;

// connect wires to game logic
gameControl game_ctrl {
    .clock(clk),
    .reset(rst_n),
    .v_sync(vsync),
    .button(inp_up), // flapping
    .bird_pos(bird_pos),
    .hole_pos(hole_pos),
    .pipe_pos(pipe_pos),
    .score(score)
}

// Colors
localparam [5:0] BLACK = { 2'b00, 2'b00, 2'b00 };
localparam [5:0] GREEN = { 2'b00, 2'b11, 2'b00 };
localparam [5:0] WHITE = { 2'b11, 2'b11, 2'b11 };
localparam [5:0] YELLOW = { 2'b11, 2'b11, 2'b00 };
localparam [5:0] BLUE = { 2'b00, 2'b00, 2'b11 };

// game object detection
wire bird_active;
wire pipe_active;
wire hole_active;

// Pipe rendering
wire pipe_visible = (pipe_pos < 640) && (pipe_pos > 0);
wire in_pipe_x = pipe_visible && (pix_x >= pipe_pos[9:0]) && (pix_x < pipe_pos[9:0] + 40);
// Top pipe (from 0 to hole_pos)
wire top_pipe = in_pipe_x && (pix_y < hole_pos);
// Bottom pipe (from hole_pos + 100 to bottom of screen)
wire bottom_pipe = in_pipe_x && (pix_y > hole_pos + 100);
assign pipe_active = top_pipe || bottom_pipe;
assign hole_active = in_pipe_x && (pix_y >= hole_pos) && (pix_y <= hole_pos + 100);

always @(posedge clk) begin
    if (~rst_n) begin
        R <= 0;
        G <= 0;
        B <= 0;
    end else begin
        if (video_active) begin
            if (bird_active) begin
                { R, G, B } <= YELLOW // Yellow bird
            end else if (pipe_active) begin
                { R, G, B } <= GREEN // green pipes
            end else if (hole_active) begin
                { R, G, B} <= BLACK;
            end
        end else begin
            { R, G, B } <= 0;
        end
    end
end
endmodule // tt_um_vga_example
START AT LEVEL 15: https://bitstream.hackclub.com/tutorials/flappy-bird