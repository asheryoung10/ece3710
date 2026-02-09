transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/register_file.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/register.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/mux4.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/mux2.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/memory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/instruction_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Verilog/CPU Lab/alu.v}

vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/top.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/tb_cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/shifting_unit.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/register_file.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/register.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/mux4.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/mux2.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/memory.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/instruction_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/cpu.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710-main/Quartus\ Project/../Verilog/CPU\ Lab {/home/u1462567/Documents/ece3710-main/Quartus Project/../Verilog/CPU Lab/alu.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_cpu

add wave *
view structure
view signals
run -all
