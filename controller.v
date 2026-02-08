`timescale 1ns / 1ps



module controller#(parameter data_width=8)(
    input clk,
    input sclk_in,
    input reset,
    input miso,
    input spi_enable,
    input negative_edge,
    input positive_edge,
    input [data_width-1:0] data_in,
    output mosi,
    output reg clk_divider_reset,
    output reg cs,
    output reg sclk_out,
    output reg [data_width-1:0] data_out
    );
    
    
    
    
    reg [data_width-1:0] buffer;    
    reg [data_width-1:0] mosi_reg , mosi_next;
    reg [data_width-1:0] miso_reg,miso_next;
    reg [$clog2(data_width) :0] counter_reg,counter_next;
    reg [1:0] state_reg,state_next;

    localparam idle=0;
    localparam load=1;
    localparam transmit=2;
    localparam store=3;
    
    
    
    always@(posedge clk)
    begin
    
        if(reset)
        begin
            counter_reg<=0;
            state_reg<=idle;
            miso_reg<=0;
            mosi_reg<=0;
            buffer<=0;
        end
        
        
        else
        begin
            counter_reg<=counter_next;
            state_reg<=state_next;
            miso_reg<=miso_next;
            mosi_reg<=mosi_next;
            buffer<=data_in;
        end
        
               
    end
    
    
    
    
    
    
    always@(*)
    begin
        cs=1;
        sclk_out=0;
        state_next=state_reg;
        mosi_next=mosi_reg;
        miso_next=miso_reg;
        data_out=0;
        counter_next=counter_reg;
        clk_divider_reset=0;
        
        case(state_reg)
            
               
            idle:
            begin
                if(spi_enable==0)
                begin
                    state_next=idle;
                    cs=1;
                    sclk_out=0;
                end
                         
                else if(spi_enable==1)
                begin 
                    state_next=load;
                    cs=0;
                    clk_divider_reset=1;   //synchronous reset to the clock devider so when the transaction starts sclk is valid
                end
                           
            end
            
            
            
            
            load:
            begin
                mosi_next=buffer;
                state_next=transmit;
                sclk_out=sclk_in;
                cs=0;
                
            end

            
            
            transmit:
            begin
                
                sclk_out=sclk_in;
                cs=0;
                
                if(counter_reg==data_width)
                begin
                    state_next=store;
                    counter_next=0;
                end
                
                
                else 
                begin
                    
                    if(positive_edge)
                    begin
                        miso_next={miso,miso_reg[data_width-1:1]};
                        counter_next=counter_reg+1'b1;
                    end
                    
                    else if(negative_edge)
                    begin
                        mosi_next={1'b0,mosi_reg[data_width-1:1]};
                    end
                    
                end
                
                
            end
            
            
            store:
            begin
                sclk_out=sclk_in;
                cs=0;
                data_out=miso_reg;
                if(negative_edge)              //to get full cycle before going back to idle
                    state_next=idle;
            end
   
        endcase
    end
    
 





    assign mosi=mosi_reg[0];


endmodule


