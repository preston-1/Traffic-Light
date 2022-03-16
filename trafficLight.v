module trafficLight(clock,reset, gLength, yLength, rLength, carCount, light,walkButton, walkLight, walkCount);
    input clock;
    input reset; 
    input walkButton;
    input [10:0] gLength; //length of green light
    input [10:0] yLength; //length of yellow light
    input [10:0] rLength; //length of red light
    output [8:0] carCount; //total cars passed in sequence
    output [1:0] light; //current light color 
    output [8:0] walkCount; //count of "people" walked during a red light
    output walkLight; //use to "display" walk light
    reg [8:0] carCount; 
    reg [8:0] walkCount;
    reg [1:0] light;
    reg walkLight; 
    

    reg [10:0] currentCounterGreen; //store the time left on green light
    reg [10:0] currentCounterYellow; //store the time left on yellow light
    reg [10:0] currentCounterRed; //store the time left on red light
    //yellow light helper
    reg yellowFlipper = 0; //May not technically be accurate but idea is less cars go through yellow light so every other posEdge send a car through...
    reg walkEnable = 0; 
    
    //light options 
    //00: red
    //01: yellow
    //11: green
    
    always @(posedge clock) begin 
        if(reset) begin
            currentCounterGreen <= 0;
            currentCounterYellow <= 0;
            currentCounterRed <= 0;
            light <= 2'b00;
            carCount <= 0;
            walkCount <= 0;
            walkEnable <= 0;
            walkLight <= 0;
            yellowFlipper <= 0;
        end
        else begin
            if(light == 2'b00 && currentCounterGreen == 0 && currentCounterYellow == 0 && currentCounterRed == 0 )begin //right after a reset
                currentCounterGreen <= gLength;
                currentCounterYellow <= yLength;
                currentCounterRed <= rLength;
                walkEnable <= 0;
                light <= 2'b10;
                walkLight <= 0;
            end
            if(walkButton && (light == 2'b01 || light == 2'b11))begin //button was pushed during green or yellow cycle so 
                walkEnable <= walkButton;
            end
            if(light == 2'b10) begin //we are at a green light so count passing cars and 
                carCount <= carCount + 1;
                currentCounterGreen <= currentCounterGreen - 1;
                if(currentCounterGreen == 0) begin //the green light period is now over so set light to yellow
                    light <= 2'b01;
                    yellowFlipper = 0;
                end
            end
            else if(light == 2'b01)begin // cars pass by at "half" speed
                if(yellowFlipper)begin
                    carCount <= carCount + 1;
                    currentCounterYellow <= currentCounterYellow - 1;
                    yellowFlipper <= 0;
                    if(currentCounterYellow == 0)begin
                        light <= 2'b00; //yellow period is over so set light to red
                    end
                end
                else begin //flipper is off so reduce light cycle time but do not increase count;
                    yellowFlipper <= 1; 
                    currentCounterYellow <= currentCounterYellow - 1;
                    if(currentCounterYellow == 0)begin
                        light <= 2'b00; //yellow period is over so set light to red
                    end
                    
                end
            end
            else begin //light == 2'b00 so its red but we need to check if the walkButton was pressed during green or yellow cycle
                if(currentCounterRed != 0)begin
                    if (walkEnable) begin
                        walkLight <= 1;
                        walkCount <= walkCount + 1; 
                    end
                    currentCounterRed <= currentCounterRed - 1;
                end
            end
        end    
        
    end
endmodule
