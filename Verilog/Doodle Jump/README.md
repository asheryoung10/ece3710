# Doodle Jump Repo Guide

This directory now follows the refactored split used by the active build flow: `rtl/` holds implementation modules, `sim/` holds testbenches, `mem/` holds ROM images, and `filelists/` drives compilation.

The quickest way to navigate the design is:

- Start at [doodle_jump.v](doodle_jump.v). It is the board-facing wrapper and Quartus top-level entrypoint.
- Drop into [rtl/top/doodle_jump_top.v](rtl/top/doodle_jump_top.v). That file wires together the CPU, memory map, VGA, audio, synchronized inputs, and debug displays.
- Follow CPU accesses through [rtl/game/mem_router.v](rtl/game/mem_router.v). It decides whether an address hits ROM, RAM, game registers, audio registers, or board inputs.
- Follow video from [rtl/video/vga_subsystem.v](rtl/video/vga_subsystem.v) and audio from [rtl/audio/audio_subsystem.v](rtl/audio/audio_subsystem.v). Those are the top-level peripheral pipelines.
- Run checks through [Makefile](Makefile). `make test` runs all current smoke tests using the files listed in [filelists/soc.f](filelists/soc.f).

## Verilog Files

### Top Level

- [doodle_jump.v](doodle_jump.v): Thin board wrapper used as the Quartus top-level entity. It forwards physical IO and CPU debug signals straight into the integrated Doodle Jump system.

- [rtl/top/doodle_jump_top.v](rtl/top/doodle_jump_top.v): Real SoC integration point for the project. It synchronizes buttons and switches, instantiates CPU/game/audio/video blocks, and drives LEDs, HEX displays, VGA, and audio pins.

### Common Definitions and Utilities

- [rtl/common/game_map_defs.vh](rtl/common/game_map_defs.vh): Shared Doodle Jump memory-map and gameplay constants. It defines ROM/RAM/MMIO address ranges, player and platform defaults, and screen geometry used across the design.

- [rtl/common/isa_defs.vh](rtl/common/isa_defs.vh): Shared ISA and CPU control definitions. It centralizes opcode encodings, condition codes, register widths, PSR flag indices, and control-unit state values.

- [rtl/common/program_rom.v](rtl/common/program_rom.v): Synchronous ROM wrapper initialized from a `.memh` program image. This is the read-only program space that feeds the CPU through the memory router.

- [rtl/common/sync_ram.v](rtl/common/sync_ram.v): Simple synchronous read/write RAM for the writable address range. It provides the CPU-visible data memory behind the SoC bus.

- [rtl/common/hex_decoder.v](rtl/common/hex_decoder.v): Nibble-to-7-segment decoder with active-low outputs. The top level uses it to show score and player-position debug values on the board HEX displays.

- [rtl/common/input_synchronizer.v](rtl/common/input_synchronizer.v): Two-stage synchronizer for asynchronous external inputs. It cleans up push-button and switch signals before the rest of the system consumes them.

### CPU

- [rtl/cpu/cpu_core.v](rtl/cpu/cpu_core.v): Top-level CPU wrapper for the datapath and control signals. It owns the IR, PC, PSR, register-file writeback mux, and the external memory bus interface.

- [rtl/cpu/control_unit.v](rtl/cpu/control_unit.v): Small finite-state controller for fetch, decode/load, execute, and load-from-memory sequencing. It turns the decoded opcode into write enables and operand-select control signals.

- [rtl/cpu/instruction_decoder.v](rtl/cpu/instruction_decoder.v): Instruction-field decoder and next-PC calculator. It extracts register addresses, immediates, combined opcodes, and branch/jump behavior from the current instruction and PSR flags.

- [rtl/cpu/alu.v](rtl/cpu/alu.v): Arithmetic and logic unit for the CPU core. It implements arithmetic, compare, bitwise, and shift operations while generating the condition flags stored in the PSR.

- [rtl/cpu/register_file.v](rtl/cpu/register_file.v): 16-register general-purpose register bank. Writes are synchronous, reads are combinational, and reset clears the full file to zero.

### Game and MMIO

- [rtl/game/game_regs.v](rtl/game/game_regs.v): MMIO-backed storage for Doodle Jump state. It holds player coordinates, platform descriptors, and score, and also defines their power-on defaults.

