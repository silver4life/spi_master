`timescale 1ns / 1ps

module master#
   (parameter data_width=8,
    parameter cpol=1,
    parameter cpha=1,
    parameter div_factor=6
    )(
    input      clk,
    input      reset,
    
    output reg spi_cs,
    output reg spi_sclk,
    input      spi_miso,
    output     spi_mosi,

    input                       enable,
    input [data_width-1:0]      bus_data_in,
    output reg [data_width-1:0] bus_data_out
    );
    reg [data_width-1:0] buffer;    
    reg [data_width-1:0] mosi_reg , mosi_next;
    reg [data_width-1:0] miso_reg,miso_next;
    reg [$clog2(data_width) :0] data_counter,data_counter_next;
    reg [1:0] state_reg,state_next;
    reg sclk;
    reg cs;
    localparam idle=0;
    localparam ready=1;
    localparam transmit=2;
    localparam store=3;
    localparam sclk_initial=cpol^cpha;
    reg [$clog2(div_factor):0] div_counter,div_counter_next;
    
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            data_counter<=0;
            state_reg<=idle;
            miso_reg<=0;
            mosi_reg<=0;
            div_counter<=0;
            spi_sclk<=cpol;
            spi_cs<=1;
        end
        else
        begin
            data_counter<=data_counter_next;
            state_reg<=state_next;
            miso_reg<=miso_next;
            mosi_reg<=mosi_next;
            div_counter<=div_counter_next;
            spi_sclk<=sclk;
            spi_cs<=cs;
        end
    end
    
    always@(*)
    begin
        sclk=spi_sclk;
        div_counter_next=div_counter;
        state_next=state_reg;
        mosi_next=mosi_reg;
        miso_next=miso_reg;
        bus_data_out=0;
        data_counter_next=data_counter;
        cs=spi_cs;
        case(state_reg)
            idle:
            begin
                if(enable==0)
                begin
                    state_next=idle;
                    cs=1;
                    sclk=cpol;
                end
                else if(enable==1)
                begin
                    state_next=ready;
                    cs=0;
                    div_counter_next=0;
                    mosi_next=bus_data_in;
                end
            end
            ready:
            begin
                sclk=sclk_initial;
                state_next=transmit;
            end
            transmit:
            begin
                cs=0;
                div_counter_next=div_counter+1;
                if(data_counter==data_width)
                begin
                    if(div_counter==div_factor-1)
                    begin
                        sclk=cpol;
                        cs=1;
                        data_counter_next=0;
                        state_next=store;
                        div_counter_next=0;
                        
                    end

                end

                else
                begin
                    if(div_counter==div_factor-1)
                    begin
                        sclk=~spi_sclk;
                        div_counter_next=0;
                        mosi_next={mosi_reg[data_width-2:0],1'b0};

                    end
                    else if(div_counter==div_factor/2-1)
                    begin
                        sclk=~spi_sclk;
                        miso_next={miso_reg[data_width-2:0],spi_miso};
                        data_counter_next=data_counter+1;
                    end
                end
                            
            end
            store:
            
            begin
                sclk=cpol;
                cs=1;
                bus_data_out=miso_reg;
                state_next=idle;
                
            end
        endcase
    end

    assign spi_mosi=mosi_reg[data_width-1];
    
    
endmodule


