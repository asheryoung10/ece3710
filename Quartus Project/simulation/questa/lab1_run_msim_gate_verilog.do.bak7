transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab1.vo}

vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/lab1.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/ALU.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/tb_ALU.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  tb_alu

add wave *
view structure
view signals
run -all
