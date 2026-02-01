transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/seven_seg_decoder.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/bin16_to_bcd5.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/bram.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/fib_copy_fsm.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Verilog/Memory Lab/bmemory.v}

vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/bram.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/tb_top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/top.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/memory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/fib_copy_fsm.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/bmemory.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/bin16_to_bcd5.v}
vlog  -work work +incdir+C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus\ Project/../Verilog/Memory\ Lab {C:/Users/asher/Desktop/SchoolWork/ece3710/Quartus Project/../Verilog/Memory Lab/seven_seg_decoder.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
