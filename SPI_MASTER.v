`timescale 1ns / 1ps



module SPI_MASTER(
input clk,reset,miso,spi_enable,
input [7:0] buffer_in, //data that will be loaded into the spi master regesiter to be sent
output mosi,
output reg cs,
output sclk_out,
output reg [7:0] buffer_out //data recieved by the master
    );
    
    
    
reg sclk;
reg [7:0] buffer;    
reg [7:0] mosi_reg , mosi_next;
reg [7:0] miso_reg,miso_next;
reg [2:0] counter_reg,counter_next;
reg [1:0] state_reg,state_next;

localparam idle=0;
localparam load=1;
localparam transmit=2;
localparam store=3;

always@(posedge clk)
begin
if(reset) buffer<=0;
else buffer<=buffer_in;
end



always@(posedge sclk) //miso register
begin
if (reset) miso_reg<='b0;
else miso_reg<=miso_next;
end


always@(posedge clk)
begin
if (reset) state_reg<= 0;
else state_reg<=state_next;
end


always@(posedge clk)      //number of shifts counter
begin
if(reset) counter_reg <='b0;
else     counter_reg<=counter_next;
end


always@(negedge sclk)      
begin
if(reset) mosi_reg <='b0;
else    mosi_reg <=mosi_next;
end





always@(*)
begin

cs=1;
state_next=idle;
counter_next=0;
mosi_next=mosi_reg;
miso_next=miso_reg;
sclk=1;
buffer_out=miso_reg;
case(state_reg)
idle:
begin

if(spi_enable)
begin
state_next=load;
mosi_next=buffer;
end
else state_next=idle;

end


load:
begin
cs=0;
sclk=clk;
state_next=transmit;
end




transmit:


begin
counter_next=counter_reg+1;
cs=0;
sclk=clk;
if(counter_reg<3'd7)
begin
mosi_next={1'b0,mosi_reg[7:1]};
miso_next={miso,miso_reg[7:1]};
end
else  state_next=store;

end


store:
begin
cs=0;
sclk=clk;
buffer_out=miso_reg;
state_next=idle;
end

endcase
end







assign mosi = mosi_reg[0];
assign sclk_out=sclk;


endmodule