- [rtl/game/mem_router.v](rtl/game/mem_router.v): Address decoder and read-data mux for the whole SoC. It routes CPU accesses between ROM, RAM, game registers, audio registers, and synchronized input registers.

### Audio

- [rtl/audio/audio_regs.v](rtl/audio/audio_regs.v): CPU-visible control/status block for audio. It latches enable, pitch, drum mode, and configure requests, then reports audio busy/done/error state back over MMIO.

- [rtl/audio/audio_subsystem.v](rtl/audio/audio_subsystem.v): High-level audio wrapper used by the top level. It manages codec-configuration handshaking and pairs the control path with the generated audio sample path.

- [rtl/audio/audio_configurator_select.v](rtl/audio/audio_configurator_select.v): Command sequencer for I2C codec configuration writes. It picks the selected setup command and steps the lower-level controller through the transaction.

- [rtl/audio/i2c_controller.v](rtl/audio/i2c_controller.v): Bit-level I2C transmit state machine. It drives start, byte send, ACK sampling, and stop phases on the open-drain codec pins.

- [rtl/audio/simple_audio_output.v](rtl/audio/simple_audio_output.v): Lightweight audio sample generator. It creates the audio clocks and emits either a square-wave tone or pseudo-random drum/noise data.

### Video

- [rtl/video/vga_subsystem.v](rtl/video/vga_subsystem.v): Top-level VGA pipeline. It combines timing generation, background rendering, platform rendering, player rendering, and final RGB composition.

- [rtl/video/video_timing.v](rtl/video/video_timing.v): 640x480 VGA timing generator derived from the 50 MHz board clock. It produces the pixel clock, sync pulses, blanking signal, and visible pixel coordinates.

- [rtl/video/background_renderer.v](rtl/video/background_renderer.v): Stateless background color generator. It paints the checkerboard-like scene backdrop directly from the current pixel coordinates.

- [rtl/video/platform_renderer.v](rtl/video/platform_renderer.v): Platform layer renderer for the packed platform buses. It unpacks width/height data and raises an active mask whenever the current pixel falls inside a platform.

- [rtl/video/player_renderer.v](rtl/video/player_renderer.v): Player layer renderer. It draws the doodle body and eyes from the MMIO position registers and varies the body tint with the selected style index.

- [rtl/video/video_compositor.v](rtl/video/video_compositor.v): Final layer compositor. It forces black during blanking and otherwise applies a simple priority order of player over platforms over background.

### Simulation

- [sim/tb_cpu_smoke.v](sim/tb_cpu_smoke.v): CPU-and-memory smoke test driven by a compact ROM image. It checks that the CPU advances, updates game state, and produces expected score/player values.

- [sim/tb_mmio_decode.v](sim/tb_mmio_decode.v): Direct memory-router verification bench. It exercises game-register writes, audio MMIO behavior, and synchronized button/switch readback paths.

- [sim/tb_doodle_soc.v](sim/tb_doodle_soc.v): Whole-system smoke test around the real top-level wrapper. It verifies the integrated design moves the player, initializes audio state, and drives VGA blanking cleanly.

## Support Files

- [Makefile](Makefile): Main local verification entrypoint. It builds and runs the three supported Icarus testbenches and keeps temporary simulation artifacts under `build/`.

- [filelists/](filelists/): Compilation manifests for the simulator. [filelists/soc.f](filelists/soc.f) is the shared active source list, while [filelists/cpu_smoke.f](filelists/cpu_smoke.f), [filelists/mmio.f](filelists/mmio.f), and [filelists/doodle_soc.f](filelists/doodle_soc.f) each add one bench.

- [mem/](mem/): Program images used by the ROM. [mem/game_demo.memh](mem/game_demo.memh) is the default integrated demo image, and [mem/cpu_smoke.memh](mem/cpu_smoke.memh) is the compact image used by the focused smoke tests.

- [lab1.tcl](lab1.tcl): Quartus-generated pin-assignment export for the board wiring. It is useful as a reference if you need to reapply or compare physical pin constraints outside the `.qsf`.

- [archive/](archive/): Historical reference area intentionally kept out of the active build. [archive/README.md](archive/README.md) explains the folder, and `archive/bak/` preserves the pre-refactor source snapshots.

- [Quartus Project/lab1.qsf](../../Quartus%20Project/lab1.qsf): Active Quartus project source list and pin-assignment file. This is the cleaned project metadata that matches the refactored RTL layout.
