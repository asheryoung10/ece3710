transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/lab1.v}
vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/ALU.v}

vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/lab1.v}
vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/ALU.v}
vlog  -work work +incdir+C:/Users/asher/Documents/ECE3710/ece3710/verilog {C:/Users/asher/Documents/ECE3710/ece3710/verilog/tb_ALU.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_alu

add wave *
view structure
view signals
run -all
