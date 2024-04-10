`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2024 03:29:47 AM
// Design Name: 
// Module Name: start_screen
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


module start_screen(
    input [63:0] x,
    input [63:0] y,
    input clk,
    input btnL,
    input btnR,
    input btnC,
    input reset,
    output reg [15:0] oled_data,
    output reg started = 0,
    output reg [1:0] difficulty
    );
    
    localparam [15:0] orange = 16'b11101_011110_00001;
    localparam [15:0] white = 16'b11111_111111_11111;
    localparam [15:0] green = 16'b00010_100101_00001;
    localparam [15:0] yellow = 16'b11010_110110_00001;
    localparam [15:0] red = 16'b11100_000111_00010;
    localparam [15:0] black = 16'b00000_000000_00000;
    
    wire [1:0]difficulty_state;
    left_right_toggler difficulty_menu (.btnL(btnL),.btnR(btnR),.clk(clk),.state(difficulty_state),.started(started));
    
    
    reg [32:0] debounce_counter = 0;
    
    // center circle
    wire signed [40:0] circle_formula;
    assign circle_formula = (x-47)*(x-47) + (y-31)*(y-31);
    wire shouldDisplayCircle;
    assign shouldDisplayCircle = (circle_formula > 60 && circle_formula <68);
    
    // left circle
    wire signed [40:0] circle_formula_left;
    assign circle_formula_left = (x-0)*(x-0) + (y-31)*(y-31);
    wire shouldDisplayCircleLeft;
    assign shouldDisplayCircleLeft = (circle_formula_left > 390 && circle_formula_left <410);
    
    //right circle
    wire signed [40:0] circle_formula_right;
    assign circle_formula_right = (x-95)*(x-95) + (y-31)*(y-31);
    wire shouldDisplayCircleRight;
    assign shouldDisplayCircleRight = (circle_formula_right > 390 && circle_formula_right <410);
 

    
    always @ (posedge clk) begin
        oled_data <= orange;
        
        // white center line
        if ( x >46 && x < 48 && y>9 && y< 52) begin
            oled_data <= white;
        end
        
        // arcs & circles
        if (shouldDisplayCircle) begin
            oled_data <= white;
        end
        
        if (shouldDisplayCircleLeft) begin
            oled_data <= white;
        end
        
        if (shouldDisplayCircleRight) begin
            oled_data <= white;
        end
        
        //keys
        if (x>0 && x < 10 && y >22 && y < 24) begin
            oled_data <= white;
        end
        else if ( x> 0 && x <10 && y>40 && y<42) begin
            oled_data <= white;
        end
        else if ( x > 8 && x < 11 && y >22 && y <42) begin
            oled_data <= white;
        end
        
        if (x>85 && x<95 && y>22 && y<24) begin
            oled_data <= white;
        end
        else if ( x>85 && x<95 && y>40 && y <42) begin
            oled_data <= white;
        end
        else if ( x>82 && x<85 && y >22 && y<42) begin
            oled_data <= white;
        end
        
        // difficulty display 
        // Easy
        if (x > 30 && x <37 && y >50 && y < 52)begin
            oled_data <= green;
        end
        else if (x > 30 && x<37 && y >54 && y < 56)begin
            oled_data <= green;
        end
        else if (x > 30 && x<37 && y >58 && y < 60)begin
            oled_data <= green;
        end
        else if (x > 30 && x <33 && y >50 && y <60) begin
            oled_data <= green;
        end 
        
        // Medium
        if ( x > 42 && x<45 && y >50 && y <60) begin
            oled_data <= yellow;
        end
        else if ($signed(x - y) > -10&& $signed(x - y)<-6 && x>42 && x<47)begin
            oled_data <= yellow;
        end 
        else if ($signed(x + y) > 100 && $signed(x + y)<104 && x>47 && x<52) begin
            oled_data <= yellow;
        end
        else if ( x >50 && x <53  && y > 50 && y <60) begin
            oled_data <= yellow;
        end
            
        // Hard
        if ( x >58 && x < 61 && y > 50 && y < 60) begin
            oled_data <= red;
        end
        else if ( x > 65 && x<68 && y > 50 && y< 60 ) begin
            oled_data <= red;
        end
        else if (x>58 && x < 68 && y >54 && y < 56) begin 
            oled_data <= red;
        end
        
        // selection 
        if ( x > 30 && x <37 && y > 60 && y<63 && difficulty_state == 0) begin
           oled_data <= black ;
        end
        else if (x > 42 && x<53 && y > 60 && y<63 && difficulty_state ==1) begin
           oled_data <= black;
        end 
        else if ( x> 58 && x<68 && y > 60 && y<63 && difficulty_state == 2) begin 
            oled_data <= black;
        end
        
        if (reset) started <= 0;
        
        // set the started state
        if (started == 0) begin
            if (btnC)
                debounce_counter <= debounce_counter + 1;
            else
                debounce_counter <= 0;
                
             if (debounce_counter == 20_000_00) begin
                started <= started+1;
             end
        end
        difficulty = difficulty_state;

             
    end
    
    
    
endmodule
