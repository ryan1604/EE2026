`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 15:16:31
// Design Name: 
// Module Name: score_tracker
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


module score_tracker(
    //input rst, // for resetting scores before starting a new game
    input show_top_score, // for showing top score on display during menus
    //input clk_ani, // clock used for animation/display to ensure that score updates happen after scoring animations finish
    //input [31:0] dunk_ani_time, // # of clk_ani's clock cycles required to finish displaying the dunk animation
    //input [31:0] shot_ani_time, // # of clk_ani's clock cycyles required to finish displaying the shot animation
    //input has_scored_dunk, // binary 1 or 0 to indicate whether this point came from a dunk or not
    //input has_scored_shot, // binary 1 or 0 to indicate whether this point came from a shot or not
    //input scored_by_player, // // binary 1 or 0 to indicate whether this point came from the player or not (aka the ai)
    input clk_25Mhz_seg, // 25MHz clock used for flipping between anodes to display scores on 7-seg displays
    output reg [6:0] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111,
    input [5:0] score_player,
    //output reg [6:0] high_score_one = 0,
    //output reg [6:0] high_score_two = 0,
    //output reg [6:0] high_score_three = 0,
    input [5:0] score_ai
    );
    reg [31:0] debounce = 0;
    reg [5:0] highScore = 0;
//    always @ (posedge clk_ani) begin
//        if (rst) begin
//            score_player <= 0;
//            score_ai <= 0;
//        end
//        else begin
//            if (has_scored_dunk) begin
//                debounce <= debounce + 1;
//                if (debounce >= dunk_ani_time) begin
//                    debounce <= 0;
//                    if (scored_by_player) begin
//                        score_player <= score_player + 1;
//                        if (score_player + 1 > high_score_one) begin
//                            high_score_three <= high_score_two;
//                            high_score_two <= high_score_one;
//                            high_score_one <= score_player + 1;
//                        end
//                        else if (score_player + 1 > high_score_two) begin
//                            high_score_three <= high_score_two;
//                            high_score_two <= score_player + 1;
//                        end
//                        else if (score_player + 1 > high_score_three) begin
//                            high_score_three <= score_player + 1;
//                        end
//                    end
//                    else begin
//                        score_ai <= score_ai + 1;
//                    end
//                end
//            end
//            else if (has_scored_shot) begin
//                debounce <= debounce + 1;
//                if (debounce >= shot_ani_time) begin
//                    debounce <= 0;
//                    if (scored_by_player) begin
//                        score_player <= score_player + 1;
//                    end
//                    else begin
//                        score_ai <= score_ai + 1;
//                    end
//                end
//            end
//        end
//    end
    
    localparam zero = 7'b1000000;
    localparam one = 7'b1111001;
    localparam two = 7'b0100100;
    localparam three = 7'b0110000;
    localparam four = 7'b0011001;
    localparam five = 7'b0010010;
    localparam six = 7'b0000010;
    localparam seven = 7'b1111000;
    localparam eight = 7'b0000000;
    localparam nine = 7'b0010000;
    
    reg [2:0] an_state = 3;
    always @ (posedge clk_25Mhz_seg) begin
        an_state <= an_state - 1;
        if (score_player > highScore) highScore <= score_player;
        if (show_top_score) begin
            if (an_state == 2) begin
                an <= 4'b1011;
                case (highScore / 10)
                    0: seg <= zero;
                    1: seg <= one;
                    2: seg <= two;
                    3: seg <= three;
                    4: seg <= four;
                    5: seg <= five;
                    6: seg <= six;
                    7: seg <= seven;
                    8: seg <= eight;
                    9: seg <= nine;
                endcase
            end
            if (an_state == 1) begin
                an <= 4'b1101;
                case (highScore % 10)
                    0: seg <= zero;
                    1: seg <= one;
                    2: seg <= two;
                    3: seg <= three;
                    4: seg <= four;
                    5: seg <= five;
                    6: seg <= six;
                    7: seg <= seven;
                    8: seg <= eight;
                    9: seg <= nine;
                endcase
            end
        end
        else if (an_state == 3) begin
            an <= 4'b0111;
            case (score_player / 10)
                0: seg <= zero;
                1: seg <= one;
                2: seg <= two;
                3: seg <= three;
                4: seg <= four;
                5: seg <= five;
                6: seg <= six;
                7: seg <= seven;
                8: seg <= eight;
                9: seg <= nine;
            endcase
        end
        else if (an_state == 2) begin
            an <= 4'b1011;
            case (score_player % 10)
                0: seg <= zero;
                1: seg <= one;
                2: seg <= two;
                3: seg <= three;
                4: seg <= four;
                5: seg <= five;
                6: seg <= six;
                7: seg <= seven;
                8: seg <= eight;
                9: seg <= nine;
            endcase
        end
        else if (an_state == 1) begin
            an <= 4'b1101;
            case (score_ai / 10)
                0: seg <= zero;
                1: seg <= one;
                2: seg <= two;
                3: seg <= three;
                4: seg <= four;
                5: seg <= five;
                6: seg <= six;
                7: seg <= seven;
                8: seg <= eight;
                9: seg <= nine;
            endcase
        end
        else if (an_state == 0) begin
            an <= 4'b1110;
            case (score_ai % 10)
                0: seg <= zero;
                1: seg <= one;
                2: seg <= two;
                3: seg <= three;
                4: seg <= four;
                5: seg <= five;
                6: seg <= six;
                7: seg <= seven;
                8: seg <= eight;
                9: seg <= nine;
            endcase
        end
    end   
endmodule
