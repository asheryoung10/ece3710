transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog  -work work +incdir+. {lab1.vo}

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/tb_cpu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/shifting_unit.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/register_file.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/register.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/mux4.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/mux2.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/memory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/instruction_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/cpu.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/control_unit.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/CPU\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/CPU Lab/alu.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  tb_cpu

add wave *
view structure
view signals
run -all
