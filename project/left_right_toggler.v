`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 03:49:10 AM
// Design Name: 
// Module Name: left_right_toggler
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


module left_right_toggler(
    input btnL,
    input btnR,
    input clk,
    input started,
    output reg [1:0] state = 0
    );
    
    reg [32:0] debounce_counter = 0; // Debounce counter for both buttons
    reg left_pressed = 0; // Flag to indicate left button pressed
    reg right_pressed = 0; // Flag to indicate right button pressed
    
    reg last_activated = 0;
    
    always @(posedge clk) begin
    // Increment debounce counter if either button is pressed
        if (btnL || btnR)
        debounce_counter <= debounce_counter + 1;
        else
        debounce_counter <= 0;
        
        // Update state only if debounce counter reaches 200 ms (assuming 1 ms clock)
        if (debounce_counter == 20_000_00) begin
        if (btnL && state > 0 && started ==0)
            state <= state - 1;
        else if (btnR && state < 2 && started == 0)
            state <= state + 1;
        end
    end

endmodule
