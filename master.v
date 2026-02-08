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
    
    
    wire clk_divider_wire;
    wire pos_edge;
    wire neg_edge;
    wire clk_divider_reset;
    
    controller#(.data_width(8))   controller_instance(.mosi(mosi),.miso(miso),.clk(clk),.cs(cs),
    .reset(reset),.negative_edge(neg_edge),.positive_edge(pos_edge),.data_in(data_in),
    .sclk_out(sclk),.data_out(data_out)
    ,.sclk_in(clk_devider_wire),
    .spi_enable(spi_enable),.clk_devider_reset(clk_devider_reset));
    
    
    
    edge_detector    edge_detector_instance(.clk(clk),.reset(reset),.signal(clk_divider_wire),
    .positive_edge(pos_edge),.negative_edge(neg_edge));
    
    
    
    clock_divider    clock_divider_instance(.clk(clk),.reset(reset),.sclk(clk_divider_wire),.clk_devider_reset(clk_divider_reset));
    
endmodule
