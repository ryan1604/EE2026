`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2024 23:46:51
// Design Name: 
// Module Name: lsfr_32bit
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


module lsfr_32bit(input clk, input rst, output reg [3:0] out);
    reg [31:0] tempOut = 1;
    wire random = tempOut[31] ^ tempOut[21] ^ tempOut[1] ^ tempOut[0];
    
    always @ (*) begin
        out = tempOut % 11;
    end
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            tempOut <= 1;
        end else begin
            tempOut <= {tempOut[30:0], random};
        end
    end

endmodule
