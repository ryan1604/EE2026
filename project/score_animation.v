`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 09:47:21 AM
// Design Name: 
// Module Name: score_animation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module score_animation(
    input [63:0] x,
    input [63:0] y,
    input clk,
    input run,
    output reg [15:0] oled_data,
    output reg [1:0] animation_frame = 0
    );
    
    localparam [15:0] orange = 16'b11101_011110_00001;
    localparam [15:0] black = 16'b00000_000000_00000;
    localparam [15:0] red = 16'b11100_000111_00010;
    localparam [15:0] blue = 16'b00001_101011_11010;
    localparam [15:0] white = 16'b11111_111111_11111;
    
    //reg [1:0] animation_frame = 0;
    
    reg [63:0] frame_rate_counter = 0;
    
    always @ (posedge clk) begin
        oled_data <= blue;
        
        // ball either entering or exiting the hoop
        if (run) begin
            frame_rate_counter = frame_rate_counter + 1;
            
            if (frame_rate_counter == 10_000_000) begin
                animation_frame = animation_frame +1;
                frame_rate_counter = 0;
            end
        end
        else begin
            frame_rate_counter = 0;
            animation_frame = 0;
        end
        
        case (animation_frame)
            0: if (x>15 && x < 25 && y>10 && y <20) begin
                oled_data <= orange;
               end
            1: if (x >25 && x<35 && y >0 && y<10) begin
                oled_data <= orange;
               end 
            2: if (x >35 && x<45 && y>10 && y<20) begin
                oled_data <= orange;
               end 
            3: if (x > 35 && x<45 && y>30 && y<40) begin
                 oled_data <= orange;
               end
            default:if (x>15 && x < 25 && y>10 && y <20) begin
                oled_data <= orange;
               end
        endcase
        
        
        // hoop
        if (x > 30 && x <50 && y > 20 && y<25) begin
            oled_data <= red;
        end
        else if (x>50&& x<53 && y >0 && y <22) begin
            oled_data <= black;
        end
        else if ( x> 48 && x <50 && y >22 && y < 40) begin
            oled_data <= black;
        end
        else if ( x>40 && x < 43 && y >22 && y<40) begin
            oled_data <= black;
        end
        else if ( x>30 && x <33 && y>22 && y<40) begin
            oled_data <= black;
        end
        else if (x>30 && x <53 && y >28 && y<30) begin
            oled_data <= black;
        end
        else if (x>30 && x <53 && y>34 && y<37) begin
            oled_data <= black;
        end
        else if (x>50&& x<53 && y >22 && y <63)begin
            oled_data <= white;
        end
        
    end
    
    
endmodule
