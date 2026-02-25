transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Verilog/VGA Lab/vga_controller.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Verilog/VGA Lab/hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Verilog/VGA Lab/hard_coded_bitgen.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Verilog/VGA Lab/clk_divider.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Verilog/VGA Lab/block_mover.v}

vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/block_mover.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/clk_divider.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/hard_coded_bitgen.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/tb_hard_coded_vga.v}
vlog -vlog01compat -work work +incdir+/home/u1462567/Documents/ece3710/Quartus\ Project/../Verilog/VGA\ Lab {/home/u1462567/Documents/ece3710/Quartus Project/../Verilog/VGA Lab/vga_controller.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_hard_coded_vga

add wave *
view structure
view signals
run -all
