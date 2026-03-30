`timescale 1ns/1ps

package game_map_pkg;

    localparam logic [15:0] ROM_BASE_ADDR  = 16'h0000;
    localparam logic [15:0] ROM_LAST_ADDR  = 16'h03ff;
    localparam logic [15:0] RAM_BASE_ADDR  = 16'h0400;
    localparam logic [15:0] RAM_LAST_ADDR  = 16'h07ff;

    localparam logic [15:0] PLAYER_X_ADDR  = 16'h8000;
    localparam logic [15:0] PLAYER_Y_ADDR  = 16'h8001;

    localparam logic [15:0] PLATFORM_BASE_ADDR  = 16'h8010;
    localparam int PLATFORM_WORDS = 3;
    localparam int NUM_PLATFORMS = 4;

    localparam logic [15:0] AUDIO_CONTROL_ADDR = 16'h8100;
    localparam logic [15:0] AUDIO_PITCH_ADDR   = 16'h8101;
    localparam logic [15:0] AUDIO_STATUS_ADDR  = 16'h8102;
    localparam logic [15:0] AUDIO_DEBUG_ADDR   = 16'h8103;

    localparam logic [15:0] BUTTONS_ADDR = 16'h8200;
    localparam logic [15:0] SWITCHES_ADDR = 16'h8201;

    localparam logic [15:0] SCORE_STATUS_ADDR = 16'h8300;

    localparam logic [15:0] PLAYER_DEFAULT_X = 16'd256;
    localparam logic [15:0] PLAYER_DEFAULT_Y = 16'd360;
    localparam logic [15:0] PLATFORM_DEFAULT_W = 16'd96;
    localparam logic [15:0] PLATFORM_DEFAULT_H = 16'd16;
    localparam logic [15:0] DEFAULT_SCORE = 16'd0;

    localparam logic [9:0] SCREEN_WIDTH = 10'd640;
    localparam logic [9:0] SCREEN_HEIGHT = 10'd480;
    localparam logic [9:0] PLAYER_WIDTH = 10'd64;
    localparam logic [9:0] PLAYER_HEIGHT = 10'd64;

    function automatic logic [15:0] platform_word_addr(int platform_index, int field_index);
        platform_word_addr = PLATFORM_BASE_ADDR + (platform_index * PLATFORM_WORDS) + field_index;
    endfunction

    function automatic logic [15:0] default_platform_x(int platform_index);
        default_platform_x = 16'd48 + (platform_index * 16'd144);
    endfunction

    function automatic logic [15:0] default_platform_y(int platform_index);
        default_platform_y = 16'd400 - (platform_index * 16'd88);
    endfunction

endpackage
