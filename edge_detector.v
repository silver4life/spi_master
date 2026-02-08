`timescale 1ns / 1ps



module edge_detector(
    input clk,reset,
    input signal, // signal to be edge detected
    output positive_edge,negative_edge
    );
    reg state;


    always@(posedge clk)
    begin
        if(reset) 
            state<=0;
        else 
            state<=signal;
    end

    assign positive_edge= (!state) && signal;
    assign negative_edge= state && (!signal);
endmodule
