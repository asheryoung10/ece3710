transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/snes {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/snes/SNES_latchGen.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/snes {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/snes/SNES_Controller.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/snes {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/snes/SNES_clkdiv.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/snes {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/snes/snes.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/seven_seg_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/sixteen_bit_seven_seg_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/audio/top.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/audio/audio_configurator_select.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/audio/audio_output.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/memory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/sharedMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/vga/playerMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/vga/tileMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/register_file.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/register.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/mux4.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/mux2.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/audio/i2c_controller.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/vga/hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/doodle_jump.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/instruction_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/cpu/alu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/vga/glyph_rom.v}

vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/alu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/instruction_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/mux2.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/mux4.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/register.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/register_file.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/top.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/block_mover.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/clk_divider.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/hard_coded_bitgen.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/playerMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/tb_hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/tileMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/doodle_jump.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/tb_i2c_controller.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/i2c_controller.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/tb_doodle.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/cpu {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/cpu/tb_cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/sharedMemory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/memory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/sixteen_bit_seven_seg_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/seven_seg_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/vga {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/vga/glyph_rom.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/top.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/tb_audio_configurator.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_output.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_configurator_select.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/ece3710/Quartus\ Project/../Verilog/Doodle\ Jump/audio {/home/u1462567/Desktop/ece3710/Quartus Project/../Verilog/Doodle Jump/audio/audio_configurator.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_doodle

add wave *
view structure
view signals
run -all
