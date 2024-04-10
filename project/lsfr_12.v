`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 13:53:43
// Design Name: 
// Module Name: lfsr_12
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


module lfsr_12(
    input RST,
    input CLK,
    output reg [11:0] Q = 0
    );
    
    always @ (posedge CLK, posedge RST) begin
        if (RST) begin
            Q <= 0;
        end    
        else begin
            Q <= { Q[10:6], ~(Q[5]^Q[11]), Q[4], ~(Q[3]^Q[11]), Q[2:0], Q[11] };
        end
    end
    
endmodule
