transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio Test 2/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio Test 2/audio_output.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio Test 2/audio_configurator.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Audio Test 2/i2c_controller.v}

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Audio Test 2/tb_audio_configurator.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Audio Test 2/i2c_controller.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Audio\ Test\ 2 {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Audio Test 2/audio_configurator.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_audio_configurator

add wave *
view structure
view signals
run -all
