`timescale 1ns / 1ps





module clock_devider(
    input clk,reset,
    output sclk
    );
    reg [4:0] counter_reg;
    always@(posedge clk)
    begin
        if(reset) counter_reg<=0;
        
        else
        begin
            if(counter_reg==5'd31)
                counter_reg<=0;
               
            else
                counter_reg<=counter_reg+1;
        end
        
        
    end
    
    assign sclk=counter_reg[4];
endmodule
