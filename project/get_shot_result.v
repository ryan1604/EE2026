`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 13:53:43
// Design Name: 
// Module Name: get_shot_result
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


module get_shot_result(
    input rng_rst,
    input clr,
    input clk_10hz,
    input clk_25m,
    input [6:0] ball_x,
    output reg scored = 0
    );
    
    wire [11:0] random_num;
    lfsr_12 ran_gen (rng_rst, clk_10hz, random_num);
        
    always @ (posedge clk_25m, posedge clr) begin
        if (clr) begin
            scored <= 0;
        end
        else begin
            scored <= (ball_x / 10) >= (random_num % 10) ? 1 : 0;
        end
    end
    
endmodule
