`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 06:10:35 AM
// Design Name: 
// Module Name: display_bball_court
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

module display_bball_court(
    input [63:0] x,
    input [63:0] y,
    input clk,
    output reg [15:0] oled_data
    );
    
    localparam [15:0] orange = 16'b11101_011110_00001;
    localparam [15:0] white = 16'b11111_111111_11111;
    localparam [15:0] green = 16'b00010_100101_00001;
    localparam [15:0] yellow = 16'b11010_110110_00001;
    localparam [15:0] red = 16'b11100_000111_00010;
    localparam [15:0] black = 16'b00000_000000_00000;
    localparam [15:0] blue = 16'b00001_101011_11010;
    
    always @ (posedge clk) begin
        oled_data <= blue;
        
        //floor && left hoop
        if (y>60 && y<=63) begin
            oled_data <= orange;
        end
        else if ( x>=0 && x <2 && y>40 && y<=60) begin
            oled_data <= white;
        end
        else if ( x>=0 && x<2 && y>30 && y<=40) begin
            oled_data <= black;
        end
        else if (x>=0 && x <6 && y>38 && y<42) begin
            oled_data <= red;
        end
        
        //right hoop
        if ( x>93 && x<=95 && y>40 && y<=60) begin
            oled_data <= white;
        end
        else if(x>93 && x <=95 && y>30&& y<=40) begin
            oled_data <= black;
        end
        else if(x>89&& x<=95 && y>38 && y<42) begin
            oled_data <= red;
        end
    end
    
endmodule
