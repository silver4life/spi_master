`timescale 1ns / 1ps




module clock_devider(
    input clk,
    input reset,
    input clk_devider_reset,
    output sclk
    );
    reg [4:0] counter_reg;
    always@(posedge clk)
    begin
    
        if(reset)
            counter_reg<=0;
        
        else
            if(clk_devider_reset)
                counter_reg<=0;
            else    
                counter_reg<=counter_reg+1;
     
    end
    
    assign sclk=counter_reg[4];
endmodule
