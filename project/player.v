`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 01:01:49 PM
// Design Name: 
// Module Name: player
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


module player(
    input [63:0] x,
    input [63:0] y,
    input [63:0]player_locx,
    input [63:0] player_locy,
    input [15:0] player_jersey_color,
    input clk,
    output reg [15:0] oled_data
    );
    
    localparam [15:0] beige = 16'b11110_110101_10101;
    localparam [15:0] white = 16'b11111_111111_11111;
    
    always @(posedge clk) begin
        
        //if (row >= player_row && row <= player_row + player_height && col >= player_col && col <= player_col + player_width) begin
        
        if (x >=player_locx && x<=player_locx+2 && y>=player_locy && y<=player_locy+2) begin
           oled_data <= beige;
        end 
        else if (x >= player_locx && x<=player_locx +2 && y>=player_locy+3 && y<player_locy+8) begin
            oled_data <=player_jersey_color;
        end

    end
    
    
    
endmodule
