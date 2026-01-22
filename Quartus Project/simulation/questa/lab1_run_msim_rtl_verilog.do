transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Verilog/ALU\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Verilog/ALU Lab/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Verilog/ALU\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Verilog/ALU Lab/lab1.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Verilog/ALU\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Verilog/ALU Lab/ALU.v}

vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/ALU\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/ALU Lab/tb_ALU.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_alu

add wave *
view structure
view signals
run -all
