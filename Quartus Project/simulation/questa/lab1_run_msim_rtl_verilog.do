transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Verilog/Register File Lab/FibFSM.v}

vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/lab1.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/FibFSM.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/ALU.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/tb_fib.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/ImmMux.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/bin16_to_bcd5.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/register_file.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/SubtractFSM.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/ShiftFSM.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/School\ Work/ece3710/Quartus\ Project/../Verilog/Register\ File\ Lab {C:/Users/asher/Desktop/School Work/ece3710/Quartus Project/../Verilog/Register File Lab/BitMaskFSM.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_fib

add wave *
view structure
view signals
run -all
