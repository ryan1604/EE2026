`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:25:21
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock(input basys_clock, input [31:0] m, output reg slow_clock = 0);
    reg [31:0] count = 0;
    always @ (posedge basys_clock) begin
        count <= (count == m) ? 0 : count + 1;
        slow_clock <= (count == 0) ? ~slow_clock : slow_clock;
    end
endmodule
