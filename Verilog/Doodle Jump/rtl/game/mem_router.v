`timescale 1ns/1ps
`include "game_map_defs.vh"

module mem_router #
(
    parameter ROM_INIT_FILE = "mem/game_demo.memh"
)
(
    input wire clk,
    input wire rst,
    input wire [15:0] address,
    input wire [15:0] write_data,
    input wire write_enable,
    input wire [3:0] push_buttons,
    input wire [9:0] switches,
    input wire audio_busy,
    input wire audio_done,
    input wire audio_error,
    input wire audio_configure_ack,
    output reg [15:0] read_data,
    output wire [15:0] player_x,
    output wire [15:0] player_y,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_x_bus,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_y_bus,
    output wire [(`DJ_NUM_PLATFORMS*16)-1:0] platform_wh_bus,
    output wire [15:0] score_status,
    output wire audio_configure_request,
    output wire audio_enable_output,
    output wire audio_drum_toggle,
    output wire [3:0] audio_selected_command,
    output wire [7:0] audio_pitch
);

// Track the selected memory-map region and readback buses.
reg rom_selected;
reg ram_selected;
reg game_selected;
reg audio_selected;
reg io_selected;

wire [15:0] rom_read_data;
wire [15:0] ram_read_data;
wire [15:0] game_read_data;
wire [15:0] audio_read_data;
reg [15:0] io_read_data;

// Provide the CPU with synchronous instruction ROM reads.
program_rom #(
    .INIT_FILE(ROM_INIT_FILE)
) program_rom_instance (
    .clk(clk),
    .addr(address[9:0]),
    .rdata(rom_read_data)
);

// Provide writable data memory for the CPU RAM region.
sync_ram data_ram_instance (
    .clk(clk),
    .we(ram_selected && write_enable),
    .addr(address[9:0]),
    .wdata(write_data),
    .rdata(ram_read_data)
);

// Expose player, platform, and score state as MMIO registers.
game_regs game_regs_instance (
    .clk(clk),
    .rst(rst),
    .chip_select(game_selected),
    .write_enable(write_enable),
    .address(address),
    .write_data(write_data),
    .read_data(game_read_data),
    .player_x(player_x),
    .player_y(player_y),
    .platform_x_bus(platform_x_bus),
    .platform_y_bus(platform_y_bus),
    .platform_wh_bus(platform_wh_bus),
    .score_status(score_status)
);

// Expose audio control and status registers on the MMIO bus.
audio_regs audio_regs_instance (
    .clk(clk),
    .rst(rst),
    .chip_select(audio_selected),
    .write_enable(write_enable),
    .address(address),
    .write_data(write_data),
    .configure_ack(audio_configure_ack),
    .busy(audio_busy),
    .done(audio_done),
    .error(audio_error),
    .read_data(audio_read_data),
    .configure_request(audio_configure_request),
    .enable_output(audio_enable_output),
    .drum_toggle(audio_drum_toggle),
    .selected_command(audio_selected_command),
    .pitch(audio_pitch)
);

// Decode the address map and mux the selected read data source.
always @(*) begin
    rom_selected = (address >= `DJ_ROM_BASE_ADDR) && (address <= `DJ_ROM_LAST_ADDR);
    ram_selected = (address >= `DJ_RAM_BASE_ADDR) && (address <= `DJ_RAM_LAST_ADDR);
    game_selected = (address == `DJ_PLAYER_X_ADDR) ||
                    (address == `DJ_PLAYER_Y_ADDR) ||
                    (address == `DJ_SCORE_STATUS_ADDR) ||
                    ((address >= `DJ_PLATFORM_BASE_ADDR) &&
                     (address < (`DJ_PLATFORM_BASE_ADDR + (`DJ_NUM_PLATFORMS * `DJ_PLATFORM_WORDS))));
    audio_selected = (address >= `DJ_AUDIO_CONTROL_ADDR) && (address <= `DJ_AUDIO_DEBUG_ADDR);
    io_selected = (address == `DJ_BUTTONS_ADDR) || (address == `DJ_SWITCHES_ADDR);

    // Format synchronized button and switch inputs as 16-bit MMIO reads.
    if (address == `DJ_BUTTONS_ADDR)
        io_read_data = {12'd0, push_buttons};
    else if (address == `DJ_SWITCHES_ADDR)
        io_read_data = {6'd0, switches};
    else
        io_read_data = 16'h0000;

    // Return the read data from the highest-priority selected region.
    case (1'b1)
        rom_selected: read_data = rom_read_data;
        ram_selected: read_data = ram_read_data;
        game_selected: read_data = game_read_data;
        audio_selected: read_data = audio_read_data;
        io_selected: read_data = io_read_data;
        default: read_data = 16'h0000;
    endcase
end

endmodule
