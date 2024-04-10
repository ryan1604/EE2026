`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Lavan Aidan Sumanan
//  STUDENT B NAME: Andre Villanueva
//  STUDENT C NAME: Neo Min Wei
//  STUDENT D NAME: Chua Qing Wei Ryan
//
//////////////////////////////////////////////////////////////////////////////////

`define RED 16'b11111_000000_00000
`define GREEN 16'b00000_111111_00000
`define BLUE 16'b00000_000000_11111
`define WHITE 16'b11111_111111_11111
`define BLACK 16'b00000_000000_00000
`define ORANGE 16'b11111_100000_00000

module Top_Student (input basys_clock, btnC, btnU, btnL, btnR, btnD, input [15:0] sw, output [7:0] JC, 
    output reg [15:0] led, output [7:0] seg, output [3:0] an, inout PS2Clk, PS2Data);
    wire clk_6p25m;
    wire clk_25m;
    wire clk_12p5m;
    wire clk_1h;
    wire clk_2h;
    wire clk_100h;
    wire clk_10h;
    wire clk_1k;
    
    reg [31:0] oled_data;
    wire fb;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    
    wire [5:0] row;
    wire [6:0] col;
    
    // task lavan
    reg [5:0] game_timer = 59;
    
    
    // task andre
    wire [31:0] start_screen_data;
    wire [31:0] end_screen_data;
    wire [31:0] bball_court_data;
    wire [31:0] scored_screen_data;
    wire [31:0] missed_screen_data;
    wire [31:0] dunked_screen_data;
    wire game_started;
    wire game_restart;
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] JX;
    wire [7:0] JY;
    wire fb1;
    wire [12:0] pixel_index1;
    wire sending_pixels1;
    wire sample_pixel1;
    wire fb2;
    wire [12:0] pixel_index2;
    wire sending_pixels2;
    wire sample_pixel2;
    
    // task min wei
    reg [25:0] gravity = 90000;
    reg [5:0] arc_max_height = (63 - 40);
    reg [25:0] player_speed = 0;
    reg [25:0] ball_initial_grav = 0;
    reg [5:0] player_row = 52;
    reg [6:0] player_col = 15;
//    reg [5:0] bot_row = 55;
//    reg [6:0] bot_col = 50;
    reg [5:0] hoop_height = (63 - 20);
    reg [6:0] hoop_width = 3;
    reg [5:0] player_jump_max_height = 20;
    reg [5:0] player_curr_jump = 0;
    reg [3:0] player_height = 8;
    reg [1:0] player_width = 2;
    reg [5:0] player_hand_row = 0; 
    //reg [5:0] bot_hand_row = 0;        
    reg [1:0] ball_height = 1;
    reg [1:0] ball_width = 1;
    reg [6:0] ball_col = 0;
    reg [5:0] ball_posvert_difference = 0;
    reg [5:0] ball_negvert_difference = 0;
    reg [6:0] initial_ball_col = 0;
    reg [6:0] initial_ball_row = 0;
    reg [5:0] ball_posvert_counter = 0;
    reg [11:0] ball_row = 0;
    reg [6:0] ball_row_offscreen = 0;
    reg [6:0] distance_to_basket = 0;
    reg is_shot = 0;
    reg playerHasBall = 1;
    reg player_is_jumping = 0;
    reg [25:0] player_jump_speed = 0;
    reg [25:0] player_grav = 0;
    reg [25:0] ball_grav = 0;
    //reg [25:0] ball_vert_speed = 0;
    //reg bot_has_ball = 0;    
    reg player_direction = 0; // 0 = right, 1 = left
    //reg bot_direction = 0; // 0 = right, 1 = left
    //reg btnU_tracker = 0;
    reg playerHasScored;
    wire playerHasScoredTemp;
    
    // task ryan
    wire [1:0] aiState;
    wire [1:0] diffLevel;
    wire [6:0] shootingRange;
    wire [6:0] defendRange;
    wire [6:0] attackRange;
    wire [6:0] aggressiveness;
    wire isAggressive;
    wire canSteal;
    wire [2:0] stealChance;
    reg aiHasBall, isLooseBall, reset, canScore;
    reg aiDirection; // right = 0, left = 1
    reg [6:0] aiLeft = 90;
    reg [6:0] aiRight = 92;
    reg [5:0] aiTop = 52;
    reg [5:0] aiBottom = 60;
    reg [6:0] aiDistanceToBasket = 0;
    reg aiShotBall = 0;
    reg aiScoreChance;
    wire aiHasScored;
    reg aiIsJumping = 0;
    reg aiShotResult = 0;
    wire [5:0] aiMaxJumpHeight;
    reg [5:0] aiCurrHeight = 0;
    reg [25:0] aiJumpSpeed = 0;
    reg [25:0] aiGrav = 0;
    reg lsfrReset = 0;
    //reg [6:0] playerLeft = 28;
    //reg [6:0] playerRight = 30;
    reg [31:0] counter = 0;
    wire [3:0] randomCounter;
    wire [31:0] aiSpeed;
    wire [31:0] boost;
    wire [4:0] shotCorrection;
    parameter defending = 2'b00;
    parameter attacking = 2'b01;
    parameter shooting = 2'b10;
    parameter waiting = 2'b11;
    parameter easy = 2'b00;
    parameter normal = 2'b01;
    parameter hard = 2'b10;
    parameter left = 1;
    parameter right = 0;
    
    reg [31:0] ballSpeed = 0;
    reg [5:0] aiScore = 0;
    reg [5:0] playerScore = 0;
    reg outcome = 0; // 0 = lose, 1 = win
    reg game_end = 0;
    reg resetGame = 0;
    reg scoreUnitReset = 0;
    reg isDunkAni = 0;
    reg isShootAni = 0;
    reg isMissAni = 0;
    wire [1:0] dunkFrame;
    wire [1:0] missFrame;
    wire [1:0] shootFrame;
    wire [31:0] player_data;
    wire [31:0] ai_data;
    reg playerShotResult = 0;
    reg [6:0] playerShotPos = 0;
    
    flexible_clock clk_6p25m_unit (.basys_clock(basys_clock), .m(7), .slow_clock(clk_6p25m));
    flexible_clock clk_25m_unit (.basys_clock(basys_clock), .m(1), .slow_clock(clk_25m));
    //flexible_clock clk_12p5m_unit (.basys_clock(basys_clock), .m(3), .slow_clock(clk_12p5m));
    flexible_clock clk_1h_unit (.basys_clock(basys_clock), .m(49999999), .slow_clock(clk_1h));
    flexible_clock clk_10h_unit (.basys_clock(basys_clock), .m(4999999), .slow_clock(clk_10h));
    //flexible_clock clk_100h_unit (.basys_clock(basys_clock), .m(499999), .slow_clock(clk_100h));
    flexible_clock clk_1k_unit (.basys_clock(basys_clock), .m(49999), .slow_clock(clk_1k));
    
    lsfr_32bit ai_rng_unit (.clk(clk_1h), .rst(lsfrReset), .out(randomCounter));
    
    Oled_Display oled_unit(.clk(clk_6p25m), .reset(0), .frame_begin(fb), .sending_pixels(sending_pixels),
  .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), 
  .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
 .pmoden(JC[7]));
    
//    Oled_Display start_oled_unit(.clk(clk_6p25m), .reset(0), .frame_begin(fb1), .sending_pixels(sending_pixels1),
//   .sample_pixel(sample_pixel1), .pixel_index(pixel_index1), .pixel_data(start_screen_data), .cs(JX[0]), .sdin(JX[1]), 
//   .sclk(JX[3]), .d_cn(JX[4]), .resn(JX[5]), .vccen(JX[6]),
//  .pmoden(JX[7]));
    
//    Oled_Display end_oled_unit(.clk(clk_6p25m), .reset(0), .frame_begin(fb2), .sending_pixels(sending_pixels2),
//    .sample_pixel(sample_pixel2), .pixel_index(pixel_index2), .pixel_data(end_screen_data), .cs(JY[0]), .sdin(JY[1]), 
//    .sclk(JY[3]), .d_cn(JY[4]), .resn(JY[5]), .vccen(JY[6]),
//   .pmoden(JY[7]));
   
    start_screen start_unit (.x(col), .y(row), .clk(clk_25m), .btnL(btnL), .btnR(btnR), .btnC(btnD), .oled_data(start_screen_data),
                             .started(game_started), .difficulty(diffLevel), .reset(resetGame));
    
    end_screen end_unit (.x(col), .y(row), .clk(clk_25m), .btnC(btnD), .win(outcome), .oled_data(end_screen_data), .restart(game_restart), .reset(game_end));
    
    score_tracker score_tracker_unit (.show_top_score(!game_started), .clk_25Mhz_seg(clk_1k), .seg(seg[6:0]), .an(an), .score_player(playerScore), .score_ai(aiScore));
    
//    score_tracker score_tracker_unit (.rst(), .show_top_score(), .clk_ani(), .dunk_ani_time(), .shot_ani_time(), .has_scored_dunk(), .has_scored_shot(),
//                              .scored_by_player(), .clk_25Mhz_seg(), .seg(), .an(), .score_player(playerScore), .high_score_one(), .high_score_two(),
//                              .high_score_three(), .score_ai(aiScore));
    
    get_shot_result score_unit (.rng_rst(scoreUnitReset), .clr(scoreUnitReset), .clk_10hz(clk_10h), .clk_25m(clk_25m),
                                .ball_x(player_col), .scored(playerHasScoredTemp));
    
    display_bball_court bball_court (.x(col), .y(row), .clk(clk_25m), .oled_data(bball_court_data));
    
    dunk_animation dunk (.x(col), .y(row), .clk(clk_25m), .run(isDunkAni), .oled_data(dunked_screen_data), .animation_frame(dunkFrame));
    
    miss_animation miss (.x(col), .y(row), .clk(clk_25m), .run(isMissAni), .oled_data(missed_screen_data), .animation_frame(missFrame));
    
    score_animation score (.x(col), .y(row), .clk(clk_25m), .run(isShootAni), .oled_data(scored_screen_data), .animation_frame(shootFrame));
    
    player player_unit (.x(col), .y(row), .player_locx(player_col), .player_locy(player_row), .clk(clk_25m), .player_jersey_color(`BLUE), .oled_data(player_data));
    
    player ai_unit (.x(col), .y(row), .player_locx(aiLeft), .player_locy(aiTop), .clk(clk_25m), .player_jersey_color(`GREEN), .oled_data(ai_data));
    
    //assign x = pixel_index % 96;
    //assign y = pixel_index / 96;
    assign col = pixel_index % 96;
    assign row = pixel_index / 96;
    //assign an = 4'b1010;
    
    // test lsfr
//    always @ (posedge clk_25m) begin
//        case (randomCounter)
//        0: led[15:0] = 16'b0000000000000001;
//        1: led[15:0] = 16'b0000000000000010;
//        2: led[15:0] = 16'b0000000000000100;
//        3: led[15:0] = 16'b0000000000001000;
//        4: led[15:0] = 16'b0000000000010000;
//        5: led[15:0] = 16'b0000000000100000;
//        6: led[15:0] = 16'b0000000001000000;
//        7: led[15:0] = 16'b0000000010000000;
//        8: led[15:0] = 16'b0000000100000000;
//        9: led[15:0] = 16'b0000001000000000;
//        10: led[15:0] = 16'b0000010000000000;
//        endcase
//    end
    
    always @ (posedge clk_1h) begin
        if (!game_started) begin
            game_timer <= 59;
            led[9:0] = 10'b1111111111;
        end
        else if (game_timer < 0) begin
            led[9:0] = 10'b0000000000;
        end
        else begin
            if (game_timer <= 9) begin
                led[game_timer] = 1'b0;
            end
            if (game_timer > 0) begin
                game_timer <= game_timer - 1;
            end
        end
    end
    
    always @ (posedge clk_25m) begin
        counter <= counter + 1;
        //diffLevel <= hard;
        //ballSpeed <= ballSpeed + 1;
        player_jump_speed <= (player_jump_speed == 10333 + player_grav) ? 0 : player_jump_speed + 1;
        ballSpeed <= (ballSpeed == 1033 + ball_grav) ? 0 : ballSpeed + 1;
        aiJumpSpeed <= (aiJumpSpeed == 10333 + aiGrav) ? 0 : aiJumpSpeed + 1;
        player_speed <= (player_speed == 1033333) ? 0 : player_speed + 1;
        player_hand_row <= player_row + 2;
        
        //oled_data <= start_screen_data;
        if (~game_started && ~game_end) begin
            oled_data <= start_screen_data;
            resetGame <= 0;
            aiScore <= 0;
            playerScore <= 0;
            reset <= 1;
            playerHasBall <= 1;
            is_shot <= 0;
            aiIsJumping <= 0;
            aiShotBall <= 0;
            aiHasBall <= 0;
            isLooseBall <= 0;
            aiShotResult <= 0;
            ball_grav <= 0;
            player_grav <= 0;
            aiGrav <= 0;
            //aiDistanceToBasket <= 0;
            distance_to_basket <= 0;
            ball_posvert_counter <= 0;
            ball_negvert_difference <= 0;
            ball_posvert_difference <= 0;
            ball_initial_grav <= 0;
            playerShotResult <= 0;
            //ball_col <= player_col + player_width;
            //ball_row <= player_hand_row;
        end
        else if (game_started && !game_end) begin
            if (game_timer == 0 && !is_shot && !aiShotBall && !aiCurrHeight && !player_curr_jump && !aiIsJumping && !player_is_jumping) begin
                outcome <= aiScore > playerScore ? 0 : 1;
                game_end <= 1;
            end
            if (reset) begin
                reset <= 0;
                aiLeft <= 90;
                aiRight <= 92;
                player_col <= 15;
                isLooseBall <= 0;
                isDunkAni <= 0;
                isShootAni <= 0;
                isMissAni <= 0;
                canScore <= 0;
                aiShotResult <= 0;
                playerShotResult <= 0;
                player_row <= 52;
            end
            if (!reset) begin
                oled_data <= bball_court_data;
                if (row >= player_row && row <= player_row + player_height && col >= player_col && col <= player_col + player_width) begin
                    oled_data <= player_data;
                end    
                if (row >= player_hand_row && row <= player_hand_row + ball_height && col >= player_col + player_width && col <= player_col + player_width + ball_width && player_direction == 0 && playerHasBall) begin
                    ball_col <= player_col + player_width;
                    initial_ball_col <= ball_col;
                    ball_row <= player_hand_row;
                    initial_ball_row <= ball_row;
                    distance_to_basket <= (95 - ball_col);
                    oled_data <= `ORANGE;
                end
                else if (row >= player_hand_row && row <= player_hand_row + ball_height && col >= player_col - ball_width && col <= player_col && player_direction == 1 && playerHasBall) begin
                    ball_col <= player_col + player_width;
                    initial_ball_col <= ball_col;
                    ball_row <= player_hand_row;
                    initial_ball_row <= ball_row;
                    distance_to_basket <= (95 - ball_col);            
                    oled_data <= `ORANGE;
                end
                else if (is_shot && row >= ball_row && row <= ball_row + ball_height && col >= ball_col && col <= ball_col + ball_width) begin
                    oled_data <= `ORANGE;
                end
//                if (row == hoop_height && ((col >= 95 - hoop_width  && col <= 95) || (col >= 0  && col <= hoop_width))) begin
//                    oled_data <= `RED;
//                end
                if (btnR && btnL) begin
                end
                else if (player_speed == 1033333 && btnR) begin
                    player_col <= (player_col + player_width + ball_width == 95) ? 92 : player_col + 1;
                    player_direction <= 0;
                end
                else if (player_speed == 1033333 && btnL) begin
                    player_col <= (player_col - ball_width == 0) ? 1 : player_col - 1;
                    player_direction <= 1;
                end
                if (btnU && player_curr_jump == 0) begin
                    player_is_jumping <= 1;
                end
                if (player_is_jumping) begin
                    if (player_jump_speed == 0) begin
                        player_grav <= player_grav + gravity;
                        player_curr_jump <= player_curr_jump + 1;
                        player_row <= (player_row == 0) ? 0 : player_row - 1;
                    end     
                    if (player_curr_jump == player_jump_max_height) begin
                        player_is_jumping <= 0;
                    end
                end
                else if (player_jump_speed == 0 && ~player_is_jumping) begin
                    player_grav <= (player_grav == 0) ? 0 : player_grav - gravity;
                    player_row = (player_row + player_height == 60) ? 52 : player_row + 1;
                    if (player_row == 52) begin
                        player_curr_jump <= 0;
                        player_grav <= 0;
                    end
                end
                if (btnC && playerHasBall) begin
                    is_shot <= 1;
                    if (playerHasScoredTemp) begin
                        playerHasScored <= 1;
                        playerShotPos <= player_col + player_width;
                    end else begin
                        playerHasScored <= 0;
                    end
                    playerHasBall <= 0;
                    isLooseBall <= 1;
                    aiHasBall <= 0;
                end
                if (is_shot) begin
                    if (ballSpeed == 0) begin
                        ball_posvert_difference <= (initial_ball_row < hoop_height) ? hoop_height - initial_ball_row : 0;
                        ball_initial_grav <= (initial_ball_row < hoop_height) ? (hoop_height - initial_ball_row) * gravity * 2 : 0;
                        ball_negvert_difference <= (initial_ball_row > hoop_height) ? initial_ball_row - hoop_height : 0;
                        if (ball_col < (distance_to_basket / 2) + initial_ball_col + ball_negvert_difference / 2 - ball_posvert_difference / 2) begin
                            ball_grav <= ball_initial_grav + gravity * ball_posvert_counter;
                            ball_posvert_counter <= ball_posvert_counter + 1;
                            ball_row <= ball_row - 1;
                        end
                        else begin
                            ball_grav <= (ball_grav <= 0) ? 0 : (ball_grav - gravity);
                            ball_row <= ball_row + 1;                
                        end
                    end
                    if (player_speed == 1033333) begin
                        ball_col <= (ball_col + ball_width >= 92) ? 92 : ball_col + 1;
                    end
                    if (ball_col >= 92) begin
                        if (playerShotResult == 0) begin
                            playerShotResult <= 1;
                            if (playerHasScored) begin
                                if (playerShotPos > 85) isDunkAni <= 1;
                                else isShootAni <= 1;
                            end else isMissAni <= 1;
                            
                        end
                        if (dunkFrame == 3 || shootFrame == 3 || missFrame == 3) begin
                            if (dunkFrame == 3 || shootFrame == 3) playerScore <= playerScore + 1;
                            playerHasBall <= 0;
                            aiHasBall <= 1;
                            is_shot <= 0;
                            ball_grav <= 0;
                            ball_posvert_counter <= 0;
                            isLooseBall <= 0;
                            reset <= 1;
                            isDunkAni <= 0;
                            isMissAni <= 0;
                            isShootAni <= 0;
                            playerShotResult <= 0;
                            playerHasScored <= 0;
                            if (game_timer == 0) begin
                                outcome <= aiScore > playerScore ? 0 : 1;
                                game_end <= 1;
                            end
                        end
                    end
                end
                if (~playerHasBall && ~is_shot && ~aiShotBall && btnD && player_row + player_height >= ball_row && player_row <= ball_row + ball_height && player_col <= ball_col + ball_width && player_col + player_width >= ball_col) begin
                    playerHasBall <= 1;
                    aiHasBall <= 0;
                end
                if (aiState == defending) begin
                    if (counter >= aiSpeed) begin // ai decision making and movement
                        counter <= 0;
                        if ((aiLeft < player_col + defendRange && aiRight < 95)) begin //|| (player_direction == right && player_col + player_width > 55 && aiRight < 95)) begin
                            aiLeft <= aiLeft + 1;
                            aiRight <= aiRight + 1;
                            aiDirection <= right;
                        end else if ((aiLeft > player_col + player_width + defendRange && aiRight > 48) || (player_direction == left && player_col + player_width < 30)) begin
                            aiLeft <= aiLeft - 1;
                            aiRight <= aiRight - 1;
                            aiDirection <= left;
                        end
                    end
                    if (row >= aiTop && row <= aiBottom && col >= aiLeft && col <= aiRight) begin // ai model
                        oled_data <= ai_data;
                    end
                    if (canSteal && (aiLeft <= player_col + player_width && aiLeft >= player_col || aiRight <= player_col + player_width && aiRight >= player_col) &&
                        aiTop <= ball_row) // steal condition
                    begin
                        playerHasBall <= 0;
                        aiHasBall <= 1;
                    end
                end else if (aiState == attacking) begin
                    if (row >= aiTop && row <= aiBottom && col >= aiLeft - 1 && col <= aiRight + 1) begin // ai model
                        if (row >= aiTop && row <= aiBottom && col >= aiLeft && col <= aiRight) oled_data <= ai_data;
                        if (aiDirection == left && row >= aiTop + 2 && row <= aiTop + 3 && col >= aiLeft - 1 && col <= aiLeft && ~aiShotBall) begin
                            ball_col <= aiLeft - 1;
                            ball_row <= aiTop + 2;
                            initial_ball_col <= ball_col;
                            aiDistanceToBasket <= ball_col;
                            initial_ball_row <= ball_row;
                            oled_data <= `ORANGE;
                        end else if (aiDirection == right && row >= aiTop + 2 && row <= aiTop + 3 && col >= aiRight && col <= aiRight + 1 && ~aiShotBall) begin
                            ball_col <= aiRight;
                            ball_row <= aiTop + 2;
                            initial_ball_col <= ball_col;
                            aiDistanceToBasket <= ball_col;
                            initial_ball_row <= ball_row;                            
                            oled_data <= `ORANGE;
                        end
                    end
                    if (counter >= aiSpeed - boost * isAggressive) begin // ai decision making and movement
                        counter <= 0;
                        if (aiLeft < player_col + player_width + attackRange || aiLeft > 80 || player_col + player_width <= 50 || isAggressive) begin
                            aiLeft <= aiLeft - 1;
                            aiRight <= aiRight - 1;
                            aiDirection <= left;
                        end else begin
                            aiLeft <= aiLeft + 1;
                            aiRight <= aiRight + 1;
                            aiDirection <= right;
                        end
                    end
                    if ((aiLeft <= shootingRange && player_col + player_width < aiLeft - 2) && !isAggressive) begin // ai shooting condition
                        canScore <= 1;
                        aiIsJumping <= 1;
                    end
                    else if (aiLeft <= 20 - attackRange) begin
                        canScore <= 1;
//                        if (aiHasScored) begin
//                            aiScore <= aiScore + 1;
//                            isDunkAni <= 1;
//                        end else begin
//                            isMissAni <= 1;
//                        end
                    end
                end else if (aiState == shooting) begin
                    if (aiLeft <= 20 - attackRange) begin // ai dunk
                        if (aiShotResult == 0) begin
                            aiShotResult <= 1;
                            if (aiHasScored) begin
                                aiScore <= aiScore + 1;
                                isDunkAni <= 1;
                            end else begin
                                isMissAni <= 1;
                            end
                        end
                        if (isDunkAni) oled_data <= dunked_screen_data;
                        else if (isMissAni) oled_data <= missed_screen_data;
                        if (dunkFrame == 3 || missFrame == 3) begin
                            canScore <= 0;
                            playerHasBall <= 1;
                            aiHasBall <= 0;
                            reset <= 1;
                            isDunkAni <= 0;
                            isMissAni <= 0;
                            aiShotResult <= 0;
                            if (game_timer == 0) begin
                                outcome <= aiScore > playerScore ? 0 : 1;
                                game_end <= 1;
                            end
                        end
                    end else begin // ai shoot
                        if (row >= aiTop && row <= aiBottom && col >= aiLeft && col <= aiRight) oled_data <= ai_data;
                        if (row >= ball_row && row <= ball_row + ball_height && col >= ball_col && col <= ball_col + ball_width) oled_data <= `ORANGE;
                    end
        //            aiHasBall <= 0;
        //            playerHasBall <= 0;
        //            isLooseBall <= 1;
                end else if (aiState == waiting) begin
                    if (row >= aiTop && row <= aiBottom && col >= aiLeft && col <= aiRight) oled_data <= ai_data; // ai model
                end
                if (aiIsJumping) begin
                    if (aiJumpSpeed == 0) begin
                        aiGrav <= aiGrav + gravity;
                        aiTop <= aiTop - 1;
                        aiBottom <= aiBottom - 1;
                        ball_row <= aiTop + 2;
                        initial_ball_row <= ball_row;                            
                        ball_col <= aiLeft - 1;
                        aiDistanceToBasket <= ball_col;
                        aiCurrHeight <= aiCurrHeight + 1;
                    end
                    if (aiCurrHeight == aiMaxJumpHeight) begin
                        aiIsJumping <= 0;
                        if (aiHasBall) begin
                            aiShotBall <= 1;
//                            if (aiHasScored) isShootAni <= 1;
//                            else isMissAni <= 1;
                        end
                    end
                end else if (aiJumpSpeed == 0 && ~aiIsJumping) begin
                    aiGrav <= aiGrav <= 0 ? 0 : aiGrav - gravity;
                    if (aiTop < 52) begin
                        aiTop <= aiTop + 1;
                        aiBottom <= aiBottom + 1;
                    end else begin
                        aiGrav <= 0;
                        aiCurrHeight <= 0;
                    end
                end
                if (aiShotBall) begin
                    if (ballSpeed == 0) begin
                        ball_posvert_difference <= (initial_ball_row < hoop_height) ? hoop_height - initial_ball_row : 0;
                        ball_initial_grav <= (initial_ball_row < hoop_height) ? (hoop_height - initial_ball_row) * gravity * 2 : 0;
                        ball_negvert_difference <= (initial_ball_row > hoop_height) ? initial_ball_row - hoop_height : 0;
                        if (ball_col > (aiDistanceToBasket / 2) - ball_negvert_difference / 2 + ball_posvert_difference / 2) begin
                            ball_grav <= ball_initial_grav + gravity * ball_posvert_counter;
                            ball_posvert_counter <= ball_posvert_counter + 1;
                            ball_row <= ball_row - 1;
                        end
                        else begin
                            ball_grav <= (ball_grav <= 0) ? 0 : (ball_grav - gravity);
                            ball_row <= ball_row + 1;                
                        end
                    end
                    if (player_speed == 1033333) begin
                        ball_col <= (ball_col == 0) ? 0 : ball_col - 1;
                    end                
//                    if (ballSpeed == 0) begin
//                        ball_col <= (ball_col <= 1) ? 2 : ball_col - 1;
//                        if (ball_col > aiDistanceToBasket / 2 + shotCorrection) begin
//                            ball_grav <= ball_grav + gravity;
//                            ball_row <= ball_row - 1;
//                        end
//                        else begin
//                            ball_grav <= (ball_grav <= 0) ? 0 : (ball_grav - gravity);
//                            ball_row <= ball_row + 1;                
//                        end
                        if (ball_col <= 3) begin
                            if (aiShotResult == 0) begin
                                aiShotResult <= 1;
                                if (aiHasScored) begin
                                    aiScore <= aiScore + 1;
                                    isShootAni <= 1;
                                end else begin
                                    isMissAni <= 1;
                                end
                            end
//                            if (isShootAni) oled_data <= scored_screen_data;
//                            else if (isMissAni) oled_data <= missed_screen_data;
                            if (shootFrame == 3 || missFrame == 3) begin
                                playerHasBall <= 1;
                                aiHasBall <= 0;
                                aiShotBall <= 0;
                                canScore <= 0;
                                ball_grav <= 0;
                                ball_posvert_counter <= 0;                                
                                reset <= 1;
                                isShootAni <= 0;
                                isMissAni <= 0;
                                aiShotResult <= 0;
                                if (game_timer == 0) begin
                                    outcome <= aiScore > playerScore ? 0 : 1;
                                    game_end <= 1;
                                end
                            end
                        end
//                    end
                    if (isShootAni) oled_data <= scored_screen_data;
                    else if (isMissAni) oled_data <= missed_screen_data;
                end
                if (is_shot) begin
                    if (isShootAni) oled_data <= scored_screen_data;
                    else if (isDunkAni) oled_data <= dunked_screen_data;
                    else if (isMissAni) oled_data <= missed_screen_data;
                end
            end
        end
        else if (game_end) begin
            oled_data <= end_screen_data;
            if (game_restart) begin
                resetGame <= 1;
                game_end <= 0;
            end
        end
    end
    
    assign shootingRange = diffLevel == easy ? 40 : diffLevel == normal ? 50 : diffLevel == hard ? 55 : 40;
    assign defendRange = diffLevel == easy ? 7 : diffLevel == normal ? 3 : diffLevel == hard ? 1 : 8;
    assign attackRange = diffLevel == easy ? 8 : diffLevel == normal ? 5 : diffLevel == hard ? 3 : 8;
    assign aiHasScored = canScore ? diffLevel == easy ? randomCounter <= 3 : diffLevel == normal ? randomCounter <= 6 :
                         diffLevel == hard ? randomCounter <= 9 : 0 : 0;
    assign aggressiveness = diffLevel == easy ? 0 : diffLevel == normal ? 3 : diffLevel == hard ? 6 : 0;
    assign isAggressive = diffLevel == easy ? 0 : randomCounter <= aggressiveness ? 1 : 0;
    assign stealChance = diffLevel == easy ? 0 : diffLevel == normal ? 3 : diffLevel == hard ? 6 : 0;
    assign canSteal = diffLevel == easy ? 0 : randomCounter <= stealChance ? 1 : 0;
    assign boost = diffLevel == easy ? 0 : diffLevel == normal ? 50000 : diffLevel == hard ? 100000 : 0;
    assign aiMaxJumpHeight = diffLevel == easy ? 15 : diffLevel == normal ? 18 : diffLevel == hard ? 22 : 15;
    assign shotCorrection = diffLevel == easy ? 0 : diffLevel == normal ? 1 : diffLevel == hard ? 2 : 0;
    assign aiSpeed = diffLevel == easy ? 1233333 : diffLevel == normal ? 1033333 : diffLevel == hard ? 833333 : 1233333;
    assign aiState = playerHasBall ? defending : aiHasBall ? canScore ? shooting : attacking : isLooseBall ? waiting : defending;
endmodule