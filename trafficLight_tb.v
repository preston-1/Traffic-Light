`timescale 1ns / 1ns
`include "trafficLight.v"
`include "clock.v"

module trafficLight_tb;
    wire importClock;
    reg clock;
    reg reset; 
    reg walkButton;
    reg [10:0] gLength, yLength, rLength;
    wire [8:0] count;
    wire [1:0] lightType;  
    wire [8:0] walkCount;
    wire walkLight;
    clock CLK(importClock); 
    trafficLight UTT(clock, reset, gLength, yLength, rLength, count, lightType, walkButton, walkLight, walkCount);

    //loop variable for displaying traffic light states
    integer i;

    //clock to drive traffic light
    initial begin
        forever begin
            clock = importClock;
            #10;
            clock = importClock;
        end
    end

    initial begin
        $dumpfile("trafficLight_tb.vcd");
        $dumpvars(0, trafficLight_tb);
        reset = 1; //initalize all variables
        #10;
        //set inputs and turn off reset to run
        gLength = 10'b0000001000; 
        yLength = 10'b0000000010;
        rLength = 10'b0000001000;
        walkButton = 0;
        reset = 0;
        #10;
        
        for (i = gLength + yLength + rLength; i > 0; i = i - 1) begin
            case (lightType)
                0:begin
                    $display("RED light with car count %b", count);
                    #20;
                    if (walkLight) begin
                        $display("Walk light is ON with people count: %b", walkCount);
                        #20;
                    end
                    else begin
                        $display("Walk light is OFF with people count: %b", walkCount);
                        #20;
                    end
                end 
                1:begin
                    walkButton = 1; //someone clicked the walk button when the light turned yellow
                    $display("YELLOW light with total car count %b", count);
                    #20;
                    if(walkButton)begin
                        $display("Walk button has been clicked",);
                    end
                end 
                2:begin
                    $display("GREEN light with total car count %b", count);
                    #20;
                    if(walkButton)begin
                        $display("Walk button has been clicked",);
                    end
                end 
            endcase
        end

        $finish;
        
    end
endmodule