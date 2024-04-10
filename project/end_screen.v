`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 05:38:05 AM
// Design Name: 
// Module Name: end_screen
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


module end_screen(
    input [63:0] x,
    input [63:0] y,
    input clk,
    input btnC,
    input win,
    input reset,
    output reg [15:0] oled_data,
    output reg restart = 0
    );
    
    reg btnC_prev = 0;
    reg [31:0] debounce;
    
    localparam [63:0] centerx = 47;
    localparam [63:0] centery = 31;
    localparam [15:0] brown = 16'b10100_011001_00001;
    localparam [15:0] black = 16'b00000_000000_00000;
    localparam [15:0] red = 16'b11100_000111_00010;
    localparam [15:0] green = 16'b00010_100101_00001;
    
    always @ (posedge clk) begin
        oled_data <= brown;
        
        //G
        if (x>centerx - 20 && x< centerx-10 && y >10 && y< 13) begin
            oled_data <= black;
        end
        else if (x >centerx-20 && x < centerx-17 && y>10 && y<20) begin
            oled_data <= black;
        end
        else if (x > centerx-20 && x < centerx-10 && y>18 && y<20) begin
            oled_data <= black;
        end
        else if (x > centerx-13 && x < centerx-10 && y>15 && y <20) begin
            oled_data <= black;
        end
        else if ( x>centerx-15 && x<centerx-10 && y>15 && y<18) begin
            oled_data <= black;
        end
        
        //A
        if ($signed(2*x + y) > 90 && $signed(2*x + y) <96 && x>centerx-10 && x<centerx-5 ) begin
            oled_data <= black;
        end
        else if ($signed(y-2*x)< -72 && $signed(y-2*x)>-76 && x>=centerx-5 && x<centerx) begin
            oled_data <= black;
        end
        else if (x>centerx-10&& x<centerx && y>13 && y<15) begin
            oled_data <= black;
        end
        
        //M
        if (x > centerx && x < centerx +3 && y >10 && y <20) begin
            oled_data <= black;
        end
        else if ( x > centerx+7 && x<centerx+10 && y>10 && y<20) begin
            oled_data <= black;
        end
        else if ( $signed(y-x) < -35 &&$signed(y-x)>-39 && x>centerx && x<centerx+5) begin
            oled_data <= black;
        end
        else if ( $signed(x+y) > 65 && $signed(x+y) < 69 && x>centerx+5&& x<centerx+10) begin
            oled_data <= black;
        end
        
        //E 
        if (x>centerx+10 && x<centerx+20 && y>10 && y<13) begin
            oled_data <= black;
        end
        else if (x>centerx+10 && x<centerx +13 && y>10 && y<20) begin
            oled_data <= black;
        end
        else if (x> centerx+10 && x <centerx+20 && y>14&& y<17) begin
            oled_data<= black;
        end
        else if (x> centerx+10 && x<centerx+20 && y>18 && y<20) begin
            oled_data <= black;
        end
        
        //O next line
        if ( x> centerx-20 && x <centerx-11 && y > 21 && y<23) begin
            oled_data <= black;
        end
        else if ( x>centerx-20 && x <centerx - 18 && y>21 && y<30) begin
            oled_data <= black;
        end
        else if ( x> centerx-20 && x < centerx -11 && y >27 && y<30 ) begin
            oled_data <= black;
        end
        else if (x > centerx -13 && x<centerx-11 && y>21 && y<30) begin
            oled_data <= black;
        end
        
        // V
        if ( $signed(y - 2*x) > -54 && $signed(y - 2*x) < -50 && x> centerx-11 && x <centerx-5) begin
            oled_data <= black;
        end
        else if ( $signed(y +2*x) > 112 && $signed(y +2*x) <116 && x>centerx-6 && x<centerx-1) begin
            oled_data <= black;
        end
        
        // E
        if ( x > centerx+1 && x< centerx+10 && y> 21 && y <24) begin
            oled_data <= black;
        end
        else if ( x > centerx+1 && x< centerx+10 && y>24 && y <26) begin
            oled_data <= black;
        end
        else if ( x > centerx+1 && x< centerx+10 && y>28 && y<30) begin
            oled_data <= black;
        end
        else if (x >centerx+1 && x<centerx+3 && y>21 && y<30) begin
            oled_data <= black;
        end
        
        //R
        if ( x > centerx+11 && x < centerx+20 && y>21 && y<24) begin
            oled_data <= black;
        end
        else if (x > centerx+11 && x< centerx+13 && y>21&& y<30) begin
            oled_data <= black;
        end
        else if ( x> centerx+11 && x<centerx+20 && y>24&& y<26) begin
            oled_data <= black;
        end
        else if (x > centerx+18 && x<centerx+20 && y>21 && y<26 ) begin
            oled_data <= black;
        end
        else if ($signed(y - x) < -31 && $signed(y - x)> -35 && x > centerx+11 && x<centerx+20 ) begin
            oled_data <= black;
        end
        
        
        // W 13,87,-7,107 
        if ( win) begin
            if ($signed(y-x) > 11 &&$signed(y-x) < 15 && x >27&& x<37) begin
            oled_data <= green;
            end
            else if ($signed(y+x) > 85 && $signed(y+x) < 89 &&x>37 && x<47) begin
            oled_data <= green;
            end
            else if ( $signed(y-x) > -9 &&$signed(y-x) < -5&& x>47&& x<57) begin
            oled_data <= green;
            end
            else if ( $signed(y+x) > 105&& $signed(y+x) < 109 && x >57 && x<67) begin
            oled_data <= green;
            end
        end
        else if (win == 0) begin 
            // L 
            if (x > centerx-2 && x < centerx+2&& y > 40 && y <50) begin
                oled_data <= red;
            end
            else if ( x> centerx -2 && x < centerx+8 && y >47 && y<50) begin
                oled_data <= red;
            end
        end
        
//        if (btnC && !btnC_prev) begin
//           restart <= 1;
//        end else begin
//           restart <= 0;
//        end
//        btnC_prev <= btnC;

        if (reset) begin
            if (btnC) debounce <= debounce + 1;
            else debounce <= 0;
            if (debounce >= 2000000) restart <= 1;
        end else restart <= 0;
        
     
    end
    
endmodule
