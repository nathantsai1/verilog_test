---
purpose: explain the usefulness of each function of project.v and basic Verilog details
---

FPGA: Field Programmable Gate Array, used for parallel processing(processing multiple data at the same time) and speed. This contrasts to a CPU as it does not process one piece of information at a time. Good for reprgramming.
HDL: Hardware Description Language, describes "layout" of circuit. Technically is a schematic in text format. Doesn't execute programs one at at time but rather defines a layout.
Verilog: An HDL that describes the digital circuits.Reads digital circuits through describing **how** electronics should be designed as. Differs from languages like C and Pascal by describing digital circuits and not how computer programs should work.
VGA: Video Graphics Array, an analog interface for computer video output. Outdated and HDMI would work better.


module: a block of Verilog code that implements a certain functionability. Can be nested within other modules has a module()/endmodule statement
assign: a signnal name that could either be a single signla or a concatenation of different signla nets. 
wire, reg, logic: signal types in Verilog, and represent either 0, 1, Z, or X
wire: represent **physical** connections between different components of a design.
reg: represent **internal storage** in a desing. Can only be driven by one source, and get stable values at end of every clock cycle
logic: **combination** of wire & reg **signals**. Can be driven by multiple sources, but their values are stable at end of clock cycle


Line:
10-18 == /* 
    [7:0] means bus width of 8 bits. these ports map directly to physical pins of FPGA/ASIC
    this enables communication with external componenets
    rst_n resets when signal is low
*/

27-35 == /* 
    have monitor draw pixels line by line, frame by frame using VGA (video graphics array). Uses hsync and vsync for x/y placement. R, G, B use 2 bits, resulting in 64 possible colors. 'video_active' represents if electron bean is within visible display area
*/

37-38 == /* 
    use continuous assignment to put individual VDA signals into 'uo_out' bus
    and connect to physical outputs. {} means combine multiple signals into bigger bus
    customize with reordering signals for different hardware pin assignments/more bits
*/

40-49 == /*
    use 'hvsync_generator' module, which helps generate precise timing signals 
    needed for VGA display. This module helps output 'pix_x' and 'pix_y' pixel coords,
    which increment every clock cycle and help the logic remember where it is being drawn
    Customize this by changing the screen resolution (640x480->1024x768) by changing aforementioned variables
*/

 - == /*
    declare individual 'wire' signals for each button on the gamepad. 
    Declare smth like 'wire [7:0] joystick_x' to create analog values instead of digital ones