`ifndef DOODLE_JUMP_GAME_MAP_DEFS_VH
`define DOODLE_JUMP_GAME_MAP_DEFS_VH

// Define the program ROM and data RAM address ranges.
`define DJ_ROM_BASE_ADDR 16'h0000
`define DJ_ROM_LAST_ADDR 16'h03ff
`define DJ_RAM_BASE_ADDR 16'h0400
`define DJ_RAM_LAST_ADDR 16'h07ff

// Define the player state register addresses.
`define DJ_PLAYER_X_ADDR 16'h8000
`define DJ_PLAYER_Y_ADDR 16'h8001

// Define the packed platform register block layout.
`define DJ_PLATFORM_BASE_ADDR 16'h8010
`define DJ_PLATFORM_WORDS 3
`define DJ_NUM_PLATFORMS 4

// Define the audio control and status register addresses.
`define DJ_AUDIO_CONTROL_ADDR 16'h8100
`define DJ_AUDIO_PITCH_ADDR 16'h8101
`define DJ_AUDIO_STATUS_ADDR 16'h8102
`define DJ_AUDIO_DEBUG_ADDR 16'h8103

// Define the synchronized board input register addresses.
`define DJ_BUTTONS_ADDR 16'h8200
`define DJ_SWITCHES_ADDR 16'h8201

// Define the score register address.
`define DJ_SCORE_STATUS_ADDR 16'h8300

// Define the default gameplay state values loaded on reset.
`define DJ_PLAYER_DEFAULT_X 16'd256
`define DJ_PLAYER_DEFAULT_Y 16'd360
`define DJ_PLATFORM_DEFAULT_W 16'd96
`define DJ_PLATFORM_DEFAULT_H 16'd16
`define DJ_DEFAULT_SCORE 16'd0

// Define the visible screen and player sprite dimensions.
`define DJ_SCREEN_WIDTH 10'd640
`define DJ_SCREEN_HEIGHT 10'd480
`define DJ_PLAYER_WIDTH 10'd64
`define DJ_PLAYER_HEIGHT 10'd64

`endif
