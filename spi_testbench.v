`timescale 1ns / 0.1ns

module spi_tb(

    );
    wire spi_cs;
    wire spi_sclk;
    reg spi_miso;
    wire spi_mosi;
    
    reg clk=0;
    reg reset=1;
    
    reg enable;
    reg [7:0] bus_data_in;
    wire [7:0] bus_data_out;
    
    master #(
    .cpol(1)
    ,.cpha(1)
    ,.div_factor(10)
    ,.data_width(8))
    master_tb(
    .spi_cs(spi_cs)
    ,.spi_sclk(spi_sclk)
    ,.spi_miso(spi_miso)
    ,.spi_mosi(spi_mosi)
    ,.clk(clk)
    ,.reset(reset)
    ,.enable(enable)
    ,.bus_data_in(bus_data_in)
    ,.bus_data_out(bus_data_out)
    );
    always
    begin
        #5 clk =~clk;
    end
    
    initial
    begin
        repeat(2)@(posedge clk);
        reset=0;
        bus_data_in=8'hfa;
        repeat(5)@(posedge clk);
        enable=1;
        repeat(2)@(posedge clk);
        enable=0;
        repeat(100)@(posedge clk);
        enable=1;
        repeat(1)@(posedge clk);
        enable=0;
    end
    
    reg [7:0] miso=8'b1111000;
    integer i=7;
    initial
    begin
        
        
        repeat(8)@(negedge spi_sclk)
        begin
            spi_miso<=miso[i];
            i=i-1;
        end
        i=7;
        miso=8'b11111000;
        
        
        repeat(8)@(negedge spi_sclk)
        begin
            spi_miso<=miso[i];
            i=i-1;
        end
    end
endmodule
