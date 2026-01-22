transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog  -work work +incdir+. {lab1.vo}

vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/ALU\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/ALU Lab/tb_ALU.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  tb_alu

add wave *
view structure
view signals
run -all
