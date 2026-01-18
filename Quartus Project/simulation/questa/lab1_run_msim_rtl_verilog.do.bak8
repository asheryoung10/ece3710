transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/seven_seg_decoder.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/lab1.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/ALU.v}

vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/lab1.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/ALU.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Desktop/3710/ece3710/verilog {/home/u1462567/Desktop/3710/ece3710/verilog/tb_ALU.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_alu

add wave *
view structure
view signals
run -all
