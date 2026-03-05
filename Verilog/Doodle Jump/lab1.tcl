# Copyright (C) 2024  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime Version 23.1std.1 Build 993 05/14/2024 SC Lite Edition
# File: /home/u1462567/Desktop/ece3710/Verilog/Doodle Jump/lab1.tcl
# Generated on: Wed Mar  4 16:28:53 2026

package require ::quartus::project

set_location_assignment PIN_A13 -to vga_red[0]
set_location_assignment PIN_C13 -to vga_red[1]
set_location_assignment PIN_E13 -to vga_red[2]
set_location_assignment PIN_B12 -to vga_red[3]
set_location_assignment PIN_D12 -to vga_red[5]
set_location_assignment PIN_C12 -to vga_red[4]
set_location_assignment PIN_F13 -to vga_red[7]
set_location_assignment PIN_E12 -to vga_red[6]
set_location_assignment PIN_J9 -to vga_green[0]
set_location_assignment PIN_J10 -to vga_green[1]
set_location_assignment PIN_H12 -to vga_green[2]
set_location_assignment PIN_G10 -to vga_green[3]
set_location_assignment PIN_G11 -to vga_green[4]
set_location_assignment PIN_G12 -to vga_green[5]
set_location_assignment PIN_F11 -to vga_green[6]
set_location_assignment PIN_E11 -to vga_green[7]
set_location_assignment PIN_B13 -to vga_blue[0]
set_location_assignment PIN_G13 -to vga_blue[1]
set_location_assignment PIN_H13 -to vga_blue[2]
set_location_assignment PIN_F14 -to vga_blue[3]
set_location_assignment PIN_H14 -to vga_blue[4]
set_location_assignment PIN_F15 -to vga_blue[5]
set_location_assignment PIN_G15 -to vga_blue[6]
set_location_assignment PIN_J14 -to vga_blue[7]
set_location_assignment PIN_A11 -to vga_clock
set_location_assignment PIN_B11 -to vga_hs
set_location_assignment PIN_C10 -to vga_sync_n
set_location_assignment PIN_D11 -to vga_vs
set_location_assignment PIN_F10 -to vga_blank_n
set_location_assignment PIN_J12 -to i2c_clock
set_location_assignment PIN_K12 -to i2c_data
set_location_assignment PIN_H8 -to audio_leftRightClock
set_location_assignment PIN_G7 -to audio_masterClock
set_location_assignment PIN_J7 -to audio_data
set_location_assignment PIN_H7 -to audio_bitClock
set_location_assignment PIN_AE26 -to hex0[0]
set_location_assignment PIN_AE27 -to hex0[1]
set_location_assignment PIN_AE28 -to hex0[2]
set_location_assignment PIN_AG27 -to hex0[3]
set_location_assignment PIN_AF28 -to hex0[4]
set_location_assignment PIN_AG28 -to hex0[5]
set_location_assignment PIN_AH28 -to hex0[6]
set_location_assignment PIN_AJ29 -to hex1[0]
set_location_assignment PIN_AH29 -to hex1[1]
set_location_assignment PIN_AH30 -to hex1[2]
set_location_assignment PIN_AG30 -to hex1[3]
set_location_assignment PIN_AF29 -to hex1[4]
set_location_assignment PIN_AF30 -to hex1[5]
set_location_assignment PIN_AD27 -to hex1[6]
set_location_assignment PIN_AB23 -to hex2[0]
set_location_assignment PIN_AE29 -to hex2[1]
set_location_assignment PIN_AD29 -to hex2[2]
set_location_assignment PIN_AC28 -to hex2[3]
set_location_assignment PIN_AD30 -to hex2[4]
set_location_assignment PIN_AC29 -to hex2[5]
set_location_assignment PIN_AC30 -to hex2[6]
set_location_assignment PIN_AD26 -to hex3[0]
set_location_assignment PIN_AC27 -to hex3[1]
set_location_assignment PIN_AD25 -to hex3[2]
set_location_assignment PIN_AC25 -to hex3[3]
set_location_assignment PIN_AB28 -to hex3[4]
set_location_assignment PIN_AB25 -to hex3[5]
set_location_assignment PIN_AB22 -to hex3[6]
set_location_assignment PIN_AA24 -to hex4[0]
set_location_assignment PIN_Y23 -to hex4[1]
set_location_assignment PIN_Y24 -to hex4[2]
set_location_assignment PIN_W22 -to hex4[3]
set_location_assignment PIN_W24 -to hex4[4]
set_location_assignment PIN_V23 -to hex4[5]
set_location_assignment PIN_W25 -to hex4[6]
set_location_assignment PIN_V25 -to hex5[0]
set_location_assignment PIN_AA28 -to hex5[1]
set_location_assignment PIN_Y27 -to hex5[2]
set_location_assignment PIN_AB27 -to hex5[3]
set_location_assignment PIN_AB26 -to hex5[4]
set_location_assignment PIN_AA26 -to hex5[5]
set_location_assignment PIN_AA25 -to hex5[6]
set_location_assignment PIN_V16 -to leds[0]
set_location_assignment PIN_W16 -to leds[1]
set_location_assignment PIN_V17 -to leds[2]
set_location_assignment PIN_V18 -to leds[3]
set_location_assignment PIN_W17 -to leds[4]
set_location_assignment PIN_W19 -to leds[5]
set_location_assignment PIN_Y19 -to leds[6]
set_location_assignment PIN_W20 -to leds[7]
set_location_assignment PIN_W21 -to leds[8]
set_location_assignment PIN_Y21 -to leds[9]
set_location_assignment PIN_AA14 -to push_buttons[0]
set_location_assignment PIN_AA15 -to push_buttons[1]
set_location_assignment PIN_W15 -to push_buttons[2]
set_location_assignment PIN_Y16 -to push_buttons[3]
set_location_assignment PIN_AB12 -to switches[0]
set_location_assignment PIN_AC12 -to switches[1]
set_location_assignment PIN_AF9 -to switches[2]
set_location_assignment PIN_AF10 -to switches[3]
set_location_assignment PIN_AD11 -to switches[4]
set_location_assignment PIN_AD12 -to switches[5]
set_location_assignment PIN_AE11 -to switches[6]
set_location_assignment PIN_AC9 -to switches[7]
set_location_assignment PIN_AD10 -to switches[8]
set_location_assignment PIN_AE12 -to switches[9]
set_location_assignment PIN_AF14 -to systemClock50MHz
