`timescale 1ns / 1ps


module master(
    input clk,
    input spi_enable,
    input reset,
    input miso,
    input [7:0]data_in,
    output cs,
    output sclk,
    output mosi,
    output [7:0] data_out
    );
    
    
    wire sclk_clock_devider;
    wire pos_edge;
    wire neg_edge;
    
    
    controller#(.data_width(8)) controller_instance(.negative_edge(neg_edge),.positive_edge(pos_edge),
    .data_in(data_in),.mosi(mosi),.cs(cs),
    .sclk_out(sclk),.data_out(data_out)
    ,.clk(clk),.sclk_in(sclk_clock_devider),.reset(reset)
    ,.miso(miso),.spi_enable(spi_enable));
    
    
    
    edge_detector    edge_detector_instance(.clk(clk),.reset(reset),.signal(sclk_clock_devider),
    .positive_edge(pos_edge),.negative_edge(neg_edge));
    
    
    
    clock_devider    clock_devider_instance(.clk(clk),.reset(reset),.sclk(sclk_clock_devider));
    
endmodule
