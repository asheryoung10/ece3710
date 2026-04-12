transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/snes {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/snes/SNES_latchGen.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/snes {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/snes/SNES_Controller.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/snes {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/snes/SNES_clkdiv.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/snes {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/snes/snes.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/sixteen_bit_seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/audio/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/audio/audio_configurator_select.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/audio/audio_output.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/memory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/sharedMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/vga/playerMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/vga/tileMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/register_file.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/register.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/mux4.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/mux2.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/cpu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/audio/i2c_controller.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/vga/hard_coded_vga.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/doodle_jump.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/instruction_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/control_unit.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/cpu/alu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Doodle Jump/vga/glyph_rom.v}

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/alu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/control_unit.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/cpu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/instruction_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/mux2.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/mux4.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/register.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/register_file.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/block_mover.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/clk_divider.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/hard_coded_bitgen.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/hard_coded_vga.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/playerMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/tb_hard_coded_vga.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/tileMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/doodle_jump.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/tb_i2c_controller.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/i2c_controller.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/tb_doodle.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/tb_cpu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/sharedMemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/memory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/sixteen_bit_seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/glyph_rom.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/tb_audio_configurator.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_output.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_configurator_select.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_configurator.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_doodle

add wave *
view structure
view signals
run -all
