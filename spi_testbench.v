`timescale 1ns / 1ps


module spi_testbench(); 
    reg clk;
    reg reset;
    reg miso;
    reg spi_enable;
    reg [7:0] data_in;
    reg [7:0] slave_shift_reg;
    wire mosi;
    wire cs;
    wire sclk;
    wire [7:0] data_out;
    integer i=0;
    
    master master_tb
    (.clk(clk),
    .reset(reset)
    ,.miso(miso)
    ,.spi_enable(spi_enable)
    ,.data_in(data_in)
    ,.mosi(mosi)
    ,.cs(cs)
    ,.sclk(sclk)
    ,.data_out(data_out));

    always
    begin
        clk=0;#5;
        clk=1;#5;
    end
    initial
    begin
        i=0;
        reset=1; 
        #20;
        reset=0; 
        #10;
        data_in=8'b11100110;
        slave_shift_reg=8'b00000011;
        #10;
        spi_enable=1;#100;
        spi_enable=0;#4000;
        data_in=8'b00001111;
        slave_shift_reg=8'b11000011;
        spi_enable=1;#20;
        spi_enable=0;#4000;
        $finish; 
    end
       
    always@(negedge cs)
    begin
        miso=slave_shift_reg[0];
        i=i+1;
    end

    always@(negedge sclk)
    begin
        if(i<8 & i>0)
        begin
            miso=slave_shift_reg[i];
            i=i+1;
        end
        else
        begin
            i=0;
        end
    end    
endmodule
